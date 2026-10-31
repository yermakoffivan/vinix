// SPDX-License-Identifier: GPL-2.0-or-later
// Preserve a separately guest-pinned failed log from standard base64 UART text.
// This is a diagnostic derivation, never a fixture pass or protocol import.
module main

import crypto.sha256
import encoding.base64
import json2
import os
import strconv

#include <fcntl.h>
#include <sys/stat.h>
#include <unistd.h>

fn C.open(&char, int, ...int) int
fn C.close(int) int
fn C.fstat(int, &C.stat) int
fn C.pread(int, voidptr, u64, i64) i64
fn C.write(int, voidptr, u64) i64
fn C.mkfifo(&char, u32) int

const uart_limit = 8 * 1024 * 1024
const child_limit = 4 * 1024 * 1024
const line_limit = 8192
const source_text = $embed_file(@FILE).to_string()
const kind = 'vinix-diagnostic-uart-base64-child-v1'
const scope = 'Exact guest-pinned bytes decoded from one maximal standard base64 line run. Representation LF/CRLF only; no payload repair, protocol receipt, fixture PASS or authentication claim.'

struct Selection {
	start int
	end int
	lines int
	child []u8
}

struct Inputs {
	serial_path string
	serial_sha256 string
	guest_bytes int
	guest_sha256 string
	decoder_origin string
	decoder_sha256 string
	source_sha256 string
}

struct Receipt {
	kind string
	scope string
	inputs_sha256 string
	serial_bytes int
	serial_sha256 string
	encoded_start_inclusive int
	encoded_end_exclusive int
	encoded_lines int
	encoded_bytes int
	encoded_sha256 string
	child_bytes int
	child_sha256 string
	decoder_sha256 string
	source_sha256 string
}

fn digest(bytes []u8) string { return sha256.sum(bytes).hex() }
fn pin(value string) bool {
	return value.len == 64 && value.bytes().all((it >= `0` && it <= `9`) || (it >= `a` && it <= `f`))
}
fn guest_count(value string) !int {
	if value == '' || value[0] == `0` || value.len > 7 || !value.bytes().all(it >= `0` && it <= `9`) {
		return error('canonical positive guest bytecount required')
	}
	count := strconv.parse_uint(value, 10, 32)!
	if count > child_limit { return error('guest log exceeds 4 MiB') }
	return int(count)
}

fn canonical(path string) ! {
	if !os.is_abs_path(path) || path.contains_any('\x00\r\n\\') || os.real_path(path) != path {
		return error('canonical absolute path required')
	}
}
fn described_path(path string) bool {
	return os.is_abs_path(path) && os.norm_path(path) == path && !path.contains_any('\x00\r\n\\')
}
fn fresh_output(path string) ! {
	parent := os.dir(path)
	canonical(parent)!
	if !os.is_abs_path(path) || parent + '/' + os.file_name(path) != path || path.ends_with('/')
		|| path.contains_any('\x00\r\n\\') || os.file_name(path) in ['', '.', '..']
		|| os.exists(path) || os.is_link(path) { return error('fresh external output required') }
	mut ancestor := parent
	for {
		if os.exists(ancestor + '/.git') { return error('output inside checkout rejected') }
		if ancestor == '/' { break }
		ancestor = os.dir(ancestor)
	}
}
fn metadata(fd int) !os.Stat {
	mut value := C.stat{}
	if C.fstat(fd, &value) != 0 || value.st_size <= 0 { return error('regular nonempty file required') }
	return os.Stat{dev: u64(value.st_dev), inode: value.st_ino, mode: value.st_mode,
		nlink: value.st_nlink, size: u64(value.st_size), mtime: value.st_mtime, ctime: value.st_ctime}
}
fn same(a os.Stat, b os.Stat) bool {
	return a.dev == b.dev && a.inode == b.inode && a.mode == b.mode && a.nlink == b.nlink
		&& a.size == b.size && a.mtime == b.mtime && a.ctime == b.ctime
}
fn read_exact(fd int, count int) ![]u8 {
	mut bytes := []u8{len: count}
	mut at := 0
	for at < count {
		n := C.pread(fd, unsafe { &bytes[at] }, u64(count - at), i64(at))
		if n <= 0 { return error('input truncated or unreadable') }
		at += int(n)
	}
	mut extra := u8(0)
	if C.pread(fd, &extra, 1, i64(count)) != 0 { return error('input size changed') }
	return bytes
}
fn read_stable(path string, limit int, readonly bool) ![]u8 {
	canonical(path)!
	named := os.lstat(path)!
	fd := C.open(path.str, C.O_RDONLY | C.O_NONBLOCK | C.O_NOFOLLOW | C.O_CLOEXEC)
	if fd < 0 { return error('input open failed') }
	defer { C.close(fd) }
	before := metadata(fd)!
	if before.get_filetype() != .regular || before.nlink != 1 || before.size > u64(limit)
		|| (readonly && before.mode & 0o777 != 0o400) || !same(named, before) {
		return error('single-link regular input mode or bounds rejected')
	}
	bytes := read_exact(fd, int(before.size))!
	if read_exact(fd, bytes.len)! != bytes || !same(before, metadata(fd)!) || !same(before, os.lstat(path)!) {
		return error('input bytes or identity changed')
	}
	return bytes
}

