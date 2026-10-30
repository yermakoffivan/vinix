// SPDX-License-Identifier: GPL-2.0-or-later
// Five additive attribute-dispatch methods; all preceding class bytes survive.
module main

import androidtools
import os

const window_class = 'android/view/Window'
const callback_class = 'android/view/Window$Callback'
const activity_class = 'android/app/Activity'
const dialog_class = 'android/app/Dialog'
const params_class = 'android/view/WindowManager$LayoutParams'
const classes = [window_class, callback_class, activity_class, dialog_class, params_class]
const params_type = 'Landroid/view/WindowManager$LayoutParams;'

struct Refusal {
	owner string
	label string
	source string
}

fn methods(source string) map[string]string {
	mut result := map[string]string{}
	for block in source.split('\n.method ')[1..] {
		header := block.all_before('\n')
		name := header.all_after_last(' ')
		assert name !in result && block.contains('\n.end method'), 'unique complete method required'
		result[name] = '.method ' + block.all_before('\n.end method') + '\n.end method'
	}
	return result
}

fn norm(source string) string {
	return source.split_into_lines().map(it.all_before('#').trim_space()).filter(it != '').join('\n')
}

fn canonical(source string) string {
	lines := norm(source).split_into_lines()
	mut labels := map[string]string{}
	for line in lines { if line.starts_with(':') { labels[line] = ':label_' + labels.len.str() } }
	mut result := []string{}
	for line in lines {
		if line.starts_with('.locals ') {
			// Every added concrete method has an instance and one single-word argument.
			result << '.registers ' + (line.all_after(' ').int() + 2).str()
			continue
		}
		mut parts := line.split(' ')
		for i, part in parts { if replacement := labels[part] { parts[i] = replacement } }
		result << parts.join(' ')
	}
	return result.join('\n')
}

fn expected(owner string) map[string]string {
	return match owner {
		window_class {
			{
				'setWindowAnimations(I)V': '.method public setWindowAnimations(I)V\n.locals 1\ninvoke-virtual {p0}, Landroid/view/Window;->getAttributes()${params_type}\nmove-result-object v0\niput p1, v0, ${params_type}->windowAnimations:I\ninvoke-virtual {p0, v0}, Landroid/view/Window;->dispatchWindowAttributesChanged(${params_type})V\nreturn-void\n.end method'
				'dispatchWindowAttributesChanged(${params_type})V': '.method protected dispatchWindowAttributesChanged(${params_type})V\n.locals 1\ninvoke-virtual {p0}, Landroid/view/Window;->getCallback()Landroid/view/Window$Callback;\nmove-result-object v0\nif-eqz v0, :done\ninvoke-interface {v0, p1}, Landroid/view/Window$Callback;->onWindowAttributesChanged(${params_type})V\n:done\nreturn-void\n.end method'
			}
		}
		callback_class {
			{'onWindowAttributesChanged(${params_type})V': '.method public abstract onWindowAttributesChanged(${params_type})V\n.end method'}
		}
		activity_class {
			{'onWindowAttributesChanged(${params_type})V': '.method public onWindowAttributesChanged(${params_type})V\n.locals 3\ninvoke-virtual {p0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;\nmove-result-object v0\nif-eqz v0, :done\ninvoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;\nmove-result-object v1\nif-eqz v1, :done\ninvoke-virtual {v1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;\nmove-result-object v2\nif-eqz v2, :done\ninvoke-virtual {p0}, Landroid/app/Activity;->getWindowManager()Landroid/view/WindowManager;\nmove-result-object v0\ninvoke-interface {v0, v1, p1}, Landroid/view/WindowManager;->updateViewLayout(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V\n:done\nreturn-void\n.end method'}
		}
		dialog_class {
			{'onWindowAttributesChanged(${params_type})V': '.method public onWindowAttributesChanged(${params_type})V\n.locals 2\ninvoke-virtual {p0}, Landroid/app/Dialog;->isShowing()Z\nmove-result v0\nif-eqz v0, :done\ninvoke-virtual {p0}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;\nmove-result-object v0\nif-eqz v0, :done\ninvoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;\nmove-result-object v1\nif-eqz v1, :done\ninvoke-virtual {v0}, Landroid/view/Window;->getWindowManager()Landroid/view/WindowManager;\nmove-result-object v0\ninvoke-interface {v0, v1, p1}, Landroid/view/WindowManager;->updateViewLayout(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V\n:done\nreturn-void\n.end method'}
		}
		else { map[string]string{} }
	}
}

