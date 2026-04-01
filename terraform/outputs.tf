# Lambda outputs.
output "scrape_roster_function_name" {
  description = "Function name for the roster scraping Lambda."
  value       = aws_lambda_function.scrape_roster.function_name
}

output "scrape_roster_function_arn" {
  description = "ARN for the roster scraping Lambda."
  value       = aws_lambda_function.scrape_roster.arn
}

output "scrape_players_function_name" {
  description = "Function name for the player scraping Lambda."
  value       = aws_lambda_function.scrape_players.function_name
}

output "scrape_players_function_arn" {
  description = "ARN for the player scraping Lambda."
  value       = aws_lambda_function.scrape_players.arn
}

output "combine_player_json_function_name" {
  description = "Function name for the combine-player-json Lambda."
  value       = aws_lambda_function.combine_player_json.function_name
}

output "combine_player_json_function_arn" {
  description = "ARN for the combine-player-json Lambda."
  value       = aws_lambda_function.combine_player_json.arn
}

output "clean_player_stats_function_name" {
  description = "Function name for the clean-player-stats Lambda."
  value       = aws_lambda_function.clean_player_stats.function_name
}

output "clean_player_stats_function_arn" {
  description = "ARN for the clean-player-stats Lambda."
  value       = aws_lambda_function.clean_player_stats.arn
}

output "snowflake_ingest_function_name" {
  description = "Function name for the snowflake-ingest Lambda."
  value       = aws_lambda_function.snowflake_ingest.function_name
}

output "snowflake_ingest_function_arn" {
  description = "ARN for the snowflake-ingest Lambda."
  value       = aws_lambda_function.snowflake_ingest.arn
}

output "lambda_exec_role_name" {
  description = "Execution role name for the Lambda functions."
  # This resolves to dev_lamda because iam.tf now matches the live AWS role name.
  value = aws_iam_role.lambda_exec.name
}

output "lambda_exec_role_arn" {
  description = "Execution role ARN for the Lambda functions."
  value       = aws_iam_role.lambda_exec.arn
}
