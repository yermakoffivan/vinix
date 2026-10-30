# ImageView ARM regression and Maps account runtime, 2026-10-30

The signed ImageView regression passed on ARM with the exact new framework/native
pair. Maps' account flow then advanced to a different failure:
`WindowManager.LayoutParams.systemUiVisibility:I` is missing. The inspected stack
no longer shows `ImageView.getMaxHeight`. Google login, authentication and current
map imagery remain unverified; no credentials were supplied.

The run follows source `a9c7c95ae`, including the
[bounded dependency-inventory tools](maps-imageview-bounds-parallel-tools-2026-10-30.md).
Its [framework/native producers](imageview-bounds-producers-2026-10-30.md),
[host checks](image-bounds-host-2026-10-30.md),
[fixture runner](image-bounds-fixture-run.md), and
[media profile](maps-imageview-bounds-stage.md) retain their exact source and input
closures. Concurrent unrelated checkout changes were not included in the frozen
Android tools or runtime inputs.

Paths below are relative to `/Users/alex/.local/state/vinix/android` (`S`):

- Successful preparation: `maps-imageview-bounds-r3`; controls:
  `maps-imageview-bounds-prepare-2026-10-30-r3`.
- Stopped guest: `maps-imageview-bounds-vm-r1` (`VM`).
- Runtime controls/imports: `maps-imageview-bounds-runtime-audit-2026-10-30-r1` (`A`).
- Transfer: `image-bounds-api-transfer-live-2026-10-30-r1`.

Preparation attempt 1 stopped during final input rechecking when observed shared
volume growth reached 4,307,079,168 bytes, exceeding its unchanged 4 GiB cap.
Its partial `maps-imageview-bounds-r1` and controls remain preserved. Attempt 2
stopped after 5.683 seconds when its RSS monitor exceeded one second; no r2 output
image exists. The unchanged qualified two-worker stager completed fresh attempt 3
in 212.880 seconds, sampled 83,558,400 bytes RSS and recorded zero swaps. The
600 MiB RSS, 900-second, 4 GiB shared-growth, 1 GiB reserve and internal write
limits remained enforced. Clone and frozen-kernel installation passed in
5.535/31.338 seconds with complete cleanup.

The four-CPU, 12 GiB guest used the same frozen kernel and qualified runner as the
[previous account retry](maps-platform-fragments-account-runtime-2026-10-30.md).

| Artifact | SHA-256 |
| --- | --- |
| Prepared r3 `sha256.json` | `6fa4cb4086126a2c1c3a66252474abd8bad79d8b15c4394a305d0f1db7998eb5` |
| Framework JAR | `9cfdbeaff047b693837508c3f7676510a63c05af118e864964b4b432fb813af9` |
| Native DSO | `fd38d7f8e3c0d17934617242cb95b0412a0c6ed676cb4454e5a52c8cf494dc2c` |
| Signed fixture APK | `7d11a0e6d71b6c556a57f84fd5f27610157f0a49735282f0bb31aaac0ff00a62` |
| Exported fixture receipt | `115ddae7e1317181f135e0e1a7f285d4887bd43460141c129b094f775e08d0f6` |
| Decoded fixture child log | `8ca82dd3873734331b9e44b2713a5afa999eaf751819db1b26d8f7936bfdfdc9` |

The initial fixture invocation refused input-directory mode 0700 before child
launch or export. The root-owned public-fixture input directory was corrected to
0755, and the unchanged runner/APK passed using a fresh result path. Its receipt
records UID/GID 10119, `wait_status=0`, exact pins, one PASS and one native readiness
marker. It covers constructor defaults/virtual setter ordering, signed setters,
axis/instance isolation, inheritance and styled dimensions. Measurement remains
outside scope. The fixture mount was released before broker startup.

The strict collector refused unsupported `--service-query` before parsing or
creating output; that refusal is retained. The unchanged no-removal planner,
diagnostic reconstructor and child extractor all passed, including exact child
log/receipt hash agreement. `A/fixture-validation.md` preserves the detailed
checks. This is a zero-removal diagnostic derivation, not a strict fixture import.

Both root terminals existed before the fixture and broker. Maps rendered
onboarding and its Add account chooser, then opened a partially rendered account
window and displayed the compositor's stopped/exited message. The private capture
`VM/image-bounds-private-system-ui-stack.png`, SHA-256
`0de015f7c01536c7ef134c036761456439b39266ca239d9f853d0cfc2750e230`,
shows `ANDROID-SERVICE-EXIT phase=6 reason=1 status=1` and `NoSuchFieldError` for
`WindowManager$LayoutParams.systemUiVisibility:I`, through `gjbr.e`, `gjbr.f`,
`atsn.b(:283)` and `WrapperControlledChimeraActivity`. This identifies the inspected
account failure; it does not establish a usable login form.

The complete Maps export passed the unchanged strict collector: 24 entries,
2,819 chunks, archive SHA-256
`6a2a096cb32a84cc9d37356618721163304835ce8153692fc4defebec55315e7`.
The exact 2,236,862-byte interval is
`5a49c2a5b8a0db5c3098b2e3ab54921f54f07982cdc4f36f3bcd264049ac008b`;
after-Maps receipt `27bdd6f38b1912cdbe4d7efa8e5bd03421d07204516fc2d3d3e9166551d6f450`
links to before-Maps receipt
`080d0a7d150b29c760a3058d4fd90eb6eac6e3ca123e130b99a7d62436bba409`.
The imported controller receipt reports `status=failed`, `broker_exit=1` and two
cleanup survivors. Private raw logs remain excluded by its existing producer.
The whole guest was stopped afterward: SIGTERM at 11:38:32 UTC, then recorded
absence at 11:38:36 through unchanged reconciliation after a transient ownership
mismatch. No second signal was sent or ownership check bypassed.

All fourteen roots were closed to writes: successful preparation and controls,
failed preparations and retained partial r1, VM, audit, transfer, four original
clone sidecars, and both original host-check/fixture roots. The unchanged generic
streaming sealer and separate fresh-process full readback passed for 796 entries:
`S/maps-imageview-bounds-runtime-sealed-2026-10-30-r1/sealed/manifest.json`, SHA-256
`88bdf92441f570442dbca31cd46e880c4af29169502cad8971254c4dc514a0c6`.
Seal/readback took 14.046/4.727 seconds with sampled RSS 28,884,992/22,888,448 bytes,
zero exits, complete cleanup and zero swaps. Caps stayed at 600 MiB RSS,
900 seconds, 64 MiB observed shared-volume growth and 1 GiB reserve. This generic
integrity seal retains partial r1 without qualifying it as prepared media; no
historical checker was weakened. Keep the complete original bundles and auditors.
