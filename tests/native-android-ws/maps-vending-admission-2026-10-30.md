# Vending APK admission, 2026-10-30

The pinned `com.android.vending` APK was admitted from the immutable
`maps-broker-tail-r1` boot media. The producer streams the FAT module with the
qualified `mtype`, checks its complete SHA-256 before and after extraction, scans
the tar archive, and requires exactly one regular APK with the expected length
and digest. The complete base inventory, retained project sources, tools and
producer identity are checked before and after admission.

Actual metadata is version code `85292100`, version name
`52.9.21-24 [0] [PR] 968642861`, minimum SDK 24, target SDK 37, no split name or
required splits, and ABIs `arm64-v8a`, `armeabi-v7a`, `x86`, `x86_64`.
`apksigner verify --min-sdk-version 29 --max-sdk-version 29` succeeded with exactly
one signer, certificate SHA-256
`f0fd6c5b410f25cb25c3b53346c8972fae30f8ee7411df910480ad6b2d60db83`.
This establishes the signing identity for the guest SDK; installation, Google
authentication and target SDK compatibility still require runtime validation.

All paths below are under `/Users/alex/.local/state/vinix/android/`:

| Artifact | SHA-256 |
| --- | --- |
| `maps-broker-tail-r1/sha256.json` | `c6ab0709b40b1718f0d3c6d13e6f1ba3f2a8ccf5de2b6a8e36cd62802ef2c6e9` |
| Source `qemu-runtime.tar` module | `1c6988d1f3d3844425f0e8cbb49a878b3a16f2a270b4eb3852c71dfaa8fe200e` |
| `maps-vending-admission-2026-10-30-r2/vending.apk` (106020565 bytes) | `444e41ee8ef6ec8c55815087c51c28e516ea32f93d856f8bdd0025bb6fc36bc2` |
| `maps-vending-admission-2026-10-30-r2/sha256.json` | `c6e9ec6ef3280b977fadee1aed5a7d91a94d10807bbc65da1feff98823228f1d` |
| `maps-vending-admission-2026-10-30-r2/build.json` | `2a71077cb254a6f6bc72ab153fbdc06f08149223df345e241c1dba74496c9dc2` |
| `maps-vending-admission-tools-2026-10-30-r1/project-r5/maps-vending-admission` | `6ab522885fc109df058efdae46d6170cdc0cbfa35d91dc5b84ec86b29b61e44a` |
| `maps-vending-admission-sealed-2026-10-30-r1/sealed/manifest.json` | `8054ddf5541a3a757fe26c61c7848d0b00bd15856d3b10aff9728282d865c99e` |

The admission receipt records source revision
`582767435a81d11f037fff239d9d6695f497318f` and producer source SHA-256
`7422c4e6acf6814d15c78eab5a713bc566d801c68d52a088d22ebf8c9d16ceb8`.
The retained source bytes are authoritative for the uncommitted producer used by
the run; this report and those sources are committed together afterward.

Validation passed: serial V generation, the unchanged emitted C make command,
focused malformed metadata/signer/member self-tests, actual APK extraction and
SDK 29 signature verification, and a separate process reading back the complete
external seal. The actual admission took 10.136 seconds, sampled aggregate RSS
320012288 bytes and disk growth 234520576 bytes, with clean exit and cleanup.
The original guards remained 600 MiB RSS, 300 seconds, 512 MiB growth and 1 GiB
free reserve. Sealing and readback used the original 64 MiB growth limit.

The tools bundle retains generated C, exact build commands, logs, guard receipts,
source snapshots and a 696-file closure copied with hash-before/copy/hash-after.
The closure was discovered after the build using the imported V listing and the
actual emitted C command with `cc -M`; it is post-build evidence. Required C
headers were all present. The unused emitted `LegacySupport` include directory
was absent and is explicitly recorded. Initial syntax/compiler attempts and the
first actual admission, which rejected this aapt version's `minSdkVersion`
spelling, are preserved. The final parser uses that exact spelling and rejects
an additional ambiguous legacy SDK record. The seal covers the tools bundle,
failed admission r1 and passed admission r2 (three roots, 936 entries).
