# OIDC Flow Reference

## Endpoints

- `GET /login`
- `GET /callback`

## High-Level Flow

1. Client requests `/login`.
2. Server creates or validates login state and returns provider auth URL.
3. IdP redirects back to `/callback` with code/state.
4. Server validates state, exchanges code for token/userinfo, maps user/org context.
5. Server returns token via redirect or configured exchange mode.

## Key Guards

- State token validation for CSRF prevention.
- Issuer/client configuration must match provider settings.
- Group extraction and role mapping must remain deterministic.
- Anonymous/unregistered handling must respect route type and tenancy.

## Common Pitfalls

- Breaking callback redirect URL composition when API base path changes.
- Changing claim extraction without updating role/group behavior.
- Returning inconsistent token location (header/cookie/url) across flows.
