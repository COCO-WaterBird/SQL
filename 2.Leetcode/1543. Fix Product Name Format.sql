select lower(trim(product_name)) as product_name ,date_format(sale_date,'%Y-%m') as sale_date,count(*) as total
From sales
Group by lower(trim(product_name)),date_format(sale_date,'%Y-%m')
Order by product_name asc,sale_date asc;