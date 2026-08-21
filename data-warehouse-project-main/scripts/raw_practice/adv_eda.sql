-- ===============================
-- 7. CHANGE OVER TIME ANALYSIS 
-- ===============================

-- analyze sales perf over time

-- over year
SELECT
    YEAR(order_date) AS order_year,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date)
ORDER BY YEAR(order_date)
/*
2010	43419	14	14
2011	7075088	2216	2216
2012	5842231	3255	3397
2013	16344878	17427	52807
2014	45642	834	1970
*/

-- over month (seasonality)
SELECT
    MONTH(order_date) AS order_month,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY MONTH(order_date)
ORDER BY MONTH(order_date)
/*
1	1868558	1818	4043
2	1744517	1765	3858
3	1908375	1982	4449
4	1948226	1916	4355
5	2204969	2074	4781
6	2935883	2430	5573
7	2412838	2154	5107
8	2684313	2312	5335
9	2536520	2210	5070
10	2916550	2533	5838
11	2979113	2500	5756
12	3211396	2656	6239
*/

-- for each spec month over years
SELECT
--  DATETRUNC(month, order_date) AS order_date,
	FORMAT(order_date, 'yyyy-MMM') AS order_date,
	SUM(sales_amount) AS total_sales,
	COUNT(DISTINCT customer_key) AS total_customers,
	SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM')
/*
2010-Dec	43419	14	14
2011-Apr	502042	157	157
2011-Aug	614516	193	193
2011-Dec	669395	222	222
2011-Feb	466307	144	144
2011-Jan	469795	144	144
2011-Jul	596710	188	188
2011-Jun	737793	230	230
2011-Mar	485165	150	150
2011-May	561647	174	174
2011-Nov	660507	208	208
2011-Oct	708164	221	221
2011-Sep	603047	185	185
2012-Apr	400324	219	219
2012-Aug	523887	294	294
2012-Dec	624454	354	483
2012-Feb	506992	260	260
2012-Jan	495363	252	252
2012-Jul	444533	246	246
2012-Jun	555142	318	318
2012-Mar	373478	212	212
2012-May	358866	207	207
2012-Nov	537918	324	324
2012-Oct	535125	313	313
2012-Sep	486149	269	269
2013-Apr	1045860	1564	3979
2013-Aug	1545910	1898	4848
2013-Dec	1874128	2133	5520
2013-Feb	771218	1373	3454
2013-Jan	857758	627	1677
2013-Jul	1371595	1796	4673
2013-Jun	1642948	1948	5025
2013-Mar	1049732	1631	4087
2013-May	1284456	1719	4400
2013-Nov	1780688	2036	5224
2013-Oct	1673261	2073	5304
2013-Sep	1447324	1832	4616
2014-Jan	45642	834	1970
*/

-- ===============================
-- 8. CUMULATIVE ANALYSIS
-- ===============================

-- calc total sales per month and running total of sales 
SELECT
	order_date,
	total_revenue,
	SUM(total_revenue) OVER(ORDER BY order_date) AS running_total_revenue,
	avg_revenue,
	AVG(avg_revenue) OVER(ORDER BY order_date) AS running_avg_revenue
