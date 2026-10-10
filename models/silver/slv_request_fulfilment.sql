select
    request_id,
    opened_at,
    fulfilled_at,
    case when fulfilled_at is not null
         then {{ dbt.datediff('opened_at', 'fulfilled_at', 'hour') }} end   as fulfilment_hours,
    fulfilled_at is not null                                                 as is_fulfilled
from {{ ref('slv_requests') }}
