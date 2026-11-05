# runtime-evaluation


## ADDED Requirements
### Requirement: Separate POST-only runtime interface
The system SHALL expose business Runtime API operations using POST with JSON request bodies, independent of caller application identity.
#### Scenario: Single flag check
- **WHEN** a permitted client posts a known active flag key to `/api/v1/runtime/flag/check`
- **THEN** it receives the flag key, Boolean enabled value and snapshot revision
#### Scenario: Unknown flag
- **WHEN** a client checks a key that does not exist or is archived
- **THEN** it receives an explicit 404 Problem Details response, not a fabricated false value

### Requirement: Batch check from one revision
The system SHALL evaluate each batch against one consistent immutable snapshot.
#### Scenario: Valid batch
- **WHEN** a client posts up to 100 distinct known keys
- **THEN** it receives each Boolean state with a single snapshot revision
#### Scenario: Missing key in batch
- **WHEN** a batch contains an unknown or archived key
- **THEN** the complete request fails with a structured 404 response naming missing keys

### Requirement: Complete configuration snapshot
The system SHALL expose a globally versioned snapshot of all active global Boolean flags.
#### Scenario: Snapshot request
- **WHEN** a permitted client posts `{}` to `/api/v1/runtime/flags/snapshot`
- **THEN** it receives exactly the active flags and one monotonic revision
