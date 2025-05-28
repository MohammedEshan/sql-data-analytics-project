/*
===============================================================================
Part-To-Whole Analysis
===============================================================================
Purpose:
    - To Compare Performance Or Metrics Across Dimensions Or Time Periods.
    - To Evaluate Differences Between Categories.
    - Useful For A/B Testing Or Regional Comparisons.

SQL Functions Used:
    - SUM(), AVG(): Aggregates Values For Comparison.
    - Window Functions: SUM() OVER() For Total Calculations.
===============================================================================
*/



-- Which Categories Contribute the Most to Overall Sales

WITH Sales_Category AS 
(
	SELECT 
		p.category,
		SUM(F.sales_amount) AS total_sales
	FROM Gold.fact_sales AS f
	LEFT JOIN Gold.dim_products AS p
	ON f.product_key = p.product_key
	GROUP BY p.category
)
SELECT
	category,
	total_sales,
	SUM(total_sales) OVER() AS overall_sales,
	CONCAT(ROUND((CAST(total_sales AS FLOAT)/SUM(total_sales) OVER()) * 100,2),'%') AS percent_of_total
FROM Sales_Category
ORDER BY total_sales DESC
