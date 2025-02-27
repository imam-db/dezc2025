{{config(materialized='table')}}

WITH cte AS
(
    SELECT *,
        TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, second) AS trip_duration
    FROM {{ref("dim_fhv_trips")}}
)
SELECT *,
    PERCENTILE_CONT(trip_duration, 0.90) OVER(PARTITION BY period_year, period_month, pickup_locationid, dropoff_locationid) AS p90
FROM cte