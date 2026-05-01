-- =============================================================================
-- stg_customers.sql
-- Staging layer: casts, cleans and standardises the customers dimension table
-- Grain: one row per customer_id
-- =============================================================================

WITH source_data AS (

    -- Standardise data types from raw source
    SELECT
        CAST(customer_id AS text)        AS customer_id,
        CAST(customer_name AS text)      AS customer_name,
        CAST(city AS text)               AS city

    FROM {{ source('raw_supply_chain', 'dim_customers') }}

),

deduplicated AS (

    -- Remove duplicate customer records
    SELECT
        customer_id,
        customer_name,
        city,

        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY customer_id
        ) AS row_num

    FROM source_data

),

cleaned AS (

    -- Keep one record per customer
    SELECT
        customer_id,
        customer_name,
        city

    FROM deduplicated
    WHERE row_num = 1

)

-- Final cleaned dataset at customer grain
SELECT
    customer_id,
    customer_name,
    city

FROM cleaned
