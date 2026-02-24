--===================================================================
--	CLAEN AND LOAD silver.playlist
--===================================================================

PRINT('Truncating table silver.playlist');
TRUNCATE TABLE silver.playlist;

PRINT('Inserting data into silver.playlist');

WITH CTE AS
(
	SELECT
		playlist_id,
		ISNULL(TRIM(playlist_name), 'n/a')  AS playlist_name,
		ROW_NUMBER() OVER(PARTITION BY playlist_id ORDER BY playlist_name) AS rn
	FROM bronze.playlist
	WHERE playlist_id IS NOT NULL
)
INSERT INTO silver.playlist
(
	playlist_id,
	playlist_name
)
SELECT
	playlist_id,
	playlist_name
FROM CTE	
WHERE rn = 1