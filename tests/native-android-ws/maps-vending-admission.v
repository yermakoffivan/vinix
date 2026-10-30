// SPDX-License-Identifier: GPL-2.0-or-later
// Admit one pinned Vending APK from immutable boot media at the guest's SDK.
module main

import json2
import mapsaccountstage as stage
import os
import tarstream
import time

#include <unistd.h>
#include <errno.h>
#include <poll.h>
#include <signal.h>
#include <sys/wait.h>
@[typedef]
struct C.posix_spawn_file_actions_t {}
pub struct C.pollfd {
pub mut:
	fd i32
	events i16
	revents i16
}
@[c: 'read']
fn C.vending_admission_read(i32, voidptr, u64) i64
@[c: 'poll']
fn C.vending_admission_poll(&C.pollfd, u64, i32) i32
@[c: 'posix_spawnp']
fn C.vending_admission_spawn(&i32, &char, voidptr, voidptr, &&char, &&char) i32
@[c: 'posix_spawn_file_actions_init']
fn C.vending_admission_actions_init(voidptr) i32
@[c: 'posix_spawn_file_actions_destroy']
fn C.vending_admission_actions_destroy(voidptr) i32
@[c: 'posix_spawn_file_actions_adddup2']
fn C.vending_admission_actions_dup2(voidptr, i32, i32) i32
@[c: 'posix_spawn_file_actions_addclose']
fn C.vending_admission_actions_close(voidptr, i32) i32
@[c: 'waitpid']
fn C.vending_admission_wait(i32, &i32, i32) i32
@[c: 'kill']
fn C.vending_admission_kill(i32, i32) i32
@[c: 'WIFEXITED']
fn C.vending_admission_exited(i32) i32
@[c: 'WEXITSTATUS']
fn C.vending_admission_exit_status(i32) i32

const repo = '/Users/alex/code/vinix'
const state = '/Users/alex/.local/state/vinix/android'
const base_root = state + '/maps-broker-tail-r1'
const base_seal = 'c6ab0709b40b1718f0d3c6d13e6f1ba3f2a8ccf5de2b6a8e36cd62802ef2c6e9'
const boot_pin = 'e8e820377cae6fb1b0f32e0c7d0eedeb4164b9bab82c71226b8c35d3867b52f4'
const module_name = 'qemu-runtime.tar'
const module_pin = '1c6988d1f3d3844425f0e8cbb49a878b3a16f2a270b4eb3852c71dfaa8fe200e'
const member_name = 'tmp/maps256-data/_installed_apks_/com.android.vending.apk'
const apk_pin = '444e41ee8ef6ec8c55815087c51c28e516ea32f93d856f8bdd0025bb6fc36bc2'
const apk_size = u64(106020565)
const certificate_pin = 'f0fd6c5b410f25cb25c3b53346c8972fae30f8ee7411df910480ad6b2d60db83'
const mtype = state + '/maps-account-r5/tools/mtype'
const mtype_pin = 'e8310ca53ac5f471b7cd8b0b4dacd2ef11a57e399e35d034d1b6899e49dd48a6'
const aapt = repo + '/build/android-native-ws/aapt2'
const aapt_pin = '71b3b768db0d930691706cb31413c7e2664959842fd8fba50b619d0da3d50c36'
const signer = repo + '/build/android-native-ws/android-15/lib/apksigner.jar'
const signer_pin = '00ef9948f843fe395d2440ae3ef41405b8040a6d5d46493bd1902ac0ee6deae7'
const java = '/opt/homebrew/Cellar/openjdk@25/25.0.5.0.2/libexec/openjdk.jdk/Contents/Home/bin/java'
const java_pin = '236c86402d47923ebc974f8237175038eedfcb3b8a7594b2a2dd8113249b99ea'
const version_name = '52.9.21-24 [0] [PR] 968642861'
const retained = {
	'tests/native-android-ws/maps-vending-admission.v': $embed_file(@FILE).to_string()
	'tests/native-android-ws/mapsaccountstage/bundle.v': $embed_file('mapsaccountstage/bundle.v').to_string()
	'tests/native-android-ws/mapsaccountstage/hostsha.v': $embed_file('mapsaccountstage/hostsha.v').to_string()
	'tests/native-android-ws/mapsaccountstage/parallel.v': $embed_file('mapsaccountstage/parallel.v').to_string()
	'tests/native-android-ws/mapsaccountstage/elf.v': $embed_file('mapsaccountstage/elf.v').to_string()
	'tests/native-android-ws/mapsaccountstage/media.v': $embed_file('mapsaccountstage/media.v').to_string()
	'tests/native-android-ws/mapsaccountstage/headless.v': $embed_file('mapsaccountstage/headless.v').to_string()
	'build-support/android/modulestream/stream.v': $embed_file('../../build-support/android/modulestream/stream.v').to_string()
	'build-support/android/modulestream/spawn_abi.h': $embed_file('../../build-support/android/modulestream/spawn_abi.h').to_string()
	'build-support/tarcore/writer.v': $embed_file('../../build-support/tarcore/writer.v').to_string()
	'build-support/tarcore/gzip.v': $embed_file('../../build-support/tarcore/gzip.v').to_string()
	'build-support/tarstream/reader.v': $embed_file('../../build-support/tarstream/reader.v').to_string()
	'build-support/tarstream/sparse.v': $embed_file('../../build-support/tarstream/sparse.v').to_string()
	'build-support/tarstream/filter_abi.h': $embed_file('../../build-support/tarstream/filter_abi.h').to_string()
}

