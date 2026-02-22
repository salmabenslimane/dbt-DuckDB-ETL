
  
    
    

    create  table
      "app_market"."main"."fact_reviews"
  
    as (
      -- models/marts/facts/fact_reviews.sql
-- Purpose: analytics-ready fact table for app reviews.
-- Grain: one row per review event for one app at a given point in time.
--
-- Materialization: INCREMENTAL
--   - First run: full load of all reviews
--   - Subsequent runs: only new reviews (reviewed_at > max existing reviewed_at)
--   - Unique key: review_sk — prevents duplicate insertions on re-runs
--   - Inner joins on dim_apps and dim_date filter orphan foreign keys automatically



with reviews as (
    select * from "app_market"."main"."stg_playstore_reviews"

    -- Incremental filter: on subsequent runs, only process reviews
    -- more recent than the latest already loaded into the fact table
    
),

apps as (
    select app_id, app_sk, developer_sk, category_sk
    from "app_market"."main"."dim_apps"
),

dates as (
    select date_key
    from "app_market"."main"."dim_date"
)

select
    reviews.review_sk,
    apps.app_sk,
    apps.developer_sk,
    apps.category_sk,
    reviews.date_key,
    reviews.review_id,
    reviews.user_name,
    reviews.score,
    reviews.thumbs_up_count,
    reviews.reviewed_at,
    reviews.content
from reviews
inner join apps  on reviews.app_id   = apps.app_id
inner join dates on reviews.date_key = dates.date_key
    );
  
  
  