-- Total revenue by country
SELECT 
    c.Country,
    SUM(f.total_amount) AS Total_Revenue
FROM gold.fact_sales f
JOIN gold.dim_customers c
    ON f.customer_id = c.customer_id
GROUP BY c.Country
ORDER BY Total_Revenue DESC;


-- Top 5 countries by revenue
SELECT TOP 5
    c.Country,
    SUM(f.total_amount) AS Total_Revenue
FROM gold.fact_sales f
JOIN gold.dim_customers c
    ON f.customer_id = c.customer_id
GROUP BY c.Country
ORDER BY Total_Revenue DESC;


-- Countries with highest number of customers
SELECT
    Country,
    COUNT(customer_id) AS total_customers
FROM gold.dim_customers
GROUP BY Country
ORDER BY total_customers DESC;


-- Country with highest average order value
WITH country_orders AS 
(
    SELECT 
        c.Country,
        SUM(f.total_amount) AS revenue,
        COUNT(DISTINCT f.invoice_id) AS total_orders
    FROM gold.fact_sales f
    JOIN gold.dim_customers c
        ON f.customer_id = c.customer_id
    GROUP BY c.Country
)
SELECT TOP 1
    Country,
    (revenue * 1.0 / total_orders) AS average_order_value
FROM country_orders
ORDER BY average_order_value DESC;


-- Most popular genres (by quantity)
SELECT TOP 5
    t.general_name AS genre,
    SUM(f.quantity) AS total_sold
FROM gold.fact_sales f
JOIN gold.dim_track t
    ON f.track_id = t.track_id
GROUP BY t.general_name
ORDER BY total_sold DESC;


-- Average price of track
SELECT 
    AVG(unit_price) AS average_price
FROM gold.dim_track;


-- Top 5 months with highest sales
SELECT TOP 5
    DATETRUNC(MONTH, invoice_date) AS sales_month,
    SUM(total_amount) AS total_sales
FROM gold.fact_sales
GROUP BY DATETRUNC(MONTH, invoice_date)
ORDER BY total_sales DESC;


-- Average order value per customer
SELECT 
    customer_id,
    SUM(total_amount) * 1.0 / COUNT(DISTINCT invoice_id) AS avg_order_value
FROM gold.fact_sales
GROUP BY customer_id
ORDER BY avg_order_value DESC;


-- Customers who never ordered
SELECT
    c.customer_id,
    c.FirstName,
    'No Orders Found' AS Status
FROM gold.dim_customers c
LEFT JOIN gold.fact_sales f
    ON c.customer_id = f.customer_id
WHERE f.customer_id IS NULL;


-- Most sold product (by quantity)
SELECT
    f.track_id,
    t.track_name,
    SUM(f.quantity) AS total_quantity
FROM gold.fact_sales f
JOIN gold.dim_track t
    ON f.track_id = t.track_id
GROUP BY f.track_id, t.track_name
ORDER BY total_quantity DESC;


-- Monthly sales growth %
WITH month_sales AS
(
    SELECT
        DATETRUNC(MONTH, invoice_date) AS month_date,
        SUM(total_amount) AS monthly_sales
    FROM gold.fact_sales
    GROUP BY DATETRUNC(MONTH, invoice_date)
)
SELECT 
    month_date,
    LAG(monthly_sales) OVER(ORDER BY month_date) AS prev_month_sales,
    (monthly_sales - LAG(monthly_sales) OVER(ORDER BY month_date)) 
        / NULLIF(LAG(monthly_sales) OVER(ORDER BY month_date), 0) * 100 AS growth_pct
FROM month_sales;


-- Repeat vs One-Time Customers (summary)
WITH customer_type AS
(
    SELECT 
        customer_id,
        CASE 
            WHEN COUNT(DISTINCT invoice_id) = 1 THEN 'One-Time'
            ELSE 'Repeat'
        END AS type
    FROM gold.fact_sales
    GROUP BY customer_id
)
SELECT
    type,
    COUNT(*) AS total_customers
FROM customer_type
GROUP BY type;


