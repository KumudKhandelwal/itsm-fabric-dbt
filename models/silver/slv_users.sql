select
    cast(user_id as int)                              as user_id,
    trim(first_name)                                  as first_name,
    trim(last_name)                                   as last_name,
    lower(trim(email))                                as email,
    cast(dept_id as int)                              as dept_id,
    cast(location_id as int)                          as location_id,
    cast(manager_id as int)                           as manager_id,
    trim(role_title)                                  as role_title,
    {{ flag_to_boolean('is_active') }}                as is_active,
    cast(created_at as timestamp)                     as created_at
from {{ ref('brz_users') }}
