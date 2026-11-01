# Resources float ARM result and Maps imagery retry

The signed Resources float fixture passes on ARM. Maps completes onboarding,
renders labeled map tiles, finds Oasis d'Aboukir in Paris and displays street
tiles, place data and photos. Opening the avatar then exits Maps with missing
`android.graphics.drawable.PaintDrawable`. The prior Resources.getFloat error
is absent from this successor stack. No working profile menu, account window,
authentication, GPS, routes or navigation is established.

The deployed API source is `c01f167cf`, with [SDK/native qualification](resources-float-pair-2026-11-01.md)
`b61a8ad44`, signed [fixture](resources-float-host-2026-10-31.md) `17f8b1b5d`,
runtime tools `98845ee4f` and media `98fad1911`. One public virtual float getter
uses the retained typed lookup and strict type check; old methods and neighboring
classes remain unchanged. The newly coupled native DSO passed the actual-command
prefix proof and full artifact audit; the generated native sources, JNI, C and
exports are unchanged. Neither failed native predecessor was deployed. No Google
APK, account identity or validation policy was changed.

Original artifacts remain beneath `/Users/alex/.local/state/vinix/android` (`S`):

- Prepared `maps-resources-float-r1` (`P`).
- Controls `maps-resources-float-prepare-2026-11-01-r1` (`E`).
- Stopped guest `maps-resources-float-vm-r1` (`VM`).
- Audit `maps-resources-float-runtime-audit-2026-11-01-r1` (`A`).
- Transfer `resources-float-api-transfer-live-2026-11-01-r1` (`T`).

| Input or result | SHA-256 |
| --- | --- |
| Prepared `sha256.json` | `76984d82922315563f88d46e72a77bc4995466ed2581a5df0b62000ac2c4d888` |
| Framework JAR | `aac12a41b70ce34c0893580431a28de81cb3476e7c6833cbe0c0ca8596db677d` |
| Coupled native DSO | `441ae035ec4b69c36635cc4521af3fafcb6a867305b0ba25d6e55df7ff0dadc9` |
| Signed fixture APK | `59439180e4b2bff8c533689db5e4f6ba121406a3cb4950b3746f170a960a7d93` |
| ARM runner | `dbe6ed9779facb8de3257eaf76b0420ac6a60f777af7575dacfb6a1ac35d04f9` |
| Controller receipt | `c1de508898477abb7a50ef4447753b1ff756484c361a428ad6b54c90c874ef5d` |

Preparation, clone and frozen-kernel installation/readback passed in
298.321/7.206/57.134 seconds at sampled RSS 86,786,048/34,914,304/36,847,616
bytes. All guard/child exits were zero with cleanup complete. Original 600 MiB,
900-second, 1 GiB reserve and file-size limits remained enforced, with 4 GiB
preparation and 2 GiB clone/kernel growth caps. The qualified coexistence runner
launched owned PID 265 at 01:18:51 UTC with 12 GiB/four CPUs; its tool completed
at 01:19:13. Admission snapshots record foreign PID 91929 with its unchanged
Oct31 03:03:56 start identity, combined 28 GiB/eight CPUs on the 128 GiB/
18-logical-CPU host, normal pressure and disk reserve. No foreign process was
signalled or modified. Admission is not continuous resource monitoring.

The standalone fixture used float-check UID/GID 10133, protected root-owned
inputs, one ro/nosuid/nodev/wxallowed runtime bind with actual relatime flags,
and separate data/home/surface output. Its receipt validates six exact pins and
eleven checks, one complete PASS/readiness pair, bounded log/lines, drained EOF
and clean child exit. Packaged floats/aliases, strict wrong types, virtual lookup,
raw bits, unchanged value fields and lookup exception identity all pass.

The unchanged zero-removal diagnostic SERVICE-QUERY import passed: archive
15,242 bytes/30 chunks, SHA-256
`454ab6028047c06465a79acc5db65ffbbd31ef674b1beee4a31c7afd2406236b`.
The 9,377-byte/109-line child log is
`ea600ba74d79993e44b868bd88c4116329f11786ed2af0ebcb0c7fc14e879068`,
with the full Resources PASS at line 92, readiness at 103 and onDestroy/final LF
at 109. No payload was repaired and no health check relaxed. This is diagnostic
fixture import, not strict fixture-protocol qualification. Detailed six-pin/
eleven-check validation is `A/fixture-validation.md`, SHA-256
`40e855e792b1c20b88fa305d962079dbc65dcbfcde5a1b76dee262d95d25442c`.

After mount release, `VM/resources-map-01.png` shows real North America tiles.
`resources-place-01.png` shows actual Paris street tiles and photos before the
01:24:52 avatar action. Private error/stack captures identify PaintDrawable,
top `caan.C` source 206; `resources-profile-01.png` shows the exited app.
No cause is inferred for the previous run's blank imagery.

Bounded private broker checks before/after avatar show the same two snapshot-
token causes and no selected missing-class/method, fatal or native-exit records.
A 01:27:17 sample shows parent PID 52496/root UID/state S; it does not establish
every GMS child's health. The controller starts 01:20:58 and finishes 01:29:32,
status `user-stopped-no-authentication-claim`, readiness true and empty error.
Stop was requested at 01:29:30 before the 15-minute bound. Recorded broker exit
137 follows controlled cleanup; no clean broker exit is claimed. Drain EOF is
true, status 1, 107,824 bytes and error number zero. One cleanup survivor's
running/zombie state is unknown. This result does not replace the earlier
independent broker-exit-1 failure.

The unchanged strict account collector passed integrity for 25 entries,
2,835 chunks and 1,451,170 archive bytes, SHA-256
`2577d78011e52379291c1d783dedcc5b86f3051bbeaf924473e5e7a2758d8056`.
The exact interval is 2,254,179 bytes,
`01bd1606b24f01a191aee8a2ee40ab7840207ec3f8eb596ddfa95e4f8c25fba0`;
linked snapshots agree and stopped final UART matches the full snapshot. Raw
app/broker logs remain excluded except hashes and bounded private captures.
Owned VM 265 received one SIGTERM at 01:29:57; after a transient ownership error,
its absence was verified and unchanged reconciliation returned zero without a
second signal. Foreign PID 91929 remained untouched.

All nine original roots, including four adjacent VM clone sidecars, are closed
to writes. Final `A/operator-notes.md` SHA-256 is
`d2460b878ecdfc1ff50e11719bd57cdd5cda5181850f72652276870da0f20b4f`.
Complete sealing and separate fresh-process full readback passed on the first
attempt for nine roots and 639 typed entries. Manifest
`S/maps-resources-float-runtime-sealed-2026-11-01-r1/sealed/manifest.json` has SHA-256
`02db0ec7b177cb95f17914c78c7cd3000296564143bb796e4d101181e523b111`.
Seal/readback took 16.405/9.463 seconds at sampled RSS 23,822,336/22,986,752
bytes. All guard/child exits were zero with complete cleanup and zero swaps,
using the unchanged qualified sealer, 600 MiB/900-second/64 MiB-growth/1 GiB-
reserve/file-size limits. Retain every original bundle and historical auditor.