-- Contribution % of each product
WITH product_sales AS
(
    SELECT
        track_id,
        SUM(total_amount) AS total_sales
    FROM gold.fact_sales
    GROUP BY track_id
)
SELECT
    track_id,
    ROUND(100.0 * total_sales / SUM(total_sales) OVER(), 2) AS contribution_pct
FROM product_sales
ORDER BY contribution_pct DESC;


-- Customers who increased spending YoY
WITH yearly_spend AS 
(
    SELECT
        customer_id,
        YEAR(invoice_date) AS order_year,
        SUM(total_amount) AS current_year_spend
    FROM gold.fact_sales
    GROUP BY customer_id, YEAR(invoice_date)
),
compare AS
(
    SELECT
        customer_id,
        order_year,
        current_year_spend,
        LAG(current_year_spend) OVER(PARTITION BY customer_id ORDER BY order_year) AS prev_year_spend
    FROM yearly_spend
)
SELECT *
FROM compare
WHERE current_year_spend > prev_year_spend;


-- Cohort Analysis (TRUE retention)
WITH first_purchase AS (
    SELECT 
        customer_id,
        MIN(DATETRUNC(MONTH, invoice_date)) AS cohort_month
    FROM gold.fact_sales
    GROUP BY customer_id
),
activity AS (
    SELECT 
        f.customer_id,
        DATETRUNC(MONTH, f.invoice_date) AS activity_month,
        fp.cohort_month
    FROM gold.fact_sales f
    JOIN first_purchase fp 
        ON f.customer_id = fp.customer_id
)
SELECT
    cohort_month,
    activity_month,
    COUNT(DISTINCT customer_id) AS active_customers
FROM activity
GROUP BY cohort_month, activity_month
ORDER BY cohort_month, activity_month;


-- Rolling 3-month average sales
SELECT
    DATETRUNC(MONTH, invoice_date) AS sale_month,
    SUM(total_amount) AS monthly_sales,
    AVG(SUM(total_amount)) OVER(
        ORDER BY DATETRUNC(MONTH, invoice_date)
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ) AS rolling_3_month_avg
FROM gold.fact_sales
GROUP BY DATETRUNC(MONTH, invoice_date)
ORDER BY sale_month;


-- Top 5 customers by spending
SELECT TOP 5
    customer_id,
    SUM(total_amount) AS total_spending
FROM gold.fact_sales
GROUP BY customer_id
ORDER BY total_spending DESC;


-- Most popular genre by revenue
SELECT TOP 2
    t.general_name,
    SUM(s.total_amount) AS total_sales
FROM gold.fact_sales s
JOIN gold.dim_track t
    ON s.track_id = t.track_id
GROUP BY t.general_name
ORDER BY total_sales DESC;


-- Artist generating highest revenue
SELECT TOP 2
    t.artist_name,
    SUM(s.total_amount) AS total_sales
FROM gold.fact_sales s
JOIN gold.dim_track t
    ON s.track_id = t.track_id
GROUP BY t.artist_name
ORDER BY total_sales DESC;


-- Rank customers by spending
SELECT
    customer_id,
    SUM(total_amount) AS total_sales,
    RANK() OVER(ORDER BY SUM(total_amount) DESC) AS customer_rank
FROM gold.fact_sales
GROUP BY customer_id;


-- Running total of sales
SELECT
    invoice_date,
    SUM(total_amount) OVER(
        ORDER BY invoice_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM gold.fact_sales;


-- Highest selling track in each genre
SELECT
    general_name,
    track_name,
    total_sales
FROM
(
    SELECT
        t.general_name,
        t.track_name,
        SUM(s.total_amount) AS total_sales,
        DENSE_RANK() OVER(
            PARTITION BY t.general_name 
            ORDER BY SUM(s.total_amount) DESC
        ) AS rank_num
    FROM gold.fact_sales s
    JOIN gold.dim_track t
        ON s.track_id = t.track_id
    GROUP BY t.general_name, t.track_name
) ranked
WHERE rank_num = 1
ORDER BY total_sales DESC;
