select
    {{ dbt.date_trunc('month', 'implemented_date') }}                                   as month_start,
    count(*)                                                                            as implemented_changes,
    sum(case when success_flag then 1 else 0 end)                                       as successful_changes,
    round(sum(case when success_flag then 1 else 0 end) * 1.0 / count(*), 4)            as change_success_rate,
    sum(case when is_emergency then 1 else 0 end)                                       as emergency_changes
from {{ ref('fct_changes') }}
where implemented_date is not null
group by {{ dbt.date_trunc('month', 'implemented_date') }}
