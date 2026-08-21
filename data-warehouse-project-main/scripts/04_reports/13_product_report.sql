/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This report consolidates key product metrics and performance indicators.

Highlights:
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

SQL Functions Used:
    - Window Aggregation Functions
    - CASE Statements for Segmentation
    - DATEDIFF() for Time Calculations
    - COUNT(DISTINCT) for Unique Counts
    - MIN(), MAX(), SUM() Aggregations
===============================================================================
*/

-- =============================================================================
-- Create Report: gold.report_products
-- =============================================================================
IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS

WITH base_query AS (
    /*
    ---------------------------------------------------------------------------
    1) Base Query: Retrieves core columns from tables
    ---------------------------------------------------------------------------
    */
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

product_aggregation AS (
    /*
    ---------------------------------------------------------------------------
    2) Product Aggregations: Summarizes key metrics at the product level
    ---------------------------------------------------------------------------
    */
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

/*
---------------------------------------------------------------------------
3) Final Report: Calculates valuable KPIs and segments products
---------------------------------------------------------------------------
*/
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
        WHEN total_revenue < 100000 THEN 'Low Performer'
        WHEN total_revenue < 500000 THEN 'Mid Performer'
        ELSE 'High Performer'
    END AS product_segment,
    total_quantity,
    total_customers,
    CASE
        WHEN total_orders = 0 THEN 0
        ELSE total_revenue / total_orders
    END AS avg_order_revenue,
    CASE
        WHEN life_span = 0 THEN 0
        ELSE total_revenue / life_span
    END AS avg_monthly_revenue
FROM product_aggregation;
