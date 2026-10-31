# Bundle and absent cross-profile service fixture tools, 2026-10-31

The runner adds two explicit profiles on the corrected framework and retained
native library. `--bundle-cross-profile` selects the small boolean/null-key and
typed-null CrossProfileApps fixture. `--user-restrictions-bundle` reruns the exact
original signed UserManager APK with every case and its original marker intact.
The historical `--user-restrictions` profile remains pinned to its old framework.
Earlier failures are separate retained evidence; these host checks establish no
ARM retry result, Maps UI, policy enforcement or Google authentication success.

Transfer modes each retain the existing two-file protocol:

| Selector after `serve` | Routes |
| --- | --- |
| `--bundle-cross-profile-api` | `/bundle-cross-profile-api-run`, `/bundle-cross-profile.apk` |
| `--user-restrictions-bundle-api` | `/user-restrictions-bundle-api-run`, `/user-restrictions.apk` |

Both modes intentionally transfer the same new ARM runner under distinct URLs.
The retry serves the exact original UserManager APK path/pin/route. Selftests
verify these shared identities and retain all historical asset pins/routes.
Protected inputs, identity/mount isolation, six pins, eleven receipt checks,
descriptor closure, bounded child lifetime and exact PASS/READY remain unchanged.
Only new BUNDLE marker-conflict recognition is added to health checks; no fatal
or exception check is relaxed and there is no expected-warning grammar.

The new exact marker is:

```text
BUNDLE-BOOLEAN-PASS null-keys defaults stored-values nonmutating ordinary-keys legacy-control cross-profile-absent
```

The unchanged retry marker is:

```text
USER-RESTRICTIONS-PASS fresh-snapshots bundle-truth virtual-backend mutation-isolation exceptions context-controls
```

Paths below are relative to `S=/Users/alex/.local/state/vinix/android`. Actual
artifacts were rehashed before pinning and again during independent review.

| Input | Path below S | SHA-256 |
| --- | --- | --- |
| Corrected framework | `combined-account-webview-bundle-cross-profile-framework-2026-10-31-r1/api-impl.jar` | `3ebf88615dcb87ec103b098a0baf397f5a4428623f809fd139b23e9f60978235` |
| Retained native | `current-native-build-2026-10-30-layout-alignment-r1/native/libvinix-android-native.so` | `b6aeb06b7473220da8844015a253ed87394fef6209173c14317fcbaf19141e95` |
| Small fixture | `bundle-boolean-fixture-2026-10-31-r1/probe.apk` | `c781769a0ef5fd5357ae1f678d52ef98a2532a5ae07c155a013e278a7b2248ab` |
| Original UserManager fixture | `user-restrictions-fixture-2026-10-30-r1/probe.apk` | `19f8715bcc6e5f19dff1dc11e031912907d7c762a7f1927b85dda697f447dbea` |

All five required checks passed on the first attempt. Runner tests rejected
1,351 malformed/mixed/failure cases, including 105 actual CLI refusals. Transfer
adds 20 malformed-selector/port cases while retaining bounded snapshot, binary
HTTP, traversal, request and deadline tests. Independent mapping/guard review
passed. ELF inspection confirms AArch64 EXEC without an interpreter.

| Check | Guard seconds | Sampled aggregate RSS bytes | Time maximum bytes |
| --- | ---: | ---: | ---: |
| Host runner compile | 1.779 | 355,647,488 | 368,771,072 |
| Runner selftest | 0.879 | 21,741,568 | 17,743,872 |
| Static ARM runner compile | 2.299 | 373,702,656 | 362,676,224 |
| Host transfer compile | 2.018 | 371,851,264 | 386,957,312 |
| Transfer selftest | 0.779 | 10,108,928 | 8,880,128 |

All guard/child exits were zero with complete cleanup and zero swaps under the
original 600 MiB aggregate RSS, 300-second, 512 MiB shared-growth, 1 GiB reserve
and file-size caps. The small fixture does not exercise warning-emitting wrong
types; preservation of the existing catch/warning body is a source-oracle check.
The original UserManager fixture remains unchanged and separate.

Shared runner `S/bundle-cross-profile-api-run-2026-10-31-r1/run` has SHA-256
`ca7165c9758553dedc6815451f2a8618f56357e097dc5718188688b3e88dc7e1`.
Transfer `S/bundle-cross-profile-api-transfer-build-2026-10-31-r1/transfer` has
SHA-256 `c937906684a7bff89aae93b41d5cfa2a75ad94b13740730c2737d2cf12e09c39`.
Source hashes are respectively
`6a1ec07d4a20182d0f97e31ede7ad6a65d60271cf52689cbeaa6b9b7f1d24578` and
`ba077d118e7e223feef904cb0a929deb1d5a355e4319bcc553e20990d5db1bbf`;
captured source base is `16143aa8fc19c7fcc4cedb449be2cfae450da3d6`.
All source snapshots, tools, runtime pins, commands and logs are retained.

Four original run/build/transfer/control roots are closed. Complete seal and
separate fresh-process full readback passed for 35 entries at
`S/bundle-cross-profile-api-tools-sealed-2026-10-31-r1/manifest.json`, SHA-256
`2aa371d229d5146359ed326370f1be06f5782d58ebfd9a531821850a5ef6f7a9`.
Both guard/child exits were zero, cleanup complete and swaps zero under original
600 MiB/300-second/64 MiB growth/1 GiB reserve audit caps. Preserve all original
complete bundles and failure controls. Guest execution remains a separate check.
