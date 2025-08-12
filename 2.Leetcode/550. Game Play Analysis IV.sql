with cte as(
    select player_id, min(event_date) as first_login
    From Activity
    Group by player_id),

cte2 as(
    select *, date_add(first_login, interval 1 day) as next_date
    from cte)

select
    round((select count(distinct player_id)
    from Activity
    where (player_id,event_date) in (select player_id,next_date from cte2))/
    (select count(distinct player_id) from Activity),2) as fraction