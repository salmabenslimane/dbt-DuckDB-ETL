
  
    
    

    create  table
      "app_market"."main"."dim_apps__dbt_tmp"
  
    as (
      -- models/marts/dimensions/dim_apps.sql
-- Fix: added WHERE category_id IS NOT NULL to prevent null category_sk
-- which was causing not_null test failure for one app with no category in raw data.
-- Apps with no category are excluded from the dimension — they will be filtered
-- out of fact_reviews via the inner join on app_sk.

with stg as (
    select * from "app_market"."main"."stg_playstore_apps"
    where category_id is not null   -- exclude apps with no category
),

categories as (
    select category_id, category_sk
    from "app_market"."main"."dim_categories"
),

developers as (
    select developer_id, developer_sk
    from "app_market"."main"."dim_developers"
)

select
    stg.app_sk,
    stg.app_id,
    stg.app_name,
    stg.score              as app_score,
    stg.ratings_count,
    stg.installs,
    stg.price,
    stg.is_free,
    stg.content_rating,
    stg.released_at,
    stg.updated_at,
    cat.category_sk,
    dev.developer_sk
from stg
left join categories cat on stg.category_id = cat.category_id
left join developers dev  on stg.developer_id = dev.developer_id
    );
  
  