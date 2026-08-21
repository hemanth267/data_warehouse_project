-- ========================
-- crm_cust_info cleaning
-- ========================

-- peek
SELECT
TOP 100
	*
FROM bronze.crm_cust_info;

-- check nulls for key
SELECT
	cst_id,
	COUNT(*) AS flag
FROM bronze.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*)>1 OR cst_id IS NULL;
-- 29449	2
-- 29473	2
-- 29433	2
-- NULL	3
-- 29483	2
-- 29466	3

-- peek what to do with these duplicates
SELECT
	*
FROM bronze.crm_cust_info
WHERE cst_id = 29466;

-- 29466	AW00029466	NULL	NULL	NULL	NULL	2026-01-25
-- 29466	AW00029466	Lance	Jimenez	M	NULL	2026-01-26
-- 29466	AW00029466	Lance	Jimenez	M	M	2026-01-27
-- ie latest the cst_create_date updated the records

SELECT
	*
FROM(
	SELECT
		*,
		ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag
	FROM bronze.crm_cust_info
) t
-- WHERE flag>1; -- for duplicated rows (we will ignore these)
WHERE flag = 1;

-- check for unwanted spaces
SELECT
	cst_firstname
FROM bronze.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);
-- columns exists so we have unwanted spaces (expected : not exists)

SELECT
	cst_lastname
FROM bronze.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);
-- columns exists so we have unwanted spaces (expected : not exists)

SELECT
	cst_key
FROM bronze.crm_cust_info
WHERE cst_key != TRIM(cst_key);
-- columns dont exists so we have unwanted spaces (expected : not exists) TRUE

SELECT
	DISTINCT cst_marital_status
FROM bronze.crm_cust_info;
-- S
-- NULL
-- M
-- replace nulls with def 'n/a' and be more specific and meaningful names (Single Marries n/a)

SELECT
	DISTINCT cst_gndr
FROM bronze.crm_cust_info;
-- NULL
-- F
-- M
-- replace nulls with def 'n/a' and be more specific and meaningful names (Female Male n/a)

SELECT
	*
FROM bronze.crm_cust_info
WHERE cst_create_date IS NULL;

-- NULL	SF566	NULL	NULL	NULL	NULL	NULL
-- NULL	PO25	NULL	NULL	NULL	NULL	NULL
-- NULL	13451235	NULL	NULL	NULL	NULL	NULL
-- handled by cst_id since its null we will ignore these too

SELECT
	*
FROM bronze.crm_cust_info
WHERE cst_firstname IS NULL;

-- 29433	AW00029433	NULL	NULL	M	M	2026-01-25
-- NULL	SF566	NULL	NULL	NULL	NULL	NULL
-- 29449	AW00029449	NULL	Chen	S	NULL	2026-01-25
-- 29466	AW00029466	NULL	NULL	NULL	NULL	2026-01-25
-- NULL	PO25	NULL	NULL	NULL	NULL	NULL
-- 29483	AW00029483	NULL	Navarro	NULL	NULL	2026-01-25
-- NULL	13451235	NULL	NULL	NULL	NULL	NULL
-- handled by cst_id since its null or repeated we will ignore these too


-- final cleaning process
-- 1. cst_id use ROW_NUMBER(OVER cst_id ORDER BY cst_create_date) pick only whose rank is 1 and id not null
-- 2. cst_key is clean so no needed for any transformation
-- 3. cst_firstname, cst_lastname have unwanted spaces TRIM them
-- 4. cst_martial_status, cst_gndr use case for detailed names and n/a def value in place of null
-- 5. cst_create_date, cst_firstname, cst_lastname null handled in cst_id
-- 6. cst_key dont have null (expected)

INSERT INTO silver.crm_cust_info (
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_marital_status,
	cst_gndr,
	cst_create_date
)
SELECT
	cst_id,
	cst_key,
	TRIM(cst_firstname) AS cst_firstname,
	TRIM(cst_lastname) AS cst_lastname,
	CASE
		WHEN TRIM(UPPER(cst_marital_status)) = 'M' THEN 'Married'
		WHEN TRIM(UPPER(cst_marital_status)) = 'S' THEN 'Single'
		ELSE 'n/a'
	END AS cst_marital_status,
	CASE
		WHEN TRIM(UPPER(cst_gndr)) = 'M' THEN 'Male'
		WHEN TRIM(UPPER(cst_gndr)) = 'F' THEN 'Female'
		ELSE 'n/a'
	END AS cst_gndr,
	cst_create_date
FROM (
	SELECT
		*,
		ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) AS flag
	FROM bronze.crm_cust_info
	WHERE cst_id IS NOT NULL
) t
WHERE t.flag = 1;

SELECT
	*
FROM silver.crm_cust_info;