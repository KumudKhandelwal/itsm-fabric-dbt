select
    g.group_id,
    g.group_name,
    count(*)                                                      as incidents,
    round(avg(f.resolution_hours), 2)                             as avg_resolution_hours,
    round(sum(case when f.is_breached then 1 else 0 end) * 1.0
          / nullif(sum(case when f.is_breached is not null then 1 else 0 end), 0), 4) as sla_breach_rate
from {{ ref('fct_incidents') }} f
join {{ ref('dim_group') }} g on g.group_id = f.assignment_group_id
group by g.group_id, g.group_name
