# Native resource synchronization fixture tools, 2026-11-01

The additive `--resource-locks` runner profile uses the unchanged Intent r2
framework and requires a distinct native resource-lock library and signed
fixture. `serve --resource-locks-api` retains the two-file protocol at
`/resource-locks-api-run` and `/resource-locks.apk`. The test-only JNI helper is
inside the pinned APK and uses the ordinary APK native-library load path.
Historical profiles, pins, routes and strict health checks remain intact.

The exact success marker is:

```text
RESOURCE-LOCKS-PASS workers=4 iterations=64 ids names strings arrays bags themes same-copy cross-copy configuration paths owned-asset owned-directory
```

Protected inputs, dedicated identity/data, six input pins, eleven receipt checks,
descriptor closure, bounded lifetime, exact PASS/READY markers, drained EOF and
clean child exit remain required. This fixture covers concurrent packaged
resource and owned NDK asset/directory operations; it does not establish Maps,
Play Services or authentication behavior.

Runtime identity is UID/GID 10137, with transfer port 55529, mount
`/opt/resource-locks-runtime`, inputs
`/opt/input/resource-locks-run` and `/opt/input/resource-locks.apk`, and fresh
output `/var/lib/resource-locks-r1`. The guest must verify the identity is unused
before provisioning it.

Paths below use `S=/Users/alex/.local/state/vinix/android`:

| Input | Path below S | SHA-256 |
| --- | --- | --- |
| Framework | `combined-account-webview-intent-extras-framework-2026-11-01-r2/api-impl.jar` | `02aefc8136cb87eb8e9ebd0928cb15f3e1c2042e47d2a687170a0f9309ac4b20` |
| Native | `current-native-build-2026-11-01-resource-lock-r2/native/libvinix-android-native.so` | `aeb5ccd643020cbb20ad5630dabff4bfd0ff8b04a5b0fbcfd1b657b3bcd91dd7` |
| Signed fixture | `resource-lock-fixture-2026-11-01-r3/probe.apk` | `bafc5f4e708f15fdb0d2868d8b332863c7ce429f1447952867968300e58e12dd` |

All five tool checks passed on their first attempt. Runner selftests rejected
1,941 malformed, mixed and failure cases. Transfer checks preserve exact pinned
snapshots, traversal/request/deadline controls and add malformed selector/port
refusals plus exact resource route/asset uniqueness assertions. ELF inspection
confirms static AArch64 EXEC without INTERP or DYNAMIC segments. This host
qualification establishes no ARM fixture or live Maps result.

| Check | Guard seconds | Sampled aggregate RSS bytes | Time maximum bytes |
| --- | ---: | ---: | ---: |
| Host runner compile | 2.243 | 346,570,752 | 375,668,736 |
| Runner selftest | 1.142 | 22,298,624 | 17,776,640 |
| Static ARM runner compile | 2.769 | 366,018,560 | 363,380,736 |
| Host transfer compile | 2.889 | 370,884,608 | 381,665,280 |
| Transfer selftest | 1.438 | 10,633,216 | 9,404,416 |

Every guard and child exited zero with complete cleanup and zero swaps under
the unchanged 600 MiB aggregate RSS, 300-second, 512 MiB observed shared-growth,
1 GiB reserve, 4 MiB output and file-size caps. Runtime/tool/artifact inputs
were rehashed after checks; frozen sources still match the checkout. The Intent
r2 APK, runner, transfer and seal manifest were rehashed without modifying them.
Source base is `fea4b7a85b75a7db10300e1c1fcac3c49064ed84`; runner and transfer
source hashes are respectively
`1eddc5383df2115ccb7ce814a0e64933bcb5991499bf5ffb6fb54ef5fb6e651a`
and `0d98f92f61196157a636c6f1c19383235b599437beae7f6671c9349998f5aab3`.

ARM runner `S/resource-locks-api-run-2026-11-01-r1/run` has SHA-256
`a62460d72f5a20dcd239cf8abb8d479e4893ba167c970b1f1887b72c96482259`.
Transfer `S/resource-locks-api-transfer-build-2026-11-01-r1/transfer` has SHA-256
`bd66ede231a76a8b511586b98b1527b2700b0ce31ed9ba43b5ae5154b3c24a28`.
The four complete tool/control roots are closed. Full sealing and separate
fresh-process readback passed for 35 entries at
`S/resource-locks-api-tools-sealed-2026-11-01-r1/manifest.json`, SHA-256
`5895080689f336f04a1bbde112f1dbd001c9f4d78203889b6eacff3df004b538`.
Seal/readback took 0.096/0.273 seconds with zero guard/child exits, complete
cleanup and zero swaps under the unchanged 600 MiB/300-second/64 MiB
shared-growth/1 GiB reserve/file-size caps. Controls remain in
`S/resource-locks-api-tools-seal-controls-2026-11-01-r1`. Independent source and
final pin/artifact/guard/ELF/seal reviews passed. Preserve all complete original
bundles and unchanged auditors.
