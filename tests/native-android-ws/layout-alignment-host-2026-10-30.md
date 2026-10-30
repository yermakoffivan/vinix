# Layout stored accessors, 2026-10-30

The Maps avatar failure reaches a missing Layout.getAlignment() during text
measurement. The selected Maps caller also references missing getSpacingAdd().
Feature `74968571b` appends these two public final accessors to Layout, reading
its existing private alignment and additive-spacing fields. It preserves enum/
null identity and raw float state, every existing field/method, the legacy
misspelled getSpacing_add(), Builder behavior and native rendering paths.

The bounded caller audit covers all ten root DEX files of the unchanged Maps APK
`6218d72f48b184eb71f68879bce48cb9ebb2b510be7f7cff88217ea3fd592bb2`.
Three selected classes contain five genuine getAlignment invokes. Litho's
`lre.ae` compares the returned reference and conditionally reads getSpacingAdd;
it does not immediately dereference a null alignment. The wrapper `lga.a` is
not a direct Layout caller. Its precise failing call is not established by the
wrapper-only stack. A conditional getLineBounds(I,Rect)I reference remains a
separate missing geometry API; this repair does not implement it.

StaticLayout.Builder currently creates a layout with null alignment and its
setAlignment is inert. The selected audit does not justify changing those
construction semantics to repair a missing accessor. The fixture explicitly
retains this limitation. The full caller audit, DEX selector source/executable,
selected classes and exact original input pins are retained below; the maintained
selector is `maps-layout-alignment-caller-select.v` in this directory.

Source checking isolated the actual provider and passed 39 malformed/repeated
input refusals. Complete API-28 DEX assembly/disassembly roundtrips all 2,106
classes: exactly two final getters are appended, all retained Layout members
stay exact, and all 2,105 neighboring classes remain byte-identical. Independent
read-only provider/checker review passed. Source feature is `74968571b`; focused
qualification used working sources over `19608994a73c23b17f5e49b3ac3ca2d9ff8f48a7`.

The signed standalone APK is
`/Users/alex/.local/state/vinix/android/layout-alignment-fixture-2026-10-30-r1/probe.apk`,
SHA-256 `d0a5f8524c5d135cce08705946d72487947b637b0d7c1c7fa77994a323111fd6`.
Two-class canonical DEX roundtrip, APK v3 signature, package and launch-activity
checks passed. Source in `layoutalignmentfixture/main.v` and `sources.v` reuses
the existing signing conventions and captures both complete source files.

Prepared ARM assertions exercise all five Alignment enums and null through all
four retained StaticLayout constructors, BoringLayout and a direct protected
Layout subclass. The 84 constructor cases also cover additive spacing raw bits
for signed zero, negative finite values, a quiet NaN payload, both infinities,
minimum subnormal and maximum finite float. They compare the new accessor to
the legacy getter and verify retained spacing multiplier, exact text/Paint
identity, paint state and native metrics before/after repeated reads. Builder
controls check its existing null/zero defaults, same built-layout identity and
inert setAlignment. Independent fixture register/oracle review passed. This
host report establishes no ARM, visual text-alignment or Google login result.

| Final check | Guard seconds | Sampled aggregate RSS bytes |
| --- | ---: | ---: |
| Source driver compile | 1.267 | 357,777,408 |
| Provider/refusals/full DEX check | 14.358 | 395,952,128 |
| Fixture generator compile | 1.276 | 311,115,776 |
| Signed fixture production | 5.720 | 88,768,512 |

All final guards and children exited zero with complete cleanup and zero swaps.
The original 600 MiB aggregate RSS, 300-second, 512 MiB observed shared-growth,
1 GiB reserve and file-size caps remained enforced. No failed focused source or
fixture build attempts occurred.

Six closed roots below `/Users/alex/.local/state/vinix/android` are retained:

- `layout-alignment-host-controls-2026-10-30-r1`.
- `layout-alignment-source-checks-2026-10-30-r1`.
- `layout-alignment-fixture-controls-2026-10-30-r1`.
- `layout-alignment-fixture-2026-10-30-r1`.
- `maps-layout-alignment-caller-audit-2026-10-30-r1`.
- `maps-layout-alignment-caller-controls-2026-10-30-r1`.

Complete sealing and separate fresh-process full readback passed for 9,070
entries, manifest
`/Users/alex/.local/state/vinix/android/layout-alignment-host-sealed-2026-10-30-r1/sealed/manifest.json`,
SHA-256 `9aa58a1e423299495dcf202648209717d09240cee499b05c6859846c8115a060`.
Both retained 600 MiB/900-second/64 MiB shared-growth/1 GiB-reserve caps, with
zero exits and complete cleanup. Retain the complete original GMS/SDK bundles
required by the caller audit; this selected evidence does not replace them.

The exact marker is
`LAYOUT-ALIGNMENT-PASS enums nullable constructors identity spacing-bits builder-retained`.
