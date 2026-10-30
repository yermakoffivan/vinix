# Seed options and Google companion media

The additive stager and `patch-kernel --maps-seed-account-companion` profile
combine two fixed companion packages with the three-class seed-options fix.
UserManager adds its null-returning getter; PersistableBundle adds immutable
`EMPTY`; ArrayMap initializes its immutable constants before constructing
`EMPTY`. All 2,105 framework classes are accounted for, and the 68 native inputs,
88 native sources, bindings and generated JNI remain unchanged.

Actual Maps `berv.b` requires Vending on this path: its absence returns
`SERVICE_INVALID` (9), and `bfdc.h` disables remote Dynamite. That evidence is
sealed at `S/maps-gms-availability-method-evidence-2026-10-30-r1/sealed`, manifest
`b3b624b83b9813c4aaa32e3d01c65ea28dfe63da60e873b5f1e65f93d29d1ca6`.
It establishes a package-availability requirement; imagery causality remains
unverified until the live successor run. Here `S` is
`/Users/alex/.local/state/vinix/android`.

The ten-file overlay replaces the controller and alias, framework JAR/DEX,
native DSO, three headless framework receipts and deployment receipt, and adds
one protected Vending APK. The deployed APK is extracted from the pinned
original `qemu-runtime.tar` member, never a mutable guest path. Its exact SDK 29
signer was verified before admission. Only the Vending leaf can be new: regular,
single-link, mode 0644, exact size/hash, safe inherited ancestors, and no
preexisting destination. All other destinations retain their inode rules.

The deployment has exactly eight existing input replacements plus one new APK
input and one new `vending_signer_sdk29_sha256` field. Additions are checked
separately from replacements. Broker, browser, authority registry and all other
deployment fields remain pinned. The profile also supports a byte-identical
coupled DSO by omitting that unchanged hash from the replacement delta while
keeping the DSO in the overlay. The actual new DSO differs.

All 65 inherited complete inventories run in both phases: 64 through the
unchanged two-worker helper, with the previous controller explicitly loaded
and rechecked. The full dependency map remains intact. Base plus four new
producer roots give 70 seals. All 30 inherited modules are rehashed and read
back; the new overlay is module 31.

| Artifact under `S` | Manifest SHA-256 |
| --- | --- |
| `maps-broker-tail-r1` | `c6ab0709b40b1718f0d3c6d13e6f1ba3f2a8ccf5de2b6a8e36cd62802ef2c6e9` |
| `combined-account-webview-seed-account-options-framework-2026-10-30-r1` | `470636b2812f339d58071ba59986282ac5107e5256aa2588dd9305d7ef5b45e9` |
| `current-native-build-2026-10-30-seed-account-options-r1` | `8fbfbd2c74eca6c412909a2a64fb91949cbaa1ed0b262e9970ff375dddff61f8` |
| `maps-account-guest-build-2026-10-30-gms-companion-r1` | `d903515f7d493f6174128bede8511e8f470515b580a8e5374aa5623360e289d5` |
| `maps-vending-admission-2026-10-30-r2` | `c6e9ec6ef3280b977fadee1aed5a7d91a94d10807bbc65da1feff98823228f1d` |

The [Vending admission report](maps-vending-admission-2026-10-30.md) records
failed attempts, exact metadata, SDK 29 certificate, source/tool closure and
seal `8054ddf5541a3a757fe26c61c7848d0b00bd15856d3b10aff9728282d865c99e`.
The controller roots are separately sealed at
`S/maps-companion-controller-sealed-2026-10-30-r1`, manifest
`b82fdf64e1b8a7e96f45569cad7a3d3afddcdbfac877b7641ecb575f7d9f8bf8`.

Qualification `Q = S/maps-seed-account-companion-tools-2026-10-30-r1` passed
serial V generation, exact emitted C compilation for all three tools, stager
self-tests, complete historical/new patcher tests, and actual framework,
native, controller and Vending audits. The post-build helper discovered frozen
V imports and actual emitted `cc -M` headers for both media tools. A fresh
832-input capture retains generated C, commands, compiler, tool and header
bytes with before/copy/after checks. This is post-build provenance, not a claim
that every host SDK/system library was captured contemporaneously.
The recorded source base revision is
`cccb73ec2a73af5cd849742b63b5a97ef1cc7e55`; the three qualified source hashes
below identify the captured changes precisely. See also the
[framework/native pair report](seed-account-options-pair-2026-10-30.md) and
[controller producer report](maps-companion-controller-2026-10-30.md).

Every guard passed with cleanup complete. Build/test limits remained 600 MiB
aggregate RSS, 300 seconds, 512 MiB shared-volume growth and a 1 GiB reserve.
Largest sampled aggregate RSS was 376,406,016 bytes; largest `time -l` RSS was
385,155,072 bytes. All time reports recorded zero swaps. Source and input
inventories, SDK/tool identities, tests, commands and generated projects remain
in the closed qualification root.

| Qualified artifact | SHA-256 |
| --- | --- |
| Stager source | `457aafb452545c3222c38ab9df9d1f374fbb57f17c41aca347a55f61041cb4eb` |
| Patcher source | `9c10b6f98963d5e64a97929ac268acd26102d1510665f14a5df288757c468402` |
| Input-discovery helper source | `f6ef46cb86bda9547bdc6a2f14f632812676f81f6faaf9eb75c491e4151bb876` |
| `Q/stager-project/maps-seed-account-companion-stage` | `108f0941061dd6d4590e62deea3a8afef0af1fe791c6e51c828ef5ded6ad5b6b` |
| `Q/patcher-project/patch-kernel` | `53a63be603de1abe84174eed87502a6e20e171b14d25fbc696851e7bc58a3999` |
| `Q/header-helper-project/media-stage-inputs` | `9803ea323d03118dc2666ac35d6615d7ad00c7419813d82d73bdd3864be2ec37` |

The closed qualification root is sealed at
`S/maps-seed-account-companion-tools-sealed-2026-10-30-r1/sealed/manifest.json`,
SHA-256 `9affb39f9ffe0bb7ee8f8d9d52247388837bcb75e9cf8d432b1a6f6a774a3a75`.
Inline and separate full readbacks passed: one root, 1,613 entries, original
600 MiB RSS, 900-second, 64 MiB growth and 1 GiB reserve limits.

Use the qualified stager with `--prepare S/maps-seed-account-companion-r1`, then
the qualified patcher on a fresh clone with `--maps-seed-account-companion
FRESH_STAGE FROZEN_KERNEL_BUILD BUILD_JSON_SHA256`. Preparation retains its
original 600 MiB/900-second/4 GiB growth/1 GiB reserve outer guards and internal
512 MiB write budget. Host tooling is qualified; the ARM fixture and live Maps
run remain necessary.
