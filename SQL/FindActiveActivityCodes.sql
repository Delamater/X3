-- Author:		Bob Delamater
-- Description:	Located activated activity codes, 
--				with their associated description from the ATEXTE table
-- Date:		01/21/2015
--
-- Parameters:	This procedure is a template. Press control + shift + m on your keyboard 
--				to replace the template parameters

/************************************************************************/
/******************* Find Activated Activity Codes **********************/
/************************************************************************/
USE <Database Name, SYSNAME, x3v6>

GO

SELECT CODACT_0, FLACT_0, t.TEXTE_0
FROM <Sage ERP X3 Folder Name, SYSNAME, NATRAINV6>.ACTIV a
	INNER JOIN <Sage ERP X3 Folder Name, SYSNAME, NATRAINV6>.ATEXTE t
	ON a.LIBACT_0 = t.NUMERO_0
	AND t.LAN_0 = 'ENG'
WHERE 
	FLACT_0 = 2				-- 1 = No, 2 = Yes
	AND a.CODACT_0 LIKE '[<Pattern Range For Activity Codes (1st char only), CHAR(3), X-Z>]%'
ORDER BY 1
