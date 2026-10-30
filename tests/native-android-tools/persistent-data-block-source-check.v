// SPDX-License-Identifier: GPL-2.0-or-later
// Verify the absent persistent-data service type and retained lookup paths.
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
	assert os.args.len == 7, 'usage: persistent-data-block-source-check V REPO FRESH_OUTPUT BASELINE_SMALI JAVA SMALI_TOOLS'
	compiler, repo := os.real_path(os.args[1]), os.real_path(os.args[2])
	work := os.abs_path(os.args[3])
	baseline, java, tools := os.real_path(os.args[4]), os.real_path(os.args[5]), os.real_path(os.args[6])
	assert !os.exists(work) && !os.is_link(work) && work != repo && !work.starts_with(repo + '/')
	os.mkdir_all(work + '/androidtools')!
	provider := repo + '/tests/native-android-tools/androidtools/framework_persistent_data_block.v'
	checks := repo + '/tests/native-android-tools/persistentdatablockcheck/main.v'
	integration := repo + '/tests/native-android-tools/androidtools/framework.v'
	mut pins := map[string]string{}
	for path in [compiler, java, @FILE, provider, checks, integration] { pins[path] = digest(path)! }
	assert os.read_file(integration)!.contains(' framework_seed_account_options(smali)!\n framework_persistent_data_block(smali)!')
	os.cp(provider, work + '/androidtools/provider.v')!
	os.cp(checks, work + '/check.v')!
	classes := ['android/app/ContextImpl', 'android/content/Context', 'android/content/ContextWrapper',
		'android/os/UserManager', 'android/os/PersistableBundle', 'android/os/BaseBundle', 'android/util/ArrayMap']
	added := 'android/service/persistentdata/PersistentDataBlockManager'
	assert !os.exists(baseline + '/' + added + '.smali') && !os.is_link(baseline + '/' + added + '.smali')
	for name in classes {
		path := baseline + '/' + name + '.smali'
		pins[path] = digest(path)!
		os.mkdir_all(os.dir(work + '/proof/' + name + '.smali'))!
		os.cp(path, work + '/proof/' + name + '.smali')!
	}
	for name in os.ls(tools)! { if name.ends_with('.jar') { pins[tools + '/' + name] = digest(tools + '/' + name)! } }
	command(work, 'compile', [compiler, '-nocache', '-path', '@vlib|' + work, '-cc', 'cc', '-o', work + '/check', work + '/check.v'], true)!
	command(work, 'source', [work + '/check', work], false)!
	for kind in ['baseline', 'patched'] {
		directory := work + '/' + kind + '-smali'
		for name in classes {
			from := if kind == 'baseline' { baseline } else { work + '/proof' }
			os.mkdir_all(os.dir(directory + '/' + name + '.smali'))!
			os.cp(from + '/' + name + '.smali', directory + '/' + name + '.smali')!
		}
		if kind == 'patched' {
			os.mkdir_all(os.dir(directory + '/' + added + '.smali'))!
			os.cp(work + '/proof/' + added + '.smali', directory + '/' + added + '.smali')!
		}
		dex := work + '/' + kind + '.dex'
		assert !os.exists(dex)
		command(work, kind + '-assemble', [java, '-Xmx256m', '-XX:ActiveProcessorCount=2', '-cp', tools + '/*', 'org.jf.smali.Main', 'assemble', '--api', '28', '--jobs', '2', directory, '-o', dex], true)!
		assert os.is_file(dex) && os.file_size(dex) > 112, 'fresh DEX required'
		command(work, kind + '-disassemble', [java, '-Xmx256m', '-XX:ActiveProcessorCount=2', '-cp', tools + '/*', 'org.jf.baksmali.Main', 'disassemble', '--api', '28', '--jobs', '2', dex, '-o', work + '/' + kind + '-roundtrip'], true)!
	}
	command(work, 'roundtrip', [work + '/check', work, '--roundtrip'], true)!
	for name in classes[1..] { assert digest(work + '/proof/' + name + '.smali')! == pins[baseline + '/' + name + '.smali']! }
	for path, pin in pins { assert digest(path)! == pin, 'input changed: ' + path }
	for path in ['check.v', 'androidtools/provider.v', 'check', 'baseline.dex', 'patched.dex',
		'proof/android/app/ContextImpl.smali', 'proof/' + added + '.smali'] { pins[work + '/' + path] = digest(work + '/' + path)! }
	os.write_file(work + '/receipt.json', json2.encode(pins, prettify: true) + '\n')!
	println('PERSISTENT-DATA-BLOCK-CHECK-PASS memberless-type typed-null named-path-preserved API28-DEX-roundtrip')
}
