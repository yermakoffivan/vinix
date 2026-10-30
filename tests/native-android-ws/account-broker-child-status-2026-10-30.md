# Account broker child status, 2026-10-30

The selected authenticator child previously reached the broker's generic exit-1
path without preserving its `waitpid` status. `selected_child_exited` now writes
`ANDROID-ACCOUNT-BROKER-CHILD-STATUS raw=<decimal>` and flushes it after a successful
nonblocking reap. The existing error, exit status, child cleanup and unsuccessful
`waitpid` behavior are preserved. This record belongs only to the controller's
private broker output; it adds no application text or public receipt field.

The V checker extracts the production observer and unchanged `main`, then tests
actual child exits 0, 1, 37, 125, 126 and 255; SIGTERM and SIGKILL; and live,
already-reaped and nonchild controls. A fully buffered stdout test exits through
raw `_exit` immediately after the observer, proving that the explicit flush
preserves the record. Removing that flush and replacing the status with zero are
detected negative controls. All checks passed. Independent source and test review
found no blocker. These host checks establish diagnostic behavior, not ARM runtime
or Google authentication success.

The source snapshot used by the checker was based on
`adf958f59cfe3d0611a1179b6dd1791e0ee62568`. The broker source SHA-256 is
`8fe3aa16cbe43cf815bf5e794d49fb0c6eca4df8a97851c8f2e55dc3da5cfc03`;
the checker SHA-256 is
`8125342ebe3092b9f7cf2d8b3aa527eb79fb23f05c2b61a06c75aff29682bea3`.
Generated evidence is retained outside Git at
`/Users/alex/.local/state/vinix/android/account-broker-status-checks-2026-10-30-r1`.
Its test-run inventory `run-r1/sha256.json` is pinned by
`d6d2739f9dfa83070ebe966d46d58f84eccd22cf1bed265da330416a844d7012`.
The complete 33-entry evidence root passed sealing and an independent full
readback at
`/Users/alex/.local/state/vinix/android/account-broker-status-sealed-2026-10-30-r1`,
manifest
`4b5063edebd2035e420b9038b25a7b542d22ae9435b06f6a9e9b3c0e5d03a388`.
Separate guard receipts are retained in
`/Users/alex/.local/state/vinix/android/account-broker-status-seal-controls-2026-10-30-r1`;
both checks passed the unchanged 600 MiB, 900-second, 64 MiB growth and 1 GiB
reserve limits with complete cleanup.

The final checker compile and full test run completed with exit 0 and complete
cleanup under the original 600 MiB, 300-second, 512 MiB growth and 1 GiB reserve
guards. Their sampled peaks were 284,672,000 and 178,077,696 bytes; elapsed times
were 1,831 and 2,079 ms, with no process swaps. The first checker compile rejected
an Option assertion before producing an executable; its original logs and guard
receipt are retained. `failed-checker-source.v.input` reconstructs that initial
source from the final file and reverse hunk after the failure; it is not a
contemporaneous source capture. The production broker did not change during that
checker-only correction.
