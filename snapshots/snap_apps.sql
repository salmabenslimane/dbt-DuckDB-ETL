-- snapshots/snap_apps.sql
-- Purpose: capture historical changes in app attributes using dbt snapshots (SCD Type 2).
-- Strategy: CHECK — dbt compares check_cols on every run and records a new version
--   of the row whenever any tracked column changes.
-- dbt automatically adds: dbt_scd_id, dbt_updated_at, dbt_valid_from, dbt_valid_to.
-- dbt_valid_to = NULL means the row is the current version.
--
-- Run with: dbt snapshot
-- Then verify: SELECT * FROM snapshots.snap_apps ORDER BY app_id, dbt_valid_from;

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
