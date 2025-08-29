-- with cte1 as(
-- Select *, dense_rank()over(Order by salary asc) as rnk
-- From employees),

-- cte2 as(
-- Select employee_id
-- From cte1
-- Group by rnk
-- having count(*) < 2 )

-- select *,dense_rank()over(Order by salary asc) as team_id
-- From Employees
-- Where employee_id not in (select * from cte2)
-- Order by team_id,employee_id

with cte as(
Select *, count(employee_id) over (partition by salary) as num_of_emp_in_that_group
From employees)

Select employee_id, name, salary, dense_rank()over(Order by salary asc) as team_id
From cte
Where num_of_emp_in_that_group >= 2
Order by team_id,employee_id