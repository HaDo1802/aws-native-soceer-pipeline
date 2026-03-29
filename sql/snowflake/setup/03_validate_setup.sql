-- File: 03_validate_setup.sql
-- Purpose: Validate that the Snowflake setup completed correctly before the first pipeline run.
-- When to run: After 01_setup.sql and 02_tables.sql.
-- Dependencies: Database, schemas, stage, and tables must already exist.
-- Params that require manual substitution: none
-- Documentation note: This file is reference/setup SQL for humans and is NOT executed by Python code.
-- Expected result: All four schemas are listed, both tables exist, LIST returns stage connectivity, and both tables are empty before first ingest.

SHOW SCHEMAS IN DATABASE SOCCER_ANALYTICS;

SHOW TABLES LIKE 'PLAYER_STATS_RAW' IN SCHEMA SOCCER_ANALYTICS.STAGING;
SHOW TABLES LIKE 'PLAYER_STATS' IN SCHEMA SOCCER_ANALYTICS.BRONZE;

LIST @SOCCER_ANALYTICS.STAGING.cleaned_stage;

SELECT 'STAGING.PLAYER_STATS_RAW' AS table_name, COUNT(*) AS row_count
FROM SOCCER_ANALYTICS.STAGING.PLAYER_STATS_RAW
UNION ALL
SELECT 'BRONZE.PLAYER_STATS' AS table_name, COUNT(*) AS row_count
FROM SOCCER_ANALYTICS.BRONZE.PLAYER_STATS;
