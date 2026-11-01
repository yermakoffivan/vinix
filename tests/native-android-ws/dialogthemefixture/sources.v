// SPDX-License-Identifier: GPL-2.0-or-later
module main

const package_name = 'org.vinix.bootstrap'
const main_type = 'Lorg/vinix/bootstrap/Main;'
const pass_marker = 'DIALOG-THEME-PASS explicit default inherited contexts inflation isolation missing-default'
const fail_marker = 'DIALOG-THEME-FAIL'

fn method(signature string, locals int, body string) string {
	return '.method ${signature}\n.locals ${locals}\n${body}\n.end method\n'
}

fn resource_values() string {
	return '<resources>' +
		'<attr name="colorSurfaceContainerLowest" format="color"/>' +
		'<attr name="fixtureRole" format="color"/><attr name="fixtureBaseOnly" format="color"/>' +
		'<attr name="fixtureOverlayOnly" format="color"/><attr name="fixtureChildOnly" format="color"/>' +
		'<style name="FixtureBase" parent="">' +
		'<item name="fixtureRole">#ff102030</item><item name="fixtureBaseOnly">#ff123456</item>' +
		'<item name="android:dialogTheme">@style/FixtureDefault</item></style>' +
		'<style name="FixtureExplicit" parent="">' +
		'<item name="fixtureRole">#ff203040</item><item name="colorSurfaceContainerLowest">#ff234567</item>' +
		'<item name="fixtureOverlayOnly">#ff345678</item></style>' +
		'<style name="FixtureInherited" parent="@style/FixtureExplicit">' +
		'<item name="fixtureChildOnly">#ff456789</item></style>' +
		'<style name="FixtureDefaultParent" parent="">' +
		'<item name="fixtureRole">#ff405060</item><item name="colorSurfaceContainerLowest">#ff56789a</item></style>' +
		'<style name="FixtureDefault" parent="@style/FixtureDefaultParent">' +
		'<item name="fixtureOverlayOnly">#ff6789ab</item></style>' +
		'<style name="FixtureBare" parent="">' +
		'<item name="fixtureRole">#ff708090</item><item name="fixtureBaseOnly">#ff789abc</item></style></resources>'
}

fn resource_layout() string {
	return '<TextView xmlns:android="http://schemas.android.com/apk/res/android" ' +
		'android:id="@+id/theme_probe" android:layout_width="wrap_content" android:layout_height="wrap_content" ' +
		'android:text="dialog role" android:textColor="?attr/colorSurfaceContainerLowest"/>'
}

fn resource_names() []string {
	return ['attr/colorSurfaceContainerLowest', 'attr/fixtureRole', 'attr/fixtureBaseOnly',
		'attr/fixtureOverlayOnly', 'attr/fixtureChildOnly', 'style/FixtureBase', 'style/FixtureExplicit',
		'style/FixtureInherited', 'style/FixtureDefaultParent', 'style/FixtureDefault', 'style/FixtureBare',
		'layout/theme_probe', 'id/theme_probe'].sorted()
}

// Check the signed table's exact bags, parents, typed colors and references.
fn verify_resource_dump(value string, ids map[string]string) {
	mut blocks := map[string][]string{}
	mut current := ''
	for line in value.split_into_lines() {
		text := line.trim_space()
		if text.starts_with('resource ') {
			parts := text.fields()
			assert parts.len == 3 && parts[2] in ids, 'known signed resource required: ' + text
			current = parts[2]
			assert current !in blocks && parts[1] == ids[current], 'unique exact signed resource ID required'
			blocks[current] = []string{}
		} else if current != '' && text != '' { blocks[current] << text }
	}
	assert blocks.keys().sorted() == resource_names(), 'signed resource membership differs'
	expected := {
		'FixtureBase': {'fixtureRole': '#ff102030', 'fixtureBaseOnly': '#ff123456', 'android:dialogTheme': '@style/FixtureDefault'}
		'FixtureExplicit': {'fixtureRole': '#ff203040', 'colorSurfaceContainerLowest': '#ff234567', 'fixtureOverlayOnly': '#ff345678'}
		'FixtureInherited': {'fixtureChildOnly': '#ff456789'}
		'FixtureDefaultParent': {'fixtureRole': '#ff405060', 'colorSurfaceContainerLowest': '#ff56789a'}
		'FixtureDefault': {'fixtureOverlayOnly': '#ff6789ab'}
		'FixtureBare': {'fixtureRole': '#ff708090', 'fixtureBaseOnly': '#ff789abc'}
	}
	for name, entries in expected {
		lines := blocks['style/' + name]
		assert lines.len == entries.len + 1 && lines[0].contains('(style) size=' + entries.len.str()), 'exact style bag required: ' + name
		parent := match name {
			'FixtureInherited' { 'style/FixtureExplicit' }
			'FixtureDefault' { 'style/FixtureDefaultParent' }
			else { '' }
		}
		if parent == '' { assert !lines[0].contains('parent='), 'unexpected style parent: ' + name }
		else { assert lines[0].contains('parent=' + parent + ' ('), 'exact style parent required: ' + name }
		mut actual := map[string]string{}
		for line in lines[1..] {
			assert line.count('=') == 1, 'one signed bag assignment required'
			key := line.all_before('=')
			assert key !in actual, 'duplicate signed bag key'
			actual[key] = line.all_after('=')
		}
		for attr, data in entries {
			key := if attr == 'android:dialogTheme' { '0x01010308' } else { attr + '(' + ids['attr/' + attr] + ')' }
			assert actual[key] == data, 'exact signed style value required: ' + name + '/' + attr
		}
	}
}

