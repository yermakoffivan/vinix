# PaintDrawable fixture tools, 2026-11-01

The additive `--paint-drawable` runner profile pins the signed PaintDrawable
fixture to its new framework and the qualified retained Resources native
library. `serve --paint-drawable-api` retains the two-file protocol with routes
`/paint-drawable-api-run` and `/paint-drawable.apk`. Historical profiles, ordering,
pins and routes remain unchanged. The only generic health change recognizes the
new marker as conflicting with other fixtures; no fatal or exception check is
relaxed.

The exact marker is:

```text
PAINT-DRAWABLE-PASS constructors corners invalidation arrays pixels inflation canvas-state
```

Protected inputs, dedicated identity/data, six input pins, eleven receipt checks,
descriptor closure, bounded child lifetime, exact PASS/READY, drained EOF and
clean child exit remain required. These host results establish no ARM fixture,
Maps UI, network, Play Services or authentication outcome.

Paths are below `S=/Users/alex/.local/state/vinix/android`:

| Input | Path below S | SHA-256 |
| --- | --- | --- |
| Framework | `combined-account-webview-paint-drawable-framework-2026-11-01-r1/api-impl.jar` | `b3fed7d846a23d9e8afc1256e5bfa7d9ebcd1ba5330705d40fd14131291d516c` |
| Retained native | `current-native-build-2026-11-01-resources-float-r2/native/libvinix-android-native.so` | `441ae035ec4b69c36635cc4521af3fafcb6a867305b0ba25d6e55df7ff0dadc9` |
| Signed fixture | `paint-drawable-fixture-2026-11-01-r1/probe.apk` | `cd459b703196920a7e07e1bfdb7d43e304c1115b12b1ad0998281fab1ea64868` |

All five required checks passed on the first attempt. Runner selftests rejected
1,575 malformed, mixed and failure cases; transfer tests retain pinned binary
snapshots, traversal/request/deadline controls and add malformed selector/port
refusals and exact route/asset uniqueness assertions. ELF inspection confirms
static AArch64 EXEC without an interpreter. Independent draft and final
pin/artifact/guard reviews passed. Runtime execution remains a separate check.

| Check | Guard seconds | Sampled aggregate RSS bytes | Time maximum bytes |
| --- | ---: | ---: | ---: |
| Host runner compile | 1.951 | 359,366,656 | 371,179,520 |
| Runner selftest | 1.076 | 38,289,408 | 34,324,480 |
| Static ARM runner compile | 2.482 | 370,393,088 | 369,049,600 |
| Host transfer compile | 1.662 | 366,673,920 | 389,038,080 |
| Transfer selftest | 0.853 | 9,420,800 | 8,863,744 |

Every guard/child exited zero with complete cleanup and zero swaps under the
original 600 MiB aggregate RSS, 300-second, 512 MiB observed shared-growth,
1 GiB reserve and file-size caps. Runtime inputs were rehashed afterward, and
frozen source copies still match the checkout.

ARM runner `S/paint-drawable-api-run-2026-11-01-r1/run` has SHA-256
`b18b61aa29edd5760e06c164899ed66fd220e1d74e1715c511b984b7ab68d43e`.
Transfer `S/paint-drawable-api-transfer-build-2026-11-01-r1/transfer` has SHA-256
`d02581d245afbe9b00aaf0eb5b7bd8b4fb4921da98ff716d3e54dd0676b626c7`.
Captured source base is `67b06755fe76bad5e9301f3301422ab171f90364`; runner and
transfer source hashes are respectively
`67a115532dc7e2f3e458292936ec8cba32d38b6086e45cb74fb1b66b82346a4f`
and `435914a6053872434ff1703577870098f81e67a13bea4da09329cdf73e6cbbfe`.

Four complete tool/control roots are closed. Complete sealing and a separate
fresh-process full readback passed for 34 entries at
`S/paint-drawable-api-tools-sealed-2026-11-01-r1/manifest.json`, SHA-256
`f4708ddc43f9c200a1ff225997ce5a8f3709401c24996d2951556b8671aa34fa`.
Seal/readback took 0.054/0.147 seconds under the original 600 MiB/300-second/
64 MiB shared-growth/1 GiB reserve/file caps, with zero guard/child exits,
complete cleanup and zero swaps. Retain all original bundles and auditors.
