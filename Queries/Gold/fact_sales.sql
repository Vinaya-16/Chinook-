
CREATE OR ALTER VIEW gold.fact_sales AS
SELECT
    i.invoice_id,
    iv.cust_id AS customer_id,
    i.track_id,
    iv.invoice_date,
    c.support_rep_id AS employee_id,
    i.quantity,
    i.unit_price,
    (i.quantity * i.unit_price) AS total_amount
FROM silver.invoice_line i
JOIN silver.invoice iv
    ON i.invoice_id = iv.invoice_id
JOIN silver.cust_info c
    ON iv.cust_id = c.cust_id;