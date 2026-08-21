-- ============================================================
-- 01_schema_setup.sql
-- Nigeria Telecom Subscriber & Data Usage Trend Analysis
-- Creates the database and all tables.
-- Dataset scope: January 2020 - December 2025 (trimmed from
-- the full available history of 2012-2026 for dashboard
-- clarity and presentation).
-- ============================================================

CREATE DATABASE nigeria_telecom;
USE nigeria_telecom;

-- Overall subscriber base and teledensity, monthly
CREATE TABLE overall_subscribers (
    month_year DATE,
    total_subscribers BIGINT,
    teledensity_pct DECIMAL(5,2)
);

-- GSM subscribers by operator, monthly (long format, unpivoted from source)
CREATE TABLE gsm_subs_operator_data (
    month_year DATE,
    operator_name VARCHAR(50),
    gsm_subscribers BIGINT
);

-- NCC's officially reported GSM total per month (kept separate from
-- the operator sum since the two do not always reconcile - see notes
-- in 03_analysis_queries.sql)
CREATE TABLE gsm_reported_total (
    month_year DATE,
    reported_total BIGINT
);

-- Internet subscribers by operator, monthly (long format, unpivoted from source)
CREATE TABLE gsm_internet_subs_operator_data (
    month_year DATE,
    operator_name VARCHAR(50),
    internet_subscribers BIGINT
);

-- NCC's officially reported internet subscriber total per month
CREATE TABLE internet_reported_total (
    month_year DATE,
    reported_total BIGINT
);

-- Broadband subscriptions and penetration %, monthly
CREATE TABLE broadband_penetration (
    month_year DATE,
    broadband_subscriptions BIGINT,
    penetration_pct DECIMAL(5,2)
);

-- Internet data usage in terabytes, monthly.
-- NOTE: source data for this table only exists from 2023
-- onward, even within the 2020-2025 window - not a result of
-- trimming, but a genuine gap in the original NCC source.
CREATE TABLE internet_usage (
    month_year DATE,
    internet_data_usage_tb DECIMAL(14,2)
);

-- Network technology (2G/3G/4G/5G) market share %, monthly.
-- NOTE: this table covers May 2023 - Dec 2025 only, a narrower
-- window than the other tables. Any analysis joining this
-- table to the others will be limited to the overlapping period.
CREATE TABLE technology_market_share (
    month_year DATE,
    technology VARCHAR(10),
    share_pct DECIMAL(5,2)
);