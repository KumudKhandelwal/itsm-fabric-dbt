with d as (select cast(date_day as date) as date_day from {{ ref('brz_calendar') }})
select
    date_day,
    cast(extract(year from date_day) as int)      as year,
    cast(extract(quarter from date_day) as int)   as quarter,
    cast(extract(month from date_day) as int)     as month,
    {{ dbt.date_trunc('week', 'date_day') }}      as week_start
from d
