# Resources float fixture tools, 2026-11-01

The dedicated `--resources-float` runner profile pins the signed Resources
fixture to the completed framework and coupled native library. The new
`serve --resources-float-api` transfer mode serves exactly two routes:
`/resources-float-api-run` and `/resources-float.apk`. All historical profiles,
pins and routes remain unchanged. Only the new marker's conflict recognition
is added to generic health checks; no exception or fatal check is relaxed.

The marker is exactly:

```text
RESOURCES-FLOAT-PASS packaged-floats aliases strict-types virtual-lookup raw-bits unchanged-values failures
```

Protected inputs, separate Unix identity/data, six input pins, eleven receipt
checks, descriptor closure, bounded child lifetime, exact PASS/READY, complete
drain and clean child exit remain required. These host checks establish no ARM
fixture, Maps UI, imagery, Play Services or authentication result.

Paths are below `S=/Users/alex/.local/state/vinix/android`:

| Input | Path below S | SHA-256 |
| --- | --- | --- |
| Framework | `combined-account-webview-resources-float-framework-2026-10-31-r1/api-impl.jar` | `aac12a41b70ce34c0893580431a28de81cb3476e7c6833cbe0c0ca8596db677d` |
| Coupled native | `current-native-build-2026-11-01-resources-float-r2/native/libvinix-android-native.so` | `441ae035ec4b69c36635cc4521af3fafcb6a867305b0ba25d6e55df7ff0dadc9` |
| Signed fixture | `resources-float-fixture-2026-10-31-r1/probe.apk` | `59439180e4b2bff8c533689db5e4f6ba121406a3cb4950b3746f170a960a7d93` |

All five required checks passed on the first November 1 attempt. Runner tests
rejected 1,461 malformed, mixed and failure cases. Transfer tests cover its
new selector/port refusals together with retained pinned snapshots, exact
binary HTTP, traversal, request limits and absolute deadlines. ELF inspection
confirms AArch64 EXEC with no interpreter. Independent source and final
artifact/pin/guard reviews passed. Runtime execution remains a separate check.

| Check | Guard seconds | Sampled aggregate RSS bytes | Time maximum bytes |
| --- | ---: | ---: | ---: |
| Host runner compile | 3.134 | 358,236,160 | 371,064,832 |
| Runner selftest | 1.066 | 21,741,568 | 17,743,872 |
| Static ARM runner compile | 2.915 | 368,738,304 | 373,309,440 |
| Host transfer compile | 3.549 | 368,017,408 | 373,571,584 |
| Transfer selftest | 1.112 | 10,420,224 | 9,240,576 |

Every guard/child exited zero with complete cleanup and zero swaps under the
unchanged 600 MiB aggregate RSS, 300-second, 512 MiB shared-growth, 1 GiB reserve
and file-size caps. Runtime inputs were rehashed after qualification and source
copies compared exactly to the checkout. Prior October 31 empty setup roots
remain untouched; the fresh November 1 outputs contain the admitted tools.

ARM runner `S/resources-float-api-run-2026-11-01-r1/run` has SHA-256
`dbe6ed9779facb8de3257eaf76b0420ac6a60f777af7575dacfb6a1ac35d04f9`.
Transfer `S/resources-float-api-transfer-build-2026-11-01-r1/transfer` has SHA-256
`d7c257e282114331b7ba668fcfe1739f58586d7c99fac39a30f37df86fbe8d04`.
Captured source base is `bf587779a90f820b5ca89bfa9dfe083cf0c8add0`; runner and
transfer source hashes are respectively
`3ad44be4db548e84d0fd8825b25cb5e1274f110c9dcd0fb4de0e8270aad18292`
and `49704648b7645d6e9cf613c360dce96c06cda8d426a64f27c0463eeae86a88ff`.

Four complete original tool/control roots are closed. Complete sealing and a
separate fresh-process full readback passed for 34 entries at
`S/resources-float-api-tools-sealed-2026-11-01-r1/manifest.json`, SHA-256
`ef90fd836260a2b0c976cab59bd41dc655d97a094aec42884ae63a9b3c3e1c85`.
Seal/readback took 0.098/0.254 seconds with original 600 MiB/300-second/64 MiB
shared-growth/1 GiB reserve/file caps, zero guard/child exits, complete cleanup
and zero swaps. Preserve the original complete bundles and historical auditors.
