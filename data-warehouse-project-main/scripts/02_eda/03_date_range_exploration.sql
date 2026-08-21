/*
===============================================================================
Date Range Exploration
===============================================================================
Purpose:
    - To understand the temporal scope of the data.
    - To identify date ranges for key dates in the data warehouse.
    - To analyze customer demographics across time.

SQL Functions Used:
    - MIN(), MAX()
    - DATEDIFF()
    - Date Functions: YEAR(), MONTH()
===============================================================================
*/

-- What is the date range for orders (order_date)?
SELECT
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_months
FROM gold.fact_sales;

-- What is the date range for shipments (shipping_date)?
SELECT
	MIN(shipping_date) AS first_shipping_date,
	MAX(shipping_date) AS last_shipping_date,
	DATEDIFF(MONTH, MIN(shipping_date), MAX(shipping_date)) AS shipping_range_months
FROM gold.fact_sales;

-- What is the date range for due dates (due_date)?
SELECT
	MIN(due_date) AS first_due_date,
	MAX(due_date) AS last_due_date,
	DATEDIFF(MONTH, MIN(due_date), MAX(due_date)) AS due_date_range_months
FROM gold.fact_sales;

-- What is the age distribution based on customer birthdates?
SELECT
	MIN(birthdate) AS oldest_birthday,
	MAX(birthdate) AS youngest_birthday,
	DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS min_age,
	DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS max_age
FROM gold.dim_customers;

-- What is the date range for product start dates?
SELECT
	MIN(start_date) AS oldest_start_date,
	MAX(start_date) AS latest_start_date,
	DATEDIFF(MONTH, MIN(start_date), MAX(start_date)) AS start_date_range_months
FROM gold.dim_products;
