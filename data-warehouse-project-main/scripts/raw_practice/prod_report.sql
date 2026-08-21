-- ==================================
-- PRODUCT REPORT
/*
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
       - total orders
       - total sales
       - total quantity sold
       - total customers (unique)
       - lifespan (in months)
    4. Calculates valuable KPIs:
       - recency (months since last sale)
       - average order revenue (AOR)
       - average monthly revenue
*/
-- ==================================

IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products
GO

CREATE VIEW gold.report_products AS

-- 1. Gathers essential fields such as product name, category, subcategory, and cost.
WITH base_query AS (
    SELECT
        f.order_number,
        f.customer_key,
        f.order_date,
        f.sales_amount,
        f.price,
        f.quantity,
        p.product_key,
        p.product_number,
        p.product_name,
        p.category,
        p.subcategory,
        p.maintenance,
        p.product_line,
        p.cost,
        p.start_date
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
),

-- base query output
/*
SO43697	2010-12-29	3578	3578	1	20	BK-R93R-62	Road-150 Red- 62	Bikes	Road Bikes	Yes	Road	2171	2011-07-01
SO43698	2010-12-29	3400	3400	1	9	BK-M82S-44	Mountain-100 Silver- 44	Bikes	Mountain Bikes	Yes	Mountain	1912	2011-07-01
SO43699	2010-12-29	3400	3400	1	9	BK-M82S-44	Mountain-100 Silver- 44	Bikes	Mountain Bikes	Yes	Mountain	1912	2011-07-01
SO43700	2010-12-29	699	699	1	41	BK-R50B-62	Road-650 Black- 62	Bikes	Road Bikes	Yes	Road	487	2012-07-01
*/

-- 3. Aggregates product-level metrics
product_aggregation AS (
    SELECT
        product_key,
        product_number,
        product_name,
        category,
        subcategory,
        maintenance,
        product_line,
        cost,
        start_date,
        COUNT(DISTINCT order_number) AS total_orders,
        MIN(order_date) AS first_order_date,
        MAX(order_date) AS last_order_date,
        DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS life_span,
        SUM(sales_amount) AS total_revenue,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT customer_key) AS total_customers
    FROM base_query
    GROUP BY
        product_key,
        product_number,
        product_name,
        category,
        subcategory,
        maintenance,
        product_line,
        cost,
        start_date
)

-- output of product aggregation
/*
3	BK-M82B-38	Mountain-100 Black- 38	Bikes	Mountain Bikes	Yes	Mountain	1898	2011-07-01	49	2011-12-27	165375	49	49
4	BK-M82B-42	Mountain-100 Black- 42	Bikes	Mountain Bikes	Yes	Mountain	1898	2011-07-01	45	2011-12-27	151875	45	45
5	BK-M82B-44	Mountain-100 Black- 44	Bikes	Mountain Bikes	Yes	Mountain	1898	2011-07-01	60	2011-12-21	202500	60	60
6	BK-M82B-48	Mountain-100 Black- 48	Bikes	Mountain Bikes	Yes	Mountain	1898	2011-07-01	57	2011-12-26	192375	57	57
*/

-- 2430	1373454	225817 (min, max, avg) of total_reveue
SELECT
    product_key,
    product_number,
    product_name,
    category,
    subcategory,
    maintenance,
    product_line,
    cost,
    start_date,
    total_orders,
    first_order_date,
    last_order_date,
    DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency,
    life_span,
    total_revenue,
    CASE
        WHEN total_revenue<100000 THEN 'Low Performers'
        WHEN total_revenue<500000 THEN 'Mid Performers'
        ELSE 'High Performers'
    END AS product_segment,
    total_quantity,
    total_customers,
    CASE
        WHEN total_orders =0 THEN 0
        ELSE total_revenue/total_orders
    END AS avg_order_revenue,
    CASE
        WHEN life_span = 0 THEN 0
        ELSE total_revenue/life_span
    END AS avg_monthly_revenue
FROM product_aggregation