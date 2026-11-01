# PaintDrawable ARM pixels and Maps profile retry

The signed PaintDrawable fixture passes on ARM, including offscreen pixels,
corner state, callbacks, arrays, XML inflation and Canvas-state restoration.
Maps completes onboarding and renders real labeled tiles. Opening the avatar
then exits with `IllegalArgumentException: Failed to resolve SURFACE_CONTAINER_LOWEST`,
top `brsj.a` source 87. The earlier missing PaintDrawable/Resources failures are
absent from this successor stack. No working profile menu, account window or
authentication is established. Search/photos, GPS, routes and navigation were
not repeated on this pair; the prior Resources pair's Paris imagery is separate.

The deployed API source is `a13caf3e9`, qualified [SDK/native pair](paint-drawable-pair-2026-11-01.md)
`59adb5a4e`, signed [fixture](paint-drawable-host-2026-11-01.md) `67b06755f`,
[runtime tools](paint-drawable-fixture-run.md) `efc6802b8` and
[media](maps-paint-drawable-stage.md) `41657eb20`. Only one fieldless, five-method
PaintDrawable subclass is added; all 2,107 old classes remain exact. The retained
native library's 69 consumed canonical classes match its own Resources SDK,
with only the known raw Resources formatting pair differing. No native rebuild
or relink was performed. Complete audits preserve native sources, JNI, C and
exports. Google APKs, account identities and validation policy remain unchanged.

Artifacts remain beneath `/Users/alex/.local/state/vinix/android` (`S`):

- Prepared `maps-paint-drawable-r1` (`P`).
- Controls `maps-paint-drawable-prepare-2026-11-01-r1` (`E`).
- Stopped guest `maps-paint-drawable-vm-r1` (`VM`).
- Audit `maps-paint-drawable-runtime-audit-2026-11-01-r1` (`A`).
- Transfer `paint-drawable-api-transfer-live-2026-11-01-r1` (`T`).

| Input or result | SHA-256 |
| --- | --- |
| Prepared `sha256.json` | `d835836d3ce75adde417df33ebbfc866705c2010c583fe15beb57bb9a4237fbe` |
| Framework JAR | `b3fed7d846a23d9e8afc1256e5bfa7d9ebcd1ba5330705d40fd14131291d516c` |
| Retained native DSO | `441ae035ec4b69c36635cc4521af3fafcb6a867305b0ba25d6e55df7ff0dadc9` |
| Signed fixture APK | `cd459b703196920a7e07e1bfdb7d43e304c1115b12b1ad0998281fab1ea64868` |
| ARM runner | `b18b61aa29edd5760e06c164899ed66fd220e1d74e1715c511b984b7ab68d43e` |
| Controller receipt | `7799da27f3c4642ab185abd1df49abfb884280aeacc178f113a404c461c16751` |

Preparation, clone and frozen-kernel installation/readback passed in
455.322/12.426/80.465 seconds, sampled RSS
84,885,504/35,160,064/49,266,688 bytes. All guard/child exits were zero with
cleanup complete. Original 600 MiB/900-second/1 GiB-reserve/file-size limits
remained enforced, with 4 GiB preparation and 2 GiB clone/kernel growth caps.
Preparation observed 2,464,153,600 bytes of shared growth; internal stager charge
196,931,584 bytes stayed below 512 MiB. The qualified coexistence runner launched
owned PID 55781 at 02:10:02 UTC with 12 GiB/four CPUs; its tool completed at
02:10:04. Admission snapshots record the same foreign PID 91929/start identity,
combined 28 GiB/eight CPUs on the 128 GiB/18-logical-CPU host, pressure1 and disk
reserve. No foreign process was signalled or modified; admission is not
continuous monitoring.

The standalone fixture used paint-check UID/GID 10134, protected root-owned
inputs, one ro/nosuid/nodev/wxallowed runtime bind with actual relatime flags and
separate output. Exact six pins and eleven checks pass, with one full PASS and
readiness marker, bounded complete log, drained EOF and clean exit. Tests cover
inherited Paint identity, constructors/corner selection, invalidation counts,
array validation/reference mutation, 16-by-16 pixel grids/rounded samples,
alpha/color/translation/clipping, restored state and four packaged XML controls.

