-- =====================================================
-- Tutorial 3: JOINs (Combining Tables)
-- -----------------------------------------------------
-- Goal:
-- Learn how to combine tables to answer real
-- product and business questions.
--
-- Tables used:
-- - plans
-- - subscriptions
-- - invoices
-- - users
-- =====================================================


-- -----------------------------------------------------
-- 1. Inspect the tables (quick sanity check)
-- -----------------------------------------------------

SELECT * FROM plans LIMIT 5;
SELECT * FROM subscriptions LIMIT 5;
SELECT * FROM invoices LIMIT 5;


-- -----------------------------------------------------
-- 2. JOIN subscriptions to plans (add plan names)
-- -----------------------------------------------------
-- Each subscription has a plan_id that matches plans.id

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
LIMIT 10;


-- -----------------------------------------------------
-- 3. Active subscriptions by plan
-- -----------------------------------------------------
-- "Active" means end_date IS NULL

SELECT
  p.name AS plan,
  COUNT(*) AS active_subscriptions
FROM subscriptions s
JOIN plans p
  ON s.plan_id = p.id
WHERE s.end_date IS NULL
GROUP BY p.name
ORDER BY active_subscriptions DESC;


-- -----------------------------------------------------
-- 4. Revenue by plan (excluding refunds)
-- -----------------------------------------------------
-- invoices → subscriptions → plans

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


-- -----------------------------------------------------
-- 5. Refund rate by plan
-- -----------------------------------------------------
-- What share of invoices are refunded, by plan?

SELECT
  p.name AS plan,
  COUNT(*) AS total_invoices,
  SUM(CASE WHEN i.refunded THEN 1 ELSE 0 END) AS refunded_invoices,
  ROUND(
    100.0 * SUM(CASE WHEN i.refunded THEN 1 ELSE 0 END) / COUNT(*),
    1
  ) AS refund_rate_pct
FROM invoices i
JOIN subscriptions s
  ON i.subscription_id = s.id
JOIN plans p
  ON s.plan_id = p.id
GROUP BY p.name
ORDER BY refund_rate_pct DESC;


-- -----------------------------------------------------
-- 6. Revenue over time (daily), excluding refunds
-- -----------------------------------------------------

SELECT
  i.invoice_date AS day,
  SUM(i.amount) AS revenue
FROM invoices i
WHERE i.refunded = false
GROUP BY i.invoice_date
ORDER BY day;


-- -----------------------------------------------------
-- 7. Revenue over time (last 30 days), excluding refunds
-- -----------------------------------------------------

SELECT
  i.invoice_date AS day,
  SUM(i.amount) AS revenue
FROM invoices i
WHERE i.refunded = false
  AND i.invoice_date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY i.invoice_date
ORDER BY day;


-- -----------------------------------------------------
-- 8. Which countries generate the most revenue?
-- -----------------------------------------------------
-- invoices → subscriptions → users

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
