USE walmart_sales;

-- ============================================
-- 01 DATA VALIDATION
-- Walmart Sales Analytics
-- ============================================

-- 1. Total number of records
-- Result: 421,570 records
SELECT COUNT(*) AS total_records
FROM walmart_train;


-- 2. Date range
-- Result: Data covers 2010-02-05 to 2012-10-26.
-- The dataset contains 3 years of data.
-- Note: 2012 is a partial year.
SELECT
    MIN(Date) AS start_date,
    MAX(Date) AS end_date,
    COUNT(DISTINCT YEAR(Date)) AS total_years
FROM walmart_train;

-- 3. Check for missing values
-- Result: No missing values found in Store, Dept, Date,
-- Weekly_Sales, or IsHoliday.
SELECT
	SUM(store IS NULL) AS missing_stores,
    SUM(dept IS NULL) AS missing_department,
    SUM(date IS NULL) AS missing_date,
    SUM(weekly_sales IS NULL) AS missing_sales,
    SUM(isholiday IS NULL) AS missing_holiday
FROM walmart_train;

-- 4. Check for duplicate rows
-- Result: No exact duplicate rows found.
SELECT 
	store,
    dept,
    date,
    weekly_sales,
    isholiday,
    COUNT(*) AS duplicate_count
FROM walmart_train
GROUP BY
	store,
    dept,
    date,
    weekly_sales,
    isholiday
HAVING COUNT(*) > 1;

-- 5. Check negative sales
-- Result: 1,285 records, totaling -$88,161.56
-- Negative values are retained because their business meaning
-- has not been established.

SELECT 
	COUNT(*) AS negative_sales_records,
    ROUND(SUM(weekly_sales),2) AS negative_sales_amount
FROM walmart_train
WHERE weekly_sales<0;

-- 6. Check zero sales
-- Result: 73 records
-- Zero sales are retained because they may represent
-- valid business activity.
SELECT 
	COUNT(*) AS zero_sales_records
FROM walmart_train
WHERE weekly_sales=0;

-- 7. Check number of stores
-- Result: 45 Stores

SELECT
    COUNT(DISTINCT Store) AS total_stores
FROM walmart_train;


-- 8. Check number of departments
-- Result: 81 Departments
SELECT
    COUNT(DISTINCT Dept) AS total_departments
FROM walmart_train;
    