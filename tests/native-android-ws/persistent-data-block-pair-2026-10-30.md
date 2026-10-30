# Persistent data block framework/native pair, 2026-10-30

The full framework and fresh coupled native build passed for the SDK repair
`b2da1fb72` and native window-lookup guard `4901bf57c`. Both production manifests
record revision `4901bf57c467cf77ce83927021502c2f8da09e01`. The additive framework
producer profile and its qualification report are committed as `94de43dd2`.

The qualified Boehm producer preserves all 2,105 preceding classes and adds
exactly the memberless public PersistentDataBlockManager type. ContextImpl's
typed service lookup is the sole changed existing method; no existing field or
other member changes. Its named service lookup remains unchanged. Complete DEX
disassembly checks the 2,106-class result and the exact method/class ABI, and
all other JAR entry payloads remain equal. The canonical baseline class map is
byte-identical to the preceding seed-options framework's final map.

The native producer restored the retained old-276 compiler/library inputs,
froze and rechecked complete source closures, generated JNI from copied classes,
and passed its AArch64 `-Werror` shared link and complete export check. The 68
consumed raw classes and all 88 native source files remain unchanged. Of the
89 source/binding input hashes, only bindings.txt changes to its reviewed guard.
The 718-symbol export inventory remains byte-identical.

The full generated V differs only in `ws_binding_195`, exported as
`Java_android_view_View_native_1get_1window__J`: three guards return null when
the runtime state or activity is absent, or an exception is already pending.
The original Activity.getWindow call remains exact. The full generated C diff
contains only the corresponding nine added guard lines in that same function;
all other generated C bytes remain unchanged. The focused recording-JNI tests
for that source cover 14 cases and reject six mutants, including incorrect
exception handling and receiver use; their original bundle is documented in
[native-view-window-host-2026-10-30.md](native-view-window-host-2026-10-30.md).
An independent read-only review confirmed the complete generated diffs and
unchanged input/export inventories in the finished native bundle.

The complete retained roots are:

- Builder qualification and framework controls:
  `/Users/alex/.local/state/vinix/android/persistent-data-block-framework-builder-2026-10-30-r1`.
- Full framework:
  `/Users/alex/.local/state/vinix/android/combined-account-webview-persistent-data-block-framework-2026-10-30-r1`.
- Fresh coupled native build:
  `/Users/alex/.local/state/vinix/android/current-native-build-2026-10-30-persistent-data-block-r1`.
- Native guard controls:
  `/Users/alex/.local/state/vinix/android/persistent-data-block-native-controls-2026-10-30-r1`.

All four complete roots passed sealing and independent full readback: 9,258
entries, manifest
`/Users/alex/.local/state/vinix/android/persistent-data-block-producers-sealed-2026-10-30-r1/sealed/manifest.json`,
SHA-256 `3ce578603de059e2bd626aedcb6221ce960e840f459bc566eec8ad35de2390b2`.
There were no failed production attempts.

| Final phase | Guard seconds | Sampled aggregate RSS bytes | Time maximum bytes |
| --- | ---: | ---: | ---: |
| Boehm producer compile | 2.352 | 349044736 | 295878656 |
| Boehm producer self-tests | 0.472 | 1245184 | 13975552 |
| Full framework production | 43.807 | 492306432 | 479559680 |
| Fresh coupled native production | 26.921 | 618807296 | 404914176 |

Every final guard/child exited zero with complete cleanup and zero reported
swaps. The original 629,145,600-byte RSS limit, 300-second production deadline,
1 GiB reserve and file-size limit remain enforced. Framework and native
production retain their 1 GiB observed-growth allowance; qualification retains
512 MiB. Sealing/readback retain their 64 MiB growth allowance and 900-second
limit. No guard was raised for this result.

| Artifact | SHA-256 |
| --- | --- |
| Qualified Boehm producer | `97de748ae41cde12fc1a68d58094082108998e812758ca3b3d873fc9d3e11a0a` |
| Producer source snapshot | `28663eaeecb77308e9e01fb1edd00c53b3f7a49e054eee0b3feecea8c5a779ba` |
| Framework `sha256.json` | `a6d34af62a2b8fd6f85c84dd36493d47b3eefa9690cf875c7ac0e67abe882858` |
| Framework `build.json` | `f0f7cbad1cea5f966c9be3a75ca8e75e1e34e6ab14b2c65b903f8db3f38b5262` |
| Framework `api-impl.jar` | `7c1b2fa03924003c7717e07ef463bff81c6429c7667b2bc42d35954fb6d41752` |
| Framework `classes.dex` | `c7aa301de104c40a793477d4a86349301b21e243932011088b22e2d16228eb53` |
| Native `sha256.json` | `a3be17ca4753f9bc816ee21483ed3481aa229ecc6383a5daa9b3691bf71f3da9` |
| Native `build.json` | `d65c4d31c93933828924a63655e2bf9197c5d782422940b5fe6edcd17e6b7838` |
| Native ELF | `192411171dec072c89a64a81d8b35f36e92d060c75505fadceb47d683e9ed2e5` |
| Consumed 68-class map | `5acb52c6bc4e18d57382393e3d95e04a46275a73df265d0a2b344b1417d54aaf` |
| Native binding specification | `a94a653fe96f3f05310ab07d68f9d551f1a3b192129e2fd93d9d4f90409547d5` |
| Generated JNI | `efc0319f32eb20e944caa8bd91dfd4b42efaa05df65365f3c616a4916dd8f70f` |
| Generated C | `8a819be801b1076e4f6954f1a330bfe176c9fa16f06dbc95b344a1a244202d85` |
| Native exports | `1f420a37fe1379f3291bd841a978dbac87122008b722ba8c42046933f61bdb83` |

The signed SDK fixture and focused checks are documented in
[persistent-data-block-host-2026-10-30.md](persistent-data-block-host-2026-10-30.md).
This establishes the production pair; ARM fixture execution and the real Google
account service still require runtime checks.
