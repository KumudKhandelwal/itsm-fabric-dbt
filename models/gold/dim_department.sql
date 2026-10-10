select dept_id, dept_name, cost_center from {{ ref('slv_departments') }}
