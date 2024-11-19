--------------------------------------------------------
--  DDL for Package Body XXMX_HCM_PERSON_EXT_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_HCM_PERSON_EXT_PKG" 
AS
--//=====================================================================================================
--// Version1
--// $Id:$
--//=====================================================================================================
--// Object Name        :: xxmx_hcm_person_ext_pkg.pkb
--//
--// Object Type        :: Package Body
--//
--// Object Description :: This package contains Procedures for applying transformation rules after
--//                       copying from STG and applying simple transforms
--//
--// Version Control
--//=====================================================================================================
--// Version      Author               Date               Description
--//-----------------------------------------------------------------------------------------------------
--// 1.0          Pallavi Kanajar      27/01/2022         Initial Build
--// 1.1          Bharath              25/04/2022         Adding new procedure update Legislation Code
--// 1.2          Bharath              26/04/2022         Adding new procedure update BG ID and name
--// 1.3          Vamsi                26/04/2022         Adding new procedure for updating Position Code
--// 1.4          Vamsi                13/05/2022         Added new procedure Update_Absence_Types
--// 1.5          Vamsi                17/05/2022         Added new procedure transform_BU_LE_NAME
--// 1.6          Vamsi                19/05/2022         Updating Position_Code for BU's US2230,DK5350
--// 1.7          Vamsi                19/05/2022         Updating Phone Type and Assignment Status
--// 1.8          Vamsi                20/05/2022         Updating Performance Rating Code.
--// 1.9          Vamsi                24/05/2022         Added All for Update_Absence_Types
--// 2.0          Vamsi                31/05/2022         Added transform_TALENT_CONFIG_PROC Procedure.
--// 2.1          Vamsi                10/06/2022         Added transform_salary_basis_proc Procedure.
--// 2.2          Vamsi                10/06/2022         Added transform_emp_category_proc Procedure.
--// 2.3          Vamsi                06/07/2022         Added add_phone_area_code_proc Procedure.
--// 2.4          Dhanu                13/10/2022         Added location_code update, salary_basis update
--// 2.5          Vamsi                14/10/2022         Modified Queries in transform_LEGISLATIONCODE and transform_BG_ID_NAME Procedures.
--// 2.6          Vamsi                23/10/2022         Updated PHONE_TYPE from WM to HM for M Type, As confirmed by CITCO.
--// 2.7          Vamsi                27/07/2023         Updated ASSIGNMENT_STATUS_TYPE - Added SUSPENDED status also.
--// 2.8          Vamsi                09/11/2023         Added update_term_reason_codes_prc procedure.
--// 2.9          Vamsi                21/11/2023         Updating Sick Leave Category in ATTRIBUTE15 column in Absence_XFM table.
--// 2.10         Vamsi                21/11/2023         Updating DEFAULT_EXPENSE_ACCOUNT column in XXMX_PER_ASSIGNMENTS_M_XFM table.
--// 2.11         Vamsi                21/11/2023         Removed LEGISLATION_CODE transformation for CITIZENSHIPS.
--//=====================================================================================================

     --
     --
     /*
     ********************************
     ** PROCEDURE: transform_line
     ********************************
     */
     --
     --
      gcv_PackageName                 CONSTANT xxmx_module_messages.package_name%TYPE       := 'xxmx_hcm_person_ext_pkg';
      vt_ApplicationSuite             xxmx_migration_metadata.application_suite%TYPE;
      vt_Application                  xxmx_migration_metadata.application%TYPE;
      gvv_ApplicationErrorMessage     VARCHAR2(2048);


      gvv_ProgressIndicator                     VARCHAR2(100); 
      gvn_RowCount                              NUMBER;
      gvv_ReturnMessage                         xxmx_module_messages .module_message%TYPE;
      gvt_Severity                              xxmx_module_messages .severity%TYPE;
      gvt_OracleError                           xxmx_module_messages .oracle_error%TYPE;
      gvt_ModuleMessage                         xxmx_module_messages .module_message%TYPE;
      gvv_category_code                         xxmx_mapping_master.category_code%TYPE;                  
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
    PROCEDURE transform_line(
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2)
     IS
         CURSOR TransformMetadata_cur
                      (
                       pt_BusinessEntity             xxmx_migration_metadata.business_entity%TYPE
                      )
          IS
               --
               SELECT    xmd.application_suite
                        ,xmd.application
                        ,xst.stg_table_id
                        ,LOWER(xst.schema_name)                         AS stg_schema_name
                        ,LOWER(xst.table_name)                          AS stg_table_name
                        ,xxt.xfm_table_id
                        ,LOWER(xxt.schema_name)                         AS xfm_schema_name
                        ,LOWER(xxt.table_name)                          AS xfm_table_name
                        ,xxhs.Transform_code
                        ,xxhs.column_name
               FROM      xxmx_migration_metadata  xmd
                        ,xxmx_stg_tables          xst
                        ,xxmx_xfm_tables          xxt
                        ,xxmx_hcm_comp_ssid_transform xxhs
               WHERE     1 = 1
               AND       xmd.business_entity = pt_BusinessEntity
               AND       xst.metadata_id     = xmd.metadata_id
               AND       xxt.metadata_id     = xmd.metadata_id
               AND       UPPER(xxhs.xfm_table) = UPPER(xxt.table_name)
               AND       xxt.xfm_table_id    = xst.xfm_table_id;
               --

          --************************
          --** Constant Declarations
          --************************
          --

          ct_ProcOrFuncName               CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'transform_line';
          gcn_ApplicationErrorNumber      CONSTANT NUMBER := -20000;
          --
          --************************
          --** Variable Declarations
          --************************
          --

          ct_Phase                        xxmx_module_messages.phase%TYPE              := 'TRANSFORM';
          --
          --*************************
          --** Exception Declarations
          --*************************
          --

          --
     --** END Declarations **
     --
     BEGIN

          --
          ct_Phase := ct_Phase;
          --
          gvv_ProgressIndicator := '0010';


          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application     
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => 'ALL'
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                        ||gcv_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||') initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          gvv_ProgressIndicator := '0050';
          --

         FOR TransformMetadata_rec
         IN TransformMetadata_cur ( pt_i_BusinessEntity)
         LOOP

             gvt_sql := 'UPDATE '||TransformMetadata_rec.xfm_schema_name||'.'||TransformMetadata_rec.xfm_table_name
                        ||' SET '||TransformMetadata_rec.column_name ||' = OBJECT_NAME || ''-'' ||'||TransformMetadata_rec.Transform_code
                        ||' WHERE MIGRATION_SET_ID ='||pt_i_MigrationSetID;

             xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         --,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'SQL STATEMENT - '||gvt_sql
                         ,pt_i_OracleError       => NULL
                         );
             execute immediate gvt_sql;
         END LOOP;
         pv_o_ReturnStatus :='S';
        EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    ROLLBACK;
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         --,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR('"e_ModuleError" Exception raised after Progress Indicator "'
                                                       ||gcv_PackageName
                                                       ||'.'
                                                       ||ct_ProcOrFuncName
                                                       ||'-'
                                                       ||gvv_ProgressIndicator
                                                       ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                        ,1
                                                        ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END e_ModuleError Exception
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         --,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
                                                        ||gcv_PackageName
                                                        ||'.'
                                                        ||ct_ProcOrFuncName
                                                        ||'-'
                                                        ||gvv_ProgressIndicator
                                                        ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                         ,1
                                                         ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --       


    END transform_line;

    PROCEDURE Update_DFF(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    )
    IS
          --************************
          --** Constant Declarations
          --************************
          --

          ct_ProcOrFuncName               CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'Update_DFF';
          gcn_ApplicationErrorNumber      CONSTANT NUMBER := -20000;
          --
          --************************
          --** Variable Declarations
          --************************
          --

          ct_Phase                        xxmx_module_messages.phase%TYPE              := 'EXTRACT';
          --
          --*************************
          --** Exception Declarations
          --*************************
          --

          --
     --** END Declarations **
     --

    BEGIN
        UPDATE XXMX_PER_ASSIGNMENTS_M_STG
        SET ASS_ATTRIBUTE20 = 'TEST'
        WHERE MIGRATION_SET_ID = pt_i_MigrationSetID;

        -- Updating  XXMX_PER_ASSIGNMENTS_M_XFM  Table.	   
	   UPDATE XXMX_PER_ASSIGNMENTS_M_XFM 
	      SET ASS_ATTRIBUTE2 = DECODE(ASS_ATTRIBUTE2,'L','L','AI','F','A')
        WHERE MIGRATION_SET_ID = pt_i_MigrationSetID;

        COMMIT ;
        pv_o_ReturnStatus :='S';
        EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    ROLLBACK;
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         --,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR('"e_ModuleError" Exception raised after Progress Indicator "'
                                                       ||gcv_PackageName
                                                       ||'.'
                                                       ||ct_ProcOrFuncName
                                                       ||'-'
                                                       ||gvv_ProgressIndicator
                                                       ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                        ,1
                                                        ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END e_ModuleError Exception
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         --,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
                                                        ||gcv_PackageName
                                                        ||'.'
                                                        ||ct_ProcOrFuncName
                                                        ||'-'
                                                        ||gvv_ProgressIndicator
                                                        ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                         ,1
                                                         ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --       

    END Update_DFF;

     --
     --
     /*
     *************************************
     ** PROCEDURE: Transform_LEGISLATIONCODE
     *************************************
     */
     --
     --

    PROCEDURE transform_LEGISLATIONCODE(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    )
    IS
          --************************
          --** Constant Declarations
          --************************
          --

          ct_ProcOrFuncName               CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'transform_LEGISLATIONCODE';
          gcn_ApplicationErrorNumber      CONSTANT NUMBER := -20000;
          --
          --************************
          --** Variable Declarations
          --************************
          --

          ct_Phase                        xxmx_module_messages.phase%TYPE              := 'TRANSFORM';
          --
          --*************************
          --** Exception Declarations
          --*************************
          --

          --
     --** END Declarations **
     --

    BEGIN

       gvv_ProgressIndicator := '0010';
       gvv_category_code :='LE_BU';
       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||') initiated.'
            ,pt_i_OracleError       => NULL
            );
       --
  -- Updating Legislation Code for XXMX_PER_ABSENCE_XFM
  IF pt_i_BusinessEntity = 'PERSON'
  THEN
       UPDATE XXMX_PER_ABSENCE_XFM pax
          SET pax.legislationcode = (SELECT UNIQUE LEG_CODE FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSONID = XMM.PERSON_ID);

   END IF;

-- Updating Legislation Code for XXMX_PER_VISA_F_XFM
 IF pt_i_BusinessEntity = 'PERSON'
  THEN
		UPDATE XXMX_PER_VISA_F_XFM pax
          SET pax.legislationcode = (SELECT UNIQUE LEG_CODE FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSON_ID = XMM.PERSON_ID);
  END IF;

-- Updating Legislation Code for XXMX_PER_DISABILITY_XFM
  IF pt_i_BusinessEntity = 'PERSON'
  THEN
		UPDATE XXMX_PER_DISABILITY_XFM pax
          SET pax.legislationcode = (SELECT UNIQUE LEG_CODE FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSONID = XMM.PERSON_ID);
   END IF;

-- Updating Legislation Code for XXMX_PER_PHONES_XFM
  IF pt_i_BusinessEntity = 'PERSON'
  THEN
		UPDATE XXMX_PER_PHONES_XFM pax
          SET pax.legislation_code = (SELECT UNIQUE LEG_CODE FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSON_ID = XMM.PERSON_ID);
   END IF;

-- Updating Legislation Code for XXMX_CITIZENSHIPS_XFM
-- Updating on 21Nov23 -- LEGISLATION_CODE transform not required for Citizenship
   /*IF pt_i_BusinessEntity = 'PERSON'
  THEN
		UPDATE XXMX_CITIZENSHIPS_XFM pax
          SET pax.legislation_code = (SELECT LEG_CODE FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSON_ID = XMM.PERSON_ID);
   END IF; */

-- Updating Legislation Code for XXMX_PER_ETHNICITIES_XFM
  IF pt_i_BusinessEntity = 'PERSON'
  THEN
		UPDATE XXMX_PER_ETHNICITIES_XFM pax
          SET pax.legislation_code = (SELECT UNIQUE LEG_CODE FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSON_ID = XMM.PERSON_ID);
   END IF;

-- Updating Legislation Code for XXMX_PER_LEG_F_XFM
   IF pt_i_BusinessEntity = 'PERSON'
  THEN
		UPDATE XXMX_PER_LEG_F_XFM pax
          SET pax.legislation_code = (SELECT UNIQUE xmm.leg_code
                                        FROM xxmx_hcm_position_le_bu_tab xmm 
                                       WHERE pax.person_id = xmm.person_id);
   END IF;

-- Updating Legislation Code for XXMX_PER_RELIGION_XFM
  IF pt_i_BusinessEntity = 'PERSON'
  THEN
		UPDATE XXMX_PER_RELIGION_XFM pax
          SET pax.legislationcode = (SELECT UNIQUE LEG_CODE FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSONID = XMM.PERSON_ID);
  END IF;

-- Updating Legislation Code for XXMX_PER_CONTACT_PHONE_XFM
  IF pt_i_BusinessEntity = 'PERSON'
  THEN
		UPDATE XXMX_PER_CONTACT_PHONE_XFM pax
          SET pax.legislationcode = (SELECT UNIQUE LEG_CODE FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.CONTPERSONID = XMM.PERSON_ID);
   END IF;

-- Updating Legislation Code for XXMX_PER_NID_F_XFM
   IF pt_i_BusinessEntity = 'PERSON'
  THEN
		UPDATE XXMX_PER_NID_F_XFM pax
          SET pax.legislation_code = (SELECT UNIQUE LEG_CODE FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSON_ID = XMM.PERSON_ID);
   END IF;

-- Updating Legislation Code for XXMX_PER_PASSPORT_XFM
   IF pt_i_BusinessEntity = 'PERSON'
  THEN
		UPDATE XXMX_PER_PASSPORT_XFM pax
          SET pax.legislationcode = (SELECT UNIQUE LEG_CODE FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSONID = XMM.PERSON_ID);
   END IF;

-- Updating Legislation Code for XXMX_PER_CONTACTS_XFM
   IF pt_i_BusinessEntity = 'PERSON'
  THEN
		UPDATE XXMX_PER_CONTACTS_XFM pax
          SET pax.legislation_code = (SELECT UNIQUE LEG_CODE FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSON_ID = XMM.PERSON_ID);
   END IF;

-- Updating Legislation Code for XXMX_PER_NAMES_F_XFM
   IF pt_i_BusinessEntity = 'PERSON'
  THEN
		UPDATE XXMX_PER_NAMES_F_XFM pax
          SET pax.legislation_code = (SELECT UNIQUE LEG_CODE FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSON_ID = XMM.PERSON_ID);
   END IF;

-- Updating Legislation Code for XXMX_PER_PAY_METHOD_XFM
  IF pt_i_BusinessEntity = 'WORKER'
  THEN
		UPDATE XXMX_PER_PAY_METHOD_XFM pax
          SET pax.legislation_code = (SELECT UNIQUE LEG_CODE FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSON_ID = XMM.PERSON_ID);
   END IF;

-- Updating Legislation Code for XXMX_ASG_PAYROLL_XFM
  IF pt_i_BusinessEntity = 'WORKER'
  THEN
		UPDATE XXMX_ASG_PAYROLL_XFM pax
          SET pax.legislation_code = (SELECT UNIQUE LEG_CODE FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSON_ID = XMM.PERSON_ID);
   END IF;

-- Updating Legislation Code for XXMX_ASG_WORKMSURE_XFM
  IF pt_i_BusinessEntity = 'WORKER'
  THEN
		UPDATE XXMX_ASG_WORKMSURE_XFM pax
          SET pax.legislation_code = (SELECT UNIQUE LEG_CODE FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSON_ID = XMM.PERSON_ID);
   END IF;

-- Updating Legislation Code for XXMX_PER_ASSIGNMENTS_M_XFM
  IF pt_i_BusinessEntity = 'WORKER'
  THEN
		UPDATE XXMX_PER_ASSIGNMENTS_M_XFM pax
          SET pax.legislation_code = (SELECT UNIQUE LEG_CODE FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSON_ID = XMM.PERSON_ID);
  END IF;

-- Updating Legislation Code for XXMX_PER_POS_WR_XFM
  IF pt_i_BusinessEntity = 'WORKER'
  THEN
		UPDATE XXMX_PER_POS_WR_XFM pax
          SET pax.legislation_code = (SELECT UNIQUE LEG_CODE FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSON_ID = XMM.PERSON_ID);
  END IF;

-- Updating Legislation Code for XXMX_PER_SENIORITYDT_XFM
  IF pt_i_BusinessEntity = 'WORKER'
  THEN
		UPDATE XXMX_PER_SENIORITYDT_XFM pax
          SET pax.legislationcode = (SELECT UNIQUE LEG_CODE FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSONID = XMM.PERSON_ID);
  END IF;

-- Updating Legislation Code for XXMX_PER_ASG_SALARY_XFM
  IF pt_i_BusinessEntity = 'WORKER'
  THEN
		UPDATE XXMX_PER_ASG_SALARY_XFM pax
          SET pax.legislation_code = (SELECT UNIQUE LEG_CODE FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSON_ID = XMM.PERSON_ID);
  END IF;

       gvv_ProgressIndicator := '0030';
       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||':End of Transform Legislation Code at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
            ,pt_i_OracleError       => NULL
            );

        COMMIT ;
        pv_o_ReturnStatus :='S';
        EXCEPTION
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         --,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
                                                        ||gcv_PackageName
                                                        ||'.'
                                                        ||ct_ProcOrFuncName
                                                        ||'-'
                                                        ||gvv_ProgressIndicator
                                                        ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                         ,1
                                                         ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --       

    END transform_LEGISLATIONCODE;

     --
     --
     /*
     *************************************
     ** PROCEDURE: transform_BG_ID_NAME
     *************************************
     */
     --
     --

    PROCEDURE transform_BG_ID_NAME(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    )
    IS
          --************************
          --** Constant Declarations
          --************************
          --

          ct_ProcOrFuncName               CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'transform_BG_ID_NAME';
          gcn_ApplicationErrorNumber      CONSTANT NUMBER := -20000;
          --
          --************************
          --** Variable Declarations
          --************************
          --

          ct_Phase                        xxmx_module_messages.phase%TYPE              := 'TRANSFORM';
          --
          --*************************
          --** Exception Declarations
          --*************************
          --

          --
     --** END Declarations **
     --

    BEGIN

       gvv_ProgressIndicator := '0010';
       gvv_category_code :='LE_BU';
       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||') initiated.'
            ,pt_i_OracleError       => NULL
            );
       --
  -- Updating Absence Table.
  IF pt_i_BusinessEntity = 'PERSON'
  THEN
       UPDATE XXMX_PER_ABSENCE_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.personid = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSONID = XMM.PERSON_ID);

       UPDATE XXMX_CARRY_OVER_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.personid = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSON_ID = XMM.PERSON_ID);
  END IF;

