-- ================================================================
--		 CLEAN AND LOAD DATA INTO SILVER LAYER
-- ================================================================

PRINT('Truncating Table silver.general');
TRUNCATE TABLE silver.general;

PRINT('Inserting data into silver.general');

WITH CTE AS 
(
	SELECT
		general_id,
		ISNULL(TRIM(general_name), 'Unknown') AS general_name,
		ROW_NUMBER() OVER(PARTITION BY general_id ORDER BY general_name DESC) AS rn
		FROM bronze.general
		WHERE general_id IS NOT NULL
)
INSERT INTO silver.general
(
	general_id,
	general_name
)
SELECT
	general_id,
	general_name
FROM CTE
WHERE rn = 1