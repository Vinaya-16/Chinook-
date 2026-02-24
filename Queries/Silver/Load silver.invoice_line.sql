--=========================================================
--	CLEAN AND LOAD THE DATA INTO silver.invoice_line
--==========================================================

PRINT('Truncating data from table silver.invoice_line');
TRUNCATE TABLE silver.invoice_line;

PRINT('INSERTING DATA INTO silver.invoice_line');

WITH CTE AS
(
	SELECT
		invoice_line_id,
		invoice_id,
		track_id,
		CAST(unit_price AS DECIMAL(5,2)) AS unit_price,
		CAST(quantity AS INT) AS quantity,
		ROW_NUMBER() OVER(PARTITION BY invoice_line_id ORDER BY invoice_id) AS rn 
	FROM bronze.invoice_line
	WHERE invoice_line_id IS NOT NULL
)
INSERT INTO silver.invoice_line
(
	invoice_line_id,
	invoice_id,
	track_id,
	unit_price,
	quantity
)
SELECT
	invoice_line_id,
	invoice_id,
	track_id,
	unit_price,
	quantity
FROM CTE
WHERE rn = 1
	  AND quantity > 0
	  AND unit_price >= 0