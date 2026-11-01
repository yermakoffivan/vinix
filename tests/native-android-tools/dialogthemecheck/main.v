// SPDX-License-Identifier: GPL-2.0-or-later
module main

import androidtools
import crypto.sha256
import os

const target = 'android/app/Dialog.smali'
const constructor = '<init>(Landroid/content/Context;I)V'
const dependencies = ['android/content/Context', 'android/view/ContextThemeWrapper',
	'android/content/res/Resources$Theme', 'android/util/TypedValue', 'android/view/Window',
	'android/R$attr']

struct Mutation {
	name string
	text string
}

fn digest(path string) !string { return sha256.sum(os.read_bytes(path)!).hex() }

fn methods(source string) map[string]string {
	mut result := map[string]string{}
	for block in source.split('.method ')[1..] {
		name := block.all_before('\n').all_after_last(' ')
		assert name !in result && block.contains('.end method'), 'unique complete methods required'
		result[name] = '.method ' + block.all_before('.end method') + '.end method'
	}
	return result
}

fn norm(source string) string {
	mut text := source.split_into_lines().map(it.trim_space()).filter(it != '' && !it.starts_with('#')).join('\n')
	// This constructor has one conditional label; baksmali names it by offset.
	labels := text.split_into_lines().filter(it.starts_with(':'))
	for index, label in labels {
		text = text.replace(label, ':label' + index.str())
	}
	return text
}

fn expected_constructor() string {
	return '.method public constructor <init>(Landroid/content/Context;I)V
.registers 7
invoke-direct {p0}, Ljava/lang/Object;-><init>()V
if-nez p2, :label0
new-instance v0, Landroid/util/TypedValue;
invoke-direct {v0}, Landroid/util/TypedValue;-><init>()V
invoke-virtual {p1}, Landroid/content/Context;->getTheme()Landroid/content/res/Resources$Theme;
move-result-object v1
sget v2, Landroid/R$attr;->dialogTheme:I
const/4 v3, 0x1
invoke-virtual {v1, v2, v0, v3}, Landroid/content/res/Resources$Theme;->resolveAttribute(ILandroid/util/TypedValue;Z)Z
iget p2, v0, Landroid/util/TypedValue;->resourceId:I
:label0
new-instance v0, Landroid/view/ContextThemeWrapper;
invoke-direct {v0, p1, p2}, Landroid/view/ContextThemeWrapper;-><init>(Landroid/content/Context;I)V
iput-object v0, p0, Landroid/app/Dialog;->context:Landroid/content/Context;
new-instance v1, Landroid/view/Window;
invoke-direct {v1, v0, p0}, Landroid/view/Window;-><init>(Landroid/content/Context;Landroid/view/Window$Callback;)V
iput-object v1, p0, Landroid/app/Dialog;->window:Landroid/view/Window;
invoke-virtual {p0}, Landroid/app/Dialog;->nativeInit()J
move-result-wide v0
iput-wide v0, p0, Landroid/app/Dialog;->nativePtr:J
iget-object v0, p0, Landroid/app/Dialog;->window:Landroid/view/Window;
iget-wide v2, p0, Landroid/app/Dialog;->nativePtr:J
invoke-virtual {v0, v2, v3}, Landroid/view/Window;->set_native_window(J)V
return-void
.end method'
}

fn verify(old string, patched string, raw bool) {
	before, after := methods(old), methods(patched)
	assert after.len == before.len, 'Dialog ABI changed'
	for name, body in before {
		if name != constructor {
			assert after[name] == body, 'changed retained method: ' + name
		}
	}
	assert norm(after[constructor]) == expected_constructor(), 'Dialog constructor contract differs'
	if raw {
		assert patched.replace(after[constructor], '<CONSTRUCTOR>') == old.replace(before[constructor], '<CONSTRUCTOR>'), 'Dialog metadata changed'
	} else {
		assert norm(patched.replace(after[constructor], '')) == norm(old.replace(before[constructor], '')), 'Dialog DEX metadata changed'
	}
	native := 'invoke-virtual {p0}, Landroid/app/Dialog;->nativeInit()J'
	assert norm(after[constructor]).all_after(native) == norm(before[constructor]).all_after(native), 'native initialization tail changed'
}

