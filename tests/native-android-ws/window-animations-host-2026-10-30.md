# Window animation attributes, 2026-10-30

The Maps avatar/account flow reaches a missing `Window.setWindowAnimations(I)V`.
This repair stores the supplied resource ID on the existing LayoutParams object
and always dispatches the attributes callback, including repeated values and
zero resets. It adds five methods across Window, Window.Callback, Activity and
Dialog. Activity updates attached decor through its WindowManager; Dialog
updates shown decor. All existing methods/fields and LayoutParams remain exact.
Execution of visual animation resources is outside this change.

Focused checks used working sources over
`7d2f1d0f1230ec356fa3c046d89dda55c4b4755c` and the retained bitmap framework at
`/Users/alex/.local/state/vinix/android/combined-account-webview-bitmap-tiles-framework-2026-10-30-r1/new-dex`.
The isolated actual provider passed 79 malformed/repeated/missing-input refusals,
including transactional wrapper checks. The instruction/flag oracle verifies
exactly five additions, preservation of every existing method and field, and
byte-identical LayoutParams. Complete API-28 DEX assembly/disassembly roundtrips
all five classes. The first isolated compile exposed Option propagation syntax
unsupported by the retained compiler; the corrected provider changes no emitted
method behavior. Failed controls and complete inputs remain preserved.

The signed six-class standalone APK is
`/Users/alex/.local/state/vinix/android/window-animations-fixture-2026-10-30-r1/probe.apk`,
SHA-256 `b78a43516d2f5f42ec7686c39acd81b3612402d80eb25ccd854de512fd6119a6`.
Its complete canonical DEX roundtrip, APK v3 signature and package/activity checks
passed. Fixture source is in `windowanimationsfixture/main.v` and `sources.v`;
both full source files are captured and pinned alongside the generator.

The fixture checks default/set/reset/negative/same-value calls, protected virtual
dispatch, exact attributes alias and mutation-before-callback order. Reflection
compares every unrelated public instance attribute against its seeded snapshot.
It exercises null and replaced callbacks, nested setter dispatch, the exact
identity of a throwing callback's exception, retained mutation and subsequent
callback reuse. A recording WindowManager checks base Activity's null-window and
unattached no-ops, then its update after a real container addView. Dialog tests
use the existing real show/hide/isShowing path on the main Looper while recording
WindowManager updates, covering pre-show, shown repeated/reset and hidden calls.
These are prepared ARM assertions; host qualification establishes no ARM result
or visible animation behavior.

| Final check | Guard seconds | Sampled aggregate RSS bytes |
| --- | ---: | ---: |
| Source-check driver compile | 1.265 | 336,658,432 |
| Provider/source/five-class DEX check | 6.995 | 218,300,416 |
| Fixture generator compile | 1.364 | 331,087,872 |
| Signed six-class APK production | 5.624 | 90,783,744 |

All final guards and children exited zero with complete cleanup and zero swaps.
Original caps remained 600 MiB aggregate RSS, 300 seconds, 512 MiB observed
shared-volume growth, 1 GiB reserve and the file-size limit. Fixture/compiler
work was complete when these host roots closed.

Four complete closed roots beneath `/Users/alex/.local/state/vinix/android` are
`window-animations-fixture-controls-2026-10-30-r1`,
`window-animations-source-checks-2026-10-30-r1`,
`window-animations-source-checks-2026-10-30-r2` and
`window-animations-fixture-2026-10-30-r1`. Full sealing and separate fresh-process
readback passed for 145 entries, manifest
`/Users/alex/.local/state/vinix/android/window-animations-host-sealed-2026-10-30-r1/sealed/manifest.json`,
SHA-256 `296ca50bc13a1858f63a0c8d4c007ffdd25cce8178589e5a640a0f0370878249`.
Audit caps stayed 600 MiB/900 seconds/64 MiB shared growth/1 GiB reserve.

| Source | SHA-256 |
| --- | --- |
| SDK provider | `ee414e021f2eed17c8ee43cf9f806f61e74480f45e6488c5b3808cb076a6a60b` |
| Source-check driver | `1021b2605588858530010d7dfd708f52adabeeabbb14e7d47b2e60d4a647554a` |
| Isolated checker | `7525ecd732b01beccd43c85eca33601b8462305641f3841b9ecacd526c9a5d4a` |
| Fixture builder | `a2cea48c806cd0d8bd9673630ce71aee13e8e74c0a716ab206101a14872f5d97` |
| Fixture cases | `c95718a5d9084d9b5749454bb35471166bc0c424965bf06b89594090579601ed` |

The exact marker is
`WINDOW-ANIMATIONS-PASS attributes alias always-dispatch callbacks reentrancy exceptions activity dialog`.
