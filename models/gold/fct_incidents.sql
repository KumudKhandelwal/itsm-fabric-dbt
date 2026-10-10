{{ config(materialized='incremental', unique_key='incident_id', incremental_strategy=('merge' if target.type == 'fabricspark' else 'delete+insert')) }}

select
    i.incident_id,
    cast(i.opened_at as date)     as opened_date,
    cast(i.resolved_at as date)   as resolved_date,
    i.caller_id,
    i.assignment_group_id,
    i.ci_id,
    i.priority_level,
    i.category,
    i.state,
    i.reopen_count,
    s.resolution_hours,
    s.sla_target_hours,
    s.is_breached,
    i.updated_at
from {{ ref('slv_incidents') }} i
join {{ ref('slv_incident_sla') }} s on s.incident_id = i.incident_id
{% if is_incremental() %}
where i.updated_at > (select coalesce(max(updated_at), cast('1900-01-01' as timestamp)) from {{ this }})
{% endif %}
