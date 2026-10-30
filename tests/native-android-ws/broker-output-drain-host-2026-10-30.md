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

Serial V C generation, the emitted C Makefile and the actual test executable
all exited zero with complete cleanup. The final generation took 1.715 s
(232,947,712 bytes sampled aggregate RSS; 258,523,136 process maximum RSS),
C compilation took 0.360 s, and tests took 0.290 s. Each phase kept the original
600 MiB RSS, 300 s wall, 512 MiB shared growth and 1 GiB reserve limits. Generated
C uses a 4096-byte stack buffer and pointer append into reserved capacity;
the regression also verifies stable buffer address and capacity.

Final source pins, based on revision `5374d8f6187659afb2c9a2c82996efee22c0a8b1`:

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
