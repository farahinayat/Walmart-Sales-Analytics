USE walmart_sales;

-- ============================================
-- 04 DEPARTMENT ANALYSIS
-- Walmart Sales Analytics
-- ============================================

-- Sales by Department
-- Department 92 recorded the highest total sales at approximately $483.94M,
-- followed by Department 95 at approximately $449.32M.
-- Department-level sales vary substantially across the dataset.
-- Record counts also differ between departments, so total sales
-- should be interpreted alongside average weekly sales.
-- Some departments contain negative total sales, reflecting
-- negative sales records identified during data validation.
SELECT 
	dept,
    COUNT(*) AS total_records,
    ROUND(SUM(weekly_sales),2) AS total_sales,
    ROUND(AVG(weekly_sales),2) AS average_weekly_sales
FROM walmart_train
GROUP BY dept
ORDER BY total_sales DESC;

-- Top 10 Departments by Average Weekly Sales
-- Departments 92, 95, and 38 have the highest average weekly sales.
-- Department 65 ranks highly by average weekly sales despite having
-- only 143 records, resulting in much lower total sales.
-- This demonstrates why both total sales and average weekly sales
-- should be considered when evaluating department performance.
SELECT
    Dept,
    COUNT(*) AS records,
    ROUND(SUM(Weekly_Sales), 2) AS total_sales,
    ROUND(AVG(Weekly_Sales), 2) AS average_weekly_sales
FROM walmart_train
GROUP BY Dept
ORDER BY average_weekly_sales DESC
LIMIT 10;

-- Department Sales Ranking
-- Departments were ranked by total sales using RANK().
-- Department 92 ranked first with approximately $483.94M in sales.
-- Department 65 illustrates the difference between average performance
-- and total contribution: it ranked highly by average weekly sales
-- but ranked 67th by total sales because it has relatively few records.
-- Department 47 had negative total sales, consistent with negative
-- sales records identified during data validation.
WITH department_sales AS (
	SELECT
		dept,
        ROUND(SUM(weekly_sales),2) AS total_sales
	FROM walmart_train
    GROUP BY dept
)

SELECT 
	dept,
    total_sales,
    RANK() OVER(
		ORDER BY total_sales DESC
	) AS sales_rank
FROM department_sales
ORDER BY sales_rank;

-- Top 3 Departments Within Each Store
-- Department performance varies across stores.
-- Departments 92, 95, and 38 frequently appear among
-- the top-performing departments, but some stores have
-- different leading departments such as 72 or 2.
-- Store-level department rankings can therefore help identify
-- differences in sales mix across locations.
WITH store_department_sales AS(
	SELECT
		store,
        dept,
        SUM(weekly_sales) AS total_sales
	FROM walmart_train
    GROUP BY
		store,
        dept
),

ranked_departments AS(
	SELECT
		store,
        dept,
        total_sales,
        RANK() OVER(
        PARTITION BY store
        ORDER BY total_sales DESC
	) AS department_rank
	FROM store_department_sales
)

SELECT 
	store,
    dept,
    ROUND(total_sales,2) AS total_sales,
    department_rank
FROM ranked_departments
WHERE department_rank <=3
ORDER BY
	store,
    department_rank;
    
-- Department Sales by Year
-- Department 92, 95, and 38 were consistently among the
-- largest contributors to total sales across the years.
-- Many departments recorded higher sales in 2011 than in 2010.
-- 2012 generally shows lower totals, but the year is incomplete
-- because the dataset ends on 2012-10-26.
-- Department 65 demonstrates that high average weekly sales
-- do not necessarily result in high total sales when record counts
-- are relatively low.
SELECT
	YEAR(date) AS year,
    dept,
    ROUND(SUM(weekly_sales),2) AS total_sales,
    ROUND(AVG(weekly_sales),2) AS average_weekly_sales
FROM walmart_train
GROUP BY
	YEAR(date),
    dept
ORDER BY 
	year,
	total_sales DESC;
    
