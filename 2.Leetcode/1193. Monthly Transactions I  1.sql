Select
t1.month,t1.country,t1.trans_count,ifnull(t2.approved_count,0) as approved_count,t1.trans_total_amount,ifnull(t2.approved_total_amount,0) as approved_total_amount
From
(Select
date_format(trans_date,'%Y-%m') as month,country,count(*) as trans_count,sum(amount) as  trans_total_amount
From Transactions
Group by month,country) as t1

Left Join
(
Select
date_format(trans_date,'%Y-%m') as month,country,count(*) as approved_count,sum(amount) as  approved_total_amount
From Transactions
Where state  = 'approved'
Group by month,country
) as t2
On t1.month = t2.month and t1.country = t2.country OR (t1.country is null and t2.country is null);