-- Updating XXMX_PER_PEOPLE_F_XFM Table.
IF pt_i_BusinessEntity = 'PERSON'
  THEN
       UPDATE XXMX_PER_PEOPLE_F_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.person_id = pps.person_id ),*/
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSON_ID = XMM.PERSON_ID);
  END IF;

-- Updating XXMX_PER_PERSONS_XFM Table.
   IF pt_i_BusinessEntity = 'PERSON'
  THEN
       UPDATE XXMX_PER_PERSONS_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.person_id = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSON_ID = XMM.PERSON_ID);
  END IF;

-- Updating  XXMX_PER_NAMES_F_XFM Table.
  IF pt_i_BusinessEntity = 'PERSON'
  THEN
       UPDATE  XXMX_PER_NAMES_F_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.person_id = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSON_ID = XMM.PERSON_ID);
   END IF;

-- Updating  XXMX_PER_ADDRESS_F_XFM Table.
  IF pt_i_BusinessEntity = 'PERSON'
  THEN
       UPDATE  XXMX_PER_ADDRESS_F_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.person_id = pps.person_id ),*/
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSON_ID = XMM.PERSON_ID);
   END IF;

-- Updating  XXMX_PER_EMAIL_F_XFM Table.
  IF pt_i_BusinessEntity = 'PERSON'
  THEN
       UPDATE  XXMX_PER_EMAIL_F_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.person_id = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSON_ID = XMM.PERSON_ID);
   END IF;

