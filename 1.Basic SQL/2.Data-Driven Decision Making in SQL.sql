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
