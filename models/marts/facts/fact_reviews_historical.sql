-- models/marts/facts/fact_reviews_historical.sql
-- Purpose: historical fact table that links each review to the version of the app
-- that was valid AT THE TIME the review was written (true point-in-time join).
--
-- This differs from fact_reviews which always joins to the CURRENT app version.
-- Without this model, a review written when an app was in "Productivity" would
-- incorrectly appear under "Education" if the category changed after the review.
--
-- Join logic (Kimball point-in-time):
--   reviewed_at >= valid_from AND (reviewed_at < valid_to OR valid_to IS NULL)
--
-- Materialization: incremental (same strategy as fact_reviews)

{{
    config(
        materialized='incremental',
        unique_key='review_sk'
    )
}}

with reviews as (
    select * from {{ ref('stg_playstore_reviews') }}

    {% if is_incremental() %}
        where reviewed_at > (select max(reviewed_at) from {{ this }})
    {% endif %}
),

-- Use the SCD2 dimension: one row per version of each app
apps_scd as (
    select
        app_version_sk,
        app_id,
        app_name,
        category_id,
        category_name,
        developer_id,
        developer_name,
        valid_from,
        valid_to,
        is_current
    from {{ ref('dim_apps_scd') }}
),

dates as (
    select date_key
    from {{ ref('dim_date') }}
)

select
    reviews.review_sk,

    -- Point-in-time surrogate key: version of the app valid at review time
    apps_scd.app_version_sk,

    reviews.date_key,
    reviews.review_id,
    reviews.user_name,

    -- Measures
    reviews.score,
    reviews.thumbs_up_count,
    reviews.reviewed_at,
    reviews.content,

    -- Carry SCD2 context directly for easier querying in BI tools
    apps_scd.app_name,
    apps_scd.category_name,
    apps_scd.developer_name,
    apps_scd.valid_from      as app_version_valid_from,
    apps_scd.valid_to        as app_version_valid_to,
    apps_scd.is_current      as app_is_current_version

from reviews

-- Point-in-time join: find the app version that was active when the review was written
inner join apps_scd
    on  reviews.app_id       = apps_scd.app_id
    and reviews.reviewed_at >= apps_scd.valid_from
    and (
        reviews.reviewed_at  < apps_scd.valid_to
        or apps_scd.valid_to is null   -- open-ended: current version
    )

-- Validate date key exists in dim_date
inner join dates
    on reviews.date_key = dates.date_key
