--======================================
--== MXDM 1.0 CORE OIC Script
--======================================
--
--========================================================================================================
--== The following script installs supporting OIC required in CORE schema to extract EBS/HCM/PAYROLL 
--== Source Data for Cloudbridge 2.0 Toolkit. 
--========================================================================================================

--==========================================================================
--== Log Header and timestamps
--==========================================================================


set verify off
set termout off
set echo on


spool &1/OIC.log

column dcol new_value spool_date noprint
select to_char(sysdate,'RRRRMMDD_HH24MISS') dcol from dual;

CREATE OR REPLACE PROCEDURE DropTable (pTable IN VARCHAR2) IS
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE ' || pTable ;
EXCEPTION
   WHEN OTHERS THEN
	  IF SQLCODE != -942 THEN
		 RAISE;
	  END IF;
END DropTable ;
/
CREATE OR REPLACE PROCEDURE DropSequence (pSequence IN VARCHAR2) IS
BEGIN
  EXECUTE IMMEDIATE 'DROP SEQUENCE ' || pSequence ;
EXCEPTION
   WHEN OTHERS THEN
	  IF SQLCODE != -02289 THEN
		 RAISE;
	  END IF;
END DropSequence ;
/


--==========================================================================
--== Calling CORE PLSQL to support OIC Data Migration
--==========================================================================
--
--
PROMPT
PROMPT ****************************************
PROMPT  Run Script xxmx_utilities_dbi
PROMPT ****************************************
PROMPT
--
--
@"&1/HCM/DBObjects/xxmx_person_migr_temp_s.sql"
@"&1/HCM/DBObjects/xxmx_hdl_file_temp.sql"
@"&1/CORE/DBObjects/xxmx_utilities_dbi.sql"

--
--
PROMPT
PROMPT ****************************************
PROMPT  Run Script xxmx_create_arch_dbi_script
PROMPT ****************************************
PROMPT
--
--

@"&1/EXTENSION/xxmx_create_arch_dbi_script.sql"
--
--
PROMPT
PROMPT ****************************************
PROMPT  Run Script xxmx_dm_entity_table_map_v
PROMPT ****************************************
PROMPT
--
--
@"&1/EXTENSION/xxmx_dm_entity_table_map_v.sql"
--
--
PROMPT
PROMPT ****************************************
PROMPT  Run Script xxmx_ftp_directory_create_scripts
PROMPT ****************************************
PROMPT
--
--

@"&1/EXTENSION/xxmx_ftp_directory_create_scripts.sql"
--
--
PROMPT
PROMPT ****************************************
PROMPT  Run script xxmx_oic_table_dbi
PROMPT ****************************************
PROMPT
--
--

@"&1/EXTENSION/xxmx_oic_table_dbi.sql"
--
--
PROMPT
PROMPT ****************************************
PROMPT Run script xxmx_temp_file_names_v
PROMPT ****************************************
PROMPT
--
--

@"&1/EXTENSION/xxmx_temp_file_names_v.sql"
--
--
PROMPT
PROMPT ****************************************
PROMPT  Scripts Executions Completed
PROMPT ****************************************
PROMPT
--
--

select to_char(sysdate,'DDMMRRRR HH24MISS') End_time from dual;

EXIT

spool off;


