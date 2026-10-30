// SPDX-License-Identifier: GPL-2.0-or-later
module mapsaccountstage

// Every job owns its selector strings; workers only read their own inputs and
// construct their own inventory, file descriptors and digest contexts.
struct InventoryAuditJob {
	root string
	seal string
}

struct InventoryAuditResult {
	failure string
}

type InventoryAuditWorker = fn (InventoryAuditJob) InventoryAuditResult

fn full_inventory_audit(job InventoryAuditJob) InventoryAuditResult {
	load_inventory(job.root, job.seal) or {
		return InventoryAuditResult{failure: err.msg()}
	}
	return InventoryAuditResult{}
}

fn run_inventory_audit(job InventoryAuditJob, worker InventoryAuditWorker) InventoryAuditResult {
	return worker(job)
}

// Fixed pairs bound concurrency independently of the number of dependencies.
// Join both members before returning either failure, selecting the first job
// in the declared order even if its partner finishes or fails sooner.
fn audit_inventory_jobs(jobs []InventoryAuditJob, worker InventoryAuditWorker) ! {
	if jobs.len == 0 || jobs.len > 64 { return error('bounded nonempty inventory audit plan required') }
	for offset := 0; offset < jobs.len; offset += 2 {
		first := spawn run_inventory_audit(jobs[offset], worker)
		if offset + 1 < jobs.len {
			second := spawn run_inventory_audit(jobs[offset + 1], worker)
			first_result := first.wait()
			second_result := second.wait()
			if first_result.failure != '' {
				return error('inventory dependency ' + jobs[offset].root + ': ' + first_result.failure)
			}
			if second_result.failure != '' {
				return error('inventory dependency ' + jobs[offset + 1].root + ': ' + second_result.failure)
			}
		} else {
			result := first.wait()
			if result.failure != '' {
				return error('inventory dependency ' + jobs[offset].root + ': ' + result.failure)
			}
		}
	}
}

// No proof survives a call: both the initial and final phase repeat every byte
// and complete inventory check through the unchanged load_inventory function.
pub fn audit_inventories_parallel(pins map[string]string) ! {
	if pins.len == 0 || pins.len > 64 { return error('bounded nonempty inventory audit plan required') }
	mut roots := pins.keys()
	roots.sort()
	mut jobs := []InventoryAuditJob{cap: roots.len}
	for root in roots {
		jobs << InventoryAuditJob{root: root.clone(), seal: pins[root]!.clone()}
	}
	audit_inventory_jobs(jobs, full_inventory_audit)!
}
