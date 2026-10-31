# User restriction framework and retained native, 2026-10-31

Fresh framework production passed after host disk space recovered. The build
records revision `02c10fb01e0dfcd08b877e36ea26f8f2e4dcb2fa`, containing SDK fix
`ba7751ec7`, signed fixture `16c33479b` and producer profile `28430e69b`.
All 2,106 classes remain present. UserManager alone gains public virtual
`getUserRestrictions()` and `hasUserRestriction(String)` methods. Every existing
method, field, constructor and non-DEX JAR payload remains unchanged.

The documented unmanaged single-user backend returns fresh empty snapshots.
The boolean query invokes the virtual snapshot getter and Bundle.getBoolean,
honoring true backend restrictions and exceptions. This adds no policy writer,
administrator, managed profile, account identity or authentication result.
See the [host regression report](user-restrictions-host-2026-10-30.md) for the
signed fixture and independent source reviews; ARM execution remains separate.

Production used the previously qualified builder executable, SHA-256
`84ff56d75991408328db95d320968f74df1cabac2ac2b1f77eb57cb33fd469d7`.
The complete build took 76.885 seconds, sampled aggregate RSS 505,364,480 bytes,
observed shared-volume growth 362,074,112 bytes and zero reported swaps.
Guard and child exited zero with complete cleanup. Original limits remain
629,145,600 bytes RSS, 300 seconds, 1 GiB growth, 1 GiB reserve and the file cap.

The final media tool's complete artifact audit passed for all 2,106 canonical
classes and all 69 native-consumed canonical classes. UserManager is outside
that native set. All 69 canonical classes remain identical; the only raw native
input difference is the exact Layout canonicalization pair. The retained native
library, all 89 native sources, the 90-input map, JNI, C and 719 exports remain
exact, with its original Layout SDK provenance checked. No native build or
path-mapped relink was performed here.

Complete closed roots under `/Users/alex/.local/state/vinix/android` (`S`) are:

- `user-restrictions-framework-builder-2026-10-30-r1` (original qualification
  controls and original failed production controls).
- `combined-account-webview-user-restrictions-framework-2026-10-30-r1`
  (original incomplete, unadmitted SDK producer).
- `user-restrictions-framework-production-2026-10-30-r2` (original preflight
  refusal; the intended SDK output was never created).
- `combined-account-webview-user-restrictions-framework-2026-10-31-r3`
  (complete admitted SDK).
- `user-restrictions-framework-production-2026-10-31-r3` (fresh production controls).
- `current-native-build-2026-10-30-layout-alignment-r1` (retained qualified native).

The old r1/r2 failures remain unchanged and are described in the
[blocked checkpoint](user-restrictions-blocked-2026-10-30.md). No partial SDK was
recovered, resumed or admitted. The external integrity seal below includes the
failed producer bytes without making that incomplete producer admissible.
Historical complete bundles and their unchanged auditors remain required.

All six roots passed sealing and separate fresh-process complete readback:
16,753 entries, `S/user-restrictions-producers-sealed-2026-10-31-r3/sealed/manifest.json`,
SHA-256 `93dc4477755d8baa8a324b82e32582e2c2d4af04dfa7e3468d6289b9696d4dec`.
Seal/readback took 4.168/1.541 seconds with sampled RSS 24,920,064/23,920,640
bytes. Both guard/child exits were zero, cleanup complete and reported swaps zero,
under original 600 MiB/900-second/64 MiB growth/1 GiB reserve limits.

| Artifact | SHA-256 |
| --- | --- |
| Framework manifest | `2e3b4a212238fc14a47b6cc72d1abde24c95a26e379ecd79f99f54527314040c` |
| Framework build receipt | `9fbaa2abd500a9a922d7ff7674604a5d73067a18c09a4db8e6072928d7d5a157` |
| Framework JAR | `646a83ea74795fb29b4db8811fc3249add3693b6e2de03e043c52e4e13b09bdc` |
| Framework DEX | `c2b14de4404b9ded7489b2a168d14618baafd65190d8008c55b40f44c1b72950` |
| Retained native manifest | `ad1c44a5ac2f06925c19c02648d837263a9f1aa9661735b9e49e958193b80413` |
| Retained native build receipt | `e6d7ca1b38a82b2f7a15b018a1fef294356693207993c0966b6f291073967a0d` |
| Retained native DSO | `b6aeb06b7473220da8844015a253ed87394fef6209173c14317fcbaf19141e95` |
