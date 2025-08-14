with cte as(
select student_id,course_id,grade,dense_rank()over(partition by student_id order by grade desc, course_id asc) as rnk
From Enrollments)

select student_id,course_id,grade
from cte
Where rnk = 1;
