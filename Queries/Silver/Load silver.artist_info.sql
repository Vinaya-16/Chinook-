-- ================================================================
--		 CLEAN AND LOAD DATA INTO SILVER LAYER
-- ================================================================

PRINT('TRUNCATING TABLE silver.artist_info');
TRUNCATE TABLE silver.artist_info;

PRINT('INSERTING DATA INTO silver.artist_info');

WITH CTE AS
(
	SELECT
		artist_id,
		TRIM(ISNULL(artist_name, 'Unknown')) AS artist_name,
		ROW_NUMBER() OVER(
			PARTITION BY artist_id
			ORDER BY artist_name
		) AS rn
	FROM bronze.artist_info
	WHERE artist_id IS NOT NULL
)
INSERT INTO silver.artist_info
(
	artist_id,
	artist_name
)
SELECT
	artist_id,
	artist_name
FROM CTE
WHERE rn = 1;
