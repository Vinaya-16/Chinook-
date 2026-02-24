
-- CREATE A PROCEDURE TO LOAD CLEAN DATA INTO SILVER DATABASE IN RESPECTIVE TABLES

CREATE OR ALTER PROCEDURE silver.load_silver AS
DECLARE @start_time DATE, @end_time DATE, @batch_start_time DATE, @batch_end_time DATE;
BEGIN 
	BEGIN TRY 
		SET @batch_start_time = GETDATE();

		SET @start_time = GETDATE();

			-- ================================================================
			--		 CLEAN AND LOAD DATA INTO SILVER.album_info LAYER
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
			WHERE rn = 1;

		SET @end_time = GETDATE();

		PRINT '--------------------------------------------';
		PRINT 'Loading Duration : ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '--------------------------------------------';


		SET @start_time = GETDATE();

			-- ================================================================
			--		 CLEAN AND LOAD DATA INTO SILVER.artist_info LAYER
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

		SET @end_time = GETDATE();

		PRINT '--------------------------------------------';
		PRINT 'Loading Duration : ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '--------------------------------------------';


		SET @start_time = GETDATE();
			-- ================================================================
			--		 CLEAN AND LOAD DATA INTO SILVER.cust_info LAYER
			-- ================================================================

			PRINT('TRUNCATING TABLE silver.cust_info');
			TRUNCATE TABLE silver.cust_info;

			PRINT('INSERTING DATA INTO silver.cust_info');

			WITH CTE AS
			(
				SELECT
					cust_id,
					ISNULL(TRIM(cust_firstname), 'Unknown') AS cust_firstname,
					ISNULL(TRIM(cust_lastname), 'Unknown') AS cust_lastname,
					ISNULL(TRIM(cust_company), 'n/a') AS cust_company,
					ISNULL(TRIM(cust_address), 'n/a') AS cust_address,
					ISNULL(TRIM(cust_city), 'n/a') AS cust_city,
					ISNULL(TRIM(cust_state), 'n/a') AS cust_state,
					ISNULL(TRIM(cust_country), 'n/a') AS cust_country,
					ISNULL(TRIM(cust_postalcode), 'n/a') AS cust_postalcode,
					ISNULL(TRIM(cust_phone), 'n/a') AS cust_phone,
					ISNULL(TRIM(cust_fax), 'n/a') AS cust_fax,
					TRIM(cust_email) AS cust_email,
					support_rep_id,
					ROW_NUMBER() OVER(PARTITION BY cust_id ORDER BY cust_id) AS rn
				FROM bronze.cust_info
				WHERE cust_id IS NOT NULL
			)
			INSERT INTO silver.cust_info
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
			FROM CTE
			WHERE rn = 1;

		SET @end_time = GETDATE();

		PRINT '--------------------------------------------';
		PRINT 'Loading Duration : ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '--------------------------------------------';


		SET @start_time = GETDATE();

			-- ================================================================
			--		 CLEAN AND LOAD DATA INTO SILVER.emp_info LAYER
			-- ================================================================

			PRINT('TRUNCATING TABLE silver.emp_info');
			TRUNCATE TABLE silver.emp_info;

			PRINT('INSERTING DATA INTO silver.emp_info');

			WITH CTE AS
			(
				SELECT
					emp_id,
					ISNULL(TRIM(emp_lastname), 'Unknown') AS emp_lastname,
					ISNULL(TRIM(emp_firstname), 'Unknown') AS emp_firstname,
					ISNULL(TRIM(emp_title), 'Unknown') AS emp_title,
					emp_reportsTo,
					CAST(emp_birthdate AS DATE) AS emp_birthdate,
					CAST(emp_hiredate AS DATE) AS emp_hiredate,
					ISNULL(TRIM(emp_address), 'n/a') AS emp_address,
					ISNULL(TRIM(emp_city), 'n/a') AS emp_city,
					ISNULL(TRIM(emp_state), 'n/a') AS emp_state,
					ISNULL(TRIM(emp_country), 'n/a') AS emp_country,
					ISNULL(TRIM(emp_postalCode), 'n/a') AS emp_postalcode,
					ISNULL(TRIM(emp_phone), 'n/a') AS emp_phone,
					ISNULL(TRIM(emp_fax), 'n/a') AS emp_fax,
					TRIM(emp_email) AS emp_email,
					ROW_NUMBER() OVER(PARTITION BY emp_id ORDER BY emp_id) AS rn
				FROM bronze.emp_info
				WHERE emp_id IS NOT NULL
			)
			INSERT INTO silver.emp_info
			(
				emp_id,
				emp_lastname,
				emp_firstname,
				emp_title,
				emp_reports_to,
				emp_birthdate,
				emp_hiredate,
				emp_address,
				emp_city,
				emp_state,
				emp_country,
				emp_postalcode,
				emp_phone,
				emp_fax,
				emp_email
			)
			SELECT
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
				emp_postalcode,
				emp_phone,
				emp_fax,
				emp_email
			FROM CTE
			WHERE rn = 1;

		SET @end_time = GETDATE();

		PRINT '--------------------------------------------';
		PRINT 'Loading Duration : ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '--------------------------------------------';


		SET @start_time = GETDATE();

			-- ================================================================
			--		 CLEAN AND LOAD DATA INTO SILVER.general LAYER
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
			WHERE rn = 1;

		SET @end_time = GETDATE();

		PRINT '--------------------------------------------';
		PRINT 'Loading Duration : ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '--------------------------------------------';


		SET @start_time = GETDATE();

			-- ==============================================================================
			-- Clean and Load data in silver.invoice layer
			-- ==============================================================================

			PRINT('Truncating Table silver.invoice');
			TRUNCATE TABLE silver.invoice;

			PRINT('Inserting data into silver.invoice');

			WITH CTE AS
			(
				SELECT
					invoice_id,
					cust_id,
					CAST(invoice_date AS DATE) AS invoice_date,
					ISNULL(TRIM(billing_address), 'n/a') AS billing_address,
					ISNULL(TRIM(billing_city), 'n/a') AS billing_city,
					ISNULL(TRIM(billing_state), 'n/a') AS billing_state,
					ISNULL(TRIM(billing_country), 'n/a') AS billing_country,
					ISNULL(TRIM(billing_postalcode), 'n/a') AS billing_postalcode,
					total,
					ROW_NUMBER() OVER(PARTITION BY invoice_id ORDER BY cust_id) AS rn
				FROM bronze.invoice
				WHERE invoice_id IS NOT NULL
			)
			INSERT INTO silver.invoice
			(
				invoice_id,
				cust_id,
				invoice_date,
				billing_address,
				billing_city,
				billing_state,
				billing_country,
				billing_postalcode,
				total
			)
			SELECT
				invoice_id,
				cust_id,
				invoice_date,
				billing_address,
				billing_city,
				billing_state,
				billing_country,
				billing_postalcode,
				total
			FROM CTE
			WHERE rn = 1;

		SET @end_time = GETDATE();

		PRINT '--------------------------------------------';
		PRINT 'Loading Duration : ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '--------------------------------------------';

		SET @start_time = GETDATE();

			--=========================================================
			--	CLEAN AND LOAD THE DATA INTO silver.invoice_line
			--==========================================================

			PRINT('Truncating data from table silver.invoice_line');
			TRUNCATE TABLE silver.invoice_line;

			PRINT('INSERTING DATA INTO silver.invoice_line');

			WITH CTE AS
			(
				SELECT
					invoice_line_id,
					invoice_id,
					track_id,
					CAST(unit_price AS DECIMAL(5,2)) AS unit_price,
					CAST(quantity AS INT) AS quantity,
					ROW_NUMBER() OVER(PARTITION BY invoice_line_id ORDER BY invoice_id) AS rn 
				FROM bronze.invoice_line
				WHERE invoice_line_id IS NOT NULL
			)
			INSERT INTO silver.invoice_line
			(
				invoice_line_id,
				invoice_id,
				track_id,
				unit_price,
				quantity
			)
			SELECT
				invoice_line_id,
				invoice_id,
				track_id,
				unit_price,
				quantity
			FROM CTE
			WHERE rn = 1
				  AND quantity > 0
				  AND unit_price >= 0;

		SET @end_time = GETDATE();

		PRINT '--------------------------------------------';
		PRINT 'Loading Duration : ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '--------------------------------------------';

		SET @start_time = GETDATE();

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
			WHERE rn = 1;

		SET @end_time = GETDATE();

		PRINT '--------------------------------------------';
		PRINT 'Loading Duration : ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '--------------------------------------------';

		SET @start_time = GETDATE();

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
			WHERE rn = 1;

		SET @end_time = GETDATE();

		PRINT '--------------------------------------------';
		PRINT 'Loading Duration : ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '--------------------------------------------';

		SET @start_time = GETDATE();

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
			WHERE rn = 1;

		SET @end_time = GETDATE();

		PRINT '--------------------------------------------';
		PRINT 'Loading Duration : ' + CAST (DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds';
		PRINT '--------------------------------------------';

		SET @start_time = GETDATE();

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
				AND unit_price >= 0;

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

	PRINT 'Entire Sillver Layer is loaded in ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds';
END;

EXEC silver.load_silver;