struct Metadata {
	package_name string
	version_code string
	version_name string
	min_sdk string
	target_sdk string
	split_name string
	split_required bool
	native_abis []string
}

fn as_json[T](value T) !json2.Any { return json2.decode[json2.Any](json2.encode(value)) }
fn write_json[T](path string, value T) ! {
	os.write_file(path, json2.encode(value, prettify: true) + '\n')!
	os.chmod(path, 0o600)!
}
fn regular(path string) ! {
	if os.real_path(path) != path || os.is_link(path) || os.lstat(path)!.get_filetype() != .regular {
		return error('canonical regular input required: ' + path)
	}
}
fn tool_pins() map[string]string {
	return {mtype: mtype_pin, aapt: aapt_pin, signer: signer_pin, java: java_pin}
}
fn verify_tools() ! {
	for path, pin in tool_pins() { regular(path)!; if stage.hash(path)! != pin { return error('qualified tool differs: ' + path) } }
}

// aapt's package header is a key='value' record. Values may contain spaces;
// duplicate names and malformed quoting are refused rather than normalized.
fn package_fields(line string) !map[string]string {
	if !line.starts_with('package: ') { return error('package header absent') }
	mut rest := line.all_after('package: ').trim_space()
	mut result := map[string]string{}
	for rest != '' {
		equal := rest.index("='") or { return error('malformed package attribute') }
		name := rest[..equal]
		if name == '' || !name.bytes().all((it >= `a` && it <= `z`) || (it >= `A` && it <= `Z`) || (it >= `0` && it <= `9`) || it in [`_`, `-`]) || name in result {
			return error('duplicate or malformed package attribute')
		}
		rest = rest[equal + 2..]
		end := rest.index("'") or { return error('unterminated package attribute') }
		result[name] = rest[..end]
		rest = rest[end + 1..]
		if rest != '' && !rest.starts_with(' ') { return error('package attribute separator absent') }
		rest = rest.trim_space()
	}
	return result
}
fn one_value(lines []string, prefix string) !string {
	selected := lines.filter(it.starts_with(prefix))
	if selected.len != 1 { return error('one metadata value required: ' + prefix) }
	value := selected[0].all_after(prefix)
	if !value.starts_with("'") || !value.ends_with("'") || value.len < 2 || value[1..value.len - 1].contains("'") {
		return error('quoted metadata scalar required')
	}
	return value[1..value.len - 1]
}
fn quoted_abis(line string) ![]string {
	mut rest := line.all_after('native-code:').trim_space()
	mut result := []string{}
	for rest != '' {
		if !rest.starts_with("'") { return error('quoted native ABI required') }
		rest = rest[1..]
		end := rest.index("'") or { return error('unterminated native ABI') }
		value := rest[..end]
		if value !in ['arm64-v8a', 'armeabi-v7a', 'armeabi', 'x86', 'x86_64', 'mips', 'mips64', 'riscv64'] || value in result { return error('unknown or duplicate native ABI') }
		result << value
		rest = rest[end + 1..]
		if rest != '' && !rest.starts_with(' ') { return error('native ABI separator absent') }
		rest = rest.trim_space()
	}
	if result.len == 0 { return error('native ABI metadata absent') }
	return result
}
fn metadata(badging string, manifest string) !Metadata {
	if badging.len == 0 || badging.len > 4 * 1024 * 1024 || manifest.len == 0 || manifest.len > 8 * 1024 * 1024
		|| badging.contains('\x00') || manifest.contains('\x00') { return error('bounded textual APK metadata required') }
	lines := badging.split_into_lines()
	headers := lines.filter(it.starts_with('package: '))
	if headers.len != 1 { return error('one package header required') }
	fields := package_fields(headers[0])!
	name := fields['name'] or { return error('package name absent') }
	code := fields['versionCode'] or { return error('version code absent') }
	version := fields['versionName'] or { return error('version name absent') }
	split := fields['split'] or { '' }
	minimum := one_value(lines, 'minSdkVersion:')!
	target := one_value(lines, 'targetSdkVersion:')!
	if name != 'com.android.vending' || code != '85292100' || version != version_name || minimum != '24' || target != '37' || split != '' {
		return error('pinned Vending package/version/SDK/base metadata differs')
	}
	if lines.any(it.starts_with('uses-split:') || it.starts_with('uses-split-not-required:')) { return error('split package dependency is not admitted') }
	if lines.any(it.starts_with('sdkVersion:')) { return error('ambiguous legacy minimum SDK record') }
	abi_lines := lines.filter(it.starts_with('native-code:'))
	if abi_lines.len != 1 { return error('one native ABI record required') }
	abis := quoted_abis(abi_lines[0])!
	mut packages := 0
	mut roots := 0
	for raw in manifest.split_into_lines() {
		line := raw.trim_space()
		if line.starts_with('E: manifest ') { roots++ }
		if line.starts_with('A: package=') {
			packages++
			if line.all_after('A: package=') != '"com.android.vending" (Raw: "com.android.vending")' { return error('manifest package differs') }
		}
		if line.starts_with('A: split=') && line.all_after('A: split=') !in ['""', '"" (Raw: "")'] { return error('manifest split name is not empty') }
		if line.starts_with('E: uses-split ') { return error('manifest split dependency is not admitted') }
		attribute := if line.starts_with('A: http://schemas.android.com/apk/res/android:') { 'A: android:' + line.all_after('A: http://schemas.android.com/apk/res/android:') } else { line }
		if attribute.starts_with('A: android:isSplitRequired') {
			value := attribute.all_after('=').trim_space()
			if value !in ['(type 0x12)0x0', 'false'] { return error('manifest requires splits or has an unknown split flag') }
		}
		if attribute.starts_with('A: android:requiredSplitTypes') && attribute.all_after('=').trim_space() !in ['""', '"" (Raw: "")'] { return error('manifest required split types are not empty') }
	}
	if roots != 1 || packages != 1 { return error('one complete manifest root/package required') }
	return Metadata{name, code, version, minimum, target, split, false, abis}
}
fn sdk29_certificate(output string) !string {
	if output.len == 0 || output.len > 1024 * 1024 || output.contains('\x00') { return error('bounded signature output required') }
	lines := output.split_into_lines()
	if lines.filter(it == 'Verifies').len != 1 || lines.filter(it == 'Number of signers: 1').len != 1 { return error('one verified SDK29 signer required') }
	certificates := lines.filter(it.starts_with('Signer #1 certificate SHA-256 digest: '))
	if certificates.len != 1 || certificates[0] != 'Signer #1 certificate SHA-256 digest: ' + certificate_pin { return error('SDK29 signing certificate differs') }
	for line in lines.filter(it.starts_with('Signer #')) { if !line.starts_with('Signer #1 ') { return error('multiple or malformed SDK29 signers') } }
	return certificate_pin
}

