select
    u.user_id,
    concat(u.first_name, ' ', u.last_name)  as full_name,
    u.email,
    u.role_title,
    u.is_active,
    u.dept_id,
    d.dept_name,
    l.city,
    l.country
from {{ ref('slv_users') }} u
left join {{ ref('slv_departments') }} d on d.dept_id = u.dept_id
left join {{ ref('slv_locations') }} l on l.location_id = u.location_id
