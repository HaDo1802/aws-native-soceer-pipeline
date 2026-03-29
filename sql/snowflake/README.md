# Snowflake SQL Reference

This folder contains Snowflake SQL files used as setup and validation documentation for the project. These files are intended for human review and manual execution in Snowflake.

## Folder Structure

- `setup/`
  - Initial Snowflake environment creation.
  - Database, schemas, storage integration, external stage, and tables.
- `staging/`
  - SQL that documents how cleaned S3 files are copied into the staging table.
- `bronze/`
  - SQL that documents how staging rows are merged into the persistent bronze table.
- `validate/`
  - Post-load validation queries for row counts, duplicates, null checks, and spot checks.

## Recommended Order

1. Run `setup/01_setup.sql`
2. Run `setup/02_tables.sql`
3. Run `setup/03_validate_setup.sql`
4. Run the Python or Lambda ingestion pipeline
5. Run `validate/04_validate_load.sql`

## Medallion Architecture

This project follows a medallion-style Snowflake layout:

- `STAGING`
  - temporary landing area for copied CSV rows
- `BRONZE`
  - merged historical record used as the durable ingestion layer
- `SILVER`
  - planned curated layer populated later by dbt
- `GOLD`
  - planned business-facing marts populated later by dbt

At this stage:

- `STAGING` and `BRONZE` are active in the ingestion pipeline
- `SILVER` and `GOLD` are reserved for dbt models and are not yet implemented

## Relationship to Python Code

The SQL files in `staging/` and `bronze/` also serve as references for the SQL executed programmatically by `src/loader/snowflake_loader.py`.

The `setup/` and `validate/` files are documentation and manual-run utilities only.
