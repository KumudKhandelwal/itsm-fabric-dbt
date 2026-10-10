select f.incident_id from {{ ref('fct_incidents') }} f
left join {{ ref('dim_priority') }} p on p.priority_level = f.priority_level
where p.priority_level is null
