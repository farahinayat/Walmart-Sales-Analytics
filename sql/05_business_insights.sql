USE walmart_sales;

-- ============================================
-- 05 BUSINESS INSIGHTS
-- Walmart Sales Analytics
-- ============================================

-- This file summarizes the key business insights
-- identified from the SQL analysis.

-- 1. Overall Sales Performance
-- The dataset contains 421,570 sales records with approximately
-- $6.74B in total sales and average Weekly Sales of $15,981.26.

-- 2. Yearly Performance
-- Total sales increased by approximately 6.96% from 2010 to 2011.
-- The 2012 data ends on October 26, so 2012 totals should not be
-- directly compared with complete-year results.

-- 3. Seasonal Sales Pattern
-- Monthly sales vary throughout the year.
-- December recorded the highest monthly sales in both 2010 and 2011.

-- 4. Holiday Sales
-- Holiday weeks recorded average Weekly Sales of approximately $17,035.82,
-- compared with $15,901.45 during non-holiday weeks.
-- This represents approximately 7.13% higher average sales during
-- holiday weeks. This is an association and does not establish causation.

-- 5. Store Performance
-- Store 20 generated the highest total sales at approximately $301.4M,
-- followed closely by Store 4 at approximately $299.5M.
-- Store-level sales performance varies considerably across locations.

-- 6. Store Type Performance
-- Type A stores recorded the highest total and average Weekly Sales.
-- However, store types differ in both the number of stores and records,
-- so total sales should be interpreted alongside average sales.

-- 7. Store Size
-- Larger stores generally recorded higher sales, but store size alone
-- does not fully explain differences in store performance.

-- 8. Department Performance
-- Department 92 recorded the highest total sales at approximately $483.94M,
-- followed by Department 95 at approximately $449.32M.
-- Department performance varies substantially across the dataset.

-- 9. Department YoY Performance
-- Among departments with more than $1M in 2010 sales,
-- Department 87 recorded the highest 2011 YoY growth at 22.74%.
-- Department 59 recorded the largest decline among the bottom 10
-- departments at -48.12%.

-- 10. Store YoY Performance
-- Store 38 recorded the highest 2011 YoY growth at 20.21%.
-- Store 35 recorded the largest decline at -15.54%.

-- 11. Data Quality
-- No missing values or exact duplicate rows were found in the main
-- sales dataset. Negative and zero sales were retained because their
-- business meaning could not be confirmed as data errors.

-- Analyst Note:
-- These findings describe patterns and associations in the historical
-- Walmart dataset. They should not be interpreted as evidence of
-- causal relationships without additional analysis.