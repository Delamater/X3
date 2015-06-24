/********************************************************************************************
Author:			Sage																	
Description:		The following procedure either reports or fixes the following use cases:
					-- 1. SORDERP where missing SORDER
					-- 2. SORDERQ where missing SORDER	
					-- 3. SORDERP where missing SORDERQ - 
							leave SORDERQ with records that only have SORDERP matches / line 
					-- 4. SORDERQ where missing SORDERP - 
							leave SORDERP with records that only have SORDERQ matches
					-- 5. CPTANALIN where missing SORDERP
					-- 6. SORDER with missing SORDERP 
					-- 7. PORDERP where missing PORDER
					-- 8. DELETE PORDERQ where missing PORDER
					-- 11. CPTANALIN where missing PORDERP
					-- 12. PORDER with missing PORDERP		
	
					Order of deletion is as follows:
					Use case 1
					Use case 3
					Use case 6
					Use case 2
					Use case 4
					Use case 5
					Use case 11
					Use case 7
					Use case 12
					Uase case 8
					Use case 9
																
Date:				06/24/2015
Disclaimer:			<To be entered by legal>	
********************************************************************************************/
	

CREATE PROCEDURE uspFixOrphanSalesOrderRows @DiagMode BIT = 1 AS
IF @DiagMode = 1
BEGIN
	--1. SORDERP where missing SORDER
	SELECT * 
	FROM DEMO.SORDERP p 
	WHERE 
		p.SOHCAT_0<4
		AND NOT EXISTS (SELECT 'X' FROM DEMO.SORDER s WHERE s.SOHNUM_0=p.SOHNUM_0)
		
	-- 2. SORDERQ where missing SORDER	
	SELECT * 
	FROM DEMO.SORDERQ p 
	WHERE 
		p.SOHCAT_0<4
		AND NOT EXISTS (SELECT 'X' FROM DEMO.SORDER s WHERE s.SOHNUM_0=p.SOHNUM_0)

	-- 3. SORDERP where missing SORDERQ - leave SORDERQ with records that only have SORDERP matches / line 
	SELECT * 
	FROM DEMO.SORDERP p 
	WHERE p.SOHCAT_0<4
	AND NOT EXISTS (SELECT 'X' FROM DEMO.SORDERQ q WHERE q.SOHNUM_0=p.SOHNUM_0 AND q.SOPLIN_0=p.SOPLIN_0 AND q.SOQSEQ_0=p.SOPSEQ_0)
			
	-- 4. SORDERQ where missing SORDERP - leave SORDERP with records that only have SORDERQ matches
	SELECT * 
	FROM DEMO.SORDERQ q 
	WHERE q.SOHCAT_0<4
	AND NOT EXISTS (SELECT 'X' FROM DEMO.SORDERP p WHERE q.SOHNUM_0=p.SOHNUM_0 AND q.SOPLIN_0=p.SOPLIN_0 AND q.SOQSEQ_0=p.SOPSEQ_0)

	-- 5. CPTANALIN where missing SORDERP
	SELECT * 
	FROM DEMO.CPTANALIN A 
	WHERE ABRFIC_0 = 'SOP' 
		AND NOT EXISTS 
		(
			SELECT 'X' 
			FROM DEMO.SORDERP P 
			WHERE 
				P.SOHNUM_0=A.VCRNUM_0 
				AND P.SOPLIN_0=A.VCRLIN_0 
				AND P.SOPSEQ_0 =A.VCRSEQ_0
		)

	-- 6. SORDER with missing SORDERP 
	SELECT *
	FROM DEMO.SORDER s
	WHERE s.SOHCAT_0 <4
			AND NOT EXISTS (SELECT 'X' FROM DEMO.SORDERP p WHERE s.SOHNUM_0=p.SOHNUM_0)

	-- 7. PORDERP where missing PORDER
	SELECT * 
	FROM DEMO.PORDERP p 
	WHERE 
		p.POHTYP_0=1
		AND NOT EXISTS (SELECT 'X' FROM DEMO.PORDER s WHERE s.POHNUM_0=p.POHNUM_0)
		
	-- 8. DELETE PORDERQ where missing PORDER
	SELECT * 
	FROM DEMO.PORDERQ p 
	WHERE 
		p.POHTYP_0=1
		AND NOT EXISTS (SELECT 'X' FROM DEMO.PORDER s WHERE s.POHNUM_0=p.POHNUM_0)

	-- 11. CPTANALIN where missing PORDERP
	SELECT * 
	FROM DEMO.CPTANALIN A 
	WHERE ABRFIC_0 = 'POP' 
		AND NOT EXISTS 
		(
			SELECT 'X' 
			FROM DEMO.PORDERP P 
			WHERE 
				P.POHNUM_0=A.VCRNUM_0 
				AND P.POPLIN_0=A.VCRLIN_0 
				AND P.POPSEQ_0 =A.VCRSEQ_0
		)

	-- 12. PORDER with missing PORDERP 
	SELECT *
	FROM DEMO.PORDER s
	WHERE s.POHTYP_0=1
			AND NOT EXISTS (SELECT 'X' FROM DEMO.PORDERP p WHERE s.POHNUM_0=p.POHNUM_0)

	PRINT 'Diagnostic mode completed. No changes were made.'
	
