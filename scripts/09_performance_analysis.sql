-- =================================================================================================================
-- Performance Analysis
-- =================================================================================================================

-- Analyze the yearly performance of products by comparing their sales
-- to both the average sales performance of the product and the previous year's sales


-- yearly performance of products
SELECT
	YEAR(fs.order_date) AS order_year,
	dm.product_name,
	SUM(fs.sales_amount) AS current_sales
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dm
ON fs.product_key = dm.product_key
WHERE YEAR(fs.order_date) IS NOT NULL
GROUP BY YEAR(fs.order_date),
		 dm.product_name
ORDER BY dm.product_name, order_year 


-- compared to average sales and previous year's sales

WITH yearly_product_sales AS
(
SELECT
	YEAR(fs.order_date) AS order_year,
	dm.product_name,
	SUM(fs.sales_amount) AS current_sales
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dm
ON fs.product_key = dm.product_key
WHERE YEAR(fs.order_date) IS NOT NULL
GROUP BY YEAR(fs.order_date),
		 dm.product_name
)
SELECT
		order_year,
		product_name,
		current_sales,
		AVG(current_sales) OVER(PARTITION BY product_name) AS avg_sales,
		current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS diff_avg,
		CASE
			WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Average'
			WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Average'
			ELSE 'Avg'
		END avg_change,
		LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) py_sales,
		current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) AS diff_py,
		CASE
			WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
			WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
			ELSE 'No Change'
		END py_change
FROM yearly_product_sales
GROUP BY 
		order_year,
		product_name,
		current_sales
ORDER BY product_name, order_year
