// SPDX-License-Identifier: GPL-2.0-or-later
module mapsaccountstage

import crypto.sha256
import json2
import os
import sync.stdatomic
import time

struct InventoryProbe {
mut:
	active u64
	completed u64
}

struct InventoryProbeOutcome {
	failure string
	completed u64
}

fn parallel_fixture_root(name string) !string {
	parent := os.getenv('VINIX_INVENTORY_PARALLEL_TEST_ROOT')
	assert parent != '' && os.is_abs_path(parent) && os.is_dir(parent)
	root := parent + '/' + name
	assert !os.exists(root) && !os.is_link(root)
	os.mkdir(root, mode: 0o700)!
	return root
}

fn sealed_parallel_fixture(root string, payload []u8) !string {
	os.mkdir(root + '/nested', mode: 0o700)!
	os.write_file_array(root + '/nested/payload', payload)!
	os.write_file(root + '/empty', '')!
	pins := {'nested/payload': sha256.sum(payload).hex(), 'empty': sha256.sum([]u8{}).hex()}
	os.write_file(root + '/sha256.json', json2.encode(pins))!
	return digest(root + '/sha256.json')!
}

fn inventory_probe_outcome(jobs []InventoryAuditJob, worker InventoryAuditWorker, probe &InventoryProbe) InventoryProbeOutcome {
	mut failure := ''
	audit_inventory_jobs(jobs, worker) or { failure = err.msg() }
	return InventoryProbeOutcome{failure: failure, completed: stdatomic.load_u64(unsafe { &probe.completed })}
}

fn test_inventory_workers_overlap_bound_and_odd_tail() {
	probe := &InventoryProbe{}
	started := chan string{cap: 8}
	release := chan bool{cap: 8}
	finished := chan string{cap: 8}
	worker := fn [probe, started, release, finished] (job InventoryAuditJob) InventoryAuditResult {
		active := stdatomic.add_u64(unsafe { &probe.active }, 1)
		started <- job.root
		_ := <-release
		stdatomic.sub_u64(unsafe { &probe.active }, 1)
		stdatomic.add_u64(unsafe { &probe.completed }, 1)
		finished <- job.root
		return InventoryAuditResult{failure: if active > 2 { 'worker bound exceeded' } else { '' }}
	}
	jobs := [InventoryAuditJob{root: 'a'}, InventoryAuditJob{root: 'b'},
		InventoryAuditJob{root: 'c'}, InventoryAuditJob{root: 'd'}, InventoryAuditJob{root: 'e'}]
	handle := spawn inventory_probe_outcome(jobs, worker, probe)
	for expected in [['a', 'b'], ['c', 'd'], ['e']] {
		mut actual := []string{}
		for _ in expected { actual << <-started }
		actual.sort()
		assert actual == expected
		assert stdatomic.load_u64(unsafe { &probe.active }) == u64(expected.len)
		for _ in expected { release <- true }
		mut completions := []string{}
		for _ in expected { completions << <-finished }
		completions.sort()
		assert completions == expected
	}
	outcome := handle.wait()
	assert outcome.failure == ''
	assert outcome.completed == 5
	assert stdatomic.load_u64(unsafe { &probe.active }) == 0
}

fn test_inventory_workers_join_before_error_and_choose_first() {
	for failing in ['first', 'second', 'both'] {
		probe := &InventoryProbe{}
		started := chan string{cap: 2}
		finished := chan string{cap: 2}
		first_release := chan bool{cap: 1}
		second_release := chan bool{cap: 1}
		worker := fn [probe, started, finished, first_release, second_release, failing] (job InventoryAuditJob) InventoryAuditResult {
			started <- job.root
			if job.root == 'a' { _ := <-first_release } else { _ := <-second_release }
			stdatomic.add_u64(unsafe { &probe.completed }, 1)
			finished <- job.root
			return InventoryAuditResult{failure: if failing == 'both' ||
				(failing == 'first' && job.root == 'a') || (failing == 'second' && job.root == 'b') {
				'failure-' + job.root
			} else { '' }}
		}
		jobs := [InventoryAuditJob{root: 'a'}, InventoryAuditJob{root: 'b'}]
		handle := spawn inventory_probe_outcome(jobs, worker, probe)
		_ := <-started
		_ := <-started
		// Exercise both completion orders. A result snapshot records how many
		// callbacks finished when the coordinator returned.
		if failing == 'both' {
			second_release <- true
			assert <-finished == 'b'
			time.sleep(25 * time.millisecond)
			first_release <- true
			assert <-finished == 'a'
		} else {
			first_release <- true
			assert <-finished == 'a'
			time.sleep(25 * time.millisecond)
			second_release <- true
			assert <-finished == 'b'
		}
		outcome := handle.wait()
		assert outcome.completed == 2
		assert outcome.failure == 'inventory dependency ' + if failing == 'second' { 'b: failure-b' } else { 'a: failure-a' }
	}
}

