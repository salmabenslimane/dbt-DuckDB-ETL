
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select developer_sk
from "app_market"."main"."dim_apps"
where developer_sk is null



  
  
      
    ) dbt_internal_test