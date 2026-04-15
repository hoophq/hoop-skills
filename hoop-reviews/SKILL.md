# Hoop Reviews Skill

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

## Important Behavior

- Review handler is dependency-injected (`NewHandler(...)`) unlike most API packages.
- Time-window and force-approval logic are central to review correctness.
- Access request rules define reviewer groups, approval requirements, and max duration.

## Change Checklist

1. Keep review status transitions strict.
2. Preserve group-based approval behavior.
3. Keep time-window parsing and validation consistent.
4. Ensure session review and review-by-id paths stay aligned.
