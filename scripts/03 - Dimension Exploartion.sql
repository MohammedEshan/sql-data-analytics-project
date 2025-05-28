
/*
===============================================================================
Dimensions Exploration
===============================================================================
Purpose:
    - To Explore the Structure of Dimension Tables.
	
SQL Functions Used:
    - DISTINCT
    - ORDER BY
===============================================================================
*/
 

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