fn verify_layout_dump(value string, ids map[string]string) {
	assert value.count('E: TextView') == 1 && value.count('E: ') == 1, 'one signed TextView root required'
	assert value.contains('android:id(0x010100d0)=@' + ids['id/theme_probe']), 'signed layout ID differs'
	assert value.contains('android:textColor(0x01010098)=?' + ids['attr/colorSurfaceContainerLowest']), 'signed theme color reference differs'
	assert value.contains('android:layout_width(0x010100f4)=-2\n') &&
		value.contains('android:layout_height(0x010100f5)=-2\n'), 'signed wrap-content dimensions differ'
}

fn assertion_source() string {
	mut text := ''
	for name, branch in {'same': 'if-eq', 'different': 'if-ne'} {
		text += method('private static ${name}(Ljava/lang/Object;Ljava/lang/Object;)V', 2, '
${branch} p0, p1, :done
new-instance v0, Ljava/lang/AssertionError;
const-string v1, "Unexpected object identity: ${name}"
invoke-direct {v0, v1}, Ljava/lang/AssertionError;-><init>(Ljava/lang/Object;)V
throw v0
:done
return-void')
	}
	return text + method('private static equal(II)V', 2, '
if-eq p0, p1, :done
new-instance v0, Ljava/lang/AssertionError;
const-string v1, "Expected literal integer or ARGB value"
invoke-direct {v0, v1}, Ljava/lang/AssertionError;-><init>(Ljava/lang/Object;)V
throw v0
:done
return-void') + method('private static color(Landroid/content/res/Resources$Theme;II)V', 3, '
new-instance v0, Landroid/util/TypedValue;
invoke-direct {v0}, Landroid/util/TypedValue;-><init>()V
const/4 v1, 1
invoke-virtual {p0, p1, v0, v1}, Landroid/content/res/Resources$Theme;->resolveAttribute(ILandroid/util/TypedValue;Z)Z
move-result v2
invoke-static {v2, v1}, ${main_type}->equal(II)V
iget v1, v0, Landroid/util/TypedValue;->type:I
const/16 v2, 0x1c
invoke-static {v1, v2}, ${main_type}->equal(II)V
iget v1, v0, Landroid/util/TypedValue;->data:I
invoke-static {v1, p2}, ${main_type}->equal(II)V
return-void') + method('private static absent(Landroid/content/res/Resources$Theme;I)V', 3, '
new-instance v0, Landroid/util/TypedValue;
invoke-direct {v0}, Landroid/util/TypedValue;-><init>()V
const/4 v1, 1
invoke-virtual {p0, p1, v0, v1}, Landroid/content/res/Resources$Theme;->resolveAttribute(ILandroid/util/TypedValue;Z)Z
move-result v1
const/4 v2, 0
invoke-static {v1, v2}, ${main_type}->equal(II)V
return-void')
}

fn theme_source(ids map[string]string) string {
	mut body := ''
	for i, attr in ['fixtureRole', 'colorSurfaceContainerLowest', 'fixtureOverlayOnly', 'fixtureChildOnly'] {
		p := 'p' + (i + 1).str()
		body += 'const v0, ' + ids['attr/' + attr] + '\n'
		if i > 1 { body += 'if-eqz ${p}, :absent_${i}\n' }
		body += 'invoke-static {p0, v0, ${p}}, ${main_type}->color(Landroid/content/res/Resources$Theme;II)V\n'
		if i > 1 {
			body += 'goto :after_${i}\n:absent_${i}\n' +
				'invoke-static {p0, v0}, ${main_type}->absent(Landroid/content/res/Resources$Theme;I)V\n:after_${i}\n'
		}
	}
	body += 'const v0, ' + ids['attr/fixtureBaseOnly'] + '\nconst v1, 0xff123456\n' +
		'invoke-static {p0, v0, v1}, ${main_type}->color(Landroid/content/res/Resources$Theme;II)V\nreturn-void'
	mut base := '
invoke-virtual {p0}, Landroid/content/Context;->getTheme()Landroid/content/res/Resources$Theme;
move-result-object v0
invoke-static {v0, p1}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;)V
'
	for attr, color in {'fixtureRole': '0xff102030', 'fixtureBaseOnly': '0xff123456'} {
		base += 'const v1, ' + ids['attr/' + attr] + '\nconst v2, ${color}\n' +
			'invoke-static {v0, v1, v2}, ${main_type}->color(Landroid/content/res/Resources$Theme;II)V\n'
	}
	for attr in ['colorSurfaceContainerLowest', 'fixtureOverlayOnly', 'fixtureChildOnly'] {
		base += 'const v1, ' + ids['attr/' + attr] + '\ninvoke-static {v0, v1}, ${main_type}->absent(Landroid/content/res/Resources$Theme;I)V\n'
	}
	return method('private static colors(Landroid/content/res/Resources$Theme;IIII)V', 2, body) +
		method('private static base(Landroid/content/Context;Landroid/content/res/Resources$Theme;)V', 3, base + 'return-void')
}

fn dialog_source(ids map[string]string) string {
	return method('private static dialog(Landroid/app/Dialog;Landroid/content/Context;I)Landroid/content/Context;', 7, '
invoke-virtual {p0}, Landroid/app/Dialog;->getContext()Landroid/content/Context;
move-result-object v0
invoke-static {v0, p1}, ${main_type}->different(Ljava/lang/Object;Ljava/lang/Object;)V
instance-of v1, v0, Landroid/view/ContextThemeWrapper;
const/4 v2, 1
invoke-static {v1, v2}, ${main_type}->equal(II)V
move-object v1, v0
check-cast v1, Landroid/view/ContextThemeWrapper;
invoke-virtual {v1}, Landroid/content/ContextWrapper;->getBaseContext()Landroid/content/Context;
move-result-object v1
invoke-static {v1, p1}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;)V
invoke-virtual {v0}, Landroid/content/Context;->getTheme()Landroid/content/res/Resources$Theme;
move-result-object v1
invoke-virtual {p1}, Landroid/content/Context;->getTheme()Landroid/content/res/Resources$Theme;
move-result-object v2
invoke-static {v1, v2}, ${main_type}->different(Ljava/lang/Object;Ljava/lang/Object;)V
invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;
move-result-object v1
invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;
move-result-object v2
invoke-static {v1, v2}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;)V
invoke-virtual {p0}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;
move-result-object v1
invoke-virtual {v1}, Landroid/view/Window;->getContext()Landroid/content/Context;
move-result-object v2
invoke-static {v2, v0}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;)V
invoke-virtual {v1}, Landroid/view/Window;->getDecorView()Landroid/view/View;
move-result-object v1
invoke-virtual {v1}, Landroid/view/View;->getContext()Landroid/content/Context;
move-result-object v2
invoke-static {v2, v0}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;)V
invoke-virtual {p0}, Landroid/app/Dialog;->isShowing()Z
move-result v1
const/4 v2, 0
invoke-static {v1, v2}, ${main_type}->equal(II)V
if-eqz p2, :done
invoke-static {p1}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;
move-result-object v1
invoke-static {v0}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;
move-result-object v3
invoke-static {v1, v3}, ${main_type}->different(Ljava/lang/Object;Ljava/lang/Object;)V
invoke-virtual {v1}, Landroid/view/LayoutInflater;->getContext()Landroid/content/Context;
move-result-object v2
invoke-static {v2, v0}, ${main_type}->different(Ljava/lang/Object;Ljava/lang/Object;)V
move-object v6, v2
invoke-virtual {v3}, Landroid/view/LayoutInflater;->getContext()Landroid/content/Context;
move-result-object v2
invoke-static {v2, v0}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;)V
const-class v2, Landroid/view/LayoutInflater;
invoke-virtual {v0, v2}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;
move-result-object v2
invoke-static {v2, v3}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;)V
invoke-virtual {v1, v0}, Landroid/view/LayoutInflater;->cloneInContext(Landroid/content/Context;)Landroid/view/LayoutInflater;
move-result-object v4
invoke-static {v4, v1}, ${main_type}->different(Ljava/lang/Object;Ljava/lang/Object;)V
invoke-virtual {v4}, Landroid/view/LayoutInflater;->getContext()Landroid/content/Context;
move-result-object v2
invoke-static {v2, v0}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;)V
invoke-virtual {v1}, Landroid/view/LayoutInflater;->getContext()Landroid/content/Context;
move-result-object v2
invoke-static {v2, v6}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;)V
const v2, ${ids['layout/theme_probe']}
const/4 v6, 0
invoke-virtual {v4, v2, v6}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;)Landroid/view/View;
move-result-object v5
invoke-static {v5, v0, p2}, ${main_type}->text(Landroid/view/View;Landroid/content/Context;I)V
invoke-virtual {p0, v2}, Landroid/app/Dialog;->setContentView(I)V
const v2, ${ids['id/theme_probe']}
invoke-virtual {p0, v2}, Landroid/app/Dialog;->findViewById(I)Landroid/view/View;
move-result-object v5
invoke-static {v5, v0, p2}, ${main_type}->text(Landroid/view/View;Landroid/content/Context;I)V
:done
return-object v0') + method('private static text(Landroid/view/View;Landroid/content/Context;I)V', 2, '
instance-of v0, p0, Landroid/widget/TextView;
const/4 v1, 1
invoke-static {v0, v1}, ${main_type}->equal(II)V
invoke-virtual {p0}, Landroid/view/View;->getContext()Landroid/content/Context;
move-result-object v0
invoke-static {v0, p1}, ${main_type}->same(Ljava/lang/Object;Ljava/lang/Object;)V
check-cast p0, Landroid/widget/TextView;
invoke-virtual {p0}, Landroid/widget/TextView;->getCurrentTextColor()I
move-result v0
invoke-static {v0, p2}, ${main_type}->equal(II)V
return-void')
}

