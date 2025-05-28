/*
===============================================================================
Performance Analysis (Year-Over-Year, Month-Over-Month)
===============================================================================
Purpose:
    - To Measure The Performance Of Products, Customers, Or Regions Over Time.
    - For Benchmarking And Identifying High-Performing Entities.
    - To Track Yearly Trends And Growth.

SQL Functions Used:
    - LAG(): Accesses Data From Previous Rows.
    - AVG() OVER(): Computes Average Values Within Partitions.
    - CASE: Defines Conditional Logic For Trend Analysis.
===============================================================================
*/


-- Analyze the Yaerly Performance of Products by Comparing their sales to Both Avg Sales and Previous Sales Performance of the Year


WITH yearly_sales_performance AS
(
	SELECT 
		YEAR(order_date) AS order_year,
		product_name,
		SUM(sales_amount)  AS current_sales
	FROM Gold.fact_sales AS f
	LEFT JOIN Gold.dim_products p
	ON f.product_key = p.product_key
	WHERE order_date IS NOT NULL
	GROUP BY YEAR(order_date), product_name
)
SELECT
	order_year,
	product_name,
	current_sales,
	AVG(current_sales) OVER(PARTITION BY product_name) avg_sales,
	current_sales - AVG(current_sales) OVER(PARTITION BY product_name) AS diff_avg,
	CASE 
		WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) < 0 THEN 'Below Average'
		WHEN current_sales - AVG(current_sales) OVER(PARTITION BY product_name) > 0 THEN 'Above Average' 
		ELSE 'Average'
	END AS avg_change,
	LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) previous_year_sales,
	current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) diff_py_sales,
	CASE 
		WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) < 0 THEN 'Decrease'
		WHEN current_sales - LAG(current_sales) OVER(PARTITION BY product_name ORDER BY order_year) > 0 THEN 'Increase'
		ELSE 'No Change'
	END AS py_change
FROM yearly_sales_performance
ORDER BY product_name,order_year