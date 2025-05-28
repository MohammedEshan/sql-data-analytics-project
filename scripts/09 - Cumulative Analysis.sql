/*
===============================================================================
Cumulative Analysis
===============================================================================
Purpose:
    - To Calculate Running Totals Or Moving Averages For Key Metrics.
    - To Track Performance Over Time Cumulatively.
    - Useful For Growth Analysis Or Identifying Long-Term Trends.

SQL Functions Used:
    - Window Functions: SUM() OVER(), AVG() OVER()
===============================================================================
*/


-- Calculate Total Sales per Month and the Running Total of Sales Over Time

SELECT
	*,
	SUM(total_sales) OVER(PARTITION BY YEAR(order_month)  ORDER BY order_month) running_total_sales,
	AVG(avg_price) OVER(PARTITION BY YEAR(order_month)  ORDER BY order_month) moving_avg_price
FROM (
	SELECT
		DATETRUNC(MONTH, order_date) AS order_month,
		SUM(sales_amount) AS total_sales,
		AVG(price) AS avg_price
	FROM Gold.fact_sales
	WHERE  order_date IS NOT NULL
	GROUP BY DATETRUNC(MONTH, order_date)
	)t
