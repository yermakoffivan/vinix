// SPDX-License-Identifier: GPL-2.0-or-later
module androidtools

import os

fn dialog_theme_norm(text string) string {
	return text.split_into_lines().map(it.trim_space()).filter(it != '' && !it.starts_with('#')).join('\n')
}

fn dialog_theme_methods(source string) !map[string]string {
	mut methods := map[string]string{}
	for block in source.split('.method ')[1..] {
		name := block.all_before('\n').all_after_last(' ')
		if name in methods || !block.contains('.end method') {
			return error('unique complete dialog theme methods required')
		}
		methods[name] = '.method ' + block.all_before('.end method') + '.end method'
	}
	if source.count('.end method') != methods.len {
		return error('complete dialog theme method schema required')
	}
	return methods
}

fn dialog_theme_dependency(source string, declaration string, parent string, required map[string]string, fields []string) ! {
	if source.split_into_lines().filter(it.starts_with('.class ')) != ['.class ' + declaration]
		|| source.split_into_lines().filter(it.starts_with('.super ')) != ['.super ' + parent] {
		return error('canonical dialog theme dependency required: ' + declaration)
	}
	methods := dialog_theme_methods(source)!
	for signature, header in required {
		method := methods[signature] or { return error('missing dialog theme dependency: ' + signature) }
		if method.all_before('\n') != '.method ' + header + ' ' + signature {
			return error('retained dialog theme dependency ABI required: ' + signature)
		}
	}
	for field in fields {
		if source.split_into_lines().filter(it == field).len != 1 {
			return error('retained dialog theme field required: ' + field)
		}
	}
}

pub fn framework_dialog_theme_source(sources map[string]string) !string {
	original := sources['android/app/Dialog'] or { return error('Dialog source required') }
	dialog_theme_dependency(original, 'public Landroid/app/Dialog;', 'Ljava/lang/Object;', {
		'<init>(Landroid/content/Context;)V':    'public constructor'
		'<init>(Landroid/content/Context;I)V':   'public constructor'
		'getContext()Landroid/content/Context;': 'public'
		'getWindow()Landroid/view/Window;':      'public'
		'nativeInit()J':                         'protected native'
	}, ['.field private context:Landroid/content/Context;',
		'.field private window:Landroid/view/Window;', '.field protected nativePtr:J'])!
	for name, declaration in {
		'android/content/Context':             'public abstract Landroid/content/Context;|Ljava/lang/Object;'
		'android/view/ContextThemeWrapper':    'public Landroid/view/ContextThemeWrapper;|Landroid/content/ContextWrapper;'
		'android/content/res/Resources$Theme': 'public final Landroid/content/res/Resources$Theme;|Ljava/lang/Object;'
		'android/util/TypedValue':             'public Landroid/util/TypedValue;|Ljava/lang/Object;'
		'android/view/Window':                 'public Landroid/view/Window;|Ljava/lang/Object;'
		'android/R$attr':                      'public final Landroid/R$attr;|Ljava/lang/Object;'
	} {
		text := sources[name] or { return error('missing dialog theme dependency class: ' + name) }
		parts := declaration.split('|')
		required := match name {
			'android/content/Context' {
				{
					'getTheme()Landroid/content/res/Resources$Theme;': 'public abstract'
				}
			}
			'android/view/ContextThemeWrapper' {
				{
					'<init>(Landroid/content/Context;I)V':             'public constructor'
					'getTheme()Landroid/content/res/Resources$Theme;': 'public'
				}
			}
			'android/content/res/Resources$Theme' {
				{
					'resolveAttribute(ILandroid/util/TypedValue;Z)Z': 'public'
				}
			}
			'android/util/TypedValue' { {
				'<init>()V': 'public constructor'
			} }
			'android/view/Window' {
				{
					'<init>(Landroid/content/Context;Landroid/view/Window$Callback;)V': 'public constructor'
					'set_native_window(J)V':                                            'public'
					'getContext()Landroid/content/Context;':                            'public'
				}
			}
			else { map[string]string{} }
		}
		fields := match name {
			'android/util/TypedValue' { ['.field public resourceId:I'] }
			'android/R$attr' { ['.field public static final dialogTheme:I = 0x1010308'] }
			else { []string{} }
		}
		dialog_theme_dependency(text, parts[0], parts[1], required, fields)!
	}
	methods := dialog_theme_methods(original)!
	old := methods['<init>(Landroid/content/Context;I)V'] or { return error('retained Dialog constructor required') }
	expected := '.method public constructor <init>(Landroid/content/Context;I)V
.registers 7
invoke-direct {p0}, Ljava/lang/Object;-><init>()V
iput-object p1, p0, Landroid/app/Dialog;->context:Landroid/content/Context;
new-instance v0, Landroid/view/Window;
invoke-direct {v0, p1, p0}, Landroid/view/Window;-><init>(Landroid/content/Context;Landroid/view/Window$Callback;)V
iput-object v0, p0, Landroid/app/Dialog;->window:Landroid/view/Window;
invoke-virtual {p0}, Landroid/app/Dialog;->nativeInit()J
move-result-wide v0
iput-wide v0, p0, Landroid/app/Dialog;->nativePtr:J
iget-object v0, p0, Landroid/app/Dialog;->window:Landroid/view/Window;
iget-wide v2, p0, Landroid/app/Dialog;->nativePtr:J
invoke-virtual {v0, v2, v3}, Landroid/view/Window;->set_native_window(J)V
return-void
.end method'
	if dialog_theme_norm(old) != expected {
		return error('retained unthemed Dialog constructor required')
	}
	// Match Android 10: a zero ID selects android:dialogTheme, then the dialog
	// and its Window share a fresh wrapper. Native window setup stays unchanged.
	next := '.method public constructor <init>(Landroid/content/Context;I)V
.registers 7
invoke-direct {p0}, Ljava/lang/Object;-><init>()V
if-nez p2, :theme_selected
new-instance v0, Landroid/util/TypedValue;
invoke-direct {v0}, Landroid/util/TypedValue;-><init>()V
invoke-virtual {p1}, Landroid/content/Context;->getTheme()Landroid/content/res/Resources$Theme;
move-result-object v1
sget v2, Landroid/R$attr;->dialogTheme:I
const/4 v3, 0x1
invoke-virtual {v1, v2, v0, v3}, Landroid/content/res/Resources$Theme;->resolveAttribute(ILandroid/util/TypedValue;Z)Z
iget p2, v0, Landroid/util/TypedValue;->resourceId:I
:theme_selected
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
	return original.replace(old, next)
}

pub fn framework_dialog_theme(smali string) ! {
	mut sources := map[string]string{}
	for name in ['android/app/Dialog', 'android/content/Context', 'android/view/ContextThemeWrapper',
		'android/content/res/Resources$Theme', 'android/util/TypedValue', 'android/view/Window',
		'android/R$attr'] {
		sources[name] = os.read_file(smali + '/' + name + '.smali')!
	}
	patched := framework_dialog_theme_source(sources)!
	os.write_file(smali + '/android/app/Dialog.smali', patched)!
}
