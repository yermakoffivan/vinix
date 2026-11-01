# Intent extras first ARM run and Maps native failure

The first signed Intent extras ARM fixture failed on a setup assumption: it
expected a new Intent to have null extras, while the retained constructor
creates a Bundle. Maps reached onboarding, then exited natively after Skip.
This run establishes neither map imagery nor account content with the new pair.
The [prior Dialog imagery/profile result](maps-dialog-theme-runtime-2026-11-01.md)
remains separate. Google authentication is unverified; no credentials were used.

Provider `9229c490d` changes only the two existing `Intent.putExtras` bodies to
merge and copy incoming extras. The [source/caller audit](intent-extras-framework-2026-11-01.md),
[SDK/native audit](intent-extras-pair-2026-11-01.md),
[original signed fixture](intent-extras-fixture-2026-11-01.md),
[runner](intent-extras-fixture-run.md) `f6a101198` and
[media qualification](maps-intent-extras-stage.md) `57e765b08` preserve the
complete source and host checks. No native rebuild or relink was needed;
all 69 consumed canonical classes and 719 exports remain exact. Google APKs,
assertions and validation policy were unchanged for this first runtime attempt.

Artifacts remain under `/Users/alex/.local/state/vinix/android` (`S`): failed
`maps-intent-extras-r1` and `maps-intent-extras-prepare-2026-11-01-r1` (`P1/E1`),
prepared `maps-intent-extras-r2` and `maps-intent-extras-prepare-2026-11-01-r2`
(`P2/E2`), stopped `maps-intent-extras-vm-r1` (`VM`),
`maps-intent-extras-runtime-audit-2026-11-01-r1` (`A`), and
`intent-extras-api-transfer-live-2026-11-01-r1` (`T`).

| Input or result | SHA-256 |
| --- | --- |
| Prepared P2 `sha256.json` | `0a06846c3bc25825ba7b1b6508078523a4a0de789450a7ae57b52ae64b3fcd8e` |
| Framework JAR | `02aefc8136cb87eb8e9ebd0928cb15f3e1c2042e47d2a687170a0f9309ac4b20` |
| Retained native DSO | `280730c4166687394cf69e548cdd106e58c57ba9472f339dde2c80ebdee2595a` |
| Original signed fixture APK | `fed8561ffe44b7562499a22dac8fc5e8e0e28607135bd44a835fefd5be347b5a` |
| Original ARM runner | `2edf61e7afe2bfcf9551a29fe00a1110de36d4f6534c71664827de2074ff083e` |
| Controller receipt | `f0f146efa1c1ea1cbc79cfa799472fe2ee4a1acf13c133888df0c44af1b0a75b` |

P1 preparation passed immutable-input auditing and began its six-file overlay,
then stopped on the unchanged internal cumulative 512 MiB disk-growth guard.
Guard/child exits were 1/1 with cleanup complete, 260.005 seconds and sampled
RSS 70,533,120 bytes. The outer guard observed 2,438,017,024 bytes of shared-volume
growth. Its partial image and complete controls are rejected and retained.
Fresh P2 preparation, clone and frozen-kernel installation/readback passed in
438.519/9.046/70.931 seconds at sampled RSS
90,603,520/32,915,456/50,659,328 bytes, all exits zero with host cleanup complete.
Original 600 MiB/900-second/1 GiB-reserve/file-size limits remained, with 4 GiB
preparation and 2 GiB clone/kernel growth caps and the 512 MiB internal budget.

The owned 12 GiB/four-CPU VM32875 ran from 04:33:51 to 04:44:49 UTC with
exclusive admission and user-default networking. The standalone fixture used
dedicated UID/GID10136 and protected root-owned inputs. It reached
`controlled`, `bundleMerge`, `bundleInitial` and `intentMerge`, then failed in
`emptyIntent`: `Main.same` source6 → `emptyIntent` source36 → `onCreate` source15.
The original source assumes constructor-null extras without explicitly setting
them. A later corrected fixture must prepare null through the existing
`replaceExtras((Bundle)null)` API; it belongs to a separate retry.

