set ANSI_NULLS ON
set QUOTED_IDENTIFIER ON
go

-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
/*SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO*/
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
/* use adonix */
/*
Auteur	:	Adonix
Date	:	Fvrier 2006
Objet	:	Lister les tables d'une base de donnes en vue de procder 
		une suppression des tables en question ...
Syntaxe	:	use base de donnes // obligatoire avant d'excuter la procdure
		exec sp_X3_drop_tables 'propritaire' 'base de donnes'
		ex : sp_X3_drop_tables 'DEMO1','X3SQLV143'
Paramtres :
	Obligatoire(s) :
		propritaire : un nom de user (dossier) DEMO1 	: ex. DEMO1
                          database : nom de la database         :  ex. X3SQLV143
*/
CREATE procedure [dbo].[sp_X3_drop_tables](
			   @table_owner 	nvarchar(384)	= null,
			   @database_name	sysname	= null) 
with
	recompile
as
/*	declare @type1 varchar(3)  */
	declare @tableindex int
	declare @next char(30)

/*
On positionne les paramtres qui nous intresse !
	Les noms des objets 	: % (donc tous)
	Le nom de la base 	: db_name() = celle sur laquelle on est connect, normalement 'adonix' !
	Le type des objets	: TABLE
*/
/*select @table_name = '%'*/
/*select @table_type = "'TABLE'"*/
/*select @type1 = 'U' */

/* 
On contrle le(s) autre(s) paramtre(s)
*/

	if @table_owner is null
	begin
		raiserror ('You must indicate a owner - It must be a user of the database. Typically it should be a X3 folder name', -1, -1)
		return
	end

	if @table_owner = ''
	begin
		raiserror ('You must indicate a owner - It must be a user of the database. Typically it should be a X3 folder name', -1, -1)
		return
	end
	
	if @database_name is null
	begin
		raiserror ('You must indicate a database - It must be the database of the user.', -1, -1)
		return
	end

	if @database_name = ''
	begin
		raiserror ('You must indicate a database - It must be the database of the user.', -1, -1)
		return
	end

       if not (db_name () = @database_name)
	begin
		raiserror ('This database is not correct !' , -1, -1)
		return
	end

	if not exists (select * from sysusers where name = @table_owner) 
	begin
		raiserror ('This user does not exists !' , -1, -1)
		return
	end

/* 
Fin des contrles de dpart
*/		
SET NOCOUNT ON
declare @nom_table char(30)
declare @Table_to_drop char (200)
declare MonCurseur INSENSITIVE CURSOR
	for 
 	   select name from sysobjects where type = 'U' and name like '%' and schema_name(uid) = @table_owner
open MonCurseur
fetch next from MonCurseur into @nom_table
while (@@fetch_status = 0)
	begin
		/* On constitue le nom complet de la table : bdd.owner.table */
		select @Table_to_drop ='['+ @database_name + '].[' + @table_owner + '].[' + @nom_table+']' 
		PRINT 'Drop the table : ' + @Table_to_drop
		/* l'utilisation de exec permet de passer un nom de table dynamique  l'ordre DROP */
		exec ('drop table ' + @Table_to_drop)
		fetch next from MonCurseur into @nom_table
	end
SET NOCOUNT OFF
DEALLOCATE MonCurseur

