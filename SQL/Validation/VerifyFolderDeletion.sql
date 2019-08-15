

-- Discover if any objects are left over

/**** Variable Declarations		****/
DECLARE 
	@folderToDelete		SYSNAME,
	@schema_name		SYSNAME, 
	@schema_ID			INT,
	@table_count		INT, 
	@schema_count		INT, 
	@trigger_count		INT, 
	@login_count		INT, 
	@db_user_count		INT, 
	@role_count			INT, 
	@procedure_count	INT,
	@type_count			INT,
	@assembly_count		INT,
	@sequence_count		INT,
	@view_count			INT--;
	--@recur_batch_params	INT,
	--@batch_task_params	INT,
	--@activity_codes		INT,
	--@sizing_elements	INT,
	--@solution			INT,
	--@adossier			INT,

/**** SET Variables			****/
SET @folderToDelete		= 'SEED'
SET @schema_name		= 'SEED';
SET @table_count		= (SELECT COUNT(*) FROM sys.tables t WHERE t.schema_id = SCHEMA_ID(@schema_name))
SET @schema_count		= (SELECT COUNT(*) FROM sys.schemas s WHERE s.name = @schema_name)
SET @trigger_count		= (
	SELECT COUNT(*)
		--OBJECT_SCHEMA_NAME(o.object_id), tr.*
	FROM sys.triggers tr
		INNER JOIN sys.objects o
			ON tr.parent_id = o.object_id
	WHERE OBJECT_SCHEMA_NAME(o.object_id) = @folderToDelete
)
SET @login_count		=	(SELECT COUNT(*) FROM sys.sql_logins l WHERE l.name = @folderToDelete)
SET @db_user_count		=	(
	SELECT COUNT(*) FROM sys.sql_logins sl 
	WHERE 
		sl.type = 'S' 
		AND sl.is_disabled = 0 
		AND sl.name = @folderToDelete
)
SET @role_count			= (
	SELECT COUNT(*)
		--DP1.name AS DatabaseRoleName,   
		--isnull (DP2.name, 'No members') AS DatabaseUserName   
	 FROM sys.database_role_members AS DRM  
	 RIGHT OUTER JOIN sys.database_principals AS DP1  
	   ON DRM.role_principal_id = DP1.principal_id  
	 LEFT OUTER JOIN sys.database_principals AS DP2  
	   ON DRM.member_principal_id = DP2.principal_id  
	WHERE DP1.type = 'R' AND LOWER(DP1.name) LIKE LOWER('%' + @folderToDelete +'%')
)
SET @procedure_count	= (SELECT COUNT(*) FROM sys.procedures p WHERE p.schema_id = schema_id(@schema_name))
SET @type_count			= (SELECT COUNT(*) FROM sys.types t WHERE t.schema_id = schema_id(@schema_name))
SET @assembly_count		= -1 -- Not implemented at the moment
SET @view_count			= (SELECT COUNT(*) FROM sys.views v WHERE v.schema_id = schema_id(@schema_name))


/**** View Results			****/
SELECT	@folderToDelete FolderToDelete, @schema_name SchemaName, @table_count TableCount, 
		@schema_count SchemaCount, @trigger_count TriggerCount, @login_count LoginCount, 
		@db_user_count DBUserCount, @role_count RoleCount, @procedure_count ProcedureCount, 
		@type_count TypeCount, @assembly_count AssemblyCount, @view_count ViewCount

