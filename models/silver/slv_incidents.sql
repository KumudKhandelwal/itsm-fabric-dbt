{{ config(materialized='incremental', unique_key='incident_id', incremental_strategy=('merge' if target.type == 'fabricspark' else 'delete+insert')) }}

-- Incremental on updated_at; keeps only the latest version of each incident.
with src as (
    select * from {{ ref('brz_incidents') }}
    {% if is_incremental() %}
    where cast(updated_at as timestamp) > (select coalesce(max(updated_at), cast('1900-01-01' as timestamp)) from {{ this }})
    {% endif %}
),
ranked as (
    select *, row_number() over (partition by incident_id order by cast(updated_at as timestamp) desc) as rn
    from src
)
select
    trim(incident_id)                        as incident_id,
    cast(opened_at as timestamp)             as opened_at,
    cast(resolved_at as timestamp)           as resolved_at,
    cast(closed_at as timestamp)             as closed_at,
    cast(caller_id as int)                   as caller_id,
    cast(assignment_group_id as int)         as assignment_group_id,
    {{ priority_level('priority') }}         as priority_level,
    trim(state)                              as state,
    lower(trim(category))                    as category,
    cast(ci_id as int)                       as ci_id,
    trim(short_description)                  as short_description,
    cast(reopen_count as int)                as reopen_count,
    cast(updated_at as timestamp)            as updated_at
from ranked
where rn = 1
