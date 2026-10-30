# Window animations producer profile, 2026-10-30

The additive `--window-animations` framework profile accepts only the complete
bitmap tiling framework baseline at
`/Users/alex/.local/state/vinix/android/combined-account-webview-bitmap-tiles-framework-2026-10-30-r1`:
manifest `bf8626569c82826e4d6b6379a3e2266741db3d2919d2eda4cf647b18c5b5f7df`,
JAR `741641c30098cf2f682672889c7ac653c6b2f23b9c09001a7af8f56bb01d9500`.
The complete class count remains 2,106. Exactly five methods are added to four
existing classes: Window's public setter and protected attribute dispatcher,
the public abstract Window.Callback notification and Activity/Dialog's public
implementations. No existing method, field or class metadata may change.
LayoutParams already supplies `windowAnimations`; its complete class is preserved.

ABI checks run before assembly and after complete DEX disassembly. They enforce
exact method flags and a declaration-only interface method. Maintained focused
self-tests reject changed flags, interface bodies, unrelated member/class
changes, missing or substituted targets and new classes. All existing producer
self-tests remain enabled. The compositor does not execute Android animation
resources; this repair supplies attribute storage and callback propagation.

Qualification is based on working source over revision `5a3428975`. The final
Boehm builder compilation and complete self-test passed under unchanged 600 MiB
aggregate RSS, 300-second, 1 GiB reserve and 512 MiB observed-growth limits.
Compilation took 2.279 seconds at 347,602,944 sampled RSS bytes; self-tests took
0.287 seconds at 15,187,968 bytes. Both guard/child exits were zero with complete
cleanup and zero reported swaps. Complete controls remain at
`/Users/alex/.local/state/vinix/android/window-animations-framework-builder-2026-10-30-r2`.
Source SHA-256 `6193fba136d8f4d624aa33e8002ca39bc621a8d0bcfb8812704a6888d85d64f1`;
executable SHA-256 `61fee5271db99405743b56de9f73d95e53491e98075db9d80d6974368df62451`.
The initial compilation rejected an ambiguous map literal; its unchanged source,
failed log and original guard receipt remain in the adjacent `-r1` root.

The [full framework/native pair](window-animations-pair-2026-10-30.md) and its
path-provenance proof now pass production and complete evidence readback.
ARM runtime validation remains separate.
