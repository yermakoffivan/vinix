# UserManager ARM failure and Maps profile retry, 2026-10-31

The UserManager fixture fails during Activity creation at its null-key control:
the existing BaseBundle boolean getter invokes String.equals on null. Maps,
tested separately, renders real labeled North America tiles, but the avatar
then exits with missing `android.content.pm.CrossProfileApps`. There is no
successful UserManager ARM regression, profile menu or authentication result.
Place search/photos, routes, GPS and navigation were not repeated on this pair.

The deployed API source is `ba7751ec7`, signed fixture `16c33479b`,
[qualified SDK/native](user-restrictions-pair-2026-10-31.md) `edf2c7599`,
fixture tools `26173db85` and [media tools](maps-user-restrictions-stage.md)
`643fdbe55`. UserManager gains fresh restriction snapshots for the documented
unmanaged backend and a virtual boolean query through Bundle. No policy writer,
administrator, managed profile, account identity or Google APK was added.
The retained native library is exact: all 69 consumed canonical classes remain
compatible, with only Layout raw formatting differing. No native rebuild or
relink was performed.

Original artifacts remain under `/Users/alex/.local/state/vinix/android` (`S`):

- Prepared `maps-user-restrictions-r1` (`P`).
- Controls `maps-user-restrictions-prepare-2026-10-31-r1` (`E`).
- Stopped guest `maps-user-restrictions-vm-r1` (`VM`).
- Audit `maps-user-restrictions-runtime-audit-2026-10-31-r1` (`A`).
- Transfer `user-restrictions-api-transfer-live-2026-10-31-r1` (`T`).

| Input or result | SHA-256 |
| --- | --- |
| Prepared `sha256.json` | `be3d6e5dcb7e8097f9fcf25290d9f6446d77b2aa9b80e649cc3c8d97195f461d` |
| Framework JAR | `646a83ea74795fb29b4db8811fc3249add3693b6e2de03e043c52e4e13b09bdc` |
| Retained native DSO | `b6aeb06b7473220da8844015a253ed87394fef6209173c14317fcbaf19141e95` |
| Original Maps APK | `6218d72f48b184eb71f68879bce48cb9ebb2b510be7f7cff88217ea3fd592bb2` |
| Signed fixture APK | `19f8715bcc6e5f19dff1dc11e031912907d7c762a7f1927b85dda697f447dbea` |
| Exact failed child log | `20d886218a4f21a233132032c1f8210d54050ce5ad4b48d6f251e2d0f92e7199` |
| Controller receipt | `ec894f7879bcbbc3cb9cdd952d4a6b8043bc7d163109892c77acc920fcd311ae` |

Preparation, fresh clone and frozen-kernel installation/readback passed in
433.176/11.122/63.271 seconds, sampled RSS
90,161,152/33,718,272/41,107,456 bytes. Original 600 MiB RSS/900-second/1 GiB
reserve caps remained enforced, with 4 GiB preparation and 2 GiB clone/kernel
growth caps. Preparation observed 2,177,671,168 bytes of shared-volume growth.

The legacy launcher initially refused before creating launch/ownership files
because unrelated Debian QEMU PID 91929 was running. The separately qualified
[explicit coexistence mode](../android-webview-browser-probe/coexist-runner-2026-10-31.md),
feature `1ab70d4b9`, then launched owned PID 82002 at 04:20:31 UTC. Its runner
SHA-256 is `6d7fcdccda76a3d4637a9bad2785acc2af1e126574528b143af1b04768c161df`.
The owned guest remained 12 GiB/four CPUs. Two admission snapshots verified the
foreign 16 GiB/four-CPU identity, combined 28 GiB/eight CPUs, 128 GiB host memory,
18 logical CPUs, normal pressure and disk reserve. No foreign VM was signalled
or modified by this test. These are admission checks, not continuous monitoring.

The original signed fixture ran as dedicated UID/GID 10131 with protected
inputs and one ro/nosuid/nodev/wxallowed fixture bind; actual relatime flags were
retained. It failed in the first direct-manager `base()` null-key control before
the context/backend assertions. The recovered log contains one
`USER-RESTRICTIONS-FAIL`, an Activity-creation failure and the BaseBundle null
String.equals stack through UserManager.hasUserRestriction. There is no PASS,
native readiness marker, successful runner receipt or completed six-pin/
eleven-check ARM result. The original APK and assertions were not changed.

`A/fixture-failure-validation.md` records preservation of all 9,860 failed-log
bytes. The guest-pinned hash above matches the diagnostic derivation from a
13,605-byte immutable UART interval, SHA-256
`50b5bacf6e3aaf0c7e05a4a40d872d888c0c0b6df4a04f8938ba38b176441fd7`.
Only base64 representation LF/CRLF separators are stripped; no decoded payload
is repaired. The complete original and seven-member derivation bundle remain
under `A/failed-fixture-decoded-r1`; this is not a SERVICE-QUERY protocol import.
The [maintained decoder](diagnostic-uart-base64.md) is committed as `e5a302b0c`.
Its two frozen tool/control roots passed sealing and independent readback,
manifest `S/diagnostic-uart-base64-sealed-2026-10-31-r1/sealed/manifest.json`,
SHA-256 `f36a8f0464790292492e5ae87392cd5e16c35908375a48fcfbb2746a34ed0a14`.

After the fixture bind was released and its absence captured, a separate
diagnostic Maps attempt reached broker readiness and Skip. `VM/restrictions-map-01.png`
shows current real tiles. The later avatar action exited Maps before controlled
stop; private `restrictions-avatar-error-private-01.png` and stack capture show
missing CrossProfileApps. The earlier UserManager missing-method error is absent
from this successor stack, but the standalone regression remains failed.
`restrictions-account-menu-01.png` is an exited-app screen, not a working menu.

Controller receipt start is 04:29:19 UTC and finish 04:39:43, status
`user-stopped-no-authentication-claim`, readiness true and empty error. Stop was
requested before the 15-minute bound. Broker exit 137 follows controlled cleanup;
one survivor has unknown running/zombie state. No clean broker exit is claimed.
Drain records EOF true, status 1, 107,677 bytes and error number zero. Owned QEMU
received SIGTERM at 04:40:07; unchanged reconciliation recorded PID 82002 absent
at 04:40:16 without a second signal.

Strict account import passed: 25 entries, 2,835 chunks and 1,451,223 archive
bytes, SHA-256 `ba805a614e0e877a9d772f3006d539d6e94d026527dd4aa2ae60ae6783e985d5`.
No reconstruction/removal was used. The exact 2,252,032-byte interval is
`64ee09e63f81041f6af4806b4319b4eddd17fc8b5a950c55aeafbe1290a2123a`;
linked snapshot receipts agree, and the stopped final UART matches its full
snapshot. Raw application logs remain excluded from this public export except
hashes and bounded private captures.

The nine original roots, including four adjacent VM clone sidecars, are closed.
Complete sealing and separate fresh-process full readback passed for 608 typed
entries, `S/maps-user-restrictions-runtime-sealed-2026-10-31-r1/sealed/manifest.json`,
SHA-256 `138ba1dc2b9e88f467427a5b6a5ddb64ddc7a92b51318454e45eb1e75ad9f728`.
Seal/readback took 8.669/3.392 seconds with sampled RSS 15,548,416/13,156,352
bytes. All guard/child exits were zero, cleanup complete and process swaps zero,
under unchanged 600 MiB RSS/900-second/64 MiB shared-growth/1 GiB reserve caps.
No seal attempt failed. The qualified sealer required no compiler. Retain all
complete original bundles, failed controls and their unchanged historical auditors.
