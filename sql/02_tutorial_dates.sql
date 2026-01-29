-- =====================================================
-- Tutorial 2: Working with Dates
-- -----------------------------------------------------
-- Goal:
-- Learn how to work with time-based data to answer
-- product questions around trends, cohorts, and recency.
--
-- Tables used:
-- - users
-- - subscriptions
-- =====================================================


-- -----------------------------------------------------
-- 1. Inspect date fields
-- -----------------------------------------------------

-- Look at signup dates
SELECT
  signup_date
FROM users
ORDER BY signup_date DESC
LIMIT 10;


-- -----------------------------------------------------
-- 2. Users by signup week
-- -----------------------------------------------------
-- This is often the first step toward cohort analysis

SELECT
  DATE_TRUNC('week', signup_date) AS signup_week,
  COUNT(*) AS users
FROM users
GROUP BY signup_week
ORDER BY signup_week;


-- -----------------------------------------------------
-- 3. Users by signup month
-- -----------------------------------------------------

SELECT
  DATE_TRUNC('month', signup_date) AS signup_month,
  COUNT(*) AS users
FROM users
GROUP BY signup_month
ORDER BY signup_month;


-- -----------------------------------------------------
-- 4. Recent signups (rolling window)
-- -----------------------------------------------------

-- Users who signed up in the last 7 days
SELECT COUNT(*) AS users_last_7_days
FROM users
WHERE signup_date >= CURRENT_DATE - INTERVAL '7 days';


-- Users who signed up in the last 30 days
SELECT COUNT(*) AS users_last_30_days
FROM users
WHERE signup_date >= CURRENT_DATE - INTERVAL '30 days';


-- -----------------------------------------------------
-- 5. Active vs churned subscriptions
-- -----------------------------------------------------

-- Active subscriptions (no end_date)
SELECT COUNT(*) AS active_subscriptions
FROM subscriptions
WHERE end_date IS NULL;


-- Churned subscriptions
SELECT COUNT(*) AS churned_subscriptions
FROM subscriptions
WHERE end_date IS NOT NULL;


-- -----------------------------------------------------
-- 6. Time to churn
-- -----------------------------------------------------
-- How long did churned users stay subscribed?

SELECT
  (end_date - start_date) AS days_active
FROM subscriptions
WHERE end_date IS NOT NULL
ORDER BY days_active DESC
LIMIT 10;


-- -----------------------------------------------------
-- 7. Average time to churn
-- -----------------------------------------------------

SELECT
  AVG(end_date - start_date) AS avg_days_active
FROM subscriptions
WHERE end_date IS NOT NULL;


-- -----------------------------------------------------
-- 8. Churn by signup week
-- -----------------------------------------------------
-- This starts to reveal cohort behaviour

SELECT
  DATE_TRUNC('week', u.signup_date) AS signup_week,
  COUNT(s.id) AS churned_subscriptions
FROM users u
JOIN subscriptions s ON u.id = s.user_id
WHERE s.end_date IS NOT NULL
GROUP BY signup_week
ORDER BY signup_week;
