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
-- 2. ÖRNEK VERİ (SAMPLE DATA)
-- ============================================================


