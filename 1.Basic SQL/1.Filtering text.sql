-- 1
SELECT name
FROM people
-- Select names that don't start with A
Where name not like 'A%'

-- 2
SELECT title, language
FROM films
WHERE language IN ('English', 'Spanish', 'French');


-- 3
-- Find the title, certification, and language all films certified NC-17 or R that are in English, Italian, or Greek
Select title, certification, language
From films
Where certification in ('NC-17','R')
AND language in ('English','Italian','Greek')

-- 4
-- Count the number of films we have language data for
Select Count(*) As count_language_known
From films
Where language is Not NUll;

-- 5
-- Query the sum of film durations
Select sum(duration) AS total_duration
From films

-- 6
-- Calculate the average duration of all films
Select avg(duration) As average_duration
From films

-- 7
-- Find the latest release_year
Select Max(release_year) as latest_year
From films

-- 8
-- Find the duration of the shortest film
Select Min(duration) As shortest_film
From films

-- 9
-- Calculate the sum of gross from the year 2000 or later
Select sum(gross) as total_gross
From films
Where release_year >= 2000;

-- 10
-- Calculate the average gross of films that start with A
Select avg(gross) as avg_gross_A
From films
Where title like 'A%';

-- 10
-- Calculate the lowest gross film in 1994
Select min(gross) as lowest_gross
From films
Where release_year = 1994

-- 11
-- Round the average number of facebook_likes to one decimal place
Select Round(avg(facebook_likes),1) As avg_facebook_likes
From reviews

-- 12
-- Calculate the average budget rounded to the thousands
Select Round(avg(budget),-3) as avg_budget_thousands
From films

-- 13
-- Calculate the percentage of people who are no longer alive
SELECT  count(deathdate) * 100.0 / count(*) AS percentage_dead
FROM people;

-- 14
-- Find the number of decades in the films table
SELECT (max(release_year)-min(release_year)) / 10.0 AS number_of_decades
FROM films;

-- 15
-- Select name from people and sort alphabetically
Select name
From people
Order by name asc

-- 16
-- Select the title and duration from longest to shortest film
Select title, duration
From films
Order by duration DESC;

-- 17
-- Select the release year, duration, and title sorted by release year and duration
Select release_year, duration, title
From films
Order by release_year,duration

-- 18
-- Select the certification, release year, and title sorted by certification and release year
Select certification,release_year,title
From films
Order by certification asc, release_year desc;