Unchanged zero-removal diagnostic SERVICE-QUERY import passed for 15,046 archive
bytes/30 chunks, SHA-256
`0b75a459c6a5b9ed8c407b985fb7f651dfcf89c9b6574098effa7b6ec43e7c14`.
The 9,239-byte/108-line child log is
`adacf9f3a9f0c7ee78dcc4f4d7be3a3fb45ad1df64baee7dc98c1f4584c3c08c`,
with exact Paint PASS at line 91, READY102 and onDestroy/final LF at 108. No
payload repair or relaxed health check was used. This is diagnostic fixture
import, not strict fixture-protocol qualification. Detailed validation remains
at `A/fixture-validation.md`, SHA-256
`aaa2b38a332a74f4a04c387007b256d6168a105733c10158d67ab9947aa9a3bd`.

After mount release, `VM/paint-map-01.png` at 02:15:59 shows current real North
America tiles. Avatar was clicked at 02:16:09; `paint-profile-01.png` shows the
exited app at 02:16:21. Bounded private error/stack captures identify the theme
resolution exception, through `brsj.a`, `bqud.a` and `btqy.s`. Its cause is not
guessed here. The PaintDrawable ARM regression is independently passing.

Private broker checks before/after profile show two snapshot-config causes but
no selected fatal/native-exit records. The post-profile parent PID 27631 is root
UID/state S, which does not establish every GMS child's health. Actual controller
receipt starts 02:12:14 and finishes 02:18:50, status
`user-stopped-no-authentication-claim`, readiness true and empty error. Stop was
requested at 02:18:48 before the 15-minute bound. Broker exit137 follows
controlled cleanup; no clean exit is claimed. Drain EOF is true, status1,
107,358 bytes and error number0; one cleanup survivor's running/zombie state is
unknown. No credential was supplied or authentication claimed.

The unchanged strict account collector passed 25 entries/2,835 chunks/
1,451,170 archive bytes, SHA-256
`02a3148bd492a7349d68f1f6ce53a3497be8196bb6b165a791539a2520dfd334`.
The exact 2,252,945-byte interval is
`77b899c56eaa74578567c22db5db0e0b47613b53d705194a8f6ca25ce848ad8d`;
linked snapshots agree and stopped final UART matches its full snapshot. Raw
private app/broker logs remain excluded except hashes and bounded private
captures. Integrity PASS does not establish the failed profile or Google login.
Owned VM55781 received one SIGTERM at 02:19:29; after a transient ownership
error its absence was verified and reconciliation returned zero without a
second signal. Foreign91929 retained its original start identity and was untouched.

All nine original roots, including four adjacent VM clone sidecars, are closed
to writes. Final `A/operator-notes.md` SHA-256 is
`65518613d4c3d3ba6d2dc69f5f356da75f5c86afc8e80099beea0c0f44523c01`.
The first complete-seal attempt is preserved at
`S/maps-paint-drawable-runtime-sealed-2026-11-01-r1`. The unchanged guard stopped
it on observed shared-volume growth of 121,888,768 bytes against 64 MiB after
3.679 seconds, sampled RSS 13,221,888 bytes. Guard/child exits were 125/137 with
cleanup complete; `seal.guard.json` SHA-256 is
`31dc2a94c1217c6cca77bc406465e0c15f0d34e89055abee8633391afa8ecc14`.
It produced partial inventories but no manifest; no fresh readback was run for
that attempt. The failed control remains preserved.

A later coordinated retry passed complete sealing and separate fresh-process
full readback for ten roots: the nine closed originals and complete failed
control, 639 typed entries. Manifest
`S/maps-paint-drawable-runtime-sealed-2026-11-01-r2/sealed/manifest.json` has
SHA-256 `916d8f06dc6bfe0b0549a26ddf7e82d7bc1d2c9f3ff4c8072eb08ef24b64bd59`.
Seal/readback took 8.473/3.352 seconds at sampled RSS 28,229,632/13,385,728 bytes;
observed growth was 23,785,472/204,800 bytes. Both guard/child exits were zero,
cleanup complete and process swaps zero. The unchanged qualified sealer and
original 600 MiB/900-second/64 MiB-growth/1 GiB-reserve/file-size limits were
used. This recovers evidence completeness; the runtime outcomes above remain
unchanged. Retain all originals, both controls and unchanged auditors.
