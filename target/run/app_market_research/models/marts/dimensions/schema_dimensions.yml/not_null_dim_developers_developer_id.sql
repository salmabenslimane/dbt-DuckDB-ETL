
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select developer_id
from "app_market"."main"."dim_developers"
where developer_id is null



  
  
      
    ) dbt_internal_test