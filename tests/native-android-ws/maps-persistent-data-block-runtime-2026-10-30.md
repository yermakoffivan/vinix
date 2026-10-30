# Final anonymous Maps runtime validation, 2026-10-30

Maps again renders real labeled tiles, Paris streets and photos, search results,
routes and preview/Next instructions on ARM. The previous persistent-data class
failure and native null-Activity abort did not repeat in the inspected account
flow. Sign-in remains unresolved: the Google account window stays blank, and
its layout inflation reports missing `BitmapDrawable.setTileModeXY`. No login
form, credentials or successful authentication are claimed.

Deployment checkpoint is `65e9bc3cd`, following the
[working imagery/route baseline](maps-seed-account-companion-runtime-2026-10-30.md).
The [SDK/native pair](persistent-data-block-pair-2026-10-30.md) adds the absent
persistent-data manager type, typed null service lookup and native View window
null/pending-exception guard. It adds no persistent-data backend or operations.
The controller, broker and admitted Google companion catalogs remain pinned.
The [fixture runner](persistent-data-block-fixture-run.md) and
[media profile](maps-persistent-data-block-stage.md) retain complete producers.

Paths below are relative to `/Users/alex/.local/state/vinix/android` (`S`):

- Prepared image: `maps-persistent-data-block-r1`; controls:
  `maps-persistent-data-block-prepare-2026-10-30-r1`.
- Stopped guest: `maps-persistent-data-block-vm-r1` (`VM`).
- Runtime audit/imports: `maps-persistent-data-block-runtime-audit-2026-10-30-r1` (`A`).
- Transfer: `persistent-data-block-api-transfer-live-2026-10-30-r1`.

Preparation passed complete initial/final audits, seven-file overlay and module
readback in 185.675 seconds, with 89,948,160 bytes sampled aggregate RSS.
Original 600 MiB RSS/900-second/4 GiB growth/1 GiB reserve caps and the internal
512 MiB write budget stayed enforced. Fresh clone and frozen-kernel installation
passed. One owned four-CPU, 12 GiB guest ran with both root terminals opened
before testing.

| Input | SHA-256 |
| --- | --- |
| Prepared `sha256.json` | `6a170ca8049800d72852cf56dab5754880ffccd256ab3142defbeb2f400058d8` |
| Framework JAR | `7c1b2fa03924003c7717e07ef463bff81c6429c7667b2bc42d35954fb6d41752` |
| Native DSO | `192411171dec072c89a64a81d8b35f36e92d060c75505fadceb47d683e9ed2e5` |
| Signed fixture APK | `0acd05b909c7c2d3b798cb515a799df8c40263af9be1e7ab4334f7b4f113b7a8` |
| Exported fixture receipt | `68fd22f2cc77cd48db56e310b0b1d287ccd8d75f72b6687f60c1b24c332b7f15` |

The signed standalone regression passed on its first invocation using protected
`/opt/pdbm-input` and fresh `/opt/pdbm-result`: UID/GID 10125, child PID 57683,
`wait_status=0`, exact six pins and eleven checks, one PASS and one native READY.
It covers named/typed service absence and null casting, plus ordinary service,
seed-options and immutable-empty controls. The unchanged zero-removal diagnostic
tools validated receipt/log/protocol/limits; no strict SERVICE-QUERY import is
claimed. The runtime mount was released before the broker. See
`A/fixture-validation.md` for the complete checks.

Both admitted companions were provisioned for Maps UID 10012. Genuine captures
revalidate the manual anonymous workflow:

| Interaction | Actual result |
| --- | --- |
| Skip | Labeled map tiles. |
| Oasis d'Aboukir search | Paris address, detailed street map and real photos. |
| Palais-Royal → Oasis d'Aboukir | Seven-minute route over the base map. |
| Preview | `Head toward Rue Thérèse` with map/route. |
| Next | Right turn to Rue Saint-Augustin in 400 m with map/route. |

The retained images are `VM/pdbm-map-after-skip-01.png`, `pdbm-place-photos-01.png`,
`pdbm-route-loaded-01.png`, `pdbm-route-preview-01.png` and `pdbm-route-next-01.png`.
GPS, voice and live navigation were not tested.

Add account opened a separate window which stayed open past the previous failure,
but its content remained blank. Private capture
`VM/pdbm-account-layout-error-private-01.png`, SHA-256
`aab715389f6bb248e2f51432a74051c3492c15cd2906c3a1df45afb2e5f0c05e`,
shows layout-inflation `RuntimeException`/`InvocationTargetException` caused by
missing `BitmapDrawable.setTileModeXY(Shader.TileMode, Shader.TileMode)` through
`SetupWizardLayout.a`, its constructor and `SetupWizardAccountLayout` constructors.
This is an unresolved sign-in UI limitation; this deployment implements no bitmap
tiling fix. The account window was closed through its native title bar, and Maps
remained displayed (`pdbm-maps-after-account-close-01.png`). A bounded complete-log
search returned zero matches for the previous persistent-data class failure,
`JNI DETECTED` and `ANDROID-SERVICE-EXIT`. That establishes no repeat on this
captured path, not correctness of every possible teardown state.

The controller naturally ended its bounded session: start 15:45:02, finish
16:00:43 UTC, status `bounded-session-ended-no-authentication-claim`, empty error
and readiness true. The later Back/stop request occurred after that deadline;
the stopped-app screen and missing protected session file then are not a new
account crash. The late explicit stop refusal bypassed no identity check.
Recorded broker exit 137 follows bounded owned cleanup, with two survivors of
unestablished running-versus-zombie state. No raw selected-child wait event is
claimed. Drain is `status:1, bytes:172149, error_number:0, eof:true`: complete
bounded pipe capture, not authentication success.

The unchanged strict collector accepted the complete public export: 24 entries,
2,835 chunks, 1,451,394 bytes, archive SHA-256
`3cd64501b941c3b5c32536d38801ae9fdb45452064f0845fdf7ad24043dfc3de`.
The exact 2,257,596-byte interval is
`fb56175646de4322ec0fc171bd4baf5ad10658197235948e4091f687b7b991e2`.
After-Maps receipt `e2fce56205cfea0cb1f1114f14ddb8b23050c86bb703281f8d5f3cd17e6f9c6e`
links to before-Maps receipt
`ba2a021785ab60aafe56754af415368e673ddfa47f4490c7ed0698a40c173548`.
Private application logs remain excluded except hashes. Subsequent read-only GUI
commands can add OS diagnostics to final UART, so it need not equal this snapshot.
The owned runner recorded SIGTERM for PID 810 at 16:05:06; unchanged reconciliation
recorded absence at 16:06:04 without another signal or ownership bypass.

All nine original preparation/control/runtime/audit/transfer/clone roots are
closed to writes. The unchanged generic sealer and separate fresh-process full
readback passed for 657 entries at
`S/maps-persistent-data-block-runtime-sealed-2026-10-30-r1/sealed-retry1/manifest.json`,
SHA-256 `deaa61aace9a4b62ee17a54f0814dd72dbdf08f9a36b688447e9b10feca4a7ae`.
Seal/readback took 7.450/3.449 seconds, sampled 28,721,152/22,937,600 bytes RSS,
and both exited zero with complete cleanup and zero swaps under unchanged
600 MiB RSS/900-second/64 MiB shared-growth/1 GiB-reserve caps. The first attempt
stopped at 96,903,168 bytes observed growth after 0.225 seconds; its controls and
incomplete output remain preserved. No input roots, caps or historical checkers
were changed. Retain all original complete bundles and auditors.
