-- Find the field name, what screens it is tied to, and what the long string name is for any given X3 field
-- Press Ctrl + Shift + M to enter the parameters
SELECT f.CODMSK_0, f.CODTYP_0 Mask, f.CODZON_0 Field, t.TEXTE_0 FieldStringName
FROM <Folder Name, SYSNAME, SEED>.AMSKZON f
	INNER JOIN <Folder Name, SYSNAME, SEED>.ATEXTE t
		ON f.INTIT_0 = t.NUMERO_0
		AND t.LAN_0 = 'ENG'
WHERE CODZON_0 = '<Field Name, VARCHAR(100), ITMREF>'
