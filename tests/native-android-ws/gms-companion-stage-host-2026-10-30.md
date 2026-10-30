# GMS companion staging host checks — 2026-10-30

`companionstage.stage` publishes the admitted GMS APK into the Maps principal's
package catalog and its ARM64 libraries into the fixed package library path.
Extraction uses a separate private scratch directory, preserving the existing
DATA root and primary APK's `data/native-libraries` tree. No package metadata
sidecar is fabricated: the caller admits the APK identity, version and signer;
the runtime continues parsing the real, unchanged APK.

The helper requires an immutable, single-linked regular source with the selected
owner/group and SHA-256. Path and descriptor identity checks bracket bounded
stream copying and publication. Independent regular copies have target UID/GID,
APK mode 0400, library mode 0500 and directory mode 0700. Raw atomic renames
publish only the exact selected destinations. The caller must first establish
that selected app UIDs have no processes; this is a fresh, single-use diagnostic
transaction. Rollback removes only matching inodes from a 1024-object ledger,
using individual unlink/rmdir operations. Successful staging removes its private
extraction cache. The existing `nativeapk.install` implementation is unchanged.

Five host test functions passed: one exact publication and 35 refusal cases.
They cover real synthetic AArch64 ELF libraries, ignored foreign ABI/assets,
all output hashes/owners/modes, copied inode separation, original source nlink1,
preserved DATA identity and primary-cache contents, scratch removal, malformed
and duplicate/traversal native archives, zero/257 ARM libraries, source and parent
protections, unsafe paths, ownership mismatches and preexisting targets. Rejected
existing files, directories and symlink targets retain their metadata/content.

Serial host C generation, emitted Makefile compilation and actual tests passed.
The complete test unit also passed Linux/AArch64 C generation and actual musl
GCC 14.2.0 compilation with the controller producer's strict flags, including
`-Werror=implicit-function-declaration -Werror=int-conversion`; the output is an
ELF64 AArch64 object. Host tests took 0.47 s (7,061,504 process maximum RSS bytes);
ARM C compilation took 3.21 s (247,873,536 process maximum RSS bytes). Every phase
kept the original 600 MiB RSS, 300 s wall, 512 MiB shared growth and 1 GiB reserve
limits, with exit zero and complete cleanup. Independent source and generated-C
lifetime review passed. Actual target-UID staging in guest ART remains a runtime
check for the coupled controller.

Source pins, based on revision `ed9ac7421539de780973d43dafac47eb1d664110`:

- `companionstage/stage.v`: `681ce2873f89dc7bc7b6a6fd3faefd43876bbf76f5b8e2b6bc9c57fbba779e5f`
- `companionstage/stage_test.v`: `f1eda6bf205dd09c5cc2a788449dd7890943b52bbfc6119e7d7b1027a767724e`
- Unchanged `build-support/android/nativeapk/install.v`: `f6acba7d015eca12be7721890a0f37a5e59a27eef4983b5f1f36d84eeb676807`

All four attempts remain outside Git under
`/Users/alex/.local/state/vinix/android/gms-companion-stage-host-2026-10-30-r{1,2,3,4}`.
This includes the initial missing-C-declaration refusal, intermediate passing
checks and final full passing run. The four closed roots passed a stream seal
and separate full readback under the unchanged 64 MiB growth guard: 558 entries,
manifest `4101bf9dbb345974c10e11a878019cca33874a41a14a172d1ebbb7900a08060b`,
at the sibling `gms-companion-stage-sealed-2026-10-30-r1` directory. Guard logs and
receipts are retained in `gms-companion-stage-seal-controls-2026-10-30-r1`.
