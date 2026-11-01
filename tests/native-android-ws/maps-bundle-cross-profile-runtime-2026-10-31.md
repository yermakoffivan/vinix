# Bundle and UserManager ARM results, Maps retry, 2026-10-31

Both signed fixtures pass on ARM: the unchanged original UserManager APK now
completes its null-key control and remaining cases, and the small Bundle/
CrossProfileApps fixture passes. Maps completes onboarding and returns Paris
place suggestions and data, but current tiles/photos remain blank. The avatar
then exits Maps with missing `Resources.getFloat(I)F`. Independently, the
controller records broker exit 1 with an unverified cause. No working profile
menu, account window, authentication, GPS, routes or navigation is established.

The deployed source is `16143aa8fc19c7fcc4cedb449be2cfae450da3d6`, with
[SDK qualification](bundle-cross-profile-pair-2026-10-31.md) `4732c48c5`,
[fixture tools](bundle-cross-profile-fixture-run.md) `a98b17930` and
[media tools](maps-bundle-cross-profile-stage.md) `c82eef4cb`. BaseBundle changes
one boolean getter operand pair; ContextImpl returns typed null for the absent
CrossProfileApps service and its memberless public class is available. There is
no service backend or profile/account identity. All 69 native-consumed canonical
classes retain compatibility; the exact native library was retained without
rebuilding or relinking.

Original artifacts remain under `/Users/alex/.local/state/vinix/android` (`S`):

- Prepared `maps-bundle-cross-profile-r1` (`P`).
- Controls `maps-bundle-cross-profile-prepare-2026-10-31-r1` (`E`).
- Stopped guest `maps-bundle-cross-profile-vm-r1` (`VM`).
- Audit `maps-bundle-cross-profile-runtime-audit-2026-10-31-r1` (`A`).
- Transfers `user-restrictions-bundle-api-transfer-live-2026-10-31-r1` and
  `bundle-cross-profile-api-transfer-live-2026-10-31-r1`.

| Input or result | SHA-256 |
| --- | --- |
| Prepared `sha256.json` | `03e847ea0b37729b04a9794294b8d39f1c8e5db96d5ab08868f2775312c16631` |
| Framework JAR | `3ebf88615dcb87ec103b098a0baf397f5a4428623f809fd139b23e9f60978235` |
| Retained native DSO | `b6aeb06b7473220da8844015a253ed87394fef6209173c14317fcbaf19141e95` |
| Original UserManager APK | `19f8715bcc6e5f19dff1dc11e031912907d7c762a7f1927b85dda697f447dbea` |
| Bundle/CrossProfileApps APK | `c781769a0ef5fd5357ae1f678d52ef98a2532a5ae07c155a013e278a7b2248ab` |
| Common ARM runner | `ca7165c9758553dedc6815451f2a8618f56357e097dc5718188688b3e88dc7e1` |
| Controller receipt | `cd0626ce12ae6d93d26643d15c4f08727ab7cc4bcee1fb5759ac2661fd0d50e9` |

Preparation, fresh clone and frozen-kernel installation/readback passed in
331.615/9.151/59.782 seconds, sampled RSS
89,358,336/33,767,424/47,661,056 bytes. Original memory/time/reserve and growth
caps remained enforced. The qualified coexistence runner `6d7fcdccda76a3d4637a9bad2785acc2af1e126574528b143af1b04768c161df`
launched owned PID 68080 at 05:12:31 UTC with 12 GiB/four CPUs. Admission snapshots
verified unchanged foreign PID 91929 with 16 GiB/four CPUs, total 28 GiB/eight
CPUs on the 128 GiB/18-logical-CPU host, normal pressure and disk reserve. No
foreign process was signalled or modified; these are admission snapshots.

The independent fixtures used dedicated UID/GID 10131 and 10132, protected
`/opt/input` files, runtime alias `/opt/restrict-runtime` and separate output
directories. Each receipt pins six inputs and eleven checks, with one exact
full PASS, one native readiness marker, bounded lines/log, final LF, drained EOF
and clean child exit. The original UserManager APK/cases/marker are unchanged;
its previous failed run remains separately preserved. This run covers its
restriction snapshots, boolean backend/delegation, mutation isolation, context
controls and exceptions. The small fixture covers 19 boolean probes, null keys,
defaults, stored values, nonmutation, the legacy control and CrossProfileApps
class identity/typed-null lookups. Wrong-type warning behavior was not exercised;
its existing source/catch/warning checks remain unchanged.

Unchanged zero-removal diagnostic SERVICE-QUERY imports passed, with separate
linked snapshot/plan/reconstruction/extraction evidence. These are diagnostic
imports, not strict fixture-protocol imports; no payload repair occurred.

