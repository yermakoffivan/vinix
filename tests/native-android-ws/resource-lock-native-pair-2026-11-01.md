# Resource adapter synchronization native pair

The native correction in `a5310a98f`, with three established readonly casts
restored in `fea4b7a85`, serializes shared resource-manager and theme operations
through one adapter mutex, with the manager mutex acquired second. The
[source qualification](resource-locking-source-2026-11-01.md)
records the concrete missing synchronization, host contention checks and isolated
ARM initializer/link proof. Those checks do not establish the cause of the
earlier Maps exit.

The Java SDK remains the admitted 2,108-class Intent r2 bundle,
`S/combined-account-webview-intent-extras-framework-2026-11-01-r2`, where
`S=/Users/alex/.local/state/vinix/android`. Its manifest is
`bef486d060754858d51612b9c4bb8a24f7c2fdf8f37cc3565101e24a049bf52f`, JAR
`02aefc8136cb87eb8e9ebd0928cb15f3e1c2042e47d2a687170a0f9309ac4b20`, and DEX
`339ced728be216f45470f8435b65e23cc8ae7aafd8c4f11a86d35c9eb0ef1245`.
No SDK rebuild is part of this correction.

The native predecessor remains intact at
`S/current-native-build-2026-11-01-dialog-theme-r1`, manifest
`a293cfedb3fa2c7775af0cd15330b559ca4850c9ae7496e7e16717d520e2b0a4`, DSO
`280730c4166687394cf69e548cdd106e58c57ba9472f339dde2c80ebdee2595a`.
Its own framework coupling remains the original Dialog SDK; the successor couples
directly to the unchanged Intent SDK above.

The maintained native producer is unchanged at source SHA-256
`b307f9afc36f19aefdf160c51c528f6bf7b157b4cfcced7d625fc697dfe55eeb`.
The retained Dialog bootstrap is
`3b9cdfd9ddbf83984aefa2e8545fd09d7a47d5b154b6001b6aed59ce642d4728`.
It captures the current helper closure, compiles a private frozen builder, then
replaces the bootstrap process before snapshotting and building the native
sources. Compiler, compiler-library, runtime and C-header inputs retain their
original complete checks.

The production input change is exactly three V files plus ten AssetManager
binding bodies. Raw theme pointers and JNI declarations remain unchanged.

| Source | SHA-256 |
| --- | --- |
| `resources.v` | `a94e1d8fc8187b13603f8db205653e307b9c5fac82b6c524780c8ceec1820b5d` |
| `ndk_assets.v` | `072f3f6dc3920d4b6f995d6679ce84cef869fb8acb0aeb79d68647557245d3a4` |
| `asset_directories.v` | `ce5c9358406e79293f462b2e536ee18d1c327490f429c215ef36e903b78587de` |
| `bindings.txt` | `6fcfb9aff1f73a308f3c7b68f8982243179805ca488f35fba6e2b0db54c6b2b4` |

Relative to the Dialog native capture, the producer helper closure changes only
the already qualified Intent registry (`framework.v`, `dafce215...` to
`f4756de6...`) and adds its provider (`framework_intent_extras.v`,
`830ae79f...`). This follows from coupling the new native library directly to
the admitted Intent SDK. Generated C and the DSO contain the actual resource-lock
correction; a whole-library path-only equivalence claim would not apply.

The first native attempt, `S/current-native-build-2026-11-01-resource-lock-r1`
with controls in `S/resource-lock-native-controls-2026-11-01-r1`, is preserved
and unadmitted. Full generation passed, including one static mutex initializer
and no runtime reset. The Werror C compile rejected three const conversions in
the new array-size, array-retrieval and pooled-string wrappers. No warning flag
was relaxed. Guard and child exited one with complete cleanup after 29.295
seconds, at sampled aggregate RSS 559,382,528 bytes and 203,505,664 bytes
observed shared growth; process swaps were zero. Its guard receipt SHA-256 is
`691c01895f0a77c1f44cabc9d9b8bfec7a8ea514ea8f20fb879b9c099aa0e169`.
The changed-source host r6 check subsequently passed all 24,000 operations and
three negative controls. Its host-only evidence is separate from the retained
isolated initializer check and the full successor production.

