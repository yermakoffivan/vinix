# Resources float media

This seven-file overlay deploys the qualified Resources.getFloat API and its
coupled native library over the immutable Bundle/CrossProfileApps image.
API source `c01f167cf` adds one typed getter; existing Resources methods,
reference resolution and neighboring classes remain unchanged. Native builder
`b2aad79ed` separates host V generation from C compilation to preserve the
600 MiB cap. ARM execution and the real Maps profile retry remain separate.

The complete 2,107-class audit allows only the added Resources getter. Native
compatibility is checked against the original Layout SDK/native producer,
independently from the immediate Bundle SDK parent. Of all 69 consumed classes,
Resources is the sole canonical change; raw Resources and the fixed Layout
formatting pair are the only differences. All 89 native sources, 90 inputs,
generated JNI/C, headers and 719 exports remain exact. The tool-source closure
permits only the reviewed builder/registration replacements and four added
providers. The five-file prefix-map proof uses the actual successor command and
reproduces the entire original `b6aeb06b...` DSO; no native implementation change
or authentication claim is made.

Artifacts remain under `/Users/alex/.local/state/vinix/android` (`S`):

| Producer | Manifest SHA-256 |
| --- | --- |
| `maps-bundle-cross-profile-r1` | `03e847ea0b37729b04a9794294b8d39f1c8e5db96d5ab08868f2775312c16631` |
| `combined-account-webview-resources-float-framework-2026-10-31-r1` | `b88ea5adb85e7b5ea6ff70cdd7310fbb039e1922c4d3467b35ce6f71ebd0d38f` |
| Native origin SDK: `combined-account-webview-layout-alignment-framework-2026-10-30-r1` | `1266de2e0a64d876e3559240fe5596ad67d9f2cfce81bd0e1e727675c0d39e00` |
| Native origin: `current-native-build-2026-10-30-layout-alignment-r1` | `ad1c44a5ac2f06925c19c02648d837263a9f1aa9661735b9e49e958193b80413` |
| Successor: `current-native-build-2026-11-01-resources-float-r2` | `c8a7134531f5fdfb6a8e484537a4eb798564fb039760ae9f82cc9a2045ba3062` |

Both preparation phases reread all 86 inherited inventories in sorted disjoint
64+22 batches with the unchanged two-worker/64-job helper. The new profile
requires 89 dependency seals plus five exact proof leaves, preserves all 37
inherited modules and adds module 38. The original internal 512 MiB write budget
charges all digest receipts. The executable DSO and six framework/deployment
files form the complete overlay; broker/controller/Vending/registry remain pinned.

Qualification roots are `S/maps-resources-float-tools-2026-11-01-r1` (`Q`) and
`S/maps-resources-float-inventory-batches-tests-2026-11-01-r1`. Exact86 tests,
three split tool builds, stager self-tests/full artifact audit, all historical
and new patcher profile/FAT checks, actual header discovery and 855-input
original/copy/recheck capture passed. Independent source and final artifact
readback reviews passed. All 23 recorded guard/child executions exited zero
with complete cleanup. Maximum sampled RSS was 432,308,224 bytes; recorded process
swaps were zero. A guard setup invocation rejected logs inside the generated
root before launching a child; its complete attempted argv/output are preserved
in `Q/setup-refusal-01.txt`. Correcting the root required no code or limit change.
Host SDK/system-library hermeticity is not claimed.

| Qualified executable | SHA-256 |
| --- | --- |
| `Q/stager-project/maps-resources-float-stage` | `94db559398f584a8be9bb98e1456b2f145c53d30549e31d3bca838e7da9acb3b` |
| `Q/patcher-project/patch-kernel` | `98cc88708c56411c9caf27505107b343301dbe24664e8d386a16c4311fafbe92` |
| `Q/header-helper-project/media-stage-inputs` | `7b7aa00d66d53d4bbd85b55c8b9c51d520d3b24f205bbaa4f1a0a55dc7573514` |

The two closed roots passed sealing and separate fresh-process full readback,
4,259 entries, `S/maps-resources-float-tools-sealed-2026-11-01-r1/sealed/manifest.json`,
SHA-256 `1499f530ce6fb6f397422039748232f5c664ce255256f7fa329a2ec2fb4ebbd5`.
Seal/readback took 0.506/0.253 seconds, sampled RSS 22,740,992/22,872,064 bytes;
both guards/children exited zero with complete cleanup and zero recorded swaps.
Original limits remain 600 MiB RSS, build/test 300 seconds (audit 900), 1 GiB
reserve, 512 MiB build growth and 64 MiB seal growth, with the same file-size cap.
Keep the original complete bundles, failed native controls and historical auditors.

Prepare with `Q/stager-project/maps-resources-float-stage --prepare
S/maps-resources-float-r1`, then clone and install the frozen kernel using
`Q/patcher-project/patch-kernel --maps-resources-float FRESH_STAGE
FROZEN_KERNEL_BUILD BUILD_JSON_SHA256`. Image preparation retains the original
600 MiB/900-second/4 GiB outer-growth/1 GiB-reserve caps and internal write budget.
