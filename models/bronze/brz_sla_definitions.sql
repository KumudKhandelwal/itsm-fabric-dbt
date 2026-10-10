-- Bronze: raw data as landed, plus load metadata. No business logic.
select
    *,
    current_timestamp as _loaded_at,
    'sla_definitions' as _source_table
from {{ raw('sla_definitions') }}
