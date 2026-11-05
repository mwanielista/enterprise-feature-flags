# ADR-002: Local immutable snapshots with revision polling
Status: Accepted for MVP

No DB query per runtime read, no Redis initially. Each replica retains last-known-good immutable snapshot and polls PostgreSQL global revision. Commit sequence is serialized by update of the singleton revision row, then full snapshot reload is atomically published. Optional PostgreSQL NOTIFY is only an accelerator. During DB failure, stale snapshots are served with metrics; cold replicas are unready. Choose staleness policy and alert thresholds before production acceptance.
