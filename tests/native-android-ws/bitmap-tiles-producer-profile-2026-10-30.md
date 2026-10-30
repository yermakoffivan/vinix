# Bitmap drawable tiling producer profile, 2026-10-30

The additive `--bitmap-tiles` framework profile accepts only the complete
persistent-data framework baseline at
`/Users/alex/.local/state/vinix/android/combined-account-webview-persistent-data-block-framework-2026-10-30-r1`:
manifest `a6d34af62a2b8fd6f85c84dd36493d47b3eefa9690cf875c7ac0e67abe882858`,
JAR `7c1b2fa03924003c7717e07ef463bff81c6429c7667b2bc42d35954fb6d41752`.
The complete class count remains 2,106, with exactly one changed class,
`android.graphics.drawable.BitmapDrawable`.

The explicit member scope replaces `getPaint` and `setTileModeX`, adds public
Y/XY setters, X/Y getters and `draw`, and adds three private tiling helpers.
Three new private fields retain the two nullable tile modes and one Paint.
No constructors, other existing methods, fields, class metadata or classes may
change. Public and private/static helper method flags are checked separately
before assembly and after complete DEX disassembly. Full class inventories and
all other JAR entry payloads must remain equal to the pinned baseline.

The maintained producer self-tests reject missing/duplicate/wrong-access fields,
changed retained members, invalid method flags, unrelated class changes,
missing or substituted BitmapDrawable and new classes. Existing producer tests
remain enabled. This profile does not itself establish correct pixels or a
successful Google account screen; the provider and runtime require their own
checks.

Working source is based on repository revision `275c7f369`. The first builder
compilation and complete self-test passed under the unchanged 600 MiB aggregate
RSS, 300-second, 1 GiB reserve and 512 MiB observed-growth limits. Compilation
took 2.610 seconds at 346,521,600 sampled RSS bytes; self-tests took 0.370 seconds
at 1,245,184 sampled RSS bytes. Both guard/child exits were zero with complete
cleanup and zero reported swaps. Complete controls are retained at
`/Users/alex/.local/state/vinix/android/bitmap-tiles-framework-builder-2026-10-30-r1`.
Builder source SHA-256:
`9fe0bf1fbb9ea56a72438107bdf253b4d5840f146b45d42b85f7b27ff40546be`.
Qualified executable SHA-256:
`9a1df83dd9273598291f146946deb31dc8ee7ec26aceb2af9d5dc6d4b1c00f41`.

Full framework production and the coupled native build remain pending.
