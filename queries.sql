-- ============================================================
-- MTM4692 — E-Commerce Database Project
-- Erhan Türker, Andaç Demirdelen, Hüseyin Ekşici, Ahmet Barkın Mecer
-- ============================================================
 
-- ============================================================
-- 1. CREATE TABLES
-- ============================================================

-- 1.1 Customers Table ========================================
CREATE TABLE IF NOT EXISTS customers(
    customer_id INTEGER PRIMARY KEY AUTOINCREMENT,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    email TEXT NOT NULL UNIQUE,
    phone TEXT,
    address TEXT,
    city TEXT,
    state TEXT,
    created_at datetime DEFAULT CURRENT_TIMESTAMP
);

-- 1.2 Categories Table =========================================

CREATE TABLE IF NOT EXISTS categories(
    category_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE,
    description TEXT
);

-- 1.3 Products Table ============================================

CREATE TABLE IF NOT EXISTS products(
    product_id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL,
    description TEXT,
    price REAL NOT NULL CHECK (price >= 0),
    stock_qty INTEGER NOT NULL DEFAULT 0,
    category_id INTEGER NOT NULL,
    created_at datetime DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);

-- 1.4 Orders Table ==============================================

CREATE TABLE IF NOT EXISTS orders(
    order_id INTEGER PRIMARY KEY AUTOINCREMENT,
    customer_id INTEGER NOT NULL,
    order_date datetime DEFAULT CURRENT_TIMESTAMP,
    total_amount REAL NOT NULL CHECK (total_amount >= 0),
    status TEXT NOT NULL DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- 1.5 Order Items Table =========================================
CREATE TABLE IF NOT EXISTS order_items(
    order_item_id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    price REAL NOT NULL CHECK (price >= 0),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 1.6 Payments Table =============================================

CREATE TABLE IF NOT EXISTS payments(
    payment_id INTEGER PRIMARY KEY AUTOINCREMENT,
    order_id INTEGER NOT NULL,
    payment_date datetime DEFAULT CURRENT_TIMESTAMP,
    amount REAL NOT NULL CHECK (amount >= 0),
    payment_method TEXT NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

-- 1.7 Reviews Table =============================================

CREATE TABLE IF NOT EXISTS reviews(
    review_id INTEGER PRIMARY KEY AUTOINCREMENT,
    product_id INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    review_date datetime DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- ============================================================
-- 2. SAMPLE DATA
-- ============================================================

-- Query 1: Monthly Sales Report 
SELECT
    strftime('%Y-%m', o.order_date)  AS month,
    COUNT(DISTINCT o.order_id)       AS total_orders,
    SUM(o.total_amount)              AS total_revenue
FROM orders o
WHERE o.status != 'cancelled'
GROUP BY strftime('%Y-%m', o.order_date)
ORDER BY month DESC;
 
-- Query 2: Top 5 Customers by Lifetime Value 
WITH customer_spending AS (
    SELECT
        o.customer_id,
        SUM(o.total_amount)  AS lifetime_value,
        COUNT(o.order_id)    AS order_count
    FROM orders o
    WHERE o.status != 'cancelled'
    GROUP BY o.customer_id
)
SELECT
    c.first_name,
    c.last_name,
    c.email,
    cs.lifetime_value,
    cs.order_count
FROM customer_spending cs
JOIN customers c ON cs.customer_id = c.customer_id
ORDER BY cs.lifetime_value DESC
LIMIT 5;
 
-- Query 3: Products Without Reviews
SELECT
    p.product_id,
    p.name,
    p.price,
    cat.name AS category
FROM products p
JOIN categories cat ON p.category_id = cat.category_id
WHERE p.product_id NOT IN (
    SELECT DISTINCT product_id FROM reviews
);
 
-- Query 4: Category Performance Report
SELECT
    cat.name                                        AS category,
    COUNT(DISTINCT oi.order_id)                    AS total_orders,
    SUM(oi.quantity * oi.unit_price)               AS category_revenue,
    ROUND(AVG(oi.unit_price), 2)                   AS avg_item_price
FROM order_items oi
JOIN products p   ON oi.product_id = p.product_id
JOIN categories cat ON p.category_id = cat.category_id
JOIN orders o     ON oi.order_id = o.order_id
WHERE o.status != 'cancelled'
GROUP BY cat.category_id
ORDER BY category_revenue DESC;
 
-- Query 5: Customers Who Have Not Written Reviews
SELECT
    c.customer_id,
    c.first_name || ' ' || c.last_name  AS full_name,
    c.email
FROM customers c
WHERE c.customer_id NOT IN (
    SELECT DISTINCT customer_id FROM reviews
);
 
-- Query 6: Above Average Revenue Products
WITH product_revenue AS (
    SELECT
        p.product_id,
        p.name,
        SUM(oi.quantity * oi.unit_price) AS total_revenue
    FROM products p
    JOIN order_items oi ON p.product_id = oi.product_id
    JOIN orders o       ON oi.order_id = o.order_id
    WHERE o.status != 'cancelled'
    GROUP BY p.product_id
)
SELECT *
FROM product_revenue
WHERE total_revenue > (SELECT AVG(total_revenue) FROM product_revenue)
ORDER BY total_revenue DESC;
 
-- Query 7: Exact Order Details 
SELECT
    o.order_id,
    c.first_name || ' ' || c.last_name  AS customer_name,
    o.order_date,
    o.status,
    p.name                              AS product_name,
    oi.quantity,
    oi.unit_price,
    oi.quantity * oi.unit_price         AS line_total,
    pay.payment_method,
    pay.amount                          AS amount_paid
FROM orders o
JOIN customers   c   ON o.customer_id  = c.customer_id
JOIN order_items oi  ON o.order_id     = oi.order_id
JOIN products    p   ON oi.product_id  = p.product_id
LEFT JOIN payments pay ON o.order_id   = pay.order_id
ORDER BY o.order_date DESC, o.order_id, oi.item_id;
