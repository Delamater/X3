/********************************************************************************************
Search for specific parameters inside X3
Press CTRL+SHIFT+M to replace the parameters
********************************************************************************************/

-- Find Parameter by parameter code
DECLARE @ParamCode NVARCHAR(50)
SELECT t.TEXTE_0 AS MessageText, p.CHAPITRE_0 AS ParamChapter, p.GRPPAR_0 AS ParamGroup, p.PARAM_0
FROM <X3 Folder, SYSNAME, SEED>.ADOPAR p
	INNER JOIN <X3 Folder, SYSNAME, SEED>.ATEXTE t
		ON p.NAM_0 = t.NUMERO_0
		AND t.LAN_0 = '<Language Code, NVARCHAR(10), ENG>'
WHERE p.PARAM_0 = '<Parameter Code, VARCHAR(255), BUYFLT>'

-- Retrieve Values
SELECT * FROM <X3 Folder, SYSNAME, SEED>.ADOVAL WHERE PARAM_0 = '<Parameter Code, VARCHAR(255), BUYFLT>'

SELECT TOP 10 * 
FROM <X3 Folder, SYSNAME, SEED>.ADOPAR p
	INNER JOIN <X3 Folder, SYSNAME, SEED>.ATEXTE t
		ON p.NAM_0 = t.NUMERO_0
		AND t.LAN_0 = '<Language Code, NVARCHAR(10), ENG>'
WHERE t.TEXTE_0 LIKE '%<Parameter Text To Search, NVARCHAR(MAX), Filter by buyer>%'
