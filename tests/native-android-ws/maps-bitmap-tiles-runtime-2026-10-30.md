# Bitmap drawable tiling ARM runtime, first run, 2026-10-30

The signed graphics regression passes on ARM, including all sixteen complete
pixel grids. Google's account window now renders blue setup artwork and its
Next footer instead of the preceding all-white window. It is ErrorActivity;
Next cancels back to Maps onboarding. No login form or authentication success
is established. Place search/details load, but this run retains beige base-map
and gray photo placeholders, so it is not a current imagery or routing pass.
The [earlier positive imagery baseline](maps-persistent-data-block-runtime-2026-10-30.md)
is separate; this run does not establish why imagery differed.

Deployment checkpoint is `fb489384c`, with graphics implementation `5a6cb656a`.
The [framework/native pair](bitmap-tiles-pair-2026-10-30.md),
[fixture runner](bitmap-tiles-fixture-run.md) and
[media profile](maps-bitmap-tiles-stage.md) preserve the complete producers.
The Google APKs, admitted companion catalogs, broker, browser and authority
remain pinned. This validates raw-pixel tiling, not density scaling or a general
shader backend.

Artifacts remain outside Git under `/Users/alex/.local/state/vinix/android` (`S`):

- Prepared image `maps-bitmap-tiles-r1`; controls
  `maps-bitmap-tiles-prepare-2026-10-30-r1`.
- Stopped guest `maps-bitmap-tiles-vm-r1` (`VM`).
- Runtime audit `maps-bitmap-tiles-runtime-audit-2026-10-30-r1` (`A`).
- Transfer `bitmap-tiles-api-transfer-live-2026-10-30-r1`.

Preparation passed complete initial/final audits and 33-module readback in
201.206 seconds, with 73,465,856 bytes sampled aggregate RSS. The original
600 MiB RSS/900-second/4 GiB growth/1 GiB reserve caps and internal 512 MiB
write budget stayed enforced. Fresh clone and frozen-kernel installation passed
in 6.050/33.445 seconds under their original caps. One fresh owned four-CPU,
12 GiB QEMU guest booted the 33-module image with recorded executable identity.

| Input | SHA-256 |
| --- | --- |
| Prepared `sha256.json` | `f3e218fe2794477e4728d9fc0a8d160f6dee5e76622b7503e2b3e155788eeeb6` |
| Framework JAR | `741641c30098cf2f682672889c7ac653c6b2f23b9c09001a7af8f56bb01d9500` |
| Native DSO | `6969a813fbfe69cd882f3cb47760cb09cb106ca9aad748ea67ab93967aacad20` |
| Signed fixture APK | `d4aedf04a871758249fbea08e79a7ac49f9fdb2eb98f915f6a7c8ee389fede7c` |
| Exported fixture receipt | `3978a376f1b46bd223c8ce1f7611032a5e35eda3778c01835017d4433d25abce` |

The fixture passed on its first invocation: protected `/opt/tiles-input`, fresh
`/opt/tiles-result`, UID/GID 10127, child PID 57338 and `wait_status=0`. Its six
exact pins, eleven checks, one PASS/READY pair and complete log were verified.
Assertions cover nullable mode/setter/reset state, change invalidation, retained
Paint, all repeat/mirror/clamp combinations, translated/negative/huge bounds,
clipping, alpha, empty inputs and Canvas state. Unchanged zero-removal diagnostic
tools validated the export; no strict SERVICE-QUERY import is claimed. Complete
details remain in `A/fixture-validation.md`. The runtime mount was released
before starting the broker.

The broker reached readiness with PID 21747 and both companion catalogs
provisioned for Maps UID 10012; GMS uses UID 10013. The actual Maps launcher was
selected at 18:00:23 UTC. Sign in → Add account opened the artwork/Next window
(`VM/tiles-account-window-01.png`); Next returned to onboarding
(`tiles-account-next-01.png`). Private logs identify ErrorActivity under
AddAccountController, ending at stage 9/operation 2/event 2/code 4 (cancellation).
The specific preceding controller reason was not captured. Reflected `getUsers`
failures are not established as the cause. A nearby PendingIntent warning was
traced to NetworkScheduler's GCM ACTION_SCHEDULE path, not the account caller;
it justifies no account-identity authority change. The missing error text remains
unresolved. No credentials were entered.

After cancellation, Skip and corrected Oasis d'Aboukir search returned place
name, rating/address and details. `tiles-map-after-skip-02.png` and
`tiles-place-photos-01.png` retain the unfilled map/photo regions. GPS, voice,
route preview and authentication are unverified in this run.

The controller naturally ended its bounded session: start 17:57:04, finish
18:13:19 UTC, status `bounded-session-ended-no-authentication-claim`, empty error
and readiness true. The later stop request at 18:14:03 did not cause that
termination. Broker exit 137 follows bounded owned cleanup; two reported
survivors have unestablished running/zombie state. No clean broker exit or raw
selected-child wait event is claimed. Drain confirms EOF with status 1,
173,358 bytes and error number zero. The owned QEMU PID 33632 received SIGTERM
at 18:14:47; unchanged observation confirmed absence at 18:14:48.

Strict import rejected console interleaving in CHUNK 2765. Its failed controls,
failed zero-removal plan and untouched original 2,255,871-byte interval remain:
SHA-256 `411bd0112beb65a5f7c69ce968ddb9c4bb54d755caa4e3c4f0f819b3b2c83679`.
The unchanged diagnostic reconstructor accepted three explicitly pinned
console-only removal spans totaling 222 bytes in its ephemeral parsing view.
Every original chunk/header and the complete advertised archive hash remained
required. The recovered 24-entry/2,835-chunk/1,451,499-byte archive hashes to
`12d3fd0c38b60feac608d5b44a1cd1170927ec50a5fa544862233b67259740f6`.
See `A/maps-export-recovery.md`; this is diagnostic recovery, not strict success.
Private application logs remain excluded from public UART except hashes.

All nine original roots, including the four adjacent original clone sidecars,
are closed. Complete sealing and separate fresh-process full readback passed
for 623 entries at
`S/maps-bitmap-tiles-runtime-sealed-2026-10-30-r1/sealed/manifest.json`, SHA-256
`df76519f09d6bd4d676c1cae5ca7d9c7720cb1479861cd340c7cb77bfe117c71`.
Seal/readback took 14.677/6.098 seconds with sampled RSS
24,117,248/24,002,560 bytes. Both guards and children exited zero with complete
cleanup and zero swaps under the unchanged 600 MiB RSS/900-second/64 MiB
shared-growth/1 GiB-reserve caps. No seal attempt failed. Preserve every original
complete bundle and its unchanged auditors.
