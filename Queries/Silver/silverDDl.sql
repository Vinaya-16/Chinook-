-- CREATE DDL SCRIPTS TO LOAD DATA IN SILVER LAYER

IF OBJECT_ID('silver.album_info', 'U') IS NOT NULL
	DROP TABLE silver.album_info;

CREATE TABLE silver.album_info
(
	album_id		INT,
	album_title		NVARCHAR(100),
	artist_id		INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID ('silver.artist_info', 'U') IS NOT NULL
	DROP TABLE silver.artist_info;

CREATE TABLE silver.artist_info
(
	artist_id		INT,
	artist_name		NVARCHAR(100),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('silver.cust_info', 'U') IS NOT NULL
	DROP TABLE silver.cust_info;

CREATE TABLE silver.cust_info
(
	cust_id				INT,
	cust_firstname		NVARCHAR(50),
	cust_lastname		NVARCHAR(50),
	cust_company		NVARCHAR(100),
	cust_address		NVARCHAR(100),
	cust_city			NVARCHAR(100),
	cust_state			NVARCHAR(100),
	cust_country		NVARCHAR(100),
	cust_postalcode		NVARCHAR(100),
	cust_phone			NVARCHAR(100),
	cust_fax			NVARCHAR(100),
	cust_email			NVARCHAR(100),
	support_rep_id		INT,
	dwh_create_date		DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('silver.emp_info', 'U') IS NOT NULL
	DROP TABLE silver.emp_info;

CREATE TABLE silver.emp_info
(
	emp_id				INT,
	emp_lastname		NVARCHAR(50),
	emp_firstname		NVARCHAR(50),
	emp_title			NVARCHAR(100),
	emp_reports_to		INT,
	emp_birthdate		DATE,
	emp_hiredate		DATETIME,
	emp_address			NVARCHAR(100),
	emp_city			NVARCHAR(50),
	emp_state			NVARCHAR(100),
	emp_country			NVARCHAR(100),
	emp_postalcode		NVARCHAR(100),
	emp_phone			NVARCHAR(100),
	emp_fax				NVARCHAR(100),
	emp_email			NVARCHAR(100),
	dwh_create_date		DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('silver.general', 'U') IS NOT NULL
	DROP TABLE silver.general;

CREATE TABLE silver.general
(
	general_id		INT,
	general_name	NVARCHAR(50),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('silver.invoice', 'U') IS NOT NULL
	DROP TABLE silver.invoice;

CREATE TABLE silver.invoice
(
	invoice_id				INT,
	cust_id					INT,
	invoice_date			DATE,
	billing_address			NVARCHAR(100),
	billing_city			NVARCHAR(50),
	billing_state			NVARCHAR(50),
	billing_country			NVARCHAR(50),
	billing_postalcode		NVARCHAR(50),
	total					DECIMAL(5,2),
	dwh_create_date			DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('silver.invoice_line', 'U') IS NOT NULL
	DROP TABLE silver.invoice_line;

CREATE TABLE silver.invoice_line
(
	invoice_line_id	INT,
	invoice_id		INT,
	track_id		INT,
	unit_price		DECIMAL,
	quantity		INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('silver.media_type', 'U') IS NOT NULL
	DROP TABLE silver.media_type;

CREATE TABLE silver.media_type
(
	mediatype_id	INT,
	media_name		NVARCHAR(50),
	dwh_create_date	DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('silver.playlist', 'U') IS NOT NULL
	DROP TABLE silver.playlist;

CREATE TABLE silver.playlist
(
	playlist_id		INT,
	playlist_name	NVARCHAR(50),
	dwh_create_date	DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('silver.playlistTrack', 'U') IS NOT NULL
	DROP TABLE silver.playlistTrack;

CREATE TABLE silver.playlistTrack
(
	playlist_id		INT,
	track_id		INT,
	dwh_create_date	DATETIME2 DEFAULT GETDATE()
);

IF OBJECT_ID('silver.track', 'U') IS NOT NULL
	DROP TABLE silver.track;

CREATE TABLE silver.track
(
	track_id		INT, 
	track_name		NVARCHAR(500),
	album_id		INT,
	mediatype_id	INT,
	general_id		INT,
	composer		NVARCHAR(500),
	milli_sec		INT,
	bytes			INT,
	unit_price		DECIMAL,
	dwh_create_date	DATETIME2 DEFAULT GETDATE()
);