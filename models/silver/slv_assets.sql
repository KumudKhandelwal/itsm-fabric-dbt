select
    cast(asset_id as int)              as asset_id,
    upper(trim(asset_tag))             as asset_tag,
    lower(trim(asset_type))            as asset_type,
    trim(model)                        as model,
    lower(trim(status))                as status,
    cast(assigned_user_id as int)      as assigned_user_id,
    cast(location_id as int)           as location_id,
    cast(purchase_date as date)        as purchase_date,
    cast(cost_eur as decimal(12, 2))   as cost_eur
from {{ ref('brz_assets') }}
