/*
===============================================================================
Date Range Exploration 
===============================================================================
Purpose:
    - To Determine the Temporal Boundaries of Key Data Points.
    - To Understand the Range of Historical Data.

SQL Functions Used:
    - MIN(), MAX(), DATEDIFF()
===============================================================================
*/

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