fn test_parallel_inventory_real_inputs_recheck_and_failure_order() ! {
	root := parallel_fixture_root('real-inventories')!
	mut pins := map[string]string{}
	for name in ['c', 'b', 'a'] {
		os.mkdir(root + '/' + name, mode: 0o700)!
		pins[root + '/' + name] = sealed_parallel_fixture(root + '/' + name, ('binary-' + name + '\x00\xff').bytes())!
	}
	audit_inventories_parallel(pins)!
	audit_inventories_parallel(pins)!
	// A later phase must read the payload again rather than reusing a pass.
	os.write_file(root + '/a/nested/payload', 'changed-a')!
	os.write_file(root + '/b/nested/payload', 'changed-b')!
	mut failure := ''
	audit_inventories_parallel(pins) or { failure = err.msg() }
	assert failure.starts_with('inventory dependency ' + root + '/a: ')
	assert failure.contains('nested/payload')
}

fn test_parallel_inventory_rejects_changed_members_and_selectors() ! {
	for kind in ['unlisted', 'missing', 'symlink', 'wrong-pin', 'unsafe-manifest', 'trailing-bytes'] {
		root := parallel_fixture_root(kind)!
		pin := sealed_parallel_fixture(root, 'original'.bytes())!
		mut selected := pin
		match kind {
			'unlisted' { os.write_file(root + '/extra', 'unlisted')! }
			'missing' { os.rm(root + '/nested/payload')! }
			'symlink' { os.symlink('empty', root + '/linked')! }
			'wrong-pin' { selected = '0'.repeat(64) }
			'unsafe-manifest' {
				os.write_file(root + '/sha256.json', json2.encode({'../escape': '0'.repeat(64)}))!
				selected = digest(root + '/sha256.json')!
			}
			else {
				mut output := os.open_append(root + '/nested/payload')!
				output.write_string('trailing')!
				output.close()
			}
		}
		mut refused := false
		audit_inventories_parallel({root: selected}) or { refused = true }
		assert refused, kind
	}
	mut empty_refused := false
	audit_inventories_parallel(map[string]string{}) or { empty_refused = true }
	assert empty_refused
	mut oversized := map[string]string{}
	for i in 0 .. 65 { oversized['unused-' + i.str()] = '0'.repeat(64) }
	mut oversized_refused := false
	audit_inventories_parallel(oversized) or { oversized_refused = true }
	assert oversized_refused
}

fn test_parallel_inventory_large_uncached_digest_isolation() ! {
	root := parallel_fixture_root('large-uncached')!
	mut pins := map[string]string{}
	for name in ['a', 'b'] {
		selected := root + '/' + name
		os.mkdir(selected, mode: 0o700)!
		os.write_file(selected + '/large', '')!
		os.truncate(selected + '/large', 64 * 1024 * 1024 + 19)!
		mut output := os.open_file(selected + '/large', 'r+')!
		output.seek(-4, .end)!
		output.write_string(name + '\x00\xff!')!
		output.close()
		os.write_file(selected + '/sha256.json', json2.encode({'large': digest(selected + '/large')!}))!
		pins[selected] = digest(selected + '/sha256.json')!
	}
	audit_inventories_parallel(pins)!
	mut changed := os.open_file(root + '/b/large', 'r+')!
	changed.seek(-1, .end)!
	changed.write_string('?')!
	changed.close()
	mut refused := false
	audit_inventories_parallel(pins) or {
		assert err.msg().starts_with('inventory dependency ' + root + '/b: ')
		refused = true
	}
	assert refused
}
