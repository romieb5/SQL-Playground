-- =====================================================
-- Solutions: SQL Practice on a Fake SaaS Dataset
-- -----------------------------------------------------
-- These queries correspond to the questions in:
-- `sql/90_exercises.sql`
-- =====================================================


-- -----------------------------------------------------
-- Section A: Basics
-- -----------------------------------------------------

-- A1) How many users are in the users table?
SELECT COUNT(*) AS total_users
FROM users;

-- A2) How many users signed up in the last 7 days?
SELECT COUNT(*) AS users_last_7_days
FROM users
WHERE signup_date >= CURRENT_DATE - INTERVAL '7 days';

-- A3) How many users signed up in the last 30 days?
SELECT COUNT(*) AS users_last_30_days
FROM users
WHERE signup_date >= CURRENT_DATE - INTERVAL '30 days';

-- A4) How many users are there per country? Sort descending.
SELECT
  country,
  COUNT(*) AS users
FROM users
GROUP BY country
ORDER BY users DESC;

-- A5) How many users signed up each day? Sort newest to oldest.
SELECT
  signup_date,
  COUNT(*) AS users
FROM users
GROUP BY signup_date
ORDER BY signup_date DESC;

-- A6) How many users signed up each week? Sort oldest to newest.
SELECT
  DATE_TRUNC('week', signup_date) AS signup_week,
  COUNT(*) AS users
FROM users
GROUP BY signup_week
ORDER BY signup_week;


-- -----------------------------------------------------
-- Section B: Subscriptions (active vs churned)
-- -----------------------------------------------------

-- B1) How many total subscriptions are there?
SELECT COUNT(*) AS total_subscriptions
FROM subscriptions;

-- B2) How many active subscriptions are there?
SELECT COUNT(*) AS active_subscriptions
FROM subscriptions
WHERE end_date IS NULL;

-- B3) How many churned subscriptions are there?
SELECT COUNT(*) AS churned_subscriptions
FROM subscriptions
WHERE end_date IS NOT NULL;

-- B4) What percentage of subscriptions are active?
SELECT
  ROUND(
    100.0 * SUM(CASE WHEN end_date IS NULL THEN 1 ELSE 0 END)::numeric
    / COUNT(*)::numeric,
    1
  ) AS pct_active_subscriptions
FROM subscriptions;

-- B5) For churned subscriptions, what is the average number of days active?
SELECT
  ROUND(AVG((end_date - start_date))::numeric, 1) AS avg_days_active
FROM subscriptions
WHERE end_date IS NOT NULL;

-- B6) For churned subscriptions, what is the maximum number of days active?
SELECT
  MAX(end_date - start_date) AS max_days_active
FROM subscriptions
WHERE end_date IS NOT NULL;


-- -----------------------------------------------------
-- Section C: JOINs (plans, subscriptions, invoices)
-- -----------------------------------------------------

-- C1) Sample subscriptions with plan name attached
SELECT
  s.id AS subscription_id,
  s.user_id,
  p.name AS plan,
  p.price,
  s.start_date,
  s.end_date
FROM subscriptions s
JOIN plans p
  ON s.plan_id = p.id
LIMIT 20;

-- C2) Active subscriptions by plan
SELECT
  p.name AS plan,
  COUNT(*) AS active_subscriptions
FROM subscriptions s
JOIN plans p
  ON s.plan_id = p.id
WHERE s.end_date IS NULL
GROUP BY p.name
ORDER BY active_subscriptions DESC;

-- C3) Revenue by plan (excluding refunded invoices)
SELECT
  p.name AS plan,
  SUM(i.amount) AS revenue
FROM invoices i
JOIN subscriptions s
  ON i.subscription_id = s.id
JOIN plans p
  ON s.plan_id = p.id
WHERE i.refunded = false
GROUP BY p.name
ORDER BY revenue DESC;

-- C4) Refund rate (%) by plan
SELECT
  p.name AS plan,
  COUNT(*) AS total_invoices,
  SUM(CASE WHEN i.refunded THEN 1 ELSE 0 END) AS refunded_invoices,
  ROUND(
    100.0 * SUM(CASE WHEN i.refunded THEN 1 ELSE 0 END)::numeric
    / COUNT(*)::numeric,
    1
  ) AS refund_rate_pct
FROM invoices i
JOIN subscriptions s
  ON i.subscription_id = s.id
JOIN plans p
  ON s.plan_id = p.id
GROUP BY p.name
ORDER BY refund_rate_pct DESC;

-- C5) Which country generated the most revenue (excluding refunds)?
SELECT
  u.country,
  SUM(i.amount) AS revenue
FROM invoices i
JOIN subscriptions s
  ON i.subscription_id = s.id
JOIN users u
  ON s.user_id = u.id
WHERE i.refunded = false
GROUP BY u.country
ORDER BY revenue DESC;

-- C6) Revenue per day (excluding refunds), oldest to newest
SELECT
  invoice_date AS day,
  SUM(amount) AS revenue
FROM invoices
WHERE refunded = false
GROUP BY invoice_date
ORDER BY day;

-- C7) Revenue per day in the last 30 days (excluding refunds)
SELECT
  invoice_date AS day,
  SUM(amount) AS revenue
FROM invoices
WHERE refunded = false
  AND invoice_date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY invoice_date
ORDER BY day;


