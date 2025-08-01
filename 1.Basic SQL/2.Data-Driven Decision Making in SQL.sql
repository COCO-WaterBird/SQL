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


SELECT movie_id -- Select movie IDs with more than 5 views
FROM renting
Group by movie_id
Having count(*) > 5


SELECT *
FROM movies
Where movie_id in  -- Select movie IDs from the inner query
	(SELECT movie_id
	FROM renting
	GROUP BY movie_id
	HAVING COUNT(*) > 5)


SELECT title -- Report the movie titles of all movies with average rating higher than the total average
FROM movies
WHERE movie_id in
	(SELECT movie_id
	 FROM renting
     GROUP BY movie_id
     HAVING AVG(rating) >
		(SELECT AVG(rating)
		 FROM renting));

-- Select customers with less than 5 movie rentals
SELECT *
FROM customers as c
WHERE 5 >
	(SELECT count(*)
	FROM renting as r
	WHERE r.customer_id = c.customer_id);

SELECT *
FROM customers AS c
WHERE 4 > -- Select all customers with a minimum rating smaller than 4
	(SELECT MIN(rating)
	FROM renting AS r
	WHERE r.customer_id = c.customer_id);


SELECT *
FROM movies as m
WHERE 5 < (
    SELECT COUNT(rating)
    FROM renting as r
    Where r.movie_id = m.movie_id
);


SELECT *
FROM customers as c -- Select all customers with at least one rating
WHERE exists
	(SELECT *
	FROM renting AS r
	WHERE rating IS NOT NULL
	AND r.customer_id = c.customer_id);

SELECT *
FROM actsin AS ai
LEFT JOIN movies AS m
ON m.movie_id = ai.movie_id
WHERE m.genre = 'Comedy'
And ai.actor_id = 1; -- Select only the actor with ID 1


SELECT *
FROM actors as a
WHERE exists
	(SELECT *
	 FROM actsin AS ai
	 LEFT JOIN movies AS m
	 ON m.movie_id = ai.movie_id
	 WHERE m.genre = 'Comedy'
	  AND ai.actor_id = a.actor_id);


SELECT a.nationality, count(*) -- Report the nationality and the number of actors for each nationality
FROM actors AS a
WHERE EXISTS
	(SELECT ai.actor_id
	 FROM actsin AS ai
	 LEFT JOIN movies AS m
	 ON m.movie_id = ai.movie_id
	 WHERE m.genre = 'Comedy'
	 AND ai.actor_id = a.actor_id)
Group by a.nationality;


SELECT name,nationality,year_of_birth -- Report the name, nationality and the year of birth
FROM actors
Where nationality != 'USA'; -- Of all actors who are not from the USA

SELECT name,
       nationality,
       year_of_birth
FROM actors
WHERE nationality <> 'USA'
Intersect -- Select all actors who are not from the USA and who are also born after 1990
SELECT name,
       nationality,
       year_of_birth
FROM actors
WHERE year_of_birth > 1990;


SELECT *
FROM movies
WHERE genre = 'Drama'
  AND movie_id IN (
    SELECT movie_id
    FROM renting
    GROUP BY movie_id
    HAVING AVG(rating) > 9
  );


SELECT count(*),
       genre,
       year_of_release
FROM movies
Group BY cube(genre, year_of_release)
ORDER BY year_of_release;

