// SPDX-License-Identifier: GPL-2.0-or-later
module main

import androidtools
import crypto.sha256
import os

const target = 'android/content/Intent.smali'
const bundle_target = 'android/os/Bundle.smali'

struct Mutation {
	name string
	text string
}

fn digest(path string) !string { return sha256.sum(os.read_bytes(path)!).hex() }

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
	mut text := source.split_into_lines().map(it.trim_space()).filter(it != '' && !it.starts_with('#')).join('\n')
	for index, label in text.split_into_lines().filter(it.starts_with(':')) {
		text = text.replace(label, ':label' + index.str())
	}
	return text
}

// Baksmali may emit conditional and goto aliases at the same destination.
// Preserve every instruction/register/directive and compare only their targets
// by instruction position, refusing duplicate or undefined branch labels.
fn method_norm(source string) !string {
	lines := source.split_into_lines().map(it.trim_space()).filter(it != '' && !it.starts_with('#'))
	mut labels := map[string]string{}
	mut instruction := 0
	for line in lines {
		if line.starts_with(':') {
			if line in labels { return error('duplicate Intent extras label') }
			labels[line] = ':instruction_' + instruction.str()
		} else if !line.starts_with('.') {
			instruction++
		}
	}
	mut result := []string{}
	for line in lines {
		if line.starts_with(':') { continue }
		mut parts := line.split(' ')
		for i, part in parts {
			if target := labels[part] {
				parts[i] = target
			} else if part.starts_with(':') {
				return error('undefined Intent extras label')
			}
		}
		result << parts.join(' ')
	}
	return result.join('\n')
}

fn label_controls() ! {
	canonical := expected()['putExtras(Landroid/content/Intent;)Landroid/content/Intent;']!
	aliased := canonical.replace('goto :label1', 'goto :alias_done').replace(':label1\nreturn-object', ':label1\n:alias_done\nreturn-object')
	assert method_norm(canonical)! == method_norm(aliased)!
	assert method_norm(canonical)! != method_norm(canonical.replace('if-eqz v0, :label1', 'if-eqz v0, :label0'))!
	for invalid in [
		canonical.replace(':label1\nreturn-object', ':label1\n:label1\nreturn-object'),
		canonical.replace('goto :label1', 'goto :missing'),
	] {
		mut refused := false
		method_norm(invalid) or { refused = true }
		assert refused
	}
}

fn expected() map[string]string {
	return {
		'putExtras(Landroid/content/Intent;)Landroid/content/Intent;': '.method public putExtras(Landroid/content/Intent;)Landroid/content/Intent;
.registers 4
iget-object v0, p1, Landroid/content/Intent;->extras:Landroid/os/Bundle;
if-eqz v0, :label1
iget-object v1, p0, Landroid/content/Intent;->extras:Landroid/os/Bundle;
if-nez v1, :label0
new-instance v1, Landroid/os/Bundle;
invoke-direct {v1, v0}, Landroid/os/Bundle;-><init>(Landroid/os/Bundle;)V
iput-object v1, p0, Landroid/content/Intent;->extras:Landroid/os/Bundle;
goto :label1
:label0
invoke-virtual {v1, v0}, Landroid/os/Bundle;->putAll(Landroid/os/Bundle;)V
:label1
return-object p0
.end method'
		'putExtras(Landroid/os/Bundle;)Landroid/content/Intent;':      '.method public putExtras(Landroid/os/Bundle;)Landroid/content/Intent;
.registers 3
iget-object v0, p0, Landroid/content/Intent;->extras:Landroid/os/Bundle;
if-nez v0, :label0
new-instance v0, Landroid/os/Bundle;
invoke-direct {v0}, Landroid/os/Bundle;-><init>()V
iput-object v0, p0, Landroid/content/Intent;->extras:Landroid/os/Bundle;
:label0
invoke-virtual {v0, p1}, Landroid/os/Bundle;->putAll(Landroid/os/Bundle;)V
return-object p0
.end method'
	}
}

fn verify(old string, patched string, raw bool) ! {
	before, after := methods(old), methods(patched)
	wanted := expected()
	assert before.len == after.len, 'Intent ABI changed'
	mut old_metadata, new_metadata := old, patched
	for name, body in before {
		if name !in wanted {
			assert after[name] == body, 'changed retained Intent method: ' + name
			continue
		}
		assert method_norm(after[name])! == method_norm(wanted[name])!, 'Intent extras contract differs'
		old_metadata = old_metadata.replace(body, '<' + name + '>')
		new_metadata = new_metadata.replace(after[name], '<' + name + '>')
	}
	if raw {
		assert old_metadata == new_metadata, 'Intent metadata changed'
	} else {
		assert norm(old_metadata) == norm(new_metadata), 'Intent DEX metadata changed'
	}
}