// Padding is validated only after every adjacent alphabet/'=' line has joined
// its maximal run. A malformed padding line must never disappear as chatter.
fn alphabet_line(bytes []u8) bool {
	return bytes.len > 0 && bytes.all((it >= `A` && it <= `Z`) || (it >= `a` && it <= `z`)
		|| (it >= `0` && it <= `9`) || it in [`+`, `/`, `=`])
}
fn candidate(raw []u8, start int, end int, chars int, lines int, count int, expected string) ?Selection {
	if chars != 4 * ((count + 2) / 3) { return none }
	mut joined := []u8{cap: chars}
	for value in raw[start..end] { if value !in [`\r`, `\n`] { joined << value } }
	if joined.len != chars || chars % 4 != 0 { return none }
	mut padding := 0
	for i, value in joined {
		if value == `=` {
			padding++
			if i < chars - 2 || padding > 2 { return none }
		} else if padding != 0 { return none }
	}
	encoded := joined.bytestr()
	child := base64.decode(encoded)
	if child.len != count || base64.encode(child) != encoded || digest(child) != expected { return none }
	return Selection{start, end, lines, child}
}
fn select_run(raw []u8, count int, expected string) !Selection {
	if raw.len == 0 || raw.len > uart_limit || raw.last() != `\n`
		|| count <= 0 || count > child_limit || !pin(expected) { return error('bounded complete UART and explicit guest pins required') }
	mut at := 0
	mut start := -1
	mut chars := 0
	mut lines := 0
	mut matches := 0
	mut result := Selection{}
	for at < raw.len {
		mut end := at
		for raw[end] != `\n` { end++ }
		mut body_end := end
		if body_end > at && raw[body_end - 1] == `\r` { body_end-- }
		if body_end - at > line_limit { return error('UART line exceeds 8192 bytes') }
		if alphabet_line(raw[at..body_end]) {
			if start < 0 { start = at }
			chars += body_end - at
			lines++
		} else if start >= 0 {
			if selected := candidate(raw, start, at, chars, lines, count, expected) {
				matches++
				if matches > 1 { return error('multiple matching maximal base64 runs') }
				result = selected
			}
			start = -1
			chars = 0
			lines = 0
		}
		at = end + 1
	}
	if start >= 0 {
		if selected := candidate(raw, start, at, chars, lines, count, expected) {
			matches++
			if matches > 1 { return error('multiple matching maximal base64 runs') }
			result = selected
		}
	}
	if matches != 1 { return error('exactly one maximal guest-pinned base64 run required') }
	return result
}

