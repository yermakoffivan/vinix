// SPDX-License-Identifier: GPL-2.0-or-later
// Verify the added scalar resource API and the complete retained SDK.
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
	assert !os.exists(work) && !os.is_link(work) && work != repo && !work.starts_with(repo + '/')
	os.mkdir_all(work + '/androidtools')!
	provider := repo + '/tests/native-android-tools/androidtools/framework_resources_float.v'
	checks := repo + '/tests/native-android-tools/resourcesfloatcheck/main.v'
	integration := repo + '/tests/native-android-tools/androidtools/framework.v'
	mut pins := map[string]string{}
	for path in [compiler, java, @FILE, provider, checks, integration] { pins[path] = digest(path)! }
	assert os.read_file(integration)!.contains(' framework_cross_profile_apps(smali)!\n framework_resources_float(smali)!')
	os.cp(provider, work + '/androidtools/provider.v')!
	os.cp(checks, work + '/check.v')!
	classes := os.walk_ext(baseline, '.smali').sorted()
	assert classes.len == 2107, 'complete 2107-class baseline tree required'
	for path in classes {
		assert !os.is_link(path), 'plain baseline class required'
		name := path.all_after(baseline + '/')
		assert name != path && !name.starts_with('../')
		pins[path] = digest(path)!
		for kind in ['baseline', 'proof'] {
			os.mkdir_all(os.dir(work + '/' + kind + '/' + name))!
			os.cp(path, work + '/' + kind + '/' + name)!
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
	command(work, 'roundtrip', [work + '/check', work, '--roundtrip'], false)!
	for path, pin in pins { assert digest(path)! == pin, 'input changed: ' + path }
	for path in classes {
		name := path.all_after(baseline + '/')
		if name != 'android/content/res/Resources.smali' { assert digest(work + '/proof/' + name)! == pins[path]! }
	}
	for path in ['check.v', 'androidtools/provider.v', 'check', 'baseline.dex', 'patched.dex',
		'proof/android/content/res/Resources.smali'] { pins[work + '/' + path] = digest(work + '/' + path)! }
	os.write_file(work + '/receipt.json', json2.encode(pins, prettify: true) + '\n')!
	println('RESOURCES-FLOAT-CHECK-PASS one-added-method strict-type lookup-preserved complete-API28-DEX all-neighbors-unchanged')
}
