/*
===============================================================================
Magnitude Analysis
===============================================================================
Purpose:
    - To Quantify Data And Group Results By Specific Dimensions.
    - For Understanding Data Distribution Across Categories.

SQL Functions Used:
    - Aggregate Functions: SUM(), COUNT(), AVG()
    - GROUP BY, ORDER BY
===============================================================================
*/


-- Find the Total Number of Customers By Country	

SELECT 
	country,
	COUNT(customer_id) total_customers
FROM Gold.dim_customers
GROUP BY country
ORDER BY COUNT(customer_id) DESC

-- Find the Total Customers By Gender

SELECT 
	gender,
	COUNT(customer_key) total_customers
FROM Gold.dim_customers
GROUP BY gender
ORDER BY COUNT(customer_key) DESC

-- Find Total Products by Category

SELECT 
	category,
	COUNT(product_name) AS total_products
FROM Gold.dim_products
GROUP BY category
ORDER BY COUNT(product_name) DESC

-- Find the Average Cost of Each Category

SELECT 
	category,
	AVG(product_cost) AS avg_productcost
FROM Gold.dim_products
GROUP BY category

-- What is the Revenue Generated for Each Category

SELECT 
	dp.category,
	SUM(fs.sales_amount) AS total_sales
FROM Gold.dim_products dp
LEFT JOIN Gold.fact_sales fs
ON dp.product_key = fs.product_key
GROUP BY dp.category
ORDER BY total_sales DESC

-- OR

SELECT 
	dp.category,
	SUM(fs.sales_amount) AS total_sales
FROM Gold.fact_sales fs
LEFT JOIN Gold.dim_products dp
ON dp.product_key = fs.product_key
GROUP BY dp.category
ORDER BY total_sales DESC


-- What is the Revenue Generated for Each Customer

SELECT 
	dc.customer_key,
	SUM(fs.sales_amount) AS total_sales
FROM Gold.dim_customers AS dc
LEFT JOIN Gold.fact_sales AS fs
ON dc.customer_key = fs.product_key
GROUP BY dc.customer_key
ORDER BY total_sales DESC

-- or

SELECT 
	dc.customer_key,
	dc.first_name,
	dc.last_name,
	SUM(fs.sales_amount) AS total_sales
FROM Gold.fact_sales AS fs 
LEFT JOIN Gold.dim_customers AS dc
ON dc.customer_key = fs.customer_key
GROUP BY 	dc.customer_key,
	        dc.first_name,
	        dc.last_name
ORDER BY total_sales DESC

-- What is the Distribution of Sold Items Across Countries

SELECT
	c.country,
	SUM(f.quantity) AS total_sold_items
FROM Gold.fact_sales AS f
LEFT JOIN Gold.dim_customers AS c
ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY total_sold_items