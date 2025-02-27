{{
    config(
        materialized='table'
    )
}}

with fhv_tripdata AS (
    SELECT *,
        'FHV' AS service_type
    FROM {{ ref('stg_fhv') }}
),
dim_zones AS (
    SELECT *
    FROM {{ ref('dim_zones') }}
    WHERE borough != 'Unknown'
)
SELECT f.dispatching_base_num,
    f.pickup_locationid, 
    pickup_zone.borough as pickup_borough, 
    pickup_zone.zone as pickup_zone, 
    f.dropoff_locationid,
    dropoff_zone.borough as dropoff_borough, 
    dropoff_zone.zone as dropoff_zone,  
    f.pickup_datetime, 
    FORMAT_DATE('%Y', f.pickup_datetime) AS period_year,
    FORMAT_DATE('%m', f.pickup_datetime) AS period_month,
    f.dropoff_datetime, 
    f.sr_flag, 
    f.affiliated_base_number,
    'FHV' as service_type
FROM fhv_tripdata AS f
INNER JOIN dim_zones AS pickup_zone
ON f.pickup_locationid = pickup_zone.locationid
INNER JOIN dim_zones AS dropoff_zone
ON f.dropoff_locationid = dropoff_zone.locationid