# Hoop Auth Skill

> **API version**: 1.55.5

Use this skill for authentication entry points, login callbacks, and public server identity endpoints.

## Primary Files

- `hoop/gateway/api/server.go`
- `hoop/gateway/api/login/oidc/`
- `hoop/gateway/api/login/saml/`
- `hoop/gateway/api/login/local/`
- `hoop/gateway/api/signup/`
- `hoop/gateway/api/serverinfo/`
- `hoop/gateway/api/publicserverinfo/`

## Route Coverage

| Method | Path | Handler |
|---|---|---|
| GET | `/login` | `loginOidcApiHandler.Login` |
| GET | `/callback` | `loginOidcApiHandler.LoginCallback` |
| GET | `/saml/login` | `loginSamlApiHandler.SamlLogin` |
| POST | `/saml/callback` | `loginSamlApiHandler.SamlLoginCallback` |
| POST | `/localauth/register` | `loginlocalapi.Register` |
| POST | `/localauth/login` | `loginlocalapi.Login` |
| POST | `/signup` | `signupapi.Post` |
| GET | `/publicserverinfo` | `apipublicserverinfo.Get` |
| GET | `/serverinfo` | `apiserverinfo.Get` |

## Access Model

- `/publicserverinfo`, `/login`, `/callback`, `/saml/*`, `/localauth/*`, `/signup`: public entry routes
- `/serverinfo`: read-only + authenticated

## Core Types

- `openapi.Login`
- `openapi.LocalUserRequest`
- `openapi.SignupRequest`
- `openapi.PublicServerInfo`
- `openapi.ServerInfo`

## Implementation Notes

- OIDC flow relies on state validation and callback token exchange.
- SAML flow maps identity and group claims into Hoop user/group context.
- Local auth uses password hashing and returns token material for client bootstrap.
- Signup behavior depends on tenancy mode and config flags.

## Change Checklist

When touching auth endpoints:

1. Keep callback token/cookie behavior backward compatible.
2. Preserve state validation in OIDC/SAML callback paths.
3. Keep `serverinfo` response fields synchronized with `appconfig` and feature flags.
4. Update OpenAPI annotations and request/response schemas as needed.

## Additional References

- `references/oidc-flow.md`
- `references/saml-flow.md`
