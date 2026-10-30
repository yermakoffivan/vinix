# Unseeded account options, 2026-10-30

The complete Google account log identifies a missing
`UserManager.getSeedAccountOptions(): PersistableBundle` call in `atlx.a`, reached
from `atrr.invokeSuspend`. The selected GMS method substitutes
`PersistableBundle.EMPTY` when the result is null; only its non-null branch calls
`clearSeedAccountData()`. This runtime has no seed-account store, so the new
public instance getter returns null and introduces no seeded branch or clear API.

The required fallback also lacked its typed empty constant. The provider adds
`public static final PersistableBundle EMPTY` with the Android initialization
sequence: construct a bundle, then use `ArrayMap.EMPTY` as its backing map.
The retained ArrayMap initializer constructed that immutable map before publishing
its immutable-array marker, leaving `mHashes` null. Reordering those existing
initializations restores its existing `UnsupportedOperationException` mutation
guard. All other ArrayMap methods, fields and constructors remain unchanged.
The three transformations validate their dependencies before writing any class.

The checked primary sources are the
[AOSP UserManager API](https://github.com/aosp-mirror/platform_frameworks_base/blob/main/core/java/android/os/UserManager.java),
[UserManagerService absent seed-data behavior](https://github.com/aosp-mirror/platform_frameworks_base/blob/main/services/core/java/com/android/server/pm/UserManagerService.java),
[PersistableBundle empty constant](https://github.com/aosp-mirror/platform_frameworks_base/blob/main/core/java/android/os/PersistableBundle.java)
and [ArrayMap immutable marker](https://github.com/aosp-mirror/platform_frameworks_base/blob/main/core/java/android/util/ArrayMap.java),
read on 2026-10-30. The precise selected GMS call and null handling are retained
under `/Users/alex/.local/state/vinix/android/gms-seed-account-method-2026-10-30-r1/corrected-selected`;
the initial similarly named, incorrect candidates remain preserved separately.

Validation used working sources over revision
`d7d84f1d5196909ec3bccbda4a668a577d01afbf`, against
`/Users/alex/.local/state/vinix/android/combined-account-webview-window-system-ui-framework-2026-10-30-r1/new-dex`.
Complete tools, controls and focused results remain at
`/Users/alex/.local/state/vinix/android/seed-account-options-source-checks-2026-10-30-r1`.
The production-provider checker rejects 53 malformed or repeated inputs and
checks that refusal leaves all three classes unchanged. Exact raw source deltas
are UserManager one added method, PersistableBundle one field and one static
initializer, and ArrayMap one changed static initializer. API-28 DEX roundtrip
checks preserve every other method and metadata, with BaseBundle, Bundle,
ContextImpl and ContainerHelpers byte-identical between baseline and patch.
Independent read-only reviews passed the provider, both checkers and fixture.

The signed fixture is retained at
`/Users/alex/.local/state/vinix/android/seed-account-options-fixture-2026-10-30-r1`.
It exercises string and typed service lookup, repeated null queries across
instances, the exact typed null fallback and reflection of both public API
shapes. Mutation attempts on the shared constants must specifically throw
`UnsupportedOperationException`; another failure cannot count as success.
Ordinary bundles and maps remain mutable and independent, and application
restrictions remain fresh empty bundles. One-class canonical DEX roundtrip,
APK v3 signature, package and launch-activity checks passed. ARM execution,
seeded accounts, provisioning authority and Google authentication remain
unverified by these host checks.

| Check | Seconds | Sampled RSS bytes | Time maximum bytes |
| --- | ---: | ---: | ---: |
| Source checker compile | 1.342 | 339476480 | 342458368 |
| Provider/source/DEX check | 7.187 | 193708032 | 189513728 |
| Fixture generator compile | 1.418 | 343605248 | 369999872 |
| Signed fixture production | 5.776 | 82509824 | 92831744 |

Every guard and child exited zero with complete cleanup, below 600 MiB aggregate
RSS, 300 seconds, 512 MiB observed growth and a 1 GiB reserve. Time reports
recorded zero swaps. No full framework or native build ran in this qualification.

| Artifact | SHA-256 |
| --- | --- |
| Provider source | `ac0b975213dc9c55c99ed9fed78a61e1653bcff55c932a2a312524e0e9ea0f03` |
| Source checker driver | `ad3986ede2387516faedb852cc3ecd949ca18b3356c8093d441d08b7acf99703` |
| Final source receipt | `f66206ce4d5f5b9c3f883f1a45ef14f0d3808d15f8a104c506c59022f086e5ef` |
| Fixture generator source | `98fa91ae6834069e1b6065ab94b2100794512c75ff416f6e3024192961096f87` |
| Fixture `build.json` | `7963fe918ee2b400eeee53799314e815a83d9e38dc509a0e970127fc12bd858c` |
| Signed `probe.apk` | `36c87d606306c799f50771ab0bed5cacdf07603e96f3e85b6c4aab4870f1f333` |

The exact runtime marker is
`SEED-ACCOUNT-OPTIONS-PASS unseeded-null service-lookup method-shape empty-singleton immutable-empty null-branch`.
