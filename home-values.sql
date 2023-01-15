-- Basic requirements

-- 1. How many distinct zip codes are in this data set?

SELECT COUNT (DISTINCT zip_code)
FROM home_value_data;

-- 2. How many zip codes are from each state?

SELECT state, COUNT(DISTINCT zip_code)
FROM home_value_data
GROUP BY 1;

-- 3. What range of years are represented in the data?

SELECT SUBSTR(MIN(date), 1, 4) AS 'Oldest Date',
  SUBSTR(MAX(date), 1, 4) AS 'Newest Date'
FROM home_value_data;
 
-- 4. Using the most recent month of data available, what is the range of estimated home values across the nation?

SELECT date, MAX(value), MIN(value)
FROM home_value_data
WHERE date = (
	SELECT MAX(date)
	FROM home_value_data
);

-- 5. Using the most recent month of data available, which states have the highest average home values? How about the lowest?

SELECT state, ROUND(AVG(value), 2)
FROM home_value_data
WHERE date = (
  SELECT MAX(date)
  FROM home_value_data
)
GROUP BY 1
ORDER BY 2 DESC;

-- 6. Which states have the highest/lowest average home values for the year of 2017? What about for the year of 2007? 1997?

SELECT SUBSTR(date, 1, 4), state, ROUND(AVG(value), 2) AS 'Average 2017 price'
FROM home_value_data
WHERE date LIKE '2017-%'
GROUP BY 2
ORDER BY 3 DESC;

SELECT SUBSTR(date, 1, 4), state, ROUND(AVG(value), 2) AS 'Average 2007 price'
FROM home_value_data
WHERE date LIKE '2007-%'
GROUP BY 2
ORDER BY 3 DESC;

SELECT SUBSTR(date, 1, 4), state, ROUND(AVG(value), 2) AS 'Average 1997 price'
FROM home_value_data
WHERE date LIKE '1997-%'
GROUP BY 2
ORDER BY 3 DESC;

-- Intermediate problems

-- 7. What is the percent change in average home values from 2007 to 2017 by state? How about from 1997 to 2017? 

WITH
old_avg AS (
	SELECT state, AVG(value) AS old_value
	FROM home_value_data
	WHERE date LIKE '2007-%'
	GROUP BY 1),
new_avg AS (
	SELECT state, AVG(value) AS new_value
	FROM home_value_data
	WHERE date LIKE '2017-%'
	GROUP BY 1)
SELECT old_avg.state, 
	ROUND(old_value, 2) AS '2007 Average Price', 
	ROUND(new_value, 2) AS '2017 Average Price',
	ROUND((((new_value - old_value)/old_value)*100), 2) AS 'Percent Change'
FROM old_avg
JOIN new_avg
  ON old_avg.state = new_avg.state;

-- 8. How would you describe the trend in home values for each state from 1997 to 2017? How about from 2007 to 2017? Which states would you recommend for making real estate investments?

