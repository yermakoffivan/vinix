# Dialog theme SDK and coupled native pair

Provider `b97a9861a` changes only `Dialog(Context, int)`: a zero theme resolves
`android.R.attr.dialogTheme`, then the selected theme wraps the supplied context
for both the Dialog and Window. The original native initialization tail remains
exact. Qualified producer `d5efefea8` preserves all 2,108 classes, every existing
method signature, field, native declaration, neighboring class and non-DEX JAR
payload. Its independent old/new constructor oracle runs before assembly and
after the complete DEX roundtrip; it permits only the known equivalent branch
label. Historical profiles and checks remain intact.

The immediate SDK predecessor is the complete PaintDrawable SDK, manifest
`15a60de7b8196aaca79d869cec972b0382da1be7327ee8f10c56b7e1db37cbb2`.
The source provider and registration are pinned respectively to
`28be91da8aa473ee3ca5650946cf44c5ed44a409a10a7769f79f4cb6c1eac26c`
and `dafce2154198259c14f6279b69638cca6124307b35414e9c572a2d971ee6a79b`.
Focused source checks, including 75 refusals and all 2,108 classes, are recorded
in [the feature report](dialog-theme-framework-2026-11-01.md).

| Qualified operation | Seconds | Sampled aggregate RSS bytes |
| --- | ---: | ---: |
| SDK producer compile | 2.077 | 369,639,424 |
| Complete producer self-tests | 0.310 | 15,384,576 |
| Complete SDK production | 59.692 | 512,311,296 |
| Coupled native production | 86.105 | 565,493,760 |
| Actual-command prefix-map proof | 15.800 | 382,353,408 |

Every operation passed on its first attempt with guard/child exits zero and
complete cleanup under the unchanged 600 MiB, 300-second, 1 GiB reserve and
file-size caps. SDK/native production retained their 1 GiB observed shared-growth
limits and recorded 317,149,184/408,637,440 bytes. Tools/proof retained 512 MiB;
the proof recorded 110,673,920 bytes. These results do not replace any historical
failed controls retained by the predecessor reports.

Dialog belongs to the 69 native-consumed classes, so a fresh coupled native
build uses the committed split builder `b2aad79ed`, source SHA-256
`b307f9afc36f19aefdf160c51c528f6bf7b157b4cfcced7d625fc697dfe55eeb`.
The native predecessor is `current-native-build-2026-11-01-resources-float-r2`,
manifest `c8a7134531f5fdfb6a8e484537a4eb798564fb039760ae9f82cc9a2045ba3062`;
its framework origin remains the Resources-float SDK. The fresh build consumes
the complete new Dialog SDK and retains the compiler/runtime provenance checks.

The exact five-leaf proof at
`S/dialog-theme-prefix-map-proof-2026-11-01-r1` copies the actual successor
`build-native.json` byte for byte. It changes only the output path and adds one
`-ffile-prefix-map=new-root=Resources-native-r2-root` immediately before the
existing maximum-page-size flag. All 17 recorded physical pins passed a fresh
readback after compilation. The resulting whole DSO is byte-identical to the
Resources-native-r2 library, SHA-256
`441ae035ec4b69c36635cc4521af3fafcb6a867305b0ba25d6e55df7ff0dadc9`.
This establishes a source-root-path-only binary difference; it does not replace
the full media compatibility audit or ARM checks.

The later media artifact audit passed all 2,108 canonical classes and the full
69-class native input set: only the Dialog constructor changes canonically;
the two exact raw differences are Dialog and the known Resources formatting
pair. Native sources, JNI, generated C, headers and all 719 exports remain exact,
with only the reviewed three-entry native helper delta. It also rechecks the
complete five-leaf prefix proof. This audit took 8.771 seconds at sampled
aggregate RSS 55,771,136 bytes, with guard/child exits zero and complete cleanup
under unchanged 600 MiB, 900-second, 512 MiB-growth and 1 GiB-reserve limits.
Its receipt and log are `S/maps-dialog-theme-tools-2026-11-01-r1/framework-audit.*`.

Artifacts remain under `S=/Users/alex/.local/state/vinix/android`:

| Artifact | SHA-256 |
| --- | --- |
| `combined-account-webview-dialog-theme-framework-2026-11-01-r1/sha256.json` | `a3547ad6477b3fb2eb7a9bcd7d73b8870c89a6bf69c4a84db03dc79e3222859f` |
| Framework `build.json` | `8da4edbd62080d545efc44071a43bd9451724f0559954acb80c5938654571787` |
| Framework JAR | `9d8d2b1f59f80bf0d704daa65eaf3b479fa83458338f23d9fe17aa7a57b541b6` |
| Framework DEX | `4e2c69c8f32f4ef77c92d68a1c3733d4a1ca3c8b8c960acf462ae508e20f84f8` |
| Changed raw Dialog class | `66a711e288271a52f5fe9d44b4fca75738ee882f60f869d12030c4ba3f8290f1` |
| Changed canonical Dialog class | `fb1951defc731f6f52b907aaa81fd94272662e9a7348d1b2dbf6caee32a59042` |
| `current-native-build-2026-11-01-dialog-theme-r1/sha256.json` | `a293cfedb3fa2c7775af0cd15330b559ca4850c9ae7496e7e16717d520e2b0a4` |
| Native `build.json` | `733f4c5137884a7bc551ad313495920932d6a3583084e51fbe9cc441a8ac9e95` |
| Native DSO | `280730c4166687394cf69e548cdd106e58c57ba9472f339dde2c80ebdee2595a` |

Complete qualification evidence remains in
`S/dialog-theme-framework-builder-2026-11-01-r1`,
`S/dialog-theme-framework-production-2026-11-01-r1` and
`S/dialog-theme-native-controls-2026-11-01-r1`, together with the SDK, native and
proof roots above. One joint seal and a separate fresh-process full readback
passed for all 16 closed SDK/native/proof, source/caller/selector and fixture
roots: 20,570 typed entries. Both fixture attempts are retained, including r1's
host rejection for the XML dump representation and the passing r2; no rejected
output is admitted. The exact root list is
`S/dialog-theme-producers-sealed-2026-11-01-r1/roots.txt`, with manifest
`sealed/manifest.json` SHA-256
`21f05fa4110985523c32885b944da3fcceed2b45defae22370f2624b81b5582e`.
Seal/readback took 3.565/1.123 seconds at sampled aggregate RSS
28,295,168/24,576,000 bytes, with guard/child exits zero and complete cleanup
under unchanged 600 MiB, 900-second, 64 MiB-growth, 1 GiB-reserve and file-size
caps. No attempt in this seal root failed. Retain all complete predecessor and
failed-control bundles. The signed fixture's host checks are separate evidence;
ARM Dialog behavior, live Maps profile behavior and authentication remain
unverified with this pair.
