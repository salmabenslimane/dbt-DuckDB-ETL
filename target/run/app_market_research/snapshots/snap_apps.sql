
      
  
    
    

    create  table
      "app_market"."snapshots"."snap_apps"
  
    as (
      
    

    select *,
        md5(coalesce(cast(app_id as varchar ), '')
         || '|' || coalesce(cast(now()::timestamp as varchar ), '')
        ) as dbt_scd_id,
        now()::timestamp as dbt_updated_at,
        now()::timestamp as dbt_valid_from,
        
  
  coalesce(nullif(now()::timestamp, now()::timestamp), null)
  as dbt_valid_to
from (
        



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
from "app_market"."main"."stg_playstore_apps"

    ) sbq



    );
  
  
  