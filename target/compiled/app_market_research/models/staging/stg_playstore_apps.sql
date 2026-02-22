-- models/staging/stg_playstore_apps.sql
-- Purpose: standardize the raw apps data.
-- Transformations applied at this layer:
--   - Rename fields to snake_case (appId → app_id)
--   - Cast fields to correct types (score → double, installs → bigint)
--   - Clean installs: strip commas and "+" from strings like "1,000,000+"
--   - Flatten nested categories list: extract first category name and id
--   - Remove rows with null app_id (no key = unusable)
--   - Generate a surrogate key using md5 on app_id
-- No business logic or aggregations at this stage.

with raw as (
    select * from "app_market"."main"."src_playstore_apps"
),

cleaned as (
    select
        -- Surrogate key: md5 hash of the natural key
        md5(appId)                                                      as app_sk,

        -- Natural key
        appId                                                           as app_id,

        -- Descriptive attributes
        title                                                           as app_name,
        developer                                                       as developer_name,
        developerId                                                     as developer_id,
        developerEmail                                                  as developer_email,
        developerWebsite                                                as developer_website,

        -- Category: flatten first element of the categories list
        categories[1]['name']::varchar                                  as category_name,
        categories[1]['id']::varchar                                    as category_id,

        -- Genre (simpler single-value field, kept as fallback)
        genre                                                           as genre,

        -- Ratings and score
        try_cast(score as double)                                       as score,
        try_cast(ratings as bigint)                                     as ratings_count,

        -- Installs: clean "1,000,000+" → 1000000
        try_cast(
            regexp_replace(
                regexp_replace(coalesce(installs, '0'), ',', '', 'g'),
                '\+', '', 'g'
            ) as bigint
        )                                                               as installs,

        -- Pricing
        try_cast(price as double)                                       as price,
        free                                                            as is_free,

        -- App metadata
        minInstalls                                                     as min_installs,
        contentRating                                                   as content_rating,
        released                                                        as released_at,
        updated                                                         as updated_at

    from raw
    where appId is not null   -- drop rows with no primary key
)

select * from cleaned