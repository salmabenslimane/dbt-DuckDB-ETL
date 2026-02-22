-- models/staging/src_playstore_apps.sql
-- Purpose: expose the raw apps_metadata.json file as a dbt relation.
-- This is a source model only — no transformations, no business logic.
-- DuckDB's read_json_auto() infers the schema from the JSON file.
-- Materialized as view: no cost, always reads fresh from disk.

select *
from read_json_auto('{{ env_var("DBT_RAW_DATA_PATH", "data/raw") }}/apps_metadata.json')
