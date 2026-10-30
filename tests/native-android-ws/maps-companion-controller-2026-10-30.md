# Maps companion provisioning — 2026-10-30

The controller now provisions the two real companion APKs into Maps' private
data directory before starting either Android app. The prior runtime's catalog
was absent even after Maps initialized. Audited Maps code checks Vending before
GMS on this framework's normal device branch and returns status 9 when Vending
is missing; that result also disables remote Dynamite loading. This establishes
a missing prerequisite. Tile/photo rendering still needs the successor run.

Only the fixed GMS and Vending package pair is admitted. Their real SDK29
signers, APK hashes and version/split facts are bound to verified deployment
metadata. The account authority registry retains exactly Maps and GMS.

| Companion | APK SHA-256 | Version code |
| --- | --- | --- |
| GMS | `a34d6a3ccea3ceba491369517e8f12e11df3791e86fec38b1cdf693785e35707` | 264131013 |
| Vending | `444e41ee8ef6ec8c55815087c51c28e516ea32f93d856f8bdd0025bb6fc36bc2` | 85292100 |

Both dedicated SDK29 signer digests are
`f0fd6c5b410f25cb25c3b53346c8972fae30f8ee7411df910480ad6b2d60db83`.
Vending was extracted from the immutable pinned `qemu-runtime.tar` member and
verified with aapt and apksigner, then admitted as a new protected deployment
input. That complete bundle is
`/Users/alex/.local/state/vinix/android/maps-vending-admission-2026-10-30-r2`,
manifest `c6e9ec6ef3280b977fadee1aed5a7d91a94d10807bbc65da1feff98823228f1d`.

The maintained `companionstage` helper composes the canonical
`nativeapk.install` extractor with independent regular copies into
`_installed_apks_/PACKAGE.apk` and `PACKAGE_/lib`. Extraction caches stay in
root-private scratch outside Maps' primary `native-libraries` cache. Published
directories/APKs/libraries have UID/GID 10012 and modes 0700/0400/0500.
Both immutable source APKs remain single-linked. The existing data directory's
device/inode/owner/group/mode is preserved. Both sources are admitted before
publication and hashed again after the second package; failure rolls back the
batch's owned inodes. The public receipt contains fixed metadata and hashes.

Helper host tests cover three successful cases and 62 refusals, including the
256+256 library boundary, malformed second input, rollback and independent
copies. Strict ARM compilation and independent generated-C ownership review
passed; helper commits are `0869d0585` and `cccb73ec2`. The controller adds nine
metadata/input rejection cases and receipt roundtrip checks. All existing
controller host self-tests, static ARM ELF/header/link checks also passed.

The final controller producer completed in 27.495 seconds with peak sampled
aggregate RSS 564,543,488 bytes under the original 600 MiB/300-second/1 GiB
reserve/1 GiB observed-growth limits. Its closed bundle is
`maps-account-guest-build-2026-10-30-gms-companion-r1` under the same state root:

- Manifest: `d903515f7d493f6174128bede8511e8f470515b580a8e5374aa5623360e289d5`.
- Static ARM executable: `7d48a43d7f6fbe39ad5704e68a62b1cdbab65e867000c91f5fdfbc9066cfc216`.
- Controller source: `fa4e346391d8bdb7ad916e6165a833126dad0fdf9217303aaf3d8c0cff263564`.
- Generated ARM C: `20468805f91b43f98771c8d016f106e0fe6ab16b077d4728735bfc3a0228a394`.

Independent review checked the final full-context clone/free ordering,
descriptor cleanup and receipt inventory lifetimes. Two closed producer/control
roots (3,441 entries) passed stream sealing and a separate full readback under
the original 64 MiB shared-growth guard. Their seal is
`maps-companion-controller-sealed-2026-10-30-r1`, manifest
`b82fdf64e1b8a7e96f45569cad7a3d3afddcdbfac877b7641ecb575f7d9f8bf8`.
The combined media and actual Maps/account behavior are subsequent validation.
