-- ============================================
-- Fake SaaS Product: Schema + Seed Data
-- --------------------------------------------
-- This file creates a small but realistic
-- subscription SaaS dataset for learning SQL.
--
-- Tables:
-- - users
-- - plans
-- - subscriptions
-- - invoices
-- - events
-- ============================================

-- Drop tables if they already exist (for re-runs)
DROP TABLE IF EXISTS events;
DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS subscriptions;
DROP TABLE IF EXISTS plans;
DROP TABLE IF EXISTS users;

-- ============================================
-- USERS
-- ============================================
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  email TEXT NOT NULL,
  signup_date DATE NOT NULL,
  country TEXT NOT NULL
);

-- ============================================
-- PLANS
-- ============================================
CREATE TABLE plans (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  price NUMERIC NOT NULL
);

-- ============================================
-- SUBSCRIPTIONS
-- ============================================
CREATE TABLE subscriptions (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  plan_id INT REFERENCES plans(id),
  start_date DATE NOT NULL,
  end_date DATE
);

-- ============================================
-- INVOICES
-- ============================================
CREATE TABLE invoices (
  id SERIAL PRIMARY KEY,
  subscription_id INT REFERENCES subscriptions(id),
  amount NUMERIC NOT NULL,
  invoice_date DATE NOT NULL,
  refunded BOOLEAN DEFAULT FALSE
);

-- ============================================
-- EVENTS (product usage)
-- ============================================
CREATE TABLE events (
  id SERIAL PRIMARY KEY,
  user_id INT REFERENCES users(id),
  event_type TEXT NOT NULL,
  event_date DATE NOT NULL
);

-- ============================================
-- SEED DATA
-- ============================================

-- Plans
INSERT INTO plans (name, price) VALUES
('Basic', 10),
('Pro', 25),
('Premium', 50);

-- Users (200 fake users over last ~4 months)
INSERT INTO users (email, signup_date, country)
SELECT
  'user' || i || '@example.com',
  CURRENT_DATE - (RANDOM() * 120)::INT,
  (ARRAY['US', 'UK', 'DE', 'FR', 'IN'])[FLOOR(RANDOM() * 5) + 1]
FROM GENERATE_SERIES(1, 200) AS s(i);

-- Subscriptions
-- ~70% active, ~30% churned
INSERT INTO subscriptions (user_id, plan_id, start_date, end_date)
SELECT
  u.id,
  (RANDOM() * 2 + 1)::INT,
  u.signup_date,
  CASE
    WHEN RANDOM() > 0.7 THEN u.signup_date + (RANDOM() * 60)::INT
    ELSE NULL
  END
FROM users u;

-- Invoices
-- One or more invoices per subscription
INSERT INTO invoices (subscription_id, amount, invoice_date, refunded)
SELECT
  s.id,
  p.price,
  s.start_date + (RANDOM() * 90)::INT,
  RANDOM() > 0.85
FROM subscriptions s
JOIN plans p ON s.plan_id = p.id;

-- Events
-- Simulate product usage
INSERT INTO events (user_id, event_type, event_date)
SELECT
  u.id,
  (ARRAY['login', 'feature_use', 'upgrade_click'])[FLOOR(RANDOM() * 3) + 1],
  u.signup_date + (RANDOM() * 90)::INT
FROM users u,
     GENERATE_SERIES(1, 5);
