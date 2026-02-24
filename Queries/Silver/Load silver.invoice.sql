-- ==============================================================================
-- Clean and Load data in silver.invoice layer
-- ==============================================================================

PRINT('Truncating Table silver.invoice');
TRUNCATE TABLE silver.invoice;

PRINT('Inserting data into silver.invoice');

WITH CTE AS
(
	SELECT
		invoice_id,
		cust_id,
		CAST(invoice_date AS DATE) AS invoice_date,
		ISNULL(TRIM(billing_address), 'n/a') AS billing_address,
		ISNULL(TRIM(billing_city), 'n/a') AS billing_city,
		ISNULL(TRIM(billing_state), 'n/a') AS billing_state,
		ISNULL(TRIM(billing_country), 'n/a') AS billing_country,
		ISNULL(TRIM(billing_postalcode), 'n/a') AS billing_postalcode,
		total,
		ROW_NUMBER() OVER(PARTITION BY invoice_id ORDER BY cust_id) AS rn
	FROM bronze.invoice
	WHERE invoice_id IS NOT NULL
)
INSERT INTO silver.invoice
(
	invoice_id,
	cust_id,
	invoice_date,
	billing_address,
	billing_city,
	billing_state,
	billing_country,
	billing_postalcode,
	total
)
SELECT
	invoice_id,
	cust_id,
	invoice_date,
	billing_address,
	billing_city,
	billing_state,
	billing_country,
	billing_postalcode,
	total
FROM CTE
WHERE rn = 1