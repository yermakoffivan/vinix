// SPDX-License-Identifier: GPL-2.0-or-later
module main

import androidtools
import crypto.sha256
import os

const target = 'android/os/UserManager.smali'
const get_signature = 'getUserRestrictions()Landroid/os/Bundle;'
const has_signature = 'hasUserRestriction(Ljava/lang/String;)Z'
const get_method = '.method public getUserRestrictions()Landroid/os/Bundle;\n.locals 1\nnew-instance v0, Landroid/os/Bundle;\ninvoke-direct {v0}, Landroid/os/Bundle;-><init>()V\nreturn-object v0\n.end method'
const has_method = '.method public hasUserRestriction(Ljava/lang/String;)Z\n.locals 1\ninvoke-virtual {p0}, Landroid/os/UserManager;->getUserRestrictions()Landroid/os/Bundle;\nmove-result-object v0\ninvoke-virtual {v0, p1}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;)Z\nmove-result v0\nreturn v0\n.end method'

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

fn normalize(source string) string {
	return source.split_into_lines().map(it.trim_space()).filter(it != '').join('\n')
}

fn main() {
	assert os.args.len in [2, 3], 'WORK [--roundtrip]'
	work := os.args[1]
	old := os.read_file(work + '/baseline/' + target)!
	patched := androidtools.framework_user_restrictions_source(old)!
	assert patched == old + '\n' + get_method + '\n\n' + has_method + '\n', 'only exact snapshot and virtual boolean methods may be appended'
	before, after := methods(old), methods(patched)
	assert get_signature !in before && has_signature !in before && after.len == before.len + 2
	for name, body in before { assert after[name] == body, 'existing method changed: ' + name }
	assert after[get_signature] == get_method && after[has_signature] == has_method
	assert old.split_into_lines().filter(it.starts_with('.field ')) == patched.split_into_lines().filter(it.starts_with('.field '))
	if os.args.len == 3 {
		assert os.args[2] == '--roundtrip'
		baseline_files := os.walk_ext(work + '/baseline-roundtrip', '.smali').sorted()
		patched_files := os.walk_ext(work + '/patched-roundtrip', '.smali').sorted()
		assert baseline_files.len == patched_files.len && baseline_files.len > 1
		for path in baseline_files {
			name := path.all_after(work + '/baseline-roundtrip/')
			other := work + '/patched-roundtrip/' + name
			assert os.is_file(other), 'DEX removed class: ' + name
			if name != target { assert digest(path)! == digest(other)!, 'DEX changed neighbor: ' + name; continue }
			original := os.read_file(path)!
			roundtrip := os.read_file(other)!
			original_methods, final_methods := methods(original), methods(roundtrip)
			assert final_methods.len == original_methods.len + 2
			for method_name, body in original_methods {
				assert final_methods[method_name] == body, 'DEX changed retained method: ' + method_name
			}
			assert original.split_into_lines().filter(it.starts_with('.field ')) == roundtrip.split_into_lines().filter(it.starts_with('.field '))
			assert normalize(final_methods[get_signature]) == get_method.replace('.locals 1', '.registers 2'), 'DEX changed snapshot instructions or flags'
			assert normalize(final_methods[has_signature]) == has_method.replace('.locals 1', '.registers 3'), 'DEX changed virtual query instructions or flags'
		}
		println('USER-RESTRICTIONS-ROUNDTRIP-PASS classes=' + baseline_files.len.str() + ' all-neighbors-unchanged')
		return
	}
	mut neighbors := map[string]string{}
	for path in os.walk_ext(work + '/proof', '.smali') {
		if path != work + '/proof/' + target { neighbors[path] = digest(path)! }
	}
	app_method := before['getApplicationRestrictions(Ljava/lang/String;)Landroid/os/Bundle;']
	mut invalids := [patched,
		old.replace('.class public Landroid/os/UserManager;', '.class private Landroid/os/UserManager;'),
		old.replace('.class public Landroid/os/UserManager;', '.class public Lwrong/UserManager;'),
		old + '\n.class public Landroid/os/UserManager;\n',
		old.replace('.super Ljava/lang/Object;', '.super Lwrong/Parent;'),
		old + '\n.field private policy:I\n',
		old + '\n# getUserRestrictions(\n', old + '\n# hasUserRestriction(\n',
		old + '\n' + get_method + '\n', old + '\n' + has_method + '\n',
		old.replace(app_method, app_method.replace('new-instance v0, Landroid/os/Bundle;', 'const/4 v0, 0x0')),
		old.replace(app_method, app_method.replace('.registers 3', '.registers 4')),
		old.replace(app_method, app_method.replace('return-object v0', 'const/4 v0, 0x0\nreturn-object v0'))]
	for _, body in before {
		invalids << old.replace(body, '')
		invalids << old + '\n' + body
		invalids << old.replace(body, body.replace('.method public ', '.method private '))
		invalids << old.replace(body, body.replace('.end method', ''))
	}
	path := work + '/proof/' + target
	for invalid in invalids {
		assert invalid != old, 'negative mutation must change input'
		os.write_file(path, invalid)!
		mut refused := false
		androidtools.framework_user_restrictions(work + '/proof') or { refused = true }
		assert refused && os.read_file(path)! == invalid, 'refusal must precede mutation'
	}
	// Full extension runs before DEX assembly and uses .locals for this method.
	generator_form := old.replace(app_method, app_method.replace('.registers 3', '.locals 1'))
	assert generator_form != old
	assert androidtools.framework_user_restrictions_source(generator_form)! == generator_form + '\n' + get_method + '\n\n' + has_method + '\n'
	os.write_file(path, old)!
	androidtools.framework_user_restrictions(work + '/proof')!
	assert os.read_file(path)! == patched
	for neighbor_path, pin in neighbors { assert digest(neighbor_path)! == pin, 'provider changed neighbor: ' + neighbor_path }
	println('USER-RESTRICTIONS-SOURCE-PASS rejected=' + invalids.len.str() + ' fresh-snapshot virtual-query retained-members all-neighbors')
}
