Select distinct visited_on,
        amount,
        round(amount/7,2) as average_amount
From
    (
    select
        visited_on,
        sum(amount)over(Order by visited_on range interval 6 day preceding) as amount
    From Customer) t
Where Datediff(visited_on, (select min(visited_on)From Customer)) >=6