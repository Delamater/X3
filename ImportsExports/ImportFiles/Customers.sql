IF OBJECT_ID('Import', 'U') IS NULL
BEGIN
	PRINT 'Creating Table: Import'
	CREATE TABLE Import
	(
		LineOfFile VARCHAR(MAX)
	)
END

GO


SET NOCOUNT ON

DECLARE @BPCNUM VARCHAR(20)
SET @BPCNUM = 'BOB'

DECLARE @i INT
SET @i = 7001

WHILE @i < 14000
BEGIN
	INSERT INTO Import(LineOfFile)
	select 'B;US;' + @BPCNUM + CONVERT(VARCHAR(5), @i) + ';ABC Industrial;ABCIndus;ABCIndus;CORP;CORP;CORP;CORP;USD;;;;' + @BPCNUM + CONVERT(VARCHAR(5), @i) + ';NTX;CH30NET;LOCAL;400;730;100000.32;1;NA203;;;;;'
	INSERT INTO Import(LineOfFile)
	select 'A;CORP;Corporate;4205 River Green Parkway;;;30096;DULUTH;US;7708139200;7708139201'
	INSERT INTO Import(LineOfFile)
	select 'D;CORP;ABC Industrial;NA203;3;NA501;EXW;1;;;;'
	INSERT INTO Import(LineOfFile)
	select 'C;CEO;1;Allan;Fine;7708139200;1'

	SET @i = @i + 1
END

IF NOT EXISTS
(
	SELECT 1
	FROM sys.tables t
		INNER JOIN sys.columns c
			ON t.object_id = c.object_id
		INNER JOIN sys.schemas s
			ON t.schema_id = s.schema_id
	WHERE s.name = 'dbo' AND t.name = 'Import' AND c.name = 'ID'
)
BEGIN
	PRINT 'Adding ID field'
	ALTER TABLE Import ADD ID INT IDENTITY(1,1)
END
ELSE
BEGIN
	PRINT 'ID field already exists, will not add to table'
END

--

--truncate table Import
--DELETE Import WHERE ID > 7000


PRINT 'Complete'

