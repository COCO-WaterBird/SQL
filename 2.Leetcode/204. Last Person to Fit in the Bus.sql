with cte as
(
    Select
    Turn,
    person_id As ID,
    person_name,
    Weight,
    sum(Weight)over(order by turn) Total_Weight
    From Queue
)

Select person_name
From cte
Where Total_Weight <= 1000
Order by turn desc
Limit 1