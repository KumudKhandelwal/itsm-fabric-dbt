select
    cast(ci_id as int)             as ci_id,
    trim(ci_name)                  as ci_name,
    lower(trim(ci_class))          as ci_class,
    lower(trim(environment))       as environment,
    cast(owner_group_id as int)    as owner_group_id,
    cast(criticality as int)       as criticality
from {{ ref('brz_cmdb_ci') }}
