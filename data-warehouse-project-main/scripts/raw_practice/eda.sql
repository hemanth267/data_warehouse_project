-- ===============================
-- 1. DATABASE EXPLORATION 
-- ===============================

-- exploring all obj in database
SELECT	* FROM INFORMATION_SCHEMA.TABLES;
/*
DataWarehouse	gold	dim_customers	VIEW
DataWarehouse	gold	dim_products	VIEW
DataWarehouse	gold	fact_sales	VIEW
*/

-- exploring all cols in database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';
/*
DataWarehouse	gold	dim_customers	customer_key	1
DataWarehouse	gold	dim_customers	customer_id	2
DataWarehouse	gold	dim_customers	customer_number	3
DataWarehouse	gold	dim_customers	first_name	4
DataWarehouse	gold	dim_customers	last_name	5
DataWarehouse	gold	dim_customers	country	6
DataWarehouse	gold	dim_customers	marital_status	7
DataWarehouse	gold	dim_customers	gender	8
DataWarehouse	gold	dim_customers	birthdate	9
DataWarehouse	gold	dim_customers	create_date	10 ...
*/

-- ===============================
-- 2. DIMENSION EXPLORATION
-- ===============================

-- >> dim_customers/country
SELECT DISTINCT country FROM gold.dim_customers;
/*
n/a
Germany
United States
Australia
United Kingdom
Canada
France
*/

-- >> dim_customers/marital status
SELECT DISTINCT marital_status FROM gold.dim_customers;
/*
Single
Married
*/

-- >> dim_customers/gender
SELECT DISTINCT gender FROM gold.dim_customers;
/*
n/a
Male
Female
*/

-- >> dim_products/category

SELECT DISTINCT category FROM gold.dim_products;
/*
NULL
Accessories
Bikes
Clothing
Components
*/

-- >> dim_products/subcategory

SELECT DISTINCT category, subcategory FROM gold.dim_products;
/*
Accessories	Bike Racks
Accessories	Bike Stands
Accessories	Bottles and Cages
Accessories	Cleaners
Accessories	Fenders
Accessories	Helmets
Accessories	Hydration Packs
Accessories	Lights
Accessories	Locks
Accessories	Panniers
Accessories	Pumps
Accessories	Tires and Tubes
Bikes	Mountain Bikes
...
*/

SELECT DISTINCT category, subcategory, product_name FROM gold.dim_products
ORDER BY 1,2,3
/*
Bikes	Mountain Bikes	Mountain-100 Black- 38
Bikes	Mountain Bikes	Mountain-100 Black- 42
Bikes	Mountain Bikes	Mountain-100 Black- 44
...
*/

-- >> dim_products/maintenance
SELECT DISTINCT maintenance FROM gold.dim_products;
/*
NULL
No
Yes
*/

-- >> dim_products/product_line
SELECT DISTINCT product_line FROM gold.dim_products;
/*
Mountain
n/a
Other Sales
Road
Touring
*/

-- ===============================
-- 3. DATE EXPLORATION
-- ===============================

-- >> fact_sales/order_date
SELECT
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_months
FROM gold.fact_sales
-- 2010-12-29	2014-01-28	37

-- >> fact_sales/shipping_date
SELECT
	MIN(shipping_date) AS first_shipping_date,
	MAX(shipping_date) AS last_shipping_date,
	DATEDIFF(MONTH, MIN(shipping_date), MAX(shipping_date)) AS order_range_months
FROM gold.fact_sales
-- 2011-01-05	2014-02-04	37

-- >> fact_sales/due_date
SELECT
	MIN(due_date) AS first_due_date,
	MAX(due_date) AS last_due_date,
	DATEDIFF(MONTH, MIN(due_date), MAX(due_date)) AS order_range_months
FROM gold.fact_sales
-- 2011-01-10	2014-02-09	37

-- >> dim_customers/birthdate
SELECT
	MIN(birthdate) AS oldest_birthday,
	MAX(birthdate) AS youngest_birthday,
	DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS min_age,
	DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS max_age
FROM gold.dim_customers
-- 1916-02-10	1986-06-25	110	40

-- >> dim_products/start_date
SELECT
	MIN(start_date) AS oldest_start_date,
	MAX(start_date) AS lastest_start_date,
	DATEDIFF(MONTH, MIN(start_date), MAX(start_date)) AS start_date_range_months
FROM gold.dim_products
-- 2003-07-01	2013-07-01 120

-- ===============================
-- 4. MEASURES EXPLORATION 
-- ===============================

-- total sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales
-- 29356250

-- items sold
SELECT SUM(quantity) AS total_quantity FROM gold.fact_sales
-- 60423

-- avg selling price
SELECT AVG(price) AS average_price FROM gold.fact_sales
-- 486

-- total no of orders
SELECT COUNT(order_number) AS total_orders FROM gold.fact_sales
-- 60398
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales
-- 27659

-- total no of products
SELECT COUNT(product_key) AS total_products FROM gold.dim_products
-- 295
SELECT COUNT(DISTINCT product_key) AS total_products FROM gold.dim_products
--295

-- total no of customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers
-- 18484
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.dim_customers
-- 18484

-- customers placed order
SELECT COUNT(DISTINCT customer_key) AS customers_placed_order FROM gold.fact_sales
-- 18484

