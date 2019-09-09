-- Find indexes with one column name that isn't ROWID
SELECT s.name schem_name, t.name table_name, i.name AS index_name  
    ,COL_NAME(ic.object_id,ic.column_id) AS column_name  
    ,ic.index_column_id  
    ,ic.key_ordinal  , ic.object_id
,ic.is_included_column  
into #tmp
FROM sys.indexes AS i  
	INNER JOIN sys.index_columns AS ic
		ON	i.object_id = ic.object_id 
			AND i.index_id = ic.index_id  
	INNER JOIN sys.tables t
		ON i.object_id = t.object_id
	INNER JOIN sys.schemas s
		ON s.schema_id = t.schema_id
WHERE 
	s.name = 'SEED'
	--and t.name = 'ABANK'
	AND COL_NAME(ic.object_id,ic.column_id) NOT LIKE '%ROWID'

select schem_name, table_name, index_name, count(*)
from #tmp
group by schem_name, table_name, index_name
having count(*) = 1
