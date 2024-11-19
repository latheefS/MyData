--------------------------------------------------------
--  DDL for Package Body XXMX_PPM_PROJECTS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_PPM_PROJECTS_PKG" AS
--*****************************************************************************
--**
--**                 Copyright (c) 2020 Version 1
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
--** FILENAME  :  xxmx_ppm_projects_pkg.pkb
--** 
--** FILEPATH  :  $XXV1_TOP/install/sql
--** 
--** VERSION   :  1.0
--**
--** EXECUTE 
--** IN SCHEMA :  XXMX_CORE 
--**
--** AUTHORS   :  Shaik Latheef
--**
--** PURPOSE   :  This package contains procedures for extracting Projects into Staging tables
--***************************************************************************************************
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  14-MAR-2022   Dhanu Gundala      Created for Citco.
--***************************************************************************************************

    gvv_ReturnStatus                          VARCHAR2(1);
    gvt_ReturnMessage                         xxmx_module_messages.module_message%TYPE;
    gvv_ProgressIndicator                     VARCHAR2(100);
    gcv_PackageName                           CONSTANT  VARCHAR2(30)                                := 'XXMX_PA_PROJECTS_PKG';
    gct_ApplicationSuite                      CONSTANT  xxmx_module_messages.application_suite%TYPE:= 'PPM';
    gct_Application                           CONSTANT  xxmx_module_messages.application%TYPE      := 'PPM';
    gv_i_BusinessEntity                       CONSTANT  VARCHAR2(100)                               := 'PROJECTS';
    gvt_migrationsetname                                VARCHAR2(100);
    ct_Phase                                  CONSTANT  xxmx_module_messages.phase%TYPE            := 'EXTRACT';
    cv_i_BusinessEntityLevel                  CONSTANT  VARCHAR2(100)                               := 'ALL';
    g_batch_name                              CONSTANT  VARCHAR2(300) := 'Projects_'||to_char(SYSDATE,'DDMMYYYYHHMISS') ;
    gv_hr_date                                DATE := '31-DEC-4712';
    gct_stgschema                                       VARCHAR2(10)                                := 'XXMX_STG';

    gvt_Severity                              xxmx_module_messages.severity%TYPE;
    gvt_ModuleMessage                         xxmx_module_messages.module_message%TYPE;
    gvt_OracleError                           xxmx_module_messages.oracle_error%TYPE;

    e_moduleerror                             EXCEPTION;
    e_dateerror                               EXCEPTION;
    gvv_migration_date                        VARCHAR2(30) := '31-MAR-2024';
    gvd_migration_date                        DATE;
    gvn_RowCount                              NUMBER;


	/****************************************************************
	----------------Stg_main Procedure-------------------------------
	*****************************************************************/
   PROCEDURE stg_main (pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                      ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE )
   IS

        CURSOR metadata_cur
        IS
         SELECT  Entity_package_name
                ,Stg_procedure_name
                ,business_entity
                ,sub_entity_seq
                ,sub_entity
         FROM     xxmx_migration_metadata a
         WHERE application_suite = gct_ApplicationSuite
         AND   Application = gct_Application
         AND   business_entity = gv_i_BusinessEntity
         AND   a.enabled_flag = 'Y'
         ORDER
         BY  Business_entity_seq,
             sub_entity_seq;

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'stg_main';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PROJECTS';
        vt_MigrationSetID                               xxmx_migration_headers.migration_set_id%TYPE;
        lv_sql                                          VARCHAR2(32000);
   BEGIN
   -- setup
        --
        gvv_ReturnStatus  := '';
        gvv_ProgressIndicator := '0000';
        xxmx_utilities_pkg.clear_messages
            (
            pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'MODULE'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        --
        IF   gvv_ReturnStatus = 'F'
        THEN
            --
            xxmx_utilities_pkg.log_module_message(
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError         => gvt_ReturnMessage
            );
            --
            RAISE e_ModuleError;
            --
        END IF;
        --
        --
        gvv_ProgressIndicator := '0010';
        -- Migration Set ID Generation
      /*  xxmx_utilities_pkg.init_migration_set
         (
         pt_i_ApplicationSuite  => gct_ApplicationSuite
         ,pt_i_Application       => gct_Application
         ,pt_i_BusinessEntity    => gv_i_BusinessEntity
         ,pt_i_MigrationSetName  => pt_i_MigrationSetName
         ,pt_o_MigrationSetID    => vt_MigrationSetID
         );*/

         --
        gvv_ProgressIndicator :='0015';
        xxmx_utilities_pkg.log_module_message(
                         pt_i_ApplicationSuite    => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => 'Migration Set "'
                                                   ||pt_i_MigrationSetName
                                                   ||'" initialized (Generated Migration Set ID = '
                                                   ||vt_MigrationSetID
                                                   ||').  Processing extracts:'       ,
                         pt_i_OracleError         => NULL
         );
        --
        --
        --main


        gvv_ProgressIndicator := '0020';
        xxmx_utilities_pkg.log_module_message(
            pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => 'Extract for Projects Started',
             pt_i_OracleError         => NULL
        );

        FOR METADATA_REC IN METADATA_CUR -- 2
        LOOP

--                dbms_output.put_line(' #' ||r_package_name.v_package ||' #'|| l_bg_name || '  #' || l_bg_id || '  #' || vt_MigrationSetID || '  #' || pt_i_MigrationSetName  );

                    lv_sql:= 'BEGIN '
                            ||METADATA_REC.Entity_package_name
                            ||'.'||METADATA_REC.Stg_procedure_name
                            ||'('
                            ||vt_MigrationSetID
                            ||','''
                            ||METADATA_REC.sub_entity
                            ||''''||'); END;'
                            ;

                    EXECUTE IMMEDIATE lv_sql ;

                    gvv_ProgressIndicator := '0030';
                    xxmx_utilities_pkg.log_module_message(
                        pt_i_ApplicationSuite    => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => 'Extract call for Projects -'|| lv_sql       ,
                         pt_i_OracleError         => NULL
                     );
                    DBMS_OUTPUT.PUT_LINE(lv_sql);

        END LOOP;

          gvv_ProgressIndicator := '0035';
         xxmx_utilities_pkg.log_module_message(
         pt_i_ApplicationSuite    => gct_ApplicationSuite
         ,pt_i_Application         => gct_Application
         ,pt_i_BusinessEntity      => gv_i_BusinessEntity
         ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
         ,pt_i_Phase               => ct_Phase
         ,pt_i_Severity            => 'NOTIFICATION'
         ,pt_i_PackageName         => gcv_PackageName
         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
         ,pt_i_ModuleMessage       => 'Extracts for Prjects Completed'
         ,pt_i_OracleError         => NULL
         );
    EXCEPTION
        WHEN e_ModuleError THEN
                --
        xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage
                    ,pt_i_OracleError         => gvt_ReturnMessage       );
            --
            RAISE;
            --** END e_ModuleError Exception
            --

        WHEN OTHERS THEN
            --
            ROLLBACK;
            --
            gvt_OracleError := SUBSTR(
                                        SQLERRM
                                    ||'** ERROR_BACKTRACE: '
                                    ||dbms_utility.format_error_backtrace
                                    ,1
                                    ,4000
                                    );
            --
            xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                    ,pt_i_OracleError         => gvt_OracleError       );
            --
            RAISE;
            -- Hr_Utility.raise_error@xxmx_extract;

   END stg_main;
   /*********************************************************
   --------------------src_pa_projects-----------------------
   -- Extracts Projects information from EBS
   ----------------------------------------------------------
   **********************************************************/

PROCEDURE src_pa_projects
                     (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
                     ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
AS
    --
    --**********************
    --** Cursor Declarations
    --**********************
    --
    CURSOR src_pa_projects_cur IS
        SELECT
             REGEXP_REPLACE(ppa.name, '[^[:print:]]','')                        as project_name
            ,REGEXP_REPLACE(ppa.long_name, '[^[:print:]]','')                   as project_long_name
            ,ppa.segment1                                                       as project_number
            ,ppa.source_template_number                                         as source_template_number
            ,null                                                               as source_template_name
            ,null                                                               as source_application_code
			,null                                                               as source_project_reference
            ,null                                                               as schedule_name
            ,null                                                               as eps_name
            ,null                                                               as project_plan_view_access
            ,null                                                               as schedule_type
            ,ppa.organization_name                                              as organization_name 
            ,ppa.legal_entity_name                                              as legal_entity_name
            ,REGEXP_REPLACE(ppa.description, '[^[:print:]]','')                 as description
            ,null                                                               as project_manager_number
            ,null                                                               as project_manager_name 
            ,null                                                               as project_manager_email
            ,ppa.start_date                                                     as project_start_date			  
           /* ,case 
                when project_type like '%Contract%' then to_date('31-DEC-2050','DD-MON-YYYY')
                else ppa.completion_date
             end                                                                as project_finish_date*/
            , ppa.completion_date       as project_finish_date
            ,ppa.closed_date                                                    as closed_date
            ,''                                                                 as prj_plan_baseline_name
            ,''                                                                 as prj_plan_baseline_desc
            ,''                                                                 as prj_plan_baseline_date
            ,ppa.project_status_name                                            as project_status_name
            ,NULL                                                               as project_priority_code
            ,''                                                                 as outline_display_level
            ,''                                                                 as planning_project_flag
            ,''                                                                 as service_type_code
            ,NULL  																as work_type_name
            ,ppa.limit_to_txn_controls_flag                                     as limit_to_txn_controls_code
            ,''                                                                 as budgetary_control_flag
            ,ppa.project_currency_code                                          as project_currency_code
            ,ppa.project_rate_type                                              as currency_conv_rate_type
            ,ppa.project_bil_rate_date_code                                     as currency_conv_date_type_code
            ,ppa.project_bil_rate_date                                          as currency_conv_date
            ,null                                                               as cint_eligible_flag
            ,null                                                               as cint_rate_sch_name
            ,null                                                               as cint_stop_date
            ,''                                                                 as asset_allocation_method_code
            ,''                                                                 as capital_event_processing_code
            ,null                                                               as allow_cross_charge_flag
            ,null                                                               as cc_process_labor_flag
            ,''                                                                 as labor_tp_schedule_name
            ,null                                                               as labor_tp_fixed_date
            ,null                                                               as cc_process_nl_flag
            ,''                                                                 as nl_tp_schedule_name
            ,null                                                               as nl_tp_fixed_date
            ,''                                                                 as burden_schedule_name
            ,''                                                                 as burden_sch_fixed_dated
            ,''                                                                 as kpi_notification_enabled
            ,''                                                                 as kpi_notification_recipientS
            ,''                                                                 as kpi_notification_include_nOTES
            ,''                                                                 as copy_team_members_flag
            ,''                                                                 as copy_project_classes_flag
            ,''                                                                 as copy_attachments_flag
            ,''                                                                 as copy_dff_flag
            ,''                                                                 as copy_tasks_flag
            ,''                                                                 as copy_task_attachments_flag
            ,''                                                                 as copy_task_dff_flag
            ,''                                                                 as copy_task_assignments_flag
            ,''                                                                 as copy_transaction_controls_FLAG
            ,''                                                                 as copy_assets_flag
            ,''                                                                 as copy_asset_assignments_flaG
            ,''                                                                 as copy_cost_overrides_flag
            ,''                                                                 as opportunity_id
            ,''                                                                 as opportunity_number
            ,''                                                                 as opportunity_customer_number
            ,''                                                                 as opportunity_customer_id
            ,''                                                                 as opportunity_amt
            ,''                                                                 as opportunity_currcode
            ,''                                                                 as opportunity_win_conf_perceNT
            ,''                                                                 as opportunity_name
            ,''                                                                 as opportunity_desc
            ,''                                                                 as opportunity_customer_name
            ,''                                                                 as opportunity_status
            ,null                                                               as attribute_category
            ,(select max(ppc.customer_number)
                                   from   pa_project_customers_v@xxmx_extract ppc,
                                          pa_agreements_all@xxmx_extract      a,
                                          pa_project_fundings@xxmx_extract    f
                                   where  a.agreement_id = f.agreement_id
                                   and    f.project_id = ppc.project_id
                                   and    f.project_id = ppa.project_id)        as attribute1
            ,(select max(t.name)
                                   from   pa_project_customers_v@xxmx_extract ppc,
                                          pa_agreements_all@xxmx_extract      a,
                                          pa_project_fundings@xxmx_extract    f,
                                          ra_terms@xxmx_extract               t
                                   where  a.agreement_id = f.agreement_id
                                   and    a.term_id = t.term_id
                                   and    f.project_id = ppc.project_id
                                   and    f.project_id = ppa.project_id)        as attribute2
            ,(select 'Y'
                from 
                    pa_billing_assignments_all@xxmx_extract paba,
                    pa_billing_extensions@xxmx_extract      pabe
                where paba.BILLING_EXTENSION_ID = pabe.BILLING_EXTENSION_ID
                and   pabe.name                 = 'Citco Sundry Charges'
                and   paba.active_flag          = 'Y'
                and   paba.project_id           = ppa.project_id )              as attribute3
            ,null                                                               as attribute4
            ,null                                                               as attribute5
            ,null                                                               as attribute6
            ,null                                                               as attribute7
            ,null                                                               as attribute8
            ,null                                                               as attribute9
            ,null                                                               as attribute10
              --,REGEXP_REPLACE(ppa.name, '[^[:print:]]','')                                          attribute11
            ,''                                                                             attribute11
            ,''                                                                             attribute12 
            ,''                                                                             attribute13
            ,''                                                                             attribute14
            ,''                                                                             attribute15
            ,''                                                                             attribute16
            ,''                                                                             attribute17
            ,''                                                                             attribute18
            ,''                                                                             attribute19
            ,''                                                                             attribute20
            ,''                                                                             attribute21
            ,''                                                                             attribute22
            ,''                                                                             attribute23
            ,''                                                                             attribute24
            ,''                                                                             attribute25
            ,''                                                                             attribute26
            ,''                                                                             attribute27
            ,''                                                                             attribute28
            ,''                                                                             attribute29
            ,''                                                                             attribute30
            ,''                                                                             attribute31
            ,''                                                                             attribute32
            ,''                                                                             attribute33
            ,''                                                                             attribute34
            ,''                                                                             attribute35
            ,''                                                                             attribute36
            ,''                                                                             attribute37
            ,''                                                                             attribute38
            ,''                                                                             attribute39
            ,''                                                                             attribute40
            ,''                                                                             attribute41
            ,''                                                                             attribute42
            ,''                                                                             attribute43
            ,''                                                                             attribute44
            ,''                                                                             attribute45
            ,''                                                                             attribute46
            ,''                                                                             attribute47
            ,''                                                                             attribute48
            ,''                                                                             attribute49
            ,''                                                                             attribute50
            ,ppa.attribute2                                                   as attribute1_number
            ,''                                                                             attribute2_number
            ,''                                                                             attribute3_number
            ,''                                                                             attribute4_number
            ,''                                                                             attribute5_number
            ,''                                                                             attribute6_number
            ,''                                                                             attribute7_number
            ,''                                                                             attribute8_number
            ,''                                                                             attribute9_number
            ,''                                                                             attribute10_number
            ,''                                                                             attribute11_number
            ,''                                                                             attribute12_number
            ,''                                                                             attribute13_number
            ,''                                                                             attribute14_number
            ,''                                                                             attribute15_number
            ,''                                                                             attribute1_date
            ,''                                                                             attribute2_date
            ,''                                                                             attribute3_date
            ,''                                                                             attribute4_date
            ,''                                                                             attribute5_date
            ,''                                                                             attribute6_date
            ,''                                                                             attribute7_date
            ,''                                                                             attribute8_date
            ,''                                                                             attribute9_date
            ,''                                                                             attribute10_date
            ,''                                                                             attribute11_date
            ,''                                                                             attribute12_date
            ,''                                                                             attribute13_date
            ,''                                                                             attribute14_date 
            ,''                                                                             attribute15_date
            ,''                                                                             copy_group_space_flag
            ,ppa.proj_owning_org                                                as proj_owning_org
            ,ppa.project_id                                                     as project_id
        FROM
            XXMX_CORE.XXMX_PPM_PROJECTS_SCOPE_MV           ppa
        WHERE nvl(ppa.template_flag,'N') != 'Y' 
        ;
    --
    --**********************
    --** Record Declarations 
    --**********************
    --
    TYPE src_pa_projects_tbl IS TABLE OF src_pa_projects_cur%ROWTYPE INDEX BY BINARY_INTEGER;
    src_pa_projects_tb  src_pa_projects_tbl;
    --
    --************************
    --** Constant Declarations
    --************************
    --
    cv_ProcOrFuncName                   CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'src_pa_projects';
    cv_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
    cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PPM_PROJECTS_STG';
    cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PROJECTS';
    --
    --************************
    --** Variable Declarations
    --************************
    --
    --
    --*************************
    --** Exception Declarations
    --*************************
    --
    e_ModuleError                         EXCEPTION;
    e_DateError                           EXCEPTION;
    ex_dml_errors                         EXCEPTION;
    PRAGMA EXCEPTION_INIT(ex_dml_errors, -24381);
    l_error_count             NUMBER;
    --
    --** END Declarations **
    --
    -- Local Type Variables
BEGIN
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0000';
        xxmx_utilities_pkg.clear_messages
            (
            pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'MODULE'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        --
        IF   gvv_ReturnStatus = 'F'
        THEN
            xxmx_utilities_pkg.log_module_message(
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'ERROR'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                ,pt_i_OracleError         => gvt_ReturnMessage    );
            --
            RAISE e_ModuleError;
        END IF;
        --
    gvv_ProgressIndicator := '0010';
    xxmx_utilities_pkg.log_module_message(
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'Deleting from "' || cv_StagingTable   || '".'
                ,pt_i_OracleError         => gvt_ReturnMessage  );
    --
    DELETE FROM xxmx_ppm_projects_stg ;
    COMMIT;
    --
    gvv_ProgressIndicator := '0020';
    gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
        --
        --
        -- If the Migration Set Name is NULL then the Migration has not been initialized.
        --
        --
    IF  gvt_MigrationSetName IS NOT NULL THEN
        --
        gvv_ProgressIndicator := '0030';
        xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => 'Extracting "'||pt_i_SubEntity||'":'
                 ,pt_i_OracleError       => NULL
                 );
        --
        --
        -- The Migration Set has been initialised, so now initialize the detail record
        -- for the current entity.
        --
      /*  xxmx_utilities_pkg.init_migration_details
                 (
                  pt_i_ApplicationSuite => gct_ApplicationSuite
                 ,pt_i_Application      => gct_Application
                 ,pt_i_BusinessEntity   => gv_i_BusinessEntity
                 ,pt_i_SubEntity        => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                 ,pt_i_StagingTable     => cv_StagingTable
                 ,pt_i_ExtractStartDate => SYSDATE
                 );*/
        --
        --
        xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => 'Staging Table "'||cv_StagingTable||'" reporting details initialised.'
                 ,pt_i_OracleError       => NULL
                 );
        --
        -- Extract the Projects and insert into the staging table.
        --
        gvv_ProgressIndicator := '0040';
        xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '  - Extracting data into "'
                                          ||cv_StagingTable
                                          ||'".'
                 ,pt_i_OracleError       => NULL
                 );
    --
    OPEN src_pa_projects_cur;
    --
    gvv_ProgressIndicator := '0050';
    xxmx_utilities_pkg.log_module_message(
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       =>'Cursor Open src_pa_projects_cur'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );
    --
    LOOP
        --
        FETCH src_pa_projects_cur  BULK COLLECT INTO src_pa_projects_tb LIMIT 1000;
        --
        gvv_ProgressIndicator := '0070';
        xxmx_utilities_pkg.log_module_message(
                        pt_i_ApplicationSuite    => gct_ApplicationSuite
                       ,pt_i_Application         => gct_Application
                       ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                       ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                       ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                       ,pt_i_Phase               => ct_Phase
                       ,pt_i_Severity            => 'NOTIFICATION'
                       ,pt_i_PackageName         => gcv_PackageName
                       ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                       ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                       ,pt_i_ModuleMessage       => 'Cursor: src_pa_projects_cur fetch project_details'
                       ,pt_i_OracleError         => gvt_ReturnMessage  );
        --
        EXIT WHEN src_pa_projects_tb.COUNT=0;
        --
        FORALL I IN 1..src_pa_projects_tb.COUNT SAVE EXCEPTIONS
        --
        INSERT INTO xxmx_ppm_projects_stg (
                                    migration_set_id
                                    ,migration_status
                                    ,migration_set_name
                                    ,project_name
                                    ,project_long_name
                                    ,project_number
                                    ,source_template_number
                                    ,source_template_name
                                    ,source_application_code
                                    ,source_project_reference
                                    ,schedule_name
                                    ,eps_name
                                    ,project_plan_view_access
                                    ,schedule_type
                                    ,organization_name
                                    ,legal_entity_name
                                    ,description
                                    ,project_manager_number
                                    ,project_manager_name
                                    ,project_manager_email
                                    ,project_start_date
                                    ,project_finish_date
                                    ,closed_date
                                    ,prj_plan_baseline_name
                                    ,prj_plan_baseline_desc
                                    ,prj_plan_baseline_date
                                    ,project_status_name
                                    ,project_priority_code
                                    ,outline_display_level
                                    ,planning_project_flag
                                    ,service_type_code
                                    ,work_type_name
                                    ,limit_to_txn_controls_code
                                    ,budgetary_control_flag
                                    ,project_currency_code
                                    ,currency_conv_rate_type
                                    ,currency_conv_date_type_code
                                    ,currency_conv_date
                                    ,cint_eligible_flag
                                    ,cint_rate_sch_name
                                    ,cint_stop_date
                                    ,asset_allocation_method_code
                                    ,capital_event_processing_code
                                    ,allow_cross_charge_flag
                                    ,cc_process_labor_flag
                                    ,labor_tp_schedule_name
                                    ,labor_tp_fixed_date
                                    ,cc_process_nl_flag
                                    ,nl_tp_schedule_name
                                    ,nl_tp_fixed_date
                                    ,burden_schedule_name
                                    ,burden_sch_fixed_dated
                                    ,kpi_notification_enabled
                                    ,kpi_notification_recipients
                                    ,kpi_notification_include_notes
                                    ,copy_team_members_flag
                                    ,copy_project_classes_flag
                                    ,copy_attachments_flag
                                    ,copy_dff_flag
                                    ,copy_tasks_flag
                                    ,copy_task_attachments_flag
                                    ,copy_task_dff_flag
                                    ,copy_task_assignments_flag
                                    ,copy_transaction_controls_flag
                                    ,copy_assets_flag
                                    ,copy_asset_assignments_flag
                                    ,copy_cost_overrides_flag
                                    ,opportunity_id
                                    ,opportunity_number
                                    ,opportunity_customer_number
                                    ,opportunity_customer_id
                                    ,opportunity_amt
                                    ,opportunity_currcode
                                    ,opportunity_win_conf_percent
                                    ,opportunity_name
                                    ,opportunity_desc
                                    ,opportunity_customer_name
                                    ,opportunity_status
                                    ,attribute_category
                                    ,attribute1
                                    ,attribute2
                                    ,attribute3
                                    ,attribute4
                                    ,attribute5
                                    ,attribute6
                                    ,attribute7
                                    ,attribute8
                                    ,attribute9
                                    ,attribute10
                                    ,attribute11
                                    ,attribute12
                                    ,attribute13
                                    ,attribute14
                                    ,attribute15
                                    ,attribute16
                                    ,attribute17
                                    ,attribute18
                                    ,attribute19
                                    ,attribute20
                                    ,attribute21
                                    ,attribute22
                                    ,attribute23
                                    ,attribute24
                                    ,attribute25
                                    ,attribute26
                                    ,attribute27
                                    ,attribute28
                                    ,attribute29
                                    ,attribute30
                                    ,attribute31
                                    ,attribute32
                                    ,attribute33
                                    ,attribute34
                                    ,attribute35
                                    ,attribute36
                                    ,attribute37
                                    ,attribute38
                                    ,attribute39
                                    ,attribute40
                                    ,attribute41
                                    ,attribute42
                                    ,attribute43
                                    ,attribute44
                                    ,attribute45
                                    ,attribute46
                                    ,attribute47
                                    ,attribute48
                                    ,attribute49
                                    ,attribute50
                                    ,attribute1_number
                                    ,attribute2_number
                                    ,attribute3_number
                                    ,attribute4_number
                                    ,attribute5_number
                                    ,attribute6_number
                                    ,attribute7_number
                                    ,attribute8_number
                                    ,attribute9_number
                                    ,attribute10_number
                                    ,attribute11_number
                                    ,attribute12_number
                                    ,attribute13_number
                                    ,attribute14_number
                                    ,attribute15_number
                                    ,attribute1_date
                                    ,attribute2_date
                                    ,attribute3_date
                                    ,attribute4_date
                                    ,attribute5_date
                                    ,attribute6_date
                                    ,attribute7_date
                                    ,attribute8_date
                                    ,attribute9_date
                                    ,attribute10_date
                                    ,attribute11_date
                                    ,attribute12_date
                                    ,attribute13_date
                                    ,attribute14_date
                                    ,attribute15_date
                                    ,copy_group_space_flag
                                    ,batch_name
                                    ,created_by
                                    ,creation_date
                                    ,last_updated_by
                                    ,last_update_date
                                    ,batch_id
                                    ,proj_owning_org
                                    ,project_id
                                    --,max_ei_creation_date
                                    --,max_event_creation_date
                             )
            VALUES
                           (
                            pt_i_MigrationSetID
                           ,'EXTRACTED'
                           ,gvt_MigrationSetName
                           ,src_pa_projects_tb(i).project_name                          --project_name
                           ,src_pa_projects_tb(i).project_long_name                     --project_name
                           ,src_pa_projects_tb(i).project_number                        --project_number
                           ,src_pa_projects_tb(i).source_template_number                --source_template_number
                           ,src_pa_projects_tb(i).source_template_name                  --source_template_name
                           ,src_pa_projects_tb(i).source_application_code               --source_application_code
                           ,src_pa_projects_tb(i).source_project_reference              --source_project_reference
                           ,src_pa_projects_tb(i).schedule_name                         --schedule_name
                           ,src_pa_projects_tb(i).eps_name                              --eps_name
                           ,src_pa_projects_tb(i).project_plan_view_access              --project_plan_view_access
                           ,src_pa_projects_tb(i).schedule_type                         --schedule_type
                           ,src_pa_projects_tb(i).organization_name                     --organization_name
                           ,src_pa_projects_tb(i).legal_entity_name                     --legal_entity_name
                           ,src_pa_projects_tb(i).description                           --description
                           ,src_pa_projects_tb(i).project_manager_number                --project_manager_number
                           ,src_pa_projects_tb(i).project_manager_name                  --project_manager_name
                           ,src_pa_projects_tb(i).project_manager_email                 --project_manager_email
                           ,src_pa_projects_tb(i).project_start_date                    --project_start_date
                           ,src_pa_projects_tb(i).project_finish_date                   --project_finish_date
                           ,src_pa_projects_tb(i).closed_date                           --closed_date
                           ,src_pa_projects_tb(i).prj_plan_baseline_name                --prj_plan_baseline_name
                           ,src_pa_projects_tb(i).prj_plan_baseline_desc                --prj_plan_baseline_desc
                           ,src_pa_projects_tb(i).prj_plan_baseline_date                --prj_plan_baseline_date
                           ,src_pa_projects_tb(i).project_status_name                   --project_status_name
                           ,src_pa_projects_tb(i).project_priority_code                 --project_priority_code
                           ,src_pa_projects_tb(i).outline_display_level                 --outline_display_level
                           ,src_pa_projects_tb(i).planning_project_flag                 --planning_project_flag
                           ,src_pa_projects_tb(i).service_type_code                     --service_type_code
                           ,src_pa_projects_tb(i).work_type_name                        --work_type_name
                           ,src_pa_projects_tb(i).limit_to_txn_controls_code            --limit_to_txn_controls_code
                           ,src_pa_projects_tb(i).budgetary_control_flag                --budgetary_control_flag
                           ,src_pa_projects_tb(i).project_currency_code                 --project_currency_code
                           ,src_pa_projects_tb(i).currency_conv_rate_type               --currency_conv_rate_type
                           ,src_pa_projects_tb(i).currency_conv_date_type_code          --currency_conv_date_type_code
                           ,src_pa_projects_tb(i).currency_conv_date                    --currency_conv_date
                           ,src_pa_projects_tb(i).cint_eligible_flag                    --cint_eligible_flag
                           ,src_pa_projects_tb(i).cint_rate_sch_name                    --cint_rate_sch_name
                           ,src_pa_projects_tb(i).cint_stop_date                        --cint_stop_date
                           ,src_pa_projects_tb(i).asset_allocation_method_code          --asset_allocation_method_code
                           ,src_pa_projects_tb(i).capital_event_processing_code         --capital_event_processing_code
                           ,src_pa_projects_tb(i).allow_cross_charge_flag               --allow_cross_charge_flag
                           ,src_pa_projects_tb(i).cc_process_labor_flag                 --cc_process_labor_flag
                           ,src_pa_projects_tb(i).labor_tp_schedule_name                --labor_tp_schedule_name
                           ,src_pa_projects_tb(i).labor_tp_fixed_date                   --labor_tp_fixed_date
                           ,src_pa_projects_tb(i).cc_process_nl_flag                    --cc_process_nl_flag
                           ,src_pa_projects_tb(i).nl_tp_schedule_name                   --nl_tp_schedule_name
                           ,src_pa_projects_tb(i).nl_tp_fixed_date                      --nl_tp_fixed_date
                           ,src_pa_projects_tb(i).burden_schedule_name                  --burden_schedule_name
                           ,src_pa_projects_tb(i).burden_sch_fixed_dated                --burden_sch_fixed_dated
                           ,src_pa_projects_tb(i).kpi_notification_enabled              --kpi_notification_enabled
                           ,src_pa_projects_tb(i).kpi_notification_recipients           --kpi_notification_recipients
                           ,src_pa_projects_tb(i).kpi_notification_include_notes        --kpi_notification_include_notes
                           ,src_pa_projects_tb(i).copy_team_members_flag                --copy_team_members_flag
                           ,src_pa_projects_tb(i).copy_project_classes_flag             --copy_project_classes_flag
                           ,src_pa_projects_tb(i).copy_attachments_flag                 --copy_attachments_flag
                           ,src_pa_projects_tb(i).copy_dff_flag                         --copy_dff_flag
                           ,src_pa_projects_tb(i).copy_tasks_flag                       --copy_tasks_flag
                           ,src_pa_projects_tb(i).copy_task_attachments_flag            --copy_task_attachments_flag
                           ,src_pa_projects_tb(i).copy_task_dff_flag                    --copy_task_dff_flag
                           ,src_pa_projects_tb(i).copy_task_assignments_flag            --copy_task_assignments_flag
                           ,src_pa_projects_tb(i).copy_transaction_controls_flag        --copy_transaction_controls_flag
                           ,src_pa_projects_tb(i).copy_assets_flag                      --copy_assets_flag
                           ,src_pa_projects_tb(i).copy_asset_assignments_flag           --copy_asset_assignments_flag
                           ,src_pa_projects_tb(i).copy_cost_overrides_flag              --copy_cost_overrides_flag
                           ,src_pa_projects_tb(i).opportunity_id                        --opportunity_id
                           ,src_pa_projects_tb(i).opportunity_number                    --opportunity_number
                           ,src_pa_projects_tb(i).opportunity_customer_number           --opportunity_customer_number
                           ,src_pa_projects_tb(i).opportunity_customer_id               --opportunity_customer_id
                           ,src_pa_projects_tb(i).opportunity_amt                       --opportunity_amt
                           ,src_pa_projects_tb(i).opportunity_currcode                  --opportunity_currcode
                           ,src_pa_projects_tb(i).opportunity_win_conf_percent          --opportunity_win_conf_percent
                           ,src_pa_projects_tb(i).opportunity_name                      --opportunity_name
                           ,src_pa_projects_tb(i).opportunity_desc                      --opportunity_desc
                           ,src_pa_projects_tb(i).opportunity_customer_name             --opportunity_customer_name
                           ,src_pa_projects_tb(i).opportunity_status                    --opportunity_status
                           ,src_pa_projects_tb(i).attribute_category                    --attribute_category
                           ,src_pa_projects_tb(i).attribute1                            --attribute1
                           ,src_pa_projects_tb(i).attribute2                            --attribute2
                           ,src_pa_projects_tb(i).attribute3                            --attribute3
                           ,src_pa_projects_tb(i).attribute4                            --attribute4
                           ,src_pa_projects_tb(i).attribute5                            --attribute5
                           ,src_pa_projects_tb(i).attribute6                            --attribute6
                           ,src_pa_projects_tb(i).attribute7                            --attribute7
                           ,src_pa_projects_tb(i).attribute8                            --attribute8
                           ,src_pa_projects_tb(i).attribute9                            --attribute9
                           ,src_pa_projects_tb(i).attribute10                           --attribute10
                           ,src_pa_projects_tb(i).attribute11                           --attribute11
                           ,src_pa_projects_tb(i).attribute12                           --attribute12
                           ,src_pa_projects_tb(i).attribute13                           --attribute13
                           ,src_pa_projects_tb(i).attribute14                           --attribute14
                           ,src_pa_projects_tb(i).attribute15                           --attribute15
                           ,src_pa_projects_tb(i).attribute16                           --attribute16
                           ,src_pa_projects_tb(i).attribute17                           --attribute17
                           ,src_pa_projects_tb(i).attribute18                           --attribute18
                           ,src_pa_projects_tb(i).attribute19                           --attribute19
                           ,src_pa_projects_tb(i).attribute20                           --attribute20
                           ,src_pa_projects_tb(i).attribute21                           --attribute21
                           ,src_pa_projects_tb(i).attribute22                           --attribute22
                           ,src_pa_projects_tb(i).attribute23                           --attribute23
                           ,src_pa_projects_tb(i).attribute24                           --attribute24
                           ,src_pa_projects_tb(i).attribute25                           --attribute25
                           ,src_pa_projects_tb(i).attribute26                           --attribute26
                           ,src_pa_projects_tb(i).attribute27                           --attribute27
                           ,src_pa_projects_tb(i).attribute28                           --attribute28
                           ,src_pa_projects_tb(i).attribute29                           --attribute29
                           ,src_pa_projects_tb(i).attribute30                           --attribute30
                           ,src_pa_projects_tb(i).attribute31                           --attribute31
                           ,src_pa_projects_tb(i).attribute32                           --attribute32
                           ,src_pa_projects_tb(i).attribute33                           --attribute33
                           ,src_pa_projects_tb(i).attribute34                           --attribute34
                           ,src_pa_projects_tb(i).attribute35                           --attribute35
                           ,src_pa_projects_tb(i).attribute36                           --attribute36
                           ,src_pa_projects_tb(i).attribute37                           --attribute37
                           ,src_pa_projects_tb(i).attribute38                           --attribute38
                           ,src_pa_projects_tb(i).attribute39                           --attribute39
                           ,src_pa_projects_tb(i).attribute40                           --attribute40
                           ,src_pa_projects_tb(i).attribute41                           --attribute41
                           ,src_pa_projects_tb(i).attribute42                           --attribute42
                           ,src_pa_projects_tb(i).attribute43                           --attribute43
                           ,src_pa_projects_tb(i).attribute44                           --attribute44
                           ,src_pa_projects_tb(i).attribute45                           --attribute45
                           ,src_pa_projects_tb(i).attribute46                           --attribute46
                           ,src_pa_projects_tb(i).attribute47                           --attribute47
                           ,src_pa_projects_tb(i).attribute48                           --attribute48
                           ,src_pa_projects_tb(i).attribute49                           --attribute49
                           ,src_pa_projects_tb(i).attribute50                           --attribute50
                           ,src_pa_projects_tb(i).attribute1_number                     --attribute1_number
                           ,src_pa_projects_tb(i).attribute2_number                     --attribute2_number
                           ,src_pa_projects_tb(i).attribute3_number                     --attribute3_number
                           ,src_pa_projects_tb(i).attribute4_number                     --attribute4_number
                           ,src_pa_projects_tb(i).attribute5_number                     --attribute5_number
                           ,src_pa_projects_tb(i).attribute6_number                     --attribute6_number
                           ,src_pa_projects_tb(i).attribute7_number                     --attribute7_number
                           ,src_pa_projects_tb(i).attribute8_number                     --attribute8_number
                           ,src_pa_projects_tb(i).attribute9_number                     --attribute9_number
                           ,src_pa_projects_tb(i).attribute10_number                    --attribute10_number
                           ,src_pa_projects_tb(i).attribute11_number                    --attribute11_number
                           ,src_pa_projects_tb(i).attribute12_number                    --attribute12_number
                           ,src_pa_projects_tb(i).attribute13_number                    --attribute13_number
                           ,src_pa_projects_tb(i).attribute14_number                    --attribute14_number
                           ,src_pa_projects_tb(i).attribute15_number                    --attribute15_number
                           ,src_pa_projects_tb(i).attribute1_date                       --attribute1_date
                           ,src_pa_projects_tb(i).attribute2_date                       --attribute2_date
                           ,src_pa_projects_tb(i).attribute3_date                       --attribute3_date
                           ,src_pa_projects_tb(i).attribute4_date                       --attribute4_date
                           ,src_pa_projects_tb(i).attribute5_date                       --attribute5_date
                           ,src_pa_projects_tb(i).attribute6_date                       --attribute6_date
                           ,src_pa_projects_tb(i).attribute7_date                       --attribute7_date
                           ,src_pa_projects_tb(i).attribute8_date                       --attribute8_date
                           ,src_pa_projects_tb(i).attribute9_date                       --attribute9_date
                           ,src_pa_projects_tb(i).attribute10_date                      --attribute10_date
                           ,src_pa_projects_tb(i).attribute11_date                      --attribute11_date
                           ,src_pa_projects_tb(i).attribute12_date                      --attribute12_date
                           ,src_pa_projects_tb(i).attribute13_date                      --attribute13_date
                           ,src_pa_projects_tb(i).attribute14_date                      --attribute14_date
                           ,src_pa_projects_tb(i).attribute15_date                      --attribute15_date
                           ,src_pa_projects_tb(i).copy_group_space_flag                 --copy_group_space_flag
                           ,g_batch_name                                                -- src_pa_projects_tb(i).batch_name                            --batch_name
                           ,xxmx_utilities_pkg.gvv_UserName                             -- src_pa_projects_tb(i).created_by                            --created_by
                           ,SYSDATE                                                     -- src_pa_projects_tb(i).creation_date                         --creation_date
                           ,xxmx_utilities_pkg.gvv_UserName                             -- src_pa_projects_tb(i).last_updated_by                       --last_updated_by
                           ,SYSDATE                                                     -- src_pa_projects_tb(i).last_update_date                      --last_update_date
--                           ,to_char(TO_DATE(SYSDATE, 'DD-MON-RRRR'),'DDMMRRRRHHMISS')     -- src_pa_projects_tb(i).batch_id                              --batch_id
                           ,to_char(SYSDATE, 'DDMMRRRRHHMISS')     -- src_pa_projects_tb(i).batch_id                              --batch_id
                           ,src_pa_projects_tb(i).proj_owning_org                       --proj_owning_org
                           ,src_pa_projects_tb(i).project_id                            --project_id
                           );
                --
    END LOOP;
    --
    gvv_ProgressIndicator := '0080';
    xxmx_utilities_pkg.log_module_message(
                            pt_i_ApplicationSuite    => gct_ApplicationSuite
                           ,pt_i_Application         => gct_Application
                           ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                           ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                           ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                           ,pt_i_Phase               => ct_Phase
                           ,pt_i_Severity            => 'NOTIFICATION'
                           ,pt_i_PackageName         => gcv_PackageName
                           ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                           ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                           ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                           ,pt_i_OracleError         => gvt_ReturnMessage       );

    --
    COMMIT;
                --
                -- Update latest transaction dates per project
                --UPDATE pfc_ppm_projects_src tt
                --SET    (tt.max_ei_creation_date, tt.max_event_creation_date) =
                --                    (SELECT st.max_ei_creation_date, st.max_event_creation_date
                --                                                    FROM   pfc_ppm_projects_scope_p3_mv st
                --                                                    WHERE  st.project = tt.project_number
                --                    );
                --
                --
    gvv_ProgressIndicator := '0090';
    xxmx_utilities_pkg.log_module_message(
                               pt_i_ApplicationSuite    => gct_ApplicationSuite
                              ,pt_i_Application         => gct_Application
                              ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                              ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase               => ct_Phase
                              ,pt_i_Severity            => 'NOTIFICATION'
                              ,pt_i_PackageName         => gcv_PackageName
                              ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                              ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage       => 'Close the Cursor src_pa_projects_cur'
                              ,pt_i_OracleError         => gvt_ReturnMessage       );
             --


    IF src_pa_projects_cur%ISOPEN THEN
            CLOSE src_pa_projects_cur;
    END IF;
    --
    gvv_ProgressIndicator := '0100';
    --
    --
    -- Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
    -- clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
    -- is reached.
    --
    gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                 (
                                  gct_StgSchema
                                 ,cv_StagingTable
                                 ,pt_i_MigrationSetID
                                 );
    --
    COMMIT;
/*        --
			FOR r IN  (
                SELECT project_name,project_currency_code from xxmx_ppm_projects_Stg
				WHERE project_name IN (
						select PROJECT_NAME from (
						select count(*), project_name from xxmx_ppm_projects_Stg
						group by project_name
						having count(*) > 1 )
						)

                )
			LOOP
				UPDATE xxmx_ppm_projects_Stg
				   SET project_name = r.project_name||r.project_currency_code
				 WHERE project_name = r.project_name;

			END LOOP;
--
			COMMIT;
*/
--
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extraction complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '0110';
               --
               --
               xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gv_i_BusinessEntity
                    ,pt_i_SubEntity               => cv_i_BusinessEntityLevel
                    ,pt_i_Phase                   => ct_Phase
                    ,pt_i_ExtractCompletionDate   => SYSDATE
                    ,pt_i_ExtractRowCount         => gvn_RowCount
                    ,pt_i_TransformTable          => NULL
                    ,pt_i_TransformStartDate      => NULL
                    ,pt_i_TransformCompletionDate => NULL
                    ,pt_i_ExportFileName          => NULL
                    ,pt_i_ExportStartDate         => NULL
                    ,pt_i_ExportCompletionDate    => NULL
                    ,pt_i_ExportRowCount          => NULL
                    ,pt_i_ErrorFlag               => NULL
                    );
               --
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Migration Table "'
                                             ||cv_StagingTable
                                             ||'" reporting details updated.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
          ELSE
               --
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set not initialized.';
               --
               --
               RAISE e_ModuleError;
               --
               --
          END IF;
          --
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gv_i_BusinessEntity
               ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gcv_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          --
EXCEPTION
    WHEN ex_dml_errors THEN
        l_error_count := SQL%BULK_EXCEPTIONS.count;
        DBMS_OUTPUT.put_line('Number of failures: ' || l_error_count);
        FOR i IN 1 .. l_error_count LOOP
            gvt_ModuleMessage := 
                'Error: ' || i ||' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
                ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE);
            xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage
                    ,pt_i_OracleError         => gvt_ReturnMessage   );
            DBMS_OUTPUT.put_line(gvt_ModuleMessage);
        END LOOP;
    WHEN e_ModuleError THEN
        IF src_pa_projects_cur%ISOPEN
        THEN
            CLOSE src_pa_projects_cur;
        END IF;
        xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage
                    ,pt_i_OracleError         => gvt_ReturnMessage       );
         RAISE;
    WHEN OTHERS THEN
        IF src_pa_projects_cur%ISOPEN
        THEN
            CLOSE src_pa_projects_cur;
        END IF;
        ROLLBACK;
        --
        gvt_OracleError := 
            SUBSTR(SQLERRM||'** ERROR_BACKTRACE: '||dbms_utility.format_error_backtrace,1,4000);
        xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                    ,pt_i_OracleError         => gvt_OracleError       );
         --
         RAISE;
END src_pa_projects;

     /***********************************************
     -----------------src_pa_tasks-------------------
     ***********************************************/

PROCEDURE src_pa_tasks (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
                            ,pt_i_SubEntity                   IN      xxmx_migration_metadata.sub_entity%TYPE)
     IS

           cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'src_pa_tasks';
           ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
           cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PPM_PRJ_TASKS_STG';
           cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'TASKS';

           e_DateError                         EXCEPTION;
    --
    -- Local Cursors
    --
    CURSOR src_projects_scope is
        SELECT
             project_id 
			,project_name 
			,project_number 
			,proj_owning_org 
			,project_finish_date 
			,organization_name 	
        FROM  xxmx_ppm_projects_stg;           
    --
    --
    CURSOR src_pa_tasks_cur
       /* (
            p_project_id NUMBER
			, p_project_name VARCHAR2
			, p_project_number VARCHAR2
			, p_proj_owning_org VARCHAR2
			, p_project_finish_date DATE
			, p_organization_name VARCHAR2
        ) */
		(
		p_start_num number,
		p_end_num number
		)		
		IS
        SELECT
            -- p_project_name                                                     as project_name
			--,p_project_number                                                   as project_number
			ppa.project_name
			,ppa.project_number
            ,REGEXP_REPLACE(pt.long_task_name, '[^[:print:]]','') 	            as task_name
            ,pt.task_number                                                     as task_number
            ,pm_task_reference                                                  as source_task_reference
                  ,''                                                                 financial_task
                  ,REGEXP_REPLACE(pt.description , '[^[:print:]]','')                task_description
                  /*,(SELECT t.task_number
                    FROM  xxpa_tasks_stg t-- apps.pa_tasks@xxmx_extract t -- changed by Govardhan on 26/10/22
                    WHERE  t.task_id = pt.parent_task_id)                             parent_task_number*/
					, null  parent_task_number
                  ,pt.start_date                                                      planning_start_date
                  --,nvl(pt.completion_date,ppa.project_finish_date )                   planning_end_date  
				  --,nvl(pt.completion_date,p_project_finish_date )                   planning_end_date  
				  ,ppa.project_finish_date 												planning_end_date
                 /* ,(SELECT max(ptp.planned_effort)
                    FROM   apps.pa_task_progress_v@xxmx_extract ptp
                    WHERE  pt.task_id = ptp.task_id
                    AND    pt.project_id = ptp.project_id)                            planned_effort*/
                  ,''               planned_effort
                  ,''                                                                 planned_duration
                  /*,(SELECT max(ptp.milestone_flag)
                    FROM   apps.pa_task_progress_v@xxmx_extract ptp
                    WHERE  pt.task_id = ptp.task_id
                    AND    pt.project_id = ptp.project_id)                            milestone_flag*/
                 , '' milestone_flag
                 /* ,(SELECT max(ptp.critical_flag)
                    FROM   apps.pa_task_progress_v@xxmx_extract ptp
                    WHERE  pt.task_id = ptp.task_id
                    AND    pt.project_id = ptp.project_id)                            critical_flag*/
                  , '' critical_flag
                  ,pt.chargeable_flag                                                 chargeable_flag
                  ,pt.billable_flag                                                   billable_flag
                  ,null                                                               capitalizable_flag
                  ,pt.limit_to_txn_controls_flag                                      limit_to_txn_controls_flag
                  ,pt.service_type_code                                               service_type_code
                  --,pt.work_type_id                                                    work_type_id
                  ,null                                                               work_type_id  --Milind blanked it out as per user review
                 /* ,(SELECT papf.employee_number
                   FROM   apps.per_all_people_f@xxmx_extract papf
                   WHERE  1=1
                   AND  papf.person_id =pt.task_manager_person_id
                   AND   TRUNC(sysdate) BETWEEN papf.effective_start_Date AND
                         NVL(papf.effective_end_Date, sysdate))                       manager_person_id*/
                   ,'' manager_person_id
                  ,pt.allow_cross_charge_flag                                         allow_cross_charge_flag
                  ,pt.cc_process_labor_flag                                           cc_process_labor_flag
                  ,pt.cc_process_nl_flag                                              cc_process_nl_flag
                  ,pt.receive_project_invoice_flag                                    receive_project_invoice_flag
                  /*,(SELECT hou.name
                    FROM   apps.hr_all_organization_units@xxmx_extract hou
                    WHERE  hou.organization_id = pt.carrying_out_organization_id)     organization_name*/
				  , NULL organization_name
				  --,'' 																 organization_name
                  ,''                                                                 reqmnt_code
                  ,''                                                                 sprint
                  ,''                                                                 priority
                  ,''                                                                 schedule_mode
                 /* ,(SELECT pptp.baseline_start_date
                    FROM   apps.pa_proj_task_prog_det_v@xxmx_extract pptp
                    WHERE  pt.task_id = pptp.task_id
                    AND    pt.project_id = pptp.project_id)                          baseline_start_date*/
                 ,'' baseline_start_date
                 /* ,(SELECT pptp.baseline_finish_date
                    FROM   apps.pa_proj_task_prog_det_v@xxmx_extract pptp
                    WHERE  pt.task_id = pptp.task_id
                    AND    pt.project_id = pptp.project_id)                          baseline_finish_date*/
                ,'' baseline_finish_date
                 /* ,(SELECT pptp.baselined_effort
                    FROM   apps.pa_proj_task_prog_det_v@xxmx_extract pptp
                    WHERE  pt.task_id = pptp.task_id
                    AND    pt.project_id = pptp.project_id)                           baseline_effort*/
                , '' baseline_effort
                  ,NULL                                                               baseline_duration
                  ,''                                                                 baseline_allocation
                  ,''                                                                 baseline_labor_cost_amount
                  ,''                                                                 baseline_labor_billed_amount
                  ,''                                                                 baseline_expense_cost_amount
                  ,''                                                                 constraint_type
                  ,''                                                                 constraint_date
                  ,pt.attribute_category                                              attribute_category
                  ,pt.attribute1                                                      attribute1
                  ,pt.attribute2                                                      attribute2
                  ,pt.attribute3                                                      attribute3
                  ,REGEXP_REPLACE(pt.task_name, '[^[:print:]]','')                    attribute4
                  ,pt.task_id                                                         attribute5
                  ,pt.project_id                                                        attribute6
                  ,''                                                                 attribute7
                  ,''                                                                 attribute8
                  ,''                                                                 attribute9
                  ,''                                                                 attribute10
                  ,''                                                                 attribute11
                  ,''                                                                 attribute12
                  ,''                                                                 attribute13
                  ,''                                                                 attribute14
                  ,''                                                                 attribute15
                  ,''                                                                 attribute16
                  ,''                                                                 attribute17
                  ,''                                                                 attribute18
                  ,''                                                                 attribute19
                  ,''                                                                 attribute20
                  ,''                                                                 attribute21
                  ,''                                                                 attribute22
                  ,''                                                                 attribute23
                  ,''                                                                 attribute24
                  ,''                                                                 attribute25
                  ,''                                                                 attribute26
                  ,''                                                                 attribute27
                  ,''                                                                 attribute28
                  ,''                                                                 attribute29
                  ,''                                                                 attribute30
                  ,''                                                                 attribute31
                  ,''                                                                 attribute32
                  ,''                                                                 attribute33
                  ,''                                                                 attribute34
                  ,''                                                                 attribute35
                  ,''                                                                 attribute36
                  ,''                                                                 attribute37
                  ,''                                                                 attribute38
                  ,''                                                                 attribute39
                  ,''                                                                 attribute40
                  ,''                                                                 attribute41
                  ,''                                                                 attribute42
                  ,''                                                                 attribute43
                  ,''                                                                 attribute44
                  ,''                                                                 attribute45
                  ,''                                                                 attribute46
                  ,''                                                                 attribute47
                  ,''                                                                 attribute48
                  ,''                                                                 attribute49
                  ,''                                                                 attribute50
                  ,''                                                                 attribute1_number
                  ,''                                                                 attribute2_number
                  ,''                                                                 attribute3_number
                  ,''                                                                 attribute4_number
                  ,''                                                                 attribute5_number
                  ,''                                                                 attribute6_number
                  ,''                                                                 attribute7_number
                  ,''                                                                 attribute8_number
                  ,''                                                                 attribute9_number
                  ,''                                                                 attribute10_number
                  ,''                                                                 attribute11_number
                  ,''                                                                 attribute12_number
                  ,''                                                                 attribute13_number
                  ,''                                                                 attribute14_number
                  ,''                                                                 attribute15_number
                  ,''                                                                 attribute1_date
                  ,''                                                                 attribute2_date
                  ,''                                                                 attribute3_date
                  ,''                                                                 attribute4_date
                  ,''                                                                 attribute5_date
                  ,''                                                                 attribute6_date
                  ,''                                                                 attribute7_date
                  ,''                                                                 attribute8_date
                  ,''                                                                 attribute9_date
                  ,''                                                                 attribute10_date
                  ,''                                                                 attribute11_date
                  ,''                                                                 attribute12_date
                  ,''                                                                 attribute13_date
                  ,''                                                                 attribute14_date
                  ,''                                                                 attribute15_date
                  ,NULL                                                               source_application_code
                  --,p_organization_name                                              ou_name
                  ,NULL                                                               ou_name
                  ,null                                                               task_rank
        FROM
            --xxpa_tasks_stg pt -- apps.pa_tasks@xxmx_extract                   pt-- Modified by Govardhan on 26/10/22
            apps.pa_tasks@xxmx_extract                   pt
            , xxmx_ppm_projects_stg ppa
        WHERE  1=1--pt.project_id = p_project_id
		AND pt.project_id =  ppa.project_id 
        AND    ( pt.completion_date                              IS NULL
                    --OR pt.completion_date                          >= trunc(sysdate) 
                    OR pt.completion_date  >= to_date(gvv_migration_date,'DD-MON-YYYY')
                    )
                    --OR pt.completion_date                          >= to_date('31-MAR-2024','DD-MON-RRRR'))
		AND ppa.last_update_login between to_number(p_start_num) AND TO_NUMBER(p_end_num);


         -- Local Type Variables
         TYPE src_pa_tasks_tbl IS TABLE OF src_pa_tasks_cur%ROWTYPE INDEX BY BINARY_INTEGER;
         src_pa_tasks_tb  src_pa_tasks_tbl;

         ex_dml_errors             EXCEPTION;
         PRAGMA EXCEPTION_INIT(ex_dml_errors, -24381);
         l_error_count             NUMBER;
		 l_proj_count				NUMBER := 0;
		 l_start NUMBER :=0;
		 l_end NUMBER :=0;
		 l_batch_id VARCHAR2(100) := to_char(SYSDATE, 'DDMMRRRRHHMISS');

   BEGIN
           gvv_ReturnStatus  := '';
              gvt_ReturnMessage := '';
              gvv_ProgressIndicator := '0000';
              xxmx_utilities_pkg.clear_messages
                  (
                  pt_i_ApplicationSuite     => gct_ApplicationSuite
                  ,pt_i_Application         => gct_Application
                  ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                  ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                  ,pt_i_Phase               => ct_Phase
                  ,pt_i_MessageType         => 'MODULE'
                  ,pv_o_ReturnStatus        => gvv_ReturnStatus
                  );
              --
              IF   gvv_ReturnStatus = 'F'
              THEN
                  xxmx_utilities_pkg.log_module_message(
                       pt_i_ApplicationSuite    => gct_ApplicationSuite
                      ,pt_i_Application         => gct_Application
                      ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                      ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                      ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                      ,pt_i_Phase               => ct_Phase
                      ,pt_i_Severity            => 'ERROR'
                      ,pt_i_PackageName         => gcv_PackageName
                      ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                      ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                      ,pt_i_ModuleMessage       => 'Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                      ,pt_i_OracleError         => gvt_ReturnMessage    );
                  --
                  RAISE e_ModuleError;
              END IF;
              --
            update xxmx_ppm_projects_stg set last_update_login= rownum;
            --
            xxmx_utilities_pkg.log_module_message
                (pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'Begin Procedure '|| TO_CHAR(systimestamp, 'DDMMYYYYHH24MISS')
                ,pt_i_OracleError         => gvt_ReturnMessage
                );
            --

              gvv_ProgressIndicator := '0010';
              xxmx_utilities_pkg.log_module_message(
                       pt_i_ApplicationSuite    => gct_ApplicationSuite
                      ,pt_i_Application         => gct_Application
                      ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                      ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                      ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                      ,pt_i_Phase               => ct_Phase
                      ,pt_i_Severity            => 'NOTIFICATION'
                      ,pt_i_PackageName         => gcv_PackageName
                      ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                      ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                      ,pt_i_ModuleMessage       => 'Deleting from "' || cv_StagingTable   || '".'
                      ,pt_i_OracleError         => gvt_ReturnMessage  );
              --
			 -- xxmx_utilities_pkg.truncate_table('xxmx_stg.XXMX_PPM_PRJ_TASKS_STG');
              --EXECUTE IMMEDIATE 'TRUNCATE TABLE xxmx_stg.XXMX_PPM_PRJ_TASKS_STG';
			  --DELETE
             -- FROM    XXMX_STG.XXMX_PPM_PRJ_TASKS_STG ;

             COMMIT;
              --

            gvv_ProgressIndicator := '0020';
            --
            gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
            --
            /*
            ** If the Migration Set Name is NULL then the Migration has not been initialized.
            */
            --
            IF   gvt_MigrationSetName IS NOT NULL
            THEN
               --
               gvv_ProgressIndicator := '0030';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Extracting "'
                                             ||pt_i_SubEntity
                                             ||'":'
                    ,pt_i_OracleError       => NULL
                    );
               --
               /*
               ** The Migration Set has been initialised, so now initialize the detail record
               ** for the current entity.
               */
               --
               --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
               --**                  table based on the Application Suite, Application and Business Entity parameters.
               --**
               --**                  Removed "entity" from procedure_name.
               --
            /*   xxmx_utilities_pkg.init_migration_details
                    (
                     pt_i_ApplicationSuite => gct_ApplicationSuite
                    ,pt_i_Application      => gct_Application
                    ,pt_i_BusinessEntity   => gv_i_BusinessEntity
                    ,pt_i_SubEntity        => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                    ,pt_i_StagingTable     => cv_StagingTable
                    ,pt_i_ExtractStartDate => SYSDATE
                    );*/
               --
               --** ISV 21/10/2020 - "pt_i_StagingTable" no longer needs to be passed as a parameter from the STG_MAIN procedure
               --**                  as the table name will never change so replace with new constant "ct_StgTable".
               --
               --**                  We will still keep the table name in the Metadata table as that can be used for reporting
               --**                  purposes.
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Staging Table "'
                                             ||cv_StagingTable
                                             ||'" reporting details initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0040';
               --
               --** Extract the Projects and insert into the staging table.
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extracting data into "'
                                             ||cv_StagingTable
                                             ||'".'
                    ,pt_i_OracleError       => NULL
                    );
      --  FOR X IN src_projects_scope 
      --  LOOP 
		l_start  := 1;
		l_end	:= 250;
		FOR i in 1..200
		LOOP		
               --
               --** ISV 21/10/2020 - The staging table is in the xxmx_stg schema but should not need to be prefixed as there should
               --**                  by a Synonym in the xxmx_core schema to that table.
               --

              OPEN src_pa_tasks_cur(l_start, l_end); /*(
									  x.project_id 
									, x.project_name 
									, x.project_number 
									, x.proj_owning_org 
									, x.project_finish_date 
									, x.organization_name 
							); */
              --
			  
			  

             /*  gvv_ProgressIndicator := '0050';
              xxmx_utilities_pkg.log_module_message(
                       pt_i_ApplicationSuite    => gct_ApplicationSuite
                      ,pt_i_Application         => gct_Application
                      ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                      ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                      ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                      ,pt_i_Phase               => ct_Phase
                      ,pt_i_Severity            => 'NOTIFICATION'
                      ,pt_i_PackageName         => gcv_PackageName
                      ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                      ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                      ,pt_i_ModuleMessage       => 'Cursor Open src_pa_tasks_cur'
                      ,pt_i_OracleError         => gvt_ReturnMessage  ); */
              --
              LOOP
              --
              /* gvv_ProgressIndicator := '0060';
              xxmx_utilities_pkg.log_module_message(
                       pt_i_ApplicationSuite    => gct_ApplicationSuite
                      ,pt_i_Application         => gct_Application
                      ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                      ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                      ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                      ,pt_i_Phase               => ct_Phase
                      ,pt_i_Severity            => 'NOTIFICATION'
                      ,pt_i_PackageName         => gcv_PackageName
                      ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                      ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                      ,pt_i_ModuleMessage       => 'Inside the Cursor loop'
                      ,pt_i_OracleError         => gvt_ReturnMessage  ); */
              --
              FETCH src_pa_tasks_cur  BULK COLLECT INTO src_pa_tasks_tb;-- LIMIT 1000;
              --

               gvv_ProgressIndicator := '0070';
              xxmx_utilities_pkg.log_module_message(
                       pt_i_ApplicationSuite    => gct_ApplicationSuite
                      ,pt_i_Application         => gct_Application
                      ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                      ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                      ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                      ,pt_i_Phase               => ct_Phase
                      ,pt_i_Severity            => 'NOTIFICATION'
                      ,pt_i_PackageName         => gcv_PackageName
                      ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                      ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                      ,pt_i_ModuleMessage       => 'Cursor src_pa_tasks_cur Fetch into src_pa_tasks_tb. src_pa_tasks_tb.COUNT '||
                            src_pa_tasks_tb.COUNT
                      ,pt_i_OracleError         => gvt_ReturnMessage  ); 
              --
              EXIT WHEN src_pa_tasks_tb.COUNT=0;
              --
              FORALL I IN 1..src_pa_tasks_tb.COUNT
              --
                  INSERT INTO XXMX_PPM_PRJ_TASKS_STG
                                              (
                                              migration_set_id
                                              ,migration_status
                                              ,migration_set_name
                                              ,project_name
                                              ,project_number
                                              ,task_name
                                              ,task_number
                                              ,source_task_reference
                                              ,financial_task
                                              ,task_description
                                              ,parent_task_number
                                              ,planning_start_date
                                              ,planning_end_date
                                              ,planned_effort
                                              ,planned_duration
                                              ,milestone_flag
                                              ,critical_flag
                                              ,chargeable_flag
                                              ,billable_flag
                                              ,capitalizable_flag
                                              ,limit_to_txn_controls_flag
                                              ,service_type_code
                                              ,work_type_id
                                              ,manager_person_id
                                              ,allow_cross_charge_flag
                                              ,cc_process_labor_flag
                                              ,cc_process_nl_flag
                                              ,receive_project_invoice_flag
                                              ,reqmnt_code
                                              ,sprint
                                              ,priority
                                              ,schedule_mode
                                              ,baseline_start_date
                                              ,baseline_finish_date
                                              ,baseline_effort
                                              ,baseline_duration
                                              ,baseline_allocation
                                              ,baseline_labor_cost_amount
                                              ,baseline_labor_billed_amount
                                              ,baseline_expense_cost_amount
                                              ,CONSTRAINT_TYPE_CODE
                                              ,constraint_date
                                              ,attribute_category
                                              ,attribute1
                                              ,attribute2
                                              ,attribute3
                                              ,attribute4
                                              ,attribute5
                                              ,attribute6
                                              ,attribute7
                                              ,attribute8
                                              ,attribute9
                                              ,attribute10
                                              ,attribute11
                                              ,attribute12
                                              ,attribute13
                                              ,attribute14
                                              ,attribute15
                                              ,attribute16
                                              ,attribute17
                                              ,attribute18
                                              ,attribute19
                                              ,attribute20
                                              ,attribute21
                                              ,attribute22
                                              ,attribute23
                                              ,attribute24
                                              ,attribute25
                                              ,attribute26
                                              ,attribute27
                                              ,attribute28
                                              ,attribute29
                                              ,attribute30
                                              ,attribute31
                                              ,attribute32
                                              ,attribute33
                                              ,attribute34
                                              ,attribute35
                                              ,attribute36
                                              ,attribute37
                                              ,attribute38
                                              ,attribute39
                                              ,attribute40
                                              ,attribute41
                                              ,attribute42
                                              ,attribute43
                                              ,attribute44
                                              ,attribute45
                                              ,attribute46
                                              ,attribute47
                                              ,attribute48
                                              ,attribute49
                                              ,attribute50
                                              ,attribute1_number
                                              ,attribute2_number
                                              ,attribute3_number
                                              ,attribute4_number
                                              ,attribute5_number
                                              ,attribute6_number
                                              ,attribute7_number
                                              ,attribute8_number
                                              ,attribute9_number
                                              ,attribute10_number
                                              ,attribute11_number
                                              ,attribute12_number
                                              ,attribute13_number
                                              ,attribute14_number
                                              ,attribute15_number
                                              ,attribute1_date
                                              ,attribute2_date
                                              ,attribute3_date
                                              ,attribute4_date
                                              ,attribute5_date
                                              ,attribute6_date
                                              ,attribute7_date
                                              ,attribute8_date
                                              ,attribute9_date
                                              ,attribute10_date
                                              ,attribute11_date
                                              ,attribute12_date
                                              ,attribute13_date
                                              ,attribute14_date
                                              ,attribute15_date
                                              ,source_application_code
                                              ,batch_name
                                              ,created_by
                                              ,creation_date
                                              ,last_updated_by
                                              ,last_update_date
                                              ,batch_id
                                              ,organization_name
                                          )




                              VALUES
                                          (
                                               pt_i_MigrationSetID                                             
                                              ,'EXTRACTED'
                                              , gvt_MigrationSetName                                              
                                              ,src_pa_tasks_tb(i).project_name
                                              ,src_pa_tasks_tb(i).project_number
                                              ,src_pa_tasks_tb(i).task_name
                                              ,src_pa_tasks_tb(i).task_number
                                              ,src_pa_tasks_tb(i).source_task_reference
                                              ,src_pa_tasks_tb(i).financial_task
                                              ,src_pa_tasks_tb(i).task_description
                                              ,src_pa_tasks_tb(i).parent_task_number
                                              ,src_pa_tasks_tb(i).planning_start_date
                                              ,src_pa_tasks_tb(i).planning_end_date
                                              ,src_pa_tasks_tb(i).planned_effort
                                              ,src_pa_tasks_tb(i).planned_duration
                                              ,src_pa_tasks_tb(i).milestone_flag
                                              ,src_pa_tasks_tb(i).critical_flag
                                              ,src_pa_tasks_tb(i).chargeable_flag
                                              ,src_pa_tasks_tb(i).billable_flag
                                              ,src_pa_tasks_tb(i).capitalizable_flag
                                              ,src_pa_tasks_tb(i).limit_to_txn_controls_flag
                                              ,src_pa_tasks_tb(i).service_type_code
                                              ,src_pa_tasks_tb(i).work_type_id
                                              ,src_pa_tasks_tb(i).manager_person_id
                                              ,src_pa_tasks_tb(i).allow_cross_charge_flag
                                              ,src_pa_tasks_tb(i).cc_process_labor_flag
                                              ,src_pa_tasks_tb(i).cc_process_nl_flag
                                              ,src_pa_tasks_tb(i).receive_project_invoice_flag
                                              ,src_pa_tasks_tb(i).reqmnt_code
                                              ,src_pa_tasks_tb(i).sprint
                                              ,src_pa_tasks_tb(i).priority
                                              ,src_pa_tasks_tb(i).schedule_mode
                                              ,src_pa_tasks_tb(i).baseline_start_date
                                              ,src_pa_tasks_tb(i).baseline_finish_date
                                              ,src_pa_tasks_tb(i).baseline_effort
                                              ,src_pa_tasks_tb(i).baseline_duration
                                              ,src_pa_tasks_tb(i).baseline_allocation
                                              ,src_pa_tasks_tb(i).baseline_labor_cost_amount
                                              ,src_pa_tasks_tb(i).baseline_labor_billed_amount
                                              ,src_pa_tasks_tb(i).baseline_expense_cost_amount
                                              ,src_pa_tasks_tb(i).constraint_type
                                              ,src_pa_tasks_tb(i).constraint_date
                                              ,src_pa_tasks_tb(i).attribute_category
                                              ,src_pa_tasks_tb(i).attribute1
                                              ,src_pa_tasks_tb(i).attribute2
                                              ,src_pa_tasks_tb(i).attribute3
                                              ,src_pa_tasks_tb(i).attribute4
                                              ,src_pa_tasks_tb(i).attribute5
                                              ,src_pa_tasks_tb(i).attribute6
                                              ,src_pa_tasks_tb(i).attribute7
                                              ,src_pa_tasks_tb(i).attribute8
                                              ,src_pa_tasks_tb(i).attribute9
                                              ,src_pa_tasks_tb(i).attribute10
                                              ,src_pa_tasks_tb(i).attribute11
                                              ,src_pa_tasks_tb(i).attribute12
                                              ,src_pa_tasks_tb(i).attribute13
                                              ,src_pa_tasks_tb(i).attribute14
                                              ,src_pa_tasks_tb(i).attribute15
                                              ,src_pa_tasks_tb(i).attribute16
                                              ,src_pa_tasks_tb(i).attribute17
                                              ,src_pa_tasks_tb(i).attribute18
                                              ,src_pa_tasks_tb(i).attribute19
                                              ,src_pa_tasks_tb(i).attribute20
                                              ,src_pa_tasks_tb(i).attribute21
                                              ,src_pa_tasks_tb(i).attribute22
                                              ,src_pa_tasks_tb(i).attribute23
                                              ,src_pa_tasks_tb(i).attribute24
                                              ,src_pa_tasks_tb(i).attribute25
                                              ,src_pa_tasks_tb(i).attribute26
                                              ,src_pa_tasks_tb(i).attribute27
                                              ,src_pa_tasks_tb(i).attribute28
                                              ,src_pa_tasks_tb(i).attribute29
                                              ,src_pa_tasks_tb(i).attribute30
                                              ,src_pa_tasks_tb(i).attribute31
                                              ,src_pa_tasks_tb(i).attribute32
                                              ,src_pa_tasks_tb(i).attribute33
                                              ,src_pa_tasks_tb(i).attribute34
                                              ,src_pa_tasks_tb(i).attribute35
                                              ,src_pa_tasks_tb(i).attribute36
                                              ,src_pa_tasks_tb(i).attribute37
                                              ,src_pa_tasks_tb(i).attribute38
                                              ,src_pa_tasks_tb(i).attribute39
                                              ,src_pa_tasks_tb(i).attribute40
                                              ,src_pa_tasks_tb(i).attribute41
                                              ,src_pa_tasks_tb(i).attribute42
                                              ,src_pa_tasks_tb(i).attribute43
                                              ,src_pa_tasks_tb(i).attribute44
                                              ,src_pa_tasks_tb(i).attribute45
                                              ,src_pa_tasks_tb(i).attribute46
                                              ,src_pa_tasks_tb(i).attribute47
                                              ,src_pa_tasks_tb(i).attribute48
                                              ,src_pa_tasks_tb(i).attribute49
                                              ,src_pa_tasks_tb(i).attribute50
                                              ,src_pa_tasks_tb(i).attribute1_number
                                              ,src_pa_tasks_tb(i).attribute2_number
                                              ,src_pa_tasks_tb(i).attribute3_number
                                              ,src_pa_tasks_tb(i).attribute4_number
                                              ,src_pa_tasks_tb(i).attribute5_number
                                              ,src_pa_tasks_tb(i).attribute6_number
                                              ,src_pa_tasks_tb(i).attribute7_number
                                              ,src_pa_tasks_tb(i).attribute8_number
                                              ,src_pa_tasks_tb(i).attribute9_number
                                              ,src_pa_tasks_tb(i).attribute10_number
                                              ,src_pa_tasks_tb(i).attribute11_number
                                              ,src_pa_tasks_tb(i).attribute12_number
                                              ,src_pa_tasks_tb(i).attribute13_number
                                              ,src_pa_tasks_tb(i).attribute14_number
                                              ,src_pa_tasks_tb(i).attribute15_number
                                              ,src_pa_tasks_tb(i).attribute1_date
                                              ,src_pa_tasks_tb(i).attribute2_date
                                              ,src_pa_tasks_tb(i).attribute3_date
                                              ,src_pa_tasks_tb(i).attribute4_date
                                              ,src_pa_tasks_tb(i).attribute5_date
                                              ,src_pa_tasks_tb(i).attribute6_date
                                              ,src_pa_tasks_tb(i).attribute7_date
                                              ,src_pa_tasks_tb(i).attribute8_date
                                              ,src_pa_tasks_tb(i).attribute9_date
                                              ,src_pa_tasks_tb(i).attribute10_date
                                              ,src_pa_tasks_tb(i).attribute11_date
                                              ,src_pa_tasks_tb(i).attribute12_date
                                              ,src_pa_tasks_tb(i).attribute13_date
                                              ,src_pa_tasks_tb(i).attribute14_date
                                              ,src_pa_tasks_tb(i).attribute15_date
                                              ,src_pa_tasks_tb(i).source_application_code
                                              ,g_batch_name                                 --src_pa_tasks_tb(i).batch_name
                                              ,xxmx_utilities_pkg.gvv_UserName              --src_pa_tasks_tb(i).created_by
                                              ,SYSDATE                                      --src_pa_tasks_tb(i).creation_date
                                              ,xxmx_utilities_pkg.gvv_UserName               --src_pa_tasks_tb(i).last_updated_by
                                              ,SYSDATE                                      --src_pa_tasks_tb(i).last_update_date
--                                              ,to_char(TO_DATE(SYSDATE, 'DD-MON-RRRR'),'DDMMRRRRHHMISS')          --src_pa_tasks_tb(i).batch_id
                                              --,to_char(SYSDATE, 'DDMMRRRRHHMISS')          --src_pa_tasks_tb(i).batch_id
											  ,l_batch_id
                                              ,src_pa_tasks_tb(i).organization_name
                                          );
										  
						
						
			

              --
 
              END LOOP;
              --
			  COMMIT;	
			   l_start  := l_end + 1;
			   l_end	:= l_end + 250;

              /* gvv_ProgressIndicator := '0080';
              xxmx_utilities_pkg.log_module_message(
                       pt_i_ApplicationSuite    => gct_ApplicationSuite
                      ,pt_i_Application         => gct_Application
                      ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                      ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                      ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                      ,pt_i_Phase               => ct_Phase
                      ,pt_i_Severity            => 'NOTIFICATION'
                      ,pt_i_PackageName         => gcv_PackageName
                      ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                      ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                      ,pt_i_ModuleMessage       => 'After insert into XXMX_PPM_PRJ_TASKS_STG'
                      ,pt_i_OracleError         => gvt_ReturnMessage  ); */
              --
             -- COMMIT;
              --

              gvv_ProgressIndicator := '0090';
              /* xxmx_utilities_pkg.log_module_message(
                       pt_i_ApplicationSuite    => gct_ApplicationSuite
                      ,pt_i_Application         => gct_Application
                      ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                      ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                      ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                      ,pt_i_Phase               => ct_Phase
                      ,pt_i_Severity            => 'NOTIFICATION'
                      ,pt_i_PackageName         => gcv_PackageName
                      ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                      ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                      ,pt_i_ModuleMessage       => 'Data Insertion in SRC Table End' ||cv_StagingTable
                      ,pt_i_OracleError         => gvt_ReturnMessage  ); */


              --

             IF src_pa_tasks_cur%ISOPEN
             THEN
               --
               CLOSE src_pa_tasks_cur;
               --
             END IF;
              --

            gvv_ProgressIndicator := '0100';
            --
            /*
            ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
            ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
            ** is reached.
            */
            --
            --** ISV 21/10/2020 - Replace "pt_i_ClientSchemaName" (no longer passed into the extract procedures) with new constant "gct_StgSchema".
            --**                  Replace "pt_i_StagingTable" (no longer passed into the extract procedures) with new constant "ct_StgTable"
            --
/*             gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                 (
                                  gct_StgSchema
                                 ,cv_StagingTable
                                 ,pt_i_MigrationSetID
                                 ); */
            --
            l_proj_count := l_proj_count + 1;

			--IF MOD(l_proj_count,100) = 0 THEN
			--	COMMIT;
			--END IF;
			
				-- l_start  := 1;
			  --l_end	:= 250;
			   END LOOP;
/* 
            xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extraction complete.'
                    ,pt_i_OracleError       => NULL
                    ); */
               --
               --
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
             /*   gvv_ProgressIndicator := '0110';
               --
               --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
               --**                  table based on the Application Suite, Application, Business Entity and Sub-Entity parameters.
               --**
               --**                  Removed "entity" from procedure_name.
               --
               xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gv_i_BusinessEntity
                    ,pt_i_SubEntity               => cv_i_BusinessEntityLevel
                    ,pt_i_Phase                   => ct_Phase
                    ,pt_i_ExtractCompletionDate   => SYSDATE
                    ,pt_i_ExtractRowCount         => gvn_RowCount
                    ,pt_i_TransformTable          => NULL
                    ,pt_i_TransformStartDate      => NULL
                    ,pt_i_TransformCompletionDate => NULL
                    ,pt_i_ExportFileName          => NULL
                    ,pt_i_ExportStartDate         => NULL
                    ,pt_i_ExportCompletionDate    => NULL
                    ,pt_i_ExportRowCount          => NULL
                    ,pt_i_ErrorFlag               => NULL
                    );
               --
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Migration Table "'
                                             ||cv_StagingTable
                                             ||'" reporting details updated.'
                    ,pt_i_OracleError       => NULL
                    ); */
               --
               --
      --CLOSE src_pa_tasks_cur;  
       -- END LOOP;
          ELSE
               --
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set not initialized.';
               --
               --
               RAISE e_ModuleError;
               --
               --
          END IF;
          --
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gv_i_BusinessEntity
               ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gcv_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          --
              --
          EXCEPTION

            WHEN ex_dml_errors THEN
                  l_error_count := SQL%BULK_EXCEPTIONS.count;
                  DBMS_OUTPUT.put_line('Number of failures: ' || l_error_count);
                  FOR i IN 1 .. l_error_count LOOP

                    gvt_ModuleMessage := 'Error: ' || i ||
                                         ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
                                         ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE);

                    xxmx_utilities_pkg.log_module_message(
                              pt_i_ApplicationSuite    => gct_ApplicationSuite
                             ,pt_i_Application         => gct_Application
                             ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                             ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                             ,pt_i_Phase               => ct_Phase
                             ,pt_i_Severity            => 'ERROR'
                             ,pt_i_PackageName         => gcv_PackageName
                             ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                             ,pt_i_ModuleMessage       => gvt_ModuleMessage
                             ,pt_i_OracleError         => gvt_ReturnMessage   );

                    DBMS_OUTPUT.put_line('Error: ' || i ||
                                        ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
                                        ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
                  END LOOP;

            WHEN e_ModuleError THEN
                         --
                   IF src_pa_tasks_cur%ISOPEN
                   THEN
                     --
                     CLOSE src_pa_tasks_cur;
                     --
                   END IF;

                 xxmx_utilities_pkg.log_module_message(
                              pt_i_ApplicationSuite    => gct_ApplicationSuite
                             ,pt_i_Application         => gct_Application
                             ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                             ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                             ,pt_i_Phase               => ct_Phase
                             ,pt_i_Severity            => 'ERROR'
                             ,pt_i_PackageName         => gcv_PackageName
                             ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                             ,pt_i_ModuleMessage       => gvt_ModuleMessage
                             ,pt_i_OracleError         => gvt_ReturnMessage       );
                  --
                  RAISE;
                  --** END e_ModuleError Exception
                  --
            WHEN e_DateError THEN
                         --
                  IF src_pa_tasks_cur%ISOPEN
                   THEN
                     --
                     CLOSE src_pa_tasks_cur;
                     --
                   END IF;

                 xxmx_utilities_pkg.log_module_message(
                              pt_i_ApplicationSuite    => gct_ApplicationSuite
                             ,pt_i_Application         => gct_Application
                             ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                             ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                             ,pt_i_Phase               => ct_Phase
                             ,pt_i_Severity            => 'ERROR'
                             ,pt_i_PackageName         => gcv_PackageName
                             ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                             ,pt_i_ModuleMessage       => 'From, to or Prev Tax Year variable not populated'
                             ,pt_i_OracleError         => gvt_ReturnMessage       );
                     --
                     RAISE;

            WHEN OTHERS THEN

                  IF src_pa_tasks_cur%ISOPEN
                   THEN
                     --
                     CLOSE src_pa_tasks_cur;
                     --
                   END IF;

                  --
                  ROLLBACK;
                  --
                  gvt_OracleError := SUBSTR(SQLERRM
                                          ||'** ERROR_BACKTRACE: '
                                          ||dbms_utility.format_error_backtrace
                                          ,1
                                          ,4000
                                          );
                  --
                  xxmx_utilities_pkg.log_module_message(
                              pt_i_ApplicationSuite    => gct_ApplicationSuite
                             ,pt_i_Application         => gct_Application
                             ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                             ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                             ,pt_i_Phase               => ct_Phase
                             ,pt_i_Severity            => 'ERROR'
                             ,pt_i_PackageName         => gcv_PackageName
                             ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                             ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                             ,pt_i_OracleError         => gvt_OracleError       );
                  --
                  RAISE;

      END src_pa_tasks;

PROCEDURE src_pa_tasks_v2 
	(
		pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE,
        pt_i_SubEntity                   IN      xxmx_migration_metadata.sub_entity%TYPE
	) IS
--
	cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'src_pa_tasks';
    ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
    cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PPM_PRJ_TASKS_STG';
    cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'TASKS';
--
    e_DateError                         EXCEPTION;
    --
    -- Local Cursors
    --
    CURSOR src_pa_tasks_cur 
        (
            p_min_proj_id       number,
            p_max_proj_id       number
        ) is
        SELECT
             xpps.project_name                                                     as project_name
			,xpps.project_number                                                   as project_number				  
            ,REGEXP_REPLACE(pt.long_task_name, '[^[:print:]]','') 	            as task_name
            ,pt.task_number                                                     as task_number
            ,pm_task_reference                                                  as source_task_reference
                  ,''                                                                 financial_task
                  ,REGEXP_REPLACE(pt.description , '[^[:print:]]','')                task_description
                  ,(SELECT t.task_number
                    FROM  xxpa_tasks_stg t-- apps.pa_tasks@xxmx_extract t -- changed by Govardhan on 26/10/22
                    WHERE  t.task_id = pt.parent_task_id)                             parent_task_number
                  ,pt.start_date                                                      planning_start_date
                  --,nvl(pt.completion_date,ppa.project_finish_date )                   planning_end_date  
				  --,nvl(pt.completion_date,p_project_finish_date )                   planning_end_date  
            ,xpps.project_finish_date 												planning_end_date
                 /* ,(SELECT max(ptp.planned_effort)
                    FROM   apps.pa_task_progress_v@xxmx_extract ptp
                    WHERE  pt.task_id = ptp.task_id
                    AND    pt.project_id = ptp.project_id)                            planned_effort*/
                  ,''               planned_effort
                  ,''                                                                 planned_duration
                  /*,(SELECT max(ptp.milestone_flag)
                    FROM   apps.pa_task_progress_v@xxmx_extract ptp
                    WHERE  pt.task_id = ptp.task_id
                    AND    pt.project_id = ptp.project_id)                            milestone_flag*/
                 , '' milestone_flag
                 /* ,(SELECT max(ptp.critical_flag)
                    FROM   apps.pa_task_progress_v@xxmx_extract ptp
                    WHERE  pt.task_id = ptp.task_id
                    AND    pt.project_id = ptp.project_id)                            critical_flag*/
                  , '' critical_flag
                  ,pt.chargeable_flag                                                 chargeable_flag
                  ,pt.billable_flag                                                   billable_flag
                  ,null                                                               capitalizable_flag
                  ,pt.limit_to_txn_controls_flag                                      limit_to_txn_controls_flag
                  ,pt.service_type_code                                               service_type_code
                  --,pt.work_type_id                                                    work_type_id
                  ,null                                                               work_type_id  --Milind blanked it out as per user review
                 /* ,(SELECT papf.employee_number
                   FROM   apps.per_all_people_f@xxmx_extract papf
                   WHERE  1=1
                   AND  papf.person_id =pt.task_manager_person_id
                   AND   TRUNC(sysdate) BETWEEN papf.effective_start_Date AND
                         NVL(papf.effective_end_Date, sysdate))                       manager_person_id*/
                   ,'' manager_person_id
                  ,pt.allow_cross_charge_flag                                         allow_cross_charge_flag
                  ,pt.cc_process_labor_flag                                           cc_process_labor_flag
                  ,pt.cc_process_nl_flag                                              cc_process_nl_flag
                  ,pt.receive_project_invoice_flag                                    receive_project_invoice_flag
                  ,(SELECT hou.name
                    FROM   apps.hr_all_organization_units@xxmx_extract hou
                    WHERE  hou.organization_id = pt.carrying_out_organization_id)     organization_name
				  --,'' 																 organization_name
                  ,''                                                                 reqmnt_code
                  ,''                                                                 sprint
                  ,''                                                                 priority
                  ,''                                                                 schedule_mode
                 /* ,(SELECT pptp.baseline_start_date
                    FROM   apps.pa_proj_task_prog_det_v@xxmx_extract pptp
                    WHERE  pt.task_id = pptp.task_id
                    AND    pt.project_id = pptp.project_id)                          baseline_start_date*/
                 ,'' baseline_start_date
                 /* ,(SELECT pptp.baseline_finish_date
                    FROM   apps.pa_proj_task_prog_det_v@xxmx_extract pptp
                    WHERE  pt.task_id = pptp.task_id
                    AND    pt.project_id = pptp.project_id)                          baseline_finish_date*/
                ,'' baseline_finish_date
                 /* ,(SELECT pptp.baselined_effort
                    FROM   apps.pa_proj_task_prog_det_v@xxmx_extract pptp
                    WHERE  pt.task_id = pptp.task_id
                    AND    pt.project_id = pptp.project_id)                           baseline_effort*/
                , '' baseline_effort
                  ,NULL                                                               baseline_duration
                  ,''                                                                 baseline_allocation
                  ,''                                                                 baseline_labor_cost_amount
                  ,''                                                                 baseline_labor_billed_amount
                  ,''                                                                 baseline_expense_cost_amount
                  ,''                                                                 constraint_type
                  ,''                                                                 constraint_date
                  ,pt.attribute_category                                              attribute_category
                  ,pt.attribute1                                                      attribute1
                  ,pt.attribute2                                                      attribute2
                  ,pt.attribute3                                                      attribute3
                  ,REGEXP_REPLACE(pt.task_name, '[^[:print:]]','')                    attribute4
                  ,pt.task_id                                                         attribute5
                  ,pt.project_id                                                        attribute6
                  ,''                                                                 attribute7
                  ,''                                                                 attribute8
                  ,''                                                                 attribute9
                  ,''                                                                 attribute10
                  ,''                                                                 attribute11
                  ,''                                                                 attribute12
                  ,''                                                                 attribute13
                  ,''                                                                 attribute14
                  ,''                                                                 attribute15
                  ,''                                                                 attribute16
                  ,''                                                                 attribute17
                  ,''                                                                 attribute18
                  ,''                                                                 attribute19
                  ,''                                                                 attribute20
                  ,''                                                                 attribute21
                  ,''                                                                 attribute22
                  ,''                                                                 attribute23
                  ,''                                                                 attribute24
                  ,''                                                                 attribute25
                  ,''                                                                 attribute26
                  ,''                                                                 attribute27
                  ,''                                                                 attribute28
                  ,''                                                                 attribute29
                  ,''                                                                 attribute30
                  ,''                                                                 attribute31
                  ,''                                                                 attribute32
                  ,''                                                                 attribute33
                  ,''                                                                 attribute34
                  ,''                                                                 attribute35
                  ,''                                                                 attribute36
                  ,''                                                                 attribute37
                  ,''                                                                 attribute38
                  ,''                                                                 attribute39
                  ,''                                                                 attribute40
                  ,''                                                                 attribute41
                  ,''                                                                 attribute42
                  ,''                                                                 attribute43
                  ,''                                                                 attribute44
                  ,''                                                                 attribute45
                  ,''                                                                 attribute46
                  ,''                                                                 attribute47
                  ,''                                                                 attribute48
                  ,''                                                                 attribute49
                  ,''                                                                 attribute50
                  ,''                                                                 attribute1_number
                  ,''                                                                 attribute2_number
                  ,''                                                                 attribute3_number
                  ,''                                                                 attribute4_number
                  ,''                                                                 attribute5_number
                  ,''                                                                 attribute6_number
                  ,''                                                                 attribute7_number
                  ,''                                                                 attribute8_number
                  ,''                                                                 attribute9_number
                  ,''                                                                 attribute10_number
                  ,''                                                                 attribute11_number
                  ,''                                                                 attribute12_number
                  ,''                                                                 attribute13_number
                  ,''                                                                 attribute14_number
                  ,''                                                                 attribute15_number
                  ,''                                                                 attribute1_date
                  ,''                                                                 attribute2_date
                  ,''                                                                 attribute3_date
                  ,''                                                                 attribute4_date
                  ,''                                                                 attribute5_date
                  ,''                                                                 attribute6_date
                  ,''                                                                 attribute7_date
                  ,''                                                                 attribute8_date
                  ,''                                                                 attribute9_date
                  ,''                                                                 attribute10_date
                  ,''                                                                 attribute11_date
                  ,''                                                                 attribute12_date
                  ,''                                                                 attribute13_date
                  ,''                                                                 attribute14_date
                  ,''                                                                 attribute15_date
                  ,NULL                                                               source_application_code
                  --,p_organization_name                                              ou_name
                  ,NULL                                                               ou_name
                  ,null                                                               task_rank
        FROM
            xxpa_tasks_stg                                   pt,
			xxmx_ppm_projects_stg                            xpps
        WHERE  pt.project_id                          = xpps.project_id
        and    xpps.project_id between p_min_proj_id and p_max_proj_id
        AND    ( pt.completion_date                              IS NULL
                    --OR pt.completion_date                          > SYSDATE
                      OR pt.completion_date  >= to_date(gvv_migration_date,'DD-MON-YYYY')                    
                    )
        ;


         -- Local Type Variables
         TYPE src_pa_tasks_tbl IS TABLE OF src_pa_tasks_cur%ROWTYPE INDEX BY BINARY_INTEGER;
         src_pa_tasks_tb  src_pa_tasks_tbl;

         ex_dml_errors             EXCEPTION;
         PRAGMA EXCEPTION_INIT(ex_dml_errors, -24381);
         l_error_count             NUMBER;
		 l_proj_count				NUMBER := 0;
    --
    v_min_project_id                            number;
    v_max_project_id                            number;
    v_project_from                              number;
    v_project_to                                number;
    --
BEGIN
    --
           gvv_ReturnStatus  := '';
              gvt_ReturnMessage := '';
              gvv_ProgressIndicator := '0000';
              xxmx_utilities_pkg.clear_messages
                  (
                  pt_i_ApplicationSuite     => gct_ApplicationSuite
                  ,pt_i_Application         => gct_Application
                  ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                  ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                  ,pt_i_Phase               => ct_Phase
                  ,pt_i_MessageType         => 'MODULE'
                  ,pv_o_ReturnStatus        => gvv_ReturnStatus
                  );
              --
              IF   gvv_ReturnStatus = 'F'
              THEN
                  xxmx_utilities_pkg.log_module_message(
                       pt_i_ApplicationSuite    => gct_ApplicationSuite
                      ,pt_i_Application         => gct_Application
                      ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                      ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                      ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                      ,pt_i_Phase               => ct_Phase
                      ,pt_i_Severity            => 'ERROR'
                      ,pt_i_PackageName         => gcv_PackageName
                      ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                      ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                      ,pt_i_ModuleMessage       => 'Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                      ,pt_i_OracleError         => gvt_ReturnMessage    );
                  --
                  RAISE e_ModuleError;
              END IF;
              --

            xxmx_utilities_pkg.log_module_message
                (pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'Begin Procedure '|| TO_CHAR(systimestamp, 'DDMMYYYYHH24MISS')
                ,pt_i_OracleError         => gvt_ReturnMessage
                );
            --
			  DELETE
              FROM    XXMX_STG.XXMX_PPM_PRJ_TASKS_STG ;

              COMMIT;
              --

            gvv_ProgressIndicator := '0020';
            --
            gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
            --
            /*
            ** If the Migration Set Name is NULL then the Migration has not been initialized.
            */
            --
    IF   gvt_MigrationSetName IS NULL THEN
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set not initialized.';
               --
               RAISE e_ModuleError;
               --
    ELSE
        gvv_ProgressIndicator := '0030';
        select min(project_id),max(project_id) into v_min_project_id,v_max_project_id from xxmx_ppm_projects_stg;
        --
        xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => 'Extracting "'||pt_i_SubEntity||'":'
                    ,pt_i_OracleError       => NULL
                    );
        --
/*        xxmx_utilities_pkg.init_migration_details
                    (
                     pt_i_ApplicationSuite => gct_ApplicationSuite
                    ,pt_i_Application      => gct_Application
                    ,pt_i_BusinessEntity   => gv_i_BusinessEntity
                    ,pt_i_SubEntity        => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                    ,pt_i_StagingTable     => cv_StagingTable
                    ,pt_i_ExtractStartDate => SYSDATE
                    ); */ -- getting error so commentthis out for now MA 04/01/23 13:49

               --
        v_project_from := v_min_project_id;
        v_project_to  :=v_min_project_id+999;
        loop
            exit when v_project_from > v_max_project_id;
       
            OPEN src_pa_tasks_cur ( v_project_from, v_project_to ) ;
            LOOP
                FETCH src_pa_tasks_cur  BULK COLLECT INTO src_pa_tasks_tb LIMIT 1000;
                EXIT WHEN src_pa_tasks_tb.COUNT=0;
            --
            FORALL I IN 1..src_pa_tasks_tb.COUNT
            --
                INSERT INTO XXMX_PPM_PRJ_TASKS_STG
                                              (
                                              migration_set_id
                                              ,migration_status
                                              ,migration_set_name
                                              ,project_name
                                              ,project_number
                                              ,task_name
                                              ,task_number
                                              ,source_task_reference
                                              ,financial_task
                                              ,task_description
                                              ,parent_task_number
                                              ,planning_start_date
                                              ,planning_end_date
                                              ,planned_effort
                                              ,planned_duration
                                              ,milestone_flag
                                              ,critical_flag
                                              ,chargeable_flag
                                              ,billable_flag
                                              ,capitalizable_flag
                                              ,limit_to_txn_controls_flag
                                              ,service_type_code
                                              ,work_type_id
                                              ,manager_person_id
                                              ,allow_cross_charge_flag
                                              ,cc_process_labor_flag
                                              ,cc_process_nl_flag
                                              ,receive_project_invoice_flag
                                              ,reqmnt_code
                                              ,sprint
                                              ,priority
                                              ,schedule_mode
                                              ,baseline_start_date
                                              ,baseline_finish_date
                                              ,baseline_effort
                                              ,baseline_duration
                                              ,baseline_allocation
                                              ,baseline_labor_cost_amount
                                              ,baseline_labor_billed_amount
                                              ,baseline_expense_cost_amount
                                              ,CONSTRAINT_TYPE_CODE
                                              ,constraint_date
                                              ,attribute_category
                                              ,attribute1
                                              ,attribute2
                                              ,attribute3
                                              ,attribute4
                                              ,attribute5
                                              ,attribute6
                                              ,attribute7
                                              ,attribute8
                                              ,attribute9
                                              ,attribute10
                                              ,attribute11
                                              ,attribute12
                                              ,attribute13
                                              ,attribute14
                                              ,attribute15
                                              ,attribute16
                                              ,attribute17
                                              ,attribute18
                                              ,attribute19
                                              ,attribute20
                                              ,attribute21
                                              ,attribute22
                                              ,attribute23
                                              ,attribute24
                                              ,attribute25
                                              ,attribute26
                                              ,attribute27
                                              ,attribute28
                                              ,attribute29
                                              ,attribute30
                                              ,attribute31
                                              ,attribute32
                                              ,attribute33
                                              ,attribute34
                                              ,attribute35
                                              ,attribute36
                                              ,attribute37
                                              ,attribute38
                                              ,attribute39
                                              ,attribute40
                                              ,attribute41
                                              ,attribute42
                                              ,attribute43
                                              ,attribute44
                                              ,attribute45
                                              ,attribute46
                                              ,attribute47
                                              ,attribute48
                                              ,attribute49
                                              ,attribute50
                                              ,attribute1_number
                                              ,attribute2_number
                                              ,attribute3_number
                                              ,attribute4_number
                                              ,attribute5_number
                                              ,attribute6_number
                                              ,attribute7_number
                                              ,attribute8_number
                                              ,attribute9_number
                                              ,attribute10_number
                                              ,attribute11_number
                                              ,attribute12_number
                                              ,attribute13_number
                                              ,attribute14_number
                                              ,attribute15_number
                                              ,attribute1_date
                                              ,attribute2_date
                                              ,attribute3_date
                                              ,attribute4_date
                                              ,attribute5_date
                                              ,attribute6_date
                                              ,attribute7_date
                                              ,attribute8_date
                                              ,attribute9_date
                                              ,attribute10_date
                                              ,attribute11_date
                                              ,attribute12_date
                                              ,attribute13_date
                                              ,attribute14_date
                                              ,attribute15_date
                                              ,source_application_code
                                              ,batch_name
                                              ,created_by
                                              ,creation_date
                                              ,last_updated_by
                                              ,last_update_date
                                              ,batch_id
                                              ,organization_name
                                          )
                      VALUES
                                          (
                                               pt_i_MigrationSetID                                             
                                              ,'EXTRACTED'
                                              , gvt_MigrationSetName                                              
                                              ,src_pa_tasks_tb(i).project_name
                                              ,src_pa_tasks_tb(i).project_number
                                              ,src_pa_tasks_tb(i).task_name
                                              ,src_pa_tasks_tb(i).task_number
                                              ,src_pa_tasks_tb(i).source_task_reference
                                              ,src_pa_tasks_tb(i).financial_task
                                              ,src_pa_tasks_tb(i).task_description
                                              ,src_pa_tasks_tb(i).parent_task_number
                                              ,src_pa_tasks_tb(i).planning_start_date
                                              ,src_pa_tasks_tb(i).planning_end_date
                                              ,src_pa_tasks_tb(i).planned_effort
                                              ,src_pa_tasks_tb(i).planned_duration
                                              ,src_pa_tasks_tb(i).milestone_flag
                                              ,src_pa_tasks_tb(i).critical_flag
                                              ,src_pa_tasks_tb(i).chargeable_flag
                                              ,src_pa_tasks_tb(i).billable_flag
                                              ,src_pa_tasks_tb(i).capitalizable_flag
                                              ,src_pa_tasks_tb(i).limit_to_txn_controls_flag
                                              ,src_pa_tasks_tb(i).service_type_code
                                              ,src_pa_tasks_tb(i).work_type_id
                                              ,src_pa_tasks_tb(i).manager_person_id
                                              ,src_pa_tasks_tb(i).allow_cross_charge_flag
                                              ,src_pa_tasks_tb(i).cc_process_labor_flag
                                              ,src_pa_tasks_tb(i).cc_process_nl_flag
                                              ,src_pa_tasks_tb(i).receive_project_invoice_flag
                                              ,src_pa_tasks_tb(i).reqmnt_code
                                              ,src_pa_tasks_tb(i).sprint
                                              ,src_pa_tasks_tb(i).priority
                                              ,src_pa_tasks_tb(i).schedule_mode
                                              ,src_pa_tasks_tb(i).baseline_start_date
                                              ,src_pa_tasks_tb(i).baseline_finish_date
                                              ,src_pa_tasks_tb(i).baseline_effort
                                              ,src_pa_tasks_tb(i).baseline_duration
                                              ,src_pa_tasks_tb(i).baseline_allocation
                                              ,src_pa_tasks_tb(i).baseline_labor_cost_amount
                                              ,src_pa_tasks_tb(i).baseline_labor_billed_amount
                                              ,src_pa_tasks_tb(i).baseline_expense_cost_amount
                                              ,src_pa_tasks_tb(i).constraint_type
                                              ,src_pa_tasks_tb(i).constraint_date
                                              ,src_pa_tasks_tb(i).attribute_category
                                              ,src_pa_tasks_tb(i).attribute1
                                              ,src_pa_tasks_tb(i).attribute2
                                              ,src_pa_tasks_tb(i).attribute3
                                              ,src_pa_tasks_tb(i).attribute4
                                              ,src_pa_tasks_tb(i).attribute5
                                              ,src_pa_tasks_tb(i).attribute6
                                              ,src_pa_tasks_tb(i).attribute7
                                              ,src_pa_tasks_tb(i).attribute8
                                              ,src_pa_tasks_tb(i).attribute9
                                              ,src_pa_tasks_tb(i).attribute10
                                              ,src_pa_tasks_tb(i).attribute11
                                              ,src_pa_tasks_tb(i).attribute12
                                              ,src_pa_tasks_tb(i).attribute13
                                              ,src_pa_tasks_tb(i).attribute14
                                              ,src_pa_tasks_tb(i).attribute15
                                              ,src_pa_tasks_tb(i).attribute16
                                              ,src_pa_tasks_tb(i).attribute17
                                              ,src_pa_tasks_tb(i).attribute18
                                              ,src_pa_tasks_tb(i).attribute19
                                              ,src_pa_tasks_tb(i).attribute20
                                              ,src_pa_tasks_tb(i).attribute21
                                              ,src_pa_tasks_tb(i).attribute22
                                              ,src_pa_tasks_tb(i).attribute23
                                              ,src_pa_tasks_tb(i).attribute24
                                              ,src_pa_tasks_tb(i).attribute25
                                              ,src_pa_tasks_tb(i).attribute26
                                              ,src_pa_tasks_tb(i).attribute27
                                              ,src_pa_tasks_tb(i).attribute28
                                              ,src_pa_tasks_tb(i).attribute29
                                              ,src_pa_tasks_tb(i).attribute30
                                              ,src_pa_tasks_tb(i).attribute31
                                              ,src_pa_tasks_tb(i).attribute32
                                              ,src_pa_tasks_tb(i).attribute33
                                              ,src_pa_tasks_tb(i).attribute34
                                              ,src_pa_tasks_tb(i).attribute35
                                              ,src_pa_tasks_tb(i).attribute36
                                              ,src_pa_tasks_tb(i).attribute37
                                              ,src_pa_tasks_tb(i).attribute38
                                              ,src_pa_tasks_tb(i).attribute39
                                              ,src_pa_tasks_tb(i).attribute40
                                              ,src_pa_tasks_tb(i).attribute41
                                              ,src_pa_tasks_tb(i).attribute42
                                              ,src_pa_tasks_tb(i).attribute43
                                              ,src_pa_tasks_tb(i).attribute44
                                              ,src_pa_tasks_tb(i).attribute45
                                              ,src_pa_tasks_tb(i).attribute46
                                              ,src_pa_tasks_tb(i).attribute47
                                              ,src_pa_tasks_tb(i).attribute48
                                              ,src_pa_tasks_tb(i).attribute49
                                              ,src_pa_tasks_tb(i).attribute50
                                              ,src_pa_tasks_tb(i).attribute1_number
                                              ,src_pa_tasks_tb(i).attribute2_number
                                              ,src_pa_tasks_tb(i).attribute3_number
                                              ,src_pa_tasks_tb(i).attribute4_number
                                              ,src_pa_tasks_tb(i).attribute5_number
                                              ,src_pa_tasks_tb(i).attribute6_number
                                              ,src_pa_tasks_tb(i).attribute7_number
                                              ,src_pa_tasks_tb(i).attribute8_number
                                              ,src_pa_tasks_tb(i).attribute9_number
                                              ,src_pa_tasks_tb(i).attribute10_number
                                              ,src_pa_tasks_tb(i).attribute11_number
                                              ,src_pa_tasks_tb(i).attribute12_number
                                              ,src_pa_tasks_tb(i).attribute13_number
                                              ,src_pa_tasks_tb(i).attribute14_number
                                              ,src_pa_tasks_tb(i).attribute15_number
                                              ,src_pa_tasks_tb(i).attribute1_date
                                              ,src_pa_tasks_tb(i).attribute2_date
                                              ,src_pa_tasks_tb(i).attribute3_date
                                              ,src_pa_tasks_tb(i).attribute4_date
                                              ,src_pa_tasks_tb(i).attribute5_date
                                              ,src_pa_tasks_tb(i).attribute6_date
                                              ,src_pa_tasks_tb(i).attribute7_date
                                              ,src_pa_tasks_tb(i).attribute8_date
                                              ,src_pa_tasks_tb(i).attribute9_date
                                              ,src_pa_tasks_tb(i).attribute10_date
                                              ,src_pa_tasks_tb(i).attribute11_date
                                              ,src_pa_tasks_tb(i).attribute12_date
                                              ,src_pa_tasks_tb(i).attribute13_date
                                              ,src_pa_tasks_tb(i).attribute14_date
                                              ,src_pa_tasks_tb(i).attribute15_date
                                              ,src_pa_tasks_tb(i).source_application_code
                                              ,g_batch_name                                 --src_pa_tasks_tb(i).batch_name
                                              ,xxmx_utilities_pkg.gvv_UserName              --src_pa_tasks_tb(i).created_by
                                              ,SYSDATE                                      --src_pa_tasks_tb(i).creation_date
                                              ,xxmx_utilities_pkg.gvv_UserName               --src_pa_tasks_tb(i).last_updated_by
                                              ,SYSDATE                                      --src_pa_tasks_tb(i).last_update_date
--                                              ,to_char(TO_DATE(SYSDATE, 'DD-MON-RRRR'),'DDMMRRRRHHMISS')          --src_pa_tasks_tb(i).batch_id
                                              ,to_char(SYSDATE, 'DDMMRRRRHHMISS')          --src_pa_tasks_tb(i).batch_id
                                              ,src_pa_tasks_tb(i).organization_name
                                          );
              --
              END LOOP;

              --

             IF src_pa_tasks_cur%ISOPEN
             THEN
               --
               CLOSE src_pa_tasks_cur;
               --
             END IF;
              --

            gvv_ProgressIndicator := '0100';
            --
            l_proj_count := l_proj_count + 1;

			IF MOD(l_proj_count,100) = 0 THEN
				COMMIT;
			END IF;

               --
               --
            v_project_from:= v_project_from+999;
            v_project_to  := v_project_to  +999;
            
        END LOOP;
    END IF;
          --
          --
          --
          --
              --
EXCEPTION

            WHEN ex_dml_errors THEN
                  l_error_count := SQL%BULK_EXCEPTIONS.count;
                  DBMS_OUTPUT.put_line('Number of failures: ' || l_error_count);
                  FOR i IN 1 .. l_error_count LOOP

                    gvt_ModuleMessage := 'Error: ' || i ||
                                         ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
                                         ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE);

                    xxmx_utilities_pkg.log_module_message(
                              pt_i_ApplicationSuite    => gct_ApplicationSuite
                             ,pt_i_Application         => gct_Application
                             ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                             ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                             ,pt_i_Phase               => ct_Phase
                             ,pt_i_Severity            => 'ERROR'
                             ,pt_i_PackageName         => gcv_PackageName
                             ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                             ,pt_i_ModuleMessage       => gvt_ModuleMessage
                             ,pt_i_OracleError         => gvt_ReturnMessage   );

                    DBMS_OUTPUT.put_line('Error: ' || i ||
                                        ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
                                        ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
                  END LOOP;

            WHEN e_ModuleError THEN
                         --
                   IF src_pa_tasks_cur%ISOPEN
                   THEN
                     --
                     CLOSE src_pa_tasks_cur;
                     --
                   END IF;

                 xxmx_utilities_pkg.log_module_message(
                              pt_i_ApplicationSuite    => gct_ApplicationSuite
                             ,pt_i_Application         => gct_Application
                             ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                             ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                             ,pt_i_Phase               => ct_Phase
                             ,pt_i_Severity            => 'ERROR'
                             ,pt_i_PackageName         => gcv_PackageName
                             ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                             ,pt_i_ModuleMessage       => gvt_ModuleMessage
                             ,pt_i_OracleError         => gvt_ReturnMessage       );
                  --
                  RAISE;
                  --** END e_ModuleError Exception
                  --
            WHEN e_DateError THEN
                         --
                  IF src_pa_tasks_cur%ISOPEN
                   THEN
                     --
                     CLOSE src_pa_tasks_cur;
                     --
                   END IF;

                 xxmx_utilities_pkg.log_module_message(
                              pt_i_ApplicationSuite    => gct_ApplicationSuite
                             ,pt_i_Application         => gct_Application
                             ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                             ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                             ,pt_i_Phase               => ct_Phase
                             ,pt_i_Severity            => 'ERROR'
                             ,pt_i_PackageName         => gcv_PackageName
                             ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                             ,pt_i_ModuleMessage       => 'From, to or Prev Tax Year variable not populated'
                             ,pt_i_OracleError         => gvt_ReturnMessage       );
                     --
                     RAISE;

            WHEN OTHERS THEN

                  IF src_pa_tasks_cur%ISOPEN
                   THEN
                     --
                     CLOSE src_pa_tasks_cur;
                     --
                   END IF;

                  --
                  ROLLBACK;
                  --
                  gvt_OracleError := SUBSTR(SQLERRM
                                          ||'** ERROR_BACKTRACE: '
                                          ||dbms_utility.format_error_backtrace
                                          ,1
                                          ,4000
                                          );
                  --
                  xxmx_utilities_pkg.log_module_message(
                              pt_i_ApplicationSuite    => gct_ApplicationSuite
                             ,pt_i_Application         => gct_Application
                             ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                             ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                             ,pt_i_Phase               => ct_Phase
                             ,pt_i_Severity            => 'ERROR'
                             ,pt_i_PackageName         => gcv_PackageName
                             ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                             ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                             ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                             ,pt_i_OracleError         => gvt_OracleError       );
                  --
                  RAISE;

END src_pa_tasks_v2;

     /*********************************************************
     -----------------src_pa_classifications-------------------
     **********************************************************/

     PROCEDURE src_pa_classifications
                            (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
                            ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)

     AS
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
    CURSOR pa_classifications_cur
        (
            p_project_id                   NUMBER,
			p_project_name                 VARCHAR2,
			p_project_long_name            VARCHAR2,
            p_project_number               VARCHAR2,
			p_organization_name            VARCHAR2
        ) IS
        SELECT
             p_project_name 										AS project_name
            ,p_project_long_name 									AS project_long_name
            ,p_project_number								    	AS project_number
            ,ppc.class_category                                     AS CLASS_CATEGORY
            ,ppc.class_code                                         AS CLASS_CODE
            ,null                                                   AS CODE_PERCENTAGE
            ,g_batch_name                                           AS BATCH_NAME
            ,sysdate                                                AS CREATION_DATE
            ,xxmx_utilities_pkg.gvv_UserName                        AS CREATED_BY
            ,sysdate                                                AS LAST_UPDATE_DATE
            ,xxmx_utilities_pkg.gvv_UserName                        AS LAST_UPDATED_BY
            ,to_char(SYSDATE, 'DDMMRRRRHHMISS')                     AS batch_id
			,NULL                                                   AS ou_name
        FROM
            apps.pa_project_classes@xxmx_extract         ppc
                 -- ,apps.hr_all_organization_units@xxmx_extract  org
                  --,XXMX_CORE.XXMX_PPM_PROJECTS_SCOPE_MV           xps
                --  , xxmx_ppm_projects_stg ppa
        WHERE --ppa.project_id                        = ppc.project_id
            --and   ppa.project_id                        = xps.project_id
            --AND ppa.org_id                              = org.organization_id 
			ppc.project_id                                =  p_project_id
            and ppc.class_category                        not in ('CAIS', 'Customer Type','Reporting Entity')   --Milind added
--            AND org.NAME                               IN (SELECT PARAMETER_VALUE
--                                                                FROM XXMX_MIGRATION_PARAMETERS
--                                                                WHERE PARAMETER_CODE = 'ORGANIZATION_NAME'
--                                                                AND APPLICATION_SUITE= 'FIN'
--                                                                AND APPLICATION = 'ALL'
--                                                               )
            ;
	CURSOR src_projects_scope 
    IS 
    SELECT project_id 
			, project_name 
			, project_long_name 
			, project_number 
			, proj_owning_org 
			, project_finish_date 
			, organization_name 	
      FROM  xxmx_ppm_projects_stg; 

       --
       --**********************
       --** Record Declarations
       --**********************
       --
         TYPE pa_classifications_tbl IS TABLE OF pa_classifications_cur%ROWTYPE INDEX BY BINARY_INTEGER;
         pa_classifications_tb pa_classifications_tbl;
       --
       --************************
       --** Constant Declarations
       --************************
       --
        cv_ProcOrFuncName                   CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'src_pa_classifications';
        cv_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PPM_PRJ_CLASS_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'CLASSIFICATIONS';


       --
       --************************
       --** Variable Declarations
       --************************
       --
       --
       --*************************
       --** Exception Declarations
       --*************************
       --
       e_ModuleError                         EXCEPTION;
       e_DateError                           EXCEPTION;
       ex_dml_errors                         EXCEPTION;
       PRAGMA EXCEPTION_INIT(ex_dml_errors, -24381);
       l_error_count             NUMBER;
	   l_proj_count				 NUMBER := 0;
       --
       --** END Declarations **
       --
       -- Local Type Variables


   BEGIN
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0000';
        xxmx_utilities_pkg.clear_messages
            (
            pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'MODULE'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        --
        IF   gvv_ReturnStatus = 'F'
        THEN
            xxmx_utilities_pkg.log_module_message(
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'ERROR'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                ,pt_i_OracleError         => gvt_ReturnMessage    );
            --
            RAISE e_ModuleError;
        END IF;
        --
        --
         gvv_ProgressIndicator := '0010';
         xxmx_utilities_pkg.log_module_message(
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'Deleting from "' || cv_StagingTable   || '".'
                ,pt_i_OracleError         => gvt_ReturnMessage  );
        --
		--xxmx_utilities_pkg.truncate_table('xxmx_stg.XXMX_PPM_PRJ_CLASS_STG');
		--EXECUTE IMMEDIATE 'TRUNCATE TABLE XXMX_STG.XXMX_PPM_PRJ_CLASS_STG';
	    --DELETE       FROM    XXMX_PPM_PRJ_CLASS_STG ;

        COMMIT;
        --

        gvv_ProgressIndicator := '0020';
        --
        gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
        --
        /*
        ** If the Migration Set Name is NULL then the Migration has not been initialized.
        */
        --
        IF   gvt_MigrationSetName IS NOT NULL
        THEN
            --
            gvv_ProgressIndicator := '0030';
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '- Extracting "'
                                          ||pt_i_SubEntity
                                          ||'":'
                 ,pt_i_OracleError       => NULL
                 );
            --
            /*
            ** The Migration Set has been initialised, so now initialize the detail record
            ** for the current entity.
            */
            --
            --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
            --**                  table based on the Application Suite, Application and Business Entity parameters.
            --**
            --**                  Removed "entity" from procedure_name.
            --
           /* xxmx_utilities_pkg.init_migration_details
                 (
                  pt_i_ApplicationSuite => gct_ApplicationSuite
                 ,pt_i_Application      => gct_Application
                 ,pt_i_BusinessEntity   => gv_i_BusinessEntity
                 ,pt_i_SubEntity        => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                 ,pt_i_StagingTable     => cv_StagingTable
                 ,pt_i_ExtractStartDate => SYSDATE
                 );*/
            --
            --** ISV 21/10/2020 - "pt_i_StagingTable" no longer needs to be passed as a parameter from the STG_MAIN procedure
            --**                  as the table name will never change so replace with new constant "ct_StgTable".
            --
            --**                  We will still keep the table name in the Metadata table as that can be used for reporting
            --**                  purposes.
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '  - Staging Table "'
                                          ||cv_StagingTable
                                          ||'" reporting details initialised.'
                 ,pt_i_OracleError       => NULL
                 );
            --
            gvv_ProgressIndicator := '0040';
            --
            --** Extract the Projects and insert into the staging table.
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '  - Extracting data into "'
                                          ||cv_StagingTable
                                          ||'".'
                 ,pt_i_OracleError       => NULL
                 );
            --
            --** ISV 21/10/2020 - The staging table is in the xxmx_stg schema but should not need to be prefixed as there should
            --**                  by a Synonym in the xxmx_core schema to that table.
            --

		FOR x IN src_projects_scope
		LOOP
            OPEN pa_classifications_cur ( x.project_id,
										  x.project_name,
										  x.project_long_name,
                                          x.project_number,
										  x.organization_name
										) ;
                --

          /*  gvv_ProgressIndicator := '0050';
            xxmx_utilities_pkg.log_module_message(
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       =>'Cursor Open pa_classifications_cur'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );*/
            --
            LOOP
            --
           /* gvv_ProgressIndicator := '0060';
            xxmx_utilities_pkg.log_module_message(
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       =>'Inside the Cursor loop'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );*/

            --
            FETCH pa_classifications_cur  BULK COLLECT INTO pa_classifications_tb LIMIT 1000;
            --
/* 
            gvv_ProgressIndicator := '0070';
            xxmx_utilities_pkg.log_module_message(
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       => 'Cursor pa_classifications_cur Fetch into pa_classifications_tb'
                   ,pt_i_OracleError         => gvt_ReturnMessage  ); */
            --
            EXIT WHEN pa_classifications_tb.COUNT=0;
            --
            FORALL I IN 1..pa_classifications_tb.COUNT SAVE EXCEPTIONS
            --
                -- INSERT INTO XXMX_PPM_PRJ_CLASS_STG 
				INSERT INTO XXMX_PPM_PRJ_CLASS_STG
				 (
                                    migration_set_id
                                   ,migration_set_name
                                   ,migration_status
                                   ,project_name
									        ,class_category
									        ,class_code
									        ,code_percentage
									        ,batch_name
									        ,created_by
									        ,creation_date
									        ,last_updated_by
									        ,last_update_date
                                   ,batch_id
                                   ,organization_name
                                   ,project_long_name
                                   ,project_number
									       )
                                  VALUES
                                  (
                                   pt_i_MigrationSetID
                                  ,gvt_MigrationSetName
                                  ,'Extracted'
                                  ,pa_classifications_tb(i).project_name         --project_name
										    ,pa_classifications_tb(i).class_category       --class_category
										    ,pa_classifications_tb(i).class_code           --class_code
										    ,pa_classifications_tb(i).code_percentage      --code_percentage
										    ,g_batch_name                                  --pa_classifications_tb(i).batch_name                          --batch_name
                                  ,xxmx_utilities_pkg.gvv_UserName
                                  ,sysdate
                                  ,xxmx_utilities_pkg.gvv_UserName
                                  ,sysdate
--                                  ,to_char(TO_DATE(SYSDATE, 'DD-MON-RRRR'),'DDMMRRRRHHMISS')
                                  ,to_char(SYSDATE, 'DDMMRRRRHHMISS')
                                  ,pa_classifications_tb(i).ou_name              --ou_name
                                  ,pa_classifications_tb(i).project_long_name
                                  ,pa_classifications_tb(i).project_number
										   );
                --
                END LOOP;
                --
              /*   gvv_ProgressIndicator := '0080';
                  xxmx_utilities_pkg.log_module_message(
                            pt_i_ApplicationSuite    => gct_ApplicationSuite
                           ,pt_i_Application         => gct_Application
                           ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                           ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                           ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                           ,pt_i_Phase               => ct_Phase
                           ,pt_i_Severity            => 'NOTIFICATION'
                           ,pt_i_PackageName         => gcv_PackageName
                           ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                           ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                           ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                           ,pt_i_OracleError         => gvt_ReturnMessage       );*/

                --

                --

                --
                --
             /*  gvv_ProgressIndicator := '0090';
              xxmx_utilities_pkg.log_module_message(
                               pt_i_ApplicationSuite    => gct_ApplicationSuite
                              ,pt_i_Application         => gct_Application
                              ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                              ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase               => ct_Phase
                              ,pt_i_Severity            => 'NOTIFICATION'
                              ,pt_i_PackageName         => gcv_PackageName
                              ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                              ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage       => 'Close the Cursor pa_classifications_cur'
                              ,pt_i_OracleError         => gvt_ReturnMessage       );*/
             --


             IF pa_classifications_cur%ISOPEN
             THEN
                  --
                     CLOSE pa_classifications_cur;
                  --
             END IF;
			 l_proj_count := l_proj_count + 1;

			 IF MOD(l_proj_count,100) = 0 THEN

			 COMMIT;

			 END IF;


		END LOOP;	 

           gvv_ProgressIndicator := '0100';
            --
            /*
            ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
            ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
            ** is reached.
            */
            --
            --** ISV 21/10/2020 - Replace "pt_i_ClientSchemaName" (no longer passed into the extract procedures) with new constant "gct_StgSchema".
            --**                  Replace "pt_i_StagingTable" (no longer passed into the extract procedures) with new constant "ct_StgTable"
            --
   /*          gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                 (
                                  gct_StgSchema
                                 ,cv_StagingTable
                                 ,pt_i_MigrationSetID
                                 );
            --
            COMMIT; */


            xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extraction complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '0110';
               --
               --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
               --**                  table based on the Application Suite, Application, Business Entity and Sub-Entity parameters.
               --**
               --**                  Removed "entity" from procedure_name.
               --
               xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gv_i_BusinessEntity
                    ,pt_i_SubEntity               => cv_i_BusinessEntityLevel
                    ,pt_i_Phase                   => ct_Phase
                    ,pt_i_ExtractCompletionDate   => SYSDATE
                    ,pt_i_ExtractRowCount         => gvn_RowCount
                    ,pt_i_TransformTable          => NULL
                    ,pt_i_TransformStartDate      => NULL
                    ,pt_i_TransformCompletionDate => NULL
                    ,pt_i_ExportFileName          => NULL
                    ,pt_i_ExportStartDate         => NULL
                    ,pt_i_ExportCompletionDate    => NULL
                    ,pt_i_ExportRowCount          => NULL
                    ,pt_i_ErrorFlag               => NULL
                    );
               --
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Migration Table "'
                                             ||cv_StagingTable
                                             ||'" reporting details updated.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
          ELSE
               --
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set not initialized.';
               --
               --
               RAISE e_ModuleError;
               --
               --
          END IF;
          --
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gv_i_BusinessEntity
               ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gcv_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          --

    EXCEPTION
      WHEN ex_dml_errors THEN
         l_error_count := SQL%BULK_EXCEPTIONS.count;
         DBMS_OUTPUT.put_line('Number of failures: ' || l_error_count);
         FOR i IN 1 .. l_error_count LOOP

           gvt_ModuleMessage := 'Error: ' || i ||
                                ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
                                ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE);

           xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage
                    ,pt_i_OracleError         => gvt_ReturnMessage   );

           DBMS_OUTPUT.put_line('Error: ' || i ||
             ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
             ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
         END LOOP;

      WHEN e_ModuleError THEN
                --
        IF pa_classifications_cur%ISOPEN
        THEN
            --
            CLOSE pa_classifications_cur;
            --
        END IF;

        xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage
                    ,pt_i_OracleError         => gvt_ReturnMessage       );
         --
         RAISE;
         --** END e_ModuleError Exception
         --
      WHEN OTHERS THEN

         IF pa_classifications_cur%ISOPEN
         THEN
             --
             CLOSE pa_classifications_cur;
             --
         END IF;
         --
         ROLLBACK;
         --
         gvt_OracleError := SUBSTR(
                                        SQLERRM
                                    ||'** ERROR_BACKTRACE: '
                                    ||dbms_utility.format_error_backtrace
                                    ,1
                                    ,4000
                                    );
         --
         xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                    ,pt_i_OracleError         => gvt_OracleError       );
         --
         RAISE;
         -- Hr_Utility.raise_error@xxmx_extract;



     END src_pa_classifications;


     /*********************************************************
     -----------------src_pa_trx_control-------------------
     **********************************************************/

     PROCEDURE src_pa_trx_control
                            (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                            ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)

     AS
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
             CURSOR pa_trx_control_cur ( p_project_id NUMBER
										, p_project_name  VARCHAR2
										, p_project_number VARCHAR2
										, p_proj_owning_org  VARCHAR2
										, p_project_finish_date  VARCHAR2
										, p_organization_name VARCHAR2
										)
             IS

               SELECT
                   xxmx_stg.xxmx_ppm_prj_trx_control_seq.nextval AS  txn_ctrl_reference,
                   src.project_name,
                   src.project_number,
                   src.task_number,
                   src.task_name,
                   src.expenditure_category_name,
                   src.expenditure_type,
                   src.non_labor_resource,
                   src.person_number,
                   src.person_name,
                   src.person_emailid,
                   src.person_type,
                   src.job_name,
                   src.organization_name,
                   src.chargeable_flag,
                   src.billable_flag,
                   src.capitalizable_flag,
                   src.start_date_active,
                   src.end_date_active
               from
               (SELECT
                     -- ppa.project_name                                                          AS  project_name
                     --,ppa.project_number                                                      AS  project_number
					 p_project_name						 AS  project_name
					 ,p_project_number					 AS  project_number					 
                     ,ptc.task_number                                                    AS  task_number
                     ,ptc.task_name                                                      AS  task_name
                     ,ptc.expenditure_category                                          as  expenditure_category_name
                     ,ptc.expenditure_type                                              as  expenditure_type
                     ,ptc.non_labor_resource                                            AS  non_labor_resource
                     ,NULL                                   AS  person_number
                     ,null                                      AS  person_name
                     ,null                                    AS  person_emailid
                     ,null           AS  person_type
                     ,NULL                                                              AS  job_name
                     --,org.name                                                         AS organization_name
					 --,p_organization_name						 AS organization_name
					 ,NULL   						 AS organization_name
                     ,ptc.chargeable_flag                                               AS chargeable_flag
                     ,ptc.billable_indicator                                            AS billable_flag
                     ,NULL                                                              AS capitalizable_flag
                     ,ptc.start_date_active                                             AS start_date_active
                     ,ptc.end_date_active                                               AS end_date_active
                FROM   XXMX_PPM_PROJ_TRX_CTL_V ptc
				WHERE ptc.project_id = p_project_id
                  AND nvl(ptc.expenditure_type,'x') != 'Cost of Sales'
				) src;



			CURSOR src_projects_scope 
			IS 
			SELECT project_id 
					, project_name 
					, project_number 
					, proj_owning_org 
					, project_finish_date 
					, organization_name 	
			  FROM  xxmx_ppm_projects_stg; 

       --
       --**********************
       --** Record Declarations
       --**********************
       --
         TYPE pa_trx_control_tbl IS TABLE OF pa_trx_control_cur%ROWTYPE INDEX BY BINARY_INTEGER;
         pa_trx_control_tb pa_trx_control_tbl;
       --
       --************************
       --** Constant Declarations
       --************************
       --
        cv_ProcOrFuncName                   CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'src_pa_trx_control';
        cv_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PPM_PRJ_TRX_CONTROL_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'TRX_CONTROL';


       --
       --************************
       --** Variable Declarations
       --************************
       --
       --
       --*************************
       --** Exception Declarations
       --*************************
       --
       e_ModuleError                         EXCEPTION;
       e_DateError                           EXCEPTION;
       ex_dml_errors                         EXCEPTION;
       PRAGMA EXCEPTION_INIT(ex_dml_errors, -24381);
       l_error_count             NUMBER;
	   l_proj_count 			 NUMBER := 0;
       --
       --** END Declarations **
       --
       -- Local Type Variables


   BEGIN
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0000';
        xxmx_utilities_pkg.clear_messages
            (
            pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'MODULE'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        --
        IF   gvv_ReturnStatus = 'F'
        THEN
            xxmx_utilities_pkg.log_module_message(
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'ERROR'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                ,pt_i_OracleError         => gvt_ReturnMessage    );
            --
            RAISE e_ModuleError;
        END IF;
        --
        --
         gvv_ProgressIndicator := '0010';
         xxmx_utilities_pkg.log_module_message(
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'Deleting from "' || cv_StagingTable   || '".'
                ,pt_i_OracleError         => gvt_ReturnMessage  );
        --
		--xxmx_utilities_pkg.truncate_table('XXMX_STG.xxmx_ppm_prj_trx_control_stg');
        --EXECUTE IMMEDIATE 'TRUNCATE TABLE XXMX_STG.xxmx_ppm_prj_trx_control_stg';
		DELETE
        FROM    xxmx_ppm_prj_trx_control_stg ;


        --COMMIT;
        --

        gvv_ProgressIndicator := '0020';
        --
        gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
        --
        /*
        ** If the Migration Set Name is NULL then the Migration has not been initialized.
        */
        --
        IF   gvt_MigrationSetName IS NOT NULL
        THEN
            --
            gvv_ProgressIndicator := '0030';
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '- Extracting "'
                                          ||pt_i_SubEntity
                                          ||'":'
                 ,pt_i_OracleError       => NULL
                 );
            --
            /*
            ** The Migration Set has been initialised, so now initialize the detail record
            ** for the current entity.
            */
            --
            --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
            --**                  table based on the Application Suite, Application and Business Entity parameters.
            --**
            --**                  Removed "entity" from procedure_name.
            --
          /*  xxmx_utilities_pkg.init_migration_details
                 (
                  pt_i_ApplicationSuite => gct_ApplicationSuite
                 ,pt_i_Application      => gct_Application
                 ,pt_i_BusinessEntity   => gv_i_BusinessEntity
                 ,pt_i_SubEntity        => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                 ,pt_i_StagingTable     => cv_StagingTable
                 ,pt_i_ExtractStartDate => SYSDATE
                 );*/
            --
            --** ISV 21/10/2020 - "pt_i_StagingTable" no longer needs to be passed as a parameter from the STG_MAIN procedure
            --**                  as the table name will never change so replace with new constant "ct_StgTable".
            --
            --**                  We will still keep the table name in the Metadata table as that can be used for reporting
            --**                  purposes.
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '  - Staging Table "'
                                          ||cv_StagingTable
                                          ||'" reporting details initialised.'
                 ,pt_i_OracleError       => NULL
                 );
            --
            gvv_ProgressIndicator := '0040';
            --
            --** Extract the Projects and insert into the staging table.
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '  - Extracting data into "'
                                          ||cv_StagingTable
                                          ||'".'
                 ,pt_i_OracleError       => NULL
                 );
            --
            --** ISV 21/10/2020 - The staging table is in the xxmx_stg schema but should not need to be prefixed as there should
            --**                  by a Synonym in the xxmx_core schema to that table.
            --
		FOR x IN src_projects_scope
		 LOOP


            OPEN pa_trx_control_cur( x.project_id 
										, x.project_name 
										, x.project_number 
										, x.proj_owning_org 
										, x.project_finish_date 
										, x.organization_name
										) ;
                --

           /*  gvv_ProgressIndicator := '0050';
            xxmx_utilities_pkg.log_module_message(
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       =>'Cursor Open pa_trx_control_cur'
                   ,pt_i_OracleError         => gvt_ReturnMessage  ); */
            --
            LOOP
            --
        /*     gvv_ProgressIndicator := '0060';
            xxmx_utilities_pkg.log_module_message(
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       =>'Inside the Cursor loop'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );
 */
            --
            FETCH pa_trx_control_cur  BULK COLLECT INTO pa_trx_control_tb LIMIT 1000;
            --
/* 
            gvv_ProgressIndicator := '0070';
            xxmx_utilities_pkg.log_module_message(
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       => 'Cursor pa_trx_control_cur Fetch into pa_trx_control_tb'
                   ,pt_i_OracleError         => gvt_ReturnMessage  ); */
            --
            EXIT WHEN pa_trx_control_tb.COUNT=0;
            --
            FORALL I IN 1..pa_trx_control_tb.COUNT SAVE EXCEPTIONS
            --

                        INSERT INTO xxmx_ppm_prj_trx_control_stg (
                                       migration_set_id
                                      ,migration_set_name
                                      ,migration_status
                                      ,txn_ctrl_reference
                                      ,project_name
                                      ,project_number
                                      ,task_number
                                      ,task_name
                                      ,expenditure_category_name
                                      ,expenditure_type
                                      ,non_labor_resource
                                      ,person_number
                                      ,person_name
                                      ,person_email
                                      ,person_type
		                                ,job_name
		                                ,organization_name
		                                ,chargeable_flag
		                                ,billable_flag
		                                ,capitalizable_flag
		                                ,start_date_active
		                                ,end_date_active
		                                ,batch_name
		                                ,creation_date
		                                ,created_by
		                                ,last_update_date
		                                ,last_updated_by
                                      ,batch_id
									    )
                                  VALUES
                                        (
                                         pt_i_MigrationSetID
                                        ,gvt_MigrationSetName
                                        ,'Extracted'
                                        ,pa_trx_control_tb(i).txn_ctrl_reference                   --txn_ctrl_reference
                                        ,pa_trx_control_tb(i).project_name                         --project_name
                                        ,pa_trx_control_tb(i).project_number                       --project_number
                                        ,pa_trx_control_tb(i).task_number                          --task_number
                                        ,pa_trx_control_tb(i).task_name                            --task_name
                                        ,pa_trx_control_tb(i).expenditure_category_name            --expenditure_category_name
                                        ,pa_trx_control_tb(i).expenditure_type                     --expenditure_type
                                        ,pa_trx_control_tb(i).non_labor_resource                   --non_labor_resource
                                        ,pa_trx_control_tb(i).person_number                        --person_number
                                        ,pa_trx_control_tb(i).person_name                          --person_name
                                        ,pa_trx_control_tb(i).person_emailid                       --person_emailid
                                        ,pa_trx_control_tb(i).person_type                          --person_type
                                        ,pa_trx_control_tb(i).job_name                             --job_name
                                        ,pa_trx_control_tb(i).organization_name                    --organization_name
                                        ,pa_trx_control_tb(i).chargeable_flag                      --chargeable_flag
                                        ,pa_trx_control_tb(i).billable_flag                        --billable_flag
                                        ,pa_trx_control_tb(i).capitalizable_flag                   --capitalizable_flag
                                        ,pa_trx_control_tb(i).start_date_active                    --start_date_active
                                        ,pa_trx_control_tb(i).end_date_active                      --end_date_active
                                        ,g_batch_name                                  --pa_classifications_tb(i).batch_name                          --batch_name
                                        ,sysdate
                                        ,xxmx_utilities_pkg.gvv_UserName
                                        ,sysdate
                                        ,xxmx_utilities_pkg.gvv_UserName
--                                        ,to_char(TO_DATE(SYSDATE, 'DD-MON-RRRR'),'DDMMRRRRHHMISS')                            --batch_id
                                        ,to_char(SYSDATE, 'DDMMRRRRHHMISS')                            --batch_id
										);


                --
                END LOOP;
                --
                 gvv_ProgressIndicator := '0080';
                  xxmx_utilities_pkg.log_module_message(
                            pt_i_ApplicationSuite    => gct_ApplicationSuite
                           ,pt_i_Application         => gct_Application
                           ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                           ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                           ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                           ,pt_i_Phase               => ct_Phase
                           ,pt_i_Severity            => 'NOTIFICATION'
                           ,pt_i_PackageName         => gcv_PackageName
                           ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                           ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                           ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                           ,pt_i_OracleError         => gvt_ReturnMessage       );

                --
                --COMMIT;
                --
                --
               gvv_ProgressIndicator := '0090';
              xxmx_utilities_pkg.log_module_message(
                               pt_i_ApplicationSuite    => gct_ApplicationSuite
                              ,pt_i_Application         => gct_Application
                              ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                              ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase               => ct_Phase
                              ,pt_i_Severity            => 'NOTIFICATION'
                              ,pt_i_PackageName         => gcv_PackageName
                              ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                              ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage       => 'Close the Cursor pa_trx_control_cur'
                              ,pt_i_OracleError         => gvt_ReturnMessage       );
             --


             IF pa_trx_control_cur%ISOPEN
             THEN
                  --
                     CLOSE pa_trx_control_cur;
                  --
             END IF;


			IF MOD(l_proj_count,100) = 0 THEN
				COMMIT;
			END IF;

			END LOOP;
           gvv_ProgressIndicator := '0100';
            --
            /*
            ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
            ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
            ** is reached.
            */
/*             --
            --** ISV 21/10/2020 - Replace "pt_i_ClientSchemaName" (no longer passed into the extract procedures) with new constant "gct_StgSchema".
            --**                  Replace "pt_i_StagingTable" (no longer passed into the extract procedures) with new constant "ct_StgTable"
            --

            --
            COMMIT; */


			            gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                 (
                                  gct_StgSchema
                                 ,cv_StagingTable
                                 ,pt_i_MigrationSetID
                                 );


            xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extraction complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '0110';
               --
               --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
               --**                  table based on the Application Suite, Application, Business Entity and Sub-Entity parameters.
               --**
               --**                  Removed "entity" from procedure_name.
               --
               xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gv_i_BusinessEntity
                    ,pt_i_SubEntity               => cv_i_BusinessEntityLevel
                    ,pt_i_Phase                   => ct_Phase
                    ,pt_i_ExtractCompletionDate   => SYSDATE
                    ,pt_i_ExtractRowCount         => gvn_RowCount
                    ,pt_i_TransformTable          => NULL
                    ,pt_i_TransformStartDate      => NULL
                    ,pt_i_TransformCompletionDate => NULL
                    ,pt_i_ExportFileName          => NULL
                    ,pt_i_ExportStartDate         => NULL
                    ,pt_i_ExportCompletionDate    => NULL
                    ,pt_i_ExportRowCount          => NULL
                    ,pt_i_ErrorFlag               => NULL
                    );
               --
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Migration Table "'
                                             ||cv_StagingTable
                                             ||'" reporting details updated.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
          ELSE
               --
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set not initialized.';
               --
               --
               RAISE e_ModuleError;
               --
               --
          END IF;
          --
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gv_i_BusinessEntity
               ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gcv_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          --

    EXCEPTION
      WHEN ex_dml_errors THEN
         l_error_count := SQL%BULK_EXCEPTIONS.count;
         DBMS_OUTPUT.put_line('Number of failures: ' || l_error_count);
         FOR i IN 1 .. l_error_count LOOP

           gvt_ModuleMessage := 'Error: ' || i ||
                                ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
                                ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE);

           xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage
                    ,pt_i_OracleError         => gvt_ReturnMessage   );

           DBMS_OUTPUT.put_line('Error: ' || i ||
             ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
             ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
         END LOOP;

      WHEN e_ModuleError THEN
                --
        IF pa_trx_control_cur%ISOPEN
        THEN
            --
            CLOSE pa_trx_control_cur;
            --
        END IF;

        xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage
                    ,pt_i_OracleError         => gvt_ReturnMessage       );
         --
         RAISE;
         --** END e_ModuleError Exception
         --
      WHEN OTHERS THEN

         IF pa_trx_control_cur%ISOPEN
         THEN
             --
             CLOSE pa_trx_control_cur;
             --
         END IF;
         --
         ROLLBACK;
         --
         gvt_OracleError := SUBSTR(
                                        SQLERRM
                                    ||'** ERROR_BACKTRACE: '
                                    ||dbms_utility.format_error_backtrace
                                    ,1
                                    ,4000
                                    );
         --
         xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                    ,pt_i_OracleError         => gvt_OracleError       );
         --
         RAISE;
         -- Hr_Utility.raise_error@xxmx_extract;



     END src_pa_trx_control;


     /*********************************************************
     -----------------src_pa_team_members-------------------
     **********************************************************/

     PROCEDURE src_pa_team_members
                            (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                            ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)

     AS
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
    CURSOR src_projects_scope IS 
        SELECT
             project_id
			,project_name 
			,project_long_name 
			,project_number 
			,proj_owning_org 
			,project_finish_date 
			,organization_name 	
        FROM  xxmx_ppm_projects_stg; 
    --
	CURSOR pa_team_mem_cur 
        (
            p_project_id                    NUMBER,
			p_project_name                  VARCHAR2,
			p_project_long_name             VARCHAR2,
			p_project_number                VARCHAR2,
			p_organization_name             VARCHAR2									
        ) IS
        SELECT DISTINCT
                p_project_name                                 	   AS project_name,
                p_project_long_name                                AS project_long_name,
                NVL(papf.employee_number,papf.npw_number)          AS team_member_number,
                NULL                                               AS team_member_name,
                NULL                                               AS team_member_email,
                pprt.meaning                                       AS PROJECT_ROLE_NAME,
            	ppp.start_date_active                              AS START_DATE_ACTIVE,
                ppp.end_date_active                                AS end_date_active,
                NULL                                               AS allocation,
                NULL                                               AS effort,
                NULL                                               AS cost_rate,
                NULL                                               AS bill_rate,
                NULL                                               AS track_time_flag,
                NULL                                               AS assignment_type,
                NULL                                               AS billable_percent,
                NULL                                               AS billable_percent_reason_code,
                p_organization_name                                AS ou_name,
                p_project_number                          		   AS project_number,
                NULL                                               AS extract_source,
                NULL                                               AS extract_comments
        FROM
             apps.pa_project_parties@xxmx_extract         ppp
            ,apps.per_all_people_f@xxmx_extract           papf
            ,apps.pa_project_role_types_tl@xxmx_extract   pprt
                  --,XXMX_PPM_PROJECTS_STG xps
        WHERE   ppp.project_id                              = p_project_id
            AND ppp.resource_source_id                      = papf.person_id
            AND pprt.project_role_id                        = ppp.project_role_id
          --  AND SYSDATE                                     BETWEEN papf.effective_start_date AND NVL(papf.effective_end_date,SYSDATE+1)
          --  AND SYSDATE                                     BETWEEN ppp.start_date_active AND NVL(ppp.end_date_active,SYSDATE+1)
            AND to_date(gvv_migration_date,'DD-MON-YYYY')                                     BETWEEN papf.effective_start_date AND NVL(papf.effective_end_date,to_date(gvv_migration_date,'DD-MON-YYYY'))
            AND to_date(gvv_migration_date,'DD-MON-YYYY')                                     BETWEEN ppp.start_date_active AND NVL(ppp.end_date_active,to_date(gvv_migration_date,'DD-MON-YYYY'))         
            AND nvl(papf.employee_number,papf.npw_number)   IS NOT NULL
            AND pprt.meaning                                not in ('Customer Organization', 'Observer')     --Milind added to stop this record getting migrated as per user review.
            AND pprt.meaning                                not like '%Controller%'  --Milind added after ticket in mini DM.
            --where exists (select null from xxmx_ppm_valid_persons v where v.person_number = src.team_member_number)
            ;
       --
       --**********************
       --** Record Declarations
       --**********************
       --
         TYPE pa_team_mem_tbl IS TABLE OF pa_team_mem_cur%ROWTYPE INDEX BY BINARY_INTEGER;
         pa_team_mem_tb pa_team_mem_tbl;
       --
       --************************
       --** Constant Declarations
       --************************
       --
        cv_ProcOrFuncName                   CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'src_pa_team_members';
        cv_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PPM_PRJ_TEAM_MEM_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'TEAM_MEMBERS';


       --
       --************************
       --** Variable Declarations
       --************************
       --
       --
       --*************************
       --** Exception Declarations
       --*************************
       --
       e_ModuleError                         EXCEPTION;
       e_DateError                           EXCEPTION;
       ex_dml_errors                         EXCEPTION;
       PRAGMA EXCEPTION_INIT(ex_dml_errors, -24381);
       l_error_count             NUMBER;
	   l_proj_count  NUMBER :=0;
       --
       --** END Declarations **
       --
       -- Local Type Variables


   BEGIN
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0000';
        xxmx_utilities_pkg.clear_messages
            (
            pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'MODULE'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        -- 
        IF   gvv_ReturnStatus = 'F'
        THEN
            xxmx_utilities_pkg.log_module_message(
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'ERROR'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                ,pt_i_OracleError         => gvt_ReturnMessage    );
            --
            RAISE e_ModuleError;
        END IF;
        --
        --
         gvv_ProgressIndicator := '0010';
         xxmx_utilities_pkg.log_module_message(
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'Deleting from "' || cv_StagingTable   || '".'
                ,pt_i_OracleError         => gvt_ReturnMessage  );
        --
		--xxmx_utilities_pkg.truncate_table('XXMX_STG.xxmx_ppm_prj_team_mem_stg');
       -- EXECUTE IMMEDIATE 'TRUNCATE TABLE XXMX_STG.xxmx_ppm_prj_team_mem_stg';
		DELETE
        FROM    xxmx_ppm_prj_team_mem_stg ;

        COMMIT;
        --

        gvv_ProgressIndicator := '0020';
        --
        gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
        --
        /*
        ** If the Migration Set Name is NULL then the Migration has not been initialized.
        */
        --
        IF   gvt_MigrationSetName IS NOT NULL
        THEN
            --
            gvv_ProgressIndicator := '0030';
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '- Extracting "'
                                          ||pt_i_SubEntity
                                          ||'":'
                 ,pt_i_OracleError       => NULL
                 );
            --
            /*
            ** The Migration Set has been initialised, so now initialize the detail record
            ** for the current entity.
            */
            --
            --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
            --**                  table based on the Application Suite, Application and Business Entity parameters.
            --**
            --**                  Removed "entity" from procedure_name.
            --
         /*   xxmx_utilities_pkg.init_migration_details
                 (
                  pt_i_ApplicationSuite => gct_ApplicationSuite
                 ,pt_i_Application      => gct_Application
                 ,pt_i_BusinessEntity   => gv_i_BusinessEntity
                 ,pt_i_SubEntity        => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                 ,pt_i_StagingTable     => cv_StagingTable
                 ,pt_i_ExtractStartDate => SYSDATE
                 );*/
            --
            --** ISV 21/10/2020 - "pt_i_StagingTable" no longer needs to be passed as a parameter from the STG_MAIN procedure
            --**                  as the table name will never change so replace with new constant "ct_StgTable".
            --
            --**                  We will still keep the table name in the Metadata table as that can be used for reporting
            --**                  purposes.
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '  - Staging Table "'
                                          ||cv_StagingTable
                                          ||'" reporting details initialised.'
                 ,pt_i_OracleError       => NULL
                 );
            --
            gvv_ProgressIndicator := '0040';
            --
            --** Extract the Projects and insert into the staging table.
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '  - Extracting data into "'
                                          ||cv_StagingTable
                                          ||'".'
                 ,pt_i_OracleError       => NULL
                 );
            --
            --** ISV 21/10/2020 - The staging table is in the xxmx_stg schema but should not need to be prefixed as there should
            --**                  by a Synonym in the xxmx_core schema to that table.
            --
			FOR x IN src_projects_scope
			LOOP
			--
            OPEN pa_team_mem_cur( x.project_id ,
									x.project_name ,
									x.project_long_name ,
									x.project_number ,
									x.organization_name 
								)  ;
                --
/* 
            gvv_ProgressIndicator := '0050';
            xxmx_utilities_pkg.log_module_message(
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       =>'Cursor Open pa_team_mem_cur'
                   ,pt_i_OracleError         => gvt_ReturnMessage  ); */
            --
            LOOP
            --
        /*     gvv_ProgressIndicator := '0060';
            xxmx_utilities_pkg.log_module_message(
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       =>'Inside the Cursor loop'
                   ,pt_i_OracleError         => gvt_ReturnMessage  ); */

            --
            FETCH pa_team_mem_cur  BULK COLLECT INTO pa_team_mem_tb LIMIT 1000;
            --
/* 
            gvv_ProgressIndicator := '0070';
            xxmx_utilities_pkg.log_module_message(
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       => 'Cursor pa_team_mem_cur Fetch into pa_team_mem_tb'
                   ,pt_i_OracleError         => gvt_ReturnMessage  ); */
            --
            EXIT WHEN pa_team_mem_tb.COUNT=0;
            --
            FORALL I IN 1..pa_team_mem_tb.COUNT SAVE EXCEPTIONS
            --

                        INSERT INTO xxmx_ppm_prj_team_mem_stg (
                                       migration_set_id,
                                       migration_set_name,
                                       migration_status,
                                       project_name,
                                       project_long_name,
                                       team_member_number,
                                       team_member_name,
                                       team_member_email,
                                       project_role,
                                       start_date_active,
                                       end_date_active,
                                       allocation,
                                       labour_effort,
                                       cost_rate,
                                       bill_rate,
                                       track_time_flag,
                                       assignment_type_code,
                                       billable_percent,
                                       billable_percent_reason_code,
                                       batch_name,
                                       creation_date,
                                       created_by,
                                       last_update_date,
                                       last_updated_by,
                                       batch_id,
                                       Organization_name,
                                       project_number
									    )
                                  VALUES
                                        (
                                         pt_i_MigrationSetID
                                        ,gvt_MigrationSetName
                                        ,'Extracted'
                                        ,pa_team_mem_tb(i).project_name
                                        ,pa_team_mem_tb(i).project_long_name
                                        ,pa_team_mem_tb(i).team_member_number
                                        ,pa_team_mem_tb(i).team_member_name
                                        ,pa_team_mem_tb(i).team_member_email
                                        ,pa_team_mem_tb(i).project_role_name
                                        ,pa_team_mem_tb(i).start_date_active
                                        ,pa_team_mem_tb(i).end_date_active
                                        ,pa_team_mem_tb(i).allocation
                                        ,pa_team_mem_tb(i).effort
                                        ,pa_team_mem_tb(i).cost_rate
                                        ,pa_team_mem_tb(i).bill_rate
                                        ,pa_team_mem_tb(i).track_time_flag
                                        ,pa_team_mem_tb(i).assignment_type
                                        ,pa_team_mem_tb(i).billable_percent
                                        ,pa_team_mem_tb(i).billable_percent_reason_code
                                        ,g_batch_name
                                        ,sysdate
                                        ,xxmx_utilities_pkg.gvv_UserName
                                        ,sysdate
                                        ,xxmx_utilities_pkg.gvv_UserName
--                                        ,to_char(TO_DATE(SYSDATE, 'DD-MON-RRRR'),'DDMMRRRRHHMISS') --batch_id
                                        ,to_char(SYSDATE, 'DDMMRRRRHHMISS') --batch_id
                                        ,pa_team_mem_tb(i).ou_name
                                        ,pa_team_mem_tb(i).project_number
										);


                --
                END LOOP;
                --
          /*        gvv_ProgressIndicator := '0080';
                  xxmx_utilities_pkg.log_module_message(
                            pt_i_ApplicationSuite    => gct_ApplicationSuite
                           ,pt_i_Application         => gct_Application
                           ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                           ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                           ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                           ,pt_i_Phase               => ct_Phase
                           ,pt_i_Severity            => 'NOTIFICATION'
                           ,pt_i_PackageName         => gcv_PackageName
                           ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                           ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                           ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                           ,pt_i_OracleError         => gvt_ReturnMessage       ); */

                --
               -- COMMIT;
				l_proj_count := l_proj_count + 1;
                --
                --
				--

               gvv_ProgressIndicator := '0090';
           /*   xxmx_utilities_pkg.log_module_message(
                               pt_i_ApplicationSuite    => gct_ApplicationSuite
                              ,pt_i_Application         => gct_Application
                              ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                              ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase               => ct_Phase
                              ,pt_i_Severity            => 'NOTIFICATION'
                              ,pt_i_PackageName         => gcv_PackageName
                              ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                              ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage       => 'Close the Cursor pa_team_mem_cur'
                              ,pt_i_OracleError         => gvt_ReturnMessage       );*/
             --


             IF pa_team_mem_cur%ISOPEN
             THEN
                  --
                     CLOSE pa_team_mem_cur;
                  --
             END IF;


			 IF MOD(l_proj_count,500) = 0 THEN
				COMMIT;
			 END IF;

			END LOOP;
           gvv_ProgressIndicator := '0100';
            --
            /*
            ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
            ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
            ** is reached.
            */
            --
            --** ISV 21/10/2020 - Replace "pt_i_ClientSchemaName" (no longer passed into the extract procedures) with new constant "gct_StgSchema".
            --**                  Replace "pt_i_StagingTable" (no longer passed into the extract procedures) with new constant "ct_StgTable"
            --
            gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                 (
                                  gct_StgSchema
                                 ,cv_StagingTable
                                 ,pt_i_MigrationSetID
                                 );
            --
            COMMIT;


            xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extraction complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '0110';
               --
               --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
               --**                  table based on the Application Suite, Application, Business Entity and Sub-Entity parameters.
               --**
               --**                  Removed "entity" from procedure_name.
               --
               xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gv_i_BusinessEntity
                    ,pt_i_SubEntity               => cv_i_BusinessEntityLevel
                    ,pt_i_Phase                   => ct_Phase
                    ,pt_i_ExtractCompletionDate   => SYSDATE
                    ,pt_i_ExtractRowCount         => gvn_RowCount
                    ,pt_i_TransformTable          => NULL
                    ,pt_i_TransformStartDate      => NULL
                    ,pt_i_TransformCompletionDate => NULL
                    ,pt_i_ExportFileName          => NULL
                    ,pt_i_ExportStartDate         => NULL
                    ,pt_i_ExportCompletionDate    => NULL
                    ,pt_i_ExportRowCount          => NULL
                    ,pt_i_ErrorFlag               => NULL
                    );
               --
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Migration Table "'
                                             ||cv_StagingTable
                                             ||'" reporting details updated.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
          ELSE
               --
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set not initialized.';
               --
               --
               RAISE e_ModuleError;
               --
               --
          END IF;
          --
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gv_i_BusinessEntity
               ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gcv_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          --

    EXCEPTION
      WHEN ex_dml_errors THEN
         l_error_count := SQL%BULK_EXCEPTIONS.count;
         DBMS_OUTPUT.put_line('Number of failures: ' || l_error_count);
         FOR i IN 1 .. l_error_count LOOP

           gvt_ModuleMessage := 'Error: ' || i ||
                                ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
                                ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE);

           xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage
                    ,pt_i_OracleError         => gvt_ReturnMessage   );

           DBMS_OUTPUT.put_line('Error: ' || i ||
             ' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
             ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE));
         END LOOP;

      WHEN e_ModuleError THEN
                --
        IF pa_team_mem_cur%ISOPEN
        THEN
            --
            CLOSE pa_team_mem_cur;
            --
        END IF;

        xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage
                    ,pt_i_OracleError         => gvt_ReturnMessage       );
         --
         RAISE;
         --** END e_ModuleError Exception
         --
      WHEN OTHERS THEN

         IF pa_team_mem_cur%ISOPEN
         THEN
             --
             CLOSE pa_team_mem_cur;
             --
         END IF;
         --
         ROLLBACK;
         --
         gvt_OracleError := SUBSTR(
                                        SQLERRM
                                    ||'** ERROR_BACKTRACE: '
                                    ||dbms_utility.format_error_backtrace
                                    ,1
                                    ,4000
                                    );
         --
         xxmx_utilities_pkg.log_module_message(  
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                    ,pt_i_OracleError         => gvt_OracleError       );
         --
         RAISE;
         -- Hr_Utility.raise_error@xxmx_extract;



     END src_pa_team_members;


     /*********************************************************
     -----------------batch_project_team_members_data-------------------
     **********************************************************/

       /*  PROCEDURE batch_project_team_members_data (pt_i in varchar2 default null) IS

        temp_project VARCHAR2(200);
        CURSOR c2 IS
        SELECT
            batch_name,
            batch_value,
            ROWID
        FROM
            xxmx_csv_file_temp
        WHERE
            file_name = 'Projects.csv';

        CURSOR c3 IS
        SELECT
            line_content,
            ROWID
        FROM
            xxmx_csv_file_temp
        WHERE
            file_name = 'ProjectTeamMembers.csv';

    BEGIN
        FOR i IN c2 LOOP
            FOR j IN c3 LOOP
                dbms_output.put_line(replace(substr(j.line_content, 1, instr(j.line_content, ',', 1) - 1), '"', ''));

                temp_project := replace(substr(j.line_content, 1, instr(j.line_content, ',', 1) - 1), '"', '');

                IF i.batch_value = temp_project THEN
                    UPDATE xxmx_csv_file_temp
                    SET
                        batch_value = replace(substr(j.line_content, 1, instr(j.line_content, ',', 1) - 1), '"', ''),
                        batch_name = i.batch_name
                    WHERE
                        ROWID = j.rowid;

                    COMMIT;
                END IF;

                EXIT WHEN c3%notfound;
            END LOOP;

            EXIT WHEN c2%notfound;
        END LOOP;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(sqlcode
                                 || ' '
                                 || sqlerrm);
    END batch_project_team_members_data;*/


    /*********************************************************
     -----------------batch_project_classifications_data-------------------
     **********************************************************/

   /* PROCEDURE batch_project_classifications_data (pt_i in varchar2 default null) IS

        temp_project VARCHAR2(200);
        CURSOR c2 IS
        SELECT
            batch_name,
            batch_value,
            ROWID
        FROM
            xxmx_csv_file_temp
        WHERE
            file_name = 'Projects.csv';

        CURSOR c3 IS
        SELECT
            line_content,
            ROWID
        FROM
            xxmx_csv_file_temp
        WHERE
            file_name = 'ProjectClassifications.csv';

    BEGIN
        FOR i IN c2 LOOP
            FOR j IN c3 LOOP
                dbms_output.put_line(replace(substr(j.line_content, 1, instr(j.line_content, ',', 1) - 1), '"', ''));

                temp_project := replace(substr(j.line_content, instr(j.line_content, ',', 1) + 1,(instr(j.line_content, ',', 1, 2) - 1) -
                instr(j.line_content, ',', 1)), '"', '');

                dbms_output.put_line('test' || temp_project);
                IF i.batch_value = temp_project THEN
                    UPDATE xxmx_csv_file_temp
                    SET
                        batch_value = replace(substr(j.line_content, instr(j.line_content, ',', 1) + 1,(instr(j.line_content, ',', 1,
                        2) - 1) - instr(j.line_content, ',', 1)), '"', ''),
                        batch_name = i.batch_name
                    WHERE
                        ROWID = j.rowid;

                    COMMIT;
                END IF;

                EXIT WHEN c3%notfound;
            END LOOP;

            EXIT WHEN c2%notfound;
        END LOOP;

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            dbms_output.put_line(sqlcode
                                 || ' '
                                 || sqlerrm);
    END batch_project_classifications_data;*/


/*********************************************************
     -----------------batch_projects_data-------------------
     **********************************************************/

   /* PROCEDURE batch_projects_data(pt_i in varchar2 default null) IS

        rc       NUMBER;
        startrow NUMBER;
        endrow   NUMBER;
        rowvar   NUMBER;
        CURSOR c1 IS
        SELECT
            line_content,
            ROWID
        FROM
            xxmx_csv_file_temp
        WHERE
            file_name = 'Projects.csv';

    BEGIN
-- Batch Project--
        rc := 1;
        startrow := 0;
        endrow := 100;
        LOOP
            UPDATE xxmx_csv_file_temp
            SET
                batch_name = 'BATCH_' || to_char(rc)
            WHERE
--batch_name = p_batch_name
                    file_name = 'Projects.csv'
                AND ROWNUM < 101
                AND batch_name IS NULL;

            rowvar := SQL%rowcount;
            COMMIT;
            EXIT WHEN rowvar < 100;
            rc := rc + 1;
            startrow := endrow;
            endrow := endrow + 100;
        END LOOP;

        BEGIN -- spliting project name
            FOR i IN c1 LOOP
                dbms_output.put_line(replace(substr(i.line_content, 1, instr(i.line_content, ',', 1) - 1), '"', ''));

                UPDATE xxmx_csv_file_temp
                SET
                    batch_value = replace(substr(i.line_content, 1, instr(i.line_content, ',', 1) - 1), '"', '')
                WHERE
                    ROWID = i.rowid;

                EXIT WHEN c1%notfound;
            END LOOP;

            COMMIT;
            batch_project_classifications_data();
            batch_project_team_members_data();
        EXCEPTION
            WHEN OTHERS THEN
                dbms_output.put_line(sqlcode
                                     || ' '
                                     || sqlerrm);
        END;

    END batch_projects_data;*/
   /*

   /***************************************************************
   --------------------src_pa_rate_overrides-----------------------
   -- Extracts Project rate overrides information from EBS
   ----------------------------------------------------------------
   ***************************************************************/

PROCEDURE src_pa_rate_overrides
                     (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
                      ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
AS

          --
          --**********************
          --** Cursor Declarations
          --********************** 
          --

          CURSOR src_pa_rate_overrides_cur
         IS
         --
          SELECT  distinct 
                  NULL                                                         CONTRACT_NUMBER
                 ,NULL                                                         CONTRACT_TYPE
                 ,NULL                                                         PLAN_NAME
                 ,NULL                                                         PLAN_TYPE
                 ,NULL                                                         CONTRACT_LINE_NUMBER
                 ,NVL(project_number,task_project_number)                       PROJECT_NUMBER
                 ,task_number                                                   TASK_NUMBER
                 ,NULL                                                         PERSON_NAME -- Any one value required out of person name, person number and email
                 ,person_number                                                PERSON_NUMBER  --TBD
                 ,NULL                                                         PERSON_EMAIL  -- Any one value required out of person name, person number and email
                -- ,JOB_NAME                                                     JOB_CODE
                 ,substr(job_name,1,30)                                                         JOB_CODE -- Need to find job code 
                 ,EXPENDITURE_TYPE                                             EXPENDITURE_TYPE_NAME
                 ,RATE                                                         RATE
                 ,RATE_CURRENCY_CODE                                           CURRENCY_CODE
                 ,START_DATE_ACTIVE                                            START_DATE_ACTIVE
                 ,END_DATE_ACTIVE                                              END_DATE_ACTIVE
                 ,NULL                                                         RATE_OVERRIDE_REASON
                 ,override_type
                 ,discount_percentage
                 ,markup_percentage
            FROM xxmx_rate_overrides_v ;
       --
       --**********************
       --** Record Declarations 
       --**********************
       --
         TYPE src_pa_rate_overrides_tbl IS TABLE OF src_pa_rate_overrides_cur%ROWTYPE INDEX BY BINARY_INTEGER;
         src_pa_rate_overrides_tb  src_pa_rate_overrides_tbl;
       --
       --************************
       --** Constant Declarations
       --************************
       --
        cv_ProcOrFuncName                   CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'SRC_PA_RATE_OVERRIDES';
        cv_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PPM_RATE_OVERRIDES_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'OVERRIDES';
       --
       --************************
       --** Variable Declarations
       --************************
       --
       --
       --*************************
       --** Exception Declarations
       --*************************
       --
       e_ModuleError                         EXCEPTION;
       e_DateError                           EXCEPTION;
       ex_dml_errors                         EXCEPTION;
       PRAGMA EXCEPTION_INIT(ex_dml_errors, -24381);
       l_error_count             NUMBER;
       --
       --** END Declarations **
       --
       -- Local Type Variables
   BEGIN
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0000';
        xxmx_utilities_pkg.clear_messages
            (
            pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'MODULE'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        --
        IF   gvv_ReturnStatus = 'F'
        THEN
            xxmx_utilities_pkg.log_module_message(
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'ERROR'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                ,pt_i_OracleError         => gvt_ReturnMessage    );
            --
            RAISE e_ModuleError;
        END IF;
        --
        --
         gvv_ProgressIndicator := '0010';
         xxmx_utilities_pkg.log_module_message(
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'Deleting from "' || cv_StagingTable   || '".'
                ,pt_i_OracleError         => gvt_ReturnMessage  );
        --
		--xxmx_utilities_pkg.truncate_table('xxmx_stg.xxmx_ppm_rate_overrides_stg');
        --EXECUTE IMMEDIATE 'TRUNCATE TABLE xxmx_stg.xxmx_ppm_rate_overrides_stg';
		DELETE FROM    xxmx_ppm_rate_overrides_stg ;
        COMMIT;  
        --

        gvv_ProgressIndicator := '0020';
        --
        gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
        --
        --
        -- If the Migration Set Name is NULL then the Migration has not been initialized.
        --
        --
        IF   gvt_MigrationSetName IS NOT NULL
        THEN
            --
            gvv_ProgressIndicator := '0030';
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '- Extracting "'
                                          ||pt_i_SubEntity
                                          ||'":'
                 ,pt_i_OracleError       => NULL
                 );
            --
            --
            -- The Migration Set has been initialised, so now initialize the detail record
            -- for the current entity.
            --
          /*  xxmx_utilities_pkg.init_migration_details
                 (
                  pt_i_ApplicationSuite => gct_ApplicationSuite
                 ,pt_i_Application      => gct_Application
                 ,pt_i_BusinessEntity   => gv_i_BusinessEntity
                 ,pt_i_SubEntity        => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                 ,pt_i_StagingTable     => cv_StagingTable
                 ,pt_i_ExtractStartDate => SYSDATE
                 );*/
            --
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '  - Staging Table "'
                                          ||cv_StagingTable
                                          ||'" reporting details initialised.'
                 ,pt_i_OracleError       => NULL
                 );
            --
            gvv_ProgressIndicator := '0040';
            --
            --** Extract the Project Rate Overrides and insert into the staging table.
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => gct_ApplicationSuite
                 ,pt_i_Application       => gct_Application
                 ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                 ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                 ,pt_i_Phase             => ct_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gcv_PackageName
                 ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '  - Extracting data into "'
                                          ||cv_StagingTable
                                          ||'".'
                 ,pt_i_OracleError       => NULL
                 );
            --
            --** ISV 21/10/2020 - The staging table is in the xxmx_stg schema but should not need to be prefixed as there should
            --**                  by a Synonym in the xxmx_core schema to that table.
            --


            OPEN src_pa_rate_overrides_cur;
                --

            gvv_ProgressIndicator := '0050';
            xxmx_utilities_pkg.log_module_message(
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       =>'Cursor Open src_pa_rate_overrides_cur'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );
            --
            LOOP
            --
            gvv_ProgressIndicator := '0060';
            xxmx_utilities_pkg.log_module_message(
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       =>'Inside the Cursor loop'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );

            --
            FETCH src_pa_rate_overrides_cur  BULK COLLECT INTO src_pa_rate_overrides_tb LIMIT 1000;
            --

            gvv_ProgressIndicator := '0070';
            xxmx_utilities_pkg.log_module_message(
                    pt_i_ApplicationSuite    => gct_ApplicationSuite
                   ,pt_i_Application         => gct_Application
                   ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                   ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       => 'Cursor src_pa_rate_overrides_cur Fetch into src_pa_rate_overrides_tb'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );
            --
            EXIT WHEN src_pa_rate_overrides_tb.COUNT=0;
            --
            FORALL I IN 1..src_pa_rate_overrides_tb.COUNT SAVE EXCEPTIONS
            --
                 INSERT INTO xxmx_ppm_rate_overrides_stg (
                                     migration_set_id
									,migration_status
                                    ,migration_set_name
                                    ,contract_number
                                    ,contract_type
                                    ,plan_name
                                    ,plan_type
                                    ,contract_line_number
                                    ,project_number
                                    ,task_number
                                    ,person_name
                                    ,person_number
                                    ,person_email
                                    ,job_code
                                    ,expenditure_type_name
                                    ,rate
                                    ,currency_code
                                    ,start_date_active
                                    ,end_date_active
                                    ,rate_override_reason
                                    ,batch_name
                                    ,batch_id
                                    ,last_updated_by
                                    ,created_by
                                    ,creation_date
                                    ,last_update_date
                                    ,discount_percentage
                                    ,markup_percentage
                             )
                           VALUES
                           (
                            pt_i_MigrationSetID
                           ,'EXTRACTED'
                           ,gvt_MigrationSetName
                           ,src_pa_rate_overrides_tb(i).contract_number
                           ,src_pa_rate_overrides_tb(i).contract_type
                           ,src_pa_rate_overrides_tb(i).plan_name
                           ,src_pa_rate_overrides_tb(i).plan_type
                           ,src_pa_rate_overrides_tb(i).contract_line_number
                           ,src_pa_rate_overrides_tb(i).project_number
                           ,src_pa_rate_overrides_tb(i).task_number
                           ,src_pa_rate_overrides_tb(i).person_name
                           ,src_pa_rate_overrides_tb(i).person_number
                           ,src_pa_rate_overrides_tb(i).person_email
                           ,src_pa_rate_overrides_tb(i).job_code
                           ,src_pa_rate_overrides_tb(i).expenditure_type_name
                           ,src_pa_rate_overrides_tb(i).rate
                           ,src_pa_rate_overrides_tb(i).currency_code
                           ,src_pa_rate_overrides_tb(i).start_date_active
                           ,src_pa_rate_overrides_tb(i).end_date_active
                           ,src_pa_rate_overrides_tb(i).rate_override_reason   
                           ,g_batch_name 						                        --batch_name
						   ,to_char(SYSDATE, 'DDMMRRRRHHMISS')                          --batch_id
                           ,xxmx_utilities_pkg.gvv_UserName                             --last_updated_by
                           ,xxmx_utilities_pkg.gvv_UserName                             --created_by
                           ,SYSDATE                                                     --creation_date
                           ,SYSDATE                                                     --last_update_date
                           ,src_pa_rate_overrides_tb(i).discount_percentage
                           ,src_pa_rate_overrides_tb(i).markup_percentage
                           );
                --
                END LOOP;
                --
                 gvv_ProgressIndicator := '0080';
                  xxmx_utilities_pkg.log_module_message(
                            pt_i_ApplicationSuite    => gct_ApplicationSuite
                           ,pt_i_Application         => gct_Application
                           ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                           ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                           ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                           ,pt_i_Phase               => ct_Phase
                           ,pt_i_Severity            => 'NOTIFICATION'
                           ,pt_i_PackageName         => gcv_PackageName
                           ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                           ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                           ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                           ,pt_i_OracleError         => gvt_ReturnMessage       );

                --
                COMMIT;
                --
               gvv_ProgressIndicator := '0090';
               xxmx_utilities_pkg.log_module_message(
                               pt_i_ApplicationSuite    => gct_ApplicationSuite
                              ,pt_i_Application         => gct_Application
                              ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                              ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase               => ct_Phase
                              ,pt_i_Severity            => 'NOTIFICATION'
                              ,pt_i_PackageName         => gcv_PackageName
                              ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                              ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage       => 'Close the Cursor src_pa_rate_overrides_cur'
                              ,pt_i_OracleError         => gvt_ReturnMessage       );
             --


             IF src_pa_rate_overrides_cur%ISOPEN
             THEN
                  --
                     CLOSE src_pa_rate_overrides_cur;
                  --
             END IF;

           gvv_ProgressIndicator := '0100';
            --
            --
            -- Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
            -- clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
            -- is reached.
            --
            --
            --
            gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                 (
                                  gct_StgSchema
                                 ,cv_StagingTable
                                 ,pt_i_MigrationSetID
                                 );
            --
            COMMIT;
--
            xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extraction complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '0110';
               --
               --
               xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gv_i_BusinessEntity
                    ,pt_i_SubEntity               => cv_i_BusinessEntityLevel
                    ,pt_i_Phase                   => ct_Phase
                    ,pt_i_ExtractCompletionDate   => SYSDATE
                    ,pt_i_ExtractRowCount         => gvn_RowCount
                    ,pt_i_TransformTable          => NULL
                    ,pt_i_TransformStartDate      => NULL
                    ,pt_i_TransformCompletionDate => NULL
                    ,pt_i_ExportFileName          => NULL
                    ,pt_i_ExportStartDate         => NULL
                    ,pt_i_ExportCompletionDate    => NULL
                    ,pt_i_ExportRowCount          => NULL
                    ,pt_i_ErrorFlag               => NULL
                    );
               --
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gv_i_BusinessEntity
                    ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Migration Table "'
                                             ||cv_StagingTable
                                             ||'" reporting details updated.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
          ELSE
               --
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set not initialized.';
               --
               --
               RAISE e_ModuleError;
               --
               --
          END IF;
          --
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gv_i_BusinessEntity
               ,pt_i_SubEntity         => cv_i_BusinessEntityLevel
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gcv_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          --
EXCEPTION
    WHEN ex_dml_errors THEN
        l_error_count := SQL%BULK_EXCEPTIONS.count;
        DBMS_OUTPUT.put_line('Number of failures: ' || l_error_count);
        FOR i IN 1 .. l_error_count LOOP
            gvt_ModuleMessage := 
                'Error: ' || i ||' Array Index: ' || SQL%BULK_EXCEPTIONS(i).error_index ||
                ' Message: ' || SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE);
            xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage
                    ,pt_i_OracleError         => gvt_ReturnMessage   );
            DBMS_OUTPUT.put_line(gvt_ModuleMessage);
        END LOOP;
    WHEN e_ModuleError THEN
        IF src_pa_rate_overrides_cur%ISOPEN
        THEN
            CLOSE src_pa_rate_overrides_cur;
        END IF;
        xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => gvt_ModuleMessage
                    ,pt_i_OracleError         => gvt_ReturnMessage       );
         RAISE;
    WHEN OTHERS THEN
        IF src_pa_rate_overrides_cur%ISOPEN
        THEN
            CLOSE src_pa_rate_overrides_cur;
        END IF;
        ROLLBACK;
        --
        gvt_OracleError := 
            SUBSTR(SQLERRM||'** ERROR_BACKTRACE: '||dbms_utility.format_error_backtrace,1,4000);
        xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                    ,pt_i_OracleError         => gvt_OracleError       );
         --
         RAISE;
END src_pa_rate_overrides;
--
END XXMX_PPM_PROJECTS_PKG;

/
