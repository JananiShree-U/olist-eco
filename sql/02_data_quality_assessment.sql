/*=====================================================================
                    OLIST E-COMMERCE PROJECT
                  Phase 1 - Data Quality Assessment
=======================================================================

Objective:
Validate the integrity and quality of the dataset before performing
Exploratory Data Analysis (EDA) and Business Analysis.

Checks Included:
1. Verify Table Structure
2. Duplicate Checks
3. Row Count Validation

=====================================================================*/


/*---------------------------------------------------------------------
1. VERIFY TABLE STRUCTURE
Preview the first 5 rows of each table to understand the schema and
confirm that the data was imported correctly.
---------------------------------------------------------------------*/

SELECT * FROM customers LIMIT 5;

SELECT * FROM orders LIMIT 5;

SELECT * FROM order_items LIMIT 5;

SELECT * FROM payments LIMIT 5;

SELECT * FROM reviews LIMIT 5;

SELECT * FROM products LIMIT 5;

SELECT * FROM sellers LIMIT 5;

SELECT * FROM category_translation LIMIT 5;


/*---------------------------------------------------------------------
2. DUPLICATE CHECKS
Verify that primary key columns do not contain duplicate values.
Expected Result:
Each query should return 0 rows.
---------------------------------------------------------------------*/


-- Duplicate Customer IDs

SELECT
    customer_id,
    COUNT(*) AS duplicate_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;



-- Duplicate Order IDs

SELECT
    order_id,
    COUNT(*) AS duplicate_count
FROM orders
GROUP BY order_id
HAVING COUNT(*) > 1;



-- Duplicate Product IDs

SELECT
    product_id,
    COUNT(*) AS duplicate_count
FROM products
GROUP BY product_id
HAVING COUNT(*) > 1;



-- Duplicate Seller IDs

SELECT
    seller_id,
    COUNT(*) AS duplicate_count
FROM sellers
GROUP BY seller_id
HAVING COUNT(*) > 1;


/*---------------------------------------------------------------------
3. ROW COUNT VALIDATION
Compare the imported row counts against the official Olist dataset.

---------------------------------------------------------------------*/

SELECT
    'customers' AS table_name,
    COUNT(*) AS row_count
FROM customers

UNION ALL

SELECT
    'orders',
    COUNT(*)
FROM orders

UNION ALL

SELECT
    'order_items',
    COUNT(*)
FROM order_items

UNION ALL

SELECT
    'payments',
    COUNT(*)
FROM payments

UNION ALL

SELECT
    'reviews',
    COUNT(*)
FROM reviews

UNION ALL

SELECT
    'products',
    COUNT(*)
FROM products

UNION ALL

SELECT
    'sellers',
    COUNT(*)
FROM sellers

UNION ALL

SELECT
    'category_translation',
    COUNT(*)
FROM category_translation;

/*---------------------------------------------------------------------
4. MISSING VALUE ANALYSIS
Count NULL values in important columns of every table.

Purpose:
Identify incomplete fields that may affect business analysis,
dashboard calculations, or joins.
---------------------------------------------------------------------*/


/*---------------------------------------------------------------------
4.1 CUSTOMERS TABLE
---------------------------------------------------------------------*/

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS missing_customer_id,
    COUNT(*) FILTER (WHERE customer_unique_id IS NULL) AS missing_customer_unique_id,
    COUNT(*) FILTER (WHERE customer_zip_code_prefix IS NULL) AS missing_zip_code,
    COUNT(*) FILTER (WHERE customer_city IS NULL) AS missing_city,
    COUNT(*) FILTER (WHERE customer_state IS NULL) AS missing_state
FROM customers;


/*---------------------------------------------------------------------
4.2 ORDERS TABLE
---------------------------------------------------------------------*/

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE order_id IS NULL) AS missing_order_id,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS missing_customer_id,
    COUNT(*) FILTER (WHERE order_status IS NULL) AS missing_order_status,
    COUNT(*) FILTER (WHERE order_purchase_timestamp IS NULL)
        AS missing_purchase_timestamp,
    COUNT(*) FILTER (WHERE order_approved_at IS NULL)
        AS missing_approved_at,
    COUNT(*) FILTER (WHERE order_delivered_carrier_date IS NULL)
        AS missing_carrier_date,
    COUNT(*) FILTER (WHERE order_delivered_customer_date IS NULL)
        AS missing_customer_delivery_date,
    COUNT(*) FILTER (WHERE order_estimated_delivery_date IS NULL)
        AS missing_estimated_delivery_date
