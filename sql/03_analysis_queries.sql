-- ============================================================
-- 03_analysis_queries.sql
-- Nigeria Telecom Subscriber & Data Usage Trend Analysis
-- Source: NCC (Nigerian Communications Commission)
-- Dataset scope: January 2020 - December 2025
--
-- These queries use only basic SQL (SELECT, WHERE, GROUP BY,
-- JOIN, simple aggregates). Trend charts use one data point
-- per YEAR (6 points: 2020-2025) instead of one per month (72
-- points), for cleaner, uncluttered charts in Power BI.
--
-- Two different year-based approaches are used, depending on
-- what kind of metric is involved:
--   - "Snapshot" metrics (subscribers, teledensity, broadband)
--     use the DECEMBER value for each year, since these measure
--     "how many exist right now" - summing them across 12
--     months would double-count the same subscribers/lines
--     repeatedly and produce a meaningless number.
--   - "Flow" metrics (internet data usage) are genuinely
--     additive, so these use SUM() across the year to show
--     total usage, which is a real, meaningful figure.
-- ============================================================

USE nigeria_telecom;


-- ============================================================
-- NOTE ON SCOPE
-- This analysis is scoped to GSM mobile operators (Airtel,
-- Globacom, MTN, T2, and legacy VITEL/Visafone), matching
-- NCC's own "Sub-Total (GSM)" reporting category. Where
-- operator-level sums do not fully reconcile with NCC's
-- reported_total figures, this is due to (a) non-reporting by
-- specific operators in specific months, and (b) NCC's totals
-- spanning segments beyond core GSM operators. See the
-- reconciliation query near the end of this file.
-- ============================================================


-- ============================================================
-- Q1: How has Nigeria's telecom subscriber base changed over time?
-- Shows total subscribers at the END of each year (December's
-- value) - a snapshot metric, not summed across the year.
-- ============================================================
SELECT
    YEAR(month_year) AS year,
    total_subscribers
FROM overall_subscribers
WHERE MONTH(month_year) = 12
ORDER BY year;


-- ============================================================
-- Q2: How has Nigeria's teledensity changed over time?
-- Shows teledensity at the END of each year (December's value).
-- ============================================================
SELECT
    YEAR(month_year) AS year,
    teledensity_pct
FROM overall_subscribers
WHERE MONTH(month_year) = 12
ORDER BY year;


-- ============================================================
-- Q3a: Which operators have the largest subscriber base, and
-- how has market share changed over time?
-- Shows each operator's subscriber count at the END of each
-- year. In Power BI, feeding this into a 100% Stacked Column
-- chart automatically converts these into % market share.
-- ============================================================
SELECT
    YEAR(month_year) AS year,
    operator_name,
    gsm_subscribers
FROM gsm_subs_operator_data
WHERE MONTH(month_year) = 12
ORDER BY year, operator_name;


-- ============================================================
-- Q3b: Who is the current market leader?
-- Finds the most recent month in the data, then shows each
-- operator's subscriber count for that month only, largest
-- first - answers "who is #1 right now."
-- ============================================================
SELECT
    operator_name,
    gsm_subscribers
FROM gsm_subs_operator_data
WHERE month_year = (SELECT MAX(month_year) FROM gsm_subs_operator_data)
ORDER BY gsm_subscribers DESC;


-- ============================================================
-- Q4a: How has internet subscriber adoption changed over time?
-- Shows total internet subscribers (summed across operators)
-- at the END of each year - a snapshot metric.
-- ============================================================
SELECT
    YEAR(month_year) AS year,
    SUM(internet_subscribers) AS total_internet_subscribers
FROM gsm_internet_subs_operator_data
WHERE MONTH(month_year) = 12
GROUP BY YEAR(month_year)
ORDER BY year;


-- ============================================================
-- Q4b: How has broadband adoption/penetration changed over time?
-- Shows broadband subscriptions and penetration % at the END
-- of each year.
-- ============================================================
SELECT
    YEAR(month_year) AS year,
    broadband_subscriptions,
    penetration_pct
FROM broadband_penetration
WHERE MONTH(month_year) = 12
ORDER BY year;


-- ============================================================
-- Q5a: How is Nigeria transitioning from 2G/3G toward 4G/5G?
-- Shows each technology's share (%) at the END of each year.
-- NOTE: covers 2023-2025 only (3 data points), since this
-- table only has data from May 2023 onward.
-- ============================================================
SELECT
    YEAR(month_year) AS year,
    technology,
    share_pct
FROM technology_market_share
WHERE MONTH(month_year) = 12
ORDER BY year, technology;


-- ============================================================
-- Q5b: 5G adoption on its own
-- Same table, filtered to just one technology - useful for a
-- standalone "5G Adoption Trend" chart in Power BI.
-- ============================================================
SELECT
    YEAR(month_year) AS year,
    share_pct AS pct_5g
FROM technology_market_share
WHERE technology = '5G' AND MONTH(month_year) = 12
ORDER BY year;


-- ============================================================
-- Q6: How has Nigeria's internet data usage changed over time?
-- Data usage is a genuinely additive (flow) metric, so this
-- SUMs all 12 months' usage to show total terabytes consumed
-- in each year - not a December snapshot.
-- ============================================================
SELECT
    YEAR(month_year) AS year,
    SUM(internet_data_usage_tb) AS total_data_usage_tb
FROM internet_usage
GROUP BY YEAR(month_year)
ORDER BY year;


-- ============================================================
-- BONUS: Reporting completeness by month
-- Kept at monthly granularity deliberately - this query is
-- about spotting which specific months had gaps in reporting,
-- which a yearly view would hide.
-- ============================================================
SELECT
    month_year,
    COUNT(DISTINCT operator_name) AS operators_reporting
FROM gsm_subs_operator_data
GROUP BY month_year
ORDER BY month_year;


-- ============================================================
-- BONUS: Reconciliation check - GSM operator sum vs NCC's
-- official reported_total
-- Kept at monthly granularity, for the same reason as above -
-- the gap itself is a month-by-month phenomenon worth seeing
-- in detail, not smoothed into a yearly figure.
-- ============================================================
SELECT
    g.month_year,
    SUM(g.gsm_subscribers) AS sum_of_reported_operators,
    r.reported_total,
    r.reported_total - SUM(g.gsm_subscribers) AS gap
FROM gsm_subs_operator_data g
JOIN gsm_reported_total r ON r.month_year = g.month_year
GROUP BY g.month_year, r.reported_total
ORDER BY g.month_year;


-- ============================================================
-- BONUS: Same reconciliation check, for internet subscribers
-- ============================================================
SELECT
    g.month_year,
    SUM(g.internet_subscribers) AS sum_of_reported_operators,
    r.reported_total,
    r.reported_total - SUM(g.internet_subscribers) AS gap
FROM gsm_internet_subs_operator_data g
JOIN internet_reported_total r ON r.month_year = g.month_year
GROUP BY g.month_year, r.reported_total
ORDER BY g.month_year;