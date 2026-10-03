USE walmart_sales;

-- ============================================
-- 03 STORE ANALYSIS
-- Walmart Sales Analytics
-- ============================================

-- Top 10 Stores by Total Sales
-- Store 20 recorded the highest total sales at approximately $301.4M,
-- followed closely by Store 4 at approximately $299.5M.
-- Top-performing stores also show relatively high average weekly sales.
-- Record counts are broadly similar across the top stores.
 SELECT
    Store,
    ROUND(SUM(Weekly_Sales),2) AS total_sales,
    ROUND(AVG(Weekly_Sales),2) AS average_weekly_sales,
    COUNT(*) AS total_records
FROM walmart_train
GROUP BY Store
ORDER BY total_sales DESC
LIMIT 10;

-- Sales by Store Type
-- Type A stores recorded the highest total sales
-- and the highest average weekly sales.
-- Type C stores recorded the lowest total sales
-- and lowest average weekly sales.
-- Store types also differ in the number of stores and records,
-- so total sales should be interpreted alongside average sales.
SELECT
    s.Type,
    COUNT(DISTINCT s.Store) AS total_stores,
    ROUND(SUM(w.Weekly_Sales),2) AS total_sales,
    ROUND(AVG(w.Weekly_Sales),2) AS average_weekly_sales,
    COUNT(*) AS total_records
FROM walmart_train w
JOIN walmart_stores s
    ON w.Store = s.Store
GROUP BY s.Type
ORDER BY total_sales DESC;

-- Store Size vs Total Sales
-- Larger stores generally show higher sales,
-- but store size alone does not fully explain sales differences.
-- For example, Stores 33 and 42 have the same listed size
-- (39,690) but substantially different total sales.
-- Other factors such as store type, location, department mix,
-- and time-related patterns may also contribute to sales differences.
SELECT
    s.Store,
    s.Type,
    s.Size,
    ROUND(SUM(w.Weekly_Sales), 2) AS total_sales,
    ROUND(AVG(w.Weekly_Sales), 2) AS average_weekly_sales
FROM walmart_train w
JOIN walmart_stores s
    ON w.Store = s.Store
GROUP BY
    s.Store,
    s.Type,
    s.Size
ORDER BY
    s.Size DESC;
    
    
-- Top 10 Stores by YoY Growth in 2011
-- Store 38 recorded the highest YoY growth at 20.21%,
-- increasing sales from approximately $16.59M in 2010
-- to $19.94M in 2011.
-- Store 7 followed closely with 19.93% growth.
-- Stores 4, 41, and 39 also recorded strong growth
-- above 15%.
-- All 10 selected stores experienced positive YoY growth in 2011.
-- The results highlight stores with notable year-over-year
-- improvements in sales performance.

WITH store_yearly_sales AS (
    SELECT
        YEAR(Date) AS year,
        Store,
        SUM(Weekly_Sales) AS total_sales
    FROM walmart_train
    GROUP BY
        YEAR(Date),
        Store
),

store_growth AS (
    SELECT
        year,
        Store,
        total_sales,
        LAG(total_sales) OVER (
            PARTITION BY Store
            ORDER BY year
        ) AS previous_year_sales
    FROM store_yearly_sales
)

SELECT
    Store,
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
FROM store_growth
WHERE year = 2011
ORDER BY yoy_growth_pct DESC
LIMIT 10;

-- Bottom 10 Stores by YoY Growth in 2011
-- Store 35 recorded the largest decline at -15.54%,
-- with sales decreasing from approximately $52.20M in 2010
-- to $44.09M in 2011.
-- Store 36 also experienced a notable decline of 10.31%.
-- Store 18 declined slightly by 3.15%.
-- The remaining seven stores recorded positive but relatively
-- modest growth ranging from 0.60% to 3.12%.
-- The results show that store-level performance varied considerably
-- across locations during 2011.
WITH store_yearly_sales AS (
    SELECT
        YEAR(Date) AS year,
        Store,
        SUM(Weekly_Sales) AS total_sales
    FROM walmart_train
    GROUP BY
        YEAR(Date),
        Store
),

store_growth AS (
    SELECT
        year,
        Store,
        total_sales,
        LAG(total_sales) OVER (
            PARTITION BY Store
            ORDER BY year
        ) AS previous_year_sales
    FROM store_yearly_sales
)

SELECT
    Store,
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
FROM store_growth
WHERE year = 2011
ORDER BY yoy_growth_pct ASC
LIMIT 10;