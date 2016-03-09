-- Address Validation Script"
-- Run this script first to determine if your accounts in 
-- X3 have addresses that are longer than what Sage CRM can accomodate. 
-- Any records that come back will fail migration with 
-- "String or binary data would be truncated" error message within SQL Server

-- To Execute this script you will need to adjust the schema definition. 
-- To do this with SQL Server Management Studion press CTRL + Shift + M
-- which will specify template values. 
-- The name of the schema will be the same name as your Sage X3 folder


-- This is the known limit for Sage CRM, but can be validated through sp_help ADDRESS against the Sage CRM Database
DECLARE @iCRMAddressLimit SMALLINT
SET @iCRMAddressLimit = 40				

SELECT TOP 10 BPANUM_0, BPAADD_0, BPAADDLIG_0, BPAADDLIG_1, BPAADDLIG_2
FROM <X3 Folder Name, SYSNAME, PROD>.BPADDRESS
WHERE 
	LEN(BPAADDLIG_0) >= @iCRMAddressLimit 
	OR LEN(BPAADDLIG_1) >= @iCRMAddressLimit 
	OR LEN(BPAADDLIG_2) >= @iCRMAddressLimit 
