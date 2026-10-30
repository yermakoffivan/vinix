# Layout stored-state getter media

This seven-file overlay deploys the qualified
[Layout getter pair](layout-alignment-pair-2026-10-30.md) over the immutable
Window attribute image. The only SDK change is adding public final
`getAlignment()` and `getSpacingAdd()` to the existing Layout class, returning
its stored fields. Every prior method, field, class and Builder behavior stays
unchanged. ARM regression and the real Maps avatar still require a fresh run.

The complete 2,106-class audit checks that exact two-method addition. Native
membership stays 69 classes: Layout is the sole canonical API change; four raw
pairs include the exact inherited Window/Activity/Dialog formatting changes.
All 89 production-native sources, 90 inputs, generated JNI/C and 719 exports
remain byte-identical. The actual DSO differs in embedded STB source paths;
the existing five-file flag-only relink proof reproduces the entire preceding
Window DSO and validates exact physical inputs, argv, guard limits and outputs.
No native producer or production-native source changes are admitted.

Both phases reread all 79 inherited inventories through sorted, disjoint 64+15
batches with exact union and unchanged two-worker/64-job helpers. Prior wrappers
remain exact. The profile pins 82 dependency seals plus five new proof leaves;
old proof leaves remain in their original historical bundles. All 34 inherited
modules are checked before/after installation; new readback includes module35.
All 69 digest receipts are charged to the original 512 MiB internal write budget.
Controller, broker, browser, Google companion catalogs/signatures and unrelated
deployment inputs remain pinned.

Artifacts are under `/Users/alex/.local/state/vinix/android` (`S`), outside Git:

| Bundle | Manifest SHA-256 |
| --- | --- |
| `maps-window-animations-r1` | `054ecabdaf7bf238b254e51cefd9c9f68c027b5255d425a3b595b07f99d0017a` |
| `combined-account-webview-layout-alignment-framework-2026-10-30-r1` | `1266de2e0a64d876e3559240fe5596ad67d9f2cfce81bd0e1e727675c0d39e00` |
| `current-native-build-2026-10-30-layout-alignment-r1` | `ad1c44a5ac2f06925c19c02648d837263a9f1aa9661735b9e49e958193b80413` |

Qualification is `S/maps-layout-alignment-tools-2026-10-30-r1` (`Q`), source base
`0051bcf557cea78a1aa7f6ba81c46618db4552b6`. Serial V generation/exact emitted C
compilation passed for all three tools. Required stager tests, all historical/new
patcher/FAT tests, complete real pair/proof audits and helper enumeration passed
on their first attempts. All five focused batch tests passed, including real
65/70/73/76/79-root rereads, mutations and failure joins with live assertions.

The existing post-build V/C-header capture verified 855 inputs before/copy/after;
host SDK/system-library hermeticity is not claimed. Original build/test/audit
caps stayed 600 MiB aggregate RSS,300 seconds,512 MiB growth and1 GiB reserve.
Every final guard/child exited zero with complete cleanup and zero reported
swaps. Largest sampled RSS was413,761,536 bytes; largest `time -l` maximum was
407,322,624 bytes.

| Qualified artifact | SHA-256 |
| --- | --- |
| Stager source | `d9bc0a8bb9e4f5cec9cb3c05831fbca6ff83707a81aa4e28d7e798bdec149a7e` |
| Patcher source | `57314741fb269a859d9df12b88efa22cf663eeadf2cd32f455ea2e7336567700` |
| `Q/stager-project/maps-layout-alignment-stage` | `f2bbc35c3600140387c97b8daa764d27e64fbfcbbbcbfc1614cc1b3ffcf77909` |
| `Q/patcher-project/patch-kernel` | `d0cc8641d8915aa9eb5100ecb0d68a2c3b8e1ac6ae14cc4b1b50156b662bf74e` |
| `Q/header-helper-project/media-stage-inputs` | `426be6b521fd96d1275f107685fdc155ca5ea88b827fb0b9fdbc757a41e3a72e` |

Three closed roots (`Q`, the matching inventory-batches test root, and original
`S/layout-alignment-prefix-map-proof-2026-10-30-r1`) passed complete seal and
separate readback:2,982 entries,
`S/maps-layout-alignment-tools-sealed-2026-10-30-r1/sealed/manifest.json`, SHA-256
`09827750f870280fc4e2d15052408bc1b9f021838ac3c8502ff3305ceb250a2d`.
Original600 MiB/900-second/64 MiB-growth/1 GiB-reserve guards passed with complete
cleanup and zero swaps. Preserve all original complete bundles and auditors.

Prepare with `Q/stager-project/maps-layout-alignment-stage --prepare
S/maps-layout-alignment-r1`. After a fresh clone, use `Q/patcher-project/patch-kernel
--maps-layout-alignment FRESH_STAGE FROZEN_KERNEL_BUILD BUILD_JSON_SHA256`.
Preparation retains original600 MiB/900-second/4 GiB-growth/1 GiB-reserve outer
caps plus the unchanged internal512 MiB write budget.
