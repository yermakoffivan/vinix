// SPDX-License-Identifier: GPL-2.0-or-later
// Generate the actual View binding, then execute it against a recording JNI ABI.
module main

import crypto.sha256
import json2
import os

fn source_function(source string, name string) !string {
	marker := 'fn ' + name + '('
	if source.count(marker) != 1 { return error('one production function required: ' + name) }
	start := source.index(marker) or { return error('function absent: ' + name) }
	line_end := source[start..].index('\n') or { return error('function line absent: ' + name) }
	if source[start..start + line_end].ends_with('}') { return source[start..start + line_end] }
	end := source[start..].index('\n}') or { return error('function end absent: ' + name) }
	return source[start..start + end + 2]
}

fn recorded(root string, label string, argv []string) !string {
	result := os.exec(argv)
	os.write_file(root + '/' + label + '.json', json2.encode({
		'argv': json2.Any(argv), 'exit_code': json2.Any(result.exit_code), 'output': json2.Any(result.output)
	}, prettify: true) + '\n')!
	if result.exit_code != 0 { return error('command failed; see ' + root + '/' + label + '.json') }
	return result.output
}

fn main() {
	$if prod { panic('live assertions required') }
	assert os.args.len == 4, 'usage: check-native-view-window FRESH_EXTERNAL_OUTPUT REPO FRAMEWORK_SMALI'
	root := os.abs_path(os.args[1])
	repo, smali := os.real_path(os.args[2]), os.real_path(os.args[3])
	assert os.real_path(os.dir(root)) == os.dir(root) && !os.exists(root) && !os.is_link(root)
	assert root != repo && !root.starts_with(repo + '/')
	bindings_path := repo + '/build-support/android/nativews/bindings.txt'
	jni_path := repo + '/build-support/android/atlframework/jni.v'
	generator_path := repo + '/tests/native-android-tools/androidtools/native_ws.v'
	view_path := smali + '/android/view/View.smali'
	bindings, jni := os.read_file(bindings_path)!, os.read_file(jni_path)!
	generator, view := os.read_file(generator_path)!, os.read_file(view_path)!
	selected := bindings.split_into_lines().filter(it.starts_with('android/view/View|native_get_window|'))
	assert selected.len == 1 && selected[0].split('|').len == 3
	assert view.split_into_lines().filter(it.starts_with('.method ') && it.contains(' native ') && it.contains(' native_get_window(J)Landroid/view/Window;')).len == 1
	os.mkdir(root, mode: 0o700)!
	os.mkdir_all(root + '/inputs/smali/android/view', mode: 0o700)!
	os.write_file(root + '/inputs/bindings.txt', bindings)!
	os.write_file(root + '/inputs/jni.v', jni)!
	os.write_file(root + '/inputs/native_ws.v', generator)!
	os.write_file(root + '/inputs/smali/android/view/View.smali', view)!
	os.cp(os.real_path(@FILE), root + '/inputs/checker.v')!
	mut generate := 'module main\nimport os\n'
	for name in ['native_ws_hex4', 'native_ws_jni_escape', 'native_ws_abi', 'native_ws_bindings'] {
		generate += source_function(generator, name)! + '\n'
	}
	// This exact View-only binding cannot enter the unrelated broadcast branch.
	generate += 'fn native_ws_broadcast_bridge(_ string) !bool { return error("unexpected broadcast binding") }\n'
	generate += 'fn main() { os.write_file(os.args[2], native_ws_bindings(' + json2.encode(selected[0]) + ', os.args[1])!)! }\n'
	os.write_file(root + '/generate.v', generate)!
	compiler := os.getenv_opt('VINIX_V_COMPILER') or { 'v' }
	for name in ['generate'] {
		recorded(root, name + '-build', [compiler, '-w', '-n', '-no-parallel', '-cc', 'cc', '-o', root + '/' + name, root + '/' + name + '.v'])!
	}
	recorded(root, 'generate-binding', [root + '/generate', root + '/inputs/smali', root + '/binding.v'])!
	binding := source_function(os.read_file(root + '/binding.v')!, 'ws_binding_0')!
	assert binding.contains('fn ws_binding_0(e voidptr, this voidptr, p0 i64) voidptr')
	mut program := recording_jni
	for name in ['slot', 'pending', 'cls', 'method', 'obj'] { program += source_function(jni, name)! + '\n' }
	program += binding + '\n'
	body := selected[0].split('|')[2]
	old := "return obj(e,ws.activity,c'android/app/Activity',c'getWindow',c'()Landroid/view/Window;',nil)"
	mutations := [old,
		body.replace('if ws.activity == nil { return nil }; ', ''),
		body.replace('if pending(e)', 'if !pending(e)'),
		body.replace('obj(e,ws.activity,', 'obj(e,this,'),
		body.replace('return obj(', '_ = obj(') + '; return nil',
		body.replace('if pending(e)', 'if pending_and_clear(e)')]
	mut checks := 'fn main() { assert window_suite(ws_binding_0, true, true)\n'
	for index, mutation in mutations {
		assert mutation != body, 'negative mutation no longer applies'
		name := 'window_mutant_' + index.str()
		program += 'fn ' + name + '(e voidptr, this voidptr, p0 i64) voidptr { unsafe { ' + mutation + ' } }\n'
		checks += 'assert !window_suite(' + name + ', ' + (index != 0).str() + ', false), "mutant ' + index.str() + ' escaped"\n'
	}
	checks += 'println("NATIVE-VIEW-WINDOW-PASS cases=14 negative-mutations=6 generated-binding recording-JNI original-exception-preserved")\n}\n'
	os.write_file(root + '/probe.v', program + recording_cases + checks)!
	recorded(root, 'probe-build', [compiler, '-w', '-n', '-no-parallel', '-enable-globals', '-cc', 'cc', '-o', root + '/probe', root + '/probe.v'])!
	output := recorded(root, 'probe-run', [root + '/probe'])!
	assert output.trim_space() == 'NATIVE-VIEW-WINDOW-PASS cases=14 negative-mutations=6 generated-binding recording-JNI original-exception-preserved'
	mut pins := map[string]string{}
	for path in [bindings_path, jni_path, generator_path, view_path, os.real_path(@FILE)] {
		pins[path] = sha256.sum(os.read_bytes(path)!).hex()
	}
	assert os.read_file(bindings_path)! == bindings && os.read_file(jni_path)! == jni
	assert os.read_file(generator_path)! == generator && os.read_file(view_path)! == view
	os.write_file(root + '/inputs-sha256.json', json2.encode(pins, prettify: true) + '\n')!
	println(output.trim_space())
}

