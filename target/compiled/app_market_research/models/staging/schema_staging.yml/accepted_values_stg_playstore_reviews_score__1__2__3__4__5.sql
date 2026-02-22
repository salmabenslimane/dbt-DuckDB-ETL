
    
    

with all_values as (

    select
        score as value_field,
        count(*) as n_records

    from "app_market"."main"."stg_playstore_reviews"
    group by score

)

select *
from all_values
where value_field not in (
    '1','2','3','4','5'
)


