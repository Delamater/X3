-- Locate non-validated deliveries for larger line counts
WITH LargeDeliveries (DeliveryNumber, LineCount) AS
(
	SELECT SDHNUM_0, COUNT(*) LineCount
	FROM PROD.SDELIVERYD
	GROUP BY SDHNUM_0
	--ORDER BY COUNT(*) DESC
)

SELECT 
	Case d.CFMFLG_0
		WHEN 1 THEN 'Not Validated'
		WHEN 2 THEN 'Validated'
		ELSE 'Unknown'		
	END AS IsValidated, 
	ld.DeliveryNumber, 
	ld.LineCount
FROM LargeDeliveries ld
	INNER JOIN PROD.SDELIVERY d
		ON ld.DeliveryNumber = d.SDHNUM_0
WHERE 
	d.CFMFLG_0 = 1
	AND ld.LineCount> 1000
