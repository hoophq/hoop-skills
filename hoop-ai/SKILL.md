# Hoop AI Skill

Use this skill for AI provider configuration, AI session analyzer rules, and Ask AI feature routes.

## Primary Files

- `hoop/gateway/api/ai/`
- `hoop/gateway/api/features/`
- `hoop/gateway/api/server.go`
- `hoop/gateway/api/openapi/types.go`

## Route Coverage

| Method | Path | Handler |
|---|---|---|
| GET | `/ai/session-analyzer/providers` | `apiai.GetSessionAnalyzerProvider` |
| POST | `/ai/session-analyzer/providers` | `apiai.UpsertSessionAnalyzerProvider` |
| DELETE | `/ai/session-analyzer/providers` | `apiai.DeleteSessionAnalyzerProvider` |
| GET | `/ai/session-analyzer/rules` | `apiai.ListSessionAnalyzerRules` |
| POST | `/ai/session-analyzer/rules` | `apiai.CreateSessionAnalyzerRule` |
| GET | `/ai/session-analyzer/rules/:name` | `apiai.GetSessionAnalyzerRule` |
| PUT | `/ai/session-analyzer/rules/:name` | `apiai.UpdateSessionAnalyzerRule` |
| DELETE | `/ai/session-analyzer/rules/:name` | `apiai.DeleteSessionAnalyzerRule` |
| PUT | `/orgs/features` | `apifeatures.FeatureUpdate` |
| POST | `/features/ask-ai/v1/chat/completions` | `apifeatures.PostChatCompletions` |

## Core Types

- `openapi.AIProviderRequest`
- `openapi.AIProviderResponse`
- `openapi.AISessionAnalyzerRuleRequest`
- `openapi.AISessionAnalyzerRule`
- `openapi.FeatureRequest`

## Behavior Notes

- Provider configuration controls downstream analyzer behavior.
- Rule routes bind named analyzer rules to selected connections.
- Feature update route controls availability of AI feature flags.

## Change Checklist

1. Keep provider secrets handling secure and non-echoing in responses.
2. Preserve rule naming/path semantics (`:name`).
3. Keep chat completion proxy contract stable for clients.
