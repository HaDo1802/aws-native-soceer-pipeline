-- File: cleanup_staging.sql
-- Purpose: Remove old rows from STAGING.PLAYER_STATS_RAW after a successful merge.
-- When to run: After MERGE INTO BRONZE.PLAYER_STATS succeeds.
-- Dependencies: SOCCER_ANALYTICS database, STAGING schema, PLAYER_STATS_RAW table.
-- Params that require manual substitution: none
-- Documentation note: This file is reference SQL and is also executed programmatically by the Python loader.
-- Retention policy: Keep approximately two weeks of recent staging rows for replay/debugging, then delete older ones.

DELETE FROM SOCCER_ANALYTICS.STAGING.PLAYER_STATS_RAW
WHERE bronze_scrape_date < DATEADD(week, -2, CURRENT_DATE())
