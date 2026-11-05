# Implementation checklist (ordered)

## 1. Foundation and contracts
- [ ] 1.1 Review design/security assumptions; add ADRs for POST-only and consistency; document open decisions.
- [ ] 1.2 Finalize OpenAPI schemas, error model, limits and examples; validate specification with a parser.
- [ ] 1.3 Create backend Spring Boot/Maven and frontend Angular/PrimeNG scaffolds with pinned supported versions.
- [ ] 1.4 Provide local Docker Compose PostgreSQL and developer commands (no shipped default production credentials).

## 2. Persistence and administration
- [ ] 2.1 Flyway migrations for flags, immutable history and global revision; constraints/indexes.
- [ ] 2.2 Transactional create/update/status/archive/rollback with expectedVersion and actor metadata.
- [ ] 2.3 Admin API validation, pagination/filtering, RFC 9457 errors and OpenAPI contract tests.
- [ ] 2.4 Secure Admin API (SSO/OIDC or explicit approved mechanism), project-independent role policy and negative authorization tests.
- [ ] 2.5 Integration tests with PostgreSQL Testcontainers incl. rollback and concurrent stale writes.

## 3. Runtime and cache
- [ ] 3.1 Immutable snapshot model, initial load and atomic publish.
- [ ] 3.2 Revision polling, synchronized refresh, retry and bounded consistency across replicas.
- [ ] 3.3 Implement POST check, batch and snapshot endpoints; missing/archived behavior.
- [ ] 3.4 Ensure no SQL per cached runtime request; benchmark and test multi-replica divergence/convergence.
- [ ] 3.5 Implement no-snapshot fail-closed 503 and last-good snapshot on DB failures; tests.

## 4. Angular administration
- [ ] 4.1 Create flag list/search/filter/pagination screen and empty/loading/error states.
- [ ] 4.2 Create/edit/status/archive dialog with validation and confirmation.
- [ ] 4.3 History view and rollback flow; conflict feedback, session handling and accessible controls.
- [ ] 4.4 Frontend unit/Playwright tests against real API in test environment.

## 5. Consumer Java library
- [ ] 5.1 Implement typed check, batch, snapshot load and caller-supplied defaults.
- [ ] 5.2 Add refresh scheduling, timeouts, backoff/jitter and atomic cache replacement.
- [ ] 5.3 Test offline startup, stale state, API outage, recovery and malformed snapshot.
- [ ] 5.4 Create executable example integration and usage instructions.

## 6. Operations and acceptance
- [ ] 6.1 Container build, Kubernetes Deployment/Service/Ingress/NetworkPolicy/PDB/topology constraints.
- [ ] 6.2 Metrics, dashboard template, alert rules, structured logs and health checks.
- [ ] 6.3 CI pipeline: compile, unit, integration, contract, UI, dependency checks.
- [ ] 6.4 Load test against agreed workload and document actual p95/error rates.
- [ ] 6.5 Fault-injection: one replica down, DB outage/failover, rolling update, cold start without DB.
- [ ] 6.6 Backup/restore test, RPO/RTO results, secure release runbook, acceptance matrix.
- [ ] 6.7 Human sign-off on observed test evidence, then archive the OpenSpec change.
