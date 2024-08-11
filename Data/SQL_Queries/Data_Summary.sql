USE Divvy_tripdata;

GO

-- Check for NULL ids & duplicate rides
WITH All_data AS (
    SELECT 
        *
    FROM
        dbo.data_2021

    UNION ALL

    SELECT 
        *
    FROM
        dbo.data_2022
)

SELECT
    'Data_2021 + 2022',
    (SELECT COUNT(Counts_Per_Id.DUPLICATES_ID) 
     FROM (SELECT
            COUNT(ride_id) DUPLICATES_ID
           FROM
            All_data
           GROUP BY 
            ride_id
           HAVING
            COUNT(ride_id) > 1)AS Counts_Per_Id) AS Count_Duplicates_Id ,
    (SELECT 
        SUM(CASE 
            WHEN ride_id IS NULL THEN 1
            ELSE 0
        END) 
    FROM
        All_data) AS Count_NULL_Id;

GO

-- Summary of the two tables in wide format
SELECT '2021' AS Year,
    COUNT(*) +
        SUM(CASE
                WHEN ride_id IS NULL THEN 1
                ELSE 0
            END) AS Number_Of_Rides,
    (SELECT COUNT(Counts_per_ride.RIDES_COUNT)
     FROM   
        (SELECT 
            COUNT(data_2021.ride_id) AS RIDES_COUNT
            FROM
            data_2021
        GROUP BY
            data_2021.ride_id
        HAVING
            COUNT(data_2021.ride_id) > 1
        ) Counts_per_ride

    ) AS Duplicates,
    (SELECT 
        SUM(CASE
            WHEN data_2021.started_at IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_START_DATE
     FROM
        data_2021
    ) AS Missing_Start_Time,
    (SELECT 
        SUM(CASE
            WHEN data_2021.ended_at IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_END_DATE
     FROM
        data_2021
    ) AS Missing_End_Time,
    (SELECT 
        SUM(CASE
            WHEN data_2021.start_station_id IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_START_STATION
     FROM
        data_2021
    ) AS Missing_Start_Station_Id,
    (SELECT 
        SUM(CASE
            WHEN data_2021.end_station_id IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_END_STATION
     FROM
        data_2021
    ) AS Missing_End_Station_Id,
    ((SELECT 
        SUM(CASE
            WHEN data_2021.start_lat IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_START_LAT
     FROM
        data_2021
    ) +
    (SELECT 
        SUM(CASE
            WHEN data_2021.start_lng IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_START_LNG
     FROM
        data_2021
    )) AS Missing_Start_Coordinates,
    ((SELECT 
        SUM(CASE
            WHEN data_2021.end_lat IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_END_LAT
     FROM
        data_2021
    ) +
    (SELECT 
        SUM(CASE
            WHEN data_2021.end_lng IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_END_LAT
     FROM
        data_2021
    )) AS Missing_End_Coordinates,
    (SELECT 
        SUM(CASE
            WHEN data_2021.member_casual IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_MEMBERSHIP
     FROM
        data_2021
    ) AS Missing_Membership_Type,
    (SELECT
        COUNT(Invalid_Lat)
        FROM
        (SELECT
            start_lat AS Invalid_Lat
        FROM
            data_2021
        WHERE
            ABS(start_lat)>90

        UNION ALL

        SELECT
            end_lat AS Invalid_Lat
        FROM
            data_2021
        WHERE
            ABS(end_lat)>90
        ) AS Invalid_Lats
    ) AS Invalid_Latitudes,
    (SELECT
        COUNT(Invalid_lng)
        FROM
        (SELECT
            start_lng AS Invalid_lng
        FROM
            data_2021
        WHERE
            ABS(start_lng)>180

        UNION ALL

        SELECT
            end_lng AS Invalid_lng
        FROM
            data_2021
        WHERE
            ABS(end_lng)>180
        ) AS Invalid_Lngs
    ) AS Invalid_Longitudes
    
FROM
    data_2021

UNION ALL

SELECT '2022' AS Year,
    COUNT(*) +
        SUM(CASE
                WHEN ride_id IS NULL THEN 1
                ELSE 0
            END) AS Number_Of_Rides,
    (SELECT COUNT(Counts_per_ride.RIDES_COUNT)
     FROM   
        (SELECT 
            COUNT(data_2022.ride_id) AS RIDES_COUNT
            FROM
            data_2022
        GROUP BY
            data_2022.ride_id
        HAVING
            COUNT(data_2022.ride_id) > 1
        ) Counts_per_ride

    ) AS Duplicates,
    (SELECT 
        SUM(CASE
            WHEN data_2022.started_at IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_START_DATE
     FROM
        data_2022
    ) AS Missing_Start_Time,
    (SELECT 
        SUM(CASE
            WHEN data_2022.ended_at IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_END_DATE
     FROM
        data_2022
    ) AS Missing_End_Time,
    (SELECT 
        SUM(CASE
            WHEN data_2022.start_station_id IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_START_STATION
     FROM
        data_2022
    ) AS Missing_Start_Station_Id,
    (SELECT 
        SUM(CASE
            WHEN data_2022.end_station_id IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_END_STATION
     FROM
        data_2022
    ) AS Missing_End_Station_Id,
    ((SELECT 
        SUM(CASE
            WHEN data_2022.start_lat IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_START_LAT
     FROM
        data_2022
    ) +
    (SELECT 
        SUM(CASE
            WHEN data_2022.start_lng IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_START_LNG
     FROM
        data_2022
    )) AS Missing_Start_Coordinates,
    ((SELECT 
        SUM(CASE
            WHEN data_2022.end_lat IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_END_LAT
     FROM
        data_2022
    ) +
    (SELECT 
        SUM(CASE
            WHEN data_2022.end_lng IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_END_LAT
     FROM
        data_2022
    )) AS Missing_End_Coordinates,
    (SELECT 
        SUM(CASE
            WHEN data_2022.member_casual IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_MEMBERSHIP
     FROM
        data_2022
    ) AS Missing_Membership_Type,
    (SELECT
        COUNT(Invalid_Lat)
        FROM
        (SELECT
            start_lat AS Invalid_Lat
        FROM
            data_2022
        WHERE
            ABS(start_lat)>90

        UNION ALL

        SELECT
            end_lat AS Invalid_Lat
        FROM
            data_2022
        WHERE
            ABS(end_lat)>90
        ) AS Invalid_Lats
    ) AS Invalid_Latitudes,
    (SELECT
        COUNT(Invalid_lng)
        FROM
        (SELECT
            start_lng AS Invalid_lng
        FROM
            data_2022
        WHERE
            ABS(start_lng)>180

        UNION ALL

        SELECT
            end_lng AS Invalid_lng
        FROM
            data_2022
        WHERE
            ABS(end_lng)>180
        ) AS Invalid_Lngs
    ) AS Invalid_Longitudes
    
FROM
    data_2022

GO

-- Summary of the two tables in long format
SELECT 
    'Number_Of_Rides' AS Year,
    (SELECT 
        COUNT(ride_id) +
        SUM(CASE
            WHEN ride_id IS NULL THEN 1
            ELSE 0
            END) -- To count rides with null id too
     FROM
     data_2021) AS '2021',
     (SELECT 
        COUNT(*) +
        SUM(CASE
            WHEN ride_id IS NULL THEN 1
            ELSE 0
            END) -- To count rides with null id too
     FROM
     data_2022) AS '2022'

UNION ALL

SELECT
    'Duplicates',
    (SELECT COUNT(Counts_per_ride.RIDES_COUNT)
     FROM   
        (SELECT 
            COUNT(data_2021.ride_id) AS RIDES_COUNT
            FROM
            data_2021
        GROUP BY
            data_2021.ride_id
        HAVING
            COUNT(data_2021.ride_id) > 1
        ) Counts_per_ride
    ),
    (SELECT COUNT(Counts_per_ride.RIDES_COUNT)
     FROM   
        (SELECT 
            COUNT(data_2022.ride_id) AS RIDES_COUNT
            FROM
            data_2022
        GROUP BY
            data_2022.ride_id
        HAVING
            COUNT(data_2022.ride_id) > 1
        ) Counts_per_ride
    )

UNION ALL

SELECT
    'Missing_Start_Time',
    (SELECT 
        SUM(CASE
            WHEN data_2021.started_at IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_START_DATE
     FROM
        data_2021
    ),
    (SELECT 
        SUM(CASE
            WHEN data_2022.started_at IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_START_DATE
     FROM
        data_2022
    )

UNION ALL

SELECT
    'Missing_End_Time',
    (SELECT 
        SUM(CASE
            WHEN data_2021.ended_at IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_END_DATE
     FROM
        data_2021
    ),
    (SELECT 
        SUM(CASE
            WHEN data_2022.ended_at IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_END_DATE
     FROM
        data_2022
    )

UNION ALL

SELECT
    'Missing_Start_Station_Id',
    (SELECT 
        SUM(CASE
            WHEN data_2021.start_station_id IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_START_STATION
     FROM
        data_2021
    ),
    (SELECT 
        SUM(CASE
            WHEN data_2022.start_station_id IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_START_STATION
     FROM
        data_2022
    )

UNION ALL

SELECT
    'Missing_End_Station_Id',
    (SELECT 
        SUM(CASE
            WHEN data_2021.end_station_id IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_END_STATION
     FROM
        data_2021
    ),
    (SELECT 
        SUM(CASE
            WHEN data_2022.end_station_id IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_END_STATION
     FROM
        data_2022
    )

UNION ALL

SELECT
    'Missing_Start_Coordinates',
    ((SELECT 
        SUM(CASE
            WHEN data_2021.start_lat IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_START_LAT
     FROM
        data_2021
    ) +
    (SELECT 
        SUM(CASE
            WHEN data_2021.start_lng IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_START_LNG
     FROM
        data_2021
    )),
    ((SELECT 
        SUM(CASE
            WHEN data_2022.start_lat IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_START_LAT
     FROM
        data_2022
    ) +
    (SELECT 
        SUM(CASE
            WHEN data_2022.start_lng IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_START_LNG
     FROM
        data_2022
    ))

UNION ALL

SELECT
    'Missing_End_Coordinates',
    ((SELECT 
        SUM(CASE
            WHEN data_2021.end_lat IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_END_LAT
     FROM
        data_2021
    ) +
    (SELECT 
        SUM(CASE
            WHEN data_2021.end_lng IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_END_LAT
     FROM
        data_2021
    )),
    ((SELECT 
        SUM(CASE
            WHEN data_2022.end_lat IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_END_LAT
     FROM
        data_2022
    ) +
    (SELECT 
        SUM(CASE
            WHEN data_2022.end_lng IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_END_LAT
     FROM
        data_2022
    ))

UNION ALL

SELECT
    'Missing_Membership_Type',
    (SELECT 
        SUM(CASE
            WHEN data_2021.member_casual IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_MEMBERSHIP
     FROM
        data_2021
    ),
    (SELECT 
        SUM(CASE
            WHEN data_2022.member_casual IS NULL THEN 1
            ELSE 0
            END
        ) AS NULL_MEMBERSHIP
     FROM
        data_2022
    )

UNION ALL

SELECT
    'Invalid_Latitudes',
    (SELECT
        COUNT(Invalid_Lat)
        FROM
        (SELECT
            start_lat AS Invalid_Lat
        FROM
            data_2021
        WHERE
            ABS(start_lat)>90

        UNION ALL

        SELECT
            end_lat AS Invalid_Lat
        FROM
            data_2021
        WHERE
            ABS(end_lat)>90
        ) AS Invalid_Lats
    ),
    (SELECT
        COUNT(Invalid_Lat)
        FROM
        (SELECT
            start_lat AS Invalid_Lat
        FROM
            data_2022
        WHERE
            ABS(start_lat)>90

        UNION ALL

        SELECT
            end_lat AS Invalid_Lat
        FROM
            data_2022
        WHERE
            ABS(end_lat)>90
        ) AS Invalid_Lats
    )

UNION ALL

SELECT
    'Invalid_Longitudes',
    (SELECT
        COUNT(Invalid_lng)
        FROM
        (SELECT
            start_lng AS Invalid_lng
        FROM
            data_2021
        WHERE
            ABS(start_lng)>180

        UNION ALL

        SELECT
            end_lng AS Invalid_lng
        FROM
            data_2021
        WHERE
            ABS(end_lng)>180
        ) AS Invalid_Lngs
    ),
    (SELECT
        COUNT(Invalid_lng)
        FROM
        (SELECT
            start_lng AS Invalid_lng
        FROM
            data_2022
        WHERE
            ABS(start_lng)>180

        UNION ALL

        SELECT
            end_lng AS Invalid_lng
        FROM
            data_2022
        WHERE
            ABS(end_lng)>180
        ) AS Invalid_Lngs
    )