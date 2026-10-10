select
    priority_level,
    case priority_level when 1 then 'Critical' when 2 then 'High' when 3 then 'Moderate' else 'Low' end as priority_label,
    response_hours   as response_target_hours,
    resolution_hours as resolution_target_hours
from {{ ref('slv_sla_definitions') }}
