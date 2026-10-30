// SPDX-License-Identifier: GPL-2.0-or-later
// Read-only observations of the selected runtime's connectivity and interfaces.
module main

import crypto.sha256
import json2
import os

const package_name = 'org.vinix.bootstrap'
const main_type = 'Lorg/vinix/bootstrap/Main;'
const raw_type = 'Lorg/vinix/bootstrap/RawManager;'
const manager_type = 'Landroid/net/ConnectivityManager;'
const pass_marker = 'CONNECTIVITY-TRUTH-PASS observations active-info active-network all-networks capabilities interfaces raw-native'
const fail_marker = 'CONNECTIVITY-TRUTH-FAIL'

fn method(signature string, locals int, body string) string {
	return '.method ${signature}\n.locals ${locals}\n${body}\n.end method\n'
}

fn guarded(signature string, locals int, label string, body string) string {
	return method(signature, locals, ':probe_start\n' + body + '\n:probe_end\nreturn-void\n' +
		'.catch Ljava/lang/Exception; {:probe_start .. :probe_end} :probe_error\n:probe_error\n' +
		'move-exception v0\nconst-string v1, "${label}"\n' +
		'invoke-static {v1, v0}, ${main_type}->error(Ljava/lang/String;Ljava/lang/Exception;)V\nreturn-void')
}

