-- ========================
-- erp_px_catg1v2 cleaning
-- ========================

-- peek
SELECT
	id,
	cat,
	subcat,
	maintenance
FROM bronze.erp_px_cat_g1v2;

SELECT
	id,
	COUNT(*) AS cnt
FROM bronze.erp_px_cat_g1v2
GROUP BY Id
HAVING COUNT(*)>1;
-- none clean id

-- its mapped to prd_key in crm_prd_info cat_id
SELECT
	*
FROM silver.crm_prd_info;

SELECT
	*
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat);
-- none clean no unwanted spaces

SELECT
	DISTINCT cat
FROM bronze.erp_px_cat_g1v2;
-- clean no duplicates


SELECT
	*
FROM bronze.erp_px_cat_g1v2
WHERE subcat != TRIM(subcat);
-- none clean no unwanted spaces

SELECT
	DISTINCT subcat
FROM bronze.erp_px_cat_g1v2;
-- clean no duplicates

SELECT
	*
FROM bronze.erp_px_cat_g1v2
WHERE maintenance != TRIM(maintenance)
-- none clean no unwanted spaces

SELECT
	DISTINCT maintenance
FROM bronze.erp_px_cat_g1v2;
-- clean only Yes or No

SELECT
	*
FROM silver.crm_prd_info
WHERE cat_id NOT IN (
	SELECT id FROM bronze.erp_px_cat_g1v2
);
-- we got one single lost mapping ie CO_PE

-- after we decided to CO_PE -> Components	Pedals
-- but we dont know about maintenance so am i ignoring it

-- final insert cleaned data
INSERT INTO silver.erp_px_cat_g1v2 (id, cat, subcat, maintenance)
SELECT
	id,
	cat,
	subcat,
	maintenance
FROM bronze.erp_px_cat_g1v2;

SELECT
	*
FROM silver.erp_px_cat_g1v2;