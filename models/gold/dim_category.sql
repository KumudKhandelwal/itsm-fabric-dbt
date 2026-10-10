select
    row_number() over (order by category) as category_key,
    category
from (select distinct category from {{ ref('slv_incidents') }}) c