const recording_jni = '
module main
union Value {
mut:
 l voidptr
 i i32
 j i64
 f f32
 d f64
}
type Lookup = fn (voidptr, &char) voidptr
type Member = fn (voidptr, voidptr, &char, &char) voidptr
type ObjectCall = fn (voidptr, voidptr, voidptr, &Value) voidptr
type Check = fn (voidptr) u8
type Drop = fn (voidptr, voidptr)
type WindowGetter = fn (voidptr, voidptr, i64) voidptr
struct WsState {
mut:
 activity voidptr
}
struct Probe {
mut:
 exception voidptr
 expected_activity voidptr = voidptr(34)
 result voidptr = voidptr(51)
 find_fails bool
 method_fails bool
 call_throws bool
 invalid int
 events string
}
__global ws &WsState
__global probe = Probe{}
__global expected_env voidptr
fn env_ok(e voidptr) { if e != expected_env { probe.invalid++ } }
fn probe_check(e voidptr) u8 { env_ok(e); probe.events += "C"; return u8(probe.exception != unsafe { nil }) }
fn probe_find(e voidptr, name &char) voidptr {
 env_ok(e); probe.events += "F"
 if probe.exception != unsafe { nil } || unsafe { cstring_to_vstring(name) } != "android/app/Activity" { probe.invalid++ }
 if probe.find_fails { probe.exception = voidptr(81); return unsafe { nil } }
 return voidptr(17)
}
fn probe_method(e voidptr, class voidptr, name &char, signature &char) voidptr {
 env_ok(e); probe.events += "M"
 if probe.exception != unsafe { nil } || class != voidptr(17) || unsafe { cstring_to_vstring(name) } != "getWindow" || unsafe { cstring_to_vstring(signature) } != "()Landroid/view/Window;" { probe.invalid++ }
 if probe.method_fails { probe.exception = voidptr(82); return unsafe { nil } }
 return voidptr(18)
}
fn probe_drop(e voidptr, class voidptr) { env_ok(e); probe.events += "D"; if class != voidptr(17) { probe.invalid++ } }
fn probe_object(e voidptr, receiver voidptr, method voidptr, args &Value) voidptr {
 env_ok(e); probe.events += "O"
 if probe.exception != unsafe { nil } || receiver == unsafe { nil } || receiver != probe.expected_activity || method != voidptr(18) || args != unsafe { nil } { probe.invalid++ }
 if probe.call_throws { probe.exception = voidptr(83); return unsafe { nil } }
 return probe.result
}
fn pending_and_clear(e voidptr) bool { result := pending(e); probe.exception = unsafe { nil }; return result }
'