| Fixture | Archive SHA-256 | Child-log SHA-256 |
| --- | --- | --- |
| Original UserManager | `3ae08a45d4f25cc7f4910ce7d8e9bf2f637c15c0aaf298814e9070f0305cf13c` | `0f3626225e73efbc6b8cb2300dfab35a71790475c7d86ac9341efd683e3470c6` |
| Bundle/CrossProfileApps | `ea60d1c0842964ceef5304330fbc2e795ed56532f5bf63af917b11331ed3a96f` | `54cd39b27855c135b3ad64e868c0c7138d62c4a9c797c90e1398d8b8c7d41242` |

The archives contain 18,635 bytes/37 chunks and 19,087 bytes/38 chunks. Child logs
contain 11,878 and 12,206 bytes. Detailed validations remain in
`A/user-fixture-validation.md` and `A/bundle-fixture-validation.md`, SHA-256
`0724fdf469df3fe8f590f93eeef6bd614e31ea20f429a53ec00f7b6e1e3dba2f` and
`75f0c04b43eedbbefca8d8b0d93309ff9348e655b8c5d6d55f671d2d324f1fb7`.

After releasing the fixture mount, Maps was opened through its real launcher.
`VM/bundle-search-results-01.png` and `bundle-place-02.png` show the Oasis
d Aboukir Paris suggestion and place/address/rating data, with blank tiles and
photo placeholders before the avatar action. Private error/stack captures show
the subsequent missing Resources method. The controller receipt separately
finishes at 05:19:55 with status `failed`, error `GMS broker exited; inspect
private broker.log`, readiness true and `broker_exit=1`. Drain EOF is true,
status 1, 107,387 bytes, error number zero; one cleanup survivor has unknown
running/zombie state. The later 05:23:36 stop request is neither that finish nor
a demonstrated cause. The private broker log was not captured before VM stop;
the next run requires a bounded private check. No cause is attributed to
Resources, cleanup, the framework change or network state.

The unchanged strict account collector passed export integrity for 24 entries,
2,835 chunks and 1,451,243 archive bytes, SHA-256
`8cf29d8f4df6cb48f1564a54136132a17397fb31ab9ca9072d397ebe41eb8e63`.
The 2,252,548-byte interval is
`e8d18ee71b332fb4bbc2e5b58dcd23ec32b4df55382b510cdb39e7b49199b9fc`;
snapshot receipts are `7ba0116e8c0de9bf5e39caa7526f6eb2219799e8e3c293a23ef17033b90c2f10`
and `ce88f162776a426090c1e700ab4ab1644c4c069651a0605e31b2faf33ea899a9`.
Stopped VM UART matches the full snapshot. Integrity PASS does not make the
failed controller run successful. Owned PID 68080 stopped at 05:24:11 after one
SIGTERM; foreign PID 91929 remained untouched.

All ten original roots, including the four adjacent VM clone sidecars, are
closed to writes. Final `A/operator-notes.md` SHA-256 is
`95c82f5891a80bccf793f085550deba6e40c89f113dc45adba4b32b24835b5fa`.
The original sealing attempt and one coordinated retry were stopped by the
unchanged 64 MiB shared-volume growth guard. Controls
remain in `S/maps-bundle-cross-profile-runtime-sealed-2026-10-31-r1` and `-r2`;
the retry includes the complete first failed control as its eleventh root.
Observed growth was 88,174,592/1,074,167,808 bytes at 4.879/6.527 seconds, sampled
RSS 7,897,088/7,864,320 bytes. Both guard/child exits were 125/137 with complete
cleanup, no manifest and no full-readback PASS. Guard receipt hashes are
`4baac0116d17bc49d75e3108d98d171bb917779d00b234287cea4482f02212cf` and
`4da66a17af2bcc24517e03ccca1721ffaf9c9ce646de12e1b0ef643f74d549d8`.
Both failures remain preserved. A third attempt during a later quiet window
passed complete sealing and separate fresh-process full readback for 12 roots:
the ten closed originals and both failed control roots, 705 typed entries.
Manifest `S/maps-bundle-cross-profile-runtime-sealed-2026-11-01-r3/sealed/manifest.json`
has SHA-256 `1af0d1e898c488ef5f032c672518903acd412bfbdb9239a4a3a31b1a6fedc485`.
Seal/readback took 13.789/3.777 seconds at sampled RSS 15,564,800/12,599,296
bytes, with guard/child exits zero, cleanup complete and process swaps zero.
The unchanged qualified sealer and original 600 MiB/900-second/64 MiB-growth/
1 GiB-reserve/file-size caps were used. This recovers evidence completeness;
the failed controller and recorded runtime outcomes above remain unchanged.
