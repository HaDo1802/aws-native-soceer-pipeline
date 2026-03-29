-- File: 04_validate_load.sql
-- Purpose: Validate the quality of loaded data after COPY + MERGE completes.
-- When to run: After a pipeline ingestion run succeeds.
-- Dependencies: STAGING.PLAYER_STATS_RAW and BRONZE.PLAYER_STATS must contain data.
-- Params that require manual substitution: optional team or season filters if you want a narrower validation.
-- Documentation note: This file is reference/setup SQL for humans and is NOT executed by Python code.

-- Row count by team and season.
SELECT
    team,
    season,
    COUNT(*) AS row_count
FROM SOCCER_ANALYTICS.BRONZE.PLAYER_STATS
GROUP BY team, season
ORDER BY team, season;

-- Duplicate check on the natural key.
-- Expected result: zero rows returned.
SELECT
    team,
    season,
    player_id,
    competition_code,
    matchday,
    COUNT(*) AS duplicate_count
FROM SOCCER_ANALYTICS.BRONZE.PLAYER_STATS
GROUP BY team, season, player_id, competition_code, matchday
HAVING COUNT(*) > 1;

-- Null rate check on critical columns.
SELECT
    COUNT(*) AS total_rows,
    SUM(IFF(player_id IS NULL, 1, 0)) AS null_player_id,
    SUM(IFF(season IS NULL, 1, 0)) AS null_season,
    SUM(IFF(matchday IS NULL, 1, 0)) AS null_matchday,
    SUM(IFF(match_date_iso IS NULL, 1, 0)) AS null_match_date_iso,
    SUM(IFF(club IS NULL, 1, 0)) AS null_club
FROM SOCCER_ANALYTICS.BRONZE.PLAYER_STATS;

-- Sample spot check.
SELECT
    team,
    season,
    player_name,
    player_id,
    competition_code,
    matchday,
    match_date_iso,
    goals,
    assists,
    bronze_scrape_date,
    ingested_at
FROM SOCCER_ANALYTICS.BRONZE.PLAYER_STATS
ORDER BY ingested_at DESC
LIMIT 25;
