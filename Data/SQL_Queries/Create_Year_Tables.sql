/* 
A new database have been created to hold the data tables with
the name of 'Divvy_tripdata' with the pre-existing schema 'dbo'
*/
USE Divvy_tripdata;

GO

CREATE TABLE dbo.data_2021 (
    [ride_id] [nvarchar](50) NOT NULL,
	[rideable_type] [nvarchar](50) NULL,
	[started_at] [datetime2](7) NULL,
	[ended_at] [datetime2](7) NULL,
	[start_station_name] [nvarchar](max) NULL,
	[start_station_id] [nvarchar](50) NULL,
	[end_station_name] [nvarchar](max) NULL,
	[end_station_id] [nvarchar](50) NULL,
	[start_lat] [float] NULL,
	[start_lng] [float] NULL,
	[end_lat] [float] NULL,
	[end_lng] [float] NULL,
	[member_casual] [nvarchar](50) NULL,
)

GO

EXECUTE dbo.Add_Month_Data_To_Year_Table @Year = '2021'

GO

CREATE TABLE dbo.data_2022 (
    [ride_id] [nvarchar](50) NOT NULL,
	[rideable_type] [nvarchar](50) NULL,
	[started_at] [datetime2](7) NULL,
	[ended_at] [datetime2](7) NULL,
	[start_station_name] [nvarchar](max) NULL,
	[start_station_id] [nvarchar](50) NULL,
	[end_station_name] [nvarchar](max) NULL,
	[end_station_id] [nvarchar](50) NULL,
	[start_lat] [float] NULL,
	[start_lng] [float] NULL,
	[end_lat] [float] NULL,
	[end_lng] [float] NULL,
	[member_casual] [nvarchar](50) NULL,
)

GO

EXECUTE dbo.Add_Month_Data_To_Year_Table @Year = '2022';
