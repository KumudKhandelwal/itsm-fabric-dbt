select
    cast(location_id as int)     as location_id,
    trim(city)                   as city,
    upper(trim(country))         as country,
    trim(region)                 as region
from {{ ref('brz_locations') }}
