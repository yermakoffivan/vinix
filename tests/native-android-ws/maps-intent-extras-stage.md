# Intent extras Maps media qualification

The Intent fix (`9229c490d`, clarified in `2f7285aaf`) merges extras into the
destination without aliasing the source Bundle. This media profile retains all
2,108 framework classes and changes only the two existing `Intent.putExtras`
methods. It inherits the prepared Dialog r2 image, appends module 41 after its
40 retained modules, and overlays six files. The native library is retained.

The profile audits 94 inherited inventories and requires exactly 96 dependency
seals. The complete SDK/native audit passed all 69 consumed canonical class
equalities; Intent and Bundle are absent from that native map. Its sole raw
class difference is the exact Dialog formatting pair. Native sources, bindings,
generated JNI, C, headers and 719 exports remain equal. The retained native
producer's Dialog SDK origin stays pinned independently of the SDK successor.
Original historical proof bundles and their unchanged auditors remain required;
this profile adds no native build, relink or proof. The V ancestry checker also
passed the actual 34-stage pinned metadata chain ending at `maps-account-r5`.

| Artifact | SHA256 |
| --- | --- |
| Prepared Dialog r2 parent | `4b28f8921073af2168a6a2bd639c7897f5b2796cc3142a4f8a06228de21efdf2` |
| Intent extras SDK r2 manifest | `bef486d060754858d51612b9c4bb8a24f7c2fdf8f37cc3565101e24a049bf52f` |
| Framework JAR | `02aefc8136cb87eb8e9ebd0928cb15f3e1c2042e47d2a687170a0f9309ac4b20` |
| Framework DEX | `339ced728be216f45470f8435b65e23cc8ae7aafd8c4f11a86d35c9eb0ef1245` |
| Retained native manifest | `a293cfedb3fa2c7775af0cd15330b559ca4850c9ae7496e7e16717d520e2b0a4` |
| Retained native DSO | `280730c4166687394cf69e548cdd106e58c57ba9472f339dde2c80ebdee2595a` |
| Qualified stager | `68245edcdaf06711faa22520470f3b05f9ea27df302e0dc98a2fd4da20aa3656` |
| Qualified kernel patcher | `01147f847cf5b1c02c7e4f14bcaa47f3157416bce9564343623e5b7ab0e1167c` |

Exact 94-root positive, refusal and full-byte tests, split V/C builds, stager
selftests, the complete framework/native audit, helper enumeration and every
kernel profile/FAT selftest passed. Discovery and original/copy/recheck capture
retained 862 inputs. Independent source and final pin reviews passed. The largest
sampled aggregate compile RSS was 447,512,576 bytes. Every admitted guarded phase
exited zero with complete cleanup.

The initial inventory test invocation failed because its configured output parent
did not exist. Its receipt and log are preserved. Creating a fresh protected
output directory and rerunning the same completed binary passed without source
changes. The failed SDK r1 shared-growth attempt remains in the producer evidence;
only SDK r2 is admitted.

Complete tool evidence is outside Git at
`/Users/alex/.local/state/vinix/android/maps-intent-extras-tools-2026-11-01-r1`
and `maps-intent-extras-inventory-batches-tests-2026-11-01-r1`.
Their two-root stream seal and separate fresh readback passed 5,666 entries.
The manifest at
`maps-intent-extras-tools-sealed-2026-11-01-r1/sealed/manifest.json` has SHA256
`34c6bf1e1410d1c5ef898a0d16f82306132e8c50421d705aed34a9d75be9465c`.
The separate twelve-root producer/source/caller/fixture/native seal and fresh
readback passed 27,732 entries, manifest
`intent-extras-producers-sealed-2026-11-01-r1/sealed/manifest.json`, SHA256
`52f29f274c80693528e5bf628389e99bf7180c2b5cb5e324c0072f16d628dccb`.
SDK qualification is recorded in `5d9393ac3`; fixture runners in `f6a101198`.

All original limits remain: 600 MiB aggregate RSS, 300 seconds for builds/tests,
900 seconds for full audits, 1 GiB reserve, 512 MiB tool growth, 64 MiB seal
growth and shell file cap 16777216. Complete artifacts and rejected attempts stay
outside Git. Image preparation and ARM/live Maps validation belong to the parent
runtime task; this qualification makes no authentication or map-rendering claim.
