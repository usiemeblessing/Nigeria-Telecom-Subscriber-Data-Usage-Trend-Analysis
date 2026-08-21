-- ============================================================
-- 02_data_import.sql
-- Nigeria Telecom Subscriber & Data Usage Trend Analysis
-- Loads all cleaned, 2020-2025 trimmed CSVs into their
-- matching tables.
--
-- Replace the folder path below with the value returned by:
--   SHOW VARIABLES LIKE 'secure_file_priv';
-- CSVs must be copied into that exact folder before running.
-- ============================================================

USE nigeria_telecom;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/overall_subscribers.csv'
INTO TABLE overall_subscribers
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Verification: expected 72 rows (Jan 2020 - Dec 2025, monthly)
SELECT COUNT(*) FROM overall_subscribers;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/gsm_subs_operator_data.csv'
INTO TABLE gsm_subs_operator_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Verification: expected 290 rows (72 months x ~4 operators reporting on average)
SELECT COUNT(*) FROM gsm_subs_operator_data;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/gsm_subs_reported_total.csv'
INTO TABLE gsm_reported_total
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Verification: expected 72 rows
SELECT COUNT(*) FROM gsm_reported_total;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/gsm_internet_subs_operator_data.csv'
INTO TABLE gsm_internet_subs_operator_data
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Verification: expected 290 rows
SELECT COUNT(*) FROM gsm_internet_subs_operator_data;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/gsm_internet_subs_reported_total.csv'
INTO TABLE internet_reported_total
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Verification: expected 72 rows
SELECT COUNT(*) FROM internet_reported_total;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/broadband_penetration.csv'
INTO TABLE broadband_penetration
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Verification: expected 72 rows
SELECT COUNT(*) FROM broadband_penetration;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/internet_usage_tb.csv'
INTO TABLE internet_usage
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Verification: expected 36 rows (source only has data from 2023 onward)
SELECT COUNT(*) FROM internet_usage;


LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/technology_market_share.csv'
INTO TABLE technology_market_share
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

-- Verification: expected 128 rows (32 months x 4 technologies, May 2023 - Dec 2025)
SELECT COUNT(*) FROM technology_market_share;