-- Objective 4: Explore unique names in the dataset

/* 1: Find the 10 most popular andrgynous names (names given to both females and males) */
SELECT Name, COUNT(DISTINCT Gender) as num_genders, SUM(Births) as num_babies
FROM names
GROUP by Name
HAVING num_genders = 2
ORDER by num_babies DESC
LIMIT 10;


/* 2: Find the length of the shortest and longest names and identify the most popular short
names (those with the fewest characters) and long names (those with the most characters) */
SELECT Name, LENGTH(Name) as name_length
FROM names
ORDER by name_length; -- 2

SELECT Name, LENGTH(Name) as name_length
FROM names
ORDER by name_length DESC; -- 15

WITH short_long_names as (SELECT *
FROM names
WHERE Length(Name) IN (2, 15))

SELECT Name, SUM(Births) as num_babies
FROM short_long_names
GROUP by Name
ORDER BY num_babies DESC;

/* 3: Find the state with the highest percent of babies named "Chris" */
SELECT State, num_chris / num_babies * 100 as pct_chris
FROM

(with count_chris as (SELECT State, SUM(Births) as num_chris
FROM names
WHERE name = 'Chris'
GROUP BY State),

count_all as (SELECT State, SUM(Births) as num_babies
FROM names
GROUP BY State)

SELECT cc.State, cc.num_chris, ca.num_babies
FROM count_chris cc INNER JOIN count_all ca
	ON cc.State = ca.State) as state_chris_all
    
ORDER by pct_chris DESC;