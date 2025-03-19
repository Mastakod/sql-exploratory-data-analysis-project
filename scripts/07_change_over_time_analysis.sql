-- =================================================================================================================
-- Change over time
-- =================================================================================================================

SELECT
		YEAR(order_date)AS order_year, -- the output will be integer
		MONTH(order_date) AS order_month, -- the output will be integer
		SUM(sales_amount) AS total_sales,
		COUNT(DISTINCT customer_key) AS total_customers,
		SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY YEAR(order_date), MONTH(order_date)



SELECT
		DATETRUNC(month, order_date)AS order_month, -- the output will be in date format, easy to sort
		SUM(sales_amount) AS total_sales,
		COUNT(DISTINCT customer_key) AS total_customers,
		SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date)


SELECT
		FORMAT(order_date, 'yyyy-MMM')AS order_date, -- here the output will be a string not a date, not possible to sort it
		SUM(sales_amount) AS total_sales,
		COUNT(DISTINCT customer_key) AS total_customers,
		SUM(quantity) AS total_quantity
FROM gold.fact_sales
WHERE order_date IS NOT NULL
GROUP BY FORMAT(order_date, 'yyyy-MMM')
ORDER BY FORMAT(order_date, 'yyyy-MMM')
