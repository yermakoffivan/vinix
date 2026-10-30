// SPDX-License-Identifier: GPL-2.0-or-later
// Account compatibility: typed persistent-data absence and guarded native window lookup.
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
const base_root = state_root + '/maps-seed-account-companion-r1'
const base_seal = '67be52229ca728113d7819f6020ba928a26745f7ce59f7ab458cabfe88d30137'
const startup_root = state_root + '/maps-startup-r1'
const startup_seal = 'f79065bc79d816f8cf35a21c72ef375369229b0ee8170165890808e3d194e332'
const controller_stage_root = state_root + '/maps-controller-r1'
const controller_stage_seal = '3026dfd0e7d69fe81d0b8ba4d504d952fd14fa34d20c9b4cdf6d0b98cc9d857a'
const controller_root = state_root + '/maps-account-guest-build-2026-10-30-gms-companion-r1'
const controller_seal = 'd903515f7d493f6174128bede8511e8f470515b580a8e5374aa5623360e289d5'
const controller_pin = '7d48a43d7f6fbe39ad5704e68a62b1cdbab65e867000c91f5fdfbc9066cfc216'
const broker_root = state_root + '/current-account-broker-build-2026-10-30-child-status-r1'
const broker_seal = '7bba04e39681e31c6e13dbd65df99094dadec17a1ab99e114e50f74aa2d18ae9'
const broker_pin = '0bf4d36c6c4035eb7e736ee04f3f7a612b9582ef44bad6950bf0aa8b1b1c35ee'
const retained_broker_seal = 'b06d4aadb661eb1ba13ac07e9033d88db1db731d54d2b1685df6dba1e69cd8f6'
const vending_root = state_root + '/maps-vending-admission-2026-10-30-r2'
const vending_seal = 'c6e9ec6ef3280b977fadee1aed5a7d91a94d10807bbc65da1feff98823228f1d'
const vending_pin = '444e41ee8ef6ec8c55815087c51c28e516ea32f93d856f8bdd0025bb6fc36bc2'
const vending_signer = 'f0fd6c5b410f25cb25c3b53346c8972fae30f8ee7411df910480ad6b2d60db83'
const broker_framework_root = state_root + '/combined-account-webview-application-restrictions-framework-2026-10-28-r1'
const broker_framework_seal = '8907c1f11d8886b47358b458a8026d8351c6feac44d78346d6d426208b8ffe15'
const old_framework_root = state_root + '/combined-account-webview-seed-account-options-framework-2026-10-30-r1'
const old_framework_seal = '470636b2812f339d58071ba59986282ac5107e5256aa2588dd9305d7ef5b45e9'
const old_framework_build_pin = '4934f484c1d9dbeb41e0b9e53e31634cae19be72a21bbf88bb758969bec046ce'
const framework_root = state_root + '/combined-account-webview-persistent-data-block-framework-2026-10-30-r1'
const framework_seal = 'a6d34af62a2b8fd6f85c84dd36493d47b3eefa9690cf875c7ac0e67abe882858'
const framework_build_pin = 'f0f7cbad1cea5f966c9be3a75ca8e75e1e34e6ab14b2c65b903f8db3f38b5262'
const native_root = state_root + '/current-native-build-2026-10-30-seed-account-options-r1'
const native_seal = '8fbfbd2c74eca6c412909a2a64fb91949cbaa1ed0b262e9970ff375dddff61f8'
const native_build_pin = '1a968278009d05f2c3d68068b46f5128c46f23ee6ae7bb384ede50c67bc2c5ce'
const native_pin = '179f51ad25cc99fd939ca1f217e87f1d3ab9c452b98db861da11e0344363f6ce'
const old_generated_pin = 'b349742dff2bdcc464e3df011ccf54d0ff546ea36a1feb9cd82b26ec3da67dde'
const generated_pin = 'efc0319f32eb20e944caa8bd91dfd4b42efaa05df65365f3c616a4916dd8f70f'
const successor_native_root = state_root + '/current-native-build-2026-10-30-persistent-data-block-r1'
const successor_native_seal = 'a3be17ca4753f9bc816ee21483ed3481aa229ecc6383a5daa9b3691bf71f3da9'
const successor_native_pin = '192411171dec072c89a64a81d8b35f36e92d060c75505fadceb47d683e9ed2e5'
const successor_native_build_pin = 'd65c4d31c93933828924a63655e2bf9197c5d782422940b5fe6edcd17e6b7838'
const headless_source_pin = 'd22892cc47def3c2e830a6e29873acd5c0eb08b944f68d131e39f4922c1663ff'
const framework_helper_after_pin = '68e00e36424a12d379153aa62705524d172da711c284073b621d28f4e5beb3ef'
const persistent_helper_added_pin = '5af098c201f898ed4592203f21227fe9d543814280799ddb8b99542c602f0408'
const old_bindings_pin = 'e3fa613993c1ca60aab021ebdbacc93dc71ae68e4bef3d112482f77c8ddeb95b'
const bindings_pin = 'a94a653fe96f3f05310ab07d68f9d551f1a3b192129e2fd93d9d4f90409547d5'
const builder_pin = 'a468758d4957f66703836da209b901e1344a2f889b27c2df868630d97adc4d33'
const framework_helper_before_pin = '7f5a04072cbba86c1c4f752c9eb4f085055488a16b2591d123b75729f44feab4'
const browser_seal = 'fa39f1486d651dff8904a9d75e82cf67d462b2c41511a1a4cd3a184c49239e62'
const browser_pin = '16def2047bf7605a23d949ff7b6b56bc56dcece038136553a98a0524b26ded1a'
const old_jar_pin = 'cb2e3fabab652c65351da16770ae98c4113781df0830440b734395bb35b6f265'
const old_dex_pin = '790d9c0436e070a0ff643127228f622f0a30ae12e4560e7acccadf4550a13dfa'
const jar_pin = '7c1b2fa03924003c7717e07ef463bff81c6429c7667b2bc42d35954fb6d41752'
const dex_pin = 'c7aa301de104c40a793477d4a86349301b21e243932011088b22e2d16228eb53'
const launch_seal = '920ed6f1a5f5d9e705bdcc108937db6266066718fe4203859a6ac8577bd405be'
const controller_path = 'opt/vinix-maps-account/bin/maps-account-guest'
const broker_path = 'opt/vinix-android-aarch64/usr/bin/native-account-broker'
const alias_path = 'usr/bin/run-android-calculator'
const deployment_path = 'opt/vinix-maps-account/build.json'
const jar_path = 'opt/vinix-android-aarch64/usr/lib/java/dex/android_translation_layer/api-impl.jar'
const dex_path = 'opt/vinix-android-aarch64/usr/lib/java/dex/android_translation_layer/classes.dex'
const native_path = 'opt/vinix-android-aarch64/usr/lib/art/libvinix-android-native.so'
const headless = 'opt/vinix-headless-service'
const headless_base = base_root + '/payload/'
const old_headless_pin = '08d01053bdacf288b1aa08b4ed4aecd437da9accdea2b23c59e1b7a9b48609fb'
const old_deployment_pin = 'd1aaa88cfb2edd190158a9394e08a219fe4a0c78849635531eff3115f3837636'
const overlay = 'maps-persistent-data-block.tar'
const disk_reserve = u64(1024) * 1024 * 1024
const disk_growth = u64(512) * 1024 * 1024
const digest_receipt_charge = u64(1024) * 1024
const retained = {
	'tests/native-android-ws/maps-persistent-data-block-stage.v': carry($embed_file(@FILE))
	'tests/native-android-ws/mapsaccountstage/bundle.v': carry($embed_file('mapsaccountstage/bundle.v'))
	'tests/native-android-ws/mapsaccountstage/hostsha.v': carry($embed_file('mapsaccountstage/hostsha.v'))
	'tests/native-android-ws/mapsaccountstage/parallel.v': carry($embed_file('mapsaccountstage/parallel.v'))
	'tests/native-android-ws/mapsaccountstage/batches.v': carry($embed_file('mapsaccountstage/batches.v'))
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
	println('MAPS-PERSISTENT-DATA-BLOCK disk ' + label + ' available_bytes=' + available.str() + ' charged_growth_bytes=' + budget.charged.str())
}
fn charge_audit(count int, mut budget DiskBudget) ! {
	if count < 1 || count > 32 || budget.charged > disk_growth || u64(count) * digest_receipt_charge > disk_growth - budget.charged { return error('module digest receipts exceed preparation budget') }
	budget.charged += u64(count) * digest_receipt_charge
	budget.digest_receipt_charged += u64(count) * digest_receipt_charge
}
fn audit_modules(root string, label string, image string, names []string, expected map[string]string,
	mut budget DiskBudget, mut samples map[string]u64) !map[string]string {
	if names.len < 1 || names.len > 32 || names.len != expected.len { return error('bounded exact module audit required') }
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
		|| !stage.valid_pin(successor_native_seal) || !stage.valid_pin(successor_native_pin) || !stage.valid_pin(successor_native_build_pin)
		|| !stage.valid_pin(headless_source_pin) || !stage.valid_pin(framework_helper_after_pin) || !stage.valid_pin(persistent_helper_added_pin)
		|| !stage.valid_pin(generated_pin) || generated_pin == old_generated_pin || bindings_pin == old_bindings_pin
		|| manifest == old_framework_seal || jar == old_jar_pin || dex == old_dex_pin
		|| successor_native_seal == native_seal {
		return error('exact reviewed persistent-data framework/native profile required')
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
	return [jar_path, dex_path, native_path, headless + '/framework-build.json', headless + '/framework-sha256.json', headless + '/guest-inputs.json']
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
		|| stage.text_field(original, 'browser_client_manifest_sha256')! != browser_seal
		|| stage.text_field(original, 'vending_signer_sdk29_sha256')! != vending_signer {
		return error('retained deployment identity differs')
	}
	old := json2.decode[map[string]string](json2.encode(original['inputs_sha256']!))!
	if old['/' + controller_path] or { '' } != controller_pin
		|| old['/' + alias_path] or { '' } != controller_pin
		|| old['/' + broker_path] or { '' } != broker_pin
		|| old['/opt/vinix-maps-account/apks/vending.apk'] or { '' } != vending_pin
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
	if actual != expected || replacements['/' + jar_path]! != jar_pin || replacements['/' + dex_path]! != dex_pin
		|| replacements['/' + native_path]! != successor_native_pin
		|| replacements['/' + headless + '/framework-build.json']! != framework_build_pin
		|| replacements['/' + headless + '/framework-sha256.json']! != framework_seal { return error('exact six framework/native replacements required') }
	for name, pin in deployment_input_delta(replacements) {
		if !stage.valid_pin(pin) { return error('invalid framework replacement pin') }
		updated[name] = pin
		changes[name] = json2.Any(pin)
	}
	exact_delta(as_json(old)!.as_map(), as_json(updated)!.as_map(), changes)!
	mut result := original.clone()
	result['inputs_sha256'] = as_json(updated)!
	result['framework_manifest_sha256'] = json2.Any(framework_seal)
	result['native_manifest_sha256'] = json2.Any(successor_native_seal)
	verify_deployment_delta(original, result, replacements)!
	return result
}
fn verify_deployment_delta(original map[string]json2.Any, updated map[string]json2.Any, replacements map[string]string) ! {
	old := json2.decode[map[string]string](json2.encode(original['inputs_sha256']!))!
	actual := updated['inputs_sha256'] or { return error('deployment pins removed') }
	exact_delta(as_json(old)!.as_map(), actual.as_map(), as_json(deployment_input_delta(replacements))!.as_map())!
	exact_delta(original, updated, {'inputs_sha256': actual, 'framework_manifest_sha256': json2.Any(framework_seal), 'native_manifest_sha256': json2.Any(successor_native_seal)})!
}
fn exact_regular_names(names []string) ! {
	mut actual := names.clone()
	mut expected := changed_paths()
	expected << deployment_path
	actual.sort()
	expected.sort()
	if actual != expected { return error('seven-file payload allowlist differs') }
}
fn payload_inventory(root string) ![]stage.Entry {
	mut entries := []stage.Entry{}
	mut roots := os.ls(root)!
	roots.sort()
	if roots != ['opt'] { return error('payload root set differs') }
	for prefix in roots { stage.inventory(root + '/' + prefix, '', prefix, mut entries)! }
	exact_regular_names(entries.filter(it.kind == 'regular').map(it.name))!
	for entry in entries {
		if entry.kind == 'regular' {
			if entry.name == jar_path && entry.sha256 != jar_pin { return error('payload JAR differs') }
			if entry.name == dex_path && entry.sha256 != dex_pin { return error('payload DEX differs') }
			if entry.name == headless + '/framework-build.json' && entry.sha256 != framework_build_pin { return error('payload framework build differs') }
			if entry.name == headless + '/framework-sha256.json' && entry.sha256 != framework_seal { return error('payload framework inventory differs') }
			mode := if entry.name == native_path { u32(0o755) } else { u32(0o644) }
			if entry.mode != mode { return error('payload file mode differs') }
			if entry.name == native_path && entry.sha256 != successor_native_pin { return error('payload native differs') }
			continue
		}
		mut allowed := changed_paths()
		allowed << deployment_path
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
		if target.name !in modes { return error('destination absent from original media: ' + target.name) }
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
	if selected.len != 70 || selected[controller_root] or { '' } != controller_seal
		|| selected[broker_root] or { '' } != broker_seal
		|| selected[startup_root] or { '' } != startup_seal
		|| selected[controller_stage_root] or { '' } != controller_stage_seal
		|| selected[old_framework_root] or { '' } != old_framework_seal
		|| selected[broker_framework_root] or { '' } != broker_framework_seal
		|| selected[vending_root] or { '' } != vending_seal
		|| selected[native_root] or { '' } != native_seal {
		return error('exact inherited complete dependency set differs')
	}
	return selected
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
	return {'android/app/ContextImpl.smali': '5e61970bcb36e5f4354d1c17ac85583db7bc4e8bb6d0983426ab6e72265ef07a'}
}
fn framework_source_delta() map[string]string {
	return {'smali/android/app/ContextImpl.smali': 'd87e937313ee9a20ea98095bb1b3f0733621fde0c2630d58c4556d75c7d35ff1',
		'smali/android/service/persistentdata/PersistentDataBlockManager.smali': '1454cbd051ea70c12bdac38fd882bd1e7ad8fed0f88ba64d030277c291ac7859'}
}
fn framework_canonical_delta() map[string]string {
	return {'new-dex/android/app/ContextImpl.smali': 'bb3370f9aac0630357dfced4d361a358f990b982441fe78cc046f7e938540eac',
		'new-dex/android/service/persistentdata/PersistentDataBlockManager.smali': '1454cbd051ea70c12bdac38fd882bd1e7ad8fed0f88ba64d030277c291ac7859'}
}
fn added_classes() []string { return ['android/service/persistentdata/PersistentDataBlockManager.smali'] }
fn framework_method_changes() map[string]int {
	return {'android/app/ContextImpl.smali': 1}
}
fn framework_method_additions() map[string]int {
	return {'android/app/ContextImpl.smali': 0}
}
fn framework_field_additions() map[string][]string {
	return map[string][]string{}
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
	if classes.len != count || count !in [2105, 2106] { return error('complete bounded canonical framework class membership required') }
	return classes
}
fn exact_canonical_delta(before map[string]string, after map[string]string) ! {
	mut names := before.keys()
	names << added_classes()
	names.sort()
	if before.len != 2105 || after.len != 2106 || after.keys().sorted() != names { return error('complete 2105-to-2106-class canonical membership differs') }
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
		|| 'smali/android/app/ContextImpl.smali' in consumed
		|| 'smali/android/service/persistentdata/PersistentDataBlockManager.smali' in consumed { return error('exact 68-class consumed membership required') }
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
		|| stage.text_field(successor.receipt, 'profile')! != 'persistent-data-block-2106'
		|| stage.text_field(successor.receipt, 'baseline_manifest_sha256')! != old_framework_seal
		|| stage.text_field(successor.receipt, 'baseline_api_impl_sha256')! != old_jar_pin {
		return error('exact persistent-data successor profile differs')
	}
	stage.verify_native(native, previous)!
	if native.files['native/libvinix-android-native.so']! != native_pin || native.files['build.json']! != native_build_pin
		|| native.files['native/atlframework/ws_generated.v']! != old_generated_pin { return error('retained native producer differs') }
	if previous.files['framework-dex-after.json']! != successor.files['framework-dex-before.json']! { return error('canonical post-DEX/pre-DEX inventory differs') }
	before := canonical_classes(previous, 2105)!
	after := canonical_classes(successor, 2106)!
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
	if actual_raw != expected_raw { return error('complete canonical-clone raw source tree differs beyond persistent-data scope') }
	for key, value in {'class_count': as_json(2106)!, 'changed_classes': as_json(framework_before().keys().sorted())!,
		'added_classes': as_json(added_classes())!, 'added_fields': as_json(framework_field_additions())!,
		'changed_method_counts': as_json(framework_method_changes())!, 'added_method_counts': as_json(framework_method_additions())!} {
		if successor.receipt[key] or { json2.Any('absent') } != value { return error('exact platform method/field delta receipt differs: ' + key) }
	}
	consumed := json2.decode[map[string]string](os.read_file(native.root + '/framework/consumed-smali.json')!)!
	if consumed.len != 68 || 'smali/android/widget/ImageView.smali' !in consumed
		|| 'smali/android/app/ContextImpl.smali' in consumed
		|| 'smali/android/service/persistentdata/PersistentDataBlockManager.smali' in consumed
		|| native.files.keys().filter(it.starts_with('framework/smali/')).sorted() != consumed.keys().map('framework/' + it).sorted() {
		return error('complete retained 68-class native consumed membership differs')
	}
	exact_consumed_canonical(consumed, before, after)!
	mut raw_delta := map[string][]string{}
	for path, pin in consumed {
		if !path.starts_with('smali/') || !path.ends_with('.smali') || !stage.relative(path)
			|| native.files['framework/' + path] or { '' } != pin || previous.files[path] or { '' } != pin {
			return error('retained native raw input differs from its exact seed framework')
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
fn window_body_before() string {
	return "return obj(e,ws.activity,c'android/app/Activity',c'getWindow',c'()Landroid/view/Window;',nil)"
}
fn window_body_after() string {
	return 'if ws == nil { return nil }; if ws.activity == nil { return nil }; if pending(e) { return nil }; ' + window_body_before()
}
fn exact_window_guard(before string, after string, generated bool) ! {
	old_body := window_body_before()
	if before.count(old_body) != 1 || after != before.replace(old_body, window_body_after()) {
		return error('exact single native window nil/pending guard change required')
	}
	if generated {
		if before.count("@[export: 'Java_android_view_View_native_1get_1window__J']") != 1 || before.count('fn ws_binding_195(') != 1 {
			return error('exact original native window JNI export and function required')
		}
	} else if before.split_into_lines().filter(it.starts_with('android/view/View|native_get_window|')).len != 1 {
		return error('exact original native window binding declaration required')
	}
}
fn exact_helper_delta(label string, before map[string]string, after map[string]string) ! {
	mut expected := before.clone()
	if label == 'builder' {
		framework := os.getwd() + '/tests/native-android-tools/androidtools/framework.v'
		provider := os.getwd() + '/tests/native-android-tools/androidtools/framework_persistent_data_block.v'
		if before[framework] or { '' } != framework_helper_before_pin || provider in before
			|| !stage.valid_pin(framework_helper_after_pin) || !stage.valid_pin(persistent_helper_added_pin) {
			return error('exact reviewed persistent-data registration/provider helper delta required')
		}
		expected[framework] = framework_helper_after_pin
		expected[provider] = persistent_helper_added_pin
	} else if label != 'native-generator' { return error('unknown native helper closure') }
	if after != expected { return error('unreviewed complete native helper closure change: ' + label) }
}
fn exact_native_sources(previous stage.Bundle, successor stage.Bundle, framework stage.Bundle) ! {
	stage.verify_native(successor, framework)!
	if successor.files['native/libvinix-android-native.so']! != successor_native_pin
		|| successor.files['build.json']! != successor_native_build_pin { return error('exact persistent-data-coupled native producer differs') }
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
	for path, pin in {'builder-source.v': builder_pin,
		'native/atlframework/headless.v': headless_source_pin} {
		if previous.files[path]! != pin || successor.files[path]! != pin { return error('retained bindings/JNI/builder differs: ' + path) }
	}
	for path, pins in {'native/bindings.txt': [old_bindings_pin, bindings_pin],
		'native/atlframework/ws_generated.v': [old_generated_pin, generated_pin]} {
		if previous.files[path] or { '' } != pins[0] || successor.files[path] or { '' } != pins[1] { return error('exact native window binding/JNI pins required') }
		exact_window_guard(os.read_file(previous.root + '/' + path)!, os.read_file(successor.root + '/' + path)!, path.ends_with('ws_generated.v'))!
	}
	for path in ['native/exports.json', 'tools/find-v.sh',
		'closure/builder/' + os.getwd().trim_left('/') + '/tests/native-android-tools/androidtools/native_ws.v',
		'closure/native-generator/' + os.getwd().trim_left('/') + '/tests/linuxkpi/generate_module.v'] {
		if successor.files[path]! != previous.files[path]! { return error('retained native helper or export set differs: ' + path) }
	}
	for label in ['builder', 'native-generator'] { exact_helper_delta(label, native_source_closure(previous, label)!, native_source_closure(successor, label)!)! }
	spec := os.getwd() + '/build-support/android/nativews/bindings.txt'
	old_inputs[spec] = old_bindings_pin
	new_inputs[spec] = bindings_pin
	if json2.decode[map[string]string](os.read_file(previous.root + '/native/current-inputs.json')!)! != old_inputs
		|| json2.decode[map[string]string](os.read_file(successor.root + '/native/current-inputs.json')!)! != new_inputs
		|| old_inputs.len != 89 || new_inputs.len != 89 { return error('exact complete native input map with sole binding delta required') }
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
		if successor.files['framework/' + path] or { '' } != pin || framework.files[path] or { '' } != pin { return error('successor native raw input differs from its exact persistent-data framework') }
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
	println('MAPS-PERSISTENT-DATA-BLOCK-AUDIT PASS exact native window binding/JNI guard 2106 canonical classes 68 consumed equalities raw_differences=' + raw.len.str())
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
	stage.disjoint(root, [base_root, controller_root, broker_root, framework_root, successor_native_root, os.getwd()])!
	disk_start := disk_available(os.dir(root))!
	if disk_start < disk_reserve + disk_growth { return error('preparation requires 1.5 GiB initial free space') }
	mut disk := DiskBudget{available: disk_start}
	mut disk_samples := {'preflight': disk_start}
	println('MAPS-PERSISTENT-DATA-BLOCK auditing immutable inputs')
	base_files := stage.load_inventory(base_root, base_seal)!
	base := read_json(base_root + '/stage.json')!
	if stage.text_field(base, 'kind')! != 'vinix-maps-seed-account-companion-v1'
		|| stage.text_field(base, 'base_root')! != state_root + '/maps-broker-tail-r1'
		|| stage.text_field(base, 'base_manifest_sha256')! != 'c6ab0709b40b1718f0d3c6d13e6f1ba3f2a8ccf5de2b6a8e36cd62802ef2c6e9'
		|| stage.text_field(base, 'controller_build_root')! != controller_root
		|| stage.text_field(base, 'controller_manifest_sha256')! != controller_seal
		|| stage.text_field(base, 'controller_sha256')! != controller_pin
		|| stage.text_field(base, 'broker_build_root')! != broker_root
		|| stage.text_field(base, 'broker_manifest_sha256')! != broker_seal
		|| stage.text_field(base, 'broker_sha256')! != broker_pin
		|| stage.text_field(base, 'retained_broker_manifest_sha256')! != retained_broker_seal
		|| stage.text_field(base, 'vending_build_root')! != vending_root
		|| stage.text_field(base, 'vending_manifest_sha256')! != vending_seal
		|| stage.text_field(base, 'vending_sha256')! != vending_pin
		|| stage.text_field(base, 'vending_signer_sdk29_sha256')! != vending_signer
		|| stage.text_field(base, 'framework_manifest_sha256')! != old_framework_seal
		|| stage.text_field(base, 'native_manifest_sha256')! != native_seal
		|| stage.text_field(base, 'native_sha256')! != native_pin
		|| stage.text_field(base, 'native_build_root')! != native_root
		|| stage.text_field(base, 'native_build_sha256')! != native_build_pin
		|| stage.text_field(base, 'generated_jni_sha256')! != old_generated_pin
		|| stage.text_field(base, 'browser_client_manifest_sha256')! != browser_seal
		|| stage.text_field(base, 'browser_client_sha256')! != browser_pin
		|| stage.text_field(base, 'retained_launch_manifest_sha256')! != launch_seal {
		return error('exact immutable seed account companion stage differs')
	}
	if base_files['payload/' + deployment_path]! != old_deployment_pin { return error('retained deployment receipt differs') }
	mut inputs := map[string]string{}
	inputs[base_root + '/sha256.json'] = base_seal
	deps := dependencies(base)!
	stage.disjoint(root, deps.keys())!
	stage.audit_seventy_inventories(deps)!
	for path, pin in deps {
		inputs[path + '/sha256.json'] = pin
	}
	controller := stage.load_bundle(controller_root, controller_seal)!
	stage.verify_static_controller(controller, 'vinix-maps-account-guest-build-v1', 'maps-account-guest')!
	if controller.files['bin/maps-account-guest']! != controller_pin { return error('retained executable differs') }
	inputs[controller_root + '/sha256.json'] = controller_seal
	old_framework := stage.load_bundle(old_framework_root, old_framework_seal)!
	framework := stage.load_bundle(framework_root, framework_seal)!
	native := stage.load_bundle(native_root, native_seal)!
	raw_delta := exact_compatibility(old_framework, framework, native)!
	new_native := stage.load_bundle(successor_native_root, successor_native_seal)!
	exact_native_sources(native, new_native, framework)!
	inputs[framework_root + '/sha256.json'] = framework_seal
	inputs[successor_native_root + '/sha256.json'] = successor_native_seal
	broker_framework := stage.load_bundle(broker_framework_root, broker_framework_seal)!
	broker := stage.load_bundle(broker_root, broker_seal)!
	stage.verify_account_broker(broker, broker_framework)!
	if broker.files['bin/native-account-broker']! != broker_pin { return error('new broker differs') }
	inputs[broker_root + '/sha256.json'] = broker_seal
	if inputs.keys().filter(it.ends_with('/sha256.json')).len != 73 { return error('exact seventy-three complete dependency seals required') }
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
	before['maps-seed-account-companion.tar'] = stage.text_field(base, 'overlay_sha256')!
	if config.modules != ['initramfs.tar', 'qemu-runtime.tar', 'maps335-diagnostics.tar', 'maps350-diagnostics.tar',
		'maps372-diagnostics.tar', 'headless-service.tar', 'maps-account.tar', 'protected-storage-diagnostic.tar',
		'maps-controller-diagnostic.tar', 'maps-service-query-diagnostic.tar', 'maps-controller-memory-diagnostic.tar',
		'maps-direct-boot-diagnostic.tar', 'maps-context-storage-diagnostic.tar', 'maps-broadcast-result-diagnostic.tar',
		'maps-onboarding-trace-diagnostic.tar', 'maps-native-onboarding-trace-diagnostic.tar',
		'maps-onboarding-framework-diagnostic.tar', 'maps-native-heartbeat-diagnostic.tar',
		'maps-browser-poll.tar', 'maps-account-pump.tar', 'maps-application-restrictions.tar', 'maps-account-handoff.tar',
		'maps-auth-exception.tar', 'maps-auth-worker.tar', 'maps-binder-identity.tar', 'maps-service-lifecycle.tar',
		'maps-platform-fragments.tar', 'maps-imageview-bounds.tar', 'maps-window-system-ui.tar', 'maps-broker-tail.tar',
		'maps-seed-account-companion.tar']
		|| before.len != config.modules.len { return error('exact original thirty-one-module set differs') }
	if stage.command(root, 'original-limine', [root + '/tools/mtype', '-i', base_root + '/boot.img', '::/boot/limine.conf'])! != original {
		return error('source media configuration differs')
	}
	check_disk(root, 'original-limine', true, mut disk, mut disk_samples)!
	audit_modules(root, 'original', base_root + '/boot.img', config.modules, before, mut disk, mut disk_samples)!
	original_entries := original_inodes(deps)!
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
	println('MAPS-PERSISTENT-DATA-BLOCK cloning media and appending seven files')
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
	println('MAPS-PERSISTENT-DATA-BLOCK rechecking complete inputs')
	stage.audit_seventy_inventories(deps)!
	stage.recheck(controller)!
	stage.recheck(broker)!
	stage.recheck(framework)!
	stage.recheck(old_framework)!
	stage.recheck(native)!
	stage.recheck(new_native)!
	stage.recheck(broker_framework)!
	if stage.load_inventory(base_root, base_seal)! != base_files { return error('immutable seed account companion stage changed') }
	for path, pin in inputs { if stage.hash(path)! != pin { return error('source/tool changed: ' + path) } }
	if payload_inventory(root + '/payload')! != entries { return error('payload changed') }
	verify_deployment_delta(old_deployment, read_json(root + '/payload/' + deployment_path)!, replacements)!
	if read_json(root + '/payload/' + headless + '/guest-inputs.json')! != repin_headless(old_headless)! { return error('headless input delta changed') }
	check_disk(root, 'complete-recheck', false, mut disk, mut disk_samples)!
	write_json(root + '/stage.json', {
		'kind': json2.Any('vinix-maps-persistent-data-block-v1'), 'format': json2.Any(1),
		'scope': json2.Any('Typed-null persistent-data service with memberless type and exact native window Activity/pending guard. Controller, broker, Vending, registry and all68 native-consumed classes remain unchanged. No Google login proof.'),
		'source_revision': json2.Any(revision), 'base_root': json2.Any(base_root), 'base_manifest_sha256': json2.Any(base_seal),
		'controller_build_root': json2.Any(controller_root), 'controller_manifest_sha256': json2.Any(controller_seal),
		'controller_sha256': json2.Any(controller_pin), 'retained_controller_manifest_sha256': base['retained_controller_manifest_sha256']!,
		'broker_build_root': json2.Any(broker_root), 'broker_manifest_sha256': json2.Any(broker_seal), 'broker_sha256': json2.Any(broker_pin),
		'retained_broker_manifest_sha256': json2.Any(retained_broker_seal),
		'vending_build_root': json2.Any(vending_root), 'vending_manifest_sha256': json2.Any(vending_seal),
		'vending_sha256': json2.Any(vending_pin), 'vending_signer_sdk29_sha256': json2.Any(vending_signer),
		'vending_source_base_manifest_sha256': base['vending_source_base_manifest_sha256']!,
		'vending_source_module_sha256': base['vending_source_module_sha256']!, 'vending_source_member': base['vending_source_member']!,
		'framework_build_root': json2.Any(framework_root),
		'retained_framework_manifest_sha256': json2.Any(old_framework_seal),
		'framework_jar_sha256': json2.Any(jar_pin), 'framework_dex_sha256': json2.Any(dex_pin),
		'native_build_root': json2.Any(successor_native_root), 'native_build_sha256': json2.Any(successor_native_build_pin), 'native_sha256': json2.Any(successor_native_pin),
		'retained_native_manifest_sha256': json2.Any(native_seal), 'generated_jni_sha256': json2.Any(generated_pin),
		'native_framework_manifest_sha256': json2.Any(framework_seal),
		'native_source_delta': as_json(map[string]string{})!,
		'native_bindings_delta': as_json({'native/bindings.txt': [old_bindings_pin, bindings_pin]})!,
		'native_generated_jni_delta': as_json({'native/atlframework/ws_generated.v': [old_generated_pin, generated_pin]})!,
		'native_builder_helper_delta': as_json({'tests/native-android-tools/androidtools/framework.v': framework_helper_after_pin,
			'tests/native-android-tools/androidtools/framework_persistent_data_block.v': persistent_helper_added_pin})!,
		'native_compatibility_framework_manifest_sha256': json2.Any(old_framework_seal),
		'native_consumed_class_count': as_json(68)!, 'native_consumed_raw_delta': as_json(raw_delta)!,
		'native_consumed_canonical_delta': as_json(consumed_canonical_delta())!,
		'framework_class_count': as_json(2106)!,
		'framework_source_delta': as_json(framework_source_delta())!,
		'framework_canonical_delta': as_json(framework_canonical_delta())!,
		'browser_client_build_root': base['browser_client_build_root']!, 'browser_client_manifest_sha256': json2.Any(browser_seal), 'browser_client_sha256': json2.Any(browser_pin),
		'framework_manifest_sha256': json2.Any(framework_seal), 'native_manifest_sha256': json2.Any(successor_native_seal),
		'retained_launch_manifest_sha256': json2.Any(launch_seal),
		'deployment_input_delta': as_json(deployment_input_delta(replacements))!,
		'deployment_top_level_delta': as_json(['inputs_sha256', 'framework_manifest_sha256', 'native_manifest_sha256'])!, 'inputs_sha256': as_json(inputs)!,
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
	println('MAPS-PERSISTENT-DATA-BLOCK-STAGE PASS ' + root + ' seal=' + stage.hash(root + '/sha256.json')!)
}
fn self_test() ! {
	exact_profile(base_seal, framework_seal, jar_pin, dex_pin)!
	framework_helper := os.getwd() + '/tests/native-android-tools/androidtools/framework.v'
	service_helper := os.getwd() + '/tests/native-android-tools/androidtools/framework_persistent_data_block.v'
	helper_before := {framework_helper: framework_helper_before_pin, '/unchanged': 'a'.repeat(64)}
	helper_after := {framework_helper: framework_helper_after_pin, service_helper: persistent_helper_added_pin, '/unchanged': 'a'.repeat(64)}
	binding_before := 'android/view/View|native_get_window|' + window_body_before() + '\n'
	jni_before := "@[export: 'Java_android_view_View_native_1get_1window__J']\nfn ws_binding_195(e voidptr, this voidptr, p0 i64) voidptr {\n " + window_body_before() + '\n}\n'
	for before_guard in [binding_before, jni_before] {
		generated := before_guard == jni_before
		after_guard := before_guard.replace(window_body_before(), window_body_after())
		exact_window_guard(before_guard, after_guard, generated)!
		for bad in [before_guard, after_guard + '\n', after_guard.replace('if pending(e) { return nil }; ', ''),
			after_guard.replace('if ws == nil { return nil }; ', ''), after_guard.replace('if ws.activity == nil { return nil }; ', '')] {
			if _ := exact_window_guard(before_guard, bad, generated) { return error('unreviewed native window body change accepted') }
		}
		if _ := exact_window_guard(before_guard + window_body_before(), after_guard + window_body_before(), generated) { return error('duplicate native window body accepted') }
	}
	wrong_export := jni_before.replace('Java_android_view_View_native_1get_1window__J', 'Java_wrong_window')
	if _ := exact_window_guard(wrong_export, wrong_export.replace(window_body_before(), window_body_after()), true) { return error('unreviewed JNI export accepted') }
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
	for i in 0 .. 2103 { before['other/' + i.str() + '.smali'] = 'a'.repeat(64) }
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
	for target in ['android/app/ContextImpl.smali', 'android/service/persistentdata/PersistentDataBlockManager.smali'] {
		mut consumed_target := consumed.clone()
		consumed_target.delete('smali/other/66.smali')
		consumed_target['smali/' + target] = after[target]!
		if _ := exact_consumed_canonical(consumed_target, before, after) { return error('persistent-data framework target accepted among native consumed classes') }
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
	charge_audit(32, mut budget)!
	if budget.charged != 31 + 32 * digest_receipt_charge || budget.digest_receipt_charged != 32 * digest_receipt_charge { return error('audit receipt charge differs') }
	update_budget(start + 100, false, mut budget)!
	if budget.charged != 31 + 32 * digest_receipt_charge { return error('baseline refresh refunded charge') }
	for count in [0, 33, -1] { if _ := charge_audit(count, mut budget) { return error('unbounded audit accepted') } }
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
		'vending_signer_sdk29_sha256': json2.Any(vending_signer),
		'inputs_sha256': as_json({'/' + controller_path: controller_pin, '/' + alias_path: controller_pin, '/' + broker_path: broker_pin,
			'/opt/vinix-maps-account/apks/vending.apk': vending_pin,
			'/' + jar_path: old_jar_pin, '/' + dex_path: old_dex_pin, '/' + native_path: native_pin, '/unchanged': native_seal,
			'/' + headless + '/framework-build.json': old_framework_build_pin, '/' + headless + '/framework-sha256.json': old_framework_seal,
			'/' + headless + '/guest-inputs.json': old_headless_pin})!,
	}
	replacements := {'/' + jar_path: jar_pin, '/' + dex_path: dex_pin, '/' + native_path: successor_native_pin,
		'/' + headless + '/framework-build.json': framework_build_pin, '/' + headless + '/framework-sha256.json': framework_seal,
		'/' + headless + '/guest-inputs.json': 'c'.repeat(64)}
	updated := repin_deployment(deployment, replacements)!
	actual_delta := deployment_input_delta(replacements)
	if actual_delta.len != (if successor_native_pin == native_pin { 5 } else { 6 })
		|| ('/' + native_path in actual_delta) != (successor_native_pin != native_pin) {
		return error('actual changed input set differs from rebuilt DSO identity')
	}
	if replacements.len != 6 || replacements['/' + native_path]! != successor_native_pin {
		return error('same native DSO was dropped from the replacement files')
	}
	mut checked_paths := changed_paths()
	checked_paths << [controller_path, alias_path, broker_path, native_path, 'unchanged']
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
	for path in [controller_path, alias_path, broker_path, 'opt/vinix-maps-account/apks/vending.apk', jar_path, dex_path, native_path,
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
	mut allowed := changed_paths()
	allowed << deployment_path
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
	native_plan := [stage.Entry{name: native_path, kind: 'regular', mode: 0o755}]
	mut native_inodes := [stage.Entry{name: 'opt', kind: 'directory', mode: 0o755}, stage.Entry{name: native_path, kind: 'regular', mode: 0o755}]
	native_inodes << stage.Entry{name: native_path, kind: 'regular', mode: 0o644}
	if inherited_modes(native_inodes, native_plan)![native_path]! != 0o755 { return error('first executable native inode lost') }
	if _ := inherited_modes([stage.Entry{name: native_path, kind: 'regular', mode: 0o644}], native_plan) { return error('nonexecutable first native inode accepted') }
	println('MAPS-PERSISTENT-DATA-BLOCK-STAGE SELFTEST PASS seven-file framework/native delta memberless type and typed-null service exact native window guard 68 consumed equalities role modes disk bounds')
}
fn main() {
	if os.args.len == 2 && os.args[1] == '--self-test' { self_test() or { eprintln(err); exit(1) }; return }
	if os.args.len == 2 && os.args[1] == '--audit-framework' { audit_framework_inputs() or { eprintln(err); exit(1) }; return }
	if os.args.len == 2 && os.args[1] == '--enumerate-native-helpers' { enumerate_native_helpers() or { eprintln(err); exit(1) }; return }
	if os.args.len != 3 || os.args[1] != '--prepare' { eprintln('usage: maps-persistent-data-block-stage --prepare FRESH_EXTERNAL_OUTPUT | --self-test | --audit-framework | --enumerate-native-helpers'); exit(2) }
	run(os.args[2]) or { eprintln(err); exit(1) }
}
