# View native window lookup host regression — 2026-10-30

`View.native_get_window(long)` previously called `Activity.getWindow()` with the
global activity as its JNI receiver, even after service UI shutdown cleared that
global before pause/stop/destroy callbacks. The captured account failure reached
this path and CheckJNI aborted on a null receiver while handling an earlier Java
failure.

Only that binding body changes. It returns null when the runtime state or its
activity is absent, or when a Java exception is already pending. The valid
activity path retains the original `obj` call, receiver, method/signature,
arguments and return value. No reference is allocated, released or reassigned;
the lifecycle dispatcher and shared JNI helpers remain unchanged.

`check-native-view-window.v` runs the production binding generator's ABI, escape
and generation functions against the retained real `View.smali` declaration. It
then executes the generated binding and production `slot`, `pending`, `cls`,
`method` and `obj` functions using a recording JNI function table.

All 14 cases passed, and six negative mutants were rejected. Cases cover absent
runtime and activity, preservation of an original pending exception, valid and
null window returns, lookup/method/call exceptions, and callback states with the global
activity cleared. The callback states model the shutdown condition; the separate
existing account UI checker executes production shutdown. Mutants include the
original unsafe body, omitted activity protection, inverted exception policy,
wrong receiver, discarded valid return and exception clearing.

The existing account UI transport/teardown checker and headless service
lifecycle checker also passed; the latter retained its 33 cases and 18 negative
mutants. All nine successful generation, C compilation and execution phases
exited zero with complete guard cleanup under the unchanged 600 MiB aggregate
RSS, 300 s wall, 512 MiB shared-volume growth and 1 GiB reserve limits. The
focused run took 5.472 s, with 536,952,832 sampled aggregate RSS bytes and
450,887,680 time-reported process maximum RSS bytes. The account UI and lifecycle
runs took 3.730 s and 0.915 s respectively.

The original combined outer build was stopped at 658,898,944 aggregate RSS bytes
and remains preserved as r1. An initial split-generation CLI attempt omitted the
required project-path value; it was rejected before generation and remains r2.
The successful r3 uses supported serial V C-project generation followed by the
unaltered emitted Makefile. Neither limit nor generated compiler flags changed.

Sources were checked against revision `b2da1fb722045b5f75769611d10c28ad284f16de`:

- Prior `bindings.txt`: `e3fa613993c1ca60aab021ebdbacc93dc71ae68e4bef3d112482f77c8ddeb95b`.
- Updated `bindings.txt`: `a94a653fe96f3f05310ab07d68f9d551f1a3b192129e2fd93d9d4f90409547d5`.
- Focused checker: `fa6c9033d869e3af0d8c086bc3fbb9c7964310bd4a4eb0b8cbe9d5632249e8ea`.

Complete evidence, binaries, generated projects and retained inputs are outside
Git at `/Users/alex/.local/state/vinix/android/native-view-window-host-2026-10-30-r{1,2,3}`.
All three roots passed an aggregate seal and separate full readback: 81 entries,
manifest `6c3da9112cd46f79c2d136f0ef302653b79d3b6b62bb561864be0100db76a399`,
at the sibling `native-view-window-host-sealed-2026-10-30-r1/sealed/manifest.json`.
Both checks retained the original 600 MiB RSS, 900 s wall, 64 MiB growth and 1 GiB
reserve caps, with zero exits and complete cleanup.
The focused receipt retains the exact generator, JNI helper and real View input
hashes. Source and temporary JNI table lifetimes received an independent review.
The coupled native producer supplies the separate complete generated-JNI delta
and ARM/runtime validation; these host checks do not establish Google login.
