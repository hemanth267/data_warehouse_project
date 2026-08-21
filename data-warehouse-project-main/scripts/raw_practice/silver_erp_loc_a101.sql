-- ========================
-- erp_loc_a101 cleaning
-- ========================

-- peek
SELECT
	*
FROM bronze.erp_loc_a101;

-- check its mapping to cst_key in crm_cust_info
SELECT
	*
FROM silver.crm_cust_info;

-- one minor issue in crm like just like char then no
-- but in erp we have like char - then no we need to handle it

SELECT
	cid,
	REPLACE(cid,'-','') AS cid,
	cntry
FROM bronze.erp_loc_a101
WHERE REPLACE(cid,'-','') NOT IN (
	SELECT cst_key FROM silver.crm_cust_info
);
-- none ie the transformation was successful and dont need extrahandling

SELECT DISTINCT
	cntry
FROM bronze.erp_loc_a101;
/*
DE
USA
Germany
United States
NULL
Australia
United Kingdom
  
Canada
France
US
*/

SELECT DISTINCT
	cntry,
	CASE
		WHEN TRIM(cntry) = 'DE' THEN 'Germany' 
		WHEN TRIM(cntry) IN ('USA', 'US') THEN 'United States'
		WHEN cntry IS NULL OR TRIM(cntry)='' THEN 'n/a'
		ELSE TRIM(cntry)
	END AS cntry
FROM bronze.erp_loc_a101
/*
US	United States
United States	United States
DE	Germany
Canada	Canada
Australia	Australia
France	France
USA	United States
NULL	n/a
United Kingdom	United Kingdom
  	n/a
Germany	Germany
*/

-- Final insert cleaned data 
INSERT INTO silver.erp_loc_a101 (cid, cntry)
SELECT
	REPLACE(cid,'-','') AS cid,
	CASE
		WHEN TRIM(cntry) = 'DE' THEN 'Germany' 
		WHEN TRIM(cntry) IN ('USA', 'US') THEN 'United States'
		WHEN cntry IS NULL OR TRIM(cntry)='' THEN 'n/a'
		ELSE TRIM(cntry)
	END AS cntry
FROM bronze.erp_loc_a101;

SELECT
	*
FROM silver.erp_loc_a101;