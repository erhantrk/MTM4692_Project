# MTM4692 E-Commerce Database Project

**Team Members:**
- Erhan Türker
- Andaç Demirdelen
- Hüseyin Ekşici
- Ahmet Barkın Mecer

**Repository:** [github.com/erhantrk/MTM4692_Project](https://github.com/erhantrk/MTM4692_Project)

---


## Project Overview

This project designs and implements a relational database for a small online retail store. The database tracks customers, products, orders, payments, and reviews the core data any e-commerce business needs to operate, analyze sales, and improve the customer experience.

## Purpose

Online retail businesses generate large volumes of transactional data every day. Without a well structured database, it becomes difficult to answer basic but critical questions. Which products are selling the most? Who are the highest value customers? Are there seasonal trends in revenue? Which products receive poor reviews and may need attention?

This project aims to build a normalized relational database that can answer these questions through structured SQL queries, views, and reports.

## Real World Business Need

A growing e-commerce company needs to:

- Track inventory and product catalog across multiple categories.
- Process and record orders with multiple line items and payment information.
- Understand customer behavior, repeat purchases, spending patterns, and review activity.
- Generate business reports, monthly revenue, top selling products, category performance, and customer lifetime value.

This database provides the foundation for all of these capabilities. It is designed to be queried with standard SQL techniques including joins, aggregations, common table expressions, subqueries, and views. Making it both a practical business tool.

## Scope

| Element        | Target                                      |
|----------------|---------------------------------------------|
| Tables         | 7                                           |
| Key Queries    | 5–7                                         |
| Views          | 3                                           |
| SQL Features   | Joins, Aggregation, CTEs, Subqueries, Views |

## Schema at a Glance

The database consists of seven tables:

1. **customers** — registered user accounts
2. **categories** — product categories
3. **products** — the product catalog
4. **orders** — customer purchase orders
5. **order_items** — individual line items within each order
6. **payments** — payment records tied to orders
7. **reviews** — customer reviews for purchased products

## How to Run the Demo App

The repo includes a Flask-based admin UI (`app.py`) that lets you browse the schema, run all 7 queries, inspect the 3 views, and execute ad-hoc SELECT statements against the live SQLite database.

### Setup

```bash
# 1. Create a virtual environment
python3 -m venv .venv
source .venv/bin/activate          # macOS / Linux
# .venv\Scripts\activate           # Windows

# 2. Install Flask
pip install -r requirements.txt

# 3. Run the app
python app.py
```

The first run automatically builds `project.db` from `queries.sql` (schema), `seed.sql` (sample data), and `views.sql` (views).

Open <http://localhost:5000> in your browser.

### What you'll see

- **Schema tab** — all 7 tables with columns, types, PKs, FKs, and live row counts.
- **Queries tab** — buttons for the 7 named queries from `queries.sql`. Click any query to see both the SQL and the result.
- **Views tab** — the 3 views with their CREATE VIEW definition and current rows.
- **SQL Console** — paste any SELECT / WITH / PRAGMA statement and run it. Writes are blocked (read-only connection).
- **Reset DB** (top-right) — drops the database and rebuilds it from the .sql files. Useful between demos.

### File map

| File                     | Purpose                                       |
|--------------------------|-----------------------------------------------|
| `queries.sql`            | CREATE TABLE statements + the 7 named queries |
| `seed.sql`               | Realistic sample data (8 customers, 20 products, 25 orders, …) |
| `views.sql`              | The 3 CREATE VIEW statements                  |
| `app.py`                 | Flask backend (6 endpoints)                   |
| `templates/index.html`   | Single-page admin UI                          |
| `static/style.css`       | Dark IT-terminal styling                      |
| `presentation_script.md` | Word-for-word video script with timing cues   |
| `technical_report.pdf`   | 2-3 page project report                       |
| `ERD.pdf`                | Entity-Relationship Diagram                   |
