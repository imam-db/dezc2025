-- Question 1: What is count of records for the 2024 Yellow Taxi Data?
SELECT COUNT(*) AS total_records
FROM `dezoomcamp2025-449022.dezc2025.yellow_trip_external`;


-- Question 2: Write a query to count the distinct number of PULocationIDs for the entire dataset on both the tables.
-- What is the estimated amount of data that will be read when this query is executed on the External Table and the Table?

-- external 0 B
SELECT COUNT(DISTINCT PULocationID) AS total_records
FROM `dezoomcamp2025-449022.dezc2025.yellow_trip_external`;

-- regular 155.12 MB
SELECT COUNT(DISTINCT PULocationID) AS total_records
FROM `dezoomcamp2025-449022.dezc2025.yellow_trip_regular`;


-- Question 3: Write a query to retrieve the PULocationID from the table (not the external table) in BigQuery. 
-- Now write a query to retrieve the PULocationID and DOLocationID on the same table. Why are the estimated number of Bytes different?

-- 155.12 MB
SELECT PULocationID
FROM `dezoomcamp2025-449022.dezc2025.yellow_trip_regular`;

-- 310.24 MB 
SELECT PULocationID, 
  DOLocationID
FROM `dezoomcamp2025-449022.dezc2025.yellow_trip_regular`;


-- Question 4: How many records have a fare_amount of 0?
SELECT COUNT(*) AS total_records
FROM `dezc2025.yellow_trip_external`
WHERE fare_amount = 0;


-- Question 5: What is the best strategy to make an optimized table in Big Query if your query will always filter based on tpep_dropoff_datetime and order the results by VendorID (Create a new table with this strategy)

-- partition by tpep_dropoff_datetime
-- cluster by VendorID
CREATE OR REPLACE TABLE dezc2025.yellow_trip_partitioned_clustered
PARTITION BY DATE(tpep_dropoff_datetime )
CLUSTER BY VendorID 
AS
SELECT *
FROM `dezc2025.yellow_trip_regular`;


-- Question 6: Write a query to retrieve the distinct VendorIDs between tpep_dropoff_datetime 2024-03-01 and 2024-03-15 (inclusive)
-- Use the materialized table you created earlier in your from clause and note the estimated bytes. 
-- Now change the table in the from clause to the partitioned table you created for question 5 and note the estimated bytes processed. What are these values? 

-- regular table
-- 310.24 MB
SELECT COUNT(DISTINCT VendorID) AS total_records
FROM `dezc2025.yellow_trip_regular`
WHERE tpep_dropoff_datetime BETWEEN '2024-03-01' AND '2024-03-15';

-- clustered table
-- 26.84 MB
SELECT COUNT(DISTINCT VendorID) AS total_records
FROM `dezc2025.yellow_trip_partitioned_clustered`
WHERE tpep_dropoff_datetime BETWEEN '2024-03-01' AND '2024-03-15';

-- Question 7: Where is the data stored in the External Table you created?
-- GCP Bucket


-- Question 8 : It is best practice in Big Query to always cluster your data:
-- False


