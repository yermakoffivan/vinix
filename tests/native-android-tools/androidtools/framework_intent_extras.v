// SPDX-License-Identifier: GPL-2.0-or-later
module androidtools

import os

fn intent_extras_norm(source string) string {
	return source.split_into_lines().map(it.trim_space()).filter(it != '' && !it.starts_with('#')).join('\n')
}

fn intent_extras_methods(source string) !map[string]string {
	mut methods := map[string]string{}
	for block in source.split('.method ')[1..] {
		name := block.all_before('\n').all_after_last(' ')
		if name in methods || !block.contains('.end method') {
			return error('unique complete Intent extras methods required')
		}
		methods[name] = '.method ' + block.all_before('.end method') + '.end method'
	}
	if source.count('.end method') != methods.len {
		return error('complete Intent extras schema required')
	}
	return methods
}

pub fn framework_intent_extras_source(original string, bundle string) !string {
	if original.split_into_lines().filter(it.starts_with('.class ')) != ['.class public Landroid/content/Intent;']
		|| original.split_into_lines().filter(it.starts_with('.super ')) != ['.super Ljava/lang/Object;']
		|| original.split_into_lines().filter(it == '.field private extras:Landroid/os/Bundle;').len != 1 {
		return error('canonical Intent extras owner required')
	}
	if bundle.split_into_lines().filter(it.starts_with('.class ')) != ['.class public final Landroid/os/Bundle;']
		|| bundle.split_into_lines().filter(it.starts_with('.super ')) != ['.super Landroid/os/BaseBundle;'] {
		return error('canonical Bundle dependency required')
	}
	dependencies := intent_extras_methods(bundle)!
	for name, flags in {
		'<init>()V':                    'public constructor'
		'<init>(Landroid/os/Bundle;)V': 'public constructor'
		'putAll(Landroid/os/Bundle;)V': 'public'
	} {
		method := dependencies[name] or { return error('missing Bundle extras dependency: ' + name) }
		if method.all_before('\n') != '.method ' + flags + ' ' + name {
			return error('retained Bundle extras dependency ABI required: ' + name)
		}
	}
	methods := intent_extras_methods(original)!
	old_intent := methods['putExtras(Landroid/content/Intent;)Landroid/content/Intent;'] or { return error('retained Intent extras overload required') }
	old_bundle := methods['putExtras(Landroid/os/Bundle;)Landroid/content/Intent;'] or { return error('retained Bundle extras overload required') }
	if intent_extras_norm(old_intent) != '.method public putExtras(Landroid/content/Intent;)Landroid/content/Intent;
.registers 3
invoke-virtual {p1}, Landroid/content/Intent;->getExtras()Landroid/os/Bundle;
move-result-object v0
iput-object v0, p0, Landroid/content/Intent;->extras:Landroid/os/Bundle;
return-object p0
.end method'
		|| intent_extras_norm(old_bundle) != '.method public putExtras(Landroid/os/Bundle;)Landroid/content/Intent;
.registers 2
iput-object p1, p0, Landroid/content/Intent;->extras:Landroid/os/Bundle;
return-object p0
.end method' {
		return error('retained replacement-only Intent extras bodies required')
	}
	// Android 10 merges incoming keys and never lends the source's top-level
	// map. A source Intent without extras leaves the destination untouched.
	next_intent := '.method public putExtras(Landroid/content/Intent;)Landroid/content/Intent;
.registers 4
iget-object v0, p1, Landroid/content/Intent;->extras:Landroid/os/Bundle;
if-eqz v0, :done
iget-object v1, p0, Landroid/content/Intent;->extras:Landroid/os/Bundle;
if-nez v1, :merge
new-instance v1, Landroid/os/Bundle;
invoke-direct {v1, v0}, Landroid/os/Bundle;-><init>(Landroid/os/Bundle;)V
iput-object v1, p0, Landroid/content/Intent;->extras:Landroid/os/Bundle;
goto :done
:merge
invoke-virtual {v1, v0}, Landroid/os/Bundle;->putAll(Landroid/os/Bundle;)V
:done
return-object p0
.end method'
	// Allocate before putAll, including its ordinary null-argument exception.
	next_bundle := '.method public putExtras(Landroid/os/Bundle;)Landroid/content/Intent;
.registers 3
iget-object v0, p0, Landroid/content/Intent;->extras:Landroid/os/Bundle;
if-nez v0, :merge
new-instance v0, Landroid/os/Bundle;
invoke-direct {v0}, Landroid/os/Bundle;-><init>()V
iput-object v0, p0, Landroid/content/Intent;->extras:Landroid/os/Bundle;
:merge
invoke-virtual {v0, p1}, Landroid/os/Bundle;->putAll(Landroid/os/Bundle;)V
return-object p0
.end method'
	return original.replace(old_intent, next_intent).replace(old_bundle, next_bundle)
}

pub fn framework_intent_extras(smali string) ! {
	path := smali + '/android/content/Intent.smali'
	patched := framework_intent_extras_source(os.read_file(path)!, os.read_file(smali + '/android/os/Bundle.smali')!)!
	os.write_file(path, patched)!
}
