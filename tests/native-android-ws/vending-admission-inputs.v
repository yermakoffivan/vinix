// SPDX-License-Identifier: GPL-2.0-or-later
// Retain post-build imported V files and the actual C preprocessor closure.
module main

import json2
import os

const compiler = '/Users/alex/code/v-tccbin-bootstrap-20261026/v'
const repo = '/Users/alex/code/vinix'

fn command(root string, label string, argv []string) !string {
	result := os.exec(argv)
	os.write_file(root + '/' + label + '.raw', result.output)!
	os.write_file(root + '/' + label + '.json', json2.encode({'argv': json2.Any(argv), 'exit_code': json2.Any(result.exit_code)}, prettify: true) + '\n')!
	if result.exit_code != 0 { return error('input discovery failed: ' + label) }
	return result.output
}
fn add(path string, mut selected map[string]bool) ! {
	if !os.is_abs_path(path) || !os.is_file(path) { return error('existing absolute input required: ' + path) }
	selected[path] = true
}
fn headers(directory string, mut selected map[string]bool) ! {
	for name in os.ls(directory)! {
		path := directory + '/' + name
		if os.is_dir(path) { headers(path, mut selected)! } else { add(path, mut selected)! }
	}
}
fn run(project string, root string) ! {
	if os.real_path(project) != project || !os.is_dir(project) || os.exists(root) || os.is_link(root) || os.real_path(os.dir(root)) != os.dir(root) { return error('canonical project and fresh discovery output required') }
	os.mkdir(root, mode: 0o700)!
	listing := command(root, 'v-inputs', [compiler, '-new-compiler', '-prod', '-gc', 'boehm', '-nocache', '-cc', 'cc', '-no-parallel', '-print-v-files', '-path', repo + '/tests/native-android-ws|' + repo + '/build-support|' + repo + '/build-support/android|@vlib', repo + '/tests/native-android-ws/maps-vending-admission.v'])!
	mut v_inputs := map[string]bool{}
	for line in listing.split_into_lines() { if line.starts_with('/') && line.ends_with('.v') { add(line, mut v_inputs)! } }
	if v_inputs.len < 100 || repo + '/tests/native-android-ws/maps-vending-admission.v' !in v_inputs { return error('complete imported V listing absent') }
	// The generated command uses whitespace-free canonical paths and no shell
	// expansions. Its exact production invocation was already run unchanged.
	text := os.read_file(project + '/build_command.txt')!.trim_space()
	if text.contains_any("'\"`\n\r") { return error('unexpected quoting in emitted C command') }
	tokens := text.fields()
	if tokens.len < 10 || tokens[0] != 'cc' { return error('expected emitted host C compiler command') }
	mut dependency_argv := ['/usr/bin/cc', '-M']
	mut c_inputs := map[string]bool{}
	mut skip := false
	for token in tokens[1..] {
		if skip { skip = false; continue }
		if token == '-o' { skip = true; continue }
		dependency_argv << token
		if token.starts_with('/') && os.is_file(token) { add(token, mut c_inputs)! }
	}
	if skip { return error('truncated emitted output selector') }
	dependencies := command(root, 'c-inputs', dependency_argv)!
	for token in dependencies.replace('\\\n', ' ').fields() {
		if token.starts_with('/') { add(token, mut c_inputs)! }
	}
	for name in ['maps-vending-admission.c', 'Makefile', 'build_command.txt', 'build.sh', 'build.bat'] { add(project + '/' + name, mut c_inputs)! }
	tool := root + '/input-discovery-tool'
	os.cp(os.real_path(os.executable()), tool)!
	os.chmod(tool, 0o700)!
	for path in [repo + '/build-support/android/modulestream/spawn_abi.h', repo + '/build-support/tarstream/filter_abi.h', os.abs_path(@FILE), tool] { add(path, mut c_inputs)! }
	mut missing_include_directories := []string{}
	for directory in ['/Users/alex/code/v-tccbin-bootstrap-20261026/thirdparty/libgc/include', '/Users/alex/code/v-tccbin-bootstrap-20261026/thirdparty/stdatomic/nix', '/Users/alex/code/v-tccbin-bootstrap-20261026/thirdparty/legacy/include/LegacySupport'] {
		if os.is_dir(directory) { headers(directory, mut c_inputs)! } else { missing_include_directories << directory }
	}
	// Unused emitted -I paths can be absent. Every header actually required by
	// the emitted C command above remains a required existing regular input.
	os.write_file(root + '/missing-include-directories.json', json2.encode(missing_include_directories, prettify: true) + '\n')!
	os.write_file(root + '/v-inputs.txt', v_inputs.keys().sorted().join('\n') + '\n')!
	os.write_file(root + '/c-inputs.txt', c_inputs.keys().sorted().join('\n') + '\n')!
	println('VENDING-ADMISSION-INPUTS PASS V=' + v_inputs.len.str() + ' C=' + c_inputs.len.str() + ' post-build discovery only')
}
fn main() {
	if os.args.len != 3 { eprintln('usage: vending-admission-inputs GENERATED_PROJECT FRESH_DISCOVERY_OUTPUT'); exit(2) }
	run(os.args[1], os.args[2]) or { eprintln(err); exit(1) }
}