RETURN 
END


PRINT 'Proceeding to data clean up'
BEGIN TRAN
BEGIN TRY

IF @DiagMode = 1

	-- Create backup tables and prepare them for insertion
	IF OBJECT_ID('DEMO.ZSORDERP_BACK', 'U') IS NULL
	BEGIN
		SELECT * INTO DEMO.ZSORDERP_BACK FROM DEMO.SORDERP WHERE 1=2
		ALTER TABLE DEMO.ZSORDERP_BACK DROP COLUMN ROWID
		ALTER TABLE DEMO.ZSORDERP_BACK ADD ROWID INT NOT NULL
		
		EXEC sys.sp_addextendedproperty 
			@name = 'Desc. - 1', 
			@value = 'Log of SORDERP records that where missing SORDER records.',
			@level0type = 'Schema', 
			@level0name = 'DEMO',
			@level1type = 'TABLE', 
			@level1name = 'ZSORDERP_BACK'

		EXEC sys.sp_addextendedproperty 
			@name = 'Desc. - 3', 
			@value = 'Log of SORDERP where missing SORDERQ. This will leave SORDERQ with records that only have SORDERP matches at the line level', 
			@level0type = 'Schema', 
			@level0name = 'DEMO',
			@level1type = 'TABLE', 
			@level1name = 'ZSORDERP_BACK'
			
		PRINT 'New table created DEMO.ZSORDERP_BACK'	
	END

	IF OBJECT_ID('DEMO.ZSORDER_BACK', 'U') IS NULL
	BEGIN
		SELECT * INTO DEMO.ZSORDER_BACK FROM DEMO.SORDER WHERE 1=2
		ALTER TABLE DEMO.ZSORDER_BACK DROP COLUMN ROWID
		ALTER TABLE DEMO.ZSORDER_BACK ADD ROWID INT NOT NULL
		EXEC sys.sp_addextendedproperty 
			@name = 'Desc. - 6', 
			@value = 'Log of SORDER where missing SORDERP records', 
			@level0type = 'Schema', 
			@level0name = 'DEMO',
			@level1type = 'TABLE', 
			@level1name = 'ZSORDER_BACK'	
		PRINT 'New table created DEMO.ZSORDER_BACK'	
	END

	IF OBJECT_ID('DEMO.ZSORDERQ_BACK', 'U') IS NULL
	BEGIN
		SELECT * INTO DEMO.ZSORDERQ_BACK FROM DEMO.SORDERQ WHERE 1=2
		ALTER TABLE DEMO.ZSORDERQ_BACK DROP COLUMN ROWID
		ALTER TABLE DEMO.ZSORDERQ_BACK ADD ROWID INT NOT NULL
		
		EXEC sys.sp_addextendedproperty 
			@name = 'Desc. - 2', 
			@value = 'Log of SORDERQ where missing SORDER records', 
			@level0type = 'Schema', 
			@level0name = 'DEMO',
			@level1type = 'TABLE', 
			@level1name = 'ZSORDERQ_BACK'

		EXEC sys.sp_addextendedproperty 
			@name = 'Desc. - 4', 
			@value = 'Log of SORDERPQ records that where missing SORDERP correlations. This will leave SORDERP with records that only have SORDERP matches at the line level', 
			@level0type = 'Schema', 
			@level0name = 'DEMO',
			@level1type = 'TABLE', 
			@level1name = 'ZSORDERQ_BACK'
			
		PRINT 'New table created DEMO.ZSORDERQ_BACK'	
	END
	
	IF OBJECT_ID('DEMO.ZCPTANALIN_BACK', 'U') IS NULL
	BEGIN
		SELECT * INTO DEMO.ZCPTANALIN_BACK FROM DEMO.CPTANALIN WHERE 1=2
		ALTER TABLE DEMO.ZCPTANALIN_BACK DROP COLUMN ROWID
		ALTER TABLE DEMO.ZCPTANALIN_BACK ADD ROWID INT NOT NULL

		EXEC sys.sp_addextendedproperty 
			@name = 'Desc - 5.', 
			@value = 'Log of CPTANALIN records missing SORDERP correlations. ',
			@level0type = 'Schema', 
			@level0name = 'DEMO',
			@level1type = 'TABLE', 
			@level1name = 'ZCPTANALIN_BACK'
			
		EXEC sys.sp_addextendedproperty 
			@name = 'Desc. - 11', 
			@value = 'Log of CPTANALIN records missing PORDERP correlations. ',
			@level0type = 'Schema', 
			@level0name = 'DEMO',
			@level1type = 'TABLE', 
			@level1name = 'ZCPTANALIN_BACK'
		
		PRINT 'New table created DEMO.ZCPTANALIN_BACK'	
	END

	IF OBJECT_ID('DEMO.ZPORDERP_BACK', 'U') IS NULL
	BEGIN
		SELECT * INTO DEMO.ZPORDERP_BACK FROM DEMO.PORDERP WHERE 1=2
		ALTER TABLE DEMO.ZPORDERP_BACK DROP COLUMN ROWID
		ALTER TABLE DEMO.ZPORDERP_BACK ADD ROWID INT NOT NULL
		EXEC sys.sp_addextendedproperty 
			@name = 'Desc. - 7', 
			@value = 'Log of PORDERP where missing PORDER.',
			@level0type = 'Schema', 
			@level0name = 'DEMO',
			@level1type = 'TABLE', 
			@level1name = 'ZPORDERP_BACK'
			
		PRINT 'New table created DEMO.ZPORDERP_BACK'	
	END

	IF OBJECT_ID('DEMO.ZPORDER_BACK', 'U') IS NULL
	BEGIN
		SELECT * INTO DEMO.ZPORDER_BACK FROM DEMO.PORDER WHERE 1=2
		ALTER TABLE DEMO.ZPORDER_BACK DROP COLUMN ROWID
		ALTER TABLE DEMO.ZPORDER_BACK ADD ROWID INT NOT NULL
		EXEC sys.sp_addextendedproperty 
			@name = 'Desc. - 12', 
			@value = 'Log of PORDER with missing PORDERP.',
			@level0type = 'Schema', 
			@level0name = 'DEMO',
			@level1type = 'TABLE', 
			@level1name = 'ZPORDER_BACK'
			
		PRINT 'New table created DEMO.ZPORDER_BACK'	
	END
	
	
	IF OBJECT_ID('DEMO.ZPORDERQ_BACK', 'U') IS NULL
	BEGIN
		SELECT * INTO DEMO.ZPORDERQ_BACK FROM DEMO.PORDERQ WHERE 1=2
		ALTER TABLE DEMO.ZPORDERQ_BACK DROP COLUMN ROWID
		ALTER TABLE DEMO.ZPORDERQ_BACK ADD ROWID INT NOT NULL
		EXEC sys.sp_addextendedproperty 
			@name = 'Desc. - 8', 
			@value = 'Log of PORDERQ where missing PORDER.',
			@level0type = 'Schema', 
			@level0name = 'DEMO',
			@level1type = 'TABLE', 
			@level1name = 'ZPORDERQ_BACK'	
		
		PRINT 'New table created DEMO.ZPORDERQ_BACK'		
	END
	
	--ZSORDERC Considered and not needed


