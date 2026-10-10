{{ config(materialized='incremental', unique_key='change_id', incremental_strategy=('merge' if target.type == 'fabricspark' else 'delete+insert')) }}

select
    c.change_id,
    cast(c.opened_at as date)        as opened_date,
    cast(c.implemented_at as date)   as implemented_date,
    c.ci_id,
    c.assignment_group_id,
    o.change_type,
    o.risk,
    o.success_flag,
    o.lead_time_hours,
    o.is_emergency,
    c.updated_at
from {{ ref('slv_changes') }} c
join {{ ref('slv_change_outcomes') }} o on o.change_id = c.change_id
{% if is_incremental() %}
where c.updated_at > (select coalesce(max(updated_at), cast('1900-01-01' as timestamp)) from {{ this }})
{% endif %}
