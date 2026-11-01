// Stream the admitted Maps resource table without changing the outer log cap.
module main

import crypto.sha256
import json2
import os
import time

const maps_apk = '/Users/alex/code/vinix/build/android-maps/GoogleMaps.apk'
const maps_pin = '6218d72f48b184eb71f68879bce48cb9ebb2b510be7f7cff88217ea3fd592bb2'
const aapt_path = '/Users/alex/code/vinix/build/android-native-ws/aapt2'
const aapt_pin = '71b3b768db0d930691706cb31413c7e2664959842fd8fba50b619d0da3d50c36'
const previous_dump = '/Users/alex/code/vinix/build/android-maps/resources.txt'
const resource_cap = 64 * 1024 * 1024

struct Capture {
	argv         []string
	exit_code    int
	output_bytes int
	output_sha   string
}

struct Receipt {
	apk_sha                 string
	aapt_sha                string
	previous_dump_sha       string
	previous_dump_unchanged bool
	previous_dump_matches   bool
	inputs_unchanged        bool
	resources               Capture
}

fn file_hash(path string) !string {
	mut file := os.open(path)!
	defer { file.close() }
	mut digest := sha256.new()
	mut buffer := []u8{len: 1024 * 1024}
	for {
		count := file.read(mut buffer) or {
			if err is os.Eof {
				break
			}
			return err
		}
		if count == 0 {
			break
		}
		digest.write(buffer[..count])!
	}
	return digest.sum([]u8{}).hex()
}

fn append_chunk(mut file os.File, chunk string, written int, cap int) !int {
	if chunk.len > cap - written {
		return error('capture output cap exceeded')
	}
	unsafe { file.write_full_buffer(chunk.str, u32(chunk.len))! }
	return written + chunk.len
}

fn capture(argv []string, path string, cap int) !Capture {
	assert argv.len > 0 && cap > 0
	assert !os.exists(path), 'fresh output required'
	mut file := os.create(path)!
	defer { file.close() }
	mut child := os.new_process(argv[0])
	child.set_args(argv[1..])
	child.set_redirect_stdio_merged()
	child.set_stdin_path('/dev/null')
	child.run()
	defer {
		if child.is_alive() {
			child.signal_kill()
		}
		child.wait()
		child.close()
	}
	if child.pid <= 1 {
		return error('cannot start capture command')
	}
	mut written := 0
	for {
		chunk := child.stdout_read()
		written = append_chunk(mut file, chunk, written, cap)!
		if chunk.len != 0 {
			continue
		}
		if !child.is_alive() {
			written = append_chunk(mut file, child.stdout_slurp(), written, cap)!
			break
		}
		time.sleep(time.millisecond)
	}
	child.wait()
	if child.code != 0 {
		return error('capture command exited ' + child.code.str())
	}
	file.flush()
	return Capture{
		argv:         argv
		exit_code:    child.code
		output_bytes: written
		output_sha:   file_hash(path)!
	}
}

fn self_test(root string) ! {
	os.mkdir(root)!
	literal := '$HOME `true` trailing\n'
	result := capture(['/usr/bin/printf', '%s', literal], root + '/literal.txt', literal.len)!
	assert os.read_file(root + '/literal.txt')! == literal
	assert result.output_bytes == literal.len
	assert result.output_sha == sha256.sum(literal.bytes()).hex()
	capture(['/usr/bin/printf', '%s', 'abcdef'], root + '/overflow.txt', 5) or {
		assert err.msg() == 'capture output cap exceeded'
		assert os.file_size(root + '/overflow.txt') <= 5
		capture(['/usr/bin/false'], root + '/failed.txt', 16) or {
			assert err.msg() == 'capture command exited 1'
			println('PASS literal arguments, exact output cap, overflow, nonzero exit and readback hash')
			return
		}
		return error('nonzero child exit was accepted')
	}
	return error('output overflow was accepted')
}

fn main() {
	if os.args.len == 3 && os.args[1] == '--self-test' {
		self_test(os.args[2])!
		return
	}
	assert os.args.len == 2, 'usage: maps-theme-resource-dump FRESH_ROOT | --self-test FRESH_ROOT'
	root := os.args[1]
	assert os.is_abs_path(root), 'absolute fresh root required'
	assert file_hash(maps_apk)! == maps_pin, 'admitted APK mismatch'
	assert file_hash(aapt_path)! == aapt_pin, 'qualified aapt mismatch'
	old_sha := file_hash(previous_dump)!
	os.mkdir(root)!
	resources := capture([aapt_path, 'dump', 'resources', maps_apk], root + '/resources.txt', resource_cap)!
	inputs_unchanged := file_hash(maps_apk)! == maps_pin && file_hash(aapt_path)! == aapt_pin
	previous_unchanged := file_hash(previous_dump)! == old_sha
	receipt := Receipt{
		apk_sha:                 maps_pin
		aapt_sha:                aapt_pin
		previous_dump_sha:       old_sha
		previous_dump_unchanged: previous_unchanged
		previous_dump_matches:   resources.output_sha == old_sha
		inputs_unchanged:        inputs_unchanged
		resources:               resources
	}
	os.write_file(root + '/receipt.json', json2.encode(receipt, prettify: true, legacy_layout: true, escape_unicode: true, time_as_unix: true) + '\n')!
	assert inputs_unchanged && previous_unchanged, 'input changed during capture'
	println('Captured bytes=' + resources.output_bytes.str() + ' SHA256=' + resources.output_sha)
	println('Existing resources.txt identical=' + receipt.previous_dump_matches.str())
}
