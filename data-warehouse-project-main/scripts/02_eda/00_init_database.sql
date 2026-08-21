/*
===============================================================================
Database Initialization
===============================================================================
Purpose:
    - Database setup and prerequisites for data warehouse analysis.

Note:
    - Ensure the database and tables are properly created before running analysis scripts.
    - All subsequent scripts assume the gold schema (dim_customers, dim_products, fact_sales) exists.
===============================================================================
*/

-- Database connection and schema validation
-- Verify the gold schema tables are accessible
SELECT 
    TABLE_SCHEMA,
    TABLE_NAME,
    TABLE_TYPE
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_SCHEMA = 'gold'
ORDER BY TABLE_NAME;
