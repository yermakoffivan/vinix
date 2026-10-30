// SPDX-License-Identifier: GPL-2.0-or-later
module main

const package_name = 'org.vinix.bootstrap'
const root_type = 'Lorg/vinix/bootstrap/Main;'
const collector_type = 'Lorg/vinix/bootstrap/Collector;'
const window_type = 'Lorg/vinix/bootstrap/ManagedWindow;'
const manager_type = 'Lorg/vinix/bootstrap/Manager;'
const activity_type = 'Lorg/vinix/bootstrap/ManagedActivity;'
const dialog_type = 'Lorg/vinix/bootstrap/ManagedDialog;'
const params_type = 'Landroid/view/WindowManager$LayoutParams;'
const pass_marker = 'WINDOW-ANIMATIONS-PASS attributes alias always-dispatch callbacks reentrancy exceptions activity dialog'
const fail_marker = 'WINDOW-ANIMATIONS-FAIL'

fn method(signature string, locals int, body string) string {
	return '.method ${signature}\n.locals ${locals}\n${body}\n.end method\n'
}

fn constructor(owner string, parent string) string {
	return '.class public ${owner}\n.super ${parent}\n' + method('public constructor <init>()V', 0,
		'invoke-direct {p0}, ${parent}-><init>()V\nreturn-void')
}

