# Intent extras fixture tools, 2026-11-01

The additive `--intent-extras` runner profile pins the signed regression to its
successor framework and the verified retained Dialog native library.
`serve --intent-extras-api` preserves the two-file protocol with routes
`/intent-extras-api-run` and `/intent-extras.apk`. Historical profiles, ordering,
pins and routes remain unchanged. Generic health checks only recognize the new
competing marker; no fatal or exception check is relaxed.

The exact marker is:

```text
INTENT-EXTRAS-PASS merge precedence copies no-op nulls shallow controlled-intent
```

Protected inputs, dedicated identity/data, six input pins, eleven receipt checks,
descriptor closure, bounded lifetime, exact PASS/READY markers, drained EOF and
clean child exit remain required. Host qualification establishes no ARM fixture,
Maps, Play Services or authentication result. The SDK is the admitted r2; its
earlier failed production remains separately preserved by the SDK producer.

Paths are below `S=/Users/alex/.local/state/vinix/android`. The original r1
qualification follows; the corrected fixture and current r2 tools are recorded
after it.

| Input | Path below S | SHA-256 |
| --- | --- | --- |
| Framework | `combined-account-webview-intent-extras-framework-2026-11-01-r2/api-impl.jar` | `02aefc8136cb87eb8e9ebd0928cb15f3e1c2042e47d2a687170a0f9309ac4b20` |
| Retained native | `current-native-build-2026-11-01-dialog-theme-r1/native/libvinix-android-native.so` | `280730c4166687394cf69e548cdd106e58c57ba9472f339dde2c80ebdee2595a` |
| Signed fixture | `intent-extras-fixture-2026-11-01-r1/probe.apk` | `fed8561ffe44b7562499a22dac8fc5e8e0e28607135bd44a835fefd5be347b5a` |

All five runner/transfer checks passed on their first attempt. Runner selftests
rejected 1,815 malformed, mixed and failure cases. Transfer tests retain exact
pinned snapshots and traversal/request/deadline controls, adding malformed
selector/port refusals and exact route/asset uniqueness assertions. ELF inspection
confirms static AArch64 EXEC without an interpreter or dynamic segment.
Independent draft and final pin/artifact/guard reviews passed. Runtime execution
remains a separate check.

| Check | Guard seconds | Sampled aggregate RSS bytes | Time maximum bytes |
| --- | ---: | ---: | ---: |
| Host runner compile | 2.134 | 362,774,528 | 374,833,152 |
| Runner selftest | 1.151 | 22,003,712 | 17,760,256 |
| Static ARM runner compile | 2.912 | 371,032,064 | 373,800,960 |
| Host transfer compile | 2.239 | 368,738,304 | 392,085,504 |
| Transfer selftest | 0.912 | 10,551,296 | 9,322,496 |

Every guard and child exited zero with complete cleanup and zero swaps under
the unchanged 600 MiB aggregate RSS, 300-second, 512 MiB observed shared-growth,
1 GiB reserve and file-size caps. Runtime/tool inputs were rehashed after checks,
and both frozen source copies still match the checkout.

ARM runner `S/intent-extras-api-run-2026-11-01-r1/run` has SHA-256
`2edf61e7afe2bfcf9551a29fe00a1110de36d4f6534c71664827de2074ff083e`.
Transfer `S/intent-extras-api-transfer-build-2026-11-01-r1/transfer` has SHA-256
`54fe5243f6f6cae7ce0eb343772055f775d4b3982282762292c2f4d5f1a48409`.
Captured source base is `0b4ae37944eac0e5bd1e7c648713d1a6472c5ee1`; runner and
transfer source hashes are respectively
`25d87cee4877aba7c25eff6a4911529a0cd8c6dc78e28c5122fab34d72013bf9`
and `12d107002d563d971ddf7928812752c7c07b7192460a55b3715f1af119923634`.

