-- 1
SELECT name
FROM people
-- Select names that don't start with A
Where name not like 'A%'

-- 2
SELECT title, language
FROM films
WHERE language IN ('English', 'Spanish', 'French');


