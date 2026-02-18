-- Develop SQL load scripts
-- Write SQL insert to load all data into your bronze tables

CREATE OR ALTER PROCEDURE bronze.load_bronze AS
DECLARE @start_time DATE, @end_time DATE, @batch_start_time DATE, @batch_end_time DATE;
BEGIN
	BEGIN TRY 
		SET @batch_start_time = GETDATE();

		PRINT('=====================================================================================');
		PRINT('Loading Bronze Layer');
		PRINT('=====================================================================================');

		SET @start_time = GETDATE();

			PRINT('Truncating Table bronze.album_info');
			TRUNCATE TABLE bronze.album_info;

			PRINT('Loading data into bronze.album_info');
			INSERT INTO bronze.album_info 
				(album_id, album_title, artist_id)
			SELECT 
				AlbumId,
				Title,
				ArtistId
			FROM dbo.Album;

		SET @end_time = GETDATE();

		PRINT '--------------------------------------------';
		PRINT 'Loading Duration : ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '--------------------------------------------';

		SET @start_time = GETDATE();

			TRUNCATE TABLE bronze.artist_info;

			INSERT INTO bronze.artist_info 
			(
				artist_id,
				artist_name
			)
			SELECT 
				ArtistId,
				Name
			FROM dbo.Artist;

		SET @end_time = GETDATE();

		PRINT '--------------------------------------------';
		PRINT 'Loading Duration : ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '--------------------------------------------';

		SET @start_time = GETDATE();

			PRINT('Truncating Table bronze.cust-info');
			TRUNCATE TABLE bronze.cust_info;

			PRINT('Loading data into bronze.cust_info');
			INSERT INTO bronze.cust_info
			(
				cust_id,
				cust_firstname,
				cust_lastname,
				cust_company,
				cust_address,
				cust_city,
				cust_state,
				cust_country,
				cust_postalcode,
				cust_phone,
				cust_fax,
				cust_email,
				support_rep_id
			)
			SELECT
				CustomerId,
				FirstName,
				LastName,
				Company,
				Address,
				City,
				State,
				Country,
				PostalCode,
				fax,
				Phone,
				Email,
				SupportRepId
			FROM dbo.Customer;

		SET @end_time = GETDATE();

		PRINT '--------------------------------------------';
		PRINT 'Loading Duration : ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '--------------------------------------------';

		SET @start_time = GETDATE();

			PRINT('Truncating Table bronze.emp_info');
			TRUNCATE TABLE bronze.emp_info;

			PRINT('Loading data into bronze.emp_info');
			INSERT INTO bronze.emp_info
			(
				emp_id,
				emp_lastname,
				emp_firstname,
				emp_title,
				emp_reportsTo,
				emp_birthdate,
				emp_hiredate,
				emp_address,
				emp_city,
				emp_state,
				emp_country,
				emp_postalCode,
				emp_phone,
				emp_fax,
				emp_email
			)
			SELECT
				EmployeeId,
				LastName,
				FirstName,
				Title,
				ReportsTo,
				BirthDate,
				HireDate,
				Address,
				City,
				State,
				Country,
				PostalCode,
				Phone,
				Fax,
				Email
			FROM dbo.Employee;

		SET @end_time = GETDATE();

		PRINT '--------------------------------------------';
		PRINT 'Loading Duration : ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '--------------------------------------------';

		SET @start_time = GETDATE();

			PRINT('Truncating Table bronze.general');
			TRUNCATE TABLE bronze.general;

			PRINT('Loading data into bronze.general');
			INSERT INTO bronze.general
			(
				general_id,
				general_name
			)
			SELECT
				GenreId,
				Name
			FROM dbo.Genre;

		SET @end_time = GETDATE();

		PRINT '--------------------------------------------';
		PRINT 'Loading Duration : ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '--------------------------------------------';

		SET @start_time = GETDATE();

			PRINT('Truncating Table bronze.invoice');
			TRUNCATE TABLE bronze.invoice;

			PRINT('Loading data into bronze.invoice');
			INSERT INTO bronze.invoice
			(
				invoice_id,
				cust_id,
				invoice_date,
				billing_address,
				billing_city,
				billing_state,
				billing_country,
				billing_postalCode,
				total				
			)
			SELECT
					InvoiceId,
					CustomerId,
					InvoiceDate,
					BillingAddress,
					BillingCity,
					BillingState,
					BillingCountry,
					BillingPostalCode,
					Total
			FROM dbo.Invoice;

		SET @end_time = GETDATE();

		PRINT '--------------------------------------------';
		PRINT 'Loading Duration : ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '--------------------------------------------';

		SET @start_time = GETDATE();

			PRINT('Truncating Table bronze.invoice_line');
			TRUNCATE TABLE bronze.invoice_line;

			PRINT('Loading data into bronze.invoice_line');
			INSERT INTO bronze.invoice_line
			(
				invoice_line_id,
				invoice_id,
				track_id,
				unit_price,
				quantity
			)
			SELECT
				InvoiceLineId,
				InvoiceId,
				TrackId,
				UnitPrice,
				Quantity
			FROM dbo.InvoiceLine;

		SET @end_time = GETDATE();

		PRINT '--------------------------------------------';
		PRINT 'Loading Duration : ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '--------------------------------------------';

		SET @start_time = GETDATE();
			
			PRINT('Truncating Table bronze.media_type');
			TRUNCATE TABLE bronze.media_type;

			PRINT('Loading data into bronze.media_type');
			INSERT INTO bronze.media_type
			(
				mediatype_id,
				media_name
			)
			SELECT
				MediaTypeId,
				Name
			FROM dbo.MediaType;

		SET @end_time = GETDATE();

		PRINT '--------------------------------------------';
		PRINT 'Loading Duration : ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '--------------------------------------------';

		SET @start_time = GETDATE();

			PRINT('Trunacting Table bronze.playlist');
			TRUNCATE TABLE bronze.playlist;

			PRINT('Loading data into bronze.playlist');
			INSERT INTO bronze.playlist
			(
				playlist_id,
				playlist_name
			)
			SELECT
				PlaylistId,
				Name
			FROM dbo.Playlist;

		SET @end_time = GETDATE();

		PRINT '--------------------------------------------';
		PRINT 'Loading Duration : ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '--------------------------------------------';

		SET @start_time = GETDATE();

			PRINT('Truncating Table bronze.playlistTrack');
			TRUNCATE TABLE bronze.playlistTrack;

			PRINT('Loading data into playlistTrack');
			INSERT INTO bronze.playlistTrack
			(
				playlist_id,
				track_id
			)
			SELECT
				PlaylistId,
				TrackId
			FROM dbo.PlaylistTrack;

		SET @end_time = GETDATE();

		PRINT '--------------------------------------------';
		PRINT 'Loading Duration : ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '--------------------------------------------';

		SET @start_time = GETDATE();

			PRINT('Truncating Table bronze.Track');
			TRUNCATE TABLE bronze.track;

			PRINT('Loading data into bronze.Track');
			INSERT INTO bronze.Track
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
				TrackId,
				Name,
				AlbumId,
				MediaTypeId,
				GenreId,
				Composer,
				Milliseconds,
				Bytes,
				UnitPrice
			FROM dbo.Track;

		SET @end_time = GETDATE();

		PRINT '--------------------------------------------';
		PRINT 'Loading Duration : ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '--------------------------------------------';

	END TRY
	
	BEGIN CATCH
		PRINT '=============================================';
		PRINT 'Error Occured While Loading Bronze Layer';
		PRINT 'Error Message: ' + ERROR_MESSAGE();
		PRINT '=============================================';
	END CATCH

	SET @batch_end_time = GETDATE();

	PRINT 'Entire Bronze Layer is loaded in ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds';
END;

GO

EXEC bronze.load_bronze;