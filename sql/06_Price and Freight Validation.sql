-- ============================================================
-- 8. Price and Freight Validation Summary
-- ============================================================

SELECT
    'Negative Product Prices' AS validation,
    COUNT(*) AS affected_records
FROM order_items
WHERE price < 0

UNION ALL

SELECT
    'Zero Product Prices',
    COUNT(*)
FROM order_items
WHERE price = 0

UNION ALL

SELECT
    'Negative Freight Values',
    COUNT(*)
FROM order_items
WHERE freight_value < 0

UNION ALL

SELECT
    'Zero Freight Values',
    COUNT(*)
FROM order_items
WHERE freight_value = 0

UNION ALL

SELECT
    'Freight Greater Than Product Price',
    COUNT(*)
FROM order_items
WHERE freight_value > price

UNION ALL

SELECT
    'Negative Payment Values',
    COUNT(*)
FROM payments
WHERE payment_value < 0

UNION ALL

SELECT
    'Zero Payment Values',
    COUNT(*)
FROM payments
WHERE payment_value = 0;

SELECT
    payment_type,
    COUNT(*) AS total_orders
FROM payments
WHERE payment_value = 0
GROUP BY payment_type;

/*
Price Validation Findings:

- No negative or zero product prices were found.
- No negative freight charges were found.
- 383 order items have zero freight charges, likely representing
  free shipping promotions or seller-covered shipping costs.
- 4,124 order items have freight charges greater than the product
  price. This is considered a valid business scenario for
  inexpensive or bulky products.
- Nine payment records have zero payment value:
    • 6 were paid using vouchers.
    • 3 have the payment type 'not_defined'.
  These represent a very small proportion of the dataset and are
  not expected to affect downstream analysis.
*/