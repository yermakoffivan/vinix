// SPDX-License-Identifier: GPL-2.0-or-later
module androidtools

import os

fn seed_options_method_source(source string, header string) !string {
	mut found := ''
	for block in source.split('.method ')[1..] {
		if block.all_before('\n').all_after_last(' ') != header.all_after_last(' ') { continue }
		if found != '' || block.all_before('\n') != header { return error('unique seed-options dependency method required: ' + header) }
		end := block.index('.end method') or { return error('unterminated seed-options dependency method') }
		found = '.method ' + block[..end + '.end method'.len]
	}
	if found == '' { return error('missing seed-options dependency method: ' + header) }
	return found
}

fn seed_options_normalize(source string) string {
	return source.split_into_lines().map(it.trim_space()).filter(it != '').join('\n')
}

// The single-user runtime has no seed account data or provisioning store.
// Android represents absent seed options with null, rather than an empty bundle.
pub fn framework_seed_account_options_method() string {
	return '.method public getSeedAccountOptions()Landroid/os/PersistableBundle;\n.registers 2\nconst/4 v0, 0x0\nreturn-object v0\n.end method'
}

pub fn framework_seed_account_options_source(original string) !string {
	if original.split_into_lines().filter(it.starts_with('.class ')) != ['.class public Landroid/os/UserManager;']
		|| original.split_into_lines().filter(it.starts_with('.super ')) != ['.super Ljava/lang/Object;']
		|| original.split_into_lines().any(it.starts_with('.field ')) {
		return error('canonical unseeded UserManager class required')
	}
	mut actual := original.split_into_lines().filter(it.starts_with('.method '))
	actual.sort()
	mut expected := [
		'.method public constructor <init>()V',
		'.method public static supportsMultipleUsers()Z',
		'.method public getApplicationRestrictions(Ljava/lang/String;)Landroid/os/Bundle;',
		'.method public getSerialNumberForUser(Landroid/os/UserHandle;)J',
		'.method public getUserProfiles()Ljava/util/List;',
		'.method public isSystemUser()Z',
		'.method public isUserUnlocked()Z',
	]
	expected.sort()
	if actual != expected || original.count('.end method') != expected.len {
		return error('canonical unextended UserManager method schema required')
	}
	for block in original.split('.method ')[1..] {
		if !block.contains('.end method') { return error('unterminated UserManager method') }
	}
	return original + '\n' + framework_seed_account_options_method() + '\n'
}

pub fn framework_seed_account_empty_initializer() string {
	return '.method static constructor <clinit>()V\n.registers 2\nnew-instance v0, Landroid/os/PersistableBundle;\ninvoke-direct {v0}, Landroid/os/PersistableBundle;-><init>()V\nsput-object v0, Landroid/os/PersistableBundle;->EMPTY:Landroid/os/PersistableBundle;\nsget-object v0, Landroid/os/PersistableBundle;->EMPTY:Landroid/os/PersistableBundle;\nsget-object v1, Landroid/util/ArrayMap;->EMPTY:Landroid/util/ArrayMap;\niput-object v1, v0, Landroid/os/BaseBundle;->mMap:Landroid/util/ArrayMap;\nreturn-void\n.end method'
}

pub fn framework_seed_account_empty_source(original string) !string {
	if original.split_into_lines().filter(it.starts_with('.class ')) != ['.class public Landroid/os/PersistableBundle;']
		|| original.split_into_lines().filter(it.starts_with('.super ')) != ['.super Landroid/os/BaseBundle;']
		|| original.split_into_lines().any(it.starts_with('.field ')) {
		return error('canonical unextended PersistableBundle class required')
	}
	mut actual := original.split_into_lines().filter(it.starts_with('.method '))
	actual.sort()
	mut expected := ['.method public constructor <init>()V', '.method public constructor <init>(I)V', '.method public declared-synchronized toString()Ljava/lang/String;']
	expected.sort()
	if actual != expected || original.count('.end method') != 3 { return error('canonical PersistableBundle method schema required') }
	for declaration in expected { seed_options_method_source(original, declaration.all_after('.method '))! }
	return original + '\n.field public static final EMPTY:Landroid/os/PersistableBundle;\n' + framework_seed_account_empty_initializer() + '\n'
}

pub fn framework_seed_account_array_map_source(original string) !string {
	if original.split_into_lines().filter(it.starts_with('.class ')) != ['.class public final Landroid/util/ArrayMap;']
		|| original.split_into_lines().filter(it.starts_with('.super ')) != ['.super Ljava/lang/Object;']
		|| original.split_into_lines().filter(it == '.field public static final EMPTY:Landroid/util/ArrayMap;').len != 1
		|| original.split_into_lines().filter(it == '.field static final EMPTY_IMMUTABLE_INTS:[I').len != 1 {
		return error('canonical ArrayMap immutable-empty fields required')
	}
	constructor := seed_options_method_source(original, 'private constructor <init>(Z)V')!
	if seed_options_normalize(constructor) != '.method private constructor <init>(Z)V\n.registers 3\ninvoke-direct {p0}, Ljava/lang/Object;-><init>()V\nsget-object v0, Landroid/util/ArrayMap;->EMPTY_IMMUTABLE_INTS:[I\niput-object v0, p0, Landroid/util/ArrayMap;->mHashes:[I\nsget-object v0, Landroid/util/ContainerHelpers;->EMPTY_OBJECTS:[Ljava/lang/Object;\niput-object v0, p0, Landroid/util/ArrayMap;->mArray:[Ljava/lang/Object;\nconst/4 v0, 0x0\niput v0, p0, Landroid/util/ArrayMap;->mSize:I\nreturn-void\n.end method' {
		return error('retained ArrayMap immutable constructor required')
	}
	old := seed_options_method_source(original, 'static constructor <clinit>()V')!
	object := 'new-instance v0, Landroid/util/ArrayMap;\nconst/4 v1, 0x1\ninvoke-direct {v0, v1}, Landroid/util/ArrayMap;-><init>(Z)V\nsput-object v0, Landroid/util/ArrayMap;->EMPTY:Landroid/util/ArrayMap;\n'
	marker := 'const/4 v0, 0x0\nnew-array v0, v0, [I\nsput-object v0, Landroid/util/ArrayMap;->EMPTY_IMMUTABLE_INTS:[I\n'
	if seed_options_normalize(old) != '.method static constructor <clinit>()V\n.registers 2\n' + object + marker + 'return-void\n.end method' {
		return error('retained ArrayMap static initialization order required')
	}
	// The private constructor reads the marker. Publish it before constructing
	// EMPTY so its existing allocation guard rejects mutation, rather than NPE.
	changed := '.method static constructor <clinit>()V\n.registers 2\n' + marker + object + 'return-void\n.end method'
	return original.replace(old, changed)
}

pub fn framework_seed_account_options(smali string) ! {
	users := smali + '/android/os/UserManager.smali'
	empty := smali + '/android/os/PersistableBundle.smali'
	array_map := smali + '/android/util/ArrayMap.smali'
	patched_users := framework_seed_account_options_source(os.read_file(users)!)!
	patched_empty := framework_seed_account_empty_source(os.read_file(empty)!)!
	patched_array_map := framework_seed_account_array_map_source(os.read_file(array_map)!)!
	// Validate all dependencies before modifying any output class.
	os.write_file(users, patched_users)!
	os.write_file(empty, patched_empty)!
	os.write_file(array_map, patched_array_map)!
}
