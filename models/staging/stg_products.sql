-- =============================================================================
-- stg_products.sql
-- Staging layer: casts, cleans and standardises the products dimension table
-- Grain: one row per product_id
-- =============================================================================

WITH source_data AS (

    -- Standardise data types from raw source
    SELECT
        CAST(product_id AS text)        AS product_id,
        CAST(product_name AS text)      AS product_name,
        CAST(category AS text)          AS category

    FROM {{ source('raw_supply_chain', 'dim_products') }}

),

deduplicated AS (

    -- Remove duplicate product records
    SELECT
        product_id,
        product_name,
        category,

        ROW_NUMBER() OVER (
            PARTITION BY product_id
            ORDER BY product_id
        ) AS row_num

    FROM source_data

),

cleaned AS (

    -- Keep one record per product
    SELECT
        product_id,
        product_name,
        category

    FROM deduplicated
    WHERE row_num = 1

)

-- Final cleaned dataset at product grain
SELECT
    product_id,
    product_name,
    category

FROM cleaned

