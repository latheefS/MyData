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

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_PAE',
pt_i_SubEntity=> 'CALC_CARDS_PAE',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'CalculationCard',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_PAE',
pt_i_SubEntity=> 'COMP_DTL_PAE',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'ComponentDetail',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_PAE',
pt_i_SubEntity=> 'COMP_ASOC_PAE',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'ComponentAssociation',
pt_fusion_template_sheet_order=>3,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_PAE',
pt_i_SubEntity=> 'COMP_ASOC_DTL_PAE',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'ComponentAssociationDetail',
pt_fusion_template_sheet_order=>4,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_PAE',
pt_i_SubEntity=> 'CALC_COMP_PAE',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'CalculationCard',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- *****************************************************
-- **NI and PAYE Calculation Card (Statutory Deductions)
-- *****************************************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_SD',
pt_i_SubEntity=> 'CALC_CARDS_SD',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'CalculationCard',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_SD',
pt_i_SubEntity=> 'COMP_DTL_SD',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'ComponentDetail',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_SD',
pt_i_SubEntity=> 'COMP_ASSOC_DTL',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'CalculationCard',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_SD',
pt_i_SubEntity=> 'COMP_ASSOC_SD',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'CalculationCard',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_SD',
pt_i_SubEntity=> 'ASSOC_DTL_SD',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'CalculationCard',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_SD',
pt_i_SubEntity=> 'CARD_ASSOC_SD',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'CalculationCard',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/
DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_SD',
pt_i_SubEntity=> 'CALC_COMP_SD',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'CalculationCard',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- *******************************
-- **Student Loan Calculation Card
-- *******************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_SL',
pt_i_SubEntity=> 'CALC_CARDS_SL',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'CalculationCard',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_SL',
pt_i_SubEntity=> 'COMP_SL',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'CardComponent',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_SL',
pt_i_SubEntity=> 'CARD_ASOC_SL',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'CardAssociation',
pt_fusion_template_sheet_order=>3,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_SL',
pt_i_SubEntity=> 'COMP_DTL_SL',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'ComponentDetail',
pt_fusion_template_sheet_order=>4,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_SL',
pt_i_SubEntity=> 'COMP_ASOC_SL',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'ComponentAssociation',
pt_fusion_template_sheet_order=>5,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- **************************************
-- **Benefit and Pension Calculation Card
-- **************************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_BP',
pt_i_SubEntity=> 'CALC_CARDS_BP',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'CalculationCard',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_BP',
pt_i_SubEntity=> 'CARD_COMP_BP',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'CardComponent',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_BP',
pt_i_SubEntity=> 'ASOC_BP',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'CardAssociation',
pt_fusion_template_sheet_order=>3,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_BP',
pt_i_SubEntity=> 'ASOC_DTL_BP',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'CardAssociationDetail',
pt_fusion_template_sheet_order=>4,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_BP',
pt_i_SubEntity=> 'COMP_DTL_BP',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'ComponentDetail',
pt_fusion_template_sheet_order=>5,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_BP',
pt_i_SubEntity=> 'ENTVAL_BP',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'EnterableCalculationValue',
pt_fusion_template_sheet_order=>6,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_BP',
pt_i_SubEntity=> 'CALC_VALDF_BP',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'CalculationValueDefinition',
pt_fusion_template_sheet_order=>7,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- *************************
-- **New Starter Declaration
-- *************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_NSD',
pt_i_SubEntity=> 'CALC_CARDS_NSD',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'CalculationCard',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_NSD',
pt_i_SubEntity=> 'CARD_COMP_NSD',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'CardComponent',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_NSD',
pt_i_SubEntity=> 'ASOC_NSD',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'CardAssociation',
pt_fusion_template_sheet_order=>3,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_NSD',
pt_i_SubEntity=> 'ASOC_DTL_NSD',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'CardAssociationDetail',
pt_fusion_template_sheet_order=>4,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_NSD',
pt_i_SubEntity=> 'COMP_DTL_NSD',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'ComponentDetail',
pt_fusion_template_sheet_order=>5,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_NSD',
pt_i_SubEntity=> 'ENTVAL_NSD',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'EnterableCalculationValue',
pt_fusion_template_sheet_order=>6,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_NSD',
pt_i_SubEntity=> 'CALC_VALDF_NSD',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'CalculationValueDefinition',
pt_fusion_template_sheet_order=>7,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- *************************************
-- **Post Graduate Loan Calculation Card
-- *************************************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_PGL',
pt_i_SubEntity=> 'CALC_CARDS_PGL',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'CalculationCard',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_PGL',
pt_i_SubEntity=> 'CARD_COMP_PGL',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'CardComponent',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_PGL',
pt_i_SubEntity=> 'ASOC_PGL',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'CardAssociation',
pt_fusion_template_sheet_order=>3,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_PGL',
pt_i_SubEntity=> 'ASOC_DTL_PGL',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'CardAssociationDetail',
pt_fusion_template_sheet_order=>4,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_PGL',
pt_i_SubEntity=> 'COMP_DTL_PGL',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'ComponentDetail',
pt_fusion_template_sheet_order=>5,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_PGL',
pt_i_SubEntity=> 'ENTVAL_PGL',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'EnterableCalculationValue',
pt_fusion_template_sheet_order=>6,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'CALC_CARDS_PGL',
pt_i_SubEntity=> 'CALC_VALDF_PGL',
pt_fusion_template_name=> 'CalculationCard.dat',
pt_fusion_template_sheet_name => 'CalculationValueDefinition',
pt_fusion_template_sheet_order=>7,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- **************
-- **Pay Balances
-- **************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'PAY_BALANCES',
pt_i_SubEntity=> 'BALANCE_HEADERS',
pt_fusion_template_name=> 'InitializeBalanceBatchHeader.dat',
pt_fusion_template_sheet_name => 'InitializeBalanceBatchHeader',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'PAY_BALANCES',
pt_i_SubEntity=> 'BALANCE_LINES',
pt_fusion_template_name=> 'InitializeBalanceBatchLine.dat',
pt_fusion_template_sheet_name => 'InitializeBalanceBatchLine',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

-- **************
-- **Pay Elements
-- **************

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'ELEMENTS',
pt_i_SubEntity=> 'ELEMENTS',
pt_fusion_template_name=> 'ElementEntry.dat',
pt_fusion_template_sheet_name => 'ElementEntry',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'PAY',
pt_i_BusinessEntity=> 'ELEMENTS',
pt_i_SubEntity=> 'ELEM_ENTRIES',
pt_fusion_template_name=> 'ElementEntry.dat',
pt_fusion_template_sheet_name => 'ElementEntryValue',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END ;
/