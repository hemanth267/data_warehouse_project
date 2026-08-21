-- ========================
-- crm_prd_info cleaning
-- ========================

-- peek
SELECT
	prd_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info

-- check null n duplicates on id
SELECT
	prd_id,
	COUNT(*) AS flag
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*)>1
-- none not needed

SELECT
	*
FROM bronze.crm_prd_info
WHERE prd_nm IS NULL
-- no null

SELECT
	*
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm)
-- no spaces safe


-- prd key
SELECT
	prd_key,
	COUNT(*) AS flag
FROM bronze.crm_prd_info
GROUP BY prd_key
HAVING COUNT(*)>1
-- duplicates exists
SELECT
	prd_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info
WHERE prd_key = 'AC-HE-HL-U509'
-- 215	AC-HE-HL-U509	Sport-100 Helmet- Black	12	S 	2011-07-01 00:00:00.000	2007-12-28 00:00:00.000
-- 216	AC-HE-HL-U509	Sport-100 Helmet- Black	14	S 	2012-07-01 00:00:00.000	2008-12-27 00:00:00.000
-- 217	AC-HE-HL-U509	Sport-100 Helmet- Black	13	S 	2013-07-01 00:00:00.000	NULL
-- but they represent prices of same prod over time so allowed n its not pk

-- no extract imp detailings like first 2 pairchar used as prd_cat and rem used in crm_sales
SELECT
	prd_id,
	prd_key,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
	SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info

-- prd_cost check <0 and null
SELECT
	*
FROM bronze.crm_prd_info
WHERE prd_cost IS NULL OR prd_cost<=0
-- 210	CO-RF-FR-R92B-58	HL Road Frame - Black- 58	NULL	R 	2003-07-01 00:00:00.000	NULL
-- 211	CO-RF-FR-R92R-58	HL Road Frame - Red- 58	NULL	R 	2003-07-01 00:00:00.000	NULL
-- for better agg func replace those with 0's

SELECT
	prd_id,
	prd_key,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
	SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
	prd_nm,
	ISNULL(prd_cost, 0) AS prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info
WHERE ISNULL(prd_cost, 0) IS NULL

-- prd line
SELECT
	DISTINCT prd_line
FROM bronze.crm_prd_info
/*NULL
M 
R 
S 
T*/
-- replace them with standards (mountain, road, other sales, touring) with case
SELECT
	prd_id,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
	SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
	prd_nm,
	ISNULL(prd_cost, 0) AS prd_cost,
	CASE
		WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
		WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
		WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
		WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
		ELSE 'n/a'
	END AS prd_line,
	prd_start_dt,
	prd_end_dt
FROM bronze.crm_prd_info

-- check stdate and enddate any issues
SELECT
	*
FROM bronze.crm_prd_info
WHERE prd_end_dt IS NULL OR prd_start_dt IS NULL OR prd_end_dt < prd_start_dt
ORDER BY prd_key
-- 215	AC-HE-HL-U509	Sport-100 Helmet- Black	12	S 	2011-07-01 00:00:00.000	2007-12-28 00:00:00.000
-- 216	AC-HE-HL-U509	Sport-100 Helmet- Black	14	S 	2012-07-01 00:00:00.000	2008-12-27 00:00:00.000
-- 217	AC-HE-HL-U509	Sport-100 Helmet- Black	13	S 	2013-07-01 00:00:00.000	NULL
-- so um sol1 might be swapping them but the regions overlap n for some of then st and end are NULL so not good
-- best solution will be to use start date of next record -1 as end date will resolve this issue

SELECT
	prd_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt,
	LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) -1 AS prd_end_dt_test
FROM bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R', 'AC-HE-HL-U509')
-- 215	AC-HE-HL-U509	Sport-100 Helmet- Black	12	S 	2011-07-01 00:00:00.000	2007-12-28 00:00:00.000	2012-06-30 00:00:00.000
-- 216	AC-HE-HL-U509	Sport-100 Helmet- Black	14	S 	2012-07-01 00:00:00.000	2008-12-27 00:00:00.000	2013-06-30 00:00:00.000
-- 217	AC-HE-HL-U509	Sport-100 Helmet- Black	13	S 	2013-07-01 00:00:00.000	NULL	NULL
-- 212	AC-HE-HL-U509-R	Sport-100 Helmet- Red	12	S 	2011-07-01 00:00:00.000	2007-12-28 00:00:00.000	2012-06-30 00:00:00.000
-- 213	AC-HE-HL-U509-R	Sport-100 Helmet- Red	14	S 	2012-07-01 00:00:00.000	2008-12-27 00:00:00.000	2013-06-30 00:00:00.000
-- 214	AC-HE-HL-U509-R	Sport-100 Helmet- Red	13	S 	2013-07-01 00:00:00.000	NULL	NULL
-- so we can accpet this after disc with and also change ddl to DATE since time is not req all r 0's its consume memory

-- final load
INSERT INTO silver.crm_prd_info (
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)
SELECT
	prd_id,
	REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
	SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
	prd_nm,
	ISNULL(prd_cost, 0) AS prd_cost,
	CASE
		WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
		WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'Road'
		WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
		WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
		ELSE 'n/a'
	END AS prd_line,
	CAST (prd_start_dt AS DATE) AS prd_start_dt,
	CAST (LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt) -1 AS DATE) AS prd_end_dt
FROM bronze.crm_prd_info

SELECT
	*
FROM silver.crm_prd_info
ORDER BY prd_id, prd_end_dt
/*
210	CO_RF	FR-R92B-58	HL Road Frame - Black- 58	0	Road	2003-07-01	NULL	2026-05-21 06:07:38.6600000
211	CO_RF	FR-R92R-58	HL Road Frame - Red- 58	0	Road	2003-07-01	NULL	2026-05-21 06:07:38.6600000
212	AC_HE	HL-U509-R	Sport-100 Helmet- Red	12	Other Sales	2011-07-01	2012-06-30	2026-05-21 06:07:38.6600000
213	AC_HE	HL-U509-R	Sport-100 Helmet- Red	14	Other Sales	2012-07-01	2013-06-30	2026-05-21 06:07:38.6600000
214	AC_HE	HL-U509-R	Sport-100 Helmet- Red	13	Other Sales	2013-07-01	NULL	2026-05-21 06:07:38.6600000
215	AC_HE	HL-U509	Sport-100 Helmet- Black	12	Other Sales	2011-07-01	2012-06-30	2026-05-21 06:07:38.6600000
216	AC_HE	HL-U509	Sport-100 Helmet- Black	14	Other Sales	2012-07-01	2013-06-30	2026-05-21 06:07:38.6600000
217	AC_HE	HL-U509	Sport-100 Helmet- Black	13	Other Sales	2013-07-01	NULL	2026-05-21 06:07:38.6600000
*/