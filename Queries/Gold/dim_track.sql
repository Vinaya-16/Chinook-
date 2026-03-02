
CREATE OR ALTER VIEW gold.dim_track AS
	SELECT
		t.track_id,
		t.track_name,
		al.album_title,
		ar.artist_name,
		g.general_name AS genre_name,
		m.media_name AS media_type_name,
		t.composer,
		t.milli_sec AS milliseconds
	FROM silver.track t
	JOIN silver.album_info al
	ON t.album_id = al.album_id
	JOIN silver.artist_info ar
	ON al.artist_id = ar.artist_id
	JOIN silver.general g
	ON t.general_id = g.general_id
	JOIN silver.media_type m
	ON t.mediatype_id = m.mediatype_id