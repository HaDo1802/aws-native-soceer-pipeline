import argparse
import os
from pathlib import Path
import sys

from dotenv import load_dotenv

ROOT_DIR = Path(__file__).resolve().parents[1]
if str(ROOT_DIR) not in sys.path:
    sys.path.insert(0, str(ROOT_DIR))

from src.loader import snowflake_loader
from utils.config import Config
from utils.logger import get_logger


LOGGER = get_logger(__name__)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--team", required=True)
    parser.add_argument("--season", required=True)
    parser.add_argument("--scrape-date", required=True)
    args = parser.parse_args()

    load_dotenv()

    base_config = Config()
    config = base_config.for_team(args.team)
    try:
        os.environ["SNOWFLAKE_ACCOUNT"] = _required_env("SNOWFLAKE_ACCOUNT")
        os.environ["SNOWFLAKE_USER"] = _required_env("SNOWFLAKE_USER")
        os.environ["SNOWFLAKE_PASSWORD"] = _required_env("SNOWFLAKE_PASSWORD")
        os.environ["SNOWFLAKE_WAREHOUSE"] = _optional_env("SNOWFLAKE_WAREHOUSE", "COMPUTE_WH")
        result = snowflake_loader.ingest_season(
            team=config.TEAM_KEY,
            season=args.season,
            scrape_date=args.scrape_date,
            config=config,
        )
        print("Snowflake ingest completed successfully")
        print(f"Team: {result['team']}")
        print(f"Season: {result['season']}")
        print(f"Scrape date: {result['scrape_date']}")
        print(f"Rows staged: {result['rows_staged']}")
        print(f"Rows merged: {result['rows_merged']}")
        print(f"Rows in bronze: {result['rows_in_bronze']}")
    except Exception as exc:
        print(f"Snowflake ingest failed: {exc}")
        LOGGER.exception("Top-level Snowflake ingest run failed: %s", exc)
        raise SystemExit(1)


def _required_env(name: str) -> str:
    import os

    value = os.environ.get(name)
    if not value:
        raise ValueError(f"Missing required environment variable: {name}")
    return value


def _optional_env(name: str, default: str) -> str:
    import os

    return os.environ.get(name, default)


if __name__ == "__main__":
    main()
