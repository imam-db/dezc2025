{{
    config(
        materialized='view'
    )
}}
SELECT DISTINCT service_type,
    period_year,
    period_month,
    PERCENTILE_CONT(fare_amount, 0.97) OVER(PARTITION BY service_type, period_year, period_month) AS p97,
    PERCENTILE_CONT(fare_amount, 0.95) OVER(PARTITION BY service_type, period_year, period_month) AS p95,
    PERCENTILE_CONT(fare_amount, 0.90) OVER(PARTITION BY service_type, period_year, period_month) AS p90
FROM {{ref("fact_trips")}}
WHERE fare_amount > 0
AND trip_distance > 0
AND payment_type_description IN ('Cash', 'Credit card')