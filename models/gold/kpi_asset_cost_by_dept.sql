select
    u.dept_id,
    u.dept_name,
    count(*)                         as assigned_assets,
    round(sum(a.cost_eur), 2)        as total_cost_eur,
    round(avg(a.age_days), 0)        as avg_age_days
from {{ ref('fct_asset_inventory') }} a
join {{ ref('dim_user') }} u on u.user_id = a.assigned_user_id
group by u.dept_id, u.dept_name
