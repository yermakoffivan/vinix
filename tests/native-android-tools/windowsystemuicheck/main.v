// SPDX-License-Identifier: GPL-2.0-or-later
// Isolated checks for the production one-field LayoutParams extension.
module main

import androidtools
import os

const relative = '/android/view/WindowManager$LayoutParams.smali'
const added_field = '.field public systemUiVisibility:I'

fn methods(source string) map[string]string {
	mut result := map[string]string{}
	for block in source.split('.method ')[1..] {
		signature := block.all_before('\n').all_after_last(' ')
		assert signature !in result && block.contains('.end method')
		result[signature] = '.method ' + block.all_before('.end method') + '.end method'
	}
	return result
}

fn norm(source string) string {
	return source.split_into_lines().map(it.trim_space()).filter(it != '').join('\n')
}

fn main() {
	assert os.args.len in [2, 3], 'WORK [--roundtrip]'
	work := os.args[1]
	if os.args.len == 3 {
		assert os.args[2] == '--roundtrip'
		for name in ['WindowManager$LayoutParams', 'ViewGroup$LayoutParams', 'Window'] {
			old := os.read_file(work + '/baseline-roundtrip/android/view/' + name + '.smali')!
			patched := os.read_file(work + '/patched-roundtrip/android/view/' + name + '.smali')!
			if name == 'WindowManager$LayoutParams' {
				assert patched.count(added_field + '\n') == 1
				assert methods(old) == methods(patched), 'constructors and setTitle changed through DEX'
				assert norm(patched.replace(added_field + '\n', '')) == norm(old), 'roundtrip metadata beyond field changed'
			} else { assert patched == old, name + ' changed' }
		}
		return
	}
	path := work + '/proof' + relative
	old := os.read_file(path)!
	patched := androidtools.framework_window_system_ui_source(old)!
	assert patched == old + '\n' + added_field + '\n', 'field-only source delta required'
	assert methods(old) == methods(patched) && methods(old).len == 3
	init := methods(old)['<init>(IIIII)V']
	invalids := [patched,
		old.replace('.class public Landroid/view/WindowManager$LayoutParams;', '.class public Lwrong/LayoutParams;'),
		old.replace('.super Landroid/view/ViewGroup$LayoutParams;', '.super Ljava/lang/Object;'),
		old.replace('.field public alpha:F', '.field public static alpha:F'),
		old.replace('.field public softInputMode:I', '.field private softInputMode:I'),
		old.replace('.field public x:I', '.field public x:J'),
		old.replace('.field public type:I\n', ''),
		old + '\n.field public unexpected:I\n',
		old + '\n.field public static systemUiVisibility:I\n',
		old + '\n.field public systemUiVisibility:J\n',
		old.replace('.method public setTitle(', '.method private setTitle('),
		old + '\n' + methods(old)['setTitle(Ljava/lang/CharSequence;)V'],
		old.replace('setTitle(Ljava/lang/CharSequence;)V', 'missingTitle(Ljava/lang/CharSequence;)V'),
		old.replace(init, init.replace('    return-void', '    const/4 v0, 1\n    return-void')),
		old.replace(init, init.replace('.registers 7', '.registers 8')),
		old.replace(init, init.replace('invoke-direct {p0, p1, p2}', 'invoke-direct {p0, p2, p1}')),
	]
	for invalid in invalids {
		assert invalid != old, 'negative mutation did not match baseline'
		os.write_file(path, invalid)!
		mut rejected := false
		androidtools.framework_window_system_ui(work + '/proof') or { rejected = true }
		assert rejected && os.read_file(path)! == invalid, 'invalid input accepted or modified'
	}
	os.write_file(path, old)!
	androidtools.framework_window_system_ui(work + '/proof')!
	assert os.read_file(path)! == patched
	println('WINDOW-SYSTEM-UI-SOURCE-PASS changed=0 added=0 fields=1 malformed=' + invalids.len.str() + ' constructors-window-preserved')
}
