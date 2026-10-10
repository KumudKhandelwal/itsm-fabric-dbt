select
    {{ dbt.date_trunc('week', 'opened_date') }}                  as week_start,
    count(*)                                                     as opened_incidents,
    sum(case when resolved_date is null then 1 else 0 end)       as still_open_incidents
from {{ ref('fct_incidents') }}
group by {{ dbt.date_trunc('week', 'opened_date') }}
