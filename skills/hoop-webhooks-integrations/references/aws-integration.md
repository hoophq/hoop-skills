# AWS Integration Reference

## Endpoints

- `GET /integrations/aws/iam/userinfo`
- `PUT /integrations/aws/iam/accesskeys`
- `DELETE /integrations/aws/iam/accesskeys`
- `GET /integrations/aws/organizations`
- `POST /integrations/aws/rds/describe-db-instances`
- `POST /integrations/aws/rds/credentials`

## Main Types

- `openapi.IAMAccessKeyRequest`
- `openapi.IAMUserInfo`
- `openapi.IAMVerifyPermission`
- `openapi.ListAWSAccounts`
- `openapi.ListAWSDBInstancesRequest`
- `openapi.ListAWSDBInstances`
- `openapi.CreateRdsRootPasswordRequest`
- `openapi.CreateRdsRootPasswordResponse`

## Behavior Notes

- IAM key update/delete must keep credential verification contract stable.
- Organization listing should preserve account identity fields and status mapping.
- RDS discovery and credential generation are admin-sensitive operations.
