--=======================================================================
--	CLEAN AND LOAD DATA INTO silver.track
--=========================================================================

PRINT('Truncating table silver.track');
TRUNCATE TABLE silver.track;

PRINT('Inserting data into silver.track');

WITH CTE AS
(
	SELECT
		track_id,
		ISNULL(TRIM(track_name), 'n/a') AS track_name,
		album_id,
		mediatype_id,
		general_id,
		ISNULL(TRIM(composer), 'n/a') AS composer,
		milli_sec,
		bytes,
		CAST(unit_price AS DECIMAL(5,2)) AS unit_price,
		ROW_NUMBER() OVER(PARTITION BY track_id ORDER BY track_name) AS rn
	FROM bronze.track
	WHERE track_id IS NOT NULL
		AND album_id IS NOT NULL
		AND mediatype_id IS NOT NULL
)
INSERT INTO silver.track
(
	track_id,
	track_name,
	album_id,
	mediatype_id,
	general_id,
	composer,
	milli_sec,
	bytes,
	unit_price
)
SELECT
	track_id,
	track_name,
	album_id,
	mediatype_id,
	general_id,
	composer,
	milli_sec,
	bytes,
	unit_price
FROM CTE 
WHERE rn = 1
	AND milli_sec > 0
	AND bytes > 0
	AND unit_price >= 0