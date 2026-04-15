#!/usr/bin/env bash
set -euo pipefail

# Runs drift-check.sh and, if drift is found, invokes an AI coding agent
# to update the SKILL.md files automatically.
#
# Supports: cursor-agent, claude, codex (auto-detected or via --agent flag).
#
# Usage:
#   ./scripts/drift-fix.sh <path-to-server.go> [--agent cursor-agent|claude|codex]
#   ./scripts/drift-fix.sh --from-ci [--agent cursor-agent|claude|codex]
#
# Examples:
#   ./scripts/drift-fix.sh /path/to/hoop/gateway/api/server.go
#   ./scripts/drift-fix.sh /path/to/hoop/gateway/api/server.go --agent claude
#   ./scripts/drift-fix.sh --from-ci
#   ./scripts/drift-fix.sh --from-ci --agent cursor-agent

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/../skills"
DRIFT_CHECK="$SCRIPT_DIR/drift-check.sh"

FROM_CI=false
SERVER_GO=""
AGENT_CLI=""

while [ $# -gt 0 ]; do
  case "$1" in
    --from-ci)
      FROM_CI=true
      shift
      ;;
    --agent)
      AGENT_CLI="$2"
      shift 2
      ;;
    -*)
      echo "Unknown option: $1"
      exit 1
      ;;
    *)
      SERVER_GO="$1"
      shift
      ;;
  esac
done

if [ "$FROM_CI" = false ] && [ -z "$SERVER_GO" ]; then
  echo "Usage: $0 <path-to-server.go> [--agent cursor-agent|claude|codex]"
  echo "       $0 --from-ci [--agent cursor-agent|claude|codex]"
  exit 1
fi

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

download_ci_report() {
  if ! command -v gh &>/dev/null; then
    echo "Error: 'gh' CLI is required for --from-ci. Install it: https://cli.github.com" >&2
    exit 1
  fi

  local tmpdir
  tmpdir=$(mktemp -d)
  echo "Downloading latest drift report from CI..."
  if ! gh run download --repo hoophq/hoop-skills --name drift-report --dir "$tmpdir" 2>/dev/null; then
    echo "Error: could not download drift-report artifact." >&2
    echo "Make sure the Skills Drift Check workflow has run and the artifact exists." >&2
    rm -rf "$tmpdir"
    exit 1
  fi

  if [ ! -f "$tmpdir/drift-report.txt" ]; then
    echo "Error: drift-report.txt not found in downloaded artifact." >&2
    rm -rf "$tmpdir"
    exit 1
  fi

  cat "$tmpdir/drift-report.txt"
  rm -rf "$tmpdir"
}

# --- Run drift check ---
DRIFT_OUTPUT=""
DRIFT_EXIT=0

if [ "$FROM_CI" = true ]; then
  echo "Fetching drift report from CI..."
  echo ""
  DRIFT_OUTPUT=$(download_ci_report) || DRIFT_EXIT=$?
  if [ "$DRIFT_EXIT" -ne 0 ]; then
    exit 1
  fi
  if echo "$DRIFT_OUTPUT" | grep -q "All routes are in sync"; then
    echo "$DRIFT_OUTPUT"
    echo ""
    echo "No drift detected. Nothing to fix."
    exit 0
  fi
  DRIFT_EXIT=1
else
  echo "Running drift check..."
  echo ""
  DRIFT_OUTPUT=$("$DRIFT_CHECK" "$SERVER_GO" 2>&1) || DRIFT_EXIT=$?
fi

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
VERIFY_HINT=""
if [ -n "$SERVER_GO" ]; then
  VERIFY_HINT="- After editing, run: bash scripts/drift-check.sh $SERVER_GO
- Confirm the check passes (exit code 0) before finishing."
else
  VERIFY_HINT="- You do not have access to server.go locally. Apply the changes listed in the drift report and double-check the edits manually."
fi

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
$VERIFY_HINT"

# --- Invoke agent ---
cd "$SCRIPT_DIR/.."
case "$AGENT" in
  cursor-agent) cursor-agent "$PROMPT" ;;
  claude)       claude "$PROMPT" ;;
  codex)        codex "$PROMPT" ;;
esac

# --- Verify fix ---
if [ -n "$SERVER_GO" ]; then
  echo ""
  echo "Verifying fix..."
  echo ""
  "$DRIFT_CHECK" "$SERVER_GO"
else
  echo ""
  echo "Skipping verification (no local server.go). Run drift-check.sh manually to confirm."
fi
