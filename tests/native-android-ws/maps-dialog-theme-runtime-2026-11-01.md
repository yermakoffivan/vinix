# Dialog theme ARM result and Maps profile/account retry

The signed Dialog theme fixture passes on ARM. Maps renders real tiles, finds
Paris places and photos, and now opens its profile menu. The previous
`SURFACE_CONTAINER_LOWEST` failure is resolved. Sign in opens a separate Google
account window, initially Checking info, then a largely blank blue/white page
with Next. Next returns to unauthenticated Maps. Account content is incomplete
and Google authentication remains unverified; no credentials were supplied.
GPS, routes and navigation were not exercised.

Provider `b97a9861a` changes only `Dialog(Context,int)`: select android:dialogTheme
for zero, wrap the supplied context with the chosen style and share that wrapper
with Window. The native initialization tail and all 2,107 neighboring classes
remain exact. Qualified producer `d5efefea8`, signed [fixture](dialog-theme-fixture-2026-11-01.md)
`a822e6d8e`, [runner/transfer](dialog-theme-fixture-run.md) `faaf10c29`,
[SDK/native pair](dialog-theme-pair-2026-11-01.md) `8a885b8b3` and
[media](maps-dialog-theme-stage.md) `6ef1c5e34` retain their complete evidence.
The coupled native build passed the full 69-class audit. Its actual-command
path-only prefix proof reproduces predecessor whole DSO `441ae035…`; no native
behavior change is claimed. Google APKs and validation policy remain unchanged.

Artifacts remain beneath `/Users/alex/.local/state/vinix/android` (`S`):

- Failed preparation `maps-dialog-theme-r1` and controls
  `maps-dialog-theme-prepare-2026-11-01-r1` (`P1/E1`).
- Prepared `maps-dialog-theme-r2` and controls
  `maps-dialog-theme-prepare-2026-11-01-r2` (`P2/E2`).
- Stopped guest `maps-dialog-theme-vm-r1` (`VM`).
- Audit `maps-dialog-theme-runtime-audit-2026-11-01-r1` (`A`).
- Transfer `dialog-theme-api-transfer-live-2026-11-01-r1` (`T`).

| Input or result | SHA-256 |
| --- | --- |
| Prepared P2 `sha256.json` | `4b28f8921073af2168a6a2bd639c7897f5b2796cc3142a4f8a06228de21efdf2` |
| Framework JAR | `9d8d2b1f59f80bf0d704daa65eaf3b479fa83458338f23d9fe17aa7a57b541b6` |
| Coupled native DSO | `280730c4166687394cf69e548cdd106e58c57ba9472f339dde2c80ebdee2595a` |
| Signed fixture APK | `57e1bc1d8f1df2874be1c4837f169176e5fa88310f37ea99fd726c5f839a2161` |
| ARM runner | `bfcc6464a0d55f1fd9ce2ec452f834f01c3aa6d6525c470bbec2bf74d6cdbb08` |
| Controller receipt | `a5647a9e6ab626c6bfffdf774f3c8543f0fdb656d13e519f1d4b0841834dccee` |

First preparation stopped after original-module readback with `stage ancestry
exceeds bound`, before creating a boot image. Its exit1/cleanup complete,
115.225 seconds, sampled RSS 85,524,480 bytes and complete artifacts are retained.
Fix `92d05cabc` admits the verified 33-stage chain only in the new Dialog profile;
membership, cycle and overlay checks remain unchanged. Fresh qualification,
865-input capture and tool seal/readback passed before P2 preparation.

P2 preparation, clone and frozen-kernel install/readback passed in
255.042/6.060/37.787 seconds, sampled RSS
88,588,288/37,634,048/49,790,976 bytes, all guard/child exits zero with cleanup
complete. Original 600 MiB/900-second/1 GiB-reserve/file-size limits remained,
with 4 GiB preparation and 2 GiB clone/kernel growth caps. Preparation observed
327,753,728 bytes of shared growth. The qualified coexistence runner launched
owned PID76383 at 03:21:38 UTC with 12 GiB/four CPUs. Admission snapshots record
foreign PID91929's unchanged start identity, combined 28 GiB/eight CPUs on the
128 GiB/18-logical-CPU host, pressure1 and disk reserve. No foreign process was
signalled or modified; admission is not continuous monitoring.

