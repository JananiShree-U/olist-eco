-- ============================================================
-- 7. Date Validation Summary
-- ============================================================

SELECT
    'Purchase → Approval' AS validation,
    COUNT(*) AS invalid_records
FROM orders
WHERE order_approved_at IS NOT NULL
  AND order_purchase_timestamp > order_approved_at

UNION ALL

SELECT
    'Approval → Carrier',
    COUNT(*)
FROM orders
WHERE order_approved_at IS NOT NULL
  AND order_delivered_carrier_date IS NOT NULL
  AND order_approved_at > order_delivered_carrier_date

UNION ALL

SELECT
    'Carrier → Customer',
    COUNT(*)
FROM orders
WHERE order_delivered_carrier_date IS NOT NULL
  AND order_delivered_customer_date IS NOT NULL
  AND order_delivered_carrier_date > order_delivered_customer_date

UNION ALL

SELECT
    'Purchase → Delivery',
    COUNT(*)
FROM orders
WHERE order_delivered_customer_date IS NOT NULL
  AND order_purchase_timestamp > order_delivered_customer_date

UNION ALL

SELECT
    'Late Deliveries',
    COUNT(*)
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date > order_estimated_delivery_date

UNION ALL

SELECT
    'On-Time Deliveries',
    COUNT(*)
FROM orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date <= order_estimated_delivery_date;

  /*
Date Validation Findings:
- No purchase-to-approval or purchase-to-delivery inconsistencies were found.
- 1,359 records show carrier handover before order approval.
- 23 records show customer delivery before carrier handover.
- These anomalies likely result from system synchronization, logging,
  or ETL timestamp inconsistencies.
- 88,644 deliveries were on time and 7,826 were late.
*/