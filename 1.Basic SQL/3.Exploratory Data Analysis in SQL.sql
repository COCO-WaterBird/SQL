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

