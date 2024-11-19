--*****************************************************************************
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
--**
--** VERSION   :  2.0
--**
--** AUTHORS   :  Joe Lalor
--**
--** PURPOSE   :  Maximise schema creation
--**
--** NOTES     :
--**
--******************************************************************************

prompt
prompt Please wait ...
prompt

set verify off
set termout off
set echo on

spool &4/schema_creation.log

column dcol new_value spool_date noprint
select to_char(sysdate,'RRRRMMDD_HH24MISS') dcol from dual;

alter system set GLOBAL_NAMES=false;	

DECLARE

   PROCEDURE DropUser (pUser IN VARCHAR2) IS
   BEGIN
      EXECUTE IMMEDIATE 'DROP USER ' || pUser || ' CASCADE' ;
   EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -1918 THEN
         RAISE;
      END IF;
   END DropUser ;
   
   PROCEDURE DropTableSpace (pTableSpace IN VARCHAR2) IS
   BEGIN
      EXECUTE IMMEDIATE 'DROP TABLESPACE ' || pTableSpace || ' including contents and datafiles';
   EXCEPTION
   WHEN OTHERS THEN
      IF SQLCODE != -1543 AND SQLCODE != -959 THEN
         RAISE;
      END IF;
   END DropTableSpace ;
   
BEGIN
    DropUser ('xxmx_stg') ;
    DropUser ('xxmx_xfm') ;
    DropUser ('XXMX_CORE') ;
    DropTableSpace ('TEMP_MXDM') ;
    DropTableSpace ('XXMX_CORE') ;
    DropTableSpace ('xxmx_stg') ;
    DropTableSpace ('xxmx_xfm') ;
END;
/

CREATE TEMPORARY TABLESPACE TEMP_MXDM TEMPFILE '+DATA' size 10G reuse autoextend on maxsize 12G;

set echo off
set termout on
prompt Working ...
set termout off
set echo on
create TABLESPACE XXMX_CORE   datafile  'XXMX_CORE1.dbf' size 4G reuse autoextend on maxsize 5G;

set echo off
set termout on
prompt
prompt Working ...
set termout off
set echo on
create TABLESPACE xxmx_stg    datafile  'XXMX_STG1.dbf'  size 4G reuse autoextend on maxsize 5G;

set echo off
set termout on
prompt
prompt Still working ...
set termout off
set echo on
create TABLESPACE xxmx_xfm    datafile  'XXMX_XFM1.dbf'  size 4G reuse autoextend on maxsize 5G;

create user xxmx_stg    identified by "&1"  default TABLESPACE xxmx_stg  TEMPORARY TABLESPACE TEMP_MXDM;
create user xxmx_xfm    identified by "&2"  default TABLESPACE xxmx_xfm  TEMPORARY TABLESPACE TEMP_MXDM;
create user XXMX_CORE   identified by "&3"  default TABLESPACE XXMX_CORE TEMPORARY TABLESPACE TEMP_MXDM;

alter user xxmx_xfm quota unlimited on xxmx_xfm;
alter user xxmx_stg quota unlimited on xxmx_stg;
alter user XXMX_CORE quota unlimited on XXMX_CORE;

GRANT CREATE CLUSTER TO XXMX_CORE;
GRANT CREATE DIMENSION TO XXMX_CORE;
GRANT CREATE INDEXTYPE TO XXMX_CORE;
GRANT CREATE JOB TO XXMX_CORE;
GRANT CREATE MATERIALIZED VIEW TO XXMX_CORE;
GRANT CREATE OPERATOR TO XXMX_CORE;
GRANT CREATE PROCEDURE TO XXMX_CORE;
GRANT CREATE SEQUENCE TO XXMX_CORE;
GRANT CREATE SESSION TO XXMX_CORE ;
GRANT CREATE SYNONYM TO XXMX_CORE;
GRANT CREATE TABLE TO XXMX_CORE;
GRANT CREATE TRIGGER TO XXMX_CORE;
GRANT CREATE TYPE TO XXMX_CORE;
GRANT CREATE VIEW TO XXMX_CORE;
GRANT CREATE SESSION TO XXMX_CORE;
GRANT IMP_FULL_DATABASE TO XXMX_CORE;
GRANT RESOURCE TO XXMX_CORE;
GRANT CONNECT TO XXMX_CORE;

alter user XXMX_STG quota unlimited on xxmx_stg;
GRANT CREATE CLUSTER TO xxmx_stg;
GRANT CREATE DIMENSION TO xxmx_stg;
GRANT CREATE INDEXTYPE TO xxmx_stg;
GRANT CREATE JOB TO xxmx_stg;
GRANT CREATE MATERIALIZED VIEW TO xxmx_stg;
GRANT CREATE OPERATOR TO xxmx_stg;
GRANT CREATE PROCEDURE TO xxmx_stg;
GRANT CREATE SEQUENCE TO xxmx_stg;
GRANT CREATE SESSION TO xxmx_stg ;
GRANT CREATE SYNONYM TO xxmx_stg;
GRANT CREATE TABLE TO xxmx_stg;
GRANT CREATE TRIGGER TO xxmx_stg;
GRANT CREATE TYPE TO xxmx_stg;
GRANT CREATE VIEW TO xxmx_stg;
GRANT CREATE SESSION TO xxmx_stg;
GRANT IMP_FULL_DATABASE TO xxmx_stg;
GRANT RESOURCE TO xxmx_stg;
GRANT CONNECT TO xxmx_stg;

alter user XXMX_XFM quota unlimited on xxmx_xfm;
GRANT CREATE CLUSTER TO xxmx_xfm;
GRANT CREATE DIMENSION TO xxmx_xfm;
GRANT CREATE INDEXTYPE TO xxmx_xfm;
GRANT CREATE JOB TO xxmx_xfm;
GRANT CREATE MATERIALIZED VIEW TO xxmx_xfm;
GRANT CREATE OPERATOR TO xxmx_xfm;
GRANT CREATE PROCEDURE TO xxmx_xfm;
GRANT CREATE SEQUENCE TO xxmx_xfm;
GRANT CREATE SESSION TO xxmx_xfm ;
GRANT CREATE SYNONYM TO xxmx_xfm;
GRANT CREATE TABLE TO xxmx_xfm;
GRANT CREATE TRIGGER TO xxmx_xfm;
GRANT CREATE TYPE TO xxmx_xfm;
GRANT CREATE VIEW TO xxmx_xfm;
GRANT CREATE SESSION TO xxmx_xfm;
GRANT IMP_FULL_DATABASE TO xxmx_xfm;
GRANT RESOURCE TO xxmx_xfm;
GRANT CONNECT TO xxmx_xfm;

set echo off

SELECT DISTINCT 'Schemas successfully created'
  FROM dba_role_privs rp JOIN role_sys_privs rsp ON (rp.granted_role = rsp.role)
 WHERE rp.grantee = 'xxmx_xfm'
 AND ROLE = 'CONNECT' ;
 
spool off;

set verify on
set echo off
set termout on

EXIT

