-- ============================================
-- 00 DATABASE SETUP
-- Walmart Sales Analytics
-- ============================================

CREATE DATABASE IF NOT EXISTS walmart_sales;
USE walmart_sales;

-- Main historical sales table
CREATE TABLE IF NOT EXISTS walmart_train (
    Store INT,
    Dept INT,
    Date DATE,
    Weekly_Sales DECIMAL(15,2),
    IsHoliday BOOLEAN
);

-- Store information table
CREATE TABLE IF NOT EXISTS walmart_stores (
    Store INT,
    Type VARCHAR(5),
    Size INT
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.4/Uploads/walmart_train.csv'
INTO TABLE walmart_train
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.4/Uploads/walmart_stores.csv'
INTO TABLE walmart_stores
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

SELECT COUNT(*) AS total_rows
FROM walmart_train;

SELECT COUNT(*) AS total_rows
FROM walmart_stores;




