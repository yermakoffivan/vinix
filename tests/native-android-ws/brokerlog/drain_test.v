// SPDX-License-Identifier: GPL-2.0-or-later
module brokerlog

import json2
import os
import time

#include <signal.h>
#include <sys/wait.h>

fn C.fork() i32
fn C.pipe(&i32) i32
fn C.waitpid(i32, &i32, i32) i32
fn C._exit(i32)
fn C.alarm(uint) uint

fn capture_root(name string) !string {
	parent := os.getenv('VINIX_BROKER_DRAIN_TEST_ROOT')
	assert parent != '' && os.is_abs_path(parent) && os.is_dir(parent)
	root := parent + '/' + name
	assert !os.exists(root) && !os.is_link(root)
	os.mkdir(root, mode: 0o700)!
	return root
}

fn capture_pipe() [2]i32 {
	mut fds := [2]i32{}
	assert C.pipe(unsafe { &fds[0] }) == 0
	return fds
}

fn raw_write_all(fd int, payload []u8) bool {
	mut written := 0
	for written < payload.len {
		n := C.write(i32(fd), unsafe { &u8(payload.data) + written }, uint(payload.len - written))
		if n < 0 && C.errno == C.EINTR { continue }
		if n <= 0 { return false }
		written += int(n)
	}
	return true
}

fn wait_child(pid i32) int {
	end := time.sys_mono_now() + 2 * time.second
	mut status := 0
	for time.sys_mono_now() < end {
		waited := C.waitpid(pid, &status, C.WNOHANG)
		if waited == pid { return int(status) }
		assert waited == 0 || (waited < 0 && C.errno == C.EINTR)
		time.sleep(time.millisecond)
	}
	C.kill(pid, C.SIGKILL)
	C.waitpid(pid, &status, 0)
	assert false, 'fixture child did not exit before its deadline'
	return -1
}

fn assert_private_capture(path string, output []u8, expected []u8) ! {
	assert output == expected
	stored := os.read_bytes(path)!
	defer { unsafe { stored.free() } }
	assert stored == expected
}

fn test_exited_child_tail_is_captured_before_descriptor_close() ! {
	root := capture_root('exited-child-tail')!
	path := root + '/broker.log'
	mut log := os.create(path)!
	defer { log.close() }
	fds := capture_pipe()
	mut payload := []u8{len: 12 * 1024, init: u8(index % 251)}
	tail := '\nPRIVATE-TAIL-SENTINEL\nANDROID-ACCOUNT-BROKER-CHILD-STATUS raw=1792\n'.bytes()
	for i, b in tail { payload[payload.len - tail.len + i] = b }
	defer { unsafe { payload.free(); tail.free() } }
	pid := C.fork()
	assert pid >= 0
	if pid == 0 {
		C.alarm(3)
		C.close(fds[0])
		if !raw_write_all(fds[1], payload) { C._exit(91) }
		C.close(fds[1])
		C._exit(7)
	}
	C.close(fds[1])
	defer { C.close(fds[0]) }
	mut output := []u8{cap: 32 * 1024}
	defer { unsafe { output.free() } }
	data_pointer := output.data
	nonblocking(fds[0])!
	// One live read models the old controller's final iteration. The child
	// still leaves two complete 4096-byte blocks after its direct exit.
	end := time.sys_mono_now() + time.second
	mut live := ReadResult{}
	for time.sys_mono_now() < end {
		live = read_once(fds[0], mut log, mut output, 32 * 1024)
		if live.status == data { break }
		assert live.status == again
		time.sleep(time.millisecond)
	}
	assert live.status == data && live.bytes == 4096
	assert wait_child(pid) == 7 << 8
	assert payload.len - output.len > 4096
	assert C.fcntl(fds[0], C.F_GETFD, 0) >= 0
	drained := finish(fds[0], mut log, mut output, 32 * 1024, 500)
	assert drained.status == eof && drained.eof
	assert drained.bytes == payload.len - 4096
	assert output.data == data_pointer && output.cap == 32 * 1024
	assert_private_capture(path, output, payload)!
	public_result := json2.encode(drained)
	assert !public_result.contains('PRIVATE-TAIL')
	assert !public_result.contains('CHILD-STATUS')
	assert public_result == '{"status":1,"bytes":8192,"error_number":0,"eof":true}'
}

