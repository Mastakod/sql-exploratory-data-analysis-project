-- =================================================================================================================
-- Part to Whole Analysis
-- =================================================================================================================

-- Which categories contribute the most to overall sales?
WITH category_sales AS
(
SELECT
		dm.category AS categories,
		SUM(fs.sales_amount) AS total_sales
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dm
ON fs.product_key = dm.product_key
GROUP BY dm.category
)
SELECT
		categories,
		total_sales,
		SUM(total_sales) OVER() AS overall_sales,
		CONCAT(ROUND((CAST(total_sales AS FLOAT) / SUM(total_sales) OVER()) * 100, 2), '%') AS percentage_of_total
FROM category_sales
ORDER BY total_sales DESC
