// SPDX-License-Identifier: GPL-2.0-or-later
// Signed ART regression for the public WindowManager.LayoutParams field.
module main

import crypto.sha256
import json2
import os

const package_name = 'org.vinix.bootstrap'
const main_type = 'Lorg/vinix/bootstrap/Main;'
const params_type = 'Landroid/view/WindowManager$LayoutParams;'
const pass_marker = 'WINDOW-SYSTEM-UI-PASS defaults field-shape bitmasks instance-isolation window-attributes'
const fail_marker = 'WINDOW-SYSTEM-UI-FAIL'

fn method(signature string, locals int, body string) string {
	return '.method ${signature}\n.locals ${locals}\n${body}\n.end method\n'
}

fn failure(message string) string {
	return ':bad\nnew-instance v0, Ljava/lang/AssertionError;\nconst-string v1, "${message}"\n' +
		'invoke-direct {v0, v1}, Ljava/lang/AssertionError;-><init>(Ljava/lang/Object;)V\nthrow v0'
}

fn assertions() string {
	mut text := method('private static expectValue(${params_type}I)V', 2, '
iget v0, p0, ${params_type}->systemUiVisibility:I
if-ne v0, p1, :bad
return-void
' + failure('LayoutParams systemUiVisibility must retain the exact integer'))
	text += method('private static expectUnrelated(${params_type}IIII)V', 2, '
iget v0, p0, Landroid/view/ViewGroup$LayoutParams;->width:I
if-ne v0, p1, :bad
iget v0, p0, Landroid/view/ViewGroup$LayoutParams;->height:I
if-ne v0, p2, :bad
iget v0, p0, ${params_type}->flags:I
if-ne v0, p3, :bad
iget v0, p0, ${params_type}->alpha:F
invoke-static {v0}, Ljava/lang/Float;->floatToRawIntBits(F)I
move-result v0
if-ne v0, p4, :bad
return-void
' + failure('Writing systemUiVisibility changed unrelated LayoutParams values'))
	return text
}

fn exercise_source() string {
	mut body := '
iget v2, p0, Landroid/view/ViewGroup$LayoutParams;->width:I
iget v3, p0, Landroid/view/ViewGroup$LayoutParams;->height:I
iget v4, p0, ${params_type}->flags:I
iget v0, p0, ${params_type}->alpha:F
invoke-static {v0}, Ljava/lang/Float;->floatToRawIntBits(F)I
move-result v5
iget v6, p0, ${params_type}->systemUiVisibility:I
'
	for value in ['0', '1', '-1', '-2147483648', '2147483647'] {
		body += 'const v0, ${value}\niput v0, p0, ${params_type}->systemUiVisibility:I\n' +
			'invoke-static {p0, v0}, ${main_type}->expectValue(${params_type}I)V\n'
	}
	body += '
# Reproduce the Google layout mask while retaining unrelated high and low bits.
const v0, 0x40001020
iput v0, p0, ${params_type}->systemUiVisibility:I
iget v0, p0, ${params_type}->systemUiVisibility:I
const v1, 0x400000
or-int/2addr v0, v1
iput v0, p0, ${params_type}->systemUiVisibility:I
const v0, 0x40401020
invoke-static {p0, v0}, ${main_type}->expectValue(${params_type}I)V
iget v0, p0, ${params_type}->systemUiVisibility:I
const v1, -4194305
and-int/2addr v0, v1
iput v0, p0, ${params_type}->systemUiVisibility:I
const v0, 0x40001020
invoke-static {p0, v0}, ${main_type}->expectValue(${params_type}I)V
invoke-static {p0, v2, v3, v4, v5}, ${main_type}->expectUnrelated(${params_type}IIII)V
iput v6, p0, ${params_type}->systemUiVisibility:I
return-void'
	return method('private static exercise(${params_type})V', 7, body)
}

fn reflection_source() string {
	return method('private static reflection()V', 4, '
const-class v0, ${params_type}
const-string v1, "systemUiVisibility"
invoke-virtual {v0, v1}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;
move-result-object v1
invoke-virtual {v1}, Ljava/lang/reflect/Field;->getDeclaringClass()Ljava/lang/Class;
move-result-object v2
if-ne v0, v2, :bad
invoke-virtual {v1}, Ljava/lang/reflect/Field;->getType()Ljava/lang/Class;
move-result-object v0
sget-object v2, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;
if-ne v0, v2, :bad
invoke-virtual {v1}, Ljava/lang/reflect/Field;->getModifiers()I
move-result v0
and-int/lit8 v2, v0, 0x1
if-eqz v2, :bad
and-int/lit8 v2, v0, 0x8
if-nez v2, :bad
and-int/lit8 v2, v0, 0x10
if-nez v2, :bad
new-instance v0, ${params_type}
invoke-direct {v0}, ${params_type}-><init>()V
const v2, 0x81234567
invoke-virtual {v1, v0, v2}, Ljava/lang/reflect/Field;->setInt(Ljava/lang/Object;I)V
invoke-static {v0, v2}, ${main_type}->expectValue(${params_type}I)V
invoke-virtual {v1, v0}, Ljava/lang/reflect/Field;->getInt(Ljava/lang/Object;)I
move-result v3
if-ne v3, v2, :bad
return-void
' + failure('systemUiVisibility must be a declared writable public instance int'))
}

fn copy_attributes_source() string {
	mut body := ''
	for field in ['gravity:I', 'height:I', 'weight:F', 'width:I'] {
		body += 'iget v0, p0, Landroid/view/ViewGroup$LayoutParams;->${field}\n' +
			'iput v0, p1, Landroid/view/ViewGroup$LayoutParams;->${field}\n'
	}
	for field in ['alpha:F', 'flags:I', 'format:I', 'layoutInDisplayCutoutMode:I',
		'packageName:Ljava/lang/String;', 'preferredRefreshRate:F', 'screenBrightness:F',
		'softInputMode:I', 'token:Landroid/os/IBinder;', 'type:I', 'windowAnimations:I',
		'x:I', 'y:I', 'systemUiVisibility:I'] {
		op := if field.ends_with(';') { '-object' } else { '' }
		body += 'iget${op} v0, p0, ${params_type}->${field}\n' +
			'iput${op} v0, p1, ${params_type}->${field}\n'
	}
	return method('private static copyAttributes(${params_type}${params_type})V', 1,
		body + 'return-void')
}

fn window_source() string {
	return method('private windowAttributes()V', 10, '
invoke-virtual {p0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;
move-result-object v0
invoke-virtual {v0}, Landroid/view/Window;->getAttributes()${params_type}
move-result-object v1
iget v2, v1, ${params_type}->systemUiVisibility:I
iget v3, v1, Landroid/view/ViewGroup$LayoutParams;->width:I
iget v4, v1, Landroid/view/ViewGroup$LayoutParams;->height:I
iget v5, v1, ${params_type}->flags:I
iget v6, v1, ${params_type}->alpha:F
invoke-static {v6}, Ljava/lang/Float;->floatToRawIntBits(F)I
move-result v6
new-instance v7, ${params_type}
invoke-direct {v7}, ${params_type}-><init>()V
# Keep all currently available public attributes, including reference fields.
invoke-static {v1, v7}, ${main_type}->copyAttributes(${params_type}${params_type})V
const v8, 0x40000000
xor-int/2addr v8, v2
iput v8, v7, ${params_type}->systemUiVisibility:I
:installed_start
invoke-virtual {v0, v7}, Landroid/view/Window;->setAttributes(${params_type})V
invoke-virtual {v0}, Landroid/view/Window;->getAttributes()${params_type}
move-result-object v9
invoke-static {v9, v8}, ${main_type}->expectValue(${params_type}I)V
invoke-static {v9, v3, v4, v5, v6}, ${main_type}->expectUnrelated(${params_type}IIII)V
:installed_end
# A Window may retain the argument or copy it into its current attributes.
iput v2, v1, ${params_type}->systemUiVisibility:I
invoke-virtual {v0, v1}, Landroid/view/Window;->setAttributes(${params_type})V
invoke-virtual {v0}, Landroid/view/Window;->getAttributes()${params_type}
move-result-object v7
invoke-static {v7, v2}, ${main_type}->expectValue(${params_type}I)V
invoke-static {v7, v3, v4, v5, v6}, ${main_type}->expectUnrelated(${params_type}IIII)V
return-void
.catchall {:installed_start .. :installed_end} :failed
:failed
move-exception v7
iput v2, v1, ${params_type}->systemUiVisibility:I
invoke-virtual {v0, v1}, Landroid/view/Window;->setAttributes(${params_type})V
throw v7')
}

fn test_source() string {
	return method('private test()V', 7, '
new-instance v0, ${params_type}
invoke-direct {v0}, ${params_type}-><init>()V
const/4 v1, 0
invoke-static {v0, v1}, ${main_type}->expectValue(${params_type}I)V
invoke-static {v0}, ${main_type}->exercise(${params_type})V
new-instance v0, ${params_type}
const/16 v1, 123
const/16 v2, 234
const/4 v3, 2
const/16 v4, 8
const/4 v5, 1
invoke-direct/range {v0 .. v5}, ${params_type}-><init>(IIIII)V
const/4 v1, 0
invoke-static {v0, v1}, ${main_type}->expectValue(${params_type}I)V
invoke-static {v0}, ${main_type}->exercise(${params_type})V
new-instance v6, ${params_type}
invoke-direct {v6}, ${params_type}-><init>()V
const v1, 0x10203040
iput v1, v0, ${params_type}->systemUiVisibility:I
const/4 v2, 0
invoke-static {v6, v2}, ${main_type}->expectValue(${params_type}I)V
const/4 v2, -1
iput v2, v6, ${params_type}->systemUiVisibility:I
invoke-static {v0, v1}, ${main_type}->expectValue(${params_type}I)V
const/4 v1, 0
iput v1, v0, ${params_type}->systemUiVisibility:I
invoke-static {v6, v2}, ${main_type}->expectValue(${params_type}I)V
invoke-static {}, ${main_type}->reflection()V
invoke-direct {p0}, ${main_type}->windowAttributes()V
return-void')
}

fn main_source() string {
	mut text := '.class public final ${main_type}\n.super Landroid/app/Activity;\n'
	text += method('public constructor <init>()V', 0,
		'invoke-direct {p0}, Landroid/app/Activity;-><init>()V\nreturn-void')
	text += assertions() + exercise_source() + reflection_source() + copy_attributes_source() + window_source() + test_source()
	text += method('public onCreate(Landroid/os/Bundle;)V', 3, '
invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V
:test_start
invoke-direct {p0}, ${main_type}->test()V
:test_end
sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;
const-string v1, "${pass_marker}"
invoke-virtual {v0, v1}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V
invoke-virtual {v0}, Ljava/io/PrintStream;->flush()V
new-instance v0, Landroid/widget/TextView;
invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
const-string v1, "Window system UI attribute field passed"
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
	argv   []string
	status int
	output string
}

struct FixtureBuild {
	argv             []string
	source_revision  string
	inputs_sha256    map[string]string
	artifacts_sha256 map[string]string
	java_version     string
	apk_sha256       string
	package_name     string
	activity_name    string
	pass_marker      string
	fail_marker      string
	scope            string
}

fn file_hash(path string) !string {
	mut file := os.open(path)!
	defer { file.close() }
	mut digest := sha256.new()
	mut buffer := []u8{len: 1024 * 1024}
	for {
		count := file.read(mut buffer) or {
			if err is os.Eof { break }
			return err
		}
		if count == 0 { break }
		digest.write(buffer[..count])!
	}
	return digest.sum([]u8{}).hex()
}

fn recorded(out string, name string, argv []string) !string {
	result := os.exec(argv)
	os.write_file(out + '/commands/' + name + '.json', json2.encode(CommandReceipt{
		argv: argv
		status: result.exit_code
		output: result.output
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
		kind := (os.lstat(item)!).get_filetype()
		if kind == .directory { result << output_files(item)! }
		else if kind == .regular { result << item }
		else { return error('unexpected output type: ' + item) }
	}
	return result
}

fn manifest() string {
	return '<manifest xmlns:android="http://schemas.android.com/apk/res/android" package="${package_name}" android:versionCode="1">' +
		'<uses-sdk android:minSdkVersion="29" android:targetSdkVersion="35"/>' +
		'<application android:label="Window system UI field fixture">' +
		'<activity android:name="${package_name}.Main" android:exported="true"><intent-filter>' +
		'<action android:name="android.intent.action.MAIN"/><category android:name="android.intent.category.LAUNCHER"/>' +
		'</intent-filter></activity></application></manifest>'
}

fn main() {
	if os.args.len != 7 { panic('OUTPUT AAPT2 FRAMEWORK_RES SMALI_TOOLS JAVA APKSIGNER') }
	$if prod { panic('build the fixture generator without -prod so evidence assertions remain enabled') }
	out := os.abs_path(os.args[1])
	aapt, resources := os.real_path(os.args[2]), os.real_path(os.args[3])
	tools, java, signer := os.real_path(os.args[4]), os.real_path(os.args[5]), os.real_path(os.args[6])
	if os.exists(out) || os.is_link(out) { panic('fresh output directory required') }
	os.mkdir_all(out + '/commands')!
	os.mkdir(out + '/inputs')!
	source := os.real_path(@FILE)
	executable := os.real_path(os.executable())
	keytool := os.dir(java) + '/keytool'
	zip := os.real_path(os.find_abs_path_of_executable('zip')!)
	mut inputs := map[string]string{}
	for path in [source, executable, aapt, resources, java, signer, keytool, zip] {
		assert os.is_file(path), 'missing input: ' + path
		inputs[path] = file_hash(path)!
	}
	mut tool_names := os.ls(tools)!
	tool_names.sort()
	for name in tool_names {
		path := tools + '/' + name
		if os.is_file(path) { inputs[path] = file_hash(path)! }
	}
	os.cp(source, out + '/inputs/window-system-ui-fixture.v')!
	os.cp(executable, out + '/inputs/generator')!
	assert file_hash(out + '/inputs/window-system-ui-fixture.v')! == inputs[source]!
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
		'-storepass', 'android', '-keypass', 'android', '-alias', 'fixture', '-dname',
		'CN=Vinix Window System UI Fixture', '-keyalg', 'RSA', '-keysize', '2048', '-validity', '3650'])!
	inputs[key] = file_hash(key)!
	recorded(out, 'link', [aapt, 'link', '-I', resources, '--manifest', out + '/AndroidManifest.xml',
		'-o', out + '/unsigned.apk'])!
	assembly := recorded(out, 'assemble', java_command(java, ['-cp', tools + '/*', 'org.jf.smali.Main',
		'assemble', '--jobs', '2', out + '/smali', '-o', out + '/classes.dex']))!
	assert assembly.trim_space() == '', 'unexpected assembly diagnostics: ' + assembly
	assert os.is_file(out + '/classes.dex'), 'assembler produced no DEX'
	recorded(out, 'disassemble', java_command(java, ['-cp', tools + '/*', 'org.jf.baksmali.Main',
		'disassemble', '--jobs', '2', out + '/classes.dex', '-o', out + '/roundtrip-smali']))!
	reassembly := recorded(out, 'reassemble', java_command(java, ['-cp', tools + '/*', 'org.jf.smali.Main',
		'assemble', '--jobs', '2', out + '/roundtrip-smali', '-o', out + '/roundtrip.dex']))!
	assert reassembly.trim_space() == '', 'unexpected roundtrip assembly diagnostics: ' + reassembly
	assert os.is_file(out + '/roundtrip.dex'), 'roundtrip assembler produced no DEX'
	recorded(out, 'roundtrip-disassemble', java_command(java, ['-cp', tools + '/*', 'org.jf.baksmali.Main',
		'disassemble', '--jobs', '2', out + '/roundtrip.dex', '-o', out + '/roundtrip-checked-smali']))!
	first := output_files(out + '/roundtrip-smali')!
	second := output_files(out + '/roundtrip-checked-smali')!
	assert first.len == 1 && second.len == first.len, 'roundtrip class membership changed'
	for path in first {
		name := path.all_after(out + '/roundtrip-smali/')
		assert os.is_file(out + '/roundtrip-checked-smali/' + name), 'roundtrip class missing: ' + name
		assert file_hash(path)! == file_hash(out + '/roundtrip-checked-smali/' + name)!, 'roundtrip changed class: ' + name
	}
	recorded(out, 'zip', [zip, '-q', '-j', out + '/unsigned.apk', out + '/classes.dex'])!
	apk := out + '/probe.apk'
	recorded(out, 'sign', java_command(java, ['-jar', signer, 'sign', '--ks', key, '--ks-key-alias', 'fixture',
		'--ks-pass', 'pass:android', '--key-pass', 'pass:android', '--out', apk, out + '/unsigned.apk']))!
	verification := recorded(out, 'verify', java_command(java, ['-jar', signer, 'verify', '--verbose', apk]))!
	assert verification.contains('Verified using v3 scheme (APK Signature Scheme v3): true'), 'APK v3 signature missing'
	badging := recorded(out, 'badging', [aapt, 'dump', 'badging', apk])!
	assert badging.contains("package: name='${package_name}'"), 'wrong APK package'
	assert badging.contains("launchable-activity: name='${package_name}.Main'"), 'wrong launch activity'
	for path, before in inputs { assert file_hash(path)! == before, 'input changed during build: ' + path }
	mut artifacts := map[string]string{}
	for path in output_files(out)! { artifacts[path.all_after(out + '/')] = file_hash(path)! }
	receipt := FixtureBuild{
		argv: os.args.clone()
		source_revision: revision
		inputs_sha256: inputs
		artifacts_sha256: artifacts
		java_version: java_version.trim_space()
		apk_sha256: file_hash(apk)!
		package_name: package_name
		activity_name: package_name + '.Main'
		pass_marker: pass_marker
		fail_marker: fail_marker
		scope: 'Synthetic public LayoutParams field, signed bitmasks, reflection and Window attribute-value retention; compositor effects, Google services and authentication remain unverified.'
	}
	os.write_file(out + '/build.json', json2.encode(receipt, prettify: true) + '\n')!
	println('WINDOW-SYSTEM-UI-FIXTURE-APK ' + apk)
	println('WINDOW-SYSTEM-UI-FIXTURE-APK-SHA256 ' + receipt.apk_sha256)
}