const recording_cases = '
fn window_case(getter WindowGetter, scenario int) bool {
 probe = Probe{}
 mut state := WsState{activity: voidptr(34)}
 unsafe { ws = &state }
 mut expected_result := voidptr(51)
 mut expected_exception := unsafe { voidptr(nil) }
 mut expected_events := "CCFMDO"
 match scenario {
  0, 1 { unsafe { ws = nil }; expected_result = unsafe { nil }; expected_events = "" }
  2, 3 { state.activity = unsafe { nil }; expected_result = unsafe { nil }; expected_events = "" }
  4 { expected_result = unsafe { nil }; expected_events = "C" }
  5, 6 { }
  7 { probe.result = unsafe { nil }; expected_result = unsafe { nil } }
  8 { probe.find_fails = true; expected_result = unsafe { nil }; expected_exception = voidptr(81); expected_events = "CCF" }
  9 { probe.method_fails = true; expected_result = unsafe { nil }; expected_exception = voidptr(82); expected_events = "CCFMD" }
  10 { probe.call_throws = true; expected_result = unsafe { nil }; expected_exception = voidptr(83) }
  11, 12, 13 {
   // Teardown retains the callback receiver locally but clears the global
   // activity before each pause/stop/destroy callback can call this binding.
   retained := state.activity
   state.activity = unsafe { nil }
   if retained != voidptr(34) { return false }
   expected_result = unsafe { nil }; expected_events = ""
  }
  else { return false }
 }
 if scenario in [1, 3, 4] { probe.exception = voidptr(80); expected_exception = voidptr(80) }
 mut table := [229]voidptr{}
 table[6] = voidptr(probe_find)
 table[23] = voidptr(probe_drop)
 table[33] = voidptr(probe_method)
 table[36] = voidptr(probe_object)
 table[228] = voidptr(probe_check)
 mut table_pointer := unsafe { voidptr(&table[0]) }
 env := unsafe { voidptr(&table_pointer) }
 expected_env = env
 result := getter(env, voidptr(102), if scenario == 6 { i64(0) } else { i64(9123) })
 return result == expected_result && probe.exception == expected_exception && probe.events == expected_events && probe.invalid == 0
}
fn window_suite(getter WindowGetter, include_no_state bool, loud bool) bool {
 for scenario in 0 .. 14 {
  if !include_no_state && scenario < 2 { continue }
  if !window_case(getter, scenario) {
   if loud { eprintln("View window case failed: " + scenario.str() + " events=" + probe.events + " invalid=" + probe.invalid.str()) }
   return false
  }
 }
 return true
}
'
