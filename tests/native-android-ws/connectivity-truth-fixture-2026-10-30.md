# Connectivity truth fixture, 2026-10-30

This signed standalone APK observes the existing bitmap runtime without changing
its SDK, native library or network state. It records the actual ConnectivityManager
service, active NetworkInfo null/connected/available/type/state, active Network,
all Networks and their capabilities/transports. It also queries capabilities for
a null active Network. A subclass exposes the inherited protected JNI
`nativeGetNetworkState()` as a read-only wrapper; it supplies no replacement state.
Real `java.net.NetworkInterface` enumeration reports names, isUp results and
numeric addresses from getHostAddress, with operational exception class/messages.

Observations are bounded to 32 networks, 32 interfaces, 64 addresses per interface
and 256 characters per value, with explicit truncation markers. Exceptions are
printed as data; linkage/verification errors propagate to the distinct FAIL path.
PASS means observation attempts completed, including honest offline/null/error
results. It does not mean connected, validated, reachable or authenticated.
There are no sockets, DNS requests, callbacks, pending intents or framework edits.

The target framework and native DSO remain respectively
`741641c30098cf2f682672889c7ac653c6b2f23b9c09001a7af8f56bb01d9500`
and `6969a813fbfe69cd882f3cb47760cb09cb106ca9aad748ea67ab93967aacad20`.
The intended live principal is already-provisioned GMS UID/GID 10013 with separate
fresh fixture data/home/surface; the fixture logs Process.myUid as an observation.
Actual ARM execution is pending and is not established by host qualification.

Working source was built over `436dc32e1a27df482d9e2ad55827c71cf7d9d12e`.
Final source SHA-256 is
`bc0ecc1b41617987744b4e42d1b93abd60d0eac22dc8a2a4c038cdbbc7678acf`.
The generator and fixture production passed under unchanged 600 MiB aggregate
RSS, 300-second, 512 MiB shared-growth and 1 GiB reserve caps. Guard/child exits
were zero with complete cleanup and zero swaps. Final compile took 3.289 seconds
at 326,893,568 bytes sampled RSS; signed production took 11.678 seconds at
104,939,520 bytes. Complete two-class DEX roundtrip, APK v3 signature and package/
launch-activity checks passed. The earlier signed r1 is preserved; r2 adds the
actual capabilities(null) query and is the selected artifact.

Paths below are relative to `/Users/alex/.local/state/vinix/android` (`S`):

- Selected APK: `connectivity-truth-fixture-2026-10-30-r2/probe.apk`, SHA-256
  `e562c6344c8560908a5d5cd70fa0480d76ea60ba6929e0720a2fbe69abba943d`.
- Complete preceding artifact: `connectivity-truth-fixture-2026-10-30-r1`.
- Controls/tools: `connectivity-truth-fixture-controls-2026-10-30-r1`.

All three closed roots passed sealing and separate fresh-process full readback:
100 entries, manifest `S/connectivity-truth-host-sealed-2026-10-30-r1/sealed/manifest.json`,
SHA-256 `324f88d942a92a8107b83c729fdf4d26225f91279ca5162223dcef4412e579df`.
Original 600 MiB/900-second/64 MiB shared-growth/1 GiB-reserve audit caps remained.
The exact marker is
`CONNECTIVITY-TRUTH-PASS observations active-info active-network all-networks capabilities interfaces raw-native`.
