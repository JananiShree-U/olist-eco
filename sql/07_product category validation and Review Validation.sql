-- ============================================================
-- 9.1 PRODUCT CATEGORY VALIDATION SUMMARY
-- ============================================================

SELECT
    'Products With Missing Category' AS validation,
    COUNT(*) AS affected_records
FROM products
WHERE product_category_name IS NULL

UNION ALL

SELECT
    'Products With Category but Missing Translation',
    COUNT(*)
FROM products p
LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
WHERE p.product_category_name IS NOT NULL
  AND ct.product_category_name_english IS NULL

UNION ALL

SELECT
    'Duplicate Portuguese Categories in Translation Table',
    COUNT(*)
FROM (
    SELECT product_category_name
    FROM category_translation
    GROUP BY product_category_name
    HAVING COUNT(*) > 1
) duplicate_categories

UNION ALL

SELECT
    'Duplicate English Categories in Translation Table',
    COUNT(*)
FROM (
    SELECT product_category_name_english
    FROM category_translation
    WHERE product_category_name_english IS NOT NULL
    GROUP BY product_category_name_english
    HAVING COUNT(*) > 1
) duplicate_english_categories

UNION ALL

SELECT
    'Translation Categories Not Used by Products',
    COUNT(*)
FROM category_translation ct
LEFT JOIN products p
    ON ct.product_category_name = p.product_category_name
WHERE p.product_id IS NULL

UNION ALL

SELECT
    'Products With Valid English Translation',
    COUNT(*)
FROM products p
INNER JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name
WHERE ct.product_category_name_english IS NOT NULL;


-- ============================================================
-- 9.2 INVESTIGATE CATEGORIES WITHOUT ENGLISH TRANSLATION
-- ============================================================

SELECT
    p.product_category_name,
    COUNT(*) AS total_products
FROM products p

LEFT JOIN category_translation ct
    ON p.product_category_name = ct.product_category_name

WHERE p.product_category_name IS NOT NULL
  AND ct.product_category_name_english IS NULL

GROUP BY p.product_category_name
ORDER BY total_products DESC;


-- ============================================================
-- 10.1 REVIEW VALIDATION SUMMARY
-- ============================================================

SELECT
    'Missing Review Score' AS validation,
    COUNT(*) AS affected_records
FROM reviews
WHERE review_score IS NULL

UNION ALL

SELECT
    'Invalid Review Score (<1 OR >5)',
    COUNT(*)
FROM reviews
WHERE review_score NOT BETWEEN 1 AND 5

UNION ALL

SELECT
    'Duplicate Review IDs',
    COUNT(*)
FROM (
    SELECT review_id
    FROM reviews
    GROUP BY review_id
    HAVING COUNT(*) > 1
) duplicate_reviews

UNION ALL

SELECT
    'Multiple Reviews for Same Order',
    COUNT(*)
FROM (
    SELECT order_id
    FROM reviews
    GROUP BY order_id
    HAVING COUNT(*) > 1
) duplicate_orders

UNION ALL

SELECT
    'Missing Review Creation Date',
    COUNT(*)
FROM reviews
WHERE review_creation_date IS NULL

UNION ALL

SELECT
    'Missing Review Answer Timestamp',
    COUNT(*)
FROM reviews
WHERE review_answer_timestamp IS NULL

UNION ALL

SELECT
    'Review Answer Before Creation',
    COUNT(*)
FROM reviews
WHERE review_answer_timestamp < review_creation_date

UNION ALL

SELECT
    'Missing Review Title',
    COUNT(*)
FROM reviews
WHERE review_comment_title IS NULL

UNION ALL

SELECT
    'Missing Review Message',
    COUNT(*)
FROM reviews
WHERE review_comment_message IS NULL;

-- ============================================================
-- INVESTIGATE DUPLICATE REVIEW IDs
-- ============================================================

SELECT
    review_id,
    COUNT(*) AS occurrences
FROM reviews
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY occurrences DESC, review_id
LIMIT 20;

-- ============================================================
-- CHECK WHETHER DUPLICATE REVIEW IDs BELONG TO DIFFERENT ORDERS
-- ============================================================

SELECT
    review_id,
    COUNT(DISTINCT order_id) AS unique_orders,
    COUNT(*) AS total_records
FROM reviews
GROUP BY review_id
HAVING COUNT(*) > 1
ORDER BY total_records DESC;