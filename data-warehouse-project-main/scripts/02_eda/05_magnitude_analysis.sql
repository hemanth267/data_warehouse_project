/*
===============================================================================
Magnitude Analysis
===============================================================================
Purpose:
    - To analyze data distribution across key dimensions.
    - To identify relative sizes and proportions.
    - To understand composition and structure.

SQL Functions Used:
    - GROUP BY
    - SUM(), AVG(), COUNT()
    - ORDER BY
    - LEFT JOIN
===============================================================================
*/

-- How are customers distributed across countries?
SELECT
	country,
	COUNT(*) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY COUNT(*) DESC;

-- How are customers distributed by marital status?
SELECT
	marital_status,
	COUNT(*) AS count
FROM gold.dim_customers
GROUP BY marital_status
ORDER BY COUNT(*) DESC;

-- How are customers distributed by gender?
SELECT
	gender,
	COUNT(*) AS count
FROM gold.dim_customers
GROUP BY gender
ORDER BY COUNT(*) DESC;

-- How are products distributed by maintenance requirement?
SELECT 
	maintenance,
	COUNT(*) AS count
FROM gold.dim_products
GROUP BY maintenance;

-- How are products distributed by product line?
SELECT 
	product_line,
	COUNT(*) AS count
FROM gold.dim_products
GROUP BY product_line;

-- How are products distributed by category?
SELECT
	category,
	COUNT(*) AS count
FROM gold.dim_products
GROUP BY category
ORDER BY COUNT(*) DESC;

-- What is the average cost by product category?
SELECT
	category,
	AVG(cost) AS average_cost
FROM gold.dim_products
GROUP BY category
ORDER BY AVG(cost) DESC;

-- What is the total revenue by product category?
SELECT
	p.category,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
	ON f.product_key = p.product_key
GROUP BY p.category
ORDER BY SUM(f.sales_amount) DESC;

-- What is the total revenue by customer?
SELECT
	c.customer_key,
	c.first_name,
	c.last_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
	ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY SUM(f.sales_amount) DESC;

-- What is the distribution of sold items across countries?
SELECT
	c.country,
	SUM(f.quantity) AS total_sold_items
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
	ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY SUM(f.quantity) DESC;
