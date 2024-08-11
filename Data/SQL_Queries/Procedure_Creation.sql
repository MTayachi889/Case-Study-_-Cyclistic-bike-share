USE Divvy_tripdata;

GO

CREATE PROCEDURE Add_Month_Data_To_Year_Table

@Year NVARCHAR(4)  

AS
DECLARE @Month INT
DECLARE @Year_Table_Name NVARCHAR(20)
DECLARE @Month_Table_Name NVARCHAR(20)
/* 
Create the variable month to be used as a counter to loop through 
the 12 months' tables and to be used as tables' names identifier
*/ 
SET @Month = 1
SET @Year_Table_Name = 'dbo.data_' + @Year
-- Loop to insert 12 months data into the year table
WHILE (@Month < 13 )

BEGIN
/*
Years should be created prior to the procedure execution following the exact 
columns order and types
All the years' tables should be created using the name format 'data_@year'
*/

--All the months tables have been created using the name's format '@year+@month'
SET @Month_Table_Name = 'dbo.[' + @Year + FORMAT(@Month,'00') + ']'

EXECUTE('INSERT INTO '+ @Year_Table_Name + ' SELECT * FROM ' + @Month_Table_Name)    

-- Increment @Month
SET @Month = @Month + 1

END;
