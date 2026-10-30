# User restriction query producer profile, 2026-10-30

The additive `--user-restrictions` framework profile accepts only the complete
Layout framework baseline at
`/Users/alex/.local/state/vinix/android/combined-account-webview-layout-alignment-framework-2026-10-30-r1`:
manifest `1266de2e0a64d876e3559240fe5596ad67d9f2cfce81bd0e1e727675c0d39e00`,
JAR `162c77f853e6cb85f373493c40c302ff4df5b90ed52f2e6dce961e5e17281d01`.
All 2,106 classes remain present. UserManager alone gains public virtual
`getUserRestrictions()` and `hasUserRestriction(String)` methods. No existing
method, field, constructor or class metadata changes.

The documented unmanaged single-user backend supplies fresh empty snapshots.
The boolean query invokes the virtual snapshot getter and Bundle.getBoolean;
it preserves true backend values and exceptions. The producer's ABI checks run
before assembly and after complete DEX disassembly. Maintained focused tests
reject changed flags, missing/substituted targets, unrelated class changes and
new classes. All historical producer tests remain enabled.

Builder compilation and complete self-tests passed first attempt under the
original 600 MiB aggregate RSS, 300-second, 512 MiB observed-growth and 1 GiB
reserve limits. Compilation took 2.269 seconds at 350,633,984 sampled RSS bytes;
self-tests took 0.293 seconds at 7,634,944 bytes. Both guard/child exits were zero
with complete cleanup and zero reported swaps. Complete controls remain at
`/Users/alex/.local/state/vinix/android/user-restrictions-framework-builder-2026-10-30-r1`.
Builder source SHA-256 `8413b1fc434291c34af16207be242a68f30092b660aacb6f8b2607f1b3038d0a`;
qualified executable SHA-256 `84ff56d75991408328db95d320968f74df1cabac2ac2b1f77eb57cb33fd469d7`.
The checked SDK implementation is committed as `ba7751ec7`.

UserManager is absent from the retained native producer's complete 69-class
input set. Production will retain that qualified native library and require
full canonical equality for all 69 consumed classes; no native rebuild is needed.
Full framework production and ARM execution remain pending.
