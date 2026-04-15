# Session Exec Flow

## Main Endpoints

- `POST /sessions`
- `POST /sessions/:session_id/exec`
- `POST /sessions/provision`
- `POST /sessions/:session_id/kill`

## Standard Execution Path

1. Validate request payload and access to target connection.
2. Build execution context and create session record.
3. Try immediate execution window.
4. If execution exceeds sync threshold, return accepted/async pattern.
5. Persist final status and output metadata.

## Reviewed Execution Path

1. A pending session is approved via review flow.
2. Client calls `POST /sessions/:session_id/exec`.
3. Handler resumes execution with approved context.

## Operational Constraints

- Provision endpoint is API-key only.
- Kill endpoint should be idempotent.
- Exec and list filters must remain CLI-compatible.
