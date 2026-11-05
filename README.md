# Enterprise Feature Flags — spec-first Claude Code starter

**Status: planning scaffold, NOT a working application.** This repository contains a ready-to-use OpenSpec change, API contract, architecture and Claude Code agent instructions. Claude Code is expected to generate the application following `openspec/changes/implement-mvp/`.

## Prerequisites (macOS/Linux)
- Git, Java 21+, Maven, Node.js LTS, Docker (with Compose), kubectl (production only)
- Claude Code installed and authenticated: https://code.claude.com/docs/en/overview
- OpenSpec CLI: https://openspec.dev/docs/installation

## Start
```bash
unzip enterprise-feature-flags-starter.zip
cd enterprise-feature-flags
git init
# Install OpenSpec (if not installed):
curl -fsSL https://openspec.dev/cli/install.sh | sh
# Install OpenSpec-native Claude Code skills/commands:
openspec init --tools claude
openspec validate implement-mvp
claude
```

In Claude Code, first ask: `Read CLAUDE.md and openspec/changes/implement-mvp. Review the architecture and OpenSpec artifacts, validate them, then propose an implementation plan without writing code.`

After reviewing, execute `/opsx:apply implement-mvp` (or `/openspec-apply-change implement-mvp` if only skill aliases are available). Check tasks, tests, and commits per phase. After release and verification, execute `/opsx:archive implement-mvp`.

**Important**: Run `openspec init --tools claude` AFTER extracting. This intentionally delegates generation of official OpenSpec skills and slash commands to the installed CLI instead of bundling potentially obsolete generated copies. The starter's own `.claude/agents` and `.claude/commands` remain separate.

## Product decisions
- One independent deployment per environment, global Boolean flags in that deployment.
- Any permitted consumer sees the same flags; no application registry or targeting.
- POST-only **business APIs** with JSON request bodies; infrastructure endpoints (health/metrics) retain conventional methods.
- Admin API separated from Runtime API; no JWT for runtime in MVP (trusted private network only). Admin access must be secured from day one.
- Future JWT Authorization header, never token in body.
- Unknown/archived flags explicitly return error; clients choose a safe default.
- Fail-open in availability of configuration reads from last good snapshots, not fail-open for authorization or business security.

## Repo map
- `CLAUDE.md`: mandatory execution rules for Claude Code
- `.claude/agents/`: scoped subagents
- `.claude/commands/`: custom prompts for phase execution and review
- `openspec/config.yaml`: project context and artifact rules
- `openspec/changes/implement-mvp/`: proposal, design, delta specs, tasks
- `docs/`: architecture, API decisions, operational and security expectations
- `contracts/openapi.yaml`: illustrative contract to implement and validate
- `backend/`, `frontend/`, `client-java/`, `infra/`: future code roots

## Definition of done
An MVP is done only after executable backend and frontend, Flyway migrations, a Java consumer client, unit/integration/E2E tests, local Docker Compose, production manifests, monitoring and resilience validation exist. This scaffold does **not** claim completion.
