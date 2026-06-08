# Video Presentation Script — MTM4692 E-Commerce Database Project

**Duration target:** 7–9 minutes
**Format:** Screen recording (browser + code editor + terminal)
**Tone:** Read calmly. Pause briefly between sections.

---

## 0:00 – 0:45 — Project Overview *(rubric: 20%)*

**[ON SCREEN: README.md open]**

> Hello, this is our final project for MTM4692 — an E-Commerce Database built with SQLite.
> The team is Erhan Türker, Andaç Demirdelen, Hüseyin Ekşici, and Ahmet Barkın Mecer.
>
> The problem we solve is simple: small online retailers collect thousands of records every month — customers, orders, products, payments, reviews — but most of them have no structured way to actually ask questions about that data. Without a database, they can't tell which products sell the most, which customers are most valuable, or how revenue is trending.
>
> Our project answers those questions. We designed a normalized relational schema with seven tables, populated it with realistic sample data, and built an admin-style web interface that lets you run every query and view against the live database.

---

## 0:45 – 3:45 — Database Design *(rubric: 30%)*

**[ON SCREEN: open ERD.pdf]**

> Let's start with the schema. The database has seven tables, and the relationships between them follow the natural flow of an e-commerce transaction.

**[Point at each table on the ERD as you mention it]**

> - **`customers`** stores registered users — primary key `customer_id`, with a unique email.
> - **`categories`** groups products — six categories like Electronics, Books, Home & Kitchen.
> - **`products`** is the catalog. It has a foreign key to `categories`, so every product belongs to exactly one category. We store `price` and `stock_qty` here.
> - **`orders`** records a purchase. It has a foreign key to `customers`, an order date, a total amount, and a status — pending, completed, or cancelled.
> - **`order_items`** is the junction table between `orders` and `products`. One order can have many products, and each line item stores the quantity and the price *at the time of purchase*. This is important — storing the price per line means future price changes don't corrupt historical revenue.
> - **`payments`** records the actual money received. Foreign key to `orders`. We allow one payment per order in this design.
> - **`reviews`** links customers and products with a 1–5 rating. We use a CHECK constraint to make sure rating is between 1 and 5.

**[ON SCREEN: switch to queries.sql, scroll through CREATE TABLE statements]**

> If we open `queries.sql`, you can see the actual DDL. Every primary key is `INTEGER PRIMARY KEY AUTOINCREMENT`. Every foreign key uses the `REFERENCES` clause. We added CHECK constraints to enforce business rules — price can't be negative, quantity must be positive, rating must be 1 to 5.
>
> The schema is in third normal form. There are no repeating groups, no transitive dependencies, and price history is preserved in `order_items`.

---

## 3:45 – 5:30 — SQL Implementation *(rubric: 20%)*

**[ON SCREEN: queries.sql, scroll to the queries section]**

> We implemented seven analytical queries that demonstrate a wide range of SQL features.

**[Scroll to Query 1]**

> **Query 1** is a monthly sales report — it uses `strftime` to group orders by month, with `COUNT DISTINCT` and `SUM` aggregations.

**[Scroll to Query 2]**

> **Query 2** finds the top 5 customers by lifetime value. It uses a Common Table Expression — the `WITH customer_spending AS …` block — to first compute spending per customer, then joins back to the `customers` table for the names.

**[Scroll to Query 3]**

> **Query 3** finds products that have never been reviewed. It uses a subquery with `NOT IN` to exclude any product that appears in the `reviews` table.

**[Scroll to Query 4]**

> **Query 4** is a category performance report — it joins four tables: `order_items`, `products`, `categories`, and `orders`, with aggregation grouped by category.

**[Scroll to Query 6]**

> **Query 6** finds products with above-average revenue. It uses a CTE to compute per-product revenue, then a subquery to compare each row against the overall average.

**[ON SCREEN: open views.sql]**

> We also defined three views — `vw_monthly_revenue`, `vw_top_customers`, and `vw_product_performance`. Views let us treat complex queries as if they were simple tables, which is exactly how a real BI dashboard would consume this database.

---

## 5:30 – 8:30 — Live Demo *(rubric: 30%)*

**[ON SCREEN: terminal in the project folder]**

> Now let's run the application. We built a small Flask backend that exposes the database through a web UI.

```bash
.venv/bin/python app.py
```

> The server starts on port 5000. Let's open it in the browser.

**[ON SCREEN: browser at http://localhost:5000, Schema tab]**

> This is the **Schema** tab. The backend reads the actual SQLite metadata — `sqlite_master` and `PRAGMA table_info` — so every column, type, primary key, and foreign key you see here is read live from the database. Each card also shows the current row count: 8 customers, 20 products, 25 orders, 59 order items, and so on.

**[Click the Queries tab, then click Q1]**

> **Queries tab.** Let me click Query 1 — Monthly Sales Report. You can see the exact SQL on top, and the result below: revenue and order count grouped by month, ordered most recent first.

**[Click Q2]**

> **Query 2** — top 5 customers by lifetime value. Here's the CTE I mentioned earlier, and the result shows Erhan at the top with multiple completed orders.

**[Click Q3]**

> **Query 3** — products with no reviews. The subquery filters them out.

**[Click Q7]**

> **Query 7** is the big one — a full order-details report joining `orders`, `customers`, `order_items`, `products`, and a LEFT JOIN to `payments`. Every line item across the entire database appears here with the customer name, the product, the quantity, the line total, and the payment method.

**[Click Views tab → vw_top_customers]**

> Switching to the **Views** tab. This is `vw_top_customers` — the same logic as Query 2, but stored as a view. The CREATE VIEW statement is shown at the top, and the result is identical because the view *is* that query.

**[Click vw_product_performance]**

> And `vw_product_performance` — every product with its category, units sold, total revenue, review count, and average rating. A real product manager could open this view every morning.

**[Click SQL Console tab]**

> Finally, the **SQL Console**. This connects to the database in read-only mode, so the user can run any SELECT, WITH, or PRAGMA statement — but writes are blocked. Let me run a small example:

```sql
SELECT name, stock_qty FROM products WHERE stock_qty < 20 ORDER BY stock_qty;
```

> Four products are low on stock — the Remote Car has only 3 left.

---

## 8:30 – 9:00 — Wrap-up

> That's the project. To summarize: a normalized seven-table schema, seven analytical queries covering joins, aggregation, CTEs, and subqueries, three views, and a Flask-based admin UI that proves the entire system works end-to-end against a real SQLite database.
>
> The full source code, the technical report, the ERD, and all SQL files are on our GitHub repository linked in the README.
>
> Thank you for watching.

---

## Notes for recording

- **Window setup:** browser on the left half, code editor on the right half. Switch focus by clicking, don't use Alt-Tab (looks jumpy on video).
- **Font size:** zoom both browser and editor to 125% so text is readable at 1080p.
- **Mouse:** move slowly. Hover over a query for a second before clicking.
- **Audio:** record in a quiet room. If you make a mistake, pause for 3 seconds and re-read the sentence — you can cut the pause in editing.
- **Total runtime budget:**
  - Intro: 45 s
  - Design walk-through: 3 min
  - SQL implementation: 1 min 45 s
  - Demo: 3 min
  - Wrap: 30 s
- **Practice run:** read this script aloud once before recording. It should land between 7 and 9 minutes at a natural pace.
