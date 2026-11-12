# Hoop Reviews Skill

> **API version**: 1.55.5

Use this skill for review approvals and access request rule management.

## Primary Files

- `hoop/gateway/api/review/`
- `hoop/gateway/api/accessrequests/`
- `hoop/gateway/api/server.go`
- `hoop/gateway/api/openapi/types.go`

## Route Coverage

| Method | Path | Handler |
|---|---|---|
| GET | `/reviews` | `reviewHandler.List` |
| GET | `/reviews/:id` | `reviewHandler.GetByIdOrSid` |
| PUT | `/reviews/:id` | `reviewHandler.ReviewByIdOrSid` |
| GET | `/approvals/routing/integrations` | `reviewapi.GetRoutingIntegrations` |
| PUT | `/sessions/:session_id/review` | `reviewHandler.ReviewBySid` |
| GET | `/access-requests/rules` | `accessrequestsapi.ListAccessRequestRules` |
| POST | `/access-requests/rules` | `accessrequestsapi.CreateAccessRequestRule` |
| GET | `/access-requests/rules/:name` | `accessrequestsapi.GetAccessRequestRule` |
| PUT | `/access-requests/rules/:name` | `accessrequestsapi.UpdateAccessRequestRule` |
| DELETE | `/access-requests/rules/:name` | `accessrequestsapi.DeleteAccessRequestRule` |

## Core Types

- `openapi.Review`
- `openapi.ReviewRequest`
- `openapi.ReviewSessionTimeWindow`
- `openapi.AccessRequestRule`
- `openapi.AccessRequestRuleRequest`
- `openapi.ApprovalRoutingIntegrations`

## Important Behavior

- Review handler is dependency-injected (`NewHandler(...)`) unlike most API packages.
- Time-window and force-approval logic are central to review correctness.
- Access request rules define reviewer groups, approval requirements, and max duration.
- `GET /approvals/routing/integrations` is admin only. It lists the notify integrations (`slack`, `teams`) and the Slack channels a level's `routing` config can use. `integrated` is false for an integration that is not set up; a channel with no known name shows its id.

## Change Checklist

1. Keep review status transitions strict.
2. Preserve group-based approval behavior.
3. Keep time-window parsing and validation consistent.
4. Ensure session review and review-by-id paths stay aligned.
