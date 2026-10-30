// SPDX-License-Identifier: GPL-2.0-or-later
// Exercise the production selected-child observer with actual host waitpid.
module main

import crypto.sha256
import json2
import os

struct StatusCommand {
	argv []string
	exit_code int
	output string
}

fn status_function(source string, name string) !string {
	start := source.index('fn ' + name + '(') or { return error('missing production ' + name) }
	end := source[start..].index('\n}') or { return error('unterminated production ' + name) }
	return source[start..start + end + 2]
}

fn status_command(root string, label string, argv []string) !StatusCommand {
	result := os.exec(argv)
	receipt := StatusCommand{argv: argv, exit_code: result.exit_code, output: result.output}
	os.write_file(root + '/' + label + '.json', json2.encode(receipt, prettify: true) + '\n')!
	return receipt
}

fn main() {
	if os.args.len != 2 { eprintln('usage: check-account-broker-status FRESH_EXTERNAL_OUTPUT'); exit(2) }
	root := os.abs_path(os.args[1])
	repo := os.real_path(os.getwd())
	if os.exists(root) || os.is_link(root) || root == repo || root.starts_with(repo + '/') {
		eprintln('fresh external evidence directory required')
		exit(2)
	}
	os.mkdir_all(root)!
	source := os.read_file('build-support/android/native-account-broker.v')!
	checker := os.read_file(@FILE)!
	observer := status_function(source, 'selected_child_exited')!
	branch := 'if selected_child_exited(pid) {\n\t\t\treturn error(\'selected authenticator process exited\')\n\t\t}'
	assert source.count(branch) == 1, 'selected process exit must preserve its original error'
	assert source.count('C.waitpid(pid, &child_status, C.WNOHANG)') == 1
	assert observer.count("C.printf(c'ANDROID-ACCOUNT-BROKER-CHILD-STATUS raw=%d\\n', child_status)") == 1
	assert observer.count('C.fflush(unsafe { nil })') == 1
	flush_position := observer.index('C.fflush') or { panic('missing status flush') }
	return_position := observer.index('return true') or { panic('missing observed-child return') }
	assert flush_position < return_position
	main_source := status_function(source, 'main')!
	assert main_source == "fn main() {\n\trun() or {\n\t\teprintln('ANDROID-ACCOUNT-BROKER-FAILED \${err.msg()}')\n\t\texit(1)\n\t}\n}"
	mut fixture := fixture_prelude + '\n' + observer + '\n'
	fixture += observer.replace('fn selected_child_exited(', 'fn child_no_flush(')
		.replace('\n\tC.fflush(unsafe { nil })', '') + '\n'
	fixture += observer.replace('fn selected_child_exited(', 'fn child_bad_status(')
		.replace("raw=%d\\n', child_status)", "raw=%d\\n', i32(0))") + '\n'
	fixture += fixture_cases + '\n' + main_source + '\n'
	os.write_file(root + '/main.v', fixture)!
	os.write_file(root + '/broker-source.v.input', source)!
	os.write_file(root + '/checker-source.v.input', checker)!
	compiler := os.real_path(os.getenv_opt('VINIX_V_COMPILER') or { os.find_abs_path_of_executable('v')! })
	build := status_command(root, 'compile', [compiler, '-gc', 'none', '-nocache', '-cc', 'cc', '-o', root + '/probe', root + '/main.v'])!
	assert build.exit_code == 0, build.output
	failed := 'ANDROID-ACCOUNT-BROKER-FAILED selected authenticator process exited\n'
	for code in [0, 1, 37, 125, 126, 255] {
		result := status_command(root, 'exit-' + code.str(), [root + '/probe', 'exit', code.str()])!
		assert result.exit_code == 1, result.output
		assert result.output == 'ANDROID-ACCOUNT-BROKER-CHILD-STATUS raw=' + (code << 8).str() + '\n' + failed, result.output
	}
	for pair in [['term', '15'], ['kill', '9']] {
		result := status_command(root, 'signal-' + pair[0], [root + '/probe', 'signal', pair[1]])!
		assert result.exit_code == 1 && result.output == 'ANDROID-ACCOUNT-BROKER-CHILD-STATUS raw=' + pair[1] + '\n' + failed, result.output
	}
	for mode in ['running', 'reaped', 'not-child'] {
		result := status_command(root, mode, [root + '/probe', mode])!
		assert result.exit_code == 0 && result.output == 'BROKER-CHILD-STATUS-CONTROL-PASS\n', result.output
	}
	boundary := 'ANDROID-ACCOUNT-BROKER-CHILD-STATUS raw=9472\nBROKER-STATUS-RETURNED\n'
	flushed := status_command(root, 'flush-boundary', [root + '/probe', 'flush-boundary', '37'])!
	assert flushed.exit_code == 1 && flushed.output == boundary, flushed.output
	no_flush := status_command(root, 'no-flush', [root + '/probe', 'no-flush', '37'])!
	assert no_flush.exit_code == 1 && no_flush.output == 'BROKER-STATUS-RETURNED\n', no_flush.output
	bad_status := status_command(root, 'bad-status', [root + '/probe', 'bad-status', '37'])!
	assert bad_status.exit_code == 1 && bad_status.output != 'ANDROID-ACCOUNT-BROKER-CHILD-STATUS raw=9472\n' + failed,
		'negative control failed to distinguish raw status'
	assert os.read_file('build-support/android/native-account-broker.v')! == source
	assert os.read_file(@FILE)! == checker
	revision := status_command(root, 'revision', ['/usr/bin/git', 'rev-parse', 'HEAD'])!
	assert revision.exit_code == 0
	os.write_file(root + '/evidence.json', json2.encode({
		'scope': 'Production-extracted selected-child observer with real waitpid: six normal exits, two signals, live/reaped/not-child controls and two negative diagnostic mutations; no ART or Google authentication proof.'
		'source_revision': revision.output.trim_space()
		'source_sha256': sha256.sum(source.bytes()).hex()
		'checker_sha256': sha256.sum(checker.bytes()).hex()
		'compiler': compiler
		'compiler_sha256': sha256.sum(os.read_bytes(compiler)!).hex()
	}, prettify: true) + '\n')!
	mut pins := map[string]string{}
	for path in os.walk_ext(root, '') {
		if os.is_file(path) { pins[path[root.len + 1..]] = sha256.sum(os.read_bytes(path)!).hex() }
	}
	os.write_file(root + '/sha256.json', json2.encode(pins, prettify: true) + '\n')!
	println('BROKER-CHILD-STATUS-CHECK-PASS exits=6 signals=2 controls=3 mutations=2')
}

