// SPDX-License-Identifier: GPL-2.0-or-later
module androidtools

import os

fn window_system_ui_method(source string, header string) !string {
	mut found := ''
	for block in source.split('.method ')[1..] {
		if block.all_before('\n').all_after_last(' ') != header.all_after_last(' ') { continue }
		if found != '' || block.all_before('\n') != header {
			return error('unique WindowManager.LayoutParams method required: ' + header)
		}
		end := block.index('.end method') or { return error('unterminated WindowManager.LayoutParams method') }
		found = '.method ' + block[..end + '.end method'.len]
	}
	if found == '' { return error('missing WindowManager.LayoutParams method: ' + header) }
	return found
}

fn window_system_ui_lines(source string) string {
	return source.split_into_lines().map(it.all_before('#').trim_space()).filter(it != '').join('\n')
}

// LayoutParams has no copy/parcel implementation in the retained framework.
// Its constructors inherit the VM's zero initialization, and Window keeps the
// supplied attributes object. Preserve those paths and retain this app field.
pub fn framework_window_system_ui_source(original string) !string {
	if original.split_into_lines().filter(it.starts_with('.class ')) != ['.class public Landroid/view/WindowManager$LayoutParams;']
		|| original.split_into_lines().filter(it.starts_with('.super ')) != ['.super Landroid/view/ViewGroup$LayoutParams;'] {
		return error('canonical WindowManager.LayoutParams class required')
	}
	mut fields := original.split_into_lines().filter(it.starts_with('.field '))
	fields.sort()
	mut wanted := window_system_ui_fields.clone()
	wanted.sort()
	if fields != wanted { return error('canonical WindowManager.LayoutParams fields required') }
	mut headers := original.split_into_lines().filter(it.starts_with('.method ')).map(it.all_after('.method '))
	headers.sort()
	mut expected := ['public constructor <init>()V', 'public constructor <init>(IIIII)V', 'public setTitle(Ljava/lang/CharSequence;)V']
	expected.sort()
	if headers != expected || original.count('.end method') != 3 {
		return error('canonical WindowManager.LayoutParams method schema required')
	}
	for header, body in {
		'public constructor <init>()V': '.registers 2\ninvoke-direct {p0}, Landroid/view/ViewGroup$LayoutParams;-><init>()V\nconst/high16 v0, -0x40800000\niput v0, p0, Landroid/view/WindowManager$LayoutParams;->screenBrightness:F\nreturn-void'
		'public constructor <init>(IIIII)V': '.registers 7\ninvoke-direct {p0, p1, p2}, Landroid/view/ViewGroup$LayoutParams;-><init>(II)V\nconst/high16 v0, -0x40800000\niput v0, p0, Landroid/view/WindowManager$LayoutParams;->screenBrightness:F\nreturn-void'
		'public setTitle(Ljava/lang/CharSequence;)V': '.registers 2\nreturn-void'
	} {
		method := window_system_ui_method(original, header)!
		if window_system_ui_lines(method) != '.method ' + header + '\n' + body + '\n.end method' {
			return error('retained WindowManager.LayoutParams method body required: ' + header)
		}
	}
	return original + '\n.field public systemUiVisibility:I\n'
}

pub fn framework_window_system_ui(smali string) ! {
	path := smali + '/android/view/WindowManager$LayoutParams.smali'
	patched := framework_window_system_ui_source(os.read_file(path)!)!
	os.write_file(path, patched)!
}

const window_system_ui_fields = [
	'.field public static final FLAG_DIM_BEHIND:I = 0x2',
	'.field public static final FLAG_KEEP_SCREEN_ON:I = 0x0',
	'.field public static final FLAG_NOT_FOCUSABLE:I = 0x8',
	'.field public alpha:F', '.field public flags:I', '.field public format:I',
	'.field public layoutInDisplayCutoutMode:I', '.field public packageName:Ljava/lang/String;',
	'.field public preferredRefreshRate:F', '.field public screenBrightness:F',
	'.field public softInputMode:I', '.field public token:Landroid/os/IBinder;',
	'.field public type:I', '.field public windowAnimations:I', '.field public x:I', '.field public y:I',
]
