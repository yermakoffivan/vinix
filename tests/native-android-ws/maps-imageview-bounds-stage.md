# ImageView maximum-bounds media tools

The explicit `maps-imageview-bounds-stage` and `--maps-imageview-bounds` kernel
profile extend the sealed platform-fragment image without changing historical
profiles. Source snapshots over revision
`52f55817144cda6c30bffcc0e03dccf2b2d09287` and complete qualification evidence are
retained at `/Users/alex/.local/state/vinix/android/maps-imageview-bounds-tools-2026-10-30-r1`
(`T`). Exact source/tool pins are in `T/completed-tool-inputs.sha256`.

The immutable base is `maps-platform-fragments-r2`, manifest
`1a079687d54ed8eae5ab881be3f0459d37ce8e69533bc12df48874cf7335199a`.
The successor requires 59 complete dependency seals, seven overlay files,
six actual deployment-input changes, three top-level changes, 27 inherited
modules and 28 final modules. Original ancestry, TAR inode/mode checks, the
first executable native inode and historical headless/launcher roles remain
verified. The headless input receipt changes only its JAR input.

The framework is
`combined-account-webview-imageview-bounds-framework-2026-10-30-r1`, manifest
`95853b2f31ac34f731c8c31fc1251fd695ed6d856a8bfef0f71041efc10273e0`,
JAR `9cfdbeaff047b693837508c3f7676510a63c05af118e864964b4b432fb813af9`,
DEX `fb8ec08f3830293c3859ca043d9296ada34fecb3fe2cb7f11c3ed03dfa69e474`.
Complete 2,105-class membership is preserved. Only ImageView changes canonically:
three changed methods, two added getters and two private fields. The complete
canonical-clone source tree, before/after inventories and method/field receipts
are exact; unrelated classes stay equal.

The coupled native producer is
`current-native-build-2026-10-30-imageview-bounds-r1`, manifest
`d7d8ac996d63b2bd8ad8f6b658a32ae23903ebb9e248297d219f46f6df8f59c8`,
DSO `fd38d7f8e3c0d17934617242cb95b0412a0c6ed676cb4454e5a52c8cf494dc2c`.
All 88 native sources, generated JNI, bindings and exports remain unchanged.
Complete helper closures allow exactly the new ImageView provider and its
framework registration. Of 68 consumed classes, only ImageView changes
canonically; 67 remain equal. Raw inputs additionally retain the exact Activity
formatting change caused by cloning its canonical DEX source; the other 66 raw
inputs remain equal. Fresh DSO bytes differ from the predecessor. The tools
also handle a byte-identical rebuilt DSO by declaring only five actual input
changes while retaining its pinned file in the seven-file overlay.

Both tools passed serial V `-generate-c-project -no-parallel`, compilation of
their exact emitted production C commands, selftests and actual input auditing.
The patcher passed all historical profiles and new malformed receipt, seal,
proof, module, payload, digest and mode refusals. Fresh `-dump-files` lists and
a post-build 424-input source/compiler/C/header capture are retained; capture
verifies each original, copy and subsequent original hash. Exact source copies,
generated C, commands, inherited closure and flagged C inputs are preserved.
The host SDK and system libraries remain environmental inputs; this is not a
hermetic build.

Every successful production, test and capture phase kept 600 MiB aggregate RSS,
300 seconds, 512 MiB observed shared-volume growth and a 1 GiB reserve. Guard
and child exits were zero with complete cleanup; time reports recorded zero
swaps. The largest sampled aggregate RSS was 384,499,712 bytes, including the
capture helper build. Failed initial attempts remain intact: stager generation
stopped on 1,075,920,896 bytes of shared-volume growth after 1.185 seconds;
patcher generation rejected an omitted module search path. Fresh retries used
the original limits and complete module paths, with no source relaxation.

The closed one-root, 1,106-entry seal and separate-process full readback passed
under 600 MiB/900-second/64 MiB-growth/1 GiB-reserve limits:
`/Users/alex/.local/state/vinix/android/maps-imageview-bounds-tools-sealed-2026-10-30-r1/sealed/manifest.json`,
SHA-256 `d12738c91346d54f733a1d98582f4d3956e8a244f22d88190ddf99bf71a009fc`.
Final executables below `T` are:

- `stager-project-r2/maps-imageview-bounds-stage`: `dae88278c4cc9758d887718f08b46f56544bf5633facc5bb8041636a3728142c`
- `patcher-project-r2/patch-kernel`: `48a7436bf206498230b743090586df0f3097ef1f1145c19eba930aa9935b0fae`

Run the stager with `--prepare FRESH_EXTERNAL_OUTPUT`, clone the complete sealed
image, then use the patcher's `--maps-imageview-bounds` profile with the frozen
kernel build and its exact receipt pin. Preserve the original preparation,
clone and kernel 600 MiB/900-second/4 GiB growth plus 1 GiB reserve and 8 GiB
shell file-size limits. This qualification prepared no image and booted no VM.
ARM regression, Maps rendering and Google authentication require guest evidence.
