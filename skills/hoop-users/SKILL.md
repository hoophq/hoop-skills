# Hoop Users Skill

> **API version**: 1.55.5

Use this skill for user lifecycle operations, group management, and service accounts.

## Primary Files

- `hoop/gateway/api/user/`
- `hoop/gateway/api/serviceaccount/`
- `hoop/gateway/api/server.go`
- `hoop/gateway/api/openapi/types.go`

## Route Coverage

| Method | Path | Handler |
|---|---|---|
| GET | `/userinfo` | `userapi.GetUserInfo` |
| GET | `/users` | `userapi.List` |
| GET | `/users/:emailOrID` | `userapi.GetUserByEmailOrID` |
| POST | `/users` | `userapi.Create` |
| PUT | `/users/:id` | `userapi.Update` |
| PATCH | `/users/self/slack` | `userapi.PatchSlackID` |
| DELETE | `/users/:id` | `userapi.Delete` |
| GET | `/users/groups` | `userapi.ListAllGroups` |
| POST | `/users/groups` | `userapi.CreateGroup` |
| DELETE | `/users/groups/:name` | `userapi.DeleteGroup` |
| GET | `/serviceaccounts` | `serviceaccountapi.List` |
| POST | `/serviceaccounts` | `serviceaccountapi.Create` |
| PUT | `/serviceaccounts/:subject` | `serviceaccountapi.Update` |

## Role Expectations

- Read/list/get endpoints: read-only access role
- Mutations: admin-only access role
- Most mutations include audit middleware and analytics event tracking

## Core Types

- `openapi.User`
- `openapi.UserInfo`
- `openapi.UserPatchSlackID`
- `openapi.UserGroup`
- `openapi.ServiceAccount`

## Implementation Notes

- User endpoints enforce self-protection checks to avoid accidental lockout/escalation issues.
- Group operations affect authorization behavior globally.
- Service account IDs are derived deterministically from subject.

## Change Checklist

1. Preserve admin/auditor group semantics.
2. Keep self-update and self-delete guardrails.
3. Keep response schema stable for CLI/UI consumers.
4. Ensure audit middleware remains on admin mutation paths.