fn logging_source() string {
	return method('private static text(Ljava/lang/String;Ljava/lang/String;)V', 4, '
if-nez p1, :nonnull
const-string p1, "null"
:nonnull
invoke-virtual {p1}, Ljava/lang/String;->length()I
move-result v0
const/16 v1, 256
if-le v0, v1, :bounded
const/4 v0, 0
invoke-virtual {p1, v0, v1}, Ljava/lang/String;->substring(II)Ljava/lang/String;
move-result-object p1
:bounded
const/16 v0, 10
const/16 v1, 32
invoke-virtual {p1, v0, v1}, Ljava/lang/String;->replace(CC)Ljava/lang/String;
move-result-object p1
const/16 v0, 13
invoke-virtual {p1, v0, v1}, Ljava/lang/String;->replace(CC)Ljava/lang/String;
move-result-object p1
new-instance v0, Ljava/lang/StringBuilder;
invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V
const-string v1, "CONNECTIVITY-TRUTH "
invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
const-string v1, "="
invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;
invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;
move-result-object v0
sget-object v1, Ljava/lang/System;->out:Ljava/io/PrintStream;
invoke-virtual {v1, v0}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V
invoke-virtual {v1}, Ljava/io/PrintStream;->flush()V
return-void') + method('private static number(Ljava/lang/String;I)V', 1, '
invoke-static {p1}, Ljava/lang/Integer;->toString(I)Ljava/lang/String;
move-result-object v0
invoke-static {p0, v0}, ${main_type}->text(Ljava/lang/String;Ljava/lang/String;)V
return-void') + method('private static bool(Ljava/lang/String;Z)V', 1, '
invoke-static {p1}, Ljava/lang/Boolean;->toString(Z)Ljava/lang/String;
move-result-object v0
invoke-static {p0, v0}, ${main_type}->text(Ljava/lang/String;Ljava/lang/String;)V
return-void') + method('private static error(Ljava/lang/String;Ljava/lang/Exception;)V', 3, '
invoke-virtual {p1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;
move-result-object v0
invoke-virtual {v0}, Ljava/lang/Class;->getName()Ljava/lang/String;
move-result-object v0
const-string v1, ".error.class"
invoke-virtual {p0, v1}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;
move-result-object v1
invoke-static {v1, v0}, ${main_type}->text(Ljava/lang/String;Ljava/lang/String;)V
invoke-virtual {p1}, Ljava/lang/Exception;->getMessage()Ljava/lang/String;
move-result-object v0
const-string v1, ".error.message"
invoke-virtual {p0, v1}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;
move-result-object v1
invoke-static {v1, v0}, ${main_type}->text(Ljava/lang/String;Ljava/lang/String;)V
return-void')
}

fn info_source() string {
	return guarded('private static activeInfo(${manager_type})V', 4, 'active-info', '
invoke-virtual {p0}, ${manager_type}->getActiveNetworkInfo()Landroid/net/NetworkInfo;
move-result-object v0
const-string v1, "active-info.null"
const/4 v2, 1
if-eqz v0, :null_info
const/4 v2, 0
:null_info
invoke-static {v1, v2}, ${main_type}->bool(Ljava/lang/String;Z)V
if-eqz v0, :info_done
invoke-virtual {v0}, Landroid/net/NetworkInfo;->isConnected()Z
move-result v2
const-string v1, "active-info.connected"
invoke-static {v1, v2}, ${main_type}->bool(Ljava/lang/String;Z)V
invoke-virtual {v0}, Landroid/net/NetworkInfo;->isAvailable()Z
move-result v2
const-string v1, "active-info.available"
invoke-static {v1, v2}, ${main_type}->bool(Ljava/lang/String;Z)V
invoke-virtual {v0}, Landroid/net/NetworkInfo;->getType()I
move-result v2
const-string v1, "active-info.type"
invoke-static {v1, v2}, ${main_type}->number(Ljava/lang/String;I)V
invoke-virtual {v0}, Landroid/net/NetworkInfo;->getTypeName()Ljava/lang/String;
move-result-object v2
const-string v1, "active-info.type-name"
invoke-static {v1, v2}, ${main_type}->text(Ljava/lang/String;Ljava/lang/String;)V
invoke-virtual {v0}, Landroid/net/NetworkInfo;->getState()Landroid/net/NetworkInfo$State;
move-result-object v2
invoke-static {v2}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;
move-result-object v2
const-string v1, "active-info.state"
invoke-static {v1, v2}, ${main_type}->text(Ljava/lang/String;Ljava/lang/String;)V
:info_done')
}

fn networks_source() string {
	mut result := guarded('private static network(${manager_type}Landroid/net/Network;)V', 5, 'network', '
const-string v0, "network.null"
const/4 v1, 1
if-eqz p1, :null_network
const/4 v1, 0
:null_network
invoke-static {v0, v1}, ${main_type}->bool(Ljava/lang/String;Z)V
if-eqz p1, :capabilities
invoke-virtual {p1}, Landroid/net/Network;->getNetworkHandle()J
move-result-wide v0
invoke-static {v0, v1}, Ljava/lang/Long;->toString(J)Ljava/lang/String;
move-result-object v1
const-string v0, "network.handle"
invoke-static {v0, v1}, ${main_type}->text(Ljava/lang/String;Ljava/lang/String;)V
:capabilities
invoke-virtual {p0, p1}, ${manager_type}->getNetworkCapabilities(Landroid/net/Network;)Landroid/net/NetworkCapabilities;
move-result-object v0
const-string v1, "capabilities.null"
const/4 v2, 1
if-eqz v0, :null_caps
const/4 v2, 0
:null_caps
invoke-static {v1, v2}, ${main_type}->bool(Ljava/lang/String;Z)V
if-eqz v0, :network_done
invoke-virtual {v0}, Landroid/net/NetworkCapabilities;->getCapabilities()[I
move-result-object v2
invoke-static {v2}, Ljava/util/Arrays;->toString([I)Ljava/lang/String;
move-result-object v2
const-string v1, "capabilities.values"
invoke-static {v1, v2}, ${main_type}->text(Ljava/lang/String;Ljava/lang/String;)V
invoke-virtual {v0}, Landroid/net/NetworkCapabilities;->getTransportTypes()[I
move-result-object v2
invoke-static {v2}, Ljava/util/Arrays;->toString([I)Ljava/lang/String;
move-result-object v2
const-string v1, "capabilities.transports"
invoke-static {v1, v2}, ${main_type}->text(Ljava/lang/String;Ljava/lang/String;)V
const/16 v1, 12
invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z
move-result v2
const-string v1, "capabilities.internet"
invoke-static {v1, v2}, ${main_type}->bool(Ljava/lang/String;Z)V
const/16 v1, 16
invoke-virtual {v0, v1}, Landroid/net/NetworkCapabilities;->hasCapability(I)Z
move-result v2
const-string v1, "capabilities.validated"
invoke-static {v1, v2}, ${main_type}->bool(Ljava/lang/String;Z)V
:network_done')
	result += guarded('private static activeNetwork(${manager_type})V', 3, 'active-network', '
const-string v0, "network.role"
const-string v1, "active"
invoke-static {v0, v1}, ${main_type}->text(Ljava/lang/String;Ljava/lang/String;)V
invoke-virtual {p0}, ${manager_type}->getActiveNetwork()Landroid/net/Network;
move-result-object v0
invoke-static {p0, v0}, ${main_type}->network(${manager_type}Landroid/net/Network;)V')
	result += guarded('private static allNetworks(${manager_type})V', 5, 'all-networks', '
invoke-virtual {p0}, ${manager_type}->getAllNetworks()[Landroid/net/Network;
move-result-object v0
const-string v1, "all-networks.null"
const/4 v2, 1
if-eqz v0, :null_array
const/4 v2, 0
:null_array
invoke-static {v1, v2}, ${main_type}->bool(Ljava/lang/String;Z)V
if-eqz v0, :array_done
array-length v2, v0
const-string v1, "all-networks.count"
invoke-static {v1, v2}, ${main_type}->number(Ljava/lang/String;I)V
const/4 v3, 0
:array_loop
if-ge v3, v2, :array_done
const/16 v4, 32
if-ge v3, v4, :array_limit
const-string v1, "network.role"
const-string v4, "array"
invoke-static {v1, v4}, ${main_type}->text(Ljava/lang/String;Ljava/lang/String;)V
const-string v1, "network.index"
invoke-static {v1, v3}, ${main_type}->number(Ljava/lang/String;I)V
aget-object v1, v0, v3
invoke-static {p0, v1}, ${main_type}->network(${manager_type}Landroid/net/Network;)V
add-int/lit8 v3, v3, 1
goto :array_loop
:array_limit
const-string v1, "all-networks.truncated"
const/4 v4, 1
invoke-static {v1, v4}, ${main_type}->bool(Ljava/lang/String;Z)V
:array_done')
	return result
}

fn interfaces_source() string {
	mut result := guarded('private static addresses(Ljava/net/NetworkInterface;)V', 5, 'interface.addresses', '
invoke-virtual {p0}, Ljava/net/NetworkInterface;->getInetAddresses()Ljava/util/Enumeration;
move-result-object v0
const/4 v1, 0
:address_loop
invoke-interface {v0}, Ljava/util/Enumeration;->hasMoreElements()Z
move-result v2
if-eqz v2, :addresses_done
const/16 v2, 64
if-ge v1, v2, :addresses_limit
invoke-interface {v0}, Ljava/util/Enumeration;->nextElement()Ljava/lang/Object;
move-result-object v2
check-cast v2, Ljava/net/InetAddress;
invoke-virtual {v2}, Ljava/net/InetAddress;->getHostAddress()Ljava/lang/String;
move-result-object v2
const-string v3, "interface.address"
invoke-static {v3, v2}, ${main_type}->text(Ljava/lang/String;Ljava/lang/String;)V
add-int/lit8 v1, v1, 1
goto :address_loop
:addresses_limit
const-string v3, "interface.addresses.truncated"
const/4 v4, 1
invoke-static {v3, v4}, ${main_type}->bool(Ljava/lang/String;Z)V
:addresses_done
const-string v3, "interface.addresses.observed-count"
invoke-static {v3, v1}, ${main_type}->number(Ljava/lang/String;I)V')
	result += guarded('private static up(Ljava/net/NetworkInterface;)V', 3, 'interface.up', '
invoke-virtual {p0}, Ljava/net/NetworkInterface;->isUp()Z
move-result v0
const-string v1, "interface.up"
invoke-static {v1, v0}, ${main_type}->bool(Ljava/lang/String;Z)V')
	result += guarded('private static interfaces()V', 6, 'interfaces', '
invoke-static {}, Ljava/net/NetworkInterface;->getNetworkInterfaces()Ljava/util/Enumeration;
move-result-object v0
const-string v1, "interfaces.null"
const/4 v2, 1
if-eqz v0, :null_interfaces
const/4 v2, 0
:null_interfaces
invoke-static {v1, v2}, ${main_type}->bool(Ljava/lang/String;Z)V
if-eqz v0, :interfaces_done
const/4 v1, 0
:interface_loop
invoke-interface {v0}, Ljava/util/Enumeration;->hasMoreElements()Z
move-result v2
if-eqz v2, :interfaces_count
const/16 v2, 32
if-ge v1, v2, :interfaces_limit
invoke-interface {v0}, Ljava/util/Enumeration;->nextElement()Ljava/lang/Object;
move-result-object v2
check-cast v2, Ljava/net/NetworkInterface;
const-string v3, "interface.index"
invoke-static {v3, v1}, ${main_type}->number(Ljava/lang/String;I)V
invoke-virtual {v2}, Ljava/net/NetworkInterface;->getName()Ljava/lang/String;
move-result-object v4
const-string v3, "interface.name"
invoke-static {v3, v4}, ${main_type}->text(Ljava/lang/String;Ljava/lang/String;)V
invoke-static {v2}, ${main_type}->up(Ljava/net/NetworkInterface;)V
invoke-static {v2}, ${main_type}->addresses(Ljava/net/NetworkInterface;)V
add-int/lit8 v1, v1, 1
goto :interface_loop
:interfaces_limit
const-string v3, "interfaces.truncated"
const/4 v4, 1
invoke-static {v3, v4}, ${main_type}->bool(Ljava/lang/String;Z)V
:interfaces_count
const-string v3, "interfaces.observed-count"
invoke-static {v3, v1}, ${main_type}->number(Ljava/lang/String;I)V
:interfaces_done')
	return result
}

fn raw_source() string {
	return '.class public final ${raw_type}\n.super ${manager_type}\n' +
		method('public constructor <init>()V', 0, 'invoke-direct {p0}, ${manager_type}-><init>()V\nreturn-void') +
		method('public rawState()I', 1, 'invoke-virtual {p0}, ${manager_type}->nativeGetNetworkState()I\nmove-result v0\nreturn v0')
}

fn main_source() string {
	mut source := '.class public final ${main_type}\n.super Landroid/app/Activity;\n'
	source += method('public constructor <init>()V', 0, 'invoke-direct {p0}, Landroid/app/Activity;-><init>()V\nreturn-void')
	source += logging_source() + info_source() + networks_source() + interfaces_source()
	source += guarded('private static nativeState()V', 3, 'raw-native', '
new-instance v0, ${raw_type}
invoke-direct {v0}, ${raw_type}-><init>()V
invoke-virtual {v0}, ${raw_type}->rawState()I
move-result v0
const-string v1, "raw-native.state"
invoke-static {v1, v0}, ${main_type}->number(Ljava/lang/String;I)V')
	source += guarded('private static connectivity(Landroid/content/Context;)V', 4, 'connectivity-service', '
const-string v0, "connectivity"
invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;
move-result-object v0
const-string v1, "manager.null"
const/4 v2, 1
if-eqz v0, :manager_null
const/4 v2, 0
:manager_null
invoke-static {v1, v2}, ${main_type}->bool(Ljava/lang/String;Z)V
if-eqz v0, :manager_done
check-cast v0, ${manager_type}
invoke-static {v0}, ${main_type}->activeInfo(${manager_type})V
invoke-static {v0}, ${main_type}->activeNetwork(${manager_type})V
invoke-static {v0}, ${main_type}->allNetworks(${manager_type})V
:manager_done')
	source += method('public onCreate(Landroid/os/Bundle;)V', 3, '
invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V
:test_start
invoke-static {}, Landroid/os/Process;->myUid()I
move-result v0
const-string v1, "process.uid"
invoke-static {v1, v0}, ${main_type}->number(Ljava/lang/String;I)V
invoke-static {p0}, ${main_type}->connectivity(Landroid/content/Context;)V
invoke-static {}, ${main_type}->nativeState()V
invoke-static {}, ${main_type}->interfaces()V
:test_end
sget-object v0, Ljava/lang/System;->out:Ljava/io/PrintStream;
const-string v1, "${pass_marker}"
invoke-virtual {v0, v1}, Ljava/io/PrintStream;->println(Ljava/lang/String;)V
invoke-virtual {v0}, Ljava/io/PrintStream;->flush()V
new-instance v0, Landroid/widget/TextView;
invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V
const-string v1, "Connectivity observations completed"
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
	return source
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
		'<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>' +
		'<application android:label="Connectivity truth fixture"><activity android:name="${package_name}.Main" android:exported="true"><intent-filter>' +
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
	os.cp(source, out + '/inputs/connectivity-truth-fixture.v')!
	os.cp(executable, out + '/inputs/generator')!
	assert file_hash(out + '/inputs/connectivity-truth-fixture.v')! == inputs[source]!
	assert file_hash(out + '/inputs/generator')! == inputs[executable]!
	os.write_file(out + '/inputs-before.json', json2.encode(inputs, prettify: true) + '\n')!
	dir := out + '/smali/org/vinix/bootstrap'
	os.mkdir_all(dir)!
	os.write_file(dir + '/Main.smali', main_source())!
	os.write_file(dir + '/RawManager.smali', raw_source())!
	os.write_file(out + '/AndroidManifest.xml', manifest())!
	revision := recorded(out, 'source-revision', ['git', 'rev-parse', 'HEAD'])!.trim_space()
	java_version := recorded(out, 'java-version', java_command(java, ['-version']))!
	key := out + '/fixture.p12'
	recorded(out, 'keytool', [keytool, '-J-Xmx256m', '-J-XX:ActiveProcessorCount=2', '-genkeypair', '-keystore', key, '-storetype', 'PKCS12',
		'-storepass', 'android', '-keypass', 'android', '-alias', 'fixture', '-dname', 'CN=Vinix Connectivity Truth Fixture',
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
	assert first.len == 2 && second.len == first.len
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
		scope: 'Read-only ConnectivityManager and actual java.net.NetworkInterface observations; inherited protected nativeGetNetworkState bridge; offline/null/operational errors are observations, not connectivity assertions. No sockets, callbacks, permission grant, SDK/native modification or authentication claim.'
	}
	os.write_file(out + '/build.json', json2.encode(receipt, prettify: true) + '\n')!
	println('CONNECTIVITY-TRUTH-FIXTURE-APK ' + apk)
	println('CONNECTIVITY-TRUTH-FIXTURE-APK-SHA256 ' + receipt.apk_sha256)
}
