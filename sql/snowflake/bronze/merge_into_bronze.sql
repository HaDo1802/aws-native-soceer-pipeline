-- File: merge_into_bronze.sql
-- Purpose: Merge one team-season-scrape_date snapshot from staging into BRONZE.PLAYER_STATS.
-- When to run: After COPY INTO STAGING succeeds and row-count guard passes.
-- Dependencies: SOCCER_ANALYTICS database, STAGING schema, BRONZE schema, PLAYER_STATS_RAW table, PLAYER_STATS table.
-- Params that require manual substitution if running by hand: {team}, {season}, {scrape_date}
-- Documentation note: This file also serves as reference for what the Python loader executes programmatically.
-- UPDATE THIS: Replace {team}, {season}, and {scrape_date} before running manually in Snowflake.
-- Design note: MERGE is used instead of TRUNCATE + INSERT so the target table can update corrected historical rows and insert only newly observed natural keys.

MERGE INTO SOCCER_ANALYTICS.BRONZE.PLAYER_STATS AS target
USING (
    SELECT
        '{team}' AS team,
        season,
        season_label,
        bronze_scrape_date,
        transformed_at,
        club,
        player_name,
        player_id,
        competition_code,
        matchday,
        match_date,
        match_date_iso,
        venue,
        home_team,
        home_team_name,
        home_team_rank,
        away_team,
        away_team_name,
        away_team_rank,
        result,
        position,
        goals,
        assists,
        own_goals,
        yellow_cards,
        second_yellow_red_cards,
        red_cards,
        subbed_on_minute,
        subbed_off_minute,
        performance_rating,
        minutes_played,
        note
    FROM SOCCER_ANALYTICS.STAGING.PLAYER_STATS_RAW
    WHERE season = '{season}'
      AND bronze_scrape_date = '{scrape_date}'
    QUALIFY ROW_NUMBER() OVER (
        PARTITION BY
            '{team}',
            season,
            player_id,
            competition_code,
            matchday
        ORDER BY transformed_at DESC
    ) = 1
) AS source
ON target.team = source.team
   AND target.season = source.season
   AND target.player_id = source.player_id
   AND target.competition_code = source.competition_code
   AND target.matchday = source.matchday
WHEN MATCHED THEN UPDATE SET
    target.season_label = source.season_label,
    target.bronze_scrape_date = source.bronze_scrape_date,
    target.transformed_at = source.transformed_at,
    target.club = source.club,
    target.player_name = source.player_name,
    target.match_date = source.match_date,
    target.match_date_iso = source.match_date_iso,
    target.venue = source.venue,
    target.home_team = source.home_team,
    target.home_team_name = source.home_team_name,
    target.home_team_rank = source.home_team_rank,
    target.away_team = source.away_team,
    target.away_team_name = source.away_team_name,
    target.away_team_rank = source.away_team_rank,
    target.result = source.result,
    target.position = source.position,
    target.goals = source.goals,
    target.assists = source.assists,
    target.own_goals = source.own_goals,
    target.yellow_cards = source.yellow_cards,
    target.second_yellow_red_cards = source.second_yellow_red_cards,
    target.red_cards = source.red_cards,
    target.subbed_on_minute = source.subbed_on_minute,
    target.subbed_off_minute = source.subbed_off_minute,
    target.performance_rating = source.performance_rating,
    target.minutes_played = source.minutes_played,
    target.note = source.note,
    target.ingested_at = CURRENT_TIMESTAMP()
WHEN NOT MATCHED THEN INSERT (
    team,
    season,
    season_label,
    bronze_scrape_date,
    transformed_at,
    club,
    player_name,
    player_id,
    competition_code,
    matchday,
    match_date,
    match_date_iso,
    venue,
    home_team,
    home_team_name,
    home_team_rank,
    away_team,
    away_team_name,
    away_team_rank,
    result,
    position,
    goals,
    assists,
    own_goals,
    yellow_cards,
    second_yellow_red_cards,
    red_cards,
    subbed_on_minute,
    subbed_off_minute,
    performance_rating,
    minutes_played,
    note,
    ingested_at
) VALUES (
    source.team,
    source.season,
    source.season_label,
    source.bronze_scrape_date,
    source.transformed_at,
    source.club,
    source.player_name,
    source.player_id,
    source.competition_code,
    source.matchday,
    source.match_date,
    source.match_date_iso,
    source.venue,
    source.home_team,
    source.home_team_name,
    source.home_team_rank,
    source.away_team,
    source.away_team_name,
    source.away_team_rank,
    source.result,
    source.position,
    source.goals,
    source.assists,
    source.own_goals,
    source.yellow_cards,
    source.second_yellow_red_cards,
    source.red_cards,
    source.subbed_on_minute,
    source.subbed_off_minute,
    source.performance_rating,
    source.minutes_played,
    source.note,
    CURRENT_TIMESTAMP()
)
