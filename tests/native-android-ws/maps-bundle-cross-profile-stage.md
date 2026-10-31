# Bundle boolean and CrossProfileApps media

This six-file overlay deploys the qualified
[combined SDK](bundle-cross-profile-pair-2026-10-31.md) over the immutable
UserManager image. Source `16143aa8f` corrects one BaseBundle boolean operand,
guards typed ContextImpl lookup when the service name is absent, and adds the
memberless CrossProfileApps API class. Existing fields/method signatures and
unrelated behavior remain unchanged. No cross-profile service backend is added.
ARM and the actual Maps profile-menu retry remain pending.

The complete 2,106-to-2,107-class audit permits exactly two changed method bodies
and the one new class. All 69 native-consumed canonical classes remain equal
against the original Layout SDK, independently of the immediate UserManager SDK
parent. BaseBundle, ContextImpl and CrossProfileApps are outside that membership.
The sole raw native-class difference is the fixed Layout formatting pair. The
same native bundle, 89 sources, 90 inputs, generated JNI/C and 719 exports remain
pinned. There is no native rebuild or relink proof. The unchanged DSO is omitted
from the overlay; exactly five deployment input replacements are checked.

Both preparation phases reread all 84 inherited inventories in sorted, disjoint
64+20 batches, preserving the two-worker/64-job helper and exact union. The
profile requires 86 dependency seals, preserves all 36 inherited modules and
adds module 37. All 73 digest receipts are charged to the original internal
512 MiB write budget. Historical profiles and full-bundle checks remain intact.

Artifacts live under `/Users/alex/.local/state/vinix/android` (`S`):

| Bundle | Manifest SHA-256 |
| --- | --- |
| `maps-user-restrictions-r1` | `be3d6e5dcb7e8097f9fcf25290d9f6446d77b2aa9b80e649cc3c8d97195f461d` |
| `combined-account-webview-bundle-cross-profile-framework-2026-10-31-r1` | `e9b9093ee1b8546bca93732cab02a4b58e8ddb25f8c4aae216e40c6602e542aa` |
| Native provenance SDK: `combined-account-webview-layout-alignment-framework-2026-10-30-r1` | `1266de2e0a64d876e3559240fe5596ad67d9f2cfce81bd0e1e727675c0d39e00` |
| `current-native-build-2026-10-30-layout-alignment-r1` | `ad1c44a5ac2f06925c19c02648d837263a9f1aa9661735b9e49e958193b80413` |

Qualification is `S/maps-bundle-cross-profile-tools-2026-10-31-r1` (`Q`), with
batch evidence at `S/maps-bundle-cross-profile-inventory-batches-tests-2026-10-31-r1`.
Serial V generation and the exact emitted C commands passed for all tools.
Required stager self-tests, the complete real SDK/native audit, helper enumeration,
all historical/new patcher profile/FAT checks and 855-input before/copy/after
capture passed. Independent source and final pin reviews passed. Host SDK/system
library hermeticity is not claimed.

The new 84-root tests cover all prior counts, full byte rereads, mutations,
sequential completion and joined failures. The first execution refused an
operator setup omission: its required fixture parent did not yet exist. That
failure is preserved. The unchanged binary passed with a fresh pre-created
`test-results-r2`; no code or limit changed for the retry.

All 26 guard children cleaned up; 25 exited zero and the setup refusal exited one.
Build/test/audit caps remain 600 MiB aggregate RSS, 300 seconds, 512 MiB shared
growth, 1 GiB reserve and the file-size cap. Maximum sampled RSS was 417,136,640
bytes; maximum `time -l` RSS was 409,714,688 bytes. Every process swap count is zero.

| Qualified artifact | SHA-256 |
| --- | --- |
| Stager source | `99d6d55c087f39b75f7d4bbeca842be322d69f5a27837b094900bda765e5dd7e` |
| Patcher source | `d5b9436a2a4d2986ee0781975403fe6efc62ed385e7c96fbcb6f9ae6194ed28b` |
| `Q/stager-project/maps-bundle-cross-profile-stage` | `0e254a781f9cdefadc4e6019930672be6d723c5d43c140bd484efb906b6a6106` |
| `Q/patcher-project/patch-kernel` | `e2d4059c0aa91d3339aed19b3a84016b916678e3a00c4be1c4b58bb5a0135df2` |
| `Q/header-helper-project/media-stage-inputs` | `152c8b5c2e7cb72de56c5f92b5ab135432eeadae1ed07aca26511b2916b48aff` |

Both complete closed roots passed full stream sealing and separate fresh-process
readback: 3,830 entries, `S/maps-bundle-cross-profile-tools-sealed-2026-10-31-r1/sealed/manifest.json`,
SHA-256 `4fc4a89dcb875c8009a33426f30c8de56ef161da6afbcbbb62f94a39bfbaf26c`.
Original 600 MiB/900-second/64 MiB-growth/1 GiB-reserve audit guards passed.
Keep the original complete bundles, failed controls and historical auditors.

Prepare with `Q/stager-project/maps-bundle-cross-profile-stage --prepare
S/maps-bundle-cross-profile-r1`. After a fresh clone use `Q/patcher-project/patch-kernel
--maps-bundle-cross-profile FRESH_STAGE FROZEN_KERNEL_BUILD BUILD_JSON_SHA256`.
Preparation retains original 600 MiB/900-second/4 GiB outer-growth/1 GiB-reserve
caps plus the unchanged internal 512 MiB write budget.
