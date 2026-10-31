# User restriction fixture tools, 2026-10-31

`onboarding-api-run.v --user-restrictions` selects the signed UserManager
snapshot and virtual boolean-query regression on the exact new framework and
retained native library below. Protected inputs, principal isolation, six pins,
eleven receipt checks, bounded child lifetime, exact PASS/READY counts and clean
exit remain unchanged. The fixture covers the unmanaged base and supplied backend
controls; policy enforcement, GMS and Google authentication are outside its scope.

Transfer selector `serve --user-restrictions-api` serves exactly two new routes:
`/user-restrictions-api-run` and `/user-restrictions.apk`. Historical pins/routes
are retained. The exact marker is:

```text
USER-RESTRICTIONS-PASS fresh-snapshots bundle-truth virtual-backend mutation-isolation exceptions context-controls
```

All paths below are relative to `S=/Users/alex/.local/state/vinix/android`.
Inputs were rehashed before pinning; the new SDK is the complete r3 production.

| Input | Path below S | SHA-256 |
| --- | --- | --- |
| Signed APK | `user-restrictions-fixture-2026-10-30-r1/probe.apk` | `19f8715bcc6e5f19dff1dc11e031912907d7c762a7f1927b85dda697f447dbea` |
| Framework JAR | `combined-account-webview-user-restrictions-framework-2026-10-31-r3/api-impl.jar` | `646a83ea74795fb29b4db8811fc3249add3693b6e2de03e043c52e4e13b09bdc` |
| Retained native DSO | `current-native-build-2026-10-30-layout-alignment-r1/native/libvinix-android-native.so` | `b6aeb06b7473220da8844015a253ed87394fef6209173c14317fcbaf19141e95` |

Runner selftests rejected 1,147 malformed, duplicate, mixed-profile and failure
cases, including 91 actual malformed-CLI refusals. Transfer retains bounded
snapshot, pin, binary HTTP, traversal, request/deadline controls and adds ten
new selector/port refusals without output creation. ELF inspection confirms
AArch64 EXEC without an interpreter. Independent mapping review verified actual
artifacts, exact marker/selectors/routes and preserved isolation.

The first r1 host compile passed, but selftest caught the new fixture marker
missing from the existing conflicting-marker guard. The source now rejects it
for other profiles. Original source, binary, failed receipt/log and empty r1
transfer directories remain unchanged. Fresh r2 reran all five required checks
successfully. No failure was repaired or historical check relaxed.

| Final r2 check | Guard seconds | Sampled aggregate RSS bytes | Time maximum bytes |
| --- | ---: | ---: | ---: |
| Host runner compile | 2.821 | 340,148,224 | 361,381,888 |
| Runner selftest | 0.942 | 20,725,760 | 17,727,488 |
| Static ARM runner compile | 3.494 | 374,849,536 | 359,628,800 |
| Host transfer compile | 3.739 | 366,215,168 | 377,667,584 |
| Transfer selftest | 1.125 | 10,485,760 | 9,306,112 |

Final guards and children exited zero with complete cleanup and zero swaps under
unchanged 600 MiB aggregate RSS, 300-second, 512 MiB shared-growth, 1 GiB reserve
and file-size caps. Actual ARM execution and native/SDK deployment compatibility
are separate checks; this host qualification makes no runtime or login claim.

Qualified runner `S/user-restrictions-api-run-2026-10-31-r2/run` has SHA-256
`b17eec119da181bc0be8ca04351d895deb600104907bf21d8cbb7231ce415fbe`.
Transfer `S/user-restrictions-api-transfer-build-2026-10-31-r2/transfer` has
SHA-256 `33f8de74415619a8a7659478978ad0bc9ab35b3021ed8a7d51cfb7e4686268a3`.
Runner/transfer source hashes are respectively
`282e7246aa4ce3cf3555ddfbfc955aae7b0ae1149dea02592ae722dbe9297434` and
`1f038fcadb89926c42ee754c6ebab328c9ed3754039717066261d502e212c495`.
Captured source base is `02c10fb01e0dfcd08b877e36ea26f8f2e4dcb2fa`; complete
source snapshots, artifact/tool pins, commands and logs are retained.

All eight original r1/r2 run/build/transfer/control roots are closed. Complete
sealing and separate fresh-process full readback passed for 48 entries at
`S/user-restrictions-api-tools-sealed-2026-10-31-r2/manifest.json`, SHA-256
`eb193ec11387aaea74d5e1c8c86a88306c480a58437d4296eda87b969146193c`.
Both guard/child exits were zero with cleanup complete and zero swaps under the
same 600 MiB/300-second/64 MiB growth/1 GiB reserve audit caps. Preserve all
original complete bundles and failed controls.
