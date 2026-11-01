# Google account page branch diagnostic

A fresh credential-free probe of the unchanged Dialog pair reaches the account
error activity path. Bounded private `new Context` records occur in order:
AccountIntroActivity/ChimeraActivity, WrapperControlledActivity/ChimeraActivity,
PreAddAccountActivity/ChimeraActivity, then ErrorActivity/ErrorChimeraActivity.
The page remains incomplete. This identifies activity construction order, not
the missing content's cause. Next was not clicked in this probe and Google
authentication remains unverified.

The reused prepared image is `maps-dialog-theme-r2`, manifest SHA-256
`4b28f8921073af2168a6a2bd639c7897f5b2796cc3142a4f8a06228de21efdf2`.
No source, APK, framework, native or fixture change was deployed. Provider
`b97a9861a`, [qualified SDK/native pair](dialog-theme-pair-2026-11-01.md)
`8a885b8b3` and corrected [media](maps-dialog-theme-stage.md) `92d05cabc` remain
pinned. The [earlier Dialog ARM and Maps run](maps-dialog-theme-runtime-2026-11-01.md)
separately establishes the fixture pass, real tiles, Paris search/photos and
working profile menu. That run clicked Next and returned to unauthenticated
Maps; this probe does not repeat that action or run a new fixture.

Artifacts remain beneath `/Users/alex/.local/state/vinix/android` (`S`):

- Audit `maps-account-screen-runtime-audit-2026-11-01-r1` (`A`).
- Controls `maps-account-screen-live-controls-2026-11-01-r1` (`E`).
- Stopped guest `maps-account-screen-vm-r1` (`VM`) and four adjacent clone sidecars.

Fresh clone and frozen-kernel installation/readback passed in 5.402/38.657
seconds, sampled aggregate RSS 25,444,352/33,488,896 bytes, all guard/child exits
zero with complete cleanup. Original 600 MiB/900-second/2 GiB-growth/1 GiB-reserve/
file-size caps remained. The qualified coexistence runner launched owned
PID12593 at 03:39:49 UTC with 12 GiB/four CPUs. Admission snapshots preserve
foreign PID91929's original start identity; no foreign process was signalled or
modified. Admission is not continuous monitoring. No compiler ran during this
owned guest test.

`VM/account-probe-branch-private-01.png` at 03:44:33 records zero matches for
the selected no-network message, BrowserSignIn and ANDROID-WS-TREE. These finite
selected-log counts do not establish network or browser capability; no numeric
view tree was emitted. `account-probe-order-private-01.png` at 03:46:55 shows
the chronological context sequence above. The captures contain bounded class
names/counts only, without URLs, HTML, cookies or credential/form content.
`account-probe-health-private-01.png` at 03:48:28 confirms a writable root tmpfs
and parent broker PID36323, root UID/GID and sleeping state. The selected
JNI/service-exit/fatal count is zero; this does not establish every GMS child's
health. The runtime mount remains read-only. No cause is assigned to networking,
WebView, theme resolution or the error activity's Intent.

Actual controller receipt `A/strict/results/receipt.json`, SHA-256
`af30ac72e861033527434963fcc62f3ba2f8d22397bc6e53b8f89ff06b7a8bba`,
starts 03:41:18 and finishes 03:48:32, status
`user-stopped-no-authentication-claim`, readiness true and empty error. Stop was
requested at 03:48:29 before the 15-minute bound. Broker exit137 follows
controlled cleanup; no clean exit is claimed. Drain EOF is true, status1,
170,430 bytes and error number0; two cleanup survivors' running/zombie states
are unknown. No credentials, account creation or authentication is claimed.

The unchanged strict account collector passed 25 entries/2,835 chunks/
1,451,386 archive bytes, SHA-256
`e346534edbc3e5d3dc404dd149f604f3f945beb3934eb9f19230847ebf1511f9`.
The exact 2,255,703-byte interval is
`0bf5f9d529f2fffd262f94830140343727b5da99cd7f0bd99a3784a4cb5361a4`;
linked snapshot receipts match, and stopped final UART equals its full snapshot.
Complete private app/broker logs remain excluded. Export integrity does not
establish authentication. Owned VM12593 received one SIGTERM at 03:49:56. After
a transient ownership race following its stop receipt, absence was verified and
reconciliation returned zero without another signal. Foreign91929 retained its
original start identity and remained untouched.

All seven current roots are closed to writes; the reused prepared image remains
closed in its original audit. Final `A/operator-notes.md` SHA-256 is
`6809d98d74b48589334410583879c2a180dab6f09a0ee57a9b9e0679dd339a92`.
Complete sealing and separate fresh-process full readback passed seven roots/
422 typed entries. Manifest
`S/maps-account-screen-runtime-sealed-2026-11-01-r1/sealed/manifest.json` has
SHA-256 `eaf36f16462b9eb1bfb52a80e80fec3af079af932fd154876a42084bdd596204`.
Seal/readback took 3.692/2.272 seconds at sampled aggregate RSS
24,526,848/14,204,928 bytes, with zero guard/child exits, complete cleanup and zero
process swaps. The unchanged qualified sealer and original 600 MiB/900-second/
64 MiB-growth/1 GiB-reserve/file-size caps were used. Retain complete original
bundles and unchanged auditors.
