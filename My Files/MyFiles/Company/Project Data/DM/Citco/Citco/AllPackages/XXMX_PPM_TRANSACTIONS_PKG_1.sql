--------------------------------------------------------
--  DDL for Package Body XXMX_PPM_TRANSACTIONS_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_PPM_TRANSACTIONS_PKG" AS 
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
--** FILENAME  :  XXMX_PPM_TRANSACTIONS_PKG.pkb
--**
--** FILEPATH  :  $XXV1_TOP/install/sql
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  XXMX_STG 
--**
--** AUTHORS   :  Dhanu Gundala
--**
--** PURPOSE   :  This package contains procedures for extracting Purchase Order into Staging tables
--***************************************************************************************************
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--**   1.0  07-APR-2022  Dhanu Gundala       Created for Citco.
--***************************************************************************************************
	/****************************************************************	
	----------------Export Projects Information----------------
	*****************************************************************/
    gvv_ReturnStatus                          VARCHAR2(1); 
    gvt_ReturnMessage                         xxmx_module_messages.module_message%TYPE;
    gvv_ProgressIndicator                     VARCHAR2(100); 
    gcv_PackageName                           CONSTANT  VARCHAR2(30)                                := 'XXMX_PPM_TRANSACTIONS_PKG';
    gct_ApplicationSuite                      CONSTANT  xxmx_module_messages.application_suite%TYPE:= 'PPM';
    gct_Application                           CONSTANT  xxmx_module_messages.application%TYPE      := 'PPM';
    gv_i_BusinessEntity                                 VARCHAR2(100)                              := 'PRJ_COST';
    gvt_migrationsetname                                VARCHAR2(100);
    ct_Phase                                  CONSTANT  xxmx_module_messages.phase%TYPE            := 'EXTRACT';
    cv_i_BusinessEntityLevel                  CONSTANT  VARCHAR2(100)                               := 'ALL';
    g_batch_name                              CONSTANT  VARCHAR2(300)                               := 'BE_'||to_char(TO_DATE(SYSDATE, 'DD-MON-RRRR'),'DDMMRRRRHHMISS') ;
    gv_hr_date					                        DATE                                        := '31-DEC-4712';
    gct_stgschema                                       VARCHAR2(10)                                := 'XXMX_STG';

    gvt_Severity                              xxmx_module_messages.severity%TYPE;
    gvt_ModuleMessage                         xxmx_module_messages.module_message%TYPE;
    gvt_OracleError                           xxmx_module_messages.oracle_error%TYPE;

    e_moduleerror                             EXCEPTION;
    e_dateerror                               EXCEPTION;
    gvv_migration_date                        VARCHAR2(30); 
    gvd_migration_date                        DATE;
    g_migration_date                          DATE   := '31-MAR-2024'; -- Added by Govardhan on 20Jan23
    gvn_RowCount                              NUMBER;
    gvv_migration_date_to                     VARCHAR2(30); 
    gvv_migration_date_from                   VARCHAR2(30); 
    gvv_prev_tax_year_date                    VARCHAR2(30);         
    gvd_migration_date_to                     DATE;  
    gvd_migration_date_from                   DATE;
    gvd_prev_tax_year_date                    DATE;
    gvv_cost_ext_type                         VARCHAR2(30);

PROCEDURE src_citco_updates
IS
BEGIN
EXECUTE IMMEDIATE 'alter session set nls_language = '||'AMERICAN';
UPDATE XXMX_PPM_PRJ_MISCCOST_STG
  SET  project_name = NULL
     , task_name =  NULL
     , work_type = NULL
     , unit_of_measure = apps.PA_UTILS4.get_unit_of_measure_m@xxmx_extract ( unit_of_measure,expenditure_type)
                                  ;     
--
UPDATE XXMX_PPM_PRJ_lbrCOST_STG
  SET  project_name = NULL
     , task_name =  NULL
     , work_type = NULL
     , unit_of_measure = apps.PA_UTILS4.get_unit_of_measure_m@xxmx_extract ( unit_of_measure,expenditure_type)
                                 ;     
--  