fn run_source(ids map[string]string) string {
	mut body := '
new-instance v0, Landroid/view/ContextThemeWrapper;
const v4, ${ids['style/FixtureBase']}
invoke-direct {v0, p0, v4}, Landroid/view/ContextThemeWrapper;-><init>(Landroid/content/Context;I)V
invoke-virtual {v0}, Landroid/content/Context;->getTheme()Landroid/content/res/Resources$Theme;
move-result-object v1
invoke-static {v0, v1}, ${main_type}->base(Landroid/content/Context;Landroid/content/res/Resources$Theme;)V
new-instance v4, Landroid/util/TypedValue;
invoke-direct {v4}, Landroid/util/TypedValue;-><init>()V
const v5, 0x01010308
const/4 v6, 1
invoke-virtual {v1, v5, v4, v6}, Landroid/content/res/Resources$Theme;->resolveAttribute(ILandroid/util/TypedValue;Z)Z
move-result v5
invoke-static {v5, v6}, ${main_type}->equal(II)V
iget v5, v4, Landroid/util/TypedValue;->resourceId:I
const v6, ${ids['style/FixtureDefault']}
invoke-static {v5, v6}, ${main_type}->equal(II)V
invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;
move-result-object v4
invoke-virtual {v4}, Landroid/content/res/Resources;->newTheme()Landroid/content/res/Resources$Theme;
move-result-object v3
invoke-virtual {v3, v1}, Landroid/content/res/Resources$Theme;->setTo(Landroid/content/res/Resources$Theme;)V
const v4, ${ids['style/FixtureExplicit']}
const/4 v5, 1
invoke-virtual {v3, v4, v5}, Landroid/content/res/Resources$Theme;->applyStyle(IZ)V
const v4, 0xff203040
const v5, 0xff234567
const v6, 0xff345678
const/4 v7, 0
invoke-static {v3, v4, v5, v6, v7}, ${main_type}->colors(Landroid/content/res/Resources$Theme;IIII)V
invoke-static {v0, v1}, ${main_type}->base(Landroid/content/Context;Landroid/content/res/Resources$Theme;)V
'
	for kind in ['explicit', 'inherited', 'zero', 'onearg', 'delegated'] {
		is_explicit := kind in ['explicit', 'inherited']
		style := if kind == 'explicit' { ids['style/FixtureExplicit'] } else if kind == 'inherited' { ids['style/FixtureInherited'] } else { '0x0' }
		role := if is_explicit { '0xff203040' } else { '0xff405060' }
		lowest := if is_explicit { '0xff234567' } else { '0xff56789a' }
		overlay := if is_explicit { '0xff345678' } else { '0xff6789ab' }
		child := if kind == 'inherited' { '0xff456789' } else { '0x0' }
		body += 'move-object v8, v0\n'
		if kind == 'delegated' {
			body += 'new-instance v8, Landroid/content/ContextWrapper;\ninvoke-direct {v8, v0}, Landroid/content/ContextWrapper;-><init>(Landroid/content/Context;)V\n'
		}
		body += 'new-instance v2, Landroid/app/Dialog;\n'
		if kind == 'onearg' { body += 'invoke-direct {v2, v8}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V\n' }
		else { body += 'const v4, ${style}\ninvoke-direct {v2, v8, v4}, Landroid/app/Dialog;-><init>(Landroid/content/Context;I)V\n' }
		body += 'const v5, ${lowest}\ninvoke-static {v2, v8, v5}, ${main_type}->dialog(Landroid/app/Dialog;Landroid/content/Context;I)Landroid/content/Context;\nmove-result-object v3\n' +
			'invoke-virtual {v3}, Landroid/content/Context;->getTheme()Landroid/content/res/Resources$Theme;\nmove-result-object v3\n' +
			'const v4, ${role}\nconst v6, ${overlay}\nconst v7, ${child}\n' +
			'invoke-static {v3, v4, v5, v6, v7}, ${main_type}->colors(Landroid/content/res/Resources$Theme;IIII)V\n' +
			'invoke-static {v0, v1}, ${main_type}->base(Landroid/content/Context;Landroid/content/res/Resources$Theme;)V\n' +
			'invoke-virtual {v2}, Landroid/app/Dialog;->dismiss()V\n'
	}
	body += bare_source(ids)
	return method('private run()V', 9, body)
}

