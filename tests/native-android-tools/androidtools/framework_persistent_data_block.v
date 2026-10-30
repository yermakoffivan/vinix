// SPDX-License-Identifier: GPL-2.0-or-later
module androidtools

import os

pub fn framework_persistent_data_block_classes() map[string]string {
	// This device has no persistent data partition/service. The Android type
	// must still resolve for a check-cast of a null service result.
	return {'android/service/persistentdata/PersistentDataBlockManager':
		'.class public Landroid/service/persistentdata/PersistentDataBlockManager;\n.super Ljava/lang/Object;\n'}
}

fn persistent_data_block_method(source string) !string {
	signature := 'getSystemService(Ljava/lang/Class;)Ljava/lang/Object;'
	mut found := ''
	for block in source.split('.method ')[1..] {
		if block.all_before('\n').all_after_last(' ') != signature { continue }
		if found != '' || block.all_before('\n') != 'public ' + signature {
			return error('unique public typed service method required')
		}
		end := block.index('.end method') or { return error('unterminated typed service method') }
		found = '.method ' + block[..end + '.end method'.len]
	}
	if found == '' { return error('typed service method missing') }
	return found
}

pub fn framework_persistent_data_block_source(original string) !string {
	if original.split_into_lines().filter(it.starts_with('.class ')) != ['.class public final Landroid/app/ContextImpl;']
		|| original.split_into_lines().filter(it.starts_with('.super ')) != ['.super Landroid/content/Context;'] {
		return error('canonical ContextImpl required for absent persistent-data service')
	}
	old := persistent_data_block_method(original)!
	canonical := old.split_into_lines().map(it.trim_space()).filter(it != '').join('\n')
	if canonical != '.method public getSystemService(Ljava/lang/Class;)Ljava/lang/Object;\n.registers 3\nconst-class v0, Landroid/net/wifi/rtt/WifiRttManager;\nif-ne p1, v0, :cond_6\nconst/4 v0, 0x0\nreturn-object v0\n:cond_6\ninvoke-direct {p0, p1}, Landroid/app/ContextImpl;->vinixRttFallbackClass(Ljava/lang/Class;)Ljava/lang/Object;\nmove-result-object v0\nreturn-object v0\n.end method' {
		return error('retained typed service fallback required')
	}
	// The generic fallback reflectively constructs managers. An unavailable
	// persistent-data service must return null before reaching that fallback.
	guard := '\nconst-class v0, Landroid/service/persistentdata/PersistentDataBlockManager;\nif-ne p1, v0, :vinix_persistent_data_other\nconst/4 v0, 0x0\nreturn-object v0\n:vinix_persistent_data_other\n'
	return original.replace(old, old.replace('.registers 3', '.registers 3' + guard))
}

pub fn framework_persistent_data_block(smali string) ! {
	classes := framework_persistent_data_block_classes()
	context := smali + '/android/app/ContextImpl.smali'
	patched := framework_persistent_data_block_source(os.read_file(context)!)!
	for name, _ in classes {
		path := smali + '/' + name + '.smali'
		if os.exists(path) || os.is_link(path) { return error('persistent-data manager class already exists') }
	}
	// Complete validation before changing the context or adding the API type.
	for name, source in classes {
		path := smali + '/' + name + '.smali'
		os.mkdir_all(os.dir(path))!
		os.write_file(path, source)!
	}
	os.write_file(context, patched)!
}
