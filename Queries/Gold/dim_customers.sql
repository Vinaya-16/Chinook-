
CREATE OR ALTER VIEW gold.dim_customers AS
	SELECT
		cust_id AS customer_id,
		cust_firstname AS FirstName,
		cust_lastname AS LastName,
		cust_company AS Compnay,
		cust_address AS Address,
		cust_city AS City,
		cust_state AS State,
		cust_country AS Country,
		cust_postalcode AS PostalCode,
		cust_phone AS Phone,
		cust_fax AS Fax,
		cust_email AS Email,
		support_rep_id
	FROM silver.cust_info