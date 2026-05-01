-- =============================================================================
-- stg_targets.sql
-- Staging layer: casts and standardises the customer targets table
-- Grain: one row per customer_id
-- =============================================================================

SELECT
    CAST(customer_id AS text)            AS customer_id,
    CAST(ontime_target_pct AS numeric)   AS ontime_target_pct,
    CAST(infull_target_pct AS numeric)   AS infull_target_pct,
    CAST(otif_target_pct AS numeric)     AS otif_target_pct

FROM {{ source('raw_supply_chain', 'dim_targets_orders') }}
