# Write your MySQL query statement below

Select
t2.name as Department,
t1.name as Employee,
t1.salary as salary
From(
Select *,
dense_rank()over(partition by departmentID order by salary desc) do
from
Employee)t1
Left Join
department t2
On t1.departmentId = t2.id
Where t1.do <= 3