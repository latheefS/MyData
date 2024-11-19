CREATE OR REPLACE PACKAGE xxmx_pay_payroll_ext_pkg 
AS
--*****************************************************************************
--**
--**                 Copyright (c) 2022 Version 1
--**
--**                           Millennium House,
--**                           Millennium Walkway,
--**                           Dublin 1
--**                           D01 F5P8
--**
--**                           All rights reserved.
--**
--*****************************************************************************
--**
--**
--** FILENAME  :  xxmx_pay_payroll_ext_pkg.sql
--**
--** FILEPATH  :  /home/oracle/MXDM/install/CORE
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  XXMX_CORE
--**
--** AUTHORS   :  Ian S. Vickerstaff
--**
--** PURPOSE   :  This script installs the package specification for the PAYROLL Extensions
--**
--** NOTES     :
--**
--******************************************************************************
--**
--** PRE-REQUISITIES
--** ---------------
--**
--** If this script is to be executed as part of an installation script, ensure
--** that the installation script performs the following tasks prior to calling
--** this script.
--**
--** Task  Description
--** ----  ---------------------------------------------------------------------
--** 1.    Run the installation script to create all necessary database objects
--**       and Concurrent definitions:
--**
--**            $XXV1_TOP/install/sql/xxv1_mxdm_utilities_1_dbi.sql
--**
--** If this script is not to be executed as part of an installation script,
--** ensure that the tasks above are, or have been, performed prior to executing
--** this script.
--**
--******************************************************************************
--**
--** CALLING INSTALLATION SCRIPTS
--** ----------------------------
--**
--** The following installation scripts call this script:
--**
--** File Path                                     File Name
--** --------------------------------------------  ------------------------------
--** N/A                                           N/A
--**
--******************************************************************************
--**
--** CALLED INSTALLATION SCRIPTS
--** ---------------------------
--**
--** The following installation scripts are called by this script:
--**
--** File Path                                    File Name
--** -------------------------------------------  ------------------------------
--** N/A                                          N/A
--**
--******************************************************************************
--**
--** PARAMETERS
--** ----------
--**
--** Parameter                       IN OUT  Type
--** -----------------------------  ------  ------------------------------------
--** [parameter_name]                IN OUT
--**
--******************************************************************************
--**
--** [previous_filename] HISTORY
--** -----------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
--**
--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  27-JAN-2022  Pallavi              Created from original Solutions for Delivery Custom Extensions
--******************************************************************************
--
--

     --
     --
     /*
     ********************************
     ** PROCEDURE: transform-Hook procedure for applying transformation rules after copying from STG and applying simple transforms
     ********************************
     */

      PROCEDURE transform_Calc_Cards_SL(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    );

     PROCEDURE transform_Calc_Cards_SD(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    );

    PROCEDURE transform_Calc_Cards_PAE(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    );

     PROCEDURE transform_Calc_Cards_PGL(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    );
     PROCEDURE transform_Calc_Cards_NSD(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    );

     PROCEDURE transform_Calc_Cards_BP(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    );
     PROCEDURE transform_Elements(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    );

     PROCEDURE transform_Balances(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    );
                
