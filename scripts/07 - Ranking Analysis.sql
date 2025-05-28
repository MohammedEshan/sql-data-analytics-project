/*
===============================================================================
Ranking Analysis
===============================================================================
Purpose:
    - To Rank Items (E.G., Products, Customers) Based On Performance Or Other Metrics.
    - To Identify Top Performers Or Laggards.

SQL Functions Used:
    - Window Ranking Functions: RANK(), DENSE_RANK(), ROW_NUMBER(), TOP
    - Clauses: GROUP BY, ORDER BY
===============================================================================
*/


-- Which 5 Products Generate the Highest Revenue 

SELECT *
FROM (
	SELECT 
		p.product_name,
		SUM(f.sales_amount) total_revenue,
		DENSE_RANK() OVER (ORDER BY SUM(f.sales_amount) DESC) rank_no
	FROM Gold.fact_sales f
	LEFT JOIN Gold.dim_products p
	ON f.product_key = p.product_key
	GROUP BY p.product_name
	)t
WHERE rank_no <= 5

-- or

SELECT TOP 5
	p.product_name,
	SUM(f.sales_amount) total_revenue
FROM Gold.fact_sales f
LEFT JOIN Gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC

-- Which are the 5 Worst Performing Products in Terms of Sales


SELECT TOP 5
	p.product_name,
	SUM(f.sales_amount) total_revenue
FROM Gold.fact_sales f
LEFT JOIN Gold.dim_products p
ON f.product_key = p.product_key
GROUP BY p.product_name
ORDER BY total_revenue 


-- Find the Top-10 Customers Who have Generated the Highest Revenue and 3 Customers with the Fewest Orders Placed 


SELECT *
FROM (
	SELECT 
		c.customer_key,
		c.first_name,
		c.last_name,
		SUM(f.sales_amount) AS total_revenue,
		DENSE_RANK() OVER(ORDER BY SUM(f.sales_amount) DESC) rank_no
	FROM Gold.fact_sales AS f
	LEFT JOIN Gold.dim_customers c
	ON c.customer_key = f.customer_key
	GROUP BY c.customer_key,
			 c.first_name,
			 c.last_name
	)t
WHERE rank_no <= 10



SELECT TOP 3
	c.customer_key,
	c.first_name,
	c.last_name,		
	COUNT(DISTINCT f.order_number) AS total_orders
FROM Gold.fact_sales AS f
LEFT JOIN Gold.dim_customers c
ON c.customer_key = f.customer_key
GROUP BY c.customer_key,
		 c.first_name,
		 c.last_name
ORDER BY total_orders 
