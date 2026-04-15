# Hoop Plugins and Runbooks Skill

> **API version**: 1.55.5

Use this skill for plugin lifecycle, plugin connection mapping, and runbook execution/configuration routes.

## Primary Files

- `hoop/gateway/api/plugins/`
- `hoop/gateway/api/pluginconnections/`
- `hoop/gateway/api/runbooks/`
- `hoop/gateway/api/server.go`

## Route Coverage

| Method | Path | Handler |
|---|---|---|
| POST | `/plugins` | `apiplugins.Post` |
| PUT | `/plugins/:name` | `apiplugins.Put` |
| PUT | `/plugins/:name/config` | `apiplugins.PutConfig` |
| GET | `/plugins` | `apiplugins.List` |
| GET | `/plugins/:name` | `apiplugins.Get` |
| PUT | `/plugins/:name/conn/:id` | `apipluginconnections.UpsertPluginConnection` |
| GET | `/plugins/:name/conn/:id` | `apipluginconnections.GetPluginConnection` |
| DELETE | `/plugins/:name/conn/:id` | `apipluginconnections.DeletePluginConnection` |
| GET | `/plugins/runbooks/connections/:name/templates` | `apirunbooks.ListByConnection` |
| GET | `/plugins/runbooks/templates` | `apirunbooks.List` |
| POST | `/plugins/runbooks/connections/:name/exec` | `apirunbooks.RunExec` |
| POST | `/runbooks/configurations` | `apirunbooks.CreateRunbookConfigurationEntry` |
| PUT | `/runbooks/configurations/:id` | `apirunbooks.UpdateRunbookConfigurationEntry` |
| DELETE | `/runbooks/configurations/:id` | `apirunbooks.DeleteRunbookConfiguration` |
| POST | `/runbooks/configurations/:id/files` | `apirunbooks.CreateRunbookFile` |
| GET | `/runbooks` | `apirunbooks.ListRunbooksV2` |
| POST | `/runbooks/exec` | `apirunbooks.RunbookExec` |
| GET | `/runbooks/configurations` | `apirunbooks.GetRunbookConfiguration` |
| PUT | `/runbooks/configurations` | `apirunbooks.UpdateRunbookConfiguration` |
| GET | `/runbooks/rules` | `apirunbooks.ListRunbookRules` |
| GET | `/runbooks/rules/:id` | `apirunbooks.GetRunbookRule` |
| POST | `/runbooks/rules` | `apirunbooks.CreateRunbookRule` |
| PUT | `/runbooks/rules/:id` | `apirunbooks.UpdateRunbookRule` |
| DELETE | `/runbooks/rules/:id` | `apirunbooks.DeleteRunbookRule` |

## Core Types

- `openapi.Plugin`
- `openapi.PluginConfig`
- `openapi.PluginConnectionRequest`
- `openapi.PluginConnection`
- `openapi.RunbookRequest`
- `openapi.RunbookExec`
- `openapi.RunbookConfigurationRequest`
- `openapi.RunbookRuleRequest`

## Behavior Notes

- Plugin endpoints are configuration-oriented and mostly admin scoped.
- Runbooks include legacy plugin-prefixed routes and V2 top-level routes.
- V2 supports multi-repository setup and per-rule access control.

## Additional Reference

- `references/runbooks-v2.md`
