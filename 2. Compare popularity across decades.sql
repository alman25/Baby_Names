-- Objective 2: Compare popularity across decades

-- 1. For each year, return the 3 most popular girl names and 3 most popular boy names
SELECT * FROM names;

SELECT * FROM

(WITH babies_by_year as (
SELECT
	Year,
    Gender,
    Name,
    SUM(BIRTHS) as num_babies
FROM names
GROUP BY 1, 2, 3)

SELECT 
	Year,
    Gender,
    Name,
    num_babies,
    ROW_NUMBER() OVER(PARTITION BY Year, Gender ORDER BY num_babies DESC) as popularity
FROM babies_by_year) as top_three
WHERE popularity < 4    
;

-- 2. For each decade, return the 3 most popular girl names and 3 most populary boy names by decade
SELECT * FROM

(WITH babies_by_decade as (
SELECT
	(CASE WHEN Year BETWEEN 1980 and 1989 THEN 'Eighties'
		  WHEN Year BETWEEN 1990 and 1999 THEN 'Nineties'
          WHEN Year BETWEEN 2000 and 2009 THEN 'Two_Thousands'
          ELSE 'None' End) as decade,
    Gender,
    Name,
    SUM(BIRTHS) as num_babies
FROM names
GROUP BY 1, 2, 3)

SELECT 
	decade,
    Gender,
    Name,
    num_babies,
    ROW_NUMBER() OVER(PARTITION BY decade, Gender ORDER BY num_babies DESC) as popularity
FROM babies_by_decade) as top_three
WHERE popularity < 4    
;