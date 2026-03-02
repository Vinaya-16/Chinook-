
CREATE OR ALTER VIEW gold.dim_playlist AS
	SELECT
		playlist_id,
		playlist_name
	FROM silver.playlist

GO

CREATE OR ALTER VIEW gold.bridge_playlist_track AS
	SELECT
		playlist_id,
		track_id
	FROM silver.playlistTrack