fn transform(owner string, source string) !string {
	return match owner {
		window_class { androidtools.framework_window_animations_source(source)! }
		callback_class { androidtools.framework_window_animations_callback_source(source)! }
		activity_class { androidtools.framework_window_animations_activity_source(source)! }
		dialog_class { androidtools.framework_window_animations_dialog_source(source)! }
		else { source }
	}
}

fn shape(owner string, old string, patched string) {
	if owner == params_class { assert patched == old; return }
	assert patched.starts_with(old), 'existing owner bytes must remain an exact prefix: ' + owner
	before, after := methods(old), methods(patched)
	additions := expected(owner)
	assert after.len == before.len + additions.len
	for name, body in before { assert after[name] == body, 'retained method changed: ' + owner + '.' + name }
	for name, body in additions {
		assert name !in before && name in after
		assert norm(after[name]) == norm(body), 'new contract instructions/flags differ: ' + owner + '.' + name
	}
	assert patched.split_into_lines().filter(it.starts_with('.field ')) == old.split_into_lines().filter(it.starts_with('.field '))
}

fn refusal_cases(originals map[string]string) []Refusal {
	mut cases := []Refusal{}
	for owner in classes[..4] {
		old := originals[owner]
		declaration := old.split_into_lines().filter(it.starts_with('.class '))[0]
		parent := old.split_into_lines().filter(it.starts_with('.super '))[0]
		cases << Refusal{owner, 'wrong-class-' + owner, old.replace(declaration, declaration.replace('L' + owner + ';', 'Lwrong/Owner;'))}
		cases << Refusal{owner, 'duplicate-class-' + owner, old + '\n' + declaration + '\n'}
		cases << Refusal{owner, 'wrong-parent-' + owner, old.replace(parent, '.super Lwrong/Parent;')}
		cases << Refusal{owner, 'already-patched-' + owner, transform(owner, old) or { panic(err) }}
		for marker in ['setWindowAnimations(', 'dispatchWindowAttributesChanged(', 'onWindowAttributesChanged('] {
			cases << Refusal{owner, 'prior-api-' + owner + '-' + marker, old + '\n# ' + marker + '\n'}
		}
	}
	for owner, signatures in {
		window_class: ['getAttributes()${params_type}', 'getCallback()Landroid/view/Window$Callback;', 'getDecorView()Landroid/view/View;']
		activity_class: ['getWindow()Landroid/view/Window;', 'getWindowManager()Landroid/view/WindowManager;']
		dialog_class: ['getWindow()Landroid/view/Window;', 'isShowing()Z']
	} {
		old := originals[owner]
		for signature in signatures {
			body := methods(old)[signature]
			assert body != ''
			cases << Refusal{owner, 'missing-' + owner + '.' + signature, old.replace(body, '')}
			cases << Refusal{owner, 'duplicate-' + owner + '.' + signature, old + '\n' + body + '\n'}
			cases << Refusal{owner, 'unterminated-' + owner + '.' + signature, old.replace(body, body.replace('.end method', ''))}
			cases << Refusal{owner, 'static-' + owner + '.' + signature, old.replace(body, body.replace('.method public ', '.method public static '))}
			if !(owner == activity_class && signature.starts_with('getWindowManager')) && !(owner == dialog_class && signature == 'isShowing()Z') {
				cases << Refusal{owner, 'body-registers-' + owner + '.' + signature, old.replace(body, body.replace('.registers 2', '.registers 3'))}
				cases << Refusal{owner, 'body-result-' + owner + '.' + signature, old.replace(body, body.replace('return-object v0', 'return-object p0'))}
			}
		}
	}
	for owner in [activity_class, dialog_class] {
		old := originals[owner]
		line := '.implements Landroid/view/Window$Callback;'
		cases << Refusal{owner, 'missing-callback-interface-' + owner, old.replace(line, '')}
		cases << Refusal{owner, 'duplicate-callback-interface-' + owner, old + '\n' + line + '\n'}
	}
	old := originals[params_class]
	line := '.field public windowAnimations:I'
	for label, replacement in {'missing': '', 'private': '.field private windowAnimations:I', 'wrong-type': '.field public windowAnimations:J'} {
		cases << Refusal{params_class, label + '-animation-field', old.replace(line, replacement)}
	}
	cases << Refusal{params_class, 'duplicate-animation-field', old + '\n' + line + '\n'}
	return cases
}

