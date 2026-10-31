# Bundle booleans and absent cross-profile service producer, 2026-10-31

The additive `--bundle-cross-profile` SDK profile accepts only the complete
UserManager framework at
`/Users/alex/.local/state/vinix/android/combined-account-webview-user-restrictions-framework-2026-10-31-r3`:
manifest `2e3b4a212238fc14a47b6cc72d1abde24c95a26e379ecd79f99f54527314040c`,
JAR `646a83ea74795fb29b4db8811fc3249add3693b6e2de03e043c52e4e13b09bdc`.
The complete class set changes from 2,106 to 2,107 classes.

| Target | Exact scope |
| --- | --- |
| BaseBundle | One existing `getBoolean(String, boolean)` instruction reverses the String.equals receiver/argument, preserving the full remaining method, diagnostics and legacy special-key branch. |
| ContextImpl | One existing typed service lookup adds an early null return for CrossProfileApps; existing persistent-data, Wi-Fi RTT and private fallback behavior remains exact. |
| CrossProfileApps | One public, nonfinal, memberless class extending Object, for the unsupported service's class literal and null check-cast. |

No existing method, field or constructor is added or removed. The boolean
oracle compares the complete old/new method except the one operand swap. The
context oracle accepts only the explicit raw guard or its exact post-DEX label
rebase, retaining the complete old fallback tail. Both run before assembly and
after complete DEX disassembly. The type oracle rejects extra members, altered
flags and a different superclass. Mutation controls also reject changes to
registers, keys, invocations, unrelated classes, class membership and old members.
All historical producer modes and self-tests remain enabled.

Builder compilation and full self-tests passed first attempt. Compile took
1.629 seconds with sampled aggregate RSS 358,137,856 bytes; self-tests took
0.294 seconds with RSS 15,286,272 bytes. Both guard/child exits were zero,
cleanup complete and reported swaps zero. Original qualification limits remain
600 MiB RSS, 300 seconds, 512 MiB shared growth, 1 GiB reserve and the file cap.
Complete controls remain at
`/Users/alex/.local/state/vinix/android/bundle-cross-profile-framework-builder-2026-10-31-r1`.

Producer source SHA-256 is
`debceb600a37e96616c02fca0e725479bc2803c71d0dd8b5c2dff52de976c93f`;
qualified executable SHA-256 is
`3bb36545e33d561d6f95364f4bc3b967ffa6690f5b8be212249411d09800bbef`.
Two independent read reviews passed. Full SDK production, retained-native
compatibility admission and ARM execution remain separate checks. The changed
classes and new CrossProfileApps type are outside the retained native 69-class
set; native retention still requires its original Layout provenance and the
complete unchanged canonical 69-class comparison.
