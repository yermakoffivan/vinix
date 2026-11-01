# Resources float SDK and coupled native pair

The complete 2,107-class SDK adds only public virtual `Resources.getFloat(I)F`
from `c01f167cf`, through qualified producer profile `7de6f6a0a`. It calls the
existing virtual `getValue(id, value, true)`, accepts only TYPE_FLOAT, returns
`TypedValue.getFloat()`, and preserves lookup failures and wrong-type
NotFoundException semantics. All old Resources methods, fields, class metadata,
2,106 neighboring classes and non-DEX JAR payloads remain unchanged. The signed
[host fixture](resources-float-host-2026-10-31.md) is separate from ARM execution.

Resources belongs to the 69 native-consumed classes. A new coupled native build
was therefore produced from the retained Layout compiler/runtime inputs, with
the [split host compilation fix](native-host-split-2026-11-01.md) `b2aad79ed`.
The tool change separates V generation from C compilation, preserving exact
source/input capture, emitted compiler flags and before/after checks. Its final
bootstrap retained and rechecked 637 imported/native/header inputs. Builder
source is `b307f9afc36f19aefdf160c51c528f6bf7b157b4cfcced7d625fc697dfe55eeb`.

| Qualified operation | Seconds | Sampled aggregate RSS bytes |
| --- | ---: | ---: |
| SDK producer compile | 4.199 | 360,923,136 |
| Complete producer self-tests | 0.526 | 1,245,184 |
| Complete SDK production | 121.704 | 511,066,112 |
| Coupled native production | 40.846 | 552,468,480 |
| Actual-command prefix-map proof | 13.958 | 380,452,864 |

Every operation above has guard/child exit zero and complete cleanup under the
original 600 MiB, 300-second, 1 GiB reserve and file-size caps. SDK/native
production retained 1 GiB observed shared-growth limits; proof/tools retained
512 MiB. The new native production observed 425,824,256 bytes of shared growth.

The exact five-leaf proof at
`S/resources-float-prefix-map-proof-2026-11-01-r1` reproduces the entire original
Layout DSO, SHA-256
`b6aeb06b7473220da8844015a253ed87394fef6209173c14317fcbaf19141e95`.
It copies the actual successor command and changes only its output and one
`-ffile-prefix-map=new-root=original-Layout-root` argument. Physical inputs were
rechecked. This proves the newly linked DSO differs only in embedded source-root
paths; it does not substitute for the final media artifact audit or ARM result.
The original Layout native manifest remains `ad1c44a5ac2f06925c19c02648d837263a9f1aa9661735b9e49e958193b80413`.

The media tool's full actual-artifact audit subsequently passed: all 2,107
classes, the Resources-only canonical addition across the 69 native-consumed
classes, the fixed raw Layout difference, unchanged native sources/JNI/C and
719 exports, the exact six-entry builder-helper delta, and the five-leaf
actual-command prefix proof. Its `framework-audit` receipt and log remain in
`S/maps-resources-float-tools-2026-11-01-r1`. This is a host artifact result.

Original artifacts remain under
`S=/Users/alex/.local/state/vinix/android`:

| Artifact | SHA-256 |
| --- | --- |
| `combined-account-webview-resources-float-framework-2026-10-31-r1/sha256.json` | `b88ea5adb85e7b5ea6ff70cdd7310fbb039e1922c4d3467b35ce6f71ebd0d38f` |
| Framework `build.json` | `e6dd9df8164e83e4f5eb91e730b112534426cc4096b5d514013d1cb9bfb3f1b4` |
| Framework JAR | `aac12a41b70ce34c0893580431a28de81cb3476e7c6833cbe0c0ca8596db677d` |
| Framework DEX | `d5c79f9ecf953b4f33263bf45dbfcb606d0d64a0a0cf9aa4015d073f883e638c` |
| `current-native-build-2026-11-01-resources-float-r2/sha256.json` | `c8a7134531f5fdfb6a8e484537a4eb798564fb039760ae9f82cc9a2045ba3062` |
| Native `build.json` | `c9c6a06637f8b4c9e53fea29caeeb07b8bae71033e364a9e8c09eaa57df476e6` |
| Native DSO | `441ae035ec4b69c36635cc4521af3fafcb6a867305b0ba25d6e55df7ff0dadc9` |

The two unqualified native predecessors remain intact. The Oct31 attempt's
monitor failed after 11.998 seconds with cleanup unconfirmed, even though later
artifacts appeared. The Nov1-r1 attempt exceeded RSS at 634,896,384 bytes and
completed cleanup. Neither output is admitted. Capability probes include a
preserved missing-parent setup refusal; a superseded bootstrap generation is
also retained. Successful Nov1-r2 results do not replace those records.

Complete sealing and a separate fresh-process full readback passed for all 17
producer, native, proof, bootstrap and failed-control roots: 14,742 typed entries.
The exact root list is `S/resources-float-producers-sealed-2026-11-01-r1/roots.txt`.
Manifest `sealed/manifest.json` beneath that directory has SHA-256
`81c5e922fc024531789f3a0028f9d26685e935b559e2c01c952cd3ed0b6c2eae`.
Seal/readback took 3.153/1.472 seconds at sampled RSS 28,360,704/24,035,328 bytes;
both guard/child exits were zero with complete cleanup under unchanged 600 MiB,
900-second, 64 MiB shared-growth, 1 GiB reserve and file-size caps. No attempt in
this sealing root failed. Retain the complete roots and prior historical bundles.
Deployment, ARM fixture, live Maps imagery/profile and Google authentication
remain separate checks.
