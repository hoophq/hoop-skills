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

## CI Workflow

A GitHub Actions workflow runs the drift check automatically when `server.go` changes.
The workflow lives at `.github/workflows/skills-drift.yml` in this repo.

**Triggers:**
- **`workflow_dispatch`** -- run it manually from the Actions tab, optionally passing a `hoop_ref` (branch/tag/SHA)
- **`repository_dispatch`** -- triggered from the `hoop` repo when `server.go` changes (event type: `server-go-changed`)

When drift is found the workflow fails and uploads the report as a `drift-report` artifact.

### Triggering from the `hoop` repo

Add a step to any `hoop` workflow that fires when `gateway/api/server.go` changes:

```yaml
- name: Notify hoop-skills
  if: contains(github.event.commits.*.modified, 'gateway/api/server.go')
  run: |
    gh api repos/hoophq/hoop-skills/dispatches \
      -f event_type=server-go-changed \
      -f 'client_payload[ref]=${{ github.sha }}'
  env:
    GH_TOKEN: ${{ secrets.HOOP_SKILLS_DISPATCH_TOKEN }}
```

## Auto-Fix with Agent

When drift is detected, an AI agent can update the SKILL.md files automatically.
The `drift-fix.sh` script runs the drift check and invokes the first available agent CLI.

```bash
# --- Local mode (you have server.go checked out) ---

# Auto-detect agent (tries cursor-agent, claude, codex in order)
./scripts/drift-fix.sh /path/to/hoop/gateway/api/server.go

# Use a specific agent
./scripts/drift-fix.sh /path/to/hoop/gateway/api/server.go --agent cursor-agent
./scripts/drift-fix.sh /path/to/hoop/gateway/api/server.go --agent claude
./scripts/drift-fix.sh /path/to/hoop/gateway/api/server.go --agent codex

# --- CI mode (download drift report from the latest workflow run) ---

# Requires the `gh` CLI to be authenticated
./scripts/drift-fix.sh --from-ci
./scripts/drift-fix.sh --from-ci --agent cursor-agent
```

The script will:
1. Run the drift check locally, or download the latest report from CI (`--from-ci`).
2. If all routes are in sync, exit with no changes.
3. If drift is found, pass the report to the agent with instructions to update the SKILL.md files.
4. Re-run the drift check to verify the fix (skipped in `--from-ci` mode without a local `server.go`).

## Publishing to npm

The package is published automatically via GitHub Actions when you push a version tag.

### Setup (one-time)

1. Create an npm access token at [npmjs.com/settings/tokens](https://www.npmjs.com/settings/~/tokens) (type: **Automation**).
2. Add it as `NPM_TOKEN` in the repo's GitHub secrets (**Settings > Secrets and variables > Actions**).
3. Make sure the `@hoophq` org exists on npm ([npmjs.com/org/create](https://www.npmjs.com/org/create)).

### Publishing a new version

```bash
npm version patch   # 1.0.0 → 1.0.1 (or use minor / major)
git push --follow-tags
```

`npm version` updates `package.json`, commits the change, and creates a `v1.0.1` git tag.
Pushing the tag triggers the `.github/workflows/publish.yml` workflow which runs `npm publish --access public`.

The workflow verifies that the tag version matches `package.json` before publishing.

### First publish (manual)

If the package has never been published, do the first one manually:

```bash
npm login
npm publish --access public
```

After that, all subsequent releases go through the CI workflow.

## Coverage

These skills map to all 171 routes registered in `buildRoutes()` in `hoop/gateway/api/server.go` at version 1.55.5.
