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

The controlled-transfer case first demonstrates title/body loss using the
unchanged `replaceExtras` API. Its otherwise equivalent `putExtras` path must
preserve them through Intent copies, nested Parcelable Intent storage, and
title/body key indirection. This exercises real framework objects in one
process; it does not test Parcel transport or launching another Activity.

Final signed APK:
`/Users/alex/.local/state/vinix/android/intent-extras-fixture-2026-11-01-r1/probe.apk`,
SHA-256 `fed8561ffe44b7562499a22dac8fc5e8e0e28607135bd44a835fefd5be347b5a`.
Its build receipt is
`8d023a616cd2154b89d4387fbee01913ac00964e6a50dccb163e351dcd85f4d6`,
recording source revision `a8b257e84e3783d21352846c9830a1b03bea62cc` and complete
source/tool/input/artifact hashes. Generator source hashes are:

| Source | SHA-256 |
| --- | --- |
| main.v | `6474d79e305a23a3435fbf30f14b3c62134d36dca558e7e20a3af1f05665f34a` |
| sources.v | `9b584442e612bb278778c3946a33aed0a62a6bbd7a97f87aca6dc59798633043` |

Host checks passed fresh error-free API-28 DEX assembly, two equal canonical
one-class disassemblies, v3 signing, package/activity badging and full input
readback. The package is `org.vinix.bootstrap`, activity `.Main`, minimum SDK29
and target SDK35. Source/register/API/oracle review passed before production.
Independent final read-only review also passed: all 25 input and 26 artifact
hashes, 12 successful command receipts, packaged APK/DEX, canonical one-class
roundtrips and the null/controlled-transfer register and catch paths agree.

| Host phase | Seconds | Sampled aggregate RSS bytes |
| --- | ---: | ---: |
| Generator compile | 1.979 | 332,840,960 |
| Signed fixture production | 6.940 | 105,054,208 |

Both guards/children exited zero with complete cleanup and zero swaps on the
first attempt. Original limits remained 600 MiB aggregate RSS, 300 seconds,
512 MiB shared-volume growth, 1 GiB reserve and file cap16777216. Observed growth
was 63,504,384/264,376,320 bytes. Complete evidence remains outside Git in
`intent-extras-fixture-controls-2026-11-01-r1` and
`intent-extras-fixture-2026-11-01-r1` beneath
`/Users/alex/.local/state/vinix/android`.

The exact runtime marker is
`INTENT-EXTRAS-PASS merge precedence copies no-op nulls shallow controlled-intent`.
Host qualification does not establish ARM execution, a rendered Google account
error page, or successful authentication. Those require the separately pinned
SDK/runtime pair and live guest run.
