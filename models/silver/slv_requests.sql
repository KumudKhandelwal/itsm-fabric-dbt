{{ config(materialized='incremental', unique_key='request_id', incremental_strategy=('merge' if target.type == 'fabricspark' else 'delete+insert')) }}

with src as (
    select * from {{ ref('brz_requests') }}
    {% if is_incremental() %}
    where cast(updated_at as timestamp) > (select coalesce(max(updated_at), cast('1900-01-01' as timestamp)) from {{ this }})
    {% endif %}
),
ranked as (
    select *, row_number() over (partition by request_id order by cast(updated_at as timestamp) desc) as rn
    from src
)
select
    trim(request_id)                         as request_id,
    cast(opened_at as timestamp)             as opened_at,
    cast(fulfilled_at as timestamp)          as fulfilled_at,
    cast(requested_for_id as int)            as requested_for_id,
    cast(assignment_group_id as int)         as assignment_group_id,
    trim(catalog_item)                       as catalog_item,
    trim(state)                              as state,
    {{ priority_level('priority') }}         as priority_level,
    cast(cost_eur as decimal(12, 2))         as cost_eur,
    cast(updated_at as timestamp)            as updated_at
from ranked
where rn = 1
