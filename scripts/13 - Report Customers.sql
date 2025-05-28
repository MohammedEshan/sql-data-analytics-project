/*
===============================================================================
Customer Report
===============================================================================
Purpose:
    - This Report Consolidates Key Customer Metrics And Behaviors

Highlights:
    1. Gathers Essential Fields Such As Names, Ages, And Transaction Details.
    2. Segments Customers Into Categories (VIP, Regular, New) And Age Groups.
    3. Aggregates Customer-Level Metrics:
       - Total Orders
       - Total Sales
       - Total Quantity Purchased
       - Total Products
       - Lifespan (In Months)
    4. Calculates Valuable KPIs:
       - Recency (Months Since Last Order)
       - Average Order Value
       - Average Monthly Spend
===============================================================================
*/


-- =============================================================================
-- Create Report: gold.report_customers
-- =============================================================================
IF OBJECT_ID('gold.report_customers', 'V') IS NOT NULL
    DROP VIEW gold.report_customers;
GO
CREATE VIEW Gold.report_customers AS 

WITH base_query AS
/*---------------------------------------------------------------------------
1) Base Query: Retrieves Core Columns from Tables
---------------------------------------------------------------------------*/
(
	SELECT 
		f.order_number,
		f.product_key,
		f.sales_amount,
		f.quantity,
		f.price,
		f.order_date,
		DATEDIFF(YEAR, f.order_date, GETDATE()) AS age,
		c.customer_key,
		c.customer_number,
		CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
		c.country
	FROM Gold.fact_sales AS f
	LEFT Join Gold.dim_customers AS c
	ON c.customer_key = f.customer_key
),
customer_aggregation AS
/*---------------------------------------------------------------------------
2) Customer Aggregations: Summarizes key metrics at the customer level
---------------------------------------------------------------------------*/
(
	SELECT
		customer_key,
		customer_number,
		customer_name,
		country,
		age,
		COUNT(DISTINCT order_number) AS total_orders,
		SUM(sales_amount) AS total_sales,
		SUM(quantity) AS total_quantity,
		COUNT(DISTINCT product_key) AS total_products,
		MAX(order_date) AS last_order_date,
		DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan_months
	FROM base_query
	GROUP BY 
		customer_key,
		customer_number,
		customer_name,
		country,
		age
)
/*---------------------------------------------------------------------------
  3) Final Query: Combines all product results into one output
---------------------------------------------------------------------------*/
SELECT 
	customer_key,
	customer_number,
	customer_name,
	country,
	age,
	CASE
		WHEN age < 20 THEN 'Under 20'
		WHEN age BETWEEN 20 AND 29 THEN '20-29'
		WHEN age BETWEEN 30 AND 39 THEN '30-39'
		WHEN age BETWEEN 40 AND 49 THEN '40-49'
		ELSE '50 and Above'
	END AS age_groups,
	lifespan_months,
	CASE 
		WHEN lifespan_months >= 12 AND total_sales > 5000 THEN 'VIP'
		WHEN lifespan_months >= 12 AND total_sales <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment,
	last_order_date,
	DATEDIFF(month, last_order_date, GETDATE()) AS recency,
	total_orders,
	total_products,
	total_quantity,
	total_sales,
	CASE	
		WHEN total_sales = 0 THEN 0
		ELSE total_sales / total_orders
	END AS avg_order_value,
	CASE	
		WHEN lifespan_months = 0 THEN total_sales
		ELSE total_sales / lifespan_months
	END AS avg_monthly_spend
FROM customer_aggregation