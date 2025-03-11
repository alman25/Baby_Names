-- Objective 3: Compare popularity across regions

-- 1. Return the number of babies born in each of the 6 regions.

SELECT * FROM names;
SELECT * FROM regions;

SELECT DISTINCT Region
FROM Regions;


WITH clean_regions as (SELECT State,
		CASE WHEN Region = 'New England' THEN 'New_England' ELSE Region END As clean_region
FROM regions
UNION
SELECT 'MI' AS State, 'Midest' AS Region)

SELECT 
		clean_region,
        SUM(Births) as num_babies
FROM names n
LEFT JOIN clean_regions cr
	ON n.State = cr.State
GROUP BY 1
ORDER by 2 DESC;

-- 2. Return the 3 most popular girl names and 3 most popular boy names within each region.
SELECT * FROM

(WITH babies_by_region AS (
	WITH clean_regions as (
	SELECT State,
			CASE WHEN Region = 'New England' THEN 'New_England' ELSE Region END As clean_region
	FROM regions
	UNION
	SELECT 'MI' AS State, 'Midwest' AS Region)

	SELECT 
			cr.clean_region,
			n.Gender,
			n.Name,
			SUM(n.Births) as num_babies
	FROM names n
	LEFT JOIN clean_regions cr
		ON n.State = cr.State
	GROUP BY 1, 2, 3
	ORDER by 2 DESC)
    
	SELECT 
		clean_region,
		Gender,
		Name,
		ROW_NUMBER () OVER(PARTITION BY clean_region, gender ORDER BY num_babies DESC) as popularity
	FROM babies_by_region) as region_popularity
WHERE popularity < 4
;
