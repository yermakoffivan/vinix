# Bounded parallel dependency inventories

The ImageView stager's initial and final dependency phases now check complete
inventories in sorted pairs, with at most two workers. Each worker calls the
unchanged `load_inventory()` and owns its maps, file descriptors, 1 MiB read
buffer and SHA context. Both jobs are joined before either error is returned;
the first sorted path wins when both fail. Odd tails are joined individually.
Every phase performs fresh full-byte checks. The additional bundle rechecks,
zlib checks, 59 manifest selectors, payload proofs and module audits are unchanged.

Qualified outputs over source base `9dfba1823` are retained at
`/Users/alex/.local/state/vinix/android/maps-imageview-bounds-parallel-tools-2026-10-30-r1` (`Q`).
The final source identities are:

- Stager: `c25afc4f22da05c4f1d957bb764e5958b26e5514f619942086aee85f093f466a`.
- Helper: `62730a0bcb023495dd29d50c822cea27beec36f293887c687a32b69432f5e035`.
- Focused tests: `53acbda6ebf6d81301119fee7c3154ea79ea6af23ffcd477fd352baec5a3cfec`.

Serial V generation and the exact emitted production C command passed, followed
by the complete stager selftest, actual framework/native audit and helper
enumeration. Generated C joins both threads before either failure return and
uses the compiler's Boehm pthread wrappers. All five focused tests passed with
assertions retained. They cover controlled worker overlap and the two-worker
bound, odd tails, both error completion orders, joining before returning errors,
real binary manifests, later-phase corruption, malformed/missing/unlisted/symlink
inputs, and simultaneous distinct 64 MiB-plus sparse inputs with trailing-byte
corruption at unchanged size. Generated fixtures and C remain outside Git.

| Phase | Guard seconds | Peak sampled aggregate RSS, bytes |
| --- | ---: | ---: |
| Stager generation / C compile | 16.505 / 32.230 | 324,993,024 / 224,755,712 |
| Full actual input audit | 10.715 | 53,460,992 |
| Focused test generation / C compile | 5.678 / 1.420 | 298,319,872 / 109,117,440 |
| Focused test execution | 0.552 | 23,756,800 |
| Fresh 429-input closure capture | 8.341 | 8,945,664 |

All phases exited zero with complete cleanup and zero time-reported swaps.
Compile/test caps remain 600 MiB aggregate RSS, 300 seconds, 512 MiB observed
shared-volume growth and a 1 GiB reserve. No qualification attempt failed.
The complete one-root, 1,180-entry seal and separate full readback passed under
600 MiB/900-second/64 MiB-growth/1 GiB-reserve caps:
`/Users/alex/.local/state/vinix/android/maps-imageview-bounds-parallel-tools-sealed-2026-10-30-r1/sealed/manifest.json`,
SHA-256 `6362a62d51a22fe44faa670bf0b83067b198d49e6e35d60236ee874c484efd5c`.
Original compiler/source/C/header closure inputs and environmental SDK/system
library scope remain recorded. The qualification root is closed.

The final stager is `Q/stager-project/maps-imageview-bounds-stage`, SHA-256
`138ab82d05d204cd11a7492d7ba5451e0bc595eef7dc1d1e9c1d476153c4cb1e`.
Use `--prepare` with a fresh external output and the original 600 MiB RSS,
900-second, 4 GiB observed-growth, 1 GiB-reserve and 8 GiB file-size limits.
This qualification creates no guest image or VM and does not measure preparation
speed or establish Maps behavior.

Reuse the [qualified ImageView kernel patcher](maps-imageview-bounds-stage.md)
unchanged: `maps-imageview-bounds-tools-2026-10-30-r1/patcher-project-r2/patch-kernel`
below the same state root, SHA-256
`48a7436bf206498230b743090586df0f3097ef1f1145c19eba930aa9935b0fae`.
Its ImageView profile validates the exact 59 manifest inputs, image/module pins
and overlay proofs; it has no stager-source hash or retained-source count
assumption. The new helper adds a regular source/input member without changing
that receipt contract, framework, native library or payload. Kernel installation
still performs the complete required profile and media checks on the fresh clone.
