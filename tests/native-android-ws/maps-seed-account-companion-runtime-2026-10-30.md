# Maps imagery, search and routes pass on ARM, 2026-10-30

The real Maps workflow now renders labeled map tiles, Paris streets and place
photos, search results, a route and its preview/Next instructions. Google account
handoff still fails: the primary error is missing `PersistentDataBlockManager`,
followed during teardown by a separate native null-Activity JNI abort. No login
form or successful authentication was established; no credentials were entered.

Deployment source checkpoint is `8babfffe3`. The
[seed-options framework/native pair](seed-account-options-pair-2026-10-30.md),
[signed fixture runner](seed-account-options-fixture-run.md),
[companion controller](maps-companion-controller-2026-10-30.md), and
[media profile](maps-seed-account-companion-stage.md) retain exact sources,
qualified binaries and complete producer evidence. The runtime combines the
unseeded UserManager API/immutable empty-bundle repair with admitted GMS/Vending
catalog installation; this run does not isolate the effect of either change.
Subsequent persistent-data class and native null-guard fixes were not deployed.

Paths below are relative to `/Users/alex/.local/state/vinix/android` (`S`):

- Prepared image: `maps-seed-account-companion-r1`; controls:
  `maps-seed-account-companion-prepare-2026-10-30-r1`.
- Stopped guest: `maps-seed-account-companion-vm-r1` (`VM`).
- Runtime controls/imports: `maps-seed-account-companion-runtime-audit-2026-10-30-r1` (`A`).
- Transfer: `seed-account-options-api-transfer-live-2026-10-30-r1`.

Preparation passed complete input audits, ten-file overlay installation, module
readback and final full input rechecking in 178.878 seconds, with 86,409,216 bytes
sampled aggregate RSS. Original 600 MiB RSS/900-second/4 GiB growth/1 GiB reserve
caps and the internal 512 MiB write budget remained enforced. Fresh cloning and
frozen-kernel installation passed. One owned four-CPU, 12 GiB guest ran with both
root terminals created before fixture and broker use.

| Input | SHA-256 |
| --- | --- |
| Prepared `sha256.json` | `67be52229ca728113d7819f6020ba928a26745f7ce59f7ab458cabfe88d30137` |
| Framework JAR | `cb2e3fabab652c65351da16770ae98c4113781df0830440b734395bb35b6f265` |
| Native DSO | `179f51ad25cc99fd939ca1f217e87f1d3ab9c452b98db861da11e0344363f6ce` |
| Signed seed fixture APK | `36c87d606306c799f50771ab0bed5cacdf07603e96f3e85b6c4aab4870f1f333` |
| Exported fixture receipt | `50770fb84e9b88ba020523d73bf02c4994247b8d732b8d1ca810eacc93bf5eeb` |

The first fixture invocation used `/tmp` paths and was refused by the existing
protected-parent check before ART started. Its original evidence is retained;
it is not counted as a guest execution. Verified inputs were copied to root-owned
mode-0755 `/opt/seed-options-input`, and a fresh `/opt/seed-options-result` passed
as UID/GID 10123, child PID 54302, `wait_status=0`. The receipt has all six exact
input pins, eleven checks, one PASS and one native readiness marker. The unchanged
zero-removal diagnostic collectors verified the receipt and matching child-log
hash; no strict SERVICE-QUERY import is claimed. The runtime mount was released
before broker startup. `A/fixture-validation.md` preserves the full review.

The controller's public receipt verifies both regular companion APK copies in
Maps' catalog, exact source/copy hashes, SDK29 signer, ownership/modes, and all
native library hashes: 40 GMS libraries and nine Vending libraries. Private GUI
checks independently show mode-0400 APKs owned by Maps UID 10012 and mode-0700
library directories. Protected source APKs remained single-link.

Saved genuine captures establish the manual workflow:

| Interaction | Actual rendered result |
| --- | --- |
| Onboarding Skip | Labeled North America map tiles. |
| Oasis d'Aboukir search | Paris address, street/building map, rating and real photos. |
| Palais-Royal → Oasis d'Aboukir | Six-minute route over the labeled base map. |
| Preview | `Head toward Rue Thérèse` with map and route. |
| Next | Right turn to Rue Saint-Augustin in 400 m with matching map/route. |

The images are `VM/seed-map-after-skip-01.png`, `seed-place-photos-01.png`,
`seed-route-loaded-01.png`, `seed-route-preview-01.png` and `seed-route-next-01.png`.
This validates anonymous map/search/photo/route operation on this deployment.
GPS, live navigation, voice and authentication were not established.

Sign in → Add account then stops the app. The private capture
`VM/seed-account-original-private-01.png` shows primary `NoClassDefFoundError`
for `android.service.persistentdata.PersistentDataBlockManager`, from the D8 cast
helper through `akas.g` and `FrpChimeraService.onCreate`. It subsequently shows
pause/stop teardown and ART's secondary fatal JNI error: `Activity.getWindow()`
called on a null object from `View.native_getWindow(long)`. The companion
`seed-account-cause-private-01.png` retains `ANDROID-SERVICE-EXIT phase=6 reason=1 status=1`
and the abort. These are separate primary Java and secondary native failures.

The controller receipt remains failed, readiness true, broker exit 1 and
`broker_drain={status:1,bytes:162523,error_number:0,eof:true}`. EOF establishes
complete bounded pipe capture, not account success. Two cleanup survivors are
recorded without determining whether they were running or zombies. No raw
selected-child wait marker is claimed on this path.

The complete public UART export passed the unchanged strict collector: 24 entries,
2,836 chunks, 1,451,538 bytes, archive SHA-256
`d4e88f6493f8d11ca562d9df9f14c6778d16994f49abe6c8246c995bee59af35`.
Its exact interval is
`2c5a2bfdf864e1f2f43d89b58c3108127588a34c9676c2f20a00d5c81bda7cf4`.
After-Maps receipt `a0199866bdfdddc51a30ac4f6f09475547b5b880f0c9e5c51eee5c83527568f2`
links to before-Maps receipt
`d27e76e2f3a23e872980290b101faea7f12bc8cc8ee2acc96d2e2b7ccf53aa07`.
Private raw logs remain excluded except for hashes. Later bounded read-only GUI
log commands can add OS diagnostics to UART; the final whole UART is not claimed
to equal the earlier snapshot. The owned runner sent SIGTERM at 14:58:46 UTC;
unchanged reconciliation recorded PID 42599 absent at 14:58:53 after a transient
identity mismatch, without another signal or ownership bypass.

All nine preparation/control/runtime/audit/transfer/clone roots are closed to
writes. The unchanged generic sealer and separate fresh-process full readback
passed for 666 entries:
`S/maps-seed-account-companion-runtime-sealed-2026-10-30-r1/sealed/manifest.json`,
SHA-256 `0d72b4a8ac0bfc654dea2b10c47361c06ecfae70efbb809f55c5f1f169c3283a`.
Seal/readback took 7.617/3.580 seconds, sampled 24,035,328/13,434,880 bytes RSS,
and both exited zero with complete cleanup and zero swaps. Limits remained
600 MiB RSS/900-second/64 MiB shared-growth/1 GiB reserve. No seal attempt failed
or checker changed. Retain the complete original bundles and historical auditors.
