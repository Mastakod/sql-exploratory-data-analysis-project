-- =====================================================================================
	-- Database Exploration
-- =====================================================================================

-- Explore All Objects in the Database
SELECT * FROM INFORMATION_SCHEMA.TABLES

-- Explore All COlumns in the Database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_products'
