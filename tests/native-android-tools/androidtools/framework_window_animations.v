// SPDX-License-Identifier: GPL-2.0-or-later
module androidtools

import os

fn window_animations_class(source string, declaration string, parent string) ! {
	if source.split_into_lines().filter(it.starts_with('.class ')) != ['.class ' + declaration]
		|| source.split_into_lines().filter(it.starts_with('.super ')) != ['.super ' + parent] {
		return error('canonical window animation owner required: ' + declaration)
	}
	for name in ['setWindowAnimations(', 'dispatchWindowAttributesChanged(', 'onWindowAttributesChanged('] {
		if source.contains(name) { return error('window attributes API already present: ' + name) }
	}
}

fn window_animations_method(source string, header string, body string) ! {
	mut found := 0
	for block in source.split('.method ')[1..] {
		if block.all_before('\n').all_after_last(' ') != header.all_after_last(' ') { continue }
		found++
		if block.all_before('\n') != header { return error('retained window method header required') }
		end := block.index('.end method') or { return error('unterminated window method') }
		if body != '' {
			start := block.index('\n') or { return error('missing window method body') }
			actual := block[start + 1..end].split_into_lines().map(it.all_before('#').trim_space()).filter(it != '').join('\n')
			if actual != body { return error('retained window method body required: ' + header) }
		}
	}
	if found != 1 { return error('unique retained window method required: ' + header) }
}

// Android stores the style resource on the same attributes object and always
// dispatches, including when the value is unchanged. The compositor does not
// execute window animation resources; this adds the application-facing contract.
pub fn framework_window_animations_source(original string) !string {
	window_animations_class(original, 'public Landroid/view/Window;', 'Ljava/lang/Object;')!
	window_animations_method(original, 'public getAttributes()Landroid/view/WindowManager$LayoutParams;', '.registers 2\niget-object v0, p0, Landroid/view/Window;->params:Landroid/view/WindowManager$LayoutParams;\nreturn-object v0')!
	window_animations_method(original, 'public final getCallback()Landroid/view/Window$Callback;', '.registers 2\niget-object v0, p0, Landroid/view/Window;->callback:Landroid/view/Window$Callback;\nreturn-object v0')!
	window_animations_method(original, 'public getDecorView()Landroid/view/View;', '.registers 2\niget-object v0, p0, Landroid/view/Window;->decorView:Landroid/view/ViewGroup;\nreturn-object v0')!
	return original + '
.method public setWindowAnimations(I)V
.locals 1
invoke-virtual {p0}, Landroid/view/Window;->getAttributes()Landroid/view/WindowManager$LayoutParams;
move-result-object v0
iput p1, v0, Landroid/view/WindowManager$LayoutParams;->windowAnimations:I
invoke-virtual {p0, v0}, Landroid/view/Window;->dispatchWindowAttributesChanged(Landroid/view/WindowManager$LayoutParams;)V
return-void
.end method

.method protected dispatchWindowAttributesChanged(Landroid/view/WindowManager$LayoutParams;)V
.locals 1
invoke-virtual {p0}, Landroid/view/Window;->getCallback()Landroid/view/Window$Callback;
move-result-object v0
if-eqz v0, :done
invoke-interface {v0, p1}, Landroid/view/Window$Callback;->onWindowAttributesChanged(Landroid/view/WindowManager$LayoutParams;)V
:done
return-void
.end method
'
}

pub fn framework_window_animations_callback_source(original string) !string {
	window_animations_class(original, 'public interface abstract Landroid/view/Window$Callback;', 'Ljava/lang/Object;')!
	return original + '\n.method public abstract onWindowAttributesChanged(Landroid/view/WindowManager$LayoutParams;)V\n.end method\n'
}

pub fn framework_window_animations_activity_source(original string) !string {
	window_animations_class(original, 'public Landroid/app/Activity;', 'Landroid/view/ContextThemeWrapper;')!
	if original.split_into_lines().filter(it == '.implements Landroid/view/Window$Callback;').len != 1 {
		return error('Activity must implement Window.Callback')
	}
	window_animations_method(original, 'public getWindow()Landroid/view/Window;', '.registers 2\niget-object v0, p0, Landroid/app/Activity;->window:Landroid/view/Window;\nreturn-object v0')!
	window_animations_method(original, 'public getWindowManager()Landroid/view/WindowManager;', '')!
	// getDecorView() on the retained Window only reads its existing decor field.
	// An unattached Activity must not ask WindowManager to update a native view.
	return original + '
.method public onWindowAttributesChanged(Landroid/view/WindowManager$LayoutParams;)V
.locals 3
invoke-virtual {p0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;
move-result-object v0
if-eqz v0, :done
invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;
move-result-object v1
if-eqz v1, :done
invoke-virtual {v1}, Landroid/view/View;->getParent()Landroid/view/ViewParent;
move-result-object v2
if-eqz v2, :done
invoke-virtual {p0}, Landroid/app/Activity;->getWindowManager()Landroid/view/WindowManager;
move-result-object v0
invoke-interface {v0, v1, p1}, Landroid/view/WindowManager;->updateViewLayout(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
:done
return-void
.end method
'
}

pub fn framework_window_animations_dialog_source(original string) !string {
	window_animations_class(original, 'public Landroid/app/Dialog;', 'Ljava/lang/Object;')!
	if original.split_into_lines().filter(it == '.implements Landroid/view/Window$Callback;').len != 1 {
		return error('Dialog must implement Window.Callback')
	}
	window_animations_method(original, 'public getWindow()Landroid/view/Window;', '.registers 2\niget-object v0, p0, Landroid/app/Dialog;->window:Landroid/view/Window;\nreturn-object v0')!
	window_animations_method(original, 'public isShowing()Z', '')!
	// Dialog's native window exists before show(), unlike AOSP's nullable mDecor.
	// Use its existing visibility query to avoid an update before first show.
	return original + '
.method public onWindowAttributesChanged(Landroid/view/WindowManager$LayoutParams;)V
.locals 2
invoke-virtual {p0}, Landroid/app/Dialog;->isShowing()Z
move-result v0
if-eqz v0, :done
invoke-virtual {p0}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;
move-result-object v0
if-eqz v0, :done
invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;
move-result-object v1
if-eqz v1, :done
invoke-virtual {v0}, Landroid/view/Window;->getWindowManager()Landroid/view/WindowManager;
move-result-object v0
invoke-interface {v0, v1, p1}, Landroid/view/WindowManager;->updateViewLayout(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V
:done
return-void
.end method
'
}

pub fn framework_window_animations(smali string) ! {
	params := os.read_file(smali + '/android/view/WindowManager$LayoutParams.smali')!
	if params.split_into_lines().filter(it == '.field public windowAnimations:I').len != 1 {
		return error('existing public windowAnimations field required')
	}
	// Reject every malformed input before modifying any of the four classes.
	patched := {
		'android/view/Window': framework_window_animations_source(os.read_file(smali + '/android/view/Window.smali')!)!
		'android/view/Window$Callback': framework_window_animations_callback_source(os.read_file(smali + '/android/view/Window$Callback.smali')!)!
		'android/app/Activity': framework_window_animations_activity_source(os.read_file(smali + '/android/app/Activity.smali')!)!
		'android/app/Dialog': framework_window_animations_dialog_source(os.read_file(smali + '/android/app/Dialog.smali')!)!
	}
	for name, source in patched { os.write_file(smali + '/' + name + '.smali', source)! }
}
