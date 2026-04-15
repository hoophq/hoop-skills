# Runbooks V2 Reference

## V2-Focused Endpoints

- `GET /runbooks`
- `POST /runbooks/exec`
- `GET /runbooks/configurations`
- `PUT /runbooks/configurations`
- `POST /runbooks/configurations`
- `PUT /runbooks/configurations/:id`
- `DELETE /runbooks/configurations/:id`
- `POST /runbooks/configurations/:id/files`
- `GET /runbooks/rules`
- `GET /runbooks/rules/:id`
- `POST /runbooks/rules`
- `PUT /runbooks/rules/:id`
- `DELETE /runbooks/rules/:id`

## Main Types

- `openapi.RunbookConfigurationRequest`
- `openapi.RunbookConfigurationResponse`
- `openapi.RunbookRepository`
- `openapi.RunbookListV2`
- `openapi.RunbookRule`
- `openapi.RunbookRuleRequest`
- `openapi.RunbookFileCreate`

## Implementation Notes

- Configuration supports multiple repositories.
- Rule objects bind runbook files to allowed connections and user groups.
- File creation route must preserve commit semantics and overwrite behavior.
