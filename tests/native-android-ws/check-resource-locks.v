// SPDX-License-Identifier: GPL-2.0-or-later
// Production-extracted scopes with real pthread mutexes and instrumented C API
// ownership. This host check makes no ART or Maps crash-causation claim.
module main

import crypto.sha256
import json2
import os

struct ResourceCommand {
	argv []string
	exit_code int
	output string
}

struct ResourceNativeCommand {
	argv []string
	executable string
	executable_sha256 string
}

fn resource_function(source string, name string) string {
	start := source.index('fn ' + name + '(') or { panic('missing ' + name) }
	end := source[start..].index('\n}') or { panic('unclosed ' + name) }
	return source[start..start + end + 2]
}

fn resource_command(work string, label string, argv []string) os.Result {
	result := os.exec(argv)
	os.write_file(work + '/' + label + '.json', json2.encode(ResourceCommand{argv, result.exit_code, result.output}, prettify: true)) or { panic(err) }
	return result
}

fn resource_scopes(source string) {
	for name in ['ws_assets', 'ws_resource', 'ws_theme_value', 'ws_resource_id',
		'ws_resource_name', 'ws_bag_value', 'ws_resource_array', 'ws_array_size',
		'ws_retrieve_array', 'ws_pooled_string', 'ws_set_configuration',
		'ws_new_theme', 'ws_delete_theme', 'ws_theme_apply', 'ws_theme_copy',
		'ws_open_asset', 'ws_apply_style', 'ws_retrieve', 'ws_resolve_attrs'] {
		body := resource_function(source, name)
		assert body.count('ws_resources_enter(manager)') == 1, name
		assert body.count('defer { ws_resources_leave(manager) }') == 1, name
		assert body.count('ws_resources_leave(manager)') == 1, name
		assert !body.contains('C.AssetManager_lock(') && !body.contains('C.AssetManager_unlock('), name
		prefix := body.all_before('ws_resources_enter(manager)')
		for call in ['C.AssetManager_', 'C.Theme_', 'C.ApplyStyle(', 'C.ResolveAttrs(', 'C.RetrieveAttributes('] {
			assert !prefix.contains(call), name + ' calls C API before locking'
		}
	}
	assert source.count('C.AssetManager_lock(') == 2 // declaration and enter
	assert source.count('C.AssetManager_unlock(') == 2
	assert source.contains('@[cinit]\n__global ws_resources_mutex C.pthread_mutex_t = C.PTHREAD_MUTEX_INITIALIZER')
	for name in ['ws_resource_name_locked', 'ws_resource_array_locked', 'ws_value', 'ws_pool_string'] {
		assert !resource_function(source, name).contains('ws_resources_enter('), name
	}
	assert !resource_function(source, 'ws_resource_name_locked').contains('ws_resource_name(')
	assert !resource_function(source, 'ws_open_xml').contains('ws_resources_enter(')
	mut owner := ''
	for line in source.split_into_lines() {
		if line.starts_with('fn ') { owner = line.all_after('fn ').all_before('(') }
		if line.starts_with('fn C.') { continue }
		if line.contains('C.AssetManager_') || line.contains('C.Theme_') ||
			line.contains('C.ApplyStyle(') || line.contains('C.ResolveAttrs(') || line.contains('C.RetrieveAttributes(') {
			if owner in ['ws_resources_enter', 'ws_resources_leave', 'ws_resource_init',
				'ws_value', 'ws_resource_name_locked', 'ws_resource_array_locked'] { continue }
			assert resource_function(source, owner).contains('ws_resources_enter(manager)'), owner
		}
	}
	for path in os.walk_ext('build-support/android/nativews', '.v') {
		text := os.read_file(path) or { panic(err) }
		if text.contains('C.AssetManager_') || text.contains('C.Theme_') ||
			text.contains('C.ApplyStyle(') || text.contains('C.ResolveAttrs(') || text.contains('C.RetrieveAttributes(') {
			assert os.file_name(path) in ['resources.v', 'ndk_assets.v', 'asset_directories.v'], path
		}
	}
	bindings := os.read_file('build-support/android/nativews/bindings.txt') or { panic(err) }
	for line in bindings.split_into_lines() {
		assert !line.contains('C.AssetManager_') && !line.contains('C.Theme_'), line
	}
	for route in ['getArraySize|return ws_array_size(e,this,',
		'retrieveArray|return ws_retrieve_array(e,this,',
		'getPooledString|return ws_pooled_string(e,this,',
		'newTheme|return ws_new_theme(e,this)', 'deleteTheme|ws_delete_theme(e,this,',
		'applyThemeStyle|ws_theme_apply(e,this,', 'copyTheme|ws_theme_copy(e,this,',
		'applyStyle|ws_apply_style(e,this,', 'resolveAttrs|return ws_resolve_attrs(e,this,'] {
		assert bindings.count('android/content/res/AssetManager|' + route) == 1, route
	}
	assert bindings.count('; ws_set_configuration(e,this,&config)') == 1
	for item in [['ndk_assets.v', 'ndk_asset_open'], ['asset_directories.v', 'ws_asset_list']] {
		body := resource_function(os.read_file('build-support/android/nativews/' + item[0]) or { panic(err) }, item[1])
		enter := body.index('ws_resources_enter(manager)') or { panic(item[1]) }
		call := body.index('C.AssetManager_') or { panic(item[1]) }
		leave := body.index('ws_resources_leave(manager)') or { panic(item[1]) }
		assert enter < call && call < leave, item[1]
	}
}

