# Window attribute framework/native pair, 2026-10-30

The complete framework and fresh AArch64 native producer passed for
`e0316391f38d26eb3d76d2ea40516182286a14d7`. Both production manifests record
that source revision. The [additive producer profile](window-animations-producer-profile-2026-10-30.md)
retains all 2,106 classes and adds exactly five Java methods in Window,
Window.Callback, Activity and Dialog. Every existing method, field and unrelated
class remains unchanged, including LayoutParams. This supplies animation-resource
attribute storage and notification; it does not execute animation resources.

Native compilation retains all 89 V sources, the complete 90-input production
map, 69-class consumed membership and 719 exports. The generated JNI V and
complete generated C are byte-identical to the bitmap predecessor. Three
consumed canonical classes change only by their new Java APIs: Window, Activity
and Dialog. Their raw files change accordingly. One additional raw-only change
canonicalizes BitmapDrawable from `c743a425...` to its already unchanged canonical
`82ffe62e...` form; its API and canonical bytes remain equal.

The actual new DSO is pinned as
`a1f27a68285dfe6d5cef34ad077bde7537ee41c136fd40d82ad42e14097377ba`.
Its embedded STB assertion filenames use the new physical build root, changing
binary layout despite identical C and header bytes. A separate guarded relink
uses the exact original command plus only
`-ffile-prefix-map=NEW_NATIVE_ROOT=BITMAP_NATIVE_ROOT` and a fresh output path.
It recreates the entire predecessor DSO byte-for-byte, SHA-256
`6969a813fbfe69cd882f3cb47760cb09cb106ca9aad748ea67ab93967aacad20`.
The original native producer, flags and historical checkers remain unchanged;
the actual newly produced DSO is deployed, while the relink is provenance proof.

The complete proof remains at
`/Users/alex/.local/state/vinix/android/window-animations-prefix-map-proof-2026-10-30-r1`:
original command receipt, explicit input pins, guarded compile receipt/log and
canonical DSO. The new media profile requires all five exact files, successful
unchanged limits, unchanged physical inputs and the exact flag-only relink argv.
It records the host proof inventory separately from inherited producer seals
and boot modules. No extra runtime module or replacement native behavior is added.

Complete retained roots under `/Users/alex/.local/state/vinix/android` are:

- `window-animations-framework-builder-2026-10-30-r1` and `-r2`: original failed
  map-literal compilation plus corrected qualification and production controls.
- `combined-account-webview-window-animations-framework-2026-10-30-r1`.
- `window-animations-native-controls-2026-10-30-r1`.
- `current-native-build-2026-10-30-window-animations-r1`.
- `window-animations-prefix-map-proof-2026-10-30-r1`.
- `window-animations-native-profile-draft-2026-10-30-r1`: preserved uncompiled
  alternative draft; no compiler, test or commit ran for it.

All seven closed roots passed sealing and independent fresh-process full readback:
9,281 entries at
`/Users/alex/.local/state/vinix/android/window-animations-producers-sealed-2026-10-30-r1/sealed/manifest.json`,
SHA-256 `0fa7f8c90aa4fe169548200bfd53ce04d1b5ce8b57c1128d2976f6e75c3b29a2`.

| Final phase | Guard seconds | Sampled aggregate RSS bytes |
| --- | ---: | ---: |
| Builder compile | 2.279 | 347,602,944 |
| Complete producer self-tests | 0.287 | 15,187,968 |
| Full framework | 65.957 | 498,335,744 |
| Fresh native | 55.791 | 622,624,768 |
| Prefix-map relink proof | 14.496 | 377,831,424 |
| Seven-root seal | 2.568 | 24,379,392 |
| Independent complete readback | 0.986 | 15,089,664 |

Every final guard/child exited zero with complete cleanup and zero reported
swaps. The original 629,145,600-byte RSS cap and 1 GiB reserve stayed enforced.
Qualification/proof retain 300 seconds/512 MiB observed growth; framework/native
production retain 300 seconds/1 GiB; seal/readback retain 900 seconds/64 MiB.
ARM regression and the live Maps avatar flow still require runtime validation.

| Artifact | SHA-256 |
| --- | --- |
| Framework manifest | `19d67639dce414866deab4c3de57ac8576b5542dff6d58c8b0b78caf066f3e53` |
| Framework build receipt | `09f702986f4a71cbfbae3146d996b5c50a48087ee9e2b52bcaaf35158067ef52` |
| Framework JAR | `255718e8a943f8d3e276f99694c52ed5ec39af86d5d06abef3c9b14d7b9aa197` |
| Framework DEX | `b9c402c9b18c8be1104f4aa59e2d76721a4be609e4713a0984e462a8e626b7c0` |
| Native manifest | `6c8df7ccadb79ebe4fb4949b86a37aba177a9573a33f8afa7a8441cfec5af432` |
| Native build receipt | `a5848fedb670b4c88fc5bef04eacca00edbe6e3a7d10981cdca4f1810e1895b6` |
| Actual native DSO | `a1f27a68285dfe6d5cef34ad077bde7537ee41c136fd40d82ad42e14097377ba` |
| Generated JNI V | `256807c4a8ff63a2e86cd726bf9782ac93ffa1a6b22ca3edcff6bcc4b6b118c7` |
| Generated C | `b6f64efd407923433f2a0591f3a0cd6147a3da4372b93c3c9b091d3d912e3154` |
