# Broker output drain host checks — 2026-10-30

`brokerlog` captures private broker output with raw nonblocking reads. A final
drain proves completion only after `read(2)` returns zero. Empty live reads,
retained writers, byte limits and I/O failures produce finite numeric results.
The existing 16 MiB capture ceiling applies to both the private file and buffer;
an exact-length stream receives a one-byte EOF probe. Public results contain
only status, byte count, error number and EOF state.

Six host regression functions passed using real pipes and forked processes:

- A 12 KiB child stream leaves 8 KiB after its owner exits; the final drain
  preserves every byte, including NULs and a terminal numeric status marker.
- A real descendant retains the output descriptor until a separate release
  pipe permits closure. The first drain reaches its deadline without claiming
  EOF, and the later drain proves EOF.
- Exact and exceeded byte ceilings, empty live reads, bounded deadlines,
  invalid configurations, closed descriptors and private-file write failures
  preserve the expected completion and capture state.

Initial serial V C generation, the emitted C Makefile and the actual test executable
all exited zero with complete cleanup. The final generation took 1.715 s
(232,947,712 bytes sampled aggregate RSS; 258,523,136 process maximum RSS),
C compilation took 0.360 s, and tests took 0.290 s. Each phase kept the original
600 MiB RSS, 300 s wall, 512 MiB shared growth and 1 GiB reserve limits. Generated
C uses a 4096-byte stack buffer and pointer append into reserved capacity;
the regression also verifies stable buffer address and capacity.

Initial source pins, based on revision `5374d8f6187659afb2c9a2c82996efee22c0a8b1`:

- `brokerlog/drain.v`: `bb45fcba02207ec59dbcc1850b2366bade005cae7fe9f1324704012eb95e6594`
- `brokerlog/drain_test.v`: `0eca145c4fbb28148b9f6eba2e954ac6b0a2c975f83fef30d519f033a0a668a2`

Complete artifacts remain outside Git at
`/Users/alex/.local/state/vinix/android/broker-output-drain-host-2026-10-30-r{1,2,3}`.
The first C compile failure (`errno` macro collision), earlier passing run and
final run are all preserved. The later controller compile exposed the separate
local `poll`/C function collision; the final helper uses `descriptor`.
The three closed roots were sealed and independently read back under the
unchanged 64 MiB shared growth guard: 85 entries, manifest
`e37010ca2011bcd1a52f446a3933e685bfbf12e4662748c36d66bd11314d4d5b`,
at `/Users/alex/.local/state/vinix/android/broker-output-drain-host-sealed-2026-10-30-r1`.
Seal and readback controls are in the sibling
`broker-output-drain-host-seal-controls-2026-10-30-r1` directory.

These checks validate the capture helper. Controller cleanup ordering, archive
privacy and the next ARM account-flow run are validated by the coupled controller
work; this record does not establish the remaining GMS failure's cause.

## ARM poll binding successor

The full ARM controller compile exposed a nominal C pointer mismatch between
the initial V `BrokerPoll` struct and the header's `struct pollfd`. The helper
now binds `C.pollfd` directly and declares `C.poll` with `&C.pollfd`. Capture,
deadline, privacy and cleanup behavior remain unchanged. The test's raw wait
status is explicitly `i32`, matching `waitpid`'s C ABI.

The complete six-test unit now also receives a focused Linux/AArch64 C compile
using the producer's musl GCC 14.2.0 and exact flags `-D_GNU_SOURCE -O2 -fwrapv
-pthread -Werror=implicit-function-declaration -Werror=int-conversion`, with the
same V builtin, OS, synchronization and time include directories. The resulting
object is ELF 64-bit AArch64. This check passed, followed by serial host C
generation, compilation and all six actual host regressions. All five phases
exited zero with complete cleanup under the original resource limits. ARM C
compilation took 4.55 s with 275,988,480 process maximum RSS bytes.

Current pins, succeeding source commit `4f0f66a24`:

- `brokerlog/drain.v`: `24a77494a5e5e7bfc908508a5db4b2b79bbb7f180e2c1ed3e76a0f86b9bb8c59`
- `brokerlog/drain_test.v`: `252d73b817bc579f8e58dd46f2735d4d81f15e467a8cc3daafa8f9280f4360ea`

The first focused ARM attempt, which rejected the test's wider wait-status
pointer, remains at `broker-output-drain-host-2026-10-30-r4`. The complete
passing ARM and host run is at `broker-output-drain-host-2026-10-30-r5`, including
exact compiler argv and all guard receipts. Both directories are under the
same external state parent as the original attempts. Independent source and
generated-C review passed for these current pins.
Both successor roots were sealed and independently read back under the unchanged
64 MiB growth guard: 55 entries, manifest
`a0ac0e0455895e9ad1866404fdaa1f8c776c6063ac993a0de67010b17d462c70`,
at the sibling `broker-output-drain-arm-sealed-2026-10-30-r1` directory. Controls
remain in `broker-output-drain-arm-seal-controls-2026-10-30-r1`.