FROM(
	SELECT
		DATETRUNC(MONTH, order_date) AS order_date,
		SUM(sales_amount) AS total_revenue,
		AVG(sales_amount) AS avg_revenue
	FROM gold.fact_sales
	WHERE order_date IS NOT NULL
	GROUP BY DATETRUNC(MONTH, order_date)
) t 
/*
2010-12-01	43419	43419	3101	3101
2011-01-01	469795	513214	3262	3181
2011-02-01	466307	979521	3238	3200
2011-03-01	485165	1464686	3234	3208
2011-04-01	502042	1966728	3197	3206
2011-05-01	561647	2528375	3227	3209
2011-06-01	737793	3266168	3207	3209
2011-07-01	596710	3862878	3173	3204
2011-08-01	614516	4477394	3184	3202
2011-09-01	603047	5080441	3259	3208
2011-10-01	708164	5788605	3204	3207
2011-11-01	660507	6449112	3175	3205
2011-12-01	669395	7118507	3015	3190
2012-01-01	495363	7613870	1965	3102
2012-02-01	506992	8120862	1949	3026
2012-03-01	373478	8494340	1761	2946
2012-04-01	400324	8894664	1827	2881
2012-05-01	358866	9253530	1733	2817
2012-06-01	555142	9808672	1745	2760
2012-07-01	444533	10253205	1807	2713
2012-08-01	523887	10777092	1781	2668
2012-09-01	486149	11263241	1807	2629
2012-10-01	535125	11798366	1709	2589
2012-11-01	537918	12336284	1660	2550
2012-12-01	624454	12960738	1292	2500
2013-01-01	857758	13818496	516	2424
2013-02-01	771218	14589714	223	2342
2013-03-01	1049732	15639446	256	2268
2013-04-01	1045860	16685306	262	2198
2013-05-01	1284456	17969762	291	2135
2013-06-01	1642948	19612710	326	2076
2013-07-01	1371595	20984305	293	2021
2013-08-01	1545910	22530215	318	1969
2013-09-01	1447324	23977539	313	1920
2013-10-01	1673261	25650800	315	1875
2013-11-01	1780688	27431488	340	1832
2013-12-01	1874128	29305616	339	1792
2014-01-01	45642	29351258	23	1745
*/

-- ===============================
-- 9. PERFORMANCE ANALYSIS
-- ===============================

-- analyze the yearly performance of products by comparing
-- each prod sales to both its avg performance and prev yr sales

SELECT
	product_key,
	order_date,
	total_revenue AS curr_yr_revenue,
	LAG(total_revenue) OVER(PARTITION BY product_key ORDER BY order_date) AS prev_yr_revenue,
	AVG(total_revenue) OVER(PARTITION BY product_key) AS avg_product_revenue
FROM (
	SELECT
		YEAR(order_date) AS order_date,
		product_key,
		SUM(sales_amount) AS total_revenue
	FROM gold.fact_sales
	GROUP BY YEAR(order_date), product_key
) t
ORDER BY product_key, order_date;
/*
105	2012	81	9	3852
105	2013	15237	81	3852
105	2014	81	15237	3852
106	2012	540	NULL	12960
106	2013	25380	540	12960
*/

WITH yearly_product_sales AS(
	SELECT
		YEAR(f.order_date) AS order_date,
		p.product_name,
		SUM(f.sales_amount) AS curr_sales
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON f.product_key = p.product_key
	WHERE f.order_date IS NOT NULL
	GROUP BY YEAR(f.order_date), p.product_name
)
SELECT
	order_date,
	product_name,
	curr_sales,
	AVG(curr_sales) OVER(PARTITION BY product_name) avg_sales,
	curr_sales - AVG(curr_sales) OVER(PARTITION BY product_name) AS avg_diff,
	CASE 
		WHEN curr_sales < AVG(curr_sales) OVER(PARTITION BY product_name) THEN 'Below Avg'
		WHEN curr_sales > AVG(curr_sales) OVER(PARTITION BY product_name) THEN 'Above Avg'
		ELSE 'Avg'
	END AS avg_report,
	LAG(curr_sales) OVER(PARTITION BY product_name ORDER BY order_date) AS prev_yr_sales,
	curr_sales - LAG(curr_sales) OVER(PARTITION BY product_name ORDER BY order_date) AS py_diff,
	CASE 
		WHEN curr_sales < LAG(curr_sales) OVER(PARTITION BY product_name ORDER BY order_date) THEN 'Decrease'
		WHEN curr_sales > LAG(curr_sales) OVER(PARTITION BY product_name ORDER BY order_date) THEN 'Increase'
		ELSE 'Same as pv year'
	END AS year_report
FROM yearly_product_sales
ORDER BY product_name, order_date

