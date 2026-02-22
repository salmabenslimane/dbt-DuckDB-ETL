
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select price
from "app_market"."main"."stg_playstore_apps"
where price is null



  
  
      
    ) dbt_internal_test