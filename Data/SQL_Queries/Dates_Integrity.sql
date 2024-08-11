USE Divvy_tripdata;

GO

/* This script aims to check start/end dates and times integrity.
end date should come after start date and records should always include time and
shouldn't be NULL*/ 

WITH All_Data AS (SELECT
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
    'Invalid_DateTimes' AS Data_Check,
    COUNT(End_After_Start) AS Total 
FROM
    (SELECT
        started_at,
        ended_at,
        CASE
            WHEN ended_at > started_at THEN 'TRUE'
            ELSE 'FALSE'
        END End_After_Start
    FROM
        All_Data
    WHERE started_at IS NOT NULL
    AND ended_at IS NOT NULL) AS DateTime_Table
WHERE
    End_After_Start = 'FALSE'

UNION ALL

SELECT
    'Missing_Start_Date',
    SUM(CASE
        WHEN started_at IS NULL THEN 1
        ELSE 0
    END)
FROM
    All_Data

UNION ALL

SELECT
    'Missing_End_Date',
    SUM(CASE
        WHEN ended_at IS NULL THEN 1
        ELSE 0
    END)
FROM
    All_Data

GO

/*As multiple records have Invalid start/end dates or times we 
will extract them to try to identify the origin of the issue*/
WITH All_Data AS (SELECT
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
    started_at,
    ended_at,
    CASE
        WHEN ended_at > started_at THEN 'TRUE'
        ELSE 'FALSE'
    END AS End_After_Start
FROM
    All_Data
WHERE started_at IS NOT NULL
AND ended_at IS NOT NULL
AND (CASE
        WHEN ended_at > started_at THEN 'TRUE'
        ELSE 'FALSE'
    END) = 'FALSE'

/*In most of the records with invalid inputs, start and end dateTimes seems to be duplicates,
for the rest, they are reversed*/