# Middleware Chain Reference

## Global Middleware in `StartAPI()`

Applied to gin engine:

- `ginzap.RecoveryWithZap(...)`
- `ginzap.Ginzap(...)` (debug mode only)
- `SecurityHeaderMiddleware()`
- `CORSMiddleware()`
- static UI serving and SPA fallback

Applied to `/api` route group:

- `sentrygin.New(...)`
- `sentryCatchAll5xxMiddleware`
- `apiroutes.New(...)` then applies:
  - `otelgin.Middleware(...)`
  - `contextTracerMiddleware()`

## Per-Route Middleware Slots

Routes use a predictable left-to-right order:

1. Role selector (`AdminOnlyAccessRole`, `AdminAndAuditorAccessRole`, `ReadOnlyAccessRole`)
2. `r.AuthMiddleware`
3. Optional `api.AuditMiddleware()`
4. Optional `api.TrackRequest(analytics.EventXxx)`
5. Handler

## Role Middleware Behavior

Role middleware sets allowed role context that `AuthMiddleware` checks:

- `AdminOnlyAccessRole`: admin only
- `AdminAndAuditorAccessRole`: admin + auditor
- `ReadOnlyAccessRole`: standard + auditor (+ admin by rule logic)

## Auth and API Key Notes

- `AuthMiddleware` accepts:
  - `Api-Key` header (admin-style service access path)
  - `Authorization: Bearer ...`
- `OnlyApiKeyAccess` is used by provisioning flow endpoints.

## Audit Middleware Usage Pattern

Use `AuditMiddleware` on state-changing operations for sensitive resources:

- users
- connections
- agents
- guardrails
- datamasking
- auth config
- org key/license operations

## Analytics Middleware Usage Pattern

Use `TrackRequest(event)` on high-signal business events:

- login/signup
- create/update/delete core resources
- executions and reviews
- integrations and feature operations
