# MTM4692 E-Commerce Database Project


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
