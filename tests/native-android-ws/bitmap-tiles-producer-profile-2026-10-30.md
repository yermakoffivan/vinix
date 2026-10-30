# Bitmap drawable tiling producer profile, 2026-10-30

The additive `--bitmap-tiles` framework profile accepts only the complete
persistent-data framework baseline at
`/Users/alex/.local/state/vinix/android/combined-account-webview-persistent-data-block-framework-2026-10-30-r1`:
manifest `a6d34af62a2b8fd6f85c84dd36493d47b3eefa9690cf875c7ac0e67abe882858`,
JAR `7c1b2fa03924003c7717e07ef463bff81c6429c7667b2bc42d35954fb6d41752`.
The complete class count remains 2,106, with exactly one changed class,
`android.graphics.drawable.BitmapDrawable`.

The explicit member scope replaces `getPaint` and `setTileModeX`, adds public
Y/XY setters, X/Y getters and `draw`, a private tile-mode converter and a private
static native drawing bridge. The Y setter retains its public/final Android ABI.
The bridge takes strong Bitmap and Paint references, including a temporary Paint
returned by an overridden getter, throughout native drawing.
Three new private fields retain the two nullable tile modes and one Paint.
No constructors, other existing methods, fields, class metadata or classes may
change. Before assembly and after complete DEX disassembly, checks enforce
public and private/static method flags and a declaration-only native bridge.
Full class inventories and
all other JAR entry payloads must remain equal to the pinned baseline.

The maintained producer self-tests reject missing/duplicate/wrong-access fields,
changed retained members, invalid method flags, unrelated class changes,
missing or substituted BitmapDrawable and new classes. Existing producer tests
remain enabled. This profile does not itself establish correct pixels or a
successful Google account screen; the provider and runtime require their own
checks.

Working source is based on repository revision `460360b7a`. The final builder
compilation and complete self-test passed under the unchanged 600 MiB aggregate
RSS, 300-second, 1 GiB reserve and 512 MiB observed-growth limits. Compilation
took 2.418 seconds at 347,815,936 sampled RSS bytes; self-tests took 0.281 seconds
at 1,245,184 sampled RSS bytes. Both guard/child exits were zero with complete
cleanup and zero reported swaps. Complete controls are retained at
`/Users/alex/.local/state/vinix/android/bitmap-tiles-framework-builder-2026-10-30-r3`.
Builder source SHA-256:
`1c145ffdf5b4eb205da48544cecb2b62678f2983b9027d6a8a73e36bafdadae4`.
Qualified executable SHA-256:
`b04662ecc1b0280ee48f866b53694834e9ab060937cb50942d935ec9ad417853`.

The earlier builder qualifications remain retained in the adjacent `r1`/`r2` roots;
the final profile delegates clipped pixel sampling to the native renderer.

Full framework production and the coupled native build remain pending.
