# Resource adapter synchronization

The retained resource adapter serializes selected value lookups but leaves
configuration updates, APK replacement, names, pooled strings, themes, directory
opens and NDK asset opens outside the same lock. This is a concrete framework
defect. It is not yet established as the cause of the Maps crash observed after
Skip in `maps-intent-extras-vm-r1`.

The retained native bundle is
`/Users/alex/.local/state/vinix/android/current-native-build-2026-11-01-dialog-theme-r1`:
manifest `a293cfedb3fa2c7775af0cd15330b559ca4850c9ae7496e7e16717d520e2b0a4`,
native library `280730c4166687394cf69e548cdd106e58c57ba9472f339dde2c80ebdee2595a`,
and `native/atlframework/resources.v`
`066ed7687e165976d50fc88f9b74c9be6f7e502b6063e0ef7582a45c7e916cd2`.
All original source and build evidence remain intact.

The reused `libandroidfw.so` is
`/Users/alex/.local/state/vinix/android/account-contract-companion-build-2026-10-26/inputs/build/android-framework/calculator/overlay/opt/vinix-android-aarch64/usr/lib/art/libandroidfw.so`,
SHA-256 `41666cf78396cb4e97c84b365ea23ef95d17a3a047d12a8a97348f1adcb5533e`.
Its actual AArch64 instructions establish:

- `AssetManager_setApkAssets` at `0xd5b20` calls `StartOperation` and
  `SetApkAssets` without acquiring a mutex.
- `AssetManager2::StartOperation` at `0x36228` uses a non-atomic load/add/store
  on the operation count at manager offset 504.
- `FinishOperation` at `0x35ac0` decrements that count and clears per-cookie
  cached strong pointers when the count reaches zero. Its pointer-clear path
  calls `sp_report_race` at `0x35b20`.
- `GetApkAssets` at `0x35b60` promotes a weak pointer into the shared cached
  strong pointer. Its assignment path calls `sp_report_race` at `0x35c6c`.

The [upstream C facade](https://gitlab.com/android_translation_layer/art_standalone/-/raw/e78bf68917bcaaf58fef3960cd88793b3b7f39cc/libandroidfw/androidfw_c_api.cpp)
and [AssetManager2 implementation](https://gitlab.com/android_translation_layer/art_standalone/-/raw/e78bf68917bcaaf58fef3960cd88793b3b7f39cc/libandroidfw/AssetManager2.cpp)
at the repository's frozen ART input explain the same behavior. Operation scopes
manage borrowed-resource lifetimes; they do not provide mutual exclusion. The
binary observations above do not depend on assuming complete upstream source
identity.

The correction uses one adapter mutex around all shared manager and theme C API
operations, followed by the existing destination-manager mutex. Release order is
reversed. This also serializes source-manager reads during theme copy without a
second manager lock. Raw theme handles, JNI signatures and Java framework remain
unchanged. Internal helpers avoid recursive acquisition and keep borrowed names,
string pools and bags protected through copying. Owned Asset and AssetDir handles
leave the creation scope independently. Java XML archive loading remains outside
the native lock.

Independent source review passed the four-file runtime scope (`resources.v`,
`bindings.txt`, `ndk_assets.v`, `asset_directories.v`). The V checker
`check-resource-locks.v` extracts production functions and tests real pthread
contention with an instrumented C API/JNI boundary, complete caller coverage,
instance-method flags, cleanup, recursive names, and compiled negative controls.

The host contention check passed at base revision `9d572099f`, with exact copied
inputs in `S/resource-locks-host-2026-11-01-r1` (`S` is the external Android state
directory above). Four workers completed 1,000 iterations and 24,000 instrumented
API/copy operations; all three named negative controls were rejected. Compile
and run guards passed in 2.745/4.092 seconds at aggregate sampled RSS
300,580,864/182,927,360 bytes, with zero process swaps and complete cleanup.
The runtime source remained unchanged throughout qualification; `resources.v`
SHA-256 is `ac9f0b8acb10175d8f77cea018bb637a938d26b58e25cede2ab9a0b945519fe3`.

`S/resource-locks-host-2026-11-01-r5` admits the isolated initializer and ARM link
using the exact retained generator, old compiler `109a0bad...`, pinned C header
and full production compile/link argv. Only C source and output operands change.
Generated C contains one file-scope `PTHREAD_MUTEX_INITIALIZER` and no runtime
assignment. The resulting DSO exports only its probe and the same `_init`/`_fini`
CRT symbols present in the retained native library. The initializer-only guard
passed in 3.018 seconds at 72,122,368 bytes sampled aggregate RSS, with 2,985,984
bytes observed growth, zero swaps, exit zero and complete cleanup. All checks
retain the original 600 MiB, 300-second, 512 MiB-growth and 1 GiB-reserve limits.

Preserved r2/r3 attempts rejected incomplete isolated header preambles; r4
compiled and linked but rejected an expected export set that omitted the two
established CRT symbols. The corrected maintained checker captures the complete
production preamble and original command, rather than discovering compiler flags.

Full successor native/JNI/export auditing, bounded ARM resource stress, and Maps
validation remain separate required gates. Host lock discipline and the small
ARM link do not establish ARM resource behavior or Maps crash causation.

The first full native successor generated the static initializer correctly but
its unchanged `-Werror` link rejected three const-pointer conversions in the new
array-count and pooled-string wrappers. The source now uses the same explicit
`ResolvedBag` and `voidptr` casts as the established adapter. The host extraction
and borrowed-string negative mutation retain those cast expressions. This does
not change locking, resource lifetime, headers or compiler flags. The complete
failed native attempt remains at `S/resource-lock-native-controls-2026-11-01-r1`;
the native successor is unadmitted until the fresh full retry passes. Earlier
host receipts retain their original source hashes.

Changed-source host validation passed in
`S/resource-locks-host-2026-11-01-r6`, including the same 24,000 operations and
three specific negative controls. Compile/run guards passed in 3.450/2.494
seconds at 304,037,888/183,500,800 bytes sampled aggregate RSS, exit zero and
complete cleanup under unchanged limits. `--host-only` avoids repeating the
unaffected r5 initializer/link proof. The cast-corrected `resources.v` SHA-256 is
`a94e1d8fc8187b13603f8db205653e307b9c5fac82b6c524780c8ceec1820b5d`.
The original r6 receipt is preserved: its explicit host-only mode and marker
identify the checks run, while its generic scope text also mentions the skipped
ARM replay. The maintained checker now emits an accurate host-only scope that
references the separate r5 proof; this receipt-wording correction requires no
rerun of unchanged computations.
