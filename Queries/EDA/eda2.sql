
-- Total revenue by country
SELECT 
c.Country,
SUM(f.total_amount) AS Total_Revenue
FROM gold.fact_sales f
JOIN gold.dim_customers c
ON f.customer_id = c.customer_id
GROUP BY c.Country
ORDER BY Total_Revenue DESC


-- Which countries generate the most revenue?
SELECT TOP 5
c.Country,
SUM(f.total_amount) AS Total_Revenue
FROM gold.fact_sales f
JOIN gold.dim_customers c
ON f.customer_id = c.customer_id
GROUP BY c.Country
ORDER BY Total_Revenue DESC


-- Find the countries with the highest number of customers.
SELECT
COUNT(customer_id) AS total_customers,
Country
FROM gold.dim_customers
GROUP BY Country
ORDER BY total_customers DESC


-- Which country has the highest average order value?
WITH CTE AS 
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
FROM CTE
ORDER BY average_order_value


-- Which genres are most popular?
SELECT TOP 5
t.general_name AS genres,
SUM(f.quantity) AS Total_genres_sold
FROM gold.fact_sales f
JOIN gold.dim_track t
ON f.track_id = t.track_id
GROUP BY t.general_name
ORDER BY Total_genres_sold DESC


-- What is the average price of a track in the catalog?
SELECT 
AVG(unit_price) AS average_price
FROM gold.dim_track


-- Top 5 months with highest sales
SELECT TOP 5
DATETRUNC(MONTH, invoice_date) AS sales_month,
SUM(total_amount) AS total_sales
FROM gold.fact_sales
GROUP BY DATETRUNC(MONTH, invoice_date)
ORDER BY SUM(total_amount) DESC


-- Average order value per customer
SELECT 
    customer_id,
    SUM(total_amount) / COUNT(DISTINCT invoice_id) AS avg_order_value
FROM gold.fact_sales
GROUP BY customer_id
ORDER BY avg_order_value DESC;


-- Find customers who never ordered
SELECT
c.customer_id,
c.FirstName,
'No Orders Found' AS Status
FROM gold.dim_customers c
LEFT JOIN gold.fact_sales f
ON c.customer_id = f.customer_id
WHERE f.customer_id IS NULL


-- Find the most sold product (by quantity)
SELECT
f.track_id,
t.track_name,
SUM(f.quantity) AS total_quantities
FROM gold.fact_sales f
JOIN gold.dim_track t
ON f.track_id = t.track_id
GROUP BY f.track_id, t.track_name
ORDER BY total_quantities DESC


-- Monthly sales growth %
WITH month_sales AS
(
	SELECT
		MONTH(invoice_date) AS month_number,
		SUM(total_amount) AS monthly_sales
	FROM gold.fact_sales
	GROUP BY MONTH(invoice_date)
)
SELECT 
	month_number,
	LAG(monthly_sales) OVER(ORDER BY month_number) AS prev_month_sales,
	(monthly_sales - LAG(monthly_sales) OVER(ORDER BY month_number)) 
		/ NULLIF(LAG(monthly_sales) OVER(ORDER BY month_number), 0) * 100 AS growth_amt
FROM month_sales


-- Repeat customers vs one-time customers
SELECT 
    customer_id,
    CASE 
        WHEN COUNT(DISTINCT invoice_id) = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS Status
FROM gold.fact_sales
GROUP BY customer_id;


-- Contribution % of each product
WITH total_sales AS
(
	SELECT
	track_id,
	SUM(total_amount) AS total_sales
	FROM gold.fact_sales
	GROUP BY track_id
)
SELECT
	track_id,
	ROUND(((total_sales* 100) / (SUM(total_sales) OVER())), 2) AS Contribution
FROM total_sales
ORDER BY Contribution DESC


-- Customers who increased spending compared to last year
WITH annual_spend AS 
(
	SELECT
		customer_id,
		YEAR(invoice_date) AS Order_year,
		SUM(total_amount)AS current_year_spends
	FROM gold.fact_sales
	GROUP BY customer_id, YEAR(invoice_date)
),
lagging AS
(
	SELECT
		customer_id,
		Order_year,
		current_year_spends,
		LAG(current_year_spends) OVER(PARTITION BY customer_id ORDER BY Order_year) AS prev_year_spend
	FROM annual_spend
) 
SELECT 
	*
FROM lagging
WHERE current_year_spends > prev_year_spend
