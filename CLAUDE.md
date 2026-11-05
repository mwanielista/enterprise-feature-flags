# Claude Code operating instructions — Enterprise Feature Flags

## Mission
Implement an enterprise-quality, self-hosted feature-flag service **from approved OpenSpec changes**. Work incrementally. Never claim production readiness without evidence.

## First actions on every session
1. Read `README.md`, `openspec/config.yaml`, current `openspec/changes/*/proposal.md`, `design.md`, `tasks.md`, `specs/**`, then `docs/architecture.md` and `contracts/openapi.yaml`.
2. Run `openspec status --change implement-mvp` and `openspec validate implement-mvp` if CLI is available. If unavailable, state why; never fabricate results.
3. Summarize current task, constraints, acceptance criteria and planned files before edits.
4. Prioritize the next unchecked task in `openspec/changes/implement-mvp/tasks.md`. Do not implement unrelated scope.

## Non-negotiable business contract
- Global BOOLEAN flags for one deployed environment; no per-app, tenant, user or rollout targeting in MVP.
- All business Admin and Runtime endpoints use **POST** and JSON body; never put keys, flags, credentials or sensitive data in query strings.
- Health/readiness/metrics are infrastructure endpoints and may use GET (Kubernetes/Prometheus require it).
- Distinct Admin `/api/v1/admin/**` and Runtime `/api/v1/runtime/**` paths.
- Runtime application identity does NOT affect which flags are returned.
- JWT for Runtime is deferred. MVP Runtime accessible ONLY on explicitly trusted private network; never expose unauthenticated runtime endpoint to public internet.
- Admin API is authenticated and restricted in MVP. Document trust boundary and fail-closed behavior.
- Unknown or archived keys: return explicit NOT_FOUND error, not silent false.
- Snapshot is globally versioned; identical committed version produces identical content.
- All mutations journaled atomically with history and config-version increment.
- For mutation consistency, use optimistic concurrency and `expectedVersion`.

## Technology
- Java 21+ + Spring Boot + Maven; PostgreSQL + Flyway; Angular + PrimeNG; Testcontainers + JUnit 5; Playwright.
- Local Caffeine/in-memory immutable snapshot; multi-replica invalidation or bounded polling as specified in design.
- Docker Compose for local; Kubernetes manifests/Helm for production; no Redis in MVP unless justified by ADR.

## Engineering workflow
- Specification before implementation. For new scope use `/opsx:propose`; inspect artifacts, request approval before applying.
- For this seeded change, implement via `/opsx:apply implement-mvp` in small vertical slices.
- Use subagents for focused review: `architect`, `backend-engineer`, `frontend-engineer`, `security-reviewer`, `qa-engineer`, `devops-engineer`.
- Add tests for positive, negative, concurrency and failure scenarios. Never silently skip failures.
- Maintain OpenAPI contract and actual implementation together.
- No fake backend behavior in frontend; test doubles only in tests.
- Use UTC ISO-8601 timestamps, RFC 9457 errors, structured logs, correlation IDs.
- Don't log JWTs, passwords, secrets, full request bodies or sensitive user data.
- No hard-coded secrets; supply `.env.example` only.
- Do not run destructive database commands, deployments, credential changes, force-push or deletion without explicit user approval.
- Never disable tests or weaken security merely to achieve a green build.

## Completion response format
For every completed task report: changed files; decisions; tests actually executed and results; unverified items; next task. Update tasks.md only for verified complete work.

## Conflict precedence
1. Explicit user request and security obligations
2. Accepted OpenSpec requirements/scenarios
3. Approved OpenSpec design
4. API contract
5. This file and coding conventions
If conflicts occur, stop and propose a spec/ADR correction rather than silently diverging.
