-- ============================================================
-- 5.1 Verify Orders Reference Valid Customers
-- ============================================================

SELECT
    COUNT(*) AS invalid_customer_references
FROM orders o
LEFT JOIN customers c
    ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- ============================================================
-- 5.2 Verify Order Items Reference Valid Orders
-- ============================================================

SELECT
    COUNT(*) AS invalid_order_references
FROM order_items oi
LEFT JOIN orders o
    ON oi.order_id = o.order_id
WHERE o.order_id IS NULL;

-- ============================================================
-- 5.3 Verify Order Items Reference Valid Products
-- ============================================================

SELECT
    COUNT(*) AS invalid_product_references
FROM order_items oi
LEFT JOIN products p
    ON oi.product_id = p.product_id
WHERE p.product_id IS NULL;

-- ============================================================
-- 5.4 Verify Order Items Reference Valid Sellers
-- ============================================================

SELECT
    COUNT(*) AS invalid_seller_references
FROM order_items oi
LEFT JOIN sellers s
    ON oi.seller_id = s.seller_id
WHERE s.seller_id IS NULL;

-- ============================================================
-- 5.5 Verify Payments Reference Valid Orders
-- ============================================================

SELECT
    COUNT(*) AS invalid_payment_order_references
FROM payments op
LEFT JOIN orders o
    ON op.order_id = o.order_id
WHERE o.order_id IS NULL;

-- ============================================================
-- 5.6 Verify Reviews Reference Valid Orders
-- ============================================================

SELECT
    COUNT(*) AS invalid_review_order_references
FROM reviews r
LEFT JOIN orders o
    ON r.order_id = o.order_id
WHERE o.order_id IS NULL;

-- ============================================================
-- Products Never Sold
-- ============================================================

SELECT
    COUNT(*) AS unsold_products
FROM products p
LEFT JOIN order_items oi
    ON p.product_id = oi.product_id
WHERE oi.product_id IS NULL;

-- ============================================================
-- Sellers With No Orders
-- ============================================================

SELECT
    COUNT(*) AS inactive_sellers
FROM sellers s
LEFT JOIN order_items oi
    ON s.seller_id = oi.seller_id
WHERE oi.seller_id IS NULL;