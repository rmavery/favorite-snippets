CREATE proc [dbo].[snapshot_table]
    @tablename varchar(128), 
    @sp_result varchar(max) = '' OUTPUT   
as 

/* 
    --Call Like This... 
    --DECLARE @result varchar(max) 
    --EXEC dbo.snapshot_table @TABLENAME = 'xl.store_note', @sp_result = @result OUTPUT 
    --SELECT @result
*/

DECLARE @table_dest_name AS VARCHAR(255) 
DECLARE @splittable TABLE (id int, data VARCHAR(255))
DECLARE @maxid int
Declare @sch varchar(10) 
DECLARE @cmd varchar(500) 

IF EXISTS(SELECT 1 FROM SYS.SCHEMAS WHERE NAME = 'zzz') 
BEGIN SET @sch = 'zzz.' END ELSE BEGIN SET @sch = 'zzz_' END 
; 

INSERT INTO @splittable(id, data) SELECT id, data FROM dbo.Split(@tablename, '.')
SELECT @maxid = MAX(id) FROM @splittable
SELECT @table_dest_name = data + '_' + [dbo].[date_stamp_string]()  FROM @splittable WHERE id = @maxid 
SELECT @cmd = 'SELECT * INTO ' + @sch + @table_dest_name + ' FROM ' + @tablename

EXEC(@CMD)

IF (SELECT COUNT(*) FROM sys.tables t inner join sys.schemas s on s.schema_id = t.schema_id WHERE t.name = @table_dest_name and s.name = 'zzz') > 0 
    BEGIN 
	   SELECT @sp_result = 'SUCCESS' 
    END 
ELSE 
    BEGIN 
	   SELECT @sp_result = 'FAIL' 
    END 
 