fn main() {
	assert os.args.len in [2, 3], 'WORK [--roundtrip]'
	label_controls()!
	work := os.args[1]
	if os.args.len == 3 {
		assert os.args[2] == '--roundtrip'
		before := os.walk_ext(work + '/baseline-roundtrip', '.smali').sorted()
		after := os.walk_ext(work + '/patched-roundtrip', '.smali').sorted()
		assert before.len == 2108 && after.len == 2108
		for path in before {
			name := path.all_after(work + '/baseline-roundtrip/')
			other := work + '/patched-roundtrip/' + name
			assert os.is_file(other)
			if name == target {
				verify(os.read_file(path)!, os.read_file(other)!, false)!
			} else {
				assert digest(path)! == digest(other)!, 'DEX changed neighbor: ' + name
			}
		}
		println('INTENT-EXTRAS-ROUNDTRIP-PASS classes=2108 two-existing-methods all-2107-neighbors-unchanged')
		return
	}
	root := work + '/proof'
	old, bundle := os.read_file(root + '/' + target)!, os.read_file(root + '/' + bundle_target)!
	patched := androidtools.framework_intent_extras_source(old, bundle)!
	verify(old, patched, true)!
	mut mutations := []Mutation{}
	for name, source in {
		target:        old
		bundle_target: bundle
	} {
		declaration := source.split_into_lines().filter(it.starts_with('.class '))[0]
		parent := source.split_into_lines().filter(it.starts_with('.super '))[0]
		mutations << Mutation{name, source.replace(declaration, declaration.replace('Landroid/', 'Lwrong/'))}
		mutations << Mutation{name, source + '\n' + declaration + '\n'}
		mutations << Mutation{name, source.replace(parent, '.super Lwrong/Parent;')}
		mutations << Mutation{name, source + '\n' + parent + '\n'}
	}
	for signature in expected().keys() {
		retained := methods(old)[signature]
		for changed in ['', retained + '\n' + retained,
			retained.replace('.method public ', '.method private '),
			retained.replace('.method public ', '.method public static '),
			retained.replace('.method public ', '.method public native '),
			retained.replace('iput-object ', 'move-object '), retained.replace('.end method', '')] {
			mutations << Mutation{target, old.replace(retained, changed)}
		}
	}
	for signature in ['<init>()V', '<init>(Landroid/os/Bundle;)V', 'putAll(Landroid/os/Bundle;)V'] {
		retained := methods(bundle)[signature]
		for changed in ['', retained + '\n' + retained,
			retained.replace('.method public ', '.method private '),
			retained.replace('.method public ', '.method public static ')] {
			mutations << Mutation{bundle_target, bundle.replace(retained, changed)}
		}
	}
	field := '.field private extras:Landroid/os/Bundle;'
	for changed in ['', field + '\n' + field, '.field public extras:Landroid/os/Bundle;'] {
		mutations << Mutation{target, old.replace(field, changed)}
	}
	mutations << Mutation{target, patched}
	mutations << Mutation{target, old + '\n.end method\n'}
	mut neighbors := map[string]string{}
	for path in os.walk_ext(root, '.smali') { neighbors[path] = digest(path)! }
	for mutation in mutations {
		original := if mutation.name == target { old } else { bundle }
		assert mutation.text != original, 'negative mutation did not match'
		path := root + '/' + mutation.name
		os.write_file(path, mutation.text)!
		mut refused := false
		androidtools.framework_intent_extras(root) or { refused = true }
		assert refused && os.read_file(path)! == mutation.text, 'refusal must precede writes'
		if mutation.name != target {
			assert os.read_file(root + '/' + target)! == old
		}
		os.write_file(path, original)!
	}
	os.rm(root + '/' + bundle_target)!
	mut refused := false
	androidtools.framework_intent_extras(root) or { refused = true }
	assert refused && !os.exists(root + '/' + bundle_target) && os.read_file(root + '/' + target)! == old
	os.write_file(root + '/' + bundle_target, bundle)!
	androidtools.framework_intent_extras(root)!
	assert os.read_file(root + '/' + target)! == patched
	for path, pin in neighbors {
		if path != root + '/' + target {
			assert digest(path)! == pin, 'source changed neighbor: ' + path
		}
	}
	assert os.walk_ext(root, '.smali').len == 2108
	println('INTENT-EXTRAS-SOURCE-PASS rejected=' + (mutations.len + 1).str() + ' two-existing-methods metadata dependencies all-neighbors')
}
