CREATE FUNCTION [dbo].[date_stamp_string]() 
RETURNS varchar(255) 
AS 
BEGIN 
    DECLARE @var varchar(255) 
    SELECT @var=convert(varchar(30), getdate(),112) + replace(convert(varchar(30), getdate(),108),':','')
    RETURN @var 
END
