# Seed account-options fixture tools, 2026-10-30

`onboarding-api-run.v --seed-account-options` selects the signed UserManager
unseeded options and immutable empty bundle regression against its exact coupled
framework/native pair. The existing protected identity, bounded child lifetime,
single PASS/readiness and clean-exit checks remain unchanged. Transfer selector
`serve --seed-account-options-api` serves only `/seed-account-options-api-run`
and `/seed-account-options.apk`.

The exact marker is:

```text
SEED-ACCOUNT-OPTIONS-PASS unseeded-null service-lookup method-shape empty-singleton immutable-empty null-branch
```

Paths below are relative to `S=/Users/alex/.local/state/vinix/android`.
Actual artifacts were rehashed before pinning:

| Input | Path below S | SHA-256 |
| --- | --- | --- |
| Signed APK | `seed-account-options-fixture-2026-10-30-r1/probe.apk` | `36c87d606306c799f50771ab0bed5cacdf07603e96f3e85b6c4aab4870f1f333` |
| Framework JAR | `combined-account-webview-seed-account-options-framework-2026-10-30-r1/api-impl.jar` | `cb2e3fabab652c65351da16770ae98c4113781df0830440b734395bb35b6f265` |
| Native DSO | `current-native-build-2026-10-30-seed-account-options-r1/native/libvinix-android-native.so` | `179f51ad25cc99fd939ca1f217e87f1d3ab9c452b98db861da11e0344363f6ce` |

The runner selftest rejected 619 malformed, duplicate, mixed-profile and failure
cases, including 49 actual malformed-CLI refusals. Transfer selftests retain
pin/snapshot/binary/HTTP/deadline checks and add ten malformed-selector/port
refusals without output creation. Independent selector/marker review passed.
ELF inspection confirms a static AArch64 executable without an interpreter.
Historical profile values and routes remain unchanged.

All five checks passed sequentially with
600 MiB aggregate RSS, 300 seconds, 512 MiB observed shared-volume growth and
1 GiB reserve. Every guard recorded child/guard exit zero and complete cleanup;
timing reports recorded zero swaps.

| Check | Guard seconds | Sampled RSS bytes | Timing maximum bytes |
| --- | ---: | ---: | ---: |
| Host runner compile | 1.412 | 352190464 | 364478464 |
| Runner selftest | 0.519 | 18890752 | 17694720 |
| Static ARM runner compile | 1.740 | 361152512 | 361185280 |
| Host transfer compile | 1.562 | 355352576 | 371900416 |
| Transfer selftest | 0.517 | 10403840 | 9224192 |

The ARM runner is `S/seed-account-options-api-run-2026-10-30-r1/run`, SHA-256
`f4750504c0e8c7718773095c04661d18003098fe60db89434e0d9a2182da3862`.
The transfer is `S/seed-account-options-api-transfer-build-2026-10-30-r1/transfer`,
SHA-256 `f30ea329f8dad934d55e7988e8a0a95bbfaaedfedea25a8301615cdd6b8e3f85`.
Runner/transfer source hashes are respectively
`cadb859fe8d6478f987a20616d5cfd9eac19119f405b64e549724d1d86d986b0`
and `ce1ec36a54c966a6196b9b0a351de58870a1d67c5f0c593b0aee07ecc0f4dc64`.
The captured checkout base is `97b9aea1ea396196774bc65d1b13727970c575a8`;
exact changed sources, commands, input/tool hashes and checks remain in the
runner build, transfer build and transfer control roots.

The complete four-root, 34-entry seal and independent fresh-process readback
passed: `S/seed-account-options-api-tools-sealed-2026-10-30-r1/manifest.json`,
SHA-256 `6bc02550a2e54c2a400cebec23e78c7d8145b1f484bf92f5877ac3a16f243a7f`.
Both retained 600 MiB RSS, 300 seconds, 64 MiB observed shared-volume growth and
1 GiB reserve, with exit zero and complete cleanup. All roots are closed.
This establishes host checks and static ARM readiness; ART execution, GMS
behavior and Google authentication require separate runtime evidence.
