# Bitmap drawable tiling media

This additive seven-file overlay deploys the qualified BitmapDrawable tiling
[framework/native pair](bitmap-tiles-pair-2026-10-30.md) over the sealed
persistent-data account image. It preserves the controller, broker, Google
companion APK/signature catalogs, browser authority and all unrelated deployment
inputs. The overlay replaces the framework JAR/DEX, coupled native DSO and four
headless/deployment receipts. It admits no extra file, service or authority.

The complete 2,106-class audit admits exactly BitmapDrawable's two changed
methods, seven added methods and three private fields. All 68 preceding native
classes remain equal; the new bridge adds BitmapDrawable as class 69. Complete
native audits preserve 88 sources, add exactly `bitmap_tiles.v`, verify the
single exact binding/generated-JNI append, and check all 90 input hashes and
the exact 718-to-719 export addition. The only native builder helper changes
are framework registration and its new provider. Producer inputs and all
unrelated generated JNI remain exact.

All 73 inherited complete inventories run again in both audit phases. The new
wrapper uses sorted, disjoint 64+9 batches with exact union and unchanged
two-worker/64-job helpers; the historical 70-root wrapper remains exact. The
base plus new framework/native roots give 76 dependency seals. All 32 inherited
modules are checked before and after installation, with new-module readback
making 33. Only this profile's local audit limit becomes 33; all 65 digest
receipts are charged against the unchanged internal 512 MiB write budget.

The frozen kernel uses a `u64` count and module pointer array and enumerates
every response module in `kernel/initramfs/initramfs.v:438-455`; it has no
32-module cap. This is confirmed in the retained
`pidfd-wait-kernel-build-2026-10-26-r1/kernel-aarch64-r2/source` tree. No matching
bootloader-source provenance is claimed. A real 33-module boot remains required.

Artifacts are outside Git beneath `/Users/alex/.local/state/vinix/android` (`S`):

| Bundle | Manifest SHA-256 |
| --- | --- |
| `maps-persistent-data-block-r1` | `6a170ca8049800d72852cf56dab5754880ffccd256ab3142defbeb2f400058d8` |
| `combined-account-webview-bitmap-tiles-framework-2026-10-30-r1` | `bf8626569c82826e4d6b6379a3e2266741db3d2919d2eda4cf647b18c5b5f7df` |
| `current-native-build-2026-10-30-bitmap-tiles-r1` | `f4c9ab784fc630803ffb81554ec120aca8706ef4ce29751a0be25a84eb9e692e` |

Media qualification is `S/maps-bitmap-tiles-tools-2026-10-30-r1` (`Q`);
focused batch results are `S/maps-bitmap-inventory-batches-tests-2026-10-30-r1`
(`T`). The source base at freeze is
`5a6cb656a42c0e3427982678667ed4eb0ff1dc20`; exact hashes below identify the changes.
Serial V C-project generation and the exact emitted C compiler commands passed
for all three tools. Fresh self-tests, every historical/new patcher profile and
FAT fixture, the complete framework/native audit and helper enumeration passed.
All five focused batch tests passed with live assertions, including real
65/70/73-root inventories, repeated-byte checks and joined failure paths.

Post-build imported V and actual C preprocessor discovery captured 855 inputs
with before/copy/after verification, including test sources and generated
projects. This is post-build provenance; host SDK/system libraries are not
claimed hermetic. Final build/test/audit caps remain 600 MiB aggregate RSS,
300 seconds, 512 MiB observed growth and 1 GiB reserve. Every final guard/child
exited zero with complete cleanup and zero reported swaps. Largest sampled RSS
was 392,232,960 bytes; largest `time -l` maximum was 396,623,872 bytes.

An initial authoring-helper compile and initial test C-generation invocation
omitted explicit RSS and used the guard's 2 GiB default. Their original controls
remain preserved. Fresh test generation, C compilation and execution used the
original explicit 600 MiB cap; only those outputs qualify. The authoring helper
is not a production tool. No relaxed-cap artifact is deployed.

| Qualified artifact | SHA-256 |
| --- | --- |
| Stager source | `7b5d8c03a16b7b843cad2e47598413b2684caaa747633f895ae21c409d280fe9` |
| Patcher source | `4e7946f222c54b88bd8a96d8299d765177b4bae37e970ce1eac8b844a84fbfc8` |
| Discovery helper source | `f2cc9306f3c0af8f26105330310b3151643a5387fb590e50673e76a0d04f1645` |
| `Q/stager-project/maps-bitmap-tiles-stage` | `2d236d65f03d17b49ad8380ad82f9da79493cefb303516c095308f917ee6370b` |
| `Q/patcher-project/patch-kernel` | `3be63faa312f10088735076b3f920d777c58f08bab4b0a5aadb200fff4091107` |
| `Q/header-helper-project/media-stage-inputs` | `273e93c4bd3cc979a73d455928d2561d63eba98db22b44ce769916ab14c452e6` |

The three closed roots `Q`, `T` and `S/bitmap-media-edit-2026-10-30-r1` passed
complete sealing and separate full readback: 2,208 entries,
`S/maps-bitmap-tiles-tools-sealed-2026-10-30-r1/sealed/manifest.json`, SHA-256
`e085030f0b7ae12eeaff745e2bedc84814b20609dfe9591ac416f3efa99308b7`.
Both guards retained 600 MiB RSS, 900 seconds, 64 MiB observed growth and 1 GiB
reserve and exited zero with complete cleanup and zero swaps. Preserve every
original complete bundle and its auditors.

Prepare with `Q/stager-project/maps-bitmap-tiles-stage --prepare
S/maps-bitmap-tiles-r1`. After a fresh clone, install the frozen kernel using
`Q/patcher-project/patch-kernel --maps-bitmap-tiles FRESH_STAGE
FROZEN_KERNEL_BUILD BUILD_JSON_SHA256`. Preparation retains the original
600 MiB/900-second/4 GiB growth/1 GiB reserve outer caps and internal 512 MiB
budget. ARM regression and Google's real account UI remain pending.