-- Updating  XXMX_PER_PHONES_XFM Table.
  IF pt_i_BusinessEntity = 'PERSON'
  THEN
       UPDATE XXMX_PER_PHONES_XFM  pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.person_id = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSON_ID = XMM.PERSON_ID);
   END IF;

-- Updating  XXMX_PER_ETHNICITIES_XFM Table.
  IF pt_i_BusinessEntity = 'PERSON'
  THEN
       UPDATE XXMX_PER_ETHNICITIES_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.person_id = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSON_ID = XMM.PERSON_ID);
   END IF;

-- Updating  XXMX_PER_NID_F_XFM  Table.
  IF pt_i_BusinessEntity = 'PERSON'
  THEN
       UPDATE XXMX_PER_NID_F_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.person_id = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSON_ID = XMM.PERSON_ID);
  END IF;

-- Updating  XXMX_PER_PASSPORT_XFM  Table.
  IF pt_i_BusinessEntity = 'PERSON'
  THEN
       UPDATE XXMX_PER_PASSPORT_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.personid = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSONID = XMM.PERSON_ID);
  END IF;

-- Updating  XXMX_CITIZENSHIPS_XFM  Table.
  IF pt_i_BusinessEntity = 'PERSON'
  THEN
       UPDATE XXMX_CITIZENSHIPS_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.person_id = pps.person_id ),*/
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSON_ID = XMM.PERSON_ID);
  END IF;

-- Updating  XXMX_PER_LEG_F_XFM  Table.
  IF pt_i_BusinessEntity = 'PERSON'
  THEN
       UPDATE XXMX_PER_LEG_F_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.person_id = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSON_ID = XMM.PERSON_ID);
  END IF;

-- Updating  XXMX_PER_RELIGION_XFM  Table.
  IF pt_i_BusinessEntity = 'PERSON'
  THEN
       UPDATE XXMX_PER_RELIGION_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.personid = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSONID = XMM.PERSON_ID);
  END IF;

-- Updating  XXMX_PER_CONTACTS_XFM  Table.
IF pt_i_BusinessEntity = 'PERSON'
  THEN
       UPDATE XXMX_PER_CONTACTS_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.person_id = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSON_ID = XMM.PERSON_ID);
 END IF;

-- Updating  XXMX_PER_ADDR_USG_F_XFM  Table.
  IF pt_i_BusinessEntity = 'PERSON'
  THEN
       UPDATE XXMX_PER_ADDR_USG_F_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.person_id = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSON_ID = XMM.PERSON_ID);
  END IF;

-- Updating  XXMX_PER_DISABILITY_XFM  Table.
IF pt_i_BusinessEntity = 'PERSON'
  THEN
       UPDATE XXMX_PER_DISABILITY_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.personid = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSONID = XMM.PERSON_ID);
  END IF;

-- Updating  XXMX_PER_IMAGES_XFM  Table.
  IF pt_i_BusinessEntity = 'PERSON'
  THEN
       UPDATE XXMX_PER_IMAGES_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.personid = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSONID = XMM.PERSON_ID);
END IF;

-- Updating  XXMX_PER_VISA_F_XFM  Table.
  IF pt_i_BusinessEntity = 'PERSON'
  THEN
       UPDATE XXMX_PER_VISA_F_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.person_id = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.PERSON_ID = XMM.PERSON_ID);
  END IF;

-- Updating  XXMX_PER_CONTACT_REL_XFM  Table.
  IF pt_i_BusinessEntity = 'PERSON'
  THEN
       UPDATE XXMX_PER_CONTACT_REL_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.relatedpersonid = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.relatedpersonid = XMM.PERSON_ID);
  END IF;

-- Updating  XXMX_PER_CONTACT_ADDR_XFM  Table.
IF pt_i_BusinessEntity = 'PERSON'
  THEN
       UPDATE XXMX_PER_CONTACT_ADDR_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.contpersonid = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.contpersonid = XMM.PERSON_ID);
  END IF;

   -- Updating  XXMX_PER_CONTACT_PHONE_XFM  Table.
IF pt_i_BusinessEntity = 'PERSON'
  THEN
       UPDATE XXMX_PER_CONTACT_PHONE_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.contpersonid = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.contpersonid = XMM.PERSON_ID);
 END IF;

-- Updating  XXMX_PER_SENIORITYDT_XFM  Table.
IF pt_i_BusinessEntity = 'WORKER'
  THEN
       UPDATE XXMX_PER_SENIORITYDT_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.personid = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.personid = XMM.PERSON_ID);
 END IF;

-- Updating  XXMX_PER_ASG_SUP_F_XFM  Table.
IF pt_i_BusinessEntity = 'WORKER'
  THEN
       UPDATE XXMX_PER_ASG_SUP_F_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.person_id = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.person_id = XMM.PERSON_ID);
 END IF;

-- Updating  XXMX_ASG_PAYROLL_XFM  Table.
IF pt_i_BusinessEntity = 'WORKER'
  THEN
       UPDATE XXMX_ASG_PAYROLL_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.person_id = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.person_id = XMM.PERSON_ID);
END IF;

-- Updating  XXMX_PER_PAY_METHOD_XFM  Table.
IF pt_i_BusinessEntity = 'WORKER'
  THEN
       UPDATE XXMX_PER_PAY_METHOD_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.person_id = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.person_id = XMM.PERSON_ID);
END IF;


-- Updating  XXMX_PER_ASG_SALARY_XFM  Table.
IF pt_i_BusinessEntity = 'WORKER'
  THEN
       UPDATE XXMX_PER_ASG_SALARY_XFM pax
       SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.person_id = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.person_id = XMM.PERSON_ID);
END IF;

-- Updating  XXMX_ASG_WORKMSURE_XFM  Table.
IF pt_i_BusinessEntity = 'WORKER'
  THEN
       UPDATE XXMX_ASG_WORKMSURE_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.person_id = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.person_id = XMM.PERSON_ID);
END IF;

-- Updating  XXMX_ASG_GRADESTEP_XFM  Table.
IF pt_i_BusinessEntity = 'WORKER'
  THEN
       UPDATE XXMX_ASG_GRADESTEP_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.person_id = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.person_id = XMM.PERSON_ID);
END IF;

-- Updating  XXMX_EXT_BANK_ACC_XFM  Table.
IF pt_i_BusinessEntity = 'WORKER'
  THEN
       UPDATE XXMX_EXT_BANK_ACC_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.person_id = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.person_id = XMM.PERSON_ID);
END IF;

-- Updating  XXMX_PER_POS_WR_XFM  Table.
IF pt_i_BusinessEntity = 'WORKER'
  THEN
       UPDATE XXMX_PER_POS_WR_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.person_id = pps.person_id ),*/
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.person_id = XMM.PERSON_ID);
  END IF;

