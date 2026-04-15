# Connection Credential Types

## Main API Types

- `openapi.ConnectionCredentialsRequest`
  - `access_duration_sec`
- `openapi.ConnectionCredentialsResponse`
  - `id`, `connection_name`, `connection_type`, `connection_subtype`
  - `connection_credentials` (protocol-specific payload)
  - `session_id`, `has_review`, `review_id`
  - `expire_at`, `created_at`

## Protocol-Specific Payloads

- `openapi.PostgresConnectionInfo`
  - host, port, username, password, database, connection string
- `openapi.SSHConnectionInfo`
  - host, port, username, password, command
- `openapi.RDPConnectionInfo`
  - host, port, username, password, command
- `openapi.SSMConnectionInfo`
  - endpoint URL, access key, secret key, connection string
- `openapi.HttpProxyConnectionInfo`
  - host, port, proxy token, command

## Compatibility Rules

- Keep `connection_credentials` shape stable per subtype.
- Additive fields are safer than renames/removals.
- Resume and revoke endpoints rely on stable `ID` and `session_id` coordination.
