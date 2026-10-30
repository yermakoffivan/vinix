// SPDX-License-Identifier: GPL-2.0-or-later
// GMS companion provisioning and unseeded UserManager options over broker-tail media.
module main

import crypto.sha256
import json2
import mapsaccountstage as stage
import os
import time
import v.embed_file

#include <sys/clonefile.h>
fn C.clonefile(&char, &char, int) int

const state_root = '/Users/alex/.local/state/vinix/android'
const base_root = state_root + '/maps-broker-tail-r1'
const base_seal = 'c6ab0709b40b1718f0d3c6d13e6f1ba3f2a8ccf5de2b6a8e36cd62802ef2c6e9'
const base_boot_pin = 'e8e820377cae6fb1b0f32e0c7d0eedeb4164b9bab82c71226b8c35d3867b52f4'
const startup_root = state_root + '/maps-startup-r1'
const startup_seal = 'f79065bc79d816f8cf35a21c72ef375369229b0ee8170165890808e3d194e332'
const controller_stage_root = state_root + '/maps-controller-r1'
const controller_stage_seal = '3026dfd0e7d69fe81d0b8ba4d504d952fd14fa34d20c9b4cdf6d0b98cc9d857a'
const old_controller_root = state_root + '/maps-account-guest-build-2026-10-30-tail-drain-r4'
const old_controller_seal = 'cd14f050b8f3dfd96728605826d324d1ec7b291f96effbe58711759ff254324f'
const old_controller_pin = 'bf30d23fb34a382b517688df073fb54b0c140bdedd51afb5444c3f96e870bdbe'
const controller_root = state_root + '/maps-account-guest-build-2026-10-30-gms-companion-r1'
const controller_seal = 'd903515f7d493f6174128bede8511e8f470515b580a8e5374aa5623360e289d5'
const controller_pin = '7d48a43d7f6fbe39ad5704e68a62b1cdbab65e867000c91f5fdfbc9066cfc216'
const broker_root = state_root + '/current-account-broker-build-2026-10-30-child-status-r1'
const broker_seal = '7bba04e39681e31c6e13dbd65df99094dadec17a1ab99e114e50f74aa2d18ae9'
const broker_pin = '0bf4d36c6c4035eb7e736ee04f3f7a612b9582ef44bad6950bf0aa8b1b1c35ee'
const retained_broker_seal = 'b06d4aadb661eb1ba13ac07e9033d88db1db731d54d2b1685df6dba1e69cd8f6'
const broker_framework_root = state_root + '/combined-account-webview-application-restrictions-framework-2026-10-28-r1'
const broker_framework_seal = '8907c1f11d8886b47358b458a8026d8351c6feac44d78346d6d426208b8ffe15'
const old_framework_root = state_root + '/combined-account-webview-window-system-ui-framework-2026-10-30-r1'
const old_framework_seal = '1e24a8dcc2f5b315ebbb63cb06d3de46e0799b4b1a0d19339d3b98ecab0c3b09'
const old_framework_build_pin = 'd648c6541230aca6f9a369f8e99d19cb3e971670c930f82339de38fb1d48eb7b'
const framework_root = state_root + '/combined-account-webview-seed-account-options-framework-2026-10-30-r1'
const framework_seal = '470636b2812f339d58071ba59986282ac5107e5256aa2588dd9305d7ef5b45e9'
const framework_build_pin = '4934f484c1d9dbeb41e0b9e53e31634cae19be72a21bbf88bb758969bec046ce'
const native_root = state_root + '/current-native-build-2026-10-30-window-system-ui-r1'
const native_seal = 'b564d361fd1fc0271cba1967c84ac6b3ca32607b832bd6114c6943be777e2872'
const native_build_pin = '2b9fee52a40c382b949761e6759389bfc1fa4c07fbc6ab27900705bbaf14c7e2'
const native_pin = 'c97862ecb4eba730290a832b2766d58c1552ddf58ae40f77d7e140e69538ce75'
const generated_pin = 'b349742dff2bdcc464e3df011ccf54d0ff546ea36a1feb9cd82b26ec3da67dde'
const successor_native_root = state_root + '/current-native-build-2026-10-30-seed-account-options-r1'
const successor_native_seal = '8fbfbd2c74eca6c412909a2a64fb91949cbaa1ed0b262e9970ff375dddff61f8'
const successor_native_pin = '179f51ad25cc99fd939ca1f217e87f1d3ab9c452b98db861da11e0344363f6ce'
const successor_native_build_pin = '1a968278009d05f2c3d68068b46f5128c46f23ee6ae7bb384ede50c67bc2c5ce'
const headless_source_pin = 'd22892cc47def3c2e830a6e29873acd5c0eb08b944f68d131e39f4922c1663ff'
const framework_helper_after_pin = '7f5a04072cbba86c1c4f752c9eb4f085055488a16b2591d123b75729f44feab4'
const seed_helper_added_pin = 'ac0b975213dc9c55c99ed9fed78a61e1653bcff55c932a2a312524e0e9ea0f03'
const bindings_pin = 'e3fa613993c1ca60aab021ebdbacc93dc71ae68e4bef3d112482f77c8ddeb95b'
const builder_pin = 'a468758d4957f66703836da209b901e1344a2f889b27c2df868630d97adc4d33'
const framework_helper_before_pin = 'd178f0c882be349f8511b722ba86c12f7876dc8c202629af041a86589eae4767'
const browser_seal = 'fa39f1486d651dff8904a9d75e82cf67d462b2c41511a1a4cd3a184c49239e62'
const browser_pin = '16def2047bf7605a23d949ff7b6b56bc56dcece038136553a98a0524b26ded1a'
const old_jar_pin = '3f0d220a24e7d91a47f7b2d42cd5620aa498981e915a90cdbd806164b8ef0fc1'
const old_dex_pin = 'e9509dedcf935f143ffc0a68bd8af3b26901b69e231388be7ea1c2c72c5bd150'
const jar_pin = 'cb2e3fabab652c65351da16770ae98c4113781df0830440b734395bb35b6f265'
const dex_pin = '790d9c0436e070a0ff643127228f622f0a30ae12e4560e7acccadf4550a13dfa'
const launch_seal = '920ed6f1a5f5d9e705bdcc108937db6266066718fe4203859a6ac8577bd405be'
const controller_path = 'opt/vinix-maps-account/bin/maps-account-guest'
const broker_path = 'opt/vinix-android-aarch64/usr/bin/native-account-broker'
const alias_path = 'usr/bin/run-android-calculator'
const deployment_path = 'opt/vinix-maps-account/build.json'
const jar_path = 'opt/vinix-android-aarch64/usr/lib/java/dex/android_translation_layer/api-impl.jar'
const dex_path = 'opt/vinix-android-aarch64/usr/lib/java/dex/android_translation_layer/classes.dex'
const native_path = 'opt/vinix-android-aarch64/usr/lib/art/libvinix-android-native.so'
const headless = 'opt/vinix-headless-service'
const headless_base = state_root + '/maps-window-system-ui-r1/payload/'
const old_headless_pin = '5d143cd0aa44ef618c5fccd3cc85f019eee66a8de69c6f9a33041dbd144346e7'
const old_deployment_pin = '34222710eda5c2ebb42b79ad6d778aea0fd328d8ca1cbb68256c5ef8b8c4f142'
const vending_root = state_root + '/maps-vending-admission-2026-10-30-r2'
const vending_seal = 'c6e9ec6ef3280b977fadee1aed5a7d91a94d10807bbc65da1feff98823228f1d'
const vending_path = 'opt/vinix-maps-account/apks/vending.apk'
const vending_pin = '444e41ee8ef6ec8c55815087c51c28e516ea32f93d856f8bdd0025bb6fc36bc2'
const vending_size = u64(106020565)
const vending_signer = 'f0fd6c5b410f25cb25c3b53346c8972fae30f8ee7411df910480ad6b2d60db83'
const vending_module_pin = '1c6988d1f3d3844425f0e8cbb49a878b3a16f2a270b4eb3852c71dfaa8fe200e'
const vending_member = 'tmp/maps256-data/_installed_apks_/com.android.vending.apk'
const overlay = 'maps-seed-account-companion.tar'
const disk_reserve = u64(1024) * 1024 * 1024
const disk_growth = u64(512) * 1024 * 1024
const digest_receipt_charge = u64(1024) * 1024
const retained = {
	'tests/native-android-ws/maps-seed-account-companion-stage.v': carry($embed_file(@FILE))
	'tests/native-android-ws/mapsaccountstage/bundle.v': carry($embed_file('mapsaccountstage/bundle.v'))
	'tests/native-android-ws/mapsaccountstage/hostsha.v': carry($embed_file('mapsaccountstage/hostsha.v'))
	'tests/native-android-ws/mapsaccountstage/parallel.v': carry($embed_file('mapsaccountstage/parallel.v'))
	'tests/native-android-ws/mapsaccountstage/elf.v': carry($embed_file('mapsaccountstage/elf.v'))
	'tests/native-android-ws/mapsaccountstage/media.v': carry($embed_file('mapsaccountstage/media.v'))
	'tests/native-android-ws/mapsaccountstage/headless.v': carry($embed_file('mapsaccountstage/headless.v'))
	'build-support/android/modulestream/stream.v': carry($embed_file('../../build-support/android/modulestream/stream.v'))
	'build-support/android/modulestream/spawn_abi.h': carry($embed_file('../../build-support/android/modulestream/spawn_abi.h'))
	'build-support/tarcore/writer.v': carry($embed_file('../../build-support/tarcore/writer.v'))
	'build-support/tarcore/gzip.v': carry($embed_file('../../build-support/tarcore/gzip.v'))
	'build-support/tarstream/reader.v': carry($embed_file('../../build-support/tarstream/reader.v'))
	'build-support/tarstream/filter_abi.h': carry($embed_file('../../build-support/tarstream/filter_abi.h'))
	'build-support/tarstream/sparse.v': carry($embed_file('../../build-support/tarstream/sparse.v'))
}

