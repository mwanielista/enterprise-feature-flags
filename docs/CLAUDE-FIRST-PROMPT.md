# First Claude Code prompt (copy into `claude` session)

Read `CLAUDE.md`, `README.md`, `openspec/config.yaml`, `openspec/changes/implement-mvp/{proposal.md,design.md,tasks.md}`, all delta specs, `docs/architecture.md`, and `contracts/openapi.yaml`.

1. Validate OpenSpec using the local CLI (if available) and fix only structural issues, explaining changes.
2. Review the acceptance criteria and list inconsistencies or unresolved platform decisions.
3. Propose a phased implementation plan with small vertical slices and exact verification commands.
4. Do NOT implement the app yet. Present the plan for approval.

After approval, use `/opsx:apply implement-mvp` or `/implement-next` for a controlled step-by-step execution.
