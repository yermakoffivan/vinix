# Layout stored-state getter producer, 2026-10-30

The additive `--layout-alignment` profile accepts only the complete Window
attribute framework baseline at
`/Users/alex/.local/state/vinix/android/combined-account-webview-window-animations-framework-2026-10-30-r1`:
manifest `19d67639dce414866deab4c3de57ac8576b5542dff6d58c8b0b78caf066f3e53`,
JAR `255718e8a943f8d3e276f99694c52ed5ec39af86d5d06abef3c9b14d7b9aa197`.
All 2,106 classes remain present. Layout alone gains two public/final methods:
`getAlignment()` and correctly spelled `getSpacingAdd()`. They expose the
existing constructor-supplied fields. The legacy `getSpacing_add` method,
constructors, fields, Builder behavior and all other classes remain unchanged.

Before assembly and after complete DEX disassembly, the producer checks the exact
two-method addition and public/final ABI. Its maintained focused tests reject
wrong method flags, changed or missing target classes, unrelated changes and
new/substituted classes. Existing producer self-tests remain enabled.

The final builder compilation and complete self-tests passed on their first
attempt under unchanged 600 MiB aggregate RSS, 300-second, 1 GiB reserve and
512 MiB observed-growth limits. Compilation took 2.685 seconds at 350,109,696
sampled RSS bytes; self-tests took 0.269 seconds at 1,245,184 bytes. Both guard
and child exits were zero with complete cleanup and zero swaps.

Complete qualification controls and source snapshot remain at
`/Users/alex/.local/state/vinix/android/layout-alignment-framework-builder-2026-10-30-r1`.
Builder source SHA-256:
`eb9a945f61ce0cd8a4e465b0822f86b2a381a5cede122b7bdee62dbde4825edb`.
Qualified builder SHA-256:
`86aca4e2c28707e45a6c4b861b02dc9a96d5d491330bba1839f02d5b0f701ae2`.
The checked SDK implementation is committed as `74968571b`.

Full framework/native production and the next ARM runtime validation remain pending.
