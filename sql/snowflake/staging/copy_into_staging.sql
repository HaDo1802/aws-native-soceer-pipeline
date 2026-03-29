-- File: copy_into_staging.sql
-- Purpose: Copy one cleaned team-season scrape snapshot into STAGING.PLAYER_STATS_RAW.
-- When to run: After the cleaned CSV exists in the Snowflake external stage and before MERGE.
-- Dependencies: SOCCER_ANALYTICS database, STAGING schema, cleaned_stage external stage, PLAYER_STATS_RAW table.
-- Params that require manual substitution if running by hand: {team}, {season}, {scrape_date}
-- Documentation note: This file also serves as reference for what the Python loader executes programmatically.
-- UPDATE THIS: Replace {team}, {season}, and {scrape_date} before running manually in Snowflake.
-- UPDATE THIS: Keep FORCE = TRUE when you intentionally want to reload the same file again.
-- If you want Snowflake to skip files it has already loaded, remove FORCE = TRUE before manual execution.

COPY INTO SOCCER_ANALYTICS.STAGING.PLAYER_STATS_RAW
FROM @SOCCER_ANALYTICS.STAGING.cleaned_stage/transfermarkt/{team}/player_stats/{season}/scrape_date={scrape_date}.csv
FORCE = TRUE
MATCH_BY_COLUMN_NAME = CASE_INSENSITIVE
