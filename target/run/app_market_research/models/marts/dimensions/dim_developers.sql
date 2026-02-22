
  
    
    

    create  table
      "app_market"."main"."dim_developers__dbt_tmp"
  
    as (
      -- models/marts/dimensions/dim_developers.sql
-- Purpose: dimension table for app developers.
-- One row per unique developer.
-- Surrogate key: md5(developer_id).
-- Conformed dimension: shared across any future fact tables that involve developers.

with stg as (
    select distinct
        developer_id,
        developer_name,
        developer_email,
        developer_website
    from "app_market"."main"."stg_playstore_apps"
    where developer_id is not null
)

select
    md5(developer_id)   as developer_sk,
    developer_id,
    developer_name,
    developer_email,
    developer_website
from stg
    );
  
  