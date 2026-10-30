# Absent persistent-data service producer profile — 2026-10-30

The additive `--persistent-data-block` framework profile uses the exact seed
options baseline: manifest
`470636b2812f339d58071ba59986282ac5107e5256aa2588dd9305d7ef5b45e9`,
JAR `cb2e3fabab652c65351da16770ae98c4113781df0830440b734395bb35b6f265`.
It changes only ContextImpl's public typed `getSystemService(Class)` method and
adds the public, nonfinal `android.service.persistentdata.PersistentDataBlockManager`
type with Object superclass and no members. The total class count is 2,106.

The existing named lookup remains null. The targeted typed lookup now returns
null before the generic reflective fallback. The added type supplies linkage
for the actual GMS null-service check-cast. It supplies no FRP state, service,
constructors, operations or permission changes. Other typed lookup behavior
retains its original method body.

Producer ABI checks run before assembly and after DEX roundtrip. Maintained
self-tests reject changed method flags, state fields, constructors, methods,
interfaces, private/final class flags, changed superclass, missing additions,
substituted classes and unrelated class changes. All existing producer tests
also passed. Both ContextImpl and the new type are absent from the 68 native
consumed classes; the separate native window guard has its own focused checks
and fresh coupled producer.

The qualified Boehm builder source and executable are retained under
`/Users/alex/.local/state/vinix/android/persistent-data-block-framework-builder-2026-10-30-r1`.
Compilation took 2.352 seconds and peaked at 349,044,736 sampled aggregate RSS
bytes, under the unchanged 600 MiB/300-second/1 GiB reserve/512 MiB observed
growth guards. Source SHA-256:
`28663eaeecb77308e9e01fb1edd00c53b3f7a49e054eee0b3feecea8c5a779ba`.
Qualified executable SHA-256:
`97de748ae41cde12fc1a68d58094082108998e812758ca3b3d873fc9d3e11a0a`.

The complete framework build passed in 43.807 seconds at 492,306,432 sampled
aggregate RSS bytes under the original 600 MiB/300-second/1 GiB reserve/1 GiB
growth guards. The producer pair report records its final artifacts and the
fresh native build. This profile establishes no Google authentication result;
the working map, photo and route runtime remains the comparison baseline.
