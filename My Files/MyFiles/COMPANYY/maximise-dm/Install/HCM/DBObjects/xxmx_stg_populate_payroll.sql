--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  30-AUG-2023  Shaik Latheef       Created for Cloudbridge.
--**
--******************************************************************************


-- **********************
-- **PAE Calculation Card
-- **********************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_PAE',
pt_i_SubEntity=> 'CALC_CARDS_PAE',
pt_import_data_file_name => 'XXMX_PAY_CALC_CARDS_PAE.dat',
pt_control_file_name => 'XXMX_PAY_CALC_CARDS_PAE.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_PAE',
pt_i_SubEntity=> 'COMP_DTL_PAE',
pt_import_data_file_name => 'XXMX_PAY_COMP_DTL_PAE.dat',
pt_control_file_name => 'XXMX_PAY_COMP_DTL_PAE.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_PAE',
pt_i_SubEntity=> 'COMP_ASOC_PAE',
pt_import_data_file_name => 'XXMX_PAY_COMP_ASOC_PAE.dat',
pt_control_file_name => 'XXMX_PAY_COMP_ASOC_PAE.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_PAE',
pt_i_SubEntity=> 'COMP_ASOC_DTL_PAE',
pt_import_data_file_name => 'XXMX_PAY_COMP_ASOC_DTL_PAE.dat',
pt_control_file_name => 'XXMX_PAY_COMP_ASOC_DTL_PAE.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- *****************************************************
-- **NI and PAYE Calculation Card (Statutory Deductions)
-- *****************************************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_SD',
pt_i_SubEntity=> 'CALC_CARDS_SD',
pt_import_data_file_name => 'XXMX_PAY_CALC_CARDS_SD.dat',
pt_control_file_name => 'XXMX_PAY_CALC_CARDS_SD.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_SD',
pt_i_SubEntity=> 'COMP_DTL_SD',
pt_import_data_file_name => 'XXMX_PAY_COMP_DTL_SD.dat',
pt_control_file_name => 'XXMX_PAY_COMP_DTL_SD.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- *******************************
-- **Student Loan Calculation Card
-- *******************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_SL',
pt_i_SubEntity=> 'CALC_CARDS_SL',
pt_import_data_file_name => 'XXMX_PAY_CALC_CARDS_SL.dat',
pt_control_file_name => 'XXMX_PAY_CALC_CARDS_SL.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_SL',
pt_i_SubEntity=> 'COMP_SL',
pt_import_data_file_name => 'XXMX_PAY_COMP_SL.dat',
pt_control_file_name => 'XXMX_PAY_COMP_SL.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_SL',
pt_i_SubEntity=> 'CARD_ASOC_SL',
pt_import_data_file_name => 'XXMX_PAY_CARD_ASOC_SL.dat',
pt_control_file_name => 'XXMX_PAY_CARD_ASOC_SL.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_SL',
pt_i_SubEntity=> 'COMP_DTL_SL',
pt_import_data_file_name => 'XXMX_PAY_COMP_DTL_SL.dat',
pt_control_file_name => 'XXMX_PAY_COMP_DTL_SL.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_SL',
pt_i_SubEntity=> 'COMP_ASOC_SL',
pt_import_data_file_name => 'XXMX_PAY_COMP_ASOC_SL.dat',
pt_control_file_name => 'XXMX_PAY_COMP_ASOC_SL.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- **************************************
-- **Benefit and Pension Calculation Card
-- **************************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_BP',
pt_i_SubEntity=> 'CALC_CARDS_BP',
pt_import_data_file_name => 'XXMX_PAY_CALC_CARDS_BP.dat',
pt_control_file_name => 'XXMX_PAY_CALC_CARDS_BP.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_BP',
pt_i_SubEntity=> 'CARD_COMP_BP',
pt_import_data_file_name => 'XXMX_PAY_CARD_COMP_BP.dat',
pt_control_file_name => 'XXMX_PAY_CARD_COMP_BP.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_BP',
pt_i_SubEntity=> 'ASOC_BP',
pt_import_data_file_name => 'XXMX_PAY_ASOC_BP.dat',
pt_control_file_name => 'XXMX_PAY_ASOC_BP.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_BP',
pt_i_SubEntity=> 'ASOC_DTL_BP',
pt_import_data_file_name => 'XXMX_PAY_ASOC_DTL_BP.dat',
pt_control_file_name => 'XXMX_PAY_ASOC_DTL_BP.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_BP',
pt_i_SubEntity=> 'COMP_DTL_BP',
pt_import_data_file_name => 'XXMX_PAY_COMP_DTL_BP.dat',
pt_control_file_name => 'XXMX_PAY_COMP_DTL_BP.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_BP',
pt_i_SubEntity=> 'ENTVAL_BP',
pt_import_data_file_name => 'XXMX_PAY_ENTVAL_BP.dat',
pt_control_file_name => 'XXMX_PAY_ENTVAL_BP.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_BP',
pt_i_SubEntity=> 'CALC_VALDF_BP',
pt_import_data_file_name => 'XXMX_PAY_CALC_VALDF_BP.dat',
pt_control_file_name => 'XXMX_PAY_CALC_VALDF_BP.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- *************************
-- **New Starter Declaration
-- *************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_NSD',
pt_i_SubEntity=> 'CALC_CARDS_NSD',
pt_import_data_file_name => 'XXMX_PAY_CALC_CARDS_NSD.dat',
pt_control_file_name => 'XXMX_PAY_CALC_CARDS_NSD.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_NSD',
pt_i_SubEntity=> 'CARD_COMP_NSD',
pt_import_data_file_name => 'XXMX_PAY_CARD_COMP_NSD.dat',
pt_control_file_name => 'XXMX_PAY_CARD_COMP_NSD.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_NSD',
pt_i_SubEntity=> 'ASOC_NSD',
pt_import_data_file_name => 'XXMX_PAY_ASOC_NSD.dat',
pt_control_file_name => 'XXMX_PAY_ASOC_NSD.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_NSD',
pt_i_SubEntity=> 'ASOC_DTL_NSD',
pt_import_data_file_name => 'XXMX_PAY_ASOC_DTL_NSD.dat',
pt_control_file_name => 'XXMX_PAY_ASOC_DTL_NSD.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_NSD',
pt_i_SubEntity=> 'COMP_DTL_NSD',
pt_import_data_file_name => 'XXMX_PAY_COMP_DTL_NSD.dat',
pt_control_file_name => 'XXMX_PAY_COMP_DTL_NSD.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_NSD',
pt_i_SubEntity=> 'ENTVAL_NSD',
pt_import_data_file_name => 'XXMX_PAY_ENTVAL_NSD.dat',
pt_control_file_name => 'XXMX_PAY_ENTVAL_NSD.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_NSD',
pt_i_SubEntity=> 'CALC_VALDF_NSD',
pt_import_data_file_name => 'XXMX_PAY_CALC_VALDF_NSD.dat',
pt_control_file_name => 'XXMX_PAY_CALC_VALDF_NSD.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- *************************************
-- **Post Graduate Loan Calculation Card
-- *************************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_PGL',
pt_i_SubEntity=> 'CALC_CARDS_PGL',
pt_import_data_file_name => 'XXMX_PAY_CALC_CARDS_PGL.dat',
pt_control_file_name => 'XXMX_PAY_CALC_CARDS_PGL.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_PGL',
pt_i_SubEntity=> 'CARD_COMP_PGL',
pt_import_data_file_name => 'XXMX_PAY_CARD_COMP_PGL.dat',
pt_control_file_name => 'XXMX_PAY_CARD_COMP_PGL.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_PGL',
pt_i_SubEntity=> 'ASOC_PGL',
pt_import_data_file_name => 'XXMX_PAY_ASOC_PGL.dat',
pt_control_file_name => 'XXMX_PAY_ASOC_PGL.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_PGL',
pt_i_SubEntity=> 'ASOC_DTL_PGL',
pt_import_data_file_name => 'XXMX_PAY_ASOC_DTL_PGL.dat',
pt_control_file_name => 'XXMX_PAY_ASOC_DTL_PGL.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_PGL',
pt_i_SubEntity=> 'COMP_DTL_PGL',
pt_import_data_file_name => 'XXMX_PAY_COMP_DTL_PGL.dat',
pt_control_file_name => 'XXMX_PAY_COMP_DTL_PGL.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_PGL',
pt_i_SubEntity=> 'ENTVAL_PGL',
pt_import_data_file_name => 'XXMX_PAY_ENTVAL_PGL.dat',
pt_control_file_name => 'XXMX_PAY_ENTVAL_PGL.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_PGL',
pt_i_SubEntity=> 'CALC_VALDF_PGL',
pt_import_data_file_name => 'XXMX_PAY_CALC_VALDF_PGL.dat',
pt_control_file_name => 'XXMX_PAY_CALC_VALDF_PGL.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- **************
-- **Pay Balances
-- **************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'PAY_BALANCES',
pt_i_SubEntity=> 'BALANCE_HEADERS',
pt_import_data_file_name => 'XXMX_PAY_BALANCE_HEADERS.dat',
pt_control_file_name => 'XXMX_PAY_BALANCE_HEADERS.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'PAY_BALANCES',
pt_i_SubEntity=> 'BALANCE_LINES',
pt_import_data_file_name => 'XXMX_PAY_BALANCE_LINES.dat',
pt_control_file_name => 'XXMX_PAY_BALANCE_LINES.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- ***************
-- **Element Entry
-- ***************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'ELEMENTS',
pt_i_SubEntity=> 'ELEMENTS',
pt_import_data_file_name => 'XXMX_PAY_ELEMENTS.dat',
pt_control_file_name => 'XXMX_PAY_ELEMENTS.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'ELEMENTS',
pt_i_SubEntity=> 'ELEM_ENTRIES',
pt_import_data_file_name => 'XXMX_PAY_ELEM_ENTRIES.dat',
pt_control_file_name => 'XXMX_PAY_ELEM_ENTRIES.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/