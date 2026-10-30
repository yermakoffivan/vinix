# Window layout system-UI media tools

The explicit `maps-window-system-ui-stage` and `--maps-window-system-ui` kernel
profile extend the sealed ImageView runtime with the public
`WindowManager.LayoutParams.systemUiVisibility:I` field. Historical profiles
remain unchanged. Final source snapshots over revision
`c9bf0a221484fbd0982532243f9e8fba1ada08af` and complete qualification evidence are
retained at `/Users/alex/.local/state/vinix/android/maps-window-system-ui-tools-2026-10-30-r2`
(`T`). Source and executable pins are in `T/completed-tool-inputs.sha256`.

The immutable base is `maps-imageview-bounds-r3`, manifest
`6fa4cb4086126a2c1c3a66252474abd8bad79d8b15c4394a305d0f1db7998eb5`.
The stage requires 62 complete dependency seals, seven overlay files, six actual
deployment-input changes, three top-level changes, 28 inherited modules and 29
final modules. Bounded two-worker initial/final dependency audits still read
every byte and check every complete inventory. Original ancestry, TAR modes,
the first executable native inode and historical headless/launcher roles remain
verified; the headless input receipt changes only its JAR input.

The framework root is
`combined-account-webview-window-system-ui-framework-2026-10-30-r1`, manifest
`1e24a8dcc2f5b315ebbb63cb06d3de46e0799b4b1a0d19339d3b98ecab0c3b09`,
JAR `3f0d220a24e7d91a47f7b2d42cd5620aa498981e915a90cdbd806164b8ef0fc1`,
DEX `e9509dedcf935f143ffc0a68bd8af3b26901b69e231388be7ea1c2c72c5bd150`.
Complete 2,105-class membership remains equal. Only WindowManager.LayoutParams
changes canonically: one public field, zero changed or added methods. The full
canonical-clone source tree, class inventories and field/method receipts are exact.

The coupled native root is
`current-native-build-2026-10-30-window-system-ui-r1`, manifest
`b564d361fd1fc0271cba1967c84ac6b3ca32607b832bd6114c6943be777e2872`,
DSO `c97862ecb4eba730290a832b2766d58c1552ddf58ae40f77d7e140e69538ce75`.
All 88 native sources, generated JNI, bindings and exports remain unchanged.
The target class is explicitly absent from the 68 consumed classes, which all
remain canonically equal. Raw consumed inputs differ only by ImageView's exact
canonical-source formatting change; the other 67 raw inputs remain equal.
Conditional byte-identical DSO handling retains seven files while declaring
only actual changed inputs; the actual new DSO differs and requires six changes.

The complete builder helper closure permits exactly four reviewed paths:
the window provider and framework registration, plus `tools/sourcecommand/pty.v`
and `reader.v`. Each host helper changes only four local identifier occurrences
from `arguments` to `argv_pointers`, inherited from `a07c876ab`. The stager pins
both complete before/after files, rehashes their retained text and requires exact
`before.replace('arguments', 'argv_pointers')` equality with four substitutions;
no whitespace normalization or other change is accepted. Native-generator
helper closure equality remains exact. These two imported host functions are
outside the observed native-producer command path and target generated C.

The first qualification root, `maps-window-system-ui-tools-2026-10-30-r1`, is
retained unchanged. Its actual audit rejected those previously undeclared host
helper differences. Retained diffs and independent source review identified
their exact scope; the final source, generated C and executables were rebuilt
in the fresh `r2` root. No failed attempt was overwritten or relabeled as passing.

Final serial V generation, compilation of the exact emitted production C,
stager selftests, complete actual framework/native audit, helper enumeration
and every historical/new kernel-profile selftest passed. Field/method receipt
checks remain exact. New negatives cover canonical and raw consumed proofs,
four-entry helper maps, exact rename text, seals, modules, payload membership,
hashes and modes.
Fresh `-dump-files` lists and a 425-input source/compiler/C/header capture are
retained, with original/copy/subsequent-original hashes checked. The host SDK
and system libraries remain environmental inputs; the build is not hermetic.

Every successful phase kept 600 MiB aggregate RSS, 300 seconds, 512 MiB observed
shared-volume growth and a 1 GiB reserve. Guard/child exits were zero with complete
cleanup and zero time-reported swaps. The largest sampled aggregate RSS was
372,228,096 bytes; the largest time-reported process maximum was 375,816,192 bytes.

Both closed roots and all 1,740 entries passed sealing and independent readback
under 600 MiB/900-second/64 MiB-growth/1 GiB-reserve limits:
`/Users/alex/.local/state/vinix/android/maps-window-system-ui-tools-sealed-2026-10-30-r1/sealed/manifest.json`,
SHA-256 `5e78e5d1784f1fa16d787b4a53aa32620aaa0b8c63a5973bfb627cb237b456de`.
Final executables below `T` are:

- `stager-project/maps-window-system-ui-stage`: `884deb5b4537962d3724545ea1583c2a9b5cd0a9336750f84e98afd9d1575fcf`
- `patcher-project/patch-kernel`: `dcaeb59745692cfbdfb3cc813563c4d702a9f333eac88a5dba03c48c6429710a`

Use `--prepare FRESH_OUTPUT`, clone the complete sealed image, then install the
frozen kernel through `--maps-window-system-ui`. Preserve the original 600 MiB,
900-second, 4 GiB-growth, 1 GiB-reserve and 8 GiB shell file-size guards. This
qualification prepared no image and booted no VM; ARM behavior and Google
authentication require separate guest evidence.
