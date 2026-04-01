
data "aws_iam_policy_document" "lambda_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com", "states.amazonaws.com"]
    }
  }

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.snowflake_assume_role_user_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.snowflake_external_id]
    }
  }
}

# Shared execution role used by all five Lambda functions.
resource "aws_iam_role" "lambda_exec" {
  name               = "dev_lamda"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role.json
}

# Narrow S3 permissions for the ETL bucket
data "aws_iam_policy_document" "lambda_s3" {
  statement {
    sid     = "AllowListBucket"
    effect  = "Allow"
    actions = ["s3:ListBucket"]

    resources = [
      "arn:aws:s3:::${var.s3_data_bucket}",
    ]
  }

  statement {
    sid    = "AllowObjectReadWriteDelete"
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${var.s3_data_bucket}/*",
    ]
  }
}

resource "aws_iam_policy" "lambda_s3" {
  name        = "sport-analysis-lambda-s3-policy"
  description = "Allows Lambda functions to read and write objects in the ETL data bucket."
  policy      = data.aws_iam_policy_document.lambda_s3.json
}

# Narrow CloudWatch Logs permissions for Lambda log groups only.
# This replaces the broader logging access and removes the need for
# AmazonCloudWatchEvidentlyFullAccess.
data "aws_iam_policy_document" "lambda_logs" {
  statement {
    sid    = "AllowCloudWatchLogsWrite"
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = [
      "arn:aws:logs:us-west-1:317883707547:log-group:/aws/lambda/*",
    ]
  }
}

resource "aws_iam_policy" "lambda_logs" {
  name        = "sport-analysis-lambda-logs-policy"
  description = "Allows Lambda functions to write execution logs to CloudWatch Logs."
  policy      = data.aws_iam_policy_document.lambda_logs.json
}

# Attach the custom S3 policy to the shared Lambda role.
resource "aws_iam_role_policy_attachment" "lambda_s3" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_s3.arn
}

# Attach the custom logs policy to the shared Lambda role.
resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_logs.arn
}

# Keep the AWS-managed baseline Lambda execution policy that exists in AWS today.
resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}
