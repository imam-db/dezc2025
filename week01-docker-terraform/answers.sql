-- no. 3

SELECT
	SUM(CASE WHEN trip_distance <= 1 THEN 1 ELSE 0 END) AS "Up to 1 Mile",
	SUM(CASE WHEN trip_distance > 1 AND trip_distance <= 3 THEN 1 ELSE 0 END) AS "In between 1 (exclusive) and 3 miles (inclusive)", 
	SUM(CASE WHEN trip_distance > 3 AND trip_distance <= 7 THEN 1 ELSE 0 END) AS "In between 3 (exclusive) and 7 miles (inclusive)",
	SUM(CASE WHEN trip_distance > 7 AND trip_distance <= 10 THEN 1 ELSE 0 END) AS "In between 7 (exclusive) and 10 miles (inclusive)",
	SUM(CASE WHEN trip_distance > 10 THEN 1 ELSE 0 END) AS "Over 10 miles"
FROM tripdata AS td
WHERE DATE(td.lpep_pickup_datetime) >= '2019-10-01' 
	AND DATE(td.lpep_dropoff_datetime) < '2019-11-01';


-- no. 4

SELECT td.lpep_pickup_datetime::date AS date_trip,
     MAX(trip_distance) AS largest_distance
FROM tripdata AS td
GROUP BY td.lpep_pickup_datetime::date
ORDER BY largest_distance DESC
LIMIT 1;

-- no. 5

SELECT tz."Zone",
	SUM(td.total_amount) AS total_amount
FROM public.tripdata AS td
INNER JOIN public.taxizone AS tz
    ON td."PULocationID" = tz."LocationID"
WHERE td.lpep_pickup_datetime::date = '2019-10-18'
GROUP BY tz."Zone"
HAVING SUM(td.total_amount) > 13000;

-- no. 6

SELECT tzdo."Zone",
	td.tip_amount AS tip_amount
FROM public.tripdata AS td
INNER JOIN public.taxizone AS tzpu
ON td."PULocationID" = tzpu."LocationID"
INNER JOIN public.taxizone AS tzdo
ON td."DOLocationID" = tzdo."LocationID"
WHERE td.lpep_pickup_datetime::date BETWEEN '2019-10-01' AND '2019-10-31'
AND tzpu."Zone" = 'East Harlem North'
ORDER BY td.tip_amount DESC
LIMIT 1;

