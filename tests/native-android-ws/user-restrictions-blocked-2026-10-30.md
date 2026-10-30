# User restriction runtime successor blocked by host disk, 2026-10-30

Implemented SDK source `ba7751ec7`, signed fixture/host report `16c33479b` and
qualified producer profile `28430e69b` are committed. The 45 refusal checks,
complete 2,106-class DEX roundtrip and signed two-class fixture passed. Fixture
APK SHA-256 is `19f8715bcc6e5f19dff1dc11e031912907d7c762a7f1927b85dda697f447dbea`.
These are host results; this UserManager successor has no ARM or Google
authentication result.

Paths below are relative to `/Users/alex/.local/state/vinix/android` (`S`).

- `combined-account-webview-user-restrictions-framework-2026-10-30-r1` is an
  incomplete original production attempt. API/class/JAR checks and `build.json`
  completed, but the original guard stopped during inventory at 132.391 seconds:
  observed shared-volume growth 1,144,741,888 bytes exceeded 1,073,741,824.
  Sampled RSS was 507,740,160 bytes, guard/child exits 125/137 and cleanup complete.
  There is no `sha256.json`, seal or artifact admission. Preserve the entire root.
- Original controls are
  `user-restrictions-framework-builder-2026-10-30-r1/produce.guard.json` and
  `produce.log`. Guard receipt SHA-256 is
  `73f24310849de57ead38c68f0e10ccaede0b1dc91c7fd739f32f736f6b61503a`.
- The fresh R2 preflight refused in 4 ms before starting a child: 2,138,071,040
  free bytes was 9,412,608 below the required 2,147,483,648. PID is zero,
  child status -1, guard exit 125, reason `disk growth budget`; no output was
  created at `combined-account-webview-user-restrictions-framework-2026-10-30-r2`.
  Controls remain in `user-restrictions-framework-production-2026-10-30-r2`;
  receipt SHA-256 `c49f050eddb90315f7941af4f4bfa21730ea04a9b76b76c98b48a997ab3d7155`.

Original SDK limits remain 600 MiB aggregate RSS, 300 seconds, 1 GiB observed
growth and 1 GiB reserve. Starting another SDK attempt requires at least 2 GiB
backing space. The last `df` sample was 952,328 KiB free and falling; no compiler
or owned VM is running. No limits were raised or disabled. Image preparation's
separate proposed 2 GiB growth cap still requires its 1 GiB reserve.

The pending media validator has passed independent static review: retain the
qualified Layout native library (`b6aeb06b...`, manifest `ad1c44a5...`) against its
original Layout SDK provenance, exclude UserManager from its 69 consumed classes
and require complete canonical equality of all 69 against the successor SDK.
Only Layout raw text is expected to canonicalize (`d91a460d...` → `8877258e...`).
There is no native rebuild or new relink proof. This validator and media/kernel
source remain unqualified and uncommitted, awaiting a sealed SDK.

Frozen source snapshot, relative to the repository root. The first three paths
remain unqualified and uncommitted. The batch helper and its tests are committed
as `347166341` after their guarded checks passed.

| Source | SHA-256 |
| --- | --- |
| `tests/native-android-ws/maps-user-restrictions-stage.v` | `5c984c7d5a4e5c97143a229deefb38b30ab59641883262cec2b8bba6e3827310` |
| `tests/android-webview-browser-probe/patch-kernel.v` | `26bca15266804940a20294c422883ce2326cac00b50b8ce3922cb6defa20e7d1` |
| `tests/native-android-ws/media-stage-inputs.v` | `89305d1e25f29d58ab9133d28652468a9fd1c70159a2e7f3fe2306a0878fe94f` |
| `tests/native-android-ws/mapsaccountstage/batches.v` | `24ad73ffdec2124b77cf8ab0d17d89de76f47dc97b2983d0264ddcfe29d37851` |
| `tests/native-android-ws/mapsaccountstage/batches_test.v` | `bb156d061e98eab48f59c654b94b3f70d686178dde6107a9539d1c8a287cb151` |

The focused 82-root batch tests passed; their complete original evidence remains
at `S/maps-user-restrictions-inventory-batches-tests-2026-10-30-r1`; sealing is
pending. The frozen media checkpoint is
`S/user-restrictions-media-checkpoint-2026-10-30-r1.txt`, SHA-256
`0e64706b73fcdac6d6519eae37b445d2ee31511c7ff3b329a09115dbfdaf09b2`. Restore host
space before a fresh bounded R2 production, then complete the actual SDK/native
compatibility audit and runner/media checks. Do not recover, resume or admit R1.
Keep all original complete bundles and failed controls.
