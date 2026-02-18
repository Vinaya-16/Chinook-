-- Create SQL DDL scripts for all csv files in the crm and erp systems.

IF OBJECT_ID('bronze.album_info', 'U') IS NOT NULL
	DROP TABLE bronze.album_info;

CREATE TABLE bronze.album_info
(
	album_id			INT,
	album_title			NVARCHAR(100),
	artist_id			INT
)

IF OBJECT_ID('bronze.artist_info', 'U') IS NOT NULL
	DROP TABLE bronze.artist_info;

CREATE TABLE bronze.artist_info
(
	artist_id			INT,
	artist_name			NVARCHAR(100)
)

IF OBJECT_ID('bronze.cust_info', 'U') IS NOT NULL
	DROP TABLE bronze.cust_info;

CREATE TABLE bronze.cust_info
(
	cust_id				INT,
	cust_firstname		NVARCHAR(100),
	cust_lastname		NVARCHAR(100),
	cust_company		NVARCHAR(100),
	cust_address		NVARCHAR(100),
	cust_city			NVARCHAR(100),
	cust_state			NVARCHAR(100),
	cust_country		NVARCHAR(100),
	cust_postalcode		NVARCHAR(100),
	cust_phone			NVARCHAR(100),
	cust_fax			NVARCHAR(100),
	cust_email			NVARCHAR(100),
	support_rep_id		INT
)

IF OBJECT_ID('bronze.emp_info', 'U') IS NOT NULL
	DROP TABLE bronze.emp_info;

CREATE TABLE bronze.emp_info
(
	emp_id				INT,
	emp_lastname		NVARCHAR(50),
	emp_firstname		NVARCHAR(50),
	emp_title			NVARCHAR(50),
	emp_reportsTo		INT,
	emp_birthdate		DATETIME,
	emp_hiredate		DATETIME,
	emp_address			NVARCHAR(50),
	emp_city			NVARCHAR(50),
	emp_state			NVARCHAR(50),
	emp_country			NVARCHAR(50),
	emp_postalCode		NVARCHAR(50),
	emp_phone			NVARCHAR(50),
	emp_fax				NVARCHAR(50),
	emp_email			NVARCHAR(50)
)

IF OBJECT_ID('bronze.general', 'U') IS NOT NULL
	DROP TABLE bronze.general;

CREATE TABLE bronze.general
(
	general_id		INT,
	general_name	NVARCHAR(50)
)

IF OBJECT_ID('bronze.invoice', 'U') IS NOT NULL
	DROP TABLE bronze.invoice;

CREATE TABLE bronze.invoice 
(
	invoice_id			INT,
	cust_id				INT,
	invoice_date		DATETIME,
	billing_address		NVARCHAR(50),
	billing_city		NVARCHAR(50),
	billing_state		NVARCHAR(50),
	billing_country		NVARCHAR(50),
	billing_postalCode	NVARCHAR(50),
	total				DECIMAL(5,2)
)

IF OBJECT_ID('bronze.invoice_line', 'U') IS NOT NULL
	DROP TABLE bronze.invoice_line;

CREATE TABLE bronze.invoice_line
(
	invoice_line_id		INT,
	invoice_id			INT,
	track_id			INT,
	unit_price			DECIMAL,
	quantity			INT
)

IF OBJECT_ID('bronze.media_type', 'U') IS NOT NULL
	DROP TABLE bronze.media_type;

CREATE TABLE bronze.media_type 
(
	mediatype_id	INT,	
	media_name		NVARCHAR(50)
)

IF OBJECT_ID('bronze.playlist', 'U') IS NOT NULL
	DROP TABLE bronze.playlist;

CREATE TABLE bronze.playlist
(
	playlist_id		INT,	
	playlist_name	NVARCHAR(50)
)

IF OBJECT_ID('bronze.playlistTrack', 'U') IS NOT NULL
	DROP TABLE bronze.playlistTrack;

CREATE TABLE bronze.playlistTrack
(
	playlist_id		INT,
	track_id		INT
)

IF OBJECT_ID('bronze.track', 'U') IS NOT NULL
	DROP TABLE bronze.track;

CREATE TABLE bronze.track
(
	track_id		INT,
	track_name		NVARCHAR(500),
	album_id		INT,
	mediatype_id	INT,
	general_id		INT,
	composer		NVARCHAR(500),
	milli_sec		INT,
	bytes			INT,
	unit_price		DECIMAL
)


