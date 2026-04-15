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
| `hoop-server-admin` | Server and organization admin controls | `/serverconfig/*`, `/orgs/keys*`, `/orgs/license*`, `/proxymanager/*` |
| `hoop-resources` | Resources, attributes, analytics endpoints | `/resources*`, `/attributes*`, `/search`, `/metrics/sessions`, `/reports/sessions` |

## Source of Truth

- Route registration: `hoop/gateway/api/server.go`
- Router/auth/roles: `hoop/gateway/api/apiroutes/`
- Shared middleware: `hoop/gateway/api/middleware.go`
- API types: `hoop/gateway/api/openapi/types.go`

## Coverage Note

These skills map to all routes registered in `buildRoutes()` in `hoop/gateway/api/server.go`.
