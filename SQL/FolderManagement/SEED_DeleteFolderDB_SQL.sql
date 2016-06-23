/*
Before running this script, the 3 store procedures: sp_X3_drop_sequences, sp_X3_drop_tables, sp_X3_drop_views must be existed in database
Change to the correct database name e.g. sagex3 using Find and Replace with
Change to the correct folder name e.g. SEED using Find and Replace with
*/

use sagex3
GO
declare @WPARA char(30)
/* Recherche des paramètre des abonnements liés au dossier
   et suppression
*/
DECLARE lock_cursor CURSOR
FOR SELECT  CODABT_0 FROM X3.ABATABT WHERE DOSSIER_0='SEED'
OPEN lock_cursor
FETCH NEXT FROM lock_cursor INTO @WPARA
WHILE @@FETCH_STATUS = 0
   BEGIN
        DELETE FROM X3.ABATABT WHERE CODABT_0=@WPARA
      FETCH NEXT FROM lock_cursor INTO @WPARA
   END
CLOSE lock_cursor
DEALLOCATE lock_cursor
/* Suppression des abonnements */
DELETE From X3.ABATABT WHERE DOSSIER_0='SEED'
 
/* Recherche des paramètres des rèquêtes liés au dossier
   et suppression
*/
DECLARE lock_cursor1 CURSOR
FOR SELECT  NUMREQ_0 FROM X3.ABATRQT WHERE DOSSIER_0='SEED'
OPEN lock_cursor1
FETCH NEXT FROM lock_cursor1 INTO @WPARA
WHILE @@FETCH_STATUS = 0
    BEGIN
        DELETE FROM X3.ABATPAR WHERE NUMREQ_0=@WPARA
      FETCH NEXT FROM lock_cursor1 INTO @WPARA
    END
CLOSE lock_cursor1
DEALLOCATE lock_cursor1
/* Suppression des requêtes */
DELETE From X3.ABATRQT WHERE DOSSIER_0='SEED'
 
DELETE FROM X3.ADOSACT  WHERE DOSSIER_0='SEED'
DELETE FROM X3.ADOSDIM  WHERE DOSSIER_0='SEED'
/* Nouvelle table v6 */
DELETE FROM X3.ADOSSOL  WHERE DOSSIER_0='SEED'
DELETE FROM X3.ADOSSIER WHERE DOSSIER_0='SEED'
/* Suppression des tables du dossier appartenant à l'utilisateur */
EXEC sp_X3_drop_tables 'SEED','sagex3'
/* Suppression des vue du dossier appartenant à l'utilisateur */
EXEC sp_X3_drop_views  'SEED','sagex3'
/* On est en SQL2005 V150 ou V160 */
EXEC sp_X3_drop_sequences  'SEED','sagex3'

drop schema SEED
print 'drop schema SEED'
/* RECHERCHE des members du roles
   et suppression
*/
DECLARE lock_cursor CURSOR
FOR select b.name from sys.database_role_members c,
    sys.database_principals b,
    sys.database_principals a 
    where a.type='R' and a.name='SEED_ADX'
    and c.role_principal_id=a.principal_id
    and b.type='S' and b.principal_id=c.member_principal_id
OPEN lock_cursor
FETCH NEXT FROM lock_cursor INTO @WPARA
WHILE @@FETCH_STATUS = 0
   BEGIN
      EXEC sp_droprolemember 'SEED_ADX',@WPARA
      FETCH NEXT FROM lock_cursor INTO @WPARA
   END
CLOSE lock_cursor
DEALLOCATE lock_cursor
drop role SEED_ADX
print 'drop role SEED_ADX'
/* RECHERCHE des members du roles
   et suppression
*/
DECLARE lock_cursor CURSOR
FOR select b.name from sys.database_role_members c,
    sys.database_principals b,
    sys.database_principals a 
    where a.type='R' and a.name='SEED_ADX_R'
    and c.role_principal_id=a.principal_id
    and b.type='S' and b.principal_id=c.member_principal_id
