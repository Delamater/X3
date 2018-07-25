SELECT 'mess(' || LANNUM_0 || ',' || LANCHP_0 ||',1' || ')' AS PlugMeIntoTheX3Calculator, LANMES_0, LAN_0
FROM APLSTD 
WHERE LOWER(LANMES_0) like LOWER(N'%system signal%')
