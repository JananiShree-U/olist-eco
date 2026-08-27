-- ============================================================
-- 6.1 Order Status Distribution
-- ============================================================

SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(
        COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- ============================================================
-- 6.2 Cancelled Orders
-- ============================================================

SELECT COUNT(*) AS cancelled_orders
FROM orders
WHERE order_status = 'canceled';

-- ============================================================
-- 6.3 Unavailable Orders
-- ============================================================

SELECT COUNT(*) AS unavailable_orders
FROM orders
WHERE order_status = 'unavailable';

-- ============================================================
-- 6.2 Successfully Delivered Orders
-- ============================================================

SELECT COUNT(*) AS delivered_orders
FROM orders
WHERE order_status = 'delivered';