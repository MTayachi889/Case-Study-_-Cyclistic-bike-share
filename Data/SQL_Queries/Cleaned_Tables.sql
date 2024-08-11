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

-- A cleaned Table will be created for each Year
-- To export------------------------------------------------
------------------------------------------------------------
------------------------------------------------------------
-- 2021
SELECT
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
        #Stations_Table ON Table_1.end_station_id = #Stations_Table.Station_Id;

-- 2022
SELECT
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
        #Stations_Table ON Table_1.end_station_id = #Stations_Table.Station_Id;

---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------


