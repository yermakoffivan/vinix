// SPDX-License-Identifier: GPL-2.0-or-later
// Signed ART regression for an unseeded UserManager account-options lookup.
module main

import crypto.sha256
import json2
import os

const package_name = 'org.vinix.bootstrap'
const main_type = 'Lorg/vinix/bootstrap/Main;'
const manager_type = 'Landroid/os/UserManager;'
const options_type = 'Landroid/os/PersistableBundle;'
const pass_marker = 'SEED-ACCOUNT-OPTIONS-PASS unseeded-null service-lookup method-shape empty-singleton immutable-empty null-branch'
const fail_marker = 'SEED-ACCOUNT-OPTIONS-FAIL'

fn method(signature string, locals int, body string) string {
	return '.method ${signature}\n.locals ${locals}\n${body}\n.end method\n'
}

fn failure(message string) string {
	return ':bad\nnew-instance v0, Ljava/lang/AssertionError;\nconst-string v1, "${message}"\n' +
		'invoke-direct {v0, v1}, Ljava/lang/AssertionError;-><init>(Ljava/lang/Object;)V\nthrow v0'
}

fn null_guard_source() string {
	mut text := method('private static options(Landroid/content/Context;)${options_type}', 1, '
# This is the GMS typed-service lookup and null-coalescing sequence.
const-class v0, ${manager_type}
invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;
move-result-object v0
check-cast v0, ${manager_type}
invoke-virtual {v0}, ${manager_type}->getSeedAccountOptions()${options_type}
move-result-object v0
if-nez v0, :ready
sget-object v0, ${options_type}->EMPTY:${options_type}
:ready
invoke-virtual {v0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;
return-object v0')
	text += method('private static expectUnseeded(${manager_type})V', 2, '
invoke-virtual {p0}, ${manager_type}->getSeedAccountOptions()${options_type}
move-result-object v0
if-nez v0, :bad
invoke-virtual {p0}, ${manager_type}->getSeedAccountOptions()${options_type}
move-result-object v0
if-nez v0, :bad
return-void
' + failure('Unseeded UserManager options must remain null'))
	return text
}

fn reflection_source() string {
	return method('private static reflection(${manager_type})V', 4, '
const-class v0, ${manager_type}
const-string v1, "getSeedAccountOptions"
const/4 v2, 0
new-array v2, v2, [Ljava/lang/Class;
invoke-virtual {v0, v1, v2}, Ljava/lang/Class;->getDeclaredMethod(Ljava/lang/String;[Ljava/lang/Class;)Ljava/lang/reflect/Method;
move-result-object v1
invoke-virtual {v1}, Ljava/lang/reflect/Method;->getDeclaringClass()Ljava/lang/Class;
move-result-object v2
if-ne v0, v2, :bad
invoke-virtual {v1}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;
move-result-object v0
const-class v2, ${options_type}
if-ne v0, v2, :bad
invoke-virtual {v1}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;
move-result-object v0
array-length v0, v0
if-nez v0, :bad
invoke-virtual {v1}, Ljava/lang/reflect/Method;->getModifiers()I
move-result v0
and-int/lit8 v2, v0, 0x1
if-eqz v2, :bad
and-int/lit8 v2, v0, 0x8
if-nez v2, :bad
const/4 v2, 0
new-array v2, v2, [Ljava/lang/Object;
invoke-virtual {v1, p0, v2}, Ljava/lang/reflect/Method;->invoke(Ljava/lang/Object;[Ljava/lang/Object;)Ljava/lang/Object;
move-result-object v0
if-nez v0, :bad
return-void
' + failure('Seed options method must be declared public, nonstatic, noarg and return PersistableBundle'))
}

fn empty_shape_source() string {
	return method('private static emptyShape()V', 4, '
const-class v0, ${options_type}
const-string v1, "EMPTY"
invoke-virtual {v0, v1}, Ljava/lang/Class;->getDeclaredField(Ljava/lang/String;)Ljava/lang/reflect/Field;
move-result-object v1
invoke-virtual {v1}, Ljava/lang/reflect/Field;->getDeclaringClass()Ljava/lang/Class;
move-result-object v2
if-ne v0, v2, :bad
invoke-virtual {v1}, Ljava/lang/reflect/Field;->getType()Ljava/lang/Class;
move-result-object v2
if-ne v0, v2, :bad
invoke-virtual {v1}, Ljava/lang/reflect/Field;->getModifiers()I
move-result v2
and-int/lit8 v2, v2, 0x19
const/16 v3, 0x19
if-ne v2, v3, :bad
const/4 v2, 0
invoke-virtual {v1, v2}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;
move-result-object v1
sget-object v2, ${options_type}->EMPTY:${options_type}
if-eqz v2, :bad
if-ne v1, v2, :bad
invoke-virtual {v2}, Ljava/lang/Object;->getClass()Ljava/lang/Class;
move-result-object v1
if-ne v0, v1, :bad
invoke-virtual {v2}, ${options_type}->isEmpty()Z
move-result v0
if-eqz v0, :bad
return-void
' + failure('PersistableBundle.EMPTY must be the public static final typed empty singleton'))
}

fn immutable_empty_source() string {
	return method('private static immutableEmpty()V', 6, '
sget-object v0, ${options_type}->EMPTY:${options_type}
const-string v1, "fixture-int"
const/16 v2, 42
:int_start
invoke-virtual {v0, v1, v2}, ${options_type}->putInt(Ljava/lang/String;I)V
:int_end
goto :bad
.catch Ljava/lang/UnsupportedOperationException; {:int_start .. :int_end} :int_rejected
:int_rejected
move-exception v3
const-string v1, "fixture-string"
const-string v2, "local-value"
:string_start
invoke-virtual {v0, v1, v2}, ${options_type}->putString(Ljava/lang/String;Ljava/lang/String;)V
:string_end
goto :bad
.catch Ljava/lang/UnsupportedOperationException; {:string_start .. :string_end} :string_rejected
:string_rejected
move-exception v3
invoke-virtual {v0}, ${options_type}->isEmpty()Z
move-result v3
if-eqz v3, :bad
sget-object v3, ${options_type}->EMPTY:${options_type}
if-ne v0, v3, :bad
sget-object v3, Landroid/util/ArrayMap;->EMPTY:Landroid/util/ArrayMap;
:map_start
invoke-virtual {v3, v1, v2}, Landroid/util/ArrayMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
:map_end
goto :bad
.catch Ljava/lang/UnsupportedOperationException; {:map_start .. :map_end} :map_rejected
:map_rejected
move-exception v4
invoke-virtual {v3}, Landroid/util/ArrayMap;->isEmpty()Z
move-result v4
if-eqz v4, :bad
new-instance v4, ${options_type}
invoke-direct {v4}, ${options_type}-><init>()V
invoke-virtual {v4, v1, v2}, ${options_type}->putString(Ljava/lang/String;Ljava/lang/String;)V
invoke-virtual {v4, v1}, ${options_type}->getString(Ljava/lang/String;)Ljava/lang/String;
move-result-object v5
if-ne v5, v2, :bad
const-string v1, "fixture-int"
const/16 v2, 42
invoke-virtual {v4, v1, v2}, ${options_type}->putInt(Ljava/lang/String;I)V
invoke-virtual {v4, v1}, ${options_type}->getInt(Ljava/lang/String;)I
move-result v5
if-ne v5, v2, :bad
new-instance v5, ${options_type}
invoke-direct {v5}, ${options_type}-><init>()V
invoke-virtual {v5}, ${options_type}->isEmpty()Z
move-result v5
if-eqz v5, :bad
invoke-virtual {v0}, ${options_type}->isEmpty()Z
move-result v5
if-eqz v5, :bad
new-instance v4, Landroid/util/ArrayMap;
invoke-direct {v4}, Landroid/util/ArrayMap;-><init>()V
const-string v2, "mutable-map"
invoke-virtual {v4, v1, v2}, Landroid/util/ArrayMap;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;
move-result-object v5
if-nez v5, :bad
invoke-virtual {v4, v1}, Landroid/util/ArrayMap;->get(Ljava/lang/Object;)Ljava/lang/Object;
move-result-object v5
if-ne v5, v2, :bad
new-instance v5, Landroid/util/ArrayMap;
invoke-direct {v5}, Landroid/util/ArrayMap;-><init>()V
invoke-virtual {v5}, Landroid/util/ArrayMap;->isEmpty()Z
move-result v5
if-eqz v5, :bad
invoke-virtual {v3}, Landroid/util/ArrayMap;->isEmpty()Z
move-result v5
if-eqz v5, :bad
return-void
' + failure('Shared empty constants must reject mutations while new bundles and maps remain mutable'))
}

fn restrictions_source() string {
	return method('private static restrictions(${manager_type})V', 4, '
const-string v0, "${package_name}"
invoke-virtual {p0, v0}, ${manager_type}->getApplicationRestrictions(Ljava/lang/String;)Landroid/os/Bundle;
move-result-object v1
invoke-virtual {p0, v0}, ${manager_type}->getApplicationRestrictions(Ljava/lang/String;)Landroid/os/Bundle;
move-result-object v2
if-eqz v1, :bad
if-eqz v2, :bad
if-eq v1, v2, :bad
invoke-virtual {v1}, Landroid/os/Bundle;->isEmpty()Z
move-result v0
if-eqz v0, :bad
invoke-virtual {v2}, Landroid/os/Bundle;->isEmpty()Z
move-result v0
if-eqz v0, :bad
const-string v0, "fixture-local"
const-string v3, "not-seed-state"
invoke-virtual {v1, v0, v3}, Landroid/os/Bundle;->putString(Ljava/lang/String;Ljava/lang/String;)V
invoke-virtual {v2}, Landroid/os/Bundle;->isEmpty()Z
move-result v0
if-eqz v0, :bad
invoke-static {p0}, ${main_type}->expectUnseeded(${manager_type})V
return-void
' + failure('Existing application restrictions must remain fresh independent empty Bundles'))
}

fn test_source() string {
	return method('private test()V', 3, '
const-string v0, "user"
invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
move-result-object v1
instance-of v2, v1, ${manager_type}
if-eqz v2, :bad
check-cast v1, ${manager_type}
invoke-static {v1}, ${main_type}->expectUnseeded(${manager_type})V
invoke-static {v1}, ${main_type}->reflection(${manager_type})V
invoke-static {v1}, ${main_type}->restrictions(${manager_type})V
const-class v0, ${manager_type}
invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;
move-result-object v1
instance-of v2, v1, ${manager_type}
if-eqz v2, :bad
check-cast v1, ${manager_type}
invoke-static {v1}, ${main_type}->expectUnseeded(${manager_type})V
invoke-static {p0}, ${main_type}->options(Landroid/content/Context;)${options_type}
move-result-object v1
sget-object v2, ${options_type}->EMPTY:${options_type}
if-ne v1, v2, :bad
invoke-static {p0}, ${main_type}->options(Landroid/content/Context;)${options_type}
move-result-object v1
if-ne v1, v2, :bad
invoke-static {}, ${main_type}->emptyShape()V
invoke-static {}, ${main_type}->immutableEmpty()V
const-string v0, "user"
invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
move-result-object v1
instance-of v2, v1, ${manager_type}
if-eqz v2, :bad
check-cast v1, ${manager_type}
invoke-static {v1}, ${main_type}->expectUnseeded(${manager_type})V
new-instance v1, ${manager_type}
invoke-direct {v1}, ${manager_type}-><init>()V
new-instance v2, ${manager_type}
invoke-direct {v2}, ${manager_type}-><init>()V
invoke-static {v1}, ${main_type}->expectUnseeded(${manager_type})V
invoke-static {v2}, ${main_type}->expectUnseeded(${manager_type})V
invoke-static {v1}, ${main_type}->expectUnseeded(${manager_type})V
return-void
' + failure('User service lookup must supply a UserManager'))
}

fn main_source() string {
	mut text := '.class public final ${main_type}\n.super Landroid/app/Activity;\n'
	text += method('public constructor <init>()V', 0,
		'invoke-direct {p0}, Landroid/app/Activity;-><init>()V\nreturn-void')
	text += null_guard_source() + reflection_source() + empty_shape_source() + immutable_empty_source() + restrictions_source() + test_source()
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
const-string v1, "Unseeded account options lookup passed"
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
		'<application android:label="Unseeded account options fixture">' +
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
	os.cp(source, out + '/inputs/seed-account-options-fixture.v')!
	os.cp(executable, out + '/inputs/generator')!
	assert file_hash(out + '/inputs/seed-account-options-fixture.v')! == inputs[source]!
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
		'CN=Vinix Seed Account Options Fixture', '-keyalg', 'RSA', '-keysize', '2048', '-validity', '3650'])!
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
		scope: 'Synthetic unseeded null lookup, typed service fallback, immutable empty singleton, mutable independent values and public shapes; seeded accounts, provisioning authority, Google services and authentication remain unverified.'
	}
	os.write_file(out + '/build.json', json2.encode(receipt, prettify: true) + '\n')!
	println('SEED-ACCOUNT-OPTIONS-FIXTURE-APK ' + apk)
	println('SEED-ACCOUNT-OPTIONS-FIXTURE-APK-SHA256 ' + receipt.apk_sha256)
}
