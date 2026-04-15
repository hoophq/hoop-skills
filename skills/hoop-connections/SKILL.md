# Hoop Connections Skill

Use this skill for connection CRUD, connection testing, DB metadata exploration, and temporary credential workflows.

## Primary Files

- `hoop/gateway/api/connections/`
- `hoop/gateway/api/server.go`
- `hoop/gateway/api/openapi/types.go`
- `hoop/gateway/api/validation/`

## Route Coverage

| Method | Path | Handler |
|---|---|---|
| POST | `/connections` | `apiconnections.Post` |
| PUT | `/connections/:nameOrID` | `apiconnections.Put` |
| PATCH | `/connections/:nameOrID` | `apiconnections.Patch` |
| GET | `/connections` | `apiconnections.List` |
| GET | `/connections/:nameOrID` | `apiconnections.Get` |
| DELETE | `/connections/:name` | `apiconnections.Delete` |
| GET | `/connections/:nameOrID/databases` | `apiconnections.ListDatabases` |
| GET | `/connections/:nameOrID/tables` | `apiconnections.ListTables` |
| GET | `/connections/:nameOrID/columns` | `apiconnections.GetTableColumns` |
| PUT | `/connections/:nameOrID/datamasking-rules` | `apiconnections.UpdateDataMaskingRuleConnection` |
| GET | `/connections/:nameOrID/ai-session-analyzer-rule` | `apiai.GetConnectionAnalyzerRule` |
| GET | `/connections/:nameOrID/test` | `apiconnections.TestConnection` |
| POST | `/connections/:nameOrID/credentials` | `apiconnections.CreateConnectionCredentials` |
| POST | `/connections/:nameOrID/credentials/:ID` | `apiconnections.ResumeConnectionCredentials` |
| POST | `/connections/:nameOrID/credentials/:ID/revoke` | `apiconnections.RevokeConnectionCredentials` |
| GET | `/connection-tags` | `apiconnections.ListTags` |

## Role and Middleware Pattern

- Read operations: `ReadOnlyAccessRole + AuthMiddleware`
- Mutations: `AdminOnlyAccessRole + AuthMiddleware` (+ audit/analytics in core CRUD)
- Credential endpoints require auth; review flow may gate issuance

## Core Types

- `openapi.Connection`
- `openapi.ConnectionPatch`
- `openapi.ConnectionCredentialsRequest`
- `openapi.ConnectionCredentialsResponse`
- `openapi.ConnectionTestResponse`
- `openapi.ConnectionDatabaseListResponse`
- `openapi.TablesResponse`
- `openapi.ColumnsResponse`

## Operational Patterns

- Filtering and pagination are used heavily in listing routes.
- DB explorer routes call backend executors with bounded timeout.
- Credential creation can return immediate credentials or pending-review flow.

## Change Checklist

1. Keep path params (`nameOrID`, `ID`) backward compatible.
2. Do not break credential resume/revoke semantics.
3. Preserve list filters expected by UI and CLI.
4. Keep datamasking and analyzer rule links consistent with downstream modules.

## Additional References

- `references/credential-types.md`
- `references/db-explorer.md`
