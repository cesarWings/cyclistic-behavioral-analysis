-- Master Cleaning and Feature Engineering Script
CREATE OR REPLACE TABLE `cyclistic_data.combined_tripdata_cleaned` AS
SELECT 
  ride_id,
  rideable_type,
  member_casual,
  started_at,
  ended_at,
  start_station_name,
  end_station_name,
  
  -- Step 6 Equivalent: Calculate Ride Length
  TIMESTAMP_DIFF(ended_at, started_at, MINUTE) AS ride_length_minutes,
  
  -- Step 7 Equivalent: Calculate Day of Week (1 = Sunday, 7 = Saturday)
  EXTRACT(DAYOFWEEK FROM started_at) AS day_of_week,
  
  -- Additional Feature Engineering for Temporal Analysis
  EXTRACT(HOUR FROM started_at) AS hour_of_day,
  EXTRACT(MONTH FROM started_at) AS month_number,
  FORMAT_TIMESTAMP('%B', started_at) AS month_name,
  
  -- Custom Optimization: Ride Duration Buckets
  CASE 
    WHEN TIMESTAMP_DIFF(ended_at, started_at, MINUTE) <= 10 THEN '0-10 Mins'
    WHEN TIMESTAMP_DIFF(ended_at, started_at, MINUTE) <= 30 THEN '10-30 Mins'
    WHEN TIMESTAMP_DIFF(ended_at, started_at, MINUTE) <= 60 THEN '30-60 Mins'
    ELSE '1+ Hours'
  END AS ride_duration_bucket

FROM `cyclistic_data.combined_tripdata_raw`
-- Data Cleaning Filters
WHERE started_at < ended_at 
  AND TIMESTAMP_DIFF(ended_at, started_at, SECOND) >= 60; 
