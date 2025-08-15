with cte as(
Select product_id,new_price,change_date,row_number()over(partition by product_id order by change_date desc) as rnk
From Products
where  change_date <= '2019-08-16')
select c.product_id,c.new_price as price
from cte c
where rnk = 1

Union

Select p.product_id, 10 as price
From Products p
Where not exists  (select 1 from cte c where c.product_id = p.product_id) 