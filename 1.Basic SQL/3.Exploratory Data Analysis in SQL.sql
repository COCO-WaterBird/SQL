-- Count the number of null values in the ticker column
SELECT count(*) - count(ticker) AS missing
  FROM fortune500;

-- Count the number of null values in the industry column
Select count(*) - count(industry) as missing
From fortune500

SELECT company.name
-- Table(s) to select from
  FROM company
       INNER JOIN fortune500
       On company.ticker = fortune500.ticker;

-- Count the number of tags with each type
SELECT type,count(*) as count
  FROM tag_type
 -- To get the count for each type, what do you need to do?
Group by type
 -- Order the results with the most common tag types listed first
Order by count desc;

-- Select the 3 columns desired
SELECT company.name,tag_type.tag,tag_type.type
  FROM company
  	   -- Join to the tag_company table
       Inner JOIN tag_company
       ON company.id = tag_company.company_id
       -- Join to the tag_type table
       Inner JOIN tag_type
       ON tag_company.tag = tag_type.tag
  -- Filter to most common type
  WHERE type='cloud';


-- Select the original value
SELECT profits_change,
	   -- Cast profits_change
       CAST(profits_change as integer) AS profits_change_int
  FROM fortune500;

-- Divide 10 by 3
SELECT 10/3,
       -- Cast 10 as numeric and divide by 3
       10::numeric/3;


SELECT '3.2'::numeric,
       '-123'::numeric,
       '1e3'::numeric,
       '1e-3'::numeric,
       '02314'::numeric,
       '0002'::numeric;
