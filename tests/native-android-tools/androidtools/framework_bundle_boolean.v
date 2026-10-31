// SPDX-License-Identifier: GPL-2.0-or-later
module androidtools

import os

// Preserve the retained getter, including its existing special-key branch, but
// make that branch's comparison safe for an ordinary null Bundle map key.
pub fn framework_bundle_boolean_source(original string) !string {
	if original.split_into_lines().filter(it.starts_with('.class ')) != ['.class public Landroid/os/BaseBundle;']
		|| original.split_into_lines().filter(it.starts_with('.super ')) != ['.super Ljava/lang/Object;'] {
		return error('canonical BaseBundle class required')
	}
	mut found := 0
	mut retained := ''
	for block in original.split('.method ')[1..] {
		if block.all_before('\n').all_after_last(' ') != 'getBoolean(Ljava/lang/String;Z)Z' { continue }
		found++
		end := block.index('.end method') or { return error('unterminated BaseBundle boolean getter') }
		retained = '.method ' + block[..end] + '.end method'
		actual := block[..end].split_into_lines().map(it.all_before('#').trim_space()).filter(it != '').join('\n')
		expected := 'public getBoolean(Ljava/lang/String;Z)Z
.registers 10
invoke-virtual {p0}, Landroid/os/BaseBundle;->vinixGetMap()Landroid/util/ArrayMap;
move-result-object v1
invoke-virtual {v1, p1}, Landroid/util/ArrayMap;->get(Ljava/lang/Object;)Ljava/lang/Object;
move-result-object v3
sget-object v1, Ljava/lang/System;->out:Ljava/io/PrintStream;
new-instance v2, Ljava/lang/StringBuilder;
invoke-direct {v2}, Ljava/lang/StringBuilder;-><init>()V
const-string v4, "bundle.getBoolean("
invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
move-result-object v2
invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
move-result-object v2
const-string v4, ", "
invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
move-result-object v2
invoke-virtual {v2, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;
move-result-object v2
const-string v4, ") called"
invoke-virtual {v2, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
move-result-object v2
invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
move-result-object v2
invoke-virtual {v1, v2}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V
const-string v1, "com.facebook.sdk.AutoLogAppEventsEnabled"
invoke-virtual {p1, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
move-result v1
if-eqz v1, :cond_3a
const/4 p2, 0x0
:cond_39
:goto_39
return p2
:cond_3a
if-eqz v3, :cond_39
:try_start_3c
move-object v0, v3
check-cast v0, Ljava/lang/Boolean;
move-object v1, v0
invoke-virtual {v1}, Ljava/lang/Boolean;->booleanValue()Z
:try_end_43
.catch Ljava/lang/ClassCastException; {:try_start_3c .. :try_end_43} :catch_45
move-result p2
goto :goto_39
:catch_45
move-exception v6
const-string v4, "Boolean"
invoke-static {p2}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;
move-result-object v5
move-object v1, p0
move-object v2, p1
invoke-virtual/range {v1 .. v6}, Landroid/os/BaseBundle;->typeWarning(Ljava/lang/String;Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;Ljava/lang/ClassCastException;)V
goto :goto_39'
		// Parcel-map indirection changes code width before assembly. Accept only
		// its exact retained pre-assembly labels or the canonical DEX labels.
		raw := expected.replace(':cond_3a', ':cond_38').replace(':cond_39', ':cond_37')
			.replace(':goto_39', ':goto_37').replace(':try_start_3c', ':try_start_3a')
			.replace(':try_end_43', ':try_end_41').replace(':catch_45', ':catch_43')
		if actual != expected && actual != raw {
			return error('exact retained BaseBundle boolean getter required')
		}
	}
	if found != 1 { return error('unique retained BaseBundle boolean getter required') }
	old := 'invoke-virtual {p1, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z'
	if retained.count(old) != 1 { return error('unique retained key comparison required') }
	updated := retained.replace(old, 'invoke-virtual {v1, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z')
	return original.replace(retained, updated)
}

pub fn framework_bundle_boolean(smali string) ! {
	path := smali + '/android/os/BaseBundle.smali'
	os.write_file(path, framework_bundle_boolean_source(os.read_file(path)!)!)!
}
