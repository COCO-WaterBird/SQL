select u.user_id as buyer_id, u.join_date,count(order_date) as orders_in_2019
From Users u
Left Join Orders o
    On u.user_id = o.buyer_id
    And o.order_date >= '2019-01-01'
Group by u.user_id