Four complete tool/control roots are closed. Full sealing and a separate
fresh-process readback passed for 34 entries at
`S/intent-extras-api-tools-sealed-2026-11-01-r1/manifest.json`, SHA-256
`8b3fe39508a5ea5b1eed450c4babcbda3fe2759db6ce558d7788e40ed19d8c16`.
Seal/readback took 0.089/0.242 seconds, with zero guard/child exits and complete
cleanup under the unchanged 600 MiB/300-second/64 MiB shared-growth/1 GiB reserve
and file-size caps. Their controls remain in
`S/intent-extras-api-tools-seal-controls-2026-11-01-r1`. Preserve all complete
original bundles and unchanged auditors.

## Corrected fixture refresh, r2

The first ARM run exposed a fixture setup assumption: this framework's retained
`Intent` constructor eagerly allocates a `Bundle`. The corrected fixture
explicitly calls `replaceExtras(null)` and asserts the resulting null before
testing a null source or destination. This refresh changes only the fixture pin
and the transfer's runner/APK paths and pins. The framework, native library,
marker, routes and strict health checks above remain unchanged. The original r1
APK, runners, transfer and seal hashes were rechecked without modifying them.
This host qualification does not establish an r2 ARM or Maps result.

The corrected signed fixture is
`S/intent-extras-fixture-2026-11-01-r2/probe.apk`, SHA-256
`b3e0278a185bb3f7f1a302c2f515fa7a4b98edf4cfcefd69ede3f45f85a5ba2c`;
its `build.json` SHA-256 is
`1dd736fe7cf510edd122364b9fc3d179a559e4bac61936e9b98486c2a25f7f00`.
All five refreshed checks passed on their first attempt, including 1,815 runner
refusals, the transfer selftest and static AArch64 EXEC inspection without
INTERP or DYNAMIC segments.

| Check | Guard seconds | Sampled aggregate RSS bytes | Time maximum bytes |
| --- | ---: | ---: | ---: |
| Host runner compile | 2.958 | 343,490,560 | 372,375,552 |
| Runner selftest | 1.482 | 22,429,696 | 17,743,872 |
| Static ARM runner compile | 4.501 | 375,029,760 | 370,573,312 |
| Host transfer compile | 3.764 | 376,963,072 | 379,928,576 |
| Transfer selftest | 1.385 | 9,994,240 | 9,322,496 |

All guard/child exits were zero with complete cleanup and zero swaps under the
original 600 MiB/300-second/512 MiB shared-growth/1 GiB reserve/file-size caps.
Runtime/tool/artifact pins were rehashed after checks. Frozen sources still
match the checkout; captured source base is
`57e765b0855e2a5564eac662c7a2587067be17ac`. Runner and transfer source hashes are
`63354d913dc2acc5a4edaaf8012d1ac2c2672b72bcbbb5db32d47171a8de09e6`
and `fae483f2da2eed04bfdf9ee5bdfcd2e1b5c0c12d230af10d7cefa503a2264231`.

ARM runner `S/intent-extras-api-run-2026-11-01-r2/run` has SHA-256
`cad7bf5ff030b01af3bcf9a7cfc4b0bd41d3b54d93a7a864bc19daade444cc12`.
Transfer `S/intent-extras-api-transfer-build-2026-11-01-r2/transfer` has SHA-256
`b5d7c4e4222307aa87e597e7c1c6a5b5f9905087742dae31ae3b17e52e2a0abf`.
The four r2 tool/control roots are closed. Their complete seal and separate
fresh-process readback passed for 35 entries at
`S/intent-extras-api-tools-sealed-2026-11-01-r2/manifest.json`, SHA-256
`a4a1e29489a55160a582c790638e9b0f2257900e4157af4656f1611730ea16ca`.
Seal/readback took 0.114/0.279 seconds with zero guard/child exits, complete
cleanup and zero swaps under the unchanged 600 MiB/300-second/64 MiB
shared-growth/1 GiB reserve/file-size caps. Controls remain in
`S/intent-extras-api-tools-seal-controls-2026-11-01-r2`. Independent refresh
review confirmed the scoped pin changes and retained historical inputs.
