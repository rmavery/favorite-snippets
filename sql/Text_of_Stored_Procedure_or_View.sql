--Returns the text of a stored procedure in a table format so it can be copied and pasted into notepad or something.
--Example:
USE msdb;
GO
sp_helptext 'dbo.sp_send_dbmail'
 
USE Company_01;
GO
sp_helptext 'dbo.Get_MarketPriceDates'
