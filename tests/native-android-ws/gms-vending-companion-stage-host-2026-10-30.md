# Fixed GMS and Vending batch host checks — 2026-10-30

`companionstage.stage_pair(gms, vending)` stages exactly the two admitted package
identities, returning records in GMS/Vending order. The existing GMS-only
`stage(Config)` API remains available. Package selectors are private; this adds
no arbitrary-package installer or account authority.

Both sources must pass immutable regular-file, owner/group, nlink1, descriptor,
path and byte-pin checks before mutation. Both source descriptors remain open
through the batch. After the second stage, both complete APKs are rehashed and
their descriptor/path metadata and shared DATA identity are checked again.
The pair requires matching DATA/UID/GID and source ownership policy, with
distinct nonoverlapping sources and scratch paths.

The shared catalog can be reused only when its inode and existing entries belong
to the current transaction's ledger and have the expected ownership/modes. Any
later failure rolls back both packages and the catalog using exact-inode removal.
The first private extraction cache is removed before the second stage; compacting
inactive ledger entries preserves creation order and the existing 1024-object
ceiling while accepting 256 libraries in each package. Independent copied APKs
and libraries retain the existing 0400/0500 modes, 0700 directories and selected
UID/GID. Original APKs and primary DATA/native cache remain unchanged.

All ten host test functions passed: three successful publications and 62 refusal
cases, including every previous GMS-only regression. New checks cover distinct
GMS/Vending contents and library inventories, shared catalog correctness,
256+256 libraries, complete rollback on 256+257 libraries or malformed second
native contents, aliases, ownership mismatches and preserved preexisting targets.
A bad second byte pin leaves historical DATA and scratch-parent mtimes unchanged,
proving admission occurs before first-stage filesystem mutation.

Serial host C generation, compilation and actual tests passed; host execution
took 1.04 s with 25,837,568 process maximum RSS bytes. Linux/AArch64 C generation
and actual musl GCC 14.2.0 compilation also passed with the controller producer's
strict flags, including `-Werror=implicit-function-declaration` and
`-Werror=int-conversion`. ARM compilation took 4.01 s with 289,374,208 process
maximum RSS bytes and produced an ELF64 AArch64 object. All five phases exited
zero with complete cleanup under the original 600 MiB RSS, 300 s wall, 512 MiB
shared growth and 1 GiB reserve limits. Guest execution with the actual admitted
APK pair remains part of the coupled controller runtime check.

Source pins, based on revision `582767435a81d11f037fff239d9d6695f497318f`:

- `companionstage/stage.v`: `f848a4035018a4e67ba09b16165d7f05dd3b57f5b311902175349a810813c465`
- `companionstage/stage_test.v`: `60529e8d9ffbf6624e8b8e0297c3d677cd9e6d74d7d74e124477813350437457`

Both original and corrected bundles remain outside Git at
`/Users/alex/.local/state/vinix/android/gms-vending-companion-stage-host-2026-10-30-r{1,2}`.
The corrected r2 bundle passed all five checks. Their aggregate stream seal and
separate full readback passed under the unchanged 64 MiB growth guard: 2042 entries,
manifest `0e6813093bfbf373d681f1afc96b890edff9096150e768a37aa7b1110044298c`,
at the sibling `gms-vending-companion-stage-sealed-2026-10-30-r2` directory.
Controls are retained in `gms-vending-companion-stage-seal-controls-2026-10-30-r2`.

Generated-C ownership review of the initial functional attempt found that V
deep-clones active `Owned.path` strings during compaction; their old originals
were then orphaned when the old array was freed. The original sealed attempt
remains unchanged. The narrow successor releases every old path after any
derived copy, then frees the old array. Fresh ARM C confirms exactly one derived
clone for each retained active path, unconditional release of each old path,
old-array release and retained-array assignment in that order. Returned Record
inventories remain independent of the ledger's path storage.
