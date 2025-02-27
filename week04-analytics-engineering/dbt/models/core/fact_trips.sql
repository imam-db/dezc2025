{{
    config(
        materialized='table'
    )
}}

with green_tripdata AS (
    SELECT *,
        'Green' AS service_type
    FROM {{ ref('stg_green') }}
),
yellow_tripdata AS (
    SELECT *,
        'Yellow' AS service_type
    FROM {{ ref('stg_yellow') }}
),
trips_union AS (
    SELECT *
    FROM green_tripdata
    UNION ALL
    SELECT *
    FROM yellow_tripdata
)
SELECT tu.tripid, 
    tu.vendorid, 
    tu.service_type,
    tu.ratecodeid, 
    tu.pickup_locationid, 
    tu.dropoff_locationid,  
    tu.pickup_datetime, 
    FORMAT_DATE('%Y', tu.pickup_datetime) AS period_year,
    FORMAT_DATE('%m', tu.pickup_datetime) AS period_month,
    FORMAT_DATE('%Q', tu.pickup_datetime) AS period_quarter,
    FORMAT_DATE('%Y-%Q', tu.pickup_datetime) AS period_year_quarter,
    tu.dropoff_datetime, 
    tu.store_and_fwd_flag, 
    tu.passenger_count, 
    tu.trip_distance, 
    tu.trip_type, 
    tu.fare_amount, 
    tu.extra, 
    tu.mta_tax, 
    tu.tip_amount, 
    tu.tolls_amount, 
    tu.ehail_fee, 
    tu.improvement_surcharge, 
    tu.total_amount, 
    tu.payment_type, 
    tu.payment_type_description
FROM trips_union AS tu