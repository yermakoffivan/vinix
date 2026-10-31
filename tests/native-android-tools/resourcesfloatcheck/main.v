// SPDX-License-Identifier: GPL-2.0-or-later
module main

import androidtools
import crypto.sha256
import os

const target = 'android/content/res/Resources.smali'
const signature = 'getFloat(I)F'
const lookup = 'getValue(ILandroid/util/TypedValue;Z)V'

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
	// '#' is part of the resource-error text, so remove whole comment lines only.
	return source.split_into_lines().map(it.trim_space()).filter(it != '' && !it.starts_with('#')).join('\n')
}

fn digest(path string) !string { return sha256.sum(os.read_bytes(path)!).hex() }

fn expected_method() string {
	return '.method public getFloat(I)F
.locals 4
new-instance v0, Landroid/util/TypedValue;
invoke-direct {v0}, Landroid/util/TypedValue;-><init>()V
const/4 v1, 0x1
invoke-virtual {p0, p1, v0, v1}, Landroid/content/res/Resources;->getValue(ILandroid/util/TypedValue;Z)V
iget v1, v0, Landroid/util/TypedValue;->type:I
const/4 v2, 0x4
if-ne v1, v2, :not_float
invoke-virtual {v0}, Landroid/util/TypedValue;->getFloat()F
move-result v0
return v0
:not_float
new-instance v2, Landroid/content/res/Resources$NotFoundException;
new-instance v3, Ljava/lang/StringBuilder;
invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V
const-string v0, "Resource ID #0x"
invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
invoke-static {p1}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;
move-result-object v0
invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
const-string v0, " type #0x"
invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
invoke-static {v1}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;
move-result-object v0
invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
const-string v0, " is not valid"
invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
move-result-object v0
invoke-direct {v2, v0}, Landroid/content/res/Resources$NotFoundException;-><init>(Ljava/lang/String;)V
throw v2
.end method'
}

fn verify_resources(old string, patched string, raw bool) {
	before, after := methods(old), methods(patched)
	assert signature !in before && after.len == before.len + 1
	for name, body in before { assert after[name] == body, 'changed retained method: ' + name }
	expected := if raw { expected_method() } else { expected_method().replace('.locals 4', '.registers 6').replace(':not_float', ':cond_13') }
	assert norm(after[signature]) == expected, 'float getter instructions or ABI differ'
	if raw { assert patched == old + '\n' + expected_method() + '\n', 'only exact method append allowed' }
	else {
		assert norm(patched.replace(after[signature], '')) == norm(old), 'changed Resources metadata'
	}
}

fn main() {
	assert os.args.len in [2, 3], 'WORK [--roundtrip]'
	work := os.args[1]
	if os.args.len == 3 {
		assert os.args[2] == '--roundtrip'
		baseline_files := os.walk_ext(work + '/baseline-roundtrip', '.smali').sorted()
		patched_files := os.walk_ext(work + '/patched-roundtrip', '.smali').sorted()
		assert baseline_files.len == 2107 && patched_files.len == 2107
		for path in baseline_files {
			name := path.all_after(work + '/baseline-roundtrip/')
			other := work + '/patched-roundtrip/' + name
			assert os.is_file(other), 'DEX removed class: ' + name
			if name != target { assert digest(path)! == digest(other)!, 'DEX changed neighbor: ' + name; continue }
			verify_resources(os.read_file(path)!, os.read_file(other)!, false)
		}
		println('RESOURCES-FLOAT-ROUNDTRIP-PASS classes=2107 one-added-method retained-methods all-2106-neighbors-unchanged')
		return
	}
	root := work + '/proof'
	path := root + '/' + target
	old := os.read_file(path)!
	before := methods(old)
	patched := androidtools.framework_resources_float_source(old)!
	verify_resources(old, patched, true)
	mut neighbors := map[string]string{}
	for item in os.walk_ext(root, '.smali') { if item != path { neighbors[item] = digest(item)! } }
	retained := before[lookup]
	mut invalids := [patched,
		old.replace('.class public Landroid/content/res/Resources;', '.class private Landroid/content/res/Resources;'),
		old.replace('.class public Landroid/content/res/Resources;', '.class public Lwrong/Resources;'),
		old + '\n.class public Landroid/content/res/Resources;\n',
		old.replace('.super Ljava/lang/Object;', '.super Lwrong/Parent;'),
		old + '\n.super Ljava/lang/Object;\n',
		old.replace(retained, ''), old + '\n' + retained,
		old.replace(retained, retained.replace('.method public ', '.method private ')),
		old.replace(retained, retained.replace('.method public ', '.method public static ')),
		old.replace(retained, retained.replace('.method public ', '.method public native ')),
		old.replace(retained, retained.replace('.method public ', '.method public abstract ')),
		old.replace(retained, retained.replace('.end method', '')),
		old + '\n.end method\n',
		old.replace(retained, retained.replace(lookup, 'getValue(ILandroid/util/TypedValue;I)V'))]
	for flags in ['private', 'public static', 'public native', 'public final', 'public abstract'] {
		invalids << old + '\n' + expected_method().replace('.method public ' + signature, '.method ' + flags + ' ' + signature) + '\n'
	}
	for invalid in invalids {
		assert invalid != old, 'negative mutation did not match baseline'
		os.write_file(path, invalid)!
		mut refused := false
		androidtools.framework_resources_float(root) or { refused = true }
		assert refused && os.read_file(path)! == invalid, 'refusal must precede writes'
	}
	os.write_file(path, old)!
	androidtools.framework_resources_float(root)!
	assert os.read_file(path)! == patched
	for item, pin in neighbors { assert digest(item)! == pin, 'provider changed neighbor: ' + item }
	assert os.walk_ext(root, '.smali').len == 2107
	println('RESOURCES-FLOAT-SOURCE-PASS rejected=' + invalids.len.str() + ' one-added-method retained-methods metadata all-neighbors')
}