/************************************** Begin Deletion **************************************/
	-- 1. Delete SORDERP where missing SORDER
	INSERT INTO DEMO.ZSORDERP_BACK
	SELECT * 
	FROM DEMO.SORDERP p 
	WHERE 
		p.SOHCAT_0<4
		AND NOT EXISTS (SELECT 'X' FROM DEMO.SORDER s WHERE s.SOHNUM_0=p.SOHNUM_0)
	
	DELETE DEMO.SORDERP 
	FROM DEMO.SORDERP p
	WHERE 
		p.SOHCAT_0<4
		AND NOT EXISTS (SELECT 'X' FROM DEMO.SORDER s WHERE s.SOHNUM_0=p.SOHNUM_0)

	-- 2. DELETE SORDERQ where missing SORDER
	INSERT INTO DEMO.ZSORDERQ_BACK
	SELECT * 
	FROM DEMO.SORDERQ p 
	WHERE 
		p.SOHCAT_0<4
		AND NOT EXISTS (SELECT 'X' FROM DEMO.SORDER s WHERE s.SOHNUM_0=p.SOHNUM_0)

	DELETE DEMO.SORDERQ 
	FROM DEMO.SORDERQ q
		WHERE q.SOHCAT_0<4
		AND NOT EXISTS (SELECT 'X' FROM DEMO.SORDER s WHERE s.SOHNUM_0=q.SOHNUM_0)
		

	-- 3. DELETE SORDERP where missing SORDERQ - leave SORDERQ with records that only have SORDERP matches / line 
	INSERT INTO DEMO.ZSORDERP_BACK
	SELECT * 
	FROM DEMO.SORDERP p 
	WHERE p.SOHCAT_0<4
	AND NOT EXISTS (SELECT 'X' FROM DEMO.SORDERQ q WHERE q.SOHNUM_0=p.SOHNUM_0 AND q.SOPLIN_0=p.SOPLIN_0 AND q.SOQSEQ_0=p.SOPSEQ_0)

	DELETE DEMO.SORDERP 
	FROM DEMO.SORDERP p
	WHERE p.SOHCAT_0<4
	AND NOT EXISTS (SELECT 'X' FROM DEMO.SORDERQ q WHERE q.SOHNUM_0=p.SOHNUM_0 AND q.SOPLIN_0=p.SOPLIN_0 AND q.SOQSEQ_0=p.SOPSEQ_0)
	
	-- 4. DELETE SORDERQ where missing SORDERP - leave SORDERP with records that only have SORDERQ matches
	INSERT INTO DEMO.ZSORDERQ_BACK
	SELECT * 
	FROM DEMO.SORDERQ q 
	WHERE q.SOHCAT_0<4
	AND NOT EXISTS (SELECT 'X' FROM DEMO.SORDERP p WHERE q.SOHNUM_0=p.SOHNUM_0 AND q.SOPLIN_0=p.SOPLIN_0 AND q.SOQSEQ_0=p.SOPSEQ_0)

	DELETE DEMO.SORDERQ 
	FROM DEMO.SORDERQ q
	WHERE q.SOHCAT_0<4
	AND NOT EXISTS (SELECT 'X' FROM DEMO.SORDERP p WHERE q.SOHNUM_0=p.SOHNUM_0 AND q.SOPLIN_0=p.SOPLIN_0 AND q.SOQSEQ_0=p.SOPSEQ_0)

	-- 5. DELETE CPTANALIN where missing SORDERP
	INSERT INTO DEMO.ZCPTANALIN_BACK
	SELECT * 
	FROM DEMO.CPTANALIN A 
	WHERE ABRFIC_0 = 'SOP' 
		AND NOT EXISTS 
		(
			SELECT 'X' 
			FROM DEMO.SORDERP P 
			WHERE 
				P.SOHNUM_0=A.VCRNUM_0 
				AND P.SOPLIN_0=A.VCRLIN_0 
				AND P.SOPSEQ_0 =A.VCRSEQ_0
		)
	
	DELETE DEMO.CPTANALIN
	FROM DEMO.CPTANALIN A
	WHERE ABRFIC_0 = 'SOP' 
		AND NOT EXISTS 
		(
			SELECT 'X' 
			FROM DEMO.SORDERP P 
			WHERE 
				P.SOHNUM_0=A.VCRNUM_0 
				AND P.SOPLIN_0=A.VCRLIN_0 
				AND P.SOPSEQ_0 =A.VCRSEQ_0
		)

	-- 6. SORDER with missing SORDERP 
	INSERT INTO DEMO.ZSORDER_BACK
	SELECT *
	FROM DEMO.SORDER s
	WHERE s.SOHCAT_0 <4
			AND NOT EXISTS (SELECT 'X' FROM DEMO.SORDERP p WHERE s.SOHNUM_0=p.SOHNUM_0)
			
	DELETE DEMO.SORDER
	FROM DEMO.SORDER s
	WHERE s.SOHCAT_0 <4
			AND NOT EXISTS (SELECT 'X' FROM DEMO.SORDERP p WHERE s.SOHNUM_0=p.SOHNUM_0)

	-- 7. Delete PORDERP where missing PORDER
	INSERT INTO DEMO.ZPORDERP_BACK
	SELECT * 
	FROM DEMO.PORDERP p 
	WHERE 
		p.POHTYP_0=1
		AND NOT EXISTS (SELECT 'X' FROM DEMO.PORDER s WHERE s.POHNUM_0=p.POHNUM_0)
	
	DELETE DEMO.PORDERP 
	FROM DEMO.PORDERP p
	WHERE 
		p.POHTYP_0=1
		AND NOT EXISTS (SELECT 'X' FROM DEMO.PORDER s WHERE s.POHNUM_0=p.POHNUM_0)
	
	-- 8. DELETE PORDERQ where missing PORDER
	INSERT INTO DEMO.ZPORDERQ_BACK
	SELECT * 
	FROM DEMO.PORDERQ p 
	WHERE 
		p.POHTYP_0=1
		AND NOT EXISTS (SELECT 'X' FROM DEMO.PORDER s WHERE s.POHNUM_0=p.POHNUM_0)

	DELETE DEMO.PORDERQ 
	FROM DEMO.PORDERQ q
		WHERE q.POHTYP_0=1
		AND NOT EXISTS (SELECT 'X' FROM DEMO.PORDER s WHERE s.POHNUM_0=q.POHNUM_0)