-- Updating  XXMX_PER_ASSIGNMENTS_M_XFM  Table.
IF pt_i_BusinessEntity = 'WORKER'
  THEN
       UPDATE XXMX_PER_ASSIGNMENTS_M_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.person_id = pps.person_id ), */
              pax.bg_name=(SELECT UNIQUE BU FROM xxmx_hcm_position_le_bu_tab XMM WHERE PAX.person_id = XMM.PERSON_ID);
  END IF;

  IF pt_i_BusinessEntity = 'WORKER'
       THEN
            UPDATE XXMX_PER_ASSIGNMENTS_M_XFM pax
               SET pax.business_unit_name = pax.bg_name;
       END IF;
       gvv_ProgressIndicator := '0030';
       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||':End of Transform BG ID and Name at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
            ,pt_i_OracleError       => NULL
            );

        COMMIT ;
        pv_o_ReturnStatus :='S';
        EXCEPTION
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         --,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
                                                        ||gcv_PackageName
                                                        ||'.'
                                                        ||ct_ProcOrFuncName
                                                        ||'-'
                                                        ||gvv_ProgressIndicator
                                                        ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                         ,1
                                                         ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --       

    END transform_BG_ID_NAME;
------------------------------------------------------------------------------
/**************************************
     ** PROCEDURE: transform_BU_LE_NAME
     *************************************
     */
     --
     --

   PROCEDURE transform_BU_LE_NAME(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    )
    IS
          --************************
          --** Constant Declarations
          --************************
          --

          ct_ProcOrFuncName               CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'transform_BU_LE_NAME';
          gcn_ApplicationErrorNumber      CONSTANT NUMBER := -20000;
          --
          --************************
          --** Variable Declarations
          --************************
          --

          ct_Phase                        xxmx_module_messages.phase%TYPE              := 'TRANSFORM';
          --
          --*************************
          --** Exception Declarations
          --*************************
          --

          --
     --** END Declarations **
     --

    BEGIN

       gvv_ProgressIndicator := '0010';
       gvv_category_code :='LE_BU';
       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||') initiated.'
            ,pt_i_OracleError       => NULL
            );
       --

-- Updating  XXMX_PER_ABSENCE_XFM  Table.
  IF pt_i_BusinessEntity = 'PERSON'
  THEN
       UPDATE XXMX_PER_ABSENCE_XFM pax
          SET pax.legal_employer_name =(SELECT UNIQUE xmm.legal_employer
                                          FROM xxmx_hcm_position_le_bu_tab xmm  
                                         WHERE pax.personid = xmm.person_id);
   END IF;

-- Updating  XXMX_PER_ASSIGNMENTS_M_XFM  Table.
  IF pt_i_BusinessEntity = 'WORKER'
  THEN
       UPDATE XXMX_PER_ASSIGNMENTS_M_XFM pax
          SET pax.legal_employer_name =(SELECT UNIQUE xmm.legal_employer
                                          FROM xxmx_hcm_position_le_bu_tab xmm 
                                         WHERE pax.person_id = xmm.person_id);
   END IF;

-- Updating  XXMX_PER_POS_WR_XFM  Table.
   IF pt_i_BusinessEntity = 'WORKER'
  THEN
       UPDATE XXMX_PER_POS_WR_XFM pax
          SET pax.legal_employer_name =(SELECT UNIQUE xmm.legal_employer
                                          FROM xxmx_hcm_position_le_bu_tab xmm 
                                         WHERE pax.person_id = xmm.person_id);
   END IF;

-- Updating  XXMX_PER_SENIORITYDT_XFM  Table.
IF pt_i_BusinessEntity = 'WORKER'
  THEN
       UPDATE XXMX_PER_SENIORITYDT_XFM pax
          SET pax.BUSINESSUNITSHORTCODE = pax.bg_name,
              pax.LEGALEMPLOYERNAME =(SELECT UNIQUE xmm.legal_employer
                                          FROM xxmx_hcm_position_le_bu_tab xmm 
                                         WHERE pax.personid = xmm.person_id);
   END IF;

/* Updating  XXMX_PER_ASSIGNMENTS_M_XFM Table.
   Column : DEFAULT_EXPENSE_ACCOUNT -> Updating this column value where there is NA
   As this Package XXMX_CITCO_FIN_EXT_PKG.TRANSFORM_CODE_COMBO - Not able to transform
   Code Combination if there are NULLs */   --Added on 21Nov23
IF pt_i_BusinessEntity = 'WORKER'
  THEN
       UPDATE XXMX_PER_ASSIGNMENTS_M_XFM
          SET DEFAULT_EXPENSE_ACCOUNT='2710.' 
        WHERE DEFAULT_EXPENSE_ACCOUNT ='NA';
   END IF;
   
       gvv_ProgressIndicator := '0030';
       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||':End of Transform BG ID and Name at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
            ,pt_i_OracleError       => NULL
            );

        COMMIT ;
        pv_o_ReturnStatus :='S';
        EXCEPTION
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         --,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
                                                        ||gcv_PackageName
                                                        ||'.'
                                                        ||ct_ProcOrFuncName
                                                        ||'-'
                                                        ||gvv_ProgressIndicator
                                                        ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                         ,1
                                                         ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --       

    END transform_BU_LE_NAME;  
------------------------------------------------------------------------------
/*************************************
 ** PROCEDURE: Update_Position_code
**************************************/
    PROCEDURE Update_Position_code(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    )
    IS
          --************************
          --** Cursor Declaration
          --************************
             CURSOR C_ASG_POS 
                  IS 
                  --SELECT PERSON_ID,personnumber FROM XXMX_PER_ASSIGNMENTS_M_XFM;
				  SELECT ASG.PERSON_ID
				       , POS.POSITION_CODE
					   , POS.LOCATION_CODE
                    FROM XXMX_PER_ASSIGNMENTS_M_XFM ASG
					   , XX_POSITION_MAP_TEMP POS
                   WHERE ASG.PERSONNUMBER = POS.GEN1;

		  TYPE ASG_POS_REC IS TABLE OF C_ASG_POS%ROWTYPE INDEX BY PLS_INTEGER;
          ASG_POS_TBL    ASG_POS_REC;
		  --************************
          --** Constant Declarations
          --************************

          ct_ProcOrFuncName               CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'Update_Position_code';
          gcn_ApplicationErrorNumber      CONSTANT NUMBER := -20000;
          --
          --************************
          --** Variable Declarations
          --************************
          --
          --v_position_code                 VARCHAR2(250);
          --v_location_code                 VARCHAR2(250);
          ct_Phase                        xxmx_module_messages.phase%TYPE              := 'TRANSFORM';
          --
          --*************************
          --** Exception Declarations
          --*************************
          --

          --
     --** END Declarations **
     --

    BEGIN
      IF pt_i_BusinessEntity = 'WORKER'
	  THEN
       gvv_ProgressIndicator := '0010';

       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||') initiated.'
            ,pt_i_OracleError       => NULL
            );
       --
       /*FOR I IN C1
       LOOP
         V_POSITION_CODE := NULL;

         BEGIN
          SELECT POSITION_CODE, location_code
            INTO V_POSITION_CODE, v_location_code
            FROM XX_POSITION_MAP_TEMP
           WHERE gen1 = i.personnumber; 
         EXCEPTION
           WHEN OTHERS THEN
             V_POSITION_CODE := NULL; 
         END; */


   OPEN C_ASG_POS;
     FETCH C_ASG_POS BULK COLLECT INTO ASG_POS_TBL;

	 FORALL I IN 1..ASG_POS_TBL.COUNT
        UPDATE XXMX_PER_ASSIGNMENTS_M_XFM
           SET POSITION_CODE = ASG_POS_TBL(I).POSITION_CODE
             , LOCATION_CODE =  ASG_POS_TBL(I).location_code
             , DEPARTMENT_NAME = NULL
             , JOB_ID = NULL
             , JOB_CODE = NULL
             , GRADE_ID = NULL
             , GRADE_CODE = NULL
         WHERE PERSON_ID = ASG_POS_TBL(I).PERSON_ID;
	 COMMIT;
  CLOSE C_ASG_POS;
       --END LOOP;

  --execute immediate 'drop table xxmx_hcm_position_le_bu_v';
  --execute immediate 'create table xxmx_hcm_position_le_bu_v as select * from xxmx_hcm_position_le_bu_v';

  --Updating POSITION_CODE for BU's US2230, DK5350
    /*    UPDATE XXMX_PER_ASSIGNMENTS_M_XFM
           SET POSITION_CODE = 'US2230-US08-222-06'
             , DEPARTMENT_NAME = NULL
             , JOB_ID = NULL
             , JOB_CODE = NULL
             , GRADE_ID = NULL
             , GRADE_CODE = NULL
         WHERE BUSINESS_UNIT_NAME = 'US2230'
           AND MIGRATION_SET_ID = pt_i_MigrationSetId;

UPDATE XXMX_PER_ASSIGNMENTS_M_XFM
           SET POSITION_CODE = 'DK5350-DK01-230-05'
             , DEPARTMENT_NAME = NULL
             , JOB_ID = NULL
             , JOB_CODE = NULL
             , GRADE_ID = NULL
             , GRADE_CODE = NULL
         WHERE BUSINESS_UNIT_NAME = 'DK5350'
           AND MIGRATION_SET_ID = pt_i_MigrationSetId;*/

       gvv_ProgressIndicator := '0030';
       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||':End of Update Position Code at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
            ,pt_i_OracleError       => NULL
            );

        COMMIT ;
        pv_o_ReturnStatus :='S';
	END IF;
        EXCEPTION
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         --,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
                                                        ||gcv_PackageName
                                                        ||'.'
                                                        ||ct_ProcOrFuncName
                                                        ||'-'
                                                        ||gvv_ProgressIndicator
                                                        ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                         ,1
                                                         ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --       

    END Update_Position_code;

