# Maps avatar caller audit, 2026-10-30

The bounded immediate successor path after Maps' failing
`Window.setWindowAnimations(I)V` call contains no concrete additional missing
Window/WindowManager API. The next validation is the live avatar path with
the [Window fix](window-animations-host-2026-10-30.md), source revision
`e0316391f38d26eb3d76d2ea40516182286a14d7`. This read-only audit does not establish
successful dialog inflation, animation rendering or Google authentication.

The input is Maps 26.42.01.997557324, original
`build/android-maps/GoogleMaps.apk`, SHA-256
`6218d72f48b184eb71f68879bce48cb9ebb2b510be7f7cff88217ea3fd592bb2`;
its hash was rechecked. Retained DEX and qualified disassembly tools come from
`/Users/alex/.local/state/vinix/android/maps-token-method-audit-evidence-2026-10-26-r2`.
The inspected retained SDK is
`combined-account-webview-window-animations-framework-2026-10-30-r1/smali`
under the same external state directory (`S`). Neither APK nor code was changed.

The actual caller is `classes7.dex` `bqpt.vm(Bundle)`, code offset 0x24,
source 37. Its superclass creates AppCompat Dialog `ex`; both first-creation
and saved-state branches set the Window animations, then return that same
Dialog. There is no following Window/WindowManager call in `vm`.

The returning `as.oB` path configures the dialog and clones its inflater in
the dialog context. Its virtual `t` resolves to `ey.t`: optional existing
`Window.addFlags(0x18)`, then feature 1 through `ex.f` and delegate `ev.u`.
That feature branch checks the delegate's content-installation guard and sets
its own boolean; it makes no Window call. The generic other-feature fallback
uses the already-present `Window.requestFeature(I)Z`. The inspected later
dialog show/decor, avatar helper `bqor.b`, and adjacent transaction dispatch
methods supply no additional missing Window/WindowManager call. This conclusion
is bounded to the selected stack methods, not all later content or lifecycle.

Conditional retained gaps exist in Dialog state paths: `as.qy(Bundle)` calls
`Dialog.onSaveInstanceState()`, while `as.rt(Bundle)` and `sp(...)` can call
`Dialog.onRestoreInstanceState(Bundle)`. Neither descriptor is present in the
inspected SDK Dialog or its Object parent. Fresh avatar creation was not shown
to execute these paths, so the audit does not identify them as the immediate
blocker or extend the Window fix to cover them.

Twelve selected smali classes were retained through eleven strictly filtered
Java calls; no whole-DEX disassembly or compiler ran. Each call used the original
600 MiB aggregate RSS, 300-second, 512 MiB observed-growth and 1 GiB reserve
guards, Java Xmx256m/two CPUs and file-size ulimit 16777216. All eleven calls
exited zero with complete cleanup and zero swaps; total guarded time was
4.012 seconds, highest sampled/time-reported RSS 110,100,480/113,426,432 bytes.
Input/tool and selected-file final rechecks passed. The initial screenshot
transcription overselected Parcel-state class `cj`; the actual `ag.d`
transaction method was also retained and inspected.

Complete original roots `S/maps-avatar-caller-audit-2026-10-30-r1` and adjacent
`S/maps-avatar-caller-controls-2026-10-30-r1` remain closed. They passed sealing
and a separate fresh-process full readback: two roots, 55 entries,
`S/maps-avatar-caller-sealed-2026-10-30-r1/sealed/manifest.json`, SHA-256
`17d84b8a96a8b70ed091559aced8d65653f4890e65d712f6f6fc3eaa93f4fbf9`.
The unchanged qualified sealer ran without compilation during an agreed quiet
window. Seal/readback guard time was 81/268 ms; time-reported RSS was
21,594,112/12,140,544 bytes. Both guard/child exits were zero with complete
cleanup and zero swaps under the original 600 MiB RSS/900-second/64 MiB shared
growth/1 GiB reserve caps. No sealing attempt failed. Retain the complete
original roots and their historical input bundles; earlier sealed roots remain
unchanged.
