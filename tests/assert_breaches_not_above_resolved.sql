select month_start from {{ ref('kpi_sla_compliance_monthly') }}
where breached_incidents > resolved_incidents
