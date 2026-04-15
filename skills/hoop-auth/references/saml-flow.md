# SAML Flow Reference

## Endpoints

- `GET /saml/login`
- `POST /saml/callback`

## High-Level Flow

1. Client requests `/saml/login`.
2. Server returns SAML auth URL/request.
3. IdP posts assertion to `/saml/callback`.
4. Server validates assertion, extracts email/name/groups, maps local user context.
5. Server issues access token and redirects to web app callback target.

## Claim Mapping Notes

- Email, display name, and groups may come from different claim URIs.
- Group claim key can be configured in auth settings.
- Assertion timing (`NotOnOrAfter`) can influence token/session duration behavior.

## Safety Rules

- Keep assertion validation strict.
- Preserve anti-replay and callback correlation checks.
- Do not silently accept missing mandatory identity claims.
