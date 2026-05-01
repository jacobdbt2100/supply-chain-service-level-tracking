-- =============================================================================
-- fct_order_lines.sql
-- Mart layer: enriched order line data with service level metrics
-- Grain: one row per order line (order_id + product_id)
-- =============================================================================

WITH base AS (

    SELECT
        ol.order_id,
        ol.order_placement_date,
        -- ol.customer_id,
        -- ol.product_id,
        ol.order_qty,
        -- ol.agreed_delivery_date,
        -- ol.actual_delivery_date,
        ol.delivery_qty,

        c.customer_name,
        c.city,
        p.product_name,
        p.category,

        -- On-time flag
        CASE
            WHEN ol.actual_delivery_date <= ol.agreed_delivery_date THEN TRUE
            ELSE FALSE
        END AS on_time_flag,

        -- In-full flag
        CASE
            WHEN ol.delivery_qty >= ol.order_qty THEN TRUE
            ELSE FALSE
        END AS in_full_flag,

        -- OTIF flag
        CASE
            WHEN ol.actual_delivery_date <= ol.agreed_delivery_date
             AND ol.delivery_qty >= ol.order_qty
            THEN TRUE
            ELSE FALSE
        END AS otif_flag,

        -- Line fulfilled flag (strict fulfilment)
        CASE
            WHEN ol.delivery_qty >= ol.order_qty THEN TRUE
            ELSE FALSE
        END AS line_fulfilled_flag,

        -- Volume fill rate (in percentage)
        ROUND(
        CASE
            WHEN ol.order_qty = 0 THEN NULL
            ELSE (ol.delivery_qty * 100.0 / ol.order_qty)
        END,
        2
            ) AS volume_fill_rate_pct,

        -- Delay in days
        (ol.actual_delivery_date - ol.agreed_delivery_date) AS delay_days,

        -- Late delivery flag
        CASE
            WHEN ol.actual_delivery_date > ol.agreed_delivery_date THEN TRUE
            ELSE FALSE
        END AS late_delivery_flag,

        -- Time dimensions
        EXTRACT(MONTH FROM ol.order_placement_date) AS month,
        EXTRACT(WEEK FROM ol.order_placement_date)  AS week,
        EXTRACT(DAY FROM ol.order_placement_date)   AS day

    FROM {{ ref('stg_order_lines') }} ol
    LEFT JOIN {{ ref('stg_customers') }} c
        ON ol.customer_id = c.customer_id
    LEFT JOIN {{ ref('stg_products') }} p
        ON ol.product_id = p.product_id

)

SELECT
    order_id,
    order_placement_date,
    order_qty,
    delivery_qty,
    customer_name,
    city,
    product_name,
    category,
    on_time_flag,
    in_full_flag,
    otif_flag,
    line_fulfilled_flag,
    volume_fill_rate_pct,
    delay_days,
    late_delivery_flag,
    month,
    week,
    day

FROM base
