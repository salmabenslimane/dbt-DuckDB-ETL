
    
    

select
    developer_id as unique_field,
    count(*) as n_records

from "app_market"."main"."dim_developers"
where developer_id is not null
group by developer_id
having count(*) > 1


