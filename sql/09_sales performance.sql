-- ============================================================
-- 2.1.1 OVERALL SALES PERFORMANCE KPIs
-- ============================================================

SELECT
    COUNT(DISTINCT o.order_id) AS total_orders,
    COUNT(DISTINCT o.customer_id) AS total_customers,
    COUNT(oi.order_item_id) AS total_items_sold,
    ROUND(SUM(oi.price + oi.freight_value)::numeric, 2) AS total_revenue,
    ROUND(
        SUM(oi.price + oi.freight_value)::numeric
        / COUNT(DISTINCT o.order_id),
        2
    ) AS average_order_value
FROM orders o
JOIN order_items oi
    ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';

-- ============================================================
-- 2.1.2 MONTHLY SALES TREND
-- ============================================================

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(SUM(oi.price + oi.freight_value)::numeric, 2) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
)

SELECT
    TO_CHAR(order_month, 'YYYY-MM') AS month,
    total_orders,
    total_revenue,
    ROUND(
        total_revenue / total_orders,
        2
    ) AS average_order_value
FROM monthly_sales
ORDER BY order_month;

-- ============================================================
-- 2.1.3 MONTH-OVER-MONTH REVENUE GROWTH
-- ============================================================

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(SUM(oi.price + oi.freight_value)::numeric, 2) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
),

monthly_comparison AS (
    SELECT
        order_month,
        total_orders,
        total_revenue,
        LAG(total_revenue) OVER (
            ORDER BY order_month
        ) AS previous_month_revenue
    FROM monthly_sales
)

SELECT
    TO_CHAR(order_month, 'YYYY-MM') AS month,
    total_orders,
    total_revenue,
    previous_month_revenue,

    ROUND(
        total_revenue - previous_month_revenue,
        2
    ) AS revenue_change,

    ROUND(
        (
            (total_revenue - previous_month_revenue)
            / NULLIF(previous_month_revenue, 0)
        ) * 100,
        2
    ) AS mom_revenue_growth_percentage

FROM monthly_comparison
ORDER BY order_month;

-- ============================================================
-- 2.1.4 RUNNING TOTAL REVENUE
-- ============================================================

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month,
        COUNT(DISTINCT o.order_id) AS total_orders,
        ROUND(SUM(oi.price + oi.freight_value)::numeric, 2) AS total_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
)

SELECT
    TO_CHAR(order_month, 'YYYY-MM') AS month,
    total_orders,
    total_revenue,

    ROUND(
        SUM(total_revenue) OVER (
            ORDER BY order_month
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ),
        2
    ) AS cumulative_revenue

FROM monthly_sales
WHERE order_month >= DATE '2017-01-01'
ORDER BY order_month;

-- ============================================================
-- 2.1.5 3-Month Moving Average of Revenue
-- ============================================================

WITH monthly_sales AS (
    SELECT
        DATE_TRUNC('month', o.order_purchase_timestamp) AS month,
        SUM(oi.price) AS monthly_revenue
    FROM orders o
    JOIN order_items oi
        ON o.order_id = oi.order_id
    WHERE o.order_status = 'delivered'
    GROUP BY DATE_TRUNC('month', o.order_purchase_timestamp)
)

SELECT
    TO_CHAR(month, 'YYYY-MM') AS month,
    ROUND(monthly_revenue, 2) AS monthly_revenue,
    ROUND(
        AVG(monthly_revenue) OVER (
            ORDER BY month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ),
        2
    ) AS moving_avg_3_month
FROM monthly_sales
ORDER BY month;


/*==============================================================
  -- 2.1.6 Revenue Trend Smoothing
==============================================================*/


/*--------------------------------------------------------------
  Step 1: Calculate Monthly Revenue
--------------------------------------------------------------*/
WITH monthly_sales AS (

    SELECT
        DATE_TRUNC(
            'month',
            o.order_purchase_timestamp
        )::DATE AS month,

        SUM(oi.price) AS monthly_revenue

    FROM orders o

    INNER JOIN order_items oi
        ON o.order_id = oi.order_id

    WHERE o.order_status = 'delivered'
      AND o.order_purchase_timestamp >= DATE '2017-01-01'
      AND o.order_purchase_timestamp < DATE '2018-09-01'

    GROUP BY
        DATE_TRUNC(
            'month',
            o.order_purchase_timestamp
        )::DATE
),


/*--------------------------------------------------------------
  Step 2: Calculate the 3-Month Moving Average
--------------------------------------------------------------*/
revenue_trend AS (

    SELECT
        month,
        monthly_revenue,

        AVG(monthly_revenue) OVER (
            ORDER BY month
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) AS moving_avg_3_month

    FROM monthly_sales
)


/*--------------------------------------------------------------
  Step 3: Generate Final Revenue Trend Report
--------------------------------------------------------------*/
SELECT
    TO_CHAR(month, 'YYYY-MM') AS month,

    ROUND(
        monthly_revenue::NUMERIC,
        2
    ) AS actual_revenue,

    ROUND(
        moving_avg_3_month::NUMERIC,
        2
    ) AS smoothed_revenue,

    ROUND(
        (
            monthly_revenue
            - moving_avg_3_month
        )::NUMERIC,
        2
    ) AS variance_from_trend

FROM revenue_trend

ORDER BY month;