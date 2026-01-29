-- =====================================================
-- Tutorial 1: SQL Basics
-- -----------------------------------------------------
-- Goal:
-- Learn how to SELECT data, filter rows,
-- count records, and group results.
--
-- Tables used:
-- - users
-- =====================================================


-- -----------------------------------------------------
-- 1. Explore the users table
-- -----------------------------------------------------

-- View a few rows to understand the structure
SELECT *
FROM users
LIMIT 5;


-- -----------------------------------------------------
-- 2. Count total users
-- -----------------------------------------------------

-- How many users have signed up in total?
SELECT COUNT(*) AS total_users
FROM users;


-- -----------------------------------------------------
-- 3. Filter users by country
-- -----------------------------------------------------

-- How many users are based in the US?
SELECT COUNT(*) AS us_users
FROM users
WHERE country = 'US';


-- -----------------------------------------------------
-- 4. Filter users by signup date
-- -----------------------------------------------------

-- How many users signed up in the last 30 days?
SELECT COUNT(*) AS users_last_30_days
FROM users
WHERE signup_date >= CURRENT_DATE - INTERVAL '30 days';


-- -----------------------------------------------------
-- 5. Group users by country
-- -----------------------------------------------------

-- How many users are there per country?
SELECT
  country,
  COUNT(*) AS users
FROM users
GROUP BY country
ORDER BY users DESC;


-- -----------------------------------------------------
-- 6. Group users by signup date
-- -----------------------------------------------------

-- How many users signed up each day?
SELECT
  signup_date,
  COUNT(*) AS users
FROM users
GROUP BY signup_date
ORDER BY signup_date DESC;


-- -----------------------------------------------------
-- 7. Combine filtering and grouping
-- -----------------------------------------------------

-- Daily signups in the last 30 days
SELECT
  signup_date,
  COUNT(*) AS users
FROM users
WHERE signup_date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY signup_date
ORDER BY signup_date;
