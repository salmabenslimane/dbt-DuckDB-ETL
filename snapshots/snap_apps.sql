-- snapshots/snap_apps.sql
-- Purpose: capture historical changes in app attributes using dbt snapshots (SCD Type 2).
-- Strategy: CHECK — dbt compares check_cols on every run and creates a new version
--   of the row whenever any tracked column changes.
-- dbt automatically adds: dbt_scd_id, dbt_updated_at, dbt_valid_from, dbt_valid_to.
-- dbt_valid_to = NULL means the row is the current (open) version.
--
-- To simulate a change for testing:
--   1. Edit apps_metadata.json — change a category or app name
--   2. Run: dbt run --select stg_playstore_apps
--   3. Run: dbt snapshot
--   4. Query snap_apps: you should see two rows for that app_id,
--      one with dbt_valid_to set (closed) and one with dbt_valid_to null (open)

{% snapshot snap_apps %}

{{
    config(
        target_schema='snapshots',
        unique_key='app_id',
        strategy='check',
        check_cols=[
            'app_name',
            'category_name',
            'category_id',
            'developer_name',
            'score',
            'installs',
            'price',
            'is_free',
            'content_rating'
        ]
    )
}}

select
    app_id,
    app_name,
    developer_id,
    developer_name,
    developer_email,
    developer_website,
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
    updated_at
from {{ ref('stg_playstore_apps') }}

{% endsnapshot %}
