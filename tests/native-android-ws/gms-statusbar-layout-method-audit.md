# GMS status-bar template constructor audit, 2026-10-30

The Window-field runtime's private log last showed creation of
`com.google.android.setupcompat.view.StatusBarBackgroundLayout` while inflating
`sud_glif_template`. The broker exited with code 1 without a new exception in the
inspected tail. That last log line does not establish where execution stopped.

The actual StatusBar class has three constructors: Context, Context/AttributeSet,
and Context/AttributeSet/int. Each invokes only the corresponding FrameLayout
superclass constructor and returns. Its static constructor creates a `gjbi`
logger; the logger's constructor builds a string prefix. These constructors
contain no additional SDK field access or application exit call.

The selected template path is `TemplateLayout.a` → virtual `GlifLayout.m` →
`TemplateLayout.u` → `LayoutInflater.inflate(resource, this, false)`. Partner
customization `gixv` constructs the status-bar mixin `gjaz` after its TemplateLayout
superclass returns. That mixin installs the drawable and updates `setWillNotDraw`,
`setFitsSystemWindows` and invalidation. None of the eight selected classes
references `System.exit`, `Runtime.exit` or `Runtime.halt`.

A concrete later-callback API gap remains: StatusBar's `onApplyWindowInsets`
invokes the FrameLayout superclass method, but the pinned FrameLayout → ViewGroup
→ View hierarchy declares no `onApplyWindowInsets(WindowInsets)`. Its other
immediate inset/drawing APIs exist. `requestApplyInsets` exists but is a no-op.
The constructors do not call this callback; this audit does not establish that
the gap caused the observed exit. The frozen FrameLayout/View native constructor
path also contains no explicit exit: `View.native_constructor` resolves through
`ws_binding_173` to `ws_view_new(0)`, and constructor native setters update widget
state. Further runtime evidence is required to identify the failed boundary.

Paths below use `S=/Users/alex/.local/state/vinix/android`:

- Eight selected classes and review receipt:
  `S/gms-statusbar-layout-method-2026-10-30-r1`.
- Complete command controls:
  `S/gms-statusbar-layout-method-controls-2026-10-30-r1`.
- Full 24-root, 19,370-entry seal and separate-process readback:
  `S/gms-statusbar-layout-method-evidence-2026-10-30-r1/sealed/manifest.json`, SHA-256
  `b7e4ff207ffcaa176065322ffb90b44a03b4e9816231ff449629c98e96df0bcf`.

StatusBar output SHA-256 is
`10abe1de76ed6df38db3b53ccc20e12c9a89f4311226d00d8c80c3be5bf9ba6c`.
All fifteen frozen class-definition listings identify sole owners: classes3.dex
for TemplateLayout, GlifLayout and gixv; classes12.dex for StatusBar, gjaz, gjba,
gjar and gjbi. Both complete prior GMS evidence and the exact Window framework/native
producer seal passed full readback before the new seal. Recorded checkout base
was `7cf2a44e22ccd831a7c5c95e75d26d149f54011d`; comparison used framework manifest
`1e24a8dcc2f5b315ebbb63cb06d3de46e0799b4b1a0d19339d3b98ecab0c3b09`.

Each selected extraction used the unchanged Java/tool closure, a 256 MiB heap,
two active processors, two jobs and explicit class selectors. Every extraction
passed 600 MiB RSS, 300-second, 512 MiB observed-growth and 1 GiB-reserve guards;
peak sampled RSS stayed below 105 MiB. Seal and fresh readback passed in
3.273/1.755 seconds under 600 MiB RSS, 900-second, 64 MiB growth and 1 GiB-reserve
caps. All guard/child exits were zero with complete cleanup. No app was patched
and no authentication or rendering success is claimed.
