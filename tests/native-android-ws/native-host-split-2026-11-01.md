# Native host compilation under the existing memory cap

`b2aad79ed` separates V generation from host C compilation in
`build-current-native.v`. The previous combined process exceeded the 600 MiB
aggregate limit at 634,896,384 bytes. The pinned compiler's supported
`-no-parallel -generate-c-project` mode now exits before the emitted C command
runs. The compiler and output arguments are the only replacements in that
literal argv; shell syntax, response files and unclassified operands are
refused. All emitted C/object inputs, five project artifacts and the actual
host compiler are copied, pinned and checked before and after compilation.
The original imported-source and native generation checks remain in place.

Complete bootstrap qualification is retained at
`/Users/alex/.local/state/vinix/android/native-host-split-builder-2026-11-01-r2`.
Its actual imported-source/native-header capture contains 637 entries and
passed the original/copy recheck. Generation passed in 5.510 seconds at
528,875,520 sampled RSS bytes; separate C compilation passed in 4.828 seconds
at 286,359,552 bytes. Builder self-tests passed, including 21 malformed emitted
command cases. Earlier capability/setup controls, the superseded first
bootstrap generation and the input-capture tool remain in adjacent
`native-host-split-*` directories; the missing-parent probe refusal is preserved.

The complete Resources-float coupled native build then passed under the
unchanged 600 MiB/300-second/1 GiB-growth/1 GiB-reserve/file-size guards:

- Bundle: `current-native-build-2026-11-01-resources-float-r2` beneath that
  external state directory; manifest
  `c8a7134531f5fdfb6a8e484537a4eb798564fb039760ae9f82cc9a2045ba3062`.
- Build receipt: `c9c6a06637f8b4c9e53fea29caeeb07b8bae71033e364a9e8c09eaa57df476e6`.
- Native DSO: `441ae035ec4b69c36635cc4521af3fafcb6a867305b0ba25d6e55df7ff0dadc9`.
- Controls: `resources-float-native-controls-2026-11-01-r2`; 40.846 seconds,
  sampled aggregate RSS 552,468,480 bytes, observed shared growth 425,824,256
  bytes, both exits zero and cleanup complete.

The two failed predecessor attempts are retained and unqualified. The Oct31
attempt's monitor failed and did not establish cleanup despite later artifacts;
the Nov1-r1 attempt hit RSS and completed cleanup. The successful r2 does not
replace either failure. Native prefix-map equivalence, deployment and ARM/Maps
validation remain separate checks; this report makes no runtime or login claim.
