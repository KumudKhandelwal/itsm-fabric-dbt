select location_id, city, country, region from {{ ref('slv_locations') }}
