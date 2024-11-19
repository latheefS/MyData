--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  16-FEB-2022  Shaik Latheef       Created.
--**
--******************************************************************************


-- *******************
-- **AR Invoices Lines
-- *******************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'TRANSACTIONS',
pt_i_SubEntity=> 'LINES',
pt_fusion_template_name=> 'RaInterfaceLinesAll.csv',
pt_fusion_template_sheet_name => 'RaInterfaceLinesAll',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- **************************
-- **AR Invoice Distributions
-- **************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'TRANSACTIONS',
pt_i_SubEntity=> 'DISTRIBUTIONS',
pt_fusion_template_name=> 'RaInterfaceDistributionsAll.csv',
pt_fusion_template_sheet_name => 'RaInterfaceDistributionsAll',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
-- *************************
-- **AR Invoice Salescredits
-- *************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'FIN',
pt_i_Application=> 'AR',
pt_i_BusinessEntity=> 'TRANSACTIONS',
pt_i_SubEntity=> 'SALESCREDITS',
pt_fusion_template_name=> 'RaInterfaceSalesCreditsAll.csv',
pt_fusion_template_sheet_name => 'RaInterfaceSalesCreditsAll',
pt_fusion_template_sheet_order=>3,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/