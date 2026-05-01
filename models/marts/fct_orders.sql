-- =============================================================================
-- fct_orders.sql
-- Mart layer: order-level service performance
-- Grain: one row per order_id
-- =============================================================================

WITH aggregated AS (

    SELECT
        order_id,

        -- Stable attributes per order
        MIN(customer_name)           AS customer_name,
        MIN(city)                    AS city,
        MIN(order_placement_date)    AS order_placement_date,
        MIN(delay_days)              AS delay_days,
        BOOL_OR(late_delivery_flag)  AS late_delivery_flag,
        MIN(month)                   AS month,

        -- Aggregated flags (all lines must be TRUE)
        BOOL_AND(on_time_flag)       AS on_time_flag,
        BOOL_AND(in_full_flag)       AS in_full_flag

    FROM {{ ref('fct_order_lines') }}
    GROUP BY order_id

),

final AS (

    SELECT
        order_id,
        customer_name,
        city,
        order_placement_date,
        delay_days,
        late_delivery_flag,
        month,
        on_time_flag,
        in_full_flag,

        -- OTIF derived at order level
        CASE
            WHEN on_time_flag = TRUE AND in_full_flag = TRUE THEN TRUE
            ELSE FALSE
        END AS otif_flag

    FROM aggregated

)

SELECT
    order_id,
    customer_name,
    city,
    order_placement_date,
    delay_days,
    late_delivery_flag,
    month,
    on_time_flag,
    in_full_flag,
    otif_flag

FROM final
