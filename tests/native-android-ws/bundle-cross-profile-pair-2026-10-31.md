# Bundle booleans and cross-profile absence SDK, 2026-10-31

The complete SDK build passed from revision
`16143aa8fc19c7fcc4cedb449be2cfae450da3d6`, containing the combined provider fix
and qualified producer profile `fffe51003`. The class count changes from 2,106
to 2,107. BaseBundle changes one String.equals receiver/argument pair in its
existing boolean getter. ContextImpl adds an early null return for the absent
CrossProfileApps service while preserving its existing typed lookup fallback.
The new CrossProfileApps type is public, nonfinal and memberless. No existing
method, field or constructor is added or removed; all other existing methods,
class metadata and non-DEX JAR payloads remain unchanged.

The producer checks the complete old/new BaseBundle method except the one
operand swap and the complete old ContextImpl fallback except the exact typed
null guard and known DEX label rebasing. All 2,104 other existing canonical
classes remain identical. This adds no cross-profile backend, target user,
account identity, policy bypass or Google authentication result.

Production took 54.128 seconds, sampled aggregate RSS 508,280,832 bytes and
observed shared-volume growth 291,110,912 bytes. Guard and child exited zero,
cleanup completed and reported swaps were zero. Original limits remain
629,145,600 bytes RSS, 300 seconds, 1 GiB growth, 1 GiB reserve and the file cap.
Producer qualification controls and complete historical self-tests are in the
[producer report](bundle-cross-profile-producer-profile-2026-10-31.md).

The final media tool's complete artifact audit passed for all 2,107 canonical
classes and all 69 native-consumed classes against the original Layout SDK
manifest `1266de2e0a64d876e3559240fe5596ad67d9f2cfce81bd0e1e727675c0d39e00`.
BaseBundle, ContextImpl and CrossProfileApps are outside that native set. All
69 canonical classes remain equal; the sole raw native-class difference is the
fixed Layout canonicalization pair. Retained native provenance, 89 sources,
90-input map, JNI, C and 719 exports all passed. The native library was not
rebuilt or relinked for this successor.

Four complete closed roots under `/Users/alex/.local/state/vinix/android` (`S`)
passed sealing and independent fresh-process complete readback:

- `bundle-cross-profile-framework-builder-2026-10-31-r1`.
- `combined-account-webview-bundle-cross-profile-framework-2026-10-31-r1`.
- `bundle-cross-profile-framework-production-2026-10-31-r1`.
- `current-native-build-2026-10-30-layout-alignment-r1` (unchanged qualified native).

The seal contains 9,267 entries at
`S/bundle-cross-profile-producers-sealed-2026-10-31-r1/sealed/manifest.json`,
SHA-256 `a3ef381679e09411952fc411088c52fa3a9e111911ad1f2b5cd72b59532a4550`.
Seal/readback took 1.732/0.522 seconds with sampled RSS 24,625,152/22,904,832
bytes. Both guard/child exits were zero, cleanup complete and reported swaps zero
under original 600 MiB/900-second/64 MiB growth/1 GiB reserve caps. No attempt in
these four roots failed. All earlier original evidence remains required and
unchanged, including the failed original UserManager fixture and its diagnostic
byte export. These producer results establish no ARM fixture or live Maps result.

| Artifact | SHA-256 |
| --- | --- |
| Framework manifest | `e9b9093ee1b8546bca93732cab02a4b58e8ddb25f8c4aae216e40c6602e542aa` |
| Framework build receipt | `950471d3707f930aba1b6ca3d98c73f460bc8c4c05c517b8005045f72ba45d6b` |
| Framework JAR | `3ebf88615dcb87ec103b098a0baf397f5a4428623f809fd139b23e9f60978235` |
| Framework DEX | `d54fe422ae88367ca89e9f766114ad60b2bdaa767dc2200b72227617b9b370b1` |
| Retained native manifest | `ad1c44a5ac2f06925c19c02648d837263a9f1aa9661735b9e49e958193b80413` |
| Retained native build receipt | `e6d7ca1b38a82b2f7a15b018a1fef294356693207993c0966b6f291073967a0d` |
| Retained native DSO | `b6aeb06b7473220da8844015a253ed87394fef6209173c14317fcbaf19141e95` |
