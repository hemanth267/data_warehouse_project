/*
===============================================================================
Part-to-Whole Analysis
===============================================================================
Purpose:
    - To understand the contribution of individual parts to the whole.
    - To identify relative importance and proportions.
    - To analyze compositional breakdown of metrics.

SQL Functions Used:
    - SUM() with Window Functions
    - GROUP BY
    - CASE Statements
    - CAST, ROUND(), CONCAT()
    - Percentage Calculations
===============================================================================
*/

-- What is the contribution of each product category to overall sales?
SELECT
	category,
	revenue_per_cat,
	CONCAT(ROUND(100.0 * CAST(revenue_per_cat AS FLOAT) / SUM(revenue_per_cat) OVER(), 2), ' %') AS pct_contribution
FROM (
	SELECT
		p.category,
		SUM(f.sales_amount) AS revenue_per_cat
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
		ON f.product_key = p.product_key
	GROUP BY p.category
) category_revenue
ORDER BY revenue_per_cat DESC;
