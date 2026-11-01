# Signed Intent extras fixture, 2026-11-01

The Google account controller adds transition metadata to an Intent that already
contains error title/body strings. The previous `putExtras` implementation
replaced the extras map. Provider `9229c490d` corrects the two existing overloads
to merge keys and copy the incoming top-level map when needed; see the
[framework check](intent-extras-framework-2026-11-01.md).

The maintained fixture builder is `intentextrasfixture/main.v`, with generated
test source in `intentextrasfixture/sources.v`. The resource-free APK contains
one Activity class. Prepared runtime assertions cover both overloads, retained
title/body strings, incoming duplicate precedence, receiver identity, isolated
source/destination maps and preserved shallow nested Bundle values. Empty
source Intents leave destination extras unchanged; empty Bundles and null
arguments follow the Android 10 behavior, including the empty destination
Bundle allocated before a null-Bundle exception.

The retained default Intent constructor eagerly allocates an empty Bundle.
Cases requiring absent extras explicitly call `replaceExtras((Bundle)null)`
and assert the resulting null state before testing `putExtras`. This setup also
exercises first-allocation Bundle and Intent copy paths; it does not depend on
the constructor's initial extras state.

The controlled-transfer case first demonstrates title/body loss using the
unchanged `replaceExtras` API. Its otherwise equivalent `putExtras` path must
preserve them through Intent copies, nested Parcelable Intent storage, and
title/body key indirection. This exercises real framework objects in one
process; it does not test Parcel transport or launching another Activity.

Final signed APK:
`/Users/alex/.local/state/vinix/android/intent-extras-fixture-2026-11-01-r2/probe.apk`,
SHA-256 `b3e0278a185bb3f7f1a302c2f515fa7a4b98edf4cfcefd69ede3f45f85a5ba2c`.
Its build receipt is
`1dd736fe7cf510edd122364b9fc3d179a559e4bac61936e9b98486c2a25f7f00`,
recording source revision `57e765b0855e2a5564eac662c7a2587067be17ac` and complete
source/tool/input/artifact hashes. Generator source hashes are:

| Source | SHA-256 |
| --- | --- |
| main.v | `6474d79e305a23a3435fbf30f14b3c62134d36dca558e7e20a3af1f05665f34a` |
| sources.v | `6531daafc640a8ac8c9e072a2901c4a5de8bd07229293c75a3e10360decd89c0` |

Host checks passed fresh error-free API-28 DEX assembly, two equal canonical
one-class disassemblies, v3 signing, package/activity badging and full input
readback. The package is `org.vinix.bootstrap`, activity `.Main`, minimum SDK29
and target SDK35. Source/register/API/oracle review passed before production.
Independent final read-only review also passed: all 25 input and 26 artifact
hashes, 12 successful command receipts, packaged APK/DEX, canonical one-class
roundtrips and the null/controlled-transfer register and catch paths agree.

| Host phase | Seconds | Sampled aggregate RSS bytes |
| --- | ---: | ---: |
| Generator compile | 4.832 | 328,400,896 |
| Signed fixture production | 15.105 | 92,471,296 |

Both r2 guards/children exited zero with complete cleanup and zero swaps on the
first host attempt. Original limits remained 600 MiB aggregate RSS, 300 seconds,
512 MiB shared-volume growth, 1 GiB reserve and file cap16777216. Observed growth
was 25,387,008/120,803,328 bytes. Complete evidence remains outside Git in
`intent-extras-fixture-controls-2026-11-01-r2` and
`intent-extras-fixture-2026-11-01-r2` beneath
`/Users/alex/.local/state/vinix/android`.

The original r1 host-qualified bundle remains complete and unchanged: APK
`fed8561ffe44b7562499a22dac8fc5e8e0e28607135bd44a835fefd5be347b5a`, receipt
`8d023a616cd2154b89d4387fbee01913ac00964e6a50dccb163e351dcd85f4d6`.
Its first ARM execution failed in `Main.emptyIntent` (source36), because the
fixture incorrectly assumed a newly constructed Intent had null extras. The
preceding controlled, Bundle-merge/initial and Intent-merge calls returned, but
the complete fixture failed and produced no successful runner receipt.

The exact 9,463-byte failed child log is retained under
`maps-intent-extras-runtime-audit-2026-11-01-r1/failed-fixture-decoded-r1/child.log`
in the same external state directory, SHA-256
`0578e8780110e6e7bc61e9f88dfd367b31da52ad17f8031f9cf860ce1365680d`.
Its diagnostic preservation receipt is
`a2e4b3ee3bc7c58ab209d52deac0f0771d6cd345023d0378eac955e3f606e2f1`;
the sibling `fixture-failure-validation.md` records the failed export and exact
subsequent byte-preserving derivation. The r2 correction changes only fixture
setup for absent extras, preserving all assertions, null expectations and the
pass marker. Framework, SDK and native behavior are unchanged by this correction.

The exact runtime marker is
`INTENT-EXTRAS-PASS merge precedence copies no-op nulls shallow controlled-intent`.
Host qualification does not establish ARM execution, a rendered Google account
error page, or successful authentication. Those require the separately pinned
SDK/runtime pair and live guest run.
