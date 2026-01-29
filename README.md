# Learning SQL by Building a Fake SaaS Product

This repository contains a **fake but realistic SaaS dataset** and a set of **SQL tutorials, exercises, and solutions** designed to help Product Managers learn SQL by answering real product and business questions.

Rather than learning SQL in isolation or through abstract examples, this project is built around a subscription-based SaaS product, allowing you to explore retention, revenue, activation, and churn using realistic data and queries.

The goal is not to become a data scientist, but to **reduce the distance between product questions and answers**.

---

## Why this exists

In product roles, many questions are answerable with data — but not always quickly.  
Dashboards are great for monitoring known metrics, but exploratory questions often require going deeper.

This project was created to:
- learn SQL through hands-on practice
- explore realistic product analytics questions
- build confidence self-serving analysis
- understand how data informs product decisions

It reflects a learning-by-doing approach rather than a course-based one.

---

## What’s inside

### Dataset
A small, synthetic Postgres dataset modelling a SaaS product with:

- **users** – who signed up and when
- **plans** – Basic, Pro, Premium
- **subscriptions** – active vs churned customers
- **invoices** – revenue and refunds
- **events** – simple product usage signals

All data is fake and safe to share.

### SQL files

sql/
├── 00_setup.sql -- Schema + seed data
├── 01_tutorial_basics.sql -- SELECT, WHERE, GROUP BY
├── 02_tutorial_dates.sql -- Dates, cohorts, churn timing
├── 03_tutorial_joins.sql -- Revenue, plans, refunds
├── 04_tutorial_retention.sql -- Cohorts, retention, activation
├── 90_exercises.sql -- Practice questions
└── 99_solutions.sql -- Worked solutions


The tutorials are designed to be run **in order**, with exercises encouraging you to try queries before looking at solutions.

---

## How to run this

This project is designed to run in **Supabase** (or any Postgres-compatible environment).

### Quick start

1. Create a free Supabase project  
2. Open the **SQL Editor**
3. Copy and run `sql/00_setup.sql`
4. Work through the tutorial files in order:
   - `01_tutorial_basics.sql`
   - `02_tutorial_dates.sql`
   - `03_tutorial_joins.sql`
   - `04_tutorial_retention.sql`
5. Attempt the questions in `90_exercises.sql`
6. Check your answers against `99_solutions.sql`

Each file is heavily commented and intended to be run section by section.

---

## What you’ll learn

By working through this repository, you’ll practice:

- querying and filtering data
- grouping and aggregating metrics
- working with dates and time windows
- joining multiple tables
- analysing retention and cohorts
- identifying activation signals
- reasoning from data to product decisions

The focus is on **product-relevant analysis**, not just SQL syntax.

---

## Related article

This repository accompanies the Medium article:

**“How I’m Learning SQL by Building a Fake SaaS Product”**

👉 https://medium.com/@romieb/how-im-learning-sql-by-building-a-fake-saas-product-b54c22f7d16f?postPublishedType=repub

The article explains the motivation behind this approach and how learning SQL in a realistic product context changed how I think about data as a Product Manager.

---

## Who this is for

- Product Managers curious about SQL
- PMs who want to self-serve basic analysis
- Anyone who learns best by building and experimenting
- People looking for a realistic, non-academic SQL playground

---

## Notes

- This is not a course or certification
- The dataset is intentionally simple but realistic
- The emphasis is on understanding, not optimisation

If you find this useful, feel free to adapt it, extend it, or use it as a starting point for your own experiments.

