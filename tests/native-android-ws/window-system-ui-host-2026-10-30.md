# Window system UI attribute, 2026-10-30

Google account creation advanced past the ImageView maximum-height lookup, then
failed in `gjbr.f` because `WindowManager.LayoutParams.systemUiVisibility` was
missing. The selected GMS method reads the current Window attributes, sets or
clears bit `0x400000`, and passes the attributes back to the Window.

The provider adds exactly `.field public systemUiVisibility:I`. The VM supplies
the ordinary integer default of zero in both existing constructors. All existing
methods and fields remain unchanged. The retained class has no copy constructor,
`copyFrom` or parcel implementation to update; this change adds none. Window's
existing attribute storage and native compositor behavior are preserved.

The checked [AOSP WindowManager source](https://android.googlesource.com/platform/frameworks/base/+/refs/heads/main/core/java/android/view/WindowManager.java),
blob `101d5c950b71344017d72112c759401185a88b80`, declares the deprecated attribute
as a writable public instance integer. Its full `copyFrom` implementation copies
the value; implementing that broader API is outside this field-only repair.

Validation used working sources over revision
`d8c5fc7726458cb805e2df118a8109cd9b17fe59`, against the complete baseline
`/Users/alex/.local/state/vinix/android/combined-account-webview-imageview-bounds-framework-2026-10-30-r1/new-dex`.
Controls, tools and complete focused outputs remain at
`/Users/alex/.local/state/vinix/android/window-system-ui-source-checks-2026-10-30-r1`.

The production-provider checker verifies the exact one-field source delta and
rejects sixteen malformed or repeated inputs without modifying them. Baseline and
patched API-28 DEX assembly/roundtrip cover `WindowManager.LayoutParams`,
`ViewGroup.LayoutParams` and `Window`: all constructors and existing methods stay
equal, the neighboring classes stay byte-identical, and no other class metadata
changes. Independent read-only review passed the provider, checker and fixture.

The final signed fixture is
`/Users/alex/.local/state/vinix/android/window-system-ui-fixture-2026-10-30-r2`.
It verifies both constructor defaults, signed integer boundaries, the captured
set/clear mask while preserving unrelated bits, instance isolation, public
nonstatic nonfinal `int` reflection, and actual Window get/set/replacement and
restoration. The Window check compares values rather than object identity and
preserves all available public attributes when preparing its replacement.
The original UI value is restored on normal completion and an assertion failure.
One-class canonical DEX roundtrip, APK v3 signature, package and launch activity
checks passed. ARM execution remains pending.

The first fixture production attempt stopped on a `const/4` operand outside its
signed four-bit range. Its diagnostics and partial outputs remain at
`/Users/alex/.local/state/vinix/android/window-system-ui-fixture-2026-10-30-r1`.
The corrected generator uses `const/16`; the final fresh R2 producer passes.

| Final check | Seconds | Sampled RSS bytes | Time maximum bytes |
| --- | ---: | ---: | ---: |
| Source checker compile | 1.342 | 333873152 | 344211456 |
| Provider/source/DEX check | 6.449 | 209272832 | 190611456 |
| Fixture generator compile R2 | 1.259 | 323059712 | 364822528 |
| Signed fixture production R2 | 22.988 | 96354304 | 96829440 |

Every final guard and child exited zero with complete cleanup, under 600 MiB
aggregate RSS, 300 seconds, 512 MiB observed growth and 1 GiB reserve. Time
reports recorded zero swaps. These host checks establish neither compositor
system chrome effects nor Google authentication or Maps imagery.

| Artifact | SHA-256 |
| --- | --- |
| Provider source | `53ace9c9ce0ffe519162cf8cb7dd0e80b23809061da22773cfbde6e2d88779c6` |
| Final source receipt | `b6135965c4eab6217f6706366075ad2b053a6b8ec8795b07be04b2366bc1fe60` |
| Fixture generator source | `2d65b9406ee22b29e854c07df210191543fa393fc8755b6292bb611f4f32793b` |
| Final fixture `build.json` | `87a370a782a8ae0caa1f059a1feb94b43bed65f229cccae64f4e14e448061130` |
| Signed `probe.apk` | `af7f9bfcb8f106c43f9d86badfa2c5e0deb49e3a1e6da19cbe68ab6a5254ca90` |

The exact marker is
`WINDOW-SYSTEM-UI-PASS defaults field-shape bitmasks instance-isolation window-attributes`.
Preserve all three original external roots, including the rejected R1 attempt.
