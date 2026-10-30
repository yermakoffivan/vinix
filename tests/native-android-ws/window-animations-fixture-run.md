# Window animation attribute fixture tools, 2026-10-30

`onboarding-api-run.v --window-animations` selects the signed Window resource
attribute and callback regression on its exact new framework/native pair.
It checks attributes aliasing, repeated/reset calls, callback dispatch,
reentrancy, exception identity and Activity/Dialog controls. It does not claim
execution of visual animation resources, GMS behavior or authentication.
Existing protected inputs, principal isolation, six pinned inputs, eleven receipt
checks, bounded child lifetime, one exact PASS/READY and clean exit remain intact.

Transfer selector `serve --window-animations-api` serves only
`/window-animations-api-run` and `/window-animations.apk`. All historical profile
pins and routes remain unchanged. The exact marker is:

```text
WINDOW-ANIMATIONS-PASS attributes alias always-dispatch callbacks reentrancy exceptions activity dialog
```

Actual inputs were rehashed before pinning. Paths below are relative to
`S=/Users/alex/.local/state/vinix/android`:

| Input | Path below S | SHA-256 |
| --- | --- | --- |
| Signed APK | `window-animations-fixture-2026-10-30-r1/probe.apk` | `b78a43516d2f5f42ec7686c39acd81b3612402d80eb25ccd854de512fd6119a6` |
| Framework JAR | `combined-account-webview-window-animations-framework-2026-10-30-r1/api-impl.jar` | `255718e8a943f8d3e276f99694c52ed5ec39af86d5d06abef3c9b14d7b9aa197` |
| Actual coupled native DSO | `current-native-build-2026-10-30-window-animations-r1/native/libvinix-android-native.so` | `a1f27a68285dfe6d5cef34ad077bde7537ee41c136fd40d82ad42e14097377ba` |

Runner selftests rejected 955 malformed, duplicate, mixed-profile and failure
cases, including 77 actual malformed-CLI refusals. Transfer tests retain
pin/snapshot/binary/HTTP/deadline checks and add ten malformed-selector/port
refusals without output creation. ELF inspection confirms a static AArch64
executable without an interpreter. Independent mapping review checks selectors,
exact pins/marker and unchanged isolation. Actual ARM results require execution.

Five checks passed sequentially with the original 600 MiB aggregate RSS,
300-second, 512 MiB observed shared-growth and 1 GiB reserve caps. Each guard
and child exited zero with complete cleanup; timing reports recorded zero swaps.

| Check | Guard seconds | Sampled RSS bytes | Time maximum bytes |
| --- | ---: | ---: | ---: |
| Host runner compile | 2.182 | 343,818,240 | 361,250,816 |
| Runner selftest | 0.796 | 20,267,008 | 17,711,104 |
| Static ARM runner compile | 3.562 | 366,428,160 | 361,758,720 |
| Host transfer compile | 1.529 | 372,113,408 | 395,427,840 |
| Transfer selftest | 0.615 | 9,306,112 | 9,338,880 |

Runner `S/window-animations-api-run-2026-10-30-r1/run` has SHA-256
`050cef8a7a79ea5c1a1b460ad539b72234de936b983ae85210d529bdabb382cc`.
Transfer `S/window-animations-api-transfer-build-2026-10-30-r1/transfer` has
SHA-256 `cf8655309ed22fa16d3ea0a6b4df4e064f4a29e84b1f21758019741bf87602a7`.
Runner/transfer source hashes are respectively
`438461813b1376ccfbdd80691a7509e5b515a659b9ba950ce1d0cf0eb3a74d7d` and
`3b66b662a42bb1c69945873850b89d8b05d1c5e0359b7857de5049218a17cca6`.
The captured source base is `fece1c04fbc25a09bc919b32f468a3f7cafb5bf3`;
complete source snapshots, commands, runtime/tool hashes and logs are retained.

All four original run/build/transfer/control roots are closed. Complete sealing
and separate fresh-process full readback passed for 34 entries at
`S/window-animations-api-tools-sealed-2026-10-30-r1/manifest.json`, SHA-256
`313cc7a994a853dd162da0d2e9fd9c6f7ecef752772a05c238f91a98f2c9058a`.
Both preserve 600 MiB RSS, 300 seconds, 64 MiB observed growth and 1 GiB reserve,
with child/guard exit zero and complete cleanup. Retain all original bundles.