fn stream_argv() []string { return [mtype, '-i', base_root + '/boot.img', '::/boot/' + module_name] }
struct StreamChild {
	pid i32
	descriptor i32
mut:
	reaped bool
}
fn stream_child() !StreamChild {
	mut pipe := os.pipe()!
	defer { pipe.close() }
	if pipe.read_fd < 3 || pipe.write_fd < 3 { return error('private stream descriptors required') }
	for descriptor in [pipe.read_fd, pipe.write_fd] {
		if C.fcntl(i32(descriptor), C.F_SETFD, C.FD_CLOEXEC) != 0 { return os.error_posix() }
	}
	mut actions := C.posix_spawn_file_actions_t{}
	if C.vending_admission_actions_init(&actions) != 0 { return error('stream spawn action initialization failed') }
	defer { C.vending_admission_actions_destroy(&actions) }
	if C.vending_admission_actions_dup2(&actions, i32(pipe.write_fd), 1) != 0 { return error('stream stdout action failed') }
	for descriptor in [pipe.read_fd, pipe.write_fd] {
		if C.vending_admission_actions_close(&actions, i32(descriptor)) != 0 { return error('stream close action failed') }
	}
	reader_argv := stream_argv()
	mut pointers := []&char{}
	for value in reader_argv { pointers << &char(value.str) }
	pointers << &char(unsafe { nil })
	mut environment := []string{}
	for name, value in os.environ() { environment << name + '=' + value }
	mut envp := []&char{}
	for value in environment { envp << &char(value.str) }
	envp << &char(unsafe { nil })
	mut pid := i32(0)
	status := C.vending_admission_spawn(&pid, mtype.str, &actions, unsafe { nil }, pointers.data, envp.data)
	if status != 0 { return error('cannot spawn qualified module reader: ' + status.str()) }
	mut child := StreamChild{pid: pid, descriptor: i32(pipe.read_fd)}
	pipe.read_fd = -1
	if C.fcntl(child.descriptor, C.F_SETFL, C.O_NONBLOCK) != 0 { child.close(); return os.error_posix() }
	return child
}
fn (mut child StreamChild) close() {
	if child.descriptor >= 0 { os.fd_close(int(child.descriptor)) }
	if !child.reaped && child.pid > 1 {
		C.vending_admission_kill(child.pid, C.SIGKILL)
		mut status := i32(0)
		for C.vending_admission_wait(child.pid, &status, 0) < 0 { if C.errno != C.EINTR { break } }
		child.reaped = true
	}
}
fn read_chunk(descriptor i32, mut buffer []u8, deadline i64) !int {
	for {
		if time.sys_mono_now() >= deadline { return error('module stream deadline exceeded') }
		count := C.vending_admission_read(descriptor, buffer.data, u64(buffer.len))
		if count >= 0 { return int(count) }
		if C.errno == C.EINTR { continue }
		if C.errno !in [C.EAGAIN, C.EWOULDBLOCK] { return os.error_posix() }
		mut item := C.pollfd{fd: descriptor, events: i16(C.POLLIN)}
		status := C.vending_admission_poll(&item, 1, 100)
		if status < 0 && C.errno != C.EINTR { return os.error_posix() }
	}
}
fn finish_stream(mut child StreamChild, deadline i64) !int {
	for {
		mut status := i32(0)
		waited := C.vending_admission_wait(child.pid, &status, C.WNOHANG)
		if waited == child.pid {
			child.reaped = true
			if C.vending_admission_exited(status) == 0 || C.vending_admission_exit_status(status) != 0 { return error('mtype stream process failed, raw wait status=' + status.str()) }
			return 0
		}
		if waited < 0 && C.errno != C.EINTR { return os.error_posix() }
		if time.sys_mono_now() >= deadline { return error('module child exit deadline exceeded') }
		time.sleep(time.millisecond)
	}
	return error('unreachable stream status')
}
fn module_hash(root string, label string) ! {
	mut child := stream_child()!
	defer { child.close() }
	deadline := time.sys_mono_now() + 300 * time.second
	mut hash := stage.new_host_sha256()!
	defer { hash.close() }
	mut buffer := []u8{len: 1024 * 1024}
	mut bytes := u64(0)
	for {
		count := read_chunk(child.descriptor, mut buffer, deadline)!
		if count == 0 { break }
		bytes += u64(count)
		if bytes > u64(4) * 1024 * 1024 * 1024 { return error('module stream exceeds boot media bound') }
		hash.update(buffer[..count])!
	}
	actual := hash.finish()!
	status := finish_stream(mut child, deadline)!
	write_json(root + '/commands/' + label + '.json', {'argv': as_json(stream_argv())!, 'exit_code': as_json(status)!, 'bytes': as_json(bytes)!, 'sha256': as_json(actual)!})!
	if actual != module_pin { return error('complete qemu-runtime module bytes differ') }
}
fn selected_member(name string, regular bool, size i64, link string) !bool {
	if name.trim_left('./') != member_name { return false }
	if name != member_name && name != './' + member_name { return error('ambiguous selected member path') }
	if !regular || size != i64(apk_size) || link != '' { return error('selected APK is not the exact regular member') }
	return true
}
fn extract_apk(root string) ! {
	mut child := stream_child()!
	defer { child.close() }
	deadline := time.sys_mono_now() + 300 * time.second
	mut archive := tarstream.from_descriptor(child.descriptor)!
	defer { archive.close() }
	mut selected := 0
	mut entries := 0
	mut buffer := []u8{len: 1024 * 1024}
	for {
		member := archive.next() or { if err is tarstream.End { break }; return err }
		entries++
		if entries > 1000000 || time.sys_mono_now() >= deadline { return error('bounded module archive required') }
		if !selected_member(member.name, member.regular(), member.size, member.linkname)! { continue }
		selected++
		if selected != 1 { return error('duplicate selected APK member') }
		mut output := os.open_file(root + '/vending.apk', 'wx', 0o600)!
		mut bytes := u64(0)
		for {
			count := archive.read(mut buffer)!
			if count == 0 { break }
			unsafe { output.write_full_buffer(buffer.data, uint(count))! }
			bytes += u64(count)
		}
		output.close()
		if bytes != apk_size { return error('selected APK extraction length differs') }
	}
	// Consume physical trailing bytes too, then observe the producer's real exit.
	mut trailing := u64(0)
	for { count := read_chunk(child.descriptor, mut buffer, deadline)!; if count == 0 { break }; trailing += u64(count) }
	status := finish_stream(mut child, deadline)!
	write_json(root + '/commands/extract.json', {'argv': as_json(stream_argv())!, 'exit_code': as_json(status)!, 'archive_entries': as_json(entries)!, 'selected_count': as_json(selected)!, 'trailing_bytes': as_json(trailing)!})!
	if selected != 1 || stage.hash(root + '/vending.apk')! != apk_pin { return error('one exact extracted Vending APK required') }
}
fn record_command(root string, label string, argv []string) !string {
	mut child := os.new_process(argv[0])
	child.use_pgroup = true
	child.set_args(argv[1..])
	child.set_stdin_path('/dev/null')
	child.set_redirect_stdio_merged()
	child.run()
	defer { if child.is_alive() { child.signal_pgkill() }; child.wait(); child.close() }
	mut output := ''
	deadline := time.sys_mono_now() + 180 * time.second
	for {
		text := child.stdout_read()
		output += text
		if output.len > 8 * 1024 * 1024 || time.sys_mono_now() >= deadline { return error('metadata command output or deadline bound') }
		if !child.is_alive() && text == '' { break }
		time.sleep(time.millisecond)
	}
	child.wait()
	os.write_file(root + '/commands/' + label + '.log', output)!
	os.chmod(root + '/commands/' + label + '.log', 0o600)!
	write_json(root + '/commands/' + label + '.json', {'argv': as_json(argv)!, 'exit_code': as_json(child.code)!, 'output_sha256': as_json(stage.hash(root + '/commands/' + label + '.log')!)!})!
	if child.code != 0 { return error('metadata command failed: ' + label) }
	return output
}
fn collect(root string, prefix string, mut files map[string]string) ! {
	for name in os.ls(root + '/' + prefix)!.sorted() {
		path := if prefix == '' { name } else { prefix + '/' + name }
		match os.lstat(root + '/' + path)!.get_filetype() {
			.directory { collect(root, path, mut files)! }
			.regular { if path != 'sha256.json' { files[path] = stage.hash(root + '/' + path)! } }
			else { return error('admission output contains a special inode') }
		}
	}
}
fn prepare(destination string) ! {
	root := stage.external(destination)!
	stage.disjoint(root, [base_root, repo])!
	verify_tools()!
	before := stage.load_inventory(base_root, base_seal)!
	if before['boot.img'] or { '' } != boot_pin { return error('immutable source boot identity differs') }
	os.mkdir(root, mode: 0o700)!
	os.mkdir(root + '/commands', mode: 0o700)!
	mut source_inputs := map[string]string{}
	for name, source in retained {
		if source == '' || os.read_file(repo + '/' + name)! != source { return error('compiled project source differs: ' + name) }
		path := root + '/source/' + name
		os.mkdir_all(os.dir(path), mode: 0o700)!
		os.write_file(path, source)!
		source_inputs[repo + '/' + name] = stage.hash(path)!
	}
	regular(os.real_path(os.executable()))!
	producer_pin := stage.hash(os.real_path(os.executable()))!
	os.cp(os.executable(), root + '/producer')!
	os.chmod(root + '/producer', 0o700)!
	module_hash(root, 'module-before')!
	extract_apk(root)!
	badging := record_command(root, 'badging', [aapt, 'dump', 'badging', root + '/vending.apk'])!
	manifest := record_command(root, 'manifest', [aapt, 'dump', 'xmltree', '--file', 'AndroidManifest.xml', root + '/vending.apk'])!
	info := metadata(badging, manifest)!
	certificate := sdk29_certificate(record_command(root, 'sdk29', [java, '-jar', signer, 'verify', '--min-sdk-version', '29', '--max-sdk-version', '29', '--verbose', '--print-certs', root + '/vending.apk'])!)!
	module_hash(root, 'module-after')!
	verify_tools()!
	if stage.load_inventory(base_root, base_seal)! != before { return error('complete immutable source changed') }
	for path, pin in source_inputs { if stage.hash(path)! != pin { return error('project source changed during admission') } }
	if stage.hash(root + '/vending.apk')! != apk_pin || os.lstat(root + '/vending.apk')!.size != apk_size || stage.hash(os.real_path(os.executable()))! != producer_pin { return error('admission output or producer changed') }
	mut logs := map[string]string{}
	for label in ['badging', 'manifest', 'sdk29'] { logs['commands/' + label + '.log'] = stage.hash(root + '/commands/' + label + '.log')! }
	mut inputs := tool_pins()
	inputs[base_root + '/sha256.json'] = base_seal
	inputs[base_root + '/boot.img'] = boot_pin
	for path, pin in source_inputs { inputs[path] = pin }
	inputs[os.real_path(os.executable())] = producer_pin
	revision := record_command(root, 'source-revision', ['/usr/bin/git', '-C', repo, 'rev-parse', 'HEAD'])!.trim_space()
	write_json(root + '/build.json', {
		'kind': json2.Any('vinix-maps-vending-admission-v1'), 'format': json2.Any(1),
		'scope': json2.Any('Pinned base APK and SDK29 signing identity admission only; no installation, Google authentication or target-SDK compatibility claim.'),
		'source_base_root': json2.Any(base_root), 'source_base_manifest_sha256': json2.Any(base_seal), 'source_image_sha256': json2.Any(boot_pin),
		'source_module': json2.Any(module_name), 'source_module_sha256': json2.Any(module_pin), 'source_member': json2.Any(member_name),
		'apk_sha256': json2.Any(apk_pin), 'apk_size': as_json(apk_size)!,
		'package_name': json2.Any(info.package_name), 'version_code': json2.Any(info.version_code), 'version_name': json2.Any(info.version_name),
		'min_sdk': json2.Any(info.min_sdk), 'target_sdk': json2.Any(info.target_sdk), 'split_name': json2.Any(info.split_name), 'split_required': json2.Any(info.split_required), 'native_abis': as_json(info.native_abis)!,
		'signer_sdk29_sha256': json2.Any(certificate), 'signer_min_sdk_version': json2.Any(29), 'signer_max_sdk_version': json2.Any(29),
		'outputs_sha256': as_json({'vending.apk': apk_pin})!, 'metadata_logs_sha256': as_json(logs)!,
		'tool_sha256': as_json(tool_pins())!, 'input_sha256': as_json(inputs)!, 'source_inputs_sha256': as_json(source_inputs)!,
		'source_revision': json2.Any(revision), 'producer_source_sha256': json2.Any(source_inputs[repo + '/tests/native-android-ws/maps-vending-admission.v']!), 'producer_sha256': json2.Any(producer_pin),
	})!
	mut files := map[string]string{}
	collect(root, '', mut files)!
	write_json(root + '/sha256.json', files)!
	stage.load_bundle(root, stage.hash(root + '/sha256.json')!)!
	println('MAPS-VENDING-ADMISSION PASS root=' + root + ' manifest=' + stage.hash(root + '/sha256.json')! + ' SDK29=' + certificate)
}

