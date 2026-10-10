-- Mean time to resolve, per resolution day and priority.
select
    resolved_date                         as date_day,
    priority_level,
    count(*)                              as resolved_incidents,
    round(avg(resolution_hours), 2)       as mttr_hours
from {{ ref('fct_incidents') }}
where resolved_date is not null
group by resolved_date, priority_level
