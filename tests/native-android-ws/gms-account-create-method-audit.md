# GMS account creation's immediate SDK calls, 2026-10-30

A bounded follow-up to the [window system-UI caller audit](gms-window-system-ui-method-audit.md)
checks `atsn.b()` and `atsn.onCreate(Bundle)` for an immediately subsequent
missing framework API. It does not expand the field-only repair.

`atsn.b()` calls `gjbr.f(Window, boolean)` at DEX offset `0x11a`, `.line 283`.
The next instruction is `return-void` at `0x11d`. `onCreate` invokes its superclass,
calls `b()` and returns. There is no later immediate SDK operation in these
methods after the captured `systemUiVisibility` failure.

The other direct SDK signatures used by `b()` are present in the pinned framework:
`LayoutInflater.from` and `inflate(int, ViewGroup, boolean)`,
`Resources.getDrawable(int)`, `Context.getResources` and `getText(int)`, and
`Activity.setContentView(View)` and `getWindow`. The Android context ancestry
is Activity → ContextThemeWrapper → ContextWrapper → Context. `b()` has no
direct SDK field reference. This review does not prove transitive app-owned
callees, interface implementations, the concrete app hierarchy or later callbacks.

Paths below use `S=/Users/alex/.local/state/vinix/android`:

- Selected class: `S/gms-account-create-method-2026-10-30-r1/selected-atsn/atsn.smali`,
  SHA-256 `013aefc854b9aed7892cb402ebd752bfc3c82e58f8900d75bccba9619d77e099`.
- Commands and controls: `S/gms-account-create-method-controls-2026-10-30-r1`.
- Full 16-root, 10,027-entry seal and independent readback:
  `S/gms-account-create-method-evidence-2026-10-30-r1/sealed/manifest.json`,
  SHA-256 `82da02895332932d8e3e6d350647128a48d46145e420ea6c34839b205f915d9b`.

All fifteen retained class-definition listings identify exactly one owner for
`atsn`: `classes6.dex`, SHA-256
`879beeba4d39da968c7ca0b1649382e768c7a6998f842b2c4fed2bb4e0582220`.
The preceding complete GMS/framework evidence passed full readback before
extraction and remains bound by the new seal. Comparison uses the unchanged
ImageView-bounds framework manifest
`95853b2f31ac34f731c8c31fc1251fd695ed6d856a8bfef0f71041efc10273e0`.
Recorded checkout base was `d8c5fc7726458cb805e2df118a8109cd9b17fe59`;
concurrent successor edits were not extraction or comparison inputs.

Selected baksmali extraction used the pinned Java/tool closure, a 256 MiB heap,
two active processors, two jobs and one class selector. Its unchanged guard
retained 600 MiB aggregate RSS, 300 seconds, 512 MiB observed growth and a 1 GiB
reserve; it passed in 0.184 seconds at 103,890,944 bytes sampled RSS. Sealing and
fresh readback passed in 3.006/2.015 seconds with the same RSS/reserve caps,
900-second deadlines and 64 MiB growth limits. All guard/child exits were zero
and cleanup completed. No app or authentication behavior was changed or validated.
