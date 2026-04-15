# Hoop Security Skill

> **API version**: 1.55.5

Use this skill for guardrail rule management, data masking rule management, and audit log retrieval.

## Primary Files

- `hoop/gateway/api/guardrails/`
- `hoop/gateway/api/datamasking/`
- `hoop/gateway/api/auditlog/`
- `hoop/gateway/api/server.go`

## Route Coverage

| Method | Path | Handler |
|---|---|---|
| POST | `/guardrails` | `apiguardrails.Post` |
| PUT | `/guardrails/:id` | `apiguardrails.Put` |
| GET | `/guardrails` | `apiguardrails.List` |
| GET | `/guardrails/:id` | `apiguardrails.Get` |
| DELETE | `/guardrails/:id` | `apiguardrails.Delete` |
| POST | `/datamasking-rules` | `apidatamasking.Post` |
| PUT | `/datamasking-rules/:id` | `apidatamasking.Put` |
| GET | `/datamasking-rules` | `apidatamasking.List` |
| GET | `/datamasking-rules/:id` | `apidatamasking.Get` |
| DELETE | `/datamasking-rules/:id` | `apidatamasking.Delete` |
| GET | `/audit/logs` | `auditlogapi.List` |

## Core Types

- `openapi.GuardRailRuleRequest`
- `openapi.GuardRailRuleResponse`
- `openapi.DataMaskingRuleRequest`
- `openapi.DataMaskingRule`
- `openapi.SecurityAuditLogResponse`

## Behavior Notes

- Guardrail and datamasking mutations are admin-only and audited.
- List/get endpoints are available to admin and auditor roles.
- Audit logs provide filterable, security-focused operation records.

## Change Checklist

1. Preserve rule evaluation input/output schema shape.
2. Keep `:id` route compatibility.
3. Do not loosen role constraints around mutation routes.
4. Keep audit log query filter semantics stable.
