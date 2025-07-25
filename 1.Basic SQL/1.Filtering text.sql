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
