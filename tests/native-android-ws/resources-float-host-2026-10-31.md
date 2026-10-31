# Resources.getFloat host checks, 2026-10-31

Maps' profile path requested the missing Resources.getFloat(int) API. The
exact caller audit is separate; this report does not infer the requested
resource value from the earlier theme diagnostics.

The provider appends one public virtual nonnative method. It calls the
existing virtual getValue(id, TypedValue, true), accepts only TYPE_FLOAT,
and returns TypedValue.getFloat(). Every old method, field and neighboring
class remains unchanged. The [AOSP Android 10 contract](https://raw.githubusercontent.com/aosp-mirror/platform_frameworks_base/android-10.0.0_r47/core/java/android/content/res/Resources.java)
rejects other final types with `Resource ID #0x<id> type #0x<type> is not valid`
and preserves lookup failures. [TypedValue](https://raw.githubusercontent.com/aosp-mirror/platform_frameworks_base/android-10.0.0_r47/core/java/android/util/TypedValue.java)
reinterprets raw float bits without density conversion or scalar coercion.
The existing lookup handles resource references; the provider adds no parser
or resolver. Resources is one of the native producer's 69 consumed classes,
so coupled native provenance must be established separately before deployment.

Focused checks passed 20 malformed-input refusals and a complete 2,107-class
API-28 DEX roundtrip: exactly one method was added, all old Resources members
and metadata stayed exact, and all 2,106 neighboring classes stayed identical.
Independent provider and fixture register/branch/oracle reviews passed.

The signed fixture is
`/Users/alex/.local/state/vinix/android/resources-float-fixture-2026-10-31-r1/probe.apk`,
SHA-256 `59439180e4b2bff8c533689db5e4f6ba121406a3cb4950b3746f170a960a7d93`.
Its build receipt records source base
`c01f167cfc913940e9fbb8a9abaa0db7dd949720` and pins/copies both complete
generator sources, executable and tool inputs with before/after readback.
Exact two-class API-28 canonical DEX roundtrips, APK v3 signature and
package/activity checks passed. The signed APK dump preserves all 13 compiled
resource IDs/names and real reference targets. In particular,
`dimen/float_alias` (`0x7f030000`) references `dimen/float_positive`
(`0x7f030004`, value 1.25), and `dimen/float_alias_chain` (`0x7f030001`)
references the first alias. The dump also retains -2.5, both signed zeros,
unit-bearing wrong-type values and the dimension alias.
Independent review rehashed the signed APK, retained sources and receipts,
checked these compiled resource values/targets and passed the final artifacts.

The dedicated fixture contains Main and an overriding Resources subclass.
Thirteen packaged resources cover positive/negative floats, both signed zeros,
an alias and alias chain, plus dimension/fraction/integer/boolean/color/string
and wrong-type alias controls. Six positive cases independently check both
getFloat raw bits and getValue's resolved TYPE_FLOAT/data. Seven negative
cases check the original requested ID and resolved type in the exact rejection
message; zero and missing IDs must throw NotFoundException.

The subclass supplies ten raw float patterns, including a subnormal, maximum
finite value, infinities and quiet NaN payloads. Fifteen other type tags must
be rejected even when their data resembles a float. Each typed probe checks
one virtual lookup, the original identifier, resolveRefs=true and unchanged
type/data/metadata/string identity in the supplied TypedValue. Two lookup
exceptions retain their exact identities, followed by a successful recovery
probe. Expected exceptions are caught quietly, outside the assertion-failure
paths; generic runner health checks remain unchanged. PASS follows all cases.
These host checks do not claim an ARM pass, a working Maps menu or login.

| Qualified check | Guard seconds | Sampled aggregate RSS bytes |
| --- | ---: | ---: |
| Source driver compile | 1.371 | 337,674,240 |
| Provider/refusals/full DEX check | 20.871 | 411,860,992 |
| Fixture generator compile r2 | 2.988 | 338,673,664 |
| Signed fixture production | 16.260 | 104,644,608 |

Every qualified guard and child exited zero with complete cleanup and zero
swaps under the unchanged 600 MiB aggregate RSS, 300-second, 512 MiB observed
shared-growth, 1 GiB reserve and file-size caps.

Compiler attempt r1 is retained as a failed check with its exact source
snapshots: V rejected the host helper's `dump` parameter as a builtin
expression. Renaming that parameter and its one use to `resource_text`
left all generated Smali/XML/oracles unchanged. The fresh r2 compile and
production passed; no limits or runtime checks were changed. Final generator
source hashes are `main.v`
`c24196752152e35e2aca71dfa1e76b414d9f520286977f360ef80e6ec50523d0`
and `sources.v`
`5b03d0106ddfa8eb0a68398fe8b5103d6c383dcf569d2475e0ff84973f784b79`.

Six complete closed roots are retained beneath
`/Users/alex/.local/state/vinix/android`:

- `maps-resources-float-contract-2026-10-31-r1`.
- `resources-float-host-controls-2026-10-31-r1`.
- `resources-float-source-checks-2026-10-31-r1`.
- `resources-float-fixture-controls-2026-10-31-r1` (failed compile).
- `resources-float-fixture-controls-2026-10-31-r2`.
- `resources-float-fixture-2026-10-31-r1`.

Complete sealing and a separate fresh-process full readback passed for
9,075 entries. Manifest
`/Users/alex/.local/state/vinix/android/resources-float-host-sealed-2026-10-31-r1/sealed/manifest.json`,
SHA-256 `8f9af468651a785bb1804c3c7b874c058649e2c6f4ba742ffef996fe6f431109`.
The original seal/readback limits remained 600 MiB aggregate RSS, 900 seconds,
64 MiB observed shared growth, 1 GiB reserve and the same file-size cap. Both
guards/children exited zero with complete cleanup and zero swaps. Sealing
took 7.256 seconds at 24,412,160 sampled RSS bytes; readback took 1.872 seconds
at 23,904,256 bytes. Retain the complete original SDK and primary-source inputs
required by the historical checkers.

The marker is exactly
`RESOURCES-FLOAT-PASS packaged-floats aliases strict-types virtual-lookup raw-bits unchanged-values failures`.
