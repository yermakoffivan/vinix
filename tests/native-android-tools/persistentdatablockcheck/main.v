// SPDX-License-Identifier: GPL-2.0-or-later
// One absent-service guard, one memberless class and unchanged dependencies.
module main

import androidtools
import os

const context = 'android/app/ContextImpl'
const manager = 'android/service/persistentdata/PersistentDataBlockManager'
const signature = 'getSystemService(Ljava/lang/Class;)Ljava/lang/Object;'
const classes = [context, 'android/content/Context', 'android/content/ContextWrapper',
	'android/os/UserManager', 'android/os/PersistableBundle', 'android/os/BaseBundle', 'android/util/ArrayMap']

fn methods(source string) map[string]string {
	mut result := map[string]string{}
	for block in source.split('.method ')[1..] {
		name := block.all_before('\n').all_after_last(' ')
		assert name !in result && block.contains('.end method')
		result[name] = '.method ' + block.all_before('.end method') + '.end method'
	}
	return result
}

fn norm(source string) string {
	return source.split_into_lines().map(it.trim_space()).filter(it != '' && !it.starts_with('#')).join('\n')
}

// DEX changes branch label names to instruction offsets. Keep the complete
// instruction order and targets while assigning declaration-order label names.
fn labels(source string) string {
	lines := norm(source).split_into_lines()
	mut names := map[string]string{}
	for line in lines {
		if line.starts_with(':') {
			assert line !in names
			names[line] = ':label_' + names.len.str()
		}
	}
	mut result := []string{}
	for line in lines {
		mut parts := line.split(' ')
		for i, part in parts { if replacement := names[part] { parts[i] = replacement } }
		result << parts.join(' ')
	}
	return result.join('\n')
}

fn guard() string {
	return '\nconst-class v0, Landroid/service/persistentdata/PersistentDataBlockManager;\n' +
		'if-ne p1, v0, :vinix_persistent_data_other\nconst/4 v0, 0x0\nreturn-object v0\n:vinix_persistent_data_other\n'
}

fn expected_method() string {
	return '.method public ' + signature + '\n.registers 3' + guard() +
		'const-class v0, Landroid/net/wifi/rtt/WifiRttManager;\nif-ne p1, v0, :cond_6\n' +
		'const/4 v0, 0x0\nreturn-object v0\n:cond_6\n' +
		'invoke-direct {p0, p1}, Landroid/app/ContextImpl;->vinixRttFallbackClass(Ljava/lang/Class;)Ljava/lang/Object;\n' +
		'move-result-object v0\nreturn-object v0\n.end method'
}

fn manager_source() string {
	return '.class public Landroid/service/persistentdata/PersistentDataBlockManager;\n.super Ljava/lang/Object;\n'
}

fn verify_context(old string, patched string, raw bool) {
	before, after := methods(old), methods(patched)
	assert before.len == after.len && before[signature] != after[signature]
	assert labels(after[signature]) == labels(expected_method()), 'typed-service branch/instruction sequence differs'
	for name, source in before { if name != signature { assert after[name] == source, name } }
	assert norm(patched.replace(after[signature], '')) == norm(old.replace(before[signature], '')), 'ContextImpl metadata changed'
	if raw { assert patched == old.replace(before[signature], before[signature].replace('.registers 3', '.registers 3' + guard())) }
}

fn inventory(root string, relative string) ![]string {
	mut result := []string{}
	for name in os.ls(root + '/' + relative)! {
		key := if relative == '' { name } else { relative + '/' + name }
		path := root + '/' + key
		assert !os.is_link(path), 'unexpected proof symlink'
		kind := os.lstat(path)!.get_filetype()
		if kind == .directory { result << inventory(root, key)! }
		else { assert kind == .regular; result << key }
	}
	result.sort()
	return result
}

fn unchanged(root string, originals map[string]string, selected string, replacement string) ! {
	for name, source in originals {
		expected := if name == selected { replacement } else { source }
		assert os.read_file(root + '/' + name + '.smali')! == expected, 'refusal changed ' + name
	}
}

