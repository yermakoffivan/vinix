# Window system-UI fixture tools, 2026-10-30

`onboarding-api-run.v --window-system-ui` selects the signed
`WindowManager.LayoutParams.systemUiVisibility` field regression and its exact
coupled framework/native pair. Protected fixture setup, bounded child lifetime,
single PASS/readiness checks and clean exit requirements remain unchanged.
Transfer selector `serve --window-system-ui-api` serves only
`/window-system-ui-api-run` and `/window-system-ui.apk`.

The exact marker is:

```text
WINDOW-SYSTEM-UI-PASS defaults field-shape bitmasks instance-isolation window-attributes
```

Paths below are relative to `S=/Users/alex/.local/state/vinix/android`.
Actual artifacts were rehashed before pinning:

| Input | Path below S | SHA-256 |
| --- | --- | --- |
| Signed APK | `window-system-ui-fixture-2026-10-30-r2/probe.apk` | `af7f9bfcb8f106c43f9d86badfa2c5e0deb49e3a1e6da19cbe68ab6a5254ca90` |
| Framework JAR | `combined-account-webview-window-system-ui-framework-2026-10-30-r1/api-impl.jar` | `3f0d220a24e7d91a47f7b2d42cd5620aa498981e915a90cdbd806164b8ef0fc1` |
| Native DSO | `current-native-build-2026-10-30-window-system-ui-r1/native/libvinix-android-native.so` | `c97862ecb4eba730290a832b2766d58c1552ddf58ae40f77d7e140e69538ce75` |

The runner selftest rejected 545 malformed, duplicate, mixed-profile and failure
cases, including 42 actual malformed-CLI refusals. Transfer selftests preserve
pin/snapshot/binary/HTTP/deadline checks and add ten malformed-selector/port
refusals without output creation. Independent selector review passed. ELF
inspection confirms a static AArch64 executable without an interpreter.
Historical selectors, pins and routes remain unchanged.

All five checks passed sequentially with 600 MiB aggregate RSS, 300 seconds,
512 MiB observed shared-volume growth and 1 GiB reserve. Every guard recorded
child/guard exit zero and complete cleanup; timing reports recorded zero swaps.

| Check | Guard seconds | Sampled RSS bytes | Timing maximum bytes |
| --- | ---: | ---: | ---: |
| Host runner compile | 3.380 | 342867968 | 364691456 |
| Runner selftest | 0.862 | 22052864 | 17743872 |
| Static ARM runner compile | 4.927 | 367509504 | 358907904 |
| Host transfer compile | 4.450 | 352829440 | 362201088 |
| Transfer selftest | 0.729 | 7815168 | 9191424 |

The ARM runner is `S/window-system-ui-api-run-2026-10-30-r1/run`, SHA-256
`d10f94b3ecfe3f90b397e31504f79a4654f52779369af039f6e7e98ecd3bdc97`.
The transfer is `S/window-system-ui-api-transfer-build-2026-10-30-r1/transfer`,
SHA-256 `d9c8b581cddb870e135c80708481756fb90e5504c2a97e62cf0972ef2df8217a`.
Runner/transfer source hashes are respectively
`1e4a5f90a887f51d0e9c9cea82efb83c1a6d8767fd2e1950283f8b69ff7b9881`
and `04f3abb9e8e4ef4d92f24bf0e20bc10a1ad76174f954f903918ce070f48e2edc`.
The captured checkout base is `e8f6da223d6e5387b7134c4972d42f8daa46b1f7`;
exact changed sources, commands, input/tool hashes and check results remain in
the runner build, transfer build and transfer control roots.

The complete four-root, 34-entry seal and independent fresh-process readback
passed: `S/window-system-ui-api-tools-sealed-2026-10-30-r1/manifest.json`,
SHA-256 `34635ae160fbb211f44a062f525e5dc4880a26993130c81f8cca07efbc8a42ef`.
Both checks retained 600 MiB RSS, 300 seconds, 64 MiB observed shared-volume
growth and 1 GiB reserve, with exit zero and complete cleanup. All roots are
closed; their original producer bundles remain required for input auditing.
This qualification establishes host checks and static ARM readiness only.
ART execution, rendered UI and Google authentication require runtime evidence.