fn assert_unchanged(root string, originals map[string]string, selected string, replacement string) ! {
	for owner in classes {
		expected_source := if owner == selected { replacement } else { originals[owner] }
		assert os.read_file(root + '/' + owner + '.smali')! == expected_source, 'failure mutated ' + owner
	}
}

fn main() {
	assert os.args.len in [2, 3], 'WORK [--roundtrip]'
	work := os.args[1]
	mut originals := map[string]string{}
	mut patched := map[string]string{}
	mut added_count := 0
	for owner in classes {
		originals[owner] = os.read_file(work + '/baseline/' + owner + '.smali')!
		patched[owner] = transform(owner, originals[owner])!
		shape(owner, originals[owner], patched[owner])
		added_count += expected(owner).len
	}
	assert added_count == 5
	if os.args.len == 3 {
		assert os.args[2] == '--roundtrip'
		for owner in classes {
			before := os.read_file(work + '/baseline-roundtrip/' + owner + '.smali')!
			after := os.read_file(work + '/patched-roundtrip/' + owner + '.smali')!
			if owner == params_class { assert before == after; continue }
			old_methods, new_methods := methods(before), methods(after)
			assert new_methods.len == old_methods.len + expected(owner).len
			for name, body in old_methods { assert new_methods[name] == body, 'DEX altered retained method: ' + owner + '.' + name }
			for name, body in expected(owner) { assert canonical(new_methods[name]) == canonical(body), 'DEX altered added method: ' + owner + '.' + name }
			assert norm(after.split('\n.method ')[0]) == norm(before.split('\n.method ')[0]), 'DEX class metadata changed: ' + owner
		}
		return
	}
	root := work + '/proof'
	cases := refusal_cases(originals)
	for item in cases {
		assert item.source != originals[item.owner], 'negative mutation did not match: ' + item.label
		path := root + '/' + item.owner + '.smali'
		os.write_file(path, item.source)!
		mut refused := false
		androidtools.framework_window_animations(root) or { refused = true }
		assert refused, 'bad input accepted: ' + item.label
		assert_unchanged(root, originals, item.owner, item.source)!
		os.write_file(path, originals[item.owner])!
	}
	for absent in classes {
		path := root + '/' + absent + '.smali'
		os.rm(path)!
		mut refused := false
		androidtools.framework_window_animations(root) or { refused = true }
		assert refused && !os.exists(path), 'missing owner accepted or created: ' + absent
		for owner in classes { if owner != absent { assert os.read_file(root + '/' + owner + '.smali')! == originals[owner] } }
		os.write_file(path, originals[absent])!
	}
	androidtools.framework_window_animations(root)!
	for owner in classes { assert os.read_file(root + '/' + owner + '.smali')! == patched[owner] }
	println('WINDOW-ANIMATIONS-SOURCE-PASS refusals=' + (cases.len + classes.len).str() + ' five-additive-methods unchanged-layout-params')
}
