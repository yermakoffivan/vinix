# Window system UI framework and native producers

The explicit `--window-system-ui` producer from `d8c5fc772` applies the provider
from `f481dce21` over the sealed ImageView framework. Exactly one of 2,105 classes
changes: `WindowManager$LayoutParams` gains `.field public systemUiVisibility:I`.
No method changes or additions are permitted. All other fields, methods, class
metadata and non-DEX JAR entries remain unchanged before and after DEX roundtrip.
The builder selftests reject wrong field flags/type, missing/duplicate/extra
members, method-body changes, substituted classes and incorrect class membership.

Paths are relative to `/Users/alex/.local/state/vinix/android` (`S`):

- Frozen builder and controls (`B`): `S/window-system-ui-framework-builder-2026-10-30-r1`.
- Framework (`P`): `S/combined-account-webview-window-system-ui-framework-2026-10-30-r1`.
- Native producer (`N`): `S/current-native-build-2026-10-30-window-system-ui-r1`.
- Native controls (`C`): `S/native-window-system-ui-build-2026-10-30-r1`.

The framework records source revision
`d8c5fc7726458cb805e2df118a8109cd9b17fe59`; the native producer records
`e8f6da223d6e5387b7134c4972d42f8daa46b1f7`. Exact consumed source copies and
before/after hashes are retained, including provider SHA-256
`53ace9c9ce0ffe519162cf8cb7dd0e80b23809061da22773cfbde6e2d88779c6`
and framework registration
`d178f0c882be349f8511b722ba86c12f7876dc8c202629af041a86589eae4767`.

| Artifact | SHA-256 |
| --- | --- |
| `B/tools/builder` | `893e806b56a6a6021a6dd49c2ba2a1b8cd0fc3b6659b0606cf99c6b24aa2fe0d` |
| `P/sha256.json` | `1e24a8dcc2f5b315ebbb63cb06d3de46e0799b4b1a0d19339d3b98ecab0c3b09` |
| `P/build.json` | `d648c6541230aca6f9a369f8e99d19cb3e971670c930f82339de38fb1d48eb7b` |
| `P/api-impl.jar` | `3f0d220a24e7d91a47f7b2d42cd5620aa498981e915a90cdbd806164b8ef0fc1` |
| `P/classes.dex` | `e9509dedcf935f143ffc0a68bd8af3b26901b69e231388be7ea1c2c72c5bd150` |
| `N/sha256.json` | `b564d361fd1fc0271cba1967c84ac6b3ca32607b832bd6114c6943be777e2872` |
| `N/build.json` | `2b9fee52a40c382b949761e6759389bfc1fa4c07fbc6ab27900705bbaf14c7e2` |
| `N/native/libvinix-android-native.so` | `c97862ecb4eba730290a832b2766d58c1552ddf58ae40f77d7e140e69538ce75` |

LayoutParams is absent from the native producer's 68 consumed classes; all 68
remain canonically equal. The sole raw consumed difference is ImageView's
inherited source-to-canonical formatting (`6ff7772b…` → `20b3e0ec…`). A fresh
coupled native producer was built. All 88 native source files, bindings and
generated JNI remain identical; generated JNI SHA-256 is
`b349742dff2bdcc464e3df011ccf54d0ff546ea36a1feb9cd82b26ec3da67dde`.
The unchanged source-matching native bootstrap and compiler closure follow the
[ImageView producer](imageview-bounds-producers-2026-10-30.md).

The retained host builder closure additionally incorporates commit `a07c876ab`
in `tools/sourcecommand/pty.v` and `reader.v`: each file has exactly four local
identifier substitutions from `arguments` to `argv_pointers`. Independent review
compared the complete retained sources and found no other byte changes. These
helpers are absent from the target native generated C; the native builder uses
`os.exec(argv)`. The media audit requires both exact before/after hashes and
whole-source four-substitution equality, alongside the explicit framework
registration/provider changes. The native-generator closure stays unchanged.

| Phase | Guard seconds | Sampled aggregate RSS, bytes | Time maximum RSS, bytes |
| --- | ---: | ---: | ---: |
| Builder compile | 1.599 | 348,028,928 | 379,191,296 |
| Full framework producer | 103.919 | 498,204,672 | 485,851,136 |
| Coupled native producer | 66.513 | 625,573,888 | 402,472,960 |

All producer checks and children exited zero with complete cleanup and zero
time-reported swaps. Limits remain 600 MiB aggregate RSS, 300 seconds and a
1 GiB reserve. Compile/selftest used 512 MiB observed shared-volume growth;
framework/native production used 1/2 GiB. No producer attempt failed or cap
changed. These shared-volume measurements do not isolate producer writes.

The four closed roots and 9,253 typed entries are bound by
`S/window-system-ui-producers-sealed-2026-10-30-r1/sealed-r2/manifest.json`, SHA-256
`60979c87657bb0d2ef08d32b544c61ff554cba4a2adfdd880254fb786d0141ea`.
Seal/inline verification and a separate fresh-process full readback passed under
600 MiB/900-second/64 MiB-growth/1 GiB-reserve limits, in 2.141/1.521 seconds.
The first seal attempt stopped at 68,775,936 bytes observed growth after 2.847
seconds, with child 137 and complete cleanup. Its partial output and controls
remain unchanged beside the successful seal; `seal.guard.json` SHA-256 is
`92d4156a08f21518b067fc95ecc2a6bac5a504bc42ca9f3cdcea148ecd5b75b7`.

The complete compiler/source/C/header provenance remains in the original
bundles. SDK and system libraries remain recorded environmental inputs.
These are host production checks; ARM fixture execution, Maps account rendering
and Google authentication require separate runtime evidence.
