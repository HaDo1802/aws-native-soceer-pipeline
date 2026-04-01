# The backend bucket and lock table must already exist before `terraform init` can use them. Terraform cannot bootstrap this same backend automatically from this configuration alone.

# IAM Terraform Reference

## How the Resources Build on Each Other

```
layer1: data "aws_iam_policy_document"     ← memory only, no AWS resource created
  lambda_s3 / lambda_logs /                produces JSON, fed into ↓
  lambda_assume_role
         │
         │ .json
         ▼
layer2: resource "aws_iam_policy"          ← real AWS resource, has ARN
  lambda_s3 / lambda_logs                    visible in IAM → Policies on Console
         │
         │ .arn
         ▼
resource "aws_iam_role_policy_attachment"  ← the wiring, one per policy 
  lambda_s3 / lambda_logs /                  visible as checkmarks in IAM → Roles → dev_lamda → Permissions
  lambda_basic_execution (default by AWS provider)                  
         │
         │ 
         ▼
resource "aws_iam_role"                 ← the identity all 5 Lambdas assume
  lambda_exec  ("dev_lamda" in AWS)        visible in IAM → Roles
         │
         │ .arn referenced by
         ▼
resource "aws_lambda_function" x5       ← in lambdas.tf
```

## Trust Policy — Who Can Assume This Role

| Principal | Why |
|---|---|
| `lambda.amazonaws.com` | Lambda service runs your functions |
| `states.amazonaws.com` | Step Functions orchestrates the pipeline |
| Snowflake AWS user | Reads cleaned S3 data cross-account via ExternalId |

## Permissions Attached to `dev_lamda`

| Policy | Scope |
|---|---|
| `sport-analysis-lambda-s3-policy` | `sport-analysis` bucket only |
| `sport-analysis-lambda-logs-policy` | `/aws/lambda/*` log groups only |
| `AWSLambdaBasicExecutionRole` | AWS managed baseline, required for Lambda runtime |

## Terraform Name vs AWS Name

```
aws_iam_role.lambda_exec          →  dev_lamda
aws_iam_policy.lambda_s3          →  sport-analysis-lambda-s3-policy
aws_iam_policy.lambda_logs        →  sport-analysis-lambda-logs-policy
aws_lambda_function.scrape_roster →  scrape-roster
```
