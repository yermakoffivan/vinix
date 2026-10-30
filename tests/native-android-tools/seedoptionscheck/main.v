// SPDX-License-Identifier: GPL-2.0-or-later
// Exact API/empty-constant delta and transactional validation of three classes.
module main

import androidtools
import os

const user = 'android/os/UserManager'
const bundle = 'android/os/PersistableBundle'
const array_map = 'android/util/ArrayMap'
const signature = 'getSeedAccountOptions()Landroid/os/PersistableBundle;'
const empty_field = '.field public static final EMPTY:Landroid/os/PersistableBundle;'

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
	// Baksmali adds a new section comment for PersistableBundle's first field.
	return source.split_into_lines().map(it.trim_space()).filter(it != '' && !it.starts_with('#')).join('\n')
}

fn map_initializer() string {
	return '.method static constructor <clinit>()V\n.registers 2\n' +
		'const/4 v0, 0x0\nnew-array v0, v0, [I\n' +
		'sput-object v0, Landroid/util/ArrayMap;->EMPTY_IMMUTABLE_INTS:[I\n' +
		'new-instance v0, Landroid/util/ArrayMap;\nconst/4 v1, 0x1\n' +
		'invoke-direct {v0, v1}, Landroid/util/ArrayMap;-><init>(Z)V\n' +
		'sput-object v0, Landroid/util/ArrayMap;->EMPTY:Landroid/util/ArrayMap;\n' +
		'return-void\n.end method'
}

fn bundle_initializer() string {
	return '.method static constructor <clinit>()V\n.registers 2\n' +
		'new-instance v0, Landroid/os/PersistableBundle;\n' +
		'invoke-direct {v0}, Landroid/os/PersistableBundle;-><init>()V\n' +
		'sput-object v0, Landroid/os/PersistableBundle;->EMPTY:Landroid/os/PersistableBundle;\n' +
		'sget-object v0, Landroid/os/PersistableBundle;->EMPTY:Landroid/os/PersistableBundle;\n' +
		'sget-object v1, Landroid/util/ArrayMap;->EMPTY:Landroid/util/ArrayMap;\n' +
		'iput-object v1, v0, Landroid/os/BaseBundle;->mMap:Landroid/util/ArrayMap;\n' +
		'return-void\n.end method'
}

fn verify_delta(name string, old string, patched string, raw bool) {
	before, after := methods(old), methods(patched)
	if name == user {
		assert before.len == 7 && after.len == 8 && signature !in before
		added := after[signature]
		assert norm(added) == '.method public ' + signature + '\n.registers 2\nconst/4 v0, 0x0\nreturn-object v0\n.end method'
		for header, body in before { assert after[header] == body, header }
		assert norm(patched.replace(added, '')) == norm(old)
		if raw { assert patched == old + '\n' + androidtools.framework_seed_account_options_method() + '\n' }
	} else if name == bundle {
		assert before.len == 3 && after.len == 4 && '<clinit>()V' !in before
		added := after['<clinit>()V']
		assert norm(added) == bundle_initializer()
		assert patched.count(empty_field + '\n') == 1
		for header, body in before { assert after[header] == body, header }
		assert norm(patched.replace(added, '').replace(empty_field + '\n', '')) == norm(old)
		if raw { assert patched == old + '\n' + empty_field + '\n' + bundle_initializer() + '\n' }
	} else {
		assert name == array_map && before.len == after.len
		assert norm(after['<clinit>()V']) == map_initializer()
		assert after['<clinit>()V'] != before['<clinit>()V']
		for header, body in before {
			if header != '<clinit>()V' { assert after[header] == body, header }
		}
		assert norm(patched.replace(after['<clinit>()V'], '')) == norm(old.replace(before['<clinit>()V'], ''))
		if raw { assert patched == old.replace(before['<clinit>()V'], map_initializer()) }
	}
}