/*
	-- 9. DELETE PORDERP where missing PORDERQ - leave PORDERQ with records that only have PORDERP matches / line level
	INSERT INTO DEMO.ZPORDERP_BACK
	SELECT * 
	FROM DEMO.PORDERP p 
	WHERE p.POHTYP_0=1
	AND NOT EXISTS (SELECT 'X' FROM DEMO.PORDERQ q WHERE q.POHNUM_0=p.POHNUM_0 AND q.POPLIN_0=p.POPLIN_0 AND q.POQSEQ_0=p.POPSEQ_0)

	DELETE DEMO.PORDERP 
	FROM DEMO.PORDERP p
	WHERE p.POHTYP_0=1
	AND NOT EXISTS (SELECT 'X' FROM DEMO.PORDERQ q WHERE q.POHNUM_0=p.POHNUM_0 AND q.POPLIN_0=p.POPLIN_0 AND q.POQSEQ_0=p.POPSEQ_0)

	-- 10. DELETE PORDERQ where missing PORDERP - leave PORDERP with records that only have PORDERQ matches
	INSERT INTO DEMO.ZPORDERQ_BACK
	SELECT * 
	FROM DEMO.PORDERQ q 
	WHERE q.POHTYP_0=1
	AND NOT EXISTS (SELECT 'X' FROM DEMO.PORDERP p WHERE q.POHNUM_0=p.POHNUM_0 AND q.POPLIN_0=p.POPLIN_0 AND q.POQSEQ_0=p.POPSEQ_0)

	DELETE DEMO.PORDERQ 
	FROM DEMO.PORDERQ q
	WHERE q.POHTYP_0=1
	AND NOT EXISTS (SELECT 'X' FROM DEMO.PORDERP p WHERE q.POHNUM_0=p.POHNUM_0 AND q.POPLIN_0=p.POPLIN_0 AND q.POQSEQ_0=p.POPSEQ_0)

*/
	-- 11. DELETE CPTANALIN where missing PORDERP
	INSERT INTO DEMO.ZCPTANALIN_BACK
	SELECT * 
	FROM DEMO.CPTANALIN A 
	WHERE ABRFIC_0 = 'POP' 
		AND NOT EXISTS 
		(
			SELECT 'X' 
			FROM DEMO.PORDERP P 
			WHERE 
				P.POHNUM_0=A.VCRNUM_0 
				AND P.POPLIN_0=A.VCRLIN_0 
				AND P.POPSEQ_0 =A.VCRSEQ_0
		)
	
	DELETE DEMO.CPTANALIN
	FROM DEMO.CPTANALIN A
	WHERE ABRFIC_0 = 'POP' 
		AND NOT EXISTS 
		(
			SELECT 'X' 
			FROM DEMO.PORDERP P 
			WHERE 
				P.POHNUM_0=A.VCRNUM_0 
				AND P.POPLIN_0=A.VCRLIN_0 
				AND P.POPSEQ_0 =A.VCRSEQ_0
		)

	-- 12. PORDER with missing PORDERP 
	INSERT INTO DEMO.ZPORDER_BACK
	SELECT *
	FROM DEMO.PORDER s
	WHERE s.POHTYP_0=1
			AND NOT EXISTS (SELECT 'X' FROM DEMO.PORDERP p WHERE s.POHNUM_0=p.POHNUM_0)
			
	DELETE DEMO.PORDER
	FROM DEMO.PORDER s
	WHERE s.POHTYP_0=1
			AND NOT EXISTS (SELECT 'X' FROM DEMO.PORDERP p WHERE s.POHNUM_0=p.POHNUM_0)
END TRY

BEGIN CATCH
	SELECT	ERROR_NUMBER()		AS ErrorNumber,
			ERROR_SEVERITY()	AS ErrorSeverity,
			ERROR_STATE()		AS ErrorState,
			ERROR_PROCEDURE()	AS ErrorProcedure,
			ERROR_LINE()		AS ErrorLine,
			ERROR_MESSAGE()		AS ErrorMessage

	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK TRANSACTION
	END
END CATCH



-- Finally commit 
IF @@TRANCOUNT > 0
BEGIN
	COMMIT TRAN
END
