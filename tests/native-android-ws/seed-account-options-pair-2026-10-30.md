# Seed account options framework/native pair, 2026-10-30

The full framework and a fresh coupled AArch64 native library passed production
checks for the seed-options fix in `13aa31b64`. Both manifests record source
revision `97b9aea1ea396196774bc65d1b13727970c575a8`. The additive producer profile
is committed as `d7d84f1d5`, with descriptor clarification `2160bda86`.

The qualified Boehm producer preserves all 2,105 baseline classes, all unrelated
members, and every JAR entry except `classes.dex`. Its exact allowed changes,
checked before assembly and after complete DEX disassembly, are the null
UserManager getter, PersistableBundle's typed immutable EMPTY constant and static
initializer, and ArrayMap's static initialization order. The baseline canonical
class inventory equals the preceding Window system-UI build's final inventory.

The fresh native producer restored the retained old-276 compiler/library inputs,
froze and checked complete source closures, generated JNI from copied framework
classes, and passed the AArch64 `-Werror` shared link with no undefined native
symbols. Its 68 consumed raw classes, 88 native source origins, 89 source/binding
input hashes, generated C, generated JNI, and all 718 exports are byte-identical
to the preceding Window system-UI native bundle. None of the three changed
framework classes occurs in those 68 native inputs.

The fresh ELF differs from that preceding build. Readback shows the new absolute
bundle paths in `stb_image.h` and `stb_truetype.h` assertion strings. The complete
generated C is identical, and the consumed-header hashes agree after replacing
only the old/new bundle path prefix. These facts support a path-dependent ELF
difference; this is an inference rather than a claim of byte-identical machine
code. The new ELF's actual checksum is pinned below.

The complete retained roots are:

- Builder qualification and full framework controls:
  `/Users/alex/.local/state/vinix/android/seed-account-options-framework-builder-2026-10-30-r1`.
- Full framework:
  `/Users/alex/.local/state/vinix/android/combined-account-webview-seed-account-options-framework-2026-10-30-r1`.
- Fresh coupled native build:
  `/Users/alex/.local/state/vinix/android/current-native-build-2026-10-30-seed-account-options-r1`.
- Native guard controls:
  `/Users/alex/.local/state/vinix/android/seed-account-options-native-controls-2026-10-30-r1`.

All four complete roots passed sealing and independent full readback: 9,260
entries, manifest
`/Users/alex/.local/state/vinix/android/seed-account-options-producers-sealed-2026-10-30-r1/sealed/manifest.json`,
SHA-256 `1e1a2735d1be057b2155bb99ba2598ecb8707fe79a75c580452b6b6a04f7b282`.
The qualification root also preserves the initial argument refusal, which did
not execute a compiler, and the earlier source-profile qualification.

| Final phase | Guard seconds | Sampled aggregate RSS bytes | Time maximum bytes |
| --- | ---: | ---: | ---: |
| Boehm producer compile | 2.426 | 347717632 | 294977536 |
| Boehm producer self-tests | 0.411 | 1245184 | 13910016 |
| Full framework production | 44.323 | 495091712 | 482705408 |
| Fresh coupled native production | 27.620 | 609697792 | 403800064 |

All final guard/child exits are zero with complete cleanup and zero time-reported
swaps. The original 629,145,600-byte RSS ceiling, 300-second producer deadline,
1 GiB reserve and file-size limit remain in place. Framework and native
production retain their 1 GiB observed-growth allowance; qualification retains
512 MiB. Sealing and readback retain the stricter 64 MiB allowance and their
900-second limit. No guard limit was raised for these results.

| Artifact | SHA-256 |
| --- | --- |
| Qualified Boehm producer | `2dc3d0fa60abd2ffb424ae50b576e4d2245052b0c539c1957451413252d9fa0c` |
| Framework `sha256.json` | `470636b2812f339d58071ba59986282ac5107e5256aa2588dd9305d7ef5b45e9` |
| Framework `build.json` | `4934f484c1d9dbeb41e0b9e53e31634cae19be72a21bbf88bb758969bec046ce` |
| Framework `api-impl.jar` | `cb2e3fabab652c65351da16770ae98c4113781df0830440b734395bb35b6f265` |
| Framework `classes.dex` | `790d9c0436e070a0ff643127228f622f0a30ae12e4560e7acccadf4550a13dfa` |
| Native `sha256.json` | `8fbfbd2c74eca6c412909a2a64fb91949cbaa1ed0b262e9970ff375dddff61f8` |
| Native `build.json` | `1a968278009d05f2c3d68068b46f5128c46f23ee6ae7bb384ede50c67bc2c5ce` |
| Native ELF | `179f51ad25cc99fd939ca1f217e87f1d3ab9c452b98db861da11e0344363f6ce` |
| Consumed 68-class map | `5acb52c6bc4e18d57382393e3d95e04a46275a73df265d0a2b344b1417d54aaf` |
| Generated C | `cd411551d69b1680606623f40389eebeb370e732d1d156a09af7be77d9bf9758` |
| Generated JNI | `b349742dff2bdcc464e3df011ccf54d0ff546ea36a1feb9cd82b26ec3da67dde` |
| Native exports | `1f420a37fe1379f3291bd841a978dbac87122008b722ba8c42046933f61bdb83` |

The signed fixture and its focused host checks are documented in
[seed-account-options-host-2026-10-30.md](seed-account-options-host-2026-10-30.md).
These production checks establish a qualified framework/native pair; guest
execution, Google authentication and Maps imagery still require runtime checks.