fn main() {
	assert os.args.len in [5, 6], 'usage: check-resource-locks NEW_EXTERNAL_OUTPUT_DIR RETAINED_NATIVE_RESOURCES_V CONSUMED_ASSETMANAGER_SMALI RETAINED_NATIVE_ROOT [--initializer-only]'
	initializer_only := os.args.len == 6
	if initializer_only { assert os.args[5] == '--initializer-only' }
	repo := os.real_path(os.getwd())
	work := os.abs_path(os.args[1])
	assert !os.exists(work) && !os.is_link(work) && work != repo && !work.starts_with(repo + '/')
	source := os.read_file('build-support/android/nativews/resources.v')!
	old := os.read_file(os.args[2])!
	assert sha256.hexhash(old) == '066ed7687e165976d50fc88f9b74c9be6f7e502b6063e0ef7582a45c7e916cd2', 'retained native source pin changed'
	asset_manager := os.read_file(os.args[3])!
	for descriptor in ['newTheme()J', 'deleteTheme(J)V', 'applyThemeStyle(JIZ)V',
		'copyTheme(JJ)V', 'applyStyle(JJII[IIJJ)V', 'resolveAttrs(JII[I[I[I[I)Z',
		'setConfiguration(IILjava/lang/String;IIIIIIIIIIIIII)V'] {
		declarations := asset_manager.split_into_lines().filter(it.starts_with('.method ') && it.ends_with(' ' + descriptor))
		assert declarations.len == 1 && declarations[0].contains(' native ') && !declarations[0].contains(' static '), descriptor
	}
	resource_scopes(source)
	os.mkdir_all(work)!
	for name in ['resources.v', 'bindings.txt', 'ndk_assets.v', 'asset_directories.v'] {
		os.cp('build-support/android/nativews/' + name, work + '/' + name + '.input')!
	}
	os.write_file(work + '/retained-resources.v.input', old)!
	os.write_file(work + '/consumed-AssetManager.smali.input', asset_manager)!
	os.cp(@FILE, work + '/checker.v.input')!
	compiler := os.real_path(os.getenv_opt('VINIX_V_COMPILER') or { os.find_abs_path_of_executable('v')! })
	if !initializer_only {
	mut code := ''
	for name in ['ws_resources_enter', 'ws_resources_leave', 'ws_open_asset',
		'ws_resource_name', 'ws_resource_name_locked',
		'ws_pooled_string', 'ws_array_size', 'ws_retrieve_array', 'ws_theme_copy',
		'ws_theme_apply', 'ws_new_theme', 'ws_delete_theme', 'ws_set_configuration'] {
		code += '\n' + resource_function(source, name)
	}
	code += '\n' + resource_function(old, 'ws_open_asset').replace('fn ws_open_asset(', 'fn old_open_asset(')
	copy := resource_function(source, 'ws_theme_copy')
	code += '\n' + copy.replace('fn ws_theme_copy(', 'fn manager_only_copy(')
		.replace('ws_resources_enter(manager)', 'probe_manager_lock(manager)')
		.replace('ws_resources_leave(manager)', 'probe_manager_unlock(manager)')
	pooled := resource_function(source, 'ws_pooled_string')
	code += '\n' + pooled.replace('fn ws_pooled_string(', 'fn early_string_unlock(')
		.replace('defer { ws_resources_leave(manager) }', '')
		.replace('return ws_pool_string(e, C.AssetManager_getStringPoolForCookie(manager, cookie - 1), index)',
			'pool := C.AssetManager_getStringPoolForCookie(manager, cookie - 1)\n\tws_resources_leave(manager)\n\treturn ws_pool_string(e, pool, index)')
	code = code.replace('C.pthread_mutex_lock(', 'probe_global_lock(')
		.replace('C.pthread_mutex_unlock(', 'probe_global_unlock(')
		.replace('C.AssetManager_lock(', 'probe_manager_lock(')
		.replace('C.AssetManager_unlock(', 'probe_manager_unlock(')
		.replace('C.AssetManager_openNonAsset(', 'probe_open(')
		.replace('C.AssetManager_getStringPoolForCookie(', 'probe_pool(')
		.replace('C.AssetManager_getBag(', 'probe_bag(')
		.replace('C.AssetManager_getResourceName(', 'probe_name(')
		.replace('C.Theme_setTo(', 'probe_copy(')
		.replace('C.Theme_applyStyle(', 'probe_apply(')
		.replace('C.AssetManager_newTheme(', 'probe_new_theme(')
		.replace('C.Theme_delete(', 'probe_delete_theme(')
		.replace('C.AssetManager_setConfiguration(', 'probe_configuration(')
		.replace('C.ResTable_config', 'ProbeConfig')
		.replace('C.resource_name', 'ProbeName')
		.replace('WsNewString(slot(e, 163))', 'probe_new_string')
	os.write_file(work + '/main.v', probe_model + code + probe_cases)!
	build := resource_command(work, 'build', [compiler, '-new-compiler', '-gc', 'boehm', '-nocache',
		'-cc', 'cc', '-enable-globals', '-keepc', '-o', work + '/probe', work + '/main.v'])
	assert build.exit_code == 0, build.output
	run := resource_command(work, 'run', [work + '/probe'])
	assert run.exit_code == 0 && run.output.contains('RESOURCE-LOCKS-PASS'), run.output
	for control in ['old-open', 'manager-only-copy', 'early-string-unlock'] {
		negative := resource_command(work, control, [work + '/probe', control])
		expected := if control == 'manager-only-copy' { 'global-before-manager required' } else { 'unlocked C API or borrowed copy' }
		assert negative.exit_code != 0 && negative.output.contains('RESOURCE-CONTROL ' + control)
			&& negative.output.contains('assert') && negative.output.contains(expected), control + '\n' + negative.output
	}
	}
	// Qualify the aggregate initializer through the exact freestanding generator
	// and compiler used for the retained native library, then compile ARM C.
	native := os.real_path(os.args[4])
	legacy := native + '/compiler-root/v'
	assert sha256.sum(os.read_bytes(legacy)!).hex() == '109a0bad877cf42cd19382a87d3e3d62e9c153e3d74a566b2b3e650a1aec318e'
	assert sha256.sum(os.read_bytes(native + '/tools/native-generator')!).hex() == 'fdbfb5bb2f447d0a8499530399830ef6bfd8303d5d3071678851b44f41d1f63f'
	header := native + '/native/androidfw_c_api.h'
	assert sha256.sum(os.read_bytes(header)!).hex() == 'e233a055133776838b8044ca43eb9e8dfac387a0580918786d60207276d37af4'
	os.cp(header, work + '/androidfw_c_api.h.input')!
	preamble := '#define _LARGEFILE64_SOURCE\n#include "androidfw_c_api.h"\n#include <stdlib.h>\n#include <string.h>\n#include <pthread.h>\n'
	assert source.contains(preamble), 'production resource preamble changed'
	os.mkdir(work + '/resourcelockprobe')!
	os.write_file(work + '/resourcelockprobe/probe.v', '@[translated]\nmodule resourcelockprobe\n' +
		preamble +
		'struct C.pthread_mutex_t {}\nfn C.abort()\n' +
		'fn C.pthread_mutex_lock(&C.pthread_mutex_t) i32\nfn C.pthread_mutex_unlock(&C.pthread_mutex_t) i32\n' +
		'fn C.AssetManager_lock(voidptr)\nfn C.AssetManager_unlock(voidptr)\n' +
		'@[cinit]\n__global ws_resources_mutex C.pthread_mutex_t = C.PTHREAD_MUTEX_INITIALIZER\n' +
		resource_function(source, 'ws_resources_enter') + '\n' + resource_function(source, 'ws_resources_leave') +
		'\n@[export: "vinix_resource_lock_probe"]\npub fn probe(manager voidptr) { ws_resources_enter(manager); ws_resources_leave(manager) }\n')!
	for key in ['V', 'VEXE', 'VINIX_V_COMPILER'] { os.setenv(key, legacy, true) }
	os.setenv('VROOT', native + '/compiler-root', true)
	generated := resource_command(work, 'legacy-generate', [native + '/tools/native-generator',
		work + '/resourcelockprobe', work + '/mutex-arm64.c', '--arch', 'arm64'])
	assert generated.exit_code == 0, generated.output
	c_source := os.read_file(work + '/mutex-arm64.c')!
	assert c_source.count('pthread_mutex_t resourcelockprobe__ws_resources_mutex = PTHREAD_MUTEX_INITIALIZER;') == 1
	assert c_source.count('resourcelockprobe__ws_resources_mutex =') == 1, 'runtime mutex initializer write'
	// Replay the actual successful compiler/link argv. Only the generated source
	// and final output operands change; all flags and library inputs stay exact.
	command_text := os.read_file(native + '/commands/build-native.json')!
	os.write_file(work + '/build-native.json.input', command_text)!
	production := json2.decode[ResourceNativeCommand](command_text)!
	assert sha256.sum(os.read_bytes(production.executable)!).hex() == production.executable_sha256
	input_pins := json2.decode[map[string]string](os.read_file(native + '/reused-inputs.json')!)!
	os.cp(native + '/reused-inputs.json', work + '/reused-inputs.json.input')!
	mut argv := production.argv.clone()
	mut inputs := 0
	mut outputs := 0
	for index, argument in argv {
		if argument == native + '/native/android-native.c' {
			argv[index] = work + '/mutex-arm64.c'
			inputs++
		} else if argument == native + '/native/libvinix-android-native.so' {
			argv[index] = work + '/mutex-arm64.so'
			outputs++
		} else if argument.starts_with('/') {
			expected := input_pins[argument] or { panic('missing retained input pin: ' + argument) }
			assert sha256.sum(os.read_bytes(argument)!).hex() == expected, argument
		}
	}
	assert inputs == 1 && outputs == 1
	linked := resource_command(work, 'legacy-arm-link', argv)
	assert linked.exit_code == 0, linked.output
	exports := resource_command(work, 'legacy-arm-exports', ['/opt/homebrew/bin/aarch64-linux-musl-nm',
		'-D', '--defined-only', '-j', work + '/mutex-arm64.so'])
	retained_exports := resource_command(work, 'retained-arm-exports', ['/opt/homebrew/bin/aarch64-linux-musl-nm',
		'-D', '--defined-only', '-j', native + '/native/libvinix-android-native.so'])
	assert retained_exports.exit_code == 0
	for startup in ['_fini', '_init'] {
		assert retained_exports.output.split_into_lines().filter(it == startup).len == 1, startup
	}
	// The same production linker emits the same two CRT startup exports. Every
	// adapter helper and the mutex itself must remain hidden.
	assert exports.exit_code == 0 && exports.output.trim_space() == '_fini\n_init\nvinix_resource_lock_probe', exports.output
	revision := resource_command(work, 'source-revision', ['git', 'rev-parse', 'HEAD'])
	assert revision.exit_code == 0
	os.write_file(work + '/evidence.json', json2.encode({
		'scope': if initializer_only { 'Production-extracted mutex preamble/scopes; exact retained generator and compiler; static initializer and two-operand production ARM link replay. Earlier host contention proof is separate.' } else { 'Production-extracted scopes; real pthread mutexes; 4 workers, raw themes, borrowed copy, cleanup, three negative controls, and production ARM initializer/link replay. Instrumented C API/JNI; no ART or Maps claim.' }
		'source_revision': revision.output.trim_space()
		'source_sha256': sha256.hexhash(source)
		'retained_source_sha256': sha256.hexhash(old)
		'compiler': compiler
		'compiler_sha256': sha256.sum(os.read_bytes(compiler)!).hex()
	}, prettify: true))!
	mut hashes := map[string]string{}
	for path in os.walk_ext(work, '') {
		if os.is_file(path) { hashes[path[work.len + 1..]] = sha256.sum(os.read_bytes(path)!).hex() }
	}
	os.write_file(work + '/sha256.json', json2.encode(hashes, prettify: true))!
	println(if initializer_only { 'RESOURCE-INITIALIZER-CHECK-PASS static-mutex exact-production-link' } else { 'RESOURCE-LOCKS-CHECK-PASS scopes concurrency negative-controls=3 static-mutex exact-production-link' })
}

