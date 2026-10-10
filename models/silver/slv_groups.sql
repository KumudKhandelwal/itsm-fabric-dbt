select
    cast(group_id as int)        as group_id,
    trim(group_name)             as group_name,
    lower(trim(group_type))      as group_type,
    cast(manager_id as int)      as manager_id
from {{ ref('brz_groups') }}
