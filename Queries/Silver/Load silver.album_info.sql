-- ================================================================
--		 CLEAN AND LOAD DATA INTO SILVER LAYER
-- ================================================================

-- Truncating table 
PRINT('TRUNCATING TABLE silver.album_info');
TRUNCATE TABLE silver.album_info;

-- Inserting clean data 
PRINT('INSERTING DATA INTO silver.album_info');


WITH CTE AS 
(
	SELECT 
		album_id,
		TRIM(ISNULL(album_title, 'Unknown')) AS album_title,
		artist_id,
		ROW_NUMBER() OVER(PARTITION BY album_id ORDER BY album_title DESC) AS rn
	FROM bronze.album_info
	WHERE album_id IS NOT NULL AND artist_id IS NOT NULL
)
INSERT INTO silver.album_info
(
	album_id,
	album_title,
	artist_id
)
SELECT
	album_id,
	album_title,
	artist_id
FROM CTE
WHERE rn = 1