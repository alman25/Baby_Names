/* Objection 1: Track changes in name popularity */

USE baby_names_db;

-- 1: Find the overall most popular girl and boy names
-- Show how they have changed in popularity rankings over the years
SELECT * FROM names;
SELECT * FROM regions;

SELECT
		Gender,
        Name,
        sum(Births) as num_babies,
		dense_rank() OVER(PARTITION BY Gender ORDER BY sum(Births) DESC) as name_rank
FROM names
GROUP by 1, 2
ORDER by name_rank
LIMIT 2;

SELECT * FROM
(WITH girl_names as (SELECT
	Year,
    Name,
    SUM(Births) as num_babies
FROM names
WHERE Gender = 'F'
GROUP by 1, 2)

SELECT 
	Year,
	Name,
    ROW_NUMBER() OVER(Partition By Year ORDER BY num_babies DESC) as popularity
FROM girl_names) as popular_girl_names
WHERE Name = 'Jessica'
;

SELECT * FROM
(WITH boy_names as (SELECT
	Year,
    Name,
    SUM(Births) as num_babies
FROM names
WHERE Gender = 'M'
GROUP by 1, 2)

SELECT 
	Year,
	Name,
    ROW_NUMBER() OVER(Partition By Year ORDER BY num_babies DESC) as popularity
FROM boy_names) as popular_boy_names
WHERE Name = 'Michael'
;

-- Task 2: Find the names with the biggest jumps in popularity from the first year to the last year
WITH names_1980 AS(

	WITH all_names as (SELECT
		Year,
		Name,
		SUM(Births) as num_babies
	FROM names
	GROUP by 1, 2)

	SELECT 
		Year,
		Name,
		ROW_NUMBER() OVER(Partition By Year ORDER BY num_babies DESC) as popularity
	FROM all_names
	WHERE Year = 1980),
    
names_2009 as (

	WITH all_names as (SELECT
		Year,
		Name,
		SUM(Births) as num_babies
	FROM names
	GROUP by 1, 2)

	SELECT 
		Year,
		Name,
		ROW_NUMBER() OVER(Partition By Year ORDER BY num_babies DESC) as popularity
	FROM all_names
	WHERE Year = 2009)
    
    SELECT t1.Year, t1.Name, t1.popularity, t2.Year, t2.Name, t2.popularity,
		CAST(t2.popularity as Signed) - CAST(t1.popularity as Signed) as diff
    FROM names_1980 t1 INNER JOIN names_2009 t2
		ON t1.Name = t2.Name
	ORDER by diff;
