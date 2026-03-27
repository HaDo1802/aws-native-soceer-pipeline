import os
import unittest
from unittest.mock import MagicMock, patch

from lambda_deployment.clean_player_stats_handler import handler


class CleanPlayerStatsHandlerTests(unittest.TestCase):
    @patch("lambda_deployment.clean_player_stats_handler._clean_season")
    @patch("lambda_deployment.clean_player_stats_handler.boto3.client")
    def test_handler_cleans_single_requested_season(self, mock_boto3_client, mock_clean_season) -> None:
        os.environ["S3_BUCKET"] = "sport-analysis"
        os.environ["S3_BRONZE_PREFIX"] = "bronze"
        os.environ["S3_SILVER_PREFIX"] = "silver"

        mock_boto3_client.return_value = MagicMock()
        mock_clean_season.return_value = {
            "team": "manchester_united",
            "season": "2025",
            "scrape_date": "2026-03-27",
            "silver_key": "silver/transfermarkt/manchester_united/player_stats/2025/scrape_date=2026-03-27.csv",
        }

        result = handler(
            {
                "team": "manchester_united",
                "season": "2025",
                "scrape_date": "2026-03-27",
            },
            None,
        )

        self.assertEqual(200, result["statusCode"])
        self.assertEqual(1, result["seasons_cleaned"])
        self.assertEqual("2025", result["results"][0]["season"])
        self.assertEqual("2026-03-27", result["results"][0]["scrape_date"])
        mock_clean_season.assert_called_once()

    @patch("lambda_deployment.clean_player_stats_handler._clean_season")
    @patch("lambda_deployment.clean_player_stats_handler._resolve_scrape_date")
    @patch("lambda_deployment.clean_player_stats_handler.boto3.client")
    def test_handler_resolves_latest_scrape_date_for_multiple_seasons(
        self,
        mock_boto3_client,
        mock_resolve_scrape_date,
        mock_clean_season,
    ) -> None:
        os.environ["S3_BUCKET"] = "sport-analysis"
        os.environ["S3_BRONZE_PREFIX"] = "bronze"
        os.environ["S3_SILVER_PREFIX"] = "silver"

        mock_boto3_client.return_value = MagicMock()
        mock_resolve_scrape_date.side_effect = ["2026-03-26", "2026-03-27"]
        mock_clean_season.side_effect = [
            {
                "team": "manchester_united",
                "season": "2024",
                "scrape_date": "2026-03-26",
                "silver_key": "silver/transfermarkt/manchester_united/player_stats/2024/scrape_date=2026-03-26.csv",
            },
            {
                "team": "manchester_united",
                "season": "2025",
                "scrape_date": "2026-03-27",
                "silver_key": "silver/transfermarkt/manchester_united/player_stats/2025/scrape_date=2026-03-27.csv",
            },
        ]

        result = handler(
            {
                "team": "manchester_united",
                "seasons": ["2024", "2025"],
            },
            None,
        )

        self.assertEqual(200, result["statusCode"])
        self.assertEqual(2, result["seasons_cleaned"])
        self.assertEqual(["2024", "2025"], [item["season"] for item in result["results"]])
        self.assertEqual(2, mock_resolve_scrape_date.call_count)
        self.assertEqual(2, mock_clean_season.call_count)


if __name__ == "__main__":
    unittest.main()
