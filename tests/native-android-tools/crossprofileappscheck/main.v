// SPDX-License-Identifier: GPL-2.0-or-later
module main

import androidtools
import crypto.sha256
import os

const target = 'android/app/ContextImpl.smali'
const manager = 'android/content/pm/CrossProfileApps'
const signature = 'getSystemService(Ljava/lang/Class;)Ljava/lang/Object;'

fn methods(source string) map[string]string {
	mut result := map[string]string{}
	for block in source.split('.method ')[1..] {
		name := block.all_before('\n').all_after_last(' ')
		assert name !in result && block.contains('.end method'), 'unique complete method required'
		result[name] = '.method ' + block.all_before('.end method') + '.end method'
	}
	return result
}

fn norm(source string) string {
	return source.split_into_lines().map(it.all_before('#').trim_space()).filter(it != '').join('\n')
}

fn digest(path string) !string { return sha256.sum(os.read_bytes(path)!).hex() }

fn guard() string {
	return '\nconst-class v0, Landroid/content/pm/CrossProfileApps;\nif-ne p1, v0, :vinix_cross_profile_other\nconst/4 v0, 0x0\nreturn-object v0\n:vinix_cross_profile_other\n'
}

fn manager_source() string {
	return '.class public Landroid/content/pm/CrossProfileApps;\n.super Ljava/lang/Object;\n'
}

fn canonical_method() string {
	return '.method public getSystemService(Ljava/lang/Class;)Ljava/lang/Object;
.registers 3
const-class v0, Landroid/content/pm/CrossProfileApps;
if-ne p1, v0, :cond_6
const/4 v0, 0x0
return-object v0
:cond_6
const-class v0, Landroid/service/persistentdata/PersistentDataBlockManager;
if-ne p1, v0, :cond_c
const/4 v0, 0x0
return-object v0
:cond_c
const-class v0, Landroid/net/wifi/rtt/WifiRttManager;
if-ne p1, v0, :cond_12
const/4 v0, 0x0
return-object v0
:cond_12
invoke-direct {p0, p1}, Landroid/app/ContextImpl;->vinixRttFallbackClass(Ljava/lang/Class;)Ljava/lang/Object;
move-result-object v0
return-object v0
.end method'
}

fn verify_context(old string, patched string, raw bool) {
	before, after := methods(old), methods(patched)
	assert before.len == after.len && before[signature] != after[signature]
	for name, body in before { if name != signature { assert after[name] == body, 'changed retained method: ' + name } }
	assert old.replace(before[signature], '') == patched.replace(after[signature], ''), 'changed ContextImpl metadata'
	if raw { assert patched == old.replace(before[signature], before[signature].replace('.registers 3', '.registers 3' + guard())) }
	else { assert norm(after[signature]) == canonical_method(), 'DEX typed-service instructions or targets differ' }
}

