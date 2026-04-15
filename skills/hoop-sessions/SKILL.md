# Hoop Sessions Skill

> **API version**: 1.55.5

Use this skill for execution sessions, review execution handoff, downloads, streaming output, provisioning, and transport websocket ingress.

## Primary Files

- `hoop/gateway/api/session/`
- `hoop/gateway/api/server.go`
- `hoop/gateway/transport/websocket.go`
- `hoop/gateway/api/openapi/types.go`

## Route Coverage

| Method | Path | Handler |
|---|---|---|
| GET | `/plugins/audit/sessions/:session_id` | `sessionapi.Get` |
| GET | `/plugins/audit/sessions` | `sessionapi.List` |
| GET | `/sessions/:session_id` | `sessionapi.Get` |
| GET | `/sessions/:session_id/download` | `sessionapi.DownloadSession` |
| GET | `/sessions/:session_id/download/input` | `sessionapi.DownloadSessionInput` |
| GET | `/sessions/:session_id/rdp-frames` | `sessionapi.GetRDPFrames` |
| GET | `/sessions/:session_id/result/stream` | `sessionapi.StreamSessionResult` |
| POST | `/sessions/:session_id/kill` | `sessionapi.Kill` |
| PATCH | `/sessions/:session_id/metadata` | `sessionapi.PatchMetadata` |
| GET | `/sessions` | `sessionapi.List` |
| POST | `/sessions` | `sessionapi.Post` |
| POST | `/sessions/:session_id/exec` | `sessionapi.RunReviewedExec` |
| POST | `/sessions/provision` | `sessionapi.Provision` |
| GET | `/ws` | `transport.HandleConnection` |

## Role and Access Notes

- Read routes mostly use `ReadOnlyAccessRole + AuthMiddleware`.
- Provision route requires `AuthMiddleware + OnlyApiKeyAccess`.
- Download routes are externally accessible with token gate in handler logic.
- `/ws` uses transport-specific auth (`HOOP_KEY`) in websocket handler.

## Core Types

- `openapi.ExecRequest`
- `openapi.ExecResponse`
- `openapi.Session`
- `openapi.SessionList`
- `openapi.ProvisionSession`
- `openapi.ProvisionSessionResponse`
- `openapi.SessionUpdateMetadataRequest`

## Behavior Notes

- Session execution has synchronous window and async fallback behavior.
- Review-gated sessions can require `/sessions/:session_id/exec`.
- Streaming and download flows must stay backward compatible for CLI/UI.

## Additional References

- `references/exec-flow.md`
- `references/session-types.md`
