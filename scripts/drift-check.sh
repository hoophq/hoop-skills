#!/usr/bin/env bash
set -euo pipefail

# Drift check: compares routes registered in server.go against routes
# documented in SKILL.md files. Exits non-zero when routes are missing
# from skills or skills reference routes that no longer exist.
#
# Usage:
#   ./scripts/drift-check.sh <path-to-server.go>
#
# Example:
#   ./scripts/drift-check.sh ../hoop/gateway/api/server.go

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/../skills"

if [ $# -lt 1 ]; then
  echo "Usage: $0 <path-to-server.go>"
  echo ""
  echo "Example:"
  echo "  $0 ../hoop/gateway/api/server.go"
  exit 1
fi

SERVER_GO="$1"

if [ ! -f "$SERVER_GO" ]; then
  echo "Error: file not found: $SERVER_GO"
  exit 1
fi

TMPDIR_WORK=$(mktemp -d)
trap 'rm -rf "$TMPDIR_WORK"' EXIT

SOURCE_ROUTES="$TMPDIR_WORK/source-routes.txt"
SKILL_ROUTES="$TMPDIR_WORK/skill-routes.txt"

# --- Extract routes from server.go ---
# Matches patterns like: r.GET("/path", ...  r.POST("/path", ...
# Outputs normalized lines: "GET /path"
grep -oE 'r\.(GET|POST|PUT|PATCH|DELETE)\("(/[^"]*)"' "$SERVER_GO" \
  | sed 's/r\.\([A-Z]*\)("\(.*\)"/\1 \2/' \
  | sort -u \
  > "$SOURCE_ROUTES"

SOURCE_COUNT=$(wc -l < "$SOURCE_ROUTES" | tr -d ' ')

# --- Extract routes from SKILL.md files ---
# Matches table rows like: | GET | `/path` |  or  | GET | /path |
# Outputs normalized lines: "GET /path"
grep -rohE '\| (GET|POST|PUT|PATCH|DELETE) \| `(/[^`]+)`' "$SKILLS_DIR"/*/SKILL.md \
  | sed 's/^| \([A-Z]*\) | `\(.*\)`$/\1 \2/' \
  | sort -u \
  > "$SKILL_ROUTES"

SKILL_COUNT=$(wc -l < "$SKILL_ROUTES" | tr -d ' ')

# --- Diff ---
MISSING_FROM_SKILLS="$TMPDIR_WORK/missing-from-skills.txt"
STALE_IN_SKILLS="$TMPDIR_WORK/stale-in-skills.txt"

comm -23 "$SOURCE_ROUTES" "$SKILL_ROUTES" > "$MISSING_FROM_SKILLS"
comm -13 "$SOURCE_ROUTES" "$SKILL_ROUTES" > "$STALE_IN_SKILLS"

MISSING_COUNT=$(wc -l < "$MISSING_FROM_SKILLS" | tr -d ' ')
STALE_COUNT=$(wc -l < "$STALE_IN_SKILLS" | tr -d ' ')

# --- Report ---
echo "=== Hoop Skills Drift Check ==="
echo ""
echo "Source routes (server.go):  $SOURCE_COUNT"
echo "Documented routes (skills): $SKILL_COUNT"
echo ""

EXIT_CODE=0

if [ "$MISSING_COUNT" -gt 0 ]; then
  echo "Routes in server.go NOT documented in any SKILL.md ($MISSING_COUNT):"
  while IFS= read -r route; do
    echo "  + $route"
  done < "$MISSING_FROM_SKILLS"
  echo ""
  EXIT_CODE=1
fi

if [ "$STALE_COUNT" -gt 0 ]; then
  echo "Routes in SKILL.md NOT found in server.go ($STALE_COUNT):"
  while IFS= read -r route; do
    echo "  - $route"
  done < "$STALE_IN_SKILLS"
  echo ""
  EXIT_CODE=1
fi

if [ "$EXIT_CODE" -eq 0 ]; then
  echo "All routes are in sync."
fi

exit $EXIT_CODE
