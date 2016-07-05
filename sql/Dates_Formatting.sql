-- First day of last month 
select dateadd(m, datediff(m, 0, dateadd(MM, -1,getdate())), 0) as [BeginDate]

--Last Day of Last Month
select dateadd(m, datediff(m, 0, dateadd(m, 1, dateadd(MM, -1,getdate()))), -1) as [Date of Last Day of Last Month]

--Short date as Varchar
Select convert(varchar(10), GetDate(), 101) AS [ShortDate]

--Base Date (Midnight) 
Select Cast(convert(varchar(10), GetDate(), 101) as DateTime) AS [BaseDate]

--Some Date Formats 
PRINT '1) Date/time in format MON DD YYYY HH:MI AM (OR PM): ' + CONVERT(CHAR(19),GETDATE())
PRINT '2) Date/time in format MM-DD-YY: ' + CONVERT(CHAR(8),GETDATE(),10)
PRINT '3) Date/time in format MM-DD-YYYY: ' + CONVERT(CHAR(10),GETDATE(),110)
PRINT '4) Date/time in format DD MON YYYY: ' + CONVERT(CHAR(11),GETDATE(),106)
PRINT '5) Date/time in format DD MON YY: ' + CONVERT(CHAR(9),GETDATE(),6)
PRINT '6) Date/time in format DD MON YYYY HH:MM:SS:MMM(24H): ' + CONVERT(CHAR(24),GETDATE(),113)
PRINT '7) Date/time in format YYYY-MM-DDTHH:MM:SS:sss :' + CONVERT(CHAR(24), GETDATE(),126)

--Date Name
SELECT DATENAME(year, '12:10:30.123')
,DATENAME(month, '12:10:30.123')
,DATENAME(day, '12:10:30.123')
,DATENAME(dayofyear, '12:10:30.123')
,DATENAME(weekday, '12:10:30.123');
