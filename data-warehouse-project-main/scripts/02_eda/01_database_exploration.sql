/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the data warehouse.
    - To identify tables, views, and their columns.
    - To understand the schema for subsequent analysis.

SQL Functions Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

-- Which tables and views exist in the data warehouse?
SELECT *
FROM INFORMATION_SCHEMA.TABLES;

-- What columns are available in the dim_customers table?
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';
