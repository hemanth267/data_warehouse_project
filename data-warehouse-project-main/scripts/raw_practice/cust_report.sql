-- ==================================
-- CUSTOMER REPORT
/*
    1. Gathers essential fields such as names, ages, and transaction details.
	2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
	   - total orders
	   - total sales
	   - total quantity purchased
	   - total products
	   - lifespan (in months)
    4. Calculates valuable KPIs:
	    - recency (months since last order)
		- average order value
		- average monthly spend
*/
-- ==================================
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
	DROP VIEW gold.report_customers
GO

CREATE VIEW gold.report_customers AS 

-- 1. Gathers essential fields such as names, ages, and transaction details.
WITH base_query AS (
	SELECT
		f.order_number,
		f.product_key,
		f.order_date,
		f.sales_amount,
		f.quantity,
		c.customer_key,
		c.customer_number,
		CONCAT(c.first_name,'-',c.last_name) AS customer_name,
		c.birthdate,
		DATEDIFF(year, c.birthdate, GETDATE()) AS age
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c
	ON c.customer_key = f.customer_key
	WHERE f.order_date IS NOT NULL
),

-- output of base_query
/*
SO64744	289	NULL	5	1	503	Jared-Peterson	1980-09-03	46
SO64377	125	NULL	2320	1	1374	Isaac-Gray	1985-08-02	41
SO64377	235	NULL	24	1	1374	Isaac-Gray	1985-08-02	41
*/

-- 3. Aggregates customer-level metrics
customer_aggregation AS (
	SELECT
		customer_key,
		customer_number,
		customer_name,
		birthdate,
		age,
		COUNT(DISTINCT order_number) AS total_orders,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quatity,
		COUNT(DISTINCT product_key) AS total_products,
		MAX(order_date) AS last_order,
		DATEDIFF(month, MIN(order_date), MAX(order_date)) AS lifespan
	FROM base_query
	GROUP BY
		customer_key,
		customer_number,
		customer_name,
		birthdate,
		age
)

-- output of customer_aggregation
/*
1	AW00011000	1971-10-06	55	3	8249	8	8	2013-05-03	28
2	AW00011001	1976-05-10	50	3	6384	11	10	2013-12-10	35
3	AW00011002	1971-02-09	55	3	8114	4	4	2013-02-23	25
4	AW00011003	1973-08-14	53	3	8139	9	9	2013-05-10	29
*/

-- 4. Calculates valuable KPIs:
-- 2. Segments customers into categories (VIP, Regular, New) and age groups
SELECT
	customer_key,
	customer_number,
	customer_name,
	birthdate,
	age,
	CASE
		WHEN age < 20 THEN 'under 20'
		WHEN age BETWEEN 20 AND 29 THEN '20-29'
		WHEN age BETWEEN 30 AND 39 THEN '30-39'
		WHEN age BETWEEN 40 AND 49 THEN '40-49'
		ELSE '50 and above'
	END AS age_segment,
	CASE
		WHEN lifespan>=12 AND total_sales>5000 THEN 'VIP'
		WHEN lifespan>=12 AND total_sales<=5000 THEN 'REGULAR'
		ELSE 'NEW'
	END AS customer_segment, 
	last_order,
	DATEDIFF(MONTH, last_order, GETDATE()) AS recency,
	total_orders,
	total_sales,
	total_quatity,
	total_products,
	lifespan,
	CASE
		WHEN total_orders = 0 THEN 0
		ELSE total_sales/total_orders
	END AS avg_order_value,
	CASE
		WHEN lifespan = 0 THEN 0
		ELSE total_sales/lifespan
	END AS avg_monthly_spend
FROM customer_aggregation

-- output of main query
/*
1	AW00011000	Jon-Yang	1971-10-06	55	50 and above	VIP	2013-05-03	156	3	8249	8	8	28	2749	294
2	AW00011001	Eugene-Huang	1976-05-10	50	50 and above	VIP	2013-12-10	149	3	6384	11	10	35	2128	182
3	AW00011002	Ruben-Torres	1971-02-09	55	50 and above	VIP	2013-02-23	159	3	8114	4	4	25	2704	324
*/