/*************************************
 ** PROCEDURE: Update_Absence_Types
**************************************/
    PROCEDURE Update_Absence_Types(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus               OUT  VARCHAR2
                    )
    IS
          --************************
          --** Cursor Declaration
          --************************
             CURSOR PER_ABS_CUR
                  IS 
                    --SELECT * FROM XXMX_PER_ABSENCE_XFM;

			 SELECT XMM.output_code_1,XMM.output_code_2,AB.personid,AB.legislationcode,AB.ABSENCENAME
               FROM XXMX_MAPPING_MASTER XMM,XXMX_PER_ABSENCE_XFM AB
              WHERE 1=1
		      --AND input_code_3 = i.legislationcode          -- Change related to 2.0
			    AND XMM.input_code_3 IN(AB.LEGISLATIONCODE,'All')
                AND input_code_2   = AB.ABSENCENAME
			    AND CATEGORY_CODE  = 'ABSENCE_TYPES';

         TYPE PER_ABS_REC IS TABLE OF PER_ABS_CUR%ROWTYPE INDEX BY PLS_INTEGER;
         PER_ABS_TBL    PER_ABS_REC;
          --************************
          --** Constant Declarations
          --************************
          --

          ct_ProcOrFuncName               CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'Update_Absence_Types';
          gcn_ApplicationErrorNumber      CONSTANT NUMBER := -20000;
          --
          --************************
          --** Variable Declarations
          --************************
          --
          --v_absence_type                  VARCHAR2(250);
          --v_absence_reason                  VARCHAR2(250);
          ct_Phase                        xxmx_module_messages.phase%TYPE              := 'TRANSFORM';
          --
          --*************************
          --** Exception Declarations
          --*************************
          --

          --
     --** END Declarations **
     --

    BEGIN
  IF pt_i_BusinessEntity = 'PERSON'
  THEN
       gvv_ProgressIndicator := '0010';

       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||') initiated.'
            ,pt_i_OracleError       => NULL
            );

       UPDATE xxmx_per_absence_xfm SET ABSENCEREASON = NULL,ABSENCECATEGORY = NULL;
	   COMMIT;
       --
	   OPEN PER_ABS_CUR;
	   FETCH PER_ABS_CUR BULK COLLECT INTO PER_ABS_TBL;

       /*FOR I IN C1
       LOOP
         v_absence_type := NULL; 
         v_absence_reason  := NULL;

         BEGIN
          SELECT output_code_1,output_code_2
            INTO v_absence_type,v_absence_reason
            FROM XXMX_MAPPING_MASTER
           WHERE 1=1
		     --AND input_code_3 = i.legislationcode          -- Change related to 2.0
			 AND input_code_3 IN(i.legislationcode,'All')
             AND input_code_2 = i.ABSENCENAME
			 AND CATEGORY_CODE = 'ABSENCE_TYPES';


         EXCEPTION
           WHEN OTHERS THEN
             v_absence_type := NULL;
			 v_absence_reason  := NULL;
         END;

     IF v_absence_type IS NOT NULL
     THEN
	  BEGIN
        UPDATE xxmx_per_absence_xfm 
	       SET absencetype = v_absence_type
             , absencereason = v_absence_reason
         WHERE personid = i.personid
           AND legislationcode = i.legislationcode
           AND ABSENCENAME = i.ABSENCENAME
           AND MIGRATION_SET_ID = pt_i_MigrationSetId;
		EXCEPTION
           WHEN OTHERS THEN
                NULL;
         END;
     END IF;   	 
       END LOOP; */

	FORALL I IN 1..PER_ABS_TBL.COUNT
	  UPDATE xxmx_per_absence_xfm 
	       SET absencetype = PER_ABS_TBL(I).output_code_1
             , absencereason = PER_ABS_TBL(I).output_code_2
         WHERE personid = PER_ABS_TBL(I).personid
           AND legislationcode = PER_ABS_TBL(I).legislationcode
           AND ABSENCENAME = PER_ABS_TBL(I).ABSENCENAME;
	COMMIT;
 CLOSE PER_ABS_CUR;

     DELETE from xxmx_per_absence_xfm where absencename='Public Holiday';
   COMMIT; 
   
-- Added Sick Leave Category for Reconciliation -- on 21Nov23 
   UPDATE xxmx_per_absence_xfm XFM
      SET ATTRIBUTE15 = (CASE 
                          WHEN ABSENCENAME LIKE 'Sick Leave Uncertified%'
                          then 'Uncertified'
                          when ABSENCENAME LIKE 'Sick Leave Certified%'
                          then 'Certified'
                          else null
                          end)
    WHERE ABSENCENAME LIKE 'Sick%Leave%ertifi%';
  COMMIT;

       gvv_ProgressIndicator := '0030';
       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||':End of Update Absence Type at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
            ,pt_i_OracleError       => NULL
            );

        COMMIT ;
  END IF;
        pv_o_ReturnStatus :='S';
        EXCEPTION
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         --,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
                                                        ||gcv_PackageName
                                                        ||'.'
                                                        ||ct_ProcOrFuncName
                                                        ||'-'
                                                        ||gvv_ProgressIndicator
                                                        ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                         ,1
                                                         ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --       

    END Update_Absence_Types;
------------------------------------------------
/*************************************
 ** PROCEDURE: Update_Phone_Type
**************************************/
    PROCEDURE Update_Phone_Type(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus               OUT  VARCHAR2
                    )
    IS

          --************************
          --** Constant Declarations
          --************************
          --

          ct_ProcOrFuncName               CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'Update_Phone_Type';
          gcn_ApplicationErrorNumber      CONSTANT NUMBER := -20000;
          --
          --************************
          --** Variable Declarations
          --************************
          --
          ct_Phase                        xxmx_module_messages.phase%TYPE              := 'TRANSFORM';
          --
          --*************************
          --** Exception Declarations
          --*************************
          --

          --
     --** END Declarations **
     --

    BEGIN

       gvv_ProgressIndicator := '0010';

       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||') initiated.'
            ,pt_i_OracleError       => NULL
            );

       --
	IF pt_i_BusinessEntity = 'PERSON'
	THEN
	  BEGIN
        UPDATE XXMX_PER_PHONES_XFM 
	       SET phone_type = 'HM' /*--'WM' 2.6 Change */
         WHERE phone_type = 'M'
           AND MIGRATION_SET_ID = pt_i_MigrationSetId;
		EXCEPTION
           WHEN OTHERS THEN
                NULL;
         END;
    END IF;
       gvv_ProgressIndicator := '0030';
       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||':End of Update Phone Type at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
            ,pt_i_OracleError       => NULL
            );

        COMMIT ;
        pv_o_ReturnStatus :='S';
        EXCEPTION
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         --,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
                                                        ||gcv_PackageName
                                                        ||'.'
                                                        ||ct_ProcOrFuncName
                                                        ||'-'
                                                        ||gvv_ProgressIndicator
                                                        ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                         ,1
                                                         ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --       

    END Update_Phone_Type;
/*************************************
 ** PROCEDURE: Update_Assign_Status
**************************************/
    PROCEDURE Update_Assign_Status(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus               OUT  VARCHAR2
                    )
    IS

          --************************
          --** Constant Declarations
          --************************
          --

          ct_ProcOrFuncName               CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'Update_Assign_Status';
          gcn_ApplicationErrorNumber      CONSTANT NUMBER := -20000;
          --
          --************************
          --** Variable Declarations
          --************************
          --
          ct_Phase                        xxmx_module_messages.phase%TYPE              := 'TRANSFORM';
          --
          --*************************
          --** Exception Declarations
          --*************************
          --

          --
     --** END Declarations **
     --

    BEGIN

       gvv_ProgressIndicator := '0010';

       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||') initiated.'
            ,pt_i_OracleError       => NULL
            );

       --
	  BEGIN
