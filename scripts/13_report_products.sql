/*
-- =================================================================================================================
-- Product Report
-- =================================================================================================================
Purpose:
	- This report consolidates key product metrics and behaviors

Highlights:
	1. Gathers essential fields such as product name, category, subcategory and cost.
	2. Segments products by revenue to identify high-performers, mid-range, or low-performers.
	3. Aggregates product-level metrics:
	   - total orders
	   - total sales
	   - total quantity sold
	   - total customers (unique)
	   - lifespan (in months)
	4. Calculates valuable KPIs:
	   - recency (months since last sale)
	   - average order revenue (AOR)
	   - average monthly revenue
-- =================================================================================================================
*/

CREATE VIEW gold.report_products AS
WITH
base_query AS
(
-- 1) Base Query: Retrieves core columns from tables fact_sales and dim_products
SELECT
		fs.order_number,
		fs.order_date,
		fs.customer_key,
		fs.sales_amount,
		fs.quantity,
		dp.product_key,
		dp.product_name,
		dp.category,
		dp.subcategory,
		dp.cost
FROM gold.fact_sales fs
LEFT JOIN gold.dim_products dp
ON fs.product_key = dp.product_key
WHERE order_date IS NOT NULL -- only consider valid sales dates
),
product_aggregation AS
(
-- 2) Product Aggregations: Summarizes key metrics at the product level
SELECT 
		product_key,
		product_name,
		category,
		subcategory,
		cost,
		COUNT(DISTINCT order_number) AS total_orders,
		COUNT(DISTINCT customer_key) AS total_customers,
		SUM(quantity) AS total_quantity,
		SUM(sales_amount) AS total_sales,
		ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity, 0)),1) AS avg_selling_price,
		MAX(order_date) AS last_sale_date,
		DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan
FROM base_query
GROUP BY 
		product_key,
		product_name,
		category,
		subcategory,
		cost
)

-- 3) Final Query: Combines all product results into one output
SELECT 
		product_key,
		product_name,
		category,
		subcategory,
		-- Product segmentation into categories
		CASE
			WHEN total_sales > 50000 THEN 'High-Performer'
			WHEN total_sales >= 10000 THEN 'Mid-Range'
			ELSE 'Low-Performer'
		END AS product_segment,
		total_orders,
		total_quantity,
		total_customers,
		cost,
		total_sales,
		avg_selling_price,
		lifespan,
		last_sale_date,
		-- Compute the recency
		DATEDIFF(MONTH, last_sale_date, GETDATE()) AS recency_in_months,
		-- Compute average order revenue (AVR)
		CASE
			WHEN total_orders = 0 THEN 0
			ELSE total_sales / total_orders
		END  AS avg_order_revenue,
		-- Compute average monthly revenue
		CASE
			WHEN lifespan = 0 THEN total_sales
			ELSE total_sales / lifespan
		END  AS avg_monthly_revenue
FROM product_aggregation
