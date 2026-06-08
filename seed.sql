-- ============================================================
-- MTM4692 — E-Commerce Database: Sample Data
-- Run AFTER queries.sql has created the tables.
-- ============================================================

-- Wipe existing data (so seed is idempotent)
DELETE FROM reviews;
DELETE FROM payments;
DELETE FROM order_items;
DELETE FROM orders;
DELETE FROM products;
DELETE FROM categories;
DELETE FROM customers;

-- Reset autoincrement counters
DELETE FROM sqlite_sequence;

-- ============================================================
-- Categories (6)
-- ============================================================
INSERT INTO categories (name, description) VALUES
('Electronics',    'Phones, laptops, accessories'),
('Books',          'Printed books and e-readers'),
('Home & Kitchen', 'Appliances and cookware'),
('Clothing',       'Apparel for men and women'),
('Sports',         'Fitness and outdoor gear'),
('Toys',           'Toys and board games');

-- ============================================================
-- Customers (8)
-- ============================================================
INSERT INTO customers (first_name, last_name, email, phone, address, city, state, created_at) VALUES
('Erhan',  'Turker',     'erhan@example.com',  '555-0101', '12 Main St',    'Istanbul', 'IST', '2025-09-12 10:14:00'),
('Andac',  'Demirdelen', 'andac@example.com',  '555-0102', '34 Park Ave',   'Ankara',   'ANK', '2025-09-20 09:00:00'),
('Huseyin','Eksici',     'huseyin@example.com','555-0103', '7 Riverside',   'Izmir',    'IZM', '2025-10-01 14:22:00'),
('Barkin', 'Mecer',      'barkin@example.com', '555-0104', '88 Hilltop',    'Bursa',    'BUR', '2025-10-15 11:30:00'),
('Ayse',   'Yilmaz',     'ayse@example.com',   '555-0105', '21 Oak Rd',     'Istanbul', 'IST', '2025-11-02 16:45:00'),
('Mehmet', 'Kaya',       'mehmet@example.com', '555-0106', '5 Cedar Ln',    'Antalya',  'ANT', '2025-11-18 08:10:00'),
('Zeynep', 'Sahin',      'zeynep@example.com', '555-0107', '99 Birch Way',  'Konya',    'KON', '2026-01-05 12:00:00'),
('Can',    'Oz',         'can@example.com',    '555-0108', '14 Pine Blvd',  'Adana',    'ADA', '2026-02-10 09:30:00');

-- ============================================================
-- Products (20)
-- ============================================================
INSERT INTO products (name, description, price, stock_qty, category_id) VALUES
-- Electronics
('Smartphone X1',     '6.5-inch OLED, 128GB',        899.00, 25, 1),
('Laptop Pro 14',     '14-inch, 16GB RAM, 512GB SSD',1499.00, 12, 1),
('Wireless Earbuds',  'Active noise cancelling',     149.00, 60, 1),
('USB-C Charger 65W', 'GaN fast charger',             39.00, 80, 1),
-- Books
('SQL for Beginners', 'Intro to relational databases',29.00,100, 2),
('Clean Code',        'Software craftsmanship',       42.00, 45, 2),
('Designing Data-Intensive Apps','Distributed systems',55.00,30, 2),
-- Home & Kitchen
('Coffee Maker',      '12-cup drip',                  79.00, 20, 3),
('Air Fryer 5L',      'Digital touch panel',         119.00, 18, 3),
('Knife Set 8pc',     'Stainless steel',              89.00, 22, 3),
-- Clothing
('T-Shirt Basic',     '100% cotton',                  15.00,200, 4),
('Denim Jeans',       'Slim fit',                     49.00, 75, 4),
('Winter Jacket',     'Waterproof, insulated',       199.00, 30, 4),
-- Sports
('Yoga Mat',          '6mm thickness',                25.00, 90, 5),
('Dumbbell Set 10kg', 'Pair, rubber coated',          69.00, 15, 5),
('Running Shoes',     'Lightweight mesh',            129.00, 40, 5),
-- Toys
('Board Game Classic','2-6 players',                  35.00, 50, 6),
('Lego Building Set', '500 pieces',                   65.00, 28, 6),
('Puzzle 1000pc',     'Landscape art',                20.00, 70, 6),
('Remote Car',        'Rechargeable battery',         59.00,  3, 6);

