DECLARE

pv_o_ReturnStatus VARCHAR2(3000);
BEGIN

xxmx_dynamic_sql_pkg.stg_populate(
pt_i_ApplicationSuite=>'HCM',
pt_i_Application=> 'BEN',
pt_i_BusinessEntity=> 'BENEFITS',
pt_i_SubEntity=> 'PARTICIPANT_ENROLLMENT',
pt_import_data_file_name => 'XXMX_BEN_PE.dat',
pt_control_file_name => 'XXMX_BEN_PE.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_BEN_PE_CO.dat',
pt_control_file_name => 'XXMX_BEN_PE_CO.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_BEN_DE.dat',
pt_control_file_name => 'XXMX_BEN_DE.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_BEN_DE_DD.dat',
pt_control_file_name => 'XXMX_BEN_DE_DD.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_BEN_BE.dat',
pt_control_file_name => 'XXMX_BEN_BE.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_BEN_BE_DB.dat',
pt_control_file_name => 'XXMX_BEN_BE_DB.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_BEN_PBG.dat',
pt_control_file_name => 'XXMX_BEN_PBG.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_BEN_PBB.dat',
pt_control_file_name => 'XXMX_BEN_PBB.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_BEN_PH.dat',
pt_control_file_name => 'XXMX_BEN_PH.ctl',
pt_control_file_delimiter => ',',
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
pt_import_data_file_name => 'XXMX_BEN_PBO.dat',
pt_control_file_name => 'XXMX_BEN_PBO.ctl',
pt_control_file_delimiter => ',',
pv_o_ReturnStatus=> pv_o_ReturnStatus);

END;
/