fn main() {
	assert os.args.len in [2, 3], 'WORK [--roundtrip]'
	work := os.args[1]
	if os.args.len == 3 {
		assert os.args[2] == '--roundtrip'
		baseline := os.walk_ext(work + '/baseline-roundtrip', '.smali').sorted()
		patched := os.walk_ext(work + '/patched-roundtrip', '.smali').sorted()
		assert baseline.len == 2108 && patched.len == 2108
		for path in baseline {
			name := path.all_after(work + '/baseline-roundtrip/')
			other := work + '/patched-roundtrip/' + name
			assert os.is_file(other), 'DEX removed class: ' + name
			if name == target {
				verify(os.read_file(path)!, os.read_file(other)!, false)
			} else {
				assert digest(path)! == digest(other)!, 'DEX changed neighbor: ' + name
			}
		}
		println('DIALOG-THEME-ROUNDTRIP-PASS classes=2108 one-constructor native-tail all-2107-neighbors-unchanged')
		return
	}
	root := work + '/proof'
	mut sources := map[string]string{}
	for name in ['android/app/Dialog', ...dependencies] {
		sources[name] = os.read_file(root + '/' + name + '.smali')!
	}
	old := sources['android/app/Dialog']
	before := methods(old)
	patched := androidtools.framework_dialog_theme_source(sources)!
	verify(old, patched, true)
	mut mutations := []Mutation{}
	for name, source in sources {
		declaration := source.split_into_lines().filter(it.starts_with('.class '))[0]
		parent := source.split_into_lines().filter(it.starts_with('.super '))[0]
		mutations << Mutation{name, source.replace(declaration, declaration.replace('Landroid/', 'Lwrong/'))}
		mutations << Mutation{name, source + '\n' + declaration + '\n'}
		mutations << Mutation{name, source.replace(parent, '.super Lwrong/Parent;')}
		mutations << Mutation{name, source + '\n' + parent + '\n'}
	}
	retained := before[constructor]
	for changed in [
		retained.replace('.method public constructor ', '.method private constructor '),
		retained.replace('.method public constructor ', '.method public static constructor '),
		retained.replace('.method public constructor ', '.method public native constructor '),
		retained.replace('.method public constructor ', '.method public abstract constructor '),
		retained.replace(constructor, '<init>(Landroid/content/Context;Z)V'),
		retained.replace('iput-object p1, p0', 'iput-object p2, p0'),
		retained.replace('nativeInit()J', 'nativeInit()I'),
		retained.replace('.end method', ''),
	] {
		mutations << Mutation{'android/app/Dialog', old.replace(retained, changed)}
	}
	mutations << Mutation{'android/app/Dialog', old.replace(retained, '')}
	mutations << Mutation{'android/app/Dialog', old + '\n' + retained}
	mutations << Mutation{'android/app/Dialog', old + '\n.end method\n'}
	mutations << Mutation{'android/app/Dialog', patched}
	for name, signature in {
		'android/content/Context':             'getTheme()Landroid/content/res/Resources$Theme;'
		'android/view/ContextThemeWrapper':    '<init>(Landroid/content/Context;I)V'
		'android/content/res/Resources$Theme': 'resolveAttribute(ILandroid/util/TypedValue;Z)Z'
		'android/util/TypedValue':             '<init>()V'
		'android/view/Window':                 '<init>(Landroid/content/Context;Landroid/view/Window$Callback;)V'
	} {
		source := sources[name]
		method := methods(source)[signature]
		mutations << Mutation{name, source.replace(method, '')}
		mutations << Mutation{name, source + '\n' + method}
		mutations << Mutation{name, source.replace(method, method.replace('.method public ', '.method public static '))}
		mutations << Mutation{name, source.replace(method, method.replace('.method public ', '.method private '))}
	}
	for name, field in {
		'android/app/Dialog':      '.field private context:Landroid/content/Context;'
		'android/util/TypedValue': '.field public resourceId:I'
		'android/R$attr':          '.field public static final dialogTheme:I = 0x1010308'
	} {
		mutations << Mutation{name, sources[name].replace(field, '')}
		mutations << Mutation{name, sources[name] + '\n' + field + '\n'}
		mutations << Mutation{name, sources[name].replace(field, field + ' altered')}
	}
	mut neighbors := map[string]string{}
	for path in os.walk_ext(root, '.smali') { neighbors[path] = digest(path)! }
	for mutation in mutations {
		assert mutation.text != sources[mutation.name], 'negative mutation did not match'
		path := root + '/' + mutation.name + '.smali'
		os.write_file(path, mutation.text)!
		mut refused := false
		androidtools.framework_dialog_theme(root) or { refused = true }
		assert refused && os.read_file(path)! == mutation.text, 'refusal must precede writes'
		if mutation.name != 'android/app/Dialog' {
			assert os.read_file(root + '/' + target)! == old
		}
		os.write_file(path, sources[mutation.name])!
	}
	for name in dependencies {
		path := root + '/' + name + '.smali'
		os.rm(path)!
		mut refused := false
		androidtools.framework_dialog_theme(root) or { refused = true }
		assert refused && !os.exists(path) && os.read_file(root + '/' + target)! == old
		os.write_file(path, sources[name])!
	}
	androidtools.framework_dialog_theme(root)!
	assert os.read_file(root + '/' + target)! == patched
	for path, pin in neighbors {
		if path != root + '/' + target {
			assert digest(path)! == pin, 'source changed neighbor: ' + path
		}
	}
	assert os.walk_ext(root, '.smali').len == 2108
	println('DIALOG-THEME-SOURCE-PASS rejected=' + (mutations.len + dependencies.len).str() + ' one-constructor native-tail metadata dependencies all-neighbors')
}
