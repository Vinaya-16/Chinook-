--====================================================================
--	CLLEAN AND LOAD THE DATA INTO silver.media_type
--====================================================================

PRINT('Truncating table silver.media_type');
TRUNCATE TABLE silver.media_type;

PRINT('Inserting data into silver.media_type');

WITH CTE AS
(
	SELECT
		mediatype_id,
		ISNULL(TRIM(media_name), 'n/a') AS media_name,
		ROW_NUMBER() OVER(PARTITION BY mediatype_id ORDER BY media_name) AS rn
	FROM bronze.media_type
	WHERE mediatype_id IS NOT NULL
)
INSERT INTO silver.media_type
(
	mediatype_id,
	media_name
)
SELECT
	mediatype_id,
	media_name
FROM CTE
WHERE rn = 1