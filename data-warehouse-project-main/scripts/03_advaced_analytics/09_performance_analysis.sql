/*
===============================================================================
Performance Analysis
===============================================================================
Purpose:
    - To compare current performance against historical baselines.
    - To identify performance improvements or declines.
    - To track year-over-year changes.

SQL Functions Used:
    - Window Functions: LAG(), AVG() OVER, PARTITION BY
    - CASE Statements
    - GROUP BY with Date Functions
    - WITH (CTE) for Complex Queries
===============================================================================
*/

-- Yearly product performance with comparison to average and previous year
SELECT
	product_key,
	order_date,
	total_revenue AS curr_yr_revenue,
	LAG(total_revenue) OVER (PARTITION BY product_key ORDER BY order_date) AS prev_yr_revenue,
	AVG(total_revenue) OVER (PARTITION BY product_key) AS avg_product_revenue
FROM (
	SELECT
		YEAR(order_date) AS order_date,
		product_key,
		SUM(sales_amount) AS total_revenue
	FROM gold.fact_sales
	GROUP BY YEAR(order_date), product_key
) yearly_sales
ORDER BY product_key, order_date;

-- Detailed product performance analysis with variance reporting
WITH yearly_product_sales AS (
	SELECT
		YEAR(f.order_date) AS order_date,
		p.product_name,
		SUM(f.sales_amount) AS curr_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
		ON f.product_key = p.product_key
	WHERE f.order_date IS NOT NULL
	GROUP BY YEAR(f.order_date), p.product_name
)
SELECT
	order_date,
	product_name,
	curr_sales,
	AVG(curr_sales) OVER (PARTITION BY product_name) avg_sales,
	curr_sales - AVG(curr_sales) OVER (PARTITION BY product_name) AS avg_diff,
	CASE 
		WHEN curr_sales < AVG(curr_sales) OVER (PARTITION BY product_name) THEN 'Below Avg'
		WHEN curr_sales > AVG(curr_sales) OVER (PARTITION BY product_name) THEN 'Above Avg'
		ELSE 'Avg'
	END AS avg_report,
	LAG(curr_sales) OVER (PARTITION BY product_name ORDER BY order_date) AS prev_yr_sales,
	curr_sales - LAG(curr_sales) OVER (PARTITION BY product_name ORDER BY order_date) AS yoy_diff,
	CASE 
		WHEN curr_sales < LAG(curr_sales) OVER (PARTITION BY product_name ORDER BY order_date) THEN 'Decrease'
		WHEN curr_sales > LAG(curr_sales) OVER (PARTITION BY product_name ORDER BY order_date) THEN 'Increase'
		ELSE 'Same as Previous Year'
	END AS yoy_report
FROM yearly_product_sales
ORDER BY product_name, order_date;
