# Maps imagery-first runtime and connectivity observations, 2026-10-30

The current bitmap runtime renders real labeled map tiles, Paris streets and
place photos before sign-in. Search and place details work. A later profile/avatar
action exits Maps with missing `Window.setWindowAnimations(I)V`; no account UI or
authentication success is established in this run. Routing, GPS, voice and live
navigation were not checked.

This is a fresh clone of the unchanged `fb489384c` image/runtime used by the
[first bitmap run](maps-bitmap-tiles-runtime-2026-10-30.md). Its sixteen-grid ARM
graphics pass remains applicable to the identical pair; it was not repeated.
No SDK, native, kernel behavior or Google APK changes were made. The different
interaction order and positive imagery do not prove that the first run's account
cancellation caused its placeholders.

All artifacts remain under `/Users/alex/.local/state/vinix/android` (`S`):

- Shared immutable image `maps-bitmap-tiles-r1` (`P`).
- Controls `maps-bitmap-tiles-imagery-prepare-2026-10-30-r1`.
- Stopped guest `maps-bitmap-tiles-imagery-vm-r1` (`VM`).
- Audit/imports `maps-bitmap-tiles-imagery-audit-2026-10-30-r1` (`A`).
- Transfer `connectivity-truth-api-transfer-live-2026-10-30-r1`.

| Input | SHA-256 |
| --- | --- |
| Prepared `sha256.json` | `f3e218fe2794477e4728d9fc0a8d160f6dee5e76622b7503e2b3e155788eeeb6` |
| Framework JAR | `741641c30098cf2f682672889c7ac653c6b2f23b9c09001a7af8f56bb01d9500` |
| Native DSO | `6969a813fbfe69cd882f3cb47760cb09cb106ca9aad748ea67ab93967aacad20` |
| Connectivity APK | `e562c6344c8560908a5d5cd70fa0480d76ea60ba6929e0720a2fbe69abba943d` |
| Exported probe receipt | `7a9d99b68f1c5915b34c49b7d8f27555ae24664db8e535cd04b9f873553197d2` |

Fresh clone and frozen-kernel installation/readback passed in 12.499/76.289
seconds, sampled RSS 24,510,464/31,195,136 bytes. Their original 600 MiB RSS,
900-second, 2 GiB observed-growth and 1 GiB-reserve caps stayed enforced. Fresh
owned QEMU PID 42329 booted the identical 33-module image with 12 GiB/four CPUs;
executable/firmware/runner identity is retained. Two root terminals were opened,
and the broker provisioned the admitted companions and reached readiness.

The read-only [connectivity fixture](connectivity-truth-fixture-2026-10-30.md)
and [qualified runner](connectivity-truth-fixture-run.md) are committed as
`481e415c5` and `5a3428975`. The probe ran once after broker readiness as the
existing GMS UID/GID 10013, with protected `/opt/truth-input` and fresh
`/opt/truth-result` data/home/surface. Child PID 13844 exited cleanly; six pins,
eleven checks and one PASS/READY pair were verified. Unchanged zero-removal
diagnostic import preserved every byte. See `A/probe-validation.md`.

| Actual observation | Result |
| --- | --- |
| Active NetworkInfo | Present, connected/available, CONNECTED, ETHERNET type 9. |
| Networks | One active network; active and array handles agree. |
| Capabilities/transports | `[12, 13, 14, 15]` / `[3]`; INTERNET true, VALIDATED false. |
| Existing protected JNI state | 132099. |
| Interfaces | Up eth0 with 10.0.2.15 and IPv6 addresses; up lo. |

The PASS marker means observation completion, including honest offline/error
results. This separate bootstrap process under the GMS Unix UID does not prove
the Google application's own cached objects, callbacks, account-controller query,
transport reachability or validation result. No state was manufactured. During
setup an operator bind briefly duplicated the broker's attachment; one umount
reported Resource busy but left one protected ro/nosuid/nodev/wxallowed mount,
verified before the probe. No further unmount was attempted.

Maps opened through its real launcher and Skip was used before any sign-in.
`VM/imagery-map-01.png` shows labeled North America tiles.
`imagery-place-photos-01.png` shows detailed Paris streets, Oasis d'Aboukir's
address/rating and real photos. These actual captures revalidate anonymous
imagery/search/details on the current pair.

After those captures, clicking the profile/avatar exited Maps. The private stack
in `imagery-avatar-stack-private-01.png` reports `NoSuchMethodError` for
`android.view.Window.setWindowAnimations(I)V`, starting at Maps `bqpt.vm`
(source 37) through the avatar onClick and View dispatch. The exited-app screen
in `imagery-account-menu-02.png` predates the later controlled session stop.
This is the concrete next API blocker. No Google account window was opened here,
so this run supplies no new reason for the earlier GMS ErrorActivity.

The protected stop request was entered at 18:54:16 UTC. Controller receipt start
is 18:39:47, finish 18:54:19, status `user-stopped-no-authentication-claim`, empty
error and readiness true. Broker exit 137 follows controlled cleanup; one reported
survivor has unknown running/zombie state. No clean broker exit or selected raw
wait event is claimed. Drain confirms EOF: status 1, 107,806 bytes, error number
zero. Owned QEMU received SIGTERM at 18:56:22; unchanged reconciliation confirmed
PID 42329 absent at 18:56:53 without a second signal.

Complete strict import passed: 25 entries, 2,834 chunks and 1,450,804 archive
bytes, SHA-256 `b9a634f11ecab04a753c700d9b71086afcdbcd4744027d21adca3c8289f3406c`.
No reconstruction/removal was used. The exact 2,252,825-byte public interval is
`9db81c59aec07e2f11f18ad48490de73c3049ab5325e68f8ae25590d1ff7c461`.
Raw application logs remain excluded except hashes and bounded private captures;
later OS diagnostics may extend final UART beyond this snapshot.

The original nine roots, including shared P and four adjacent original VM clone
sidecars, passed complete sealing and separate fresh-process full readback:
595 entries, `S/maps-bitmap-tiles-imagery-runtime-sealed-2026-10-30-r1/sealed/manifest.json`,
SHA-256 `31a77f6c6fa4552624d86970348d20f8bd722c78248e6f08bd1db06babedd110`.
Seal/readback took 8.224/3.281 seconds with sampled RSS 15,613,952/22,855,680
bytes. Both guard/child exits were zero with complete cleanup and zero swaps
under unchanged 600 MiB RSS/900-second/64 MiB shared-growth/1 GiB-reserve caps.
No seal attempt failed. First-run roots remain closed and unchanged; retain all
original complete bundles and historical auditors.
