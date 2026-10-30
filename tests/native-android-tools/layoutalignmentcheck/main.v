// SPDX-License-Identifier: GPL-2.0-or-later
module main

import androidtools
import crypto.sha256
import os

const target = 'android/text/Layout.smali'
const signature = 'getAlignment()Landroid/text/Layout$Alignment;'
const getter = '.method public final getAlignment()Landroid/text/Layout$Alignment;\n.locals 1\niget-object v0, p0, Landroid/text/Layout;->align:Landroid/text/Layout$Alignment;\nreturn-object v0\n.end method'
const spacing_signature = 'getSpacingAdd()F'
const spacing_getter = '.method public final getSpacingAdd()F\n.locals 1\niget v0, p0, Landroid/text/Layout;->spacing_add:F\nreturn v0\n.end method'

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

fn main() {
	assert os.args.len in [2, 3], 'WORK [--roundtrip]'
	work := os.args[1]
	old := os.read_file(work + '/baseline/' + target)!
	patched := androidtools.framework_layout_alignment_source(old)!
	assert patched == old + '\n' + getter + '\n\n' + spacing_getter + '\n', 'only two exact final getters may be appended'
	before, after := methods(old), methods(patched)
	assert signature !in before && spacing_signature !in before && after.len == before.len + 2
	for name, body in before { assert after[name] == body, 'existing method changed: ' + name }
	assert after[signature] == getter
	assert after[spacing_signature] == spacing_getter
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
			normalized := final_methods[signature].split_into_lines().map(it.trim_space()).filter(it != '').join('\n')
			assert normalized == getter.replace('.locals 1', '.registers 2'), 'DEX changed getter instructions or flags'
			spacing_normalized := final_methods[spacing_signature].split_into_lines().map(it.trim_space()).filter(it != '').join('\n')
			assert spacing_normalized == spacing_getter.replace('.locals 1', '.registers 2'), 'DEX changed spacing getter instructions or flags'
		}
		println('LAYOUT-ALIGNMENT-ROUNDTRIP-PASS classes=' + baseline_files.len.str() + ' all-neighbors-unchanged')
		return
	}
	mut neighbors := map[string]string{}
	for path in os.walk_ext(work + '/proof', '.smali') {
		if path != work + '/proof/' + target { neighbors[path] = digest(path)! }
	}
	constructor_name := '<init>(Ljava/lang/CharSequence;Landroid/text/TextPaint;ILandroid/text/Layout$Alignment;FF)V'
	constructor := before[constructor_name]
	paragraph := before['getParagraphAlignment(I)Landroid/text/Layout$Alignment;']
	legacy_spacing := before['getSpacing_add()F']
	field := '.field private align:Landroid/text/Layout$Alignment;'
	spacing_field := '.field private spacing_add:F'
	store := 'iput-object p4, p0, Landroid/text/Layout;->align:Landroid/text/Layout$Alignment;'
	spacing_store := 'iput p6, p0, Landroid/text/Layout;->spacing_add:F'
	mut invalids := [patched,
		old.replace('.class public Landroid/text/Layout;', '.class private Landroid/text/Layout;'),
		old.replace('.class public Landroid/text/Layout;', '.class public Lwrong/Layout;'),
		old + '\n.class public Landroid/text/Layout;\n',
		old.replace('.super Ljava/lang/Object;', '.super Lwrong/Parent;'),
		old.replace(field, ''), old.replace(field, field.replace('private', 'public')),
		old.replace(field, '.field private align:I'), old + '\n' + field + '\n',
		old.replace(constructor, ''), old + '\n' + constructor,
		old.replace(constructor, constructor.replace('.method protected constructor ', '.method public constructor ')),
		old.replace(constructor, constructor.replace(store, '')),
		old.replace(constructor, constructor.replace(store, store.replace('p4', 'p1'))),
		old.replace(constructor, constructor.replace(store, store + '\n' + store)),
		old.replace(constructor, constructor.replace('.end method', '')),
		old.replace(paragraph, ''), old + '\n' + paragraph,
		old.replace(paragraph, paragraph.replace('.method public ', '.method private ')),
		old.replace(paragraph, paragraph.replace('.registers 3', '.registers 4')),
		old.replace(paragraph, paragraph.replace('iget-object v0, p0, Landroid/text/Layout;->align:Landroid/text/Layout$Alignment;', 'const/4 v0, 0x0')),
		old.replace(paragraph, paragraph.replace('.end method', ''))]
	invalids << [old.replace(spacing_field, ''), old.replace(spacing_field, spacing_field.replace('private', 'public')),
		old.replace(spacing_field, '.field private spacing_add:I'), old + '\n' + spacing_field + '\n',
		old.replace(constructor, constructor.replace(spacing_store, '')),
		old.replace(constructor, constructor.replace(spacing_store, spacing_store.replace('p6', 'p5'))),
		old.replace(constructor, constructor.replace(spacing_store, spacing_store + '\n' + spacing_store)),
		old.replace(legacy_spacing, ''), old + '\n' + legacy_spacing,
		old.replace(legacy_spacing, legacy_spacing.replace('.method public ', '.method private ')),
		old.replace(legacy_spacing, legacy_spacing.replace('.registers 2', '.registers 3')),
		old.replace(legacy_spacing, legacy_spacing.replace('iget v0, p0, Landroid/text/Layout;->spacing_add:F', 'const/4 v0, 0x0')),
		old.replace(legacy_spacing, legacy_spacing.replace('.end method', ''))]
	for text in ['\n# getAlignment(\n', '\n.method public getAlignment()I\n.locals 1\nconst/4 v0, 0x0\nreturn v0\n.end method\n'] {
		invalids << old + text
	}
	for text in ['\n# getSpacingAdd(\n', '\n' + spacing_getter + '\n'] { invalids << old + text }
	path := work + '/proof/' + target
	for invalid in invalids {
		assert invalid != old, 'negative mutation must change input'
		os.write_file(path, invalid)!
		mut refused := false
		androidtools.framework_layout_alignment(work + '/proof') or { refused = true }
		assert refused && os.read_file(path)! == invalid, 'refusal must precede mutation'
	}
	os.write_file(path, old)!
	androidtools.framework_layout_alignment(work + '/proof')!
	assert os.read_file(path)! == patched
	for neighbor_path, pin in neighbors { assert digest(neighbor_path)! == pin, 'provider changed neighbor: ' + neighbor_path }
	println('LAYOUT-ALIGNMENT-SOURCE-PASS rejected=' + invalids.len.str() + ' exact-final-getters retained-members all-neighbors')
}
