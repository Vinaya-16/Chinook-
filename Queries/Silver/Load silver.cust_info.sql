-- ================================================================
--		 CLEAN AND LOAD DATA INTO SILVER LAYER
-- ================================================================

PRINT('TRUNCATING TABLE silver.cust_info');
TRUNCATE TABLE silver.cust_info;

PRINT('INSERTING DATA INTO silver.cust_info');

WITH CTE AS
(
	SELECT
		cust_id,
		ISNULL(TRIM(cust_firstname), 'Unknown') AS cust_firstname,
		ISNULL(TRIM(cust_lastname), 'Unknown') AS cust_lastname,
		ISNULL(TRIM(cust_company), 'n/a') AS cust_company,
		ISNULL(TRIM(cust_address), 'n/a') AS cust_address,
		ISNULL(TRIM(cust_city), 'n/a') AS cust_city,
		ISNULL(TRIM(cust_state), 'n/a') AS cust_state,
		ISNULL(TRIM(cust_country), 'n/a') AS cust_country,
		ISNULL(TRIM(cust_postalcode), 'n/a') AS cust_postalcode,
		ISNULL(TRIM(cust_phone), 'n/a') AS cust_phone,
		ISNULL(TRIM(cust_fax), 'n/a') AS cust_fax,
		TRIM(cust_email) AS cust_email,
		support_rep_id,
		ROW_NUMBER() OVER(PARTITION BY cust_id ORDER BY cust_id) AS rn
	FROM bronze.cust_info
	WHERE cust_id IS NOT NULL
)
INSERT INTO silver.cust_info
(
	cust_id,
	cust_firstname,
	cust_lastname,
	cust_company,
	cust_address,
	cust_city,
	cust_state,
	cust_country,
	cust_postalcode,
	cust_phone,
	cust_fax,
	cust_email,
	support_rep_id
)
SELECT
	cust_id,
	cust_firstname,
	cust_lastname,
	cust_company,
	cust_address,
	cust_city,
	cust_state,
	cust_country,
	cust_postalcode,
	cust_phone,
	cust_fax,
	cust_email,
	support_rep_id
FROM CTE
WHERE rn = 1;