The runner emitted neither its success receipt nor SERVICE-QUERY export.
The failed child was exported separately as standard base64 to `/dev/console`.
The unchanged qualified [diagnostic decoder](diagnostic-uart-base64.md) and a
fresh retained-decoder full check preserved exactly 9,463 bytes/97 complete LF
lines, SHA-256
`0578e8780110e6e7bc61e9f88dfd367b31da52ad17f8031f9cf860ce1365680d`.
There is one Intent extras FAIL and no PASS/readiness marker. The first attempt
that did not reach the UART remains retained too. Complete snapshot links,
decoder pins and original-cap controls are in `A/fixture-failure-validation.md`,
SHA-256 `087e954d6b1b434b8ce70ce4a3402a58ca153151ebabd4e90d43ecea3662829e`.
Preservation integrity is not successful fixture qualification; no six-pin/
eleven-check success receipt exists for this failed attempt.

After fixture mount release, broker36367 became ready. Maps launched at
04:41:49, showed onboarding at 04:42:34, received Skip at 04:42:40 and exited
natively at 04:42:59. `VM/intent-maps-exit-stack-private.png` records expired
ApkAssets #1 for resource0x7f142520, `sp<> assignment detected data race`, signal11,
ART signal-handler reentry and a browser-client disconnect. A separate bounded
capture records a caught `IllegalStateException` in `dhgc.finalize`; no causal
chain is established. No tiles, search, photos, account content or authentication
were validated on this pair.

Actual controller receipt runs 04:40:03–04:43:49 with status
`user-stopped-no-authentication-claim`, readiness true and empty error. Stop was
requested at 04:43:45 within the 15-minute bound. Broker exit137 followed
controlled cleanup; no clean exit is claimed. Drain EOF is true, status1,
107,925 bytes and error number0. One cleanup survivor's running/zombie state is
unknown. Empty diagnostic failure arrays and account-handoff records establish
no successful account flow.

The unchanged strict account collector passed 25 entries/2,835 chunks/
1,451,199 archive bytes, SHA-256
`0c1c596152757e9b72408c51220b92347e6c6f6f1a3d3e1628daac872829b90d`.
The exact 2,250,865-byte interval is
`32e83e95ed554082356458791cb975b93c33e40b197ad836bf9d03859c22e196`;
linked snapshots agree and the stopped final UART matches its full snapshot.
Import took 899 ms at sampled RSS 28,475,392 bytes, exits zero and host cleanup
complete under original 600 MiB/300-second/64 MiB-growth/1 GiB-reserve/file-size
caps. Raw private app/broker logs remain excluded except hashes and bounded
private captures. Export integrity establishes no authentication. Owned VM32875
received one SIGTERM at 04:44:49; stop returned zero and absence was verified.

All eleven original roots, including failed P1/E1 and the four adjacent VM clone
sidecars, are closed to writes. Final `A/operator-notes.md` SHA-256 is
`ff9ad73b9d5ef37ccd406ec78308bc0b8072378c7ae215ea461961204f69f7d5`.
One coordinated runtime seal and separate fresh-process full readback passed
for all eleven roots and 799 typed entries. Manifest
`S/maps-intent-extras-runtime-sealed-2026-11-01-r1/sealed/manifest.json` has
SHA-256 `4408378ac18293278b9a9280af7c47719690f92f2b43ee6f52fa882567c25c23`.
Seal/readback took 17.257/6.268 seconds at sampled aggregate RSS
27,312,128/13,418,496 bytes and observed shared growth
64,626,688/27,598,848 bytes. Both guard/child exits were zero, cleanup complete
and process swaps zero under the unchanged qualified sealer and original
600 MiB/900-second/64 MiB-growth/1 GiB-reserve/file-size caps. No attempt in this
runtime seal root failed. Retain all originals and unchanged auditors; the
separate corrected-fixture retry does not alter this failed runtime result.
