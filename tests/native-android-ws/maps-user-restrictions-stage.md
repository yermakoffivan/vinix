# UserManager restriction query media

This six-file overlay deploys the qualified
[UserManager restriction SDK](user-restrictions-pair-2026-10-31.md) over the
immutable Layout image. The SDK adds two methods in UserManager: a fresh
restriction snapshot for the documented unmanaged backend, and a virtual
boolean query that honors supplied backend values and exceptions. The API
source is `ba7751ec7`; the signed fixture is committed as `16c33479b`.
ARM execution and the real Maps profile-menu retry remain pending.

The complete 2,106-class audit permits only those two method additions. The
retained native library stays byte-identical and is verified against its
original Layout SDK provenance. UserManager is absent from its 69 consumed
classes; all 69 canonical class fingerprints remain equal against the new SDK.
The sole raw difference is Layout's exact canonical formatting pair. All 89
native sources, 90 inputs, generated JNI/C and 719 exports remain pinned.
There is no new native build or relink proof. The overlay omits the unchanged
DSO and checks exactly five deployment input replacements.

Both preparation phases audit all 82 inherited inventories in sorted, disjoint
64+18 batches, using the unchanged two-worker/64-job helper and exact union.
The profile requires 84 dependency seals, preserves all 35 inherited modules,
and adds module 36. All 71 before/after module-digest receipts are charged to
the original internal 512 MiB write budget. Controller, broker, browser, Google
companion catalogs/signatures and other deployment inputs remain pinned.

Artifacts are under `/Users/alex/.local/state/vinix/android` (`S`):

| Bundle | Manifest SHA-256 |
| --- | --- |
| `maps-layout-alignment-r1` | `5e359cb61a16c70d08916e7b422c2729243871d42e747c8b30d13f34f76826e1` |
| `combined-account-webview-user-restrictions-framework-2026-10-31-r3` | `2e3b4a212238fc14a47b6cc72d1abde24c95a26e379ecd79f99f54527314040c` |
| `current-native-build-2026-10-30-layout-alignment-r1` | `ad1c44a5ac2f06925c19c02648d837263a9f1aa9661735b9e49e958193b80413` |

Qualification is `S/maps-user-restrictions-tools-2026-10-31-r1` (`Q`). The new
SDK records source revision `02c10fb01e0dfcd08b877e36ea26f8f2e4dcb2fa`; exact
media source identities are below. Serial V generation and exact emitted C
compilation passed for all three tools. Required stager self-tests, every
historical/new patcher profile and FAT check, the complete actual SDK/native
audit and helper enumeration passed on their first attempts. Independent source
and final artifact-mapping reviews passed. Existing 82-root batch evidence is
reused from its successful original run, matching committed `347166341`.

Post-build V/C/header/generated-project capture verified 855 inputs before,
during and after copying. Host SDK/system-library hermeticity is not claimed.
All 19 final guards and children exited zero with complete cleanup; every
`time -l` process swap count is zero. Original build/test/audit limits remained
600 MiB aggregate RSS, 300 seconds, 512 MiB shared growth, 1 GiB reserve and the
file-size cap. Maximum sampled RSS was 414,728,192 bytes; maximum `time -l` RSS
was 413,384,704 bytes. No qualification attempt failed.

| Qualified artifact | SHA-256 |
| --- | --- |
| Stager source | `a973379086fd9c0a9852a0dd2b63261b0a74d787f19f03cb56a074341c768531` |
| Patcher source | `7549be2154228d35fffea217541834e93af23e702f34e8a86c5d90a06cf55016` |
| `Q/stager-project/maps-user-restrictions-stage` | `ab05ab6bafe7feff556d39741c5318799dce1313f259f92eab3947bd28226631` |
| `Q/patcher-project/patch-kernel` | `83e1078b7dc2537d852e328035aab48673191376eff6c4abae4bd766874007a3` |
| `Q/header-helper-project/media-stage-inputs` | `35db77fbc61456af180ccbebb447e4f4a1fe68b6abb9ac665df9c87cdd57b717` |

Two closed roots, Q and the complete original
`maps-user-restrictions-inventory-batches-tests-2026-10-30-r1`, passed full
sealing and separate fresh-process readback: 3,397 typed entries,
`S/maps-user-restrictions-tools-sealed-2026-10-31-r1/sealed/manifest.json`,
SHA-256 `40bde6d8ba92fc4092a4e09ea1d1437541ce0f87650227c1c7e6783283c3a666`.
Original 600 MiB/900-second/64 MiB-growth/1 GiB-reserve guards passed with complete
cleanup and zero swaps. Preserve all original bundles and historical auditors.

Prepare with `Q/stager-project/maps-user-restrictions-stage --prepare
S/maps-user-restrictions-r1`. After a fresh clone, use `Q/patcher-project/patch-kernel
--maps-user-restrictions FRESH_STAGE FROZEN_KERNEL_BUILD BUILD_JSON_SHA256`.
The original preparation limits remain 600 MiB/900 seconds/4 GiB outer growth/
1 GiB reserve, plus the unchanged internal 512 MiB write budget.
