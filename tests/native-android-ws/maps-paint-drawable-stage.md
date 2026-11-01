# PaintDrawable Maps media qualification

The additive PaintDrawable SDK (`a13caf3e9`, producer `a0ed7c09c`) adds one
Java class to the 2,107-class Resources framework. This media profile inherits
the prepared Resources image, retains its exact native library, and installs
module 39 with six overlay files. All historical profiles remain supported.

The profile checks all 89 inherited inventories and seals 91 roots after adding
its prepared parent and SDK. The full compatibility audit passed: all 69 native
consumed classes remain canonically equal; the sole raw Resources reformat pair
is explicitly pinned. No native rebuild or new prefix-map proof is required.

Pinned artifacts:

| Artifact | SHA256 |
| --- | --- |
| Paint SDK manifest | `15a60de7b8196aaca79d869cec972b0382da1be7327ee8f10c56b7e1db37cbb2` |
| Framework JAR | `b3fed7d846a23d9e8afc1256e5bfa7d9ebcd1ba5330705d40fd14131291d516c` |
| Framework DEX | `4a981204badeaf801718457aa88c7442aa62ef1a92db3438220d6b546f235238` |
| Retained native manifest | `c8a7134531f5fdfb6a8e484537a4eb798564fb039760ae9f82cc9a2045ba3062` |
| Retained native DSO | `441ae035ec4b69c36635cc4521af3fafcb6a867305b0ba25d6e55df7ff0dadc9` |
| Prepared Resources parent | `76984d82922315563f88d46e72a77bc4995466ed2581a5df0b62000ac2c4d888` |
| Qualified stager | `e04850088da1ebf13f6ac19f1c17d1a1442caa282389224d636cbc70bceb0e24` |
| Qualified kernel patcher | `05879850fba8f4571f8640c37e3f4e7d6c1b2446f70b66bc06a06e5469081d13` |

Qualification passed the exact 89-root inventory tests, split V/C builds,
stager selftests, complete SDK/native audit, helper enumeration, all kernel
profile/FAT selftests, and original/copy/recheck capture of 855 build inputs.
The initial patcher compile failed on two shallow map clones in the new profile's
selftest; its source and failed receipt are preserved. Both statements now use
the existing deep JSON-copy pattern, and a fresh build and full selftest pass.
Production and historical verifier bodies were unchanged by that correction.
The maximum sampled aggregate RSS was 431,390,720 bytes under the original
629,145,600-byte cap; all guarded phases completed cleanup.

Complete raw evidence lives outside Git under
`/Users/alex/.local/state/vinix/android/maps-paint-drawable-tools-2026-11-01-r1`
and `maps-paint-drawable-inventory-batches-tests-2026-11-01-r1`. The two-root
stream seal and separate fresh readback passed all 4,713 entries. Its manifest is
`/Users/alex/.local/state/vinix/android/maps-paint-drawable-tools-sealed-2026-11-01-r1/sealed/manifest.json`,
SHA256 `9b1a6683d7fb9319c371169987939920ee4f804b07c8a30567080a1d36c7f161`.
The producer/retained-native five-root seal is recorded separately in
[the SDK pair report](paint-drawable-pair-2026-11-01.md).

Image preparation uses `maps-paint-drawable-r1` with controls under
`maps-paint-drawable-prepare-2026-11-01-r1`, retaining the 600 MiB RSS cap,
900-second limit, 1 GiB reserve, 4 GiB outer growth allowance and 512 MiB
internal write budget. This qualification does not establish ARM rendering or
Maps account flow success; those require the subsequent guest run.
