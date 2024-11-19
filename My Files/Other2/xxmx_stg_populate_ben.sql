DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'BEN',
pt_i_BusinessEntity=> 'BENEFITS',
pt_i_SubEntity=> 'PARTICIPANT_ENROLLMENT',
pt_import_data_file_name => 'XXMX_PAR_ENROLLMENT.dat',
pt_control_file_name => 'XXMX_PAR_ENROLLMENT.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'BEN',
pt_i_BusinessEntity=> 'BENEFITS',
pt_i_SubEntity=> 'PAR_ENRL_COMPENSATION_OBJECT',
pt_import_data_file_name => 'XXMX_PAR_ENRL_COMPEN_OBJECT.dat',
pt_control_file_name => 'XXMX_PAR_ENRL_COMPEN_OBJECT.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'BEN',
pt_i_BusinessEntity=> 'BENEFITS',
pt_i_SubEntity=> 'DEPENDENT_ENROLLMENT',
pt_import_data_file_name => 'XXMX_DEP_ENROLLMENT.dat',
pt_control_file_name => 'XXMX_DEP_ENROLLMENT.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'BEN',
pt_i_BusinessEntity=> 'BENEFITS',
pt_i_SubEntity=> 'DESIGNATE_DEPENDENT',
pt_import_data_file_name => 'XXMX_DES_DEPENDENT.dat',
pt_control_file_name => 'XXMX_DES_DEPENDENT.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'BEN',
pt_i_BusinessEntity=> 'BENEFITS',
pt_i_SubEntity=> 'BENEFICIARY_ENROLLMENT',
pt_import_data_file_name => 'XXMX_BEN_ENROLLMENT.dat',
pt_control_file_name => 'XXMX_BEN_ENROLLMENT.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'BEN',
pt_i_BusinessEntity=> 'BENEFITS',
pt_i_SubEntity=> 'DESIGNATE_BENEFICIARY',
pt_import_data_file_name => 'XXMX_DES_BENEFICIARY.dat',
pt_control_file_name => 'XXMX_DES_BENEFICIARY.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'BEN',
pt_i_BusinessEntity=> 'BENEFITS',
pt_i_SubEntity=> 'PER_BEN_GROUP',
pt_import_data_file_name => 'XXMX_PER_BEN_GROUP.dat',
pt_control_file_name => 'XXMX_PER_BEN_GROUP.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'BEN',
pt_i_BusinessEntity=> 'BENEFITS',
pt_i_SubEntity=> 'PER_BEN_BALANCE',
pt_import_data_file_name => 'XXMX_PER_BEN_BALANCE.dat',
pt_control_file_name => 'XXMX_PER_BEN_BALANCE.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'BEN',
pt_i_BusinessEntity=> 'BENEFITS',
pt_i_SubEntity=> 'PERSON_HABITS',
pt_import_data_file_name => 'XXMX_PERSON_HABITS.dat',
pt_control_file_name => 'XXMX_PERSON_HABITS.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'BEN',
pt_i_BusinessEntity=> 'BENEFITS',
pt_i_SubEntity=> 'PER_BEN_ORGANIZATION',
pt_import_data_file_name => 'XXMX_PER_BEN_ORGANIZATION.dat',
pt_control_file_name => 'XXMX_PER_BEN_ORGANIZATION.ctl',
pt_control_file_delimiter => '|',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


