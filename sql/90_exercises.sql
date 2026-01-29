-- =====================================================
-- Exercises: SQL Practice on a Fake SaaS Dataset
-- -----------------------------------------------------
-- Try to answer each question using SQL.
-- Avoid looking at solutions until you've attempted it.
--
-- Tables:
-- - users
-- - plans
-- - subscriptions
-- - invoices
-- - events
-- =====================================================


-- -----------------------------------------------------
-- Section A: Basics (SELECT, WHERE, COUNT, GROUP BY)
-- -----------------------------------------------------

-- A1) How many users are in the users table?

-- A2) How many users signed up in the last 7 days?

-- A3) How many users signed up in the last 30 days?

-- A4) How many users are there per country? Sort descending.

-- A5) How many users signed up each day? Sort newest to oldest.

-- A6) How many users signed up each week? Sort oldest to newest.


-- -----------------------------------------------------
-- Section B: Subscriptions (active vs churned)
-- -----------------------------------------------------

-- B1) How many total subscriptions are there?

-- B2) How many active subscriptions are there? (Hint: end_date IS NULL)

-- B3) How many churned subscriptions are there?

-- B4) What percentage of subscriptions are active?

-- B5) For churned subscriptions, what is the average number of days active?

-- B6) For churned subscriptions, what is the maximum number of days active?


-- -----------------------------------------------------
-- Section C: JOINs (plans, subscriptions, invoices)
-- -----------------------------------------------------

-- C1) Show a sample of subscriptions with the plan name attached
--     (subscription_id, user_id, plan, price, start_date, end_date).

-- C2) How many active subscriptions are there by plan?

-- C3) How much revenue did each plan generate, excluding refunded invoices?

-- C4) What is the refund rate (%) by plan?

-- C5) Which country generated the most revenue (excluding refunds)?

-- C6) Revenue per day (excluding refunds). Sort oldest to newest.

-- C7) Revenue per day in the last 30 days (excluding refunds).


-- -----------------------------------------------------
-- Section D: Events (engagement / behaviour)
-- -----------------------------------------------------

-- D1) How many events are there in total?

-- D2) How many events are there by event_type?

-- D3) How many distinct users generated at least one event?

-- D4) What % of users generated at least one event?
--     (Tip: COUNT(DISTINCT user_id) / COUNT(users))

-- D5) For each user, how many events did they generate?
--     Show top 10 most active users.

-- D6) For each country, how many total events occurred?


-- -----------------------------------------------------
-- Section E: “Activation” (Feature X in first 7 days)
-- -----------------------------------------------------
-- We’ll treat 'feature_use' as a meaningful moment of value.

-- E1) How many distinct users triggered 'feature_use' at least once?

-- E2) How many distinct users triggered 'feature_use' within 7 days of signup?

-- E3) What percentage of users triggered 'feature_use' within 7 days of signup?

-- E4) Split users into two groups:
--     - activated: feature_use within 7 days
--     - not_activated: no feature_use within 7 days
--     Return counts for each group.


-- -----------------------------------------------------
-- Section F: Cohorts / Retention (advanced)
-- -----------------------------------------------------

-- F1) Create a cohort table of users by signup_week:
--     signup_week, users

-- F2) Create a retention-style table for active subscriptions:
--     signup_week, weeks_since_signup, active_users
--     (Hint: weeks_since_signup can be FLOOR((CURRENT_DATE - signup_date)/7))

-- F3) Repeat F2 but ONLY for “activated” users (feature_use within 7 days).

-- F4) Repeat F2 but ONLY for “not activated” users.


-- -----------------------------------------------------
-- Stretch (optional, more PM-like)
-- -----------------------------------------------------

-- S1) Which plan has the highest proportion of refunded invoices?

-- S2) Do users who activate (feature_use in 7 days) have higher revenue?
--     (Hint: join users -> subscriptions -> invoices and segment)

-- S3) If you had to choose ONE metric to improve onboarding, what would it be?
--     (Write a short comment here after running your queries)