fn encoded_json[T](value T) []u8 { return (json2.encode(value, prettify: true) + '\n').bytes() }
fn write_new(path string, bytes []u8, mode int) ! {
	fd := C.open(path.str, C.O_WRONLY | C.O_CREAT | C.O_EXCL | C.O_NOFOLLOW | C.O_CLOEXEC, mode)
	if fd < 0 { return error('exclusive output creation failed') }
	defer { C.close(fd) }
	mut at := 0
	for at < bytes.len {
		n := C.write(fd, unsafe { &bytes[at] }, u64(bytes.len - at))
		if n <= 0 { return error('output write failed') }
		at += int(n)
	}
}
fn check_bundle(root string) ! {
	canonical(root)!
	info := os.lstat(root)!
	if info.get_filetype() != .directory || info.mode & 0o777 != 0o500 { return error('private read-only bundle directory required') }
	if os.ls(root)!.sorted() != ['child.log', 'decoder', 'decoder-source.v', 'encoded.log', 'inputs.json', 'receipt.json', 'serial-original.log'] {
		return error('exact seven-member diagnostic bundle required')
	}
	inputs_bytes := read_stable(root + '/inputs.json', 16384, true)!
	inputs := json2.decode[Inputs](inputs_bytes.bytestr())!
	raw := read_stable(root + '/serial-original.log', uart_limit, true)!
	if encoded_json(inputs) != inputs_bytes || !pin(inputs.serial_sha256) || !pin(inputs.guest_sha256)
		|| !pin(inputs.decoder_sha256) || inputs.source_sha256 != digest(source_text.bytes())
		|| digest(raw) != inputs.serial_sha256 || !described_path(inputs.serial_path) || !described_path(inputs.decoder_origin) {
		return error('exact diagnostic inputs differ')
	}
	selected := select_run(raw, inputs.guest_bytes, inputs.guest_sha256)!
	span := read_stable(root + '/encoded.log', uart_limit, true)!
	child := read_stable(root + '/child.log', child_limit, true)!
	program := read_stable(root + '/decoder', 32 * 1024 * 1024, false)!
	frozen := read_stable(root + '/decoder-source.v', 1024 * 1024, true)!
	if span != raw[selected.start..selected.end] || child != selected.child || digest(program) != inputs.decoder_sha256
		|| frozen != source_text.bytes() || os.lstat(root + '/decoder')!.mode & 0o777 != 0o500 {
		return error('retained diagnostic payload/tool differs')
	}
	encoded := read_stable(root + '/receipt.json', 16384, true)!
	receipt := json2.decode[Receipt](encoded.bytestr())!
	expected := Receipt{kind, scope, digest(inputs_bytes), raw.len, digest(raw), selected.start,
		selected.end, selected.lines, span.len, digest(span), child.len, digest(child), digest(program), digest(frozen)}
	if receipt != expected || encoded != encoded_json(expected) { return error('exact diagnostic receipt differs') }
}
fn derive(serial string, serial_pin string, count int, child_pin string, root string) ! {
	fresh_output(root)!
	if !pin(serial_pin) || !pin(child_pin) { return error('explicit SHA256 pins required') }
	raw := read_stable(serial, uart_limit, true)!
	if digest(raw) != serial_pin { return error('UART SHA256 differs') }
	selected := select_run(raw, count, child_pin)!
	executable := os.real_path(os.executable())
	program := read_stable(executable, 32 * 1024 * 1024, false)!
	inputs := Inputs{serial, serial_pin, count, child_pin, executable, digest(program), digest(source_text.bytes())}
	inputs_bytes := encoded_json(inputs)
	span := raw[selected.start..selected.end]
	receipt := Receipt{kind, scope, digest(inputs_bytes), raw.len, serial_pin, selected.start, selected.end,
		selected.lines, span.len, digest(span), selected.child.len, child_pin, digest(program), digest(source_text.bytes())}
	if read_stable(serial, uart_limit, true)! != raw { return error('UART changed before output') }
	os.mkdir(root, mode: 0o700)!
	for name, bytes in {'serial-original.log': raw, 'encoded.log': span, 'child.log': selected.child,
		'decoder-source.v': source_text.bytes(), 'inputs.json': inputs_bytes} { write_new(root + '/' + name, bytes, 0o400)! }
	write_new(root + '/decoder', program, 0o500)!
	if read_stable(serial, uart_limit, true)! != raw { return error('UART changed during output') }
	write_new(root + '/receipt.json', encoded_json(receipt), 0o400)!
	os.chmod(root, 0o500)!
	check_bundle(root)!
	println('DIAGNOSTIC-BASE64-CHILD PASS bytes=' + count.str() + ' sha256=' + child_pin + ' start=' + selected.start.str() + ' end=' + selected.end.str())
}

