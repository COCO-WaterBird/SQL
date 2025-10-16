-- Bins created in Step 2
WITH bins AS (
  SELECT generate_series(2200, 3050, 50) AS lower,
         generate_series(2250, 3100, 50) AS upper
),
-- Subset stackoverflow to just tag dropbox (Step 1)
dropbox AS (
  SELECT question_count
  FROM stackoverflow
  WHERE tag = 'dropbox'
)
-- Select columns for result
SELECT lower, upper, COUNT(question_count)
FROM bins
LEFT JOIN dropbox
  ON question_count >= lower
  AND question_count < upper
GROUP BY lower, upper
ORDER BY lower;


