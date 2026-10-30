# Read-only connectivity observation tools, 2026-10-30

`onboarding-api-run.v --connectivity-truth` runs the separately signed diagnostic
against the existing bitmap-tiling pair. Its marker means observations completed,
including offline, null or reported operational errors; it asserts no connected,
Internet or validated state. No SDK, native runtime, network flag or permission
changes are supplied. The bootstrap package remains separate from GMS even when
run under its pre-provisioned Unix UID/GID 10013.

Existing identity handling accepts that UID without changes and creates fresh
diagnostic data/home/surface paths beneath a protected output directory. It does
not open or modify GMS private data. The six pinned inputs, eleven receipt checks,
descriptor isolation, clean environment, bounded child lifetime, one exact PASS
and READY, EOF drain and clean exit remain unchanged. Transfer selector
`serve --connectivity-truth-api` serves only `/connectivity-truth-api-run` and
`/connectivity-truth.apk`; all preceding pins and routes remain intact.

The exact marker is:

```text
CONNECTIVITY-TRUTH-PASS observations active-info active-network all-networks capabilities interfaces raw-native
```

Inputs were rehashed before pinning. Paths are below
`S=/Users/alex/.local/state/vinix/android`:

| Input | Path below S | SHA-256 |
| --- | --- | --- |
| Signed diagnostic APK | `connectivity-truth-fixture-2026-10-30-r2/probe.apk` | `e562c6344c8560908a5d5cd70fa0480d76ea60ba6929e0720a2fbe69abba943d` |
| Existing framework JAR | `combined-account-webview-bitmap-tiles-framework-2026-10-30-r1/api-impl.jar` | `741641c30098cf2f682672889c7ac653c6b2f23b9c09001a7af8f56bb01d9500` |
| Existing native DSO | `current-native-build-2026-10-30-bitmap-tiles-r1/native/libvinix-android-native.so` | `6969a813fbfe69cd882f3cb47760cb09cb106ca9aad748ea67ab93967aacad20` |

The runner selftest rejected 865 malformed, duplicate, mixed-profile and failure
cases, including 70 actual malformed-CLI refusals. Transfer selftests retain
pin/snapshot/binary/HTTP/deadline checks and add ten malformed-selector/port
refusals without creating output. The ARM binary is static AArch64 with no
interpreter. Independent mapping review covers exact marker/pins, selectors and
unchanged isolation. Actual observations require separate guest execution.

All five checks passed sequentially under the original 600 MiB aggregate RSS,
300-second, 512 MiB observed shared-growth and 1 GiB reserve caps. Every guard
and child exited zero with complete cleanup; timing reports recorded zero swaps.

| Check | Guard seconds | Sampled RSS bytes | Time maximum bytes |
| --- | ---: | ---: | ---: |
| Host runner compile | 3.099 | 345,636,864 | 370,032,640 |
| Runner selftest | 1.133 | 20,758,528 | 17,727,488 |
| Static ARM runner compile | 4.566 | 370,556,928 | 360,579,072 |
| Host transfer compile | 3.159 | 379,797,504 | 381,206,528 |
| Transfer selftest | 0.828 | 6,602,752 | 9,519,104 |

ARM runner `S/connectivity-truth-api-run-2026-10-30-r1/run` has SHA-256
`aada0a7bd5b920ff42734764511f1368595645a9d3636f3068bff08b534f1c43`.
Transfer `S/connectivity-truth-api-transfer-build-2026-10-30-r1/transfer` has
SHA-256 `c1cfd1fd45c8fd42f739fd35995ef480e3b065cb14fd66d1bc052c2b6008d3dc`.
Runner/transfer source hashes are respectively
`2ba74b361a9fefb21a78807c978af20520c907cf6a5a8bd08f1a84c165ef1c7d` and
`9329443b1f0ac32f4d306c4c4dc2afe3bac596f255d7574aaebc82972471de22`.
The captured source base is `436dc32e1a27df482d9e2ad55827c71cf7d9d12e`;
source snapshots, runtime/tool hashes, complete logs and commands are retained.

All four original run/build/transfer/control roots are closed and passed the
unchanged complete sealer and separate fresh-process readback: 34 entries,
`S/connectivity-truth-api-tools-sealed-2026-10-30-r1/manifest.json`, SHA-256
`81a670fa65d49154a24dd2038ea4e4ce17efa719b4174817ab52f56bcb56f8de`.
Seal/readback retain 600 MiB RSS, 300 seconds, 64 MiB growth and 1 GiB reserve;
both exited zero with complete cleanup. No authenticated-Google or GMS
application-context result is claimed by these tools.
