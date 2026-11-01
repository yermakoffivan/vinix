# Intent extras merge and account error content

Source baseline: `e9264bb6a`. The retained Dialog SDK has 2,108 classes,
manifest `a3547ad6477b3fb2eb7a9bcd7d73b8870c89a6bf69c4a84db03dc79e3222859f`.
Both `Intent.putExtras` overloads replaced and aliased the incoming Bundle.
They now follow the [Android 10 contract](https://raw.githubusercontent.com/aosp-mirror/platform_frameworks_base/android-10.0.0_r47/core/java/android/content/Intent.java):
the Bundle overload allocates an empty destination when needed and merges;
the Intent overload ignores absent source extras, copies them for an empty
destination, and otherwise merges. Incoming duplicate keys win. Null-argument
behavior matches Android 10, including allocation before Bundle.putAll.
Only these two existing method bodies change; getExtras, replaceExtras, fields,
native declarations and all other methods remain unchanged.

The [current account probe](maps-account-screen-runtime-2026-11-01.md)
records AccountIntro, WrapperControlled, PreAddAccount and ErrorActivity in that
order. The new exact GMS classes6.dex filter confirms that PreAddAccount's
result path calls inherited gt at offset0x36a/source875. In attg.gt, a nonnull
controller next Intent makes attf.a() true; the metadata Bundle is applied with
putExtras at0x13c/source317 before A then z starts the activity. The metadata
keys are ControlledActivity.session_id/session_index; atqc separately defines
title_text/error_message. Replacement therefore discards those existing error
fields before z can preserve them. The filter does not establish which preflight
check failed, network health, or authentication. No WebView change is involved.

The admitted GMS APK is
`a34d6a3ccea3ceba491369517e8f12e11df3791e86fec38b1cdf693785e35707`;
its retained classes6.dex is
`879beeba4d39da968c7ca0b1649382e768c7a6998f842b2c4fed2bb4e0582220`.
Complete source/caller evidence remains in
`/Users/alex/.local/state/vinix/android/gms-intent-extras-caller-audit-2026-11-01-r1`
and sibling controls, with before/after input readback. The guarded exact-class
filter passed in0.312seconds at113,049,600 bytes sampled RSS, exit0/cleanuptrue.
Keep the original complete APK/DEX extraction and historical bundles required
by their unchanged auditors.

Focused source and complete API-28 DEX checks passed 40 malformed/dependency
refusals before writes. All 2,108 classes survived; all 2,107 neighboring classes
and every other Intent method remained byte-identical. Independent review of
provider semantics, registers, branch handling and preservation passed.
Evidence is outside Git at
`/Users/alex/.local/state/vinix/android/intent-extras-source-check-2026-11-01-r2`.
The complete input/output receipt SHA-256 is
`ed021da116fc70214f0ac6c8e8de8f2319c49bd2b7279999d03d2bea239fbc35`.

| Artifact | SHA-256 |
| --- | --- |
| Intent provider | `830ae79f3a8ff97ec03fa61aae13a52282d65647cfe423dc9eb6077956e04f6b` |
| Framework registration | `f4756de6c6d4cd9fa3cbb1bc4a9350d45e3fba272377d6fed125e5a3e280b44f` |
| Patched raw Intent | `f3db222897beb3e6dd99bb2da605a5ee34cc2172bbdfc79019c4d82659d50de9` |
| Patched canonical Intent | `6400c9934837225aceef5285b5732d4ca09219f5c0c4692b2870f91b922de380` |

The successful audit took15.106seconds at390,987,776 bytes sampled aggregate
RSS and252,088,320 bytes observed shared-volume growth. Guard/child exits were
zero with complete cleanup and zero process swaps. Original limits remained
600MiB RSS,900seconds for this audit,512MiB growth,1GiB reserve,4MiB output and
shell file cap16777216. Its orchestrator compile also passed under original caps.

The complete r1 attempt remains preserved. Its source checks and assembly passed,
then its checker rejected baksmali's equivalent conditional/goto labels at one
instruction destination. Only the checker was corrected: it now rebases labels
to instruction positions while retaining every opcode, register and directive.
Positive alias and negative changed-target, duplicate-label and undefined-label
controls passed before the fresh r2. The runtime provider did not change.

Intent and Bundle are absent from the retained native69 input set. The subsequent
complete SDK/native audit must still prove compatibility. Signed behavioral ARM
and live account-content validation remain pending; no login success is claimed.
