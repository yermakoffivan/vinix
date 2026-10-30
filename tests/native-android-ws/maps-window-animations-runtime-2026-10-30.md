# Window attributes ARM runtime and Maps avatar retry, 2026-10-30

The Window regression passes on ARM, and the fresh runtime renders real map
tiles, Paris streets, place details and photos. Clicking the avatar now exits
Maps with missing `Layout.getAlignment()Landroid/text/Layout$Alignment;` during
Litho/Yoga measurement. The earlier Window linkage failure is absent from this
successor stack. No account menu or authentication success is established;
routes, GPS and navigation remain unverified.

The deployed [Window feature](window-animations-host-2026-10-30.md) is
`e0316391f`, the [framework/native pair](window-animations-pair-2026-10-30.md)
`a176ade21`, fixture runner `6b5712df0` and media profile `52594dd5e`. It adds
five Java methods for resource-ID attribute storage and callback dispatch;
visual animation execution is not claimed. JNI, generated C, native sources and
exports remain equal. The actual new DSO differs through embedded header paths;
the pinned prefix-map relink recreates the complete predecessor binary.
Google APKs, network state and account identity were not changed for this fix.

All original artifacts remain under `/Users/alex/.local/state/vinix/android`
(`S`): prepared `maps-window-animations-r1` (`P`), controls
`maps-window-animations-prepare-2026-10-30-r1`, stopped guest
`maps-window-animations-vm-r1` (`VM`), audit
`maps-window-animations-runtime-audit-2026-10-30-r1` (`A`) and transfer
`window-animations-api-transfer-live-2026-10-30-r1`.

| Input | SHA-256 |
| --- | --- |
| Prepared `sha256.json` | `054ecabdaf7bf238b254e51cefd9c9f68c027b5255d425a3b595b07f99d0017a` |
| Framework JAR | `255718e8a943f8d3e276f99694c52ed5ec39af86d5d06abef3c9b14d7b9aa197` |
| Actual native DSO | `a1f27a68285dfe6d5cef34ad077bde7537ee41c136fd40d82ad42e14097377ba` |
| Original Maps APK | `6218d72f48b184eb71f68879bce48cb9ebb2b510be7f7cff88217ea3fd592bb2` |
| Signed fixture APK | `b78a43516d2f5f42ec7686c39acd81b3612402d80eb25ccd854de512fd6119a6` |
| Exported fixture receipt | `b5ebebf2c711d435bb5f057824b5faa38eea8b8b35061b9f83b629f174a95e01` |
| Final controller receipt | `72dd46ea036f8d5c5fbb6d67ada6fc714f45a035e146560af598d1d3cff60333` |

Preparation, fresh clone and frozen-kernel installation/readback passed in
236.305/10.210/64.825 seconds, sampled RSS
87,425,024/36,257,792/45,187,072 bytes. Original 600 MiB RSS/900-second/1 GiB
reserve caps remained enforced, with 4 GiB preparation and 2 GiB clone/kernel
observed-growth caps. Fresh owned QEMU PID 3684 used 12 GiB/four CPUs. Both root
terminals were opened before tests. An initial snapshot command refused a log
inside its generated root before dispatch; the corrected child-root invocation
passed with unchanged limits. Original refusal evidence remains retained.

The [signed fixture](window-animations-fixture-run.md) ran once as dedicated
UID/GID 10129, `winanim-check`, with one protected ro/nosuid/nodev/wxallowed
runtime attachment; actual relatime flags were retained. Child PID 40404 exited
cleanly. Six input pins, eleven checks and one PASS/READY pair were verified.
The unchanged diagnostic SERVICE-QUERY importer used a zero-removal plan;
no byte repair or unsupported strict fixture import is claimed. See
`A/fixture-validation.md` for original snapshots, receipt and child-log hashes.

The standalone ARM assertions cover defaults/set/reset/negative/repeated IDs,
the exact attributes alias, mutation before callback, unrelated attributes,
null/replaced callbacks, protected virtual dispatch, reentrancy, exact thrown
exception identity/recovery, unattached and attached Activity behavior, and
real Dialog pre-show/show/hide with recording WindowManager. The fixture mount
was released and its absence verified before starting the broker.

After broker readiness, Maps opened through its real desktop launcher. Skip
was used before testing the avatar. `VM/window-map-01.png` shows labeled
North America tiles;
`window-place-photos-01.png` shows detailed Paris streets and Oasis d'Aboukir
rating/details/photos. These captures revalidate current anonymous imagery,
search and details. Later clicking the avatar exited Maps before any controlled
stop. Private `window-avatar-error-private-01.png` and
`window-avatar-stack-private-01.png` show the missing Layout accessor inside
Litho/Yoga measurement. Maps `lga.a` source 505 wraps the failure; it is not
identified as the getter's direct caller. Static caller investigation is
separate. The [bounded Window caller audit](maps-avatar-caller-audit-2026-10-30.md)
does not prove all later avatar content or lifecycle paths.

The explicit protected stop was entered at 19:51:30 UTC, before the 15-minute
bound. Controller receipt start is 19:45:26, finish 19:51:34, status
`user-stopped-no-authentication-claim`, readiness true and empty error. Broker
exit 137 follows controlled cleanup; one survivor has unknown running/zombie
state. No clean broker exit or selected raw child wait event is claimed. Drain
records EOF true, status 1, 107,514 bytes and error number zero. Owned QEMU
received SIGTERM at 19:51:57; initial disappearance recording was refused,
then unchanged reconciliation confirmed PID 3684 absent at 19:52:10 without
a second signal.

Complete strict account import passed: 25 entries, 2,835 chunks and 1,451,198
archive bytes, SHA-256
`745a3a1a030fbe6339eb44667f0926268f315c9f537ea726290ac8990619983c`.
No reconstruction/removal was used. The exact 2,252,286-byte UART interval is
`278943158cafe7b4d84daba9583fd5c858bccb073d8135661ede175f2578a0c4`;
its linked snapshot receipts and import metadata agree. Raw application logs
remain excluded from public UART except hashes and bounded private captures.

All nine original roots, including the four adjacent VM clone sidecars, are
closed. Complete sealing and a separate fresh-process full readback passed:
607 entries, `S/maps-window-animations-runtime-sealed-2026-10-30-r1/sealed/manifest.json`,
SHA-256 `66602b1386d037160054d4fa6412783870df6f6d66e8774f1096cd98ac66b4ae`.
Seal/readback took 8.213/3.252 seconds, sampled RSS 27,197,440/13,172,736
bytes. Both guard/child exits were zero with complete cleanup and zero swaps
under unchanged 600 MiB RSS/900-second/64 MiB shared-growth/1 GiB-reserve caps.
The unchanged qualified sealer needed no compiler. No sealing attempt failed.
Retain all original bundles and historical checkers, including failed/refused
attempts; earlier closed roots remain unchanged.