fn bare_source(ids map[string]string) string {
	mut body := '
invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;
move-result-object v3
invoke-virtual {v3}, Landroid/content/res/Resources;->newTheme()Landroid/content/res/Resources$Theme;
move-result-object v3
const v4, ${ids['style/FixtureBare']}
const/4 v5, 1
invoke-virtual {v3, v4, v5}, Landroid/content/res/Resources$Theme;->applyStyle(IZ)V
const v4, 0x01010308
invoke-static {v3, v4}, ${main_type}->absent(Landroid/content/res/Resources$Theme;I)V
new-instance v8, Landroid/view/ContextThemeWrapper;
invoke-direct {v8, p0, v3}, Landroid/view/ContextThemeWrapper;-><init>(Landroid/content/Context;Landroid/content/res/Resources$Theme;)V
new-instance v2, Landroid/app/Dialog;
const/4 v4, 0
invoke-direct {v2, v8, v4}, Landroid/app/Dialog;-><init>(Landroid/content/Context;I)V
invoke-static {v2, v8, v4}, ${main_type}->dialog(Landroid/app/Dialog;Landroid/content/Context;I)Landroid/content/Context;
move-result-object v3
invoke-virtual {v3}, Landroid/content/Context;->getTheme()Landroid/content/res/Resources$Theme;
move-result-object v3
'
	for attr, color in {'fixtureRole': '0xff708090', 'fixtureBaseOnly': '0xff789abc'} {
		body += 'const v4, ' + ids['attr/' + attr] + '\nconst v5, ${color}\n' +
			'invoke-static {v3, v4, v5}, ${main_type}->color(Landroid/content/res/Resources$Theme;II)V\n'
	}
	body += 'const v4, ' + ids['attr/colorSurfaceContainerLowest'] + '\n' +
		'invoke-static {v3, v4}, ${main_type}->absent(Landroid/content/res/Resources$Theme;I)V\n' +
		'const v4, 0x01010308\ninvoke-static {v3, v4}, ${main_type}->absent(Landroid/content/res/Resources$Theme;I)V\n' +
		'invoke-virtual {v2}, Landroid/app/Dialog;->dismiss()V\n' +
		'invoke-static {v0, v1}, ${main_type}->base(Landroid/content/Context;Landroid/content/res/Resources$Theme;)V\nreturn-void'
	return body
}

fn fixture_sources(ids map[string]string) map[string]string {
	mut text := '.class public final ${main_type}\n.super Landroid/app/Activity;\n'
	text += method('public constructor <init>()V', 0, 'invoke-direct {p0}, Landroid/app/Activity;-><init>()V\nreturn-void')
	text += assertion_source() + theme_source(ids) + dialog_source(ids) + run_source(ids)
	text += method('public onCreate(Landroid/os/Bundle;)V', 3, '
invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V
:test_start
invoke-direct {p0}, ${main_type}->run()V
:test_end
sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;
const-string v1, "${pass_marker}"
invoke-virtual {v0, v1}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V
invoke-virtual {v0}, Ljava/io/PrintStream;->flush()V
new-instance v0, Landroid/widget/TextView;
invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
const-string v1, "Dialog themes and context propagation passed"
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
	return {'org/vinix/bootstrap/Main.smali': text}
}