The fresh full successor at
`S/current-native-build-2026-11-01-resource-lock-r2` passed its AArch64 Werror
compile/link and complete producer checks at source revision
`fea4b7a85b75a7db10300e1c1fcac3c49064ed84`. Controls are retained at
`S/resource-lock-native-controls-2026-11-01-r2`. Guard and child exited zero
with complete cleanup after 45.797 seconds, at sampled aggregate RSS
550,780,928 bytes and 345,452,544 bytes observed shared growth. The native
process recorded zero swaps. Limits remain 600 MiB aggregate RSS, 300 seconds,
1 GiB observed shared growth, 1 GiB reserve and the original file-size cap.

Independent final-artifact review found the same 89 source members and exactly
the three V changes above. Generated JNI differs in exactly ten binding bodies,
with unchanged signatures and export annotations. The actual 719-entry export
list is byte-identical to the predecessor. Generated C preserves the complete
native preamble, contains one file-scope `PTHREAD_MUTEX_INITIALIZER` for the
resource mutex and never assigns or resets it at runtime. Its difference from
the failed r1 C is exactly the three reviewed casts. The compiler and header
checks remain intact.

| Successor artifact | SHA-256 |
| --- | --- |
| `sha256.json` | `ffe69aca16f77cacac1021b94f4825d1a23a574904614bdca57610c39fa42197` |
| `build.json` | `fcca57adaa9baae43cda13b1baec9da27fe2412c8307f7155d296e62d2174698` |
| `native/libvinix-android-native.so` | `aeb5ccd643020cbb20ad5630dabff4bfd0ff8b04a5b0fbcfd1b657b3bcd91dd7` |
| `native/atlframework/ws_generated.v` | `399511deb701154341664fda6927ee3935df8df599f65d794b463514f998b123` |
| `native/android-native.c` | `e942097c854a4a1799c3c5abbd0889afce063f92e1c7008c0a3011ec3de0087c` |
| `native/exports.json` | `388c10f346d6892346496240bed78a9fddc614c03f783dde5cff66c09210d5ba` |
| Production guard receipt | `32eec298cb101ec0ad29e8cd4006138d255e10fc8536f39d5d66f1291f454423` |

The media tool's complete actual-artifact audit passed all 2,108 retained
canonical classes, all 69 native-consumed canonical equalities, the exact three
native sources and ten binding bodies, generated JNI/C, unchanged headers and
719 exports, and the exact two-entry helper-capture delta. New native raw class
inputs match the admitted Intent SDK. Comparing with the old native inputs
permits only the established Dialog formatting pair,
`66a711e288271a52f5fe9d44b4fca75738ee882f60f869d12030c4ba3f8290f1` to
`fb1951defc731f6f52b907aaa81fd94272662e9a7348d1b2dbf6caee32a59042`.

The audit log and receipt remain at
`S/maps-resource-lock-tools-2026-11-01-r1/framework-audit.{log,guard.json}`.
The audit passed in 4.527 seconds at sampled aggregate RSS 52,461,568 bytes and
37,146,624 bytes observed shared growth, with zero swaps, guard/child exit zero
and complete cleanup under unchanged 600 MiB, 900-second, 512 MiB-growth and
1 GiB-reserve limits. Receipt SHA-256 is
`3241b84840fb1463c7999c6bf40db3ef92878aac6f779a0439514ff5214d573d`.
This admits the host artifact pair; bounded ARM stress and live Maps checks
remain separate runtime gates.

Complete sealing and a separate fresh-process readback passed on the first
attempt for 18 closed roots and 13,374 typed entries. The exact list is
`S/resource-lock-producers-sealed-2026-11-01-r1/roots.txt`: all six core-check
attempts, all three fixture attempts and their controls, both native attempts
and their controls, the admitted Intent SDK and the retained Dialog native
bundle. Rejected attempts remain complete and unadmitted. The list SHA-256 is
`2972a5917cb591ab14a0e0458521e462fbc7ab52869aea22abf5521f8d90e257`.

The sealed manifest at
`S/resource-lock-producers-sealed-2026-11-01-r1/sealed/manifest.json` is
`af80d8ab44a17985e29a06fcaee3c3713c6a81ad680c0bf5781cb12508fb61ae`.
Seal/readback took 1.599/0.846 seconds at sampled aggregate RSS
28,590,080/24,018,944 bytes and shared growth 13,873,152/1,548,288 bytes.
Both guard and child exits were zero with complete cleanup under the unchanged
600 MiB, 900-second, 64 MiB-growth, 1 GiB-reserve and file-size caps. Preserve
the complete source roots and all referenced historical bundles. Media-tool
sealing and runtime validation are recorded separately.
