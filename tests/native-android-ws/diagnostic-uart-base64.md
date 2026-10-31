# Guest-pinned diagnostic UART base64 preservation

`diagnostic-uart-base64.v` preserves a failed guest log exported with standard
base64 when console line endings prevent a raw byte transfer. It requires an
independently captured guest byte count and SHA-256, plus the complete immutable
UART interval and its SHA-256. This diagnostic does not issue a fixture result
or replace any SERVICE-QUERY collector.

```text
diagnostic-uart-base64 UART UART_SHA256 GUEST_BYTES GUEST_SHA256 FRESH_OUTPUT
diagnostic-uart-base64 --check BUNDLE
diagnostic-uart-base64 --self-test
```

The input must be a canonical single-link regular file, mode `0400`, at most
8 MiB, with complete LF-terminated lines of at most 8,192 bytes. The positive
guest byte count is limited to 4 MiB. Stable double reads compare bytes and file
identity. Output must be a fresh canonical directory outside a Git checkout.

The decoder groups every adjacent base64-alphabet/padding line into a maximal
run before validating padding. Exactly one run must decode canonically to the
explicit guest length and hash. Standard LF or CRLF representation separators
are accepted; decoded payload bytes are never removed, repaired or normalized.
Corrupt padding, noncanonical low bits, truncation, interleaving and duplicate
matching runs are rejected.

Each private read-only bundle retains exactly seven members: the whole UART,
the exact encoded span, the decoded child, decoder source and executable,
inputs, and diagnostic receipt. A fresh `--check` process reselects the unique
run and verifies all bytes, pins, modes and membership. The printed diagnostic
`PASS` reports preservation integrity only.

## Qualification on 2026-10-31

Source SHA-256:
`1db1dfef0223e30fca6463eaf65d5cfb8a1b3e075212340fa632b42a7671d574`.
Qualified executable SHA-256:
`ed4c7c7087505c00e7e9bc96d3d7032770d068a971e9268931e432661e59dbc9`.

The production compile and self-tests passed under the original 600 MiB RSS,
300-second, 512 MiB shared disk-growth, 1 GiB reserve and file-size guards.
Compilation took 4,023 ms with sampled aggregate RSS 369,590,272 bytes.
Self-tests cover LF/CRLF preservation of all byte values, maximal-run padding,
mutation, interleaving, truncation, duplicates, invalid byte counts and pins,
existing output, symlink/hardlink/FIFO input, and tampering with every retained
member. All guard/child exits were zero, cleanup completed and process swaps
were zero. Independent source review passed.

Complete source, executable and controls remain under
`/Users/alex/.local/state/vinix/android/diagnostic-uart-base64-tool-2026-10-31-r1`
and `diagnostic-uart-base64-controls-2026-10-31-r1`. Their two-root/eight-entry
seal and fresh full readback passed under the original 600 MiB, 900-second,
64 MiB growth and 1 GiB reserve limits. The seal manifest is
`/Users/alex/.local/state/vinix/android/diagnostic-uart-base64-sealed-2026-10-31-r1/sealed/manifest.json`,
SHA-256 `f36a8f0464790292492e5ae87392cd5e16c35908375a48fcfbb2746a34ed0a14`.

## First diagnostic application

The failed UserRestrictions ARM log was recovered byte for byte under
`/Users/alex/.local/state/vinix/android/maps-user-restrictions-runtime-audit-2026-10-31-r1/failed-fixture-decoded-r1`.
The whole 13,605-byte UART has SHA-256
`50b5bacf6e3aaf0c7e05a4a40d872d888c0c0b6df4a04f8938ba38b176441fd7`.
Its unique raw span `[111,13605)` contains 173 CRLF base64 lines. The decoded
9,860 bytes match the independently captured guest SHA-256
`20d886218a4f21a233132032c1f8210d54050ce5ad4b48d6f251e2d0f92e7199`.
Diagnostic receipt SHA-256 is
`90920e9dd325333502ae427942cf7bf0f26ff6abf49708ac6922e740c2383e0f`.

Derivation and a fresh retained-decoder full check passed with unchanged
600 MiB, 300-second, 64 MiB growth and 1 GiB reserve limits. The recovered log
contains one `USER-RESTRICTIONS-FAIL` and a null-key exception in
`BaseBundle.getBoolean`; it contains no UserRestrictions PASS or readiness
marker. It establishes neither successful UserManager ARM behavior nor
authentication. The original signed fixture and its assertions remain intact.
The external `fixture-failure-validation.md` records the snapshot receipt
chain and failure, SHA-256
`481b7f58ed8ed778474ce3f9292e2f09dd87ac9b8442ce4c3eec871a7b9f3aa2`.
