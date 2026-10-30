// SPDX-License-Identifier: GPL-2.0-or-later
// Verify the unseeded UserManager API and its retained service/type neighbors.
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
	assert os.args.len == 7, 'usage: seed-account-options-source-check V REPO FRESH_OUTPUT BASELINE_SMALI JAVA SMALI_TOOLS'
	compiler, repo := os.real_path(os.args[1]), os.real_path(os.args[2])
	work := os.abs_path(os.args[3])
	baseline, java, tools := os.real_path(os.args[4]), os.real_path(os.args[5]), os.real_path(os.args[6])
	assert !os.exists(work) && !os.is_link(work) && work != repo && !work.starts_with(repo + '/')
	os.mkdir_all(work + '/androidtools')!
	provider := repo + '/tests/native-android-tools/androidtools/framework_seed_account_options.v'
	checks := repo + '/tests/native-android-tools/seedoptionscheck/main.v'
	integration := repo + '/tests/native-android-tools/androidtools/framework.v'
	mut pins := map[string]string{}
	for path in [compiler, java, @FILE, provider, checks, integration] { pins[path] = digest(path)! }
	assert os.read_file(integration)!.contains(' framework_window_system_ui(smali)!\n framework_seed_account_options(smali)!')
	os.cp(provider, work + '/androidtools/provider.v')!
	os.cp(checks, work + '/check.v')!
	classes := ['android/os/UserManager', 'android/os/PersistableBundle', 'android/util/ArrayMap',
		'android/os/BaseBundle', 'android/os/Bundle', 'android/app/ContextImpl', 'android/util/ContainerHelpers']
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
		dex := work + '/' + kind + '.dex'
		assert !os.exists(dex)
		command(work, kind + '-assemble', [java, '-Xmx256m', '-XX:ActiveProcessorCount=2', '-cp', tools + '/*', 'org.jf.smali.Main', 'assemble', '--api', '28', '--jobs', '2', directory, '-o', dex], true)!
		assert os.is_file(dex) && os.file_size(dex) > 112, 'fresh DEX required'
		command(work, kind + '-disassemble', [java, '-Xmx256m', '-XX:ActiveProcessorCount=2', '-cp', tools + '/*', 'org.jf.baksmali.Main', 'disassemble', '--api', '28', '--jobs', '2', dex, '-o', work + '/' + kind + '-roundtrip'], true)!
	}
	command(work, 'roundtrip', [work + '/check', work, '--roundtrip'], true)!
	for name in classes[3..] { assert digest(work + '/proof/' + name + '.smali')! == pins[baseline + '/' + name + '.smali']! }
	for path, pin in pins { assert digest(path)! == pin, 'input changed: ' + path }
	for path in ['check.v', 'androidtools/provider.v', 'check', 'baseline.dex', 'patched.dex',
		'proof/android/os/UserManager.smali', 'proof/android/os/PersistableBundle.smali', 'proof/android/util/ArrayMap.smali'] { pins[work + '/' + path] = digest(work + '/' + path)! }
	os.write_file(work + '/receipt.json', json2.encode(pins, prettify: true) + '\n')!
	println('SEED-ACCOUNT-OPTIONS-CHECK-PASS unseeded-null immutable-empty canonical-map-order retained-dependencies API28-DEX-roundtrip')
}
