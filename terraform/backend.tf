# Store Terraform's state remotely in S3 to promote the collaboration + DynamoDB table for implementing state block to avoid changes conflict

terraform {
  backend "s3" {
    bucket         = "sport-analysis-tf-state"
    key            = "pipeline/terraform.tfstate"
    region         = "us-west-1"
    dynamodb_table = "sport-analysis-tf-lock"
    encrypt        = true
  }
}
