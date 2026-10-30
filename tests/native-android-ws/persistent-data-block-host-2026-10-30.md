# Absent persistent data block service, 2026-10-30

The complete Google account service log exposed a missing
`android.service.persistentdata.PersistentDataBlockManager` type. The selected
GMS `akas.g(Context)` method gets the application context's named
`persistent_data_block` service, then its synthetic outline casts that result
to the manager type. The existing named lookup returns null, but the missing
class prevents even that null cast from resolving. All selected manager
operations are guarded by a non-null availability check.

The provider adds a public, nonfinal Object-derived class with no fields,
constructors or methods. It also makes the existing typed ContextImpl lookup
return null for this unavailable service before entering its generic reflective
manager-construction fallback. The exact preceding Wi-Fi and other typed-service
paths remain intact; the named lookup remains unchanged. There is no FRP state,
backing service, provisioning authority, permission grant or write API added.
The provider validates the original lookup and class absence before mutations.

The checked [AOSP manager type](https://github.com/aosp-mirror/platform_frameworks_base/blob/main/core/java/android/service/persistentdata/PersistentDataBlockManager.java)
is public and nonfinal and depends on a real persistent-data service. The
[AOSP registry](https://github.com/aosp-mirror/platform_frameworks_base/blob/main/core/java/android/app/SystemServiceRegistry.java)
returns null when that backing service is unsupported. This repair provides
only the type identity and unavailable-service behavior needed by the selected
caller. The exact GMS call, null outcomes and selected methods are retained under
`/Users/alex/.local/state/vinix/android/gms-frp-service-method-2026-10-30-r1`,
with sealed evidence manifest checksum
`5aacf9ba80f2dd73ad6b4cd83b873bedfffbb1d1ece0ebeea04d7f7c409b031a`.

Validation used working sources over revision
`3b1b4772d1a0e731c9965af62f0cc284f98be91b`, against
`/Users/alex/.local/state/vinix/android/combined-account-webview-seed-account-options-framework-2026-10-30-r1/new-dex`.
The complete focused results and tools remain at
`/Users/alex/.local/state/vinix/android/persistent-data-block-source-checks-2026-10-30-r1`.
The production-provider checker verifies the exact one-method insertion and
memberless class. Twenty malformed or repeated sources plus existing-file,
directory and dangling-link class collisions are rejected without altering the
context, six neighboring classes or collision contents. API-28 DEX roundtrip
checks the complete seven-class baseline and eight-class patch, preserving all
other methods and metadata. Independent read-only reviews passed the provider,
both checkers and fixture.

The signed fixture is retained at
`/Users/alex/.local/state/vinix/android/persistent-data-block-fixture-2026-10-30-r1`.
It checks class loading and shape, repeated named and typed null lookup through
Activity and application contexts, a null check-cast, and the actual GMS
application-context lookup/availability sequence. Ordinary UserManager and
LayoutInflater services remain available; seed options remain null.
PersistableBundle.EMPTY must specifically throw UnsupportedOperationException
on mutation while a new bundle remains mutable. Canonical one-class DEX
roundtrip, APK v3 signature, package and launch-activity checks passed. ARM
execution and the real account service remain pending.

Both complete host roots passed sealing and independent full readback: two
roots, 142 entries, manifest
`/Users/alex/.local/state/vinix/android/persistent-data-block-host-sealed-2026-10-30-r1/sealed/manifest.json`,
SHA-256 `e55f3642a2a43a4a56f8ab24974dfb6f9b4a835b906f9b1b9dfee4d09b30abf6`.

| Check | Guard seconds | Sampled aggregate RSS bytes | Time maximum bytes |
| --- | ---: | ---: | ---: |
| Source checker compile | 1.330 | 344195072 | 354385920 |
| Provider/source/DEX check | 6.565 | 198230016 | 191561728 |
| Fixture generator compile | 1.277 | 316260352 | 359743488 |
| Signed fixture production | 6.105 | 97255424 | 92520448 |

All final guard/child exits are zero with complete cleanup and zero reported
swaps. The original 600 MiB aggregate RSS, 300 seconds, 512 MiB observed growth,
1 GiB reserve and file-size limits remain enforced. Sealing/readback retain
their stricter 64 MiB growth allowance and 900-second limit. No full framework
or native build ran in this focused qualification.

| Artifact | SHA-256 |
| --- | --- |
| Provider source | `5af098c201f898ed4592203f21227fe9d543814280799ddb8b99542c602f0408` |
| Isolated source checker | `92f1adadd1d12b4d07d80ca2fa5273e827e63a6741d1b4390f8e23c106b115e7` |
| Source receipt | `948f95fad4633ef0725e1a5d1b71d40f103e56adcf898401d9afa41f05d24d59` |
| Fixture generator source | `4ab6096df533c4629d5b99f43d4781858194dcd059d4c598690412ad1bd95795` |
| Fixture `build.json` | `8d78d76a6d8cc7975cff77fcc71de8b43322d4dc92b75f1938a1cf9b950abd3b` |
| Signed `probe.apk` | `0acd05b909c7c2d3b798cb515a799df8c40263af9be1e7ab4334f7b4f113b7a8` |

The exact marker is
`PERSISTENT-DATA-BLOCK-PASS class-shape named-null typed-null null-cast user-service seed-options immutable-empty`.
