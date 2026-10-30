# Seed account options producer profile — 2026-10-30

The full framework builder accepts `--seed-account-options` over the exact
Window system-UI baseline (manifest
`1e24a8dcc2f5b315ebbb63cb06d3de46e0799b4b1a0d19339d3b98ecab0c3b09`,
JAR `3f0d220a24e7d91a47f7b2d42cd5620aa498981e915a90cdbd806164b8ef0fc1`).
The profile preserves all 2,105 classes and confines member changes to:

| Class | Existing methods changed | Methods added | Fields added |
| --- | --- | --- | --- |
| UserManager | 0 | public `getSeedAccountOptions()LPersistableBundle;` | 0 |
| PersistableBundle | 0 | static constructor | public static final `EMPTY` |
| ArrayMap | static constructor | 0 | 0 |

The provider supplies the unseeded null getter, the actual caller's immutable
empty-bundle fallback, and the prerequisite ArrayMap initialization order.
The producer checks exact method/field ABI before assembly and after DEX
roundtrip, and retains complete class/member delta checks. Its maintained
self-tests reject wrong flags, extra or missing members, changed existing
methods, and unrelated class changes. All existing producer self-tests passed.
None of these classes occurs in the native binding specification; a fresh
coupled native build remains required and may produce identical native bytes.

The builder source snapshot and compiled executable are retained under
`/Users/alex/.local/state/vinix/android/seed-account-options-framework-builder-2026-10-30-r1`.
Serial host compilation passed in 2.641 seconds, peaking at 357,203,968 aggregate
RSS bytes. Compilation and self-tests retained the original 600 MiB,
300-second, 1 GiB reserve and 512 MiB observed-growth guards. A first guard
argument refusal is documented there; it did not execute the compiler.

This qualifies the additive producer profile. Full framework/native output,
the separate GMS companion controller, and ARM runtime validation follow it;
no Google sign-in or imagery result is claimed by these host checks.
