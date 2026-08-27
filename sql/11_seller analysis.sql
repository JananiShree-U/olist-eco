/*==============================================================
  Analysis     : 2.4.1 Seller KPIs
  Description  : Calculate overall seller performance metrics.
==============================================================*/

WITH seller_performance AS (

    SELECT
        s.seller_id,

        COUNT(DISTINCT o.order_id) AS total_orders,

        SUM(oi.price) AS total_revenue

    FROM sellers s

    INNER JOIN order_items oi
        ON s.seller_id = oi.seller_id

    INNER JOIN orders o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY
        s.seller_id
)

SELECT
    COUNT(*) AS total_sellers,

    SUM(total_orders) AS total_orders_fulfilled,

    ROUND(
        SUM(total_revenue)::NUMERIC,
        2
    ) AS total_revenue_generated,

    ROUND(
        AVG(total_revenue)::NUMERIC,
        2
    ) AS average_revenue_per_seller,

    ROUND(
        AVG(total_orders)::NUMERIC,
        2
    ) AS average_orders_per_seller

FROM seller_performance;

/*==============================================================
  Analysis     : 2.4.2 Top Performing Sellers
  Description  : Identify the highest revenue-generating sellers.
==============================================================*/

WITH seller_metrics AS (

    SELECT
        s.seller_id,

        COUNT(DISTINCT o.order_id) AS total_orders,

        SUM(oi.price) AS total_revenue,

        ROUND(
            AVG(oi.price)::NUMERIC,
            2
        ) AS average_item_value

    FROM sellers s

    INNER JOIN order_items oi
        ON s.seller_id = oi.seller_id

    INNER JOIN orders o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY
        s.seller_id
),

seller_ranked AS (

    SELECT
        seller_id,

        total_orders,

        ROUND(
            total_revenue::NUMERIC,
            2
        ) AS total_revenue,

        average_item_value,

        ROUND(
            (
                total_revenue * 100.0
                / SUM(total_revenue) OVER ()
            )::NUMERIC,
            2
        ) AS revenue_share_pct,

        DENSE_RANK() OVER (
            ORDER BY total_revenue DESC
        ) AS seller_rank

    FROM seller_metrics
)

SELECT *

FROM seller_ranked

ORDER BY
    seller_rank

LIMIT 10;

/*==============================================================
  Analysis     : 2.4.3 Seller Revenue Distribution (Pareto)
  Description  : Determine how many sellers generate
                 50%, 80%, and 90% of total revenue.
==============================================================*/

WITH seller_revenue AS (

    SELECT
        oi.seller_id,

        SUM(oi.price) AS total_revenue

    FROM order_items oi

    INNER JOIN orders o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY
        oi.seller_id
),

revenue_ranked AS (

    SELECT
        seller_id,

        total_revenue,

        SUM(total_revenue) OVER (
            ORDER BY total_revenue DESC
        ) AS cumulative_revenue,

        SUM(total_revenue) OVER () AS overall_revenue

    FROM seller_revenue
),

pareto AS (

    SELECT
        seller_id,

        total_revenue,

        cumulative_revenue,

        ROUND(
            (
                cumulative_revenue * 100.0
                / overall_revenue
            )::NUMERIC,
            2
        ) AS cumulative_revenue_pct

    FROM revenue_ranked
)

SELECT

    MIN(
        CASE
            WHEN cumulative_revenue_pct >= 50
            THEN row_num
        END
    ) AS sellers_for_50_percent_revenue,

    MIN(
        CASE
            WHEN cumulative_revenue_pct >= 80
            THEN row_num
        END
    ) AS sellers_for_80_percent_revenue,

    MIN(
        CASE
            WHEN cumulative_revenue_pct >= 90
            THEN row_num
        END
    ) AS sellers_for_90_percent_revenue,

    COUNT(*) AS total_sellers

FROM (

    SELECT
        *,
        ROW_NUMBER() OVER (
            ORDER BY total_revenue DESC
        ) AS row_num

    FROM pareto

) ranked;

/*==============================================================
  Analysis     : 2.4.4 Seller Geographic Performance
  Description  : Analyze seller performance by state.
==============================================================*/

WITH seller_state_metrics AS (

    SELECT
        s.seller_state,

        COUNT(DISTINCT s.seller_id) AS total_sellers,

        COUNT(DISTINCT o.order_id) AS total_orders,

        SUM(oi.price) AS total_revenue

    FROM sellers s

    INNER JOIN order_items oi
        ON s.seller_id = oi.seller_id

    INNER JOIN orders o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY
        s.seller_state
)

SELECT
    seller_state,

    total_sellers,

    total_orders,

    ROUND(
        total_revenue::NUMERIC,
        2
    ) AS total_revenue,

    ROUND(
        (
            total_revenue
            / total_sellers
        )::NUMERIC,
        2
    ) AS average_revenue_per_seller,

    ROUND(
        (
            total_orders::NUMERIC
            / total_sellers
        ),
        2
    ) AS average_orders_per_seller

FROM seller_state_metrics

ORDER BY
    total_revenue DESC;
/*==============================================================
  Analysis     : 2.4.5 Seller Delivery Performance
  Description  : Evaluate seller delivery performance using
                 one unique record per seller-order combination.
==============================================================*/

