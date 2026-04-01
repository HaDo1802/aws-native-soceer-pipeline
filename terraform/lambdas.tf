# Lambda resources. Zip files are built in the repo root

resource "aws_lambda_function" "scrape_roster" {
  function_name = "scrape-roster"
  handler       = "scrape_roster_handler.handler"
  filename      = "../scrape-roster.zip"

  # Redeploy when the zip changes
  source_code_hash = filebase64sha256("../scrape-roster.zip")

  runtime = "python3.11"
  role    = aws_iam_role.lambda_exec.arn

  timeout     = 120
  memory_size = 128

  environment {
    variables = {
      S3_BUCKET     = var.s3_data_bucket
      S3_RAW_PREFIX = "raw"
    }
  }

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
    Project     = var.project_name
  }
}

resource "aws_lambda_function" "scrape_players" {
  function_name    = "scrape-players"
  handler          = "scrape_players_handler.handler"
  filename         = "../scrape-players.zip"
  source_code_hash = filebase64sha256("../scrape-players.zip")

  runtime = "python3.11"
  role    = aws_iam_role.lambda_exec.arn

  timeout     = 900
  memory_size = 512

  environment {
    variables = {
      S3_BUCKET     = var.s3_data_bucket
      S3_RAW_PREFIX = "raw"
    }
  }

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
    Project     = var.project_name
  }
}

resource "aws_lambda_function" "combine_player_json" {
  function_name    = "combine-player-json"
  handler          = "combine_player_json_to_csv_handler.handler"
  filename         = "../combine-player-json.zip"
  source_code_hash = filebase64sha256("../combine-player-json.zip")

  runtime = "python3.11"
  role    = aws_iam_role.lambda_exec.arn

  timeout     = 60
  memory_size = 512

  environment {
    variables = {
      S3_BUCKET     = var.s3_data_bucket
      S3_RAW_PREFIX = "raw"
    }
  }

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
    Project     = var.project_name
  }
}

# Cleaner Lambda. Keeps the current pandas layer
resource "aws_lambda_function" "clean_player_stats" {
  function_name    = "clean-player-stats"
  handler          = "clean_player_stats_handler.handler"
  filename         = "../clean-player-stats.zip"
  source_code_hash = filebase64sha256("../clean-player-stats.zip")

  runtime = "python3.11"
  role    = aws_iam_role.lambda_exec.arn

  timeout     = var.lambda_timeout
  memory_size = var.lambda_memory

  layers = [var.clean_player_stats_layer_arn]

  environment {
    variables = {
      S3_BUCKET         = var.s3_data_bucket
      S3_RAW_PREFIX     = "raw"
      S3_CLEANED_PREFIX = "cleaned"
    }
  }

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
    Project     = var.project_name
  }
}

# Snowflake ingest Lambda. Uses the packaged connector from the zip
resource "aws_lambda_function" "snowflake_ingest" {
  function_name    = "snowflake-ingest"
  handler          = "snowflake_ingest_handler.handler"
  filename         = "../snowflake-ingest.zip"
  source_code_hash = filebase64sha256("../snowflake-ingest.zip")

  runtime = "python3.11"
  role    = aws_iam_role.lambda_exec.arn

  timeout     = var.lambda_timeout
  memory_size = var.lambda_memory

  # Preserve the existing Snowflake layer attached in AWS.
  layers = [var.snowflake_layer_arn]

  environment {
    variables = {
      S3_BUCKET           = var.s3_data_bucket
      S3_CLEANED_PREFIX   = "cleaned"
      SNOWFLAKE_ACCOUNT   = var.snowflake_account
      SNOWFLAKE_PASSWORD  = var.snowflake_password
      SNOWFLAKE_USER      = var.snowflake_user
      SNOWFLAKE_WAREHOUSE = "COMPUTE_WH"
    }
  }

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
    Project     = var.project_name
  }
}
