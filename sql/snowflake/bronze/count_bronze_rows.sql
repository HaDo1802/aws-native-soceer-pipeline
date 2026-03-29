-- File: count_bronze_rows.sql
-- Purpose: Summarize bronze load results for one team and season after merge.
-- When to run: After MERGE completes to confirm row counts and latest scrape_date landed.
-- Dependencies: SOCCER_ANALYTICS database, BRONZE schema, PLAYER_STATS table.
-- Params that require manual substitution if running by hand: {team}, {season}
-- Documentation note: This file also serves as reference for the post-merge validation executed by the Python loader.
-- UPDATE THIS: Replace {team} and {season} before running manually in Snowflake.

SELECT
    team,
    season,
    COUNT(*) AS rows_in_bronze,
    COUNT(DISTINCT player_id) AS distinct_players,
    MAX(bronze_scrape_date) AS latest_bronze_scrape_date
FROM SOCCER_ANALYTICS.BRONZE.PLAYER_STATS
WHERE team = '{team}'
  AND season = '{season}'
GROUP BY team, season
