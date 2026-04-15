# Hoop Resources Skill

> **API version**: 1.55.5

Use this skill for resource CRUD, attributes CRUD, and search/metrics/report endpoints.

## Primary Files

- `hoop/gateway/api/resources/`
- `hoop/gateway/api/attributes/`
- `hoop/gateway/api/search/`
- `hoop/gateway/api/metrics/`
- `hoop/gateway/api/reports/`
- `hoop/gateway/api/server.go`

## Route Coverage

| Method | Path | Handler |
|---|---|---|
| GET | `/resources` | `resourcesapi.ListResources` |
| GET | `/resources/:name` | `resourcesapi.GetResource` |
| POST | `/resources` | `resourcesapi.CreateResource` |
| PUT | `/resources/:name` | `resourcesapi.UpdateResource` |
| DELETE | `/resources/:name` | `resourcesapi.DeleteResource` |
| GET | `/attributes` | `apiattributes.List` |
| GET | `/attributes/:name` | `apiattributes.Get` |
| POST | `/attributes` | `apiattributes.Post` |
| PUT | `/attributes/:name` | `apiattributes.Put` |
| DELETE | `/attributes/:name` | `apiattributes.Delete` |
| GET | `/search` | `searchapi.Get` |
| GET | `/metrics/sessions` | `metricsapi.Get` |
| GET | `/reports/sessions` | `apireports.SessionReport` |

## Core Types

- `openapi.ResourceRequest`
- `openapi.ResourceResponse`
- `openapi.AttributeRequest`
- `openapi.Attributes`
- `openapi.SearchResponse`
- `openapi.SessionMetricResponse`
- `openapi.SessionMetricsAggregatedResponse`
- `openapi.SessionReport`

## Behavior Notes

- Resource creation can imply downstream connection/resource wiring.
- Attribute links are cross-cutting and may impact multiple policy domains.
- Metrics and report endpoints support time-range filtering semantics.

## Change Checklist

1. Keep `:name` path-based compatibility for resources/attributes.
2. Preserve search response sections (`connections`, `runbooks`, `resources`).
3. Keep metrics aggregated/non-aggregated mode behavior stable.
