-- =============================================================================
-- stg_order_lines.sql
-- Staging layer: casts, cleans and standardises order lines fact table
-- Grain: one row per order line (order_id + product_id)
-- =============================================================================

WITH source_data AS (

    -- Standardise data types from raw source
    SELECT
        CAST(order_id AS text)                AS order_id,
        CAST(order_placement_date AS date)    AS order_placement_date,
        CAST(customer_id AS text)             AS customer_id,
        CAST(product_id AS text)              AS product_id,
        CAST(order_qty AS integer)            AS order_qty,
        CAST(agreed_delivery_date AS date)    AS agreed_delivery_date,
        CAST(actual_delivery_date AS date)    AS actual_delivery_date,
        CAST(delivery_qty AS integer)         AS delivery_qty

    FROM {{ source('raw_supply_chain', 'fact_order_lines') }}

),

deduplicated AS (

    -- Remove duplicate order line records
    -- Grain enforced: order_id + product_id
    SELECT
        order_id,
        order_placement_date,
        customer_id,
        product_id,
        order_qty,
        agreed_delivery_date,
        actual_delivery_date,
        delivery_qty,

        ROW_NUMBER() OVER (
            PARTITION BY order_id, product_id
            ORDER BY order_placement_date
        ) AS row_num

    FROM source_data

),

cleaned AS (

    -- Keep unique order lines
    SELECT
        order_id,
        order_placement_date,
        customer_id,
        product_id,
        order_qty,
        agreed_delivery_date,
        actual_delivery_date,
        delivery_qty

    FROM deduplicated
    WHERE row_num = 1

)

SELECT
    order_id,
    order_placement_date,
    customer_id,
    product_id,
    order_qty,
    agreed_delivery_date,
    actual_delivery_date,
    delivery_qty
FROM cleaned
