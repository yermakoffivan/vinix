# Maps account dialog: exact theme caller audit

Baseline source: `61cc240960d0f859905c546fc273c192d5f61bdb`.
Admitted Maps APK SHA-256:
`6218d72f48b184eb71f68879bce48cb9ebb2b510be7f7cff88217ea3fd592bb2`.
This change adds maintained diagnostic tools and the caller finding. Runtime
validation of a successor framework remains necessary.

The profile failure `Failed to resolve SURFACE_CONTAINER_LOWEST` comes from
`brsj.a(cmbg)` looking up a null cached role. `cmbg.i` is that role, ordinal 8.
`brsj.g` maps it to `0x7f04021e` (`colorSurfaceContainerLowest`), through
`bvsa.ar` and `butc.s` to `Theme.resolveAttribute(attribute,value,true)`.
Returning false caches null; this exact path does not use TypedArray.

The account dialog explicitly requests the theme that supplies this role:

1. `bqpt.j(Bundle)` submits `bpbw(this,15)` through its DI readiness queue.
   `bpbw.run`, branch 15, loads `0x7f15036a` at offset `0x60`/source 97 and
   calls `Las.og(0,0x7f15036a)` at `0x63`/source 100. This stores the theme
   returned by `Las.rX`.
2. `bqpt.vm -> Ley.vm -> Lex(Context,int) -> Lpd(Context,int)` passes that
   nonzero theme unchanged to `android.app.Dialog(Context,int)`.
3. `Las.oB` calls `Dialog.getContext()` at `0x62`, then
   `LayoutInflater.cloneInContext` at `0x66`/source 103.
4. `bqpt.P` inflates the account root with that inflater's Context and its
   optional overlays. Its view callback passes the root to `bmgx`, whose
   branch 14 calls `brsj.g(rootView.getContext(),...)` at `0x147`/source 328.

Theme `0x7f15036a` is `OneGoogle.Dialog.Bento`. Its parent chain is
`0x36a -> 0x36f -> 0x371 -> 0x370 -> 0x8c6`, all with prefix `0x7f150000`;
the last is `Theme.GoogleMaterial3.DayNight.Dialog`. Its light branch ends
at `0x7f150119`, which directly defines `0x7f04021e` as color resource
`0x7f060355`; the night branch ends at `0x7f150115`, defining `0x7f060324`.
These supplying bags are unversioned. The exact APK manifest separately
declares application theme `0x7f150283` and MapsActivity theme `0x7f15028a`.

The fresh qualified aapt2 dump has 47,428,908 bytes and SHA-256
`857ee8106383820b7a8d5b1b12621baf7f3a40581e28e56aa77ee2931ae60a02`.
It exactly matches the existing `build/android-maps/resources.txt`, establishing
that dump's provenance. APK, aapt2 and previous dump hashes stayed unchanged.

`maps-theme-binding-caller-select.v` embeds all ten admitted DEX hashes,
selects exact resolver/binding/dialog-style method descriptors, and bounds
each DEX to 64 candidate classes. It conservatively scans invoke code units;
canonical filtered baksmali establishes actual callers. Its self-test covers
descriptor and invoke selection, endian reads and ULEB parsing.
`maps-theme-resource-dump.v` pins APK and aapt2, streams resource output to a
fresh external root, and records before/after input and output hashes. Its
self-test covers literal arguments, the exact cap, overflow, nonzero exit,
and hash readback. Both self-tests and the complete pinned scan passed.

All producers ran serially after the VM stopped, under the original 600 MiB
RSS/300-second/512 MiB growth/1 GiB reserve/4 MiB log guards and file cap
16777216. The resource stream also has a 64 MiB internal cap. Its successful
capture used 411,680,768 bytes sampled RSS and 111,857,664 bytes observed disk
growth in 26.089 seconds, with complete cleanup. No guard was widened.

Complete external evidence lives under `~/.local/state/vinix/android/`:

- `maps-profile-surface-caller-audit-2026-11-01-r1` and sibling `controls`:
  original role and resolver captures; controls manifest SHA-256
  `92cc69c575d9b8748b52ed38b780fa75f83308faca2ae4207f73ea958704d8da`.
- `maps-theme-binding-selector-2026-11-01-r1`: initial selector snapshot,
  canonical context/dialog captures and exact manifest/XML dumps; artifact
  manifest SHA-256 `fbb7f7335702a342fb9296c8f3bd8bbe8b1a014953f7234f91e45b49dcac9b62`.
- `maps-theme-binding-selector-2026-11-01-r2`: final source snapshots, binaries,
  receipts, scan, canonical style callers, complete resource dump and detailed
  audit; artifact manifest SHA-256
  `def5ae454d990a04b2505bcc9ad27503e14038bcf359e09502413bdb981ff06e`.