-- ============================================================
-- Orders (25) — spread across months for the revenue view
-- ============================================================
INSERT INTO orders (customer_id, order_date, total_amount, status) VALUES
(1, '2025-10-05 13:20:00',  928.00,  'completed'),
(2, '2025-10-12 09:45:00',  149.00,  'completed'),
(3, '2025-10-22 17:00:00',  208.00,  'completed'),
(1, '2025-11-03 11:10:00', 1499.00,  'completed'),
(4, '2025-11-08 14:30:00',  118.00,  'completed'),
(5, '2025-11-15 10:00:00',  248.00,  'completed'),
(2, '2025-11-22 16:25:00',   97.00,  'cancelled'),
(6, '2025-11-29 08:50:00',  328.00,  'completed'),
(3, '2025-12-02 12:15:00',  199.00,  'completed'),
(1, '2025-12-09 19:00:00',  104.00,  'completed'),
(7, '2025-12-15 10:45:00',  168.00,  'completed'),
(4, '2025-12-21 13:00:00',  784.00,  'completed'),
(5, '2025-12-28 15:30:00',   55.00,  'completed'),
(2, '2026-01-04 09:20:00',  158.00,  'completed'),
(8, '2026-01-12 11:00:00',  899.00,  'completed'),
(6, '2026-01-19 14:10:00',  130.00,  'completed'),
(1, '2026-01-25 18:00:00',  213.00,  'completed'),
(3, '2026-02-02 10:30:00',   84.00,  'completed'),
(7, '2026-02-09 13:45:00',   70.00,  'cancelled'),
(4, '2026-02-16 16:00:00',  238.00,  'completed'),
(5, '2026-02-23 09:00:00',  149.00,  'completed'),
(2, '2026-03-05 12:30:00',  108.00,  'completed'),
(8, '2026-03-15 14:00:00',   45.00,  'completed'),
(1, '2026-04-02 11:15:00',  330.00,  'completed'),
(6, '2026-05-10 15:20:00',  198.00,  'completed');

-- ============================================================
-- Order Items (50) — at least 2 lines per order on average
-- ============================================================
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
-- Order 1: Smartphone + Earbuds + Charger
(1,  1, 1, 899.00), (1, 4, 1, 39.00),
-- Order 2: Earbuds
(2,  3, 1, 149.00),
-- Order 3: SQL book + Clean Code + Knife Set qty
(3,  5, 1, 29.00),  (3, 6, 1, 42.00),  (3, 10, 1, 89.00), (3, 4, 1, 39.00),
-- Order 4: Laptop
(4,  2, 1, 1499.00),
-- Order 5: Coffee maker + T-shirt
(5,  8, 1, 79.00),  (5, 11, 1, 15.00), (5, 4, 1, 39.00),
-- Order 6: Jeans + Yoga mat + Puzzle + T-shirts
(6, 12, 2, 49.00),  (6, 14, 2, 25.00), (6, 19, 1, 20.00), (6, 11, 5, 15.00),
-- Order 7 cancelled
(7,  3, 1, 97.00),
-- Order 8: Winter Jacket + Knife set + 4 T-shirts
(8, 13, 1, 199.00), (8, 10, 1, 89.00), (8, 11, 1, 15.00), (8, 19, 1, 20.00),
-- Order 9: Winter Jacket
(9, 13, 1, 199.00),
-- Order 10: Lego + Puzzle + T-shirt
(10,18, 1, 65.00),  (10,19, 1, 20.00), (10,11, 1, 15.00),
-- Order 11: Running Shoes + T-shirts
(11,16, 1, 129.00), (11,11, 2, 15.00), (11,19, 1, 20.00),
-- Order 12: Air Fryer + Knife Set + Dumbbells + SQL Book
(12, 9, 1, 119.00), (12,10, 1, 89.00), (12,15, 1, 69.00), (12,5, 1, 29.00), (12,3, 3, 149.00),
-- Order 13: Designing DI Apps
(13, 7, 1, 55.00),
-- Order 14: Remote car + Lego + 2 puzzles
(14,20, 1, 59.00),  (14,18, 1, 65.00), (14,19, 1, 20.00), (14,11, 1, 15.00),
-- Order 15: Smartphone
(15, 1, 1, 899.00),
-- Order 16: Board Game + Lego + 2 SQL Books
(16,17, 1, 35.00),  (16,18, 1, 65.00), (16,5, 1, 29.00),
-- Order 17: Winter Jacket + T-shirt
(17,13, 1, 199.00), (17,11, 1, 15.00),
-- Order 18: Coffee Maker + T-shirt (no review yet)
(18, 8, 1, 79.00),  (18,11, 1, 15.00),
-- Order 19 cancelled
(19,15, 1, 70.00),
-- Order 20: Running Shoes + Yoga Mat + T-shirts
(20,16, 1, 129.00), (20,14, 2, 25.00), (20,11, 1, 15.00),
-- Order 21: Earbuds
(21, 3, 1, 149.00),
-- Order 22: Charger + Coffee + Puzzle
(22, 4, 1, 39.00),  (22, 8, 1, 79.00), (22,19, 1, 20.00),
-- Order 23: Board Game + Charger
(23,17, 1, 35.00),
-- Order 24: Dumbbells + Yoga Mat + Running Shoes
(24,15, 1, 69.00),  (24,14, 2, 25.00), (24,11, 1, 15.00), (24,16, 1, 129.00),
-- Order 25: Winter Jacket - mistake price? use 198
(25,13, 1, 198.00);

