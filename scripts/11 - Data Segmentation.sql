/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To Group Data Into Meaningful Categories For Targeted Insights.
    - For Customer Segmentation, Product Categorization, Or Regional Analysis.

SQL Functions Used:
    - CASE: Defines Custom Segmentation Logic.
    - GROUP BY: Groups Data Into Segments.
===============================================================================
*/


-- Segment Products into Costs Ranges and Count How Many Products Falls into Each Segment

WITH product_segement AS 
(
	SELECT
		product_key,
		product_name,
		product_cost,
		CASE 
			WHEN product_cost < 100 THEN 'Below 100'
			WHEN product_cost < 500 THEN '100-500'
			WHEN product_cost < 1000 THEN '500-1000'
			ELSE 'Above 1000'	
		END AS cost_range
	FROM Gold.dim_products
)
SELECT
	cost_range,
	COUNT(product_key) AS total_products
FROM product_segement
GROUP BY cost_range
ORDER BY total_products DESC



/* Group by Customers into Three Segments Based on Their Spending Behaviour 
	- VIP : Customers with Atleast 12 Months History and Spending > 5,000.
	- Regular : Customers with Atleast 12 Months History and Spending <= 5,000.
	- New : Customers with Lifespan of Less than 12 Months.
And Find the Total No of Customers by Each Group
*/

WITH customer_spending AS 
(
	SELECT
		c.customer_key,
		SUM(f.sales_amount) AS total_sales,
		MIN(order_date) AS first_date,
		MAX(order_date) AS last_order,
		DATEDIFF(MONTH,MIN(order_date),MAX(order_date)) AS life_span
	FROM Gold.fact_sales AS f
	LEFT JOIN Gold.dim_customers AS C
	ON f.customer_key = c.customer_key
	GROUP BY c.customer_key
)	
SELECT
	customer_segment,
	COUNT(customer_key) AS total_customers
FROM
(
	SELECT 
		customer_key,
		total_sales,
		life_span,
		CASE
			WHEN life_span >= 12 AND total_sales > 5000 THEN 'VIP'
			WHEN life_span >= 12 AND total_sales <= 5000 THEN 'Regular'
			ELSE 'New'
		END AS customer_segment
	FROM customer_spending
)t
GROUP BY customer_segment
ORDER BY total_customers