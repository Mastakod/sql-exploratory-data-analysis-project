-- =====================================================================================
	-- Measure Exploration
-- =====================================================================================
-- Find the Total Sales
SELECT SUM(sales_amount) AS Total_Sales FROM gold.fact_sales;

-- Find how many items are sold
SELECT SUM(quantity) AS Total_Quantity
FROM gold.fact_sales;

-- Find the average selling price
SELECT AVG(price) AS average_price FROM gold.fact_sales

-- Find the total number of Orders
SELECT COUNT(order_number) AS Total_orders FROM gold.fact_sales
SELECT COUNT(DISTINCT order_number) AS total_orders FROM gold.fact_sales

-- Find the total number of products
SELECT COUNT(product_key) AS total_products FROM gold.dim_products
SELECT COUNT(DISTINCT product_key) AS total_products FROM gold.dim_products

-- Find the total number of customers
SELECT COUNT(customer_key) AS total_customers FROM gold.dim_customers;

-- Find the total number of customers that has placed an order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.fact_sales;

-- Generate a report that shows all key metrics of the business

SELECT 'Total_Sales' AS measure_name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total_Quantity' AS measure_name, SUM(quantity) measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Average_Price' AS measure_name, AVG(price) measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total_Nr_Orders' AS measure_name, COUNT(DISTINCT order_number) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total_Nr_Products' AS measure_name, COUNT(product_key) AS measure_value FROM gold.dim_products
UNION ALL
SELECT 'Total_Nr_Customers' AS measure_name, COUNT(customer_key) AS measure_value FROM gold.dim_customers;
