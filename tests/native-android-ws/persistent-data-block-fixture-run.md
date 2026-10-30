# Persistent data block fixture tools, 2026-10-30

`onboarding-api-run.v --persistent-data-block` selects the signed regression for
the `PersistentDataBlockManager` class identity and absent named/typed service,
with UserManager and immutable empty bundle controls. It uses the new coupled
framework/native pair. Existing identity protection, bounded child lifetime,
single PASS/readiness and clean-exit checks remain unchanged. Transfer selector
`serve --persistent-data-block-api` serves only `/persistent-data-block-api-run`
and `/persistent-data-block.apk`.

The exact marker is:

```text
PERSISTENT-DATA-BLOCK-PASS class-shape named-null typed-null null-cast user-service seed-options immutable-empty
```

Paths below are relative to `S=/Users/alex/.local/state/vinix/android`.
Actual inputs were rehashed before pinning:

| Input | Path below S | SHA-256 |
| --- | --- | --- |
| Signed APK | `persistent-data-block-fixture-2026-10-30-r1/probe.apk` | `0acd05b909c7c2d3b798cb515a799df8c40263af9be1e7ab4334f7b4f113b7a8` |
| Framework JAR | `combined-account-webview-persistent-data-block-framework-2026-10-30-r1/api-impl.jar` | `7c1b2fa03924003c7717e07ef463bff81c6429c7667b2bc42d35954fb6d41752` |
| Native DSO | `current-native-build-2026-10-30-persistent-data-block-r1/native/libvinix-android-native.so` | `192411171dec072c89a64a81d8b35f36e92d060c75505fadceb47d683e9ed2e5` |

Runner selftests rejected 697 malformed, duplicate, mixed-profile and failure
cases, including 56 actual malformed-CLI refusals. Transfer selftests retain
pin/snapshot/binary/HTTP/deadline checks and add ten malformed-selector/port
refusals without output creation. Independent selector/marker review passed.
ELF inspection confirms a static AArch64 executable without an interpreter.
Historical profile values and routes remain unchanged.

All five checks passed sequentially with 600 MiB aggregate RSS, 300 seconds,
512 MiB observed shared-volume growth and 1 GiB reserve. Each guard recorded
child/guard exit zero and complete cleanup; timing reports recorded zero swaps.

| Check | Guard seconds | Sampled RSS bytes | Timing maximum bytes |
| --- | ---: | ---: | ---: |
| Host runner compile | 1.431 | 340017152 | 362921984 |
| Runner selftest | 0.536 | 35880960 | 34521088 |
| Static ARM runner compile | 1.798 | 357122048 | 367591424 |
| Host transfer compile | 1.581 | 353009664 | 386596864 |
| Transfer selftest | 0.583 | 8011776 | 9355264 |

The ARM runner is `S/persistent-data-block-api-run-2026-10-30-r1/run`, SHA-256
`7d5d99c7ece106a16fa1ffe277a909feb665744651c986e88d96780c025c4df0`.
The transfer is `S/persistent-data-block-api-transfer-build-2026-10-30-r1/transfer`,
SHA-256 `ef197629e197acb78b335977d3342999e1776e417ddc55ea609544dc37374396`.
Runner/transfer source hashes are respectively
`650789ec4774a17b3dbf49831c9a47db3ea1fcb7195ee2cf1bef0b793a17b72e`
and `fd4b451e4475b64bfc1a34cc31bdad645c107796fc10dec2837ef6765b1689e9`.
The captured checkout base is `94de43dd2893f68d8ec6bc46f678e13e108f58e5`;
exact changed sources, commands, input/tool hashes and checks remain in the
runner build, transfer build and transfer control roots.

The complete four-root, 33-entry seal and separate fresh-process readback
passed: `S/persistent-data-block-api-tools-sealed-2026-10-30-r1/manifest.json`,
SHA-256 `c27cca5c485498a5a5968bc38c36aa6ac04cf7dc3db20e3077dc8db88c533d79`.
Both retained 600 MiB RSS, 300 seconds, 64 MiB observed shared-volume growth and
1 GiB reserve, with exit zero and complete cleanup. All roots are closed.
This establishes host checks and static ARM readiness; ART execution, GMS
behavior and Google authentication require separate runtime evidence.
