-- =====================================================================================
	-- Ranking Analysis
-- =====================================================================================

-- Which 5 products generate the highest revenue?
SELECT TOP 5
		dm.product_name,
		SUM(fc.sales_amount) AS revenue
FROM gold.fact_sales fc
LEFT JOIN gold.dim_products dm
ON fc.product_key = dm.product_key
GROUP BY dm.product_name
ORDER BY revenue DESC

SELECT *
FROM
	(
	SELECT
			dm.product_name,
			SUM(fc.sales_amount) AS revenue,
			RANK() OVER (ORDER BY SUM(fc.sales_amount) DESC) AS ranked_products
	FROM gold.fact_sales fc
	LEFT JOIN gold.dim_products dm
	ON fc.product_key = dm.product_key
	GROUP BY dm.product_name
	) T
WHERE ranked_products <= 5

-- What are the 5 worst-performing products in terms of sales?

SELECT TOP 5
		dm.product_name,
		SUM(fc.sales_amount) AS revenue
FROM gold.fact_sales fc
LEFT JOIN gold.dim_products dm
ON fc.product_key = dm.product_key
GROUP BY dm.product_name
ORDER BY revenue

-- Find the Top-10 customers who have generated the highest revenue

SELECT TOP 10
		dc.customer_key,
		dc.first_name,
		dc.last_name,
		SUM(fs.sales_amount) AS revenue
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
ON fs.customer_key = dc.customer_key
GROUP BY 
		dc.customer_key,
		dc.first_name,
		dc.last_name
ORDER BY revenue DESC



SELECT *
FROM
	(
	SELECT
			dc.customer_key,
			dc.first_name,
			dc.last_name,
			SUM(fs.sales_amount) AS revenue,
			ROW_NUMBER() OVER(ORDER BY SUM(fs.sales_amount) DESC) AS ranking
	FROM gold.fact_sales fs
	LEFT JOIN gold.dim_customers dc
	ON fs.customer_key = dc.customer_key
	GROUP BY 
			dc.customer_key,
			dc.first_name,
			dc.last_name
	) s
WHERE ranking <= 10


-- Find the 3 customers with the fewest orders placed

SELECT TOP 3
		dc.customer_key,
		dc.first_name,
		dc.last_name,
		COUNT(DISTINCT fs.order_number) AS total_orders
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
ON fs.customer_key = dc.customer_key
GROUP BY 
		dc.customer_key,
		dc.first_name,
		dc.last_name
ORDER BY total_orders
