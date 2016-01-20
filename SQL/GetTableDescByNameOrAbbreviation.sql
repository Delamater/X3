-- Press Ctrl+Shift+M to replace template parameters
-- Get Table Description by Abbreviation Or Name
SELECT t.ABRFIC_0 TableAbreviation, t.CODFIC_0 TableName, txt.TEXTE_0
FROM <X3 Folder Name,VARCHAR(255), SEED >.ATABLE t
	INNER JOIN <X3 Folder Name,VARCHAR(255), SEED >.ATEXTE txt
		ON t.INTITFIC_0 = txt.NUMERO_0
		AND txt.LAN_0 = 'ENG'
WHERE 
	CODFIC_0 = 'CACCE'		-- If you know the table name
	OR ABRFIC_0 = 'CCE'		-- If you know the table abbreviation
