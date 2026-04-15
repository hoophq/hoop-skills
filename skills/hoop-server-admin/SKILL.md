# Hoop Server Admin Skill

> **API version**: 1.55.5

Use this skill for server configuration, organization keys/license operations, agent management, and proxy manager endpoints.

## Primary Files

- `hoop/gateway/api/serverconfig/`
- `hoop/gateway/api/orgs/`
- `hoop/gateway/api/agents/`
- `hoop/gateway/api/proxymanager/`
- `hoop/gateway/api/server.go`

## Route Coverage

| Method | Path | Handler |
|---|---|---|
| POST | `/agents` | `apiagents.Post` |
| GET | `/agents` | `apiagents.List` |
| GET | `/agents/:nameOrID` | `apiagents.Get` |
| DELETE | `/agents/:nameOrID` | `apiagents.Delete` |
| POST | `/orgs/keys` | `apiorgs.CreateAgentKey` |
| GET | `/orgs/keys` | `apiorgs.GetAgentKey` |
| DELETE | `/orgs/keys` | `apiorgs.RevokeAgentKey` |
| PUT | `/orgs/license` | `apiorgs.UpdateOrgLicense` |
| POST | `/orgs/license/sign` | `apiorgs.SignLicense` |
| GET | `/serverconfig/misc` | `apiserverconfig.GetServerMisc` |
| PUT | `/serverconfig/misc` | `apiserverconfig.UpdateServerMisc` |
| GET | `/serverconfig/auth` | `apiserverconfig.GetAuthConfig` |
| PUT | `/serverconfig/auth` | `apiserverconfig.UpdateAuthConfig` |
| POST | `/serverconfig/auth/apikey` | `apiserverconfig.GenerateApiKey` |
| POST | `/proxymanager/connect` | `apiproxymanager.Post` |
| POST | `/proxymanager/disconnect` | `apiproxymanager.Disconnect` |
| GET | `/proxymanager/status` | `apiproxymanager.Get` |

## Core Types

- `openapi.AgentRequest`
- `openapi.AgentCreateResponse`
- `openapi.AgentResponse`
- `openapi.OrgKeyResponse`
- `openapi.License`
- `openapi.ServerMiscConfig`
- `openapi.ServerAuthConfig`
- `openapi.GenerateApiKeyResponse`
- `openapi.ProxyManagerRequest`
- `openapi.ProxyManagerResponse`

## Behavior Notes

- Auth config and org-key routes are security-sensitive and should stay audited.
- License operations can change runtime feature behavior.
- Proxy manager routes coordinate client-side local proxy sessions.

## Change Checklist

1. Preserve API key generation and rollout semantics.
2. Keep provider-specific auth config shape stable.
3. Maintain key/license privilege checks.
4. Keep proxy connect/disconnect contracts unchanged for CLI.
