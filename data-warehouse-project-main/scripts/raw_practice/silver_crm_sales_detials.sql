-- ========================
-- crm_sales_details cleaning
-- ========================

-- peek

SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details

SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details
WHERE sls_prd_key NOT IN (
	SELECT prd_key FROM silver.crm_prd_info
)
-- none not mapping to unknown prd_key so safe


SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details
WHERE sls_cust_id NOT IN (
	SELECT cst_id FROM silver.crm_cust_info
)
-- none here to safe mapping

SELECT
	*
FROM bronze.crm_sales_details
WHERE sls_ord_num IN (
	SELECT
		sls_ord_num
	FROM bronze.crm_sales_details
	GROUP BY sls_ord_num
	HAVING COUNT(*)>1
)
/*
SO51176	BK-R89B-58	18239	20121228	20130104	20130109	2443	1	2443
SO51176	BC-R205	18239	20121228	20130104	20130109	9	1	9
SO51177	BK-T44U-46	27873	20121228	20130104	20130109	1215	1	1215
SO51177	HL-U509	27873	20121228	20130104	20130109	35	1	35
*/
-- allowed since its like same cust ordered multiple prod so thats the reason we will allow it n its safe 

-- order ship due date weren't dates (int) we have to convert them
SELECT
	sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt IS NULL OR sls_ship_dt<=0 OR sls_ship_dt > 20500101 OR LEN(sls_ship_dt) != 8
-- here no null no 0's no right outliers

SELECT
	sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt IS NULL OR sls_due_dt<=0 OR sls_due_dt > 20500101 OR LEN(sls_due_dt) != 8
-- here no null no 0's no right outliers

-- check invalid ones in order 
SELECT
	sls_order_dt
FROM bronze.crm_sales_details
WHERE sls_order_dt IS NULL OR sls_order_dt<=0 OR sls_order_dt > 20500101 OR LEN(sls_order_dt) != 8
-- no null no right side outliers but we have 0's and these 2 values 32154 5489
-- we will replace null's with 0 but what about those 2

SELECT
	*
FROM bronze.crm_sales_details
WHERE sls_order_dt IN (32154, 5489)
-- SO69215	TI-M823	16864	32154	20131102	20131107	-35	1	35
-- SO69215	TT-M928	16864	5489	20131102	20131107	5	1	5
-- simply its bad quality data n we cant lose them so simple place null at their pos too

SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE
		WHEN sls_order_dt IS NULL OR sls_order_dt = 0 OR LEN(sls_order_dt)!= 8 THEN NULL
		ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
	END AS sls_order_dt,
	CASE
		WHEN sls_ship_dt IS NULL OR sls_ship_dt = 0 OR LEN(sls_ship_dt)!= 8 THEN NULL
		ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
	END AS sls_ship_dt,
	CASE
		WHEN sls_due_dt IS NULL OR sls_due_dt = 0 OR LEN(sls_due_dt)!= 8 THEN NULL
		ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
	END AS sls_due_dt
FROM bronze.crm_sales_details

-- check for invalid combinations too
SELECT
	*
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt
-- none

-- business rule : sales = qty * price
-- and -ve 0's null are not allowed

SELECT DISTINCT
	sls_sales,
	sls_quantity,
	sls_price
FROM bronze.crm_sales_details
WHERE sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <=0 OR sls_quantity <=0 OR sls_price <=0
OR sls_sales != sls_quantity * sls_price
ORDER BY sls_sales, sls_quantity, sls_price

-- never do it on own discuss with seniors n take decision
-- these issues can be fixed itslef in source system or can be done in datawarehouse
-- approach : 
-- when sales is <=0 or null derive it from price n quantity (if price<0 makeit +ve)
-- here sls_qty quality is quite good no <=0 and no nulls
-- when price <=0 or null derive it from sales n quantity

SELECT DISTINCT
	sls_sales,
	sls_price,
	sls_quantity,
	CASE
		WHEN sls_sales IS NULL OR sls_sales<=0 OR sls_sales!=sls_quantity*ABS(sls_price) THEN sls_quantity*ABS(sls_price)
		ELSE sls_sales
	END AS clean_sls_sales,
	CASE
		WHEN sls_price IS NULL OR sls_price <=0 THEN sls_sales/NULLIF(sls_quantity,0)
		ELSE sls_price
	END AS clean_sls_price
FROM bronze.crm_sales_details
WHERE sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <=0 OR sls_quantity <=0 OR sls_price <=0
OR sls_sales != sls_quantity * sls_price
-- as based on above rules all of them handled successfully ()

-- final go
INSERT INTO silver.crm_sales_details (
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_order_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_quantity,
	sls_sales,
	sls_price
)
SELECT
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE
		WHEN sls_order_dt IS NULL OR sls_order_dt = 0 OR LEN(sls_order_dt)!= 8 THEN NULL
		ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
	END AS sls_order_dt,
	CASE
		WHEN sls_ship_dt IS NULL OR sls_ship_dt = 0 OR LEN(sls_ship_dt)!= 8 THEN NULL
		ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
	END AS sls_ship_dt,
	CASE
		WHEN sls_due_dt IS NULL OR sls_due_dt = 0 OR LEN(sls_due_dt)!= 8 THEN NULL
		ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
	END AS sls_due_dt,
	CASE
		WHEN sls_sales IS NULL OR sls_sales<=0 OR sls_sales!=sls_quantity*ABS(sls_price) THEN sls_quantity*ABS(sls_price)
		ELSE sls_sales
	END AS sls_sales,
	sls_quantity,
	CASE
		WHEN sls_price IS NULL OR sls_price <=0 THEN sls_sales/NULLIF(sls_quantity,0)
		ELSE sls_price
	END AS sls_price
FROM bronze.crm_sales_details

SELECT
	*
FROM bronze.crm_sales_details