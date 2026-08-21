/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To track cumulative totals and running aggregates over time.
    - To identify trends in accumulated performance metrics.
    - To understand compound growth patterns.

SQL Functions Used:
    - Window Functions: SUM() OVER, AVG() OVER
    - ORDER BY with Window Frames
    - GROUP BY with Date Functions
    - DATETRUNC() or FORMAT()
===============================================================================
*/

-- Calculate monthly sales with running total and running average
SELECT
	order_date,
	total_revenue,
	SUM(total_revenue) OVER (ORDER BY order_date) AS running_total_revenue,
	avg_revenue,
	AVG(avg_revenue) OVER (ORDER BY order_date) AS running_avg_revenue
FROM (
	SELECT
		DATETRUNC(MONTH, order_date) AS order_date,
		SUM(sales_amount) AS total_revenue,
		AVG(sales_amount) AS avg_revenue
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(MONTH, order_date)
) aggregated_sales
ORDER BY order_date;
