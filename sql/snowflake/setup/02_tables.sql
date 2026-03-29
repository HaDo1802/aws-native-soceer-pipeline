-- File: 02_tables.sql
-- Purpose: Create the STAGING and BRONZE tables used by the ingestion pipeline.
-- When to run: After 01_setup.sql and before the first ingestion run.
-- Dependencies: SOCCER_ANALYTICS database and schemas must already exist.
-- Params that require manual substitution: none
-- Documentation note: This file is reference/setup SQL for humans and is NOT executed by Python code.

-- STAGING table:
-- Holds raw copied CSV rows exactly as loaded from the cleaned S3 snapshot.
-- All business columns are VARCHAR so COPY INTO stays forgiving and simple.
CREATE OR REPLACE TABLE SOCCER_ANALYTICS.STAGING.PLAYER_STATS_RAW (
    season VARCHAR,
    season_label VARCHAR,
    bronze_scrape_date VARCHAR,
    transformed_at VARCHAR,
    club VARCHAR,
    player_name VARCHAR,
    player_id VARCHAR,
    competition_code VARCHAR,
    matchday VARCHAR,
    match_date VARCHAR,
    match_date_iso VARCHAR,
    venue VARCHAR,
    home_team VARCHAR,
    home_team_name VARCHAR,
    home_team_rank VARCHAR,
    away_team VARCHAR,
    away_team_name VARCHAR,
    away_team_rank VARCHAR,
    result VARCHAR,
    position VARCHAR,
    goals VARCHAR,
    assists VARCHAR,
    own_goals VARCHAR,
    yellow_cards VARCHAR,
    second_yellow_red_cards VARCHAR,
    red_cards VARCHAR,
    subbed_on_minute VARCHAR,
    subbed_off_minute VARCHAR,
    performance_rating VARCHAR,
    minutes_played VARCHAR,
    note VARCHAR
);

-- BRONZE table:
-- Holds the merged historical record for each natural key with ingestion metadata.
-- This is the persistent bronze layer that downstream dbt models can build from.
CREATE OR REPLACE TABLE SOCCER_ANALYTICS.BRONZE.PLAYER_STATS (
    team VARCHAR,
    season VARCHAR,
    season_label VARCHAR,
    bronze_scrape_date VARCHAR,
    transformed_at VARCHAR,
    club VARCHAR,
    player_name VARCHAR,
    player_id VARCHAR,
    competition_code VARCHAR,
    matchday VARCHAR,
    match_date VARCHAR,
    match_date_iso VARCHAR,
    venue VARCHAR,
    home_team VARCHAR,
    home_team_name VARCHAR,
    home_team_rank VARCHAR,
    away_team VARCHAR,
    away_team_name VARCHAR,
    away_team_rank VARCHAR,
    result VARCHAR,
    position VARCHAR,
    goals VARCHAR,
    assists VARCHAR,
    own_goals VARCHAR,
    yellow_cards VARCHAR,
    second_yellow_red_cards VARCHAR,
    red_cards VARCHAR,
    subbed_on_minute VARCHAR,
    subbed_off_minute VARCHAR,
    performance_rating VARCHAR,
    minutes_played VARCHAR,
    note VARCHAR,
    ingested_at TIMESTAMP_TZ DEFAULT CURRENT_TIMESTAMP()
);
