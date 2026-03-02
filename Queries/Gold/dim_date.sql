CREATE OR ALTER VIEW gold.dim_date AS
SELECT
    ROW_NUMBER() OVER (ORDER BY invoice_date) AS date_key,
    invoice_date AS full_date,
    YEAR(invoice_date) AS year,
    MONTH(invoice_date) AS month,
    DATENAME(MONTH, invoice_date) AS month_name,
    DATEPART(QUARTER, invoice_date) AS quarter,
    DAY(invoice_date) AS day,
    DATENAME(WEEKDAY, invoice_date) AS weekday
FROM silver.invoice;