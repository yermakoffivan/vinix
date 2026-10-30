# Bitmap tile fixture tools, 2026-10-30

`onboarding-api-run.v --bitmap-tiles` selects the signed BitmapDrawable mode and
offscreen-pixel regression against its exact new framework/native pair. Existing
protected-input, principal, bounded-child, single PASS/readiness and clean-exit
checks remain intact. Transfer selector `serve --bitmap-tiles-api` serves only
`/bitmap-tiles-api-run` and `/bitmap-tiles.apk`; historical profiles and routes
retain their original values.

The exact marker is:

```text
BITMAP-TILES-PASS modes reset invalidation stable-paint pixels-repeat-mirror-clamp nullable-axis
```

Paths below are relative to `S=/Users/alex/.local/state/vinix/android`.
Actual inputs were rehashed before pinning:

| Input | Path below S | SHA-256 |
| --- | --- | --- |
| Signed APK | `bitmap-tiles-fixture-2026-10-30-r2/probe.apk` | `d4aedf04a871758249fbea08e79a7ac49f9fdb2eb98f915f6a7c8ee389fede7c` |
| Framework JAR | `combined-account-webview-bitmap-tiles-framework-2026-10-30-r1/api-impl.jar` | `741641c30098cf2f682672889c7ac653c6b2f23b9c09001a7af8f56bb01d9500` |
| Native DSO | `current-native-build-2026-10-30-bitmap-tiles-r1/native/libvinix-android-native.so` | `6969a813fbfe69cd882f3cb47760cb09cb106ca9aad748ea67ab93967aacad20` |

The host runner selftest rejected 779 malformed, duplicate, mixed-profile and
failure cases, including 63 actual malformed-CLI refusals. Transfer selftests
retain pin/snapshot/binary/HTTP/deadline checks and add ten malformed-selector
and port refusals without output creation. ELF inspection confirms a static
AArch64 executable without an interpreter. These checks establish tool
readiness; the fixture's actual ARM pixel results require separate execution.

All five checks passed sequentially with unchanged 600 MiB aggregate RSS,
300-second, 512 MiB shared-volume growth and 1 GiB reserve caps. Every guard
recorded child/guard exit zero and complete cleanup; time reports recorded
zero swaps.

| Check | Guard seconds | Sampled RSS bytes | Time maximum bytes |
| --- | ---: | ---: | ---: |
| Host runner compile | 1.467 | 350,846,976 | 373,997,568 |
| Runner selftest | 0.568 | 21,725,184 | 17,711,104 |
| Static ARM runner compile | 1.770 | 358,957,056 | 361,447,424 |
| Host transfer compile | 1.726 | 352,878,592 | 384,647,168 |
| Transfer selftest | 0.492 | 9,289,728 | 9,109,504 |

The ARM runner is `S/bitmap-tiles-api-run-2026-10-30-r1/run`, SHA-256
`a12a419781dcc81d59b7edf076a9f535ccc7d55c731a3296a63c2a3bcb8a205a`.
The transfer is `S/bitmap-tiles-api-transfer-build-2026-10-30-r1/transfer`,
SHA-256 `76b37c1fd9b11a066ffc9944bf53512302996b4c00009a2dc4f183f9645fe3ad`.
Runner/transfer source hashes are respectively
`d09efb45c8c6c5d164c8a9a1716717eac007e0306984c17e22ea5d7a9f2b5e2f`
and `bb6b9e3ad57f75fec16c36c9638ddf1e7b49664f686d7b53ada823c9131964e5`.
The captured source base is `5a6cb656a42c0e3427982678667ed4eb0ff1dc20`;
exact source snapshots, commands, runtime/tool hashes and checks are retained
in the runner build, transfer build and transfer control roots.

The complete four-root, 34-entry seal and separate fresh-process full readback
passed at `S/bitmap-tiles-api-tools-sealed-2026-10-30-r1/manifest.json`, SHA-256
`31c4b5cf2733ed8e01f112da416e326b566bcb9a28174d7ca314aa8486adb6dd`.
Both retained 600 MiB RSS, 300 seconds, 64 MiB observed growth and 1 GiB reserve,
with exit zero and complete cleanup. All four input roots are closed. GMS
behavior and Google authentication remain outside this standalone fixture's
scope.