END src_citco_updates;


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
         AND   Business_entity IN('PRJ_COST')--,'PRJ_BILL_EVNT')
         AND   a.enabled_flag = 'Y'
         AND a.sub_entity in('LABOR_COST','MISC_COSTS','BILLING_EVENTS')
         ORDER
         BY  Business_entity_seq, 
             sub_entity_seq;

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'stg_main'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
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
        /* Migration Set ID Generation*/
        xxmx_utilities_pkg.init_migration_set
         (
         pt_i_ApplicationSuite  => gct_ApplicationSuite
         ,pt_i_Application       => gct_Application
         ,pt_i_BusinessEntity    => gv_i_BusinessEntity
         ,pt_i_MigrationSetName  => pt_i_MigrationSetName
         ,pt_o_MigrationSetID    => vt_MigrationSetID
         );

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
                   gv_i_BusinessEntity:= METADATA_REC.business_entity;

                    lv_sql:= 'BEGIN '
                            ||METADATA_REC.Entity_package_name
                            ||'.'||METADATA_REC.Stg_procedure_name
                            ||'('
                            ||vt_MigrationSetID
                            ||','''
                            ||METADATA_REC.sub_entity
                            ||''''||'); END;'
                            ;
                dbms_output.put_line(lv_sql );

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

        --src_citco_updates;

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





   PROCEDURE src_pa_all_lbr_costs
                     (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
                     ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
     AS   

          --
          --**********************
          --** Cursor Declarations
          --**********************
          --

--
        CURSOR src_pa_cost_dtl
        IS
                 select c.*             
                 from (select a.* from xxmx_ppm_open_ar_lbr_costs_v a
                 --where a.expenditure_item_date <= to_date('31-MAR-2024','DD-MON-YYYY')
                 union 
                 select a.* from xxmx_ppm_unbil_lbr_costs_v a
                 --where a.expenditure_item_date <= to_date('31-MAR-2024','DD-MON-YYYY')
                 ) c
       ;
       --
       --**********************
       --** Record Declarations
       --**********************
       --

        TYPE pa_costs_dtl_tbl IS TABLE OF src_pa_cost_dtl%ROWTYPE INDEX BY BINARY_INTEGER;
        pa_costs_dtl_tb  pa_costs_dtl_tbl;



       --
       --************************
       --** Constant Declarations
       --************************
       --
        cv_ProcOrFuncName                   CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'src_pa_open_ar_lbr_cost';
        cv_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PPM_PRJ_LBRCOST_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'LABOUR_COST';
        gv_i_BusinessEntity                                 VARCHAR2(100)     := 'PRJ_COST';


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
       l_error_count                         NUMBER;
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


       -- gvd_migration_date_to := TO_DATE(gvv_migration_date_to,'YYYY-MM-DD');
        --
         gvv_ProgressIndicator := '0010';
         xxmx_utilities_pkg.log_module_message(  
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName        => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'Deleting from "' || cv_StagingTable   || '".'
                ,pt_i_OracleError         => gvt_ReturnMessage  );
        --   
      DELETE 
        FROM    XXMX_PPM_PRJ_LBRCOST_STG ;

        COMMIT; 
        --

        gvv_ProgressIndicator := '0020';
        --
        gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
        dbms_output.put_line(gvt_MigrationSetName);
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

         --   IF( UPPER(gvv_cost_ext_type) = 'SUMMARY') THEN 

           --      null;

          --  ELSIF ( UPPER(gvv_cost_ext_type) = 'DETAIL')   
          --  THEN

                  OPEN src_pa_cost_dtl;
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
                         ,pt_i_ModuleMessage       =>'Cursor Open src_pa_cost_dtl'
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
                  FETCH src_pa_cost_dtl  BULK COLLECT INTO pa_costs_dtl_tb;-- LIMIT 1000;
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
                         ,pt_i_ModuleMessage       => 'Cursor src_pa_cost_dtl Fetch into pa_costs_dtl_tb'
                         ,pt_i_OracleError         => gvt_ReturnMessage  );
                  --
                  EXIT WHEN pa_costs_dtl_tb.COUNT=0;
                  --
                  DELETE from XXMX_PPM_PRJ_LBRCOST_STG;
                  --
                  FORALL I IN 1..pa_costs_dtl_tb.COUNT SAVE EXCEPTIONS
                  --
                       INSERT INTO XXMX_PPM_PRJ_LBRCOST_STG (
                                           migration_set_id                 
                                          ,migration_set_name               
                                          ,migration_status                 
                                          ,transaction_type                
                                          ,business_unit                   
                                          ,org_id                          
                                          ,user_transaction_source         
                                          ,transaction_source_id           
                                          ,document_name                   
                                          ,document_id                     
                                          ,doc_entry_name                  
                                          ,doc_entry_id                    
                                          ,batch_ending_date               
                                          ,batch_description               
                                          ,expenditure_item_date           
                                          ,person_number                   
                                          ,person_name                     
                                          ,person_id                       
                                          ,hcm_assignment_name             
                                          ,hcm_assignment_id               
                                          ,project_number                  
                                          ,project_name                    
                                          ,project_id                      
                                          ,task_number                     
                                          ,task_name                       
                                          ,task_id                         
                                          ,expenditure_type                
                                          ,expenditure_type_id             
                                          ,organization_name               
                                          ,organization_id                 
                                         -- ,non_labor_resource              
                                          --,non_labor_resource_id           
                                          --,non_labor_resource_org          
                                          --,non_labor_resource_org_id       
                                          ,quantity                        
                                          ,unit_of_measure_name            
                                          ,unit_of_measure                 
                                          ,work_type                       
                                          ,work_type_id                    
                                          ,billable_flag                   
                                          ,capitalizable_flag              
                                          ,accrual_flag                    
                                         -- ,supplier_number                 
                                          --,supplier_name                   
                                          --,vendor_id                       
                                          --,inventory_item_name             
                                         -- ,inventory_item_id               
                                          ,orig_transaction_reference      
                                          ,unmatched_negative_txn_flag     
                                          ,reversed_orig_txn_reference     
                                          ,expenditure_comment             
                                          ,gl_date                         
                                          ,denom_currency_code             
                                          ,denom_currency                  
                                          ,denom_raw_cost                  
                                          ,denom_burdened_cost             
                                          ,raw_cost_cr_ccid                
                                          ,raw_cost_cr_account             
                                          ,raw_cost_dr_ccid                
                                          ,raw_cost_dr_account             
                                          ,burdened_cost_cr_ccid           
                                          ,burdened_cost_cr_account        
                                          ,burdened_cost_dr_ccid           
                                          ,burdened_cost_dr_account        
                                          ,burden_cost_cr_ccid             
                                          ,burden_cost_cr_account          
                                          ,burden_cost_dr_ccid             
                                          ,burden_cost_dr_account          
                                          ,acct_currency_code              
                                          ,acct_currency                   
                                          ,acct_raw_cost                   
                                          ,acct_burdened_cost              
                                          ,acct_rate_type                  
                                          ,acct_rate_date                  
                                          ,acct_rate_date_type             
                                          ,acct_exchange_rate              
                                          ,acct_exchange_rounding_limit    
                                          --,receipt_currency_code           
                                          --,receipt_currency                
                                          --,receipt_currency_amount         
                                         -- ,receipt_exchange_rate           
                                          ,converted_flag                  
                                          ,context_category                
                                          ,user_def_attribute1             
                                          ,user_def_attribute2             
                                          ,user_def_attribute3             
                                          ,user_def_attribute4             
                                          ,user_def_attribute5             
                                          ,user_def_attribute6             
                                          ,user_def_attribute7             
                                          ,user_def_attribute8             
                                          ,user_def_attribute9             
                                          ,user_def_attribute10            
                                          ,reserved_attribute1             
                                          ,reserved_attribute2             
                                          ,reserved_attribute3             
                                          ,reserved_attribute4             
                                          ,reserved_attribute5             
                                          ,reserved_attribute6             
                                          ,reserved_attribute7             
                                          ,reserved_attribute8             
                                          ,reserved_attribute9             
                                          ,reserved_attribute10            
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
                                          ,contract_number                 
                                          ,contract_name                   
                                          ,contract_id                     
                                          ,funding_source_number           
                                          ,funding_source_name             
                                          ,batch_name                       
                                          ,batch_id                         
                                          ,last_updated_by                  
                                          ,created_by                       
                                          ,last_update_login                
                                          ,last_update_date                 
                                          ,creation_date
										  ,cost_type
                                          ,bill_group
                                          ,ar_invoice_number
                                          --,project_currency_code
                                          --,project_raw_cost										  
                                         )
                                   VALUES
                                         (
                                           pt_i_MigrationSetID
                                          ,gvt_MigrationSetName
                                          ,'EXTRACTED'
                                          ,pa_costs_dtl_tb(i).transaction_type                
                                          ,pa_costs_dtl_tb(i).business_unit                   
                                          ,pa_costs_dtl_tb(i).org_id                          
                                          ,pa_costs_dtl_tb(i).user_transaction_source         
                                          ,pa_costs_dtl_tb(i).transaction_source_id           
                                          ,pa_costs_dtl_tb(i).document_name                   
                                          ,pa_costs_dtl_tb(i).document_id                     
                                          ,pa_costs_dtl_tb(i).doc_entry_name                  
                                          ,pa_costs_dtl_tb(i).doc_entry_id                    
                                          ,pa_costs_dtl_tb(i).batch_ending_date               
                                          ,pa_costs_dtl_tb(i).batch_description               
                                          ,pa_costs_dtl_tb(i).expenditure_item_date           
                                          ,pa_costs_dtl_tb(i).person_number                   
                                          ,pa_costs_dtl_tb(i).person_name                     
                                          ,pa_costs_dtl_tb(i).person_id                       
                                          ,pa_costs_dtl_tb(i).hcm_assignment_name             
                                          ,pa_costs_dtl_tb(i).hcm_assignment_id               
                                          ,pa_costs_dtl_tb(i).project_number                  
                                          ,pa_costs_dtl_tb(i).project_name                    
                                          ,pa_costs_dtl_tb(i).project_id                      
                                          ,pa_costs_dtl_tb(i).task_number                     
                                          ,pa_costs_dtl_tb(i).task_name                       
                                          ,pa_costs_dtl_tb(i).task_id                         
                                          ,pa_costs_dtl_tb(i).expenditure_type                
                                          ,pa_costs_dtl_tb(i).expenditure_type_id             
                                          ,pa_costs_dtl_tb(i).organization_name               
                                          ,pa_costs_dtl_tb(i).organization_id                 
                                          --,pa_costs_dtl_tb(i).non_labor_resource              
                                          --,pa_costs_dtl_tb(i).non_labor_resource_id           
                                          --,pa_costs_dtl_tb(i).non_labor_resource_org          
                                          --,pa_costs_dtl_tb(i).non_labor_resource_org_id       
                                          ,pa_costs_dtl_tb(i).quantity                        
                                          ,pa_costs_dtl_tb(i).unit_of_measure_name            
                                          ,pa_costs_dtl_tb(i).unit_of_measure                 
                                          --,pa_costs_dtl_tb(i).work_type                       
                                          ,null  
                                          ,pa_costs_dtl_tb(i).work_type_id                    
                                          ,pa_costs_dtl_tb(i).billable_flag                   
                                          ,pa_costs_dtl_tb(i).capitalizable_flag              
                                          ,pa_costs_dtl_tb(i).accrual_flag                    
                                          --,pa_costs_dtl_tb(i).supplier_number                 
                                          --,pa_costs_dtl_tb(i).supplier_name                   
                                          --,pa_costs_dtl_tb(i).vendor_id                       
                                          --,pa_costs_dtl_tb(i).inventory_item_name             
                                          --,pa_costs_dtl_tb(i).inventory_item_id               
                                          ,pa_costs_dtl_tb(i).orig_transaction_reference      
                                          ,pa_costs_dtl_tb(i).unmatched_negative_txn_flag     
                                          ,pa_costs_dtl_tb(i).reversed_orig_txn_reference     
                                          ,pa_costs_dtl_tb(i).expenditure_comment             
                                          ,pa_costs_dtl_tb(i).gl_date                         
                                          ,pa_costs_dtl_tb(i).denom_currency_code             
                                          ,pa_costs_dtl_tb(i).denom_currency                  
                                          ,pa_costs_dtl_tb(i).denom_raw_cost                  
                                          ,pa_costs_dtl_tb(i).denom_burdened_cost             
                                          ,pa_costs_dtl_tb(i).raw_cost_cr_ccid                
                                          ,pa_costs_dtl_tb(i).raw_cost_cr_account             
                                          ,pa_costs_dtl_tb(i).raw_cost_dr_ccid                
                                          ,pa_costs_dtl_tb(i).raw_cost_dr_account             
                                          ,pa_costs_dtl_tb(i).burdened_cost_cr_ccid           
                                          ,pa_costs_dtl_tb(i).burdened_cost_cr_account        
                                          ,pa_costs_dtl_tb(i).burdened_cost_dr_ccid           
                                          ,pa_costs_dtl_tb(i).burdened_cost_dr_account        
                                          ,pa_costs_dtl_tb(i).burden_cost_cr_ccid             
                                          ,pa_costs_dtl_tb(i).burden_cost_cr_account           
                                          ,pa_costs_dtl_tb(i).burden_cost_dr_ccid             
                                          ,pa_costs_dtl_tb(i).burden_cost_dr_account          
                                          ,pa_costs_dtl_tb(i).acct_currency_code              
                                          ,pa_costs_dtl_tb(i).acct_currency                   
                                          ,pa_costs_dtl_tb(i).acct_raw_cost                   
                                          ,pa_costs_dtl_tb(i).acct_burdened_cost              
                                          ,pa_costs_dtl_tb(i).acct_rate_type                  
                                          ,pa_costs_dtl_tb(i).acct_rate_date                  
                                          ,pa_costs_dtl_tb(i).acct_rate_date_type             
                                          ,pa_costs_dtl_tb(i).acct_exchange_rate              
                                          ,pa_costs_dtl_tb(i).acct_exchange_rounding_limit    
                                          --,pa_costs_dtl_tb(i).receipt_currency_code           
                                          --,pa_costs_dtl_tb(i).receipt_currency                
                                          --,pa_costs_dtl_tb(i).receipt_currency_amount         
                                          --,pa_costs_dtl_tb(i).receipt_exchange_rate           
                                          ,pa_costs_dtl_tb(i).converted_flag                  
                                          ,pa_costs_dtl_tb(i).context_category                
                                          ,pa_costs_dtl_tb(i).user_def_attribute1             
                                          ,pa_costs_dtl_tb(i).user_def_attribute2             
                                          ,pa_costs_dtl_tb(i).user_def_attribute3             
                                          ,pa_costs_dtl_tb(i).user_def_attribute4             
                                          ,pa_costs_dtl_tb(i).user_def_attribute5             
                                          ,pa_costs_dtl_tb(i).user_def_attribute6             
                                          ,pa_costs_dtl_tb(i).user_def_attribute7             
                                          ,pa_costs_dtl_tb(i).user_def_attribute8             
                                          ,pa_costs_dtl_tb(i).user_def_attribute9             
                                          ,pa_costs_dtl_tb(i).user_def_attribute10            
                                          ,pa_costs_dtl_tb(i).reserved_attribute1             
                                          ,pa_costs_dtl_tb(i).reserved_attribute2             
                                          ,pa_costs_dtl_tb(i).reserved_attribute3             
                                          ,pa_costs_dtl_tb(i).reserved_attribute4             
                                          ,pa_costs_dtl_tb(i).reserved_attribute5             
                                          ,pa_costs_dtl_tb(i).reserved_attribute6             
                                          ,pa_costs_dtl_tb(i).reserved_attribute7             
                                          ,pa_costs_dtl_tb(i).reserved_attribute8             
                                          ,pa_costs_dtl_tb(i).reserved_attribute9             
                                          ,pa_costs_dtl_tb(i).reserved_attribute10            
                                          ,pa_costs_dtl_tb(i).attribute_category              
                                          ,pa_costs_dtl_tb(i).attribute1                      
                                          ,pa_costs_dtl_tb(i).attribute2                      
                                          --,pa_costs_dtl_tb(i).attribute3                      
                                          ,pa_costs_dtl_tb(i).ar_invoice_number
                                          ,pa_costs_dtl_tb(i).attribute4                      
                                          ,pa_costs_dtl_tb(i).attribute5                      
                                          ,pa_costs_dtl_tb(i).attribute6                      
                                          ,pa_costs_dtl_tb(i).attribute7                      
                                          ,pa_costs_dtl_tb(i).attribute8                      
                                          ,pa_costs_dtl_tb(i).attribute9                      
                                          ,pa_costs_dtl_tb(i).attribute10                     
                                          ,pa_costs_dtl_tb(i).contract_number                 
                                          ,pa_costs_dtl_tb(i).contract_name                   
                                          ,pa_costs_dtl_tb(i).contract_id                     
                                          ,pa_costs_dtl_tb(i).funding_source_number           
                                          ,pa_costs_dtl_tb(i).funding_source_name             
                                          ,g_batch_name    
                                         ,to_char(TO_DATE(SYSDATE, 'DD-MON-RRRR'),'DDMMRRRRHHMISS')   
                                         ,xxmx_utilities_pkg.gvv_UserName 
                                         ,xxmx_utilities_pkg.gvv_UserName
                                         ,xxmx_utilities_pkg.gvv_UserName
                                         ,SYSDATE                                                     
                                         ,SYSDATE
										 ,pa_costs_dtl_tb(i).cost_type
                                         ,pa_costs_dtl_tb(i).bill_group
                                         ,pa_costs_dtl_tb(i).ar_invoice_number
										 --,pa_costs_dtl_tb(i).project_currency_code
                                         --,pa_costs_dtl_tb(i).project_raw_cost
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
                                    ,pt_i_ModuleMessage       => 'Close the Cursor src_pa_cost_dtl'
                                    ,pt_i_OracleError         => gvt_ReturnMessage       );   
                   --


                   IF src_pa_cost_dtl%ISOPEN
                   THEN
                        --
                           CLOSE src_pa_cost_dtl;
                        --
                   END IF;

             /*  ELSE 
                  --
                  gvv_ProgressIndicator := '0090';
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
                                    ,pt_i_ModuleMessage       => 'Parameter Cost_ext_type is mandatory - Summary or Detail Extract'
                                    ,pt_i_OracleError         => gvt_ReturnMessage       );   
                   --
               END IF;*/  

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
/*            -- Populate the invoice rate date for FX curr conv calc in Cloud.   Commented out after DRY RUN as exchange rate change is not required on labor cost
               UPDATE xxmx_ppm_prj_lbrcost_stg x
                  SET x.ATTRIBUTE5 = (select to_char(nvl(e.projfunc_inv_rate_date,e.project_inv_rate_date),'DD-MON-YYYY')
                                      from xxmx_pa_exp_scope_all e 
                                      where e.expenditure_item_id = to_number(x.attribute1) and rownum < 2)
               WHERE  x.cost_type in ('CLOSED_AR','OPEN_AR')
               AND    x.acct_rate_type is not null
               ;
*/

--DELETE costs after cutover period
    DELETE from xxmx_ppm_prj_lbrcost_stg s
    where 1=1
    and s.cost_type = 'OPEN_AR'
    and s.attribute1 not in (
    select distinct to_char(e.expenditure_item_id) attribute1
    FROM
        xxmx_pa_expenditure_items_all   e
        LEFT JOIN xxmx_pa_cust_rev_dist_lines_all rev ON e.expenditure_item_id = rev.expenditure_item_id
                                                       AND e.project_id = rev.project_id
        LEFT JOIN xxmx_costs_pa_draft_invoices_all      pdi ON rev.draft_invoice_num = pdi.draft_invoice_num
                                                  AND rev.project_id = pdi.project_id
        INNER JOIN xxmx_ppm_projects_stg p  ON e.project_id = p.project_id
    WHERE
            1 = 1
        AND coalesce(pdi.write_off_flag, 'A') <> 'Y' 
        AND trunc(pdi.gl_date) <= nvl((
            SELECT
                MAX(trunc(end_date))
            FROM
                gl.gl_periods@xxmx_Extract
            WHERE
                period_name =('MAR-24')
        ), trunc(pdi.gl_date))
        AND pdi.transfer_status_code IN ( 'P', 'A', 'T' )
);

    DELETE from xxmx_ppm_prj_lbrcost_stg s
    where 1=1
    and s.cost_type = 'UNBILLED'
    and s.gl_date > to_date('31-MAR-2024');


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



     END src_pa_all_lbr_costs;


   PROCEDURE src_pa_all_misc_costs
                     (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
                     ,pt_i_SubEntity                   IN      xxmx_migration_metadata.sub_entity%TYPE)
     AS   

          --
          --**********************
          --** Cursor Declarations
          --**********************
          --


    CURSOR src_pa_cost_dtl
    IS
    SELECT      c.*
    FROM ( select a.* from xxmx_ppm_open_ar_misc_costs_v a
           --where a.expenditure_item_date <= to_date('31-MAR-2024','DD-MON-YYYY')
           union
           select a.* from xxmx_ppm_unbil_misc_costs_v a
           --where a.expenditure_item_date <= to_date('31-MAR-2024','DD-MON-YYYY')
            ) c;
       --
       --**********************
       --** Record Declarations
       --**********************
       --

        TYPE pa_costs_dtl_tbl IS TABLE OF src_pa_cost_dtl%ROWTYPE INDEX BY BINARY_INTEGER;
        pa_costs_dtl_tb  pa_costs_dtl_tbl;



       --
       --************************
       --** Constant Declarations
       --************************
       --
        cv_ProcOrFuncName                   CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'src_pa_all_misc_costs';
        cv_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PPM_PRJ_MISCCOST_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'MISC_COSTS';
        gv_i_BusinessEntity                                 VARCHAR2(100)     := 'PRJ_COST';


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
       l_error_count                         NUMBER;
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

       /* gvv_cost_ext_type := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'PRJ_COST'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'COST_EXT_TYPE');

        gvv_migration_date_from := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'ALL'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'EXTRACT_START_DATE'
        );        
        --gvd_migration_date_from := TO_DATE(gvv_migration_date_from,'YYYY-MM-DD');


        gvv_migration_date_to := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'ALL'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'EXTRACT_END_DATE'
        );    */    
       -- gvd_migration_date_to := TO_DATE(gvv_migration_date_to,'YYYY-MM-DD');
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
        DELETE 
        FROM    XXMX_PPM_PRJ_MISCCOST_STG ;

        COMMIT; 
        --

        gvv_ProgressIndicator := '0020';
        --
        gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
        dbms_output.put_line(gvt_MigrationSetName);
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
                 ); */
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

            --IF( UPPER(gvv_cost_ext_type) = 'SUMMARY') THEN 

            --   null;

           -- ELSIF ( UPPER(gvv_cost_ext_type) = 'DETAIL')   
          --  THEN

                  OPEN src_pa_cost_dtl;
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
                         ,pt_i_ModuleMessage       =>'Cursor Open src_pa_cost_dtl'
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
                  FETCH src_pa_cost_dtl  BULK COLLECT INTO pa_costs_dtl_tb;-- LIMIT 1000;
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
                         ,pt_i_ModuleMessage       => 'Cursor src_pa_cost_dtl Fetch into pa_costs_dtl_tb'
                         ,pt_i_OracleError         => gvt_ReturnMessage  );
                  --
                  EXIT WHEN pa_costs_dtl_tb.COUNT=0;
                  --
                  FORALL I IN 1..pa_costs_dtl_tb.COUNT SAVE EXCEPTIONS
                  --
                       INSERT INTO XXMX_PPM_PRJ_MISCCOST_STG (
                                           migration_set_id                 
                                          ,migration_set_name               
                                          ,migration_status                 
                                          ,transaction_type                
                                          ,business_unit                   
                                          ,org_id                          
                                          ,user_transaction_source         
                                          ,transaction_source_id           
                                          ,document_name                   
                                          ,document_id                     
                                          ,doc_entry_name                  
                                          ,doc_entry_id                    
                                          ,batch_ending_date               
                                          ,batch_description               
                                          ,expenditure_item_date           
                                          ,person_number                   
                                          ,person_name                     
                                          ,person_id                       
                                          ,hcm_assignment_name             
                                          ,hcm_assignment_id               
                                          ,project_number                  
                                          ,project_name                    
                                          ,project_id                      
                                          ,task_number                     
                                          ,task_name                       
                                          ,task_id                         
                                          ,expenditure_type                
                                          ,expenditure_type_id             
                                          ,organization_name               
                                          ,organization_id                 
                                         -- ,non_labor_resource              
                                          --,non_labor_resource_id           
                                          --,non_labor_resource_org          
                                          --,non_labor_resource_org_id       
                                          ,quantity                        
                                          ,unit_of_measure_name            
                                          ,unit_of_measure                 
                                          ,work_type                       
                                          ,work_type_id                    
                                          ,billable_flag                   
                                          ,capitalizable_flag              
                                          ,accrual_flag                    
                                         -- ,supplier_number                 
                                          --,supplier_name                   
                                          --,vendor_id                       
                                          --,inventory_item_name             
                                         -- ,inventory_item_id               
                                          ,orig_transaction_reference      
                                          ,unmatched_negative_txn_flag     
                                          ,reversed_orig_txn_reference     
                                          ,expenditure_comment             
                                          ,gl_date                         
                                          ,denom_currency_code             
                                          ,denom_currency                  
                                          ,denom_raw_cost                  
                                          ,denom_burdened_cost             
                                          ,raw_cost_cr_ccid                
                                          ,raw_cost_cr_account             
                                          ,raw_cost_dr_ccid                
                                          ,raw_cost_dr_account             
                                          ,burdened_cost_cr_ccid           
                                          ,burdened_cost_cr_account        
                                          ,burdened_cost_dr_ccid           
                                          ,burdened_cost_dr_account        
                                          ,burden_cost_cr_ccid             
                                          ,burden_cost_cr_account          
                                          ,burden_cost_dr_ccid             
                                          ,burden_cost_dr_account          
                                          ,acct_currency_code              
                                          ,acct_currency                   
                                          ,acct_raw_cost                   
                                          ,acct_burdened_cost              
                                          ,acct_rate_type                  
                                          ,acct_rate_date                  
                                          ,acct_rate_date_type             
                                          ,acct_exchange_rate              
                                          ,acct_exchange_rounding_limit    
                                          --,receipt_currency_code           
                                          --,receipt_currency                
                                          --,receipt_currency_amount         
                                         -- ,receipt_exchange_rate           
                                          ,converted_flag                  
                                          ,context_category                
                                          ,user_def_attribute1             
                                          ,user_def_attribute2             
                                          ,user_def_attribute3             
                                          ,user_def_attribute4             
                                          ,user_def_attribute5             
                                          ,user_def_attribute6             
                                          ,user_def_attribute7             
                                          ,user_def_attribute8             
                                          ,user_def_attribute9             
                                          ,user_def_attribute10            
                                          ,reserved_attribute1             
                                          ,reserved_attribute2             
                                          ,reserved_attribute3             
                                          ,reserved_attribute4             
                                          ,reserved_attribute5             
                                          ,reserved_attribute6             
                                          ,reserved_attribute7             
                                          ,reserved_attribute8             
                                          ,reserved_attribute9             
                                          ,reserved_attribute10            
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
                                          ,contract_number                 
                                          ,contract_name                   
                                          ,contract_id                     
                                          ,funding_source_number           
                                          ,funding_source_name             
                                          ,batch_name                       
                                          ,batch_id                         
                                          ,last_updated_by                  
                                          ,created_by                       
                                          ,last_update_login                
                                          ,last_update_date                 
                                          ,creation_date
										  ,cost_type
                                          ,bill_group
                                          ,ar_invoice_number
                                          --,project_currency_code
                                          --,project_raw_cost            
                                   )
                                 VALUES
                                 (
                                   pt_i_MigrationSetID
                                  ,gvt_MigrationSetName
                                  ,'EXTRACTED'
                                  ,pa_costs_dtl_tb(i).transaction_type                
                                  ,pa_costs_dtl_tb(i).business_unit                   
                                  ,pa_costs_dtl_tb(i).org_id                          
                                  ,pa_costs_dtl_tb(i).user_transaction_source         
                                  ,pa_costs_dtl_tb(i).transaction_source_id           
                                  ,pa_costs_dtl_tb(i).document_name                   
                                  ,pa_costs_dtl_tb(i).document_id                     
                                  ,pa_costs_dtl_tb(i).doc_entry_name                  
                                  ,pa_costs_dtl_tb(i).doc_entry_id                    
                                  ,pa_costs_dtl_tb(i).batch_ending_date               
                                  ,pa_costs_dtl_tb(i).batch_description               
                                  ,pa_costs_dtl_tb(i).expenditure_item_date           
                                  ,pa_costs_dtl_tb(i).person_number                   
                                  ,pa_costs_dtl_tb(i).person_name                     
                                  ,pa_costs_dtl_tb(i).person_id                       
                                  ,pa_costs_dtl_tb(i).hcm_assignment_name             
                                  ,pa_costs_dtl_tb(i).hcm_assignment_id               
                                  ,pa_costs_dtl_tb(i).project_number                  
                                  ,pa_costs_dtl_tb(i).project_name                    
                                  ,pa_costs_dtl_tb(i).project_id                      
                                  ,pa_costs_dtl_tb(i).task_number                     
                                  ,pa_costs_dtl_tb(i).task_name                       
                                  ,pa_costs_dtl_tb(i).task_id                         
                                  ,pa_costs_dtl_tb(i).expenditure_type                
                                  ,pa_costs_dtl_tb(i).expenditure_type_id             
                                  ,pa_costs_dtl_tb(i).organization_name               
                                  ,pa_costs_dtl_tb(i).organization_id                 
                                  --,pa_costs_dtl_tb(i).non_labor_resource              
                                  --,pa_costs_dtl_tb(i).non_labor_resource_id           
                                  --,pa_costs_dtl_tb(i).non_labor_resource_org          
                                  --,pa_costs_dtl_tb(i).non_labor_resource_org_id       
                                  ,pa_costs_dtl_tb(i).quantity                        
                                  ,pa_costs_dtl_tb(i).unit_of_measure_name            
                                  ,pa_costs_dtl_tb(i).unit_of_measure                 
                                  --,pa_costs_dtl_tb(i).work_type                       
                                  ,null         
                                  ,pa_costs_dtl_tb(i).work_type_id                    
                                  ,pa_costs_dtl_tb(i).billable_flag                   
                                  ,pa_costs_dtl_tb(i).capitalizable_flag              
                                  ,pa_costs_dtl_tb(i).accrual_flag                    
                                  --,pa_costs_dtl_tb(i).supplier_number                 
                                  --,pa_costs_dtl_tb(i).supplier_name                   
                                  --,pa_costs_dtl_tb(i).vendor_id                       
                                  --,pa_costs_dtl_tb(i).inventory_item_name             
                                  --,pa_costs_dtl_tb(i).inventory_item_id               
                                  ,pa_costs_dtl_tb(i).orig_transaction_reference      
                                  ,pa_costs_dtl_tb(i).unmatched_negative_txn_flag     
                                  ,pa_costs_dtl_tb(i).reversed_orig_txn_reference     
                                  ,pa_costs_dtl_tb(i).expenditure_comment             
                                  ,pa_costs_dtl_tb(i).gl_date                         
                                  ,pa_costs_dtl_tb(i).denom_currency_code             
                                  ,pa_costs_dtl_tb(i).denom_currency                  
                                  ,pa_costs_dtl_tb(i).denom_raw_cost                  
                                  ,pa_costs_dtl_tb(i).denom_burdened_cost             
                                  ,pa_costs_dtl_tb(i).raw_cost_cr_ccid                
                                  ,pa_costs_dtl_tb(i).raw_cost_cr_account             
                                  ,pa_costs_dtl_tb(i).raw_cost_dr_ccid                
                                  ,pa_costs_dtl_tb(i).raw_cost_dr_account             
                                  ,pa_costs_dtl_tb(i).burdened_cost_cr_ccid           
                                  ,pa_costs_dtl_tb(i).burdened_cost_cr_account        
                                  ,pa_costs_dtl_tb(i).burdened_cost_dr_ccid           
                                  ,pa_costs_dtl_tb(i).burdened_cost_dr_account        
                                  ,pa_costs_dtl_tb(i).burden_cost_cr_ccid             
                                  ,pa_costs_dtl_tb(i).burden_cost_cr_account           
                                  ,pa_costs_dtl_tb(i).burden_cost_dr_ccid             
                                  ,pa_costs_dtl_tb(i).burden_cost_dr_account          
                                  ,pa_costs_dtl_tb(i).acct_currency_code              
                                  ,pa_costs_dtl_tb(i).acct_currency                   
                                  ,pa_costs_dtl_tb(i).acct_raw_cost                   
                                  ,pa_costs_dtl_tb(i).acct_burdened_cost              
                                  ,pa_costs_dtl_tb(i).acct_rate_type                  
                                  ,pa_costs_dtl_tb(i).acct_rate_date                  
                                  ,pa_costs_dtl_tb(i).acct_rate_date_type             
                                  ,pa_costs_dtl_tb(i).acct_exchange_rate              
                                  ,pa_costs_dtl_tb(i).acct_exchange_rounding_limit    
                                  --,pa_costs_dtl_tb(i).receipt_currency_code           
                                  --,pa_costs_dtl_tb(i).receipt_currency                
                                  --,pa_costs_dtl_tb(i).receipt_currency_amount         
                                  --,pa_costs_dtl_tb(i).receipt_exchange_rate           
                                  ,pa_costs_dtl_tb(i).converted_flag                  
                                  ,pa_costs_dtl_tb(i).context_category                
                                  ,pa_costs_dtl_tb(i).user_def_attribute1             
                                  ,pa_costs_dtl_tb(i).user_def_attribute2             
                                  ,pa_costs_dtl_tb(i).user_def_attribute3             
                                  ,pa_costs_dtl_tb(i).user_def_attribute4             
                                  ,pa_costs_dtl_tb(i).user_def_attribute5             
                                  ,pa_costs_dtl_tb(i).user_def_attribute6             
                                  ,pa_costs_dtl_tb(i).user_def_attribute7             
                                  ,pa_costs_dtl_tb(i).user_def_attribute8             
                                  ,pa_costs_dtl_tb(i).user_def_attribute9             
                                  ,pa_costs_dtl_tb(i).user_def_attribute10            
                                  ,pa_costs_dtl_tb(i).reserved_attribute1             
                                  ,pa_costs_dtl_tb(i).reserved_attribute2             
                                  ,pa_costs_dtl_tb(i).reserved_attribute3             
                                  ,pa_costs_dtl_tb(i).reserved_attribute4             
                                  ,pa_costs_dtl_tb(i).reserved_attribute5             
                                  ,pa_costs_dtl_tb(i).reserved_attribute6             
                                  ,pa_costs_dtl_tb(i).reserved_attribute7             
                                  ,pa_costs_dtl_tb(i).reserved_attribute8             
                                  ,pa_costs_dtl_tb(i).reserved_attribute9             
                                  ,pa_costs_dtl_tb(i).reserved_attribute10            
                                  ,pa_costs_dtl_tb(i).attribute_category              
                                  ,pa_costs_dtl_tb(i).attribute1                      
                                  ,pa_costs_dtl_tb(i).attribute2                      
                                  --,pa_costs_dtl_tb(i).attribute3                      
                                  ,pa_costs_dtl_tb(i).ar_invoice_number      
                                  ,pa_costs_dtl_tb(i).attribute4                      
                                  ,pa_costs_dtl_tb(i).attribute5                      
                                  ,pa_costs_dtl_tb(i).attribute6                      
                                  ,pa_costs_dtl_tb(i).attribute7                      
                                  ,pa_costs_dtl_tb(i).attribute8                      
                                  ,pa_costs_dtl_tb(i).attribute9                      
                                  ,pa_costs_dtl_tb(i).attribute10                     
                                  ,pa_costs_dtl_tb(i).contract_number                 
                                  ,pa_costs_dtl_tb(i).contract_name                   
                                  ,pa_costs_dtl_tb(i).contract_id                     
                                  ,pa_costs_dtl_tb(i).funding_source_number           
                                  ,pa_costs_dtl_tb(i).funding_source_name             
                                  ,g_batch_name    
                                 ,to_char(TO_DATE(SYSDATE, 'DD-MON-RRRR'),'DDMMRRRRHHMISS')   
                                 ,xxmx_utilities_pkg.gvv_UserName 
                                 ,xxmx_utilities_pkg.gvv_UserName
                                 ,xxmx_utilities_pkg.gvv_UserName
                                 ,SYSDATE                                                     
                                 ,SYSDATE
                                 ,pa_costs_dtl_tb(i).cost_type
                                 ,pa_costs_dtl_tb(i).bill_group  
                                 ,pa_costs_dtl_tb(i).ar_invoice_number
                                 --,pa_costs_dtl_tb(i).project_currency_code
                                 --,pa_costs_dtl_tb(i).project_raw_cost            
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
                                    ,pt_i_ModuleMessage       => 'Close the Cursor src_pa_cost_dtl'
                                    ,pt_i_OracleError         => gvt_ReturnMessage       );   
                   --


                   IF src_pa_cost_dtl%ISOPEN
                   THEN
                        --
                           CLOSE src_pa_cost_dtl;
                        --
                   END IF;

             /*  ELSE 
                  --
                  gvv_ProgressIndicator := '0090';
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
                                    ,pt_i_ModuleMessage       => 'Parameter Cost_ext_type is mandatory - Summary or Detail Extract'
                                    ,pt_i_OracleError         => gvt_ReturnMessage       );   
                   --
               END IF;  */

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
            -- Populate the invoice rate date for FX curr conv calc in Cloud.
/*               UPDATE xxmx_ppm_prj_misccost_stg x
                  SET x.ATTRIBUTE5 = (select to_char(nvl(e.projfunc_inv_rate_date,e.project_inv_rate_date),'DD-MON-YYYY')
                                      from xxmx_pa_exp_scope_all e 
                                      where e.expenditure_item_id = to_number(x.attribute1) and rownum < 2)
               WHERE  x.cost_type in ('CLOSED_AR','OPEN_AR')
               AND    x.acct_rate_type is not null
               ;
*/

               UPDATE xxmx_ppm_prj_misccost_xfm x
                  SET x.expenditure_item_date = (select nvl(e.projfunc_inv_rate_date,e.project_inv_rate_date)
                                                 from   xxmx_pa_expenditure_items_all e 
                                                 where  e.expenditure_item_id = to_number(x.attribute1) 
                                                   and  rownum < 2)
                WHERE  x.cost_type in ('OPEN_AR')
                  and  exists (select null from xxmx_pa_expenditure_items_all r
                               where 1=1
                                 and r.expenditure_item_id = to_number(x.attribute1)
                                 and x.denom_currency_code <> r.project_currency_code);



--DELETE costs after cutover period
    DELETE from xxmx_ppm_prj_misccost_stg s
    where 1=1
    and s.cost_type = 'OPEN_AR'
    and s.attribute1 not in (
    select distinct to_char(e.expenditure_item_id) attribute1
    FROM
        xxmx_pa_expenditure_items_all   e
        LEFT JOIN xxmx_pa_cust_rev_dist_lines_all rev ON e.expenditure_item_id = rev.expenditure_item_id
                                                       AND e.project_id = rev.project_id
        LEFT JOIN xxmx_costs_pa_draft_invoices_all      pdi ON rev.draft_invoice_num = pdi.draft_invoice_num
                                                  AND rev.project_id = pdi.project_id
        INNER JOIN xxmx_ppm_projects_stg p  ON e.project_id = p.project_id
    WHERE
            1 = 1
        AND coalesce(pdi.write_off_flag, 'A') <> 'Y' 
        AND trunc(pdi.gl_date) <= nvl((
            SELECT
                MAX(trunc(end_date))
            FROM
                gl.gl_periods@xxmx_Extract
            WHERE
                period_name =('MAR-24')
        ), trunc(pdi.gl_date))
        AND pdi.transfer_status_code IN ( 'P', 'A', 'T' )
);


    DELETE from xxmx_ppm_prj_misccost_stg s
    where 1=1
    and s.cost_type = 'UNBILLED'
    and s.gl_date > to_date('31-MAR-2024');


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



     END src_pa_all_misc_costs;




   PROCEDURE src_pa_all_events
                     (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                     ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
   IS
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --

        CURSOR src_pa_billing_events_cur
        IS
            select                  NULL                  EXTRACT_REF
                ,SYSDATE               DATE_EXTRACTED
                ,ROWNUM                EXTRACT_ROW_NUMBER
                ,evt.*
            from (select distinct          sourcename                 
                                         , sourceref                  
                                         , organization_name          
                                         , contract_type_name         
                                         , contract_number            
                                         , contract_line_number       
                                         , event_type_name            
                                         , event_desc                 
                                         , completion_date            
                                         , bill_trns_currency_code    
                                         , bill_trns_amount           
                                         , project_number             
                                         , task_number                
                                         , bill_hold_flag             
                                         , revenue_hold_flag          
                                         , attribute_category         
                                         , attribute1                 
                                         , attribute2                 
                                         , attribute3                 
                                         , attribute4                 
                                         , attribute5                 
                                         , attribute6                 
                                         , attribute7                 
                                         , attribute8                 
                                         , attribute9                 
                                         , attribute10
                  from xxmx_ppm_di_evts_v a 
                  where a.BILL_TRNS_AMOUNT <> 0 
                    --and a.completion_date <= to_date('31-MAR-2024','DD-MON-YYYY')
                    and (a.event_desc like '%2021%' or a.event_desc like '%2022%' or a.event_desc like '%2023%' or a.event_desc like '%2024%')
                    and a.event_type_name != 'Revenue Accrual'
          /*        union
                  select a.* from xxmx_ppm_open_ar_evts_v  a 
                   where a.BILL_TRNS_AMOUNT <> 0
                     --and a.completion_date <= to_date('31-MAR-2024','DD-MON-YYYY')
                     and a.event_type_name != 'Revenue Accrual'                             
                  union
                  select a.* from xxmx_ppm_unbil_evts_v  a 
                   where a.BILL_TRNS_AMOUNT <> 0
                     --and a.completion_date <= to_date('31-MAR-2024','DD-MON-YYYY')
                     and a.event_type_name != 'Revenue Accrual'                                Commenting out of the main cursor and inserting afterwards to prevent duplicate event_id records     */
                  union
                  select distinct          sourcename                 
                                         , sourceref                  
                                         , organization_name          
                                         , contract_type_name         
                                         , contract_number            
                                         , contract_line_number       
                                         , event_type_name            
                                         , event_desc                 
                                         , completion_date            
                                         , bill_trns_currency_code    
                                         , bill_trns_amount           
                                         , project_number             
                                         , task_number                
                                         , bill_hold_flag             
                                         , revenue_hold_flag          
                                         , attribute_category         
                                         , attribute1                 
                                         , attribute2                 
                                         , attribute3                 
                                         , attribute4                 
                                         , attribute5                 
                                         , attribute6                 
                                         , attribute7                 
                                         , attribute8                 
                                         , attribute9                 
                                         , attribute10
                  from xxmx_ppm_revacc_evts_v  a
                  where a.BILL_TRNS_AMOUNT <> 0
                  ) evt  
;
    --
    --**********************
    --** Record Declarations
    --**********************
    --
     TYPE src_pa_billing_events_tbl IS TABLE OF src_pa_billing_events_cur%ROWTYPE INDEX BY BINARY_INTEGER;
     src_pa_billing_events_tb  src_pa_billing_events_tbl;


    --
    --************************
    --** Constant Declarations
    --************************
    --
     cv_ProcOrFuncName                   CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'src_pa_all_events';
     cv_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
     cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PPM_PRJ_BILLEVENT_STG';
     cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'BILLING_EVENTS';


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
    l_error_count                         NUMBER;
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
         gvv_migration_date_from := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'ALL'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'EXTRACT_START_DATE'
        );        
        --gvd_migration_date_from := TO_DATE(gvv_migration_date_from,'DD-MON-RRRR');


        gvv_migration_date_to := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'ALL'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'EXTRACT_END_DATE'
        );        
        --gvd_migration_date_to := TO_DATE(gvv_migration_date_to,'DD-MON-RRRR');

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
                ,pt_i_ModuleMessage       => 'Prameters for extract' || gvv_migration_date_from   || '  '||gvv_migration_date_to
                ,pt_i_OracleError         => gvt_ReturnMessage  );

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
/*        DELETE 
        FROM    xxmx_ppm_prj_billevent_stg ;

        COMMIT; */
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
            xxmx_utilities_pkg.init_migration_details
                 (
                  pt_i_ApplicationSuite => gct_ApplicationSuite
                 ,pt_i_Application      => gct_Application
                 ,pt_i_BusinessEntity   => gv_i_BusinessEntity
                 ,pt_i_SubEntity        => cv_i_BusinessEntityLevel
                 ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                 ,pt_i_StagingTable     => cv_StagingTable
                 ,pt_i_ExtractStartDate => SYSDATE
                 );
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


            OPEN src_pa_billing_events_cur;
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
                   ,pt_i_ModuleMessage       =>'Cursor Open src_pa_billing_events_cur'
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
                   ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                   ,pt_i_Phase               => ct_Phase
                   ,pt_i_Severity            => 'NOTIFICATION'
                   ,pt_i_PackageName         => gcv_PackageName
                   ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage       =>'Inside the Cursor loop'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );

            --
            FETCH src_pa_billing_events_cur  BULK COLLECT INTO src_pa_billing_events_tb LIMIT 1000;
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
                   ,pt_i_ModuleMessage       => 'Cursor src_pa_billing_events_cur Fetch into src_pa_billing_events_tb'
                   ,pt_i_OracleError         => gvt_ReturnMessage  );
            --
            EXIT WHEN src_pa_billing_events_tb.COUNT=0;
            --
            FORALL I IN 1..src_pa_billing_events_tb.COUNT SAVE EXCEPTIONS
            --
                 INSERT INTO xxmx_ppm_prj_billevent_stg (
                                     migration_set_id                 
                                    ,migration_set_name               
                                    ,migration_status                 
                                    ,sourcename                 
                                         , sourceref                  
                                         , organization_name          
                                         , contract_type_name         
                                         , contract_number            
                                         , contract_line_number       
                                         , event_type_name            
                                         , event_desc                 
                                         , completion_date            
                                         , bill_trns_currency_code    
                                         , bill_trns_amount           
                                         , project_number             
                                         , task_number                
                                         , bill_hold_flag             
                                         , revenue_hold_flag          
                                         , attribute_category         
                                         , attribute1                 
                                         , attribute2                 
                                         , attribute3                 
                                         , attribute4                 
                                         , attribute5                 
                                         , attribute6                 
                                         , attribute7                 
                                         , attribute8                 
                                         , attribute9                 
                                         , attribute10	             
                                       --  ,project_currency_code
                                       --  ,project_bill_amount
                                       --  ,projfunc_currency_code
                                       --  ,projfunc_bill_amount
                                    ,batch_name                       
                                    ,batch_id                         
                                    ,last_updated_by                  
                                    ,created_by                       
                                    ,last_update_login                
                                    ,last_update_date                 
                                    ,creation_date                    
                             )
                           VALUES
                           (
                            pt_i_MigrationSetID
                           ,gvt_MigrationSetName
                           ,'EXTRACTED'
                            ,src_pa_billing_events_tb(i).sourcename                 
                            ,src_pa_billing_events_tb(i).sourceref                  
                            ,src_pa_billing_events_tb(i).organization_name          
                            ,src_pa_billing_events_tb(i).contract_type_name         
                            ,src_pa_billing_events_tb(i).contract_number            
                            ,src_pa_billing_events_tb(i).contract_line_number       
                            ,src_pa_billing_events_tb(i).event_type_name            
                            ,src_pa_billing_events_tb(i).event_desc                 
                            ,src_pa_billing_events_tb(i).completion_date            
                            ,src_pa_billing_events_tb(i).bill_trns_currency_code    
                            ,src_pa_billing_events_tb(i).bill_trns_amount           
                            ,src_pa_billing_events_tb(i).project_number             
                            ,src_pa_billing_events_tb(i).task_number                
                            ,NVL(src_pa_billing_events_tb(i).bill_hold_flag,'N')           
                            ,NVL(src_pa_billing_events_tb(i).revenue_hold_flag,'N')          
                            ,src_pa_billing_events_tb(i).attribute_category         
                            ,src_pa_billing_events_tb(i).attribute1                 
                            ,src_pa_billing_events_tb(i).attribute2                 
                            ,src_pa_billing_events_tb(i).attribute3                 
                            ,src_pa_billing_events_tb(i).attribute4                 
                            ,src_pa_billing_events_tb(i).attribute5                 
                            ,src_pa_billing_events_tb(i).attribute6                 
                            ,src_pa_billing_events_tb(i).attribute7                 
                            ,src_pa_billing_events_tb(i).attribute8                 
                            ,src_pa_billing_events_tb(i).attribute9                 
                            ,src_pa_billing_events_tb(i).attribute10	             
                            --,src_pa_billing_events_tb(i).PROJECT_CURRENCY_CODE
                            --,src_pa_billing_events_tb(i).PROJECT_BILL_AMOUNT
                            --,src_pa_billing_events_tb(i).PROJFUNC_CURRENCY_CODE
                            --,src_pa_billing_events_tb(i).PROJFUNC_BILL_AMOUNT                            
                           ,g_batch_name    
                           ,to_char(TO_DATE(SYSDATE, 'DD-MON-RRRR'),'DDMMRRRRHHMISS')   
                           ,xxmx_utilities_pkg.gvv_UserName 
                           ,xxmx_utilities_pkg.gvv_UserName
                           ,xxmx_utilities_pkg.gvv_UserName
                           ,SYSDATE                                                     
                           ,SYSDATE                                                     

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
                              ,pt_i_ModuleMessage       => 'Close the Cursor src_pa_billing_events_cur'
                              ,pt_i_OracleError         => gvt_ReturnMessage       );   
             --


             IF src_pa_billing_events_cur%ISOPEN
             THEN
                  --
                     CLOSE src_pa_billing_events_cur;
                  --
             END IF;

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


--Remove lines that cancel/reverse each other out and very OLD Rev Acc lines as well 
/*
delete from xxmx_ppm_prj_billevent_stg o
where o.attribute7 in ('REVACC')
and o.project_number||o.task_number||o.event_type_name||o.event_desc||o.attribute7||o.attribute10 in 
(
select z.project_number||z.task_number||z.event_type_name||z.event_desc||z.attribute7||z.attribute10
from xxmx_ppm_prj_billevent_stg z
where 1=1 --z.event_type_name = 'Revenue Accrual'
and z.attribute7 in ('REVACC')
group by z.project_number, z.task_number, z.event_type_name, z.event_desc,z.attribute7,z.attribute10
having sum(bill_trns_amount) = 0
);
*/

delete from xxmx_ppm_prj_billevent_stg o
where o.attribute7 in ('REVACC')
and o.project_number||o.task_number||o.event_desc||o.attribute7||o.attribute10 in 
(
select z.project_number||z.task_number||z.event_desc||z.attribute7||z.attribute10
from xxmx_ppm_prj_billevent_stg z
where 1=1 --z.event_type_name = 'Revenue Accrual'
and z.attribute7 in ('REVACC')
group by z.project_number, z.task_number, z.event_desc,z.attribute7,z.attribute10
having sum(bill_trns_amount) = 0
);

delete from xxmx_ppm_prj_billevent_stg o
where o.attribute7 in ('REVACC')
--and o.event_type_name = 'Revenue Accrual'
and to_date(o.completion_date,'DD-MON-RR')  < to_date('01-MAR-2024')
;


--Delete future dated closed AR events. 
    DELETE from xxmx_ppm_prj_billevent_stg s
    where 1=1
    and   s.attribute7 in ( 'CLOSED_AR')
    and   to_date(s.completion_date,'DD-MON-RR')  > to_date('31-MAR-2024');


/* Insert OPEN_AR and unbilled records here and check the STG table does not have that event_id in attribute3 */

                 INSERT INTO xxmx_ppm_prj_billevent_stg (
                                     migration_set_id                 
                                    ,migration_set_name               
                                    ,migration_status                 
                                    --,sourcename                 
                                         , sourceref                  
                                         , organization_name          
                                         --, contract_type_name         
                                         --, contract_number            
                                         --, contract_line_number       
                                         , event_type_name            
                                         , event_desc                 
                                         , completion_date            
                                         , bill_trns_currency_code    
                                         , bill_trns_amount           
                                         , project_number             
                                         , task_number                
                                         --, bill_hold_flag             
                                         --, revenue_hold_flag          
                                         --, attribute_category         
                                         , attribute1                 
                                         , attribute2                 
                                         , attribute3                 
                                         , attribute4                 
                                         , attribute5                 
                                         , attribute6                 
                                         , attribute7                 
                                         , attribute8                 
                                         , attribute9                 
                                         , attribute10	             
                                       --  ,project_currency_code
                                       --  ,project_bill_amount
                                       --  ,projfunc_currency_code
                                       --  ,projfunc_bill_amount
                                    ,batch_name                       
                                    ,batch_id                         
                                    ,last_updated_by                  
                                    ,created_by                       
                                    ,last_update_login                
                                    ,last_update_date                 
                                    ,creation_date                    
                             )
                   select 
                                          pt_i_MigrationSetID
                                         ,gvt_MigrationSetName
                                         ,'EXTRACTED'                 
                                         --,sourcename                 
                                         , sourceref                  
                                         , organization_name          
                                         --, contract_type_name         
                                         --, contract_number            
                                         --, contract_line_number       
                                         , event_type_name            
                                         , event_desc                 
                                         , completion_date            
                                         , bill_trns_currency_code    
                                         , bill_trns_amount           
                                         , project_number             
                                         , task_number                
                                         --, bill_hold_flag             
                                         --, revenue_hold_flag          
                                         --, attribute_category         
                                         , attribute1                 
                                         , attribute2                 
                                         , attribute3                 
                                         , attribute4                 
                                         , attribute5                 
                                         , attribute6                 
                                         , attribute7                 
                                         , attribute8                 
                                         , attribute9                 
                                         , attribute10	             
                                       --  ,project_currency_code
                                       --  ,project_bill_amount
                                       --  ,projfunc_currency_code
                                       --  ,projfunc_bill_amount                   
                                        ,g_batch_name    
                                        ,to_char(TO_DATE(SYSDATE, 'DD-MON-RRRR'),'DDMMRRRRHHMISS')   
                                        ,xxmx_utilities_pkg.gvv_UserName 
                                        ,xxmx_utilities_pkg.gvv_UserName
                                        ,xxmx_utilities_pkg.gvv_UserName
                                        ,SYSDATE                                                     
                                        ,SYSDATE                     
                   from xxmx_ppm_open_ar_evts_mv  a 
                   where a.BILL_TRNS_AMOUNT <> 0
                     --and a.completion_date <= to_date('31-MAR-2024','DD-MON-YYYY')
                     and a.event_type_name != 'Revenue Accrual'
                     and not exists (select null from xxmx_ppm_prj_billevent_stg n
                                     where n.attribute3 = a.attribute3);



    /*  ORACLD-13432: Attribute7 on revenue line updated to be same as billing line matching by the attribute1. The issue is caused by incorrect contract register data*/


               UPDATE xxmx_ppm_prj_billevent_stg x
                  SET (x.ATTRIBUTE7) = (select e.ATTRIBUTE7
                                                                  from xxmx_ppm_prj_billevent_stg e 
                                                                  where e.attribute1 = x.attribute1                                                                       
                                                                    and    e.attribute10 = 'BILLING' 
                                                                    and e.attribute7 = 'OPEN_AR'
                                                                    and    rownum < 2)
               WHERE  x.attribute7  in ('CLOSED_AR')
               and    x.attribute1 is not null
               and    x.attribute3 != 'TAX'
               and    x.attribute10 = 'REVENUE'
               and exists (select e.ATTRIBUTE7
                                                                  from xxmx_ppm_prj_billevent_stg e 
                                                                  where e.attribute1 = x.attribute1                                                                       
                                                                    and    e.attribute10 = 'BILLING' 
                                                                    and e.attribute7 = 'OPEN_AR'
                                                                    and    rownum < 2) ;

            COMMIT;

                delete from xxmx_ppm_prj_billevent_stg a
                where 1=1
                --and attribute1 = '30967415'
                and a.attribute10 = 'REVENUE'
                and a.attribute7 = 'CLOSED_AR'
                and a.attribute1 is not null
                and not exists (select 1 from xxmx_ppm_prj_billevent_stg b 
                                where a.attribute1 = b.attribute1 
                                and a.attribute7 = b.attribute7 
                                and b.attribute10 = 'BILLING')
                ;


            COMMIT;

                 INSERT INTO xxmx_ppm_prj_billevent_stg (
                                     migration_set_id                 
                                    ,migration_set_name               
                                    ,migration_status                 
                                    --,sourcename                 
                                         , sourceref                  
                                         , organization_name          
                                        -- , contract_type_name         
                                        -- , contract_number            
                                        -- , contract_line_number       
                                         , event_type_name            
                                         , event_desc                 
                                         , completion_date            
                                         , bill_trns_currency_code    
                                         , bill_trns_amount           
                                         , project_number             
                                         , task_number                
                                         , bill_hold_flag             
                                         , revenue_hold_flag          
                                         --, attribute_category         
                                         , attribute1                 
                                         , attribute2                 
                                         , attribute3                 
                                         , attribute4                 
                                         --, attribute5                 
                                         --, attribute6                 
                                         , attribute7                 
                                         --, attribute8                 
                                         --, attribute9                 
                                         , attribute10	             
                                       --  ,project_currency_code
                                       --  ,project_bill_amount
                                       --  ,projfunc_currency_code
                                       --  ,projfunc_bill_amount
                                    ,batch_name                       
                                    ,batch_id                         
                                    ,last_updated_by                  
                                    ,created_by                       
                                    ,last_update_login                
                                    ,last_update_date                 
                                    ,creation_date                    
                             )
                   select 
                                          pt_i_MigrationSetID
                                         ,gvt_MigrationSetName
                                         ,'EXTRACTED'                 
                                         --,sourcename                 
                                         , sourceref                  
                                         , organization_name          
                                         --, contract_type_name         
                                        -- , contract_number            
                                        -- , contract_line_number       
                                         , event_type_name            
                                         , event_desc                 
                                         , completion_date            
                                         , bill_trns_currency_code    
                                         , bill_trns_amount           
                                         , project_number             
                                         , task_number                
                                         , bill_hold_flag             
                                         , revenue_hold_flag          
                                         --, attribute_category         
                                         , attribute1                 
                                         , attribute2                 
                                         , attribute3                 
                                         , attribute4                 
                                         --, attribute5                 
                                         --, attribute6                 
                                         , attribute7                 
                                         --, attribute8                 
                                         --, attribute9                 
                                         , attribute10	             
                                       --  ,project_currency_code
                                       --  ,project_bill_amount
                                       --  ,projfunc_currency_code
                                       --  ,projfunc_bill_amount                   
                                        ,g_batch_name    
                                        ,to_char(TO_DATE(SYSDATE, 'DD-MON-RRRR'),'DDMMRRRRHHMISS')   
                                        ,xxmx_utilities_pkg.gvv_UserName 
                                        ,xxmx_utilities_pkg.gvv_UserName
                                        ,xxmx_utilities_pkg.gvv_UserName
                                        ,SYSDATE                                                     
                                        ,SYSDATE                     
                   from xxmx_core.xxmx_ppm_unbil_evts_mv  a 
                   where a.BILL_TRNS_AMOUNT <> 0
                     --and a.completion_date <= to_date('31-MAR-2024','DD-MON-YYYY')
                     and a.event_type_name != 'Revenue Accrual'
                     and not exists (select null from xxmx_ppm_prj_billevent_stg n
                                     where n.attribute3 = a.attribute3);


            COMMIT;

               UPDATE xxmx_ppm_prj_billevent_stg x
                  SET (x.bill_hold_flag,x.revenue_hold_flag) = (select nvl(e.bill_hold_flag,'N') bill_hold_flag, 
                                                                       nvl(e.revenue_hold_flag,'N') revenue_hold_flag
                                                                from xxmx_pa_events e 
                                                                where e.event_id = to_number(x.attribute3) and rownum < 2)
               --WHERE  x.attribute7 in ('CLOSED_AR','OPEN_AR','REVACC')
               WHERE  x.attribute7 in ('OPEN_AR')
               and    x.attribute3 != 'TAX';

/*
               UPDATE xxmx_ppm_prj_billevent_stg x
                  SET (x.ATTRIBUTE6,x.ATTRIBUTE8,x.ATTRIBUTE9) = (select e.ATTRIBUTE6,e.ATTRIBUTE8,e.ATTRIBUTE9 
                                                                  from xxmx_ppm_prj_billevent_stg e 
                                                                  where e.attribute1 = x.attribute1 and 
                                                                        e.attribute7 = x.attribute7 and
                                                                        e.attribute10 = 'BILLING' and 
                                                                        rownum < 2)
               WHERE  x.attribute7  in ('CLOSED_AR','OPEN_AR')
               and    x.attribute1 is not null
               and    x.attribute3 != 'TAX'
               and    x.attribute10 = 'REVENUE';
*/




               UPDATE xxmx_ppm_prj_billevent_stg x
                  SET x.ATTRIBUTE6 = null
                     ,x.ATTRIBUTE8 = null
               WHERE  x.attribute7  in ('CLOSED_AR','OPEN_AR')
               --and    x.attribute1 is not null
               and    x.attribute3 != 'TAX'
               and    x.attribute10 = 'REVENUE';

               UPDATE xxmx_ppm_prj_billevent_stg x
                  SET x.ATTRIBUTE9 = null
               WHERE  1=1;

               UPDATE xxmx_ppm_prj_billevent_stg x
                  SET x.ATTRIBUTE9 = (select decode(x.attribute10,'BILLING',to_char(nvl(e.projfunc_inv_rate_date,e.project_inv_rate_date),'DD-MON-YY')
                                                                 ,'REVENUE',to_char(e.revproc_rate_date,'DD-MON-YY')
                                                                 ,null)
                                      from xxmx_pa_events e 
                                      where e.event_id = to_number(x.attribute3) and rownum < 2)
               WHERE  x.attribute7 in ('CLOSED_AR','OPEN_AR','UNBILLED')
               and    x.attribute3 != 'TAX'
               and    exists (select null from xxmx_ppm_projects_stg r
                              where r.project_number = x.project_number 
                                and x.bill_trns_currency_code <> r.project_currency_code);


            COMMIT;

               UPDATE xxmx_ppm_prj_billevent_stg x
               set    x.revenue_hold_flag = 'N'
               where  x.revenue_hold_flag is null;

               UPDATE xxmx_ppm_prj_billevent_stg x
               set    x.bill_hold_flag = 'N'
               where  x.bill_hold_flag is null or x.attribute10 = 'REVENUE'; --Milind amended on 22-NOV-2023 after discussion with Barry.


                delete from xxmx_ppm_prj_billevent_stg
                where attribute1 in (
                                    select --sum(decode(attribute10,'BILLING',1,'REVENUE',-1) * bill_trns_amount), 
                                          attribute1
                                    from  xxmx_ppm_prj_billevent_stg 
                                    where attribute7 = 'CLOSED_AR'
                                    group by attribute1
                                    having sum(decode(attribute10,'BILLING',1,'REVENUE',-1) * bill_trns_amount) = 0
                                    )
                and attribute7 = 'CLOSED_AR'; 


update xxmx_ppm_prj_billevent_stg v
set v.ATTRIBUTE_DATE10 = 
        case when v.attribute10 = 'REVENUE' THEN (
            select max(pdra.gl_date)
            FROM
                xxmx_pa_events             e
                LEFT JOIN xxmx_pa_cust_event_rdl_all rev ON e.project_id = rev.project_id
                                                          AND e.task_id = rev.task_id
                                                          AND e.event_num = rev.event_num
                LEFT JOIN xxmx_pa_draft_revenues_all pdra ON pdra.project_id = rev.project_id
                                                           AND pdra.draft_revenue_num = rev.draft_revenue_num
            WHERE
                    1 = 1
                AND v.attribute10 = 'REVENUE'
                and v.attribute3 = e.event_id
                AND pdra.transfer_status_code IN ( 'P', 'A', 'T' )
               )
         ELSE (
            select max(pdi.gl_date)
            FROM
                xxmx_pa_events             e
                LEFT JOIN xxmx_pa_draft_invoice_items pdii ON pdii.project_id = e.project_id
                                                            AND pdii.event_num = e.event_num
                                                            AND pdii.event_task_id = e.task_id
                LEFT JOIN xxmx_pa_draft_invoices_all  pdi ON pdii.draft_invoice_num = pdi.draft_invoice_num
                                                          AND pdii.project_id = pdi.project_id
            WHERE
                    1 = 1
                AND v.attribute10 = 'BILLING'
                and v.attribute3 = e.event_id
                and e.billed_flag = 'Y'
                AND     coalesce(pdi.write_off_flag, 'A') <> 'Y'  
                AND pdi.transfer_status_code IN ( 'P', 'A', 'T' )
        ) 
        END 
where attribute3 is not null and attribute3 != 'TAX';

               UPDATE xxmx_ppm_prj_billevent_stg x
                  SET x.ATTRIBUTE_DATE10 = (select e.ATTRIBUTE_DATE10 
                                                                  from xxmx_ppm_prj_billevent_stg e 
                                                                  where e.attribute3 = x.attribute3 and 
                                                                        e.attribute7 = x.attribute7 and
                                                                        e.attribute10 = 'BILLING' and 
                                                                        e.task_number = x.task_number and
                                                                        rownum < 2)
               WHERE  1=1
               and    x.task_number = 'RETAINER'
               and    x.ATTRIBUTE_DATE10 is null
               and    x.attribute3 is not null
               and    x.attribute3 != 'TAX'
               and    x.attribute10 = 'REVENUE';

            COMMIT;

--DELETE all events after cutover period

    DELETE from xxmx_ppm_prj_billevent_stg s
    where s.attribute10 = 'BILLING'
    and   s.attribute7 not in ( 'UNBILLED', 'REVACC')
    and   s.attribute_date10 > to_date('31-MAR-2024');

    DELETE from xxmx_ppm_prj_billevent_stg s
    where s.attribute10 = 'REVENUE'
    and   s.attribute7 not in ( 'UNBILLED', 'REVACC')    
    and   s.attribute_date10 > to_date('31-MAR-2024');   

    DELETE from xxmx_ppm_prj_billevent_stg s
    where 1=1
    and   s.attribute7 in ( 'OPEN_AR')
    and   to_date(s.completion_date,'DD-MON-RR')  > to_date('31-MAR-2024');

--Temp for SIT only.
    DELETE from xxmx_ppm_prj_billevent_stg s
    where 1=1
    and   s.attribute7 in ( 'UNBILLED')
    and   to_date(s.completion_date,'DD-MON-RR')  > to_date('31-MAR-2024');


--Delete TAX lines on its own as the other events have been deleted above if any.
DELETE from xxmx_ppm_prj_billevent_stg
where 1=1
and attribute10='TAX'
and attribute6 in (select o.attribute6 
from xxmx_ppm_prj_billevent_stg o 
where o.attribute7='OPEN_AR' 
group by o.attribute6 
having count(distinct o.attribute10) = 1); 

               UPDATE xxmx_ppm_prj_billevent_stg x
                  SET (x.event_desc) = (select e.description 
                                        from pa_events@xxmx_extract e 
                                        where e.event_id = to_number(x.attribute3) 
                                        and   rownum < 2
                                        --and   e.event_type <> 'Revenue Accrual' 
                                        --and   e.reference2 is not null
                                        )
               WHERE (x.event_desc like '-%' or x.event_desc is null)
                 and x.attribute3 != 'TAX'
                 --and x.attribute7 <> 'REVACC'
                 ; 
               
DELETE from xxmx_ppm_prj_billevent_stg
where rowid in (
select min(rowid) 
from xxmx_ppm_prj_billevent_stg
group by attribute3,attribute6,attribute10
having count(1) > 1
);
               
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
        IF src_pa_billing_events_cur%ISOPEN
        THEN
            --
            CLOSE src_pa_billing_events_cur;
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

         IF src_pa_billing_events_cur%ISOPEN
         THEN
             --
             CLOSE src_pa_billing_events_cur;
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



     END src_pa_all_events;

  PROCEDURE src_pa_lic_ap_inv
  AS
   --
          --**********************
          --** Cursor Declarations
          --**********************
   --

 CURSOR get_unpaid_invoices_cur
 IS
 with 
Invdtl as
(
select distinct invoice_num,aia.invoice_id,invoice_date,invoice_amount,aid.project_id,
aid.task_id, segment1 project_num , aia.vendor_id,aia.vendor_site_id,t.task_number
from ap_invoices_all@xxmx_extract         aia,
     ap_invoice_distributions_all@xxmx_extract aid,
     pa_projects_all@xxmx_Extract p,
     xxpa_proj_statuses_v_stg    ppsv,
     pa_tasks@xxmx_Extract t
where 1=1     
  and aia.invoice_id = aid.invoice_id
  and aid.project_id =  p.project_id
  and aid.task_id = t.task_id
  and ppsv.project_status_code  = p.project_status_code
  and p.closed_date  IS NULL  
  and pay_group_lookup_code like 'LIC%'
  and aia.PAYMENT_STATUS_FLAG <> 'Y'
  and invoice_amount <> 0 
  and ppsv.project_status_name IN ( 'Active', 'Prospect', 'Inactive', 'Outgoing' )                 
),
supdtl as
(select segment1 supplier,vendor_name supplier_name,vendor_site_code,aps.vendor_id, apss.vendor_site_id
from 
  ap_suppliers@xxmx_extract          aps,
    ap_supplier_sites_all@xxmx_extract apss   
WHERE
       1 = 1
    AND apss.vendor_id = aps.vendor_id),
paysch as
(select invoice_id, sum(amount_remaining) amount_remaining
from ap_payment_schedules_all@xxmx_extract 
group by invoice_id)
select invoice_num,i.invoice_id,invoice_date,invoice_amount,
supplier,supplier_name,
vendor_site_code,project_num,task_number , p.amount_remaining
from 
Invdtl i, supdtl s, paysch p
where 1=1
and i.vendor_id = s.vendor_id
and i.vendor_site_id =s.vendor_site_id 
and i.invoice_id = p.invoice_id
--and invoice_num in ('6770/20220322/HDCM003','IKARA ASSOCIATES INC.','4049346BROCAR2019','4050967ROC2020')
;

  TYPE get_unpaid_invoices_tbl IS TABLE OF get_unpaid_invoices_cur%ROWTYPE INDEX BY BINARY_INTEGER;
     get_unpaid_invoices_tb  get_unpaid_invoices_tbl;

  BEGIN
  dbms_output.put_line('inserting');

   FORALL I IN 1..get_unpaid_invoices_tb.COUNT SAVE EXCEPTIONS
            --
                 INSERT INTO xxmx_ppm_licfee_unpaid_inv (
                                        invoice_id
                                        ,invoice_num
                                        ,invoice_amount
                                        ,invoice_date
                                        , supplier
                                        , supplier_name
                                        , vendor_site_code
                                        , project_num            
                                         , task_number                                   
                                    ,amount_remaining                    
                             )
                           VALUES
                           (
                            get_unpaid_invoices_tb(i).invoice_id                 
                            ,get_unpaid_invoices_tb(i).invoice_num                  
                            ,get_unpaid_invoices_tb(i).invoice_amount          
                            ,get_unpaid_invoices_tb(i).invoice_date         
                            ,get_unpaid_invoices_tb(i).supplier            
                            ,get_unpaid_invoices_tb(i).supplier_name       
                            ,get_unpaid_invoices_tb(i).vendor_site_code                          
                            ,get_unpaid_invoices_tb(i).project_num             
                            ,get_unpaid_invoices_tb(i).task_number
                            ,get_unpaid_invoices_tb(i).amount_remaining              

                           );
                --
                dbms_output.put_line('end of inserting');
                commit;
  EXCEPTION
  WHEN others then
    dbms_output.put_line('Error-'||sqlerrm);

  END src_pa_lic_ap_inv;





END XXMX_PPM_TRANSACTIONS_PKG;

/
