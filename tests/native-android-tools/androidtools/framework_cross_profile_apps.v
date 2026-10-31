// SPDX-License-Identifier: GPL-2.0-or-later
module androidtools

import os

pub fn framework_cross_profile_apps_classes() map[string]string {
	// This runtime has no cross-profile service. Maps resolves the API type
	// before checking the nullable service result; no manager is advertised.
	return {'android/content/pm/CrossProfileApps':
		'.class public Landroid/content/pm/CrossProfileApps;\n.super Ljava/lang/Object;\n'}
}

pub fn framework_cross_profile_apps_source(original string) !string {
	if original.split_into_lines().filter(it.starts_with('.class ')) != ['.class public final Landroid/app/ContextImpl;']
		|| original.split_into_lines().filter(it.starts_with('.super ')) != ['.super Landroid/content/Context;'] {
		return error('canonical ContextImpl required for absent cross-profile service')
	}
	signature := 'getSystemService(Ljava/lang/Class;)Ljava/lang/Object;'
	mut retained := ''
	for block in original.split('.method ')[1..] {
		if block.all_before('\n').all_after_last(' ') != signature { continue }
		if retained != '' || block.all_before('\n') != 'public ' + signature {
			return error('unique public typed service method required')
		}
		end := block.index('.end method') or { return error('unterminated typed service method') }
		retained = '.method ' + block[..end] + '.end method'
	}
	if retained == '' { return error('typed service method missing') }
	actual := retained.split_into_lines().map(it.all_before('#').trim_space()).filter(it != '').join('\n')
	expected := '.method public getSystemService(Ljava/lang/Class;)Ljava/lang/Object;
.registers 3
const-class v0, Landroid/service/persistentdata/PersistentDataBlockManager;
if-ne p1, v0, :cond_6
const/4 v0, 0x0
return-object v0
:cond_6
const-class v0, Landroid/net/wifi/rtt/WifiRttManager;
if-ne p1, v0, :cond_c
const/4 v0, 0x0
return-object v0
:cond_c
invoke-direct {p0, p1}, Landroid/app/ContextImpl;->vinixRttFallbackClass(Ljava/lang/Class;)Ljava/lang/Object;
move-result-object v0
return-object v0
.end method'
	// Accept only the retained canonical DEX body or its exact pre-assembly
	// labels from the persistent-data provider. Preserve either input spelling.
	raw := expected.replace(':cond_6', ':vinix_persistent_data_other').replace(':cond_c', ':cond_6')
	if actual != expected && actual != raw { return error('retained typed service fallbacks required') }
	guard := '\nconst-class v0, Landroid/content/pm/CrossProfileApps;\nif-ne p1, v0, :vinix_cross_profile_other\nconst/4 v0, 0x0\nreturn-object v0\n:vinix_cross_profile_other\n'
	return original.replace(retained, retained.replace('.registers 3', '.registers 3' + guard))
}

pub fn framework_cross_profile_apps(smali string) ! {
	context := smali + '/android/app/ContextImpl.smali'
	patched := framework_cross_profile_apps_source(os.read_file(context)!)!
	classes := framework_cross_profile_apps_classes()
	for name, _ in classes {
		path := smali + '/' + name + '.smali'
		if os.exists(path) || os.is_link(path) { return error('cross-profile API type already exists') }
	}
	// Validate the old method and new type path before changing either file.
	for name, source in classes {
		path := smali + '/' + name + '.smali'
		os.mkdir_all(os.dir(path))!
		os.write_file(path, source)!
	}
	os.write_file(context, patched)!
}
