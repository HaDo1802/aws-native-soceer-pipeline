# AWS region
variable "aws_region" {
  description = "AWS region where Terraform will manage resources."
  type        = string
  default     = "us-west-1"
}

# Project prefix
variable "project_name" {
  description = "Project name prefix used to build Terraform-managed resource names."
  type        = string
  default     = "sport-analysis"
}

# ETL data bucket
variable "s3_data_bucket" {
  description = "Name of the S3 bucket used by the ETL pipeline for raw and cleaned data."
  type        = string
  default     = "sport-analysis"
}

# Lambda execution role name
variable "lambda_execution_role_name" {
  description = "IAM role name used by the Lambda functions."
  type        = string
  default     = "dev_lamda"
}

# Snowflake account
variable "snowflake_account" {
  description = "Snowflake account identifier used by the ingest Lambda."
  type        = string
  sensitive   = true
}

# Snowflake user
variable "snowflake_user" {
  description = "Snowflake username used by the ingest Lambda."
  type        = string
  sensitive   = true
}

# Snowflake password
variable "snowflake_password" {
  description = "Snowflake password used by the ingest Lambda."
  type        = string
  sensitive   = true
}

# Snowflake AWS principal allowed to assume the role for S3 reads.
variable "snowflake_assume_role_user_arn" {
  description = "Snowflake AWS user ARN used in the IAM trust policy."
  type        = string
  sensitive   = true
}

# Snowflake external ID used in the trust policy.
variable "snowflake_external_id" {
  description = "Snowflake external ID used in the IAM trust policy."
  type        = string
  sensitive   = true
}

# Shared timeout for Lambdas that use the default
variable "lambda_timeout" {
  description = "Timeout in seconds for Lambda functions."
  type        = number
  default     = 300
}

# Shared memory for Lambdas that use the default
variable "lambda_memory" {
  description = "Memory size in MB for Lambda functions."
  type        = number
  default     = 256
}

# Pandas layer for the cleaner Lambda
variable "clean_player_stats_layer_arn" {
  description = "Layer ARN attached to the clean-player-stats Lambda for pandas support."
  type        = string
  default     = "arn:aws:lambda:us-west-1:336392948345:layer:AWSSDKPandas-Python311:26"
}

# Snowflake connector layer for the ingest Lambda.
variable "snowflake_layer_arn" {
  description = "Layer ARN attached to the snowflake-ingest Lambda."
  type        = string
}