-- Changes related to Version 2.7
        /*UPDATE XXMX_PER_ASSIGNMENTS_M_XFM 
	       SET ASSIGNMENT_STATUS_TYPE_ID = 'ACTIVE_PROCESS'
         WHERE ASSIGNMENT_STATUS_TYPE_ID = 'P_ACTIVE_ASSIGN'
           AND MIGRATION_SET_ID = pt_i_MigrationSetId
		   AND pt_i_BusinessEntity = 'WORKER'; */

           UPDATE XXMX_PER_ASSIGNMENTS_M_XFM    
           SET ASSIGNMENT_STATUS_TYPE = CASE 
                                        WHEN ASSIGNMENT_STATUS_TYPE_ID = 'P_ACTIVE_ASSIGN'
                                        THEN 'ACTIVE_PROCESS'
                                        WHEN ASSIGNMENT_STATUS_TYPE_ID = 'D_SUSP_ASSIGN'
                                             AND ACTION_CODE = 'CURRENT'
                                        THEN 'SUSPEND_PROCESS'
                                        ELSE ASSIGNMENT_STATUS_TYPE
                                        END
          WHERE 1=1 --ASSIGNMENT_STATUS_TYPE_ID = 'P_ACTIVE_ASSIGN'
           AND MIGRATION_SET_ID = pt_i_MigrationSetId
		   AND pt_i_BusinessEntity = 'WORKER';

		EXCEPTION
           WHEN OTHERS THEN
                NULL;
         END;

-- Updating DEFAULT_EXPENSE_ACCOUNT which are not valid - Added on 21NOV2023
       UPDATE XXMX_PER_ASSIGNMENTS_M_XFM
         SET DEFAULT_EXPENSE_ACCOUNT = 'NA'
       WHERE DEFAULT_EXPENSE_ACCOUNT LIKE '%..%';
    COMMIT;
    
       gvv_ProgressIndicator := '0030';
       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||':End of Update Assignment Status at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
            ,pt_i_OracleError       => NULL
            );

        COMMIT ;
        pv_o_ReturnStatus :='S';
        EXCEPTION
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         --,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
                                                        ||gcv_PackageName
                                                        ||'.'
                                                        ||ct_ProcOrFuncName
                                                        ||'-'
                                                        ||gvv_ProgressIndicator
                                                        ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                         ,1
                                                         ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --       

    END Update_Assign_Status;
/*************************************
 ** PROCEDURE: Update_Performance_Rating
**************************************/
    PROCEDURE Update_Performance_Rating(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus               OUT  VARCHAR2
                    )
    IS

          --************************
          --** Constant Declarations
          --************************
          --

          ct_ProcOrFuncName               CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'Update_Performance_Rating';
          gcn_ApplicationErrorNumber      CONSTANT NUMBER := -20000;
          --
          --************************
          --** Variable Declarations
          --************************
          --
          ct_Phase                        xxmx_module_messages.phase%TYPE              := 'TRANSFORM';
          --
          --*************************
          --** Exception Declarations
          --*************************
          --

          --
     --** END Declarations **
     --

    BEGIN

       gvv_ProgressIndicator := '0010';

       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||') initiated.'
            ,pt_i_OracleError       => NULL
            );

       --
	IF pt_i_BusinessEntity = 'TALENT'
	THEN
	  BEGIN
        UPDATE XXMX_PER_PROFILE_ITEM_XFM
	       SET RATINGLEVELCODE1 = DECODE(OVERALL_RATING,'Basic Performance',1
		                                             ,'Developing Performance',3
													 ,'High Performance',4
													 , 'Superior Performance',5
													 ,'Top Performance',6
									  )		   
         WHERE MIGRATION_SET_ID = pt_i_MigrationSetId;
		EXCEPTION
           WHEN OTHERS THEN
                NULL;
         END;
    END IF;

       gvv_ProgressIndicator := '0030';
       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||':End of Update Performance Rating at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
            ,pt_i_OracleError       => NULL
            );

        COMMIT ;
        pv_o_ReturnStatus :='S';
        EXCEPTION
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         --,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
                                                        ||gcv_PackageName
                                                        ||'.'
                                                        ||ct_ProcOrFuncName
                                                        ||'-'
                                                        ||gvv_ProgressIndicator
                                                        ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                         ,1
                                                         ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --       

    END Update_Performance_Rating;
-------------------------------------------------------------------------------
/* *************************************
     ** PROCEDURE: transform_TALENT_CONFIG_PROC
     *************************************      */

    PROCEDURE transform_TALENT_CONFIG_PROC(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    )
    IS
          --************************
          --** Constant Declarations
          --************************
          --

          ct_ProcOrFuncName               CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'transform_TALENT_CONFIG_PROC';
          gcn_ApplicationErrorNumber      CONSTANT NUMBER := -20000;
          --
          --************************
          --** Variable Declarations
          --************************
          --

          ct_Phase                        xxmx_module_messages.phase%TYPE              := 'TRANSFORM';
          --
          --*************************
          --** Exception Declarations
          --*************************
          --

          --
     --** END Declarations **
     --

    BEGIN

       gvv_ProgressIndicator := '0010';
       gvv_category_code :='LE_BU';
       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||') initiated.'
            ,pt_i_OracleError       => NULL
            );
       --
-- Updating  XXMX_PER_TALENT_PROFILE_XFM  Table.

       UPDATE XXMX_PER_TALENT_PROFILE_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.person_id = pps.person_id ), */
              pax.bg_name = (SELECT xmm.bu
                               FROM xxmx_hcm_position_le_bu_tab xmm 
                              WHERE pax.person_id = xmm.person_id);

-- Updating  XXMX_PER_PROFILE_ITEM_XFM  Table.
		UPDATE XXMX_PER_PROFILE_ITEM_XFM pax
          SET /*pax.bg_id=(SELECT pps.organization_id
                           FROM XXMX_PER_PERSONS_STG pps
                          WHERE pax.person_id = pps.person_id ), */
              pax.bg_name=(SELECT xmm.bu
                             FROM xxmx_hcm_position_le_bu_tab xmm 
                            WHERE pax.person_id = xmm.person_id);

-- Updating Config Values
   UPDATE XXMX_PER_TALENT_PROFILE_XFM pax
      SET profile_id='300000059587181'
    WHERE MIGRATION_SET_ID = pt_i_MigrationSetID;

   UPDATE XXMX_PER_PROFILE_ITEM_XFM pax
      SET profileid='300000059587181'
	    , contenttypeid='125'
		, ratingmodelcode1='PERFORMANCE'
		, SECTIONID='12501'
    WHERE MIGRATION_SET_ID = pt_i_MigrationSetID;

gvv_ProgressIndicator := '0030';
       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||':End of Talent Transform at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
            ,pt_i_OracleError       => NULL
            );

        COMMIT ;
        pv_o_ReturnStatus :='S';
        EXCEPTION
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         --,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
                                                        ||gcv_PackageName
                                                        ||'.'
                                                        ||ct_ProcOrFuncName
                                                        ||'-'
                                                        ||gvv_ProgressIndicator
                                                        ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                         ,1
                                                         ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --       

    END transform_TALENT_CONFIG_PROC;
-------------------------------------------------------------------------------
/* *************************************
     ** PROCEDURE: transform_salary_basis_proc
     *************************************      */

    PROCEDURE transform_salary_basis_proc(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    )
    IS

          --************************
          --** Cursor Declarations
          --************************
          --
		   CURSOR C_UPDATE_SAL_BASIS IS 
                   SELECT
                    *
                FROM
                    (
                        SELECT
                            asg.person_id,
                            asg.assignment_number,
                            output_code_1 sal_basis
                        FROM
                            xxmx_per_asg_salary_xfm    s,
                            xxmx_mapping_master        m,
                            xxmx_per_assignments_m_xfm asg
                        WHERE
                                s.name = m.input_code_1
                            AND ( input_code_2 IS NULL
                                  OR input_code_2 = asg.location_code )
                            AND asg.location_code IS NOT NULL
                            AND asg.assignment_number = s.assignment_number
                            AND action_code = 'CURRENT'
                                --and asg.person_id = s.PERSON_ID
                    )
                WHERE
                    sal_basis IS NOT NULL;
		     /* SELECT PERSON_ID,sal_basis
                FROM (select PERSON_ID,location_code,(case when location_code like 'IN%Pune%'
                                                           then 'IN Pune Annual'
                                                           when location_code like 'IN%Hyder%'
                                                           then 'IN Hyderabad Annual'
                                                           when location_code like 'IN%Mum%'
                                                           then 'IN Mumbai Annual'
                                                  --
                                                           when location_code like 'CA%Toron%'
                                                           then 'CA Toronto Annual'
                                                           when location_code like 'CA%Halifax%'
                                                           then 'CA Halifax Annual'
                                                  --
                                                           when location_code like 'PH%'
                                                           then 'PH Manila Annual'
                                                  -- 
                                                           WHEN location_code like 'US%'
                                                           then 'US San Francisco Annual'
--                                                      else asf.name
                                                      end ) sal_basis
                                      from XXMX_PER_ASSIGNMENTS_M_XFM 
                                      WHERE ACTION_CODE='CURRENT'
                                       and person_id IN(SELECT UNIQUE PERSON_ID FROM XXMX_PER_ASG_SALARY_XFM)
                                       )
         WHERE sal_basis IS NOT NULL;*/
          --************************
          --** Constant Declarations
          --************************
          --

          ct_ProcOrFuncName               CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'transform_salary_basis_proc';
          gcn_ApplicationErrorNumber      CONSTANT NUMBER := -20000;
          --
          --************************
          --** Variable Declarations
          --************************
          --

          ct_Phase                        xxmx_module_messages.phase%TYPE              := 'TRANSFORM';
          --
          --*************************
          --** Exception Declarations
          --*************************
          --

          --
     --** END Declarations **
     --

    BEGIN

       gvv_ProgressIndicator := '0010';
       --gvv_category_code :='LE_BU';
       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||') initiated.'
            ,pt_i_OracleError       => NULL
            );
       --