The standalone fixture used dedicated UID/GID10135, protected root-owned inputs,
runtime `/opt/dialog-theme-runtime` and separate output. Exact six pins and
eleven receipt checks pass, with one full PASS and READY, bounded complete log,
drained EOF and clean exit. Cases cover explicit/inherited/default themes,
missing-default absence on a fresh bare theme, direct resource controls, fresh
wrapper/theme identities, shared Dialog/Window/decor/inflation context, cached
and cloned inflaters, real TextView color and unchanged caller attributes.

Unchanged zero-removal diagnostic SERVICE-QUERY import passed for 23,707 archive
bytes/47 chunks, SHA-256
`efdfda5e5db67c378a56d45447b8adf599cae8d1b382dd098470ef5f283df296`.
The 15,685-byte/292-line child log is
`02a92d5cb35e13f8637f89f79221493f9d9da69fb4b41f11b990a1af025c4f60`,
with exact Dialog PASS275, READY286 and onDestroy/final LF292. No payload repair,
relaxed health check or assertion change was used. This is diagnostic fixture
import, not strict fixture-protocol qualification. Detailed validation remains
at `A/fixture-validation.md`, SHA-256
`9c5b4bd3be3f4f63ca53064cc984c242982a4755773e563e9a093940f69af40e`.

After fixture mount release, `VM/dialog-map-01.png` at 03:27:33 shows real North
America tiles. Search results at 03:27:52 and `dialog-paris-place-01.png` at
03:28:14 show Oasis d'Aboukir street tiles, place data and photos.
`dialog-profile-01.png` at 03:28:42 shows the working profile menu over the map.
Sign in at 03:28:49 opens Checking info at 03:28:59. Account captures at
03:29:47/03:30:13 show incomplete content; Next returns to Maps at 03:30:30.
Bounded private lifecycle capture records AccountIntroActivity/ChimeraActivity.
The cause of the incomplete account content is unknown.

Private broker checks before/after sign-in show the same two snapshot-config
causes and no selected fatal/native-exit records. Parent PID22904 remains root
UID/state S; that does not establish every GMS child's health. Actual controller
receipt starts 03:24:46 and finishes 03:33:09, status
`user-stopped-no-authentication-claim`, readiness true and empty error. Stop was
requested at 03:33:06 before the 15-minute bound. Broker exit137 follows
controlled cleanup; no clean exit is claimed. Drain EOF is true, status1,
172,603 bytes and error number0; two cleanup survivors' running/zombie states
are unknown. No authentication or working account content is established.

The unchanged strict account collector passed 25 entries/2,836 chunks/
1,451,851 archive bytes, SHA-256
`b48bd5842579dd0aa211f8576d4724a16590f3727d8944ae9b3e06107a922556`.
The exact 2,257,821-byte interval is
`32e59339d4c209b7a7cf682c0e18e3e487bcd0757d423fad74dcaed846881e5c`;
linked snapshots agree and stopped final UART matches its full snapshot. Raw
private app/broker logs remain excluded except hashes and bounded private
captures. Export integrity does not establish authentication. Owned VM76383
received one SIGTERM at 03:34:00; the stop tool returned zero and absence was
verified. Foreign91929 retained its original start identity and was untouched.

All eleven original roots, including four adjacent VM clone sidecars, are closed
to writes. Final `A/operator-notes.md` SHA-256 is
`484bf99e9f68874bcef6beab7d2d55701e659f5e5a38884f2db75a8f140ecc08`.
The first runtime seal control remains at
`S/maps-dialog-theme-runtime-sealed-2026-11-01-r1`. Its unchanged guard stopped
on 83,374,080 bytes of shared-volume growth against 64 MiB after 8.361 seconds,
sampled RSS 27,312,128 bytes. Guard/child exits were125/137 with cleanup complete;
`seal.guard.json` SHA-256 is
`62c40a97ea821df0bd3a9015ec97981561b4bb6d841d8b394ce77abb9af5cb4c`.
A manifest file exists but the guarded seal did not pass; no separate full
readback was run and no final seal is admitted. Retain all originals, failed
control and unchanged auditors/caps. Complete sealing remains pending.
