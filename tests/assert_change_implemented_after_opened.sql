select change_id from {{ ref('slv_changes') }} where implemented_at < opened_at
