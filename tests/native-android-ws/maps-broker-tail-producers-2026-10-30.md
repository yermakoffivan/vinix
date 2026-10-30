# Broker tail diagnostic producers — 2026-10-30

The controller and native account broker were rebuilt for private final-output
capture and raw numeric child status. Source fixes are committed in
`5374d8f61`, `4f0f66a24`, `06da0ce20` and `cf1277141`. No Android framework or
ART native library was rebuilt or changed for this diagnostic successor.

Both producers retain their complete frozen source/compiler/native inputs,
command records, generated C, host checks and static ARM outputs. The controller
builder's unchanged bootstrap (`433b8e2a...`) froze and compiled the maintained
builder, whose explicit `-no-parallel` ARM mode avoids the measured aggregate
memory failure. The broker's unchanged bootstrap (`b68412c6...`) retained its
existing application-restrictions framework contract. The new binaries continue
to use the current Window system-UI framework/ART pair when deployed.

All paths below are under `/Users/alex/.local/state/vinix/android`:

| Producer | Bundle | Manifest SHA-256 | Static ARM executable SHA-256 |
| --- | --- | --- | --- |
| Controller | `maps-account-guest-build-2026-10-30-tail-drain-r4` | `cd14f050b8f3dfd96728605826d324d1ec7b291f96effbe58711759ff254324f` | `bf30d23fb34a382b517688df073fb54b0c140bdedd51afb5444c3f96e870bdbe` |
| Broker | `current-account-broker-build-2026-10-30-child-status-r1` | `7bba04e39681e31c6e13dbd65df99094dadec17a1ab99e114e50f74aa2d18ae9` | `0bf4d36c6c4035eb7e736ee04f3f7a612b9582ef44bad6950bf0aa8b1b1c35ee` |

The successful controller run took 24.548 seconds and peaked at 531,480,576
sampled aggregate RSS bytes; the broker took 13.320 seconds and peaked at
450,494,464. Both original guards require at most 629,145,600 bytes, 300 seconds,
1 GiB backing reserve and 1 GiB observed disk growth. Both runs exited zero with
complete cleanup. Controller builder/controller host checks, dependency/header
audits, static ELF checks and link audits all passed.

Failed controller attempts are preserved: r1 exposed a local C `poll` name
collision; r2 passed host tests before the memory guard stopped ARM generation
at 632,963,072 bytes; r3 generated C below the cap, then strict ARM compilation
rejected a nominal poll descriptor pointer. The final helper uses the platform
`struct pollfd`; focused strict ARM GCC compilation and all six host pipe tests
passed before the successful r4 production run. No compiler checks, memory
limits or C warning policy were weakened, and no generated C was edited.

Independent final review rehashed the r4 controller C as
`7fda727ec27134ff5afb0af9ae1c07b6b9e15ba7b03bed642c0e7cb67d0f7c76`,
verified its retained controller/helper source parity, and checked cleanup,
drain, parsing, descriptor close and buffer-free ordering on error/stop/timeout
paths. Its capture loop uses a stack read buffer and pointer appends without
direct per-iteration allocation. The broker's generated wait-status helper uses
stack numeric state and C output calls without new per-poll heap allocation.

Six closed producer/attempt/control roots (12,248 entries) are sealed in
`maps-broker-tail-producers-sealed-2026-10-30-r2`, manifest
`dc28fc5253e445466c63767ec962cd635e325759a3a18475fd0681b3d2da3ecd`.
The full stream seal and separate full readback passed the original 600 MiB,
900-second, 1 GiB reserve and 64 MiB shared-growth guards. Their controls and a
retained initial CLI refusal are in
`maps-broker-tail-producers-seal-controls-2026-10-30-r1`.
The successful controller/broker manifests were not modified after closure.

These are host and static ARM build results. The successor image and actual
Maps anonymous/account flows still require a fresh guest run.
