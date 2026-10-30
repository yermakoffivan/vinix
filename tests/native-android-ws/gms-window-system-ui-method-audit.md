# GMS account window system-UI caller, 2026-10-30

The live ImageView-bounds successor reached a new account-activity failure:
`NoSuchFieldError` for `WindowManager$LayoutParams.systemUiVisibility:I`, with
`gjbr.f` in the captured stack. This follow-up disassembles `gjbr` and its five
immediate decor-view helpers from the pinned root GMS APK. No app was patched.

`gjbr.f(Window, boolean)` selects a set or clear operation on mask `0x400000`.
Both operations obtain the existing window attributes, read and write the public
integer `systemUiVisibility` field, then pass the same object to `setAttributes`.
They use no other LayoutParams field, copy constructor or `copyFrom` method.
The pinned framework lacks this field. Its direct Window calls, including
attributes access and navigation/status-bar color setters, already resolve.

The helpers `gjbl`, `gjbm`, `gjbn`, `gjbo` and `gjbp` use `Handler` construction
and posting, `Window.peekDecorView` and `View.get/setSystemUiVisibility`; all these
methods exist in that framework. `peekDecorView` currently returns null
unconditionally, so the GMS helper retries three times and returns without
applying decor-view flags. That separate semantic limitation causes no missing
method error. Field retention addresses the captured linkage failure; this audit
does not validate Android system-bar behavior or Google authentication.

Let `S=/Users/alex/.local/state/vinix/android`:

- Extraction and review receipt: `S/gms-window-system-ui-method-2026-10-30-r1`.
- Commands and guards: `S/gms-window-system-ui-method-controls-2026-10-30-r1`.
- Full 13-root, 9,994-entry seal and separate-process readback:
  `S/gms-window-system-ui-evidence-2026-10-30-r1/sealed/manifest.json`, SHA-256
  `b927b1f3a5013f88d3dabfad9dedc647e20bf57f388356176e19b453041f0f2e`.

All fifteen retained class-definition listings identify `classes12.dex` as each
selected class's sole owner, SHA-256
`800e00e6d6dcab23de8d6fcdfa48c13c684806ab06b9b744e0d907a69b3e7f30`.
`selected-gjbr/gjbr.smali` is
`d25fa27f50bb12c8f1c24c3cb452c60279277ec43af9c2c23babad2064df97cb`;
the five helper files and all exact input bytes remain in the complete seal.
The earlier [ImageView caller evidence](gms-imageview-method-audit.md), including
the complete original GMS input audit and listings, passed full readback before
extraction. Java's identity remains
`236c86402d47923ebc974f8237175038eedfcb3b8a7594b2a2dd8113249b99ea`.

Comparison used the complete [ImageView framework producer](imageview-bounds-producers-2026-10-30.md)
with manifest `95853b2f31ac34f731c8c31fc1251fd695ed6d856a8bfef0f71041efc10273e0`.
Its original four-root producer seal passed fresh readback, and all four roots
remain bound by this audit's seal. Recorded checkout base was
`a9c7c95ae074bbc7cf1ab76b67edea316255b23a`; concurrently edited successor sources
were not extraction or framework-comparison inputs.

Both selected extractions passed unchanged 600 MiB RSS, 300-second,
512 MiB observed-growth and 1 GiB-reserve guards, with Java heap 256 MiB,
two active processors, two jobs and explicit class selectors. They took
0.345/0.228 seconds and peaked at 102,711,296/87,457,792 bytes sampled RSS.
Seal and fresh readback passed in 2.224/1.188 seconds under the same RSS/reserve
caps, a 900-second deadline and the stricter 64 MiB growth allowance. Every
guard/child exited zero with complete cleanup. Preserve the complete original
bundles; selected disassembly alone does not replace their historical checks.
