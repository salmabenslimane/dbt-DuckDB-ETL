-- models/marts/dimensions/dim_apps.sql
-- Purpose: dimension table for apps.
-- One row per unique app.
-- Surrogate key: md5(app_id).
-- Hierarchy: dim_apps → dim_categories (via category_sk foreign key)
--            dim_apps → dim_developers (via developer_sk foreign key)
-- Conformed dimension: shared across all fact tables involving apps.

with stg as (
    select * from {{ ref('stg_playstore_apps') }}
),

categories as (
    select category_id, category_sk
    from {{ ref('dim_categories') }}
),

developers as (
    select developer_id, developer_sk
    from {{ ref('dim_developers') }}
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
