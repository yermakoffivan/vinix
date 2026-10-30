# Layout getters ARM runtime and Maps avatar retry, 2026-10-30

The 84-case Layout regression passes on ARM, and Maps renders real labeled
North America tiles. The avatar now exits Maps with missing
`UserManager.hasUserRestriction(Ljava/lang/String;)Z`; the preceding Layout
getter failure is absent from this successor stack. No profile menu, account
UI or authentication success is established. Place search/photos were not
repeated on this pair; routes, GPS and navigation remain unverified.

The deployed getter fix is `74968571b`, fixture/caller sources `0051bcf55`,
[framework/native pair](layout-alignment-pair-2026-10-30.md) `5f6fe0a18`,
media profile `3429fedf9` and runner `5317b3d69`. Layout gains public/final
`getAlignment()` and correctly spelled `getSpacingAdd()`, reading existing
fields. Existing methods/fields, legacy getter, constructors, Builder behavior
and native renderer remain unchanged. JNI, generated C, native sources and
exports match the Window pair. The deployed DSO has new embedded header paths;
the pinned prefix-map relink recreates the complete predecessor binary.
No Google APK, account identity or network-state change was made for this fix.

Original artifacts remain under `/Users/alex/.local/state/vinix/android` (`S`):
prepared `maps-layout-alignment-r1` (`P`), controls
`maps-layout-alignment-prepare-2026-10-30-r1`, stopped guest
`maps-layout-alignment-vm-r1` (`VM`), audit
`maps-layout-alignment-runtime-audit-2026-10-30-r1` (`A`) and transfer
`layout-alignment-api-transfer-live-2026-10-30-r1`.

| Input | SHA-256 |
| --- | --- |
| Prepared `sha256.json` | `5e359cb61a16c70d08916e7b422c2729243871d42e747c8b30d13f34f76826e1` |
| Framework JAR | `162c77f853e6cb85f373493c40c302ff4df5b90ed52f2e6dce961e5e17281d01` |
| Actual native DSO | `b6aeb06b7473220da8844015a253ed87394fef6209173c14317fcbaf19141e95` |
| Original Maps APK | `6218d72f48b184eb71f68879bce48cb9ebb2b510be7f7cff88217ea3fd592bb2` |
| Signed fixture APK | `d0a5f8524c5d135cce08705946d72487947b637b0d7c1c7fa77994a323111fd6` |
| Exported fixture receipt | `5a054bffe98055288f397dea466365184c1d82a9519cc67d091d6ad77ec9bc8e` |
| Final controller receipt | `6247039d3ff514ed9503ab6f3b8ef2c7fe3201581fcf04d4c8bd2c4fbdbdd7cb` |

Preparation, fresh clone and frozen-kernel installation/readback passed in
340.602/13.302/90.464 seconds, sampled RSS
87,719,936/33,701,888/46,710,784 bytes. Original 600 MiB RSS/900-second/1 GiB
reserve caps remained enforced, with 4 GiB preparation and 2 GiB clone/kernel
observed-growth caps. Fresh owned QEMU PID 97724 used 12 GiB/four CPUs.
Both root terminals were opened before tests.

The [signed fixture](layout-alignment-fixture-run.md) ran once as dedicated
UID/GID 10130, `layout-check`, with exactly one protected fixture bind using
actual ro/nosuid/nodev/wxallowed/relatime flags. Child PID 44074 exited cleanly.
Six pins, eleven checks and one PASS/READY pair were verified. Unchanged
diagnostic SERVICE-QUERY import used a zero-removal plan; no byte repair or
unsupported strict fixture import is claimed. `A/fixture-validation.md` retains
the complete snapshot, receipt and child-log checks.

All 84 constructor cases pass across five enums and null, four StaticLayout
overloads, BoringLayout and a protected Layout subclass. Raw spacing checks
include signed zero, negative finite values, NaN payload, infinities, minimum
subnormal and maximum finite float. Repeated reads preserve text/Paint identity,
paint state and native metrics. Builder controls preserve the existing defaults
and inert setAlignment behavior. Conditional getLineBounds and documented
Builder limitations remain outside this fix. The fixture bind was released
and its absence verified before starting the broker.

After broker readiness Maps opened through its real launcher, then Skip.
`VM/layout-map-01.png` shows current labeled North America tiles. The avatar
click at 20:26:13 UTC exited Maps before the controlled stop. Private
`layout-avatar-error-private-01.png` and `layout-avatar-stack-private-01.png`
show the exact missing UserManager descriptor. Exact caller attribution is
covered by separate static work; no caller spelling is inferred from the
small-font screenshot. No successful avatar or account UI is claimed.

The protected stop was entered at 20:28:42 UTC, before the 15-minute bound.
Controller receipt start is 20:23:38, finish 20:28:45, status
`user-stopped-no-authentication-claim`, readiness true and empty error. Broker
exit 137 follows controlled cleanup; one survivor has unknown running/zombie
state. No clean broker exit or selected raw child wait event is claimed. Drain
records EOF true, status 1, 106,164 bytes and error number zero. Owned QEMU
received SIGTERM at 20:29:15; initial disappearance recording was refused,
then unchanged reconciliation recorded PID 97724 absent at 20:29:24 without
a second signal.

Strict account import passed: 25 entries, 2,835 chunks, 1,451,211 archive bytes,
SHA-256 `57e2877363240e93cf2bf68354cf42108f2aa79cc5fd16fe2e70e41908bb3be7`.
No reconstruction/removal was used. The exact 2,251,559-byte UART interval is
`6ea239105e78b7872c51da6c31198d11debc9253f1f58173ba00d42b92919ccf`;
its linked snapshot receipts and import metadata agree. Raw application logs
remain excluded from public UART except hashes and bounded private captures.

The nine original roots, including four adjacent VM clone sidecars, are closed.
The first seal attempt remains at
`S/maps-layout-alignment-runtime-sealed-2026-10-30-r1`: the unchanged 64 MiB
shared-growth guard stopped it at 110,387,200 observed bytes after 1.117 seconds,
guard 125/child 137, sampled RSS 7,847,936 bytes, cleanup complete. Its partial
outputs and original failed receipt are preserved.

Fresh retry `S/maps-layout-alignment-runtime-sealed-2026-10-30-r2` seals the
complete original nine roots plus the closed failed first-attempt controls:
ten roots, 598 entries. Its `sealed/manifest.json` SHA-256 is
`d62e9b090899c40ebff333e48723cccd40458e6ca46fb91091b0d8a098ceceff`.
Sealing and separate fresh-process full readback passed in 11.151/3.821 seconds,
sampled RSS 15,630,336/13,664,256 bytes. Both guard/child exits were zero with
complete cleanup and zero swaps under original 600 MiB RSS/900-second/64 MiB
shared-growth/1 GiB-reserve caps. The unchanged qualified sealer required no
compiler. All closed originals, earlier bundles and historical checkers remain
required and unchanged.