const fixture_prelude = '
module main
import os
import time
#include <errno.h>
#include <signal.h>
#include <stdio.h>
#include <sys/wait.h>
#include <unistd.h>
fn C.fork() i32
fn C._exit(i32)
fn C.waitpid(i32, &i32, i32) i32
fn C.kill(i32, i32) i32
fn C.pause() i32
fn C.pipe(&i32) i32
fn C.close(i32) i32
fn C.read(i32, voidptr, usize) isize
fn C.write(i32, voidptr, usize) isize
type Observer = fn (i32) bool
'

const fixture_cases = '
fn run() ! {
 assert os.args.len >= 2
 assert unsafe { C.setvbuf(C.stdout, &char(nil), C._IOFBF, 4096) } == 0
 mode := os.args[1]
 mut observe := Observer(selected_child_exited)
 if mode == "no-flush" { observe = child_no_flush }
 if mode == "bad-status" { observe = child_bad_status }
 if mode == "not-child" {
  assert !observe(i32(2147483647))
  assert C.errno == C.ECHILD
  println("BROKER-CHILD-STATUS-CONTROL-PASS")
  return
 }
 mut pair := [i32(0), i32(0)]!
 if mode == "running" { assert C.pipe(&pair[0]) == 0 }
 pid := C.fork()
 assert pid >= 0
 if pid == 0 {
  if mode == "running" {
   C.close(pair[1])
   mut byte := u8(0)
   C.read(pair[0], &byte, 1)
   C._exit(0)
  }
  if mode == "signal" { for { C.pause() } }
  C._exit(if mode == "reaped" { i32(17) } else { i32(os.args[2].int()) })
 }
 mut reaped := false
 defer {
  if !reaped {
   C.kill(pid, C.SIGKILL)
   mut raw := i32(0)
   C.waitpid(pid, &raw, 0)
  }
 }
 if mode == "running" {
  C.close(pair[0])
  defer { C.close(pair[1]) }
  assert !observe(pid)
  println("BROKER-CHILD-STATUS-CONTROL-PASS")
  return
 }
 if mode == "reaped" {
  mut raw := i32(0)
  assert C.waitpid(pid, &raw, 0) == pid
  reaped = true
  assert raw == (17 << 8)
  assert !observe(pid)
  assert C.errno == C.ECHILD
  println("BROKER-CHILD-STATUS-CONTROL-PASS")
  return
 }
 if mode == "signal" { assert C.kill(pid, os.args[2].int()) == 0 }
 deadline := time.sys_mono_now() + 2 * time.second
 for time.sys_mono_now() < deadline {
  if observe(pid) {
   reaped = true
   if mode in ["flush-boundary", "no-flush"] {
    boundary := "BROKER-STATUS-RETURNED\n"
    assert C.write(2, boundary.str, usize(boundary.len)) == boundary.len
    C._exit(1)
   }
   return error("selected authenticator process exited")
  }
  time.sleep(time.millisecond)
 }
 return error("fixture child wait deadline")
}
'
