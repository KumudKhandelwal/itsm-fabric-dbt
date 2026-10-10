-- Bronze contains duplicate incident versions; Silver must have fewer rows than Bronze.
select 1
where (select count(*) from {{ ref('slv_incidents') }}) >= (select count(*) from {{ ref('brz_incidents') }})
