// SPDX-License-Identifier: GPL-2.0-or-later
module androidtools

import os

// The current single-user backend has no administrator, managed profile or
// user-restrictions store. Return a separate empty snapshot for every query;
// hasUserRestriction uses the virtual query so future backends and subclasses
// can supply real restrictions without changing the boolean query contract.
pub fn framework_user_restrictions_source(original string) !string {
	if original.split_into_lines().filter(it.starts_with('.class ')) != ['.class public Landroid/os/UserManager;']
		|| original.split_into_lines().filter(it.starts_with('.super ')) != ['.super Ljava/lang/Object;']
		|| original.split_into_lines().any(it.starts_with('.field ')) {
		return error('canonical fieldless UserManager class required')
	}
	if original.contains('getUserRestrictions(') || original.contains('hasUserRestriction(') {
		return error('UserManager restrictions API already present')
	}
	mut headers := original.split_into_lines().filter(it.starts_with('.method '))
	headers.sort()
	mut expected := [
		'.method public constructor <init>()V', '.method public static supportsMultipleUsers()Z',
		'.method public getApplicationRestrictions(Ljava/lang/String;)Landroid/os/Bundle;',
		'.method public getSeedAccountOptions()Landroid/os/PersistableBundle;',
		'.method public getSerialNumberForUser(Landroid/os/UserHandle;)J',
		'.method public getUserProfiles()Ljava/util/List;', '.method public isSystemUser()Z',
		'.method public isUserUnlocked()Z',
	]
	expected.sort()
	if headers != expected || original.count('.end method') != expected.len {
		return error('retained UserManager method schema required')
	}
	for block in original.split('.method ')[1..] {
		name := block.all_before('\n').all_after_last(' ')
		end := block.index('.end method') or { return error('unterminated UserManager method') }
		if name == 'getApplicationRestrictions(Ljava/lang/String;)Landroid/os/Bundle;' {
			body := block[..end].split_into_lines().map(it.all_before('#').trim_space()).filter(it != '').join('\n').replace('.locals 1', '.registers 3')
			if body != 'public getApplicationRestrictions(Ljava/lang/String;)Landroid/os/Bundle;\n.registers 3\nnew-instance v0, Landroid/os/Bundle;\ninvoke-direct {v0}, Landroid/os/Bundle;-><init>()V\nreturn-object v0' {
				return error('retained absent application-restrictions model required')
			}
		}
	}
	return original + '
.method public getUserRestrictions()Landroid/os/Bundle;
.locals 1
new-instance v0, Landroid/os/Bundle;
invoke-direct {v0}, Landroid/os/Bundle;-><init>()V
return-object v0
.end method

.method public hasUserRestriction(Ljava/lang/String;)Z
.locals 1
invoke-virtual {p0}, Landroid/os/UserManager;->getUserRestrictions()Landroid/os/Bundle;
move-result-object v0
invoke-virtual {v0, p1}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;)Z
move-result v0
return v0
.end method
'
}

pub fn framework_user_restrictions(smali string) ! {
	path := smali + '/android/os/UserManager.smali'
	os.write_file(path, framework_user_restrictions_source(os.read_file(path)!)!)!
}
