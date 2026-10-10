{{ config(materialized='incremental', unique_key='request_id', incremental_strategy=('merge' if target.type == 'fabricspark' else 'delete+insert')) }}

select
    r.request_id,
    cast(r.opened_at as date)      as opened_date,
    cast(r.fulfilled_at as date)   as fulfilled_date,
    r.requested_for_id,
    r.assignment_group_id,
    r.catalog_item,
    r.state,
    f.fulfilment_hours,
    f.is_fulfilled,
    r.cost_eur,
    r.updated_at
from {{ ref('slv_requests') }} r
join {{ ref('slv_request_fulfilment') }} f on f.request_id = r.request_id
{% if is_incremental() %}
where r.updated_at > (select coalesce(max(updated_at), cast('1900-01-01' as timestamp)) from {{ this }})
{% endif %}
