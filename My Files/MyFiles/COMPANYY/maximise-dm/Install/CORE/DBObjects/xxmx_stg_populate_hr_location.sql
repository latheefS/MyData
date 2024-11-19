--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  17-MAY-2023  Soundarya Kamatagi  Created for Maximise.
--**
--******************************************************************************


-- *********************
-- **HR LOCATION
-- *********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'LOCATION',
pt_i_SubEntity=> 'LOCATION',
pt_import_data_file_name => 'XXMX_HCM_HR_LOCATION.dat',
pt_control_file_name => 'XXMX_HCM_HR_LOCATION.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/



