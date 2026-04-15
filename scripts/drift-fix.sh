#!/usr/bin/env bash
set -euo pipefail

# Runs drift-check.sh and, if drift is found, invokes an AI coding agent
# to update the SKILL.md files automatically.
#
# Supports: cursor-agent, claude, codex (auto-detected or via --agent flag).
#
# Usage:
#   ./scripts/drift-fix.sh <path-to-server.go> [--agent cursor-agent|claude|codex]
#
# Examples:
#   ./scripts/drift-fix.sh /path/to/hoop/gateway/api/server.go
#   ./scripts/drift-fix.sh /path/to/hoop/gateway/api/server.go --agent claude

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/../skills"
DRIFT_CHECK="$SCRIPT_DIR/drift-check.sh"

if [ $# -lt 1 ]; then
  echo "Usage: $0 <path-to-server.go> [--agent cursor-agent|claude|codex]"
  exit 1
fi

SERVER_GO="$1"
shift

AGENT_CLI=""
while [ $# -gt 0 ]; do
  case "$1" in
    --agent)
      AGENT_CLI="$2"
      shift 2
      ;;
    *)
      echo "Unknown option: $1"
      exit 1
      ;;
  esac
done

detect_agent() {
  if [ -n "$AGENT_CLI" ]; then
    if command -v "$AGENT_CLI" &>/dev/null; then
      echo "$AGENT_CLI"
      return
    fi
    echo "Error: requested agent '$AGENT_CLI' not found in PATH." >&2
    exit 1
  fi

  for cmd in cursor-agent claude codex; do
    if command -v "$cmd" &>/dev/null; then
      echo "$cmd"
      return
    fi
  done

  echo "Error: no supported agent CLI found. Install cursor-agent, claude, or codex." >&2
  exit 1
}

# --- Run drift check ---
echo "Running drift check..."
echo ""

DRIFT_OUTPUT=""
DRIFT_EXIT=0
DRIFT_OUTPUT=$("$DRIFT_CHECK" "$SERVER_GO" 2>&1) || DRIFT_EXIT=$?

echo "$DRIFT_OUTPUT"
echo ""

if [ "$DRIFT_EXIT" -eq 0 ]; then
  echo "No drift detected. Nothing to fix."
  exit 0
fi

# --- Detect agent ---
AGENT=$(detect_agent)
echo "Drift detected. Using '$AGENT' to update SKILL.md files..."
echo ""

# --- Build prompt ---
PROMPT="You are in the hoop-skills repository at $(cd "$SCRIPT_DIR/.." && pwd).

The drift check found mismatches between server.go and the SKILL.md files under skills/.

Here is the drift report:

$DRIFT_OUTPUT

Instructions:
- For routes listed as '+ METHOD /path' (in server.go but NOT in skills): add them to the correct SKILL.md route table. Match the route to the right domain skill based on the URL prefix pattern.
- For routes listed as '- METHOD /path' (in skills but NOT in server.go): remove them from the SKILL.md that contains them.
- Keep the existing table format: | METHOD | \`/path\` | \`handler\` |
- If you cannot determine the handler name for a new route, use \`TBD\` as placeholder.
- Do not change any other content in the files.
- After editing, run: bash scripts/drift-check.sh $SERVER_GO
- Confirm the check passes (exit code 0) before finishing."

# --- Invoke agent ---
case "$AGENT" in
  cursor-agent)
    cd "$SCRIPT_DIR/.."
    cursor-agent "$PROMPT"
    ;;
  claude)
    cd "$SCRIPT_DIR/.."
    claude "$PROMPT"
    ;;
  codex)
    cd "$SCRIPT_DIR/.."
    codex "$PROMPT"
    ;;
esac

# --- Verify fix ---
echo ""
echo "Verifying fix..."
echo ""
"$DRIFT_CHECK" "$SERVER_GO"
