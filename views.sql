-- ============================================================
-- MTM4692 — E-Commerce Database: Views
-- 3 views supporting common business reports.
-- ============================================================

DROP VIEW IF EXISTS vw_monthly_revenue;
DROP VIEW IF EXISTS vw_top_customers;
DROP VIEW IF EXISTS vw_product_performance;

-- ============================================================
-- View 1: vw_monthly_revenue
-- Total revenue and order count per calendar month.
-- ============================================================
CREATE VIEW vw_monthly_revenue AS
SELECT
    strftime('%Y-%m', o.order_date) AS month,
    COUNT(DISTINCT o.order_id)      AS total_orders,
    ROUND(SUM(o.total_amount), 2)   AS total_revenue
FROM orders o
WHERE o.status != 'cancelled'
GROUP BY strftime('%Y-%m', o.order_date);

-- ============================================================
-- View 2: vw_top_customers
-- Customers ranked by lifetime spending (CTE inside the view).
-- ============================================================
CREATE VIEW vw_top_customers AS
WITH customer_spending AS (
    SELECT
        customer_id,
        SUM(total_amount) AS lifetime_value,
        COUNT(order_id)   AS order_count
    FROM orders
    WHERE status != 'cancelled'
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name AS full_name,
    c.email,
    cs.order_count,
    ROUND(cs.lifetime_value, 2) AS lifetime_value
FROM customer_spending cs
JOIN customers c ON cs.customer_id = c.customer_id
ORDER BY cs.lifetime_value DESC;

-- ============================================================
-- View 3: vw_product_performance
-- Per-product sales totals plus average rating and review count.
-- ============================================================
CREATE VIEW vw_product_performance AS
SELECT
    p.product_id,
    p.name AS product_name,
    cat.name AS category,
    COALESCE(SUM(oi.quantity), 0)                    AS units_sold,
    ROUND(COALESCE(SUM(oi.quantity * oi.price), 0), 2) AS total_revenue,
    (SELECT COUNT(*)        FROM reviews r WHERE r.product_id = p.product_id) AS review_count,
    (SELECT ROUND(AVG(rating), 2) FROM reviews r WHERE r.product_id = p.product_id) AS avg_rating
FROM products p
JOIN categories cat ON p.category_id = cat.category_id
LEFT JOIN order_items oi ON p.product_id = oi.product_id
LEFT JOIN orders o       ON oi.order_id = o.order_id AND o.status != 'cancelled'
GROUP BY p.product_id
ORDER BY total_revenue DESC;
