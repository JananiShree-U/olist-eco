/*---------------------------------------------------------------------
4.1 CUSTOMERS TABLE - Missing Value Analysis
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
RESULT - CUSTOMERS TABLE

Total Records: 99,441

Missing Values:
Customer ID             : 0
Customer Unique ID      : 0
ZIP Code                : 0
City                    : 0
State                   : 0

Conclusion:
No missing values found.
The customers table is complete and ready for analysis.
---------------------------------------------------------------------*/
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
RESULT - ORDERS TABLE

Total Records: 99,441

Missing Values:
Order ID                     : 0
Customer ID                  : 0
Order Status                 : 0
Purchase Timestamp           : 0
Approved At                  : 160
Delivered Carrier Date       : 1,783
Delivered Customer Date      : 2,965
Estimated Delivery Date      : 0

Conclusion:
The missing timestamp values are expected for cancelled,
unavailable, or undelivered orders. These represent valid
business scenarios and do not require data cleaning.

The orders table is suitable for further analysis.
---------------------------------------------------------------------*/
/*---------------------------------------------------------------------
4.3 ORDERS ITEMS TABLE
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
RESULT - ORDER ITEMS TABLE

Total Records: 112,650

Missing Values:
Order ID               : 0
Order Item ID          : 0
Product ID             : 0
Seller ID              : 0
Shipping Limit Date    : 0
Price                  : 0
Freight Value          : 0

Conclusion:
No missing values found.
The order_items table is complete and ready for business analysis.
---------------------------------------------------------------------*/
/*---------------------------------------------------------------------
4.4 PAYMENT TABLE
---------------------------------------------------------------------*/

SELECT
    COUNT(*) AS total_rows,
    COUNT(*) FILTER (WHERE order_id IS NULL) AS missing_order_id,
    COUNT(*) FILTER (WHERE payment_sequential IS NULL)
        AS missing_payment_sequential,
    COUNT(*) FILTER (WHERE payment_type IS NULL)
        AS missing_payment_type,
    COUNT(*) FILTER (WHERE payment_installments IS NULL)
        AS missing_installments,
    COUNT(*) FILTER (WHERE payment_value IS NULL)
        AS missing_payment_value
FROM payments;

/*---------------------------------------------------------------------
RESULT - PAYMENTS TABLE

Total Records: 103,886

Missing Values:
Order ID                 : 0
Payment Sequential       : 0
Payment Type             : 0
Payment Installments     : 0
Payment Value            : 0

Conclusion:
No missing values found.
The payments table is complete and ready for analysis.
---------------------------------------------------------------------*/
/*---------------------------------------------------------------------
4.5 Reviews Table
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
RESULT - REVIEWS TABLE

Total Records: 99,224

Missing Values:
Review ID                  : 0
Order ID                   : 0
Review Score               : 0
Review Comment Title       : 87,656
Review Comment Message     : 58,247
Review Creation Date       : 0
Review Answer Timestamp    : 0

Conclusion:
Review titles and messages are optional fields.
Many customers provide only a review score without written feedback.
These NULL values represent expected customer behavior and do not
require data cleaning.
---------------------------------------------------------------------*/
/*---------------------------------------------------------------------
4.6 Products Table
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
RESULT - PRODUCTS TABLE

Total Records: 32,951

Missing Values:
Product ID                  : 0
Category Name               : 610
Product Name Length         : 610
Description Length          : 610
Photos Quantity             : 610
Weight                      : 2
Length                      : 2
Height                      : 2
Width                       : 2

Conclusion:
Approximately 1.85% of products have incomplete metadata
(category, description, and photos). This is likely due to
incomplete product catalog information.

Only two products have missing physical dimensions, which has
minimal business impact.

The products table is suitable for analysis. Category-based
analyses should account for uncategorized products.
---------------------------------------------------------------------*/
/*---------------------------------------------------------------------
4.7 Sellers Table
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
RESULT - SELLERS TABLE

Total Records: 3,095

Missing Values:
Seller ID                : 0
ZIP Code                 : 0
City                     : 0
State                    : 0

Conclusion:
No missing values found.
The sellers table is complete and ready for analysis.
---------------------------------------------------------------------*/