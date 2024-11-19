--******************************************************************************
--**
--** xxmx_xfm_populate_hr_location.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  17-MAY-2023  Soundarya Kamatagi   Created for Maximise.
--**
--******************************************************************************


-- *********************
-- **HR LOCATION
-- *********************
   

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'HR',
pt_i_BusinessEntity=> 'LOCATION',
pt_i_SubEntity=> 'LOCATION',
pt_fusion_template_name=> 'Location.dat',
pt_fusion_template_sheet_name => 'Location',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/



