# Bitmap drawable framework/native pair, 2026-10-30

The complete framework and fresh coupled AArch64 native library passed for
`5a6cb656a42c0e3427982678667ed4eb0ff1dc20`. Both production manifests record
that source revision. The [additive producer profile](bitmap-tiles-producer-profile-2026-10-30.md)
retains the pinned persistent-data framework and its complete 2,106-class set.

BitmapDrawable is the only changed framework class: two methods replaced,
seven added and three private fields added. It retains nullable per-axis tile
modes and one Paint; the drawing bridge receives strong Bitmap/Paint references
through JNI. Explicit member/flag checks run before assembly and after complete
DEX disassembly, including the public/final Y setter and declaration-only private
static native bridge. Every other class and non-DEX JAR payload is preserved.

The native producer restores the retained old-276 compiler/library inputs,
freezes complete source closures, generates JNI from copied classes and passes
the AArch64 `-Werror` shared link and full export inventory. The predecessor's
88 native source files remain, with one `bitmap_tiles.v` added and one binding
appended. The native-consumed class set grows from 68 to 69 by adding
BitmapDrawable; the export inventory grows from 718 to 719 by adding its tiling
bridge. The final generated V appends `ws_binding_630` with strong object
arguments and pending-exception/null checks. Existing native window guards remain
present. Focused [SDK/fixture](bitmap-tiles-host-2026-10-30.md) and
[actual native source tests](bitmap-tiles-native-host-2026-10-30.md) have separate
complete evidence bundles. This report establishes production artifacts;
ARM pixel assertions and the real account screen still require runtime checks.

Independent read-only review confirmed the complete class/source/input/export
comparisons and exact generated V append. The full generated C adds the bridge,
two sampler functions and declarations; six existing compiler-generated loop
counter names change without changing their bounds, uses or bodies. The review
also checked deferred Canvas TLS restoration and alias-copy release. Its closed
single-file notes bundle is
`/Users/alex/.local/state/vinix/android/bitmap-tiles-independent-review-2026-10-30-r1/review.md`,
SHA-256 `966bcccfb2f2ee4ba8e93615e082891b831c9a833721ca89b70aa78db91abdb9`.

All six original complete roots remain retained under
`/Users/alex/.local/state/vinix/android`:

- `bitmap-tiles-framework-builder-2026-10-30-r1`, `-r2` and `-r3`: earlier
  qualifications and the final builder/framework production controls.
- `combined-account-webview-bitmap-tiles-framework-2026-10-30-r1`: complete
  framework producer.
- `bitmap-tiles-native-controls-2026-10-30-r1`: native controls.
- `current-native-build-2026-10-30-bitmap-tiles-r1`: complete native producer.

All six roots passed sealing and a separate fresh-process complete readback:
9,279 entries, manifest
`/Users/alex/.local/state/vinix/android/bitmap-tiles-producers-sealed-2026-10-30-r1/sealed/manifest.json`,
SHA-256 `8ddb001936bb3a94ecbae3be032e9b209e1bd9c13f15ce563cd4a15b0be3e587`.
No production attempts failed; intermediate builder qualifications remain
preserved rather than overwritten.

| Final phase | Guard seconds | Sampled aggregate RSS bytes |
| --- | ---: | ---: |
| Boehm builder compile | 2.418 | 347,815,936 |
| Complete builder self-tests | 0.281 | 1,245,184 |
| Full framework | 43.779 | 493,535,232 |
| Fresh coupled native | 26.990 | 615,579,648 |
| Complete six-root seal | 1.043 | 24,559,616 |
| Independent complete readback | 0.633 | 24,477,696 |

All final guard/child exits were zero with complete cleanup and zero reported
swaps. The original 629,145,600-byte RSS cap and 1 GiB reserve stayed enforced.
Qualification keeps 300 seconds/512 MiB observed growth; framework/native
production keeps 300 seconds/1 GiB; sealing/readback keeps 900 seconds/64 MiB.
No guard was raised for these results.

| Artifact | SHA-256 |
| --- | --- |
| Final builder source | `1c145ffdf5b4eb205da48544cecb2b62678f2983b9027d6a8a73e36bafdadae4` |
| Final builder | `b04662ecc1b0280ee48f866b53694834e9ab060937cb50942d935ec9ad417853` |
| Framework `sha256.json` | `bf8626569c82826e4d6b6379a3e2266741db3d2919d2eda4cf647b18c5b5f7df` |
| Framework `build.json` | `d11743557721c5bbbc1febac8098ff73cca29f5c7918fab33066279ad42842a7` |
| Framework JAR | `741641c30098cf2f682672889c7ac653c6b2f23b9c09001a7af8f56bb01d9500` |
| Framework DEX | `9cc070c5f4b0db062bff5856a4cb64ad1974dddf23646cf295e9ddeed365bb20` |
| Native `sha256.json` | `f4c9ab784fc630803ffb81554ec120aca8706ef4ce29751a0be25a84eb9e692e` |
| Native `build.json` | `d933ea795fee49dc8cc19e342c30a61eb6094d71f945d8d10d3251a528c7c4ee` |
| Native DSO | `6969a813fbfe69cd882f3cb47760cb09cb106ca9aad748ea67ab93967aacad20` |
| Generated JNI V | `256807c4a8ff63a2e86cd726bf9782ac93ffa1a6b22ca3edcff6bcc4b6b118c7` |
| Native exports | `388c10f346d6892346496240bed78a9fddc614c03f783dde5cff66c09210d5ba` |