-- -----------------------------------------------------
-- Section D: Events (engagement / behaviour)
-- -----------------------------------------------------

-- D1) How many events are there in total?
SELECT COUNT(*) AS total_events
FROM events;

-- D2) How many events are there by event_type?
SELECT
  event_type,
  COUNT(*) AS events
FROM events
GROUP BY event_type
ORDER BY events DESC;

-- D3) How many distinct users generated at least one event?
SELECT COUNT(DISTINCT user_id) AS users_with_events
FROM events;

-- D4) What % of users generated at least one event?
SELECT
  ROUND(
    100.0
    * (SELECT COUNT(DISTINCT user_id)::numeric FROM events)
    / (SELECT COUNT(*)::numeric FROM users),
    1
  ) AS pct_users_with_events;

-- D5) For each user, how many events did they generate? Top 10
SELECT
  user_id,
  COUNT(*) AS events
FROM events
GROUP BY user_id
ORDER BY events DESC
LIMIT 10;

-- D6) For each country, how many total events occurred?
SELECT
  u.country,
  COUNT(*) AS events
FROM events e
JOIN users u
  ON e.user_id = u.id
GROUP BY u.country
ORDER BY events DESC;


-- -----------------------------------------------------
-- Section E: Activation (feature_use within first 7 days)
-- -----------------------------------------------------

-- E1) How many distinct users triggered 'feature_use' at least once?
SELECT COUNT(DISTINCT user_id) AS users_with_feature_use
FROM events
WHERE event_type = 'feature_use';

-- E2) How many distinct users triggered 'feature_use' within 7 days of signup?
SELECT
  COUNT(DISTINCT u.id) AS users_activated_7d
FROM users u
JOIN events e
  ON e.user_id = u.id
WHERE e.event_type = 'feature_use'
  AND e.event_date <= u.signup_date + INTERVAL '7 days';

-- E3) What percentage of users triggered 'feature_use' within 7 days of signup?
SELECT
  ROUND(
    100.0
    * (SELECT COUNT(DISTINCT u.id)::numeric
       FROM users u
       JOIN events e ON e.user_id = u.id
       WHERE e.event_type = 'feature_use'
         AND e.event_date <= u.signup_date + INTERVAL '7 days'
      )
    / (SELECT COUNT(*)::numeric FROM users),
    1
  ) AS pct_users_activated_7d;

-- E4) Split users into activated vs not_activated
WITH activated AS (
  SELECT DISTINCT u.id AS user_id
  FROM users u
  JOIN events e
    ON e.user_id = u.id
  WHERE e.event_type = 'feature_use'
    AND e.event_date <= u.signup_date + INTERVAL '7 days'
)
SELECT
  CASE WHEN a.user_id IS NULL THEN 'not_activated' ELSE 'activated' END AS segment,
  COUNT(*) AS users
FROM users u
LEFT JOIN activated a
  ON a.user_id = u.id
GROUP BY segment
ORDER BY users DESC;


-- -----------------------------------------------------
-- Section F: Cohorts / Retention
-- -----------------------------------------------------

-- F1) Users by signup week
SELECT
  DATE_TRUNC('week', signup_date) AS signup_week,
  COUNT(*) AS users
FROM users
GROUP BY signup_week
ORDER BY signup_week;

-- F2) Retention-style table (active subscriptions)
SELECT
  DATE_TRUNC('week', u.signup_date) AS signup_week,
  FLOOR((CURRENT_DATE - u.signup_date) / 7) AS weeks_since_signup,
  COUNT(DISTINCT u.id) AS active_users
FROM users u
JOIN subscriptions s
  ON s.user_id = u.id
WHERE s.end_date IS NULL
GROUP BY signup_week, weeks_since_signup
ORDER BY signup_week, weeks_since_signup;

-- F3) Retention for activated users only
WITH activated AS (
  SELECT DISTINCT u.id AS user_id
  FROM users u
  JOIN events e
    ON e.user_id = u.id
  WHERE e.event_type = 'feature_use'
    AND e.event_date <= u.signup_date + INTERVAL '7 days'
)
SELECT
  DATE_TRUNC('week', u.signup_date) AS signup_week,
  FLOOR((CURRENT_DATE - u.signup_date) / 7) AS weeks_since_signup,
  COUNT(DISTINCT u.id) AS active_users
FROM users u
JOIN subscriptions s
  ON s.user_id = u.id
JOIN activated a
  ON a.user_id = u.id
WHERE s.end_date IS NULL
GROUP BY signup_week, weeks_since_signup
ORDER BY signup_week, weeks_since_signup;

-- F4) Retention for NOT activated users
WITH activated AS (
  SELECT DISTINCT u.id AS user_id
  FROM users u
  JOIN events e
    ON e.user_id = u.id
  WHERE e.event_type = 'feature_use'
    AND e.event_date <= u.signup_date + INTERVAL '7 days'
)
SELECT
  DATE_TRUNC('week', u.signup_date) AS signup_week,
  FLOOR((CURRENT_DATE - u.signup_date) / 7) AS weeks_since_signup,
  COUNT(DISTINCT u.id) AS active_users
FROM users u
JOIN subscriptions s
  ON s.user_id = u.id
LEFT JOIN activated a
  ON a.user_id = u.id
WHERE s.end_date IS NULL
  AND a.user_id IS NULL
GROUP BY signup_week, weeks_since_signup
ORDER BY signup_week, weeks_since_signup;
