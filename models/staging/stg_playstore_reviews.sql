-- models/staging/stg_playstore_reviews.sql
-- Fix: 'at' is a reserved keyword in DuckDB — must be quoted as "at"
-- Fix: date_key uses strftime on the quoted column

with raw as (
    select * from {{ ref('src_playstore_reviews') }}
),

cleaned as (
    select
        md5(reviewId::varchar)                                              as review_sk,
        reviewId::varchar                                                   as review_id,
        appId::varchar                                                      as app_id,
        userName                                                            as user_name,
        try_cast(score as integer)                                          as score,
        coalesce(nullif(trim(content), ''), '')                             as content,
        coalesce(try_cast(thumbsUpCount as integer), 0)                     as thumbs_up_count,
        try_cast("at" as timestamp)                                         as reviewed_at,
        cast(strftime(try_cast("at" as timestamp), '%Y%m%d') as integer)    as date_key
    from raw
    where reviewId is not null
      and appId    is not null
      and try_cast(score as integer) between 1 and 5
)

select * from cleaned
