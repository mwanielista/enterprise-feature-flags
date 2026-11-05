# flag-management


## ADDED Requirements
### Requirement: Global Boolean flag lifecycle
The system SHALL create uniquely keyed global Boolean flags with a default disabled state and immutable keys.
#### Scenario: Create flag
- **WHEN** an administrator creates a flag with a valid unused key
- **THEN** the flag is stored as disabled and visible to all authorized consumers of the environment
#### Scenario: Duplicate key
- **WHEN** an administrator creates a key that exists or is archived
- **THEN** the API returns 409 without creating another flag

### Requirement: Atomic versioned mutations
The system SHALL perform state changes with optimistic concurrency control and durable history.
#### Scenario: Valid status change
- **WHEN** an authorized administrator changes a flag with the current expectedVersion
- **THEN** the status, flag version, audit entry and global revision are committed atomically
#### Scenario: Concurrent update rejected
- **WHEN** a mutation supplies an obsolete expectedVersion
- **THEN** it fails with 409 without modifying the flag or history

### Requirement: Archive and rollback
The system SHALL archive flags without reusing keys and SHALL restore historical state through a new revision.
#### Scenario: Archive
- **WHEN** an administrator archives a flag
- **THEN** runtime queries no longer expose it and the history remains accessible
#### Scenario: Rollback
- **WHEN** an administrator restores a previous flag revision
- **THEN** a new history entry and a new monotonic revision are created
