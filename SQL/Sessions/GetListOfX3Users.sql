Select 
	X3SM1.SESSIONID_0 as 'Session_ID', 
	X3SM0.SESSIONTYPE_0,  
	X3SM1.DBIDENT1_0 as 'SPID', 
	X3SM1.DBIDENT2_0, 
	X3SM1.CREUSR_0, 
	X3SM1.UPDTICK_0, 
	X3SM0.ALOGIN_0 as 'Login Syracuse', 
	X3SM0.FOLD_0 as 'DOSSIER', 
	X3SM0.LAN_0 as 'Langue', 
	X3SM0.PEER_0 as 'IP Client', 
	X3SM0.PROCESSADX_0 as 'Port moteur',
	X3AFU.FCT_0 as 'Fonction', 
	X3AFU.USR_0 as 'User X3',  
	X3SM2.PROCESSNAME_0, 
	X3SM2.SYSTEMID_0 as 'PID OS', 
	X3SM2.PORT_0 as 'Port client'
from X3.ASYSSMDBASSO X3SM1 
	JOIN X3.ASYSSMINTERN X3SM0 
		ON X3SM1.SESSIONID_0 = X3SM0.SESSIONID_0 
	JOIN X3.AFCTCUR X3AFU 
		ON X3AFU.UID_0=X3SM1.SESSIONID_0
	JOIN X3.ASYSSMPROCES X3SM2 
		ON X3SM2.SESSIONID_0=X3SM1.SESSIONID_0
	JOIN  sys.dm_exec_connections VDS 
		ON VDS.session_id = convert(integer, X3SM1.DBIDENT1_0) 
			and VDS.connect_time = convert(datetime, X3SM1.DBIDENT2_0, 121 ) 
WHERE 
	X3SM0.FOLD_0='<X3 Folder Name, SYSNAME, SEED>' --and X3SM0.ALOGIN_0='<X3 User Login, NVARCHAR(40), admin>'
	AND X3SM2.SYSTEMID_0 = <adxpid, int, 13904>
