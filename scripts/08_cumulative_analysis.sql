-- =================================================================================================================
-- Cumulative Analysis
-- =================================================================================================================

-- Calculate the total sales per month
-- and the running total of sales over time
-- and the moving average of the price

SELECT
		order_date,
		total_sales,
		SUM(total_sales) OVER(ORDER BY order_date) AS running_total_sales, -- Window Function
		AVG(avg_price) OVER(ORDER BY order_date) AS moving_average_price -- Window Function
FROM
		(
		SELECT
				DATETRUNC(month, order_date) AS order_date,
				SUM(sales_amount) AS total_sales,
				AVG(price) AS avg_price
		FROM gold.fact_sales
		WHERE order_date IS NOT NULL
		GROUP BY DATETRUNC(month, order_date)
		) t -- total sales per month



SELECT
		order_date,
		total_sales,
		SUM(total_sales) OVER(PARTITION BY order_date ORDER BY order_date) AS running_total_sales -- Window Function
FROM
		(
		SELECT
				DATETRUNC(month, order_date) AS order_date,
				SUM(sales_amount) AS total_sales
		FROM gold.fact_sales
		WHERE order_date IS NOT NULL
		GROUP BY DATETRUNC(month, order_date)
		) t -- total sales per month
