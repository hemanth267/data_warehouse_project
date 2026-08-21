/*
===============================================================================
Change Over Time Analysis
===============================================================================
Purpose:
    - To analyze trends and patterns across different time periods.
    - To identify seasonality and cyclical patterns.
    - To understand growth and decline trends.

SQL Functions Used:
    - YEAR(), MONTH()
    - GROUP BY with Date Functions
    - FORMAT()
    - SUM(), COUNT(DISTINCT)
===============================================================================
*/

-- What is the sales performance by year?
SELECT
	YEAR(order_date) AS order_year,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date);

-- What is the seasonality pattern by month across all years?
SELECT
	MONTH(order_date) AS order_month,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date);

-- What is the monthly sales performance across all years?
SELECT
	FORMAT(order_date, 'yyyy-MMM') AS order_date,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM');