-- Updating  XXMX_PER_ASG_SALARY_XFM  Table.
  /* FOR REC_SAL_BASIS IN C_UPDATE_SAL_BASIS 
   LOOP
      UPDATE XXMX_PER_ASG_SALARY_XFM SET NAME = REC_SAL_BASIS.sal_basis
       WHERE  MIGRATION_SET_ID = pt_i_MigrationSetID
         AND assignment_number = REC_SAL_BASIS.assignment_number;
   END LOOP;*/




        for r in (
        select a.output_code_1 sal_basis, b.assignment_number, b.effective_start_date, b.effective_End_date, b.name
        from xxmx_mapping_master a, XXMX_PER_ASG_SALARY_xfm b
        where input_code_3 is null
        and category_code = 'SALARY_BASIS'
        and input_code_1 = b.name
        )
        loop
        update XXMX_PER_ASG_SALARY_xfm a
        set name =  r.sal_basis
        where r.assignment_number =  a.assignment_number
          and r.name  = a.name
          and a.effective_Start_date = r.effective_Start_Date
          and a.effective_end_date = r.effective_end_Date
          ;
        end loop;

        for r in ( select distinct  a.assignment_number, a.effective_start_date, a.effective_end_date, c.town_or_city, a.name, d.output_code_1 sal_basis
        from XXMX_PER_ASG_SALARY_xfm  a
            , per_all_assignments_f@xxmx_Extract  b
            , hr_locations@xxmx_Extract c
            ,xxmx_mapping_master d
        where 1=1
        --and personnumber = 772
        and input_code_3 is not null
        and category_code = 'SALARY_BASIS'
        and input_code_1 = a.name
        and input_code_3 = decode(c.town_or_city,'Dublin 1','Dublin','St Helier','Jersey','St Peter Port','Guernsey'
        ,'Jupiter Mills','Mumbai', town_or_city)
        and replace(a.assignment_number,'E','') =  b.assignment_number
        and A.effective_start_date between b.effective_start_date and b.effective_end_date
        and c.location_id =  b.location_id
        and not exists (select 1 from xxmx_mapping_master where category_code = 'SALARY_BASIS' AND input_code_1  = a.name and input_code_3 is null )
        )
        loop
        update XXMX_PER_ASG_SALARY_xfm a
        set name =  r.sal_basis
        where r.assignment_number =  a.assignment_number
          and r.name  = a.name
          and a.effective_Start_date = r.effective_Start_Date
          and a.effective_end_date = r.effective_end_Date
          ;
        end loop;










   gvv_ProgressIndicator := '0030';
       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||':End of Salary Basis Name Transform at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
            ,pt_i_OracleError       => NULL
            );

        COMMIT ;
        pv_o_ReturnStatus :='S';
        EXCEPTION
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         --,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
                                                        ||gcv_PackageName
                                                        ||'.'
                                                        ||ct_ProcOrFuncName
                                                        ||'-'
                                                        ||gvv_ProgressIndicator
                                                        ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                         ,1
                                                         ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --       

    END transform_salary_basis_proc;
------------------------------------------------------------------------------
-------------------------------------------------------------------------------
/* *************************************
     ** PROCEDURE: transform_emp_category_proc
     *************************************      */

    PROCEDURE transform_emp_category_proc(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    )
    IS

          --************************
          --** Cursor Declarations
          --************************
          --
		   CURSOR C_UPDATE_EMP_CAT IS 
		       select unique employment_category
			        , DECODE(employment_category,'PTEP','PR'
                                                ,'PTET','PT'
                                                ,'FTET','FT'
                                                ,'FTEP','FR',employment_category) CATEGORY 
                 from xxmx_per_assignments_m_xfm
				WHERE employment_category IN('PTET','PTEP','FTET','FTEP');
          --************************
          --** Constant Declarations
          --************************
          --

          ct_ProcOrFuncName               CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'transform_emp_category_proc';
          gcn_ApplicationErrorNumber      CONSTANT NUMBER := -20000;
          --
          --************************
          --** Variable Declarations
          --************************
          --

          ct_Phase                        xxmx_module_messages.phase%TYPE              := 'TRANSFORM';
          --
          --*************************
          --** Exception Declarations
          --*************************
          --

          --
     --** END Declarations **
     --

    BEGIN

       gvv_ProgressIndicator := '0010';
       --gvv_category_code :='LE_BU';
       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||') initiated.'
            ,pt_i_OracleError       => NULL
            );
       --
-- Updating  xxmx_per_assignments_m_xfm  Table.
   FOR REC_UPDATE_EMP_CAT IN C_UPDATE_EMP_CAT
   LOOP
      UPDATE xxmx_per_assignments_m_xfm ASG
	     SET employment_category = REC_UPDATE_EMP_CAT.CATEGORY
	   WHERE employment_category = REC_UPDATE_EMP_CAT.employment_category
         AND MIGRATION_SET_ID = pt_i_MigrationSetID;
   END LOOP;

   UPDATE xxmx_per_assignments_m_xfm SET bargaining_unit_code = NULL;

   gvv_ProgressIndicator := '0030';
       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||':End of Employment Category Transform at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
            ,pt_i_OracleError       => NULL
            );

        COMMIT ;
        pv_o_ReturnStatus :='S';
        EXCEPTION
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         --,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
                                                        ||gcv_PackageName
                                                        ||'.'
                                                        ||ct_ProcOrFuncName
                                                        ||'-'
                                                        ||gvv_ProgressIndicator
                                                        ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                         ,1
                                                         ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --       

    END transform_emp_category_proc;

-------------------------------------------------------------------------------
/* *************************************
     ** PROCEDURE: add_phone_area_code_proc
     *************************************      */

    PROCEDURE add_phone_area_code_proc(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    )
    IS

          --************************
          --** Constant Declarations
          --************************
          --

          ct_ProcOrFuncName               CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'add_phone_area_code_proc';
          gcn_ApplicationErrorNumber      CONSTANT NUMBER := -20000;
          --
          --************************
          --** Variable Declarations
          --************************
          --

          ct_Phase                        xxmx_module_messages.phase%TYPE              := 'TRANSFORM';
          --
          --*************************
          --** Exception Declarations
          --*************************
          --

          --
     --** END Declarations **
     --

    BEGIN

       gvv_ProgressIndicator := '0010';
       --gvv_category_code :='LE_BU';
       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||') initiated.'
            ,pt_i_OracleError       => NULL
            );
       --
-- Updating  XXMX_PER_PHONES_xfm  Table.
      UPDATE XXMX_PER_PHONES_xfm
         SET AREA_CODE = (CASE 
                           WHEN LEGISLATION_CODE IN('US','VG','KY','BM','BS','CA')
		                   THEN SUBSTR(SUBSTR(regexp_replace(phone_number,'[^0-9]',''),-10),1,3)
		                   WHEN LEGISLATION_CODE IN('GG','JE')
		                   THEN SUBSTR(SUBSTR(regexp_replace(phone_number,'[^0-9]',''),-11),1,5)
		                   WHEN LEGISLATION_CODE = 'AU'
		                   THEN SUBSTR(SUBSTR(regexp_replace(phone_number,'[^0-9]',''),-9),1,1)
		                   ELSE NULL
		        	      END)
        , PHONE_NUMBER = NVL((CASE
                               WHEN LEGISLATION_CODE IN('US','VG','KY','BM','BS','CA')
		                       THEN SUBSTR(SUBSTR(regexp_replace(phone_number,'[^0-9]',''),-10),4)
		                       WHEN LEGISLATION_CODE IN('GG','JE')
		                       THEN SUBSTR(SUBSTR(regexp_replace(phone_number,'[^0-9]',''),-11),6)
		                       WHEN LEGISLATION_CODE = 'AU'
		                       THEN SUBSTR(SUBSTR(regexp_replace(phone_number,'[^0-9]',''),-9),2)
		                       WHEN LEGISLATION_CODE = 'MU'
		                       THEN SUBSTR(regexp_replace(phone_number,'[^0-9]',''),-7)
		                       WHEN LEGISLATION_CODE IN('ES','FR')
		                       THEN SUBSTR(regexp_replace(phone_number,'[^0-9]',''),-9)
		                       WHEN LEGISLATION_CODE IN('HK','MT','DK')
		                       THEN SUBSTR(regexp_replace(phone_number,'[^0-9]',''),-8)
		                       ELSE PHONE_NUMBER
		                      END),PHONE_NUMBER)
       WHERE LEGISLATION_CODE IN('US','VG','KY','BM','BS','CA','GG','JE','AU','MU','ES','FR','HK','MT','DK')
         AND MIGRATION_SET_ID = pt_i_MigrationSetID;

   gvv_ProgressIndicator := '0030';
       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||':End of Area Code Transform at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
            ,pt_i_OracleError       => NULL
            );

        COMMIT ;
        pv_o_ReturnStatus :='S';
        EXCEPTION
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         --,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
                                                        ||gcv_PackageName
                                                        ||'.'
                                                        ||ct_ProcOrFuncName
                                                        ||'-'
                                                        ||gvv_ProgressIndicator
                                                        ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                         ,1
                                                         ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --       

    END add_phone_area_code_proc;

