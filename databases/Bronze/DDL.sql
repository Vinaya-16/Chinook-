-- Create SQL DDL scripts for all csv files in the crm and erp systems.

IF OBJECT_ID('bronze.album_info', 'U') IS NOT NULL
	DROP TABLE bronze.album_info;

CREATE TABLE bronze.album_info
(
	album_id			INT,
	album_title			NVARCHAR(50),
	artist_id			INT
)

IF OBJECT_ID('bronze.artist_info', 'U') IS NOT NULL
	DROP TABLE bronze.artist_info;

CREATE TABLE bronze.artist_info
(
	artist_id			INT,
	artist_name			NVARCHAR(50)
)

IF OBJECT_ID('bronze.cust_info', 'U') IS NOT NULL
	DROP TABLE bronze.cust_info;

CREATE TABLE bronze.cust_info
(
	cust_id				INT,
	cust_firstname		NVARCHAR(50),
	cust_lastname		NVARCHAR(50),
	cust_company		NVARCHAR(50),
	cust_address		NVARCHAR(50),
	cust_city			NVARCHAR(50),
	cust_state			NVARCHAR(50),
	cust_country		NVARCHAR(50),
	cust_postalcode		NVARCHAR(50),
	cust_phone			NVARCHAR(50),
	cust_fax			NVARCHAR(50),
	cust_email			NVARCHAR(50),
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
	DROP TABLE brozne.invoice;

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

