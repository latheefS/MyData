--******************************************************************************
--**
--** xxmx_xfm_populate_item_structure.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  22-JUL-2024  Sinchana Ramesh     Created for Cloudbridge.
--**
--******************************************************************************


-- ************************
-- **STRUCTURE_HEADERS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM_STRUCTURE',
pt_i_SubEntity=> 'STRUCTURE_HEADERS_IMP',
pt_fusion_template_name=> 'EgpStructuresInterface.csv.csv',
pt_fusion_template_sheet_name => 'EgpStructuresInterface.csv',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- ** COMPONENTS_IMPORT
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM_STRUCTURE',
pt_i_SubEntity=> 'COMPONENTS_IMPORT',
pt_fusion_template_name=> 'EgpComponentsInterface.csv',
pt_fusion_template_sheet_name => 'EgpComponentsInterface.csv',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **SUBSTITUTE_COMPONENTS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM_STRUCTURE',
pt_i_SubEntity=> 'SUBSTITUTE_COMPONENTS_IMP',
pt_fusion_template_name=> 'EgpSubCompsInterface.csv',
pt_fusion_template_sheet_name => 'EgpSubCompsInterface.csv',
pt_fusion_template_sheet_order=>3,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ************************
-- **REFERENCE_DESIGNATORS_IMP
-- ************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'SCM',
pt_i_Application=> 'PLC',
pt_i_BusinessEntity=> 'ITEM_STRUCTURE',
pt_i_SubEntity=> 'REFERENCE_DESIGNATORS_IMP',
pt_fusion_template_name=> 'EgpRefDesgsInterface.csv',
pt_fusion_template_sheet_name => 'EgpRefDesgsInterface',
pt_fusion_template_sheet_order=>4,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/