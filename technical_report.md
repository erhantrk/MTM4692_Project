# 1. Problem Statement

Small and medium e-commerce businesses collect large amounts of transactional data — customer registrations, product listings, orders, payments, and reviews — but often lack a structured system to store, query, and analyze this information. Without a well-designed relational database, critical business questions go unanswered: Which products drive the most revenue? Which customers are the most valuable? Are certain product categories underperforming? What does monthly revenue growth look like?

This project addresses that gap by designing a normalized relational database for an online retail store. The database captures the full lifecycle of an e-commerce transaction — from the customer browsing a product catalog, to placing an order with multiple items, to making a payment, and finally leaving a review. The goal is to create a schema that supports efficient data storage and powerful analytical queries.

## 2. Why It Matters

E-commerce is one of the fastest-growing sectors in the global economy. Even a small online store generates hundreds or thousands of records per month across customers, orders, and products. The ability to query this data effectively translates directly into better business decisions:

- **Revenue optimization**: Identifying top-selling products and high-value customers allows targeted marketing and inventory planning.
- **Customer retention**: Tracking purchase history and review patterns helps detect churn risk and reward loyalty.
- **Operational efficiency**: Monitoring stock quantities, order volumes, and payment statuses prevents overselling and delays.
- **Product quality**: Aggregating review scores highlights products that need improvement or removal.

**Feasibility**: The scope of this project — 7 tables, 5–7 key queries, and 3 views — is well-suited for a semester-long course project. The domain is familiar and well-defined, the relationships between entities are natural and unambiguous, and the data lends itself to a wide variety of SQL techniques (joins, aggregation, CTEs, subqueries, and views). This makes the project both manageable and rich enough to demonstrate meaningful database skills.
