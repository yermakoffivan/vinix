# Layout getter framework/native pair, 2026-10-30

The complete framework and fresh AArch64 native producer passed. Both manifests
record revision `0051bcf557cea78a1aa7f6ba81c46618db4552b6`, containing SDK fix
`74968571b` and [producer profile](layout-alignment-producer-profile-2026-10-30.md)
`645e92262`. All 2,106 framework classes remain present. Layout alone gains
public/final `getAlignment()` and correctly spelled `getSpacingAdd()` methods,
reading its existing stored fields. Every existing method and field, including
the legacy `getSpacing_add` and retained Builder behavior, remains unchanged.

The complete predecessor canonical map equals the new baseline map. Full final
DEX comparison changes only Layout; all other classes and non-DEX JAR payloads
remain equal. The native-consumed membership stays 69 classes. Layout has the
only canonical/API delta. Four raw files differ: its two appended methods and
exact canonicalization-only pairs for the preceding Window, Activity and Dialog
source text. No other consumed raw class changes.

All 89 native V sources, the complete 90-input native production map, generated
JNI V, generated C and all 719 exports are byte-identical to the Window pair.
The actual DSO is pinned as
`b6aeb06b7473220da8844015a253ed87394fef6209173c14317fcbaf19141e95`.
Its embedded STB assertion paths reflect the new physical build root. A separate
guarded relink adds only the exact file-prefix mapping to the preceding Window
root, with a fresh output path. It recreates the entire previous DSO byte-for-byte:
`a1f27a68285dfe6d5cef34ad077bde7537ee41c136fd40d82ad42e14097377ba`.
The original producer and historical checkers remain unchanged. Deployment
selects the actual new DSO; the relink establishes the path-only provenance difference.

The relink proof retains exactly five files: original compiler command, explicit
physical input pins, guard receipt/log and canonical DSO. The new media profile
validates their full inventory, original guard limits, exact flag-only argv and
physical input hashes, and records them as host inputs. It adds no proof boot
module or inherited producer manifest.

Complete closed roots under `/Users/alex/.local/state/vinix/android` are:

- `layout-alignment-framework-builder-2026-10-30-r1`.
- `combined-account-webview-layout-alignment-framework-2026-10-30-r1`.
- `layout-alignment-native-controls-2026-10-30-r1`.
- `current-native-build-2026-10-30-layout-alignment-r1`.
- `layout-alignment-prefix-map-proof-2026-10-30-r1`.

All five roots passed sealing and independent fresh-process complete readback:
9,272 entries at
`/Users/alex/.local/state/vinix/android/layout-alignment-producers-sealed-2026-10-30-r1/sealed/manifest.json`,
SHA-256 `29da036c66085ff62df0cdf668bc139afced87ee6386adf3f13ebd959ca314c0`.
All attempts within these five roots passed.

| Phase | Guard seconds | Sampled aggregate RSS bytes |
| --- | ---: | ---: |
| Builder compile | 2.685 | 350,109,696 |
| Complete producer self-tests | 0.269 | 1,245,184 |
| Complete framework | 75.095 | 505,331,712 |
| Fresh coupled native | 45.054 | 623,624,192 |
| Independent path-mapped relink | 9.486 | 374,243,328 |
| Complete five-root seal | 0.979 | 17,678,336 |
| Independent complete readback | 1.111 | 23,920,640 |

All guard/child exits were zero with complete cleanup and zero reported swaps.
The original 629,145,600-byte RSS cap and 1 GiB reserve remain enforced.
Qualification/proof retain 300 seconds/512 MiB observed growth, production retains
300 seconds/1 GiB, and sealing/readback retain 900 seconds/64 MiB. ARM fixture
execution and the live Maps avatar transition remain separate runtime checks.

| Artifact | SHA-256 |
| --- | --- |
| Framework manifest | `1266de2e0a64d876e3559240fe5596ad67d9f2cfce81bd0e1e727675c0d39e00` |
| Framework build receipt | `acc60b4b6080503a1707139f710a38afb446f3d9f056a65f14e151ac80ae7b7a` |
| Framework JAR | `162c77f853e6cb85f373493c40c302ff4df5b90ed52f2e6dce961e5e17281d01` |
| Framework DEX | `0a8db55273af20489ef65f7e0edc5b007fe2e4c109065ea7450df4f072fcd1e8` |
| Native manifest | `ad1c44a5ac2f06925c19c02648d837263a9f1aa9661735b9e49e958193b80413` |
| Native build receipt | `e6d7ca1b38a82b2f7a15b018a1fef294356693207993c0966b6f291073967a0d` |
| Actual native DSO | `b6aeb06b7473220da8844015a253ed87394fef6209173c14317fcbaf19141e95` |
| Generated JNI V | `256807c4a8ff63a2e86cd726bf9782ac93ffa1a6b22ca3edcff6bcc4b6b118c7` |
| Generated C | `b6f64efd407923433f2a0591f3a0cd6147a3da4372b93c3c9b091d3d912e3154` |