WITH seller_orders AS (

    SELECT DISTINCT
        oi.seller_id,
        o.order_id,
        o.order_purchase_timestamp,
        o.order_delivered_customer_date,
        o.order_estimated_delivery_date

    FROM orders o

    INNER JOIN order_items oi
        ON o.order_id = oi.order_id

    WHERE
        o.order_status = 'delivered'
        AND o.order_delivered_customer_date IS NOT NULL
        AND o.order_estimated_delivery_date IS NOT NULL
        AND o.order_purchase_timestamp IS NOT NULL
),

seller_delivery AS (

    SELECT
        seller_id,

        COUNT(*) AS total_orders,

        AVG(
            EXTRACT(
                EPOCH FROM (
                    order_delivered_customer_date
                    - order_purchase_timestamp
                )
            ) / 86400.0
        ) AS avg_delivery_days,

        SUM(
            CASE
                WHEN order_delivered_customer_date
                     <= order_estimated_delivery_date
                THEN 1
                ELSE 0
            END
        ) AS on_time_deliveries,

        SUM(
            CASE
                WHEN order_delivered_customer_date
                     > order_estimated_delivery_date
                THEN 1
                ELSE 0
            END
        ) AS late_deliveries

    FROM seller_orders

    GROUP BY
        seller_id
)

SELECT
    seller_id,

    total_orders,

    ROUND(
        avg_delivery_days::NUMERIC,
        2
    ) AS avg_delivery_days,

    on_time_deliveries,

    late_deliveries,

    ROUND(
        (
            on_time_deliveries * 100.0
            / NULLIF(total_orders, 0)
        )::NUMERIC,
        2
    ) AS on_time_pct,

    ROUND(
        (
            late_deliveries * 100.0
            / NULLIF(total_orders, 0)
        )::NUMERIC,
        2
    ) AS late_pct

FROM seller_delivery

ORDER BY
    total_orders DESC

LIMIT 10;

/*==============================================================
  Analysis     : 2.4.6 Seller Segmentation
  Description  : Segment sellers based on revenue and orders.
==============================================================*/

WITH seller_metrics AS (

    SELECT
        oi.seller_id,

        COUNT(DISTINCT o.order_id) AS total_orders,

        SUM(oi.price) AS total_revenue

    FROM order_items oi

    INNER JOIN orders o
        ON oi.order_id = o.order_id

    WHERE o.order_status = 'delivered'

    GROUP BY
        oi.seller_id
),

revenue_percentiles AS (

    SELECT DISTINCT
        total_revenue,

        PERCENT_RANK() OVER (
            ORDER BY total_revenue
        ) AS revenue_percentile

    FROM seller_metrics
),

order_percentiles AS (

    SELECT DISTINCT
        total_orders,

        PERCENT_RANK() OVER (
            ORDER BY total_orders
        ) AS order_percentile

    FROM seller_metrics
),

seller_scores AS (

    SELECT
        sm.seller_id,

        sm.total_orders,

        sm.total_revenue,

        CASE
            WHEN rp.revenue_percentile >= 0.80 THEN 5
            WHEN rp.revenue_percentile >= 0.60 THEN 4
            WHEN rp.revenue_percentile >= 0.40 THEN 3
            WHEN rp.revenue_percentile >= 0.20 THEN 2
            ELSE 1
        END AS revenue_score,

        CASE
            WHEN op.order_percentile >= 0.80 THEN 5
            WHEN op.order_percentile >= 0.60 THEN 4
            WHEN op.order_percentile >= 0.40 THEN 3
            WHEN op.order_percentile >= 0.20 THEN 2
            ELSE 1
        END AS order_score

    FROM seller_metrics sm

    JOIN revenue_percentiles rp
        ON sm.total_revenue = rp.total_revenue

    JOIN order_percentiles op
        ON sm.total_orders = op.total_orders
),

seller_segments AS (

    SELECT
        *,

        CASE

            WHEN revenue_score >= 4
             AND order_score >= 4
            THEN 'Top Performers'

            WHEN revenue_score >= 4
             AND order_score <= 3
            THEN 'Premium Sellers'

            WHEN revenue_score <= 3
             AND order_score >= 4
            THEN 'High Volume Sellers'

            WHEN revenue_score = 3
             AND order_score = 3
            THEN 'Growth Sellers'

            WHEN revenue_score <= 2
             AND order_score <= 2
            THEN 'Low Performers'

            ELSE 'Average Sellers'

        END AS seller_segment

    FROM seller_scores
)

SELECT

    seller_segment,

    COUNT(*) AS total_sellers,

    ROUND(
        COUNT(*) * 100.0
        / SUM(COUNT(*)) OVER (),
        2
    ) AS seller_percentage,

    ROUND(
        SUM(total_revenue)::NUMERIC,
        2
    ) AS total_revenue,

    ROUND(
        AVG(total_revenue)::NUMERIC,
        2
    ) AS avg_revenue_per_seller,

    ROUND(
        AVG(total_orders)::NUMERIC,
        2
    ) AS avg_orders_per_seller

FROM seller_segments

GROUP BY
    seller_segment

ORDER BY
    total_revenue DESC;