END xxmx_pay_payroll_ext_pkg;
/
create or replace PACKAGE BODY xxmx_pay_payroll_ext_pkg 
AS
     --
     --
      gcv_PackageName                 CONSTANT xxmx_module_messages.package_name%TYPE       := 'xxmx_pay_payroll_ext_pkg';
      vt_ApplicationSuite             xxmx_migration_metadata.application_suite%TYPE;
      vt_Application                  xxmx_migration_metadata.application%TYPE;
      gvv_ApplicationErrorMessage     VARCHAR2(2048);


      gvv_ProgressIndicator                     VARCHAR2(100); 
      gvn_RowCount                              NUMBER;
      gvv_ReturnMessage                         xxmx_module_messages .module_message%TYPE;
      gvt_Severity                              xxmx_module_messages .severity%TYPE;
      gvt_OracleError                           xxmx_module_messages .oracle_error%TYPE;
      gvt_ModuleMessage                         xxmx_module_messages .module_message%TYPE;
      vn_TransformCount               NUMBER;
      vn_EnrichmentCount              NUMBER;
      vn_TotalDataRowsCount           NUMBER;
      vn_ProcessedRowsCount           NUMBER;
      vn_SourceReplacedCount          NUMBER;
      vn_TransformFailCount           NUMBER;
      vn_TransformSuccessCount        NUMBER;
      vn_NullDefaultedCount           NUMBER;
      vn_EnrichedCount                NUMBER;
      vb_TransformErrors              BOOLEAN;
      vn_RowSeq                       NUMBER;
      vn_Rowid                        VARCHAR2(200);
      vn_PreviousRowSeq               NUMBER;
      vv_NewStatus                    VARCHAR2(50);
      vv_IDLabel                      VARCHAR2(100);
      vv_IDCondition                  VARCHAR2(100);

      gvt_sql                         VARCHAR2(32000);
      vt_error_code                   VARCHAR2(240);
      e_ModuleError                   EXCEPTION;

      PROCEDURE transform_Calc_Cards_SL(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    )
	AS 
	BEGIN 
		INSERT INTO XXMX_PAY_COMP_SL_STG
        (FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS,
        METADATA,
        OBJECTNAME,
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_DEFINITION_NAME,
        DIR_CARD_COMP_DEF_NAME,
        DIR_CARD_COMP_ID,
        DIR_CARD_ID,
        TAX_REPORTING_UNIT_NAME,
        ASSIGNMENT_NUMBER,
        CARD_SEQUENCE,
        PAYROLLRELATIONSHIPNUMBER,
        PAYROLLSTATUTORYUNITNAME,
        PARENTCOMPONENTSEQUENCE,
        PARENTDIRCARDCOMPDEFNAME,
        PARENTDIRCARDCOMPID,
        COMPONENT_SEQUENCE,
        REPLACEMENTTAXREPORTINGUNIT,
        DIR_REP_CARD_ID,
        SourceId		,					
        Context1	,					
        Context2	,					
        Context3	,					
        Context4	,					
        Context5	,					
        Context6	,					
        Subpriority	,					
        DisplaySequence					
        )
        Select  FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS,
        METADATA,
        'CardComponent',
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_DEFINITION_NAME,
        DIR_CARD_COMP_DEF_NAME,
        DIR_CARD_COMP_ID,
        DIR_CARD_ID,
        TAX_REPORTING_UNIT_NAME,
        ASSIGNMENT_NUMBER,
        CARD_SEQUENCE,
        PAYROLLRELATIONSHIPNUMBER,
        PAYROLLSTATUTORYUNITNAME,
        PARENTCOMPONENTSEQUENCE,
        PARENTDIRCARDCOMPDEFNAME,
        PARENTDIRCARDCOMPID,
        COMPONENT_SEQUENCE,
        REPLACEMENTTAXREPORTINGUNIT,
        DIR_REP_CARD_ID,
        SourceId		,					
        Context1	,					
        Context2	,					
        Context3	,					
        Context4	,					
        Context5	,					
        Context6	,					
        Subpriority	,					
        DisplaySequence
        FROM XXMX_PAY_CALC_CARDS_SL_STG
        where migration_set_id= pt_i_MigrationSetID;


        INSERT INTO XXMX_PAY_CARD_ASOC_SL_STG
        (FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS,
        METADATA,
        OBJECTNAME,
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_DEFINITION_NAME,
        TAX_REPORTING_UNIT_NAME,
        DIR_CARD_ID,
        ASSIGNMENT_NUMBER,
        CARD_SEQUENCE,
        PAYROLLRELATIONSHIPNUMBER,
        REPLACEMENTTAXREPORTINGUNIT,
        DIR_REP_CARD_ID
        )
        Select  FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS,
        METADATA,
        'CardAssociation',
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_DEFINITION_NAME,
        TAX_REPORTING_UNIT_NAME,
        DIR_CARD_ID,
        ASSIGNMENT_NUMBER,
        CARD_SEQUENCE,
        PAYROLLRELATIONSHIPNUMBER,
        REPLACEMENTTAXREPORTINGUNIT,
        DIR_REP_CARD_ID
        FROM XXMX_PAY_CALC_CARDS_SL_STG
        where migration_set_id= pt_i_MigrationSetID;

        INSERT INTO XXMX_PAY_COMP_DTL_SL_STG
        (FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS,
        METADATA,
        OBJECTNAME,
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_DEFINITION_NAME,
        DIR_CARD_COMP_DEF_NAME,
        DIR_INFORMATION_CATEGORY,
        DIR_CARD_COMP_ID,
        PLAN_TYPE,
        START_DATE,
        START_DATE_NOTICE,
        ATTRIBUTE_CATEGORY,
        TEACHER_REPAYMENT,
        CARD_SEQUENCE,
        COMPONENT_SEQUENCE
        )
        Select  FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS,
        METADATA,
        'ComponentDetail',
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_DEFINITION_NAME,
        DIR_CARD_COMP_DEF_NAME,
        DIR_INFORMATION_CATEGORY,
        DIR_CARD_COMP_ID,
        PLAN_TYPE,
        START_DATE,
        START_DATE_NOTICE,
        'FLEX:Deduction Developer DF',
        TEACHER_REPAYMENT,
        CARD_SEQUENCE,
        COMPONENT_SEQUENCE
        FROM XXMX_PAY_CALC_CARDS_SL_STG
        where migration_set_id= pt_i_MigrationSetID;

        INSERT INTO XXMX_PAY_COMP_ASOC_SL_STG
        (FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS,
        METADATA,
        OBJECTNAME,
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_COMP_ID,
        TAX_REPORTING_UNIT_NAME,
        CARD_SEQUENCE,
        PAYROLLRELATIONSHIPNUMBER,
        REPLACEMENTTAXREPORTINGUNIT,
        DIR_REP_CARD_ID
        )
        Select  FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS,
        METADATA,
        'ComponentAssociation',
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_COMP_ID,
        TAX_REPORTING_UNIT_NAME,
        CARD_SEQUENCE,
        PAYROLLRELATIONSHIPNUMBER,
        REPLACEMENTTAXREPORTINGUNIT,
        DIR_REP_CARD_ID
        FROM XXMX_PAY_CALC_CARDS_SL_STG
        where migration_set_id= pt_i_MigrationSetID;


        COMMIT;


	END transform_Calc_Cards_SL;

     PROCEDURE transform_Calc_Cards_SD(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    )
	AS 
	BEGIN 
		INSERT INTO XXMX_PAY_COMP_DTL_SD_STG
        (FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS,
        METADATA,
        OBJECTNAME,
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        DIR_CARD_COMP_DEF_NAME,
        DIR_INFORMATION_CATEGORY,
        TAX_CODE,
        TAX_BASIS,
        PREVIOUS_TAXABLE_PAY,
        PREVIOUS_TAX_PAID,
        AUTHORITY,
        AUTHORITY_DATE,
        PENSIONER,
        P45_ACTION,
        REPORT_NIYTD,
        EMPLOYMENT_FILED_HMRC,
        NUMBER_OF_PERIODS_CVD,
        PREV_HMRC_PAY_ROLL_ID,
        SEND_HMRC_PAYROLL_ID_CHG,
        HMRC_PAYROLL_ID_CHG_FILED,
        EXCLUDE_FROM_AL,
        DATE_LEFT_REPORTED_HMRC,
        CERTIFICATE,
        RENEWAL_DATE,
        NUMBER_OF_HRS_WORKED,
        P45_DATE_ISSUED,
        DATE_LEFT_FILED_PA,
        EMPLOYMENT_FILED_HMRC_PA,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_COMP_ID,
        DIR_CARD_ID,
        ATTRIBUTE_CATEGORY,
        ASSIGNMENT_NUMBER,
        COMPONENT_SEQUENCE,
        CARD_SEQUENCE,
        DIR_CARD_DEFINITION_NAME
        )
        SELECT   FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS,
        METADATA,
        'ComponentDetail',
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        DIR_CARD_COMP_DEF_NAME,
        DIR_INFORMATION_CATEGORY,
        TAX_CODE,
        TAX_BASIS,
        PREVIOUS_TAXABLE_PAY,
        PREVIOUS_TAX_PAID,
        AUTHORITY,
        AUTHORITY_DATE,
        PENSIONER,
        P45_ACTION,
        REPORT_NIYTD,
        EMPLOYMENT_FILED_HMRC,
        NUMBER_OF_PERIODS_CVD,
        PREV_HMRC_PAY_ROLL_ID,
        SEND_HMRC_PAYROLL_ID_CHG,
        HMRC_PAYROLL_ID_CHG_FILED,
        EXCLUDE_FROM_AL,
        DATE_LEFT_REPORTED_HMRC,
        CERTIFICATE,
        RENEWAL_DATE,
        NUMBER_OF_HRS_WORKED,
        P45_DATE_ISSUED,
        DATE_LEFT_FILED_PA,
        EMPLOYMENT_FILED_HMRC_PA,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_COMP_ID,
        DIR_CARD_ID,
        'FLEX:Deduction Developer DF',
        ASSIGNMENT_NUMBER,
        COMPONENT_SEQUENCE,
        CARD_SEQUENCE,
        DIR_CARD_DEFINITION_NAME
        FROM XXMX_PAY_CALC_CARDS_SD_STG
        where migration_set_id= pt_i_MigrationSetID;
        
        
		INSERT INTO XXMX_PAY_CARD_COMP_SD_STG
        (FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS,
        METADATA,
        OBJECTNAME,
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        DIR_CARD_COMP_DEF_NAME,
        DIR_CARD_DEFINITION_NAME,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_ID,
        ASSIGNMENT_NUMBER,
        CARD_SEQUENCE,
        COMPONENT_SEQUENCE,
        CONTEXT1,
        CONTEXT2
        )
        SELECT   FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS,
        METADATA,
        'CardComponent',
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        DIR_CARD_COMP_DEF_NAME,
        DIR_CARD_DEFINITION_NAME,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_ID,
        ASSIGNMENT_NUMBER,
        CARD_SEQUENCE,
        COMPONENT_SEQUENCE,
        CONTEXT1,
        CONTEXT2
        FROM XXMX_PAY_CALC_CARDS_SD_STG
        where migration_set_id= pt_i_MigrationSetID;


        INSERT INTO XXMX_PAY_CARD_ASSOC_SD_STG
        (FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS,
        METADATA,
        OBJECTNAME,
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        DIR_CARD_COMP_DEF_NAME,
        DIR_CARD_DEFINITION_NAME,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_ID,
        ASSIGNMENT_NUMBER,
        CARD_SEQUENCE,
        DIR_REP_CARD_ID,
        PAYROLL_RELATIONSHIP_NUM,
        REPLACEMENTTAXREPORTINGUNIT,
        TAX_REPORTING_UNIT_NAME
        )
        SELECT   FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS,
        METADATA,
        'CardAssociation',
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        DIR_CARD_COMP_DEF_NAME,
        DIR_CARD_DEFINITION_NAME,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_ID,
        ASSIGNMENT_NUMBER,
        CARD_SEQUENCE,
        DIR_REP_CARD_ID,
        PAYROLL_RELATIONSHIP_NUM,
        REPLACEMENTTAXREPORTINGUNIT,
        TAX_REPORTING_UNIT_NAME
        FROM XXMX_PAY_CALC_CARDS_SD_STG
        where migration_set_id= pt_i_MigrationSetID;
        
        INSERT INTO XXMX_PAY_CARD_ASSOC_DTL_SD_STG
            (FILE_SET_ID,
            MIGRATION_SET_ID,
            MIGRATION_SET_NAME,
            MIGRATION_STATUS,
            METADATA,
            OBJECTNAME,
            EFFECTIVE_START_DATE,
            EFFECTIVE_END_DATE,
            SOURCE_SYSTEM_ID,
            SOURCE_SYSTEM_OWNER,
            DIR_CARD_COMP_DEF_NAME,
            DIR_CARD_DEFINITION_NAME,
            ASSIGNMENT_NUMBER,
            LEGISLATIVE_DATA_GROUP_NAME,
            CARD_SEQUENCE
            )
        SELECT
            FILE_SET_ID,
            MIGRATION_SET_ID,
            MIGRATION_SET_NAME,
            MIGRATION_STATUS,
            METADATA,
            'CardAssociationDetail',
            EFFECTIVE_START_DATE,
            EFFECTIVE_END_DATE,
            SOURCE_SYSTEM_ID,
            SOURCE_SYSTEM_OWNER,
            DIR_CARD_COMP_DEF_NAME,
            DIR_CARD_DEFINITION_NAME,
            ASSIGNMENT_NUMBER,
            LEGISLATIVE_DATA_GROUP_NAME,
            CARD_SEQUENCE
        FROM XXMX_PAY_CALC_CARDS_SD_STG
        where migration_set_id= pt_i_MigrationSetID;
        
        INSERT INTO XXMX_PAY_COMP_ASSOC_DTL_SD_STG
            (FILE_SET_ID,
            MIGRATION_SET_ID,
            MIGRATION_SET_NAME,
            MIGRATION_STATUS,
            METADATA,
            OBJECTNAME,
            EFFECTIVE_START_DATE,
            EFFECTIVE_END_DATE,
            SOURCE_SYSTEM_ID,
            SOURCE_SYSTEM_OWNER,
            DIR_CARD_COMP_DEF_NAME,
            DIR_CARD_DEFINITION_NAME,
            ASSIGNMENT_NUMBER,
            TAX_REPORTING_UNIT_NAME,
            COMPONENT_SEQUENCE,
            DIR_REP_CARD_ID,
            DIR_REP_CARD_USAGE_ID,
            CARD_SEQUENCE,
            LEGISLATIVE_DATA_GROUP_NAME
            )
        SELECT
            FILE_SET_ID,
            MIGRATION_SET_ID,
            MIGRATION_SET_NAME,
            MIGRATION_STATUS,
            METADATA,
            'ComponentAssociationDetail',
            EFFECTIVE_START_DATE,
            EFFECTIVE_END_DATE,
            SOURCE_SYSTEM_ID,
            SOURCE_SYSTEM_OWNER,
            DIR_CARD_COMP_DEF_NAME,
            DIR_CARD_DEFINITION_NAME,
            ASSIGNMENT_NUMBER,
            TAX_REPORTING_UNIT_NAME,
            COMPONENT_SEQUENCE,
            DIR_REP_CARD_ID,
            DIR_REP_CARD_USAGE_ID,
            CARD_SEQUENCE,
            LEGISLATIVE_DATA_GROUP_NAME
        FROM XXMX_PAY_CALC_CARDS_SD_STG
        where migration_set_id= pt_i_MigrationSetID;
        
        
        INSERT INTO XXMX_PAY_COMP_ASSOC_SD_STG
            (FILE_SET_ID,
            MIGRATION_SET_ID,
            MIGRATION_SET_NAME,
            MIGRATION_STATUS,
            METADATA,
            OBJECTNAME,
            EFFECTIVE_START_DATE,
            EFFECTIVE_END_DATE,
            SOURCE_SYSTEM_ID,
            SOURCE_SYSTEM_OWNER,
            DIR_CARD_COMP_DEF_NAME,
            DIR_CARD_DEFINITION_NAME,
            ASSIGNMENT_NUMBER,
            TAX_REPORTING_UNIT_NAME,
            LEGISLATIVE_DATA_GROUP_NAME,
            DIR_CARD_COMP_ID,
            DIR_REP_CARD_ID,
            PAYROLL_RELATIONSHIP_NUM,
            REPLACEMENTTAXREPORTINGUNIT,
            DIR_CARD_ID,
            COMPONENT_SEQUENCE,
            CARD_SEQUENCE
            )
        SELECT
            FILE_SET_ID,
            MIGRATION_SET_ID,
            MIGRATION_SET_NAME,
            MIGRATION_STATUS,
            METADATA,
            'ComponentAssociation',
            EFFECTIVE_START_DATE,
            EFFECTIVE_END_DATE,
            SOURCE_SYSTEM_ID,
            SOURCE_SYSTEM_OWNER,
            DIR_CARD_COMP_DEF_NAME,
            DIR_CARD_DEFINITION_NAME,
            ASSIGNMENT_NUMBER,
            TAX_REPORTING_UNIT_NAME,
            LEGISLATIVE_DATA_GROUP_NAME,
            DIR_CARD_COMP_ID,
            DIR_REP_CARD_ID,
            PAYROLL_RELATIONSHIP_NUM,
            REPLACEMENTTAXREPORTINGUNIT,
            DIR_CARD_ID,
            COMPONENT_SEQUENCE,
            CARD_SEQUENCE
        FROM XXMX_PAY_CALC_CARDS_SD_STG
        where migration_set_id= pt_i_MigrationSetID;

        
        COMMIT;   

	END;

    PROCEDURE transform_Calc_Cards_PAE(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    )
	AS 
	BEGIN 
		INSERT INTO XXMX_PAY_COMP_DTL_PAE_STG
        (FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS,
        METADATA,
        OBJECTNAME ,
        DIR_CARD_COMP_ID,
        EFFECTIVE_START_DATE,                  
        EFFECTIVE_END_DATE,                    
        DIR_CARD_COMP_DEF_NAME,
        LEGISLATIVE_DATA_GROUP_NAME,
        ASSIGNMENT_NUMBER ,          
        DIR_INFORMATION_CATEGORY,         
        EMPLOYEE_CLASSIFICATION,             
        JOB_HOLDER_DATE,              
        ENROLL_ASSESMENT,                   
        CLASSIFICATION_CHGPRC_DT,
        ACT_POSTPONEMENT_TYPE,             
        ACT_POSTPONEMENT_RULE,                
        ACT_POSTPONEMENT_END_DATE ,
        ACT_QUALIFYING_SCHEME ,           
        QUALIFYING_SCHEME_JOIN_DT ,
        QUALIFYING_SCHEME_START_DT,           
        QUALIFYING_SCHEME_JOIN_METHOD,
        TRANSFER_QUALIFYING_SCHEME,        
        QUALIFYING_SCHEME_LEAVE_REASON ,
        QUALIFYING_SCHEME_LEAVE_DATE ,      
        OPT_OUT_PERIOD_END_DATE ,        
        OPT_OUT_REFUND_DUE ,             
        HISTORIC_PEN_PAY_ROLL_ID ,
        REASON_FOR_EXCLUSION ,            
        COMPONENT_SEQUENCE,                
        TAX_REPORTING_UNIT_NAME ,
        DIR_CARD_DEFINITION_NAME , 
        OVERRIDING_WORKER_POSTPONEMENT,
        OVERRIDING_ELIGIBLE_JH_POSTPMNT,     
        OVERRIDING_QUALIFYING_SCHEME ,      
        OVERRIDING_STAGING_DATE ,        
        LETTER_STATUS ,             
        LETTER_TYPE_DATE,
        SUBSEQUENT_COMMS_REQ ,
        LETTER_TYPE_GENERATED,                
        WULS_TAKEN_DATE ,                
        TAX_PROTECTION_APPLIED  ,
        PROC_AUTO_REENROLMENT_DATE ,
        QUALIFYING_SCHEME_ID , 
        CARD_SEQUENCE,
        ATTRIBUTE_CATEGORY
        )
        SELECT FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS,
        METADATA,
        'ComponentDetail' ,
        DIR_CARD_COMP_ID,
        EFFECTIVE_START_DATE,                  
        EFFECTIVE_END_DATE,                    
        DIR_CARD_COMP_DEF_NAME,
        LEGISLATIVE_DATA_GROUP_NAME,
        ASSIGNMENT_NUMBER ,          
        DIR_INFORMATION_CATEGORY,         
        EMPLOYEE_CLASSIFICATION,             
        JOB_HOLDER_DATE,              
        ENROLL_ASSESMENT,                   
        CLASSIFICATION_CHGPRC_DT,
        ACT_POSTPONEMENT_TYPE,             
        ACT_POSTPONEMENT_RULE,                
        ACT_POSTPONEMENT_END_DATE ,
        ACT_QUALIFYING_SCHEME ,           
        QUALIFYING_SCHEME_JOIN_DT ,
        QUALIFYING_SCHEME_START_DT,           
        QUALIFYING_SCHEME_JOIN_METHOD,
        TRANSFER_QUALIFYING_SCHEME,        
        QUALIFYING_SCHEME_LEAVE_REASON ,
        QUALIFYING_SCHEME_LEAVE_DATE ,      
        OPT_OUT_PERIOD_END_DATE ,        
        OPT_OUT_REFUND_DUE ,             
        HISTORIC_PEN_PAY_ROLL_ID ,
        REASON_FOR_EXCLUSION ,            
        COMPONENT_SEQUENCE,                
        TAX_REPORTING_UNIT_NAME ,
        DIR_CARD_DEFINITION_NAME ,             
        OVERRIDING_WORKER_POSTPONEMENT,
        OVERRIDING_ELIGIBLE_JH_POSTPMNT,     
        OVERRIDING_QUALIFYING_SCHEME ,      
        OVERRIDING_STAGING_DATE ,        
        LETTER_STATUS ,             
        LETTER_TYPE_DATE,
        SUBSEQUENT_COMMS_REQ ,
        LETTER_TYPE_GENERATED,                
        WULS_TAKEN_DATE ,                
        TAX_PROTECTION_APPLIED  ,
        PROC_AUTO_REENROLMENT_DATE ,
        QUALIFYING_SCHEME_ID ,  
        CARD_SEQUENCE,
        'FLEX:Deduction Developer DF'
        FROM XXMX_PAY_CALC_CARDS_PAE_STG
        where migration_set_id= pt_i_MigrationSetID;


		INSERT INTO XXMX_PAY_COMP_ASOC_PAE_STG
        (FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS,
        METADATA ,                             
        OBJECTNAME,                            
        EFFECTIVE_START_DATE  ,
        EFFECTIVE_END_DATE   ,
        DIR_CARD_COMP_DEF_NAME ,               
        LEGISLATIVE_DATA_GROUP_NAME ,
        ASSIGNMENT_NUMBER , 
        CARD_SEQUENCE,
        COMPONENT_SEQUENCE ,                   
        TAX_REPORTING_UNIT_NAME ,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        DIR_REP_CARD_ID ,
        DIR_CARD_DEFINITION_NAME ,   
        PAYROLL_RELATIONSHIP_NUM,
        REPLACEMENTTAXREPORTINGUNIT
        )
        SELECT FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS,
        METADATA,
        'ComponentAssociation' ,
        EFFECTIVE_START_DATE  ,
        EFFECTIVE_END_DATE   ,
        DIR_CARD_COMP_DEF_NAME ,               
        LEGISLATIVE_DATA_GROUP_NAME ,
        ASSIGNMENT_NUMBER , 
        CARD_SEQUENCE,
        COMPONENT_SEQUENCE ,                   
        TAX_REPORTING_UNIT_NAME ,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        DIR_REP_CARD_ID ,
        DIR_CARD_DEFINITION_NAME ,   
        PAYROLL_RELATIONSHIP_NUM,
        REPLACEMENTTAXREPORTINGUNIT
        FROM XXMX_PAY_CALC_CARDS_PAE_STG
        where migration_set_id= pt_i_MigrationSetID;



		INSERT INTO XXMX_PAY_COMP_ASOC_DTL_PAE_STG
        (FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS,
        METADATA ,                             
        OBJECTNAME,                            
        DIR_CARD_COMP_ID ,                     
        EFFECTIVE_START_DATE  ,
        EFFECTIVE_END_DATE ,               
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        DIR_CARD_COMP_DEF_NAME   ,             
        LEGISLATIVE_DATA_GROUP_NAME           ,
        CARD_SEQUENCE,
        ASSIGNMENT_NUMBER                     ,
        COMPONENT_SEQUENCE                    ,
        TAX_REPORTING_UNIT_NAME               ,
        DIR_REP_CARD_ID                       ,
        DIR_REP_CARD_USAGE_ID,
        DIR_CARD_DEFINITION_NAME              
        )
        SELECT FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS,
        METADATA,
        'ComponentAssociationDetail' ,
        DIR_CARD_COMP_ID ,                     
        EFFECTIVE_START_DATE  ,
        EFFECTIVE_END_DATE ,               
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        DIR_CARD_COMP_DEF_NAME         ,       
        LEGISLATIVE_DATA_GROUP_NAME           ,
        CARD_SEQUENCE,
        ASSIGNMENT_NUMBER                     ,
        COMPONENT_SEQUENCE                    ,
        TAX_REPORTING_UNIT_NAME               ,
        DIR_REP_CARD_ID                       ,
        DIR_REP_CARD_USAGE_ID,
        DIR_CARD_DEFINITION_NAME                                    
        FROM XXMX_PAY_CALC_CARDS_PAE_STG
        where migration_set_id= pt_i_MigrationSetID;
        
        INSERT INTO XXMX_PAY_CARD_COMP_PAE_STG
        (FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS,
        METADATA ,                             
        OBJECTNAME,                            
        EFFECTIVE_START_DATE  ,
        EFFECTIVE_END_DATE ,               
        DIR_CARD_COMP_DEF_NAME,                
        LEGISLATIVE_DATA_GROUP_NAME           ,
        ASSIGNMENT_NUMBER ,
        CARD_SEQUENCE,
        COMPONENT_SEQUENCE ,                   
        DIR_CARD_ID  ,                  
        DIR_CARD_DEFINITION_NAME 
        )
        SELECT FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS,
        METADATA,
        'CardComponent' ,
        EFFECTIVE_START_DATE  ,
        EFFECTIVE_END_DATE ,               
        DIR_CARD_COMP_DEF_NAME,                
        LEGISLATIVE_DATA_GROUP_NAME           ,
        ASSIGNMENT_NUMBER ,
        CARD_SEQUENCE,
        COMPONENT_SEQUENCE ,                   
        DIR_CARD_ID  ,                  
        DIR_CARD_DEFINITION_NAME 
        FROM XXMX_PAY_CALC_CARDS_PAE_STG
        where migration_set_id= pt_i_MigrationSetID;
	END;

     PROCEDURE transform_Calc_Cards_PGL(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    )
	AS 
	BEGIN 
		INSERT INTO XXMX_PAY_CARD_COMP_PGL_STG
        (
        FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS   ,     
        METADATA,
        OBJECTNAME,
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_DEFINITION_NAME,
        DIR_CARD_COMP_DEF_NAME,
        DIR_CARD_COMP_ID,
        TAX_REPORTING_UNIT_NAME,
        DIR_CARD_ID,
        ASSIGNMENT_NUMBER,
        CARD_SEQUENCE,
        COMPONENT_SEQUENCE,
        CONTEXT1,
        CONTEXT2,
        CONTEXT3,
        CONTEXT4,
        CONTEXT5,
        CONTEXT6,
        DISPLAYSEQUENCE,
        SOURCEID,
        SUBPRIORITY,
        PARENTCOMPONENTSEQUENCE,
        PARENTDIRCARDCOMPDEFNAME,
        PARENTDIRCARDCOMPID,
        PAYROLLRELATIONSHIPNUMBER ,
        PAYROLLSTATUTORYUNITNAME
        )
        SELECT FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS,
        METADATA,
        'CardComponent' ,
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_DEFINITION_NAME,
        DIR_CARD_COMP_DEF_NAME,
        DIR_CARD_COMP_ID,
        TAX_REPORTING_UNIT_NAME,
        DIR_CARD_ID,
        ASSIGNMENT_NUMBER,
        CARD_SEQUENCE,
        COMPONENT_SEQUENCE,
        CONTEXT1,
        CONTEXT2,
        CONTEXT3,
        CONTEXT4,
        CONTEXT5,
        CONTEXT6,
        DISPLAYSEQUENCE,
        SOURCEID,
        SUBPRIORITY,
        PARENTCOMPONENTSEQUENCE,
        PARENTDIRCARDCOMPDEFNAME,
        PARENTDIRCARDCOMPID,
        PAYROLLRELATIONSHIPNUMBER ,
        PAYROLLSTATUTORYUNITNAME
        FROM XXMX_PAY_CALC_CARDS_PGL_STG
        where migration_set_id= pt_i_MigrationSetID;


		INSERT INTO XXMX_PAY_ASOC_PGL_STG
        (
        FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS   , 
        METADATA,
        OBJECTNAME,
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_DEFINITION_NAME,
        DIR_CARD_COMP_DEF_NAME,
        DIR_CARD_COMP_ID,
        TAX_REPORTING_UNIT_NAME,
        ASSIGNMENT_NUMBER,
        CARD_SEQUENCE,
        COMPONENT_SEQUENCE,
        DIR_REP_CARD_ID,
        PAYROLLRELATIONSHIPNUMBER,
        REPLACEMENTTAXREPORTINGUNIT 
        )
        SELECT FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS,
        METADATA,
        'CardAssociation' ,
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_DEFINITION_NAME,
        DIR_CARD_COMP_DEF_NAME,
        DIR_CARD_COMP_ID,
        TAX_REPORTING_UNIT_NAME,
        ASSIGNMENT_NUMBER,
        CARD_SEQUENCE,
        COMPONENT_SEQUENCE,
        DIR_REP_CARD_ID,
        PAYROLLRELATIONSHIPNUMBER,
        REPLACEMENTTAXREPORTINGUNIT
        FROM XXMX_PAY_CALC_CARDS_PGL_STG
        where migration_set_id= pt_i_MigrationSetID;


		INSERT INTO XXMX_PAY_ASOC_DTL_PGL_STG
        (
        FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS   ,     
        METADATA,
        OBJECTNAME,
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_COMP_ID,
        TAX_REPORTING_UNIT_NAME
        )
        SELECT FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS,
        METADATA,
        'ComponentAssociation' ,
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_COMP_ID,
        TAX_REPORTING_UNIT_NAME
        FROM XXMX_PAY_CALC_CARDS_PGL_STG
        where migration_set_id= pt_i_MigrationSetID;


		INSERT INTO XXMX_PAY_COMP_DTL_PGL_STG
        (
        FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS   ,     
        METADATA,
        OBJECTNAME,
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_DEFINITION_NAME,
        DIR_CARD_COMP_DEF_NAME,
        DIR_INFORMATION_CATEGORY,
        DIR_CARD_COMP_ID,
        PLAN_TYPE,
        START_DATE,
        START_DATE_NOTICE,
        ATTRIBUTE_CATEGORY,
        ASSIGNMENT_NUMBER,
        CARD_SEQUENCE,
        COMPONENT_SEQUENCE
        )
        SELECT FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS,
        METADATA,
        'ComponentDetail' ,
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_DEFINITION_NAME,
        DIR_CARD_COMP_DEF_NAME,
        DIR_INFORMATION_CATEGORY,
        DIR_CARD_COMP_ID,
        PLAN_TYPE,
        START_DATE,
        START_DATE_NOTICE,
        'FLEX:Deduction Developer DF',
        ASSIGNMENT_NUMBER,
        CARD_SEQUENCE,
        COMPONENT_SEQUENCE
        FROM XXMX_PAY_CALC_CARDS_PGL_STG
        where migration_set_id= pt_i_MigrationSetID;


        Commit;


	END;

     PROCEDURE transform_Calc_Cards_NSD(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    )
	AS 
	BEGIN 
		NULL;
	END;

     PROCEDURE transform_Calc_Cards_BP(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    )
	AS 
	BEGIN 
		INSERT INTO XXMX_PAY_CARD_COMP_BP_STG
    (   FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS   ,     
        METADATA,
        OBJECTNAME,
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_DEFINITION_NAME,
        DIR_CARD_COMP_DEF_NAME,
        ASSIGNMENT_NUMBER,
        COMPONENT_SEQUENCE,
        DIR_CARD_ID
        )
        SELECT  FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS   ,     
        METADATA,
        'CardComponent',
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_DEFINITION_NAME,
        DIR_CARD_COMP_DEF_NAME,
        ASSIGNMENT_NUMBER,
        COMPONENT_SEQUENCE,
        DIR_CARD_ID
        FROM XXMX_PAY_CALC_CARDS_BP_STG
        where migration_set_id= pt_i_MigrationSetID;



		INSERT INTO XXMX_PAY_ASOC_BP_STG
    (   FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS   ,     
        METADATA,
        OBJECTNAME,
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_DEFINITION_NAME,
        ASSIGNMENT_NUMBER,
        DIR_CARD_ID,
        TAX_REPORTING_UNIT_NAME
        )
        SELECT  FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS   ,     
        METADATA,
        'CardAssociation',
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_DEFINITION_NAME,
        ASSIGNMENT_NUMBER,
        DIR_CARD_ID,
        TAX_REPORTING_UNIT_NAME
        FROM XXMX_PAY_CALC_CARDS_BP_STG
        where migration_set_id= pt_i_MigrationSetID;


		INSERT INTO XXMX_PAY_ASOC_DTL_BP_STG
    (   FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS   ,     
        METADATA,
        OBJECTNAME,
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        ASSIGNMENT_NUMBER,
        DIR_CARD_COMP_ID,
        DIR_REP_CARD_ID
        )
        SELECT  FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS   ,     
        METADATA,
        'CardAssociationDetail',
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        ASSIGNMENT_NUMBER,
        DIR_CARD_COMP_ID,
        DIR_REP_CARD_ID
        FROM XXMX_PAY_CALC_CARDS_BP_STG
        where migration_set_id= pt_i_MigrationSetID;



		INSERT INTO XXMX_PAY_COMP_DTL_BP_STG
    (   FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS   ,     
        METADATA,
        OBJECTNAME,
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_DEFINITION_NAME,
        DIR_CARD_COMP_DEF_NAME,
        ASSIGNMENT_NUMBER,
        COMPONENT_SEQUENCE,
        DIR_CARD_COMP_ID,
        CARD_SEQUENCE,
        DIR_INFORMATION_CATEGORY,
        ATTRIBUTE_CATEGORY
        )
        SELECT  FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS   ,     
        METADATA,
        'ComponentDetail',
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_DEFINITION_NAME,
        DIR_CARD_COMP_DEF_NAME,
        ASSIGNMENT_NUMBER,
        COMPONENT_SEQUENCE,
        DIR_CARD_COMP_ID,
        CARD_SEQUENCE,
        DIR_INFORMATION_CATEGORY,
        'FLEX:Deduction Developer DF'
        FROM XXMX_PAY_CALC_CARDS_BP_STG
        where migration_set_id= pt_i_MigrationSetID;


        INSERT INTO XXMX_PAY_ENTVAL_BP_STG
    (   FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS   ,     
        METADATA,
        OBJECTNAME,
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_DEFINITION_NAME,
        DIR_CARD_COMP_DEF_NAME,
        ASSIGNMENT_NUMBER,
        VALUE_DEFINITION_NAME,
        COMPONENT_SEQUENCE,
        VALUE1,
        VALUE_DEFN_ID
        )
        SELECT  FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS   ,     
        METADATA,
        'EnterableCalculationValue',
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_DEFINITION_NAME,
        DIR_CARD_COMP_DEF_NAME,
        ASSIGNMENT_NUMBER,
        VALUE_DEFINITION_NAME,
        COMPONENT_SEQUENCE,
        VALUE1,
        VALUE_DEFN_ID
        FROM XXMX_PAY_CALC_CARDS_BP_STG
        where migration_set_id= pt_i_MigrationSetID;


        INSERT INTO XXMX_PAY_CALC_VALDF_BP_STG
    (   FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS   ,     
        METADATA,
        OBJECTNAME,
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_DEFINITION_NAME,
        DIR_CARD_COMP_DEF_NAME,
        ASSIGNMENT_NUMBER,
        VALUE_DEFINITION_NAME,
        SOURCE_ID,
        COMPONENT_SEQUENCE
        )
        SELECT  FILE_SET_ID,
        MIGRATION_SET_ID,
        MIGRATION_SET_NAME,
        MIGRATION_STATUS   ,     
        METADATA,
        'CalculationValueDefinition',
        EFFECTIVE_START_DATE,
        EFFECTIVE_END_DATE,
        SOURCE_SYSTEM_ID,
        SOURCE_SYSTEM_OWNER,
        LEGISLATIVE_DATA_GROUP_NAME,
        DIR_CARD_DEFINITION_NAME,
        DIR_CARD_COMP_DEF_NAME,
        ASSIGNMENT_NUMBER,
        VALUE_DEFINITION_NAME,
        SOURCE_ID,
        COMPONENT_SEQUENCE
        FROM XXMX_PAY_CALC_CARDS_BP_STG
        where migration_set_id= pt_i_MigrationSetID;


        COMMIT;
	END;

    PROCEDURE transform_Elements(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    )
	AS 
	BEGIN 
		NULL;
	END;


    PROCEDURE transform_balances(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    )
	AS 
	BEGIN 
		NULL;
	END;
END xxmx_pay_payroll_ext_pkg;


/
SHOW ERRORS PACKAGE BODY xxmx_pay_payroll_ext_pkg;
/