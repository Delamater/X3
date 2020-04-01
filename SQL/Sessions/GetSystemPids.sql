-- Retrieve sadoss pid, adonix adxpid, useful when debugging the runtime
-- Press ctrl+shift+m to replace parameter
-- Retrieve parameter value from adxpid
SELECT adonix.SESSIONID_0, adonix.SYSTEMID_0 adxpid, sysa.DBIDENT1_0 spid, sadoss.SYSTEMID_0 sadossPID, sess.*
FROM X3.ASYSSMPROCES adonix
	INNER JOIN X3.ASYSSMDBASSO sysa
		ON adonix.SESSIONID_0 = sysa.SESSIONID_0
	INNER JOIN X3.ASYSSMPROCES sadoss
		ON sysa.SESSIONID_0 = sadoss.SESSIONID_0
	LEFT JOIN sys.dm_exec_sessions sess
		ON sadoss.SYSTEMID_0 = sess.host_process_id
WHERE adonix.SYSTEMID_0 = <adonix pid (adxpid), integer, 8848>
