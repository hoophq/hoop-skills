# Hoop Gateway API Skills

Generic, agent-friendly skills for the Hoop Gateway API under `hoop/gateway/api`.
These skills are written as plain markdown so any coding agent can consume them.

## Installation

```bash
# Install into current project (.cursor/skills/)
npx @hoophq/hoop-skills

# Install globally for all projects (~/.cursor/skills/)
npx @hoophq/hoop-skills --global

# Install to a custom directory
npx @hoophq/hoop-skills --target ./my-skills

# List available skills without installing
npx @hoophq/hoop-skills --list
```

## Quick Start

1. Run the install command above.
2. Start with `hoop-api-overview/SKILL.md`.
3. Pick the domain skill that matches the endpoint you are changing.
4. Open linked files in each skill's `references/` folder for deeper details.

## Skill Index

| Skill | Covers | Main Routes |
|---|---|---|
| `hoop-api-overview` | Architecture, middleware, auth chain, route conventions | Global patterns |
| `hoop-auth` | Login and identity entry points | `/login`, `/callback`, `/saml/*`, `/localauth/*`, `/signup`, `/serverinfo`, `/publicserverinfo` |
| `hoop-users` | User and service account management | `/userinfo`, `/users*`, `/serviceaccounts*` |
| `hoop-connections` | Connection lifecycle and DB exploration | `/connections*`, `/connection-tags` |
| `hoop-sessions` | Session execution and lifecycle | `/sessions*`, `/plugins/audit/sessions*`, `/ws` |
| `hoop-reviews` | Reviews and access request rules | `/reviews*`, `/access-requests/rules*`, `/sessions/:session_id/review` |
| `hoop-plugins-runbooks` | Plugins and runbooks | `/plugins*`, `/plugins/runbooks*`, `/runbooks*` |
| `hoop-security` | Guardrails, data masking, audit logs | `/guardrails*`, `/datamasking-rules*`, `/audit/logs` |
| `hoop-webhooks-integrations` | Webhooks, Jira, AWS integration | `/webhooks*`, `/integrations/*`, `/dbroles/jobs*`, `/webhooks-dashboard` |
| `hoop-ai` | AI providers and rules | `/ai/session-analyzer/*`, `/orgs/features`, `/features/ask-ai/v1/chat/completions` |
| `hoop-server-admin` | Server admin, agents, org keys, proxy manager | `/serverconfig/*`, `/orgs/keys*`, `/orgs/license*`, `/agents*`, `/proxymanager/*` |
| `hoop-resources` | Resources, attributes, analytics endpoints | `/resources*`, `/attributes*`, `/search`, `/metrics/sessions`, `/reports/sessions` |

## Source of Truth

- Route registration: `hoop/gateway/api/server.go`
- Router/auth/roles: `hoop/gateway/api/apiroutes/`
- Shared middleware: `hoop/gateway/api/middleware.go`
- API types: `hoop/gateway/api/openapi/types.go`

## Versioning

Each `SKILL.md` declares the API version it documents (e.g., `> **API version**: 1.55.5`).
When the gateway releases a new version, update the skills and bump `package.json`.

## Drift Check

A script compares routes in `server.go` against what is documented in the skills.
It exits non-zero when routes are missing or stale, so it can gate CI.

```bash
./scripts/drift-check.sh /path/to/hoop/gateway/api/server.go
```

Example output when everything is in sync:

```
=== Hoop Skills Drift Check ===

Source routes (server.go):  171
Documented routes (skills): 171

All routes are in sync.
```

When routes diverge, the script lists exactly which routes were added or removed:

```
Routes in server.go NOT documented in any SKILL.md (2):
  + GET /new-endpoint
  + POST /new-endpoint

Routes in SKILL.md NOT found in server.go (1):
  - DELETE /removed-endpoint
```

## Auto-Fix with Agent

When drift is detected, an AI agent can update the SKILL.md files automatically.
The `drift-fix.sh` script runs the drift check and invokes the first available agent CLI.

```bash
# Auto-detect agent (tries cursor-agent, claude, codex in order)
./scripts/drift-fix.sh /path/to/hoop/gateway/api/server.go

# Use a specific agent
./scripts/drift-fix.sh /path/to/hoop/gateway/api/server.go --agent cursor-agent
./scripts/drift-fix.sh /path/to/hoop/gateway/api/server.go --agent claude
./scripts/drift-fix.sh /path/to/hoop/gateway/api/server.go --agent codex
```

The script will:
1. Run the drift check.
2. If all routes are in sync, exit with no changes.
3. If drift is found, pass the report to the agent with instructions to update the SKILL.md files.
4. Re-run the drift check to verify the fix.

## Coverage

These skills map to all 171 routes registered in `buildRoutes()` in `hoop/gateway/api/server.go` at version 1.55.5.
