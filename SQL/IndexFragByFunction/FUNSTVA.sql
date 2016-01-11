DECLARE  @ObjectIDs AS dbo.ObjectIDs 

-- Insert into the driver table with any type of range of tables you require 
--	(see WHERE clause below)
INSERT INTO @ObjectIDs(ObjectId, SchemaName, TableName)
SELECT t.object_id, s.name, t.name
FROM sys.tables t
	INNER JOIN sys.schemas s
		ON t.schema_id = s.schema_id
WHERE 
	s.name = 'SEED' 
	AND t.name IN
	(
		'ITMCOST',
		'ITMMASTER',
		'FACILITY',
		'TABUNIT', 
		'TABCUR',  
		'ITMCATEG',
		'ITMMASTER', 
		'ITMMVT',    
		'ITMMVTHIS',  
		'ITMFACILIT', 
		'ITMCOST',    
		'STOLOT',    
		'STOLOTFCY',  
		'STOCK',     
		'STOCOST',  
		'STOJOU', 
		'STOJOU', 
		'STOVALWRK', 
		'STOVALCUM',  
		'TABCOSTMET', 
		'PRECEIPT',  
		'PRECEIPTD',  
		'SDELIVERY', 
		'SDELIVERYD', 
		'SRETURN',    
		'SRETURND',  
		'PRETURN',   
		'PRETURND',   
		'BPARTNER',
		'PINVOICED'
	)
						

exec dbo.uspGetDiscreteIndexFrag 
	@ObjectIDs, 
	@FragPercent = 0, 
	@PageCount = 100, 
	@Rebuild = 0, 
	@Reorganize = 0, 
	@RebuildHeap = 0, 
	@MaxDop = 64

  