fn wrapped(bytes []u8, ending string) string {
	encoded := base64.encode(bytes)
	mut result := ''
	for at := 0; at < encoded.len; at += 76 { result += encoded[at..if at + 76 < encoded.len { at + 76 } else { encoded.len }] + ending }
	return result
}
fn self_test() ! {
	root := os.real_path(os.temp_dir()) + '/diagnostic-uart-base64-' + os.getpid().str()
	if os.exists(root) || os.is_link(root) { return error('fresh selftest root required') }
	os.mkdir(root, mode: 0o700)!
	defer { os.chmod(root + '/result', 0o700) or {}; os.rmdir_all(root) or {} }
	mut child := []u8{len: 257}
	for i in 0 .. child.len { child[i] = u8(i % 256) }
	for ending in ['\n', '\r\n'] {
		raw := ('kernel chatter!\n' + wrapped(child, ending) + 'done!\n').bytes()
		selected := select_run(raw, child.len, digest(child))!
		assert selected.child == child && selected.start == 16 && raw[selected.end..].bytestr() == 'done!\n'
	}
	valid := wrapped(child, '\r\n')
	for raw in [valid[..valid.len - 1], valid.replace('\r\n', '\r\nnoise!\n'),
		valid.replace('AAEC', 'AAED'), valid + 'noise!\n' + valid, valid + '=AAA\n',
		valid + 'AAAA\n', 'Zg==\n=AAA\n', 'Zh==\n', 'Zg=\n', 'Z===\n',
		'A'.repeat(line_limit + 1) + '\n', 'unrelated!\n', valid.replace('AAEC', 'AA C')] {
		count := if raw.starts_with('Z') { 1 } else { child.len }
		expected := if count == 1 { digest('f'.bytes()) } else { digest(child) }
		if _ := select_run(raw.bytes(), count, expected) { return error('corrupt/interleaved/ambiguous base64 accepted') }
	}
	for value in ['', '0', '01', '-1', '+1', '4194305', '99999999'] { if _ := guest_count(value) { return error('invalid bytecount accepted') } }
	for path in ['relative', '/tmp/../input', '/tmp/bad\nname', '/tmp/bad\\name'] { assert !described_path(path) }
	assert described_path('/original/source/may/be/moved.log')
	assert guest_count('257')! == 257
	if _ := select_run(valid.bytes(), child.len, '0'.repeat(64)) { return error('wrong child pin accepted') }
	serial := root + '/uart.log'
	write_new(serial, ('before!\n' + valid + 'after!\n').bytes(), 0o400)!
	raw := read_stable(serial, uart_limit, true)!
	derive(serial, digest(raw), child.len, digest(child), root + '/result')!
	check_bundle(root + '/result')!
	if _ := derive(serial, digest(raw), child.len, digest(child), root + '/result') { return error('existing output accepted') }
	if _ := derive(serial, '0'.repeat(64), child.len, digest(child), root + '/wrong') { return error('wrong source pin accepted') }
	assert !os.exists(root + '/wrong')
	os.symlink(serial, root + '/alias')!
	if _ := read_stable(root + '/alias', uart_limit, true) { return error('input symlink accepted') }
	os.link(serial, root + '/hardlink')!
	if _ := read_stable(serial, uart_limit, true) { return error('input hardlink accepted') }
	os.rm(root + '/hardlink')!
	assert C.mkfifo((root + '/fifo').str, 0o600) == 0
	if _ := read_stable(root + '/fifo', uart_limit, false) { return error('FIFO accepted') }
	for name in ['child.log', 'encoded.log', 'serial-original.log', 'inputs.json', 'receipt.json', 'decoder-source.v', 'decoder'] {
		path := root + '/result/' + name
		mode := if name == 'decoder' { 0o500 } else { 0o400 }
		original := read_stable(path, 32 * 1024 * 1024, name != 'decoder')!
		os.chmod(path, 0o600)!
		mut changed := original.clone()
		changed[0] ^= 1
		os.write_file_array(path, changed)!
		os.chmod(path, mode)!
		if _ := check_bundle(root + '/result') { return error('changed bundle member accepted: ' + name) }
		os.chmod(path, 0o600)!
		os.write_file_array(path, original)!
		os.chmod(path, mode)!
	}
	check_bundle(root + '/result')!
	println('DIAGNOSTIC-BASE64-SELFTEST PASS LF-CRLF binary-identity maximal-runs canonical-padding corruption interleaving truncation duplicate-refusal bytecount pins fresh-output symlink hardlink FIFO bundle-tamper')
}
fn run() ! {
	if os.args.len == 2 && os.args[1] == '--self-test' { self_test()!; return }
	if os.args.len == 3 && os.args[1] == '--check' { check_bundle(os.args[2])!; println('DIAGNOSTIC-BASE64-CHECK PASS'); return }
	if os.args.len != 6 { return error('usage: diagnostic-uart-base64 UART UART_SHA256 GUEST_BYTES GUEST_SHA256 FRESH_OUTPUT | --check BUNDLE | --self-test') }
	derive(os.args[1], os.args[2], guest_count(os.args[3])!, os.args[4], os.args[5])!
}
fn main() { run() or { eprintln(err); exit(1) } }
