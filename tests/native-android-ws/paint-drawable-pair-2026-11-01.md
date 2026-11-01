# PaintDrawable SDK and retained native pair

Provider `a13caf3e9` adds one public `PaintDrawable` subclass, with five methods
and no fields, over the complete Resources-float SDK. Qualified producer
`a0ed7c09c` builds 2,107 to 2,108 classes with every existing class, method,
field and non-DEX JAR payload unchanged. The wrapper validates retained shape,
paint, resource and styleable dependencies before writing the class. The class
provider must then reproduce that exact file. A pinned raw class plus complete
post-DEX method/metadata/branch comparison permits only the known equivalent
label and locals/registers spellings. Historical producer profiles are intact.

The producer compile passed in 22.982 seconds at sampled aggregate RSS
360,202,240 bytes; complete historical and new self-tests passed in 0.411 seconds
at 1,245,184 bytes. Complete SDK production passed in 80.728 seconds at
508,641,280 bytes, with observed shared-volume growth 643,031,040 bytes.
All qualified guard/child exits were zero with complete cleanup under unchanged
600 MiB, 300-second, 1 GiB reserve and file-size caps. Tools retained their
512 MiB shared-growth limit; SDK production retained 1 GiB.

The first producer compilation remains unqualified and preserved: its guard
stopped on 675,487,744 bytes of shared-volume growth after 0.978 seconds, before
any compiler diagnostic or admitted binary. Guard/child exits were 125/137 with
complete cleanup. The fresh r2 used unchanged source and limits. Success does
not replace the original failed control.

Artifacts remain under `S=/Users/alex/.local/state/vinix/android`:

| Artifact | SHA-256 |
| --- | --- |
| `combined-account-webview-paint-drawable-framework-2026-11-01-r1/sha256.json` | `15a60de7b8196aaca79d869cec972b0382da1be7327ee8f10c56b7e1db37cbb2` |
| Framework `build.json` | `59405264d739d2d7e2243f5316f58597df2388efbbfa19ff7e7e744d34c99170` |
| Framework JAR | `b3fed7d846a23d9e8afc1256e5bfa7d9ebcd1ba5330705d40fd14131291d516c` |
| Framework DEX | `4a981204badeaf801718457aa88c7442aa62ef1a92db3438220d6b546f235238` |
| Added raw class | `eba47a450e64ba9c72b2032e3bb79782b084347c01915a79e2acb9816b3ac461` |
| Added canonical class | `55140f465a9b885ff13764060f451540850875f575fbc78f5e4e40ab06e4a9eb` |
| Retained native manifest | `c8a7134531f5fdfb6a8e484537a4eb798564fb039760ae9f82cc9a2045ba3062` |
| Retained native DSO | `441ae035ec4b69c36635cc4521af3fafcb6a867305b0ba25d6e55df7ff0dadc9` |

The retained native root is `current-native-build-2026-11-01-resources-float-r2`.
No native rebuild or relink is performed for this SDK. The media tool's actual
artifact audit passed all 2,108 classes, with only PaintDrawable added and all
69 native-consumed canonical classes equal to the retained native build's own
Resources SDK. Only the exact known raw Resources formatting pair differs.
Native sources, JNI, generated C, headers, 719 exports and helper closure remain
exact. Receipts are in `S/maps-paint-drawable-tools-2026-11-01-r1/framework-audit.*`.

Five complete closed roots passed sealing and a separate fresh-process full
readback: the failed producer r1, qualified producer r2, SDK, production controls
and retained native build. Their exact list is
`S/paint-drawable-producers-sealed-2026-11-01-r1/roots.txt`. The seal contains
9,322 typed entries, with `sealed/manifest.json` SHA-256
`955ea16613cf7507a220abd8c83dbd93ac37048897f797de1609ce0967235b62`.
Seal/readback took 1.754/0.509 seconds at sampled aggregate RSS
24,035,328/13,680,640 bytes. Both guard/child exits were zero and cleanup complete
under unchanged 600 MiB/900-second/64 MiB-growth/1 GiB-reserve/file-size limits.
No attempt in this seal root failed. The original complete bundles and failed
controls remain required. ARM rendering, Maps profile behavior and
authentication are separate runtime results.
