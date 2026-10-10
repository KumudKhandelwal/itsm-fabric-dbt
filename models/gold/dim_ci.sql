select ci_id, ci_name, ci_class, environment, criticality, owner_group_id
from {{ ref('slv_cmdb_ci') }}
