-- Let's check the Sex column
USE [Disease Control]
SELECT SEX, COUNT(Sex) as sex_count
FROM dataset
GROUP BY Sex
;

