-- models/marts/dimensions/dim_apps_scd.sql
-- Purpose: SCD Type 2 dimension for apps built from the snap_apps snapshot.
-- One row per version of each app — historical rows are preserved when attributes change.
-- dbt_valid_to = NULL identifies the current (open) version of each app.
-- is_current flag added for easier querying of current state in BI tools.
--
-- Use this model instead of dim_apps when historical analysis is needed:
-- e.g. "link each review to the category the app belonged to at review time"

with snapshot as (
    select * from {{ ref('snap_apps') }}
)

select
    -- Surrogate key: scoped to the specific version of the app
    md5(app_id || dbt_valid_from::varchar)  as app_version_sk,

    -- Natural key
    app_id,

    -- App attributes (as they were during the validity window)
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

    -- SCD2 validity window (added automatically by dbt snapshot)
    dbt_valid_from                          as valid_from,
    dbt_valid_to                            as valid_to,

    -- Convenience flag: current version = open row (valid_to is null)
    case when dbt_valid_to is null
        then true else false end            as is_current

from snapshot
