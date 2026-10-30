# Layout getter fixture tools, 2026-10-30

`onboarding-api-run.v --layout-alignment` selects the signed Layout alignment and
additive-spacing getter regression on its exact new framework/native pair.
Its assertions cover nullable enum identity through constructors, spacing bits
and retained Builder behavior. Text layout rendering, GMS and authentication are
outside its scope. Protected inputs, principal isolation, six input pins, eleven
receipt checks, bounded child lifetime, one exact PASS/READY and clean exit are
unchanged.

Transfer selector `serve --layout-alignment-api` serves only
`/layout-alignment-api-run` and `/layout-alignment.apk`. Historical profile pins
and routes remain intact. The exact marker is:

```text
LAYOUT-ALIGNMENT-PASS enums nullable constructors identity spacing-bits builder-retained
```

Inputs were rehashed before pinning. Paths below are relative to
`S=/Users/alex/.local/state/vinix/android`:

| Input | Path below S | SHA-256 |
| --- | --- | --- |
| Signed APK | `layout-alignment-fixture-2026-10-30-r1/probe.apk` | `d0a5f8524c5d135cce08705946d72487947b637b0d7c1c7fa77994a323111fd6` |
| Framework JAR | `combined-account-webview-layout-alignment-framework-2026-10-30-r1/api-impl.jar` | `162c77f853e6cb85f373493c40c302ff4df5b90ed52f2e6dce961e5e17281d01` |
| Actual coupled native DSO | `current-native-build-2026-10-30-layout-alignment-r1/native/libvinix-android-native.so` | `b6aeb06b7473220da8844015a253ed87394fef6209173c14317fcbaf19141e95` |

Runner selftests rejected 1,049 malformed, duplicate, mixed-profile and failure
cases, including 84 actual malformed-CLI refusals. Transfer tests retain
pin/snapshot/binary/HTTP/deadline checks and add ten malformed-selector/port
refusals without output creation. ELF inspection confirms a static AArch64
executable without an interpreter. Independent mapping review checks exact
selectors/pins/marker and unchanged isolation. ARM results require execution.

All five checks passed sequentially under the original 600 MiB aggregate RSS,
300-second, 512 MiB observed shared-growth and 1 GiB reserve caps. Each guard
and child exited zero with complete cleanup; timing reports recorded zero swaps.

| Check | Guard seconds | Sampled RSS bytes | Time maximum bytes |
| --- | ---: | ---: | ---: |
| Host runner compile | 2.330 | 349,290,496 | 365,854,720 |
| Runner selftest | 1.040 | 19,103,744 | 17,743,872 |
| Static ARM runner compile | 3.022 | 371,965,952 | 373,047,296 |
| Host transfer compile | 2.236 | 369,967,104 | 402,456,576 |
| Transfer selftest | 0.838 | 9,601,024 | 9,306,112 |

Runner `S/layout-alignment-api-run-2026-10-30-r1/run` has SHA-256
`45d4bc546ce4bbb3e30a9ac6bec9c1a88f006647de33e30ba7be942215ef01c8`.
Transfer `S/layout-alignment-api-transfer-build-2026-10-30-r1/transfer` has
SHA-256 `350aa90c940739aaf2e4ae74d6f01a9b9a870401521d0b913e4b81139230e1fc`.
Runner/transfer source hashes are respectively
`d67a28d525df10a838b6a1d6b8e6933805de780c5f7afced5909e2a8f3fe212c` and
`a014466bcd5fd078282c234be7d0f1c6c200edf4cc3bc27ce54cd7fe510778a6`.
The captured source base is `0051bcf557cea78a1aa7f6ba81c46618db4552b6`;
complete source snapshots, commands, runtime/tool hashes and logs are retained.

All four original run/build/transfer/control roots are closed. Complete sealing
and separate fresh-process full readback passed for 34 entries at
`S/layout-alignment-api-tools-sealed-2026-10-30-r1/manifest.json`, SHA-256
`33631ee57b518b922df0950ae648f5e2b1eb578045e3451a52c3bf4047a101d6`.
Both retain 600 MiB RSS, 300 seconds, 64 MiB observed growth and 1 GiB reserve,
with child/guard exit zero and complete cleanup. Retain all original bundles.
