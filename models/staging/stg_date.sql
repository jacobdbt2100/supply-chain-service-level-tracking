-- =============================================================================
-- stg_date.sql
-- Staging layer: casts and standardises the date dimension table
-- Grain: one row per date
-- =============================================================================

SELECT
    CAST(date AS date)           AS date,
    CAST(mmm_yy AS text)         AS mmm_yy,
    CAST(week_no AS integer)     AS week_no

FROM {{ source('raw_supply_chain', 'dim_date') }}