fn main() {
	assert os.args.len in [2, 3], 'WORK [--roundtrip]'
	work := os.args[1]
	added := androidtools.framework_persistent_data_block_classes()
	assert added.keys() == [manager] && added[manager] == manager_source(), 'exact memberless class factory required'
	if os.args.len == 3 {
		assert os.args[2] == '--roundtrip'
		assert inventory(work + '/baseline-roundtrip', '')! == classes.map(it + '.smali').sorted()
		assert inventory(work + '/patched-roundtrip', '')! == [...classes, manager].map(it + '.smali').sorted()
		for name in classes {
			old := os.read_file(work + '/baseline-roundtrip/' + name + '.smali')!
			patched := os.read_file(work + '/patched-roundtrip/' + name + '.smali')!
			if name == context { verify_context(old, patched, false) }
			else { assert patched == old, name + ' changed through DEX' }
		}
		assert norm(os.read_file(work + '/patched-roundtrip/' + manager + '.smali')!) == norm(manager_source())
		return
	}
	root := work + '/proof'
	path := root + '/' + context + '.smali'
	class_path := root + '/' + manager + '.smali'
	mut originals := map[string]string{}
	for name in classes { originals[name] = os.read_file(root + '/' + name + '.smali')! }
	old := originals[context]
	patched := androidtools.framework_persistent_data_block_source(old)!
	verify_context(old, patched, true)
	getter := methods(old)[signature]
	invalids := [patched,
		old.replace('.class public final Landroid/app/ContextImpl;', '.class public final Lwrong/ContextImpl;'),
		old.replace('.class public final Landroid/app/ContextImpl;', '.class public Landroid/app/ContextImpl;'),
		old.replace('.super Landroid/content/Context;', '.super Ljava/lang/Object;'),
		old.replace('.method public ' + signature, '.method private ' + signature),
		old.replace('.method public ' + signature, '.method public static ' + signature),
		old.replace('.method public ' + signature, '.method public native ' + signature),
		old.replace(signature, 'getSystemService(Ljava/lang/Object;)Ljava/lang/Object;'),
		old.replace(signature, 'getSystemService(Ljava/lang/Class;)Landroid/content/Context;'),
		old + '\n' + getter,
		old.replace(getter, ''),
		old.replace(getter, getter.replace('.end method', '')),
		old.replace(getter, getter.replace('.registers 3', '.registers 4')),
		old.replace(getter, getter.replace('WifiRttManager;', 'WifiManager;')),
		old.replace(getter, getter.replace('if-ne p1, v0', 'if-eq p1, v0')),
		old.replace(getter, getter.replace('vinixRttFallbackClass(', 'vinixPolicyFallbackClass(')),
		old.replace(getter, getter.replace('invoke-direct {p0, p1}', 'invoke-direct {p1, p0}')),
		old.replace(getter, getter.replace('move-result-object v0', 'move-result v0')),
		old.replace(getter, getter.replace('const/4 v0, 0x0', 'const/4 v0, 0x1')),
		old.replace(getter, getter.replace('    return-object v0', '    const/4 v0, 1\n    return-object v0')),
	]
	for invalid in invalids {
		assert invalid != old, 'negative mutation did not match baseline'
		os.write_file(path, invalid)!
		mut refused := false
		androidtools.framework_persistent_data_block(root) or { refused = true }
		assert refused && !os.exists(class_path) && !os.is_link(class_path)
		unchanged(root, originals, context, invalid)!
	}
	os.write_file(path, old)!
	os.mkdir_all(os.dir(class_path))!
	sentinel := 'owned collision fixture\x00\xff'
	os.write_file(class_path, sentinel)!
	mut refused_file := false
	androidtools.framework_persistent_data_block(root) or { refused_file = true }
	assert refused_file && os.read_file(class_path)! == sentinel
	unchanged(root, originals, '', '')!
	os.rm(class_path)!
	os.mkdir(class_path)!
	os.write_file(class_path + '/sentinel', sentinel)!
	mut refused_directory := false
	androidtools.framework_persistent_data_block(root) or { refused_directory = true }
	assert refused_directory && os.is_dir(class_path) && os.ls(class_path)! == ['sentinel']
	assert os.read_file(class_path + '/sentinel')! == sentinel
	unchanged(root, originals, '', '')!
	os.rm(class_path + '/sentinel')!
	os.rmdir(class_path)!
	os.symlink('absent-manager-target', class_path)!
	mut refused_link := false
	androidtools.framework_persistent_data_block(root) or { refused_link = true }
	assert refused_link && os.is_link(class_path) && os.readlink(class_path)! == 'absent-manager-target'
	unchanged(root, originals, '', '')!
	os.rm(class_path)!
	androidtools.framework_persistent_data_block(root)!
	assert os.read_file(path)! == patched && os.read_file(class_path)! == manager_source()
	unchanged(root, originals, context, patched)!
	assert inventory(root, '')! == [...classes, manager].map(it + '.smali').sorted()
	println('PERSISTENT-DATA-BLOCK-SOURCE-PASS changed=1 added=1 memberless-type malformed=' + (invalids.len + 3).str() + ' transactional-refusal retained-service-neighbors')
}
