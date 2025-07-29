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

-- 19
-- Select the country and distinct count of certification as certification_count
Select country,count(distinct certification) as certification_count
From films
-- Group by country
Group by country
-- Filter results to countries with more than 10 different certifications
Having count(distinct certification) > 10

-- 20
-- Select the country and average_budget from films
Select country, round(avg(budget),2) as average_budget
From films
-- Group by country
Group by country

-- 21
-- Filter to countries with an average_budget of more than one billion
Having avg(budget) > 1000000000
-- Order by descending order of the aggregated budget
Order by average_budget desc

-- 22
-- Select the release_year for films released after 1990 grouped by year
Select release_year
From films
WHere release_year > 1990
Group by release_year

-- 23
SELECT release_year, AVG(budget) AS avg_budget, AVG(gross) AS avg_gross
FROM films
WHERE release_year > 1990
GROUP BY release_year
-- Modify the query to see only years with an avg_budget of more than 60 million
Having avg(budget) > 60000000;

-- 24
-- SELECT release_year, AVG(budget) AS avg_budget, AVG(gross) AS avg_gross
SELECT release_year, AVG(budget) AS avg_budget, AVG(gross) AS avg_gross
FROM films
WHERE release_year > 1990
GROUP BY release_year
HAVING AVG(budget) > 60000000
ORDER BY avg_gross DESC LIMIT 1

-- 25
-- Start coding here...
Select stay, count(*) as count_int, round(avg(todep),2) as average_phq, round(avg(tosc),2) as average_scs, round(avg(toas),2) as average_as
From students
Where inter_dom = 'Inter'
Group by stay
Order by stay desc;