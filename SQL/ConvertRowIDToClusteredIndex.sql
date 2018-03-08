/********************************************************************************************
* Author:		Bob Delamater
* Description:		Convert all existing ROWID indexes to clustered. 
*			Retain primary key and unique attribute in all cases. 
*			Exclude 4 clustered indexes (called out by table name). Someone intentionally
*			set these to a clustered property for a reason, so leave them that way. 
* Date:			03/08/2018
********************************************************************************************/

-- Declare cursor for scrolling through tables to drop existing index and make a new clustered index on ROWID
DECLARE @execSQL VARCHAR(MAX)
DECLARE @SchemaName VARCHAR(255), @TableName VARCHAR(255), @IndexName VARCHAR(255)
DECLARE cur_rowid SCROLL CURSOR FOR
SELECT s.name SchemaName, t.name TableName, i.name IndexName
FROM sys.indexes i
	INNER JOIN sys.tables t
		ON i.object_id = t.object_id
	INNER JOIN sys.schemas s
		ON s.schema_id = t.schema_id
WHERE s.name = 'X3PERF' AND i.name LIKE '%ROWID' and i.is_primary_key = 1 and t.name NOT IN('MIGXTBLMAP','CGVDET','CHGVAL','ABANK')


OPEN cur_rowid

-- Fetch the row immediately after the current row in the cursor.
FETCH NEXT FROM cur_rowid INTO @SchemaName, @TableName, @IndexName

WHILE @@FETCH_STATUS = 0
BEGIN
	--SET @execSQL = 'CREATE UNIQUE CLUSTERED INDEX ['+ @TableName + '_ROWID' +'] ON [X3PERF].[' + @TableName + '] (ROWID) WITH (DROP_EXISTING = ON)'
	SET @execSQL = 'CREATE UNIQUE CLUSTERED INDEX ['+ @IndexName +'] ON [X3PERF].[' + @TableName + '] (ROWID) WITH (DROP_EXISTING = ON)'
	PRINT @execSQL
	exec (@execSQL)

	FETCH NEXT FROM cur_rowid INTO @SchemaName, @TableName, @IndexName	
END

CLOSE cur_rowid
DEALLOCATE cur_rowid
GO



-- Report clustered indexes
	
SELECT s.name SchemaName, t.name TableName, i.name IndexName, i.*
FROM sys.indexes i WITH(NOLOCK)
	INNER JOIN sys.tables t WITH(NOLOCK)
		ON i.object_id = t.object_id
	INNER JOIN sys.schemas s WITH(NOLOCK)
		ON s.schema_id = t.schema_id
WHERE s.name = 'X3PERF' and i.type = 1