fn user_invalids(old string, patched string) []string {
	return [patched,
		old.replace('.class public Landroid/os/UserManager;', '.class public Lwrong/UserManager;'),
		old.replace('.super Ljava/lang/Object;', '.super Landroid/content/Context;'),
		old + '\n.field private seed:Landroid/os/PersistableBundle;\n',
		old.replace('.method public isUserUnlocked()Z', '.method private isUserUnlocked()Z'),
		old.replace('.method public getUserProfiles()', '.method public static getUserProfiles()'),
		old.replace('getApplicationRestrictions(Ljava/lang/String;)Landroid/os/Bundle;', 'missingRestrictions(Ljava/lang/String;)Landroid/os/Bundle;'),
		old + '\n' + methods(old)['isUserUnlocked()Z'],
		old.replace(methods(old)['isUserUnlocked()Z'], ''),
		old + '\n.method public getSeedAccountOptions()Landroid/os/Bundle;\n.registers 2\nconst/4 v0, 0\nreturn-object v0\n.end method\n',
		old + '\n.method public static ' + signature + '\n.registers 1\nconst/4 v0, 0\nreturn-object v0\n.end method\n',
		old + '\n.method public getSeedAccountName()Ljava/lang/String;\n.registers 2\nconst/4 v0, 0\nreturn-object v0\n.end method\n',
		old.replace('.method public constructor <init>()V', '.method private constructor <init>()V'),
		old.replace(methods(old)['<init>()V'], ''),
		old + '\n' + methods(old)['<init>()V'],
		old.replace('.end method', ''),
	]
}

fn bundle_invalids(old string, patched string) []string {
	initializer := androidtools.framework_seed_account_empty_initializer()
	return [patched,
		old.replace('.class public Landroid/os/PersistableBundle;', '.class public Lwrong/PersistableBundle;'),
		old.replace('.super Landroid/os/BaseBundle;', '.super Landroid/os/Bundle;'),
		old + '\n.field private seed:I\n',
		old.replace('.method public constructor <init>()V', '.method private constructor <init>()V'),
		old.replace('.method public constructor <init>(I)V', '.method public static <init>(I)V'),
		old.replace(methods(old)['<init>()V'], ''),
		old + '\n' + methods(old)['<init>()V'],
		old.replace(methods(old)['toString()Ljava/lang/String;'], ''),
		old + '\n' + methods(old)['toString()Ljava/lang/String;'],
		old + '\n' + initializer,
		old + '\n' + initializer.replace('.method static constructor', '.method public static constructor'),
		patched.replace(initializer, ''),
		patched.replace(empty_field, '.field public static final EMPTY:Ljava/lang/Object;'),
		patched.replace(empty_field, '.field private static final EMPTY:Landroid/os/PersistableBundle;'),
		old.replace('.end method', ''),
	]
}

fn map_invalids(old string, patched string) []string {
	constructor := methods(old)['<init>(Z)V']
	initializer := methods(old)['<clinit>()V']
	marker := '.field static final EMPTY_IMMUTABLE_INTS:[I'
	return [patched,
		old.replace('.class public final Landroid/util/ArrayMap;', '.class public final Lwrong/ArrayMap;'),
		old.replace('.class public final Landroid/util/ArrayMap;', '.class public Landroid/util/ArrayMap;'),
		old.replace('.super Ljava/lang/Object;', '.super Ljava/util/HashMap;'),
		old.replace('.field public static final EMPTY:Landroid/util/ArrayMap;', '.field private static final EMPTY:Landroid/util/ArrayMap;'),
		old.replace(marker, '.field private static final EMPTY_IMMUTABLE_INTS:[I'),
		old.replace(marker, '.field static final EMPTY_IMMUTABLE_INTS:[J'),
		old + '\n.field public static final EMPTY:Landroid/util/ArrayMap;\n',
		old + '\n' + marker + '\n',
		old.replace(marker, ''),
		old.replace('.method private constructor <init>(Z)V', '.method public constructor <init>(Z)V'),
		old.replace(constructor, ''),
		old + '\n' + constructor,
		old.replace(constructor, constructor.replace('->EMPTY_IMMUTABLE_INTS:[I', '->EMPTY_INTS:[I')),
		old.replace(constructor, constructor.replace('const/4 v0, 0x0', 'const/4 v0, 0x1')),
		old.replace(initializer, ''),
		old + '\n' + initializer,
		old.replace(initializer, initializer.replace('.method static constructor', '.method public static constructor')),
		old.replace(initializer, initializer.replace('.registers 2', '.registers 3')),
		old.replace(initializer, initializer.replace('invoke-direct {v0, v1}', 'invoke-direct {v1, v0}')),
		old.replace(initializer, initializer.replace('    new-array v0, v0, [I', '    sput-object v0, Landroid/util/ArrayMap;->EMPTY_IMMUTABLE_INTS:[I\n    new-array v0, v0, [I')),
	]
}

