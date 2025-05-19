DROP TABLE IF EXISTS retail_sales;

CREATE TABLE retail_sales (
	transactions_id	INT PRIMARY KEY,
	sale_date DATE,
	sale_time TIME,
	customer_id	INT,
	gender	VARCHAR(10),
	age	INT,
	category	VARCHAR(20),
	quantiy	INT,
	price_per_unit	FLOAT,
	cogs	FLOAT,
	total_sale FLOAT
);

SELECT * FROM retail_sales;

SELECT COUNT (*) FROM retail_sales;

-- Data Cleaning
SELECT * FROM retail_sales
WHERE
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	gender is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

	DELETE FROM retail_sales
	WHERE
	transactions_id is null
	or
	sale_date is null
	or
	sale_time is null
	or
	gender is null
	or
	category is null
	or
	quantiy is null
	or
	price_per_unit is null
	or
	cogs is null
	or
	total_sale is null;

-- Data Exploration
-- How many sales we have?
SELECT COUNT (*) AS total_sale FROM retail_sales;

-- How many Unique customer we have?
SELECT COUNT (DISTINCT customer_id) AS total_sale FROM retail_sales;

-- How any category(numbers/names) we have?
SELECT COUNT (DISTINCT category) AS total_sale FROM retail_sales;
SELECT DISTINCT category FROM retail_sales; 

-- Data Analysis & Business key problems & answers
-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05'.
SELECT * FROM retail_sales
WHERE sale_date ='2022-11-05';

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of November 2022.
-- First Conditions: Retrive all transactions where category is "clothing"
SELECT category, SUM(quantiy)
FROM retail_sales
WHERE category = 'Clothing'
GROUP BY 1

-- Second Conditions: The quantity sold in the month of November 2022.
SELECT * FROM retail_sales
WHERE category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
GROUP BY 1

-- 
SELECT * FROM retail_sales
WHERE category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND quantiy >= 4

-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
	category,
	SUM(total_sale) as net_sale,
	COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT
	ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale > 1000

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT
	category,
	gender,
	COUNT(*) AS toatl_trans
FROM retail_sales
GROUP BY category,gender
ORDER BY 1

-- 7. Write a SQL query to calculate the average sale for each month. Find out the best-selling month in each year. (Most frequently as question in interview)
SELECT 
	year,
	month,
	avg_sale
FROM (
	SELECT 
		EXTRACT(YEAR FROM sale_date) as YEAR,
		EXTRACT(MONTH FROM sale_date) as MONTH,
		AVG(total_sale) as avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
	FROM retail_sales
	GROUP BY 1, 2
	-- ORDER BY 1, 3 DESC
) AS t1
WHERE rank = 1

-- 8. Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT
	category,
	COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category

-- 10. Write a SQL query to create each shift and count the number of orders in each (Example: Morning ≤12, Afternoon between 12 & 17, Evening >17).
WITH hourly_sale
AS (
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM retail_sales
)
SELECT 
	shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift

-- END OF PROJECT