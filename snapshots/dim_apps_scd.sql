-- models/marts/dimensions/dim_apps_scd.sql
-- Purpose: SCD Type 2 dimension for apps built from the snap_apps snapshot.
-- One row per version of each app.
-- Historical rows are preserved when tracked attributes change.
-- dbt_valid_to = NULL identifies the current open version.
-- is_current flag added for easier querying of current state in BI tools.
--
-- Use this model (instead of dim_apps) when historical analysis is needed:
-- e.g. "link each review to the category the app belonged to at review time"
-- → see fact_reviews_historical.sql for the point-in-time join pattern.

with snapshot as (
    select * from {{ ref('snap_apps') }}
)

select
    -- Version-scoped surrogate key: unique per app per validity window
    md5(app_id || dbt_valid_from::varchar)  as app_version_sk,

    -- Natural key (same across all versions of the same app)
    app_id,

    -- App attributes as they were during the validity window
    app_name,
    developer_id,
    developer_name,
    category_id,
    category_name,
    genre,
    score,
    ratings_count,
    installs,
    price,
    is_free,
    content_rating,
    released_at,
    updated_at,

    -- SCD2 validity window (managed automatically by dbt snapshot)
    dbt_valid_from  as valid_from,
    dbt_valid_to    as valid_to,

    -- Convenience flag: current version = open row (valid_to is null)
    case when dbt_valid_to is null
        then true else false end    as is_current

from snapshot
