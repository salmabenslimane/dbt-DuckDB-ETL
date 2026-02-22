
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select category_sk
from "app_market"."main"."dim_apps"
where category_sk is null



  
  
      
    ) dbt_internal_test