fn self_test() ! {
	good := "package: name='com.android.vending' versionCode='85292100' versionName='" + version_name + "'\nminSdkVersion:'24'\ntargetSdkVersion:'37'\nnative-code: 'arm64-v8a' 'armeabi-v7a'\n"
	manifest := 'E: manifest (line=1)\n  A: package="com.android.vending" (Raw: "com.android.vending")\n'
	if metadata(good, manifest)!.native_abis != ['arm64-v8a', 'armeabi-v7a'] { return error('valid metadata rejected') }
	for bad in [good.replace('com.android.vending', 'other.package'), good.replace('85292100', '1'), good.replace("minSdkVersion:'24'", "minSdkVersion:'23'"), good.replace("targetSdkVersion:'37'", "targetSdkVersion:'29'"), good.replace("versionCode='85292100'", "versionCode='85292100' versionCode='85292100'"), good.replace("native-code: 'arm64-v8a' 'armeabi-v7a'", "native-code: 'arm64-v8a' 'arm64-v8a'"), good + "uses-split:'config.en'\n", good + "minSdkVersion:'24'\n", good + "sdkVersion:'23'\n", good.replace("versionCode=", "split='config.en' versionCode=")] {
		if _ := metadata(bad, manifest) { return error('malformed or mismatched APK metadata accepted') }
	}
	for bad in [manifest.replace('com.android.vending', 'other.package'), manifest + 'E: uses-split (line=2)\n', manifest + 'A: android:isSplitRequired(0x1)=(type 0x12)0xffffffff\n', manifest + 'A: http://schemas.android.com/apk/res/android:isSplitRequired(0x1)=true\n', manifest + 'A: http://schemas.android.com/apk/res/android:requiredSplitTypes(0x1)="base__abi"\n', manifest + 'A: android:requiredSplitTypes(0x1)="base__abi"\n', manifest + 'A: split="config.en"\n', manifest + manifest] {
		if _ := metadata(good, bad) { return error('split or malformed manifest accepted') }
	}
	signed := 'Verifies\nNumber of signers: 1\nSigner #1 certificate SHA-256 digest: ' + certificate_pin + '\n'
	if sdk29_certificate(signed)! != certificate_pin { return error('SDK29 signer rejected') }
	for bad in [signed.replace(certificate_pin, '0'.repeat(64)), signed.replace('Verifies', 'DOES NOT VERIFY'), signed + 'Signer #2 certificate SHA-256 digest: ' + certificate_pin + '\n', signed + 'Signer #1 certificate SHA-256 digest: ' + certificate_pin + '\n', signed.replace('Number of signers: 1', 'Number of signers: 2')] {
		if _ := sdk29_certificate(bad) { return error('wrong or ambiguous SDK29 signer accepted') }
	}
	if !selected_member(member_name, true, i64(apk_size), '')! || !selected_member('./' + member_name, true, i64(apk_size), '')! { return error('exact source member rejected') }
	for kind in [false, true] { if _ := selected_member(member_name, kind, 0, 'elsewhere') { return error('wrong source member kind/size/link accepted') } }
	if _ := selected_member('../' + member_name, true, i64(apk_size), '') { return error('ambiguous source path accepted') }
	println('MAPS-VENDING-ADMISSION SELFTEST PASS exact package/version/SDK no splits native ABI signer cardinality and source member guards')
}
fn main() {
	if os.args.len == 2 && os.args[1] == '--self-test' { self_test() or { eprintln(err); exit(1) }; return }
	if os.args.len != 3 || os.args[1] != '--prepare' { eprintln('usage: maps-vending-admission --prepare FRESH_EXTERNAL_OUTPUT | --self-test'); exit(2) }
	prepare(os.args[2]) or { eprintln(err); exit(1) }
}
