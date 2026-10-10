select group_id, group_name, group_type from {{ ref('slv_groups') }}
