select
    {{ dbt.date_trunc('month', 'resolved_date') }}                              as month_start,
    count(*)                                                                    as resolved_incidents,
    sum(case when is_breached then 1 else 0 end)                                as breached_incidents,
    round(1.0 - sum(case when is_breached then 1 else 0 end) * 1.0 / count(*), 4) as sla_compliance_rate
from {{ ref('fct_incidents') }}
where resolved_date is not null
group by {{ dbt.date_trunc('month', 'resolved_date') }}
