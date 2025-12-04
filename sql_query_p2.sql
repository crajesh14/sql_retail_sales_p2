CREATE DATABASE sql_project_p2;

SELECT * FROM sql_retail_analysis;

ALTER TABLE sql_retail_analysis
CHANGE  ï»¿transactions_id  transactions_id int;

ALTER TABLE sql_retail_analysis
CHANGE quantiy quantity int;

ALTER TABLE sql_retail_analysis
RENAME TO retail_sales;

SELECT COUNT(*) FROM retail_sales;

SELECT category, count( category) FROM retail_sales
GROUP BY category;

SELECT * FROM retail_sales
WHERE
 transactions_id IS NULL
OR 
 sale_date IS NULL
OR
 sale_time IS NULL
OR
  gender IS NULL
OR
 category IS NULL 
OR
 quantiy IS NULL
OR
  cogs IS NULL
OR
  total_sale IS NULL;
  
SELECT * FROM retail_sales
WHERE quantiy IS NULL;

-- Data Exploration

-- How many sales we have?
SELECT count(*) FROM retail_sales;

-- How many customers we have?
SELECT count(customer_id) AS ttl_sale  FROM retail_sales;

-- How many unique customers we have?
SELECT count(DISTINCT customer_id) AS ttl_sale FROM retail_sales;

-- How many distinct category we have?
SELECT count( distinct category) from retail_sales;

-- What are the distinct categories we have?
SELECT distinct category from retail_sales;

-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT * FROM retail_sales 
WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022

SELECT * FROM retail_sales
WHERE category = 'clothing' 
AND date_format(sale_date ,'%Y-%m') = '2022-11'
AND quantity >=3;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

SELECT category , sum(total_sale) AS total_sales,
COUNT(*) as total_orders 
FROM retail_sales
GROUP BY 1;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty';
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale >=1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.


SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1;
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

WITH monthly AS (
  SELECT 
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(MONTH FROM sale_date) AS month,
    AVG(total_sale) AS avg_sale
  FROM retail_sales
  GROUP BY year, month
)

SELECT year, month, avg_sale
FROM (
  SELECT 
    year,
    month,
    avg_sale,
    RANK() OVER (PARTITION BY year ORDER BY avg_sale DESC) AS rk
  FROM monthly
) t
WHERE rk = 1
ORDER BY year;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)

WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift;






