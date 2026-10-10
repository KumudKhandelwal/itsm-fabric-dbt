-- Gold fact must hold exactly one row per Silver incident.
select 1
where (select count(*) from {{ ref('fct_incidents') }}) <> (select count(*) from {{ ref('slv_incidents') }})
