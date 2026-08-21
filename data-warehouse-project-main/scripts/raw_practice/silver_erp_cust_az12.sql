-- ========================
-- erp_cust_az12 cleaning
-- ========================

-- peek
SELECT
	*
FROM bronze.erp_cust_az12

-- its mapping to crm_cust_info so check that too
SELECT
	*
FROM silver.crm_cust_info

/*
in crm_cust_info
AW00011264
AW00011265
AW00011266

in erp_cust_az12
NASAW00011264
NASAW00011265
NASAW00011266
*/
-- and also some of in erp was same as crm
-- so we have to delete extra non imp char if they exists

SELECT
	cid,
	CASE
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
		ELSE cid
	END cid,
	bdate,
	gen
FROM bronze.erp_cust_az12
WHERE CASE
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
		ELSE cid
	  END NOT IN (SELECT DISTINCT cst_key FROM silver.crm_cust_info)
-- none so our transformation is fine

SELECT
	bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE()
-- we have bday > curr date and we have few old records like 1916 they r valid

SELECT
	cid,
	CASE
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
		ELSE cid
	END cid,
	bdate,
	CASE
		WHEN bdate > GETDATE() THEN NULL
		ELSE bdate
	END AS bdate,
	gen
FROM bronze.erp_cust_az12;

SELECT
	DISTINCT gen
FROM bronze.erp_cust_az12;
/*
NULL
F 
  
Male
Female
M 
*/
-- we have reduce them to 3 (Male Female n/a)

SELECT
	cid,
	CASE
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
		ELSE cid
	END cid,
	bdate,
	CASE
		WHEN bdate > GETDATE() THEN NULL
		ELSE bdate
	END AS bdate,
	gen,
	CASE 
		WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
		WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
		ELSE 'n/a'
	END AS gen
FROM bronze.erp_cust_az12;

-- final insert cleaned data
INSERT INTO silver.erp_cust_az12 (cid, bdate, gen)
SELECT
	CASE
		WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid,4,LEN(cid))
		ELSE cid
	END cid,
	CASE
		WHEN bdate > GETDATE() THEN NULL
		ELSE bdate
	END AS bdate,
	CASE 
		WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
		WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
		ELSE 'n/a'
	END AS gen
FROM bronze.erp_cust_az12;

SELECT
	*
FROM silver.erp_cust_az12;