-------------------------------------------------------------------------------
/* *************************************
     ** PROCEDURE: update_worker_start_date_proc
     *************************************      */

    PROCEDURE update_worker_start_date_proc(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    )
    IS

	        --************************
          --** Cursor Declaration
          --************************
             CURSOR C_POS_DATE 
                  IS 
				  SELECT PERSON_ID,DATE_START
                    FROM PER_PERIODS_OF_SERVICE@XXMX_EXTRACT
                   WHERE ACTUAL_TERMINATION_DATE IS NULL;

		  TYPE POS_DATE_REC IS TABLE OF C_POS_DATE%ROWTYPE INDEX BY PLS_INTEGER;
          POS_DATE_TBL    POS_DATE_REC;

          --************************
          --** Constant Declarations
          --************************
          --

          ct_ProcOrFuncName               CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'update_worker_start_date_proc';
          gcn_ApplicationErrorNumber      CONSTANT NUMBER := -20000;
          --
          --************************
          --** Variable Declarations
          --************************
          --

          ct_Phase                        xxmx_module_messages.phase%TYPE              := 'TRANSFORM';
          --
          --*************************
          --** Exception Declarations
          --*************************
          --

          --
     --** END Declarations **
     --

    BEGIN

       gvv_ProgressIndicator := '0010';
       --gvv_category_code :='LE_BU';
       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||') initiated.'
            ,pt_i_OracleError       => NULL
            );
       --
     OPEN C_POS_DATE;
     FETCH C_POS_DATE BULK COLLECT INTO POS_DATE_TBL;

-- Updating  xxmx_per_people_f_xfm
     FORALL I IN 1..POS_DATE_TBL.COUNT
         UPDATE xxmx_per_people_f_xfm PF
            SET PF.START_DATE = NVL(POS_DATE_TBL(I).DATE_START,PF.START_DATE)
		  WHERE PF.PERSON_ID = POS_DATE_TBL(I).PERSON_ID
            AND PF.MIGRATION_SET_ID = pt_i_MigrationSetID;

-- Updating XXMX_PER_PERSONS_xfm
     FORALL I IN 1..POS_DATE_TBL.COUNT
         UPDATE XXMX_PER_PERSONS_XFM PP
            SET PP.START_DATE = NVL(POS_DATE_TBL(I).DATE_START,PP.START_DATE)
		  WHERE PP.PERSON_ID = POS_DATE_TBL(I).PERSON_ID
            AND PP.MIGRATION_SET_ID = pt_i_MigrationSetID;
    COMMIT;
  CLOSE C_POS_DATE;

     UPDATE XXMX_PER_RELIGION_xfm PR
	    SET PR.EFFECTIVESTARTDATE = NVL((SELECT DATE_START FROM per_periods_of_service@xxmx_extract 
		                                  WHERE PERSON_ID = PR.PERSONID 
                                            AND actual_termination_date is null),PR.EFFECTIVESTARTDATE);

   gvv_ProgressIndicator := '0030';
       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||':End of Worker Start Date Transform at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
            ,pt_i_OracleError       => NULL
            );

        COMMIT ;
        pv_o_ReturnStatus :='S';
        EXCEPTION
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         --,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
                                                        ||gcv_PackageName
                                                        ||'.'
                                                        ||ct_ProcOrFuncName
                                                        ||'-'
                                                        ||gvv_ProgressIndicator
                                                        ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                         ,1
                                                         ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --       

    END update_worker_start_date_proc;
------------------------------------------------------------------------------

-------------------------------------------------------------------------------
/* *************************************
     ** PROCEDURE: INSERT_POSITION_LE_TAB
     *************************************      */

    /*PROCEDURE INSERT_POSITION_LE_TAB(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    )
    IS

          --************************
          --** Constant Declarations
          --************************
          --

          ct_ProcOrFuncName               CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'INSERT_POSITION_LE_TAB';
          gcn_ApplicationErrorNumber      CONSTANT NUMBER := -20000;
          --
          --************************
          --** Variable Declarations
          --************************
          --

          ct_Phase                        xxmx_module_messages.phase%TYPE              := 'TRANSFORM';
          --
          --*************************
          --** Exception Declarations
          --*************************
          --

          --
     --** END Declarations **
     --

    BEGIN

       gvv_ProgressIndicator := '0010';
       --gvv_category_code :='LE_BU';
       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||') initiated.'
            ,pt_i_OracleError       => NULL
            );
       --
	   DELETE FROM xxmx_hcm_position_le_bu_tab;
	   COMMIT;

	   INSERT INTO xxmx_hcm_position_le_bu_tab SELECT * FROM xxmx_hcm_position_le_bu_v;
	   COMMIT;

   gvv_ProgressIndicator := '0030';
       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||':End of Insert Position LE Data at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
            ,pt_i_OracleError       => NULL
            );

        COMMIT ;
        pv_o_ReturnStatus :='S';
        EXCEPTION
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         --,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
                                                        ||gcv_PackageName
                                                        ||'.'
                                                        ||ct_ProcOrFuncName
                                                        ||'-'
                                                        ||gvv_ProgressIndicator
                                                        ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                         ,1
                                                         ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --       

    END INSERT_POSITION_LE_TAB; */
-----------------------------------------------------------------
/* *************************************
     ** PROCEDURE: update_term_reason_codes_prc
     *************************************      */

    PROCEDURE update_term_reason_codes_prc(                     
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    )
    IS

          --************************
          --** Constant Declarations
          --************************
          --

          ct_ProcOrFuncName               CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'update_term_reason_codes_prc';
          gcn_ApplicationErrorNumber      CONSTANT NUMBER := -20000;
          --
          --************************
          --** Variable Declarations
          --************************
          --

          ct_Phase                        xxmx_module_messages.phase%TYPE              := 'TRANSFORM';
          --
          --*************************
          --** Exception Declarations
          --*************************
          --

          --
     --** END Declarations **
     --

    BEGIN

       gvv_ProgressIndicator := '0010';
       --gvv_category_code :='LE_BU';
       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||') initiated.'
            ,pt_i_OracleError       => NULL
            );

-- Updating  xxmx_per_people_f_xfm
     UPDATE XXMX_PER_ASSIGNMENTS_M_XFM
	    SET ASS_ATTRIBUTE31 = DECODE(REASON_CODE,'INVOLCI','CITCO_REDUNDANCY_SEVERANCE'
                                            ,'D','CITCO_DECEASED'
                                            ,'INVOLCOC','CITCO_END_OF_CONTRACT'
                                            ,'G','CITCO_GROSS_MISCONDUCT'
                                            ,'INVOLWPR','CITCO_WORK_PERM_RESTRICTIONS'
											,'VOLWC','CITCO_COMPANY_CULTURE'
                                            ,'VOLCJS','CITCO_CONCERN_JOB_SECURITY'
                                            ,'VOLEXWKL','CITCO_WORKLOAD_OVERTIME'
                                            ,'VOLLAR','CITCO_LACK_APPRECIATION_RECOGN'
                                            ,'VOLLOC','CITCO_LACK_OPEN_COMMUNICATION'
                                            ,'VOLLOD','CITCO_PERS_PROF_DEVELOPMENT'
                                            ,'VOLPERS','CITCO_PERS_FAMILY_REASONS'
                                            ,'VOLNODIS','CITCO_PREFER_NOT_DISCLOSE'
                                            ,'VOLREL','CITCO_RELATIONSHIP_MGR'
                                            ,'VOLRELOC','CITCO_RELOCATION'
                                            ,'VOLSAL','CITCO_SALARY_COMP'
                                            ,'VOLJOB','CITCO_JOB_ITSELF'
											,NULL)
     WHERE ACTION_CODE = 'TERMINATION';
COMMIT;
		
   gvv_ProgressIndicator := '0030';
       --
       xxmx_utilities_pkg.log_module_message
            (
             pt_i_ApplicationSuite  => pt_i_ApplicationSuite
            ,pt_i_Application       => pt_i_Application     
            ,pt_i_BusinessEntity    => pt_i_BusinessEntity
            ,pt_i_SubEntity         => 'ALL'
            ,pt_i_MigrationSetID    => pt_i_MigrationSetID
            ,pt_i_Phase             => ct_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gcv_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                     ||gcv_PackageName
                                     ||'.'
                                     ||ct_ProcOrFuncName
                                     ||':End of Termination Reason Code .Transform at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
            ,pt_i_OracleError       => NULL
            );

        COMMIT ;
        pv_o_ReturnStatus :='S';
        EXCEPTION
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         --,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
                                                        ||gcv_PackageName
                                                        ||'.'
                                                        ||ct_ProcOrFuncName
                                                        ||'-'
                                                        ||gvv_ProgressIndicator
                                                        ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                         ,1
                                                         ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --       

    END update_term_reason_codes_prc;
-----------------------------------------------------
END xxmx_hcm_person_ext_pkg;

/
