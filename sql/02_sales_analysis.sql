USE walmart_sales;

-- ============================================
-- 02 SALES ANALYSIS
-- Walmart Sales Analytics
-- ============================================

-- Overall Sales KPIs
-- 421,570 records
-- Total sales: $6.74B
-- Average weekly sales: $15,981.26
-- Minimum weekly sales: -$4,988.94
-- Maximum weekly sales: $693,099.36

SELECT
    COUNT(*) AS total_records,
    ROUND(SUM(Weekly_Sales), 2) AS total_sales,
    ROUND(AVG(Weekly_Sales), 2) AS average_weekly_sales,
    ROUND(MIN(Weekly_Sales), 2) AS minimum_sales,
    ROUND(MAX(Weekly_Sales), 2) AS maximum_sales
FROM walmart_train;

-- Yearly Sales Analysis
-- 2011 total sales increased by approximately 6.96% compared with 2010.
-- Average weekly sales decreased slightly from 2010 to 2011.
-- 2012 is a partial year (data ends on 2012-10-26),
-- so its total sales should not be directly compared
-- with complete-year totals.

SELECT
    YEAR(Date) AS year,
    COUNT(*) AS records,
    ROUND(SUM(Weekly_Sales), 2) AS total_sales,
    ROUND(AVG(Weekly_Sales), 2) AS average_weekly_sales
FROM walmart_train
GROUP BY YEAR(Date)
ORDER BY year;

-- Year-over-Year Sales Growth
-- 2011 sales increased by 6.96% compared with 2010.
-- 2012 shows an apparent 18.30% decline versus 2011,
-- but 2012 is a partial year ending on 2012-10-26.
-- Therefore, the 2012 YoY figure should not be interpreted
-- as a full-year sales decline.

WITH yearly_sales AS (
    SELECT
        YEAR(Date) AS year,
        SUM(Weekly_Sales) AS total_sales
    FROM walmart_train
    GROUP BY YEAR(Date)
)

SELECT
    year,
    ROUND(total_sales, 2) AS total_sales,
    ROUND(
        total_sales - LAG(total_sales) OVER (ORDER BY year),
        2
    ) AS yoy_change,
    ROUND(
        (
            total_sales - LAG(total_sales) OVER (ORDER BY year)
        )
        / LAG(total_sales) OVER (ORDER BY year) * 100,
        2
    ) AS yoy_growth_pct
FROM yearly_sales
ORDER BY year;

-- Monthly Sales Analysis
-- Monthly sales show noticeable variation across the year.
-- December recorded approximately $288.76M in 2010
-- and $288.08M in 2011.
-- 2012 is incomplete and ends in October, so November
-- and December comparisons are unavailable.
SELECT 
	YEAR(date) AS year,
    MONTH(date) AS month,
    MONTHNAME(date) AS month_name,
    ROUND(SUM(weekly_sales),2) AS total_sales
FROM walmart_train
GROUP BY 
	YEAR(date),
	MONTH(date),
    MONTHNAME(date)
ORDER BY
	year,
    month;

-- Highest Sales Month by Year
-- December was the highest-sales month in both 2010 and 2011.
-- June was the highest observed month in 2012,
-- but 2012 is incomplete and excludes November and December.    
With monthly_sales AS (
	SELECT 
	YEAR(date) AS year,
    MONTH(date) AS month,
    MONTHNAME(date) AS month_name,
    ROUND(SUM(weekly_sales),2) AS total_sales
FROM walmart_train
GROUP BY 
	YEAR(date),
	MONTH(date),
    MONTHNAME(date)
ORDER BY
	year,
    month
),

ranked_months AS(
	SELECT 
		year,
        month,
        month_name,
        total_sales,
        RANK() OVER(
			PARTITION BY year
            ORDER BY total_sales DESC
            ) AS sales_rank
	FROM monthly_sales
)

SELECT 
	year,
    month_name,
    ROUND(total_sales,2) AS total_sales
FROM ranked_months
WHERE sales_rank =1
ORDER BY year;

-- Holiday vs Non-Holiday Sales
-- Holiday weeks had higher average weekly sales ($17,035.82)
-- compared with non-holiday weeks ($15,901.45).
-- This represents approximately 7.13% higher average weekly sales.
-- Total holiday sales are lower because there are fewer holiday records.
-- The analysis shows an association and does not establish causation.
SELECT 
	CASE
		WHEN isholiday=1 THEN "Holiday"
        ELSE "Non-Holiday"
	END AS sales_period,
    COUNT(*) AS records,
    ROUND(SUM(weekly_sales),2) AS total_sales,
    ROUND(AVG(weekly_sales),2) AS average_weekly_sales
FROM walmart_train
GROUP BY 
	isholiday
ORDER BY
	isholiday;
   
	
