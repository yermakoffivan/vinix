# Window system UI field ARM/runtime checkpoint, 2026-10-30

The signed Window field regression passed on ARM. Maps rendered onboarding and
opened its Add account chooser and a black Google account window, then showed
the compositor's stopped/exited message. The inspected private output contains
no new terminal Java error and does not identify the cause. Google login,
authentication and map imagery on this pair remain unverified; no credentials
were supplied.

Recorded source baseline is `7cf2a44e2`. The exact
[field provider and host checks](window-system-ui-host-2026-10-30.md),
[framework/native producers](window-system-ui-producers-2026-10-30.md),
[fixture runner](window-system-ui-fixture-run.md), and
[media profile](maps-window-system-ui-stage.md) retain their frozen sources and
complete qualification evidence. Later diagnostic-source edits were not used
by this deployed pair.

Paths below are relative to `/Users/alex/.local/state/vinix/android` (`S`):

- Prepared image: `maps-window-system-ui-r1`; controls:
  `maps-window-system-ui-prepare-2026-10-30-r1`.
- Stopped guest: `maps-window-system-ui-vm-r1` (`VM`).
- Runtime controls/imports: `maps-window-system-ui-runtime-audit-2026-10-30-r1` (`A`).
- Transfer: `window-system-ui-api-transfer-live-2026-10-30-r1`.

Preparation passed in 184.355 seconds with 90,177,536 bytes sampled aggregate RSS,
unchanged 600 MiB RSS/900-second/4 GiB observed-growth/1 GiB-reserve caps, and
complete cleanup. Fresh cloning and frozen-kernel installation also passed.
Both root terminals were created before fixture and broker use.

| Artifact | SHA-256 |
| --- | --- |
| Prepared `sha256.json` | `14f92ed74d29a14a27d0c829c2f84d7695a697c730811d594b010b906c7be1f1` |
| Framework JAR | `3f0d220a24e7d91a47f7b2d42cd5620aa498981e915a90cdbd806164b8ef0fc1` |
| Native DSO | `c97862ecb4eba730290a832b2766d58c1552ddf58ae40f77d7e140e69538ce75` |
| Signed fixture APK | `af7f9bfcb8f106c43f9d86badfa2c5e0deb49e3a1e6da19cbe68ab6a5254ca90` |
| Exported fixture receipt | `c7ccbcbdb1d6aaafc09db4e2c8f61a1b1cda8489e5633c0b74874022c2a39381` |
| Decoded fixture child log | `31870f8b672ffe8d0c1b47d7c9f9f99a51974cc254cb02b70cc0806cd3274ffc` |

The standalone fixture ran as UID/GID 10121 with `wait_status=0`, exact six input
pins and all eleven runner checks. Its child log has one exact PASS marker and
one native readiness record. It verifies the zero field default in both
constructors, a writable public instance integer, signed values/bitmasks, isolation and
Window attribute values. It establishes no compositor effect. The unchanged
no-removal planner, diagnostic reconstructor and child extractor passed; this
is diagnostic collection, not a strict SERVICE-QUERY import. The fixture mount
was released before broker startup. Full details are in `A/fixture-validation.md`.

The complete public Maps export passed the unchanged strict collector: 24 entries,
2,818 chunks, archive SHA-256
`48ce2ea39212c5efb72081ad96bf823350c5591dc358fed29f834d6d2c782b37`.
The exact 2,236,598-byte interval is
`6e051ccbed28d1c6d44405de2b7fb6b4eead50d09ad9b2c4646be0498bdfaed3`;
after-Maps receipt `fa5801a20a6816e3b4bf740d3bf03e347e89f136308214bffe3ef1faf63de2db`
links to before-Maps receipt
`3c938b6072edca8d35ff193eec5b2dbb7b3ed90f98d4b2f1402aa72870982486`.
Its controller receipt reports `service_ready=true`, `status=failed`,
`broker_exit=1` and two cleanup survivors. That broker exit is not the native
authenticator child's raw wait status; the deployed broker discarded that status.

Private GUI evidence shows a 133,747-byte `broker.log` ending during setup
status-bar layout inflation. The earlier `systemUiVisibility` failure and final
service/VM/uncaught exit markers were absent from the inspected prefix. Neither
the last line nor those absences establishes where execution stopped. The
deployed controller source and retained generated C read one at-most-4096-byte
block per loop, then return when the broker is dead without draining queued
pipe data. This is a proven capture defect; it does not prove that a particular
message was lost. The complete public archive excludes private raw logs and
does not establish complete private-log capture. No causal StatusBar framework
gap is claimed from this run. `A/operator-notes.md` records these limits.

The whole guest was stopped after export. The owned runner recorded SIGTERM at
12:33:35 UTC; unchanged reconciliation recorded absence at 12:33:43 after an
initial transient ownership mismatch. No second signal was sent or ownership
check bypassed.

All twelve roots were closed to writes: preparation and controls, VM, runtime
audit, transfer, four original clone sidecars and three original host-check and
fixture roots. The failed first host fixture attempt remains intact. The
unchanged generic sealer and separate fresh-process full readback passed for
669 entries at
`S/maps-window-system-ui-runtime-sealed-2026-10-30-r1/sealed-retry1/manifest.json`,
SHA-256 `10d558149aef7b7f3a0c7bb45286dba3a48c3a54e42b596eec06f56c57720377`.
Seal/readback took 6.156/3.239 seconds, sampled 15,646,720/23,937,024 bytes RSS,
and both exited zero with complete cleanup and zero swaps under unchanged
600 MiB RSS/900-second/64 MiB shared-growth/1 GiB-reserve caps. The first seal
attempt hit the same growth cap at 99,471,360 bytes after 6.565 seconds; its
failed controls and incomplete output remain preserved. No historical checker
was changed. Retain all original complete bundles and auditors.
