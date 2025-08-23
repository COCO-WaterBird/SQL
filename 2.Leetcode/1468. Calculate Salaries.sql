with cte as(
Select *, max(salary) over(partition by company_id) as max_salary
FRom Salaries)
Select company_id,employee_id,employee_name,
Round(
Case when max_salary < 1000 then salary
     when max_salary between 1000 and 10000 then salary*0.76
     Else salary*0.51
     End,0)
     AS salary
From cte