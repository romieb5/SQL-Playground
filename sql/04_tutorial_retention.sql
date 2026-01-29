-- =====================================================
-- Tutorial 4: Retention & Cohort Analysis
-- -----------------------------------------------------
-- Goal:
-- Understand how long users stay active and how
-- early behaviour correlates with retention.
--
-- This tutorial introduces:
-- - cohort analysis
-- - weeks since signup
-- - behaviour-based segmentation
--
-- Tables used:
-- - users
-- - subscriptions
-- - events
-- =====================================================


-- -----------------------------------------------------
-- 1. Define user cohorts by signup week
-- -----------------------------------------------------
-- This groups users into weekly cohorts based on
-- when they first signed up.

SELECT
  DATE_TRUNC('week', signup_date) AS signup_week,
  COUNT(*) AS users
FROM users
GROUP BY signup_week
ORDER BY signup_week;


-- -----------------------------------------------------
-- 2. Join users to subscriptions
-- -----------------------------------------------------
-- This lets us reason about activity after signup.

SELECT
  u.id AS user_id,
  DATE_TRUNC('week', u.signup_date) AS signup_week,
  s.start_date,
  s.end_date
FROM users u
JOIN subscriptions s
  ON u.id = s.user_id
LIMIT 10;


-- -----------------------------------------------------
-- 3. Calculate weeks since signup
-- -----------------------------------------------------
-- We compute how many weeks have passed since signup
-- for active subscriptions.

SELECT
  DATE_TRUNC('week', u.signup_date) AS signup_week,
  FLOOR(
    (CURRENT_DATE - u.signup_date) / 7
  ) AS weeks_since_signup,
  COUNT(DISTINCT u.id) AS active_users
FROM users u
JOIN subscriptions s
  ON u.id = s.user_id
WHERE s.end_date IS NULL
GROUP BY signup_week, weeks_since_signup
ORDER BY signup_week, weeks_since_signup;


-- -----------------------------------------------------
-- 4. Retention table (cohort x weeks)
-- -----------------------------------------------------
-- This is a classic retention cohort table.
-- Each row shows how many users from a cohort
-- are still active after N weeks.

SELECT
  DATE_TRUNC('week', u.signup_date) AS signup_week,
  FLOOR(
    (CURRENT_DATE - u.signup_date) / 7
  ) AS weeks_since_signup,
  COUNT(DISTINCT u.id) AS active_users
FROM users u
JOIN subscriptions s
  ON u.id = s.user_id
WHERE s.end_date IS NULL
GROUP BY signup_week, weeks_since_signup
ORDER BY signup_week, weeks_since_signup;


-- -----------------------------------------------------
-- 5. Identify a key early behaviour
-- -----------------------------------------------------
-- For this dataset, we'll treat 'feature_use'
-- as a meaningful moment of value.

SELECT
  event_type,
  COUNT(*) AS events
FROM events
GROUP BY event_type
ORDER BY events DESC;


-- -----------------------------------------------------
-- 6. Users who reached feature_use in first 7 days
-- -----------------------------------------------------

SELECT DISTINCT
  u.id AS user_id
FROM users u
JOIN events e
  ON u.id = e.user_id
WHERE e.event_type = 'feature_use'
  AND e.event_date <= u.signup_date + INTERVAL '7 days';


-- -----------------------------------------------------
-- 7. Retention for users who reached feature_use early
-- -----------------------------------------------------

SELECT
  DATE_TRUNC('week', u.signup_date) AS signup_week,
  FLOOR(
    (CURRENT_DATE - u.signup_date) / 7
  ) AS weeks_since_signup,
  COUNT(DISTINCT u.id) AS active_users
FROM users u
JOIN subscriptions s
  ON u.id = s.user_id
WHERE s.end_date IS NULL
  AND u.id IN (
    SELECT DISTINCT
      u2.id
    FROM users u2
    JOIN events e
      ON u2.id = e.user_id
    WHERE e.event_type = 'feature_use'
      AND e.event_date <= u2.signup_date + INTERVAL '7 days'
  )
GROUP BY signup_week, weeks_since_signup
ORDER BY signup_week, weeks_since_signup;


-- -----------------------------------------------------
-- 8. Retention for users who did NOT reach feature_use
-- -----------------------------------------------------

SELECT
  DATE_TRUNC('week', u.signup_date) AS signup_week,
  FLOOR(
    (CURRENT_DATE - u.signup_date) / 7
  ) AS weeks_since_signup,
  COUNT(DISTINCT u.id) AS active_users
FROM users u
JOIN subscriptions s
  ON u.id = s.user_id
WHERE s.end_date IS NULL
  AND u.id NOT IN (
    SELECT DISTINCT
      u2.id
    FROM users u2
    JOIN events e
      ON u2.id = e.user_id
    WHERE e.event_type = 'feature_use'
      AND e.event_date <= u2.signup_date + INTERVAL '7 days'
  )
GROUP BY signup_week, weeks_since_signup
ORDER BY signup_week, weeks_since_signup;
