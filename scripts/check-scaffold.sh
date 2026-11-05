#!/usr/bin/env bash
set -euo pipefail
for f in CLAUDE.md .claude/settings.json openspec/config.yaml openspec/changes/implement-mvp/proposal.md openspec/changes/implement-mvp/design.md openspec/changes/implement-mvp/tasks.md contracts/openapi.yaml; do
  test -f "$f" || { echo "missing: $f"; exit 1; }
done
python3 -m json.tool .claude/settings.json >/dev/null
echo "Scaffold files and Claude JSON valid."
if command -v openspec >/dev/null 2>&1; then
  openspec validate implement-mvp
else
  echo "OpenSpec CLI not installed: install then run openspec init --tools claude && openspec validate implement-mvp"
fi
