-- Resolution time and SLA breach flag per incident.
select
    i.incident_id,
    i.priority_level,
    i.opened_at,
    i.resolved_at,
    case when i.resolved_at is not null
         then {{ dbt.datediff('i.opened_at', 'i.resolved_at', 'hour') }} end   as resolution_hours,
    s.resolution_hours                                                          as sla_target_hours,
    case when i.resolved_at is null then null
         else {{ dbt.datediff('i.opened_at', 'i.resolved_at', 'hour') }} > s.resolution_hours end as is_breached
from {{ ref('slv_incidents') }} i
left join {{ ref('slv_sla_definitions') }} s on s.priority_level = i.priority_level
