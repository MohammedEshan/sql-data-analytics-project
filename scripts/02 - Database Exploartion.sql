/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To Explore the Structure of the Database, Including the List of Tables and their Schemas.
    - To Inspect the Columns and Metadata for Specific Tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/



-- Exploring Tables in Database DataWarehouse

USE DataWarehouse

SELECT *
FROM INFORMATION_SCHEMA.TABLES

-- Exploring Columns in Database DataWarehouse

SELECT *
FROM INFORMATION_SCHEMA.Columns


-- DIMENSIONS EXPLORATION

-- Explore All Countries Our Customers Come from.

SELECT 
	DISTINCT country
FROM Gold.dim_customers

-- Explore All Category 'The Major Divisions'

SELECT 
	DISTINCT category, 
	sub_category,
	product_name
FROM Gold.dim_products


-- Date Exploration

-- Find the Date of First and Last Order
-- How Many Years of Sales are Available


SELECT
	MIN(order_date) AS first_order_date,
	MAX(order_date) AS last_order_date,
	DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) order_timespan
FROM Gold.fact_sales


-- Find the Youngest and Oldest Birhtdate

SELECT
	MIN(birth_date) AS oldest_birthdate,
	MAX(birth_date) AS youngest_birthdate,
	DATEDIFF(YEAR, MIN(birth_date), GETDATE()) AS oldest_age,
	DATEDIFF(YEAR, MAX(birth_date), GETDATE()) AS youngest_age
FROM Gold.dim_customers