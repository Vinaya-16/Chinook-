-- ================================================================
--		 CLEAN AND LOAD DATA INTO SILVER LAYER
-- ================================================================

PRINT('TRUNCATING TABLE silver.emp_info');
TRUNCATE TABLE silver.emp_info;

PRINT('INSERTING DATA INTO silver.emp_info');

WITH CTE AS
(
	SELECT
		emp_id,
		ISNULL(TRIM(emp_lastname), 'Unknown') AS emp_lastname,
		ISNULL(TRIM(emp_firstname), 'Unknown') AS emp_firstname,
		ISNULL(TRIM(emp_title), 'Unknown') AS emp_title,
		emp_reportsTo,
		CAST(emp_birthdate AS DATE) AS emp_birthdate,
		CAST(emp_hiredate AS DATE) AS emp_hiredate,
		ISNULL(TRIM(emp_address), 'n/a') AS emp_address,
		ISNULL(TRIM(emp_city), 'n/a') AS emp_city,
		ISNULL(TRIM(emp_state), 'n/a') AS emp_state,
		ISNULL(TRIM(emp_country), 'n/a') AS emp_country,
		ISNULL(TRIM(emp_postalCode), 'n/a') AS emp_postalcode,
		ISNULL(TRIM(emp_phone), 'n/a') AS emp_phone,
		ISNULL(TRIM(emp_fax), 'n/a') AS emp_fax,
		TRIM(emp_email) AS emp_email,
		ROW_NUMBER() OVER(PARTITION BY emp_id ORDER BY emp_id) AS rn
	FROM bronze.emp_info
	WHERE emp_id IS NOT NULL
)
INSERT INTO silver.emp_info
(
	emp_id,
	emp_lastname,
	emp_firstname,
	emp_title,
	emp_reports_to,
	emp_birthdate,
	emp_hiredate,
	emp_address,
	emp_city,
	emp_state,
	emp_country,
	emp_postalcode,
	emp_phone,
	emp_fax,
	emp_email
)
SELECT
	emp_id,
	emp_lastname,
	emp_firstname,
	emp_title,
	emp_reportsTo,
	emp_birthdate,
	emp_hiredate,
	emp_address,
	emp_city,
	emp_state,
	emp_country,
	emp_postalcode,
	emp_phone,
	emp_fax,
	emp_email
FROM CTE
WHERE rn = 1