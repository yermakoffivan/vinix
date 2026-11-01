# Intent extras SDK and retained native pair

Provider `9229c490d` changes only the two existing `Intent.putExtras` overloads.
Both merge incoming keys instead of replacing the destination map. The Bundle
overload creates an empty destination when needed; the Intent overload ignores
absent source extras and copies a populated source for an empty destination.
Incoming duplicate keys win, top-level maps remain isolated, and Android 10 null
behavior is preserved. Fields, native declarations and other Intent APIs remain
unchanged. The [source/caller report](intent-extras-framework-2026-11-01.md)
records the exact GMS preflight-to-error handoff and focused 2,108-class checks.

Qualified producer `a8b257e84` adds the narrow `--intent-extras` profile over the
complete Dialog SDK, manifest
`a3547ad6477b3fb2eb7a9bcd7d73b8870c89a6bf69c4a84db03dc79e3222859f`.
It permits exactly two changed bodies in one existing class, no added members
or classes, and preserves all 2,108 classes, neighboring methods/fields and
non-DEX JAR payloads. An independent literal instruction oracle runs before
assembly and after the complete DEX roundtrip. It rebases only branch labels
to instruction positions, including equivalent aliases, while rejecting changed
targets and duplicate or undefined labels. Historical profiles remain intact.
Independent read-only producer review passed without findings.

| Qualified operation | Seconds | Sampled aggregate RSS bytes |
| --- | ---: | ---: |
| Producer compile | 2.916 | 364,855,296 |
| Complete producer self-tests | 0.356 | 15,450,112 |
| Complete SDK production, r2 | 68.592 | 515,997,696 |

Every qualified guard and child exited zero with complete cleanup under unchanged
600 MiB RSS, 300-second, 1 GiB reserve, 4 MiB output and file-size caps. Tool
qualification retained its 512 MiB shared-growth cap; SDK production retained
1 GiB and observed 838,070,272 bytes of growth. The initial SDK r1 is rejected
and preserved: its unchanged guard stopped on 1,085,411,328 bytes of observed
shared-volume growth after 30.487 seconds, sampled RSS 93,978,624 bytes, exits
125/137 and complete cleanup. It emitted no admitted SDK manifest or success
result. Its guard SHA-256 is
`de9068c68136399a5637d4ebc499513253faef84ea822d92758378340ee59b62`.
The independent signed fixture was qualified before the fresh r2 retry; no
source, compiler, policy or resource limit changed for that retry.

Artifacts remain beneath `S=/Users/alex/.local/state/vinix/android`:

| Artifact | SHA-256 |
| --- | --- |
| `combined-account-webview-intent-extras-framework-2026-11-01-r2/sha256.json` | `bef486d060754858d51612b9c4bb8a24f7c2fdf8f37cc3565101e24a049bf52f` |
| Framework `build.json` | `ef32f636c84f1069019a7ca1a841282e5905d586b953e8c193345663ef26a919` |
| Framework JAR | `02aefc8136cb87eb8e9ebd0928cb15f3e1c2042e47d2a687170a0f9309ac4b20` |
| Framework DEX | `339ced728be216f45470f8435b65e23cc8ae7aafd8c4f11a86d35c9eb0ef1245` |
| Changed raw Intent class | `f3db222897beb3e6dd99bb2da605a5ee34cc2172bbdfc79019c4d82659d50de9` |
| Changed canonical Intent class | `6400c9934837225aceef5285b5732d4ca09219f5c0c4692b2870f91b922de380` |
| Retained native manifest | `a293cfedb3fa2c7775af0cd15330b559ca4850c9ae7496e7e16717d520e2b0a4` |
| Retained native DSO | `280730c4166687394cf69e548cdd106e58c57ba9472f339dde2c80ebdee2595a` |

Intent and Bundle are absent from the retained native build's 69-class input
set, so no native rebuild or relink is performed. That native root remains
`current-native-build-2026-11-01-dialog-theme-r1`, coupled to its own Dialog SDK.
The actual complete media audit passed all 2,108 classes and all 69 consumed
canonical classes, with exactly one raw formatting pair: Dialog
`66a711e288271a52f5fe9d44b4fca75738ee882f60f869d12030c4ba3f8290f1`
to `fb1951defc731f6f52b907aaa81fd94272662e9a7348d1b2dbf6caee32a59042`.
Native sources, JNI, generated C and 719 exports remain exact. The guarded audit
took 4.166 seconds at sampled RSS 52,101,120 bytes, with exits zero and complete
cleanup under original 600 MiB/900-second/512 MiB-growth/1 GiB-reserve limits.
Its receipts are `S/maps-intent-extras-tools-2026-11-01-r1/framework-audit.*`.

One joint seal and a separate fresh-process full readback passed for twelve
closed producer, source/caller, fixture and retained-native roots: 27,732 typed
entries. Both failed attempts remain complete: the r1 source check's equivalent
branch-label oracle rejection and the r1 SDK shared-growth rejection. The exact
root list is `S/intent-extras-producers-sealed-2026-11-01-r1/roots.txt`;
`sealed/manifest.json` SHA-256 is
`52f29f274c80693528e5bf628389e99bf7180c2b5cb5e324c0072f16d628dccb`.
Seal/readback took 9.478/3.114 seconds at sampled RSS 28,147,712/24,035,328 bytes
and observed shared growth 39,972,864/13,135,872 bytes. Guard/child exits were zero
with complete cleanup under unchanged 600 MiB/900-second/64 MiB-growth/1 GiB-reserve
and file-size caps. No attempt in this seal root failed. Retain all complete
predecessor and failed-control bundles required by the unchanged auditors.

Complete producer evidence is preserved in `S/intent-extras-framework-builder-2026-11-01-r1`,
both `S/intent-extras-framework-production-2026-11-01-r1` and `-r2`, and both
failed/qualified SDK roots. The signed fixture's host result is separate evidence.
ARM behavior and live account-content validation remain unverified; no login
success is claimed.
