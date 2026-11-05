# resilient-configuration


## ADDED Requirements
### Requirement: Atomic snapshot publication
Each Runtime API replica SHALL publish an immutable configuration snapshot as one atomic replacement.
#### Scenario: Updating runtime state
- **WHEN** a committed change is detected by a replica
- **THEN** requests receive either the complete old snapshot or the complete new snapshot, never mixed states

### Requirement: Convergence across replicas
The system SHALL periodically reconcile its in-memory snapshot with committed global revision.
#### Scenario: Missed notification
- **WHEN** a replica misses an optional change notification
- **THEN** periodic revision polling eventually reloads the committed configuration

### Requirement: Last known good on failure
The system SHALL serve its last successfully loaded snapshot during transient database failure, without inventing values.
#### Scenario: Database outage after warmup
- **WHEN** the database is unavailable but a valid snapshot exists
- **THEN** the Runtime API continues serving that snapshot and emits staleness metrics
#### Scenario: Cold start database outage
- **WHEN** a new replica starts with no valid snapshot and no database connection
- **THEN** readiness fails and runtime returns 503 rather than guessed flag values