fn restore(work string, originals map[string]string) ! {
	for name, source in originals { os.write_file(work + '/proof/' + name + '.smali', source)! }
}

fn rejected_without_writes(work string, originals map[string]string, name string, invalid string) ! {
	assert invalid != originals[name], 'negative mutation did not match baseline'
	restore(work, originals)!
	os.write_file(work + '/proof/' + name + '.smali', invalid)!
	mut expected := originals.clone()
	expected[name] = invalid
	mut rejected := false
	androidtools.framework_seed_account_options(work + '/proof') or { rejected = true }
	assert rejected, 'invalid dependency accepted: ' + name
	for selected, source in expected {
		assert os.read_file(work + '/proof/' + selected + '.smali')! == source, 'wrapper modified an output before rejecting ' + name
	}
}

fn main() {
	assert os.args.len in [2, 3], 'WORK [--roundtrip]'
	assert androidtools.framework_seed_account_empty_initializer() == bundle_initializer()
	work := os.args[1]
	if os.args.len == 3 {
		assert os.args[2] == '--roundtrip'
		for name in [user, bundle, array_map, 'android/os/BaseBundle', 'android/os/Bundle', 'android/app/ContextImpl', 'android/util/ContainerHelpers'] {
			old := os.read_file(work + '/baseline-roundtrip/' + name + '.smali')!
			patched := os.read_file(work + '/patched-roundtrip/' + name + '.smali')!
			if name in [user, bundle, array_map] { verify_delta(name, old, patched, false) }
			else { assert patched == old, name + ' changed through DEX' }
		}
		return
	}
	mut originals := map[string]string{}
	for name in [user, bundle, array_map] { originals[name] = os.read_file(work + '/proof/' + name + '.smali')! }
	patched := {
		'android/os/UserManager': androidtools.framework_seed_account_options_source(originals[user])!
		'android/os/PersistableBundle': androidtools.framework_seed_account_empty_source(originals[bundle])!
		'android/util/ArrayMap': androidtools.framework_seed_account_array_map_source(originals[array_map])!
	}
	for name, before in originals { verify_delta(name, before, patched[name], true) }
	invalids := {
		'android/os/UserManager': user_invalids(originals[user], patched[user])
		'android/os/PersistableBundle': bundle_invalids(originals[bundle], patched[bundle])
		'android/util/ArrayMap': map_invalids(originals[array_map], patched[array_map])
	}
	mut count := 0
	for name, cases in invalids {
		for invalid in cases { rejected_without_writes(work, originals, name, invalid)!; count++ }
	}
	restore(work, originals)!
	androidtools.framework_seed_account_options(work + '/proof')!
	for name, wanted in patched { assert os.read_file(work + '/proof/' + name + '.smali')! == wanted }
	println('SEED-ACCOUNT-OPTIONS-SOURCE-PASS changed=1 added=2 fields=1 malformed=' + count.str() + ' unseeded-null immutable-empty marker-before-construction retained-service-neighbors')
}
