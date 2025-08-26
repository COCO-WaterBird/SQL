# Write your MySQL query statement below

Select i.item_category as category,
    sum(case when weekday(order_date) = 0 then quantity else 0 end) as Monday,
    sum(case when weekday(order_date) = 1 then quantity else 0 end) as Tuesday,
    sum(case when weekday(order_date) = 2 then quantity else 0 end) as Wednesday,
    sum(case when weekday(order_date) = 3 then quantity else 0 end) as Thursday,
    sum(case when weekday(order_date) = 4 then quantity else 0 end) as Friday,
    sum(case when weekday(order_date) = 5 then quantity else 0 end) as Saturday,
    sum(case when weekday(order_date) = 6 then quantity else 0 end) as Sunday

From Items i
Left Join orders o
On o.item_id = i.item_id
GROUP BY i.item_category
Order by category