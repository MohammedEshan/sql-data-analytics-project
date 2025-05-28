/*
===============================================================================
Product Report
===============================================================================
Purpose:
    - This Report Consolidates Key Product Metrics And Behaviors.

Highlights:
    1. Gathers Essential Fields Such As Product Name, Category, Subcategory, And Cost.
    2. Segments Products By Revenue To Identify High-Performers, Mid-Range, Or Low-Performers.
    3. Aggregates Product-Level Metrics:
       - Total Orders
       - Total Sales
       - Total Quantity Sold
       - Total Customers (Unique)
       - Lifespan (In Months)
    4. Calculates Valuable KPIs:
       - Recency (Months Since Last Sale)
       - Average Order Revenue (AOR)
       - Average Monthly Revenue
===============================================================================
*/
-- =============================================================================
-- Create Report: gold.report_products
-- =============================================================================
IF OBJECT_ID('gold.report_products', 'V') IS NOT NULL
    DROP VIEW gold.report_products;
GO

CREATE VIEW gold.report_products AS 
WITH base_query AS (
/*---------------------------------------------------------------------------
1) Base Query: Retrieves core columns from fact_sales and dim_products
---------------------------------------------------------------------------*/
SELECT
	f.order_number,
	f.order_date,
	f.customer_key,
	f.sales_amount,
	f.price,
	f.quantity,
	p.category,
	p.subcategory,
	p.product_key,
	p.product_name,
	p.cost
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS P
ON f.product_key = p.product_key
),
product_aggregation AS (
/*---------------------------------------------------------------------------
2) Product Aggregations: Summarizes key metrics at the product level
---------------------------------------------------------------------------*/
SELECT
	product_key,
	category,
	subcategory,
	product_name,
	cost,
	COUNT(DISTINCT order_number) AS total_orders,
	SUM(sales_amount) AS total_sales,
	SUM(quantity) AS quantity_sold,
	COUNT(DISTINCT customer_key) AS total_customers,
	MAX(order_date) AS last_order_date,
	DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS lifespan_month,
	ROUND(AVG(CAST(sales_amount AS FLOAT) / NULLIF(quantity,0)),1) AS avg_selling_price
FROM base_query
GROUP BY 
	product_key,
	category,
	subcategory,
	product_name,
	cost
)
/*---------------------------------------------------------------------------
  3) Final Query: Combines all product results into one output
---------------------------------------------------------------------------*/
SELECT
	product_key,
	category,
	subcategory,
	product_name,
	cost,
	total_customers,
	total_orders,
	quantity_sold,
	total_sales,
	last_order_date,
	lifespan_month,
	DATEDIFF(MONTH, last_order_date, GETDATE()) AS recency_in_months,
	CASE
		WHEN total_sales > 50000 THEN 'High-Performer'
		WHEN total_sales >= 10000 THEN 'Mid-Range'
		ELSE 'Low-Performer'
	END AS product_segment,
	avg_selling_price,
		-- Average Order Revenue (AOR)
	CASE 
		WHEN total_orders = 0 THEN 0
		ELSE total_sales / total_orders
	END AS avg_order_revenue,

	-- Average Monthly Revenue
	CASE
		WHEN lifespan_month = 0 THEN total_sales
		ELSE total_sales / lifespan_month
	END AS avg_monthly_revenue
FROM product_aggregation
