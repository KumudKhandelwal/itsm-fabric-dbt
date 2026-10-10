select
    {{ dbt.date_trunc('month', 'opened_date') }}             as month_start,
    count(*)                                                 as requests,
    sum(case when is_fulfilled then 1 else 0 end)            as fulfilled_requests,
    round(avg(fulfilment_hours), 2)                          as avg_fulfilment_hours,
    round(sum(cost_eur), 2)                                  as total_cost_eur
from {{ ref('fct_requests') }}
group by {{ dbt.date_trunc('month', 'opened_date') }}
