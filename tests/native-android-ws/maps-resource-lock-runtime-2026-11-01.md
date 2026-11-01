# First resource synchronization ARM attempt

The signed r3 resource fixture failed on its XML event assumption: it expects 2
from the first parser.next(), but the unchanged parser returns START_DOCUMENT 0
first. Both reader workers stop there; the other workers subsequently report
barrier failures. This run establishes neither successful resource stress nor
the cause of the earlier Maps crash. No broker or controlled Maps run was
started. The [successful Intent Maps baseline](maps-intent-extras-retry-runtime-2026-11-01.md)
remains separate, with Google authentication still unverified.

Native fixes `a5310a98f` and `fea4b7a85` serialize resource-manager/theme access
and preserve the established pointer casts. The [source checks](resource-locking-source-2026-11-01.md),
[native pair](resource-lock-native-pair-2026-11-01.md),
[signed fixture](resource-lock-fixture-2026-11-01.md) `f1938cfdb`,
[runner](resource-locks-fixture-run.md) `461395dd3` and
[media qualification](maps-resource-lock-stage.md) `cc5f16b30` retain complete
host evidence. The Intent Java SDK remains unchanged. The native audit preserves
2,108 classes/69 canonical equalities, exact three V/ten binding changes,
JNI signatures, headers and all 719 exports. Host contention and artifact checks
do not establish ARM stress or Maps crash causation.

Artifacts remain under `/Users/alex/.local/state/vinix/android` (`S`): prepared
`maps-resource-lock-r1` (`P`), `maps-resource-lock-prepare-2026-11-01-r1` (`E`),
stopped `maps-resource-lock-vm-r1` (`VM`),
`maps-resource-lock-runtime-audit-2026-11-01-r1` (`A`) and
`resource-locks-api-transfer-live-2026-11-01-r1` (`T`).

| Input or result | SHA-256 |
| --- | --- |
| Prepared P `sha256.json` | `d4dcdfa033e7e0fa21a634cae6087e95deedbbee4c4936d6be4b7af69f4d5171` |
| Unchanged framework JAR | `02aefc8136cb87eb8e9ebd0928cb15f3e1c2042e47d2a687170a0f9309ac4b20` |
| New native DSO | `aeb5ccd643020cbb20ad5630dabff4bfd0ff8b04a5b0fbcfd1b657b3bcd91dd7` |
| Signed r3 fixture APK | `bafc5f4e708f15fdb0d2868d8b332863c7ce429f1447952867968300e58e12dd` |
| ARM runner | `a62460d72f5a20dcd239cf8abb8d479e4893ba167c970b1f1887b72c96482259` |
| Failed-log diagnostic receipt | `747d99ea6633b6480c742384cad194a516c0c23a4edddf763880ebba4fa21526` |

Preparation passed on its first attempt in 340.287 seconds at sampled aggregate
RSS 75,169,792 bytes and observed shared growth 821,092,352 bytes. Clone and frozen
kernel installation/readback passed in 6.374/58.861 seconds at sampled RSS
37,060,608/34,045,952 bytes. All guard/child exits were zero with host cleanup
complete and zero process swaps. Original 600 MiB/900-second/1 GiB-reserve/file-size
caps remained, with 4 GiB outer preparation growth, 512 MiB internal stager budget
and 2 GiB clone/kernel growth. Complete input, 35-node ancestry, original-module,
two-file overlay and final readback/recheck audits passed.

Exclusive owned VM56202 used 12 GiB/four CPUs and user-default networking from
05:41:34 to 05:50:09 UTC. Dedicated UID/GID10137 was verified unused and provisioned
with protected inputs and a read-only runtime bind. Actual mount flags report
relatime despite requested strictatime. The fixture command was typed 05:44:11;
guest input remained untouched during execution. An initial pre-broker Maps
exit placeholder was closed; it is not a controlled Maps result.

The complete failed child has 10,948 bytes/122 LF-terminated lines, SHA-256
`86e0392e99b7a0c7907f20bdca2a1473ab0bd2692b691e8b0118af242b34a470`.
Workers 2/3 report iteration 0/case=xml, Main.equal(source6) → Main.read(source231)
→ Worker.step(source34) → Worker.run(source41). Workers 0/1 report iteration 1
BrokenBarrierException/TimeoutException. Failures are printed by worker index,
so output order does not timestamp the exceptions. Five resource FAIL lines
occur; there is no PASS, native readiness or successful runner receipt/export.

Frozen signed-fixture Main expects 2 after one next(). Frozen SDK XmlBlock$Parser
initializes mStarted=false; its first next() sets true and returns 0 before
nativeNext. This independently explains the reader assertion. A separate
corrected fixture must assert 0 then 2 and retain all resource, worker, theme,
parser-close and ownership assertions. The signed r3 APK, framework/native pair
and prepared image remain unchanged. The intended four joined workers completing
64 iterations and successful owned Asset/AssetDir lifetime path are unqualified.

The guest exported standard base64 to /dev/console. Linked immutable snapshots
identify the 16,356-byte interval, SHA-256
`d849f307542bd5a2d70236c4c5cca69b309f63a991337fd9372247b1550f63d8`.
The unchanged qualified [diagnostic decoder](diagnostic-uart-base64.md) selected
one maximal encoded run matching the independently read guest length/hash;
the complete preceding UART remains. A separate retained-decoder full check
passed. Derivation/readback took 70/232 ms at sampled RSS 2,392,064/1,294,336 bytes,
with zero exits, complete host cleanup and zero swaps under original 600 MiB/
300-second/64 MiB-growth/1 GiB-reserve/file-size caps. No payload repair or relaxed
success checks were used. Preservation integrity is not successful fixture
qualification. Complete evidence and source pins remain in
`A/fixture-failure-validation.md`, SHA-256
`e44545fb1cb63fee0178801342544abf8155236b5ff72d8eb9fe59da6cea1d5c`.

Owned VM56202 received one SIGTERM at 05:50:09; stop returned zero and absence
was verified. Its final serial matches the complete 91,313-byte after snapshot,
SHA-256 `1bb52e41c90472375eac846a1f08afa52409ee2d94e5f19ec648c5ccb610669d`.
No strict Maps/account import applies because no account controller ran.
No successful six-pin/eleven-check ARM result, new Maps content, native crash
cure or authentication result is claimed.

All nine original runtime roots, including prepared P and four adjacent VM clone
sidecars, are closed to writes. Final `A/operator-notes.md` SHA-256 is
`59ada3d449d59c90ed4ca16cc13ff51ff21f14000bd87ff6da8c38edd8104528`.
The 18-root producer/source/fixture/native and two-root media-tool bundles retain
their separate admitted seals, including rejected attempts. One coordinated
runtime seal and separate fresh-process full readback passed for all nine roots
and 545 typed entries. Manifest
`S/maps-resource-lock-runtime-sealed-2026-11-01-r1/sealed/manifest.json` has
SHA-256 `74f551781733c8953908378adf46cb14039b0721bae94894feb1ab2c7e313e09`.
Seal/readback took 12.086/5.988 seconds at sampled aggregate RSS
22,446,080/22,970,368 bytes and observed shared growth 6,512,640/11,902,976 bytes.
Both guard/child exits were zero, cleanup complete and process swaps zero under
the unchanged qualified sealer and original 600 MiB/900-second/64 MiB-growth/
1 GiB-reserve/file-size caps. No attempt in this runtime seal root failed.
Retain all originals and unchanged auditors; a later corrected-fixture attempt
has separate evidence and cannot change this failed first result.
