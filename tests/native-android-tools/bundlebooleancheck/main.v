// SPDX-License-Identifier: GPL-2.0-or-later
module main

import androidtools
import crypto.sha256
import os

const target = 'android/os/BaseBundle.smali'
const signature = 'getBoolean(Ljava/lang/String;Z)Z'
const old_call = 'invoke-virtual {p1, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z'
const new_call = 'invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z'

fn methods(source string) map[string]string {
	mut result := map[string]string{}
	for block in source.split('.method ')[1..] {
		name := block.all_before('\n').all_after_last(' ')
		assert name !in result && block.contains('.end method'), 'unique complete method required'
		result[name] = '.method ' + block.all_before('.end method') + '.end method'
	}
	return result
}

fn digest(path string) !string { return sha256.sum(os.read_bytes(path)!).hex() }

fn raw_labels(source string) string {
	return source.replace(':cond_3a', ':cond_38').replace(':cond_39', ':cond_37')
		.replace(':goto_39', ':goto_37').replace(':try_start_3c', ':try_start_3a')
		.replace(':try_end_43', ':try_end_41').replace(':catch_45', ':catch_43')
}

fn main() {
	assert os.args.len in [2, 3], 'WORK [--roundtrip]'
	work := os.args[1]
	old := os.read_file(work + '/baseline/' + target)!
	before := methods(old)
	retained := before[signature]
	assert retained.count(old_call) == 1 && !retained.contains(new_call)
	updated := retained.replace(old_call, new_call)
	patched := androidtools.framework_bundle_boolean_source(old)!
	assert patched == old.replace(retained, updated), 'only one exact invoke operand order may change'
	after := methods(patched)
	assert after.len == before.len, 'no method may be added or removed'
	for name, body in before {
		expected := if name == signature { updated } else { body }
		assert after[name] == expected, 'unreviewed method change: ' + name
	}
	assert old.split_into_lines().filter(it.starts_with('.field ')) == patched.split_into_lines().filter(it.starts_with('.field '))
	if os.args.len == 3 {
		assert os.args[2] == '--roundtrip'
		baseline_files := os.walk_ext(work + '/baseline-roundtrip', '.smali').sorted()
		patched_files := os.walk_ext(work + '/patched-roundtrip', '.smali').sorted()
		assert baseline_files.len == patched_files.len && baseline_files.len == 2106
		for path in baseline_files {
			name := path.all_after(work + '/baseline-roundtrip/')
			other := work + '/patched-roundtrip/' + name
			assert os.is_file(other), 'DEX removed class: ' + name
			if name != target { assert digest(path)! == digest(other)!, 'DEX changed neighbor: ' + name; continue }
			original := os.read_file(path)!
			roundtrip := os.read_file(other)!
			original_methods, final_methods := methods(original), methods(roundtrip)
			assert final_methods.len == original_methods.len
			for method_name, body in original_methods {
				expected := if method_name == signature { body.replace(old_call, new_call) } else { body }
				assert final_methods[method_name] == expected, 'DEX changed more than the one operand pair: ' + method_name
			}
			assert original.split_into_lines().filter(it.starts_with('.field ')) == roundtrip.split_into_lines().filter(it.starts_with('.field '))
		}
		println('BUNDLE-BOOLEAN-ROUNDTRIP-PASS classes=' + baseline_files.len.str() + ' exact-one-instruction all-neighbors-unchanged')
		return
	}
	mut neighbors := map[string]string{}
	for path in os.walk_ext(work + '/proof', '.smali') {
		if path != work + '/proof/' + target { neighbors[path] = digest(path)! }
	}
	mut invalids := [patched,
		old.replace('.class public Landroid/os/BaseBundle;', '.class private Landroid/os/BaseBundle;'),
		old.replace('.class public Landroid/os/BaseBundle;', '.class public Lwrong/BaseBundle;'),
		old + '\n.class public Landroid/os/BaseBundle;\n',
		old.replace('.super Ljava/lang/Object;', '.super Lwrong/Parent;'),
		old.replace(retained, ''), old + '\n' + retained,
		old.replace(retained, retained.replace('.method public ', '.method private ')),
		old.replace(retained, retained.replace('.registers 10', '.registers 11')),
		old.replace(retained, retained.replace('.end method', '')),
		old.replace(retained, retained.replace(old_call, '')),
		old.replace(retained, retained.replace(old_call, old_call.replace('p1', 'p2'))),
		old.replace(retained, retained.replace(old_call, old_call + '\n' + old_call)),
		old.replace(retained, retained.replace('com.facebook.sdk.AutoLogAppEventsEnabled', 'changed-key')),
		old.replace(retained, retained.replace('const/4 p2, 0x0', 'const/4 p2, 0x1')),
		old.replace(retained, retained.replace('bundle.getBoolean(', 'changed diagnostic(')),
		old.replace(retained, retained.replace('return p2', 'return p1')),
		old.replace(retained, retained.replace(':cond_3a', ':changed_branch')),
		old.replace(retained, retained.replace('if-eqz v1, :cond_3a', 'if-eqz v1, :cond_38')),
		old.replace(retained, retained.replace(':cond_3a\n', ':cond_38\n')),
		old.replace(retained, retained.replace('Landroid/util/ArrayMap;->get(Ljava/lang/Object;)', 'Lwrong/Map;->get(Ljava/lang/Object;)')),
		old.replace(retained, retained.replace('Landroid/os/BaseBundle;->vinixGetMap()', 'Landroid/os/BaseBundle;->changedMap()'))]
	// Every retained instruction is guarded, including diagnostics, default/cast
	// handling and the existing special-key branch. Rejection precedes writes.
	for instruction in retained.split_into_lines().map(it.trim_space()).filter(it != '' && !it.starts_with('.method ') && it != '.end method') {
		invalids << old.replace(retained, retained.replace(instruction, '# removed retained instruction'))
	}
	path := work + '/proof/' + target
	for invalid in invalids {
		assert invalid != old, 'negative mutation must change input'
		os.write_file(path, invalid)!
		mut refused := false
		androidtools.framework_bundle_boolean(work + '/proof') or { refused = true }
		assert refused && os.read_file(path)! == invalid, 'refusal must precede mutation'
	}
	// The whole-framework generator retains original offsets until assembly.
	// Accept its exact alternate body, preserving those spellings in output.
	raw_method := raw_labels(retained)
	assert raw_method != retained
	raw_source := old.replace(retained, raw_method)
	assert androidtools.framework_bundle_boolean_source(raw_source)! == raw_source.replace(raw_method, raw_method.replace(old_call, new_call))
	os.write_file(path, old)!
	androidtools.framework_bundle_boolean(work + '/proof')!
	assert os.read_file(path)! == patched
	for neighbor_path, pin in neighbors { assert digest(neighbor_path)! == pin, 'provider changed neighbor: ' + neighbor_path }
	println('BUNDLE-BOOLEAN-SOURCE-PASS rejected=' + invalids.len.str() + ' exact-one-instruction retained-members all-neighbors')
}
