// SPDX-License-Identifier: GPL-2.0-or-later
// Isolate the actual provider and helper, reject malformed baselines, roundtrip DEX.
module main

import crypto.sha256
import json2
import os

fn digest(path string) !string { return sha256.sum(os.read_bytes(path)!).hex() }

fn command(work string, label string, argv []string, quiet bool) ! {
	result := os.exec(argv)
	os.write_file(work + '/' + label + '.json', json2.encode({
		'argv': json2.Any(argv), 'exit_code': json2.Any(result.exit_code), 'output': json2.Any(result.output)
	}, prettify: true) + '\n')!
	assert result.exit_code == 0, label + ': ' + result.output
	if quiet { assert result.output.trim_space() == '', label + ': unexpected diagnostics' }
}

fn main() {
	$if prod { panic('live assertions required') }
	assert os.args.len == 7, 'V REPO FRESH_OUTPUT BASELINE_SMALI JAVA SMALI_TOOLS'
	compiler, repo := os.real_path(os.args[1]), os.real_path(os.args[2])
	work := os.abs_path(os.args[3])
	baseline, java, tools := os.real_path(os.args[4]), os.real_path(os.args[5]), os.real_path(os.args[6])
	assert !os.exists(work) && !os.is_link(work) && !work.starts_with(repo + '/')
	os.mkdir_all(work + '/androidtools')!
	provider := repo + '/tests/native-android-tools/androidtools/framework_bitmap_tiles.v'
	checks := repo + '/tests/native-android-tools/bitmaptilescheck/main.v'
	integration := repo + '/tests/native-android-tools/androidtools/framework.v'
	mut pins := map[string]string{}
	for path in [compiler, java, @FILE, provider, checks, integration] { pins[path] = digest(path)! }
	framework := os.read_file(integration)!
	assert framework.contains(' framework_bitmap_tiles(smali)!')
	helper_start := framework.index('pub fn framework_replace_method(') or { panic('missing provider helper') }
	helper_end := helper_start + (framework[helper_start..].index('\n}\n') or { panic('unterminated provider helper') }) + 3
	os.write_file(work + '/androidtools/helper.v', 'module androidtools\n' + framework[helper_start..helper_end])!
	os.cp(provider, work + '/androidtools/provider.v')!
	os.cp(checks, work + '/check.v')!
	classes := ['android/graphics/drawable/BitmapDrawable', 'android/graphics/Bitmap', 'android/graphics/BitmapShader',
		'android/graphics/Canvas', 'android/graphics/Paint', 'android/graphics/Shader$TileMode', 'android/graphics/drawable/Drawable']
	for name in classes {
		path := baseline + '/' + name + '.smali'
		pins[path] = digest(path)!
		for kind in ['baseline', 'proof'] {
			os.mkdir_all(os.dir(work + '/' + kind + '/' + name + '.smali'))!
			os.cp(path, work + '/' + kind + '/' + name + '.smali')!
		}
	}
	for name in os.ls(tools)! { if name.ends_with('.jar') { pins[tools + '/' + name] = digest(tools + '/' + name)! } }
	command(work, 'compile', [compiler, '-nocache', '-path', '@vlib|' + work, '-cc', 'cc', '-o', work + '/check', work + '/check.v'], true)!
	command(work, 'source', [work + '/check', work], false)!
	for kind in ['baseline', 'patched'] {
		directory := work + '/' + if kind == 'baseline' { 'baseline' } else { 'proof' }
		dex := work + '/' + kind + '.dex'
		command(work, kind + '-assemble', [java, '-Xmx256m', '-XX:ActiveProcessorCount=2', '-cp', tools + '/*',
			'org.jf.smali.Main', 'assemble', '--api', '28', '--jobs', '2', directory, '-o', dex], true)!
		assert os.is_file(dex) && os.file_size(dex) > 112
		command(work, kind + '-disassemble', [java, '-Xmx256m', '-XX:ActiveProcessorCount=2', '-cp', tools + '/*',
			'org.jf.baksmali.Main', 'disassemble', '--api', '28', '--jobs', '2', dex, '-o', work + '/' + kind + '-roundtrip'], true)!
	}
	command(work, 'roundtrip', [work + '/check', work, '--roundtrip'], true)!
	for path, pin in pins { assert digest(path)! == pin, 'input changed: ' + path }
	for name in classes[1..] { assert digest(work + '/proof/' + name + '.smali')! == pins[baseline + '/' + name + '.smali']! }
	for path in ['check.v', 'androidtools/provider.v', 'androidtools/helper.v', 'check', 'baseline.dex', 'patched.dex',
		'proof/android/graphics/drawable/BitmapDrawable.smali'] { pins[work + '/' + path] = digest(work + '/' + path)! }
	os.write_file(work + '/receipt.json', json2.encode(pins, prettify: true) + '\n')!
	println('BITMAP-TILES-CHECK-PASS schema-refusals seven-class-DEX-roundtrip unchanged-neighbors')
}
