# Dialog theme Maps media qualification

The Dialog fix (`b97a9861a`) preserves explicit/default themes in the existing
`Dialog(Context,int)` constructor. The SDK retains all 2,108 classes and changes
only that constructor. This profile inherits the prepared PaintDrawable image,
adds module 40 after its 39 retained modules, and overlays seven files including
the coupled native library. Controller, broker and Vending artifacts stay pinned.

The profile audits 91 inherited inventories and requires 94 dependency seals
plus five exact path-only native-proof leaves. The immediate SDK parent is
PaintDrawable; the retained native producer's independent SDK origin remains
Resources `b88ea5ad…`. Across the 69 consumed classes, only Dialog may change
canonically. The raw changes also include the known Resources formatting pair.
Native production sources, bindings, generated JNI, C, headers and exports must
remain equal. Native helper changes are restricted to the registry and added
PaintDrawable/Dialog providers; immediate SDK helper changes are restricted to
the registry and Dialog provider.

| Artifact | SHA256 |
| --- | --- |
| Prepared PaintDrawable parent | `d835836d3ce75adde417df33ebbfc866705c2010c583fe15beb57bb9a4237fbe` |
| Dialog SDK manifest | `a3547ad6477b3fb2eb7a9bcd7d73b8870c89a6bf69c4a84db03dc79e3222859f` |
| Framework JAR | `9d8d2b1f59f80bf0d704daa65eaf3b479fa83458338f23d9fe17aa7a57b541b6` |
| Framework DEX | `4e2c69c8f32f4ef77c92d68a1c3733d4a1ca3c8b8c960acf462ae508e20f84f8` |
| Coupled native manifest | `a293cfedb3fa2c7775af0cd15330b559ca4850c9ae7496e7e16717d520e2b0a4` |
| Coupled native DSO | `280730c4166687394cf69e548cdd106e58c57ba9472f339dde2c80ebdee2595a` |
| Canonical prior native DSO required by proof | `441ae035ec4b69c36635cc4521af3fafcb6a867305b0ba25d6e55df7ff0dadc9` |
| Qualified stager | `fb38132949a18ca7f3f5161be3db8d96b4f694a7acbd9fd4e4ded0ac2dbd7e40` |
| Qualified kernel patcher | `03a2be4a0572e758ba5bf5f73b2eba4920836bcb5cf2665922f76c8b5ae751f6` |

The exact 91-root tests, split V/C tool builds, stager selftest, complete
SDK/native compatibility audit, helper enumeration and all kernel profile/FAT
selftests passed. Discovery and original/copy/recheck capture retained 855 input
files. Independent source and final pin reviews passed. The largest sampled
aggregate RSS was 452,640,768 bytes; all recorded guarded phases completed cleanup.

The initial patcher emission rejected two shallow JSON-map clones in the new
Dialog selftest. Its failed source and receipt are preserved. Exactly those two
statements now use the existing deep-copy pattern; fresh generation, C compilation
and full selftests pass. Production and historical verifier bodies are unchanged.
An earlier stager-selftest invocation preceded completion of the C build and
exited 127; its log remains preserved and the completed binary passes.

Tool evidence uses the external state roots
`/Users/alex/.local/state/vinix/android/maps-dialog-theme-tools-2026-11-01-r1`
and `maps-dialog-theme-inventory-batches-tests-2026-11-01-r1`. Their two-root
stream seal and separate fresh readback passed 5,176 entries. The manifest at
`maps-dialog-theme-tools-sealed-2026-11-01-r1/sealed/manifest.json` has SHA256
`995fe5bb9be4905d36d970e5c41f8a3404e92cf1e13df014318a30bbc51dff5f`.
The separate sixteen-root producer/fixture seal and fresh readback passed,
manifest `dialog-theme-producers-sealed-2026-11-01-r1/sealed/manifest.json`,
SHA256 `21f05fa4110985523c32885b944da3fcceed2b45defae22370f2624b81b5582e`.
Prepared media and controls use `maps-dialog-theme-r1` and
`maps-dialog-theme-prepare-2026-11-01-r1`. Image preparation and ARM/live Maps
validation remain with the parent runtime task; no runtime success is claimed here.

All original limits remain: 600 MiB aggregate RSS, 300 seconds for builds/tests,
900 seconds for full audits/preparation, 1 GiB reserve, 512 MiB tool growth,
4 GiB outer image growth with a 512 MiB internal write budget, and shell file cap
16777216. Complete raw evidence and rejected attempts remain outside Git.
