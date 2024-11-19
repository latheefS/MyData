--======================================
--== MXDM 1.0 CORE PLSQL Script
--======================================
--
--========================================================================================================
--== The following script installs suporting PLSQL required in CORE schema to extract EBS/HCM/PAYROLL 
--== Source Data for MAXIMISE 1.0 Toolkit. 
--========================================================================================================

--==========================================================================
--== Log Header and timestamps
--==========================================================================

set verify off
set termout off
set echo on

spool &1/core.log

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
--== Alters database container  
--==========================================================================

--alter session set container = MXDM_PDB1;					

--==========================================================================
--== Calling CORE PLSQL to support EBS Data extraction
--==========================================================================

@"&1/CORE/DBObjects/xxmx_utilities_dbi.sql"
@"&1/CORE/DBObjects/xxmx_dynamic_sql_pkg.sql"
@"&1/GL/DBObjects/xxmx_gl_utilities_dbi.sql"
--@"&1/CORE/DBObjects/xxmx_core_synonyms_dbi.sql"
@"&1/HCM/DBObjects/xxmx_person_migr_temp_s.sql"
@"&1/HCM/DBObjects/xxmx_hdl_file_temp.sql"
@"&1/CORE/DBObjects/xxmx_utilities_pkg.sql"
@"&1/GL/DBObjects/xxmx_gl_utilities_pkg.sql"
@"&1/CORE/DBObjects/xxmx_populate_metadata.sql"       
@"&1/CORE/DBObjects/xxmx_populate_file_groups.sql"                    
@"&1/CORE/DBObjects/xxmx_populate_fusion_job_defs.sql"                
@"&1/CORE/DBObjects/xxmx_populate_lookups.sql"                        
@"&1/CORE/DBObjects/xxmx_populate_file_locations.sql"                 
@"&1/CORE/DBObjects/xxmx_populate_operating_units.sql"    
@"&1/CORE/DBObjects/xxmx_populate_default_migration_parameters.sql"   
--@"&1/CORE/DBObjects/xxmx_gl_utilities_migration_parameters_additions.sql"
@"&1/CORE/DBObjects/xxmx_file_groups_v.sql"    
@"&1/CORE/DBObjects/xxmx_oic_utilities_pkg.sql"
@"&1/CORE/DBObjects/xxmx_request_scheduling_dbi.sql"
@"&1/CORE/DBObjects/xxmx_request_scheduling_pkg.sql"
@"&1/CORE/DBObjects/xxmx_fin_stg_extract_pkg.sql"
@"&1/CORE/DBObjects/xxmx_hcm_stg_extract_pkg.sql"
@"&1/CORE/DBObjects/xxmx_populate_datafile.sql"

spool off;

set verify on
set echo off
set termout on

exit
