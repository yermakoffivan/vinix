# Maps broker tail diagnostic media

`maps-broker-tail-stage.v` and the additive `patch-kernel --maps-broker-tail`
profile qualify the controller EOF drain and private numeric child-status
diagnostics over the sealed WindowManager system UI image. The overlay has four
files: controller, its desktop launcher alias, broker, and deployment receipt.
Only the three executable hashes in `inputs_sha256` change. Framework, native
ART, browser, headless receipts, other deployment fields, inode modes, and all
29 inherited modules remain pinned. The diagnostic overlay becomes module 30.
Both full dependency audit phases retain the existing two-worker bound. All 62
inherited complete inventories plus the base and two producers give exactly 65
dependency seals.

Artifacts are outside Git under `/Users/alex/.local/state/vinix/android` (`S`):

| Artifact | SHA-256 |
| --- | --- |
| Base `maps-window-system-ui-r1/sha256.json` | `14f92ed74d29a14a27d0c829c2f84d7695a697c730811d594b010b906c7be1f1` |
| Controller `maps-account-guest-build-2026-10-30-tail-drain-r4/sha256.json` | `cd14f050b8f3dfd96728605826d324d1ec7b291f96effbe58711759ff254324f` |
| Controller executable | `bf30d23fb34a382b517688df073fb54b0c140bdedd51afb5444c3f96e870bdbe` |
| Broker `current-account-broker-build-2026-10-30-child-status-r1/sha256.json` | `7bba04e39681e31c6e13dbd65df99094dadec17a1ab99e114e50f74aa2d18ae9` |
| Broker executable | `0bf4d36c6c4035eb7e736ee04f3f7a612b9582ef44bad6950bf0aa8b1b1c35ee` |
| Stager source | `fe99b69908338437b01ed25b40153cd00262cdb22aeb27404ef180fb189bacc1` |
| Patcher source | `fc9a71498122216d41b4d9b02960067c362aa90c26ad1ee042e78b9e92d3cd68` |
| Qualified stager executable | `e43adfd06900cf2e4131e630e74fd0ee19bfdf1bf32ee6a8640c95f389f5728f` |
| Qualified patcher executable | `8fe841e75cb8d9be7b51cfbe159f2b0e83e54bcdd57f3fa59f7c9bcf341a6b3c` |

The broker retains its original framework dependency
`8907c1f11d8886b47358b458a8026d8351c6feac44d78346d6d426208b8ffe15`.
The deployed WindowManager framework and native ART manifests remain
`1e24a8dcc2f5b315ebbb63cb06d3de46e0799b4b1a0d19339d3b98ecab0c3b09`
and `b564d361fd1fc0271cba1967c84ac6b3ca32607b832bd6114c6943be777e2872`.

Qualification root `S/maps-broker-tail-tools-2026-10-30-r1` (`Q`) contains frozen
source, inherited compiler/C inputs, serial generated C projects, emitted
Makefiles, command logs, guard receipts, SDK/tool identities and a fresh
425-input compiler/C/header capture. Its source base revision is
`cf1277141bbb52c6cf327c9ec2e978ae1b83d9a8`. The capture is post-build provenance;
it does not claim a hermetic host SDK or every system library.

Both serial V generations, emitted C compilations, stager self-tests, complete
historical and new patcher self-tests, and the actual producer audit passed.
The latter rechecks complete inventories, static ARM outputs, broker compiler,
header, static-zlib and link contracts against the retained framework. All
completed recorded guards exited zero with cleanup complete. Build/test limits
remained 600 MiB aggregate RSS, 300 seconds, 512 MiB observed shared-volume growth and a 1 GiB
reserve. The largest sampled aggregate RSS was 365,412,352 bytes; the largest
`time -l` RSS was 379,731,968 bytes. Every time report recorded zero swaps.

Initial snapshot guard arguments placed logs inside the declared generated
root and were rejected before execution. No child, source/project subtree, log
or receipt was created by those rejected invocations; two dependent copies
then failed because the source directory was absent. Corrected snapshot
commands passed. `Q/qualification-notes.txt` preserves these initial outcomes.
The [producer report](maps-broker-tail-producers-2026-10-30.md) retains the
failed controller builds and final serial-builder provenance.

The closed qualification root is sealed at
`S/maps-broker-tail-tools-sealed-2026-10-30-r1/sealed/manifest.json`, SHA-256
`05824d92021a1697ee97fb3369af3520b4217dfb0be10df176d717556ce50265`.
Inline and separate full readbacks passed: one root, 1,123 entries, original
600 MiB RSS, 900-second, 64 MiB growth and 1 GiB reserve limits. The six producer
roots are separately bound by
`S/maps-broker-tail-producers-sealed-2026-10-30-r2/manifest.json`, SHA-256
`dc28fc5253e445466c63767ec962cd635e325759a3a18475fd0681b3d2da3ecd`.

Qualified commands are `Q/stager-project/maps-broker-tail-stage --prepare
S/maps-broker-tail-r1` and, after a fresh clone,
`Q/patcher-project/patch-kernel --maps-broker-tail FRESH_STAGE
FROZEN_KERNEL_BUILD BUILD_JSON_SHA256`. Preparation retains its original
600 MiB RSS, 900-second, 4 GiB growth and 1 GiB reserve outer guards, and its
internal 512 MiB write budget. This qualification establishes host media
tooling; live Maps behavior and Google
login require the successor ARM run.
