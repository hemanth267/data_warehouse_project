/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To explore dimension tables and their distinct values.
    - To understand data categories and attributes.
    - To identify data quality and cardinality patterns.

SQL Functions Used:
    - SELECT DISTINCT
    - GROUP BY
    - COUNT()
===============================================================================
*/

-- What are the distinct countries in dim_customers?
SELECT DISTINCT country 
FROM gold.dim_customers;

-- What are the distinct marital statuses?
SELECT DISTINCT marital_status 
FROM gold.dim_customers;

-- What are the distinct genders?
SELECT DISTINCT gender 
FROM gold.dim_customers;

-- What are the distinct product categories?
SELECT DISTINCT category 
FROM gold.dim_products;

-- What are the distinct subcategories by category?
SELECT DISTINCT category, subcategory 
FROM gold.dim_products;

-- What are the distinct products by category and subcategory?
SELECT DISTINCT category, subcategory, product_name 
FROM gold.dim_products
ORDER BY 1, 2, 3;

-- What maintenance values exist for products?
SELECT DISTINCT maintenance 
FROM gold.dim_products;

-- What are the distinct product lines?
SELECT DISTINCT product_line 
FROM gold.dim_products;
