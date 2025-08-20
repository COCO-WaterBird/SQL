# Write your MySQL query statement below

SELECT
    teams.team_id,
    teams.team_name,
    Ifnull(sum(m.scores),0) as num_points
From teams
Left Join
(
Select
    host_team as team_id,
    (case
    When host_goals > guest_goals then 3
    When host_goals = guest_goals then 1
    Else 0
    end) as scores
From Matches
Union all
Select
    guest_team as team_id,
    (case
    When host_goals < guest_goals then 3
    When host_goals = guest_goals then 1
    Else 0
    end) as scores
From Matches
) m
On teams.team_id = m.team_id
Group by teams.team_id
Order by num_points DESC, teams.team_id ASC