fn main() {
	assert os.args.len in [2, 3], 'WORK [--roundtrip]'
	work := os.args[1]
	added := androidtools.framework_cross_profile_apps_classes()
	assert added.keys() == [manager] && added[manager] == manager_source(), 'exact memberless class required'
	if os.args.len == 3 {
		assert os.args[2] == '--roundtrip'
		baseline_files := os.walk_ext(work + '/baseline-roundtrip', '.smali').sorted()
		patched_files := os.walk_ext(work + '/patched-roundtrip', '.smali').sorted()
		assert baseline_files.len == 2106 && patched_files.len == 2107
		for path in baseline_files {
			name := path.all_after(work + '/baseline-roundtrip/')
			other := work + '/patched-roundtrip/' + name
			assert os.is_file(other), 'DEX removed class: ' + name
			if name != target { assert digest(path)! == digest(other)!, 'DEX changed neighbor: ' + name; continue }
			verify_context(os.read_file(path)!, os.read_file(other)!, false)
		}
		assert norm(os.read_file(work + '/patched-roundtrip/' + manager + '.smali')!) == norm(manager_source())
		println('CROSS-PROFILE-APPS-ROUNDTRIP-PASS classes=2107 one-guard memberless-type all-2105-neighbors-unchanged')
		return
	}
	root := work + '/proof'
	path := root + '/' + target
	class_path := root + '/' + manager + '.smali'
	old := os.read_file(path)!
	getter := methods(old)[signature]
	patched := androidtools.framework_cross_profile_apps_source(old)!
	verify_context(old, patched, true)
	mut neighbors := map[string]string{}
	for item in os.walk_ext(root, '.smali') { if item != path { neighbors[item] = digest(item)! } }
	mut invalids := [patched,
		old.replace('.class public final Landroid/app/ContextImpl;', '.class public Landroid/app/ContextImpl;'),
		old.replace('.class public final Landroid/app/ContextImpl;', '.class public final Lwrong/ContextImpl;'),
		old + '\n.class public final Landroid/app/ContextImpl;\n',
		old.replace('.super Landroid/content/Context;', '.super Ljava/lang/Object;'),
		old + '\n.super Landroid/content/Context;\n',
		old.replace(getter, ''), old + '\n' + getter,
		old.replace(getter, getter.replace('.method public ', '.method private ')),
		old.replace(getter, getter.replace('.method public ', '.method public static ')),
		old.replace(getter, getter.replace('.method public ', '.method public native ')),
		old.replace(getter, getter.replace('.registers 3', '.registers 4')),
		old.replace(getter, getter.replace('.end method', '')),
		old.replace(getter, getter.replace('PersistentDataBlockManager;', 'OtherManager;')),
		old.replace(getter, getter.replace('WifiRttManager;', 'WifiManager;')),
		old.replace(getter, getter.replace('if-ne p1, v0', 'if-eq p1, v0')),
		old.replace(getter, getter.replace('vinixRttFallbackClass(', 'wrongFallbackClass(')),
		old.replace(getter, getter.replace('invoke-direct {p0, p1}', 'invoke-direct {p1, p0}')),
		old.replace(getter, getter.replace('move-result-object v0', 'move-result v0')),
		old.replace(getter, getter.replace('const/4 v0, 0x0', 'const/4 v0, 0x1')),
		old.replace(getter, getter.replace(':cond_6', ':changed_branch')),
		old.replace(getter, getter.replace(':cond_c', ':cond_6'))]
	for instruction in getter.split_into_lines().map(it.trim_space()).filter(it != '' && !it.starts_with('.method ') && it != '.end method') {
		invalids << old.replace(getter, getter.replace(instruction, '# removed retained instruction'))
	}
	for invalid in invalids {
		assert invalid != old, 'negative mutation did not match baseline'
		os.write_file(path, invalid)!
		mut refused := false
		androidtools.framework_cross_profile_apps(root) or { refused = true }
		assert refused && os.read_file(path)! == invalid && !os.exists(class_path) && !os.is_link(class_path), 'refusal must precede writes'
	}
	// Exercise the exact retained pre-assembly schema as a second valid input.
	raw_getter := getter.replace(':cond_6', ':vinix_persistent_data_other').replace(':cond_c', ':cond_6')
	assert raw_getter != getter
	raw := old.replace(getter, raw_getter)
	assert androidtools.framework_cross_profile_apps_source(raw)! == raw.replace(raw_getter, raw_getter.replace('.registers 3', '.registers 3' + guard()))
	os.write_file(path, old)!
	os.mkdir_all(os.dir(class_path))!
	sentinel := 'owned collision fixture\x00\xff'
	os.write_file(class_path, sentinel)!
	mut refused_file := false
	androidtools.framework_cross_profile_apps(root) or { refused_file = true }
	assert refused_file && os.read_file(path)! == old && os.read_file(class_path)! == sentinel
	os.rm(class_path)!
	os.mkdir(class_path)!
	os.write_file(class_path + '/sentinel', sentinel)!
	mut refused_directory := false
	androidtools.framework_cross_profile_apps(root) or { refused_directory = true }
	assert refused_directory && os.read_file(path)! == old && os.ls(class_path)! == ['sentinel']
	assert os.read_file(class_path + '/sentinel')! == sentinel
	os.rm(class_path + '/sentinel')!
	os.rmdir(class_path)!
	os.symlink('absent-manager-target', class_path)!
	mut refused_link := false
	androidtools.framework_cross_profile_apps(root) or { refused_link = true }
	assert refused_link && os.read_file(path)! == old && os.is_link(class_path) && os.readlink(class_path)! == 'absent-manager-target'
	os.rm(class_path)!
	androidtools.framework_cross_profile_apps(root)!
	assert os.read_file(path)! == patched && os.read_file(class_path)! == manager_source()
	for item, pin in neighbors { assert digest(item)! == pin, 'provider changed neighbor: ' + item }
	assert os.walk_ext(root, '.smali').len == 2107
	println('CROSS-PROFILE-APPS-SOURCE-PASS rejected=' + (invalids.len + 3).str() + ' one-guard memberless-type retained-methods all-neighbors')
}
