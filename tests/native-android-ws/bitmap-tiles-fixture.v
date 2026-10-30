// SPDX-License-Identifier: GPL-2.0-or-later
// Signed ART regression for BitmapDrawable mode state and actual offscreen pixels.
module main

import crypto.sha256
import json2
import os

const package_name = 'org.vinix.bootstrap'
const main_type = 'Lorg/vinix/bootstrap/Main;'
const drawable_type = 'Landroid/graphics/drawable/BitmapDrawable;'
const mode_type = 'Landroid/graphics/Shader$TileMode;'
const pass_marker = 'BITMAP-TILES-PASS modes reset invalidation stable-paint pixels-repeat-mirror-clamp nullable-axis'
const fail_marker = 'BITMAP-TILES-FAIL'

fn method(signature string, locals int, body string) string {
	return '.method ${signature}\n.locals ${locals}\n${body}\n.end method\n'
}

fn failure(message string) string {
	return ':bad\nnew-instance v0, Ljava/lang/AssertionError;\nconst-string v1, "${message}"\n' +
		'invoke-direct {v0, v1}, Ljava/lang/AssertionError;-><init>(Ljava/lang/Object;)V\nthrow v0'
}

fn bitmap_source() string {
	return method('private static drawable()${drawable_type}', 10, '
const/4 v0, 4
new-array v9, v0, [I
fill-array-data v9, :colors
const/4 v1, 2
sget-object v2, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;
invoke-static {v1, v1, v2}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;
move-result-object v0
move-object v8, v0
move-object v1, v9
const/4 v2, 0
const/4 v3, 2
const/4 v4, 0
const/4 v5, 0
const/4 v6, 2
const/4 v7, 2
invoke-virtual/range {v0 .. v7}, Landroid/graphics/Bitmap;->setPixels([IIIIIII)V
new-instance v1, ${drawable_type}
invoke-direct {v1, v8}, ${drawable_type}-><init>(Landroid/graphics/Bitmap;)V
return-object v1
:colors
.array-data 4
0xffc02010
0xff10c030
0xff2030c0
0xffe0e0e0
.end array-data') + method('private static color(I)I', 1, '
if-eqz p0, :red
const/4 v0, 1
if-eq p0, v0, :green
const/4 v0, 2
if-eq p0, v0, :blue
const v0, 0xffe0e0e0
return v0
:red
const v0, 0xffc02010
return v0
:green
const v0, 0xff10c030
return v0
:blue
const v0, 0xff2030c0
return v0') + method('private static coordinate(II)I', 1, '
if-nez p1, :not_clamp
const/4 v0, 0
invoke-static {p0, v0}, Ljava/lang/Math;->max(II)I
move-result p0
const/4 v0, 1
invoke-static {p0, v0}, Ljava/lang/Math;->min(II)I
move-result v0
return v0
:not_clamp
const/4 v0, 2
if-ne p1, v0, :mirror
and-int/lit8 v0, p0, 1
return v0
:mirror
and-int/lit8 v0, p0, 3
const/4 p0, 1
if-le v0, p0, :done
rsub-int/lit8 v0, v0, 3
:done
return v0')
}

fn mode_source() string {
	mut source := method('private static expectModes(${drawable_type}${mode_type}${mode_type})V', 2, '
invoke-virtual {p0}, ${drawable_type}->getTileModeX()${mode_type}
move-result-object v0
if-ne v0, p1, :bad
invoke-virtual {p0}, ${drawable_type}->getTileModeY()${mode_type}
move-result-object v0
if-ne v0, p2, :bad
return-void
' + failure('Tile mode getters must retain each nullable axis independently'))
	source += method('public invalidateDrawable(Landroid/graphics/drawable/Drawable;)V', 1, '
iget v0, p0, ${main_type}->invalidations:I
add-int/lit8 v0, v0, 1
iput v0, p0, ${main_type}->invalidations:I
return-void')
	source += method('public scheduleDrawable(Landroid/graphics/drawable/Drawable;Ljava/lang/Runnable;J)V', 0, 'return-void')
	source += method('public unscheduleDrawable(Landroid/graphics/drawable/Drawable;Ljava/lang/Runnable;)V', 0, 'return-void')
	source += method('private expectInvalidations(I)V', 2, '
iget v0, p0, ${main_type}->invalidations:I
if-ne v0, p1, :bad
return-void
' + failure('Tile setters must invalidate once per changed pair and never for an unchanged pair'))
	mut body := '
invoke-static {}, ${main_type}->drawable()${drawable_type}
move-result-object v0
const/4 v1, 0
invoke-static {v0, v1, v1}, ${main_type}->expectModes(${drawable_type}${mode_type}${mode_type})V
invoke-virtual {v0}, ${drawable_type}->getPaint()Landroid/graphics/Paint;
move-result-object v1
if-eqz v1, :bad
invoke-virtual {v0}, ${drawable_type}->getPaint()Landroid/graphics/Paint;
move-result-object v2
if-ne v1, v2, :bad
const v2, 0xff112233
invoke-virtual {v1, v2}, Landroid/graphics/Paint;->setColor(I)V
invoke-virtual {v0}, ${drawable_type}->getPaint()Landroid/graphics/Paint;
move-result-object v1
invoke-virtual {v1}, Landroid/graphics/Paint;->getColor()I
move-result v1
if-ne v1, v2, :bad
invoke-virtual {v0, p0}, ${drawable_type}->setCallback(Landroid/graphics/drawable/Drawable$Callback;)V
const/4 v1, 0
iput v1, p0, ${main_type}->invalidations:I
invoke-virtual {v0, v1, v1}, ${drawable_type}->setTileModeXY(${mode_type}${mode_type})V
invoke-direct {p0, v1}, ${main_type}->expectInvalidations(I)V
sget-object v1, ${mode_type}->REPEAT:${mode_type}
invoke-virtual {v0, v1}, ${drawable_type}->setTileModeX(${mode_type})V
const/4 v2, 0
invoke-static {v0, v1, v2}, ${main_type}->expectModes(${drawable_type}${mode_type}${mode_type})V
const/4 v2, 1
invoke-direct {p0, v2}, ${main_type}->expectInvalidations(I)V
invoke-virtual {v0, v1}, ${drawable_type}->setTileModeX(${mode_type})V
invoke-direct {p0, v2}, ${main_type}->expectInvalidations(I)V
sget-object v2, ${mode_type}->MIRROR:${mode_type}
invoke-virtual {v0, v2}, ${drawable_type}->setTileModeY(${mode_type})V
invoke-static {v0, v1, v2}, ${main_type}->expectModes(${drawable_type}${mode_type}${mode_type})V
const/4 v3, 2
invoke-direct {p0, v3}, ${main_type}->expectInvalidations(I)V
invoke-virtual {v0, v1, v2}, ${drawable_type}->setTileModeXY(${mode_type}${mode_type})V
invoke-direct {p0, v3}, ${main_type}->expectInvalidations(I)V
sget-object v1, ${mode_type}->CLAMP:${mode_type}
sget-object v2, ${mode_type}->REPEAT:${mode_type}
invoke-virtual {v0, v1, v2}, ${drawable_type}->setTileModeXY(${mode_type}${mode_type})V
invoke-static {v0, v1, v2}, ${main_type}->expectModes(${drawable_type}${mode_type}${mode_type})V
const/4 v3, 3
invoke-direct {p0, v3}, ${main_type}->expectInvalidations(I)V
const/4 v1, 0
invoke-virtual {v0, v1, v1}, ${drawable_type}->setTileModeXY(${mode_type}${mode_type})V
invoke-static {v0, v1, v1}, ${main_type}->expectModes(${drawable_type}${mode_type}${mode_type})V
const/4 v3, 4
invoke-direct {p0, v3}, ${main_type}->expectInvalidations(I)V
return-void
' + failure('Every BitmapDrawable must expose one retained mutable Paint')
	source += method('private modes()V', 4, body)
	return source
}

// Every cell is checked through the public bitmap readback API. Nonzero and
// negative bounds verify the shader's canvas-origin phase, not bounds-origin.
fn pixels_source() string {
	return method('private static expectCanvasState(Landroid/graphics/Canvas;Landroid/graphics/Matrix;I)V', 7, '
invoke-virtual {p0}, Landroid/graphics/Canvas;->getSaveCount()I
move-result v0
if-ne v0, p2, :bad
const/16 v0, 9
new-array v1, v0, [F
new-array v2, v0, [F
invoke-virtual {p1, v1}, Landroid/graphics/Matrix;->getValues([F)V
invoke-virtual {p0}, Landroid/graphics/Canvas;->getMatrix()Landroid/graphics/Matrix;
move-result-object v0
invoke-virtual {v0, v2}, Landroid/graphics/Matrix;->getValues([F)V
const/4 v3, 0
:entry
aget v4, v1, v3
aget v5, v2, v3
cmpl-float v6, v4, v5
if-nez v6, :bad
add-int/lit8 v3, v3, 1
const/16 v0, 9
if-lt v3, v0, :entry
return-void
' + failure('Tiling must preserve the Canvas matrix and save stack')) +
	method('private static pixels(${drawable_type}IIII)V', 12, '
const/16 v0, 8
sget-object v1, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;
invoke-static {v0, v0, v1}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;
move-result-object v9
new-instance v0, Landroid/graphics/Canvas;
invoke-direct {v0, v9}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V
and-int/lit8 v1, p4, 1
if-eqz v1, :not_clipped
const/high16 v1, 0x3f800000
const/high16 v2, 0x40000000
const/high16 v3, 0x40a00000
const/high16 v4, 0x40c00000
invoke-virtual {v0, v1, v2, v3, v4}, Landroid/graphics/Canvas;->clipRect(FFFF)Z
:not_clipped
and-int/lit8 v1, p4, 2
if-eqz v1, :not_translated
const/high16 v1, 0x3f800000
invoke-virtual {v0, v1, v1}, Landroid/graphics/Canvas;->translate(FF)V
:not_translated
invoke-virtual {v0}, Landroid/graphics/Canvas;->getMatrix()Landroid/graphics/Matrix;
move-result-object v8
invoke-virtual {v0}, Landroid/graphics/Canvas;->getSaveCount()I
move-result v11
const/4 v1, 7
and-int/lit8 v2, p4, 4
if-eqz v2, :ordinary_bounds
const v1, 0x7fffffff
:ordinary_bounds
invoke-virtual {p0, p3, p3, v1, v1}, ${drawable_type}->setBounds(IIII)V
invoke-virtual {p0, v0}, ${drawable_type}->draw(Landroid/graphics/Canvas;)V
invoke-static {v0, v8, v11}, ${main_type}->expectCanvasState(Landroid/graphics/Canvas;Landroid/graphics/Matrix;I)V
const/16 v0, 64
new-array v10, v0, [I
move-object v0, v9
move-object v1, v10
const/4 v2, 0
const/16 v3, 8
const/4 v4, 0
const/4 v5, 0
const/16 v6, 8
const/16 v7, 8
invoke-virtual/range {v0 .. v7}, Landroid/graphics/Bitmap;->getPixels([IIIIIII)V
const/4 v11, 0
:row
const/4 v0, 0
:column
const/4 v4, 0
move v5, v0
move v6, v11
and-int/lit8 v2, p4, 2
if-eqz v2, :phase_ready
add-int/lit8 v5, v5, -1
add-int/lit8 v6, v6, -1
:phase_ready
if-lt v5, p3, :expected
if-lt v6, p3, :expected
const/4 v2, 7
and-int/lit8 v3, p4, 4
if-eqz v3, :ordinary_upper
const/16 v2, 8
:ordinary_upper
if-ge v5, v2, :expected
if-ge v6, v2, :expected
and-int/lit8 v2, p4, 1
if-eqz v2, :inside
const/4 v2, 1
if-lt v5, v2, :expected
const/4 v2, 5
if-ge v5, v2, :expected
const/4 v2, 2
if-lt v6, v2, :expected
const/4 v2, 6
if-ge v6, v2, :expected
:inside
invoke-static {v5, p1}, ${main_type}->coordinate(II)I
move-result v2
invoke-static {v6, p2}, ${main_type}->coordinate(II)I
move-result v3
mul-int/lit8 v3, v3, 2
add-int/2addr v2, v3
invoke-static {v2}, ${main_type}->color(I)I
move-result v4
invoke-virtual {p0}, ${drawable_type}->getPaint()Landroid/graphics/Paint;
move-result-object v2
invoke-virtual {v2}, Landroid/graphics/Paint;->getAlpha()I
move-result v2
shl-int/lit8 v2, v2, 24
const v3, 0xffffff
and-int/2addr v4, v3
or-int/2addr v4, v2
:expected
mul-int/lit8 v2, v11, 8
add-int/2addr v2, v0
aget v1, v10, v2
if-ne v1, v4, :bad
add-int/lit8 v0, v0, 1
const/16 v2, 8
if-lt v0, v2, :column
add-int/lit8 v11, v11, 1
if-lt v11, v2, :row
return-void
' + failure('BitmapDrawable pixels differ: repeat, mirror, clamp, phase, bounds, clip or retained paint alpha'))
}

fn cases_source() string {
	mut body := 'invoke-static {}, ${main_type}->drawable()${drawable_type}\nmove-result-object v0\n'
	for x in 0 .. 3 {
		for y in 0 .. 3 {
			xname := ['CLAMP', 'MIRROR', 'REPEAT'][x]
			yname := ['CLAMP', 'MIRROR', 'REPEAT'][y]
			body += 'sget-object v1, ${mode_type}->${xname}:${mode_type}\nsget-object v2, ${mode_type}->${yname}:${mode_type}\n' +
				'invoke-virtual {v0, v1, v2}, ${drawable_type}->setTileModeXY(${mode_type}${mode_type})V\n' +
				'const/4 v1, ${x}\nconst/4 v2, ${y}\nconst/4 v3, 1\nconst/4 v4, 0\n' +
				'invoke-static {v0, v1, v2, v3, v4}, ${main_type}->pixels(${drawable_type}IIII)V\n'
		}
	}
	body += '
sget-object v1, ${mode_type}->REPEAT:${mode_type}
const/4 v2, 0
invoke-virtual {v0, v1, v2}, ${drawable_type}->setTileModeXY(${mode_type}${mode_type})V
const/4 v1, 2
const/4 v2, 0
const/4 v3, -3
const/4 v4, 0
invoke-static {v0, v1, v2, v3, v4}, ${main_type}->pixels(${drawable_type}IIII)V
const/4 v1, 0
sget-object v2, ${mode_type}->MIRROR:${mode_type}
invoke-virtual {v0, v1, v2}, ${drawable_type}->setTileModeXY(${mode_type}${mode_type})V
const/4 v1, 0
const/4 v2, 1
const/4 v3, -3
const/4 v4, 1
invoke-static {v0, v1, v2, v3, v4}, ${main_type}->pixels(${drawable_type}IIII)V
invoke-virtual {v0}, ${drawable_type}->getPaint()Landroid/graphics/Paint;
move-result-object v1
const/16 v2, 128
invoke-virtual {v1, v2}, Landroid/graphics/Paint;->setAlpha(I)V
const/4 v1, 0
const/4 v2, 1
const/4 v3, 1
const/4 v4, 0
invoke-static {v0, v1, v2, v3, v4}, ${main_type}->pixels(${drawable_type}IIII)V
invoke-virtual {v0}, ${drawable_type}->getPaint()Landroid/graphics/Paint;
move-result-object v1
const/16 v2, 255
invoke-virtual {v1, v2}, Landroid/graphics/Paint;->setAlpha(I)V
sget-object v1, ${mode_type}->REPEAT:${mode_type}
sget-object v2, ${mode_type}->MIRROR:${mode_type}
invoke-virtual {v0, v1, v2}, ${drawable_type}->setTileModeXY(${mode_type}${mode_type})V
const/4 v1, 2
const/4 v2, 1
const/4 v3, 1
const/4 v4, 2
invoke-static {v0, v1, v2, v3, v4}, ${main_type}->pixels(${drawable_type}IIII)V
const/4 v3, -3
invoke-static {v0, v1, v2, v3, v4}, ${main_type}->pixels(${drawable_type}IIII)V
const/4 v1, 0
sget-object v2, ${mode_type}->MIRROR:${mode_type}
invoke-virtual {v0, v1, v2}, ${drawable_type}->setTileModeXY(${mode_type}${mode_type})V
const/4 v1, 0
const/4 v2, 1
invoke-static {v0, v1, v2, v3, v4}, ${main_type}->pixels(${drawable_type}IIII)V
sget-object v1, ${mode_type}->REPEAT:${mode_type}
sget-object v2, ${mode_type}->MIRROR:${mode_type}
invoke-virtual {v0, v1, v2}, ${drawable_type}->setTileModeXY(${mode_type}${mode_type})V
const/4 v1, 2
const/4 v2, 1
const/high16 v3, 0x80000000
const/4 v4, 4
invoke-static {v0, v1, v2, v3, v4}, ${main_type}->pixels(${drawable_type}IIII)V
return-void'
	return method('private static cases()V', 5, body)
}

fn empty_source() string {
	return method('private static expectClear(Landroid/graphics/Bitmap;)V', 8, '
const/16 v0, 64
new-array v1, v0, [I
move-object v0, p0
const/4 v2, 0
const/16 v3, 8
const/4 v4, 0
const/4 v5, 0
const/16 v6, 8
const/16 v7, 8
invoke-virtual/range {v0 .. v7}, Landroid/graphics/Bitmap;->getPixels([IIIIIII)V
const/4 v0, 0
:cell
aget v2, v1, v0
if-nez v2, :bad
add-int/lit8 v0, v0, 1
const/16 v2, 64
if-lt v0, v2, :cell
return-void
' + failure('A null bitmap or empty bounds must leave the target clear')) +
	method('private static empty()V', 6, '
const/16 v0, 8
sget-object v1, Landroid/graphics/Bitmap$Config;->ARGB_8888:Landroid/graphics/Bitmap$Config;
invoke-static {v0, v0, v1}, Landroid/graphics/Bitmap;->createBitmap(IILandroid/graphics/Bitmap$Config;)Landroid/graphics/Bitmap;
move-result-object v0
new-instance v1, Landroid/graphics/Canvas;
invoke-direct {v1, v0}, Landroid/graphics/Canvas;-><init>(Landroid/graphics/Bitmap;)V
new-instance v2, ${drawable_type}
invoke-direct {v2}, ${drawable_type}-><init>()V
sget-object v3, ${mode_type}->REPEAT:${mode_type}
sget-object v4, ${mode_type}->MIRROR:${mode_type}
invoke-virtual {v2, v3, v4}, ${drawable_type}->setTileModeXY(${mode_type}${mode_type})V
const/4 v3, 0
const/16 v4, 8
invoke-virtual {v2, v3, v3, v4, v4}, ${drawable_type}->setBounds(IIII)V
invoke-virtual {v2, v1}, ${drawable_type}->draw(Landroid/graphics/Canvas;)V
invoke-static {v0}, ${main_type}->expectClear(Landroid/graphics/Bitmap;)V
invoke-static {}, ${main_type}->drawable()${drawable_type}
move-result-object v2
sget-object v3, ${mode_type}->REPEAT:${mode_type}
sget-object v4, ${mode_type}->MIRROR:${mode_type}
invoke-virtual {v2, v3, v4}, ${drawable_type}->setTileModeXY(${mode_type}${mode_type})V
const/4 v3, 3
const/4 v4, 6
invoke-virtual {v2, v3, v3, v3, v4}, ${drawable_type}->setBounds(IIII)V
invoke-virtual {v2, v1}, ${drawable_type}->draw(Landroid/graphics/Canvas;)V
invoke-static {v0}, ${main_type}->expectClear(Landroid/graphics/Bitmap;)V
return-void')
}

fn main_source() string {
	mut text := '.class public final ${main_type}\n.super Landroid/app/Activity;\n.implements Landroid/graphics/drawable/Drawable$Callback;\n.field private invalidations:I\n'
	text += method('public constructor <init>()V', 0,
		'invoke-direct {p0}, Landroid/app/Activity;-><init>()V\nreturn-void')
	text += bitmap_source() + mode_source() + pixels_source() + cases_source() + empty_source()
	text += method('public onCreate(Landroid/os/Bundle;)V', 3, '
invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V
:test_start
invoke-direct {p0}, ${main_type}->modes()V
invoke-static {}, ${main_type}->empty()V
invoke-static {}, ${main_type}->cases()V
:test_end
sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;
const-string v1, "${pass_marker}"
invoke-virtual {v0, v1}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V
invoke-virtual {v0}, Ljava/io/PrintStream;->flush()V
new-instance v0, Landroid/widget/TextView;
invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
const-string v1, "Bitmap tile state and pixels passed"
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
	return text
}

struct CommandReceipt {
	argv []string
	status int
	output string
}

struct FixtureBuild {
	argv []string
	source_revision string
	inputs_sha256 map[string]string
	artifacts_sha256 map[string]string
	java_version string
	apk_sha256 string
	package_name string
	activity_name string
	pass_marker string
	fail_marker string
	scope string
}

fn file_hash(path string) !string {
	mut file := os.open(path)!
	defer { file.close() }
	mut digest := sha256.new()
	mut buffer := []u8{len: 1024 * 1024}
	for {
		count := file.read(mut buffer) or { if err is os.Eof { break }; return err }
		if count == 0 { break }
		digest.write(buffer[..count])!
	}
	return digest.sum([]u8{}).hex()
}

fn recorded(out string, name string, argv []string) !string {
	result := os.exec(argv)
	os.write_file(out + '/commands/' + name + '.json', json2.encode(CommandReceipt{
		argv: argv, status: result.exit_code, output: result.output
	}, prettify: true) + '\n')!
	if result.exit_code != 0 { return error(name + ': ' + result.output) }
	return result.output
}

fn java_command(java string, args []string) []string {
	mut command := [java, '-Xmx256m', '-XX:ActiveProcessorCount=2']
	command << args
	return command
}

fn output_files(path string) ![]string {
	mut result := []string{}
	mut names := os.ls(path)!
	names.sort()
	for name in names {
		item := path + '/' + name
		if os.is_link(item) { return error('unexpected output symlink: ' + item) }
		kind := os.lstat(item)!.get_filetype()
		if kind == .directory { result << output_files(item)! }
		else if kind == .regular { result << item }
		else { return error('unexpected output type: ' + item) }
	}
	return result
}

fn manifest() string {
	return '<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="${package_name}" android:versionCode="1">' +
		'<uses-sdk android:minSdkVersion="29" android:targetSdkVersion="35"/>' +
		'<application android:label="Bitmap tile fixture"><activity android:name="${package_name}.Main" android:exported="true"><intent-filter>' +
		'<action android:name="android.intent.action.MAIN"/><category android:name="android.intent.category.LAUNCHER"/>' +
		'</intent-filter></activity></application></manifest>'
}

fn main() {
	if os.args.len != 7 { panic('OUTPUT AAPT2 FRAMEWORK_RES SMALI_TOOLS JAVA APKSIGNER') }
	$if prod { panic('live assertions required') }
	out := os.abs_path(os.args[1])
	aapt, resources := os.real_path(os.args[2]), os.real_path(os.args[3])
	tools, java, signer := os.real_path(os.args[4]), os.real_path(os.args[5]), os.real_path(os.args[6])
	if os.exists(out) || os.is_link(out) { panic('fresh output directory required') }
	os.mkdir_all(out + '/commands')!
	os.mkdir(out + '/inputs')!
	source, executable := os.real_path(@FILE), os.real_path(os.executable())
	keytool := os.dir(java) + '/keytool'
	zip := os.real_path(os.find_abs_path_of_executable('zip')!)
	mut inputs := map[string]string{}
	for path in [source, executable, aapt, resources, java, signer, keytool, zip] {
		assert os.is_file(path), 'missing input: ' + path
		inputs[path] = file_hash(path)!
	}
	mut tool_names := os.ls(tools)!
	tool_names.sort()
	for name in tool_names { if os.is_file(tools + '/' + name) { inputs[tools + '/' + name] = file_hash(tools + '/' + name)! } }
	os.cp(source, out + '/inputs/bitmap-tiles-fixture.v')!
	os.cp(executable, out + '/inputs/generator')!
	assert file_hash(out + '/inputs/bitmap-tiles-fixture.v')! == inputs[source]!
	assert file_hash(out + '/inputs/generator')! == inputs[executable]!
	os.write_file(out + '/inputs-before.json', json2.encode(inputs, prettify: true) + '\n')!
	dir := out + '/smali/org/vinix/bootstrap'
	os.mkdir_all(dir)!
	os.write_file(dir + '/Main.smali', main_source())!
	os.write_file(out + '/AndroidManifest.xml', manifest())!
	revision := recorded(out, 'source-revision', ['git', 'rev-parse', 'HEAD'])!.trim_space()
	java_version := recorded(out, 'java-version', java_command(java, ['-version']))!
	key := out + '/fixture.p12'
	recorded(out, 'keytool', [keytool, '-J-Xmx256m', '-J-XX:ActiveProcessorCount=2', '-genkeypair', '-keystore', key, '-storetype', 'PKCS12',
		'-storepass', 'android', '-keypass', 'android', '-alias', 'fixture', '-dname', 'CN=Vinix Bitmap Tile Fixture',
		'-keyalg', 'RSA', '-keysize', '2048', '-validity', '3650'])!
	inputs[key] = file_hash(key)!
	recorded(out, 'link', [aapt, 'link', '-I', resources, '--manifest', out + '/AndroidManifest.xml', '-o', out + '/unsigned.apk'])!
	assembly := recorded(out, 'assemble', java_command(java, ['-cp', tools + '/*', 'org.jf.smali.Main', 'assemble', '--jobs', '2', out + '/smali', '-o', out + '/classes.dex']))!
	assert assembly.trim_space() == '' && os.is_file(out + '/classes.dex'), 'fresh error-free DEX required: ' + assembly
	recorded(out, 'disassemble', java_command(java, ['-cp', tools + '/*', 'org.jf.baksmali.Main', 'disassemble', '--jobs', '2', out + '/classes.dex', '-o', out + '/roundtrip-smali']))!
	reassembly := recorded(out, 'reassemble', java_command(java, ['-cp', tools + '/*', 'org.jf.smali.Main', 'assemble', '--jobs', '2', out + '/roundtrip-smali', '-o', out + '/roundtrip.dex']))!
	assert reassembly.trim_space() == '' && os.is_file(out + '/roundtrip.dex'), 'fresh roundtrip DEX required: ' + reassembly
	recorded(out, 'roundtrip-disassemble', java_command(java, ['-cp', tools + '/*', 'org.jf.baksmali.Main', 'disassemble', '--jobs', '2', out + '/roundtrip.dex', '-o', out + '/roundtrip-checked-smali']))!
	first, second := output_files(out + '/roundtrip-smali')!, output_files(out + '/roundtrip-checked-smali')!
	assert first.len == 1 && second.len == first.len
	for path in first {
		name := path.all_after(out + '/roundtrip-smali/')
		assert os.is_file(out + '/roundtrip-checked-smali/' + name)
		assert file_hash(path)! == file_hash(out + '/roundtrip-checked-smali/' + name)!, 'roundtrip changed class: ' + name
	}
	recorded(out, 'zip', [zip, '-q', '-j', out + '/unsigned.apk', out + '/classes.dex'])!
	apk := out + '/probe.apk'
	recorded(out, 'sign', java_command(java, ['-jar', signer, 'sign', '--ks', key, '--ks-key-alias', 'fixture', '--ks-pass', 'pass:android', '--key-pass', 'pass:android', '--out', apk, out + '/unsigned.apk']))!
	verification := recorded(out, 'verify', java_command(java, ['-jar', signer, 'verify', '--verbose', apk]))!
	assert verification.contains('Verified using v3 scheme (APK Signature Scheme v3): true'), 'APK v3 signature missing'
	badging := recorded(out, 'badging', [aapt, 'dump', 'badging', apk])!
	assert badging.contains("package: name='${package_name}'") && badging.contains("launchable-activity: name='${package_name}.Main'")
	for path, before in inputs { assert file_hash(path)! == before, 'input changed: ' + path }
	mut artifacts := map[string]string{}
	for path in output_files(out)! { artifacts[path.all_after(out + '/')] = file_hash(path)! }
	receipt := FixtureBuild{
		argv: os.args.clone(), source_revision: revision, inputs_sha256: inputs, artifacts_sha256: artifacts,
		java_version: java_version.trim_space(), apk_sha256: file_hash(apk)!, package_name: package_name,
		activity_name: package_name + '.Main', pass_marker: pass_marker, fail_marker: fail_marker,
		scope: 'BitmapDrawable nullable tile modes, independent setters, change invalidation, retained Paint, and complete offscreen pixel grids for repeat/mirror/clamp including shifted/negative bounds, clipping and paint alpha; no Google authentication claim.'
	}
	os.write_file(out + '/build.json', json2.encode(receipt, prettify: true) + '\n')!
	println('BITMAP-TILES-FIXTURE-APK ' + apk)
	println('BITMAP-TILES-FIXTURE-APK-SHA256 ' + receipt.apk_sha256)
}
