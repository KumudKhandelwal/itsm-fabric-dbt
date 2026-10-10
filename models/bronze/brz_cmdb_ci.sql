-- Bronze: raw data as landed, plus load metadata. No business logic.
select
    *,
    current_timestamp as _loaded_at,
    'cmdb_ci' as _source_table
from {{ raw('cmdb_ci') }}
