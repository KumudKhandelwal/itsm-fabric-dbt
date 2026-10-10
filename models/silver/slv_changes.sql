{{ config(materialized='incremental', unique_key='change_id', incremental_strategy=('merge' if target.type == 'fabricspark' else 'delete+insert')) }}

with src as (
    select * from {{ ref('brz_changes') }}
    {% if is_incremental() %}
    where cast(updated_at as timestamp) > (select coalesce(max(updated_at), cast('1900-01-01' as timestamp)) from {{ this }})
    {% endif %}
),
ranked as (
    select *, row_number() over (partition by change_id order by cast(updated_at as timestamp) desc) as rn
    from src
)
select
    trim(change_id)                          as change_id,
    cast(opened_at as timestamp)             as opened_at,
    cast(implemented_at as timestamp)        as implemented_at,
    lower(trim(change_type))                 as change_type,
    lower(trim(risk))                        as risk,
    trim(state)                              as state,
    cast(ci_id as int)                       as ci_id,
    cast(assignment_group_id as int)         as assignment_group_id,
    {{ flag_to_boolean('success_flag') }}    as success_flag,
    cast(updated_at as timestamp)            as updated_at
from ranked
where rn = 1
