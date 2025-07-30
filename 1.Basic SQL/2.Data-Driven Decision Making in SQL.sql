SELECT *
FROM renting
Where date_renting between '2018-04-01' and '2018-08-31'; -- from beginning April 2018 to end August 2018

SELECT *
FROM renting
WHERE date_renting BETWEEN '2018-04-01' AND '2018-08-31'
Order by date_renting desc; -- Order by recency in decreasing order

SELECT *
FROM movies
Where genre <> 'Drama'; -- All genres except drama

SELECT *
FROM movies
Where title in ('Showtime', 'Love Actually', 'The Fighter'); -- Select all movies with the given titles

SELECT * -- Join renting with customers
FROM renting as r
LEFT JOIN customers as c
ON r.customer_id = c.customer_id;

SELECT a.name, -- Create a list of movie titles and actor names
       m.title
FROM actsin as ai
LEFT JOIN movies AS m
ON m.movie_id = ai.movie_id
LEFT JOIN actors AS a
ON a.actor_id = ai.actor_id;

SELECT rm.title, -- Report the income from movie rentals for each movie
       sum(rm.renting_price) AS income_movie
FROM
       (SELECT m.title,
               m.renting_price
       FROM renting AS r
       LEFT JOIN movies AS m
       ON r.movie_id=m.movie_id) AS rm
Group by rm.title
ORDER BY income_movie desc; -- Order the result by decreasing income

SELECT m.title,
COUNT(*),
AVG(r.rating)
FROM renting AS r
LEFT JOIN customers AS c
ON c.customer_id = r.customer_id
LEFT JOIN movies AS m
ON m.movie_id = r.movie_id
WHERE c.date_of_birth BETWEEN '1970-01-01' AND '1979-12-31'
GROUP BY m.title
Having count(*) > 1 -- Remove movies with only one rental
Order by max(rating); -- Order with highest rating first



SELECT a.name,  c.gender,
       COUNT(*) AS number_views,
       AVG(r.rating) AS avg_rating
FROM renting as r
LEFT JOIN customers AS c
ON r.customer_id = c.customer_id
LEFT JOIN actsin as ai
ON r.movie_id = ai.movie_id
LEFT JOIN actors as a
ON ai.actor_id = a.actor_id
Where  c.country = 'Spain'-- Select only customers from Spain
GROUP BY a.name, c.gender
HAVING AVG(r.rating) IS NOT NULL
  AND COUNT(*) > 5
ORDER BY avg_rating DESC, number_views DESC;
    