fn carry(data embed_file.EmbedFileData) string {
	if data.str().all_after('uncompressed: ').trim_right(' }') == '0' { panic('requires -prod embedded source closure') }
	return data.to_string()
}
fn as_json[T](value T) !json2.Any { return json2.decode[json2.Any](json2.encode(value)) }
fn write_json(path string, value json2.Any) ! {
	os.mkdir_all(os.dir(path), mode: 0o755)!
	os.write_file(path, json2.encode(value, prettify: true) + '\n')!
}
fn read_json(path string) !map[string]json2.Any {
	if os.lstat(path)!.size > 8 * 1024 * 1024 { return error('receipt exceeds bound') }
	return json2.decode[map[string]json2.Any](os.read_file(path)!)!
}
fn copy_file(source string, destination string, mode u32) ! {
	if os.real_path(source) != source || os.lstat(source)!.get_filetype() != .regular
		|| os.exists(destination) || os.is_link(destination) { return error('canonical regular source and fresh destination required') }
	os.mkdir_all(os.dir(destination), mode: 0o755)!
	os.cp(source, destination)!
	os.chmod(destination, int(mode))!
}
struct DiskBudget {
mut:
	available u64
	charged u64
	digest_receipt_charged u64
}
fn disk_blocks(field string) !u64 {
	if field == '' || field.len > 17 { return error('invalid df count') }
	mut value := u64(0)
	limit := u64(0xffffffffffffffff) / 1024
	for digit in field.bytes() {
		if digit < `0` || digit > `9` || value > (limit - u64(digit - `0`)) / 10 { return error('invalid or overflowing df count') }
		value = value * 10 + u64(digit - `0`)
	}
	return value
}
fn available_bytes(output string) !u64 {
	rows := output.trim_space().split_into_lines()
	if output.len > 8192 || rows.len != 2 || rows[0].fields() != ['Filesystem', '1024-blocks', 'Used', 'Available', 'Capacity', 'Mounted', 'on'] { return error('unexpected df output') }
	fields := rows[1].fields()
	if fields.len < 6 || !fields[0].starts_with('/') || !fields[5].starts_with('/') || !fields[4].ends_with('%') { return error('invalid df row') }
	total := disk_blocks(fields[1])!
	used := disk_blocks(fields[2])!
	available := disk_blocks(fields[3])!
	disk_blocks(fields[4][..fields[4].len - 1])!
	if total == 0 || used > total || available > total { return error('inconsistent df count') }
	return available * 1024
}
fn update_budget(available u64, writing bool, mut budget DiskBudget) ! {
	drop := if writing && available < budget.available { budget.available - available } else { u64(0) }
	if available < disk_reserve || budget.charged > disk_growth || drop > disk_growth - budget.charged { return error('1 GiB reserve or cumulative 512 MiB preparation growth budget exceeded') }
	budget.charged += drop
	budget.available = available
}
fn disk_available(path string) !u64 {
	mut child := os.new_process('/usr/bin/env')
	child.set_args(['LC_ALL=C', '/bin/df', '-kP', path])
	child.set_stdin_path('/dev/null')
	child.set_redirect_stdio()
	child.run()
	mut finished := false
	defer {
		if !finished { child.signal_kill(); child.wait() }
		child.close()
	}
	mut stdout := ''
	mut stderr := ''
	deadline := time.sys_mono_now() + 2 * time.second
	for {
		out := child.stdout_read()
		errout := child.stderr_read()
		if stdout.len + stderr.len + out.len + errout.len > 8192 { return error('df output exceeds bound') }
		stdout += out
		stderr += errout
		if !child.is_alive() && out == '' && errout == '' { break }
		if time.sys_mono_now() >= deadline { return error('df deadline exceeded') }
		time.sleep(10 * time.millisecond)
	}
	child.wait()
	finished = true
	if child.code != 0 || stderr != '' { return error('df failed') }
	return available_bytes(stdout)
}
fn check_disk(root string, label string, writing bool, mut budget DiskBudget, mut samples map[string]u64) ! {
	available := disk_available(os.dir(root))!
	update_budget(available, writing, mut budget)!
	samples[label] = available
	println('MAPS-SEED-ACCOUNT-COMPANION disk ' + label + ' available_bytes=' + available.str() + ' charged_growth_bytes=' + budget.charged.str())
}
fn charge_audit(count int, mut budget DiskBudget) ! {
	if count < 1 || count > 31 || budget.charged > disk_growth || u64(count) * digest_receipt_charge > disk_growth - budget.charged { return error('module digest receipts exceed preparation budget') }
	budget.charged += u64(count) * digest_receipt_charge
	budget.digest_receipt_charged += u64(count) * digest_receipt_charge
}
fn audit_modules(root string, label string, image string, names []string, expected map[string]string,
	mut budget DiskBudget, mut samples map[string]u64) !map[string]string {
	if names.len < 1 || names.len > 31 || names.len != expected.len { return error('bounded exact module audit required') }
	mut pins := map[string]string{}
	for name in names {
		if name in pins { return error('duplicate module audit member') }
		pin := stage.module_hash(root, label + '-' + name, image, name)!
		if pin != expected[name]! { return error('audited module differs: ' + name) }
		path := root + '/commands/' + label + '-' + name + '.sha256'
		info := os.lstat(path)!
		if info.get_filetype() != .regular || info.mode & 0o7777 != 0o600 || info.size != 68
			|| os.read_file(path)! != pin + '  -\n' { return error('exact bounded digest receipt required') }
		pins[name] = pin
	}
	charge_audit(names.len, mut budget)!
	check_disk(root, label + '-module-audit', false, mut budget, mut samples)!
	return pins
}
fn exact_profile(base string, manifest string, jar string, dex string) ! {
	if base != base_seal || manifest != framework_seal || jar != jar_pin || dex != dex_pin
		|| !stage.valid_pin(manifest) || !stage.valid_pin(jar) || !stage.valid_pin(dex)
		|| !stage.valid_pin(framework_build_pin)
		|| !stage.valid_pin(controller_seal) || !stage.valid_pin(controller_pin)
		|| !stage.valid_pin(vending_seal) || !stage.valid_pin(vending_pin) || !stage.valid_pin(vending_signer)
		|| controller_seal == old_controller_seal || controller_pin == old_controller_pin
		|| !stage.valid_pin(successor_native_seal) || !stage.valid_pin(successor_native_pin) || !stage.valid_pin(successor_native_build_pin)
		|| !stage.valid_pin(headless_source_pin) || !stage.valid_pin(framework_helper_after_pin) || !stage.valid_pin(seed_helper_added_pin)
		|| manifest == old_framework_seal || jar == old_jar_pin || dex == old_dex_pin
		|| successor_native_seal == native_seal {
		return error('exact reviewed seed options framework/native and companion controller profile required')
	}
	for values in [framework_before(), framework_source_delta(), framework_canonical_delta()] {
		for path, pin in values { if !stage.relative(path) || !stage.valid_pin(pin) { return error('completed exact framework class pins required') } }
	}
}
fn exact_delta(before map[string]json2.Any, after map[string]json2.Any, changes map[string]json2.Any) ! {
	if before.len != after.len { return error('receipt key set changed') }
	for name, old in before {
		actual := after[name] or { return error('receipt key removed: ' + name) }
		if replacement := changes[name] {
			if actual != replacement || actual == old { return error('expected receipt change differs: ' + name) }
		} else if actual != old { return error('unrelated receipt change: ' + name) }
	}
	for name in changes.keys() { if name !in before { return error('replacement key absent') } }
}
fn changed_paths() []string {
	return [controller_path, alias_path, jar_path, dex_path, native_path, headless + '/framework-build.json', headless + '/framework-sha256.json', headless + '/guest-inputs.json']
}
fn payload_paths() []string {
	mut paths := changed_paths()
	paths << [vending_path, deployment_path]
	return paths
}
fn headless_inputs() map[string]string {
	return {
		'/opt/vinix-android-aarch64/usr/bin/run-android': '1b4d3e3d2dbc2eb5ae95343847218d4afd44d64aeb9d52cc0b07cb8f9c37b112'
		'/opt/vinix-android-aarch64/usr/bin/vinix-android-native': 'b1061601ebbcd5bc4c81c68d354704e58ff472a2bc9c8666fad6a588a614b98d'
		'/opt/vinix-android-aarch64/usr/lib/art/libvinix-android-native.so': '3ac3ec1a026a409ec52b7973d9dcc4593bd5d266fc2c6e77fc5d5c1a88e439d9'
		'/' + jar_path: old_jar_pin
		'/' + headless + '/bin/headless-service-controller': '70f23b12fb5a770587bfcebcf33ed1320fe050399f08bd256362a037f24eb0b6'
		'/' + headless + '/bin/headless-service-guest': 'd518cfc5145924479b5ad630aac2a3d3ef7dcea66f53515c03df03735e88ce05'
		'/' + headless + '/fixture.apk': '4df9e3cd757b463259c73dc038eb84d149d7ec1461a1889bc8f2d531f6980634'
	}
}
fn repin_headless(original map[string]json2.Any) !map[string]json2.Any {
	if original.len != 1 || json2.decode[map[string]string](json2.encode(original['inputs_sha256']!))! != headless_inputs() {
		return error('exact inherited seven-input headless contract differs')
	}
	mut updated := headless_inputs()
	updated['/' + jar_path] = jar_pin
	return {'inputs_sha256': as_json(updated)!}
}
fn replacement_pins(root string) !map[string]string {
	mut pins := map[string]string{}
	for path in changed_paths() { pins['/' + path] = stage.hash(root + '/' + path)! }
	return pins
}
// The fresh coupled build can reproduce the same native DSO byte for byte.
// Retain that file in the overlay, while declaring only actual input changes.
fn deployment_input_delta(replacements map[string]string) map[string]string {
	mut changes := replacements.clone()
	if successor_native_pin == native_pin { changes.delete('/' + native_path) }
	return changes
}
fn repin_deployment(original map[string]json2.Any, replacements map[string]string) !map[string]json2.Any {
	if stage.text_field(original, 'kind')! != 'vinix-maps-account-deployment-v1'
		|| stage.text_field(original, 'framework_manifest_sha256')! != old_framework_seal
		|| stage.text_field(original, 'native_manifest_sha256')! != native_seal
		|| stage.text_field(original, 'launch_manifest_sha256')! != launch_seal
		|| stage.text_field(original, 'browser_client_manifest_sha256')! != browser_seal {
		return error('retained deployment identity differs')
	}
	old := json2.decode[map[string]string](json2.encode(original['inputs_sha256']!))!
	if '/' + vending_path in old || 'vending_signer_sdk29_sha256' in original { return error('new protected Vending admission keys already exist') }
	if old['/' + controller_path] or { '' } != old_controller_pin
		|| old['/' + alias_path] or { '' } != old_controller_pin
		|| old['/' + broker_path] or { '' } != broker_pin
		|| old['/' + jar_path] or { '' } != old_jar_pin
		|| old['/' + dex_path] or { '' } != old_dex_pin
		|| old['/' + native_path] or { '' } != native_pin
		|| old['/' + headless + '/framework-build.json'] or { '' } != old_framework_build_pin
		|| old['/' + headless + '/framework-sha256.json'] or { '' } != old_framework_seal
		|| old['/' + headless + '/guest-inputs.json'] or { '' } != old_headless_pin { return error('retained framework/native or broker/controller aliases differ') }
	mut updated := old.clone()
	mut changes := map[string]json2.Any{}
	mut expected := changed_paths().map('/' + it)
	mut actual := replacements.keys()
	expected.sort(); actual.sort()
	if actual != expected || replacements['/' + controller_path]! != controller_pin || replacements['/' + alias_path]! != controller_pin
		|| replacements['/' + jar_path]! != jar_pin || replacements['/' + dex_path]! != dex_pin
		|| replacements['/' + native_path]! != successor_native_pin
		|| replacements['/' + headless + '/framework-build.json']! != framework_build_pin
		|| replacements['/' + headless + '/framework-sha256.json']! != framework_seal { return error('exact eight controller/framework/native replacements required') }
	for name, pin in deployment_input_delta(replacements) {
		if !stage.valid_pin(pin) { return error('invalid framework replacement pin') }
		updated[name] = pin
		changes[name] = json2.Any(pin)
	}
	exact_delta(as_json(old)!.as_map(), as_json(updated)!.as_map(), changes)!
	updated['/' + vending_path] = vending_pin
	mut result := original.clone()
	result['inputs_sha256'] = as_json(updated)!
	result['framework_manifest_sha256'] = json2.Any(framework_seal)
	result['native_manifest_sha256'] = json2.Any(successor_native_seal)
	result['vending_signer_sdk29_sha256'] = json2.Any(vending_signer)
	verify_deployment_delta(original, result, replacements)!
	return result
}
fn verify_deployment_delta(original map[string]json2.Any, updated map[string]json2.Any, replacements map[string]string) ! {
	old := json2.decode[map[string]string](json2.encode(original['inputs_sha256']!))!
	actual := updated['inputs_sha256'] or { return error('deployment pins removed') }
	mut input_replacements := json2.decode[map[string]string](json2.encode(actual))!
	if '/' + vending_path in old || input_replacements.len != old.len + 1 || input_replacements['/' + vending_path] or { '' } != vending_pin {
		return error('exact single new protected Vending input required')
	}
	input_replacements.delete('/' + vending_path)
	exact_delta(as_json(old)!.as_map(), as_json(input_replacements)!.as_map(), as_json(deployment_input_delta(replacements))!.as_map())!
	if 'vending_signer_sdk29_sha256' in original || updated.len != original.len + 1
		|| stage.text_field(updated, 'vending_signer_sdk29_sha256')! != vending_signer { return error('exact new verified Vending signer field required') }
	mut top_replacements := updated.clone()
	top_replacements.delete('vending_signer_sdk29_sha256')
	exact_delta(original, top_replacements, {'inputs_sha256': actual, 'framework_manifest_sha256': json2.Any(framework_seal), 'native_manifest_sha256': json2.Any(successor_native_seal)})!
}
fn exact_regular_names(names []string) ! {
	mut actual := names.clone()
	mut expected := payload_paths()
	actual.sort()
	expected.sort()
	if actual != expected { return error('ten-file payload allowlist differs') }
}
fn payload_inventory(root string) ![]stage.Entry {
	mut entries := []stage.Entry{}
	mut roots := os.ls(root)!
	roots.sort()
	if roots != ['opt', 'usr'] { return error('payload root set differs') }
	for prefix in roots { stage.inventory(root + '/' + prefix, '', prefix, mut entries)! }
	exact_regular_names(entries.filter(it.kind == 'regular').map(it.name))!
	for entry in entries {
		if entry.kind == 'regular' {
			if entry.name == vending_path && (entry.sha256 != vending_pin || entry.size != vending_size
				|| os.lstat(root + '/' + entry.name)!.nlink != 1) { return error('protected single-link Vending APK bytes differ') }
			if entry.name in [controller_path, alias_path] && entry.sha256 != controller_pin { return error('payload controller aliases differ') }
			if entry.name == jar_path && entry.sha256 != jar_pin { return error('payload JAR differs') }
			if entry.name == dex_path && entry.sha256 != dex_pin { return error('payload DEX differs') }
			if entry.name == headless + '/framework-build.json' && entry.sha256 != framework_build_pin { return error('payload framework build differs') }
			if entry.name == headless + '/framework-sha256.json' && entry.sha256 != framework_seal { return error('payload framework inventory differs') }
			mode := if entry.name in [controller_path, alias_path, native_path] { u32(0o755) } else { u32(0o644) }
			if entry.mode != mode { return error('payload file mode differs') }
			if entry.name == native_path && entry.sha256 != successor_native_pin { return error('payload native differs') }
			continue
		}
		allowed := payload_paths()
		if entry.kind != 'directory' || entry.mode != 0o755 || !allowed.any(it.starts_with(entry.name + '/')) {
			return error('unexpected payload inode or directory')
		}
	}
	return entries
}
// Existing first-inode mode wins across TARs; audit every later occurrence too.
fn inherited_modes(original []stage.Entry, planned []stage.Entry) !map[string]u32 {
	mut modes := map[string]u32{}
	for target in planned {
		if !stage.relative(target.name) || target.kind !in ['regular', 'directory'] || target.mode & 0o7022 != 0 {
			return error('unsafe diagnostic destination')
		}
		for old in original {
			if old.name == target.name {
				if target.name == vending_path { return error('new protected Vending destination already exists') }
				// Retain the established first executable DSO inode contract.
				legacy_native := target.name == native_path && target.mode == 0o755 && old.mode == 0o644
				if old.kind != target.kind || (old.mode != target.mode && !legacy_native) { return error('unsafe existing destination: ' + old.name) }
				if target.name !in modes {
					if old.mode & (target.mode & ~u32(0o222)) != target.mode & ~u32(0o222) { return error('insufficient original mode') }
					modes[target.name] = old.mode
				}
			} else if target.name.starts_with(old.name + '/') && (old.kind != 'directory' || old.mode & 0o7022 != 0) {
				return error('unsafe existing ancestor: ' + old.name)
			}
		}
		if target.name !in modes {
			if target.name != vending_path || target.kind != 'regular' || target.mode != 0o644
				|| target.sha256 != vending_pin || target.size != vending_size { return error('destination absent from original media: ' + target.name) }
			modes[target.name] = 0o644
		}
	}
	return modes
}
fn collect(root string, relative string, mut files map[string]string) ! {
	for name in os.ls(root + '/' + relative)! {
		path := if relative == '' { name } else { relative + '/' + name }
		match os.lstat(root + '/' + path)!.get_filetype() {
			.directory { collect(root, path, mut files)! }
			.regular { if path != 'sha256.json' { files[path] = stage.hash(root + '/' + path)! } }
			else { return error('unexpected sealed output inode') }
		}
	}
}
fn dependencies(base map[string]json2.Any) !map[string]string {
	all := json2.decode[map[string]string](json2.encode(base['inputs_sha256']!))!
	mut selected := map[string]string{}
	for path, pin in all {
		if path.ends_with('/sha256.json') { selected[path.all_before_last('/sha256.json')] = pin }
	}
	if selected.len != 65 || selected[old_controller_root] or { '' } != old_controller_seal
		|| selected[broker_root] or { '' } != broker_seal
		|| selected[startup_root] or { '' } != startup_seal
		|| selected[controller_stage_root] or { '' } != controller_stage_seal
		|| selected[old_framework_root] or { '' } != old_framework_seal
		|| selected[broker_framework_root] or { '' } != broker_framework_seal
		|| selected[native_root] or { '' } != native_seal {
		return error('exact inherited complete dependency set differs')
	}
	return selected
}
// The immediate predecessor controller is audited explicitly in both phases.
// Keep the full map for receipts/ancestry and only partition the worker plan.
fn paired_dependencies(full map[string]string) !map[string]string {
	if full.len != 65 || full[old_controller_root] or { '' } != old_controller_seal {
		return error('exact sixty-five dependency map and explicit controller required')
	}
	mut paired := full.clone()
	paired.delete(old_controller_root)
	if paired.len != 64 { return error('exact sixty-four paired dependencies required') }
	return paired
}
fn original_inodes(deps map[string]string) ![]stage.Entry {
	mut overlays := [][]stage.Entry{}
	mut seen := map[string]bool{}
	mut cursor := base_root
	for _ in 0 .. 32 {
		if cursor in seen || (cursor != base_root && cursor !in deps) { return error('unsealed or cyclic stage ancestry') }
		seen[cursor] = true
		value := read_json(cursor + '/stage.json')!
		overlays << json2.decode[[]stage.Entry](json2.encode(value['overlay_inventory']!))!
		original := cursor + '/original-module-inventory.json'
		if os.exists(original) {
			if os.lstat(original)!.size > 32 * 1024 * 1024 { return error('original inode inventory exceeds bound') }
			mut entries := json2.decode[[]stage.Entry](os.read_file(original)!)!
			for i := overlays.len - 1; i >= 0; i-- { entries << overlays[i] }
			return entries
		}
		cursor = stage.text_field(value, 'base_root')!
	}
	return error('stage ancestry exceeds bound')
}
fn consumed_raw_delta() map[string][]string {
	// All native-consumed inputs are already canonical in the predecessor.
	return map[string][]string{}
}
fn consumed_canonical_delta() map[string][]string {
	return map[string][]string{}
}
fn framework_before() map[string]string {
	return {'android/os/UserManager.smali': '43fc0708d9b6ad855e422357f91f806f96507700e49bb29c435dc1c625040697',
		'android/os/PersistableBundle.smali': '1cf3e8ec45a01e80ab18f743c4717bea5cbeb2471c10cc0b815a532930851973',
		'android/util/ArrayMap.smali': '76ce8ad3e3ecdc7d59bd0ed2eb8eab883c4d1ca8cd54b6f852012e60fb2b0f45'}
}
fn framework_source_delta() map[string]string {
	return {'smali/android/os/UserManager.smali': '4776812c501390042ac576ddb4079ca06cc62d8ecec7f6a9fb96f76ea17124ee',
		'smali/android/os/PersistableBundle.smali': '55255c1d6f16d32fb0ee6a845705a9c20545dc493f3c1f2b7b664f0d1886c0c3',
		'smali/android/util/ArrayMap.smali': '2651cc826e9fef60d74bae5e80ac203b953e0835c215846a25a682f87870e713'}
}
fn framework_canonical_delta() map[string]string {
	return {'new-dex/android/os/UserManager.smali': '87747ad9ac9a8da5693ca362251e2b4d18d3f87987a4350ec66daee6e818961a',
		'new-dex/android/os/PersistableBundle.smali': '073f3fc7e9c5b9b32bbec871c96af6e75f1554b395543469f0e5f7d630d79c3f',
		'new-dex/android/util/ArrayMap.smali': '7d674b45674cebc3b6d27a80dd5061fa5b888b2617b4ec48c5f18458638c26f1'}
}
fn added_classes() []string { return []string{} }
fn framework_method_changes() map[string]int {
	return {'android/os/UserManager.smali': 0, 'android/os/PersistableBundle.smali': 0, 'android/util/ArrayMap.smali': 1}
}
fn framework_method_additions() map[string]int {
	return {'android/os/UserManager.smali': 1, 'android/os/PersistableBundle.smali': 1, 'android/util/ArrayMap.smali': 0}
}
fn framework_field_additions() map[string][]string {
	return {'android/os/PersistableBundle.smali': ['.field public static final EMPTY:Landroid/os/PersistableBundle;']}
}
fn canonical_classes(bundle stage.Bundle, count int) !map[string]string {
	mut classes := map[string]string{}
	for path, pin in bundle.files {
		if path.starts_with('new-dex/') {
			name := path.all_after('new-dex/')
			if !stage.relative(name) || !name.ends_with('.smali') { return error('canonical class member differs') }
			classes[name] = pin
		}
	}
	if classes.len != count || count != 2105 { return error('complete bounded canonical framework class membership required') }
	return classes
}
fn exact_canonical_delta(before map[string]string, after map[string]string) ! {
	mut names := before.keys()
	names << added_classes()
	names.sort()
	if before.len != 2105 || after.len != 2105 || after.keys().sorted() != names { return error('complete 2105-class canonical membership differs') }
	delta := framework_canonical_delta()
	selected := framework_before()
	for path, pin in selected {
		if before[path] or { '' } != pin { return error('exact selected canonical predecessor required: ' + path) }
	}
	for path, pin in before {
		if old := selected[path] {
			if pin != old || after[path]! != delta['new-dex/' + path]! || pin == after[path]! { return error('exact platform canonical delta required: ' + path) }
		} else if after[path]! != pin { return error('unreviewed canonical framework class change: ' + path) }
	}
	for name in added_classes() {
		if name in before || after[name]! != delta['new-dex/' + name]! { return error('exact added canonical helper required') }
	}
}
fn exact_consumed_canonical(consumed map[string]string, before map[string]string, after map[string]string) ! {
	if consumed.len != 68 || 'smali/android/widget/ImageView.smali' !in consumed
		|| 'smali/android/os/UserManager.smali' in consumed || 'smali/android/os/PersistableBundle.smali' in consumed
		|| 'smali/android/util/ArrayMap.smali' in consumed { return error('exact 68-class consumed membership required') }
	for path in consumed.keys() {
		if !path.starts_with('smali/') || !path.ends_with('.smali') || !stage.relative(path) { return error('malformed consumed class path') }
		name := path.all_after('smali/')
		old := before[name] or { return error('native consumed canonical predecessor absent: ' + path) }
		new := after[name] or { return error('native consumed canonical successor absent: ' + path) }
		if expected := consumed_canonical_delta()[name] {
			if expected.len != 2 || old != expected[0] || new != expected[1] || old == new { return error('exact consumed canonical delta differs') }
		} else if new != old { return error('unreviewed consumed canonical class change: ' + path) }
	}
}
// Verify both complete DEX trees and retained native inputs. All 68 consumed
// classes remain canonically equal; formatting differences remain explicit.
fn exact_compatibility(previous stage.Bundle, successor stage.Bundle, native stage.Bundle) !map[string][]string {
	if previous.files['api-impl.jar']! != old_jar_pin || previous.files['classes.dex']! != old_dex_pin
		|| successor.files['api-impl.jar']! != jar_pin || successor.files['classes.dex']! != dex_pin
		|| successor.files['build.json']! != framework_build_pin
		|| stage.text_field(successor.receipt, 'profile')! != 'seed-account-options-2105'
		|| stage.text_field(successor.receipt, 'baseline_manifest_sha256')! != old_framework_seal
		|| stage.text_field(successor.receipt, 'baseline_api_impl_sha256')! != old_jar_pin {
		return error('exact seed account options successor profile differs')
	}
	stage.verify_native(native, previous)!
	if native.files['native/libvinix-android-native.so']! != native_pin || native.files['build.json']! != native_build_pin
		|| native.files['native/atlframework/ws_generated.v']! != generated_pin { return error('retained native producer differs') }
	if previous.files['framework-dex-after.json']! != successor.files['framework-dex-before.json']! { return error('canonical post-DEX/pre-DEX inventory differs') }
	before := canonical_classes(previous, 2105)!
	after := canonical_classes(successor, 2105)!
	if json2.decode[map[string]string](os.read_file(previous.root + '/framework-dex-after.json')!)! != before
		|| json2.decode[map[string]string](os.read_file(successor.root + '/framework-dex-after.json')!)! != after {
		return error('canonical inventory differs from complete retained class tree')
	}
	exact_canonical_delta(before, after)!
	mut expected_raw := map[string]string{}
	for name, pin in before { expected_raw['smali/' + name] = pin }
	for name, pin in framework_source_delta() { expected_raw[name] = pin }
	mut actual_raw := map[string]string{}
	for name, pin in successor.files { if name.starts_with('smali/') { actual_raw[name] = pin } }
	if actual_raw != expected_raw { return error('complete canonical-clone raw source tree differs beyond UserManager seed options') }
	for key, value in {'class_count': as_json(2105)!, 'changed_classes': as_json(framework_before().keys().sorted())!,
		'added_classes': as_json(added_classes())!, 'added_fields': as_json(framework_field_additions())!,
		'changed_method_counts': as_json(framework_method_changes())!, 'added_method_counts': as_json(framework_method_additions())!} {
		if successor.receipt[key] or { json2.Any('absent') } != value { return error('exact platform method/field delta receipt differs: ' + key) }
	}
	consumed := json2.decode[map[string]string](os.read_file(native.root + '/framework/consumed-smali.json')!)!
	if consumed.len != 68 || 'smali/android/widget/ImageView.smali' !in consumed
		|| 'smali/android/os/UserManager.smali' in consumed || 'smali/android/os/PersistableBundle.smali' in consumed
		|| 'smali/android/util/ArrayMap.smali' in consumed
		|| native.files.keys().filter(it.starts_with('framework/smali/')).sorted() != consumed.keys().map('framework/' + it).sorted() {
		return error('complete retained 68-class native consumed membership differs')
	}
	exact_consumed_canonical(consumed, before, after)!
	mut raw_delta := map[string][]string{}
	for path, pin in consumed {
		if !path.starts_with('smali/') || !path.ends_with('.smali') || !stage.relative(path)
			|| native.files['framework/' + path] or { '' } != pin || previous.files[path] or { '' } != pin {
			return error('retained native raw input differs from its exact WindowManager framework')
		}
		successor_raw := successor.files[path] or { return error('successor raw class absent') }
		if successor_raw != pin { raw_delta[path] = [pin, successor_raw] }
	}
	if raw_delta != consumed_raw_delta() { return error('unreviewed successor consumed raw formatting delta') }
	return raw_delta
}
fn normalized_source_origin(root string, origin string) !string {
	if os.norm_path(origin) != origin || origin.contains_any('\\\x00\n') { return error('malformed retained helper origin') }
	if origin.starts_with(root + '/compiler-root/') { return '@compiler/' + origin.all_after(root + '/compiler-root/') }
	if origin.starts_with(os.getwd() + '/') { return origin }
	return error('helper origin outside retained compiler and repository')
}
fn native_source_closure(bundle stage.Bundle, label string) !map[string]string {
	closure := json2.decode[map[string]string](json2.encode(read_json(bundle.root + '/' + label + '-closure.json')!))!
	if closure.len == 0 || closure.len > 2048 { return error('bounded nonempty native helper closure required') }
	mut normalized := map[string]string{}
	mut names := []string{}
	for origin, pin in closure {
		key := normalized_source_origin(bundle.root, origin)!
		path := 'closure/' + label + '/' + origin.trim_left('/')
		if key in normalized || !stage.valid_pin(pin) || bundle.files[path] or { '' } != pin { return error('native helper closure member differs') }
		normalized[key] = pin
		names << path
	}
	names.sort()
	if bundle.files.keys().filter(it.starts_with('closure/' + label + '/')).sorted() != names { return error('complete native helper source membership differs') }
	return normalized
}
fn exact_helper_delta(label string, before map[string]string, after map[string]string) ! {
	mut expected := before.clone()
	if label == 'builder' {
		framework := os.getwd() + '/tests/native-android-tools/androidtools/framework.v'
		seed := os.getwd() + '/tests/native-android-tools/androidtools/framework_seed_account_options.v'
		if before[framework] or { '' } != framework_helper_before_pin || seed in before
			|| !stage.valid_pin(framework_helper_after_pin) || !stage.valid_pin(seed_helper_added_pin) {
			return error('exact reviewed seed options registration/provider helper delta required')
		}
		expected[framework] = framework_helper_after_pin
		expected[seed] = seed_helper_added_pin
	} else if label != 'native-generator' { return error('unknown native helper closure') }
	if after != expected { return error('unreviewed complete native helper closure change: ' + label) }
}
fn exact_native_sources(previous stage.Bundle, successor stage.Bundle, framework stage.Bundle) ! {
	stage.verify_native(successor, framework)!
	if successor.files['native/libvinix-android-native.so']! != successor_native_pin
		|| successor.files['build.json']! != successor_native_build_pin { return error('exact seed options-coupled native producer differs') }
	origins := json2.decode[map[string]string](os.read_file(previous.root + '/native/source-origins.json')!)!
	new_origins := json2.decode[map[string]string](os.read_file(successor.root + '/native/source-origins.json')!)!
	if origins.len != 88 || new_origins != origins { return error('exact retained eighty-eight native origins required') }
	mut old_inputs := map[string]string{}
	mut new_inputs := map[string]string{}
	mut names := ['native/atlframework/ws_generated.v']
	for name, origin in origins {
		if !name.ends_with('.v') || os.file_name(origin) != name || os.dir(origin) !in [os.getwd() + '/build-support/android/atlframework', os.getwd() + '/build-support/android/nativews'] {
			return error('invalid retained native production source origin')
		}
		path := 'native/atlframework/' + name
		before := previous.files[path]!
		after := successor.files[path]!
		if before != after { return error('unreviewed native production source change: ' + name) }
		old_inputs[origin] = before
		new_inputs[origin] = after
		names << path
	}
	names.sort()
	if previous.files.keys().filter(it.starts_with('native/atlframework/')).sorted() != names
		|| successor.files.keys().filter(it.starts_with('native/atlframework/')).sorted() != names { return error('complete retained native source membership differs') }
	for path, pin in {'native/bindings.txt': bindings_pin, 'native/atlframework/ws_generated.v': generated_pin, 'builder-source.v': builder_pin,
		'native/atlframework/headless.v': headless_source_pin} {
		if previous.files[path]! != pin || successor.files[path]! != pin { return error('retained bindings/JNI/builder differs: ' + path) }
	}
	for path in ['native/exports.json', 'tools/find-v.sh',
		'closure/builder/' + os.getwd().trim_left('/') + '/tests/native-android-tools/androidtools/native_ws.v',
		'closure/native-generator/' + os.getwd().trim_left('/') + '/tests/linuxkpi/generate_module.v'] {
		if successor.files[path]! != previous.files[path]! { return error('retained native helper or export set differs: ' + path) }
	}
	for label in ['builder', 'native-generator'] { exact_helper_delta(label, native_source_closure(previous, label)!, native_source_closure(successor, label)!)! }
	spec := os.getwd() + '/build-support/android/nativews/bindings.txt'
	old_inputs[spec] = bindings_pin
	new_inputs[spec] = bindings_pin
	if json2.decode[map[string]string](os.read_file(previous.root + '/native/current-inputs.json')!)! != old_inputs
		|| json2.decode[map[string]string](os.read_file(successor.root + '/native/current-inputs.json')!)! != new_inputs
		|| old_inputs != new_inputs { return error('unchanged complete native input map required') }
	consumed_before := json2.decode[map[string]string](os.read_file(previous.root + '/framework/consumed-smali.json')!)!
	consumed_after := json2.decode[map[string]string](os.read_file(successor.root + '/framework/consumed-smali.json')!)!
	mut expected := consumed_before.clone()
	for path, pins in consumed_raw_delta() {
		if expected[path] or { '' } != pins[0] { return error('native consumed raw predecessor differs') }
		expected[path] = pins[1]
	}
	if consumed_after != expected || consumed_after.len != 68
		|| successor.files.keys().filter(it.starts_with('framework/smali/')).sorted() != consumed_after.keys().map('framework/' + it).sorted() { return error('complete successor native consumed source membership differs') }
	for path, pin in consumed_after {
		if successor.files['framework/' + path] or { '' } != pin || framework.files[path] or { '' } != pin { return error('successor native raw input differs from its exact seed options framework') }
	}
}
fn audit_framework_inputs() ! {
	exact_profile(base_seal, framework_seal, jar_pin, dex_pin)!
	previous := stage.load_bundle(old_framework_root, old_framework_seal)!
	successor := stage.load_bundle(framework_root, framework_seal)!
	native := stage.load_bundle(native_root, native_seal)!
	raw := exact_compatibility(previous, successor, native)!
	new_native := stage.load_bundle(successor_native_root, successor_native_seal)!
	exact_native_sources(native, new_native, successor)!
	println('MAPS-SEED-ACCOUNT-COMPANION-AUDIT PASS unchanged native sources JNI/bindings 2105 canonical classes 68 consumed equalities raw_differences=' + raw.len.str())
}
fn audit_controller_inputs() ! {
	exact_profile(base_seal, framework_seal, jar_pin, dex_pin)!
	previous := stage.load_bundle(old_controller_root, old_controller_seal)!
	successor := stage.load_bundle(controller_root, controller_seal)!
	for bundle in [previous, successor] { stage.verify_static_controller(bundle, 'vinix-maps-account-guest-build-v1', 'maps-account-guest')! }
	if previous.files['bin/maps-account-guest']! != old_controller_pin || successor.files['bin/maps-account-guest']! != controller_pin {
		return error('exact old and companion controller executables required')
	}
	stage.recheck(previous)!
	stage.recheck(successor)!
	println('MAPS-SEED-ACCOUNT-COMPANION-CONTROLLER PASS complete static ARM controller producer inventories')
}
fn verify_vending_admission(bundle stage.Bundle) ! {
	for name, value in {'kind': 'vinix-maps-vending-admission-v1', 'source_base_root': base_root,
		'source_base_manifest_sha256': base_seal, 'source_image_sha256': base_boot_pin,
		'source_module': 'qemu-runtime.tar', 'source_module_sha256': vending_module_pin, 'source_member': vending_member,
		'apk_sha256': vending_pin, 'package_name': 'com.android.vending', 'version_code': '85292100',
		'version_name': '52.9.21-24 [0] [PR] 968642861', 'min_sdk': '24', 'target_sdk': '37', 'split_name': '',
		'signer_sdk29_sha256': vending_signer} {
		if stage.text_field(bundle.receipt, name)! != value { return error('exact protected Vending admission differs: ' + name) }
	}
	for name, value in {'format': as_json(1)!, 'apk_size': as_json(vending_size)!, 'split_required': as_json(false)!,
		'signer_min_sdk_version': as_json(29)!, 'signer_max_sdk_version': as_json(29)!,
		'outputs_sha256': as_json({'vending.apk': vending_pin})!} {
		if bundle.receipt[name] or { json2.Any('absent') } != value { return error('exact Vending admission metadata differs: ' + name) }
	}
	abis := json2.decode[[]string](json2.encode(bundle.receipt['native_abis']!))!
	if abis.sorted() != ['arm64-v8a', 'armeabi-v7a', 'x86', 'x86_64'] { return error('exact actual Vending native ABI metadata required') }
	for name in ['input_sha256', 'tool_sha256'] {
		pins := json2.decode[map[string]string](json2.encode(bundle.receipt[name]!))!
		if pins.len == 0 || pins.len > 2048 || pins.values().any(!stage.valid_pin(it)) { return error('complete retained Vending source/tool pins required') }
	}
	for name in ['producer_source_sha256', 'producer_sha256'] { if !stage.valid_pin(stage.text_field(bundle.receipt, name)!) { return error('retained Vending producer identity required') } }
	logs := json2.decode[map[string]string](json2.encode(bundle.receipt['metadata_logs_sha256']!))!
	if logs.keys().sorted() != ['commands/badging.log', 'commands/manifest.log', 'commands/sdk29.log'] { return error('exact retained Vending metadata logs required') }
	for name, pin in logs { if !stage.valid_pin(pin) || bundle.files[name] or { '' } != pin { return error('retained Vending metadata log differs') } }
	info := os.lstat(bundle.root + '/vending.apk')!
	if bundle.files['vending.apk'] or { '' } != vending_pin || info.get_filetype() != .regular || info.nlink != 1
		|| info.size != vending_size { return error('admitted single-link Vending APK bytes differ') }
}
fn audit_vending_inputs() ! {
	exact_profile(base_seal, framework_seal, jar_pin, dex_pin)!
	bundle := stage.load_bundle(vending_root, vending_seal)!
	verify_vending_admission(bundle)!
	stage.recheck(bundle)!
	println('MAPS-SEED-ACCOUNT-COMPANION-VENDING PASS pinned original module member metadata and exact SDK29 signer')
}
fn enumerate_native_helpers() ! {
	if !stage.valid_pin(successor_native_seal) { return error('completed native producer required') }
	previous := stage.load_bundle(native_root, native_seal)!
	successor := stage.load_bundle(successor_native_root, successor_native_seal)!
	for label in ['builder', 'native-generator'] {
		before := native_source_closure(previous, label)!
		after := native_source_closure(successor, label)!
		mut names := before.keys()
		for name in after.keys() { if name !in names { names << name } }
		names.sort()
		for name in names {
			old := before[name] or { 'ADDED' }
			new := after[name] or { 'REMOVED' }
			if old != new { println(label + ' ' + name + ' ' + old + ' -> ' + new) }
		}
	}
}
fn run(destination string) ! {
	exact_profile(base_seal, framework_seal, jar_pin, dex_pin)!
	root := stage.external(destination)!
	stage.disjoint(root, [base_root, old_controller_root, controller_root, broker_root, framework_root, successor_native_root, vending_root, os.getwd()])!
	disk_start := disk_available(os.dir(root))!
	if disk_start < disk_reserve + disk_growth { return error('preparation requires 1.5 GiB initial free space') }
	mut disk := DiskBudget{available: disk_start}
	mut disk_samples := {'preflight': disk_start}
	println('MAPS-SEED-ACCOUNT-COMPANION auditing immutable inputs')
	base_files := stage.load_inventory(base_root, base_seal)!
	base := read_json(base_root + '/stage.json')!
	if stage.text_field(base, 'kind')! != 'vinix-maps-broker-tail-v1'
		|| stage.text_field(base, 'base_root')! != state_root + '/maps-window-system-ui-r1'
		|| stage.text_field(base, 'base_manifest_sha256')! != '14f92ed74d29a14a27d0c829c2f84d7695a697c730811d594b010b906c7be1f1'
		|| stage.text_field(base, 'controller_build_root')! != old_controller_root
		|| stage.text_field(base, 'controller_manifest_sha256')! != old_controller_seal
		|| stage.text_field(base, 'controller_sha256')! != old_controller_pin
		|| stage.text_field(base, 'broker_build_root')! != broker_root
		|| stage.text_field(base, 'broker_manifest_sha256')! != broker_seal
		|| stage.text_field(base, 'broker_sha256')! != broker_pin
		|| stage.text_field(base, 'retained_broker_manifest_sha256')! != retained_broker_seal
		|| stage.text_field(base, 'framework_manifest_sha256')! != old_framework_seal
		|| stage.text_field(base, 'native_manifest_sha256')! != native_seal
		|| stage.text_field(base, 'native_sha256')! != native_pin
		|| stage.text_field(base, 'native_build_root')! != native_root
		|| stage.text_field(base, 'native_build_sha256')! != native_build_pin
		|| stage.text_field(base, 'generated_jni_sha256')! != generated_pin
		|| stage.text_field(base, 'browser_client_manifest_sha256')! != browser_seal
		|| stage.text_field(base, 'browser_client_sha256')! != browser_pin
		|| stage.text_field(base, 'retained_launch_manifest_sha256')! != launch_seal {
		return error('exact immutable broker tail stage differs')
	}
	if base_files['payload/' + deployment_path]! != old_deployment_pin { return error('retained deployment receipt differs') }
	mut inputs := map[string]string{}
	inputs[base_root + '/sha256.json'] = base_seal
	deps := dependencies(base)!
	stage.disjoint(root, deps.keys())!
	paired := paired_dependencies(deps)!
	old_controller := stage.load_bundle(old_controller_root, old_controller_seal)!
	stage.verify_static_controller(old_controller, 'vinix-maps-account-guest-build-v1', 'maps-account-guest')!
	if old_controller.files['bin/maps-account-guest']! != old_controller_pin { return error('retained controller differs') }
	stage.audit_inventories_parallel(paired)!
	for path, pin in deps {
		inputs[path + '/sha256.json'] = pin
	}
	controller := stage.load_bundle(controller_root, controller_seal)!
	stage.verify_static_controller(controller, 'vinix-maps-account-guest-build-v1', 'maps-account-guest')!
	if controller.files['bin/maps-account-guest']! != controller_pin { return error('new companion controller differs') }
	inputs[controller_root + '/sha256.json'] = controller_seal
	old_framework := stage.load_bundle(old_framework_root, old_framework_seal)!
	framework := stage.load_bundle(framework_root, framework_seal)!
	native := stage.load_bundle(native_root, native_seal)!
	raw_delta := exact_compatibility(old_framework, framework, native)!
	new_native := stage.load_bundle(successor_native_root, successor_native_seal)!
	exact_native_sources(native, new_native, framework)!
	inputs[framework_root + '/sha256.json'] = framework_seal
	inputs[successor_native_root + '/sha256.json'] = successor_native_seal
	vending := stage.load_bundle(vending_root, vending_seal)!
	verify_vending_admission(vending)!
	inputs[vending_root + '/sha256.json'] = vending_seal
	broker_framework := stage.load_bundle(broker_framework_root, broker_framework_seal)!
	broker := stage.load_bundle(broker_root, broker_seal)!
	stage.verify_account_broker(broker, broker_framework)!
	if broker.files['bin/native-account-broker']! != broker_pin { return error('retained current broker differs') }
	inputs[broker_root + '/sha256.json'] = broker_seal
	if inputs.keys().filter(it.ends_with('/sha256.json')).len != 70 { return error('exact seventy complete dependency seals required') }
	check_disk(root, 'inputs-audited', false, mut disk, mut disk_samples)!
	os.mkdir(root, mode: 0o755)!
	os.mkdir(root + '/commands', mode: 0o755)!
	for path, source in retained {
		copy_path := root + '/source/' + path
		os.mkdir_all(os.dir(copy_path), mode: 0o755)!
		os.write_file(copy_path, source)!
		if os.read_file(os.getwd() + '/' + path)! != source { return error('compiled source differs from checkout: ' + path) }
		inputs[os.getwd() + '/' + path] = sha256.sum(source.bytes()).hex()
	}
	inputs[os.real_path(os.executable())] = stage.hash(os.real_path(os.executable()))!
	inputs['/usr/bin/git'] = stage.hash('/usr/bin/git')!
	for path in ['/usr/bin/env', '/bin/df'] { inputs[path] = stage.hash(path)! }
	revision := stage.command(root, 'source-revision', ['/usr/bin/git', 'rev-parse', 'HEAD'])!.trim_space()
	if revision.len != 40 { return error('full source revision required') }
	os.mkdir(root + '/tools', mode: 0o755)!
	for name in ['mcopy', 'mtype', 'mdir', 'shasum'] {
		source := os.real_path(os.find_abs_path_of_executable(name)!)
		inputs[source] = stage.hash(source)!
		copy_file(source, root + '/tools/' + name, 0o755)!
		inputs[root + '/tools/' + name] = inputs[source]!
	}
	os.setenv('PATH', root + '/tools:' + os.getenv('PATH'), true)
	check_disk(root, 'retained-source-tools', true, mut disk, mut disk_samples)!
	original := os.read_file(base_root + '/limine-after.conf')!
	config := stage.configure(original, overlay)!
	mut before := json2.decode[map[string]string](json2.encode(base['preserved_modules_sha256']!))!
	before['maps-broker-tail.tar'] = stage.text_field(base, 'overlay_sha256')!
	if config.modules != ['initramfs.tar', 'qemu-runtime.tar', 'maps335-diagnostics.tar', 'maps350-diagnostics.tar',
		'maps372-diagnostics.tar', 'headless-service.tar', 'maps-account.tar', 'protected-storage-diagnostic.tar',
		'maps-controller-diagnostic.tar', 'maps-service-query-diagnostic.tar', 'maps-controller-memory-diagnostic.tar',
		'maps-direct-boot-diagnostic.tar', 'maps-context-storage-diagnostic.tar', 'maps-broadcast-result-diagnostic.tar',
		'maps-onboarding-trace-diagnostic.tar', 'maps-native-onboarding-trace-diagnostic.tar',
		'maps-onboarding-framework-diagnostic.tar', 'maps-native-heartbeat-diagnostic.tar',
		'maps-browser-poll.tar', 'maps-account-pump.tar', 'maps-application-restrictions.tar', 'maps-account-handoff.tar',
		'maps-auth-exception.tar', 'maps-auth-worker.tar', 'maps-binder-identity.tar', 'maps-service-lifecycle.tar',
		'maps-platform-fragments.tar', 'maps-imageview-bounds.tar', 'maps-window-system-ui.tar', 'maps-broker-tail.tar']
		|| before.len != config.modules.len { return error('exact original thirty-module set differs') }
	if stage.command(root, 'original-limine', [root + '/tools/mtype', '-i', base_root + '/boot.img', '::/boot/limine.conf'])! != original {
		return error('source media configuration differs')
	}
	check_disk(root, 'original-limine', true, mut disk, mut disk_samples)!
	audit_modules(root, 'original', base_root + '/boot.img', config.modules, before, mut disk, mut disk_samples)!
	original_entries := original_inodes(deps)!
	for path in [controller_path, alias_path] { copy_file(controller_root + '/bin/maps-account-guest', root + '/payload/' + path, 0o755)! }
	copy_file(vending_root + '/vending.apk', root + '/payload/' + vending_path, 0o644)!
	copy_file(framework_root + '/api-impl.jar', root + '/payload/' + jar_path, 0o644)!
	copy_file(framework_root + '/classes.dex', root + '/payload/' + dex_path, 0o644)!
	copy_file(successor_native_root + '/native/libvinix-android-native.so', root + '/payload/' + native_path, 0o755)!
	copy_file(framework_root + '/build.json', root + '/payload/' + headless + '/framework-build.json', 0o644)!
	copy_file(framework_root + '/sha256.json', root + '/payload/' + headless + '/framework-sha256.json', 0o644)!
	if stage.hash(headless_base + headless + '/guest-inputs.json')! != old_headless_pin { return error('retained headless input identity differs') }
	old_headless := read_json(headless_base + headless + '/guest-inputs.json')!
	new_headless := repin_headless(old_headless)!
	write_json(root + '/payload/' + headless + '/guest-inputs.json', as_json(new_headless)!)!
	replacements := replacement_pins(root + '/payload')!
	old_deployment := read_json(base_root + '/payload/' + deployment_path)!
	write_json(root + '/payload/' + deployment_path, as_json(repin_deployment(old_deployment, replacements)!)!)!
	entries_before := payload_inventory(root + '/payload')!
	modes := inherited_modes(original_entries, entries_before)!
	for entry in entries_before { os.chmod(root + '/payload/' + entry.name, int(modes[entry.name]!))! }
	entries := payload_inventory(root + '/payload')!
	write_json(root + '/overlay-plan.json', as_json(entries)!)!
	write_json(root + '/original-inode-modes.json', as_json(modes)!)!
	os.write_file(root + '/limine-before.conf', original)!
	os.write_file(root + '/limine-after.conf', config.updated)!
	check_disk(root, 'payload', true, mut disk, mut disk_samples)!
	println('MAPS-SEED-ACCOUNT-COMPANION cloning media and appending ten files')
	for name in ['boot.img', 'efivars.fd'] {
		if C.clonefile((base_root + '/' + name).str, (root + '/' + name).str, 0) != 0 { return error('fresh APFS clone failed') }
		check_disk(root, 'clone-' + name + '-created', true, mut disk, mut disk_samples)!
		if stage.hash(root + '/' + name)! != base_files[name]! { return error('fresh APFS media clone differs') }
		check_disk(root, 'clone-' + name + '-verified', false, mut disk, mut disk_samples)!
	}
	stage.command_expected(root, 'overlay-absent', [root + '/tools/mdir', '-i', root + '/boot.img', '::/boot/' + overlay], 1)!
	mut sources := map[string]string{}
	for entry in entries.filter(it.kind == 'regular') { sources[entry.name] = root + '/payload/' + entry.name }
	stage.write_overlay(root + '/' + overlay, sources, entries)!
	stage.verify_overlay(root + '/' + overlay, entries)!
	check_disk(root, 'overlay', true, mut disk, mut disk_samples)!
	stage.command(root, 'install-overlay', [root + '/tools/mcopy', '-i', root + '/boot.img', root + '/' + overlay, '::/boot/' + overlay])!
	check_disk(root, 'install-overlay', true, mut disk, mut disk_samples)!
	stage.command(root, 'install-limine', [root + '/tools/mcopy', '-o', '-i', root + '/boot.img', root + '/limine-after.conf', '::/boot/limine.conf'])!
	check_disk(root, 'install-limine', true, mut disk, mut disk_samples)!
	if stage.command(root, 'readback-limine', [root + '/tools/mtype', '-i', root + '/boot.img', '::/boot/limine.conf'])! != config.updated { return error('diagnostic media configuration differs') }
	check_disk(root, 'readback-limine', true, mut disk, mut disk_samples)!
	mut media_pins := before.clone()
	media_pins[overlay] = stage.hash(root + '/' + overlay)!
	mut final_modules := config.modules.clone()
	final_modules << overlay
	mut after := audit_modules(root, 'readback', root + '/boot.img', final_modules, media_pins, mut disk, mut disk_samples)!
	after.delete(overlay)
	println('MAPS-SEED-ACCOUNT-COMPANION rechecking complete inputs')
	stage.audit_inventories_parallel(paired)!
	stage.recheck(old_controller)!
	stage.recheck(vending)!
	stage.recheck(controller)!
	stage.recheck(broker)!
	stage.recheck(framework)!
	stage.recheck(old_framework)!
	stage.recheck(native)!
	stage.recheck(new_native)!
	stage.recheck(broker_framework)!
	if stage.load_inventory(base_root, base_seal)! != base_files { return error('immutable broker tail stage changed') }
	for path, pin in inputs { if stage.hash(path)! != pin { return error('source/tool changed: ' + path) } }
	if payload_inventory(root + '/payload')! != entries { return error('payload changed') }
	verify_deployment_delta(old_deployment, read_json(root + '/payload/' + deployment_path)!, replacements)!
	if read_json(root + '/payload/' + headless + '/guest-inputs.json')! != repin_headless(old_headless)! { return error('headless input delta changed') }
	check_disk(root, 'complete-recheck', false, mut disk, mut disk_samples)!
	write_json(root + '/stage.json', {
		'kind': json2.Any('vinix-maps-seed-account-companion-v1'), 'format': json2.Any(1),
		'scope': json2.Any('Maps receives the two pinned Google companions GMS and Vending; absent seed options use the immutable empty PersistableBundle fallback. All 68 native-consumed classes, native sources, bindings and generated JNI remain unchanged. No Google login proof.'),
		'source_revision': json2.Any(revision), 'base_root': json2.Any(base_root), 'base_manifest_sha256': json2.Any(base_seal),
		'controller_build_root': json2.Any(controller_root), 'controller_manifest_sha256': json2.Any(controller_seal),
		'controller_sha256': json2.Any(controller_pin), 'retained_controller_manifest_sha256': json2.Any(old_controller_seal),
		'broker_build_root': json2.Any(broker_root), 'broker_manifest_sha256': json2.Any(broker_seal), 'broker_sha256': json2.Any(broker_pin),
		'retained_broker_manifest_sha256': json2.Any(retained_broker_seal),
		'vending_build_root': json2.Any(vending_root), 'vending_manifest_sha256': json2.Any(vending_seal),
		'vending_sha256': json2.Any(vending_pin), 'vending_size_bytes': as_json(vending_size)!,
		'vending_signer_sdk29_sha256': json2.Any(vending_signer), 'vending_source_base_manifest_sha256': json2.Any(base_seal),
		'vending_source_module_sha256': json2.Any(vending_module_pin), 'vending_source_member': json2.Any(vending_member),
		'framework_build_root': json2.Any(framework_root),
		'retained_framework_manifest_sha256': json2.Any(old_framework_seal),
		'framework_jar_sha256': json2.Any(jar_pin), 'framework_dex_sha256': json2.Any(dex_pin),
		'native_build_root': json2.Any(successor_native_root), 'native_build_sha256': json2.Any(successor_native_build_pin), 'native_sha256': json2.Any(successor_native_pin),
		'retained_native_manifest_sha256': json2.Any(native_seal), 'generated_jni_sha256': json2.Any(generated_pin),
		'native_framework_manifest_sha256': json2.Any(framework_seal),
		'native_source_delta': as_json(map[string]string{})!,
		'native_builder_helper_delta': as_json({'tests/native-android-tools/androidtools/framework.v': framework_helper_after_pin,
			'tests/native-android-tools/androidtools/framework_seed_account_options.v': seed_helper_added_pin})!,
		'native_compatibility_framework_manifest_sha256': json2.Any(old_framework_seal),
		'native_consumed_class_count': as_json(68)!, 'native_consumed_raw_delta': as_json(raw_delta)!,
		'native_consumed_canonical_delta': as_json(consumed_canonical_delta())!,
		'framework_class_count': as_json(2105)!,
		'framework_source_delta': as_json(framework_source_delta())!,
		'framework_canonical_delta': as_json(framework_canonical_delta())!,
		'browser_client_build_root': base['browser_client_build_root']!, 'browser_client_manifest_sha256': json2.Any(browser_seal), 'browser_client_sha256': json2.Any(browser_pin),
		'framework_manifest_sha256': json2.Any(framework_seal), 'native_manifest_sha256': json2.Any(successor_native_seal),
		'retained_launch_manifest_sha256': json2.Any(launch_seal),
		'deployment_input_delta': as_json(deployment_input_delta(replacements))!,
		'deployment_input_additions': as_json({'/' + vending_path: vending_pin})!,
		'deployment_top_level_delta': as_json(['inputs_sha256', 'framework_manifest_sha256', 'native_manifest_sha256'])!, 'inputs_sha256': as_json(inputs)!,
		'deployment_top_level_additions': as_json({'vending_signer_sdk29_sha256': vending_signer})!,
		'headless_input_delta': as_json({'/' + jar_path: jar_pin})!, 'headless_top_level_delta': as_json(['inputs_sha256'])!,
		'original_modules_sha256': as_json(before)!, 'preserved_modules_sha256': as_json(after)!,
		'overlay_inventory': as_json(entries)!, 'overlay_sha256': json2.Any(stage.hash(root + '/' + overlay)!),
		'limine_before_sha256': json2.Any(stage.hash(root + '/limine-before.conf')!), 'limine_after_sha256': json2.Any(stage.hash(root + '/limine-after.conf')!),
		'staged_boot_sha256': json2.Any(stage.hash(root + '/boot.img')!), 'staged_efivars_sha256': json2.Any(stage.hash(root + '/efivars.fd')!),
		'guest_terminal_command': json2.Any('/opt/vinix-maps-account/bin/maps-account-guest --broker --trace-tls'),
		'disk_reserve_bytes': as_json(disk_reserve)!, 'disk_growth_limit_bytes': as_json(disk_growth)!,
		'disk_growth_policy': json2.Any('Cumulative observed volume drops during writable phases plus 1 MiB per exact 68-byte module digest receipt; explicit read-only audits refresh baseline with reserve enforced. No refunds.'),
		'disk_digest_receipt_charge_bytes': as_json(disk.digest_receipt_charged)!, 'disk_charged_growth_bytes': as_json(disk.charged)!,
		'disk_available_samples_bytes': as_json(disk_samples)!,
		'disk_sample_argv': as_json(['/usr/bin/env', 'LC_ALL=C', '/bin/df', '-kP', os.dir(root)])!,
	})!
	check_disk(root, 'receipt-complete', true, mut disk, mut disk_samples)!
	mut files := map[string]string{}
	collect(root, '', mut files)!
	check_disk(root, 'output-inventory', false, mut disk, mut disk_samples)!
	write_json(root + '/sha256.json', as_json(files)!)!
	check_disk(root, 'seal-complete', true, mut disk, mut disk_samples) or {
		os.rm(root + '/sha256.json') or { return error('post-seal disk check failed and completion seal removal failed: ' + err.msg()) }
		return err
	}
	println('MAPS-SEED-ACCOUNT-COMPANION-STAGE PASS ' + root + ' seal=' + stage.hash(root + '/sha256.json')!)
}
fn self_test() ! {
	exact_profile(base_seal, framework_seal, jar_pin, dex_pin)!
	mut all_deps := {old_controller_root: old_controller_seal}
	for i in 0 .. 64 { all_deps['/retained/' + i.str()] = 'a'.repeat(64) }
	paired := paired_dependencies(all_deps)!
	if all_deps.len != 65 || paired.len != 64 || old_controller_root !in all_deps || old_controller_root in paired {
		return error('dependency partition changed the retained full map')
	}
	for path, pin in paired { if all_deps[path]! != pin { return error('dependency partition changed a paired pin') } }
	mut wrong_excluded := all_deps.clone()
	wrong_excluded[old_controller_root] = '0'.repeat(64)
	if _ := paired_dependencies(wrong_excluded) { return error('wrong excluded controller pin accepted') }
	mut missing_excluded := all_deps.clone()
	missing_excluded.delete(old_controller_root)
	if _ := paired_dependencies(missing_excluded) { return error('missing excluded controller accepted') }
	mut missing_other := all_deps.clone()
	missing_other.delete('/retained/0')
	if _ := paired_dependencies(missing_other) { return error('missing paired dependency accepted') }
	mut extra_deps := all_deps.clone()
	extra_deps['/unreviewed'] = 'b'.repeat(64)
	if _ := paired_dependencies(extra_deps) { return error('extra paired dependency accepted') }
	framework_helper := os.getwd() + '/tests/native-android-tools/androidtools/framework.v'
	service_helper := os.getwd() + '/tests/native-android-tools/androidtools/framework_seed_account_options.v'
	helper_before := {framework_helper: framework_helper_before_pin, '/unchanged': 'a'.repeat(64)}
	helper_after := {framework_helper: framework_helper_after_pin, service_helper: seed_helper_added_pin, '/unchanged': 'a'.repeat(64)}
	exact_helper_delta('builder', helper_before, helper_after)!
	exact_helper_delta('native-generator', helper_before, helper_before)!
	if _ := exact_helper_delta('native-generator', helper_before, helper_after) { return error('builder helper changes accepted in native generator') }
	for path in helper_after.keys() {
		mut bad := helper_after.clone()
		bad[path] = '0'.repeat(64)
		if _ := exact_helper_delta('builder', helper_before, bad) { return error('unexpected helper identity accepted') }
		bad.delete(path)
		if _ := exact_helper_delta('builder', helper_before, bad) { return error('missing helper identity accepted') }
	}
	mut extra_helper := helper_after.clone()
	extra_helper['/unreviewed'] = 'b'.repeat(64)
	if _ := exact_helper_delta('builder', helper_before, extra_helper) { return error('unreviewed helper addition accepted') }
	mut before := framework_before()
	before['android/widget/ImageView.smali'] = '20b3e0ec72ce502400c741b517a9953dbd045ffa0524a277d63e343252ce2029'
	for i in 0 .. 2101 { before['other/' + i.str() + '.smali'] = 'a'.repeat(64) }
	mut after := before.clone()
	for name, pin in framework_canonical_delta() { after[name.all_after('new-dex/')] = pin }
	exact_canonical_delta(before, after)!
	mut changed_classes := framework_before().keys()
	changed_classes << added_classes()
	changed_classes << 'other/0.smali'
	for changed in changed_classes {
		mut bad := after.clone()
		bad[changed] = 'b'.repeat(64)
		if _ := exact_canonical_delta(before, bad) { return error('unreviewed canonical body accepted') }
		bad.delete(changed)
		if _ := exact_canonical_delta(before, bad) { return error('missing canonical class accepted') }
	}
	mut extra_class := after.clone()
	extra_class['extra.smali'] = 'a'.repeat(64)
	if _ := exact_canonical_delta(before, extra_class) { return error('extra canonical class accepted') }
	mut consumed := {'smali/android/widget/ImageView.smali': before['android/widget/ImageView.smali']!}
	for i in 0 .. 67 { consumed['smali/other/' + i.str() + '.smali'] = 'a'.repeat(64) }
	exact_consumed_canonical(consumed, before, after)!
	for target in ['android/widget/ImageView.smali', 'other/0.smali'] {
		mut bad := after.clone()
		bad[target] = 'b'.repeat(64)
		if _ := exact_consumed_canonical(consumed, before, bad) { return error('unreviewed consumed canonical body accepted') }
		bad.delete(target)
		if _ := exact_consumed_canonical(consumed, before, bad) { return error('missing consumed canonical class accepted') }
	}
	for target in consumed.keys() {
		mut bad := consumed.clone()
		bad.delete(target)
		if _ := exact_consumed_canonical(bad, before, after) { return error('missing consumed member accepted') }
	}
	mut missing_activity := consumed.clone()
	missing_activity.delete('smali/android/widget/ImageView.smali')
	missing_activity['smali/other/67.smali'] = 'a'.repeat(64)
	if _ := exact_consumed_canonical(missing_activity, before, after) { return error('substituted consumed ImageView membership accepted') }
	for target, pin in framework_before() {
		mut consumed_target := consumed.clone()
		consumed_target.delete('smali/other/66.smali')
		consumed_target['smali/' + target] = pin
		if _ := exact_consumed_canonical(consumed_target, before, after) { return error('seed options target accepted among native consumed classes') }
	}
	for values in [[old_framework_seal, jar_pin, dex_pin], [framework_seal, old_jar_pin, dex_pin],
		[framework_seal, jar_pin, old_dex_pin], ['', jar_pin, dex_pin]] {
		if _ := exact_profile(base_seal, values[0], values[1], values[2]) { return error('obsolete or mismatched framework accepted') }
	}
	header := 'Filesystem 1024-blocks Used Available Capacity Mounted on\n'
	if available_bytes(header + '/dev/disk3s5 1948404040 1912096216 4311392 100% /System/Volumes/Data\n')! != u64(4311392) * 1024 { return error('df value differs') }
	for malformed in ['', header, header + '/dev/disk 100 1 99 bogus /\n', header + '/dev/disk 100 101 1 100% /\n',
		header + '/dev/disk 100 1 -1 100% /\n', header + '/dev/disk 100 1 18014398509481984 100% /\n'] {
		if _ := available_bytes(malformed) { return error('malformed df accepted') }
	}
	if disk_blocks('18014398509481983')! != u64(0xffffffffffffffff) / 1024 { return error('df boundary rejected') }
	start := disk_reserve + disk_growth + 32
	mut budget := DiskBudget{available: start + disk_growth}
	update_budget(start, false, mut budget)!
	if budget.charged != 0 { return error('read-only audit charged unrelated drift') }
	update_budget(start - 31, true, mut budget)!
	if budget.charged != 31 { return error('writable growth not charged') }
	charge_audit(31, mut budget)!
	if budget.charged != 31 + 31 * digest_receipt_charge || budget.digest_receipt_charged != 31 * digest_receipt_charge { return error('audit receipt charge differs') }
	update_budget(start + 100, false, mut budget)!
	if budget.charged != 31 + 31 * digest_receipt_charge { return error('baseline refresh refunded charge') }
	for count in [0, 32, -1] { if _ := charge_audit(count, mut budget) { return error('unbounded audit accepted') } }
	mut full := DiskBudget{available: start, charged: disk_growth - 1}
	update_budget(start - 1, true, mut full)!
	if full.charged != disk_growth { return error('growth boundary differs') }
	if _ := update_budget(start - 2, true, mut full) { return error('cumulative growth bypassed') }
	if _ := update_budget(disk_reserve - 1, false, mut full) { return error('read-only reserve bypassed') }
	if _ := charge_audit(1, mut full) { return error('audit charge bypassed growth ceiling') }
	if _ := exact_profile(native_seal, framework_seal, jar_pin, dex_pin) { return error('wrong base accepted') }
	old := {'a': json2.Any('old'), 'b': json2.Any('same')}
	exact_delta(old, {'a': json2.Any('new'), 'b': json2.Any('same')}, {'a': json2.Any('new')})!
	for bad in [{'a': json2.Any('new')}, {'a': json2.Any('new'), 'b': json2.Any('bad')},
		{'a': json2.Any('new'), 'b': json2.Any('same'), 'c': json2.Any('extra')}] {
		if _ := exact_delta(old, bad, {'a': json2.Any('new')}) { return error('unsafe receipt delta accepted') }
	}
	if _ := exact_delta(old, old, {'a': json2.Any('old')}) { return error('missing receipt change accepted') }
	mut deployment := {
		'kind': json2.Any('vinix-maps-account-deployment-v1'), 'framework_manifest_sha256': json2.Any(old_framework_seal),
		'native_manifest_sha256': json2.Any(native_seal), 'launch_manifest_sha256': json2.Any(launch_seal),
		'browser_client_manifest_sha256': json2.Any(browser_seal),
		'inputs_sha256': as_json({'/' + controller_path: old_controller_pin, '/' + alias_path: old_controller_pin, '/' + broker_path: broker_pin,
			'/' + jar_path: old_jar_pin, '/' + dex_path: old_dex_pin, '/' + native_path: native_pin, '/unchanged': native_seal,
			'/' + headless + '/framework-build.json': old_framework_build_pin, '/' + headless + '/framework-sha256.json': old_framework_seal,
			'/' + headless + '/guest-inputs.json': old_headless_pin})!,
	}
	replacements := {'/' + controller_path: controller_pin, '/' + alias_path: controller_pin,
		'/' + jar_path: jar_pin, '/' + dex_path: dex_pin, '/' + native_path: successor_native_pin,
		'/' + headless + '/framework-build.json': framework_build_pin, '/' + headless + '/framework-sha256.json': framework_seal,
		'/' + headless + '/guest-inputs.json': 'c'.repeat(64)}
	updated := repin_deployment(deployment, replacements)!
	actual_delta := deployment_input_delta(replacements)
	if actual_delta.len != (if successor_native_pin == native_pin { 7 } else { 8 })
		|| ('/' + native_path in actual_delta) != (successor_native_pin != native_pin) {
		return error('actual changed input set differs from rebuilt DSO identity')
	}
	if replacements.len != 8 || replacements['/' + native_path]! != successor_native_pin {
		return error('same native DSO was dropped from the replacement files')
	}
	mut checked_paths := changed_paths()
	checked_paths << [controller_path, alias_path, broker_path, native_path, vending_path, 'unchanged']
	for name in checked_paths {
		mut bad := json2.decode[map[string]json2.Any](json2.encode(updated))!
		mut pins := json2.decode[map[string]string](json2.encode(bad['inputs_sha256']!))!
		pins['/' + name] = old_jar_pin
		bad['inputs_sha256'] = as_json(pins)!
		if _ := verify_deployment_delta(deployment, bad, replacements) { return error('unrelated or missing deployment input delta accepted') }
	}
	mut extra := json2.decode[map[string]json2.Any](json2.encode(updated))!
	extra['extra'] = json2.Any('unexpected')
	if _ := verify_deployment_delta(deployment, extra, replacements) { return error('extra deployment key accepted') }
	mut wrong_native := json2.decode[map[string]json2.Any](json2.encode(updated))!
	wrong_native['native_manifest_sha256'] = json2.Any(controller_pin)
	if _ := verify_deployment_delta(deployment, wrong_native, replacements) { return error('extra deployment identity delta accepted') }
	for name in ['vending_signer_sdk29_sha256', 'unreviewed_top_field'] {
		mut bad := json2.decode[map[string]json2.Any](json2.encode(updated))!
		bad[name] = json2.Any('0'.repeat(64))
		if _ := verify_deployment_delta(deployment, bad, replacements) { return error('unverified or extra new deployment field accepted') }
	}
	mut missing_vending := json2.decode[map[string]json2.Any](json2.encode(updated))!
	mut missing_inputs := json2.decode[map[string]string](json2.encode(missing_vending['inputs_sha256']!))!
	missing_inputs.delete('/' + vending_path)
	missing_vending['inputs_sha256'] = as_json(missing_inputs)!
	if _ := verify_deployment_delta(deployment, missing_vending, replacements) { return error('missing new protected Vending input accepted') }
	mut extra_vending := json2.decode[map[string]json2.Any](json2.encode(updated))!
	mut extra_inputs := json2.decode[map[string]string](json2.encode(extra_vending['inputs_sha256']!))!
	extra_inputs['/opt/unreviewed.apk'] = vending_pin
	extra_vending['inputs_sha256'] = as_json(extra_inputs)!
	if _ := verify_deployment_delta(deployment, extra_vending, replacements) { return error('extra admitted APK input accepted') }
	mut preexisting_input := json2.decode[map[string]json2.Any](json2.encode(deployment))!
	mut preexisting_inputs := json2.decode[map[string]string](json2.encode(preexisting_input['inputs_sha256']!))!
	preexisting_inputs['/' + vending_path] = vending_pin
	preexisting_input['inputs_sha256'] = as_json(preexisting_inputs)!
	if _ := repin_deployment(preexisting_input, replacements) { return error('new Vending input treated as an old replacement') }
	mut preexisting_signer := deployment.clone()
	preexisting_signer['vending_signer_sdk29_sha256'] = json2.Any(vending_signer)
	if _ := repin_deployment(preexisting_signer, replacements) { return error('new Vending signer treated as an old field') }
	for path in [controller_path, alias_path, broker_path, jar_path, dex_path, native_path,
		headless + '/framework-build.json', headless + '/framework-sha256.json', headless + '/guest-inputs.json'] {
		mut pins := json2.decode[map[string]string](json2.encode(deployment['inputs_sha256']!))!
		pins['/' + path] = '0'.repeat(64)
		mut bad := deployment.clone()
		bad['inputs_sha256'] = as_json(pins)!
		if _ := repin_deployment(bad, replacements) { return error('mismatched prior input accepted') }
	}
	deployment['native_manifest_sha256'] = json2.Any(controller_pin)
	if _ := repin_deployment(deployment, replacements) { return error('unrelated native identity accepted') }
	old_headless := {'inputs_sha256': as_json(headless_inputs())!}
	mut new_headless_pins := headless_inputs()
	new_headless_pins['/' + jar_path] = jar_pin
	if repin_headless(old_headless)! != {'inputs_sha256': as_json(new_headless_pins)!} { return error('headless replacement differs') }
	for path in headless_inputs().keys() {
		mut bad := headless_inputs()
		bad[path] = '0'.repeat(64)
		if _ := repin_headless({'inputs_sha256': as_json(bad)!}) { return error('changed retained headless input accepted') }
	}
	allowed := payload_paths()
	exact_regular_names(allowed)!
	for bad in [allowed[..5], []string{}, [jar_path, dex_path, deployment_path, 'opt/escape'], [jar_path, jar_path, deployment_path]] {
		if _ := exact_regular_names(bad) { return error('wrong payload set accepted') }
	}
	plan := [stage.Entry{name: jar_path, kind: 'regular', mode: 0o644}]
	good := [stage.Entry{name: 'opt', kind: 'directory', mode: 0o755}, stage.Entry{name: jar_path, kind: 'regular', mode: 0o644}]
	if inherited_modes(good, plan)![jar_path]! != 0o644 { return error('file mode lost') }
	for bad in [stage.Entry{name: 'opt', kind: 'symlink', mode: 0o755}, stage.Entry{name: jar_path, kind: 'regular', mode: 0o777},
		stage.Entry{name: jar_path, kind: 'regular', mode: 0o4644}] {
		mut original := good.clone()
		original << bad
		if _ := inherited_modes(original, plan) { return error('unsafe old inode accepted') }
	}
	if _ := inherited_modes([]stage.Entry{}, plan) { return error('missing original file accepted') }
	vending_plan := [stage.Entry{name: vending_path, kind: 'regular', mode: 0o644, sha256: vending_pin, size: vending_size}]
	vending_ancestors := [stage.Entry{name: 'opt', kind: 'directory', mode: 0o755},
		stage.Entry{name: 'opt/vinix-maps-account/apks', kind: 'directory', mode: 0o755}]
	if inherited_modes(vending_ancestors, vending_plan)![vending_path]! != 0o644 { return error('exact new protected Vending leaf rejected') }
	for bad in [stage.Entry{name: vending_path, kind: 'regular', mode: 0o644, sha256: '0'.repeat(64), size: vending_size},
		stage.Entry{name: vending_path, kind: 'regular', mode: 0o644, sha256: vending_pin, size: vending_size - 1},
		stage.Entry{name: vending_path, kind: 'regular', mode: 0o755, sha256: vending_pin, size: vending_size},
		stage.Entry{name: vending_path + '.extra', kind: 'regular', mode: 0o644, sha256: vending_pin, size: vending_size}] {
		if _ := inherited_modes(vending_ancestors, [bad]) { return error('unreviewed new admission leaf accepted') }
	}
	mut preexisting_vending := vending_ancestors.clone()
	preexisting_vending << vending_plan
	if _ := inherited_modes(preexisting_vending, vending_plan) { return error('already present Vending destination accepted as new') }
	native_plan := [stage.Entry{name: native_path, kind: 'regular', mode: 0o755}]
	mut native_inodes := [stage.Entry{name: 'opt', kind: 'directory', mode: 0o755}, stage.Entry{name: native_path, kind: 'regular', mode: 0o755}]
	native_inodes << stage.Entry{name: native_path, kind: 'regular', mode: 0o644}
	if inherited_modes(native_inodes, native_plan)![native_path]! != 0o755 { return error('first executable native inode lost') }
	if _ := inherited_modes([stage.Entry{name: native_path, kind: 'regular', mode: 0o644}], native_plan) { return error('nonexecutable first native inode accepted') }
	println('MAPS-SEED-ACCOUNT-COMPANION-STAGE SELFTEST PASS ten-file controller/framework/native delta single protected Vending admission 65 complete dependencies 64 paired jobs 68 consumed equalities JNI/bindings roles modes disk bounds')
}
fn main() {
	if os.args.len == 2 && os.args[1] == '--self-test' { self_test() or { eprintln(err); exit(1) }; return }
	if os.args.len == 2 && os.args[1] == '--audit-framework' { audit_framework_inputs() or { eprintln(err); exit(1) }; return }
	if os.args.len == 2 && os.args[1] == '--audit-controller' { audit_controller_inputs() or { eprintln(err); exit(1) }; return }
	if os.args.len == 2 && os.args[1] == '--audit-vending' { audit_vending_inputs() or { eprintln(err); exit(1) }; return }
	if os.args.len == 2 && os.args[1] == '--enumerate-native-helpers' { enumerate_native_helpers() or { eprintln(err); exit(1) }; return }
	if os.args.len != 3 || os.args[1] != '--prepare' { eprintln('usage: maps-seed-account-companion-stage --prepare FRESH_EXTERNAL_OUTPUT | --self-test | --audit-framework | --audit-controller | --audit-vending | --enumerate-native-helpers'); exit(2) }
	run(os.args[2]) or { eprintln(err); exit(1) }
}
