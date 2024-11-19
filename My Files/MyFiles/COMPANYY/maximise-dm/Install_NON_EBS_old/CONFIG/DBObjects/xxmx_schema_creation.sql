--==========================================================================
--== MXDM 1.0 Schema Creation Script
--==========================================================================

--==========================================================================
--== The following script creates required schema for MAXIMISE 1.0 Toolkit. 
--==========================================================================

--==========================================================================
--== Accept Password for MAXIMISE SCHEMAS
--==========================================================================
accept XXMX_STG_SCHEMA_PASSWORD  CHAR prompt 'Enter STG  SCHEMA password ,min 2 numerals and 2 special [] '
accept XXMX_XFM_SCHEMA_PASSWORD  CHAR prompt 'Enter XFM  SCHEMA password ,min 2 numerals and 2 special [] '
accept XXMX_CORE_SCHEMA_PASSWORD CHAR prompt 'Enter CORE SCHEMA password ,min 2 numerals and 2 special [] '

--==========================================================================
--== Log Header and timestamps
--==========================================================================

column dcol new_value spool_date noprint
select to_char(sysdate,'RRRRMMDD_HH24MISS') dcol from dual;



spool /home/oracle/maximise/version1/MXDM/install/log/schema_creation_&spool_date.log
PROMPT ===============Script Start Time=====================
Select to_char(SYSDATE,'DD-MON-RRRR HH:MI:SS') strttime from Dual;
PROMPT =====================================================
set verify off

--==========================================================================
--== Creates TEMP TABLESPACE for SCHEMA Installation
--==========================================================================
DROP tablespace TEMP_MXDM including contents and datafiles;

CREATE TEMPORARY TABLESPACE TEMP_MXDM TEMPFILE '+DATA' size 10G autoextend on maxsize 12G;

--==========================================================================
--== Creates required TABLESPACE for SCHEMA required in MXDM 2.0 Toolkit. 
--==========================================================================
DROP tablespace XXMX_CORE including contents and datafiles;
DROP tablespace XXMX_STG  including contents and datafiles;
DROP tablespace XXMX_XFM  including contents and datafiles;

create TABLESPACE XXMX_CORE   datafile   size 4G autoextend on maxsize 5G;
create TABLESPACE XXMX_STG    datafile   size 4G autoextend on maxsize 5G;
create TABLESPACE XXMX_XFM    datafile   size 4G autoextend on maxsize 5G;


--==========================================================================
--== Creates required SCHEMA for MAXIMISE 1.0 Toolkit. 
--==========================================================================
DROP USER XXMX_CORE CASCADE;
DROP USER XXMX_STG  CASCADE;
DROP USER XXMX_XFM  CASCADE;

create user XXMX_CORE   identified by "&XXMX_CORE_SCHEMA_PASSWORD"  default TABLESPACE XXMX_CORE TEMPORARY TABLESPACE TEMP_MXDM;
create user XXMX_STG    identified by "&XXMX_STG_SCHEMA_PASSWORD"   default TABLESPACE XXMX_STG  TEMPORARY TABLESPACE TEMP_MXDM;
create user XXMX_XFM    identified by "&XXMX_XFM_SCHEMA_PASSWORD"   default TABLESPACE XXMX_XFM  TEMPORARY TABLESPACE TEMP_MXDM;

--==========================================================================
--== Alter and grants required roles/permissions required for XXMX_CORE SCHEMA. 
--==========================================================================
ALTER USER XXMX_CORE quota unlimited on XXMX_CORE;
GRANT CREATE CLUSTER TO XXMX_CORE;
GRANT CREATE DIMENSION TO XXMX_CORE;
GRANT CREATE INDEXTYPE TO XXMX_CORE;
GRANT CREATE JOB TO XXMX_CORE;
GRANT CREATE MATERIALIZED VIEW TO XXMX_CORE;
GRANT CREATE OPERATOR TO XXMX_CORE;
GRANT CREATE PROCEDURE TO XXMX_CORE;
GRANT CREATE SEQUENCE TO XXMX_CORE;
GRANT CREATE SESSION TO XXMX_CORE;
GRANT CREATE SYNONYM TO XXMX_CORE;
GRANT CREATE TABLE TO XXMX_CORE;
GRANT CREATE TRIGGER TO XXMX_CORE;
GRANT CREATE TYPE TO XXMX_CORE;
GRANT CREATE VIEW TO XXMX_CORE;
GRANT CREATE SESSION TO XXMX_CORE;
GRANT IMP_FULL_DATABASE TO XXMX_CORE;
GRANT RESOURCE TO XXMX_CORE;
GRANT CONNECT TO XXMX_CORE;

--==========================================================================
--== Alter and grants required roles/permissions required for XXMX_STG SCHEMA. 
--==========================================================================
ALTER USER XXMX_STG quota unlimited on XXMX_STG;
GRANT CREATE CLUSTER TO xxmx_stg;
GRANT CREATE DIMENSION TO xxmx_stg;
GRANT CREATE INDEXTYPE TO xxmx_stg;
GRANT CREATE JOB TO xxmx_stg;
GRANT CREATE MATERIALIZED VIEW TO xxmx_stg;
GRANT CREATE OPERATOR TO xxmx_stg;
GRANT CREATE PROCEDURE TO xxmx_stg;
GRANT CREATE SEQUENCE TO xxmx_stg;
GRANT CREATE SESSION TO xxmx_stg;
GRANT CREATE SYNONYM TO xxmx_stg;
GRANT CREATE TABLE TO xxmx_stg;
GRANT CREATE TRIGGER TO xxmx_stg;
GRANT CREATE TYPE TO xxmx_stg;
GRANT CREATE VIEW TO xxmx_stg;
GRANT CREATE SESSION TO xxmx_stg;
GRANT IMP_FULL_DATABASE TO xxmx_stg;
GRANT RESOURCE TO xxmx_stg;
GRANT CONNECT TO xxmx_stg;

--==========================================================================
--== Alter and grants required roles/permissions required for XXMX_XFM SCHEMA. 
--==========================================================================
ALTER USER XXMX_XFM quota unlimited on XXMX_XFM;
GRANT CREATE CLUSTER TO xxmx_xfm;
GRANT CREATE DIMENSION TO xxmx_xfm;
GRANT CREATE INDEXTYPE TO xxmx_xfm;
GRANT CREATE JOB TO xxmx_xfm;
GRANT CREATE MATERIALIZED VIEW TO xxmx_xfm;
GRANT CREATE OPERATOR TO xxmx_xfm;
GRANT CREATE PROCEDURE TO xxmx_xfm;
GRANT CREATE SEQUENCE TO xxmx_xfm;
GRANT CREATE SESSION TO xxmx_xfm;
GRANT CREATE SYNONYM TO xxmx_xfm;
GRANT CREATE TABLE TO xxmx_xfm;
GRANT CREATE TRIGGER TO xxmx_xfm;
GRANT CREATE TYPE TO xxmx_xfm;
GRANT CREATE VIEW TO xxmx_xfm;
GRANT CREATE SESSION TO xxmx_xfm;
GRANT IMP_FULL_DATABASE TO xxmx_xfm;
GRANT RESOURCE TO xxmx_xfm;
GRANT CONNECT TO xxmx_xfm;


PROMPT =============== Script End Time======================
Select to_char(SYSDATE,'DD-MON-RRRR HH:MI:SS') endtime from Dual;
PROMPT =====================================================


EXIT



spool off;


