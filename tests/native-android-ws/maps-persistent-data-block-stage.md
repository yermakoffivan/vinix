# Persistent-data service and native-window media

This additive seven-file overlay updates only framework, native ART and their
headless/deployment receipts over the sealed seed-account companion image.
ContextImpl returns typed absence for the unsupported persistent-data service;
the new public non-final PersistentDataBlockManager type has no members. The
complete canonical class audit covers 2,105 → 2,106 classes, with only that
ContextImpl method and new type admitted. All 68 native-consumed classes remain
identical in raw and canonical form.

The native change is exactly one binding body: `native_get_window` returns null
when window state or Activity is null, or a Java exception is pending. Complete
retained bindings and generated JNI must equal their predecessors with only
that body substitution. The expected JNI export and `ws_binding_195` identity
are checked. All 88 native origin sources remain byte-identical; the 89-entry
current-input map changes only its bindings pin. Controller, broker, browser,
Vending APK/signature, authority registry and other deployment fields remain
pinned. No new input, top-level field or inode is admitted.

All 70 inherited complete inventories run again in both audit phases. The new
wrapper sorts the full exact map and proves disjoint 64+6 maps with unchanged
pins and complete union, then calls the existing helper sequentially. Its
two-worker/64-job limits remain unchanged. Base plus new framework/native roots
give 73 dependency seals. All 31 inherited modules are checked before and after
installation; readback includes the new module 32. Only the new profile raises
its local module limit to 32; digest-receipt charging covers all 63 receipts.

Artifacts are outside Git under `/Users/alex/.local/state/vinix/android` (`S`):

| Bundle | Manifest SHA-256 |
| --- | --- |
| `maps-seed-account-companion-r1` | `67be52229ca728113d7819f6020ba928a26745f7ce59f7ab458cabfe88d30137` |
| `combined-account-webview-persistent-data-block-framework-2026-10-30-r1` | `a6d34af62a2b8fd6f85c84dd36493d47b3eefa9690cf875c7ac0e67abe882858` |
| `current-native-build-2026-10-30-persistent-data-block-r1` | `a3be17ca4753f9bc816ee21483ed3481aa229ecc6383a5daa9b3691bf71f3da9` |

The actual new bindings pin is
`a94a653fe96f3f05310ab07d68f9d551f1a3b192129e2fd93d9d4f90409547d5`;
generated JNI is
`efc0319f32eb20e944caa8bd91dfd4b42efaa05df65365f3c616a4916dd8f70f`.
The native DSO is
`192411171dec072c89a64a81d8b35f36e92d060c75505fadceb47d683e9ed2e5`.

Batching is committed as `f49146a70`. All five focused tests passed, including
real 65/70-root binary inventories, repeated hashes and mutations, first/second
batch failure ordering, non-overlap, and second-batch worker joins in both
failure completion orders. Assertions and all five test-main calls were checked
in emitted C. Evidence is closed at
`S/maps-inventory-batches-tests-2026-10-30-r1` (`T`). Its initial reserved-keyword
parse failure and corrected source/project are retained.

Media qualification `S/maps-persistent-data-block-tools-2026-10-30-r1` (`Q`)
passed serial V generation, exact emitted C compilations, stager self-tests,
all historical and new patcher self-tests, actual complete framework/native
audits, and helper enumeration. The initial patcher generation rejected two
new negative-test shallow clones of `json2.Any` maps. Only those test copies
became explicit deep copies; no unsafe operation or production validation rule
changed. Original source/log/guard records remain alongside the fresh
`sources-r2` and `patcher-project-r2` records.
Its recorded source base revision is
`b0c33413541c056aed6eab04bcb853c19977ec82`; the exact source hashes below bind
the captured changes. The [pair report](persistent-data-block-pair-2026-10-30.md)
records producer checks, and the [predecessor runtime report](maps-seed-account-companion-runtime-2026-10-30.md)
records the preceding Maps run.

Frozen V imports and actual emitted `cc -M` headers were discovered for both
media tools. The fresh 858-input before/copy/after capture includes focused-test
sources/project lists, compiler, tools, generated C and header bytes. This is
post-build provenance; host SDK/system libraries are not claimed hermetic.
Build/test limits remained 600 MiB aggregate RSS, 300 seconds, 512 MiB observed
shared-volume growth and a 1 GiB reserve. Successful guards exited zero with
cleanup complete. Largest sampled aggregate RSS was 382,287,872 bytes; largest
`time -l` RSS was 391,397,376 bytes. All time reports recorded zero swaps.

| Qualified artifact | SHA-256 |
| --- | --- |
| Stager source | `7194c6e2c00620d35f2438865093cc973a93f13663d8712349016ef4ba660fda` |
| Patcher source | `3bd65fd3c66d9d70c725d6f377a710afe9a6f4a5d086fc11397eec5561e0c997` |
| Discovery helper source | `f83f1b706b317cf7e54a96ec742365d9dac14de7650314ee4e9231b76d1c5f87` |
| `Q/stager-project/maps-persistent-data-block-stage` | `d20d9d83c54598b97541972b43427402c688b0b4e134b212a17555eb2017533e` |
| `Q/patcher-project-r2/patch-kernel` | `3f395c995dda47516a3d3fe58779ac07bfff2831c5c176e1a0c4ddb3c9478ef8` |
| `Q/header-helper-project/media-stage-inputs` | `27eeee52e68079dc1a175d4692397b32c45e9b697134b3d68e78942eae02a91f` |

Both closed roots `Q` and `T` are sealed at
`S/maps-persistent-data-block-tools-sealed-2026-10-30-r1/sealed/manifest.json`,
SHA-256 `049c01b75cd88bc5fa6accc8ad46560758b51b55236fa8d09c6ede2e313349d0`.
Inline and fresh-process complete readbacks passed: two roots, 2,975 entries,
original 600 MiB RSS, 900-second, 64 MiB growth and 1 GiB reserve limits.

Prepare with the qualified stager's `--prepare S/maps-persistent-data-block-r1`;
after a fresh clone use the qualified patcher's `--maps-persistent-data-block
FRESH_STAGE FROZEN_KERNEL_BUILD BUILD_JSON_SHA256`. Preparation retains its
original 600 MiB/900-second/4 GiB growth/1 GiB reserve outer guards and internal
512 MiB write budget. Host tooling is qualified; ARM regression and account
creation behavior require the successor live run.
