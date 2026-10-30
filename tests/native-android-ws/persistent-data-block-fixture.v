// SPDX-License-Identifier: GPL-2.0-or-later
// Signed ART regression for an unavailable persistent-data-block service type.
module main

import crypto.sha256
import json2
import os

const package_name = 'org.vinix.bootstrap'
const main_type = 'Lorg/vinix/bootstrap/Main;'
const manager_type = 'Landroid/service/persistentdata/PersistentDataBlockManager;'
const pass_marker = 'PERSISTENT-DATA-BLOCK-PASS class-shape named-null typed-null null-cast user-service seed-options immutable-empty'
const fail_marker = 'PERSISTENT-DATA-BLOCK-FAIL'

fn method(signature string, locals int, body string) string {
	return '.method ${signature}\n.locals ${locals}\n${body}\n.end method\n'
}

fn failure(message string) string {
	return ':bad\nnew-instance v0, Ljava/lang/AssertionError;\nconst-string v1, "${message}"\n' +
		'invoke-direct {v0, v1}, Ljava/lang/AssertionError;-><init>(Ljava/lang/Object;)V\nthrow v0'
}

fn gms_lookup_source() string {
	mut text := method('private static manager(Landroid/content/Context;)${manager_type}', 1, '
# The audited helper uses the app context, named service and synthetic cast.
invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;
move-result-object p0
const-string v0, "persistent_data_block"
invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
move-result-object v0
check-cast v0, ${manager_type}
return-object v0')
	text += method('private static available(Landroid/content/Context;)Z', 1, '
invoke-static {p0}, ${main_type}->manager(Landroid/content/Context;)${manager_type}
move-result-object v0
if-eqz v0, :absent
const/4 v0, 1
return v0
:absent
const/4 v0, 0
return v0')
	mut body := ''
	for _ in 0 .. 3 {
		body += '
const-string v0, "persistent_data_block"
invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
move-result-object v0
check-cast v0, ${manager_type}
if-nez v0, :bad
const-class v0, ${manager_type}
invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;
move-result-object v0
check-cast v0, ${manager_type}
if-nez v0, :bad
'
	}
	body += '
const/4 v0, 0
check-cast v0, ${manager_type}
if-nez v0, :bad
invoke-static {p0}, ${main_type}->manager(Landroid/content/Context;)${manager_type}
move-result-object v0
if-nez v0, :bad
invoke-static {p0}, ${main_type}->available(Landroid/content/Context;)Z
move-result v0
if-nez v0, :bad
return-void
' + failure('Unavailable persistent data block lookups and the guarded cast must remain null')
	text += method('private static expectAbsent(Landroid/content/Context;)V', 2, body)
	return text
}

fn shape_source() string {
	return method('private static shape()V', 3, '
const-class v0, ${manager_type}
const-string v1, "android.service.persistentdata.PersistentDataBlockManager"
invoke-static {v1}, Ljava/lang/Class;->forName(Ljava/lang/String;)Ljava/lang/Class;
move-result-object v1
if-ne v0, v1, :bad
invoke-virtual {v0}, Ljava/lang/Class;->getSuperclass()Ljava/lang/Class;
move-result-object v1
const-class v2, Ljava/lang/Object;
if-ne v1, v2, :bad
invoke-virtual {v0}, Ljava/lang/Class;->getModifiers()I
move-result v1
and-int/lit8 v2, v1, 0x1
if-eqz v2, :bad
and-int/lit8 v2, v1, 0x10
if-nez v2, :bad
and-int/lit16 v2, v1, 0x600
if-nez v2, :bad
invoke-virtual {v0}, Ljava/lang/Class;->getDeclaredFields()[Ljava/lang/reflect/Field;
move-result-object v1
array-length v1, v1
if-nez v1, :bad
invoke-virtual {v0}, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;
move-result-object v1
array-length v1, v1
if-nez v1, :bad
invoke-virtual {v0}, Ljava/lang/Class;->getDeclaredConstructors()[Ljava/lang/reflect/Constructor;
move-result-object v1
array-length v1, v1
if-nez v1, :bad
return-void
' + failure('PersistentDataBlockManager must expose only its public nonfinal Object class identity'))
}

fn related_source() string {
	return method('private static related(Landroid/content/Context;)V', 3, '
const-string v0, "user"
invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
move-result-object v0
instance-of v1, v0, Landroid/os/UserManager;
if-eqz v1, :bad
check-cast v0, Landroid/os/UserManager;
invoke-virtual {v0}, Landroid/os/UserManager;->getSeedAccountOptions()Landroid/os/PersistableBundle;
move-result-object v0
if-nez v0, :bad
const-class v0, Landroid/os/UserManager;
invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;
move-result-object v0
instance-of v1, v0, Landroid/os/UserManager;
if-eqz v1, :bad
check-cast v0, Landroid/os/UserManager;
invoke-virtual {v0}, Landroid/os/UserManager;->getSeedAccountOptions()Landroid/os/PersistableBundle;
move-result-object v0
if-nez v0, :bad
const-string v0, "layout_inflater"
invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
move-result-object v0
instance-of v1, v0, Landroid/view/LayoutInflater;
if-eqz v1, :bad
const-class v0, Landroid/view/LayoutInflater;
invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/Class;)Ljava/lang/Object;
move-result-object v0
instance-of v1, v0, Landroid/view/LayoutInflater;
if-eqz v1, :bad
return-void
' + failure('UserManager seed options and LayoutInflater service lookups must remain usable'))
}

fn empty_source() string {
	return method('private static emptyInterop()V', 4, '
sget-object v0, Landroid/os/PersistableBundle;->EMPTY:Landroid/os/PersistableBundle;
if-eqz v0, :bad
invoke-virtual {v0}, Landroid/os/PersistableBundle;->isEmpty()Z
move-result v1
if-eqz v1, :bad
const-string v1, "fixture-local"
const/16 v2, 42
:put_start
invoke-virtual {v0, v1, v2}, Landroid/os/PersistableBundle;->putInt(Ljava/lang/String;I)V
:put_end
goto :bad
.catch Ljava/lang/UnsupportedOperationException; {:put_start .. :put_end} :rejected
:rejected
move-exception v3
invoke-virtual {v0}, Landroid/os/PersistableBundle;->isEmpty()Z
move-result v3
if-eqz v3, :bad
new-instance v3, Landroid/os/PersistableBundle;
invoke-direct {v3}, Landroid/os/PersistableBundle;-><init>()V
invoke-virtual {v3, v1, v2}, Landroid/os/PersistableBundle;->putInt(Ljava/lang/String;I)V
invoke-virtual {v3, v1}, Landroid/os/PersistableBundle;->getInt(Ljava/lang/String;)I
move-result v1
if-ne v1, v2, :bad
invoke-virtual {v0}, Landroid/os/PersistableBundle;->isEmpty()Z
move-result v1
if-eqz v1, :bad
return-void
' + failure('PersistableBundle.EMPTY must reject writes while ordinary bundles remain mutable'))
}

fn main_source() string {
	mut text := '.class public final ${main_type}\n.super Landroid/app/Activity;\n'
	text += method('public constructor <init>()V', 0,
		'invoke-direct {p0}, Landroid/app/Activity;-><init>()V\nreturn-void')
	text += gms_lookup_source() + shape_source() + related_source() + empty_source()
	text += method('private test()V', 2, '
invoke-static {}, ${main_type}->shape()V
invoke-static {p0}, ${main_type}->expectAbsent(Landroid/content/Context;)V
invoke-static {p0}, ${main_type}->related(Landroid/content/Context;)V
invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;
move-result-object v0
if-eqz v0, :bad
invoke-static {v0}, ${main_type}->expectAbsent(Landroid/content/Context;)V
invoke-static {v0}, ${main_type}->related(Landroid/content/Context;)V
invoke-static {}, ${main_type}->emptyInterop()V
return-void
' + failure('Application context is required for the audited absent-service lookup'))
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
const-string v1, "Persistent data block service absence passed"
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
		'<application android:label="Persistent data block absence fixture">' +
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
	os.cp(source, out + '/inputs/persistent-data-block-fixture.v')!
	os.cp(executable, out + '/inputs/generator')!
	assert file_hash(out + '/inputs/persistent-data-block-fixture.v')! == inputs[source]!
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
		'CN=Vinix Persistent Data Block Fixture', '-keyalg', 'RSA', '-keysize', '2048', '-validity', '3650'])!
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
		scope: 'Synthetic absent-service class identity, named and typed null lookups, guarded null cast and existing user/empty-bundle interop; no persistent storage, FRP operations, provisioning authority or authentication claim.'
	}
	os.write_file(out + '/build.json', json2.encode(receipt, prettify: true) + '\n')!
	println('PERSISTENT-DATA-BLOCK-FIXTURE-APK ' + apk)
	println('PERSISTENT-DATA-BLOCK-FIXTURE-APK-SHA256 ' + receipt.apk_sha256)
}
