/*
===============================================================================
Measures Exploration
===============================================================================
Purpose:
    - To quantify key business metrics and KPIs.
    - To establish baseline measurements for the data warehouse.
    - To understand the scale and scope of business data.

SQL Functions Used:
    - SUM(), AVG(), COUNT()
    - COUNT(DISTINCT)
    - UNION ALL
===============================================================================
*/

-- What is the total sales revenue?
SELECT SUM(sales_amount) AS total_sales 
FROM gold.fact_sales;

-- What is the total quantity of items sold?
SELECT SUM(quantity) AS total_quantity 
FROM gold.fact_sales;

-- What is the average selling price?
SELECT AVG(price) AS average_price 
FROM gold.fact_sales;

-- What is the total number of distinct orders?
SELECT COUNT(DISTINCT order_number) AS total_orders 
FROM gold.fact_sales;

-- How many distinct products exist?
SELECT COUNT(DISTINCT product_key) AS total_products 
FROM gold.dim_products;

-- How many distinct customers exist?
SELECT COUNT(DISTINCT customer_key) AS total_customers 
FROM gold.dim_customers;

-- How many customers have placed at least one order?
SELECT COUNT(DISTINCT customer_key) AS customers_placed_order 
FROM gold.fact_sales;

-- Summary of all key measures
SELECT 'total_sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'total_quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'average_price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'total_orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT 'total_products', COUNT(DISTINCT product_key) FROM gold.dim_products
UNION ALL
SELECT 'total_customers', COUNT(DISTINCT customer_key) FROM gold.dim_customers
UNION ALL
SELECT 'customers_placed_order', COUNT(DISTINCT customer_key) FROM gold.fact_sales;
