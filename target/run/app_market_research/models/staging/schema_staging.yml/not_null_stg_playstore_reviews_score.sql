
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select score
from "app_market"."main"."stg_playstore_reviews"
where score is null



  
  
      
    ) dbt_internal_test