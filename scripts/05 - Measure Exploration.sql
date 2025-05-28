/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To Calculate Aggregated Metrics (E.g., Totals, Averages) For Quick Insights.
    - To Identify Overall Trends Or Spot Anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/



-- Find the Total Sales

SELECT SUM(sales_amount) AS total_sales
FROM Gold.fact_sales

-- Find How Many Items are sold 

SELECT SUM(quantity) AS total_quantity
FROM Gold.fact_sales

-- Find the Average Selling Price

SELECT AVG(price) AS avg_sellingprice
FROM Gold.fact_sales

-- Find the Total Numbers of Orders

SELECT COUNT(DISTINCT order_number) AS total_orders
FROM Gold.fact_sales

-- Find the Total Number of Products

SELECT COUNT(product_name) AS total_no_products
FROM Gold.dim_products

-- Find the Total Number of Customers

SELECT COUNT(customer_key) AS total_no_customers
FROM Gold.dim_customers

-- Find the Number of Cutomers who has Placed an Order

SELECT COUNT(DISTINCT dc.customer_key) total_customers_orders
FROM Gold.dim_customers dc
LEFT JOIN Gold.fact_sales fs
ON dc.customer_key = fs.customer_key
WHERE fs.customer_key IS NOT NULL

-- 0r 

SELECT COUNT(DISTINCT customer_key) AS total_no_customers
FROM Gold.dim_customers


--- Generate a Report that Shows all Key Metrics of Business


SELECT 'total sales' AS measure_name, SUM(sales_amount) AS measure_value FROM Gold.fact_sales
UNION ALL
SELECT 'total quantity', SUM(quantity) FROM Gold.fact_sales
UNION ALL
SELECT 'avg selling price', AVG(price) FROM Gold.fact_sales
UNION ALL
SELECT 'total Nr. orders', COUNT(DISTINCT order_number) FROM Gold.fact_sales
UNION ALL
SELECT 'total Nr. products', COUNT(product_name) FROM Gold.dim_products
UNION ALL
SELECT 'total Nr. customers', COUNT(customer_key) FROM Gold.dim_customers