const probe_model = '
@[translated]
module main
import os
#include <pthread.h>
#include <stdlib.h>
#include <sched.h>
#include <alloca.h>
#include <string.h>
fn C.alloca(usize) voidptr
fn C.memset(voidptr, int, usize) voidptr
struct C.pthread_mutex_t {}
@[typedef]
struct C.pthread_key_t {}
fn C.pthread_mutex_init(&C.pthread_mutex_t, voidptr) i32
fn C.pthread_mutex_destroy(&C.pthread_mutex_t) i32
fn C.pthread_mutex_lock(&C.pthread_mutex_t) i32
fn C.pthread_mutex_unlock(&C.pthread_mutex_t) i32
fn C.pthread_key_create(&C.pthread_key_t, voidptr) i32
fn C.pthread_key_delete(C.pthread_key_t) i32
fn C.pthread_getspecific(C.pthread_key_t) voidptr
fn C.pthread_setspecific(C.pthread_key_t, voidptr) i32
fn C.sched_yield() i32
fn C.abort()
@[cinit]
__global ws_resources_mutex C.pthread_mutex_t = C.PTHREAD_MUTEX_INITIALIZER
__global probe_scope C.pthread_key_t
__global probe_manager C.pthread_key_t
__global probe_operations int
struct ProbeConfig { density u16 }
struct Value { l voidptr }
struct ProbeName { mut:
 package &char = unsafe { nil }
 package_len usize
 @type &char = unsafe { nil }
 type16 &u16 = unsafe { nil }
 type_len usize
 entry &char = unsafe { nil }
 entry16 &u16 = unsafe { nil }
 entry_len usize
}
struct ProbeBag { mut: entry_count u32 = 3 }
struct ProbeManager { mut: mutex C.pthread_mutex_t bag ProbeBag }
fn probe_global_lock(mutex &C.pthread_mutex_t) i32 {
 assert C.pthread_getspecific(probe_scope) == unsafe { nil }, "nested global lock"
 result := C.pthread_mutex_lock(mutex)
 if result == 0 { assert C.pthread_setspecific(probe_scope, voidptr(1)) == 0 }
 return result
}
fn probe_global_unlock(mutex &C.pthread_mutex_t) i32 {
 assert C.pthread_getspecific(probe_manager) == unsafe { nil }, "manager-before-global unlock"
 assert C.pthread_getspecific(probe_scope) != unsafe { nil }
 assert C.pthread_setspecific(probe_scope, unsafe { nil }) == 0
 return C.pthread_mutex_unlock(mutex)
}
fn probe_manager_lock(value voidptr) {
 assert C.pthread_getspecific(probe_scope) != unsafe { nil }, "global-before-manager required"
 assert C.pthread_getspecific(probe_manager) == unsafe { nil }, "second manager lock"
 mut manager := unsafe { &ProbeManager(value) }
 assert C.pthread_mutex_lock(&manager.mutex) == 0
 assert C.pthread_setspecific(probe_manager, value) == 0
}
fn probe_manager_unlock(value voidptr) {
 assert C.pthread_getspecific(probe_manager) == value
 assert C.pthread_setspecific(probe_manager, unsafe { nil }) == 0
 mut manager := unsafe { &ProbeManager(value) }
 assert C.pthread_mutex_unlock(&manager.mutex) == 0
}
fn probe_api(value voidptr) {
 assert C.pthread_getspecific(probe_scope) != unsafe { nil }, "unlocked C API or borrowed copy"
 assert C.pthread_getspecific(probe_manager) == value, "wrong manager owner"
 // Like libandroidfw\'s shared operation counter, this update depends on the
 // actual outer mutex. Yield inside it to exercise contention.
 unsafe { probe_operations++ }
 C.sched_yield()
}
fn ws_manager(_ voidptr, object voidptr) voidptr { return object }
fn ws_utf(_ voidptr, _ voidptr) &char { return c"resource" }
fn ws_release(_ voidptr, _ voidptr, _ &char) {}
fn probe_open(manager voidptr, _ &char, mode i32) voidptr {
 probe_api(manager)
 return if mode < 0 { unsafe { nil } } else { manager }
}
fn probe_pool(manager voidptr, _ i32) voidptr { probe_api(manager); return manager }
fn ws_pool_string(_ voidptr, pool voidptr, _ i32) voidptr { probe_api(pool); return pool }
fn probe_bag(value voidptr, id u32) &ProbeBag {
 probe_api(value)
 if id == 0 { return unsafe { nil } }
 mut manager := unsafe { &ProbeManager(value) }
 return unsafe { &manager.bag }
}
fn ws_resource_array_locked(_ voidptr, manager voidptr, _ i32, _ voidptr, _ bool) voidptr {
 probe_api(manager)
 return manager
}
fn probe_copy(theme voidptr, source voidptr) { probe_api(theme); assert source != unsafe { nil } }
fn probe_apply(theme voidptr, _ u32, _ bool) { probe_api(theme) }
fn probe_new_theme(manager voidptr) voidptr { probe_api(manager); return manager }
fn probe_delete_theme(theme voidptr) { probe_api(theme) }
fn probe_configuration(manager voidptr, _ &ProbeConfig) { probe_api(manager) }
fn probe_name(manager voidptr, id u32, name &ProbeName) u32 {
 probe_api(manager)
 if id == 0 { return 0 }
 unsafe {
  mut target := &ProbeName(name)
  target.package = c"package"
  target.@type = c"string"
  target.entry = c"entry"
 }
 return 1
}
fn ws_string(_ voidptr, _ &char) voidptr {
 manager := C.pthread_getspecific(probe_manager)
 probe_api(manager)
 return manager
}
fn probe_new_string(_ voidptr, _ &u16, _ i32) voidptr { return ws_string(unsafe { nil }, c"") }
fn obj(_ voidptr, value voidptr, _ &char, _ &char, _ &char, _ &Value) voidptr {
 probe_api(value)
 return value
}
'

