
  
  create view "app_market"."main"."stg_connection_check__dbt_tmp" as (
    -- models/staging/stg_connection_check.sql
-- Sanity check: proves dbt can connect to DuckDB and create objects.
-- Run with: dbt run --select stg_connection_check
-- Then verify in DuckDB CLI: SELECT * FROM stg_connection_check;
-- This file can be deleted once the connection is confirmed.

select
    1                    as ok,
    current_timestamp    as created_at
  );
