DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'BEN',
pt_i_BusinessEntity=> 'BENEFITS',
pt_i_SubEntity=> 'PARTICIPANT_ENROLLMENT',
pt_fusion_template_name=> 'BeneficiaryEnrollment.dat', 
pt_fusion_template_sheet_name => 'ParticipantEnrollment',
pt_fusion_template_sheet_order=>1,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'BEN',
pt_i_BusinessEntity=> 'BENEFITS',
pt_i_SubEntity=> 'PAR_ENRL_COMPENSATION_OBJECT',
pt_fusion_template_name=> 'BeneficiaryEnrollment.dat', 
pt_fusion_template_sheet_name => 'ParEnrlCompensationObject',
pt_fusion_template_sheet_order=>2,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'BEN',
pt_i_BusinessEntity=> 'BENEFITS',
pt_i_SubEntity=> 'DEPENDENT_ENROLLMENT',
pt_fusion_template_name=> 'BeneficiaryEnrollment.dat', 
pt_fusion_template_sheet_name => 'DependentEnrollment',
pt_fusion_template_sheet_order=>3,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'BEN',
pt_i_BusinessEntity=> 'BENEFITS',
pt_i_SubEntity=> 'DESIGNATE_DEPENDENT',
pt_fusion_template_name=> 'BeneficiaryEnrollment.dat', 
pt_fusion_template_sheet_name => 'DesignateDependent',
pt_fusion_template_sheet_order=>4,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/



DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'BEN',
pt_i_BusinessEntity=> 'BENEFITS',
pt_i_SubEntity=> 'BENEFICIARY_ENROLLMENT',
pt_fusion_template_name=> 'BeneficiaryEnrollment.dat', 
pt_fusion_template_sheet_name => 'BeneficiaryEnrollment',
pt_fusion_template_sheet_order=>5,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'BEN',
pt_i_BusinessEntity=> 'BENEFITS',
pt_i_SubEntity=> 'DESIGNATE_BENEFICIARY',
pt_fusion_template_name=> 'BeneficiaryEnrollment.dat', 
pt_fusion_template_sheet_name => 'DesignateBeneficiary',
pt_fusion_template_sheet_order=>6,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'BEN',
pt_i_BusinessEntity=> 'BENEFITS',
pt_i_SubEntity=> 'PER_BEN_GROUP',
pt_fusion_template_name=> 'BeneficiaryEnrollment.dat', 
pt_fusion_template_sheet_name => 'PerBenGroup', 
pt_fusion_template_sheet_order=>7,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'BEN',
pt_i_BusinessEntity=> 'BENEFITS',
pt_i_SubEntity=> 'PER_BEN_BALANCE',
pt_fusion_template_name=> 'BeneficiaryEnrollment.dat', 
pt_fusion_template_sheet_name => 'PerBenBalance',
pt_fusion_template_sheet_order=>8,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'BEN',
pt_i_BusinessEntity=> 'BENEFITS',
pt_i_SubEntity=> 'PERSON_HABITS',
pt_fusion_template_name=> 'BeneficiaryEnrollment.dat', 
pt_fusion_template_sheet_name => 'PersonHabits',
pt_fusion_template_sheet_order=>9,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/

DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.xfm_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'BEN',
pt_i_BusinessEntity=> 'BENEFITS',
pt_i_SubEntity=> 'PER_BEN_ORGANIZATION',
pt_fusion_template_name=> 'BeneficiaryEnrollment.dat', 
pt_fusion_template_sheet_name => 'PerBenOrganization',
pt_fusion_template_sheet_order=>10,
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/