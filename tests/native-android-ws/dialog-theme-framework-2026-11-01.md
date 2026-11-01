# Dialog theme constructor host check

Source baseline: `bce3650a6606b5bd1d55d747d26a50c4d28c91dc`.
Runtime baseline: the retained PaintDrawable SDK, manifest
`15a60de7b8196aaca79d869cec972b0382da1be7327ee8f10c56b7e1db37cbb2`,
with 2,108 classes. The exact Maps caller and resource evidence is recorded in
[the dialog caller audit](maps-account-dialog-theme-audit-2026-11-01.md).

`Dialog(Context,int)` discarded its theme ID. It now selects
`android:dialogTheme` when the ID is zero, creates a `ContextThemeWrapper`, and
shares that context with its Window. This follows the
[Android 10 constructor contract](https://raw.githubusercontent.com/aosp-mirror/platform_frameworks_base/android-10.0.0_r47/core/java/android/app/Dialog.java).
The native initialization/pointer tail, fields, method signatures and all other
methods remain unchanged. No Maps attribute, style or color is special-cased.

The focused check passed 75 malformed/schema/dependency refusals before writes.
Complete baseline and successor API-28 DEX assembly/disassembly passed, retaining
all 2,108 classes and all 2,107 neighboring classes byte-for-byte. The constructor
retains seven registers and its complete native tail. Independent review passed.

Evidence is preserved outside Git at
`~/.local/state/vinix/android/dialog-theme-source-check-2026-11-01-r1/`.
`proof-check/receipt.json` pins source, tools, all baseline classes and outputs;
its SHA-256 is `85e20ba7d7aa93fb38336b3a852530f8460f7097628823d7beb770aca1d2af9d`.
The new Dialog raw/canonical SHA-256 values are respectively
`66a711e288271a52f5fe9d44b4fca75738ee882f60f869d12030c4ba3f8290f1`
and `fb1951defc731f6f52b907aaa81fd94272662e9a7348d1b2dbf6caee32a59042`.

The audit completed in 26.710 seconds with 412,483,584 bytes sampled aggregate
RSS, 131,420,160 bytes observed shared-volume growth, exit zero and complete
cleanup. Original limits remained 600 MiB RSS, 900 seconds for this audit,
512 MiB growth, 1 GiB reserve, 4 MiB logs and shell file cap 16777216.

Dialog belongs to the native generator's 69-class input set. A coupled framework
and native successor, behavioral ARM fixture, and live Maps profile retry remain
required before claiming runtime success.
