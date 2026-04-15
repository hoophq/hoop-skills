# Jira Integration Reference

## Endpoints

- `GET /integrations/jira`
- `POST /integrations/jira`
- `PUT /integrations/jira`
- `POST /integrations/jira/issuetemplates`
- `PUT /integrations/jira/issuetemplates/:id`
- `GET /integrations/jira/issuetemplates`
- `GET /integrations/jira/issuetemplates/:id`
- `DELETE /integrations/jira/issuetemplates/:id`
- `GET /integrations/jira/assets/objects`

## Main Types

- `openapi.JiraIntegration`
- `openapi.JiraIssueTemplate`
- `openapi.JiraIssueTemplateRequest`
- `openapi.JiraAssetObjects`

## Compatibility Guidance

- Keep mapping field schema (`mapping_types`, `prompt_types`, `cmdb_types`) backward compatible.
- Keep issue template ID path handling strict.
- Asset object endpoint should maintain pagination-like response fields.
