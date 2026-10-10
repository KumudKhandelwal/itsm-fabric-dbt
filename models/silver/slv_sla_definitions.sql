select
    cast(sla_id as int)                 as sla_id,
    {{ priority_level('priority') }}    as priority_level,
    cast(response_hours as int)         as response_hours,
    cast(resolution_hours as int)       as resolution_hours
from {{ ref('brz_sla_definitions') }}
