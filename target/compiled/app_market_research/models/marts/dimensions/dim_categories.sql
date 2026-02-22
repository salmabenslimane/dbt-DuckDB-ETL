-- models/marts/dimensions/dim_categories.sql
-- Purpose: dimension table for app categories.
-- One row per unique category.
-- Surrogate key: md5(category_id).
-- Position in hierarchy: dim_apps → dim_categories (snowflake normalization).
-- Conformed dimension: reusable across future fact tables.

with stg as (
    select distinct
        category_id,
        category_name
    from "app_market"."main"."stg_playstore_apps"
    where category_id is not null
)

select
    md5(category_id)    as category_sk,
    category_id,
    category_name
from stg