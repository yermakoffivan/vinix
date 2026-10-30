# Maps broker-tail diagnostic runtime, 2026-10-30

Maps now passes the observed anonymous Skip, search, route and preview/Next
sequence. Base-map tiles and place photos remain blank. The complete private
broker pipe capture identifies the account blocker as missing
`UserManager.getSeedAccountOptions()`. No login form, authentication or usable
base imagery is established; no credentials were supplied.

Source checkpoint is `74fd07f21`; preparation began from `ed9603cc7` with the
exact retained [media tools](maps-broker-tail-stage.md) and
[controller/broker producers](maps-broker-tail-producers-2026-10-30.md).
The successor changes the controller, its launcher alias, broker and deployment
receipt. Framework/native/browser/headless inputs remain the exact Window field
pair whose signed regression [passed on ARM](maps-window-system-ui-runtime-2026-10-30.md).
Subsequent seed-options source changes were not deployed in this run.

Paths below are relative to `/Users/alex/.local/state/vinix/android` (`S`):

- Preparation: `maps-broker-tail-r1`, controls:
  `maps-broker-tail-prepare-2026-10-30-r1`.
- Stopped guest: `maps-broker-tail-vm-r1` (`VM`).
- Runtime audit/imports: `maps-broker-tail-runtime-audit-2026-10-30-r1` (`A`).

Preparation passed complete dependency audits, overlay/module readback and final
input rechecking in 174.713 seconds, sampled 71,761,920 bytes RSS, with unchanged
600 MiB RSS/900-second/4 GiB growth/1 GiB reserve caps. Fresh clone and frozen-kernel
installation passed. One owned four-CPU, 12 GiB guest used the recorded executable
identity; both root terminals existed before the controller. Broker readiness
and both explicitly enabled tracing options are retained.

| Input | SHA-256 |
| --- | --- |
| Prepared `sha256.json` | `c6ab0709b40b1718f0d3c6d13e6f1ba3f2a8ccf5de2b6a8e36cd62802ef2c6e9` |
| Controller executable | `bf30d23fb34a382b517688df073fb54b0c140bdedd51afb5444c3f96e870bdbe` |
| Broker executable | `0bf4d36c6c4035eb7e736ee04f3f7a612b9582ef44bad6950bf0aa8b1b1c35ee` |
| Framework JAR | `3f0d220a24e7d91a47f7b2d42cd5620aa498981e915a90cdbd806164b8ef0fc1` |
| Native DSO | `c97862ecb4eba730290a832b2766d58c1552ddf58ae40f77d7e140e69538ce75` |

Saved genuine captures establish these results:

| Interaction | Observed result |
| --- | --- |
| Skip at 13:15:19 UTC | Main Maps UI opens; beige map remains after about 50 seconds. |
| Search `Oasis d Aboukir Paris` | Oasis d'Aboukir and its Paris address returned. |
| Place details | 4.6 stars (98), tourist attraction, open 24 hours; photos stay empty. |
| Palais-Royal → Oasis d'Aboukir | Seven-minute, 1.3 km route with visible geometry; no base map. |
| Preview | `Head toward Rue Thérèse` shown. |
| Next | Right turn to Rue du 4 septembre in 500 m shown. |

Route overlays demonstrate nonuniform rendering, not usable base imagery.
Late pre-route composition samples remain uniformly beige. Private TLS views
include ALPN setup and IPv6 mobilemaps ECONNABORTED failures, but do not establish
the full request/TLS sequence or imagery cause. GUI filesystem checks found the
Maps and GMS `_installed_apks_` catalogs absent before Maps launched; Maps' catalog
was also absent after initialization. No APK/catalog was copied. This differs
from the older successful same-APK baseline, without establishing causation.

The subsequent Sign in → Add account handoff stopped the app. The private
capture `VM/broker-tail-status-private-01.png`, SHA-256
`097f2243e3449222725e6810ebd77e31bfc1e7cf149cfce3ed2a40a3778f9daf`,
shows `NoSuchMethodError` for
`UserManager.getSeedAccountOptions()Landroid/os/PersistableBundle;` at GMS
`atlx.a(:11)` and `atrr.invokeSuspend`, followed by System.exit and
`ANDROID-WS-VM-EXIT status=10`, then account-input disconnection. Reading the
actual screenshot corrects the caller transcription in the closed operator note;
that original note remains unchanged. The controller receipt records broker exit 1 and
`broker_drain={status:1,bytes:153513,error_number:0,eof:true}`. EOF establishes
complete pipe capture within configured bounds; it does not establish login.
The selected-child raw wait-status marker is absent on this path, so no signal
cause is claimed. Two cleanup survivors are recorded; their running-versus-zombie
state was not established. The whole guest was stopped afterward.

The complete public UART archive passed the unchanged strict collector: 24 entries,
2,818 chunks, 1,442,453 bytes, SHA-256
`125cd3f3c99684bcaacfcd7a9d14c329a4118aef6619518ba976a900321bf67b`.
Its 2,243,359-byte interval is
`091d7bf55fdb5c95b25128feb6a3a61517ee85f3e469645007e8687b78e862f1`.
After-Maps receipt `734be2f011e63da920075abb009ef906d7e892be51993837a91b31f639fcdbc7`
links to before-Maps receipt
`506e87675f6e8841ff4d16b3366ae1ceb6beb6a08f19b50b429ba1f6e9a76cb1`.
Private raw logs remain guest-private and excluded except for hashes. Later
read-only GUI log commands may add OS diagnostics to UART; the final whole UART
is not claimed to equal this earlier snapshot. The owned runner sent SIGTERM and
recorded QEMU PID 56385 absent at 13:25:52 UTC without a second signal.

All eight preparation/control/runtime/audit/clone roots are closed to writes.
The unchanged generic sealer and separate fresh-process full readback passed
for 618 entries at
`S/maps-broker-tail-runtime-sealed-2026-10-30-r1/sealed-retry3/manifest.json`,
SHA-256 `78350c15313903175f6c8c0ce8af87a0163a29c6a9b32a4d06af7d6a5a2f1c6b`.
Seal/readback took 6.215/3.210 seconds, sampled 24,559,616/22,855,680 bytes RSS,
and both exited zero with complete cleanup and zero swaps under unchanged
600 MiB RSS/900-second/64 MiB shared-growth/1 GiB-reserve caps. Three preceding
attempts stopped on shared growth at 76,210,176, 92,041,216 and 71,966,720 bytes;
their controls and incomplete outputs remain preserved. The successful retry
changed neither input roots nor caps. No historical checker was changed. Keep
all original complete bundles and auditors.
