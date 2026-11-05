# Architecture and decision log

## Context
Central platform, one independent installation per environment. A flag has a single global Boolean state. Any permitted service receives identical values. JWT for runtime comes after MVP. No application ID in requests.

## Components
1. Angular UI — Admin API only.
2. Java Spring Boot — physically one deployable initially, logically separated Admin/Runtime controllers and security rules; horizontally scaled.
3. PostgreSQL — authoritative data, history and global revision.
4. In-memory immutable snapshot on each runtime replica.
5. Java SDK (reference) — HTTP snapshot + local last-known-good with caller defaults.

## Snapshot consistency
Transaction updates flag/history/global revision. Replicas poll revision and atomically reload complete snapshot. Eventual consistency between replicas is acceptable within measured propagation window. No distributed transaction or Redis in MVP.

## Environment isolation
Distinct deployments, distinct database and secrets, distinct ingress DNS. Configuration application selects no environment dynamically.

## Risks requiring tests
- Network partition means emergency disable may not propagate; do not use for authorization gates.
- DB outage before replica warmup means Runtime API unavailable on that replica.
- After DB failover, check revision monotonicity and cache refresh behavior.
- Routing private runtime on internet is an unacceptable MVP configuration.
- Admin endpoint auth cannot be postponed alongside JWT runtime auth.

## Proposed initial SLOs (to validate, not promises)
Runtime availability >=99.95% monthly; warmed-cache p95 response <50ms at an agreed workload; propagation p95 <=30s under healthy network; RPO/RTO to be defined by operations.
