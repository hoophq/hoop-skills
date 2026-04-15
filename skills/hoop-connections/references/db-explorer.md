# DB Explorer Reference

## Endpoints

- `GET /connections/:nameOrID/databases`
- `GET /connections/:nameOrID/tables`
- `GET /connections/:nameOrID/columns`
- `GET /connections/:nameOrID/test`

## Response Types

- `openapi.ConnectionDatabaseListResponse`
- `openapi.TablesResponse`
- `openapi.ColumnsResponse`
- `openapi.ConnectionTestResponse`

## Query and Path Behavior

- `nameOrID` accepts either resource name or ID.
- Table and column endpoints depend on query params for selected database/schema/table.
- Test endpoint confirms basic connectivity and auth.

## Reliability Guidance

- Keep request timeout bounded to avoid blocked API workers.
- Return structured API errors instead of raw executor messages.
- Maintain consistent field naming across database engines.
