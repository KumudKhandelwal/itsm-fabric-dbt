select
    cast(dept_id as int)         as dept_id,
    trim(dept_name)              as dept_name,
    trim(cost_center)            as cost_center
from {{ ref('brz_departments') }}
