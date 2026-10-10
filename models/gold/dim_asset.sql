select asset_id, asset_tag, asset_type, model, status, purchase_date, cost_eur
from {{ ref('slv_assets') }}
