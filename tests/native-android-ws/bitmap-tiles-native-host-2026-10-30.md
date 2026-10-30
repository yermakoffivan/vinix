# Native bitmap drawable tiling, 2026-10-30

`bitmap_tiles.v` adds a nearest-neighbor CLAMP/REPEAT/MIRROR sampler for the
existing native bitmap compositor. It anchors the pattern at the Canvas origin,
clips transformed bounds before sampling and preserves existing paint alpha,
color filtering, path/quadrilateral clips and SRC_OVER/DST_IN behavior. Work
scales with visible pixel bounds, including tiny sources and enormous offscreen
drawable bounds. Double-precision period arithmetic avoids integer overflow.

The sole appended binding is BitmapDrawable's private static
`nativeDrawTiles(GskCanvas, Bitmap, int, int, int, int, Paint, int, int)`.
Explicit Bitmap and Paint JNI arguments keep the exact borrowed payloads alive
through the call, including a Paint returned by an overridden getter. Null and
pending-exception guards precede extraction; each failed extraction returns
before later JNI access. Canvas selection is restored by a defer, including an
exception raised during entry. Self-drawing copies source pixels before writes
and frees that temporary on every subsequent return. Independent source and
lifetime review passed. Existing native files and bindings remain unchanged.

Validation used working sources over `460360b7a`. The host driver compiles the
actual sampler, retained compositor helpers and exact binding body, with an
independent integer pixel oracle. Normal and AddressSanitizer runs passed all
nine mode pairs; negative/fractional coordinates; dimension-three and INT_MAX
wrapping; shifted/negative/partial bounds; rotated huge bounds; real path and
quadrilateral clips; self-alias snapshots; alpha/filter/DST_IN/ALPHA_8 behavior;
and ten binding argument/null/pending/TLS paths. Existing compositor controls
also passed. ASAN used `detect_leaks=0`; this is an access-safety check, with
temporary ownership separately reviewed.

Complete artifacts are retained under `/Users/alex/.local/state/vinix/android`
(`S`) at `bitmap-tiles-native-host-2026-10-30-r1`. The first generated test build
failed on a missing closing brace in the new harness; its original inputs,
diagnostics and guard remain preserved. Corrected normal and ASAN attempts
passed in 2.575/2.663 seconds, sampled 189,775,872/195,821,568 bytes aggregate RSS,
and exited zero with complete cleanup. Driver compilation passed in 1.761
seconds at 295,190,528 bytes RSS. All time reports recorded zero swaps; original
600 MiB RSS, 300 seconds, 512 MiB growth, 1 GiB reserve and file-size caps stayed
enforced.

The closed root passed sealing and separate fresh-process full readback:
82 entries, `S/bitmap-tiles-native-host-sealed-2026-10-30-r1/sealed/manifest.json`,
SHA-256 `9a208cd7566decd99d31d38bdcc7c549ad509ac7ca09a5ae32bbe50932d0418a`.
Both guards exited zero with complete cleanup under unchanged 600 MiB,
900-second, 64 MiB shared-growth and 1 GiB-reserve caps. Retain the complete
original bundle and sealer.

| Source | SHA-256 |
| --- | --- |
| Native sampler | `db5eae1e2ef30a7bb612808f0117a50cc004aaea91926b5d44fa6c6dbc3e311a` |
| Complete bindings | `094e136e5847cf6f9207e4c031bbf25db959014dcb5ed92fcef7f08ac58d9571` |
| Host harness | `54ee768613b3f9d79057c36b4c7095a4f9924fe4f72917f3d151228b16bc39ad` |

This establishes host rendering and binding behavior. Coupled AArch64 production,
the signed ARM fixture and Google's real account UI require subsequent checks.
