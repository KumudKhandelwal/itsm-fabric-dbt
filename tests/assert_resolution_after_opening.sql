-- An incident cannot be resolved before it was opened.
select incident_id from {{ ref('slv_incidents') }} where resolved_at < opened_at