OPEN lock_cursor
FETCH NEXT FROM lock_cursor INTO @WPARA
WHILE @@FETCH_STATUS = 0
   BEGIN
      EXEC sp_droprolemember 'SEED_ADX_R',@WPARA
      FETCH NEXT FROM lock_cursor INTO @WPARA
   END
CLOSE lock_cursor
DEALLOCATE lock_cursor
drop role SEED_ADX_R
print 'drop role SEED_ADX_R'
/* RECHERCHE des members du roles
   et suppression
*/
DECLARE lock_cursor CURSOR
FOR select b.name from sys.database_role_members c,
    sys.database_principals b,
    sys.database_principals a 
    where a.type='R' and a.name='SEED_ADX_H'
    and c.role_principal_id=a.principal_id
    and b.type='S' and b.principal_id=c.member_principal_id
OPEN lock_cursor
FETCH NEXT FROM lock_cursor INTO @WPARA
WHILE @@FETCH_STATUS = 0
   BEGIN
      EXEC sp_droprolemember 'SEED_ADX_H',@WPARA
      FETCH NEXT FROM lock_cursor INTO @WPARA
   END
CLOSE lock_cursor
DEALLOCATE lock_cursor
drop role SEED_ADX_H
print 'drop role SEED_ADX_H'
/* RECHERCHE des members du roles
   et suppression
*/
DECLARE lock_cursor CURSOR
FOR select b.name from sys.database_role_members c,
    sys.database_principals b,
    sys.database_principals a 
    where a.type='R' and a.name='SEED_ADX_RH'
    and c.role_principal_id=a.principal_id
    and b.type='S' and b.principal_id=c.member_principal_id
OPEN lock_cursor
FETCH NEXT FROM lock_cursor INTO @WPARA
WHILE @@FETCH_STATUS = 0
   BEGIN
      EXEC sp_droprolemember 'SEED_ADX_RH',@WPARA
      FETCH NEXT FROM lock_cursor INTO @WPARA
   END
CLOSE lock_cursor
DEALLOCATE lock_cursor
drop role SEED_ADX_RH
print 'drop role SEED_ADX_RH'
drop user SEED
print 'drop user SEED'
drop user SEED_REPORT
print 'drop user SEED_REPORT'
use master
select OBJECT_ID('master.dbo.tmp'),objectproperty( object_id('master.dbo.tmp') , 'IsUserTable' )
if OBJECT_ID('master.dbo.tmp') is not null and objectproperty( object_id('master.dbo.tmp') , 'IsUserTable' )=1
drop table [master].[dbo].tmp
else
print 'table [master].[dbo].tmp non presente'
go
SELECT name into [master].[dbo].tmp FROM sysusers where name<>name
declare @WPARA char(30)
declare @WCOUNT integer
set @WCOUNT=0
DECLARE lock_cursor CURSOR
 For select name from master.dbo.sysdatabases
OPEN lock_cursor
FETCH NEXT FROM lock_cursor INTO @WPARA
WHILE @@FETCH_STATUS = 0
   BEGIN
        BEGIN
          use master EXEC ('USE '+@WPARA+' insert into [master].[dbo].tmp select name  FROM sysusers ')
        END
      FETCH NEXT FROM lock_cursor INTO @WPARA
   END
CLOSE lock_cursor
DEALLOCATE lock_cursor
select @WCOUNT=count(*) from [master].[dbo].tmp where name ='SEED'
select 'Nombre='+cast(@WCOUNT as varchar)
if @WCOUNT<1
BEGIN
select 'on peut supprimer le login'
DROP LOGIN SEED
print 'drop login SEED'
DROP LOGIN SEED_REPORT
print 'drop login SEED_REPORT'
END
else
select 'on ne peut peut pas supprimer le login'
if OBJECT_ID('master.dbo.tmp') is not null and objectproperty( object_id('master.dbo.tmp') , 'IsUserTable' )=1
drop table [master].[dbo].tmp
else
print 'table [master].[dbo].tmp non presente'
go
