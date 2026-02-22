-- models/staging/stg_playstore_reviews.sql
-- Purpose: standardize the raw reviews data.
-- Transformations applied at this layer:
--   - Rename fields to snake_case (reviewId → review_id, appId → app_id)
--   - Cast timestamp string to TIMESTAMP type
--   - Coerce score to integer, filter out-of-range scores (valid: 1-5)
--   - Replace null/empty content with empty string
--   - Coerce thumbsUpCount to integer, default null to 0
--   - Remove rows with null review_id or null app_id (no key = unusable)
--   - Generate a surrogate key using md5 on review_id
-- No business logic or aggregations at this stage.

with raw as (
    select * from {{ ref('src_playstore_reviews') }}
),

cleaned as (
    select
        -- Surrogate key
        md5(reviewId)                                                   as review_sk,

        -- Natural keys
        reviewId                                                        as review_id,
        appId                                                           as app_id,

        -- User info
        userName                                                        as user_name,

        -- Score: cast and validate range
        try_cast(score as integer)                                      as score,

        -- Review content: normalize null/empty
        coalesce(nullif(trim(content), ''), '')                         as content,

        -- Engagement
        coalesce(try_cast(thumbsUpCount as integer), 0)                 as thumbs_up_count,

        -- Timestamp: cast to proper TIMESTAMP
        try_cast(at as timestamp)                                       as reviewed_at,

        -- Derived date key for joining to dim_date (YYYYMMDD integer format per Kimball)
        cast(strftime(try_cast(at as timestamp), '%Y%m%d') as integer)  as date_key

    from raw
    where reviewId is not null
      and appId    is not null
      -- Filter out-of-range scores (1-5 is the valid Play Store range)
      and try_cast(score as integer) between 1 and 5
)

select * from cleaned
