with cte as (
Select *,   rank()over(partition by gender order by user_id) as rnk1,
            case when gender = 'female' then 1
                when gender = 'other' then 2
                else 3 end as rnk2
From genders )

select user_id,gender
From cte
Order by rnk1,rnk2