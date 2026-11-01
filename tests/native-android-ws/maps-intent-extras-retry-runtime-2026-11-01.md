# Intent extras ARM pass, real Maps content and readable account error

The corrected signed Intent extras fixture passes on ARM. Maps renders real
tiles, finds Paris places and photos, and opens its profile menu. Sign in now
shows the Google error title and body: “Something went wrong”, a problem
communicating with Google servers, and “Try again later.” The Intent merge fix
restores that previously missing content. The underlying preflight/communication
failure remains unresolved; no credentials were supplied and Google
authentication is unverified. GPS, routes and navigation were not exercised.

Provider `9229c490d` and the [admitted SDK/native pair](intent-extras-pair-2026-11-01.md)
are unchanged from the [first runtime attempt](maps-intent-extras-runtime-2026-11-01.md).
That original fixture failed on a constructor-null assumption, and Maps then
failed natively after Skip. Those failed artifacts remain complete and sealed.
Fixture fix `d5d39a16a` explicitly prepares absent extras with the unchanged
`replaceExtras((Bundle)null)` API and asserts the null before testing it. All
original behavioral assertions and the marker remain. Refreshed tools
`909bfc749` change only fixture/input pins and preserve strict health checks.
No image, framework, native library, Google APK or validation policy changed for
this retry. A later native asset-lifetime fix is absent from this run.

Artifacts remain under `/Users/alex/.local/state/vinix/android` (`S`):

- Controls `maps-intent-extras-retry-controls-2026-11-01-r1` (`E`).
- Stopped guest `maps-intent-extras-vm-r2` (`VM`).
- Audit `maps-intent-extras-runtime-audit-2026-11-01-r2` (`A`).
- Transfer `intent-extras-api-transfer-live-2026-11-01-r2` (`T`).
- Corrected fixture and controls `intent-extras-fixture-2026-11-01-r2` and
  `intent-extras-fixture-controls-2026-11-01-r2`.

| Input or result | SHA-256 |
| --- | --- |
| Unchanged prepared `maps-intent-extras-r2/sha256.json` | `0a06846c3bc25825ba7b1b6508078523a4a0de789450a7ae57b52ae64b3fcd8e` |
| Framework JAR | `02aefc8136cb87eb8e9ebd0928cb15f3e1c2042e47d2a687170a0f9309ac4b20` |
| Retained native DSO | `280730c4166687394cf69e548cdd106e58c57ba9472f339dde2c80ebdee2595a` |
| Corrected signed fixture APK | `b3e0278a185bb3f7f1a302c2f515fa7a4b98edf4cfcefd69ede3f45f85a5ba2c` |
| Refreshed ARM runner | `cad7bf5ff030b01af3bcf9a7cfc4b0bd41d3b54d93a7a864bc19daade444cc12` |
| Exported fixture receipt | `edbf652115c3840054ce7a47b91234f630fda435caf6f40fe5abafe0090ad4c4` |
| Controller receipt | `cf9e5c27b1dc5b12ebeae07785b8cc08f9f47c9b471c6f5214ac9c5f40c57418` |

Fresh clone and frozen-kernel installation/readback passed in 12.731/76.287
seconds at sampled aggregate RSS 32,964,608/43,368,448 bytes, both exits zero and
host cleanup complete under unchanged 600 MiB/900-second/2 GiB-growth/1 GiB-reserve/
file-size caps. Exclusive owned VM89628 used 12 GiB/four CPUs and user-default
networking from 04:51:06 to 05:02:26 UTC. The initial wrong runner download route
returned 404 and is retained; the correct two routes delivered exact input pins.

The standalone fixture used dedicated UID/GID10136 and protected root-owned
inputs/runtime mount. Child15007 exited cleanly at 04:53:19.760 UTC. All six
actual input pins and eleven required receipt checks pass, including live input
until PASS/READY, descriptor closure, EOF drain and unchanged inputs. Cases cover
both overloads, incoming precedence, receiver identity, source/destination map
isolation, shallow nested values, empty/no-op/null paths and controlled Intent
transfers retaining title/body through copies and Parcelable nesting.

