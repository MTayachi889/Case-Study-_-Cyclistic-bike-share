USE Divvy_tripdata;

GO

CREATE PROCEDURE Drop_Month_Data

@Year NVARCHAR(4)  

AS
DECLARE @Month INT
DECLARE @Month_Table_Name NVARCHAR(20)
/* 
Create the variable month to be used as a counter to loop through 
the 12 months' tables and to be used as tables' names identifier
*/ 
SET @Month = 1
-- Loop to drop months data tables
WHILE (@Month < 13 )

BEGIN

--All the months tables have been created using the name's format '@year+@month'
SET @Month_Table_Name = 'dbo.[' + @Year + FORMAT(@Month,'00') + ']'

EXECUTE('DROP TABLE '+ @Month_Table_Name)    

-- Increment @Month
SET @Month = @Month + 1

END;

GO

EXECUTE dbo.Drop_Month_Data @Year = '2021'

GO

EXECUTE dbo.Drop_Month_Data @Year = '2022'
