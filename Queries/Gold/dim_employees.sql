

CREATE OR ALTER VIEW gold.dim_employees AS
	SELECT
		emp_id AS employee_id,
		emp_firstname AS FirstName,
		emp_lastname AS LastName,
		emp_title AS title,
		emp_reports_to AS reports_to,
		emp_address AS address,
		emp_city AS city,
		emp_state AS state,
		emp_country AS country,
		emp_postalcode AS postal_code,
		emp_phone AS phone,
		emp_email AS email
	FROM silver.emp_info