The unchanged zero-removal diagnostic SERVICE-QUERY import passed 31 chunks and
15,426 archive bytes, SHA-256
`ecd6bf03438f4b498799a75d495c690cd182dc0b6bfbca5c750990300519925b`.
The complete 9,491-byte/108-line child log has SHA-256
`74ecc0d985afa3ca67a4d0506b5cb2b13cdee144537c9c775eed5973af0e5ddd`,
with one full Intent PASS91, READY102 and onDestroy/final LF108; no failure or
competing marker occurs. No payload repair or health-check relaxation occurred.
This is diagnostic fixture import, not strict fixture-protocol qualification.
One malformed 65-character extractor pin was refused before output creation;
that control remains and a fresh extraction with the exact 64-character pin
passed. Detailed validation and independent review remain at
`A/fixture-validation.md`, SHA-256
`5082daa976998a6966c648fcd2eba0d0282596350ddefb8025e2ec324dbc635e`.

After fixture mount release, `VM/intent-retry-maps-after-skip.png` at 04:59:02
shows real North America tiles. Search suggestions at 04:59:44 and
`intent-retry-paris-photos.png` at 05:00:16 show Oasis d'Aboukir street tiles,
4.6 stars/98 ratings and place photos. `intent-retry-profile.png` at 05:00:40
shows the working profile menu. Sign in at 05:00:46 opens the readable Google
error page at 05:01:00, retained as `intent-retry-account-chooser.png`; despite
that filename, the image shows an error page. No Next or credentials were used.

Bounded private capture records AccountIntroActivity/ChimeraActivity,
WrapperControlledActivity/ChimeraActivity, PreAddAccountActivity/ChimeraActivity,
then ErrorActivity/ErrorChimeraActivity. The selected exact no-network message
and BrowserSignIn counts are zero in that finite capture. These observations
establish neither network health nor successful authentication.

Actual controller receipt runs 04:54:16–05:01:57, status
`user-stopped-no-authentication-claim`, readiness true and empty error. Stop was
requested at 05:01:54 within the 15-minute bound. Broker19550 exit137 followed
controlled cleanup; no clean exit is claimed. Drain EOF is true, status1,
182,541 bytes and error number0. Two cleanup survivors' running/zombie states
are unknown. Readiness and handoff records establish no authentication.

The unchanged strict account collector passed 25 entries/2,836 chunks/
1,451,733 archive bytes, SHA-256
`03f4836dbd277a45b2decafe4a7a90e9c634c0c496e8eeef34f60759d80617e9`.
The exact 2,254,778-byte interval is
`225a8cbc1e281ff16281433fa040b1126a5dac0c25ce233264080361482e4ad8`.
Linked snapshots agree and the stopped final UART matches its full snapshot.
Import took 321 ms at sampled RSS 29,425,664 bytes with zero exits and host cleanup
complete under original 600 MiB/300-second/64 MiB-growth/1 GiB-reserve/file-size caps.
Private raw app/broker logs remain excluded except hashes and bounded captures.
Owned VM89628 received one SIGTERM at 05:02:26; stop returned zero and absence
was verified. Export integrity establishes no authentication.

All ten new roots, including the corrected fixture/control roots and four VM
clone sidecars, are closed to writes. Final `A/operator-notes.md` SHA-256 is
`4dde27bddc99aa2023c63cb9a9d86d05491dae46b7552a335ee04382169b2ab8`.
One coordinated seal and separate fresh-process full readback passed for all
ten roots and 593 typed entries. Manifest
`S/maps-intent-extras-runtime-sealed-2026-11-01-r2/sealed/manifest.json` has
SHA-256 `90fdb87ba03e7c8245a2b6fab463a3639ad752a6011adccb31fcb581b99ace21`.
Seal/readback took 5.100/2.119 seconds at sampled aggregate RSS
14,598,144/14,172,160 bytes and observed shared growth 16,039,936/1,523,712 bytes.
Both guard/child exits were zero, cleanup complete and process swaps zero under
the unchanged qualified sealer and original 600 MiB/900-second/64 MiB-growth/
1 GiB-reserve/file-size caps. No attempt in this runtime seal root failed.
The earlier failed fixture and first runtime, prepared parent, SDK/native
producer/source audit and tool qualification retain their separate complete
sealed bundles. Keep all originals and unchanged auditors.