const probe_cases = '
fn worker(manager voidptr, source voidptr) {
 for _ in 0 .. 250 {
  assert ws_open_asset(unsafe { nil }, manager, unsafe { nil }, 3) == i64(manager)
  assert ws_pooled_string(unsafe { nil }, manager, 1, 0) == manager
  assert ws_array_size(unsafe { nil }, manager, 1) == 3
  assert ws_retrieve_array(unsafe { nil }, manager, 1, unsafe { nil }) == 3
  assert ws_resource_name(unsafe { nil }, manager, 1, 3) == manager
  theme := ws_new_theme(unsafe { nil }, manager)
  ws_theme_apply(unsafe { nil }, manager, theme, 1, true)
  ws_theme_copy(unsafe { nil }, manager, theme, i64(source))
  ws_delete_theme(unsafe { nil }, manager, theme)
  ws_set_configuration(unsafe { nil }, manager, &ProbeConfig{density: 160})
 }
 assert C.pthread_getspecific(probe_scope) == unsafe { nil }
 assert C.pthread_getspecific(probe_manager) == unsafe { nil }
}
fn main() {
 assert C.pthread_key_create(&probe_scope, unsafe { nil }) == 0
 assert C.pthread_key_create(&probe_manager, unsafe { nil }) == 0
 mut a := ProbeManager{}
 mut b := ProbeManager{}
 assert C.pthread_mutex_init(&a.mutex, unsafe { nil }) == 0
 assert C.pthread_mutex_init(&b.mutex, unsafe { nil }) == 0
 if os.args.len == 2 {
  eprintln("RESOURCE-CONTROL " + os.args[1])
  match os.args[1] {
   "old-open" { old_open_asset(unsafe { nil }, &a, unsafe { nil }, 3) }
   "manager-only-copy" { manager_only_copy(unsafe { nil }, &a, i64(&a), i64(&b)) }
   "early-string-unlock" { early_string_unlock(unsafe { nil }, &a, 1, 0) }
   else { assert false }
  }
  println("CONTROL-SURVIVED")
  return
 }
 assert ws_open_asset(unsafe { nil }, &a, unsafe { nil }, -1) == 0
 assert ws_resource_name(unsafe { nil }, &a, 0, 3) == unsafe { nil }
 assert ws_array_size(unsafe { nil }, &a, 0) == 0
 assert ws_retrieve_array(unsafe { nil }, &a, 0, unsafe { nil }) == 0
 assert C.pthread_getspecific(probe_scope) == unsafe { nil }
 assert C.pthread_getspecific(probe_manager) == unsafe { nil }
 unsafe { probe_operations = 0 }
 // Opposite-direction and same-owner copies must never nest manager locks.
 t1 := spawn worker(&a, &b)
 t2 := spawn worker(&b, &a)
 t3 := spawn worker(&a, &a)
 t4 := spawn worker(&b, &b)
 t1.wait(); t2.wait(); t3.wait(); t4.wait()
 assert probe_operations == 24000
 assert C.pthread_mutex_destroy(&a.mutex) == 0
 assert C.pthread_mutex_destroy(&b.mutex) == 0
 assert C.pthread_key_delete(probe_scope) == 0
 assert C.pthread_key_delete(probe_manager) == 0
 println("RESOURCE-LOCKS-PASS workers=4 iterations=1000 api=24000")
}
'
