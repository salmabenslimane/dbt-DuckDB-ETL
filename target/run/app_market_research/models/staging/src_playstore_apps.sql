
  
  create view "app_market"."main"."src_playstore_apps__dbt_tmp" as (
    -- models/staging/src_playstore_apps.sql
-- Purpose: expose the raw apps_metadata.json file as a dbt relation.
-- This is a source model only — no transformations, no business logic.
-- DuckDB's read_json_auto() infers the schema from the JSON file.
-- Materialized as view: no cost, always reads fresh from disk.

select *
from read_json_auto('data/raw/apps_metadata.json')
  );