-- Department Sales by Year & YoY Growth
-- Several major departments recorded sales growth in 2011 compared with 2010.
-- Department 92 increased by 13.24%, while Department 38 increased by 11.18%.
-- Many departments recorded lower sales in 2012 compared with 2011.
-- Department 72 showed a notable decline of 30.11% in 2012.
-- 2012 is a partial year ending on 2012-10-26, so its YoY declines
-- should not be interpreted as full-year performance.
-- Very small departments can show unusually large percentage changes
-- because their previous-year sales values are small.
WITH department_yearly_sales AS(
	SELECT 
		YEAR(date) AS year,
        dept,
        SUM(weekly_sales) AS total_sales
	FROM walmart_train
    GROUP BY 
		YEAR(date),
		dept
),

department_growth AS (
	SELECT
		year,
        dept,
        total_sales,
        LAG(total_sales) OVER(
        PARTITION BY dept
        ORDER BY year
        ) AS previous_year_sales
	FROM department_yearly_sales
)

SELECT
	year,
    dept,
    ROUND(total_sales,2) AS total_sales,
    ROUND(
		total_sales-previous_year_sales,
        2) AS yoy_change,
	ROUND(
		(total_sales-previous_year_sales)
        /NULLIF(previous_year_sales,0)*100,
        2
        ) AS yoy_growth_pct
        FROM department_growth
        ORDER BY 
			dept,
            year;
   
-- Top 10 Departments by YoY Growth in 2011
-- Department 87 recorded the highest YoY growth at 22.74%,
-- increasing sales from approximately $25.40M in 2010 to $31.18M in 2011.
-- Departments 82 and 41 also recorded strong growth of 17.90% and 17.11%.
-- Major departments such as 90, 92, and 38 increased sales by
-- 15.57%, 13.24%, and 11.18%, respectively.
-- The results show positive sales growth across all 10 selected departments.
-- Departments were filtered to those with more than $1M in 2010 sales
-- to reduce the impact of unusually large percentage changes from small bases.
WITH department_yearly_sales AS (
    SELECT
        YEAR(Date) AS year,
        Dept,
        SUM(Weekly_Sales) AS total_sales
    FROM walmart_train
    GROUP BY
        YEAR(Date),
        Dept
),

department_growth AS (
    SELECT
        year,
        Dept,
        total_sales,
        LAG(total_sales) OVER (
            PARTITION BY Dept
            ORDER BY year
        ) AS previous_year_sales
    FROM department_yearly_sales
)

SELECT
    Dept,
    ROUND(previous_year_sales, 2) AS sales_2010,
    ROUND(total_sales, 2) AS sales_2011,
    ROUND(
        total_sales - previous_year_sales, 2
    ) AS yoy_change,
    ROUND(
        (total_sales - previous_year_sales)
        / NULLIF(previous_year_sales, 0) * 100,
        2
    ) AS yoy_growth_pct
FROM department_growth
WHERE year = 2011
  AND previous_year_sales > 1000000
ORDER BY yoy_growth_pct DESC
LIMIT 10;

-- Bottom 10 Departments by YoY Growth in 2011
-- Department 59 recorded the largest decline at -48.12%,
-- decreasing from approximately $2.53M in 2010 to $1.31M in 2011.
-- Department 6 declined by 18.54%, followed by Department 58 at 14.40%.
-- Departments 65, 55, 16, 28, 21, 85, and 5 recorded smaller declines.
-- All 10 selected departments experienced negative YoY growth in 2011.
-- Departments were filtered to those with more than $1M in 2010 sales
-- to reduce the impact of unusually large percentage changes from small bases.
WITH department_yearly_sales AS(
	SELECT 
		YEAR(date) AS year,
		dept,
        SUM(weekly_sales) AS total_sales
	FROM walmart_train
    GROUP BY 
		Year(date),
        dept
),

department_growth AS(
	SELECT 
		year,
        dept,
        total_sales,
        LAG(total_sales) OVER(
        PARTITION BY dept
        ORDER BY year
        ) AS previous_year_sales
	FROM department_yearly_sales
    )
    
    SELECT
		dept,
        ROUND(previous_year_sales,2) AS sales_2010,
		ROUND(total_sales,2) AS sales_2011,
        ROUND(
			total_sales-previous_year_sales,2
            ) AS yoy_change,
		ROUND(
			(total_sales-previous_year_sales)
            /NULLIF(previous_year_sales,0)*100,
            2) AS yoy_growth_pct
	FROM department_growth
    WHERE year=2011
		AND previous_year_sales > 1000000
	ORDER BY yoy_growth_pct ASC
    LIMIT 10;

        
        
        
    