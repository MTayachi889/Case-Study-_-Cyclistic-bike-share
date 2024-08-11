USE Divvy_Tripdata;

GO

SELECT 
        *
INTO 
    #All_data
FROM
    dbo.data_2021

UNION ALL

SELECT 
        *
FROM
    dbo.data_2022;

/* Create a temporary table holding the stations data to be used to clean and transform Records.
 As there a big variaty of possible coordinates, the latitudes and longitudes will be selected 
 from the stations table to have a more consistent represantation of the trips and to pinpoint eventual
 area related patterns*/

SELECT
    *
INTO #Stations_Table

FROM
    (SELECT 
    Station_Id,
    Station_Name,
    ROUND(Station_lat,6) AS Station_lat,
    ROUND(Station_lng,6) AS Station_lng

FROM

    (SELECT 
        DISTINCT Station_Id,
        Station_Name,
        AVG(Station_lat) OVER (PARTITION BY Station_Id) Station_lat,
        AVG(Station_lng) OVER (PARTITION BY Station_Id) Station_lng,
        ROW_NUMBER() OVER(PARTITION BY Station_Id ORDER BY Name_Occurence_Per_Id DESC) Row_Per_Name

    FROM 
        (SELECT 
            start_station_id AS Station_Id,
            start_station_name AS Station_Name,
            ROUND(start_lat,6)  AS Station_lat,
            ROUND(start_lng,6)  AS Station_lng,
            COUNT(start_station_name) OVER (PARTITION BY start_station_id) Name_Occurence_Per_Id
        FROM 
            #All_data

        UNION ALL

        SELECT 
            end_station_id AS Station_Id,
            end_station_name AS Station_Name,
            ROUND(end_lat,6)  AS Station_lat,
            ROUND(end_lng,6) AS Station_lng,
            COUNT(end_station_name) OVER (PARTITION BY end_station_id) Name_Occurence_Per_Id
        FROM 
            #All_data) AS Stations_Table) a

WHERE Row_Per_Name = 1 and Station_Id IS NOT NULL) b;

-- Creation of a cleaned Table for each Year

-- 2021
SELECT 
    *
INTO

    #Data_2021_Cleaned

FROM
    (SELECT
        Table_1.ride_id,
        Table_1.rideable_type,
        Table_1.member_casual,
        Table_1.Start_Date,
        Table_1.Start_Time,
        Table_1.End_Date,
        Table_1.End_Time,
        Table_1.start_station_id,
        Table_1.end_station_id,
        Table_1.start_station_latitude ,
        Table_1.start_station_longitude,
        Table_1.start_station_name,
        #Stations_Table.Station_lat AS end_station_latitude,
        #Stations_Table.Station_lng AS end_station_longitude,
        #Stations_Table.Station_Name AS end_station_name,
        Table_1.Trip_Duration_In_Minutes
    FROM
        (SELECT
            ride_id,
            rideable_type,
            member_casual,
            CAST(started_at AS DATE) AS Start_Date,
            CAST(started_at AS TIME) AS Start_Time,
            CAST(ended_at AS DATE) AS End_Date,
            CAST(ended_at AS TIME) AS End_Time,
            start_station_id,
            end_station_id,
            #Stations_Table.Station_lat AS start_station_latitude,
            #Stations_Table.Station_lng  AS start_station_longitude,
            #Stations_Table.Station_Name AS start_station_name,
            DATEDIFF(SECOND, CAST(started_at AS TIME), CAST(ended_at AS TIME)) / 60 AS Trip_Duration_In_Minutes

        FROM
            data_2021
        INNER JOIN
            #Stations_Table ON data_2021.start_station_id = #Stations_Table.Station_Id
        WHERE
            CAST(started_at AS TIME) < CAST(ended_at AS TIME)
        AND start_station_id IS NOT NULL
        AND end_station_id IS NOT NULL) Table_1
        INNER JOIN
            #Stations_Table ON Table_1.end_station_id = #Stations_Table.Station_Id) c;


SELECT
    *
INTO

    #Temp_Data_2021

FROM
    (SELECT 
        ride_id,
        member_casual AS Membership,
        CONCAT(start_station_name, ' / ' ,end_station_name) AS Route,
        Start_Date AS Trip_Date,
        DATENAME(weekday, Start_Date) AS Trip_Day,
        CASE
            WHEN 
                DATENAME(weekday, Start_Date) = 'Saturday' 
                OR DATENAME(weekday, Start_Date) = 'Sunday'
            THEN 'Weekend'
            ELSE
                'Business_day'
        END AS Weekend_Business,
        Start_Time,
        End_Time,
        Trip_Duration_In_Minutes AS Duration,
        rideable_type
    FROM
        #Data_2021_Cleaned) a;

-- 2022
SELECT 
    *
INTO

    #Data_2022_Cleaned

FROM
    (SELECT
        Table_1.ride_id,
        Table_1.rideable_type,
        Table_1.member_casual,
        Table_1.Start_Date,
        Table_1.Start_Time,
        Table_1.End_Date,
        Table_1.End_Time,
        Table_1.start_station_id,
        Table_1.end_station_id,
        Table_1.start_station_latitude ,
        Table_1.start_station_longitude,
        Table_1.start_station_name,
        #Stations_Table.Station_lat AS end_station_latitude,
        #Stations_Table.Station_lng AS end_station_longitude,
        #Stations_Table.Station_Name AS end_station_name,
        Table_1.Trip_Duration_In_Minutes
    FROM
        (SELECT
            ride_id,
            rideable_type,
            member_casual,
            CAST(started_at AS DATE) AS Start_Date,
            CAST(started_at AS TIME) AS Start_Time,
            CAST(ended_at AS DATE) AS End_Date,
            CAST(ended_at AS TIME) AS End_Time,
            start_station_id,
            end_station_id,
            #Stations_Table.Station_lat AS start_station_latitude,
            #Stations_Table.Station_lng  AS start_station_longitude,
            #Stations_Table.Station_Name AS start_station_name,
            DATEDIFF(SECOND, CAST(started_at AS TIME), CAST(ended_at AS TIME)) / 60 AS Trip_Duration_In_Minutes

        FROM
            data_2022
        INNER JOIN
            #Stations_Table ON data_2022.start_station_id = #Stations_Table.Station_Id
        WHERE
            CAST(started_at AS TIME) < CAST(ended_at AS TIME)
        AND start_station_id IS NOT NULL
        AND end_station_id IS NOT NULL) Table_1
        INNER JOIN
            #Stations_Table ON Table_1.end_station_id = #Stations_Table.Station_Id) d;

SELECT
    *
INTO

    #Temp_Data_2022

FROM
    (SELECT 
        ride_id,
        member_casual AS Membership,
        CONCAT(start_station_name, ' / ' ,end_station_name) AS Route,
        Start_Date AS Trip_Date,
        DATENAME(weekday, Start_Date) AS Trip_Day,
        CASE
            WHEN 
                DATENAME(weekday, Start_Date) = 'Saturday' 
                OR DATENAME(weekday, Start_Date) = 'Sunday'
            THEN 'Weekend'
            ELSE
                'Business_day'
        END AS Weekend_Business,
        Start_Time,
        End_Time,
        Trip_Duration_In_Minutes AS Duration,
        rideable_type
    FROM
        #Data_2022_Cleaned) a;

------------------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
--- Create Aggregations for analysis
--2021-----------------------------------------------------------------------------------------------------

SELECT
    Membership,
    Count(ride_id) AS Count_Trips,
    (SELECT COUNT(ride_id) FROM #Temp_Data_2021) AS Total_Trips,
    '2021' AS 'Year'
FROM
    #Temp_Data_2021
GROUP BY
    Membership;

SELECT
    DISTINCT Membership,
    AVG(Duration) AS Average_Trip_Duration,
    '2021' AS 'Year'

FROM
    #Temp_Data_2021
GROUP BY
    Membership;

-- Time of the day overview
SELECT
    DISTINCT TOP 5 DATEPART(HOUR, Start_Time) AS Pick_Up_Hour,
    Membership,
    COUNT(DATEPART(HOUR, Start_Time)) AS Count_Hours,
    '2021' AS 'Year'
FROM
    #Temp_Data_2021
WHERE
    Membership = 'member'
GROUP BY
    DATEPART(HOUR, Start_Time),
    Membership

UNION ALL

SELECT
    DISTINCT TOP 5 DATEPART(HOUR, Start_Time) AS Pick_Up_Hour,
    Membership,
    COUNT(DATEPART(HOUR, Start_Time)) AS Count_Hours,
    '2021' AS 'Year'
FROM
    #Temp_Data_2021
WHERE
    Membership = 'casual'
GROUP BY
    DATEPART(HOUR, Start_Time),
    Membership
ORDER BY
    Membership DESC,
    COUNT(DATEPART(HOUR, Start_Time)) DESC;

-- Weekend / Business day Overview

SELECT
    DISTINCT Weekend_Business,
    Membership,
    COUNT(Weekend_Business) AS Count_Weekend_Business,
    '2021' AS 'Year'
FROM
    #Temp_Data_2021
WHERE
    Membership = 'member'
GROUP BY
    Weekend_Business, 
    Membership

UNION ALL

SELECT
    DISTINCT Weekend_Business,
    Membership,
    COUNT(Weekend_Business) AS Count_Weekend_Business,
    '2021' AS 'Year'
FROM
    #Temp_Data_2021
WHERE
    Membership = 'casual'
GROUP BY
    Weekend_Business, 
    Membership
ORDER BY 
    Membership DESC,
    COUNT(Weekend_Business) DESC;

-- Top Five Routes for each membership type
SELECT *
FROM
    (SELECT 
        DISTINCT TOP 5 Route,
        Membership,
        COUNT(Route) AS Count_Route,
        '2021' AS 'Year'
        
    FROM
        #Temp_Data_2021
    WHERE
        Membership = 'member'
    GROUP BY
        Membership,
        Route
    ORDER BY
        Membership DESC,
        COUNT(Route) DESC) A

UNION ALL

SELECT *
FROM
    (SELECT 
        DISTINCT TOP 5 Route,
        Membership,
        COUNT(Route) AS Count_Route,
        '2021' AS 'Year'
        
    FROM
        #Temp_Data_2021
    WHERE
        Membership = 'casual'
    GROUP BY
        Membership,
        Route
    ORDER BY
        Membership DESC,
        COUNT(Route) DESC) B;

SELECT 
    COUNT(DISTINCT Route) Count_Routes,
    '2021' AS 'Year'
    
FROM
    #Temp_Data_2021;


--Overview period of the year
SELECT 
    DISTINCT Quarter,
    Membership,
    COUNT(Quarter) AS Count_Quarter,
    '2021' AS 'Year'
FROM
    (SELECT
        CASE
            WHEN DATEPART(MONTH, Trip_Date) IN (1, 2, 3) THEN 'Q1'
            WHEN DATEPART(MONTH, Trip_Date) IN (4, 5, 6) THEN 'Q2'
            WHEN DATEPART(MONTH, Trip_Date) IN (7, 8, 9) THEN 'Q3'
            WHEN DATEPART(MONTH, Trip_Date) IN (10, 11, 12) THEN 'Q4'
        END AS Quarter,
        Membership
    FROM
        #Temp_Data_2021) c
WHERE
    Membership = 'member'
GROUP BY
    Membership,
    Quarter

UNION ALL

SELECT 
    DISTINCT Quarter,
    Membership,
    COUNT(Quarter)  AS Count_Quarter,
    '2021' AS 'Year'
FROM
    (SELECT
        CASE
            WHEN DATEPART(MONTH, Trip_Date) IN (1, 2, 3) THEN 'Q1'
            WHEN DATEPART(MONTH, Trip_Date) IN (4, 5, 6) THEN 'Q2'
            WHEN DATEPART(MONTH, Trip_Date) IN (7, 8, 9) THEN 'Q3'
            WHEN DATEPART(MONTH, Trip_Date) IN (10, 11, 12) THEN 'Q4'
        END AS Quarter,
        Membership
    FROM
        #Temp_Data_2021) c
WHERE
    Membership = 'casual'
GROUP BY
    Membership,
    Quarter
ORDER BY 
    Membership DESC,
    COUNT(Quarter) DESC;

--Overview rideable_type
SELECT 
    DISTINCT rideable_type,
    Membership,
    COUNT(rideable_type) AS Count_rideable_type,
    '2021' AS 'Year'
FROM 
    #Temp_Data_2021
WHERE
    Membership = 'member'
GROUP BY
    rideable_type,
    Membership
 
UNION ALL

SELECT 
    DISTINCT rideable_type,
    Membership,
    COUNT(rideable_type) AS Count_rideable_type,
    '2021' AS 'Year'
FROM 
    #Temp_Data_2021
WHERE
    Membership = 'casual'
GROUP BY
    rideable_type,
    Membership
ORDER BY
    Membership DESC,
    COUNT(rideable_type) DESC;

--2022-----------------------------------------------------------------------------------------------------
SELECT
    Membership,
    Count(ride_id) AS Count_Trips,
    (SELECT COUNT(ride_id) FROM #Temp_Data_2022) AS Total_Trips,
    '2022' AS 'Year'
FROM
    #Temp_Data_2022
GROUP BY
    Membership;

SELECT
    DISTINCT Membership,
    AVG(Duration) AS Average_Trip_Duration,
    '2022' AS 'Year'

FROM
    #Temp_Data_2022
GROUP BY
    Membership;

-- Time of the day overview
SELECT
    DISTINCT TOP 5 DATEPART(HOUR, Start_Time) AS Pick_Up_Hour,
    Membership,
    COUNT(DATEPART(HOUR, Start_Time)) AS Count_Hours,
    '2022' AS 'Year'
FROM
    #Temp_Data_2022
WHERE
    Membership = 'member'
GROUP BY
    DATEPART(HOUR, Start_Time),
    Membership

UNION ALL

SELECT
    DISTINCT TOP 5 DATEPART(HOUR, Start_Time) AS Pick_Up_Hour,
    Membership,
    COUNT(DATEPART(HOUR, Start_Time)) AS Count_Hours,
    '2022' AS 'Year'
FROM
    #Temp_Data_2022
WHERE
    Membership = 'casual'
GROUP BY
    DATEPART(HOUR, Start_Time),
    Membership
ORDER BY
    Membership DESC,
    COUNT(DATEPART(HOUR, Start_Time)) DESC;

-- Weekend / Business day Overview

SELECT
    DISTINCT Weekend_Business,
    Membership,
    COUNT(Weekend_Business) AS Count_Weekend_Business,
    '2022' AS 'Year'
FROM
    #Temp_Data_2022
WHERE
    Membership = 'member'
GROUP BY
    Weekend_Business, 
    Membership

UNION ALL

SELECT
    DISTINCT Weekend_Business,
    Membership,
    COUNT(Weekend_Business) AS Count_Weekend_Business,
    '2022' AS 'Year'
FROM
    #Temp_Data_2022
WHERE
    Membership = 'casual'
GROUP BY
    Weekend_Business, 
    Membership
ORDER BY 
    Membership DESC,
    COUNT(Weekend_Business) DESC;

-- Top Five Routes for each membership type

SELECT *
FROM
    (SELECT 
        DISTINCT TOP 5 Route,
        Membership,
        COUNT(Route) AS Count_Route,
        '2022' AS 'Year'
        
    FROM
        #Temp_Data_2022
    WHERE
        Membership = 'member'
    GROUP BY
        Membership,
        Route
    ORDER BY
        Membership DESC,
        COUNT(Route) DESC) A

UNION ALL

SELECT *
FROM
    (SELECT 
        DISTINCT TOP 5 Route,
        Membership,
        COUNT(Route) AS Count_Route,
        '2022' AS 'Year'
        
    FROM
        #Temp_Data_2022
    WHERE
        Membership = 'casual'
    GROUP BY
        Membership,
        Route
    ORDER BY
        Membership DESC,
        COUNT(Route) DESC) B;

SELECT 
    COUNT(DISTINCT Route) Count_Routes,
    '2022' AS 'Year'
    
FROM
    #Temp_Data_2022;

--Overview period of the year
SELECT 
    DISTINCT Quarter,
    Membership,
    COUNT(Quarter) AS Count_Quarter,
    '2022' AS 'Year'
FROM
    (SELECT
        CASE
            WHEN DATEPART(MONTH, Trip_Date) IN (1, 2, 3) THEN 'Q1'
            WHEN DATEPART(MONTH, Trip_Date) IN (4, 5, 6) THEN 'Q2'
            WHEN DATEPART(MONTH, Trip_Date) IN (7, 8, 9) THEN 'Q3'
            WHEN DATEPART(MONTH, Trip_Date) IN (10, 11, 12) THEN 'Q4'
        END AS Quarter,
        Membership
    FROM
        #Temp_Data_2022) c
WHERE
    Membership = 'member'
GROUP BY
    Membership,
    Quarter

UNION ALL

SELECT 
    DISTINCT Quarter,
    Membership,
    COUNT(Quarter)  AS Count_Quarter,
    '2022' AS 'Year'
FROM
    (SELECT
        CASE
            WHEN DATEPART(MONTH, Trip_Date) IN (1, 2, 3) THEN 'Q1'
            WHEN DATEPART(MONTH, Trip_Date) IN (4, 5, 6) THEN 'Q2'
            WHEN DATEPART(MONTH, Trip_Date) IN (7, 8, 9) THEN 'Q3'
            WHEN DATEPART(MONTH, Trip_Date) IN (10, 11, 12) THEN 'Q4'
        END AS Quarter,
        Membership
    FROM
        #Temp_Data_2022) c
WHERE
    Membership = 'casual'
GROUP BY
    Membership,
    Quarter
ORDER BY 
    Membership DESC,
    COUNT(Quarter) DESC;

--Overview rideable_type
SELECT 
    DISTINCT rideable_type,
    Membership,
    COUNT(rideable_type) AS Count_rideable_type,
    '2022' AS 'Year'
FROM 
    #Temp_Data_2022
WHERE
    Membership = 'member'
GROUP BY
    rideable_type,
    Membership
 
UNION ALL

SELECT 
    DISTINCT rideable_type,
    Membership,
    COUNT(rideable_type) AS Count_rideable_type,
    '2022' AS 'Year'
FROM 
    #Temp_Data_2022
WHERE
    Membership = 'casual'
GROUP BY
    rideable_type,
    Membership
ORDER BY
    Membership DESC,
    COUNT(rideable_type) DESC;

--Most frequent arears for members to complete the vizualisations
SELECT
    Station_Name,
    Station_lat,
    Station_lng
FROM
    #Stations_Table
WHERE
    Station_Name IN ('Ellis Ave & 60th St ',
                    'Ellis Ave & 55th St ',
                    'University Ave & 57th St ',
                    'Calumet Ave & 33rd St ',
                    'Streeter Dr & Grand Ave ',
                    'DuSable Lake Shore Dr & Monroe St ',
                    'Millennium Park ',
                    'Michigan Ave & Oak St ',
                    'State St & 33rd St ')