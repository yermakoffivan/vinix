# User restriction queries, 2026-10-30

Maps' verified `bqsh` constructor calls missing
UserManager.hasUserRestriction("no_modify_accounts") at source 83/offset 0x52.
The true branch omits two menu models. This evidence identifies the query; it
does not establish successful avatar/menu rendering or account authentication.
Earlier mistaken class selections remain preserved in the caller controls.

Feature `ba7751ec7` adds two public, nonfinal UserManager methods. The documented
unmanaged single-user backend has no administrator or restrictions store, so
getUserRestrictions() returns a fresh empty Bundle. hasUserRestriction(key)
queries that virtual getter and then Bundle.getBoolean(key). It preserves a
backend's true values and exceptions. Mutating a returned base snapshot does
not write policy. Existing fields/methods remain unchanged. No policy writer,
administrator/enrollment service, cross-user support or account identity is added.

Focused source checks passed 45 malformed/repeated input refusals and the raw
generator-form positive control. Full API-28 DEX roundtrip covers 2,106 classes:
exactly two methods are appended, every retained UserManager member stays exact,
and all 2,105 neighbors remain byte-identical. Independent provider/checker review
passed. The fixture build receipt records `ba7751ec7` as its source base;
complete actual input snapshots and pins remain available for every check.

The signed standalone APK is
`/Users/alex/.local/state/vinix/android/user-restrictions-fixture-2026-10-30-r1/probe.apk`,
SHA-256 `19f8715bcc6e5f19dff1dc11e031912907d7c762a7f1927b85dda697f447dbea`.
Two-class canonical DEX roundtrip, APK v3 signature and package/activity checks
passed. Both complete generator source files in `userrestrictionsfixture` are
captured and pinned. Independent fixture register/oracle review passed.

Prepared ARM assertions cover direct UserManager and real Activity/application
context lookups by name and type. They check fresh empty snapshots, ordinary
Bundle mutability and isolation from other snapshots/subsequent base queries,
plus retained seed, application-restriction, unlock and single-user controls.
A subclass supplies replaceable Bundles with valid no_modify_accounts and
no_config_wifi true/false values. Its results are compared to actual Bundle truth
for valid, unknown, empty and null keys. Updates/replacement are observed through
one virtual getter call per boolean query. Exact backend exception identity,
recovery after a throw and null-backend dereference failure are preserved.
Unknown/null keys are absent in the synthetic backend; the fixture fabricates
no policy server or hypothetical invalid-key enforcement. Actual ARM execution
and the live Maps flow remain separate checks.

| Final check | Guard seconds | Sampled aggregate RSS bytes |
| --- | ---: | ---: |
| Source driver compile | 2.561 | 342,360,064 |
| Provider/refusals/full DEX check | 21.324 | 403,406,848 |
| Fixture generator compile | 1.914 | 338,460,672 |
| Signed fixture production | 6.627 | 98,516,992 |

All guards and children exited zero with complete cleanup and zero swaps under
the unchanged 600 MiB aggregate RSS, 300-second, 512 MiB observed shared-growth,
1 GiB reserve and file-size caps. No focused source/fixture attempt failed.

Six complete closed roots are retained beneath
`/Users/alex/.local/state/vinix/android`:

- `user-restrictions-host-controls-2026-10-30-r1`.
- `user-restrictions-source-checks-2026-10-30-r1`.
- `user-restrictions-fixture-controls-2026-10-30-r1`.
- `user-restrictions-fixture-2026-10-30-r1`.
- `maps-user-restrictions-caller-audit-2026-10-30-r1`.
- `maps-user-restrictions-caller-controls-2026-10-30-r1`.

Complete sealing and separate fresh-process full readback passed for 9,092
entries, manifest
`/Users/alex/.local/state/vinix/android/user-restrictions-host-sealed-2026-10-30-r1/sealed/manifest.json`,
SHA-256 `00824d1c5edc3eb9b682981a0892c304846c5eadfe2b1f13a85e4fe7fa4b7f37`.
The original audit caps stayed 600 MiB/900 seconds/64 MiB observed growth/1 GiB
reserve, with zero exits and complete cleanup. Retain the complete original
GMS/SDK inputs required by the selected caller audit.

The marker is exactly
`USER-RESTRICTIONS-PASS fresh-snapshots bundle-truth virtual-backend mutation-isolation exceptions context-controls`.
