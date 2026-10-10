select
    change_id,
    change_type,
    risk,
    opened_at,
    implemented_at,
    success_flag,
    case when implemented_at is not null
         then {{ dbt.datediff('opened_at', 'implemented_at', 'hour') }} end  as lead_time_hours,
    change_type = 'emergency'                                                 as is_emergency
from {{ ref('slv_changes') }}
