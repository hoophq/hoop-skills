# Session Types Reference

## Core Request Types

- `openapi.ExecRequest`
  - script
  - connection
  - labels
  - metadata
  - client_args
- `openapi.ProvisionSession`
  - user_email
  - script
  - connection
  - approved_reviewers
  - access_duration_sec
  - metadata
  - client_args
  - jira_fields
  - time_window

## Core Response Types

- `openapi.ExecResponse`
  - has_review
  - session_id
  - output
  - output_status
  - truncated
  - execution_time_mili
  - exit_code
- `openapi.ProvisionSessionResponse`
  - session_id
  - user_email
  - has_review

## Session Model

- `openapi.Session` includes:
  - identity (id, org_id, user_email, user_id)
  - command payload and labels
  - connection metadata
  - lifecycle fields (`status`, `start_session`, `end_session`)
  - optional review block
  - optional AI analysis and guardrails info

## List Wrapper

- `openapi.SessionList`
  - `items`
  - `total`
  - `has_next_page`
