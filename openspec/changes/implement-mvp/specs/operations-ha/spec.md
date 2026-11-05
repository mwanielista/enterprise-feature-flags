# operations-ha


## ADDED Requirements
### Requirement: Multiple production instances
The production topology SHALL support at least two runtime replicas on separate failure domains and a failover-capable database.
#### Scenario: Replica failure
- **WHEN** a healthy production replica terminates
- **THEN** the service continues serving valid runtime requests through surviving replicas

### Requirement: Operational visibility
The system SHALL expose health and operational telemetry through infrastructure endpoints independent of POST-only business API rules.
#### Scenario: Kubernetes probe
- **WHEN** Kubernetes requests the readiness endpoint with GET
- **THEN** the backend reports whether it can serve a valid snapshot

### Requirement: Recoverable persistence
The platform SHALL document and test restoring PostgreSQL backups, including flag history.
#### Scenario: Recovery rehearsal
- **WHEN** an operator restores a backup to a recovery environment
- **THEN** the recovered flag states, revision and history are verifiable and RPO/RTO are measured
