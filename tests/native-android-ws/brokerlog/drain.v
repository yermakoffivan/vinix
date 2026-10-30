// SPDX-License-Identifier: GPL-2.0-or-later
module brokerlog

import os
import time

#include <errno.h>
#include <fcntl.h>
#include <poll.h>
#include <unistd.h>

fn C.poll(voidptr, uint, i32) i32

pub const again = 0
pub const eof = 1
pub const deadline = 2
pub const byte_limit = 3
pub const read_failure = 4
pub const poll_failure = 5
pub const write_failure = 6
pub const invalid_setup = 7
pub const data = 8

const maximum_log = 16 * 1024 * 1024

pub struct ReadResult {
pub:
	status int
	bytes int
	error_number int
}

pub struct DrainResult {
pub:
	status int
	bytes int
	error_number int
	eof bool
}

struct BrokerPoll {
mut:
	fd i32
	events i16
	revents i16
}

pub fn nonblocking(fd int) ! {
	if fd < 0 { return error('broker output descriptor absent') }
	flags := C.fcntl(fd, C.F_GETFL, 0)
	if flags < 0 || C.fcntl(fd, C.F_SETFL, flags | C.O_NONBLOCK) < 0 {
		return error('cannot make broker output nonblocking')
	}
}

// One read is bounded independently of process liveness. At the byte ceiling
// a one-byte probe distinguishes exact-length EOF from an over-limit stream.
// Only bytes successfully written to the private file enter the private buffer.
pub fn read_once(fd int, mut log os.File, mut output []u8, limit int) ReadResult {
	if fd < 0 || limit < 1 || limit > maximum_log || output.cap < limit || output.len > limit {
		return ReadResult{status: invalid_setup}
	}
	flags := C.fcntl(fd, C.F_GETFL, 0)
	if flags < 0 { return ReadResult{status: read_failure, error_number: int(C.errno)} }
	if flags & C.O_NONBLOCK == 0 { return ReadResult{status: invalid_setup} }
	remaining := limit - output.len
	wanted := if remaining == 0 { 1 } else if remaining < 4096 { remaining } else { 4096 }
	mut block := [4096]u8{}
	n := C.read(i32(fd), unsafe { &block[0] }, uint(wanted))
	saved := int(C.errno)
	if n == 0 { return ReadResult{status: eof} }
	if n < 0 {
		if saved == C.EINTR || saved == C.EAGAIN || saved == C.EWOULDBLOCK {
			return ReadResult{status: again}
		}
		return ReadResult{status: read_failure, error_number: saved}
	}
	if remaining == 0 { return ReadResult{status: byte_limit} }
	mut written := 0
	mut interruptions := 0
	for written < n {
		count := C.write(i32(log.fd), unsafe { &block[0] + written }, uint(n - written))
		write_errno := int(C.errno)
		if count < 0 && write_errno == C.EINTR && interruptions < 16 {
			interruptions++
			continue
		}
		if count <= 0 {
			return ReadResult{status: write_failure, bytes: written, error_number: write_errno}
		}
		// Keep the two private captures equal even if a later file write fails.
		unsafe { output.push_many(&block[written], int(count)) }
		written += int(count)
	}
	return ReadResult{status: data, bytes: written}
}

// Called after owned process termination and before Process.close(). A retained
// writer can delay EOF, so neither an empty read nor POLLHUP proves completion.
// The only successful terminal result follows an actual read(2) return of zero.
pub fn finish(fd int, mut log os.File, mut output []u8, limit int, timeout_ms int) DrainResult {
	if fd < 0 || limit < 1 || limit > maximum_log || output.cap < limit ||
		output.len > limit || timeout_ms < 1 || timeout_ms > 5000 {
		return DrainResult{status: invalid_setup}
	}
	// Cleanup can run before the normal live-capture setup completed.
	flags := C.fcntl(fd, C.F_GETFL, 0)
	if flags < 0 || C.fcntl(fd, C.F_SETFL, flags | C.O_NONBLOCK) < 0 {
		return DrainResult{status: invalid_setup, error_number: int(C.errno)}
	}
	started := output.len
	end := time.sys_mono_now() + i64(timeout_ms) * time.millisecond
	for {
		if time.sys_mono_now() >= end {
			return DrainResult{status: deadline, bytes: output.len - started}
		}
		read := read_once(fd, mut log, mut output, limit)
		if read.status == eof {
			return DrainResult{status: eof, bytes: output.len - started, eof: true}
		}
		if read.status != data && read.status != again {
			return DrainResult{status: read.status, bytes: output.len - started, error_number: read.error_number}
		}
		if read.status == data { continue }
		remaining := end - time.sys_mono_now()
		if remaining <= 0 { continue }
		wait_ms := (remaining + time.millisecond - 1) / time.millisecond
		mut descriptor := BrokerPoll{fd: i32(fd), events: i16(C.POLLIN)}
		ready := C.poll(unsafe { &descriptor }, 1, i32(if wait_ms > 100 { 100 } else { wait_ms }))
		poll_errno := int(C.errno)
		if ready < 0 && poll_errno != C.EINTR {
			return DrainResult{status: poll_failure, bytes: output.len - started, error_number: poll_errno}
		}
		if ready > 0 && descriptor.revents & C.POLLNVAL != 0 {
			return DrainResult{status: poll_failure, bytes: output.len - started, error_number: int(C.EBADF)}
		}
	}
}
