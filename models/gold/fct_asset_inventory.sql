select
    asset_id,
    assigned_user_id,
    location_id,
    asset_type,
    status,
    cost_eur,
    purchase_date,
    {{ dbt.datediff('purchase_date', 'current_date', 'day') }} as age_days
from {{ ref('slv_assets') }}