fn check_source() string {
	return method('public static equal(IILjava/lang/String;)V', 1, '
if-eq p0, p1, :done
new-instance v0, Ljava/lang/AssertionError;
invoke-direct {v0, p2}, Ljava/lang/AssertionError;-><init>(Ljava/lang/Object;)V
throw v0
:done
return-void') + method('public static same(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V', 1, '
if-eq p0, p1, :done
new-instance v0, Ljava/lang/AssertionError;
invoke-direct {v0, p2}, Ljava/lang/AssertionError;-><init>(Ljava/lang/Object;)V
throw v0
:done
return-void')
}

fn collector_source() string {
	mut text := constructor(collector_type, 'Landroid/app/Activity;') + '
.field public selected:Landroid/view/Window;
.field public attrs:${params_type}
.field public fields:[Ljava/lang/reflect/Field;
.field public values:[Ljava/lang/Object;
.field public expected:I
.field public calls:I
.field public mode:I
.field public failure:Ljava/lang/RuntimeException;
'
	text += method('public capture()V', 6, '
iget-object v0, p0, ${collector_type}->selected:Landroid/view/Window;
invoke-virtual {v0}, Landroid/view/Window;->getAttributes()${params_type}
move-result-object v0
iput-object v0, p0, ${collector_type}->attrs:${params_type}
const-class v0, ${params_type}
invoke-virtual {v0}, Ljava/lang/Class;->getFields()[Ljava/lang/reflect/Field;
move-result-object v0
iput-object v0, p0, ${collector_type}->fields:[Ljava/lang/reflect/Field;
array-length v1, v0
new-array v1, v1, [Ljava/lang/Object;
iput-object v1, p0, ${collector_type}->values:[Ljava/lang/Object;
const/4 v2, 0
:loop
array-length v3, v0
if-ge v2, v3, :done
aget-object v3, v0, v2
invoke-virtual {v3}, Ljava/lang/reflect/Field;->getModifiers()I
move-result v4
invoke-static {v4}, Ljava/lang/reflect/Modifier;->isStatic(I)Z
move-result v4
if-nez v4, :next
invoke-virtual {v3}, Ljava/lang/reflect/Field;->getName()Ljava/lang/String;
move-result-object v4
const-string v5, "windowAnimations"
invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
move-result v4
if-nez v4, :next
iget-object v4, p0, ${collector_type}->attrs:${params_type}
invoke-virtual {v3, v4}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;
move-result-object v4
aput-object v4, v1, v2
:next
add-int/lit8 v2, v2, 1
goto :loop
:done
return-void')
	text += method('public preserved()V', 7, '
iget-object v0, p0, ${collector_type}->fields:[Ljava/lang/reflect/Field;
iget-object v1, p0, ${collector_type}->values:[Ljava/lang/Object;
const/4 v2, 0
:loop
array-length v3, v0
if-ge v2, v3, :done
aget-object v3, v0, v2
invoke-virtual {v3}, Ljava/lang/reflect/Field;->getModifiers()I
move-result v4
invoke-static {v4}, Ljava/lang/reflect/Modifier;->isStatic(I)Z
move-result v4
if-nez v4, :next
invoke-virtual {v3}, Ljava/lang/reflect/Field;->getName()Ljava/lang/String;
move-result-object v4
const-string v5, "windowAnimations"
invoke-virtual {v5, v4}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z
move-result v4
if-nez v4, :next
iget-object v4, p0, ${collector_type}->attrs:${params_type}
invoke-virtual {v3, v4}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;
move-result-object v4
aget-object v5, v1, v2
invoke-static {v4, v5}, Ljava/util/Objects;->equals(Ljava/lang/Object;Ljava/lang/Object;)Z
move-result v4
const/4 v5, 1
const-string v6, "unrelated LayoutParams field changed"
invoke-static {v4, v5, v6}, ${root_type}->equal(IILjava/lang/String;)V
:next
add-int/lit8 v2, v2, 1
goto :loop
:done
return-void')
	text += method('public onWindowAttributesChanged(${params_type})V', 5, '
iget v0, p0, ${collector_type}->calls:I
add-int/lit8 v0, v0, 1
iput v0, p0, ${collector_type}->calls:I
iget-object v0, p0, ${collector_type}->attrs:${params_type}
const-string v2, "callback must receive the exact attributes alias"
invoke-static {v0, p1, v2}, ${root_type}->same(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V
iget-object v0, p0, ${collector_type}->selected:Landroid/view/Window;
invoke-virtual {v0}, Landroid/view/Window;->getAttributes()${params_type}
move-result-object v1
invoke-static {v1, p1, v2}, ${root_type}->same(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V
iget v1, p1, ${params_type}->windowAnimations:I
iget v2, p0, ${collector_type}->expected:I
const-string v3, "attribute mutation must precede callback"
invoke-static {v1, v2, v3}, ${root_type}->equal(IILjava/lang/String;)V
invoke-virtual {p0}, ${collector_type}->preserved()V
iget v1, p0, ${collector_type}->mode:I
const/4 v2, 1
if-ne v1, v2, :not_reentrant
const/4 v1, 0
iput v1, p0, ${collector_type}->mode:I
const/16 v1, 202
iput v1, p0, ${collector_type}->expected:I
invoke-virtual {v0, v1}, Landroid/view/Window;->setWindowAnimations(I)V
return-void
:not_reentrant
const/4 v2, 2
if-ne v1, v2, :done
iget-object v1, p0, ${collector_type}->failure:Ljava/lang/RuntimeException;
throw v1
:done
return-void')
	return text
}

fn window_source() string {
	return '.class public ${window_type}\n.super Landroid/view/Window;\n' + '
.field public manager:${manager_type}
.field public dispatches:I
' + method('public constructor <init>(Landroid/content/Context;Landroid/view/Window$Callback;${manager_type})V', 0, '
invoke-direct {p0, p1, p2}, Landroid/view/Window;-><init>(Landroid/content/Context;Landroid/view/Window$Callback;)V
iput-object p3, p0, ${window_type}->manager:${manager_type}
return-void') + method('public getWindowManager()Landroid/view/WindowManager;', 1, '
iget-object v0, p0, ${window_type}->manager:${manager_type}
return-object v0') + method('protected dispatchWindowAttributesChanged(${params_type})V', 1, '
iget v0, p0, ${window_type}->dispatches:I
add-int/lit8 v0, v0, 1
iput v0, p0, ${window_type}->dispatches:I
invoke-super {p0, p1}, Landroid/view/Window;->dispatchWindowAttributesChanged(${params_type})V
return-void')
}

fn manager_source() string {
	mut text := constructor(manager_type, 'Ljava/lang/Object;').replace('.super Ljava/lang/Object;',
		'.super Ljava/lang/Object;\n.implements Landroid/view/WindowManager;') + '
.field public updates:I
.field public view:Landroid/view/View;
.field public attrs:Landroid/view/ViewGroup$LayoutParams;
'
	text += method('public updateViewLayout(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V', 1, '
iget v0, p0, ${manager_type}->updates:I
add-int/lit8 v0, v0, 1
iput v0, p0, ${manager_type}->updates:I
iput-object p1, p0, ${manager_type}->view:Landroid/view/View;
iput-object p2, p0, ${manager_type}->attrs:Landroid/view/ViewGroup$LayoutParams;
return-void')
	text += method('public getDefaultDisplay()Landroid/view/Display;', 1, 'const/4 v0, 0\nreturn-object v0')
	for signature in ['addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V',
		'removeView(Landroid/view/View;)V', 'removeViewImmediate(Landroid/view/View;)V'] {
		text += method('public ' + signature, 2, '
new-instance v0, Ljava/lang/AssertionError;
const-string v1, "unexpected WindowManager operation"
invoke-direct {v0, v1}, Ljava/lang/AssertionError;-><init>(Ljava/lang/Object;)V
throw v0')
	}
	return text
}

fn activity_source() string {
	return constructor(activity_type, 'Landroid/app/Activity;') + '
.field public selected:Landroid/view/Window;
.field public manager:${manager_type}
.field public lookups:I
' + method('public getWindow()Landroid/view/Window;', 1,
		'iget-object v0, p0, ${activity_type}->selected:Landroid/view/Window;\nreturn-object v0') +
		method('public getWindowManager()Landroid/view/WindowManager;', 1, '
iget v0, p0, ${activity_type}->lookups:I
add-int/lit8 v0, v0, 1
iput v0, p0, ${activity_type}->lookups:I
iget-object v0, p0, ${activity_type}->manager:${manager_type}
return-object v0')
}

fn dialog_source() string {
	return '.class public ${dialog_type}\n.super Landroid/app/Dialog;\n.field public selected:Landroid/view/Window;\n' +
		method('public constructor <init>(Landroid/content/Context;${manager_type})V', 1, '
invoke-direct {p0, p1}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V
new-instance v0, ${window_type}
invoke-direct {v0, p1, p0, p2}, ${window_type}-><init>(Landroid/content/Context;Landroid/view/Window$Callback;${manager_type})V
iput-object v0, p0, ${dialog_type}->selected:Landroid/view/Window;
return-void') + method('public getWindow()Landroid/view/Window;', 1,
		'iget-object v0, p0, ${dialog_type}->selected:Landroid/view/Window;\nreturn-object v0')
}

fn seed_source() string {
	mut body := ''
	for field, value in {'width': 321, 'height': 123, 'x': 17, 'y': -9, 'flags': 74565, 'type': 2038,
		'format': -3, 'layoutInDisplayCutoutMode': 2, 'softInputMode': 20, 'systemUiVisibility': 256} {
		owner := if field in ['width', 'height'] { 'Landroid/view/ViewGroup$LayoutParams;' } else { params_type }
		body += 'const v0, ${value}\niput v0, p0, ${owner}->${field}:I\n'
	}
	for field, bits in {'alpha': '0x3f000000', 'screenBrightness': '0x3e800000', 'preferredRefreshRate': '0x42700000'} {
		body += 'const v0, ${bits}\niput v0, p0, ${params_type}->${field}:F\n'
	}
	body += '
const-string v0, "fixture-unrelated-attributes"
iput-object v0, p0, ${params_type}->packageName:Ljava/lang/String;
new-instance v0, Landroid/os/Binder;
invoke-direct {v0}, Landroid/os/Binder;-><init>()V
iput-object v0, p0, ${params_type}->token:Landroid/os/IBinder;
return-void'
	return method('private static seed(${params_type})V', 1, body)
}

fn callback_tests() string {
	mut body := '
new-instance v0, ${collector_type}
invoke-direct {v0}, ${collector_type}-><init>()V
new-instance v1, ${window_type}
const/4 v2, 0
invoke-direct {v1, p0, v0, v2}, ${window_type}-><init>(Landroid/content/Context;Landroid/view/Window$Callback;${manager_type})V
iput-object v1, v0, ${collector_type}->selected:Landroid/view/Window;
invoke-virtual {v1}, Landroid/view/Window;->getAttributes()${params_type}
move-result-object v2
iget v3, v2, ${params_type}->windowAnimations:I
const/4 v4, 0
const-string v5, "default animation style"
invoke-static {v3, v4, v5}, ${root_type}->equal(IILjava/lang/String;)V
invoke-static {v2}, ${root_type}->seed(${params_type})V
invoke-virtual {v0}, ${collector_type}->capture()V
'
	for index, value in [7, 7, 0, -4] {
		body += 'const v3, ${value}\niput v3, v0, ${collector_type}->expected:I\n' +
			'invoke-virtual {v1, v3}, Landroid/view/Window;->setWindowAnimations(I)V\n' +
			'iget v3, v0, ${collector_type}->calls:I\nconst/4 v4, ${index + 1}\n' +
			'const-string v5, "every setter call must notify once including same/reset"\n' +
			'invoke-static {v3, v4, v5}, ${root_type}->equal(IILjava/lang/String;)V\n'
	}
	body += '
const/4 v3, 0
invoke-virtual {v1, v3}, Landroid/view/Window;->setCallback(Landroid/view/Window$Callback;)V
const/16 v3, 9
invoke-virtual {v1, v3}, Landroid/view/Window;->setWindowAnimations(I)V
iget v3, v0, ${collector_type}->calls:I
const/4 v4, 4
const-string v5, "null callback must be skipped"
invoke-static {v3, v4, v5}, ${root_type}->equal(IILjava/lang/String;)V
iget v3, v2, ${params_type}->windowAnimations:I
const/16 v4, 9
const-string v5, "null callback still stores the animation style"
invoke-static {v3, v4, v5}, ${root_type}->equal(IILjava/lang/String;)V
invoke-virtual {v0}, ${collector_type}->preserved()V
new-instance v6, ${collector_type}
invoke-direct {v6}, ${collector_type}-><init>()V
iput-object v1, v6, ${collector_type}->selected:Landroid/view/Window;
invoke-virtual {v6}, ${collector_type}->capture()V
const/16 v3, 10
iput v3, v6, ${collector_type}->expected:I
invoke-virtual {v1, v6}, Landroid/view/Window;->setCallback(Landroid/view/Window$Callback;)V
invoke-virtual {v1, v3}, Landroid/view/Window;->setWindowAnimations(I)V
iget v3, v0, ${collector_type}->calls:I
const/4 v4, 4
const-string v5, "replaced callback must stop receiving notifications"
invoke-static {v3, v4, v5}, ${root_type}->equal(IILjava/lang/String;)V
iget v3, v6, ${collector_type}->calls:I
const/4 v4, 1
const-string v5, "replacement callback must receive dispatch"
invoke-static {v3, v4, v5}, ${root_type}->equal(IILjava/lang/String;)V
iput v4, v6, ${collector_type}->mode:I
const/16 v3, 101
iput v3, v6, ${collector_type}->expected:I
invoke-virtual {v1, v3}, Landroid/view/Window;->setWindowAnimations(I)V
iget v3, v6, ${collector_type}->calls:I
const/4 v4, 3
const-string v5, "reentrant dispatch must complete twice"
invoke-static {v3, v4, v5}, ${root_type}->equal(IILjava/lang/String;)V
iget v3, v2, ${params_type}->windowAnimations:I
const/16 v4, 202
invoke-static {v3, v4, v5}, ${root_type}->equal(IILjava/lang/String;)V
new-instance v7, Ljava/lang/RuntimeException;
const-string v3, "fixture expected callback throwable"
invoke-direct {v7, v3}, Ljava/lang/RuntimeException;-><init>(Ljava/lang/String;)V
iput-object v7, v6, ${collector_type}->failure:Ljava/lang/RuntimeException;
const/4 v3, 2
iput v3, v6, ${collector_type}->mode:I
const/16 v3, 303
iput v3, v6, ${collector_type}->expected:I
:throw_start
invoke-virtual {v1, v3}, Landroid/view/Window;->setWindowAnimations(I)V
:throw_end
const/4 v3, 0
const/4 v4, 1
const-string v5, "throwing callback must propagate"
invoke-static {v3, v4, v5}, ${root_type}->equal(IILjava/lang/String;)V
goto :after_throw
.catch Ljava/lang/RuntimeException; {:throw_start .. :throw_end} :expected_throw
:expected_throw
move-exception v3
const-string v5, "original callback throwable identity"
invoke-static {v3, v7, v5}, ${root_type}->same(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V
:after_throw
iget v3, v2, ${params_type}->windowAnimations:I
const/16 v4, 303
const-string v5, "mutation survives callback failure"
invoke-static {v3, v4, v5}, ${root_type}->equal(IILjava/lang/String;)V
const/4 v3, 0
iput v3, v6, ${collector_type}->mode:I
iput v3, v6, ${collector_type}->expected:I
invoke-virtual {v1, v3}, Landroid/view/Window;->setWindowAnimations(I)V
iget v3, v6, ${collector_type}->calls:I
const/4 v4, 5
const-string v5, "callback remains usable after failure"
invoke-static {v3, v4, v5}, ${root_type}->equal(IILjava/lang/String;)V
iget v3, v1, ${window_type}->dispatches:I
const/16 v4, 10
const-string v5, "protected virtual dispatch always runs including null callback"
invoke-static {v3, v4, v5}, ${root_type}->equal(IILjava/lang/String;)V
return-void'
	return method('private callbacks()V', 8, body)
}

fn owner_tests() string {
	return method('private owners()V', 8, '
new-instance v0, Landroid/app/Activity;
invoke-direct {v0}, Landroid/app/Activity;-><init>()V
new-instance v1, ${params_type}
invoke-direct {v1}, ${params_type}-><init>()V
invoke-virtual {v0, v1}, Landroid/app/Activity;->onWindowAttributesChanged(${params_type})V
new-instance v0, ${activity_type}
invoke-direct {v0}, ${activity_type}-><init>()V
new-instance v1, ${manager_type}
invoke-direct {v1}, ${manager_type}-><init>()V
iput-object v1, v0, ${activity_type}->manager:${manager_type}
new-instance v2, ${window_type}
invoke-direct {v2, p0, v0, v1}, ${window_type}-><init>(Landroid/content/Context;Landroid/view/Window$Callback;${manager_type})V
iput-object v2, v0, ${activity_type}->selected:Landroid/view/Window;
const/16 v3, 23
invoke-virtual {v2, v3}, Landroid/view/Window;->setWindowAnimations(I)V
iget v3, v1, ${manager_type}->updates:I
const/4 v4, 0
const-string v5, "unattached Activity must not update WM"
invoke-static {v3, v4, v5}, ${root_type}->equal(IILjava/lang/String;)V
iget v3, v0, ${activity_type}->lookups:I
invoke-static {v3, v4, v5}, ${root_type}->equal(IILjava/lang/String;)V
new-instance v3, Landroid/widget/FrameLayout;
invoke-direct {v3, p0}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V
invoke-virtual {v2}, Landroid/view/Window;->getDecorView()Landroid/view/View;
move-result-object v6
invoke-virtual {v3, v6}, Landroid/view/ViewGroup;->addView(Landroid/view/View;)V
const/16 v3, 23
invoke-virtual {v2, v3}, Landroid/view/Window;->setWindowAnimations(I)V
iget v3, v1, ${manager_type}->updates:I
const/4 v4, 1
const-string v5, "attached Activity must update WM on repeated value"
invoke-static {v3, v4, v5}, ${root_type}->equal(IILjava/lang/String;)V
invoke-virtual {v2}, Landroid/view/Window;->getAttributes()${params_type}
move-result-object v7
iget-object v3, v1, ${manager_type}->attrs:Landroid/view/ViewGroup$LayoutParams;
invoke-static {v3, v7, v5}, ${root_type}->same(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V
iget-object v3, v1, ${manager_type}->view:Landroid/view/View;
invoke-static {v3, v6, v5}, ${root_type}->same(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V
new-instance v1, ${manager_type}
invoke-direct {v1}, ${manager_type}-><init>()V
new-instance v0, ${dialog_type}
invoke-direct {v0, p0, v1}, ${dialog_type}-><init>(Landroid/content/Context;${manager_type})V
invoke-virtual {v0}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;
move-result-object v2
const/16 v3, 44
invoke-virtual {v2, v3}, Landroid/view/Window;->setWindowAnimations(I)V
iget v3, v1, ${manager_type}->updates:I
const/4 v4, 0
const-string v5, "pre-show Dialog must not update WM"
invoke-static {v3, v4, v5}, ${root_type}->equal(IILjava/lang/String;)V
invoke-virtual {v0}, Landroid/app/Dialog;->isShowing()Z
move-result v3
invoke-static {v3, v4, v5}, ${root_type}->equal(IILjava/lang/String;)V
invoke-virtual {v0}, Landroid/app/Dialog;->show()V
invoke-virtual {v0}, Landroid/app/Dialog;->isShowing()Z
move-result v3
const/4 v4, 1
const-string v5, "fixture Dialog show must be synchronous on main Looper"
invoke-static {v3, v4, v5}, ${root_type}->equal(IILjava/lang/String;)V
const/16 v3, 44
invoke-virtual {v2, v3}, Landroid/view/Window;->setWindowAnimations(I)V
iget v3, v1, ${manager_type}->updates:I
const-string v5, "shown Dialog must update recording WM on repeated value"
invoke-static {v3, v4, v5}, ${root_type}->equal(IILjava/lang/String;)V
invoke-virtual {v2}, Landroid/view/Window;->getAttributes()${params_type}
move-result-object v7
iget-object v3, v1, ${manager_type}->attrs:Landroid/view/ViewGroup$LayoutParams;
invoke-static {v3, v7, v5}, ${root_type}->same(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V
invoke-virtual {v2}, Landroid/view/Window;->getDecorView()Landroid/view/View;
move-result-object v6
iget-object v3, v1, ${manager_type}->view:Landroid/view/View;
invoke-static {v3, v6, v5}, ${root_type}->same(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;)V
const/4 v3, 0
invoke-virtual {v2, v3}, Landroid/view/Window;->setWindowAnimations(I)V
iget v3, v1, ${manager_type}->updates:I
const/4 v4, 2
invoke-static {v3, v4, v5}, ${root_type}->equal(IILjava/lang/String;)V
invoke-virtual {v0}, Landroid/app/Dialog;->hide()V
const/4 v3, 0
invoke-virtual {v2, v3}, Landroid/view/Window;->setWindowAnimations(I)V
iget v3, v1, ${manager_type}->updates:I
const-string v5, "hidden Dialog must stop WM updates"
invoke-static {v3, v4, v5}, ${root_type}->equal(IILjava/lang/String;)V
invoke-virtual {v0}, Landroid/app/Dialog;->isShowing()Z
move-result v3
const/4 v4, 0
invoke-static {v3, v4, v5}, ${root_type}->equal(IILjava/lang/String;)V
return-void')
}

fn main_source() string {
	return constructor(root_type, 'Landroid/app/Activity;') + check_source() + seed_source() +
		callback_tests() + owner_tests() + method('public onCreate(Landroid/os/Bundle;)V', 3, '
invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V
:test_start
invoke-direct {p0}, ${root_type}->callbacks()V
invoke-direct {p0}, ${root_type}->owners()V
:test_end
sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;
const-string v1, "${pass_marker}"
invoke-virtual {v0, v1}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V
invoke-virtual {v0}, Ljava/io/PrintStream;->flush()V
new-instance v0, Landroid/widget/TextView;
invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
const-string v1, "Window animation attributes passed"
invoke-virtual {v0, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
invoke-virtual {p0, v0}, Landroid/app/Activity;->setContentView(Landroid/view/View;)V
return-void
.catchall {:test_start .. :test_end} :failed
:failed
move-exception v2
sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;
const-string v1, "${fail_marker}"
invoke-virtual {v0, v1}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V
invoke-virtual {v0}, Ljava/io/PrintStream;->flush()V
throw v2')
}

fn fixture_sources() map[string]string {
	return {
		'org/vinix/bootstrap/Main.smali': main_source()
		'org/vinix/bootstrap/Collector.smali': collector_source()
		'org/vinix/bootstrap/ManagedWindow.smali': window_source()
		'org/vinix/bootstrap/Manager.smali': manager_source()
		'org/vinix/bootstrap/ManagedActivity.smali': activity_source()
		'org/vinix/bootstrap/ManagedDialog.smali': dialog_source()
	}
}