-- ============================================================
-- Payments (one per completed order; cancelled orders have none)
-- ============================================================
INSERT INTO payments (order_id, payment_date, amount, payment_method) VALUES
(1,  '2025-10-05 13:25:00',  928.00, 'credit_card'),
(2,  '2025-10-12 09:46:00',  149.00, 'paypal'),
(3,  '2025-10-22 17:05:00',  208.00, 'credit_card'),
(4,  '2025-11-03 11:11:00', 1499.00, 'bank_transfer'),
(5,  '2025-11-08 14:31:00',  118.00, 'credit_card'),
(6,  '2025-11-15 10:05:00',  248.00, 'paypal'),
(8,  '2025-11-29 08:55:00',  328.00, 'credit_card'),
(9,  '2025-12-02 12:20:00',  199.00, 'credit_card'),
(10, '2025-12-09 19:02:00',  104.00, 'paypal'),
(11, '2025-12-15 10:50:00',  168.00, 'credit_card'),
(12, '2025-12-21 13:10:00',  784.00, 'bank_transfer'),
(13, '2025-12-28 15:35:00',   55.00, 'paypal'),
(14, '2026-01-04 09:25:00',  158.00, 'credit_card'),
(15, '2026-01-12 11:05:00',  899.00, 'credit_card'),
(16, '2026-01-19 14:15:00',  130.00, 'paypal'),
(17, '2026-01-25 18:10:00',  213.00, 'credit_card'),
(18, '2026-02-02 10:35:00',   84.00, 'credit_card'),
(20, '2026-02-16 16:05:00',  238.00, 'paypal'),
(21, '2026-02-23 09:05:00',  149.00, 'credit_card'),
(22, '2026-03-05 12:35:00',  108.00, 'paypal'),
(23, '2026-03-15 14:05:00',   45.00, 'credit_card'),
(24, '2026-04-02 11:20:00',  330.00, 'credit_card'),
(25, '2026-05-10 15:25:00',  198.00, 'paypal');

-- ============================================================
-- Reviews (15) — leaves customers 7 with no reviews; leaves some products with no reviews
-- ============================================================
INSERT INTO reviews (product_id, customer_id, rating, comment, review_date) VALUES
(1,  1, 5, 'Excellent phone, battery lasts all day',   '2025-10-10 09:00:00'),
(3,  2, 4, 'Great noise cancelling, comfortable fit',  '2025-10-15 11:30:00'),
(5,  3, 5, 'Clear and beginner-friendly',              '2025-10-25 16:00:00'),
(6,  3, 4, 'Classic, still relevant',                  '2025-10-25 16:05:00'),
(2,  1, 5, 'Fast and quiet, perfect for dev work',     '2025-11-08 10:00:00'),
(8,  4, 3, 'Works but a bit loud',                     '2025-11-12 14:00:00'),
(13, 5, 5, 'Kept me warm in -10C',                     '2025-11-20 09:30:00'),
(13, 6, 4, 'Good jacket but runs small',               '2025-12-04 12:00:00'),
(18, 1, 5, 'Kids love it, hours of fun',               '2025-12-14 18:00:00'),
(9,  4, 5, 'Crispy fries with zero oil',               '2025-12-26 11:00:00'),
(16, 4, 4, 'Comfortable for long runs',                '2026-01-02 08:00:00'),
(1,  8, 5, 'Smooth performance',                       '2026-01-15 19:00:00'),
(11, 6, 2, 'Fabric thinner than expected',             '2026-01-22 13:30:00'),
(15, 4, 5, 'Solid construction, no flex',              '2026-04-06 17:00:00'),
(13, 1, 4, 'Reliable jacket',                          '2026-05-12 10:00:00');
