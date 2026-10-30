# Bitmap drawable tiling host validation, 2026-10-30

Google's `SetupWizardLayout.a(AttributeSet,int)` calls
`BitmapDrawable.setTileModeXY(REPEAT, REPEAT)` before assigning its background.
The selected call is the source-130 failure in the preceding account-window
run. The pinned SDK lacks that method and discards X tiling; storing a
BitmapShader alone cannot render it because the current shader backend also
discards its modes. The complete retained caller audit is listed below.

The new provider retains nullable X/Y state, preserves the other axis for an
individual setter, invalidates only a changed pair and returns one retained
Paint. Its draw override preserves the inherited path when both modes are null.
Active tiling calls the native clipped sampler through Bitmap/Paint object
references. A null individual axis clamps, and drawable bounds clip the pattern
at the Canvas origin. No general shader backend or density scaling is claimed.

Validation used working sources over `275c7f369d1252544b6935ff66e3da16b77cdc59`
and the complete preceding framework at
`/Users/alex/.local/state/vinix/android/combined-account-webview-persistent-data-block-framework-2026-10-30-r1/new-dex`.
The isolated checker uses the actual provider and extracts its actual method
replacement helper. Twenty-six malformed, duplicate, missing and already
extended inputs are refused without a file mutation. It verifies that only
the two retained stubs change, seven methods and three fields are added, and
the private native bridge has the exact object-reference ABI. API-28 DEX
assembly and disassembly preserve all resulting method instructions and the
six neighboring Bitmap, BitmapShader, Canvas, Paint, TileMode and Drawable
classes. This establishes bytecode structure; ARM behavior is a separate check.

The signed standalone APK is ready at
`/Users/alex/.local/state/vinix/android/bitmap-tiles-fixture-2026-10-30-r2/probe.apk`,
SHA-256 `d4aedf04a871758249fbea08e79a7ac49f9fdb2eb98f915f6a7c8ee389fede7c`.
Canonical one-class DEX roundtrip, APK v3 verification, package and activity
checks passed. Its source uses explicit Bitmap.setPixels because the existing
colors-array creation overload ignores its input. Planned ARM assertions cover:

- Default null modes, independent X/Y setters, XY reset, exact change callbacks
  and retained mutable Paint identity.
- Sixteen complete 8×8 pixel grids using a four-color 2×2 source: every
  repeat/mirror/clamp pair, nullable axes, shifted and negative bounds, translated
  negative coordinates, explicit clipping, paint alpha and INT_MIN/INT_MAX bounds
  over a small destination. The last case catches work proportional to tile count.
- Clear targets for a null bitmap and empty bounds, plus matrix/save-stack
  preservation around every tiled draw.

The marker is exactly
`BITMAP-TILES-PASS modes reset invalidation stable-paint pixels-repeat-mirror-clamp nullable-axis`.
No ARM execution or Google authentication success is established by this host
report. The preceding account failure remains the live baseline until a new run.

All six complete host/audit roots are retained beneath
`/Users/alex/.local/state/vinix/android`:

- `bitmap-tiles-fixture-controls-2026-10-30-r1`.
- `bitmap-tiles-source-checks-2026-10-30-r1`.
- `bitmap-tiles-fixture-2026-10-30-r1` and `bitmap-tiles-fixture-2026-10-30-r2`.
- `gms-bitmap-tile-method-2026-10-30-r1` and
  `gms-bitmap-tile-method-controls-2026-10-30-r1`.

The initial fixture remains preserved; r2 strengthens the oracle and negative
coordinate coverage. One checker compile failed on Option propagation syntax;
its complete controls remain, and the corrected compile passed. All final
checks exited zero with complete cleanup and zero reported swaps under the
original 600 MiB aggregate RSS, 300 seconds, 512 MiB shared-growth, 1 GiB
reserve and file-size limits.

| Final check | Guard seconds | Sampled aggregate RSS bytes |
| --- | ---: | ---: |
| Checker compile | 1.258 | 330,579,968 |
| Provider/source/DEX check | 6.750 | 231,243,776 |
| Fixture generator compile | 1.274 | 314,359,808 |
| Signed fixture production | 5.758 | 84,508,672 |

The six roots passed complete sealing and separate fresh-process full readback:
172 entries, manifest
`/Users/alex/.local/state/vinix/android/bitmap-tiles-host-sealed-2026-10-30-r1/sealed/manifest.json`,
SHA-256 `be887958e51172d8767cee92b5f4b8f7c7d29cb3e0476ae6f41230465684a82d`.
The unchanged auditors retained the original 600 MiB/900-second/64 MiB
shared-growth/1 GiB-reserve caps and passed with complete cleanup and zero swaps.
Retain the original complete GMS/framework bundles required by the selected
caller audit; this focused bundle does not replace them.

| Source | SHA-256 |
| --- | --- |
| SDK provider | `f46309f337b205dce3341caf411278d199dba9234b54e4fadc54cfe12252633e` |
| Source-check driver | `2279d6ae984a885896cf15f6bfc4d862e52d533bc88d00566ab504360308e34e` |
| Isolated checker | `8c0de5144a0e82763bb798d7bfd57742c5c1ec4be37f0766d5b6246a91766e15` |
| Final fixture generator source | `553fbf8e92e4befc451acc806c176b54e38709c4cfe572321c421e06f7ed4db9` |
