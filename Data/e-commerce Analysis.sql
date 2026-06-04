DROP TABLE IF EXISTS online_retail;
CREATE TABLE online_retail (
    invoice VARCHAR(20),
    stock_code VARCHAR(20),
    description VARCHAR(255),
    quantity INTEGER,
    invoice_date TIMESTAMP,
    price NUMERIC(10,2),
    customer_id VARCHAR(20),
    country VARCHAR(50)
);

SELECT *
FROM online_retail;

-- Total Revenue by Country

SELECT country,
		ROUND(SUM(quantity * price):: numeric, 2) AS total_revenue,
		COUNT(DISTINCT invoice) AS total_orders,
		COUNT(DISTINCT customer_id) As total_customers
FROM online_retail
WHERE quantity > 0
		AND price > 0
		AND customer_id IS NOT NULL
GROUP BY country
ORDER BY total_revenue DESC
LIMIT 15;

-- Top 10 Customer by Spend

SELECT customer_id,
		country,
		ROUND(SUM(quantity * price):: numeric, 2) AS total_spend,
		ROUND(AVG(quantity * price):: numeric, 2) AS avg_order_value
FROM online_retail
WHERE quantity > 0
		AND price > 0
		AND customer_id IS NOT NULL
GROUP BY customer_id, country
ORDER BY total_spend DESC
LIMIT 10;

-- Top 10 Best Selling Products

SELECT stock_code,
		description,
		SUM(quantity) AS total_units_sold
		ROUND(SUM(quantity * price):: numeric, 2) AS total_revenue,
		COUNT(DISTINCT invoice) AS times_ordered
FROM online_retail
WHERE quantity > 0
		AND price > 0
		AND description IS NOT NULL
GROUP BY stock_code, description
ORDER BY total_units_sold DESC
LIMIT 10;

-- Monthly Revenue Trend
SELECT DATE_TRUNC('month', invoice_date) AS month,
		ROUND(SUM(quantity * price):: numeric, 2) AS total_revenue,
		COUNT(DISTINCT invoice) AS total_orders,
		SUM(quantity) AS total_units_sold,
		COUNT(DISTINCT customer_id) AS unique_customers
FROM online_retail
WHERE quantity > 0
		AND price > 0
		AND customer_id IS NOT NULL
GROUP BY month
ORDER BY month ASC;

-- Average Order Value

WITH order_value AS (
	SELECT invoice,
			country,
			SUM(quantity * price) AS order_total
	FROM online_retail
	WHERE quantity > 0
			AND price > 0
			AND customer_id IS NOT NULL
	GROUP BY invoice, country )
SELECT country,
		ROUND(AVG(order_total):: numeric, 2) AS avg_order_value,
		COUNT(invoice) AS total_orders
FROM order_value
GROUP BY country
ORDER BY avg_order_value DESC
LIMIT 15;

-- Unique Customers Per Country

SELECT country,
		COUNT(DISTINCT customer_id) AS unique_customers,
		ROUND(SUM(quantity * price):: numeric, 2) AS total_revenue,
		ROUND(SUM(quantity * price):: numeric /
				COUNT(DISTINCT customer_id), 2) AS revenue_per_customer
FROM online_retail
WHERE price > 0
		AND quantity > 0
		AND customer_id IS NOT NULL
GROUP BY country
ORDER BY unique_customers DESC
LIMIT 15;

-- Products with Highest Return Rate

SELECT stock_code,
		description,
		SUM( CASE WHEN quantity > 0 THEN quantity ELSE 0 END) as units_sold,
		ABS(SUM(CASE WHEN quantity < 0 THEN quantity ELSE 0 END)) AS units_returned,
		ROUND(ABS(SUM(CASE WHEN quantity < 0 THEN quantity ELSE 0 END)) /
					NULLIF(SUM(CASE WHEN quantity > 0 THEN quantity ELSE 0 END), 0) * 100, 2) AS return_rate_pct 
FROM online_retail
WHERE description IS NOT NULL
		AND price > 0
		-- AND description <> 'Discount'
GROUP BY stock_code, description
HAVING SUM(CASE WHEN quantity > 0 THEN quantity ELSE 0 END) > 100
ORDER BY return_rate_pct DESC
LIMIT 10;

-- Guest vs Registered Orders

SELECT CASE WHEN customer_id IS NULL THEN 'Guest Order'
			ELSE 'Registered Customer' END AS customer_type,
		COUNT(DISTINCT invoice) AS total_orders,
		ROUND(SUM(quantity * price):: numeric, 2) AS total_revenue,
		ROUND(AVG(quantity * price):: numeric, 2) AS avg_order_value
FROM online_retail
WHERE quantity > 0
		AND price > 0
GROUP BY customer_type
ORDER BY total_orders DESC;


