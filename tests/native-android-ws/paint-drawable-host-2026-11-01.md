# PaintDrawable caller and signed fixture, 2026-11-01

Maps' admitted classes3.dex caller `caan.C(Context,cmaz)` constructs a
PaintDrawable with an ARGB color, converts an 8dp radius, sets that radius and
the inherited intrinsic width/height, then returns the drawable. The selected
caller audit uses the unchanged Maps APK `6218d72f48b184eb71f68879bce48cb9ebb2b510be7f7cff88217ea3fd592bb2`.
Its ten filtered disassemblies and input readback passed. The API provider is
committed as `a13caf3e9`; it adds one class, five methods and no fields.
Focused checks passed 137 refusals and the full 2,107-to-2,108-class DEX
roundtrip, with all 2,107 original classes unchanged. No native API is added.

The retained AOSP Android 10 r47 PaintDrawable source has SHA-256
`5d853592c54eb435d2b651cd5e0d7b00f7dfde210b6c354b263b1d76809d3519`.
The implementation delegates to the existing ShapeDrawable and RoundRectShape,
including array validation/storage, callback behavior and superclass XML
fallback. XML corner order remains the primary source's TL/TR/BL/BR order.
The complete original caller/framework inputs remain required by their auditors.

The dedicated signed APK is
`/Users/alex/.local/state/vinix/android/paint-drawable-fixture-2026-11-01-r1/probe.apk`,
SHA-256 `cd459b703196920a7e07e1bfdb7d43e304c1115b12b1ad0998281fab1ea64868`.
Its build receipt is `f9436819459504fc822f0ae202893efc4320d1d5e421b8010c80a68b3c1c6bed`,
recording source revision `0f95f2c1b45ccaf4bbf85056dd5ce123af2b2a7b` and complete source/tool/artifact pins.
Generator sources are `main.v`
`14c4a113fbaedd8029673ebd05ad0793df4c0367f022640c64f1ae998893b17c`
and `sources.v`
`3d9f9d2452f385e7969fb0d9e0f5549762f366e8bb955358d05392e3e097e719`.

Prepared runtime assertions cover default/colored construction and inherited
Paint identity; uniform, nonpositive and NaN corner selection; repeated setters;
exact one/two invalidation counts; delegated short-array exceptions with zero
callbacks/state preservation; valid nine-entry arrays; and retained radii-array
references proved by mutation followed by a real bounds resize. Offscreen
Canvas(Bitmap)/Bitmap.getPixels checks cover complete 16-by-16 rectangular
grids, alpha, color changes, empty bounds, positive/negative translation,
clipping, rounded/nonuniform interior/exterior pixels, and Paint/Canvas-state
restoration. Rounded samples avoid antialiased boundary assumptions. No new
test-only native sampler is required.

Four packaged XML resources exercise uniform/asymmetric corners, positive-to-zero
reset and inherited padding fallback. Automated signed-dump checks verify exact
resource IDs, tags and attribute presence; independent manual inspection also
verified the final typed values: radius 4px, asymmetric TL/BL 0px, ordered 4-to-0px
reset and padding L/T/R/B 1/2/3/4px. Independent source/register/oracle and final
signed-artifact reviews passed. One-class canonical DEX roundtrips, v3 signing
and package/activity checks passed; no malformed or failed build attempt occurred.

| Host check | Seconds | Sampled aggregate RSS bytes |
| --- | ---: | ---: |
| Fixture generator compile | 2.232 | 326,270,976 |
| Signed fixture production | 7.987 | 105,857,024 |

All guards/children exited zero with complete cleanup and zero swaps under the
unchanged 600 MiB aggregate RSS, 300-second, 512 MiB shared-growth, 1 GiB reserve
and file-size caps. Six complete host roots are closed beneath
`/Users/alex/.local/state/vinix/android`: `paint-drawable-host-controls-2026-11-01-r1`,
`paint-drawable-source-checks-2026-11-01-r1`,
`maps-paint-drawable-caller-audit-2026-11-01-r1`,
`maps-paint-drawable-caller-controls-2026-11-01-r1`,
`paint-drawable-fixture-controls-2026-11-01-r1` and
`paint-drawable-fixture-2026-11-01-r1`.

Complete joint sealing and separate fresh-process full readback passed for
9,102 entries. Manifest
`/Users/alex/.local/state/vinix/android/paint-drawable-host-sealed-2026-11-01-r1/sealed/manifest.json`,
SHA-256 `21aa74678e6933fa52541c2c606a8ef41f69adcb5dd32de1be917a9c10ee9627`.
Seal/readback took 2.557/1.079 seconds at sampled RSS 23,789,568/23,986,176 bytes.
Both guards/children exited zero with complete cleanup and zero swaps under
the unchanged 600 MiB, 900-second, 64 MiB shared-growth, 1 GiB reserve and
file-size caps. No sealing attempt failed. Retain every complete original
framework/Maps bundle required by the historical source and caller auditors.

The exact marker is
`PAINT-DRAWABLE-PASS constructors corners invalidation arrays pixels inflation canvas-state`.
Host qualification does not establish ARM pixels or a working Maps profile
menu. The subsequent SDK/native compatibility audit and live run remain separate.
