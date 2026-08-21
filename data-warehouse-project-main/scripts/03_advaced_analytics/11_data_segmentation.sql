/*
===============================================================================
Data Segmentation
===============================================================================
Purpose:
    - To partition data into meaningful business segments.
    - To categorize customers based on behavioral patterns.
    - To identify different customer cohorts and segments.

SQL Functions Used:
    - CASE Statements for Conditional Segmentation
    - WITH (CTE) for Complex Logic
    - GROUP BY
    - DATEDIFF()
    - Window Functions (optional)
===============================================================================
*/

-- Segment products by cost ranges
WITH product_segments AS (
	SELECT
		product_name,
		cost,
		CASE
			WHEN cost < 100 THEN 'Below 100'
			WHEN cost <= 500 THEN '100-500'
			WHEN cost <= 1000 THEN '500-1000'
			ELSE 'Above 1000'
		END cost_range
	FROM gold.dim_products
)
SELECT
	cost_range,
	COUNT(*) AS product_count
FROM product_segments
GROUP BY cost_range
ORDER BY COUNT(*) DESC;

-- Segment customers into behavioral categories based on lifecycle and spending
WITH customer_spending AS (
	SELECT
		c.customer_key,
		SUM(f.sales_amount) AS total_spending,
		MIN(f.order_date) AS first_order,
		MAX(f.order_date) AS last_order,
		DATEDIFF(MONTH, MIN(f.order_date), MAX(f.order_date)) AS life_span
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c
		ON c.customer_key = f.customer_key
	GROUP BY c.customer_key
)
SELECT
	customer_key,
	total_spending,
	first_order,
	last_order,
	life_span,
	CASE
		WHEN life_span >= 12 AND total_spending > 5000 THEN 'VIP'
		WHEN life_span >= 12 AND total_spending <= 5000 THEN 'REGULAR'
		ELSE 'NEW'
	END AS customer_category
FROM customer_spending;

-- Summary of customer segmentation
WITH customer_spending AS (
	SELECT
		c.customer_key,
		SUM(f.sales_amount) AS total_spending,
		MIN(f.order_date) AS first_order,
		MAX(f.order_date) AS last_order,
		DATEDIFF(MONTH, MIN(f.order_date), MAX(f.order_date)) AS life_span
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c
		ON c.customer_key = f.customer_key
	GROUP BY c.customer_key
)
SELECT
	CASE
		WHEN life_span >= 12 AND total_spending > 5000 THEN 'VIP'
		WHEN life_span >= 12 AND total_spending <= 5000 THEN 'REGULAR'
		ELSE 'NEW'
	END AS customer_category,
	COUNT(*) AS count
FROM customer_spending
GROUP BY CASE
	WHEN life_span >= 12 AND total_spending > 5000 THEN 'VIP'
	WHEN life_span >= 12 AND total_spending <= 5000 THEN 'REGULAR'
	ELSE 'NEW'
END;
