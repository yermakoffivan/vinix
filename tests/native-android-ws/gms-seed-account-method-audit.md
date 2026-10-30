# GMS seed-account helper audit, 2026-10-30

The complete broker capture reports missing
`UserManager.getSeedAccountOptions()PersistableBundle` in `atlx.a` line 11,
called by `atrr.invokeSuspend` line 6. Direct inspection corrected the initial
screenshot transcription `atsl`/`attr`; those rejected extractions are retained.
All fifteen frozen GMS class listings place these names solely in classes6.dex.

The actual `atlx.a(Context)` has this complete immediate Android flow:

| DEX offset | Source line | Operation |
| --- | --- | --- |
| `0x2` | 3 | `Context.getSystemService(Class)` for UserManager |
| `0xa` | 11 | If the manager exists, call `getSeedAccountOptions()` |
| `0x12` | 19 | If manager or returned options is null, read `PersistableBundle.EMPTY` |
| `0x14` | 21 | Call `Object.getClass()` on that fallback |
| `0x18` | 25 | Only for non-null returned options, call `clearSeedAccountData()` |
| `0x1b` | 28 | Return the selected options |

The coroutine checks its Kotlin result, loads the Context, calls the helper at
offset `0x5`, and returns its result at `0x9`. It has no subsequent immediate
Android API call. Returning null for an unseeded runtime follows GMS's explicit
fallback branch; it does not call `clearSeedAccountData` on that branch.

The pinned current framework lacks both UserManager seed methods and also lacks
`PersistableBundle.EMPTY`. PersistableBundle extends BaseBundle, which extends
Object; neither Android class declares that field. Adding only a null-returning
getter would therefore expose an immediate missing-field failure. The fallback
must be a real non-null `PersistableBundle.EMPTY`. This audit establishes linkage
and branch behavior, not the field's mutability contract or authentication success.

Paths use `S=/Users/alex/.local/state/vinix/android`:

- Corrected selected classes, rejected candidates, review receipt and private
  screenshot: `S/gms-seed-account-method-2026-10-30-r1`.
- Complete command controls:
  `S/gms-seed-account-method-controls-2026-10-30-r1`.
- Full 27-root, 19,421-entry seal and separate-process readback:
  `S/gms-seed-account-method-evidence-2026-10-30-r1/sealed/manifest.json`, SHA-256
  `25ae47a9917217ca3e8e49b97f3e17784eda7c52f360746c1b193e7606337982`.

Recorded checkout base was `74fd07f21e41b10239a077fa698554e3036f24f7`.
Comparison used framework manifest
`1e24a8dcc2f5b315ebbb63cb06d3de46e0799b4b1a0d19339d3b98ecab0c3b09`.
GMS APK SHA-256 is
`a34d6a3ccea3ceba491369517e8f12e11df3791e86fec38b1cdf693785e35707`;
classes6.dex SHA-256 is
`879beeba4d39da968c7ca0b1649382e768c7a6998f842b2c4fed2bb4e0582220`.
Corrected `atlx.smali` SHA-256 is
`6091ca94620b40dc6a86be5bf2209dd3c3988ce4a779625ee8ff268afdc2b2b9`.

Complete prior evidence passed unchanged readback before extraction. Sparse
disassembly used the pinned existing Java/tool closure, explicit selectors,
256 MiB heap, two active processors and two jobs under 600 MiB RSS, 300 seconds,
512 MiB observed growth and 1 GiB reserve. Corrected extraction peaked below
99 MiB sampled RSS. Seal/readback passed in 1.740/1.489 seconds under unchanged
600 MiB RSS, 900 seconds, 64 MiB growth and 1 GiB reserve. All guard and child
exits were zero with complete cleanup. No compiler, app patch or guest mutation
was needed for this audit.
