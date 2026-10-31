# Bounded coexistence with a foreign ARM guest, 2026-10-31

The ordinary browser runner correctly refused Maps startup while a separate
Debian build guest was running. The new explicit `start-coexisting ROOT PID`
mode permits one selected foreign ARM QEMU after bounded read-only admission.
Ordinary `start` and `start-ipv4` retain their strict guest check. The diagnostic
guest remains exactly 12 GiB/four CPUs with default user networking. Existing
ownership, stop, reconciliation and evidence-cleanup paths remain unchanged.
No foreign process is signalled or modified.

Both before and after media/engine hashing, admission records and checks the
foreign PID, start time, full command and actual executable path/hash. It rejects
additional system QEMU processes, including x86 guests, an audited QEMU binary
or references/aliases to the diagnostic repository/media. Only the supported
plain decimal `-m` and `-smp` grammar is accepted, with known headless host-CPU,
network-device and disk options. Duplicate/unknown options, hotplug/backing
memory, GPU host memory, drive cache-size properties and unsupported display
modes fail closed. Foreign resource paths remain regular and single-linked;
writable paths must be canonical. Readonly Homebrew path aliases may resolve
outside the audited roots. Resolved path/device/inode/mode/link identities must
remain stable across admission; ordinary external file content writes are allowed.

Aggregate declared guest RAM must be at most 32 GiB and at most one quarter of
physical host RAM; aggregate CPUs cannot exceed host logical CPUs. The host must
report normal memory pressure and at least 1 GiB free disk space. These are
admission snapshots, not continuous monitoring. Apple's sysctl exposes dispatch
pressure flags: normal is 1, despite the internal enum's different numbering.
See the [XNU sysctl conversion](https://github.com/apple-oss-distributions/xnu/blob/main/bsd/kern/kern_memorystatus_notify.c)
and [dispatch pressure constants](https://github.com/apple-oss-distributions/xnu/blob/main/bsd/sys/event_private.h).
The disk check parses bounded `LC_ALL=C df -kP` output and records the raw report.

Source is based on `643fdbe554f73ad7f4a0d187f078ea39de696a41`. The final source
SHA-256 is `cc9be5c0ebc5472f3f651eadc264f10b62262e179e66eef5d8250b420a7e82a4`.
The qualified executable is
`/Users/alex/.local/state/vinix/android/maps-coexist-runner-2026-10-31-r5/runner`,
SHA-256 `6d7fcdccda76a3d4637a9bad2785acc2af1e126574528b143af1b04768c161df`.
The existing compiler pin is
`0cc6c1d34c1811a818e4ae89853116861a4b067d4251af257851a7714f0d11fe`.

Final compilation, 86 new refusal/boundary controls, all original runner tests,
and actual read-only admission passed. The default CLI was also observed to
refuse the live foreign guest before creating launch evidence. Actual admission
selected Debian PID 91929, 16 GiB/four CPUs, with its separate Homebrew executable;
host samples were 128 GiB, 18 logical CPUs, normal pressure 1 and
124,408,238,080 free disk bytes. `admit-coexisting ROOT PID` performs this read-only
probe; no new VM was launched for host qualification. Independent source and
receipt review passed before runtime use.

| Final phase | Guard seconds | Sampled aggregate RSS bytes |
| --- | ---: | ---: |
| Compile | 8.552 | 454,279,168 |
| Complete self-tests | 1.674 | 18,022,400 |
| Actual read-only admission | 0.237 | 5,750,784 |

All positive guard/child exits were zero, cleanup complete, and process swaps
zero. Original caps remained 600 MiB RSS, 300 seconds, 512 MiB build growth,
1 GiB reserve and file-size limit; the read-only admission/seal phases use a
stricter 64 MiB growth budget. Earlier attempts remain intact: R1 rejected tuple
test syntax, R2 exposed the `/tmp` canonical-path fixture issue, and R3 exposed
new fixture files surviving into the legacy cleanup allowlist. R4 passed tests,
but its observed `os.disk_usage` value was implausibly about 31.9 TB; it was
rejected and replaced by the strict disk parser before any runtime use.

All ten original tool/control roots R1 through R5 remain beneath
`/Users/alex/.local/state/vinix/android`, named `maps-coexist-runner-2026-10-31-rN`
and `maps-coexist-controls-2026-10-31-rN`. Complete sealing and a separate fresh
readback passed for 43 entries, manifest
`maps-coexist-sealed-2026-10-31-r5/sealed/manifest.json`, SHA-256
`8f2b22857ada6d7eb7f72170c49ac580f7092dcb1abee8be5c25ac9a3868c1c8`.
Seal/check used the unchanged qualified sealer and original 600 MiB/900-second/
64 MiB-growth/1 GiB-reserve caps. Keep all complete originals and failed controls.
