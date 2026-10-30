# Maps broker output capture — 2026-10-30

The controller previously consumed at most one 4096-byte stdout block before
checking child liveness. Its cleanup closed the pipe without proving EOF, and
parsed/freed the capture before terminating the owned processes. A child exit
therefore could leave unread private diagnostic bytes. The observed account
failure's missing text is unknown; this fix does not assign its cause.

The controller now drains bounded live batches and, after owned termination,
reads the remaining pipe through `brokerlog.finish`. The final drain has a
two-second monotonic deadline and the existing 16 MiB private capture ceiling.
Only a zero-byte read proves EOF. The output buffer, private log and pipe remain
alive until final capture and numeric parsing finish; process close and buffer
free follow them. An inherited writer, capture error or limit produces a finite
numeric receipt and an incomplete result. Completion requires both
`status == brokerlog.eof` and `eof == true`; a previously recorded capture loss
remains a failure even if a later read observes EOF. The original broker-session
error takes precedence over a secondary final-drain failure.

`broker.log` and `maps.log` retain their existing private-only treatment. No
sidecar or raw application text was added to the export. The unchanged strict
collector validates receipt files as bounded opaque regular archive entries;
it has no receipt-key schema to extend.

The maintained controller self-test exercises a tail exceeding 4096 bytes,
exact private file contents, stable buffer identity/capacity, numeric tail
parsing, private sentinel exclusion from the receipt and archive, the failed
capture plus EOF combination, and original-error preservation. The separate
maintained `brokerlog` tests exercise actual children/pipes, inherited writers,
deadline/byte limits and read/write failures. Generated outputs and failed
attempts remain outside Git. This host change does not establish a working
Google account screen or successful authentication.

The complete controller host self-test passed in both retained
`maps-account-guest-build-2026-10-30-tail-drain-r2` and `-r3` bundles under
`/Users/alex/.local/state/vinix/android`. The controller source is
`4bb4835672ddcb7bb84aac50ae9b61104d213d28bf86f937c882c63cab129368`.
Independent review checked source and generated ARM C (r3 hash
`028c7f81940ff0502e82ac9abeb42202fc75d0eb3ee1f9619cd9878139b058e5`),
including every generated return's cleanup order and the stack read buffer.

The r2 ARM generator exceeded the unchanged 600 MiB aggregate guard at
632,963,072 bytes. The maintained builder now passes `-no-parallel` explicitly
to ARM discovery/listing/generation and self-tests that setting. Its existing
environment setup clears `VFLAGS`, so an ambient flag would not suffice.
The r3 producer peaked at 564,215,808 bytes; its generated C then exposed a
separate native poll pointer-type error, which remains preserved for the
helper's cross-platform correction. Neither compiler diagnostics nor caps were
relaxed. Guard receipts and logs are in
`maps-broker-tail-producers-controls-2026-10-30-r1`; final static ARM production
and the live guest check are separate follow-up validation.
