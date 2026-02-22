
  
    
    

    create  table
      "app_market"."main"."dim_date__dbt_tmp"
  
    as (
      -- models/marts/dimensions/dim_date.sql
-- Purpose: conformed date dimension shared across all fact tables.
-- Generates a continuous range of dates anchored to the min/max review dates.
-- Date key format: YYYYMMDD integer (Kimball standard).
-- One row per calendar day.

with date_spine as (
    select
        min(reviewed_at)::date  as start_date,
        max(reviewed_at)::date  as end_date
    from "app_market"."main"."stg_playstore_reviews"
),

all_dates as (
    select
        unnest(
            generate_series(
                (select start_date from date_spine),
                (select end_date   from date_spine),
                interval '1 day'
            )
        )::date as calendar_date
)

select
    cast(strftime(calendar_date, '%Y%m%d') as integer)     as date_key,
    calendar_date,
    extract(year    from calendar_date)::integer            as year,
    extract(quarter from calendar_date)::integer            as quarter,
    extract(month   from calendar_date)::integer            as month,
    strftime(calendar_date, '%B')                           as month_name,
    extract(week    from calendar_date)::integer            as week_of_year,
    extract(day     from calendar_date)::integer            as day_of_month,
    extract(dow     from calendar_date)::integer            as day_of_week,
    strftime(calendar_date, '%A')                           as day_name,
    case when extract(dow from calendar_date) in (0, 6)
        then true else false end                            as is_weekend,
    strftime(calendar_date, '%Y-%m')                        as year_month
from all_dates
order by calendar_date
    );
  
  