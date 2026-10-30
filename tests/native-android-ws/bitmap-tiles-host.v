// SPDX-License-Identifier: GPL-2.0-or-later
// Compile the actual native sampler, compositor and binding against a host Canvas.
module main

import crypto.sha256
import json2
import os

fn function(body string, name string) string {
	start := body.index('fn ' + name + '(') or { panic('missing function ' + name) }
	tail := body[start..]
	end := tail.index('\nfn ') or { tail.len }
	return tail[..end] + '\n'
}

fn structure(body string, name string) string {
	start := body.index('struct ' + name + ' {') or { panic('missing struct ' + name) }
	tail := body[start..]
	end := tail.index('\n}') or { panic('unterminated struct ' + name) }
	return tail[..end + 3] + '\n'
}

fn command(argv []string, log string) {
	r := os.exec(argv)
	os.write_file(log, r.output) or { panic(err) }
	print(r.output)
	assert r.exit_code == 0, log
}

fn main() {
	$if prod { panic('live assertions required') }
	assert os.args.len in [5, 6], 'usage: bitmap-tiles-host V REPO FRESH_OUTPUT asan=(true|false) [--prepare-only]'
	compiler, repo := os.real_path(os.args[1]), os.real_path(os.args[2])
	out := os.abs_path(os.args[3])
	asan := os.args[4] == 'asan=true'
	assert asan || os.args[4] == 'asan=false'
	prepare := os.args.len == 6
	if prepare { assert os.args[5] == '--prepare-only' }
	assert !os.exists(out) && !os.is_link(out) && !out.starts_with(repo + '/')
	os.mkdir_all(out + '/src')!
	mut pins := map[string]string{}
	for name in ['graphics.v', 'bitmaps.v', 'canvases.v', 'affine.v', 'paths.v', 'path_clipping.v', 'bitmap_tiles.v'] {
		path := repo + '/build-support/android/nativews/' + name
		body := os.read_file(path)!
		pins[path] = sha256.sum(body.bytes()).hex()
		os.write_file(out + '/' + name + '.txt', body)!
		mut actual := '@[translated]\nmodule main\n'
		match name {
			'graphics.v' {
				actual += structure(body, 'WsTransform') + structure(body, 'WsPaint')
				for symbol in ['ws_rect_bound', 'ws_blend', 'ws_rect', 'ws_round_inset', 'ws_canvas_round_rect', 'ws_paint_new', 'ws_paint_clone'] {
					actual += function(body, symbol)
				}
			}
			'bitmaps.v' {
				actual += structure(body, 'WsBitmap')
				for symbol in ['ws_bitmap_dst_in', 'ws_draw_bitmap_region', 'ws_draw_bitmap_paint', 'ws_draw_bitmap'] {
					actual += function(body, symbol)
				}
			}
			'canvases.v' { actual += structure(body, 'WsDrawState') }
			'affine.v' {
				actual += structure(body, 'WsClipQuad')
				for symbol in ['ws_affine_point', 'ws_affine_inverse', 'ws_affine_bounds', 'ws_affine_clip'] { actual += function(body, symbol) }
			}
			'paths.v' { actual += structure(body, 'WsVertex') }
			'path_clipping.v' {
				actual += structure(body, 'WsPathClip')
				for symbol in ['ws_path_clip_contains', 'ws_path_clip_crossing'] { actual += function(body, symbol) }
			}
			'bitmap_tiles.v' {
				assert body.count('module atlframework') == 1
				actual = body.replace('module atlframework', 'module main')
			}
			else { panic('unexpected native source') }
		}
		os.write_file(out + '/src/actual_' + name, actual)!
	}
	bindings_path := repo + '/build-support/android/nativews/bindings.txt'
	bindings := os.read_file(bindings_path)!
	prefix := 'android/graphics/drawable/BitmapDrawable|nativeDrawTiles(Landroid/atl/GskCanvas;Landroid/graphics/Bitmap;IIIILandroid/graphics/Paint;II)V|'
	lines := bindings.split_into_lines().filter(it.starts_with(prefix))
	assert lines.len == 1 && lines[0].split('|').len == 3, 'exact unambiguous binding required'
	os.write_file(out + '/binding.txt', lines[0] + '\n')!
	pins[bindings_path] = sha256.sum(bindings.bytes()).hex()
	base_path := repo + '/tests/native-android-ws/xfermodehost/harness.v.txt'
	base := os.read_file(base_path)!
	assert base.count('fn main() {') == 1
	os.write_file(out + '/src/main.v', base.replace('fn main() {', 'fn existing_compositor_controls() {'))!
	tests_path := repo + '/tests/native-android-ws/bitmaptileshost/harness.v.txt'
	tests := os.read_file(tests_path)!
	os.write_file(out + '/src/tile_tests.v', tests)!
	os.write_file(out + '/src/binding.v', '@[translated]\nmodule main\nfn actual_binding(e voidptr, this voidptr, p0 voidptr, p1 voidptr, p2 i32, p3 i32, p4 i32, p5 i32, p6 voidptr, p7 i32, p8 i32) {\nunsafe {\n' + lines[0].all_after(prefix) + '\n}\n}\n')!
	for path in [base_path, tests_path, @FILE, compiler] { pins[path] = sha256.sum(os.read_bytes(path)!).hex() }
	os.write_file(out + '/source-pins.json', json2.encode(pins, prettify: true) + '\n')!
	if prepare { println('BITMAP-TILES-HOST-PREPARED'); return }
	mut argv := [compiler, '-new-compiler', '-no-parallel', '-nocache', '-cc', 'cc', '-enable-globals', '-gc', 'none']
	if asan { argv << ['-cflags', '-fsanitize=address -fno-omit-frame-pointer', '-ldflags', '-fsanitize=address'] }
	argv << ['-o', out + '/host', out + '/src']
	command(argv, out + '/compile.log')
	if asan { os.setenv('ASAN_OPTIONS', 'detect_leaks=0', true) }
	command([out + '/host'], out + '/run.log')
	for path, pin in pins { assert sha256.sum(os.read_bytes(path)!).hex() == pin, 'input changed: ' + path }
	println('BITMAP-TILES-HOST-PASS actual-source pixels compositor binding')
}
