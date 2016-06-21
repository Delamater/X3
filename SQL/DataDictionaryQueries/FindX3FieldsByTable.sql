-- Find field names by long description
SELECT t.CODFIC_0, t.CODZONE_0, shortText.TEXTE_0 ShortText, longText.TEXTE_0 LongText, longText.*
FROM PROD.ATABZON t
	LEFT JOIN PROD.ATEXTE shortText
		ON t.NOCOURT_0 = shortText.NUMERO_0
			AND shortText.LAN_0 = 'ENG'
	LEFT JOIN PROD.ATEXTE longText
		ON t.NOLONG_0 = longText.NUMERO_0
			AND longText.LAN_0 = 'ENG'
WHERE 
	CODFIC_0 = <Table Name, SYSNAME, 'SORDER'>
	AND CODZONE_0 LIKE <Field Name, SYSNAME, 'SOH%'>
	
