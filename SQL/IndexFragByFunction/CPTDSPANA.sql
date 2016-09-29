DECLARE  @ObjectIDs AS dbo.ObjectIDs 

-- Insert into the driver table with any type of range of tables you require 
--	(see WHERE clause below)
INSERT INTO @ObjectIDs(ObjectId, SchemaName, TableName)
SELECT t.object_id, s.name, t.name
FROM sys.tables t
	INNER JOIN sys.schemas s
		ON t.schema_id = s.schema_id
WHERE 
	s.name = 'DEMO' 
	AND t.name IN
	(
		'GACCOUNT',
		'GAJOUSTA',
		'COMPANY',    
		'FACILITY',   
		'TABCUR',     
		'GDIAENTRY',
		'GTYPACCENT', 
		'BALANA',
		'BLAQTY',    
		'GACCTMP',    
		'GACCTMPA',   
		'PERIOD',     
		'GJOURNAL',   
		'TABUNIT',    
		'CACCE',      
		'CDIADSP',
		'GACCENTRY',  
		'GRPDSP',     
		'GACM',       
		'GACCENTRYA', 
		'GACCENTRYD', 
		'GLED',       
		'GACCTMPD', 
		'GCOA',   
		'AGRPCPY', 
		'ATEXTRA' 
	)
	

exec dbo.uspGetDiscreteIndexFrag 
	@ObjectIDs, @FragPercent = 0, 
	@PageCount = 0, 
	@Rebuild = 0, 
	@Reorganize = 0, 
	@RebuildHeap = 0, 
	@MaxDop = 64