/*
2012	All-Purpose Bike Stand	159	13197	-13038	Below Avg	NULL	NULL	Same as pv year
2013	All-Purpose Bike Stand	37683	13197	24486	Above Avg	159	37524	Increase
2014	All-Purpose Bike Stand	1749	13197	-11448	Below Avg	37683	-35934	Decrease
2012	AWC Logo Cap	72	6570	-6498	Below Avg	NULL	NULL	Same as pv year
2013	AWC Logo Cap	18891	6570	12321	Above Avg	72	18819	Increase
2014	AWC Logo Cap	747	6570	-5823	Below Avg	18891	-18144	Decrease
*/

-- ===============================
-- 10. PART TO WHOLE ANALYSIS 
-- ===============================

-- contribution of cat to overall sales
SELECT
	category,
	revenue_per_cat,
	CONCAT(ROUND(100.0*CAST(revenue_per_cat AS FLOAT)/SUM(revenue_per_cat) OVER(), 2),' %') AS pct_contrib
FROM(
	SELECT
		p.category,
		SUM(f.sales_amount) AS revenue_per_cat
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_products p
	ON f.product_key = p.product_key
	GROUP BY p.category
) t
ORDER BY revenue_per_cat DESC

/*
Bikes	28316272	96.46 %
Accessories	700262	2.39 %
Clothing	339716	1.16 %
*/

-- ===============================
-- 11. DATA SEGMENTATION
-- ===============================

-- segment products into cost ranges and count how many products fall into each segment
WITH product_segments AS (
	SELECT
		product_name,
		cost,
		CASE
			WHEN cost<100 THEN 'Below 100'
			WHEN cost<=500 THEN '100-500'
			WHEN cost<=1000 THEN '500-1000'
			ELSE 'Above 1000'
		END cost_range
	FROM gold.dim_products
)
SELECT
	cost_range,
	COUNT(*) AS count
FROM product_segments
GROUP BY cost_range
ORDER BY COUNT(*) DESC

/*
Group customers into 3 segments based on spending behavior
VIP     : >=12 months AND >5000
REGULAR : >=12 months AND <5000
NEW		: <12 months
*/

WITH customer_spending AS (
	SELECT
		c.customer_key,
		SUM(f.sales_amount) AS total_spending,
		MIN(f.order_date) AS first_order,
		MAX(f.order_date) AS last_order,
		DATEDIFF(month, MIN(f.order_date), MAX(f.order_date)) AS life_span
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c
	ON c.customer_key = f.customer_key
	GROUP BY c.customer_key
)
SELECT
	customer_key,
	total_spending,
	first_order,
	last_order,
	life_span,
	CASE
		WHEN life_span>=12 AND total_spending>5000 THEN 'VIP'
		WHEN life_span>-12 AND total_spending<=5000 THEN 'REGULAR'
		ELSE 'NEW'
	END AS cust_cat
FROM customer_spending;
/*
190	5944	2011-08-26	2013-02-05	18	VIP
522	44	2013-03-05	2013-11-07	8	REGULAR
854	90	2013-05-10	2013-06-20	1	REGULAR
7020	5707	2012-12-03	2013-11-27	11	NEW
6210	7182	2012-09-24	2013-08-06	11	NEW
*/

WITH customer_spending AS (
	SELECT
		c.customer_key,
		SUM(f.sales_amount) AS total_spending,
		MIN(f.order_date) AS first_order,
		MAX(f.order_date) AS last_order,
		DATEDIFF(month, MIN(f.order_date), MAX(f.order_date)) AS life_span
	FROM gold.fact_sales f
	LEFT JOIN gold.dim_customers c
	ON c.customer_key = f.customer_key
	GROUP BY c.customer_key
)
SELECT
	CASE
		WHEN life_span>=12 AND total_spending>5000 THEN 'VIP'
		WHEN life_span>=12 AND total_spending<=5000 THEN 'REGULAR'
		ELSE 'NEW'
	END AS cust_cat,
	COUNT(*) AS cnt
FROM customer_spending
GROUP BY CASE
			WHEN life_span>=12 AND total_spending>5000 THEN 'VIP'
			WHEN life_span>=12 AND total_spending<=5000 THEN 'REGULAR'
			ELSE 'NEW'
		 END
/*
NEW	14631
REGULAR	2198
VIP	1655
*/