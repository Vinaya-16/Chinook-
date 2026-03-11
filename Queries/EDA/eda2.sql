
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