--******************************************************************************
--**
--**                 Copyright (c) 2022 Version 1
--**
--**                           Millennium House,
--**                           Millennium Walkway,
--**                           Dublin 1
--**                           D01 F5P8
--**
--**                           All rights reserved.
--**
--*****************************************************************************

set verify off
set termout off
set echo off
set head off
set lines 120
column Object format a40
column Object_Type format a30
column Owner format a30

spool &1/dbvalidity.log

BEGIN
  FOR cur_rec IN (SELECT owner,
                         object_name,
                         object_type,
                         DECODE(object_type, 'PACKAGE', 1,
                                             'PACKAGE BODY', 2, 
                                             'VIEW',3,
                                            'SYNONYM',4,2) AS recompile_order
                  FROM   dba_objects
                  WHERE  object_type IN ('PACKAGE', 'PACKAGE BODY','VIEW','SYNONYM')
                  AND    status != 'VALID'
                  ORDER BY 4)
  LOOP
    BEGIN
      IF cur_rec.object_type = 'PACKAGE' THEN
        EXECUTE IMMEDIATE 'ALTER ' || cur_rec.object_type || 
            ' "' || cur_rec.owner || '"."' || cur_rec.object_name || '" COMPILE';
      ElSIF cur_rec.object_type = 'PACKAGE BODY' THEN
        EXECUTE IMMEDIATE 'ALTER PACKAGE "' || cur_rec.owner || 
            '"."' || cur_rec.object_name || '" COMPILE BODY';
      ElSIF cur_rec.object_type = 'VIEW' THEN
         EXECUTE IMMEDIATE 'ALTER VIEW "' || cur_rec.owner || 
            '"."' || cur_rec.object_name || '" COMPILE';
     ElSIF cur_rec.object_type = 'VIEW' and cur_rec.owner != 'PUBLIC' THEN
         EXECUTE IMMEDIATE 'ALTER SYNONYM "' || cur_rec.owner || 
            '"."' || cur_rec.object_name || '" COMPILE';
     ELSIF cur_rec.object_type = 'VIEW' and cur_rec.owner = 'PUBLIC' THEN
         EXECUTE IMMEDIATE 'ALTER PUBLIC SYNONYM "' || cur_rec.object_name || '" COMPILE';
      END IF;
    EXCEPTION
      WHEN OTHERS THEN
        DBMS_OUTPUT.put_line(cur_rec.object_type || ' : ' || cur_rec.owner || 
                             ' : ' || cur_rec.object_name);
    END;
  END LOOP;
END;
/

SELECT 'Invalid ' || Object_Type Object_Type, Owner, Object_Name Object
FROM all_objects
WHERE status <> 'VALID' ;

SELECT 'Maximise 2.0 successfully installed'
FROM DUAL
WHERE NOT EXISTS (
   SELECT *
   FROM all_objects
   WHERE status <> 'VALID') ;

spool off;

set verify on
set echo off
set termout on

EXIT
/




