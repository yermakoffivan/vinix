# Signed Dialog theme fixture, 2026-11-01

Maps passes an explicit inherited OneGoogle dialog style through AppCompatDialog
to `Dialog(Context,int)`. The platform constructor discarded that style.
Provider commit `b97a9861a` retains a fresh ContextThemeWrapper for the Dialog
and its Window, resolving zero through `android:dialogTheme`. The signed
fixture uses its own resources, avoiding a second application resource table
with Maps' package ID. No native API is added.

The maintained V builder and signed-resource checker are in
`dialogthemefixture/main.v` and `dialogthemefixture/sources.v`. They produce one
Activity class, five color attributes, six styles, one layout and one view ID.
Runtime assertions cover explicit and inherited overlays; zero and one-argument
default selection; plain ContextWrapper delegation; and a missing-default case
created from a fresh Resources.Theme containing only the dedicated bare style.
That case explicitly verifies that android:dialogTheme is absent before creating
the Dialog and verifies retained bare colors with no fallback afterward.

Independent literal ARGB values distinguish each overlay and parent. A direct
Theme.setTo/applyStyle control verifies the resource path before testing Dialog.
The fixture checks fresh wrapper/theme identities, copied base attributes,
unchanged base theme and absent overlay attributes after every Dialog, and the
same wrapper across Dialog, Window, decor and inflated TextView. Both cached
and cloned inflater contexts are checked; cloning preserves the base inflater
context even when the input is a plain delegating ContextWrapper. Real packaged
textColor resolution and Dialog.setContentView/findViewById reach the existing
TextView native color getter. Dialogs remain unshown and are dismissed afterward.

The final signed APK is
`/Users/alex/.local/state/vinix/android/dialog-theme-fixture-2026-11-01-r2/probe.apk`,
SHA-256 `57e1bc1d8f1df2874be1c4837f169176e5fa88310f37ea99fd726c5f839a2161`.
Its build receipt SHA-256 is
`3e46f4b660ea25b9a98e687aaf2de28d25638981ad0ce98367589dfccbf86e2b`,
recording source revision `d5efefea8b424e155934408f1ed0f20e16721d67` and
complete generator/tool/input/artifact hashes. Source pins are:

| Source | SHA-256 |
| --- | --- |
| main.v | `9e4c53e291e98f2da187c147aacba703a062c712e93c6cbebb4d5c862ce00c05` |
| sources.v | `2cf24464e78edcb41755fb8f73a13ed35c6c2ad5d42012e36a793582a83e1ce4` |

Host checks passed exact 13-resource membership and IDs, six complete signed
style bags, parents, literal colors, android:dialogTheme reference, layout
attribute reference and view ID, and decoded wrap-content dimensions. The
signed layout selects colorSurfaceContainerLowest `0x7f010000` for TextView
`0x7f020000`; its layout is `0x7f030000`. Style IDs are Bare `0x7f040000`,
Base `0x7f040001`, Default `0x7f040002`, DefaultParent `0x7f040003`, Explicit
`0x7f040004`, and Inherited `0x7f040005`. Canonical one-class DEX roundtrips,
v3 signing, package/activity checks and complete input readback also passed.
Independent source/register/API/oracle review and final signed-artifact review
passed, including the complete resource bags, layout and compiled Smali.

| Successful host phase | Seconds | Sampled aggregate RSS bytes |
| --- | ---: | ---: |
| Generator compile | 5.094 | 342,704,128 |
| Signed fixture production | 21.555 | 102,023,168 |

Both guards and children exited zero with complete cleanup and zero swaps under
the unchanged 600 MiB aggregate RSS, 300-second, 512 MiB shared-growth, 1 GiB
reserve and file-size caps. Evidence roots are
`/Users/alex/.local/state/vinix/android/dialog-theme-fixture-controls-2026-11-01-r2`
and `dialog-theme-fixture-2026-11-01-r2` under the same parent.

The original r1 controls and artifact roots are preserved in full. Its generator
compiled and its DEX/resources/signature passed, then the checker rejected an
incorrect assumption about the qualified aapt XML dump format: wrap-content is
decoded as `-2`, rather than a generic typed hexadecimal integer. Only that
exact representation expectation changed before the fresh r2 compile and full
production run. The failed production guard exited one with complete cleanup;
no resource oracle, artifact membership or historical evidence check was relaxed.

The joint 16-root producer/source/caller/fixture seal and separate fresh-process
full readback passed for 20,570 typed entries, including all four r1/r2 fixture
roots and the original source/caller bundles. Manifest
`/Users/alex/.local/state/vinix/android/dialog-theme-producers-sealed-2026-11-01-r1/sealed/manifest.json`,
SHA-256 `21f05fa4110985523c32885b944da3fcceed2b45defae22370f2624b81b5582e`;
the adjacent roots.txt records exact membership. Seal/check took 3.565/1.123
seconds at sampled RSS 28,295,168/24,576,000 bytes. Both guards/children exited
zero with complete cleanup under unchanged 600 MiB, 900-second, 64 MiB
shared-growth, 1 GiB reserve and file-size caps. Every complete original bundle
remains required by its historical auditor.

The exact runtime marker is
`DIALOG-THEME-PASS explicit default inherited contexts inflation isolation missing-default`.
Host qualification does not establish ARM execution or a working Maps account
dialog. The pinned SDK/native compatibility audit and live run remain separate.
