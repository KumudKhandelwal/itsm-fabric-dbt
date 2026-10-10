select
    date_day,
    year,
    quarter,
    month,
    concat(cast(year as {{ dbt.type_string() }}), '-', lpad(cast(month as {{ dbt.type_string() }}), 2, '0')) as year_month,
    week_start
from {{ ref('slv_calendar') }}
