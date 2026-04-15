# DB Role Provisioning Reference

## Endpoints

- `POST /dbroles/jobs`
- `GET /dbroles/jobs`
- `GET /dbroles/jobs/:id`

## Main Types

- `openapi.CreateDBRoleJob`
- `openapi.CreateDBRoleJobResponse`
- `openapi.DBRoleJob`
- `openapi.DBRoleJobList`
- `openapi.DBRoleJobStepType`

## Key Semantics

- Job creation is asynchronous.
- Job step values are validator-gated (`create-connections`, `send-webhook`).
- Status/result fields are progressive and should be treated as append-only where possible.

## Safety Guidance

- Do not reduce required fields for job target identification.
- Keep job ID and status polling semantics stable for clients.
