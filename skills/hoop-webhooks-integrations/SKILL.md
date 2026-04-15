# Hoop Webhooks and Integrations Skill

> **API version**: 1.55.5

Use this skill for webhook management (Svix), Jira integration endpoints, AWS integration endpoints, and DB role jobs.

## Primary Files

- `hoop/gateway/api/webhooks/`
- `hoop/gateway/api/integrations/`
- `hoop/gateway/api/integrations/aws/`
- `hoop/gateway/api/server.go`
- `hoop/gateway/api/openapi/types.go`

## Route Coverage

| Method | Path | Handler |
|---|---|---|
| GET | `/webhooks-dashboard` | `webhooksapi.GetDashboardURL` |
| GET | `/webhooks/endpoints` | `webhooksapi.ListSvixEndpoints` |
| GET | `/webhooks/endpoints/:id` | `webhooksapi.GetSvixEndpointByID` |
| POST | `/webhooks/endpoints` | `webhooksapi.CreateSvixEndpoint` |
| PUT | `/webhooks/endpoints/:id` | `webhooksapi.UpdateSvixEndpoint` |
| DELETE | `/webhooks/endpoints/:id` | `webhooksapi.DeleteSvixEndpointByID` |
| POST | `/webhooks/eventtypes` | `webhooksapi.CreateSvixEventType` |
| PUT | `/webhooks/eventtypes/:name` | `webhooksapi.UpdateSvixEventType` |
| GET | `/webhooks/eventtypes` | `webhooksapi.ListSvixEventTypes` |
| GET | `/webhooks/eventtypes/:name` | `webhooksapi.GetSvixEventTypeByName` |
| DELETE | `/webhooks/eventtypes/:name` | `webhooksapi.DeleteSvixEventType` |
| POST | `/webhooks/messages` | `webhooksapi.CreateSvixMessage` |
| GET | `/webhooks/messages` | `webhooksapi.ListSvixMessages` |
| GET | `/webhooks/messages/:id` | `webhooksapi.GetSvixMessageByID` |
| GET | `/integrations/jira` | `apijiraintegration.Get` |
| POST | `/integrations/jira` | `apijiraintegration.Post` |
| PUT | `/integrations/jira` | `apijiraintegration.Put` |
| POST | `/integrations/jira/issuetemplates` | `apijiraintegration.CreateIssueTemplates` |
| PUT | `/integrations/jira/issuetemplates/:id` | `apijiraintegration.UpdateIssueTemplates` |
| GET | `/integrations/jira/issuetemplates` | `apijiraintegration.ListIssueTemplates` |
| GET | `/integrations/jira/issuetemplates/:id` | `apijiraintegration.GetIssueTemplatesByID` |
| DELETE | `/integrations/jira/issuetemplates/:id` | `apijiraintegration.DeleteIssueTemplates` |
| GET | `/integrations/jira/assets/objects` | `apijiraintegration.GetAssetObjects` |
| GET | `/integrations/aws/iam/userinfo` | `awsintegration.IAMGetUserInfo` |
| PUT | `/integrations/aws/iam/accesskeys` | `awsintegration.IAMUpdateAccessKey` |
| DELETE | `/integrations/aws/iam/accesskeys` | `awsintegration.IAMDeleteAccessKey` |
| GET | `/integrations/aws/organizations` | `awsintegration.ListOrganizations` |
| POST | `/integrations/aws/rds/describe-db-instances` | `awsintegration.DescribeRDSDBInstances` |
| POST | `/integrations/aws/rds/credentials` | `awsintegration.CreateRDSRootPassword` |
| POST | `/dbroles/jobs` | `awsintegration.CreateDBRoleJob` |
| GET | `/dbroles/jobs` | `awsintegration.ListDBRoleJobs` |
| GET | `/dbroles/jobs/:id` | `awsintegration.GetDBRoleJobByID` |

## Core Types

- `openapi.WebhooksDashboardResponse`
- `openapi.JiraIntegration`
- `openapi.JiraIssueTemplateRequest`
- `openapi.JiraAssetObjects`
- `openapi.IAMAccessKeyRequest`
- `openapi.IAMUserInfo`
- `openapi.ListAWSAccounts`
- `openapi.ListAWSDBInstancesRequest`
- `openapi.CreateDBRoleJob`
- `openapi.DBRoleJob`

## Behavior Notes

- Webhook endpoints proxy Svix operations and should keep response stability.
- Jira templates map session metadata to issue fields and CMDB object lookups.
- AWS routes include credential management, org discovery, and provisioning jobs.

## Additional References

- `references/jira-integration.md`
- `references/aws-integration.md`
- `references/db-role-provisioning.md`
