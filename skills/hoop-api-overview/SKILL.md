# Hoop API Overview Skill

> **API version**: 1.55.5

Use this skill before changing any endpoint in `hoop/gateway/api`.

## Scope

- API bootstrap and route registration
- Middleware order and role gates
- Auth context and handler conventions
- OpenAPI generation workflow

## Primary Files

- `hoop/gateway/api/server.go`
- `hoop/gateway/api/middleware.go`
- `hoop/gateway/api/apiroutes/router.go`
- `hoop/gateway/api/apiroutes/auth.go`
- `hoop/gateway/api/apiroutes/roles.go`
- `hoop/gateway/api/openapi/types.go`
- `hoop/gateway/api/openapi/ginvalidators.go`

## Runtime Topology

- HTTP API: `:8009`
- gRPC transport: `:8010`
- WebSocket endpoint: `/ws`
- Base API group: `/<api-base>/api`

## Infrastructure Routes

| Method | Path | Handler |
|---|---|---|
| GET | `/healthz` | `apihealthz.LivenessHandler()` |
| GET | `/openapiv2.json` | `openapi.Handler` |
| GET | `/openapiv3.json` | `openapi.HandlerV3` |

## Route Registration Pattern

All routes are registered in `buildRoutes()` in `server.go`.

Typical route chain:

1. Optional role middleware:
   - `apiroutes.AdminOnlyAccessRole`
   - `apiroutes.AdminAndAuditorAccessRole`
   - `apiroutes.ReadOnlyAccessRole`
2. `r.AuthMiddleware`
3. Optional `api.AuditMiddleware()`
4. Optional `api.TrackRequest(analytics.EventXxx)`
5. Handler function

## Handler Conventions

- Signature: `func(c *gin.Context)` for most packages
- Review package exception: methods on a handler struct
- Parse auth/org context with `storagev2.ParseContext(c)`
- Use `httputils.AbortWithErr(...)` for safe error responses
- Return typed responses from `openapi/types.go`

## Router Behavior

- `apiroutes.New(...)` applies OTel and context tracing
- `Router.GET(...)` also registers a `HEAD` route
- `AuthMiddleware` supports:
  - `Api-Key` auth
  - Bearer token auth
  - role enforcement from route middleware

## OpenAPI Workflow

1. Add or update swagger annotations on handlers.
2. Keep request/response schemas in `openapi/types.go`.
3. Register custom validators in `openapi/ginvalidators.go` when needed.
4. Run `make generate-openapi-docs`.

## Extension Checklist

When adding a new endpoint:

1. Add/update handler in correct domain package under `gateway/api`.
2. Add route in `buildRoutes()`.
3. Apply correct role middleware and auth/audit/analytics behavior.
4. Add or reuse OpenAPI request/response types.
5. Add swagger annotation block and regenerate docs.
6. Ensure response codes match existing domain patterns.

## Additional Reference

See `references/middleware-chain.md` for detailed middleware behavior.