-- report of all above 
SELECT 'total_sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'total_quantity', SUM(quantity) FROM gold.fact_sales
UNION ALL
SELECT 'average_price', AVG(price) FROM gold.fact_sales
UNION ALL
SELECT 'total_orders', COUNT(DISTINCT order_number) FROM gold.fact_sales
UNION ALL
SELECT  'total_products', COUNT(DISTINCT product_key) FROM gold.dim_products
UNION ALL
SELECT 'total_customers', COUNT(DISTINCT customer_key) FROM gold.dim_customers
UNION ALL
SELECT 'customers_placed_order', COUNT(DISTINCT customer_key) FROM gold.fact_sales
/*
total_sales				29356250
total_quantity			60423
average_price			486
total_orders			27659
total_products			295
total_customers			18484
customers_placed_order	18484
*/

-- ===============================
-- 5. MAGNITUDE ANALYSIS
-- ===============================

-- customers over country 
SELECT
	country,
	COUNT(*) AS total_cust
FROM gold.dim_customers
GROUP BY country
ORDER BY COUNT(*) DESC;
/*
United States	7482
Australia	3591
United Kingdom	1913
France	1810
Germany	1780
Canada	1571
n/a	337
*/

-- customers over marital status
SELECT
	marital_status,
	COUNT(*) AS cnt
FROM gold.dim_customers
GROUP BY marital_status
ORDER BY COUNT(*) DESC;
/*
Married	10011
Single	8473
*/

-- customers over gender
SELECT
	gender,
	COUNT(*) AS cnt
FROM gold.dim_customers
GROUP BY gender
ORDER BY COUNT(*) DESC
/*
Male	9341
Female	9128
n/a	15
*/

-- products over maintenance
SELECT 
	maintenance,
	COUNT(*) AS cnt
FROM gold.dim_products
GROUP BY maintenance;
/*
NULL	7
No	62
Yes	226
*/

-- products over product_line
SELECT 
	product_line,
	COUNT(*) AS cnt
FROM gold.dim_products
GROUP BY product_line;
/*
Mountain	91
n/a	17
Other Sales	35
Road	100
Touring	52
*/


-- products over category
SELECT
	category,
	COUNT(*) AS cnt
FROM gold.dim_products
GROUP BY category
ORDER BY COUNT(*) DESC;
/*
Components	127
Bikes	97
Clothing	35
Accessories	29
NULL	7
*/

-- avg costs over category
SELECT
	category,
	AVG(cost) AS average_cost
FROM gold.dim_products
GROUP BY category
ORDER BY AVG(cost) DESC;
/*
Bikes	949
Components	264
NULL	28
Clothing	24
Accessories	13
*/

-- total revenue for each cat
SELECT
	SUM(f.sales_amount) AS total_revenue,
	p.category
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key =p.product_key
GROUP BY p.category
ORDER BY SUM(f.sales_amount)

-- total revenue for each cust
SELECT
	c.customer_key,
	c.first_name,
	c.last_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY SUM(f.sales_amount) DESC
/*
1302	Nichole	Nara	13294
1133	Kaitlyn	Henderson	13294
1309	Margaret	He	13268
*/

-- distribution of sold items across countries
SELECT
	c.country,
	SUM(f.quantity) AS total_sold_items
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY SUM(f.quantity) DESC
/*
United States	20481
Australia	13346
Canada	7630
United Kingdom	6910
Germany	5626
France	5559
n/a	871
*/

-- ===============================
-- 6. RANKING ANALYSIS
-- ===============================

-- 5 products gen highest revenue

SELECT TOP 5
	p.product_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY SUM(f.sales_amount) DESC
/*
Mountain-200 Black- 46	1373454
Mountain-200 Black- 42	1363128
Mountain-200 Silver- 38	1339394
Mountain-200 Silver- 46	1301029
Mountain-200 Black- 38	1294854
*/

SELECT 
	product_name,
	total_revenue
FROM(
	SELECT
		p.product_name,
		SUM(f.sales_amount) AS total_revenue,
		ROW_NUMBER() OVER(ORDER BY SUM(f.sales_amount) DESC) AS rank_products
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON p.product_key = f.product_key
	GROUP BY p.product_name
) t
WHERE rank_products<=5

-- 5 worst performig products (in terms of sales)
SELECT TOP 5
	p.product_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY SUM(f.sales_amount)
/*
Racing Socks- L	2430
Racing Socks- M	2682
Patch Kit/8 Patches	6382
Bike Wash - Dissolver	7272
Touring Tire Tube	7440
*/

-- top 10 customers highest revenue
SELECT TOP 10
	c.customer_key,
	c.first_name,
	c.last_name,
	SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY SUM(f.sales_amount) DESC
/*
1302	Nichole	Nara	13294
1133	Kaitlyn	Henderson	13294
1309	Margaret	He	13268
1132	Randall	Dominguez	13265
1301	Adriana	Gonzalez	13242
1322	Rosa	Hu	13215
1125	Brandi	Gill	13195
1308	Brad	She	13172
1297	Francisco	Sara	13164
434	Maurice	Shan	12914
*/

-- top 3 customers with fewer orders placed
SELECT TOP 3
	c.customer_key,
	c.first_name,
	c.last_name,
	COUNT(DISTINCT f.order_number) AS num_of_orders
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
ON f.customer_key = c.customer_key
GROUP BY c.customer_key, c.first_name, c.last_name
ORDER BY COUNT(DISTINCT f.order_number) ASC
/*
16	Chloe	Young	1
17	Wyatt	Hill	1
21	Jordan	King	1
*/