# BaseBundle boolean and absent CrossProfileApps fixture, 2026-10-31

The unchanged UserManager regression APK failed on ARM at its null-key query:
BaseBundle.getBoolean(String, boolean) invoked String.equals on the nullable
key. The provider swaps only that invoke's two operands, using the existing
constant string as receiver. The retained legacy
`com.facebook.sdk.AutoLogAppEventsEnabled` forced-false behavior, diagnostic
prints, wrong-type catch/typeWarning path, all other members and neighboring
classes remain unchanged. Preserving that existing override limits this fix's
scope; it does not endorse its policy.

Focused BaseBundle checks passed 74 refusal cases, the raw generator-form
positive control and the complete 2,106-class API-28 DEX roundtrip. Exactly one
instruction changed and all 2,105 neighboring classes stayed byte-identical.
No native binding is added or changed.

The exact Maps caller `bryz.H` in classes2.dex obtains CrossProfileApps by
class, casts it, then checks for null before calling getTargetUserProfiles().
The class literal/cast/method outlines are in classes8.dex; all ten admitted
DEX inputs were audited. AOSP Android 10's [service registry](https://raw.githubusercontent.com/aosp-mirror/platform_frameworks_base/android-10.0.0_r47/core/java/android/app/SystemServiceRegistry.java)
returns a null manager when this service is absent. An implemented
[profile service](https://raw.githubusercontent.com/aosp-mirror/platform_frameworks_base/android-10.0.0_r47/services/core/java/com/android/server/pm/CrossProfileAppsServiceImpl.java)
with no eligible profiles instead returns an empty list. This runtime has no
cross-profile backend. The provider adds the memberless public API type and
an exact-class typed-lookup null return, preserving the existing fallbacks.
Its isolated checks passed 39 malformed/collision refusals and the complete
2,106-to-2,107-class API-28 DEX roundtrip, with all 2,105 old neighbors exact.
The full caller audit, four pinned primary-source copies and exact offsets
remain in the sealed caller roots below. Combined framework production and
runtime checks remain separate.

The separate one-class signed fixture is
`/Users/alex/.local/state/vinix/android/bundle-boolean-fixture-2026-10-31-r1/probe.apk`,
SHA-256 `c781769a0ef5fd5357ae1f678d52ef98a2532a5ae07c155a013e278a7b2248ab`.
Two canonical API-28 DEX roundtrips, exact class membership, APK v3 signature
and package/activity checks passed. The receipt records source base
`1ab70d4b9c41de3448df193feef6bc5cd70098ca`; complete actual source/tool inputs
are captured and pinned. Generator sources are `main.v`
`7bfb6930b66766c1019849fea68856fadd0419ea505d14b836fa4be7adcde7d6`
and `sources.v`
`06d9a330c486d27fdcef450f91af89e0d4ab18b58bff32a9e0b30c2821c78167`.

Prepared runtime assertions cover 19 Bundle probes, each calling the
one-argument getter and both explicit defaults. They check missing null keys,
stored true/false/null values, removal/default recovery, ordinary/empty keys,
and the retained legacy override, including its pre-cast wrong-type bypass.
Every probe checks size, key presence and exact raw-object identity after
reads. The existing wrong-type catch/warning path is preserved by the exact
source oracle; this APK does not exercise that warning-emitting branch, and
generic runner health checks remain unchanged. PASS prints only after all
assertions complete.

The same class checks CrossProfileApps class-literal/Class.forName identity,
typed getSystemService(Class) and checkcast-null using real Activity and
application contexts. The unsupported backend supplies no manager; the
fixture invokes no profile method. It makes no cross-profile backend,
management, policy, network or authentication claim. Independent fixture
register/oracle and additive Cross control reviews passed against the pinned
sources and signed APK; the retained source copies match.

The original UserManager APK remains unchanged at
`/Users/alex/.local/state/vinix/android/user-restrictions-fixture-2026-10-30-r1/probe.apk`,
SHA-256 `19f8715bcc6e5f19dff1dc11e031912907d7c762a7f1927b85dda697f447dbea`,
rechecked after this fixture's production. Its complete existing cases must
run separately on the next framework/native pair to establish failure-to-pass.
These host results do not claim ARM success or a successful Maps flow.

| Qualified check | Guard seconds | Sampled aggregate RSS bytes |
| --- | ---: | ---: |
| BaseBundle driver compile | 1.373 | 331,612,160 |
| BaseBundle refusals/full DEX check | 14.755 | 414,236,672 |
| CrossProfileApps driver compile | 1.432 | 334,643,200 |
| CrossProfileApps refusals/full DEX check | 14.587 | 401,457,152 |
| CrossProfileApps caller filters (10) | 0.147–0.228 | 107,626,496 maximum |
| Fixture generator compile r2 | 1.312 | 313,589,760 |
| Signed fixture production | 6.048 | 93,421,568 |

Each qualified guard and child exited zero with complete cleanup and zero
swaps under the unchanged 600 MiB aggregate RSS, 300-second, 512 MiB observed
shared-growth, 1 GiB reserve and file-size caps. Compile r1 is retained as an
unqualified launch-setup failure: zsh rejected its compact ulimit spelling and
continued into compilation. That binary was not used. The fresh r2 compile
required successful `ulimit -f 16777216` before the guarded child, and signing
used the same limit with shell error exit enabled.

Nine complete closed roots are retained beneath
`/Users/alex/.local/state/vinix/android`:

- `bundle-boolean-host-controls-2026-10-31-r1`.
- `bundle-boolean-source-checks-2026-10-31-r1`.
- `bundle-boolean-fixture-controls-2026-10-31-r1` (unqualified setup attempt).
- `bundle-boolean-fixture-controls-2026-10-31-r2`.
- `bundle-boolean-fixture-2026-10-31-r1`.
- `maps-cross-profile-apps-caller-audit-2026-10-31-r1`.
- `maps-cross-profile-apps-caller-controls-2026-10-31-r1`.
- `cross-profile-apps-host-controls-2026-10-31-r1`.
- `cross-profile-apps-source-checks-2026-10-31-r1`.

Complete sealing and a separate fresh-process full readback passed for
18,083 entries. Manifest
`/Users/alex/.local/state/vinix/android/bundle-boolean-host-sealed-2026-10-31-r1/sealed/manifest.json`,
SHA-256 `b41059b82e53fc7f2879e6aed50c73ecccbb9b4b911028776a326adf8a7babc3`.
The original seal/readback caps remained 600 MiB, 900 seconds, 64 MiB observed
shared growth, 1 GiB reserve and the same file-size limit. Both guards/children
exited zero with complete cleanup and zero swaps; sealing took 2.292 seconds
at 23,805,952 sampled RSS bytes, and fresh readback took 0.819 seconds at
22,921,216 bytes. Retain the complete original SDK/GMS inputs required by the
historical source and caller checkers.

The marker is exactly
`BUNDLE-BOOLEAN-PASS null-keys defaults stored-values nonmutating ordinary-keys legacy-control cross-profile-absent`.
