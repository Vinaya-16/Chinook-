--=======================================================================
--	CLEAN AND LOAD DATA INTO silver.playlistTrack
--=========================================================================

PRINT('Truncating table silver.playlistTrack');
TRUNCATE TABLE silver.playlistTrack;

PRINT('Inserting data into silver.playlistTrack');

WITH CTE AS 
(
	SELECT
		playlist_id,
		track_id,
		ROW_NUMBER() OVER(PARTITION BY playlist_id, track_id ORDER BY playlist_id) AS rn
	FROM bronze.playlistTrack
	WHERE playlist_id IS NOT NULL
		  AND track_id IS NOT NULL
)
INSERT INTO silver.playlistTrack
(
	playlist_id,
	track_id
)
SELECT
	playlist_id,
	track_id
FROM CTE 
WHERE rn = 1