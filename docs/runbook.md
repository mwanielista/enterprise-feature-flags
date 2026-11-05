# Operations runbook template (complete during implementation)

## Alerts
No ready Runtime replicas, runtime 5xx rate, snapshot age > threshold, PostgreSQL failover, replication lag, audit write failures, abnormal mutation rate, auth failures.

## Incident response
1. Confirm ingress/runtime versus admin outage; query health and relevant graphs.
2. Inspect snapshot age/revision across replicas.
3. Check DB availability and HA failover state.
4. Recover via tested procedures; avoid deleting cache or resetting revision blindly.
5. During partition, acknowledge emergency toggles may not propagate.
6. Preserve audit logs and capture incident timeline.

## Recovery verification
Document actual backup method, retention, encryption, PITR, tested restore, measured RPO and RTO.
