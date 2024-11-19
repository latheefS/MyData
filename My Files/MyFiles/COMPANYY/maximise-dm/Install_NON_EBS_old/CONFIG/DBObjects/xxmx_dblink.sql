--==================================================
--== MXDM 1.0 Database Link Creation Script
--==================================================
--
--===================================================================================
--== The following script creates required database link for MAXIMISE 1.0 Toolkit. 
--===================================================================================
--==========================================================================
--== Accept Password for MAXIMISE SCHEMAS
--==========================================================================
accept APPS_SCHEMA_PASSWORD  CHAR prompt 'Enter APPS  SCHEMA password [] '									
accept DATABASE_SID  	     CHAR prompt 'Enter DATABASE SID password [] '									

--==========================================================================
--== Log Header and timestamps
--==========================================================================

column dcol new_value spool_date noprint
select to_char(sysdate,'RRRRMMDD_HH24MISS') dcol from dual;

spool dblink.log
set verify off

alter system set GLOBAL_NAMES=false;		

--==========================================================================
--== Create Database Link
--==========================================================================
--Syntax to create database link
--create public database link &DATABASE_LINK connect to &SCHEMA_NAME identified by &SCHEMA_PASSWORD using '&SID';
DROP PUBLIC DATABASE LINK MXDM_NVIS_EXTRACT;

create public database link MXDM_NVIS_EXTRACT connect to apps identified by &APPS_SCHEMA_PASSWORD using '&DATABASE_SID';

--TESTING SYNTAX
--select = from dual@&DATABASE_LINK;
select * from dual@MXDM_NVIS_EXTRACT;

EXIT
spool off;

grep 'ORA-\|Error' dblink.log