fn test_descendant_retaining_writer_cannot_falsely_prove_eof() ! {
	root := capture_root('held-descendant-writer')!
	path := root + '/broker.log'
	mut log := os.create(path)!
	defer { log.close() }
	fds := capture_pipe()
	release := capture_pipe()
	pid := C.fork()
	assert pid >= 0
	if pid == 0 {
		C.alarm(3)
		C.close(fds[0])
		C.close(release[1])
		holder := C.fork()
		if holder < 0 { C._exit(92) }
		if holder == 0 {
			// The exited owner's real descendant retains the writer until the
			// parent explicitly releases it. Scheduling cannot close it early.
			C.alarm(3)
			mut released := u8(0)
			C.read(release[0], unsafe { &released }, 1)
			C.close(release[0])
			C.close(fds[1])
			C._exit(0)
		}
		C.close(release[0])
		if !raw_write_all(fds[1], 'private-prefix'.bytes()) { C._exit(93) }
		C.close(fds[1])
		C._exit(0)
	}
	C.close(fds[1])
	C.close(release[0])
	defer { C.close(fds[0]) }
	defer { C.close(release[1]) }
	assert wait_child(pid) == 0
	mut output := []u8{cap: 1024}
	defer { unsafe { output.free() } }
	started := time.sys_mono_now()
	drained := finish(fds[0], mut log, mut output, 1024, 30)
	elapsed := (time.sys_mono_now() - started) / time.millisecond
	assert drained.status == deadline && !drained.eof
	assert drained.bytes == 'private-prefix'.len
	assert elapsed >= 25 && elapsed < 500
	assert_private_capture(path, output, 'private-prefix'.bytes())!
	assert raw_write_all(release[1], [u8(1)])
	completed := finish(fds[0], mut log, mut output, 1024, 1000)
	assert completed.status == eof && completed.eof && completed.bytes == 0
	assert_private_capture(path, output, 'private-prefix'.bytes())!
}

fn test_exact_capture_ceiling_checks_eof_and_overflow_separately() ! {
	for extra in [false, true] {
		root := capture_root(if extra { 'byte-cap-exceeded' } else { 'byte-cap-exact' })!
		path := root + '/broker.log'
		mut log := os.create(path)!
		fds := capture_pipe()
		payload := [u8(0), 1, 255, 10, 13, 2, 0, 42]
		assert raw_write_all(fds[1], payload)
		if extra { assert raw_write_all(fds[1], [u8(99)]) }
		C.close(fds[1])
		mut output := []u8{cap: payload.len}
		drained := finish(fds[0], mut log, mut output, payload.len, 500)
		assert drained.status == if extra { byte_limit } else { eof }
		assert drained.eof == !extra
		assert drained.bytes == payload.len && output.len == payload.len
		assert_private_capture(path, output, payload)!
		C.close(fds[0])
		log.close()
		unsafe { output.free(); payload.free() }
	}
}

fn test_empty_live_pipe_read_is_again_then_bounded_deadline() ! {
	root := capture_root('empty-live-pipe')!
	mut log := os.create(root + '/broker.log')!
	defer { log.close() }
	fds := capture_pipe()
	defer { C.close(fds[0]); C.close(fds[1]) }
	mut output := []u8{cap: 32}
	defer { unsafe { output.free() } }
	// A live read requires explicit nonblocking setup; finish configures it
	// itself because an earlier controller failure may bypass normal setup.
	unconfigured := read_once(fds[0], mut log, mut output, 32)
	assert unconfigured.status == invalid_setup
	nonblocking(fds[0])!
	live := read_once(fds[0], mut log, mut output, 32)
	assert live.status == again && live.bytes == 0
	started := time.sys_mono_now()
	drained := finish(fds[0], mut log, mut output, 32, 20)
	elapsed := (time.sys_mono_now() - started) / time.millisecond
	assert drained.status == deadline && !drained.eof && drained.bytes == 0
	assert elapsed >= 15 && elapsed < 500
}

fn test_invalid_capture_inputs_are_numeric_and_never_complete() ! {
	root := capture_root('invalid-inputs')!
	mut log := os.create(root + '/broker.log')!
	defer { log.close() }
	fds := capture_pipe()
	defer { C.close(fds[0]); C.close(fds[1]) }
	mut output := []u8{cap: 32}
	defer { unsafe { output.free() } }
	for settings in [[-1, 32, 10], [int(fds[0]), 0, 10],
		[int(fds[0]), maximum_log + 1, 10], [int(fds[0]), 33, 10],
		[int(fds[0]), 32, 0], [int(fds[0]), 32, 5001]] {
		drained := finish(settings[0], mut log, mut output, settings[1], settings[2])
		assert drained.status == invalid_setup && !drained.eof && drained.bytes == 0
	}
	closed := capture_pipe()
	C.close(closed[0])
	C.close(closed[1])
	failed := finish(closed[0], mut log, mut output, 32, 10)
	assert failed.status == invalid_setup && !failed.eof && failed.error_number == C.EBADF
	live_failure := read_once(closed[0], mut log, mut output, 32)
	assert live_failure.status == read_failure && live_failure.error_number == C.EBADF
}

fn test_private_write_failure_preserves_equal_captured_prefixes() ! {
	root := capture_root('write-failure')!
	path := root + '/broker.log'
	os.write_file(path, '')!
	mut log := os.open(path)!
	defer { log.close() }
	fds := capture_pipe()
	defer { C.close(fds[0]) }
	assert raw_write_all(fds[1], 'private-content-must-not-be-exported'.bytes())
	C.close(fds[1])
	mut output := []u8{cap: 128}
	defer { unsafe { output.free() } }
	drained := finish(fds[0], mut log, mut output, 128, 500)
	assert drained.status == write_failure && !drained.eof
	assert drained.bytes == 0 && drained.error_number == C.EBADF
	assert_private_capture(path, output, []u8{})!
	assert !json2.encode(drained).contains('private-content')
}