FROM orders;


/*---------------------------------------------------------------------
4.3 ORDER ITEMS TABLE
---------------------------------------------------------------------*/

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE order_id IS NULL) AS missing_order_id,
    COUNT(*) FILTER (WHERE order_item_id IS NULL) AS missing_order_item_id,
    COUNT(*) FILTER (WHERE product_id IS NULL) AS missing_product_id,
    COUNT(*) FILTER (WHERE seller_id IS NULL) AS missing_seller_id,
    COUNT(*) FILTER (WHERE shipping_limit_date IS NULL)
        AS missing_shipping_limit_date,
    COUNT(*) FILTER (WHERE price IS NULL) AS missing_price,
    COUNT(*) FILTER (WHERE freight_value IS NULL) AS missing_freight_value
FROM order_items;


/*---------------------------------------------------------------------
4.4 PAYMENTS TABLE
---------------------------------------------------------------------*/

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE order_id IS NULL) AS missing_order_id,
    COUNT(*) FILTER (WHERE payment_sequential IS NULL)
        AS missing_payment_sequential,
    COUNT(*) FILTER (WHERE payment_type IS NULL) AS missing_payment_type,
    COUNT(*) FILTER (WHERE payment_installments IS NULL)
        AS missing_installments,
    COUNT(*) FILTER (WHERE payment_value IS NULL) AS missing_payment_value
FROM payments;


/*---------------------------------------------------------------------
4.5 REVIEWS TABLE
---------------------------------------------------------------------*/

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE review_id IS NULL) AS missing_review_id,
    COUNT(*) FILTER (WHERE order_id IS NULL) AS missing_order_id,
    COUNT(*) FILTER (WHERE review_score IS NULL) AS missing_review_score,
    COUNT(*) FILTER (WHERE review_comment_title IS NULL)
        AS missing_comment_title,
    COUNT(*) FILTER (WHERE review_comment_message IS NULL)
        AS missing_comment_message,
    COUNT(*) FILTER (WHERE review_creation_date IS NULL)
        AS missing_creation_date,
    COUNT(*) FILTER (WHERE review_answer_timestamp IS NULL)
        AS missing_answer_timestamp
FROM reviews;


/*---------------------------------------------------------------------
4.6 PRODUCTS TABLE
---------------------------------------------------------------------*/

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE product_id IS NULL) AS missing_product_id,
    COUNT(*) FILTER (WHERE product_category_name IS NULL)
        AS missing_category_name,
    COUNT(*) FILTER (WHERE product_name_length IS NULL)
        AS missing_name_length,
    COUNT(*) FILTER (WHERE product_description_length IS NULL)
        AS missing_description_length,
    COUNT(*) FILTER (WHERE product_photos_qty IS NULL)
        AS missing_photos_quantity,
    COUNT(*) FILTER (WHERE product_weight_g IS NULL)
        AS missing_weight,
    COUNT(*) FILTER (WHERE product_length_cm IS NULL)
        AS missing_length,
    COUNT(*) FILTER (WHERE product_height_cm IS NULL)
        AS missing_height,
    COUNT(*) FILTER (WHERE product_width_cm IS NULL)
        AS missing_width
FROM products;


/*---------------------------------------------------------------------
4.7 SELLERS TABLE
---------------------------------------------------------------------*/

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE seller_id IS NULL) AS missing_seller_id,
    COUNT(*) FILTER (WHERE seller_zip_code_prefix IS NULL)
        AS missing_zip_code,
    COUNT(*) FILTER (WHERE seller_city IS NULL) AS missing_city,
    COUNT(*) FILTER (WHERE seller_state IS NULL) AS missing_state
FROM sellers;


/*---------------------------------------------------------------------
4.8 CATEGORY TRANSLATION TABLE
---------------------------------------------------------------------*/

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE product_category_name IS NULL)
        AS missing_portuguese_category,
    COUNT(*) FILTER (WHERE product_category_name_english IS NULL)
        AS missing_english_category
FROM category_translation;

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE customer_id IS NULL) AS missing_customer_id,
    COUNT(*) FILTER (WHERE customer_unique_id IS NULL) AS missing_customer_unique_id,
    COUNT(*) FILTER (WHERE customer_zip_code_prefix IS NULL) AS missing_zip_code,
    COUNT(*) FILTER (WHERE customer_city IS NULL) AS missing_city,
    COUNT(*) FILTER (WHERE customer_state IS NULL) AS missing_state
FROM customers;
