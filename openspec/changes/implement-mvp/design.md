# MVP design

## Architecture
Angular UI -> Admin POST API -> Spring Boot service -> PostgreSQL.
Business application -> Runtime POST API -> immutable in-process snapshot.
Several Spring Boot replicas behind a load balancer share PostgreSQL but NOT cache memory.

## Data and transactions
Tables: `feature_flags`, `feature_flag_history`, `config_revision` (singleton monotonically increasing revision).
Flag key is immutable, uppercase snake case, unique; archived keys remain reserved.
Flags default disabled on creation. Every create/update/status/archive/rollback is a transaction that atomically updates flag, appends audit revision, and increments global config revision. Mutations include actor identity and a request correlation ID.
Concurrent mutation supplies `expectedVersion`; mismatch returns 409 CONFLICT and performs no write. `rollback` creates a new revision rather than rewriting history.

## Read consistency
Each replica builds a complete immutable snapshot `{revision, flags}`. Publish snapshot by atomic reference swap only after full successful load. Runtime never consults the DB per request.
Synchronize by polling global revision (baseline every 2-5 seconds, configurable) and reloading changed snapshot. Distinct clients may temporarily see different versions within documented propagation SLO. Optional PostgreSQL LISTEN/NOTIFY can accelerate refresh but polling MUST remain the reliability fallback; do not rely solely on NOTIFY.
If PostgreSQL is unavailable, serve last-known-good memory snapshot; readiness remains OK only while runtime can satisfy its declared snapshot freshness policy. If process starts without cached snapshot and DB unavailable, declare not ready; do not return fabricated states.

## API semantics
Admin and Runtime use POST + `application/json`. Explicit body for all business inputs. `snapshot` accepts `{}` and returns `{revision,generatedAt,flags}`; flags contains only nonarchived keys. Unknown/archived individual keys => 404 NOT_FOUND with Problem Details. Multi-check is atomic against one snapshot; any missing key causes the entire request to fail 404 with missing keys in safe structured extension. Keys deduplicated, nonempty and capped to 100.
Runtime API returns `Cache-Control: no-store` (POST-only), clients use snapshot revision for application-level change detection. No sensitive values in the URL.
Runtime API must be network restricted; Admin API requires actual authentication in MVP (OIDC preferred; locally configurable test-only dev auth only with production startup guard). JWT Runtime authentication will be implemented in a separate change, JWT transported in Authorization header.

## API failure model
400 invalid JSON/fields; 401/403 administrative auth errors; 404 unknown/archived key; 409 stale version / duplicate key; 429 rate limit; 503 no valid snapshot available. Use RFC 9457 with correlation ID. Server-generated IDs/version/timestamps.

## Consumer client
Use local immutable snapshot, cached on disk optionally (protect permissions and integrity). Configurable refresh every 15 seconds with timeouts, exponential backoff + jitter. On transport failure use last known good; on initial failure with no snapshot use caller-supplied default. Track staleness metric; documentation must warn that a central kill-switch cannot be guaranteed during network partitions.

## Availability
Reference topology: >=2 backend replicas distributed over independent nodes (prefer 3 across AZs), managed HA PostgreSQL, redundant ingress. Health and metrics GET endpoints are infrastructure exceptions. No Redis required. 99.95% monthly is a TARGET, not guaranteed. Document RPO/RTO and test failover.

## Security
Separate admin/runtime security filter chains. Admin restricted through organization SSO/OIDC or equivalent approved authenticating proxy. If only dev-mode auth is available, prohibit production enablement. CSRF protections appropriate for browser session; secure CORS, TLS, headers, secret injection. Runtime private network / NetworkPolicy, ingress policy and rate limiting. Flags are operational configuration, NOT authorization mechanism. No tokens in JSON body or logs.

## Open decisions
- Exact enterprise IdP and production OIDC discovery URL.
- Production PostgreSQL HA implementation and backup service.
- Initial p95 RPS/latency and maximum stale cache threshold under DB outage.
These are infrastructure parameters; do not invent them or mark related tests passed.
