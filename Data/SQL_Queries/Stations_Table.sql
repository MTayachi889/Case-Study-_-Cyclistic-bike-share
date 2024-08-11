USE Divvy_tripdata;

GO

/* This script aims to Check Stations details in order to Create a list
with unique ids, names and coodinates for each station  
*/

-- Data for both years will be grouped in a temporary table to have consistent results in the analysis
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
    dbo.data_2022

GO

--Agregations to check Stations details consistency 
SELECT 
    DISTINCT Station_Id,
    COUNT(DISTINCT Station_Name) Count_Of_Names,
    COUNT(DISTINCT ROUND(Station_lat,6)) Count_of_Latitudes,
    COUNT(DISTINCT ROUND(Station_lng,6)) Count_Of_Longitudes
FROM

    (SELECT 
        start_station_id AS Station_Id,
        start_station_name AS Station_Name,
        start_lat AS Station_lat,
        start_lng AS Station_lng
    FROM 
        #All_data

    UNION ALL

    SELECT 
        end_station_id AS Station_Id,
        end_station_name AS Station_Name,
        end_lat AS Station_lat,
        end_lng AS Station_lng
    FROM 
        #All_data) AS Stations_Table
    
GROUP BY
    Station_Id
HAVING
    COUNT(DISTINCT Station_Name) > 1 OR
    COUNT(DISTINCT ROUND(Station_lat,6)) > 1 OR
    COUNT(DISTINCT ROUND(Station_lng,6)) > 1

GO

/*Many Stations id s have multiple names and coordinates. In absence of Access to check for the correct latitudes and 
logitudes will be set to average values as an approximation of the stations' positions and the stations' names will be 
selected based on most occurences*/

SELECT 
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

WHERE Row_Per_Name = 1 and Station_Id IS NOT NULL


