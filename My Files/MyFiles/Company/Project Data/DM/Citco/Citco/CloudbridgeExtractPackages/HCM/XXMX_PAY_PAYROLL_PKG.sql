CREATE OR REPLACE PACKAGE xxmx_pay_payroll_pkg  AS
     --//===============================================================================
     --// 
     --// $Id:$
     --//===============================================================================
     --// Object Name        :: xxmx_pay_payroll_pkg
     --// Object Type        :: Package Specification
     --// Object Description :: This package contains procedures for generating payroll 
     --//                            components for HDL fast formula
     --// Version Control
     --//===============================================================================
     --// Version      Author               Date               Description
     --//-------------------------------------------------------------------------------
     --// 1.0          Jay McNeill          09/11/2020          Initial Build from Petrofac
     --//===============================================================================
     --
     --
     --**********************************
     --** Procedure: pay_cus_balances_stg
     --**********************************
     PROCEDURE pay_cus_balances_stg
                    (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);
     --**********************************
     --** Procedure: xxmx_pay_ebs_balance_ext
     --**********************************

      PROCEDURE xxmx_pay_ebs_balance_ext
              (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
              ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);

     --**********************************
     --** FUNCTION: get_assignment_number
     --**********************************
     FUNCTION get_assignment_number
              (pv_i_AsgNumber                    VARCHAR2
              ,pv_i_FusionNumber                 VARCHAR2
              )
     RETURN VARCHAR2;
     --      
     --*********************************
     --** FUNCTION: get_fusion_legal_emp
     --*********************************
     FUNCTION get_fusion_legal_emp
                   (pv_i_FusionAsgNumber            VARCHAR2)
     RETURN VARCHAR2;
     --      
     --*****************************
     --** FUNCTION: get_payroll_name
     --*****************************
     FUNCTION get_payroll_name
                   (pv_i_FusionAsgNumber            VARCHAR2)
     RETURN VARCHAR2;
     --
     --*******************************
     --** FUNCTION: get_fusion_lookup_code
     --*******************************
     FUNCTION get_fusion_lookup_code
                   (pv_i_ElementName                VARCHAR2
                   ,pv_i_InputValueName             VARCHAR2
                   ,pv_i_InputValueValue            VARCHAR2)
     RETURN VARCHAR2;
     --   
     --******************************
     --** FUNCTION: get_effective_date
     --*******************************
     FUNCTION get_effective_date
                   (pv_i_AsgNumber                  VARCHAR2
                   ,pv_i_ElementName                VARCHAR2
                   ,pv_i_EffDateStartOrEnd           VARCHAR2)
     RETURN VARCHAR2;
     --
     --*********************************
     --** FUNCTION: get_ebs_screen_entry_val
     --**********************************
     FUNCTION get_ebs_screen_entry_val 
                         (pv_assignment_number   VARCHAR2
                         ,pv_element_name        VARCHAR2
                         ,pv_input_val_name      VARCHAR2) 
     RETURN VARCHAR2;
     --
     --*********************************
     --** FUNCTION: get_input_value_rank
     --**********************************
     FUNCTION get_input_value_rank
                         (pv_element_name VARCHAR2
                         ,pv_input_value_name VARCHAR2)
     RETURN NUMBER;
     --
     --*********************************
     --** FUNCTION: get_payroll_relno
     --**********************************
     FUNCTION get_payroll_relno
                         (pv_fusion_asg_number VARCHAR2)
     RETURN VARCHAR2;
     --
     --*********************************
     --** FUNCTION: check_rti_sent
     --**********************************
     FUNCTION check_rti_sent
                         (pv_assignment_number VARCHAR2)
     RETURN VARCHAR2;
     --
     --*********************************
     --** FUNCTION: check_ebs_balances
     --*********************************
     FUNCTION check_ebs_balances
                       (pv_assignment_number VARCHAR2)
     RETURN VARCHAR2;
     --
     --*********************************
     --** FUNCTION: get_business_group_id
     --********************************
     FUNCTION get_business_group_id
     RETURN VARCHAR2;
     --
     --********************************
     ----** PROCEDURE: pay_elem_entries_stg
     --********************************
     PROCEDURE pay_elem_entries_stg
                         (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                         ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);
     --
     --*************************************
     ----** PROCEDURE: update_elem_entries_stg
     --*************************************
     PROCEDURE update_elem_entries_stg 
                        (pv_source_element_name          IN      VARCHAR2
                        ,pv_target_element_name          IN      VARCHAR2
                        ,pv_input_value_name             IN      VARCHAR2
                        ,pv_input_value                  IN      VARCHAR2
                        ,pv_exists                       IN      VARCHAR2
                        ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);
     --   
     --********************************
     ----** PROCEDURE: pay_balances_stg
     --********************************
     PROCEDURE pay_balances_stg
                        (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);
     --
     --*********************************
     ----** PROCEDURE: pay_cost_allocs_stg
     --*********************************
     PROCEDURE pay_cost_allocs_stg
                         (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                         ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);
     --
     -- ------------------------------------------------------------------------------
     -- |-------------------------< src_calc_card >-------------------------------------|
     -- CALC_CARDS_SD     pay_calc_cards_sd_stg
     -- CALC_CARDS_PAE     pay_calc_cards_pae_stg
     -- CALC_CARDS_BP     pay_calc_cards_bp_stg
     -- CALC_CARDS_SL     pay_calc_cards_sl_stg
     -- CALC_CARDS_NSD     pay_calc_cards_nsd_stg
     -- ------------------------------------------------------------------------------
     --**********************************
     ----** PROCEDURE:pay_calc_cards_sd_stg
     --**********************************
     PROCEDURE pay_calc_cards_sd_stg
                       (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                       ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);
     --
     --************************************
     ----** PROCEDURE: pay_calc_cards_pae_stg
     --************************************
     PROCEDURE pay_calc_cards_pae_stg
                    (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);
     -- 
     --***********************************
     ----** PROCEDURE: pay_calc_cards_bp_stg
     --***********************************
     PROCEDURE pay_calc_cards_bp_stg
                    (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);
     --
     --***********************************
     ----** PROCEDURE: pay_calc_cards_sl_stg
     --***********************************
     PROCEDURE pay_calc_cards_sl_stg
                    (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);
     --
     --************************************
     ----** PROCEDURE: pay_calc_cards_nsd_stg
     --************************************
     PROCEDURE pay_calc_cards_nsd_stg
                    (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);
     --
     --*************************************
     ----** PROCEDURE: insert_pay_ebs_balances
     --*************************************
     PROCEDURE insert_pay_ebs_balances
                    (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);     
     --
     --**********************
     ----** PROCEDURE: stg_main
     --**********************
     PROCEDURE stg_main
                    (pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE);
     --
     --********************
     ----** PROCEDURE: purge
     --********************
     PROCEDURE purge
                   (pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                   ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE);  

	--*************************************
     ----** PROCEDURE: insert_pay_ebs_balances_addnl
     --*************************************
	PROCEDURE insert_pay_ebs_balances_addnl
					(pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);     
     --
      PROCEDURE SMBC_calc_cards_pae_stg
                    (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);
     --
END xxmx_pay_payroll_pkg;
/


CREATE OR REPLACE PACKAGE BODY xxmx_pay_payroll_pkg
AS
     --//===============================================================================================
     --// 
     --// $Id:$F     
     --//===============================================================================================
     --// Object Name        :: xxmx_pay_payroll_pkg.pkb
     --// Object Type        :: Package Body
     --// Object Description :: This package contains procedures for generating payroll- Maximise
     --//
     --// Version Control
     --//===============================================================================================
     --// Version      Author               Date               Description
     --//--------------------------------------------------------------------------------
     --// 1.0          Dhanu Gundala       09/11/2020         Initial Build
	 --// 2.0 		   Pallavi Kanajar	   19/03/2021		  Changes to incorporate Maximise Structure
    --// 2.1         Pradeep                                Changes in BP for SMBC
    --// 2.2         Pallavi Kanajar      21/07/2021        Incorrect Tax Code and Benefits and Pension Change
    --// 2.3         Pallavi Kanajar      30/07/2021        Custom Balances new procedure.
     --//========b=======================================================================================
     --
     TYPE type_hdl_data IS TABLE OF VARCHAR2(30000) INDEX BY BINARY_INTEGER; 
     g_hdl_data      type_hdl_data;
     --
     gd_migration_date  VARCHAR2(20) := '2021/02/01'; -- parameters
     g_start_of_year   VARCHAR2(20) := '01/04/2020';  -- parameter
     g_cutoff_date     VARCHAR2(20) := '28/02/2021';  -- parameter
     g_monthly_bal_date VARCHAR2(100) := '25/07/2020';  -- parameter
     g_weekly_bal_date VARCHAR2(100) := '31/07/2020';  -- parameter
     g_busines_group_id VARCHAR2(10) := '0'; -- parameter
     --
     --g_pension_scheme_id VARCHAR2(100) := '300000095970570';
     --
     -- Maximise Integration Globals */
     -- Global Constants for use in all xxmx_utilities_pkg Procedure/Function Calls within this package */
     gcv_PackageName                           CONSTANT VARCHAR2(30)                                 := 'xxmx_pay_payroll_pkg';
     gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE  := 'HCM';
     gct_Application                           CONSTANT xxmx_module_messages.application%TYPE        := 'PAY';
     gct_StgSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_stg';
     gct_XfmSchema                             CONSTANT  VARCHAR2(10)                                := 'xxmx_xfm';
     gct_CoreSchema                            CONSTANT  VARCHAR2(10)                                := 'xxmx_core';
     gcv_BusinessEntity                        CONSTANT xxmx_migration_metadata.business_entity%TYPE := 'PAYROLL';
     --
     -- Global Progress Indicator Variable for use in all Procedures/Functions within this package 
     gvv_ProgressIndicator                              VARCHAR2(100);
     --
     -- Global Variables for receiving Status/Messages FROM certain Procedure/Function Calls (e.g. xxmx_utilities_pkg.clear_messages 
     gvv_ReturnStatus                                   VARCHAR2(1);
     gvt_ReturnMessage                                  xxmx_module_messages.module_message%TYPE;
     -- Global Variables for Exception Handlers 
     gvt_Severity                                       xxmx_module_messages.severity%TYPE;
     gvt_ModuleMessage                                  xxmx_module_messages.module_message%TYPE;
     gvt_OracleError                                    xxmx_module_messages.oracle_error%TYPE;
     -- Global Variable for Migration Set Name 
     gvt_MigrationSetName                               xxmx_migration_headers.migration_set_name%TYPE;
     -- Global constants and variables for dynamic SQL usage 
     gcv_SQLSpace                             CONSTANT  VARCHAR2(1) := ' ';
     gvv_SQLAction                                      VARCHAR2(20);
     gvv_SQLTableClause                                 VARCHAR2(100);
     gvv_SQLColumnList                                  VARCHAR2(4000);
     gvv_SQLValuesList                                  VARCHAR2(4000);
     gvv_SQLWhereClause                                 VARCHAR2(4000);
     gvv_SQLStatement                                   VARCHAR2(32000);
     gvv_SQLResult                                      VARCHAR2(4000);
     -- Global variables for holding table row counts 
     gvn_RowCount                                       NUMBER;

  /*****************************************
   SMBC Balances Extract 
   *****************************************/
   PROCEDURE smbc_balances
   AS

         /*********************
         Cursor Declaration
         ***********************/
         Cursor c_pensionable_pay(c_assignment_number VARCHAR2)
         IS 
            SELECT LGPS_PENSIONABLE_PAY,
                   PQP.assignment_id,
                   assignment_type||PAAF.assignment_number,
                   'Y'
            FROM PQP_ASSIGNMENT_ATTRIBUTES_F@mxdm_nvis_extract PQP, 
                 per_all_assignments_f@mxdm_nvis_extract paaf, 
                 pay_payrolls_f@mxdm_nvis_extract ppf
            WHERE PQP.assignment_id = paaf.assignment_id
            and paaf.assignment_number = c_assignment_number
            and trunc(sysdate)between pqp.effective_start_date and pqp.effective_end_date
            and trunc(sysdate)between paaf.effective_start_date and paaf.effective_end_date
            and trunc(sysdate)between ppf.effective_start_date and ppf.effective_end_date
            and paaf.payroll_id = ppf.payroll_id
            and ppf.PAyroll_name IN( Select parameter_value 
                                     From xxmx_migration_parameters
                                     where parameter_code= 'PAYROLL_NAME'
                                     and enabled_flag = 'Y')
               ;

          CURSOR c_ebs_cus_bal_lg
          IS 
             SELECT distinct 'Y'
                     , 'BalanceInitialization'
                     , TO_CHAR(SYSDATE,'RRRR/MM/DD') UPLOADDATE
                     , 'GB Legislative Data Group'  LEGISLATIVEDATAGROUPNAME
                     , 'NI Reporting HMRC Payroll ID' CONTEXTFIVENAME
                     , NI_REPORTING_HMRC_PAYROLL_ID CONTEXTFIVEVALUE
                     , LEGAL_EMPLOYER_NAME  Legalemployername
                     , Payroll_name payrollname
                     , Payrollrelationshipnumber
                     , Termnumber
                     , TAX_REPORTING_UNIT  taxreportingunit
                     , SUBSTR(Assignmentnumber,2,LENGTH(Assignmentnumber)) Assignment_number
               FROM xxmx_pay_balance_contexts
               WHERE assignmentnumber IN( select distinct assignmentnumber from xxmx_pay_calc_cards_bp_stg where dircardcompdefname like 'LG WMPF');


          CURSOR c_ebs_cus_bal_nhs
          IS 
              SELECT distinct 'Y'
                     , 'BalanceInitialization'
                     , TO_CHAR(SYSDATE,'RRRR/MM/DD') UPLOADDATE
                     , 'GB Legislative Data Group'  LEGISLATIVEDATAGROUPNAME
                     , 'NI Reporting HMRC Payroll ID' CONTEXTFIVENAME
                     , NI_REPORTING_HMRC_PAYROLL_ID CONTEXTFIVEVALUE
                     , LEGAL_EMPLOYER_NAME  Legalemployername
                     , Payroll_name payrollname
                     , Payrollrelationshipnumber
                     , Termnumber
                     , TAX_REPORTING_UNIT  taxreportingunit
                     , SUBSTR(Assignmentnumber,2,LENGTH(Assignmentnumber)) Assignment_number
               FROM xxmx_pay_balance_contexts
               WHERE assignmentnumber IN( select distinct assignmentnumber from xxmx_pay_calc_cards_bp_stg where dircardcompdefname like 'NHS Pension Fund');

          Cursor c_asg_bud_values(c_assignment_number VARCHAR2)
            IS 
            SELECT value,
                   awrk.assignment_id
            FROM xxmx_asg_workmsure_stg awrk
            WHERE awrk.assignment_id = c_assignment_number
            AND UNIT = 'FTE'
            ;      


                --************************
                --** Variable Declarations
                --***********************
                 v_assignment_number         VARCHAR2(100);
                 v_assignment_id             NUMBER;
                 v_lgps_pensionable_pay      NUMBER;
                 asg_bal_exist               VARCHAR2(10);
                 v_fte_value                 NUMBER;
                 v_migration_set_id          NUMBER;
                 v_migration_set_name        VARCHAR2(1000);

                --***************************
                --** Record Table Declarations
                --***********************
                --

         BEGIN 

            BEGIN 
               SELECT DISTINCT MIGRATION_SET_ID 
                             , MIGRATION_SET_NAME 
               INTO v_migration_set_id,
                    v_migration_set_name
               FROM xxmx_pay_cus_bal_stg
               WHERE HEADERORLINE = 'Line';
            EXCEPTION 
               WHEN OTHERS THEN 
                  v_migration_set_id := NULL;
                  v_migration_set_name := NULL;
           END ;

            FOR rec_ebs_cus_bal_lg in c_ebs_cus_bal_lg
            LOOP
               asg_bal_exist := 'N';

               OPEN c_pensionable_pay(rec_ebs_cus_bal_lg.assignment_number);
               FETCH c_pensionable_pay INTO v_lgps_pensionable_pay,
                                            v_assignment_id,
                                            v_assignment_number,
                                            asg_bal_exist;
               CLOSE c_pensionable_pay;


               IF(asg_bal_exist = 'Y') THEN                   
                     INSERT INTO xxmx_pay_cus_bal_stg
                     values(
                         v_migration_set_id,
                         v_migration_set_name,
                         'CREATE',
                         'LINE',
                         rec_ebs_cus_bal_lg.legislativedatagroupname,
                         rec_ebs_cus_bal_lg.uploaddate,
                         'EBS',
                         NULL,
                         v_assignment_number,
                         rec_ebs_cus_bal_lg.uploaddate, -- Balance_date
                         'LG WMPF Permanent Pensionable Pay',
                         NULL,--CONTEXTONENAME
                         NULL,--CONTEXTONEVALUE
                         NULL,--CONTEXTTWONAME
                         NULL,--CONTEXTTWOVALUE
                         NULL,--CONTEXTTHREENAME
                         NULL,--CONTEXTTHREEVALUE
                         NULL,--CONTEXTFOURNAME
                         NULL,--CONTEXTFOURVALUE
                         rec_ebs_cus_bal_lg.contextfivename,
                         rec_ebs_cus_bal_lg.Contextfivevalue,
                         'Assignment Last Period',
                         rec_ebs_cus_bal_lg.legalemployername,
                         rec_ebs_cus_bal_lg.payrollname,
                         rec_ebs_cus_bal_lg.payrollrelationshipnumber,
                         rec_ebs_cus_bal_lg.termnumber,
                         v_lgps_pensionable_pay/12,
                         NULL,
                         NULL,
                         NULL,
                         NULL,
                         NULL,
                         UPPER(sys_context('userenv','OS_USER')),--      created_by       
                         TO_CHAR(SYSDATE,'YYYY/MM/DD'),--                creation_date   
                         UPPER(sys_context('userenv','OS_USER')),--      last_updated_by  
                         TO_CHAR(SYSDATE,'YYYY/MM/DD')    --            last_update_date 
                         );
               END IF;



           END LOOP;

           FOR rec_ebs_cus_bal_nhs in c_ebs_cus_bal_nhs
            LOOP
               asg_bal_exist := 'N';

               OPEN c_pensionable_pay(rec_ebs_cus_bal_nhs.assignment_number);
               FETCH c_pensionable_pay INTO v_lgps_pensionable_pay,
                                            v_assignment_id,
                                            v_assignment_number,
                                            asg_bal_exist;
               CLOSE c_pensionable_pay;


               OPEN c_asg_bud_values(rec_ebs_cus_bal_nhs.assignment_number);
               FETCH c_asg_bud_values INTO v_fte_value,
                                           v_assignment_id
                                            ;
               CLOSE c_asg_bud_values;


               IF(asg_bal_exist = 'Y') THEN 

                     INSERT INTO xxmx_pay_cus_bal_stg
                     values(
                          v_migration_set_id,
                          v_migration_set_name,
                         'CREATE',
                         'LINE',
                         rec_ebs_cus_bal_nhs.legislativedatagroupname,
                         rec_ebs_cus_bal_nhs.uploaddate,
                         'EBS',
                         NULL,
                         v_assignment_number,
                         rec_ebs_cus_bal_nhs.uploaddate, -- Balance_date
                         'NHS Pension Fund Permanent Pensionable Pay',
                         NULL,--CONTEXTONENAME
                         NULL,--CONTEXTONEVALUE
                         NULL,--CONTEXTTWONAME
                         NULL,--CONTEXTTWOVALUE
                         NULL,--CONTEXTTHREENAME
                         NULL,--CONTEXTTHREEVALUE
                         NULL,--CONTEXTFOURNAME
                         NULL,--CONTEXTFOURVALUE
                         rec_ebs_cus_bal_nhs.contextfivename,
                         rec_ebs_cus_bal_nhs.Contextfivevalue,
                         'Assignment Last Period',
                         rec_ebs_cus_bal_nhs.legalemployername,
                         rec_ebs_cus_bal_nhs.payrollname,
                         rec_ebs_cus_bal_nhs.payrollrelationshipnumber,
                         rec_ebs_cus_bal_nhs.termnumber,
                         (v_fte_value*v_lgps_pensionable_pay)/12,
                         NULL,
                         NULL,
                         NULL,
                         NULL,
                         NULL,
                         UPPER(sys_context('userenv','OS_USER')),--      created_by       
                         TO_CHAR(SYSDATE,'YYYY/MM/DD'),--                creation_date   
                         UPPER(sys_context('userenv','OS_USER')),--      last_updated_by  
                         TO_CHAR(SYSDATE,'YYYY/MM/DD')    --            last_update_date 
                         );
               END IF;



           END LOOP;
         END;  


	 --
     --**********************************
     --** PROCEDURE: get_assignment_number
     --**********************************
     -- Function Returns either the EBS assignment number or the Fusion assignment number 
     -- depending on which one is desired depending on the pv_i_FusionNumber parameter.
     -- 'Y' = Get the Fusion assignment number 
     FUNCTION get_assignment_number
              (pv_i_AsgNumber                    VARCHAR2
              ,pv_i_FusionNumber                 VARCHAR2
              )
     RETURN VARCHAR2
     AS
          --** Variable Declarations
          vv_ReturnValue                  VARCHAR2(100);
     --
     BEGIN
        -- IF pv_i_FusionNumber is 'Y' Then return the Fusion assignment number
       IF pv_i_FusionNumber = 'Y' THEN

          SELECT DISTINCT fusion_asg_number
          INTO   vv_ReturnValue
          FROM   xxmx_pay_fusion_ebs_asg_map 
          WHERE  ebs_asg_number = pv_i_AsgNumber
            AND  asg_org is not null;

       ELSE -- Get EBS assignment number

          SELECT DISTINCT ebs_asg_number
          INTO   vv_ReturnValue
          FROM   xxmx_pay_fusion_ebs_asg_map
          WHERE  fusion_asg_number = pv_i_AsgNumber
            AND  asg_org is not null;

       END IF;
          --
          RETURN(vv_ReturnValue);
          --
          EXCEPTION
               WHEN OTHERS THEN 
                    --
                    RETURN(vv_ReturnValue);
     END get_assignment_number;

     --*********************************
     --** FUNCTION: get_fusion_legal_emp
     --**********************************
     FUNCTION get_fusion_legal_emp
                   (pv_i_FusionAsgNumber            VARCHAR2)
     RETURN VARCHAR2 
     AS
          --** Variable Declarations
          vv_ReturnValue                  VARCHAR2(100);

     BEGIN
          SELECT distinct legal_employer_name
          INTO   vv_ReturnValue
          FROM   xxmx_xfm.xxmx_per_assignments_m_xfm
          WHERE  1 = 1
          AND    assignment_number = pv_i_FusionAsgNumber;

          --
          RETURN(vv_ReturnValue);
          --
          EXCEPTION
               WHEN OTHERS THEN 
                    RETURN(vv_ReturnValue);
                    --
               --** END OTHERS Exception
          --** END Exception Handler
     END get_fusion_legal_emp;
     --
     --*****************************
     --** FUNCTION: get_payroll_name
     --*****************************
     FUNCTION get_payroll_name
                        (pv_i_FusionAsgNumber            VARCHAR2)
     RETURN VARCHAR2
     AS
          --***********************
          --** Constant Declarations
          --***********************
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'get_payroll_name';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXTRACT';
          --************************
          --** Variable Declarations
          --************************
          vv_ReturnValue                  VARCHAR2(100);
          --** END Declarations
     BEGIN 
          SELECT worker_payroll_name
          INTO   vv_ReturnValue
          FROM   xxmx_fusion_workers
          WHERE  1 = 1
          AND    assignment_number = pv_i_FusionAsgNumber;
          RETURN vv_ReturnValue;
          --
          RETURN(vv_ReturnValue);
          --
          EXCEPTION
               WHEN OTHERS THEN 
                    RETURN(vv_ReturnValue);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END get_payroll_name;
     --
     --***********************************
     --** FUNCTION: get_fusion_lookup_code
     --***********************************
     FUNCTION get_fusion_lookup_code
                   (pv_i_ElementName                VARCHAR2
                   ,pv_i_InputValueName             VARCHAR2
                   ,pv_i_InputValueValue            VARCHAR2)
     RETURN VARCHAR2 
     AS
          --***********************
          --** Constant Declarations
          --***********************
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'get_fusion_lookup_code';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXTRACT';
          --************************
          --** Variable Declarations
          --***********************
          vv_ReturnValue                  VARCHAR2(100);
          --** END Declarations
     BEGIN
          SELECT fusion_lookup_code
          INTO   vv_ReturnValue 
          FROM   xxmx_pay_lookup_map
          WHERE  1 = 1
          AND    element_name = pv_i_ElementName
          AND    input_value  = pv_i_InputValueName
          AND    ebs_value    = pv_i_InputValueValue;
          --
          RETURN NVL(vv_ReturnValue, pv_i_InputValueValue);
          --
          EXCEPTION
               WHEN OTHERS THEN 
                    --
                    vv_ReturnValue := pv_i_InputValueValue;
                    --
                    RETURN(vv_ReturnValue);
                    --
               --** END OTHERS Exception
          --** END Exception Handler
     END get_fusion_lookup_code;
     --
     --****************************
     --** FUNCTION: get_effective_date
     --** Former Name: fnc_get_eff_date
     --****************************
     FUNCTION get_effective_date
                   (pv_i_AsgNumber                  VARCHAR2
                   ,pv_i_ElementName                VARCHAR2
                   ,pv_i_EffDateStartOrEnd           VARCHAR2)
     RETURN VARCHAR2
     AS
          --***********************
          --** Constant Declarations
          --***********************
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'get_effective_date';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXTRACT';
          --************************
          --** Variable Declarations
          --***********************
          vv_ReturnValue                  VARCHAR2(100);
          --
          --** END Declarations
     BEGIN
          SELECT DECODE(pv_i_EffDateStartOrEnd
                       ,'START',TO_CHAR(effective_start_date,'RRRR/MM/DD')
                       ,'END'  ,TO_CHAR(effective_end_date,'RRRR/MM/DD')  
                       )
          INTO   vv_ReturnValue
          FROM   xxmx_pay_ebs_elem_entry_vals_v
          WHERE  1 = 1
          AND    assignment_number = pv_i_AsgNumber
          AND    element_name      = pv_i_ElementName
          AND    ROWNUM            = 1;
          --
          RETURN(vv_ReturnValue);
          --
          EXCEPTION
               WHEN OTHERS THEN 
                    --
                    vv_ReturnValue := NULL;
                    --
                    RETURN(vv_ReturnValue);
                    --
               --** END OTHERS Exception
          --** END Exception Handler
     END get_effective_date;
     --
     --*********************************
     --** FUNCTION: get_ebs_screen_entry_val
     --********************************
     FUNCTION get_ebs_screen_entry_val 
               (pv_assignment_number   VARCHAR2,
                pv_element_name        VARCHAR2,
                pv_input_val_name      VARCHAR2) 
     RETURN VARCHAR2
     AS
         --***********************
          --** Constant Declarations
          --***********************
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'get_ebs_screen_entry_val';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXTRACT';
          --************************
          --** Variable Declarations
          --***********************
          vv_ReturnValue                  VARCHAR2(100);
         --** END Declarations
     BEGIN
          SELECT screen_entry_value
            INTO vv_ReturnValue
            FROM xxmx_pay_ebs_elem_entry_vals_v
           WHERE assignment_number   = pv_assignment_number        
             AND element_name        = pv_element_name
             AND input_value_name    = pv_input_val_name;

          IF   ( pv_element_name = 'PFCUK Hours Related Allowance' 
                       AND  vv_ReturnValue IS NOT NULL)
          THEN
          --
                 vv_ReturnValue :=  vv_ReturnValue * 100;
          --
          --    If Employee Option is NULL default to Company Option
          --
          ELSIF    (pv_element_name = 'SMBCUK Healthcare' 
               AND  pv_input_val_name = 'Employee Option'
               AND  vv_ReturnValue IS NULL) 
          THEN
          --
               SELECT screen_entry_value
                 INTO vv_ReturnValue
                 FROM xxmx_pay_ebs_elem_entry_vals_v
                WHERE assignment_number = pv_assignment_number        
                  AND element_name      = pv_element_name
                  AND input_value_name  = 'Company Option';
          --
          END IF;    
          --
          vv_ReturnValue := get_fusion_lookup_code
                              (pv_element_name
                              ,pv_input_val_name
                              ,vv_ReturnValue);
     --     
     RETURN vv_ReturnValue;

     EXCEPTION
     WHEN OTHERS THEN
          --   vv_ReturnValue := 'NO_DATA';
          RETURN vv_ReturnValue;

     END get_ebs_screen_entry_val;    
     --
     --*********************************
     --** FUNCTION: get_input_value_rank
     --********************************
     FUNCTION get_input_value_rank( pv_element_name VARCHAR2
                                   ,pv_input_value_name VARCHAR2)
     RETURN NUMBER
     AS
          --************************
          --** Variable Declarations
          --***********************
          vn_ReturnValue NUMBER := 999;
          --** END Declarations   
          --default input value rank.
     BEGIN
          SELECT input_value_rank
            INTO vn_ReturnValue
            FROM xxmx_pay_fusion_elem_inp_vals
           WHERE fusion_element_name = pv_element_name
             AND fusion_input_value_name = pv_input_value_name;
     --
     RETURN vn_ReturnValue;
     --
     EXCEPTION
     WHEN OTHERS THEN 
      RETURN vn_ReturnValue;
     END get_input_value_rank;
     --
     --*********************************
     --** FUNCTION: get_payroll_relno
     --********************************
     FUNCTION get_payroll_relno(pv_fusion_asg_number VARCHAR2)
     RETURN VARCHAR2
     AS
          --************************
          --** Variable Declarations
          --***********************
           vv_ReturnValue                  VARCHAR2(100);
              --** END Declarations
     BEGIN 
          SELECT payroll_rel_no
            INTO vv_ReturnValue
            FROM xxmx_fusion_workers
           WHERE assignment_number = pv_fusion_asg_number;
          RETURN vv_ReturnValue;
     --
     EXCEPTION
         WHEN OTHERS THEN
             RETURN vv_ReturnValue;     
     END get_payroll_relno;
     --
     --*********************************
     --** FUNCTION: check_rti_sent
     --********************************
     FUNCTION check_rti_sent(pv_assignment_number VARCHAR2)
     RETURN VARCHAR2
     IS
          --************************
          --** Variable Declarations
          --***********************
           vv_rti_sent CHAR := 'N';
          --** END Declarations
     BEGIN
          SELECT DISTINCT NVL(rti_ns_rti_sent,'N') 
            INTO  vv_rti_sent
            FROM apps.pay_gb_rti_asg_info_v@mxdm_nvis_extract rti,
                 apps.per_all_assignments_f@mxdm_nvis_extract asg
           WHERE TO_DATE(gd_migration_date,'RRRR/MM/DD') 
                 BETWEEN asg.effective_start_date AND asg.effective_end_date
             AND asg.assignment_id     = rti.assignment_id
             AND asg.assignment_number = pv_assignment_number;
          --
          RETURN vv_rti_sent;
          --
          EXCEPTION
          WHEN OTHERS THEN

            RETURN vv_rti_sent;

          END check_rti_sent;
     --
     --*********************************
     --** FUNCTION: check_ebs_balances
     --********************************
     FUNCTION check_ebs_balances(pv_assignment_number VARCHAR2)
     RETURN VARCHAR2
     IS
          --************************
          --** Variable Declarations
          --***********************
            vv_ebs_balances CHAR := 'N';
           --** END Declarations
     BEGIN
          SELECT 'Y'
            INTO vv_ebs_balances
            FROM apps.per_all_assignments_f@mxdm_nvis_extract asg
           WHERE assignment_number = pv_assignment_number
             AND EXISTS (SELECT 1 
                           FROM xxmx_pay_ebs_balances
                          WHERE ebs_assignment_number = asg.assignment_number);

          RETURN vv_ebs_balances;

     EXCEPTION
     WHEN OTHERS THEN

      RETURN vv_ebs_balances;

     END check_ebs_balances;
  --
  --*********************************
  --** FUNCTION: get_business_group_id
  --********************************
     FUNCTION get_business_group_id
     RETURN VARCHAR2
     IS
          --************************
          --** Variable Declarations
          --***********************
            vv_business_group_id     VARCHAR2(4);

           --** END Declarations
     BEGIN
               SELECT  DISTINCT
                   haou.organization_id          business_group_id
                INTO vv_business_group_id   
           FROM    apps.hr_all_organization_units@MXDM_NVIS_EXTRACT    haou
                  ,apps.hr_organization_information@MXDM_NVIS_EXTRACT  hoi
           WHERE   hoi.organization_id   = haou.organization_id
           AND     hoi.org_information1  = 'HR_BG'
           AND     haou.name IN (SELECT xmp.parameter_value
                                 FROM   xxmx_migration_parameters  xmp
                                 WHERE  xmp.application_suite      = 'HCM'            
                                 AND    xmp.application            = 'HR'
                                 AND    xmp.business_entity        = 'ALL'
                                 AND    xmp.sub_entity             = 'ALL'
                                 AND    xmp.parameter_code         = 'BUSINESS_GROUP_NAME'
                                 AND    NVL(xmp.enabled_flag, 'N') = 'Y'
                                 AND    NOT EXISTS 
                                            (SELECT 'X'
                                             FROM   xxmx_core.xxmx_migration_parameters  xmp2
                                             WHERE  xmp2.application_suite      = 'HCM'
                                               AND    xmp2.application            = 'PAY'
                                               AND    xmp2.business_entity        = 'PAYROLL'
                                               AND    xmp2.sub_entity             = 'ALL'
                                               AND    xmp2.parameter_code         = 'BUSINESS_GROUP_NAME'
                                               AND    NVL(xmp2.enabled_flag, 'N') = 'Y')
                                 UNION
                                 SELECT xmp3.parameter_value
                                 FROM   xxmx_core.xxmx_migration_parameters  xmp3
                                 WHERE  xmp3.application_suite      = 'HCM'
                                 AND    xmp3.application            = 'PAY'
                                 AND    xmp3.business_entity        = 'PAYROLL'
                                 AND    xmp3.sub_entity             = 'ALL'
                                 AND    xmp3.parameter_code         = 'BUSINESS_GROUP_NAME'
                                 AND    NVL(xmp3.enabled_flag, 'N') = 'Y'
                                ) ;

          RETURN vv_business_group_id;

     EXCEPTION
     WHEN OTHERS THEN

      RETURN vv_business_group_id;

     END get_business_group_id;                               



     --
     --********************************
     --** End of FUNCTIONS 
     --********************************
     --
     --********************************
     ----** PROCEDURE: pay_elem_entries_stg
     --********************************
     PROCEDURE pay_elem_entries_stg
                    (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
     IS
          --**********************
          ----** CURSOR Declarations
          --**********************
          -- Cursor to get the Assignments
            Cursor FusionAssignments_cur IS 
            /*SELECT DISTINCT 
                      paaf.assignment_number assignment_number
                     ,petf.element_name
                     ,pivf.name iv_name
                     ,pivf.display_sequence
                     ,peef.effective_start_date
                     ,peef.effective_end_date
                     ,peevf.screen_entry_value
                     ,xxmx_pay_payroll_pkg.get_assignment_number(paaf.assignment_number,'Y') FusionAsgNumber 
                    FROM
                        apps.pay_element_entry_values_f@MXDM_NVIS_EXTRACT   peevf,
                        apps.pay_element_entries_f@MXDM_NVIS_EXTRACT        peef,
                        apps.pay_input_values_f@MXDM_NVIS_EXTRACT           pivf,
                        apps.pay_element_types_f@MXDM_NVIS_EXTRACT          petf,
                        apps.per_all_assignments_f@MXDM_NVIS_EXTRACT		  paaf
                    WHERE   peevf.input_value_id = pivf.input_value_id
                      AND peef.element_type_id = pivf.element_type_id
                      AND peef.element_type_id = petf.element_type_id
                      AND paaf.assignment_id =  peef.assignment_id
                      AND peevf.element_entry_id =  peef.element_entry_id
                      AND TO_DATE('01-APR-2019','DD-MON-RRRR') BETWEEN peef.effective_start_date AND peef.effective_end_date
                      AND TO_DATE('01-APR-2019','DD-MON-RRRR')  BETWEEN peevf.effective_start_date AND peevf.effective_end_date
                      AND sysdate BETWEEN pivf.effective_start_date AND pivf.effective_end_date
                      AND sysdate BETWEEN petf.effective_start_date AND petf.effective_end_date
                      AND TO_DATE('01-APR-2019','DD-MON-RRRR') BETWEEN paaf.effective_start_date AND paaf.effective_end_date
                      AND (petf.business_group_id = 0
                                OR pivf.legislation_code = 'GB')
                      AND( pivf.business_group_id = 0
                                OR pivf.legislation_code = 'GB')
                      AND paaf.business_group_id = 0
                      AND paaf.assignment_number IN ('30406','25258','45545','13444','15655','44777')
                      AND (EXISTS (SELECT 1 
							  FROM xxmx_fusion_ebs_ele_map mapping
							 WHERE mapping.ebs_element_name = petf.element_name
							)
                       OR petf.element_name IN ('Student Loan','NI','PAYE Details')
                          )
            order by assignment_number, display_sequence;*/

             SELECT DISTINCT 
                    paaf.assignment_number FusionAsgNumber
                   ,SUBSTR(paaf.assignment_number, 2,length (paaf.assignment_number)) EBS_ASG_NUMBER
                    FROM  XXMX_PER_ASSIGNMENTS_M_STG paaf
            ;

            Cursor c_ebs_element
            IS 
             SELECT      pt_i_MigrationSetID             migration_set_id  -- migration_set_id   e.g. 24 
                                ,gvt_MigrationSetName         migration_set_name     -- migration_set_name 'Test Migration'
                                ,'CREATE'                          -- migration_action  
                                ,element_entry                     -- element_entry
                                ,create_element_entry              -- create_element_entry
                                ,element_name                      -- element_name
                                ,effective_start_date              -- effective_start_date
                                ,effective_end_date                -- effective_end_date
                                ,person_number                     -- person_number
                                ,assignment_number                 -- assignment_number
                                ,terms_number                      -- terms_number
                                ,relationship_number               -- relationship_number
                                ,payroll                           -- payroll
                                ,reason                            -- reason
                                ,subpriority                       -- subpriority
                                ,entry_value_1                     -- val1
                                ,entry_value_2                     -- val2
                                ,entry_value_3                     -- val3
                                ,entry_value_4                     -- val4
                                ,entry_value_5                     -- val5
                                ,entry_value_6                     -- val6
                                ,entry_value_7                     -- val7
                                ,entry_value_8                     -- val8
                                ,entry_value_9                     -- val9
                                ,entry_value_10                    -- val10
                                ,entry_value_11                    -- val11
                                ,entry_value_12                    -- val12
                                ,entry_value_13                    -- val13
                                ,entry_value_14                    -- val14
                                ,entry_value_15                    -- val15
                                ,entry_value_16                    -- val16
                                ,entry_value_17                    -- val17
                                ,entry_value_18                    -- val18
                                ,entry_value_19                    -- val19
                                ,entry_value_20                    -- val20
                                ,xxmx_utilities_pkg.gvv_UserName  created_by  -- constant
                                ,TO_CHAR(SYSDATE,'RRRR/MM/DD')    creation_date -- constant
                                ,xxmx_utilities_pkg.gvv_UserName   last_updated_by -- constant
                                ,TO_CHAR(SYSDATE,'RRRR/MM/DD')    last_update_date -- constant
                                ,ebs_asg_number
                    FROM (SELECT *
                          FROM   (SELECT  DISTINCT element_entry
                                         ,create_element_entry
                                         ,element_name
                                       --  ,fusion_input_value_name
--                                         ,ebs_input_value_name
                                         ,person_number
                                         ,assignment_number
                                         ,terms_number
                                         ,relationship_number
                                         ,payroll
                                         ,reason
                                         ,subpriority
                                         ,value
                                         ,effective_start_date
                                         ,effective_end_date
                                         ,input_value_rank
                                         ,ebs_asg_number
                                  FROM  (                   
                                        SELECT  'Element Entry'                           element_entry
                                                ,'Create Element Entry'                    create_element_entry
                                                ,element_mapping.fusion_element_name       element_name
                                                ,element_mapping.fusion_input_value_name   fusion_input_value_name
                                                ,element_mapping.ebs_input_value_name      ebs_input_value_name
                                                ,xpeeevv.person_number                                      person_number
                                               ,xpeeevv.Fusion_asg_number                  assignment_number
                                               ,NULL                                      terms_number
                                               ,NULL                                      relationship_number
                                              ,(select payroll_name
                                               from xxmx_asg_payroll_stg
                                               where assignment_number =xpeeevv.FUSION_ASG_NUMBER )  payroll
                                               ,'Data Migration'                          reason
                                               ,NULL                                      subpriority
                                               ,xpeeevv.assignment_number   ebs_asg_number
                                                ,xpeeevv.screen_entry_value ebs_Input_value
                                              /* ,NVL(
                                                    NVL(fusion.default_value,xpeeevv.screen_entry_value)
                                                   ,element_mapping.default_value
                                                   )  
                                                value
                                                ,fusion.default_value*/
                                                ,NVL( NVL((select FUSION_LOOKUP_CODE
                                                   FROM xxmx_pay_lookup_map
                                                   WHERE element_name = xpeeevv.ELEMENT_NAME
                                                   AND INPUT_VALUE = xpeeevv.INPUT_VALUE_NAME
                                                   AND EBS_VALUE = xpeeevv.screen_entry_value),xpeeevv.screen_entry_value) ,fusion.default_value) value
                                              -- ,gd_migration_date                         effective_start_date
                                              , to_CHAR(xpeeevv.effective_start_date,'RRRR/MM/DD')  effective_start_date
                                               ,to_CHAR(xpeeevv.effective_end_date,'RRRR/MM/DD')                          effective_end_date
                                               ,fusion.input_value_rank                   input_value_rank
                                         FROM   xxmx_fusion_ebs_ele_map        element_mapping -- ISV: Is this the correct new name.
                                               ,xxmx_pay_fusion_elem_inp_vals  fusion          -- ISV: Is this the correct new name, I havent seen this table.
                                               ,XXMX_PAY_EBS_ELEM_ENTRY_VALS_V1 xpeeevv --      If it exists it should be called xxmx_pay_fusion_elem_inp_vals
                                         WHERE  fusion.fusion_element_name     = element_mapping.fusion_element_name
                                           AND  fusion.fusion_input_value_name = element_mapping.fusion_input_value_name
                                           AND   xpeeevv.ELEMENT_NAME = element_mapping.ebs_element_name
                                           AND xpeeevv.INPUT_VALUE_NAME=  element_mapping.ebs_input_value_name
                                           and xpeeevv.screen_entry_value is not null
										   AND UPPER(xpeeevv.ELEMENT_NAME) NOT IN( 'PAYE DETAILS','NI','STUDENT LOAN')
										   and TO_DATE(gd_migration_date,'RRRR/MM/DD') between xpeeevv.effective_Start_Date and xpeeevv.effective_end_Date 
																		  /*= (Select MAX(effective_Start_Date)
                                                                                FROM  XXMX_PAY_EBS_ELEM_ENTRY_VALS_V1 xpeeevv1 --      If it exists it should be called xxmx_pay_fusion_elem_inp_vals
                                                                                WHERE xpeeevv1.INPUT_VALUE_NAME = xpeeevv.INPUT_VALUE_NAME
                                                                                AND  xpeeevv1.ELEMENT_NAME = xpeeevv.element_name
                                                                                and  xpeeevv1.FUSION_ASG_NUMBER = xpeeevv.FUSION_ASG_NUMBER)*/
                                            AND EXISTS  (Select 1
                                                            from per_all_assignments_f@mxdm_nvis_extract paaf
                                                                ,pay_payrolls_f@mxdm_nvis_extract ppf
                                                            where TO_DATE(gd_migration_date,'RRRR/MM/DD') between paaf.effective_Start_Date and paaf.effective_end_date                                                        
                                                            and trunc(sysdate) between ppf.effective_Start_Date and ppf.effective_end_date
                                                            AND paaf.assignment_number= xpeeevv.assignment_number
                                                            and ppf.payroll_id = paaf.payroll_id
                                                            and PAyroll_name IN( Select parameter_value 
                                                                                From xxmx_migration_parameters
                                                                                where parameter_code= 'PAYROLL_NAME'
                                                                                and enabled_flag = 'Y'))
                                           )
                                        )
                                                   PIVOT (
                                                          MAX(value)
                                                          FOR input_value_rank
                                                          IN  (
                                                               1  AS  entry_value_1
                                                              ,2  AS  entry_value_2
                                                              ,3  AS  entry_value_3
                                                              ,4  AS  entry_value_4
                                                              ,5  AS  entry_value_5
                                                              ,6  AS  entry_value_6
                                                              ,7  AS  entry_value_7
                                                              ,8  AS  entry_value_8
                                                              ,9  AS  entry_value_9
                                                              ,10 AS  entry_value_10
                                                              ,11 AS  entry_value_11
                                                              ,12 AS  entry_value_12
                                                              ,13 AS  entry_value_13
                                                              ,14 AS  entry_value_14
                                                              ,15 AS  entry_value_15
                                                              ,16 AS  entry_value_16
                                                              ,17 AS  entry_value_17
                                                              ,18 AS  entry_value_18
                                                              ,19 AS  entry_value_19
                                                              ,20 AS  entry_value_20 
                                                              )
                                                         )
                                                   WHERE effective_start_date IS NOT NULL
                              );                                                      

          --          
          --***********************
          --** Constant Declarations
          --***********************
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'pay_elem_entries_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXTRACT';
          ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE := 'xxmx_pay_elem_entries_stg';
          --************************
          --** Variable Declarations
          --***********************
          vv_FusionAsgNumber             VARCHAR2(100);
          vd_BeginDate                   DATE;
          --*************************
          ----** Exception Declarations
          --***********************
          e_ModuleError                   EXCEPTION;

          TYPE t_elements_tab IS TABLE OF c_ebs_element%ROWTYPE INDEX BY BINARY_INTEGER;
          --p_elements_tab c_ebs_element%ROWTYPE;
          p_elements_tab t_elements_tab;

          --
     BEGIN
          --
          gvv_ProgressIndicator := '0010';
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'MODULE'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F'  THEN
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               RAISE e_ModuleError;
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          gvv_ReturnStatus  := '';
          --
          -- Delete any DATA messages FROM previous executions
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'DATA'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F' THEN
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
          END IF;
          --
          gvv_ProgressIndicator := '0030';
          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          gvv_ProgressIndicator := '0040';
          --
          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
          --
          IF   gvt_MigrationSetName IS NOT NULL  THEN
               --
               gvv_ProgressIndicator := '0050';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Extracting "'||pt_i_SubEntity||'":'
                    ,pt_i_OracleError       => NULL
                    );
               --
               xxmx_utilities_pkg.init_migration_details
                    (pt_i_ApplicationSuite => gct_ApplicationSuite
                    ,pt_i_Application      => gct_Application
                    ,pt_i_BusinessEntity   => gcv_BusinessEntity
                    ,pt_i_SubEntity        => pt_i_SubEntity
                    ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                    ,pt_i_StagingTable     => ct_StgTable
                    ,pt_i_ExtractStartDate => SYSDATE
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Staging Table "'||ct_StgTable||'" reporting details initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
                    gvv_ProgressIndicator := '0060';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extracting Header Record into "'||ct_StgTable||'".'
                    ,pt_i_OracleError       => NULL
                    );
               DELETE FROM xxmx_pay_elem_entries_stg;
               --
               INSERT INTO   xxmx_pay_elem_entries_stg
                         (migration_set_id
                         ,migration_set_name
                         ,migration_action
                         ,element_entry
                         ,create_element_entry
                         ,element_name
                         ,effective_start_date
                         ,effective_end_date
                         ,person_number
                         ,assignment_number
                         ,terms_number
                         ,relationship_number
                         ,payroll
                         ,reason
                         ,subpriority
                         ,val1
                         ,val2
                         ,val3
                         ,val4
                         ,val5
                         ,val6
                         ,val7
                         ,val8
                         ,val9
                         ,val10
                         ,val11
                         ,val12
                         ,val13
                         ,val14
                         ,val15
                         ,val16
                         ,val17
                         ,val18
                         ,val19
                         ,val20
                         ,val21
                         ,val22
                         ,val23
                         ,val24
                         ,val25
                         ,val26
                         ,val27
                         ,val28
                         ,val29
                         ,val30
                         ,val31
                         ,val32
                         ,val33
                         ,val34
                         ,val35
                         ,val36
                         ,val37
                         ,val38
                         ,val39
                         ,val40
                         ,val41
                         ,val42
                         ,val43
                         ,val44
                         ,val45
                         ,val46
                         ,val47
                         ,val48
                         ,val49
                         ,val50
                         ,segment1
                         ,segment2
                         ,segment3
                         ,segment4
                         ,segment5
                         ,segment6
                         ,segment7
                         ,segment8
                         ,segment9
                         ,segment10
                         ,segment11
                         ,segment12
                         ,segment13
                         ,segment14
                         ,segment15
                         ,segment16
                         ,segment17
                         ,segment18
                         ,segment19
                         ,segment20
                         ,segment21
                         ,segment22
                         ,segment23
                         ,segment24
                         ,segment25
                         ,segment26
                         ,segment27
                         ,segment28
                         ,segment29
                         ,segment30
                         ,override_entry
                         ,created_by       
                         ,creation_date    
                         ,last_updated_by  
                         ,last_update_date       
                         ,ebs_asg_number  
                         )
               SELECT     pt_i_MigrationSetID                      -- migration_set_id  
                         ,'Migration Set Name'                     -- migration_set_name 
                         ,'Migration Action'                       -- migration_action  
                         ,'Element Entry'                          -- element_entry
                         ,'Create Element Entry'                   -- create_element_entry
                         ,'<Element Name>'                         -- element_name
                         ,'Effective Start Date'                   -- effective_start_date
                         ,'Effective End Date'                     -- effective_end_date
                         ,'Person Number'                          -- person_number
                         ,'Assignment Number'                      -- assignment_number
                         ,'Terms Number'                           -- terms_number
                         ,'Relationship Number'                    -- relationship_number
                         ,'Payroll'                                -- payroll
                         ,'Reason'                                 -- reason
                         ,'Subpriority'                            -- subpriority
                         ,'ENTRY VALUE1'                           -- val1
                         ,'ENTRY VALUE2'                           -- val2
                         ,'ENTRY VALUE3'                           -- val3
                         ,'ENTRY VALUE4'                           -- val4
                         ,'ENTRY VALUE5'                           -- val5
                         ,'ENTRY VALUE6'                           -- val6
                         ,'ENTRY VALUE7'                           -- val7
                         ,'ENTRY VALUE8'                           -- val8
                         ,'ENTRY VALUE9'                           -- val9
                         ,'ENTRY VALUE10'                          -- val10
                         ,'ENTRY VALUE11'                          -- val11
                         ,'ENTRY VALUE12'                          -- val12
                         ,'ENTRY VALUE13'                          -- val13
                         ,'ENTRY VALUE14'                          -- val14
                         ,'ENTRY VALUE15'                          -- val15
                         ,'ENTRY VALUE16'                          -- val16
                         ,'ENTRY VALUE17'                          -- val17
                         ,'ENTRY VALUE18'                          -- val18
                         ,'ENTRY VALUE19'                          -- val19
                         ,'ENTRY VALUE20'                          -- val20
                         ,'ENTRY VALUE21'                          -- val21
                         ,'ENTRY VALUE22'                          -- val22
                         ,'ENTRY VALUE23'                          -- val23
                         ,'ENTRY VALUE24'                          -- val24
                         ,'ENTRY VALUE25'                          -- val25
                         ,'ENTRY VALUE26'                          -- val26
                         ,'ENTRY VALUE27'                          -- val27
                         ,'ENTRY VALUE28'                          -- val28
                         ,'ENTRY VALUE29'                          -- val29
                         ,'ENTRY VALUE30'                          -- val30
                         ,'ENTRY VALUE31'                          -- val31
                         ,'ENTRY VALUE32'                          -- val32
                         ,'ENTRY VALUE33'                          -- val33
                         ,'ENTRY VALUE34'                          -- val34
                         ,'ENTRY VALUE35'                          -- val35
                         ,'ENTRY VALUE36'                          -- val36
                         ,'ENTRY VALUE37'                          -- val37
                         ,'ENTRY VALUE38'                          -- val38
                         ,'ENTRY VALUE39'                          -- val39
                         ,'ENTRY VALUE40'                          -- val40
                         ,'ENTRY VALUE41'                          -- val41
                         ,'ENTRY VALUE42'                          -- val42
                         ,'ENTRY VALUE43'                          -- val43
                         ,'ENTRY VALUE44'                          -- val44
                         ,'ENTRY VALUE45'                          -- val45
                         ,'ENTRY VALUE46'                          -- val46
                         ,'ENTRY VALUE47'                          -- val47
                         ,'ENTRY VALUE48'                          -- val48
                         ,'ENTRY VALUE49'                          -- val49
                         ,'ENTRY VALUE50'                          -- val50
                         ,'Segment 1'                              -- segment1
                         ,'Segment 2'                              -- segment2
                         ,'Segment 3'                              -- segment3
                         ,'Segment 4'                              -- segment4
                         ,'Segment 5'                              -- segment5
                         ,'Segment 6'                              -- segment6
                         ,'Segment 7'                              -- segment7
                         ,'Segment 8'                              -- segment8
                         ,'Segment 9'                              -- segment9
                         ,'Segment 10'                             -- segment10
                         ,'Segment 11'                             -- segment11
                         ,'Segment 12'                             -- segment12
                         ,'Segment 13'                             -- segment13
                         ,'Segment 14'                             -- segment14
                         ,'Segment 15'                             -- segment15
                         ,'Segment 16'                             -- segment16
                         ,'Segment 17'                             -- segment17
                         ,'Segment 18'                             -- segment18
                         ,'Segment 19'                             -- segment19
                         ,'Segment 20'                             -- segment20
                         ,'Segment 21'                             -- segment21
                         ,'Segment 22'                             -- segment22
                         ,'Segment 23'                             -- segment23
                         ,'Segment 24'                             -- segment24
                         ,'Segment 25'                             -- segment25
                         ,'Segment 26'                             -- segment26
                         ,'Segment 27'                             -- segment27
                         ,'Segment 28'                             -- segment28
                         ,'Segment 29'                             -- segment29
                         ,'Segment 30'                             -- segment30
                         ,'Override Entry'                         -- override_entry
                         ,'Created By'                             -- created_by       
                         ,'Creation Date'                          -- creation_date    
                         ,'Last Updated By'                        -- last_updated_by  
                         ,'Last Update Date'                       -- last_update_date
                         ,null
                    FROM dual;                    
               --     


               gvv_ProgressIndicator := '0069';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Inserting data into Global Temp Table  "'||'XXMX_PAY_EBS_ELEM_ENTRY_VALS_TEMP'||'".'
                    ,pt_i_OracleError       => NULL
                    );

             /*  INSERT INTO XXMX_PAY_EBS_ELEM_ENTRY_VALS_TEMP 
               select * from XXMX_PAY_EBS_ELEM_ENTRY_VALS_V;

               COMMIT;*/

               gvv_ProgressIndicator := '0070';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Inserting data into "'||ct_StgTable||'".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               /*FOR  FusionAssignments_rec
               IN   FusionAssignments_cur
               LOOP*/

               /* INSERT INTO   xxmx_pay_elem_entries_stg
                                (migration_set_id
                                ,migration_set_name
                                ,migration_action
                                ,element_entry
                                ,create_element_entry
                                ,element_name
                                ,effective_start_date
                                ,effective_end_date
                                ,person_number
                                ,assignment_number
                                ,terms_number
                                ,relationship_number
                                ,payroll
                                ,reason
                                ,subpriority
                                ,val1
                                ,val2
                                ,val3
                                ,val4
                                ,val5
                                ,val6
                                ,val7
                                ,val8
                                ,val9
                                ,val10
                                ,val11
                                ,val12
                                ,val13
                                ,val14
                                ,val15
                                ,val16
                                ,val17
                                ,val18
                                ,val19
                                ,val20
                                ,created_by
                                ,creation_date
                                ,last_updated_by
                                ,last_update_date
                                ,ebs_asg_number
                                )
                    SELECT      pt_i_MigrationSetID               -- migration_set_id   e.g. 24 
                                ,gvt_MigrationSetName              -- migration_set_name 'Test Migration'
                                ,'CREATE'                          -- migration_action  
                                ,element_entry                     -- element_entry
                                ,create_element_entry              -- create_element_entry
                                ,element_name                      -- element_name
                                ,effective_start_date              -- effective_start_date
                                ,effective_end_date                -- effective_end_date
                                ,person_number                     -- person_number
                                ,assignment_number                 -- assignment_number
                                ,terms_number                      -- terms_number
                                ,relationship_number               -- relationship_number
                                ,payroll                           -- payroll
                                ,reason                            -- reason
                                ,subpriority                       -- subpriority
                                ,entry_value_1                     -- val1
                                ,entry_value_2                     -- val2
                                ,entry_value_3                     -- val3
                                ,entry_value_4                     -- val4
                                ,entry_value_5                     -- val5
                                ,entry_value_6                     -- val6
                                ,entry_value_7                     -- val7
                                ,entry_value_8                     -- val8
                                ,entry_value_9                     -- val9
                                ,entry_value_10                    -- val10
                                ,entry_value_11                    -- val11
                                ,entry_value_12                    -- val12
                                ,entry_value_13                    -- val13
                                ,entry_value_14                    -- val14
                                ,entry_value_15                    -- val15
                                ,entry_value_16                    -- val16
                                ,entry_value_17                    -- val17
                                ,entry_value_18                    -- val18
                                ,entry_value_19                    -- val19
                                ,entry_value_20                    -- val20
                                ,xxmx_utilities_pkg.gvv_UserName   -- constant
                                ,TO_CHAR(SYSDATE,'RRRR/MM/DD')     -- constant
                                ,xxmx_utilities_pkg.gvv_UserName   -- constant
                                ,TO_CHAR(SYSDATE,'RRRR/MM/DD')     -- constant
                                ,ebs_asg_number
                    FROM (SELECT *
                          FROM   (SELECT  DISTINCT element_entry
                                         ,create_element_entry
                                         ,element_name
                                       --  ,fusion_input_value_name
--                                         ,ebs_input_value_name
                                         ,person_number
                                         ,assignment_number
                                         ,terms_number
                                         ,relationship_number
                                         ,payroll
                                         ,reason
                                         ,subpriority
                                         ,value
                                         ,effective_start_date
                                         ,effective_end_date
                                         ,input_value_rank
                                         ,ebs_asg_number
                                  FROM  (                   
                                        SELECT  'Element Entry'                           element_entry
                                                ,'Create Element Entry'                    create_element_entry
                                                ,element_mapping.fusion_element_name       element_name
                                                ,element_mapping.fusion_input_value_name   fusion_input_value_name
                                                ,element_mapping.ebs_input_value_name      ebs_input_value_name
                                                ,xpeeevv.person_number                                      person_number
                                               ,xpeeevv.Fusion_asg_number                  assignment_number
                                               ,NULL                                      terms_number
                                               ,NULL                                      relationship_number
                                              ,(select payroll_name
                                               from xxmx_asg_payroll_stg
                                               where assignment_number =xpeeevv.FUSION_ASG_NUMBER )  payroll
                                               ,'Data Migration'                          reason
                                               ,NULL                                      subpriority
                                               ,xpeeevv.assignment_number   ebs_asg_number
                                               ,NVL(
                                                    NVL(fusion.default_value,xpeeevv.screen_entry_value)
                                                   ,element_mapping.default_value
                                                   )                                        value
                                              -- ,gd_migration_date                         effective_start_date
                                              , to_CHAR(xpeeevv.effective_start_date,'RRRR/MM/DD')  effective_start_date
                                               ,to_CHAR(xpeeevv.effective_end_date,'RRRR/MM/DD')                          effective_end_date
                                               ,fusion.input_value_rank                   input_value_rank
                                         FROM   xxmx_fusion_ebs_ele_map        element_mapping -- ISV: Is this the correct new name.
                                               ,xxmx_pay_fusion_elem_inp_vals  fusion          -- ISV: Is this the correct new name, I havent seen this table.
                                               ,XXMX_PAY_EBS_ELEM_ENTRY_VALS_V1 xpeeevv --      If it exists it should be called xxmx_pay_fusion_elem_inp_vals
                                         WHERE  fusion.fusion_element_name     = element_mapping.fusion_element_name
                                           AND  fusion.fusion_input_value_name = element_mapping.fusion_input_value_name
                                           AND   xpeeevv.ELEMENT_NAME = element_mapping.ebs_element_name
                                           AND xpeeevv.INPUT_VALUE_NAME=  element_mapping.ebs_input_value_name
										   AND UPPER(xpeeevv.ELEMENT_NAME) NOT IN( 'PAYE DETAILS','NI','STUDENT LOAN')
										   and TO_DATE(gd_migration_date,'RRRR/MM/DD') between xpeeevv.effective_Start_Date and xpeeevv.effective_end_Date 
																		  /*= (Select MAX(effective_Start_Date)
                                                                                FROM  XXMX_PAY_EBS_ELEM_ENTRY_VALS_V1 xpeeevv1 --      If it exists it should be called xxmx_pay_fusion_elem_inp_vals
                                                                                WHERE xpeeevv1.INPUT_VALUE_NAME = xpeeevv.INPUT_VALUE_NAME
                                                                                AND  xpeeevv1.ELEMENT_NAME = xpeeevv.element_name
                                                                                and  xpeeevv1.FUSION_ASG_NUMBER = xpeeevv.FUSION_ASG_NUMBER)*/
                                       /*    and exists (select 1 
                                                        from xxmx_per_assignments_m_stg per
                                                        where SUBSTR(per.assignment_number,2,LENGTH(per.assignment_number)) = xpeeevv.assignment_number)


                                           )
                                        )
                                                   PIVOT (
                                                          MAX(value)
                                                          FOR input_value_rank
                                                          IN  (
                                                               1  AS  entry_value_1
                                                              ,2  AS  entry_value_2
                                                              ,3  AS  entry_value_3
                                                              ,4  AS  entry_value_4
                                                              ,5  AS  entry_value_5
                                                              ,6  AS  entry_value_6
                                                              ,7  AS  entry_value_7
                                                              ,8  AS  entry_value_8
                                                              ,9  AS  entry_value_9
                                                              ,10 AS  entry_value_10
                                                              ,11 AS  entry_value_11
                                                              ,12 AS  entry_value_12
                                                              ,13 AS  entry_value_13
                                                              ,14 AS  entry_value_14
                                                              ,15 AS  entry_value_15
                                                              ,16 AS  entry_value_16
                                                              ,17 AS  entry_value_17
                                                              ,18 AS  entry_value_18
                                                              ,19 AS  entry_value_19
                                                              ,20 AS  entry_value_20 
                                                              )
                                                         )
                                                   WHERE effective_start_date IS NOT NULL
                                            );  */

                     OPEN c_ebs_element; 
                     FETCH c_ebs_element BULK COLLECT INTO p_elements_tab;
                     CLOSE c_ebs_element;

                     FOR i IN 1..p_elements_tab.count
                     LOOP
                        INSERT INTO   xxmx_pay_elem_entries_stg
                                (migration_set_id
                                ,migration_set_name
                                ,migration_action
                                ,element_entry
                                ,create_element_entry
                                ,element_name
                                ,effective_start_date
                                ,effective_end_date
                                ,person_number
                                ,assignment_number
                                ,terms_number
                                ,relationship_number
                                ,payroll
                                ,reason
                                ,subpriority
                                ,val1
                                ,val2
                                ,val3
                                ,val4
                                ,val5
                                ,val6
                                ,val7
                                ,val8
                                ,val9
                                ,val10
                                ,val11
                                ,val12
                                ,val13
                                ,val14
                                ,val15
                                ,val16
                                ,val17
                                ,val18
                                ,val19
                                ,val20
                                ,created_by
                                ,creation_date
                                ,last_updated_by
                                ,last_update_date
                                ,ebs_asg_number
                                )
                                VALUES(
                              p_elements_tab(i).migration_set_id               -- migration_set_id   e.g. 24 
                                ,p_elements_tab(i).migration_set_name              -- migration_set_name 'Test Migration'
                                ,'CREATE'                          -- migration_action  
                                ,p_elements_tab(i).element_entry                     -- element_entry
                                ,p_elements_tab(i).create_element_entry              -- create_element_entry
                                ,p_elements_tab(i).element_name                      -- element_name
                                ,p_elements_tab(i).effective_start_date              -- effective_start_date
                                ,p_elements_tab(i).effective_end_date                -- effective_end_date
                                ,p_elements_tab(i).person_number                     -- person_number
                                ,p_elements_tab(i).assignment_number                 -- assignment_number
                                ,p_elements_tab(i).terms_number                      -- terms_number
                                ,p_elements_tab(i).relationship_number               -- relationship_number
                                ,p_elements_tab(i).payroll                           -- payroll
                                ,p_elements_tab(i).reason                            -- reason
                                ,p_elements_tab(i).subpriority                       -- subpriority
                                ,p_elements_tab(i).entry_value_1                     -- val1
                                ,p_elements_tab(i).entry_value_2                     -- val2
                                ,p_elements_tab(i).entry_value_3                     -- val3
                                ,p_elements_tab(i).entry_value_4                     -- val4
                                ,p_elements_tab(i).entry_value_5                     -- val5
                                ,p_elements_tab(i).entry_value_6                     -- val6
                                ,p_elements_tab(i).entry_value_7                     -- val7
                                ,p_elements_tab(i).entry_value_8                     -- val8
                                ,p_elements_tab(i).entry_value_9                     -- val9
                                ,p_elements_tab(i).entry_value_10                    -- val10
                                ,p_elements_tab(i).entry_value_11                    -- val11
                                ,p_elements_tab(i).entry_value_12                    -- val12
                                ,p_elements_tab(i).entry_value_13                    -- val13
                                ,p_elements_tab(i).entry_value_14                    -- val14
                                ,p_elements_tab(i).entry_value_15                    -- val15
                                ,p_elements_tab(i).entry_value_16                    -- val16
                                ,p_elements_tab(i).entry_value_17                    -- val17
                                ,p_elements_tab(i).entry_value_18                    -- val18
                                ,p_elements_tab(i).entry_value_19                    -- val19
                                ,p_elements_tab(i).entry_value_20                    -- val20
                                ,xxmx_utilities_pkg.gvv_UserName   -- constant
                                ,TO_CHAR(SYSDATE,'RRRR/MM/DD')     -- constant
                                ,xxmx_utilities_pkg.gvv_UserName   -- constant
                                ,TO_CHAR(SYSDATE,'RRRR/MM/DD')     -- constant
                                ,p_elements_tab(i).ebs_asg_number);

                    END LOOP;
                 COMMIT;
                 --

                    --
            --   END LOOP;
               --
                                 -- call utilities 
               gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                    (gct_StgSchema,ct_StgTable,pt_i_MigrationSetID);

               gvv_ProgressIndicator := '0080';
               --
               COMMIT;
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extraction complete. '||gvn_RowCount||' Rows inserted '||ct_StgTable 
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0090';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => ' Updating Staging Table '||ct_StgTable
                    ,pt_i_OracleError       => NULL
                    );               
               -- 

        --All Element entries are created with start date as gd_migration_date.
                --Review for the target environment
               UPDATE xxmx_pay_elem_entries_stg stg
                  SET effective_start_date =  gd_migration_date
               WHERE migration_set_id      = pt_i_MigrationSetID
                 AND element_name          <> '<Element Name>';
               --
    --           gvv_ProgressIndicator := '0100';
    --           --
    --           xxmx_utilities_pkg.upd_migration_details
    --                (pt_i_MigrationSetID          => pt_i_MigrationSetID
    --                ,pt_i_BusinessEntity          => gcv_BusinessEntity
    --                ,pt_i_SubEntity               => pt_i_SubEntity
     --               ,pt_i_Phase                   => ct_Phase
     --               ,pt_i_ExtractCompletionDate   => SYSDATE
     --               ,pt_i_ExtractRowCount         => gvn_RowCount
     --               ,pt_i_TransformTable          => NULL
     --               ,pt_i_TransformStartDate      => NULL
     --               ,pt_i_TransformCompletionDate => NULL
     --               ,pt_i_ExportFileName          => NULL
     --               ,pt_i_ExportStartDate         => NULL
     --               ,pt_i_ExportCompletionDate    => NULL
     --               ,pt_i_ExportRowCount          => NULL
     --               ,pt_i_ErrorFlag               => NULL
      --              );
               --
     --          xxmx_utilities_pkg.log_module_message
     --               (pt_i_ApplicationSuite  => gct_ApplicationSuite
     --               ,pt_i_Application       => gct_Application
     --               ,pt_i_BusinessEntity    => gcv_BusinessEntity
     --               ,pt_i_SubEntity         => pt_i_SubEntity
     --               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
     --               ,pt_i_Phase             => ct_Phase
     --               ,pt_i_Severity          => 'NOTIFICATION'
     --               ,pt_i_PackageName       => gcv_PackageName
     --               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
     --               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
     --               ,pt_i_ModuleMessage     => 'END '||cv_ProcOrFuncName||' - Migration Table "'
     --                                        ||ct_StgTable||'" reporting details updated.'
     --               ,pt_i_OracleError       => NULL
     --               );
          ELSE
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set not initialized.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          EXCEPTION
               WHEN e_ModuleError THEN
                    --
                    ROLLBACK;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RAISE;
               --** END e_ModuleError Exception
               WHEN OTHERS THEN
                    --
                    ROLLBACK;
                    --
                    gvt_OracleError := SUBSTR(SQLERRM||'** ERROR_BACKTRACE: '
                                           ||dbms_utility.format_error_backtrace,1,4000);
                    --
                    xxmx_utilities_pkg.log_module_message
                         (pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    RAISE;
               --** END OTHERS Exception
          --** END Exception Handler
     END pay_elem_entries_stg;
     --*************************************************************************************
     --*************************************************************************************
     --*************************************************************************************
     --
     --********************************
     --** PROCEDURE: update_elem_entries_stg
     --********************************
     PROCEDURE update_elem_entries_stg 
                        (pv_source_element_name          IN      VARCHAR2
                        ,pv_target_element_name          IN      VARCHAR2
                        ,pv_input_value_name             IN      VARCHAR2
                        ,pv_input_value                  IN      VARCHAR2
                        ,pv_exists                       IN      VARCHAR2
                        ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                        ) 
     AS
          --** Constant Declarations
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'update_elem_entries_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXTRACT';
          ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE := 'xxmx_pay_elem_entries_stg';
          --** Variable Declarations
          vv_sql              VARCHAR2(10000);
          vn_input_value_rank NUMBER := 999;   
          vv_sql_generated    VARCHAR2(1) := 'N';
     BEGIN

          gvv_ProgressIndicator := '0010';

          xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Starting Procedure "' ||gcv_PackageName ||'.'||cv_ProcOrFuncName||'".'
                                              ||' Target_element_name '||pv_target_element_name
                                              ||' Input_value_name '||pv_input_value_name
                    ,pt_i_OracleError       => NULL
                    );

          vn_input_value_rank :=  get_input_value_rank(pv_target_element_name,pv_input_value_name);

          gvv_ProgressIndicator := '0020';

          xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Input Value Rank: ' ||vn_input_value_rank||' Value ' 
                    ,pt_i_OracleError       => NULL
                    );                       

          IF (vn_input_value_rank <> 999 
                AND pv_exists = 'Y' 
                AND pv_source_element_name IS NOT NULL
                AND pv_exists IS NOT NULL)
          THEN 
                    vv_sql := 'UPDATE xxmx_pay_elem_entries_stg stg'
                    || ' SET val'
                    || vn_input_value_rank ||' = '''||pv_input_value
                    || ''' WHERE element_name = '''
                    || pv_target_element_name
                    || '''  AND stg.assignment_number  IS NOT NULL AND EXISTS ( '
                    || ' SELECT '
                    || ' 1 '
                    || ' FROM '
                    || ' xxmx_pay_ebs_elem_entry_vals_v ebs '
                    || ' WHERE '
                    || 'ebs.element_name = '''
                    || pv_source_element_name
                    || ''')'
                    || ' AND migration_set_id = '||pt_i_MigrationSetID ;     

               vv_sql_generated   := 'Y';

          ELSIF ( vn_input_value_rank <> 999
                   AND pv_exists = 'N' 
                   AND pv_source_element_name IS NOT NULL
                   AND pv_exists IS NOT NULL)
          THEN
               vv_sql := 'UPDATE xxmx_pay_elem_entries_stg stg'
                    || ' SET val'
                    || vn_input_value_rank  ||' = '''||pv_input_value
                    || ''' WHERE element_name = '''
                    || pv_target_element_name
                    || '''  AND stg.assignment_number IS NOT NULL  AND NOT EXISTS ( '
                    || ' SELECT '
                    || ' 1 '
                    || ' FROM '
                    || ' xxmx_pay_ebs_elem_entry_vals_v ebs '
                    || ' WHERE '
                    || 'ebs.element_name = '''
                    || pv_source_element_name
                    || ''')'
                    || ' AND migration_set_id = '||pt_i_MigrationSetID ;     

               vv_sql_generated   := 'Y';
          END IF;
 -- dbms_output.put_line(vv_sql); 
          IF   vv_sql_generated   = 'Y' THEN
               EXECUTE IMMEDIATE vv_sql;
          END IF;       

          gvv_ProgressIndicator := '0030';

          xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '- END Procedure "' ||gcv_PackageName ||'.'||cv_ProcOrFuncName||'".' 
                                                 ||' SQL generated: '||vv_sql_generated 
                    ,pt_i_OracleError       => NULL
                    );
    --
    EXCEPTION
          WHEN OTHERS THEN
               --
               ROLLBACK;
               --
               gvt_OracleError := SUBSTR(SQLERRM||'** ERROR_BACKTRACE: '
                                                ||dbms_utility.format_error_backtrace,1,4000);
               --
               gvv_ProgressIndicator := '0020';

               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Error Executing '||vv_sql 
                    ,pt_i_OracleError       => NULL
                    );
                --
               RAISE;
                --** END OTHERS Exception
           --** END Exception Handler
     END update_elem_entries_stg;
     --*************************************************************************************
     --*************************************************************************************
     --*************************************************************************************
     --
     --********************************
     --** PROCEDURE: pay_balances_stg
     --********************************
     PROCEDURE pay_balances_stg
                    (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
     IS
          --***********************
          --** CURSOR Declarations
          --***********************
          CURSOR EbsAssignments_cur IS
              SELECT  DISTINCT
                       ebs_assignment_number
                      ,balance_name
                      ,dimension_name
                      ,effective_date
              FROM     xxmx_pay_ebs_balances bal
              WHERE    1 = 1
              AND      bal.assignment_action_id = (
                                                   SELECT  MAX(assignment_action_id)
                                                   FROM    xxmx_pay_ebs_balances bal1
                                                   WHERE   1 = 1
                                                   AND     bal.assignment_id  = bal1.assignment_id
                                                   AND     bal.balance_name   = bal1.balance_name
                                                   AND     bal.dimension_name = bal1.dimension_name
                                                   AND     bal.effective_date = bal1.effective_date
                                                  )                           
              ORDER BY ebs_assignment_number, balance_name ASC;
          --
          --***********************
          --** Constant Declarations
          --***********************
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'pay_balances_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXTRACT';
          ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE := 'xxmx_pay_balances_stg';
          --************************
          --** Variable Declarations
          --***********************
          vd_sysdate   VARCHAR(30); 
          --*************************
          --** Exception Declarations
          --***********************
          e_ModuleError                   EXCEPTION;
     --
     BEGIN
          --
          gvv_ProgressIndicator := '0010';
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'MODULE'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F' THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'DATA'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          gvv_ProgressIndicator := '0030';
          --
          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          gvv_ProgressIndicator := '0040';
          --
          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
          --
          DELETE FROM xxmx_pay_ebs_balances;
          DELETE FROM xxmx_pay_balances_stg;
          --
          IF   gvt_MigrationSetName IS NOT NULL THEN
               --
               gvv_ProgressIndicator := '0050';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Extracting "'||pt_i_SubEntity||'":'
                    ,pt_i_OracleError       => NULL
                    );
               --
               xxmx_utilities_pkg.init_migration_details
                    (pt_i_ApplicationSuite => gct_ApplicationSuite
                    ,pt_i_Application      => gct_Application
                    ,pt_i_BusinessEntity   => gcv_BusinessEntity
                    ,pt_i_SubEntity        => pt_i_SubEntity
                    ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                    ,pt_i_StagingTable     => ct_StgTable
                    ,pt_i_ExtractStartDate => SYSDATE
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Staging Table "'||ct_StgTable||'" reporting details initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               -- 
               gvv_ProgressIndicator := '0060';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => 'call procedure insert_pay_ebs_balances to populate the temp table xxmx_pay_balances_stg'
                    ,pt_i_OracleError       => NULL
                    );
               --
               -- call procedure to populate the transitory table pay_balances for insert into the xxmx_pay_balances_stg table
               insert_pay_ebs_balances( pt_i_MigrationSetID, pt_i_SubEntity);
               --
			   gvv_ProgressIndicator := '0061';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => 'call procedure insert_pay_ebs_balances_addnl to populate the temp table xxmx_pay_balances_stg'
                    ,pt_i_OracleError       => NULL
                    );
			  -- insert_pay_ebs_balances_addnl( pt_i_MigrationSetID, pt_i_SubEntity);

               gvv_ProgressIndicator := '0070';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => 'Procedure insert_pay_ebs_balances_addnl returned'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0080';
               --
               --** Extract the Entity data and insert into the staging table.
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extracting Header data into "'||ct_StgTable||'".'
                    ,pt_i_OracleError       => NULL
                    );
                    --
                    xxmx_pay_ebs_balance_ext( pt_i_MigrationSetID, pt_i_SubEntity);
                    --
                   /* vd_sysdate := xxmx_utilities_pkg.date_and_time_stamp(pv_i_IncludeSeconds => 'Y');
                    --
                    FOR   r_ctx
                    IN   (SELECT * FROM xxmx_pay_balance_contexts)
                    LOOP
                         UPDATE xxmx_pay_balance_contexts 
                            SET process_type = NVL(get_ebs_screen_entry_val
                                                       (get_assignment_number(r_ctx.assignmentnumber,'N')
                                                       ,'NI','Process Type')
                                                  ,'N')
                          WHERE assignmentnumber = r_ctx.assignmentnumber;
                    END LOOP;      
               --
               INSERT INTO xxmx_pay_balances_stg
                 WITH   balance_values
                   AS (SELECT  DISTINCT
                                  ebs_assignment_number
                                 ,balance_name
                                 ,dimension_name
                                 ,effective_date
                                 ,balance_value
                        FROM   (
                              SELECT  ebs_assignment_number
                                     ,balance_name
                                     ,dimension_name
                                     ,effective_date
                                     ,balance_value
                                     ,cursor_name
                              FROM    xxmx_pay_ebs_balances  bal
                              WHERE   bal.assignment_action_id = 
                                            (
                                             SELECT MAX(bal1.assignment_action_id)
                                               FROM   xxmx_pay_ebs_balances bal1
                                              WHERE    bal1.assignment_id  = bal.assignment_id
                                                AND    bal1.balance_name   = bal.balance_name
                                                AND    bal1.dimension_name = bal.dimension_name
                                                AND    bal1.effective_date = bal.effective_date
                                             )
                                AND     bal.cursor_name = 'c_balance_asg'
                              UNION
                              SELECT  DISTINCT 
                                      xpeb.ebs_assignment_number
                                     ,xpeb.balance_name
                                     ,xpeb.dimension_name
                                     ,xpeb.effective_date
                                     ,xpeb.balance_value
                                     ,xpeb.cursor_name
                                FROM  xxmx_pay_ebs_balances xpeb 
                                     ,(
                                       SELECT  ebs_assignment_number
                                              ,balance_name
                                              ,dimension_name
                                              ,effective_date
                                              --,balance_value
                                              ,cursor_name
                                              ,max(assignment_action_id) assignment_action_id
                                        FROM xxmx_pay_ebs_balances bal
                                       WHERE bal.effective_date = 
                                                     (
                                                      SELECT MAX(bal1.effective_date)
                                                        FROM xxmx_pay_ebs_balances bal1
                                                       WHERE bal.assignment_id = bal1.assignment_id
                                                         AND bal.balance_name = bal1.balance_name
                                                         AND bal.dimension_name = bal1.dimension_name
                                                      )
                                        AND  bal.cursor_name IN ('c_balance_asg_leaver','c_rehires')
                                        AND  balance_name <> 'NIable Pay'
                                    GROUP BY ebs_assignment_number
                                            ,balance_name
                                            ,dimension_name
                                            ,effective_date
                                          --,balance_value
                                            ,cursor_name

                                      ) maa
                              WHERE  maa.assignment_action_id   =  xpeb.assignment_action_id
                              AND    xpeb.ebs_assignment_number =  maa.ebs_assignment_number
                              AND    xpeb.balance_name          =  maa.balance_name
                              AND    xpeb.dimension_name        =  maa.dimension_name
                              AND    xpeb.effective_date        =  maa.effective_date
                              AND    xpeb.cursor_name           =  maa.cursor_name
                              )
                              UNION ALL
                              SELECT
                                      ebs_assignment_number
                                     ,balance_name
                                     ,dimension_name
                                     ,effective_date
                                     ,SUM(balance_value)
                              FROM (
               		     SELECT   
               				ebs_assignment_number,
               				balance_name,
               				dimension_name,
               				effective_date,
               				balance_value,
               				cursor_name
               			FROM  
                                   xxmx_pay_ebs_balances bal
                              WHERE   bal.cursor_name = 'c_balance_asg_niable'
                              UNION ALL
                              SELECT  ebs_assignment_number
                                     ,balance_name
                                     ,dimension_name
                                     ,effective_date
                                     ,balance_value
                                     ,cursor_name
                              FROM    xxmx_pay_ebs_balances bal
                              WHERE   bal.cursor_name = 'c_balance_asg_niable_leaver'
                                  AND NOT EXISTS (SELECT 1 FROM xxmx_pay_ebs_balances bal1 
                                        WHERE cursor_name IN ( 'c_balance_asg_niable' ,'c_rehires')
                                        AND bal.ebs_assignment_number =  bal1.ebs_assignment_number)
                              UNION ALL
                               SELECT 
                                     ebs_assignment_number,
                                     balance_name,
                                     dimension_name,
                                     effective_date,
                                     balance_value,
                                     cursor_name
                                FROM
                                     xxmx_pay_ebs_balances bal
                               WHERE cursor_name = 'c_rehires'
                                 AND balance_name = 'NIable Pay'
                                   AND NOT EXISTS (SELECT 1 FROM xxmx_pay_ebs_balances bal1
                                                  WHERE cursor_name IN ( 'c_balance_asg_niable' ,'c_balance_asg_niable_leaver')
                                                    AND bal.ebs_assignment_number =  bal1.ebs_assignment_number)
                         )
                     GROUP BY ebs_assignment_number,
                              balance_name,
                              dimension_name,
                              effective_date              
                      ORDER BY  ebs_assignment_number
                               ,balance_name
                               ,effective_date    
                     )
                                 SELECT pt_i_MigrationSetID                          migration_set_id                
                                       ,'Migration Set Name'                         migration_set_name
                                       ,'Migration Action'                           migration_action  
                                       ,'HeaderOrLine'                               headerorline
                                       ,'LegislativeDataGroupName'                   ldg
                                       ,'UploadDate'                                 uploaddate
                                       ,'SourceSystemOwner'                          sourcesystemowner
                                       ,'LineSequence'                               linesequence
                                       ,'AssignmentNumber'                           assignmentnumber
                                       ,'BalanceDate'                                balancedate
                                       ,'BalanceName'                                balancename
                                       ,'ContextOneName'                             contextonename
                                       ,'ContextOneValue'                            contextonevalue
                                       ,'ContextTwoName'                             contexttwoname
                                       ,'ContextTwoValue'                            contexttwovalue
                                       ,'ContextThreeName'                           contextthreename
                                       ,'ContextThreeValue'                          contextthreevalue
                                       ,'ContextFourName'                            contextfourname
                                       ,'ContextFourValue'                           contextfourvalue
                                       ,'ContextFiveName'                            contextfivename
                                       ,'ContextFiveValue'                           contextfivevalue
                                       ,'DimensionName'                              dimensionname
                                       ,'LegalEmployerName'                          legalemployername
                                       ,'PayrollName'                                payrollname
                                       ,'PayrollRelationshipNumber'                  payrollrelationshipnumber
                                       ,'TermNumber'                                 termnumber
                                       ,'Value'                                      value
                                       ,NULL                                         assignment_action_id 
                                       ,NULL                                         payroll_action_id 
                                       ,NULL                                         balance_type_id
                                       ,NULL                                         balance_dimension_id 
                                       ,NULL                                         defined_balance_id 
                                       ,'Created By'                                 created_by       
                                       ,'Creation Date'                              creation_date    
                                       ,'Last Updated By'                            last_updated_by  
                                       ,'Last Update Date'                           last_update_date  
           --                            ,NULL                                         ebs_asg_number
                                 FROM    dual
                                 UNION ALL
                                 SELECT pt_i_MigrationSetID                          migration_set_id  
                                       ,'Migration Set Name'                         migration_set_name
                                       ,'Migration Action'                           migration_action  
                                       ,'Header'                                     headerorline
                                       ,'GB Legislative Data Group'                  ldg
                                       ,TO_CHAR(SYSDATE,'RRRR/MM/DD')                uploaddate
                                       ,'EBS'                                        sourcesystemowner
                                       ,'LineSequence'                               linesequence
                                       ,'AssignmentNumber'                           assignmentnumber
                                       ,'BalanceDate'                                balancedate
                                       ,'BalanceName'                                balancename
                                       ,'ContextOneName'                             contextonename
                                       ,'ContextOneValue'                            contextonevalue
                                       ,'ContextTwoName'                             contexttwoname
                                       ,'ContextTwoValue'                            contexttwovalue
                                       ,'ContextThreeName'                           contextthreename
                                       ,'ContextThreeValue'                          contextthreevalue
                                       ,'ContextFourName'                            contextfourname
                                       ,'ContextFourValue'                           contextfourvalue
                                       ,'ContextFiveName'                            contextfivename
                                       ,'ContextFiveValue'                           contextfivevalue
                                       ,'DimensionName'                              dimensionname
                                       ,'LegalEmployerName'                          legalemployername
                                       ,'PayrollName'                                payrollname
                                       ,'PayrollRelationshipNumber'                  payrollrelationshipnumber
                                       ,'TermNumber'                                 termnumber
                                       ,'Value'                                      value
                                       ,NULL                                         assignment_action_id
                                       ,NULL                                         payroll_action_id
                                       ,NULL                                         balance_type_id
                                       ,NULL                                         balance_dimension_id
                                       ,NULL                                         defined_balance_id 
                                       ,'Created By'                                 created_by       
                                       ,'Creation Date'                              creation_date    
                                       ,'Last Updated By'                            last_updated_by  
                                       ,'Last Update Date'                           last_update_date   
            --                           ,NULL 
                                 FROM    dual
                                 UNION ALL
                                 SELECT 
                                        pt_i_MigrationSetID                          migration_set_id  
                                       ,gvt_MigrationSetName                         migration_set_name
                                       ,'CREATE'                                     migration_action  
                                       ,'Line'                                       headerorline
                                       ,'GB Legislative Data Group'                  legislativedatagroupname
                                       ,DECODE(balance_name
                                                    ,'NIable Pay', TO_CHAR(effective_date,'RRRR/MM/DD')
                                                                 , TO_CHAR(SYSDATE,'RRRR/MM/DD')
                                               )                                      upload_date
                                       ,'EBS'                                        sourcesystemowner
                                       ,NULL                                         linesequence
                                       ,get_assignment_number(ebs_assignment_number,'Y') assignmentnumber
                                       ,DECODE(balance_name
                                                    ,'NIable Pay', TO_CHAR(effective_date,'RRRR/MM/DD HH24:MI:SS')
                                                                 , TO_CHAR(TRUNC(SYSDATE),'RRRR/MM/DD HH24:MI:SS')
                                               )                                     balance_date
                                       ,balance_name                                 balancename
                                       ,contextonename
                                       ,contextonevalue
                                       ,contexttwoname
                                       ,contexttwovalue
                                       ,contextthreename
                                       ,contextthreevalue
                                       ,contextfourname
                                       ,contextfourvalue
                                       ,contextfivename
                                       ,contextfivevalue
                                       ,dimension_name
                                       ,legalemployername
                                       ,payrollname
                                       ,payrollrelationshipnumber
                                       ,termnumber
                                       ,TO_CHAR(balance_value)                       value
                                       ,NULL                                         assignment_action_id
                                       ,NULL                                         payroll_action_id
                                       ,NULL                                         balance_type_id
                                       ,NULL                                         balance_dimension_id
                                       ,NULL                                         defined_balance_id
                                       ,UPPER(sys_context('userenv','OS_USER'))      created_by       
                                       ,TO_CHAR(SYSDATE,'RRRR/MM/DD')                creation_date   
                                       ,UPPER(sys_context('userenv','OS_USER'))      last_updated_by  
                                       ,TO_CHAR(SYSDATE,'RRRR/MM/DD')                last_update_date     
                 --                      ,ebs_assignment_number                
                               FROM  (
                                        SELECT DISTINCT
                                              ebs_assignment_number                  ebs_assignment_number        
                                             ,balance_name                           balance_name   
                                             ,dimension_name                         dimension_name  
                                             ,effective_date                         effective_date   
                                             ,balance_value                          balance_value
                                             ,'Aggregation Information'              contextonename
                                             ,TO_CHAR(ctx.aggregation_information)   contextonevalue
                                             ,'NI Category'                          contexttwoname
                                             ,ctx.ni_category                        contexttwovalue
                                             ,'Pension Basis'                        contextthreename
                                             ,ctx.pension_basis                      contextthreevalue
                                             ,'Process Type'                         contextfourname
                                             ,ctx.process_type                       contextfourvalue
                                             ,'NI Reporting HMRC Payroll ID'         contextfivename
                                             ,TO_CHAR(ni_reporting_hmrc_payroll_id)  contextfivevalue
                                             ,legal_employer_name                    legalemployername
                                             ,payroll_name                           payrollname
                                             ,payrollrelationshipnumber              payrollrelationshipnumber
                                             ,termnumber                             termnumber
                                        FROM  xxmx_pay_ebs_balances  bal,                    
                                              xxmx_pay_balance_contexts ctx 
                                        WHERE  assignment_action_id = 
                                                 (SELECT MAX(assignment_action_id)
                                                    FROM xxmx_pay_ebs_balances bal1
                                                   WHERE bal.assignment_id = bal1.assignment_id
                                                     AND bal.balance_name = bal1.balance_name
                                                     AND bal.dimension_name = bal1.dimension_name
                                                     AND bal.effective_date = bal1.effective_date
                                                  )
                                          AND ctx.assignmentnumber = get_assignment_number(ebs_assignment_number,'Y')
                                          AND (                             
                                                ctx.ni_category    = regexp_SUBSTR(bal.balance_name,'[[:alpha:]]+',1,2)                               
                                                 --  OR SUBSTR(bal.balance_name,1,2) not IN ('NI','St')
                                                 OR bal.balance_name IN ('NI Employee','NI Employer','NIable Pay'
                                                                        ,'Student Loan','Gross Pay','Net Pay','PAYE','Taxable Pay')
                                              )
                                        UNION
                                        SELECT DISTINCT
                                              ebs_assignment_number         ebs_assignment_number
                                             ,'Gross Earnings'              grossearnings
                                             ,dimension_name                dimensionname
                                             ,effective_date                effectivedate
                                             ,balance_value                 balancevalue
                                             ,NULL                          contextonename
                                             ,NULL                          contextonevalue
                                             ,NULL                          contexttwoname
                                             ,NULL                          contexttwovalue
                                             ,NULL                          contextthreename
                                             ,NULL                          contextthreevalue
                                             ,NULL                          contextfourname
                                             ,NULL                          contextfourvalue
                                             ,NULL                          contextfivename
                                             ,NULL                          contextfivevalue
                                             ,legal_employer_name           legalemployername
                                             ,payroll_name                  payrollname
                                             ,payrollrelationshipnumber     payrollrelationshipnumber
                                             ,termnumber                    termnumber
                                        FROM
                                              xxmx_pay_ebs_balances bal,
                                              xxmx_pay_balance_contexts ctx 
                                        WHERE assignment_action_id = 
                                                  (SELECT MAX(assignment_action_id)
                                                     FROM xxmx_pay_ebs_balances bal1
                                                    WHERE bal.assignment_id = bal1.assignment_id
                                                      AND   bal.balance_name = bal1.balance_name
                                                      AND   bal.dimension_name = bal1.dimension_name
                                                      AND   bal.effective_date = bal1.effective_date
                                                  )
                                         AND ctx.assignmentnumber = get_assignment_number(ebs_assignment_number,'Y')
                                         AND bal.balance_name = 'Gross Pay'
                                        UNION
                                        SELECT DISTINCT
                                             ebs_assignment_number
                                             ,'Total Pay'
                                             ,dimension_name
                                             ,effective_date
                                             ,balance_value
                                             ,NULL                                   contextonename
                                             ,NULL                                   contextonevalue
                                             ,NULL                                   contexttwoname
                                             ,NULL                                   contexttwovalue
                                             ,NULL                                   contextthreename
                                             ,NULL                                   contextthreevalue
                                             ,NULL                                   contextfourname
                                             ,NULL                                   contextfourvalue
                                             ,NULL                                   contextfivename
                                             ,NULL                                   contextfivevalue
                                             ,legal_employer_name                    legalemployername
                                             ,payroll_name                           payrollname
                                             ,payrollrelationshipnumber              payrollrelationshipnumber
                                             ,termnumber                             termnumber
                                        FROM xxmx_pay_ebs_balances  bal,
                                             xxmx_pay_balance_contexts ctx 
                                       WHERE  assignment_action_id = 
                                                 (SELECT MAX(assignment_action_id)
                                                  FROM xxmx_pay_ebs_balances bal1
                                                  WHERE bal.assignment_id = bal1.assignment_id
                                                    AND   bal.balance_name = bal1.balance_name
                                                    AND   bal.dimension_name = bal1.dimension_name
                                                    AND   bal.effective_date = bal1.effective_date
                                                  )
                                         AND ctx.assignmentnumber = get_assignment_number(ebs_assignment_number,'Y')
                                         AND   bal.balance_name = 'Net Pay'
                                        );
          --
          UPDATE xxmx_pay_balances_stg
             SET contextonename         = NULL,
                 contextonevalue        = NULL,
                 contexttwoname         = NULL,
                 contexttwovalue        = NULL, 
                 contextthreename       = NULL,
                 contextthreevalue      = NULL,
                 contextfourname        = NULL,
                 contextfourvalue       = NULL,
                 contextfivename        = NULL,
                 contextfivevalue       = NULL
           WHERE SUBSTR(balancename,1,2) NOT IN ('NI','St')
             AND headerorline           = 'Line'
             AND migration_set_id       = pt_i_MigrationSetID;

          UPDATE xxmx_pay_balances_stg
             SET contextthreename       = NULL,
                 contextthreevalue      = NULL,
                 contextfourname        = NULL,
                 contextfourvalue       = NULL
           WHERE balancename = 'NIable Pay'
             AND headerorline = 'Line'
             AND migration_set_id       = pt_i_MigrationSetID;

          UPDATE xxmx_pay_balances_stg
             SET contexttwoname         = NULL,
                 contexttwovalue        = NULL, 
                 contextthreename       = NULL,
                 contextthreevalue      = NULL,
                 contextfourname        = NULL,
                 contextfourvalue       = NULL
           WHERE balancename = 'Student Loan'
             AND headerorline = 'Line'
             AND migration_set_id       = pt_i_MigrationSetID;

          UPDATE xxmx_pay_balances_stg
          SET 
               balancename =   DECODE(balancename
                                             ,'NI A Able','NIable by Category'
                                             ,'NI C Able','NIable by Category'
                                             ,'NI M Able','NIable by Category'
                                             ,'NI A Able ET','NI PT'
                                             ,'NI C Able ET','NI PT'
                                             ,'NI M Able ET','NI PT'
                                             ,REGEXP_REPLACE(balancename, ('A Able |M Able |C Able '),'') 
                                   ),
               dimensionname = 
               DECODE(balancename,'Gross Pay','Assignment Tax Unit Tax Year to Date'
                              ,'NIable Pay',
                              decode(dimensionname
                                    ,'_ASG_PROC_PTD','Assignment Tax Unit, Deduction Card, Insurance Type, Statutory Report Code Period to Date'
                                    ,'Assignment Tax Unit, Deduction Card, Insurance Type, Statutory Report Code Tax Year to Date')
                              ,'PAYE','Relationship Tax Unit Tax Year to Date','Taxable Pay','Assignment, Tax Year to Date'
                              ,'Student Loan','Payroll Relationship, Tax Reporting Unit, Deduction Card, Tax Year to Date'
                              ,'Net Pay','Assignment, Tax Year to Date'
                              ,'Gross Earnings','Assignment Tax Unit Tax Year to Date'
                              ,'Total Pay','Assignment, Tax Year to Date'
                              ,'Relationship Tax Unit, Deduction Card, Insurance Type, Pension Type, Process Type, SRC Tax Year to Date'
                         ),
               linesequence = rownum
           WHERE headerorline = 'Line' 
             AND migration_set_id       = pt_i_MigrationSetID;

          UPDATE xxmx_pay_balances_stg stg
             SET
                 uploaddate = TO_CHAR(last_day(TO_DATE(uploaddate,'RRRR/MM/DD') ),'RRRR/MM/DD'),
                 balancedate = TO_CHAR(last_day(TO_DATE(uploaddate,'RRRR/MM/DD') ),'RRRR/MM/DD HH24:MI:SS')
           WHERE
                 balancename = 'NIable Pay'
             AND migration_set_id       = pt_i_MigrationSetID
             AND assignmentnumber IS NOT NULL
             AND EXISTS (
                         SELECT 1
                         FROM apps.per_all_assignments_f@mxdm_nvis_extract asg
                             ,apps.pay_all_payrolls_f@mxdm_nvis_extract pay
                             ,xxmx_pay_fusion_ebs_asg_map asgmap
                        WHERE asg.payroll_id        = pay.payroll_id
                          AND pay.payroll_name LIKE '%Monthly%'
                          AND asg.assignment_number = asgmap.ebs_asg_number
                          AND stg.assignmentnumber  = asgmap.fusion_asg_number
                          AND asgmap.asg_org is not null
                        );
                        */
     ELSE
          gvt_Severity      := 'ERROR';
          gvt_ModuleMessage := '- Migration Set for '||ct_StgTable||' not initialized.';
          --
          RAISE e_ModuleError;
     END IF;
     --

     COMMIT;
--
     EXCEPTION
          WHEN e_ModuleError THEN
                    --
                    ROLLBACK;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RAISE;
               --** END e_ModuleError Exception
               --
          WHEN OTHERS THEN
                    --
                    ROLLBACK;
                    --
                    gvt_OracleError := SUBSTR(SQLERRM||'** ERROR_BACKTRACE: '
                                           ||dbms_utility.format_error_backtrace,1,4000);
                    --
                    xxmx_utilities_pkg.log_module_message
                         (pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    RAISE;
               --** END OTHERS Exception
          --** END Exception Handler     
     END pay_balances_stg;
     --
     -- ------------------------------------------------------------------------------
     -- |-----------------------------< pay_cost_allocs_stg >-------------------------------------|
     -- ------------------------------------------------------------------------------
     PROCEDURE pay_cost_allocs_stg
                         (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                         ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
     IS
          --***********************
          --** Constant Declarations
          --***********************
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'pay_cost_allocs_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXTRACT';
          ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE := 'xxmx_pay_cost_allocs_stg';
          --*************************
          --** Exception Declarations
          --***********************
          e_ModuleError                   EXCEPTION;
          --** END Declarations
     BEGIN
          gvv_ProgressIndicator := '0010';
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'MODULE'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F' THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'DATA'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          gvv_ProgressIndicator := '0030';
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          gvv_ProgressIndicator := '0040';
          --
          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
          --
          IF   gvt_MigrationSetName IS NOT NULL THEN
               --
               gvv_ProgressIndicator := '0050';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Extracting "'||pt_i_SubEntity||'":'
                    ,pt_i_OracleError       => NULL
                    );
               --
               xxmx_utilities_pkg.init_migration_details
                    (pt_i_ApplicationSuite => gct_ApplicationSuite
                    ,pt_i_Application      => gct_Application
                    ,pt_i_BusinessEntity   => gcv_BusinessEntity
                    ,pt_i_SubEntity        => pt_i_SubEntity
                    ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                    ,pt_i_StagingTable     => ct_StgTable
                    ,pt_i_ExtractStartDate => SYSDATE
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Staging Table "'||ct_StgTable||'" Cost Allocations initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
                    gvv_ProgressIndicator := '0060';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extracting Header data into "'||ct_StgTable||'".'
                    ,pt_i_OracleError       => NULL
                    );
             -- 
             DELETE FROM xxmx_pay_cost_allocs_stg; -- Remove any previous records.
             --
             INSERT INTO xxmx_pay_cost_allocs_stg
             SELECT  pt_i_MigrationSetID                       --  MIGRATION_SET_ID  e.g. 24 
                    ,'Migration Set Name'                      --  MIGRATION_SET_NAME 'Test Migration'
                    ,'Migration Action'                        -- MIGRATION_ACTION  
                    ,'HeaderOrLine'
                    ,'LegislativeDataGroupName'
                    ,'EffectiveStartDate'
                    ,'EffectiveEndDate'
                    ,'SourceSystemOwner'
                    ,'DepartmentName'
                    ,'SetCode'
                    ,'Proportion'
                    ,'segment1'
                    ,'segment2'
                    ,'segment3'
                    ,'segment4'
                    ,'segment5'
                    ,'segment6'
                    ,'segment7'
                    ,'SourceType'
                    ,'SourceSubType'
                    ,'SubTypeSequence'
                    ,'MultipleEntryCount'
                    ,'Created By'  
                    ,'Creation Date' 
                    ,'Last Updated By'
                    ,'Last Update Date'
             FROM   dual;

                 gvv_ProgressIndicator := '0070';
               --
                 xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extracting Cost data into "'||ct_StgTable||'".'
                    ,pt_i_OracleError       => NULL
                    );

             INSERT INTO xxmx_pay_cost_allocs_stg
             SELECT  pt_i_MigrationSetID          --  MIGRATION_SET_ID  e.g. 24 
                    ,gvt_MigrationSetName         --  MIGRATION_SET_NAME 'Test Migration'
                    ,''                           --  MIGRATION_ACTION 
                    ,'Line'                                                            headerorline
                    ,'GB Legislative Data Group'                                       legislativedatagroupname
                    ,TO_CHAR(TO_DATE(effective_start_date,'DD-MON-RRRR'),'RRRR/MM/DD') effectivestartdate
                    ,'4712/12/31'                                                      effectiveenddate
                    ,'EBS'                                                             sourcesystemowner
                    ,department_name                                                   departmentname
                    ,NULL                                                              setcode
                    ,1                                                                 proportion
                    ,NULL                                                              segment1
                    ,NULL                                                              segment2
                    ,NULL                                                              segment3
                    ,cost_centre_code                                                  segment4
                    ,NULL                                                              segment5
                    ,NULL                                                              segment6
                    ,NULL                                                              segment7
                    ,'ORG'                                                             sourcetype
                    ,'COST'                                                            sourcesubtype
                    ,1                                                                 subtypesequence
                    ,1                                                                 multipleentrycount
                    ,UPPER(sys_context('userenv','OS_USER'))                           created_by       
                    ,TO_CHAR(SYSDATE,'RRRR/MM/DD')                                     creation_date   
                    ,UPPER(sys_context('userenv','OS_USER'))                           last_updated_by  
                    ,TO_CHAR(SYSDATE,'RRRR/MM/DD')                                     last_update_date     
               FROM  xxmx_pay_fusion_dept_cost_ctrs;
                    -- call utilities 
                   gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                    (gct_StgSchema,ct_StgTable,pt_i_MigrationSetID);    
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => 'END '||cv_ProcOrFuncName||' - Migration Table "'||ct_StgTable
                                             ||'" Data Insert ' ||gvn_RowCount||': rows completed.'
                    ,pt_i_OracleError       => NULL
                    );    
     ELSE
          gvt_Severity      := 'ERROR';
          gvt_ModuleMessage := '- Migration Set for '||ct_StgTable||' not initialized.';
          --
          RAISE e_ModuleError;
     END IF;
     --
     COMMIT;
     --
     EXCEPTION
                WHEN e_ModuleError THEN
                     --
                     ROLLBACK;
                     --
                     xxmx_utilities_pkg.log_module_message
                          (pt_i_ApplicationSuite  => gct_ApplicationSuite
                          ,pt_i_Application       => gct_Application
                          ,pt_i_BusinessEntity    => gcv_BusinessEntity
                          ,pt_i_SubEntity         => pt_i_SubEntity
                          ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                          ,pt_i_Phase             => ct_Phase
                          ,pt_i_Severity          => gvt_Severity
                          ,pt_i_PackageName       => gcv_PackageName
                          ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                          ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                          ,pt_i_ModuleMessage     => gvt_ModuleMessage
                          ,pt_i_OracleError       => NULL
                          );
                     --
                     RAISE;
                --** END e_ModuleError Exception
                WHEN OTHERS THEN
                     --
                     ROLLBACK;
                     --
                     gvt_OracleError := SUBSTR(SQLERRM||'** ERROR_BACKTRACE: '
                                            ||dbms_utility.format_error_backtrace,1,4000);
                     --
                     xxmx_utilities_pkg.log_module_message
                          (pt_i_ApplicationSuite  => gct_ApplicationSuite
                          ,pt_i_Application       => gct_Application
                          ,pt_i_BusinessEntity    => gcv_BusinessEntity
                          ,pt_i_SubEntity         => pt_i_SubEntity
                          ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                          ,pt_i_Phase             => ct_Phase
                          ,pt_i_Severity          => 'ERROR'
                          ,pt_i_PackageName       => gcv_PackageName
                          ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                          ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                          ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                          ,pt_i_OracleError       => gvt_OracleError
                          );
                     --
                     RAISE;
                --** END OTHERS Exception
           --** END Exception Handler
     END pay_cost_allocs_stg;
     --*************************************************************************************
     --*************************************************************************************
     --*************************************************************************************
     --
     --********************************
     --** PROCEDURE: pay_calc_cards_sd_stg
     --********************************
     PROCEDURE pay_calc_cards_sd_stg
                    (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
     IS
          -- CALC_CARDS_SD     pay_calc_cards_sd_stg
          --***********************
          --** Constant Declarations
          --***********************
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'pay_calc_cards_sd_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXTRACT';
          ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE := 'xxmx_pay_calc_cards_sd_stg';
          --************************
          --** Variable Declarations
          --***********************
          vd_BeginDate                   DATE;
          --
          vv_cardcomp_sourcesysowner        VARCHAR2(40) := 'FUSION';           -- cardcomponent_sourcesystemowner,
          vv_compdet_sourcesysowner_ni      VARCHAR2(40) := 'FUSION';           -- componentdetail_sourcesystemowner_ni, componentdetail_sourcesystemowner_hrx_gb_paye
          vv_cardassoc_sourcesysid          VARCHAR2(40) := '_SD_Assoc';        -- cardassociation_sourcesystemid_ni, cardassociation_sourcesystemid_paye
          vv_cardassoc_sourcesysowner       VARCHAR2(40) := 'EBS';              -- cardassociation_sourcesystemowner_ni, cardassociation_sourcesystemowner_paye cardassocdtl_sourcesystemowner_paye
          vv_cardassocdtl_sourcesysid_ni    VARCHAR2(40) := '_SD_AssocDetail_NI'; -- cardassocdtl_sourcesystemid_ni,
          vv_dircardcompdefname_ni          VARCHAR2(40) := 'PAYE';               -- dircardcompdefname_ni,
          vv_cardassocdtl_sourcesysid_paye  VARCHAR2(40) := '_SD_AssocDetail_PAYE';  -- cardassocdtl_sourcesystemid_paye,
          vv_p45_action_hrx_gb_paye         VARCHAR2(40) := 'IAT';                   -- p45_action_hrx_gb_paye,                    
          --*************************
          --** Exception Declarations
          --***********************
          e_ModuleError                   EXCEPTION;
     --** END Declarations
     BEGIN
          gvv_ProgressIndicator := '0010';
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'MODULE'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F' THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'DATA'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F' THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
          END IF;
          --
          gvv_ProgressIndicator := '0030';
          --
          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          gvv_ProgressIndicator := '0040';

           xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Get Migration Set Name for  "'||pt_i_MigrationSetID
               ,pt_i_OracleError       => NULL
               );
          --
          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
          --
          DELETE FROM xxmx_pay_calc_cards_sd_stg;
          --
          IF   gvt_MigrationSetName IS NOT NULL THEN
               --
               gvv_ProgressIndicator := '0050';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Extracting "'||pt_i_SubEntity||'":'
                    ,pt_i_OracleError       => NULL
                    );
               --
               xxmx_utilities_pkg.init_migration_details
                    (pt_i_ApplicationSuite => gct_ApplicationSuite
                    ,pt_i_Application      => gct_Application
                    ,pt_i_BusinessEntity   => gcv_BusinessEntity
                    ,pt_i_SubEntity        => pt_i_SubEntity
                    ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                    ,pt_i_StagingTable     => ct_StgTable
                    ,pt_i_ExtractStartDate => SYSDATE
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Staging Table "'||ct_StgTable||'" reporting details initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
                    gvv_ProgressIndicator := '0060';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extracting Header Record into "'||ct_StgTable||'".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               INSERT INTO   xxmx_pay_calc_cards_sd_stg
               SELECT pt_i_MigrationSetID                             -- migration_set_id  
                     ,'Migration Set Name'                            -- migration_set_name 
                     ,'Migration Action'                              -- migration_action  
                     ,'Header'                                         -- headerorline,
                     ,'CARDCOMPONENT_SOURCESYSTEMID'                   -- cardcomponent_sourcesystemid,
                     ,'CARDCOMPONENT_SOURCESYSTEMOWNER'                -- cardcomponent_sourcesystemowner,
                     ,'EFFECTIVESTARTDATE'                            -- effectivestartdate,
                     ,'EFFECTIVEENDDATE'                              -- effectiveenddate,
                     ,'LEGISLATIVEDATAGROUPNAME'                      -- legislativedatagroupname,
                     ,'TAXREPORTINGUNITNAME'                          -- taxreportingunitname,
                     ,'ASSIGNMENTNUMBER'                              -- assignmentnumber,
                     ,'DIRCARDID_SOURCESYSTEMID'                      -- dircardid_sourcesystemid,
                     ,'DIRCARDCOMPDEFNAME_NI'                         -- dircardcompdefname_ni,
                     ,'NI_CATEGORY'                                   -- ni_category,
                     ,'PENSION_BASIS'                                 -- pension_basis,
                     ,'COMPONENTDETAIL_SOURCESYSTEMID_NI'             -- componentdetail_sourcesystemid_ni,
                     ,'COMPONENTDETAIL_SOURCESYSTEMOWNER_NI'          -- componentdetail_sourcesystemowner_ni,
                     ,'CARDASSOCIATION_SOURCESYSTEMID_NI'             -- cardassociation_sourcesystemid_ni,
                     ,'CARDASSOCIATION_SOURCESYSTEMOWNER_NI'          -- cardassociation_sourcesystemowner_ni,
                     ,'CARDASSOCDTL_SOURCESYSTEMID_NI'                -- cardassocdtl_sourcesystemid_ni,
                     ,'CARDASSOCDTL_SOURCESYSTEMOWNER_NI'             -- cardassocdtl_sourcesystemowner_ni,
                     ,'DIRCARDCOMPDEFNAME_PAYE'                       -- dircardcompdefname_paye,
                     ,'COMPONENTDETAIL_SOURCESYSTEMID_PAYE'           -- componentdetail_sourcesystemid_paye,
                     ,'COMPONENTDETAIL_SOURCESYSTEMOWNER_HRX_GB_PAYE' -- componentdetail_sourcesystemowner_hrx_gb_paye,
                     ,'CARDASSOCIATION_SOURCESYSTEMID_PAYE'           -- cardassociation_sourcesystemid_paye,
                     ,'CARDASSOCIATION_SOURCESYSTEMOWNER_PAYE'        -- cardassociation_sourcesystemowner_paye,
                     ,'CARDASSOCDTL_SOURCESYSTEMID_PAYE'              -- cardassocdtl_sourcesystemid_paye,
                     ,'CARDASSOCDTL_SOURCESYSTEMOWNER_PAYE'           -- cardassocdtl_sourcesystemowner_paye,
                     ,'TAX_CODE_HRX_GB_PAYE'                          -- tax_code_hrx_gb_paye,
                     ,'TAX_BASIS_HRX_GB_PAYE'                         -- tax_basis_hrx_gb_paye,
                     ,'PREVTAXABLEPAY_HRX_GB_PAYE'                    -- prevtaxablepay_hrx_gb_paye,
                     ,'PREVTAXPAID_HRX_GB_PAYE'                       -- prevtaxpaid_hrx_gb_paye,
                     ,'TAXAUTH_HRX_GB_PAYE'                           -- taxauth_hrx_gb_paye,
                     ,'AUTHORITY_DATE_HRX_GB_PAYE'                    -- authority_date_hrx_gb_paye,
                     ,'PENSIONER_HRX_GB_PAYE'                         -- pensioner_hrx_gb_paye,
                     ,'P45_ACTION_HRX_GB_PAYE'                        -- p45_action_hrx_gb_paye,
                     ,'REPORT_NI_YTD_VALUES_HRX_GB_PAYE'              -- report_ni_ytd_values_hrx_gb_paye,
                     ,'EMPLOYMENT_FILED_HMRC_HRX_GB_PAYE'             -- employment_filed_hmrc_hrx_gb_paye,
                     ,'NUMBER_OF_PERIODS_CVD_HRX_GB_PAYE'             -- number_of_periods_cvd_hrx_gb_paye,
                     ,'PREV_HMRC_PAYROLL_ID_HRX_GB_PAYE'              -- prev_hmrc_payroll_id_hrx_gb_paye,
                     ,'SEND_HMRC_PAYROLL_ID_CHG_HRX_GB_PAYE'          -- send_hmrc_payroll_id_chg_hrx_gb_paye,
                     ,'HMRC_PAYROLL_ID_CHG_FILED_HRX_GB_PAYE'         -- hmrc_payroll_id_chg_filed_hrx_gb_paye,
                     ,'EXCLUDE_FROM_AL_HRX_GB_PAYE'                   -- exclude_FROM_al_hrx_gb_paye,
                     ,'DATE_LEFT_REPORTED_HMRC_HRX_GB_PAYE'           -- date_left_reported_hmrc_hrx_gb_paye,
                     ,'CARD_EFF_START_DATE'                           -- card_eff_start_date,
                     ,'PRINT_COMP'                                    -- PRINT_COMP,
                     ,'PRINT_ASSODET'                                 -- PRINT_ASSODET    
                    ,'EBS Assignment Number'
                    ,'Created By'                                    -- created_by       
                     ,'Creation Date'                                 -- creation_date    
                     ,'LastUpdatedBy'                               -- last_updated_by  
                     ,'LastUpdateDate'                              -- last_update_date
               FROM  dual;
               --     
                    gvv_ProgressIndicator := '0070';

                    xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Inserting data into "'||ct_StgTable||'".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               INSERT INTO xxmx_pay_calc_cards_sd_stg
               SELECT pt_i_MigrationSetID                             -- migration_set_id 
                     ,gvt_MigrationSetName                            -- migration_set_name
                     ,'CREATE'                                        -- migration_action  
                     ,'Line'                                          -- headerorline,
                     ,a.dir_card_comp_id                              -- cardcomponent_sourcesystemid,
                     ,vv_cardcomp_sourcesysowner                      -- cardcomponent_sourcesystemowner,
                 --    ,TO_CHAR(b.effective_start_date,'RRRR/MM/DD')    -- effectivestartdate,
                 -- NEEDS to be configured for SMBC
                       ,TO_CHAR(DECODE( a.context_value1,b.ni_catg_scrn_entry_val,a.effective_start_date,b.effective_Start_date)
                             ,'RRRR/MM/DD')                           -- effectivestartdate,
                     ,TO_CHAR(b.effective_end_date,'RRRR/MM/DD')      -- effectiveenddate,
                     ,a.ldg                                           -- legislativedatagroupname,
                 --    ,a.tru                                         -- taxreportingunitname,
                     ,get_fusion_legal_emp(a.assignment_number)       -- taxreportingunitname,          
                     ,a.assignment_number                             -- assignmentnumber,
                     ,a.dir_card_id                                   -- dircardid_sourcesystemid,
                     ,a.component_name                                -- dircardcompdefname_ni,
                     ,b.ni_catg_scrn_entry_val                        -- ni_category,
                     ,b.pens_basis_scrn_entry_val                     -- pension_basis,
                     ,a.dir_comp_detail_id                            -- componentdetail_sourcesystemid_ni,
                     ,vv_compdet_sourcesysowner_ni                    -- componentdetail_sourcesystemowner_ni,
                     ,a.assignment_number||vv_cardassoc_sourcesysid   -- cardassociation_sourcesystemid_ni,
                     ,vv_cardassoc_sourcesysowner                     -- cardassociation_sourcesystemowner_ni,
                     ,a.assignment_number||vv_cardassocdtl_sourcesysid_ni -- cardassocdtl_sourcesystemid_ni,
                     ,vv_cardassoc_sourcesysowner                     -- cardassocdtl_sourcesystemowner_ni,
                     ,NULL                                            -- dircardcompdefname_paye,
                     ,NULL                                            -- componentdetail_sourcesystemid_paye,
                     ,NULL                                            -- componentdetail_sourcesystemowner_hrx_gb_paye,
                     ,NULL                                            -- cardassociation_sourcesystemid_paye,
                     ,NULL                                            -- cardassociation_sourcesystemowner_paye,
                     ,NULL                                            -- cardassocdtl_sourcesystemid_paye,
                     ,NULL                                            -- cardassocdtl_sourcesystemowner_paye,
                     ,NULL                                            -- tax_code_hrx_gb_paye,
                     ,NULL                                            -- tax_basis_hrx_gb_paye,
                     ,NULL                                            -- prevtaxablepay_hrx_gb_paye,
                     ,NULL                                            -- prevtaxpaid_hrx_gb_paye,
                     ,NULL                                            -- taxauth_hrx_gb_paye,
                     ,NULL                                            -- authority_date_hrx_gb_paye,
                     ,NULL                                            -- pensioner_hrx_gb_paye,
                     ,NULL                                            -- p45_action_hrx_gb_paye,
                     ,NULL                                            -- report_ni_ytd_values_hrx_gb_paye,
                     ,NULL                                            -- employment_filed_hmrc_hrx_gb_paye,
                     ,NULL                                            -- number_of_periods_cvd_hrx_gb_paye,
                     ,NULL                                            -- prev_hmrc_payroll_id_hrx_gb_paye,
                     ,NULL                                            -- send_hmrc_payroll_id_chg_hrx_gb_paye,
                     ,NULL                                            -- hmrc_payroll_id_chg_filed_hrx_gb_paye,
                     ,NULL                                            -- exclude_FROM_al_hrx_gb_paye,
                     ,NULL                                            -- date_left_reported_hmrc_hrx_gb_paye,
                    --TO_CHAR(a.effective_start_date,'RRRR/MM/DD') card_eff_start_date,
                    -- Compare the current NI category with Fusion NI category
                    --If both are same the fusion component effective_Start_date is considered.
                    -- Else effective_Start_date from NI Element in EBS is considered. This will cause
                    -- a date effective update in Fusion.
                    --TO_CHAR(DECODE( a.context_value1,b.ni_catg_scrn_entry_val,a.effective_start_date,b.effective_Start_date)
                    --,'RRRR/MM/DD')  card_eff_start_date,
                     ,TO_CHAR(a.effective_start_date,'RRRR/MM/DD')    -- card_eff_start_date,
                     ,'Y'                                             -- print_comp,
                     ,'Y'                                             -- print_asso_det
                     ,xxmx_utilities_pkg.gvv_UserName                 -- created by 
                     ,TO_CHAR(SYSDATE,'RRRR/MM/DD')                   -- creation date
                     ,xxmx_utilities_pkg.gvv_UserName                 -- last updated by
                     ,TO_CHAR(SYSDATE,'RRRR/MM/DD')                   -- last update date
                     ,b.assignment_number
                FROM  xxmx_fusion_calc_card_paye_ni_dtls a
                     ,xxmx_fusion_elem_entry_ni_v       b
               WHERE  a.assignment_number = b.Fusion_asg_number 
                  AND a.component_name = 'NI'
                  AND EXISTS (SELECT 1 
                               FROM xxmx_fusion_elem_entry_paye_v c 
                              WHERE c.assignment_number = b.assignment_number)          
                  AND b.effective_start_date = (SELECT MAX(ni.effective_start_date) 
                                                  FROM xxmx_fusion_elem_entry_ni_v ni
                                                 WHERE b.assignment_number =  ni.assignment_number
                                                   AND ni.effective_start_date <= TO_DATE(gd_migration_date,'RRRR/MM/DD'))
                 AND EXISTS  (Select 1
                                from per_all_assignments_f@mxdm_nvis_extract paaf
                                    ,pay_payrolls_f@mxdm_nvis_extract ppf
                                where TO_DATE(gd_migration_date,'RRRR/MM/DD') between paaf.effective_Start_Date and paaf.effective_end_date                                                        
                                and trunc(sysdate) between ppf.effective_Start_Date and ppf.effective_end_date
                                AND paaf.assignment_number= b.assignment_number
                                and ppf.payroll_id = paaf.payroll_id
                                and PAyroll_name IN( Select parameter_value 
                                                    From xxmx_migration_parameters
                                                    where parameter_code= 'PAYROLL_NAME'
                                                    and enabled_flag = 'Y'))
               UNION ALL
               SELECT pt_i_MigrationSetID                             -- migration_set_id 
                     ,gvt_MigrationSetName                            -- migration_set_name
                     ,'CREATE'                                        -- migration_action  
                     ,'Line'                                          -- headerorline,
                     ,a.dir_card_comp_id                              -- cardcomponent_sourcesystemid,
                     ,vv_cardcomp_sourcesysowner                      -- cardcomponent_sourcesystemowner,
                     ,TO_CHAR(c.effective_start_date,'RRRR/MM/DD')    -- effectivestartdate,
                  -- ,TO_CHAR(c.effective_end_date,'RRRR/MM/DD')      -- effectiveenddate,
                  --  Latest row on component detail must be 4712/12/31
                     ,'4712/12/31'                                    -- effectiveenddate,
                     ,a.ldg                                           -- legislativedatagroupname,
                   --  ,a.tru                                         -- taxreportingunitname,
                     ,get_fusion_legal_emp(a.assignment_number)       -- taxreportingunitname,
                     ,a.assignment_number                             -- assignmentnumber,
                     ,a.dir_card_id                                   -- dircardid_sourcesystemid,
                     ,vv_dircardcompdefname_ni                        -- dircardcompdefname_ni,
                     ,NULL                                            -- ni_category,
                     ,NULL                                            -- pension_basis,
                     ,NULL                                            -- componentdetail_sourcesystemid_ni,
                     ,NULL                                            -- componentdetail_sourcesystemowner_ni,
                     ,NULL                                            -- cardassociation_sourcesystemid_ni,
                     ,NULL                                            -- cardassociation_sourcesystemowner_ni,
                     ,NULL                                            -- cardassocdtl_sourcesystemid_ni,
                     ,NULL                                            -- cardassocdtl_sourcesystemowner_ni,
                     ,a.component_name                                -- dircardcompdefname_paye,
                     ,a.dir_comp_detail_id                            -- componentdetail_sourcesystemid_paye,
                     ,vv_cardcomp_sourcesysowner                      -- componentdetail_sourcesystemowner_hrx_gb_paye,
                     ,a.assignment_number||vv_cardassoc_sourcesysid   -- cardassociation_sourcesystemid_paye,
                     ,vv_cardassoc_sourcesysowner                     -- cardassociation_sourcesystemowner_paye,
                     ,a.assignment_number||vv_cardassocdtl_sourcesysid_paye -- cardassocdtl_sourcesystemid_paye,
                     ,vv_cardassoc_sourcesysowner                     -- cardassocdtl_sourcesystemowner_paye,
                     ,c.paye_taxcode_scrn_entry_val                   -- tax_code_hrx_gb_paye,
                     ,c.paye_taxbasis_scrn_entry_val                  -- tax_basis_hrx_gb_paye,
                     ,c.paye_prevtaxablepay_scrn_entry_val            -- prevtaxablepay_hrx_gb_paye,
                     ,c.paye_prevtaxpaid_scrn_entry_val               -- prevtaxpaid_hrx_gb_paye,
                     ,DECODE(c.paye_taxauth_scrn_entry_val
                                  ,'SOY','P9X'
                                  ,'P46D', 'New Starter Default'
                                  ,c.paye_taxauth_scrn_entry_val
                            )                                         -- taxauth_hrx_gb_paye,
                     ,TO_CHAR(c.effective_start_date,'RRRR/MM/DD')    -- authority_date_hrx_gb_paye,
                     ,'N'                                             -- pensioner_hrx_gb_paye,
                     ,vv_p45_action_hrx_gb_paye                       -- p45_action_hrx_gb_paye,
                     ,'Y'                                             -- report_ni_ytd_values_hrx_gb_paye,
                    /*   ,'Y'                                             -- employment_filed_hmrc_hrx_gb_paye,
                       If RTI Sent Flag = Y, Migrate Y    
                       If RTI Sent Flag = N, Balances exist, Migrate Y
                       If RTI Sent Flag = N, No Balances - Migrate N.
                    */          
                     /*,DECODE(
                             check_rti_sent(c.assignment_number),'Y','Y',
                             DECODE(check_ebs_balances(c.assignment_number),'Y','Y','N')
                            )   */
                     ,'Y'                                             -- employment_filed_hmrc_hrx_gb_paye,
                     ,'1'                                             -- number_of_periods_cvd_hrx_gb_paye,
                     ,c.assignment_number                             -- prev_hmrc_payroll_id_hrx_gb_paye,
                     ,'Y'                                             -- send_hmrc_payroll_id_chg_hrx_gb_paye,
                     ,'N'                                             -- hmrc_payroll_id_chg_filed_hrx_gb_paye,
                     ,'N'                                             -- exclude_FROM_al_hrx_gb_paye,
                     ,(
                       SELECT TO_CHAR(MAX(ppos.actual_termination_date),'RRRR/MM/DD') 
                         FROM apps.PER_PERIODS_OF_SERVICE@mxdm_nvis_extract  ppos
                            , apps.PER_ALL_ASSIGNMENTS_F@mxdm_nvis_extract   paf
                        WHERE ppos.actual_termination_date  > TO_DATE(g_start_of_year,'DD/MM/RRRR') 
                          AND ppos.period_of_service_id     =  paf.period_of_service_id
                          AND ppos.actual_termination_date  IS NOT NULL
                          AND   paf.assignment_number  = c.assignment_number
                          AND paf.organization_id               IS NOT NULL
                          AND ppos.period_of_service_id     = (SELECT MAX(period_of_service_id)
                                                                 FROM apps.per_periods_of_service@mxdm_nvis_extract ppos1
                                                                WHERE ppos.person_id =  ppos1.person_id)
                     )                                                -- date_left_reported_hmrc_hrx_gb_paye,
                     ,TO_CHAR(a.effective_start_date,'RRRR/MM/DD')    --card_eff_start_date,
                     ,'Y'                                             -- print_comp,
                     ,'Y'                                             -- print_asso_det
                     ,xxmx_utilities_pkg.gvv_UserName                 -- created by 
                     ,TO_CHAR(SYSDATE,'RRRR/MM/DD')                   -- creation date
                     ,xxmx_utilities_pkg.gvv_UserName                 -- last updated by
                     ,TO_CHAR(SYSDATE,'RRRR/MM/DD')                   -- last update date
                     ,c.assignment_number
               FROM
                    xxmx_fusion_calc_card_paye_ni_dtls a
                   ,xxmx_fusion_elem_entry_paye_v c
              WHERE a.assignment_number =  c.Fusion_asg_number 
                AND a.component_name IN ('PAYE')
                 AND EXISTS (SELECT 1 
                             FROM xxmx_fusion_elem_entry_ni_v b 
                             WHERE c.assignment_number = b.assignment_number
                            )
                 AND c.effective_start_date = (SELECT MAX(paye.effective_start_date) 
                                                 FROM xxmx_fusion_elem_entry_paye_v paye
                                                WHERE c.assignment_number =  paye.assignment_number
                                                  AND paye.effective_start_date <= TO_DATE(gd_migration_date,'RRRR/MM/DD')
                                               )
                AND EXISTS  (Select 1
                                from per_all_assignments_f@mxdm_nvis_extract paaf
                                    ,pay_payrolls_f@mxdm_nvis_extract ppf
                                where TO_DATE(gd_migration_date,'RRRR/MM/DD') between paaf.effective_Start_Date and paaf.effective_end_date                                                        
                                and trunc(sysdate) between ppf.effective_Start_Date and ppf.effective_end_date
                                AND paaf.assignment_number= c.assignment_number
                                and ppf.payroll_id = paaf.payroll_id
                                and PAyroll_name IN( Select parameter_value 
                                                    From xxmx_migration_parameters
                                                    where parameter_code= 'PAYROLL_NAME'
                                                    and enabled_flag = 'Y'));
         -- call utilities 
                   gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                    (gct_StgSchema,ct_StgTable,pt_i_MigrationSetID);

  /*
     FOR r_sd_card IN (SELECT * FROM xxmx_pay_calc_cards_sd_stg)
     LOOP
     UPDATE xxmx_pay_calc_cards_sd_stg
        SET taxreportingunitname = xxmx_pay_pkg.get_fusion_legal_emp(r_sd_card.assignmentnumber)
      WHERE assignmentnumber = r_sd_card.assignmentnumber;
     END LOOP;
  */
     FOR r_sd_update 
     IN (
         SELECT *
         FROM (
               SELECT a.*
                     ,RANK() OVER
                       ( PARTITION BY 
                             assignmentnumber
                            ,dircardcompdefname_ni
                         ORDER BY
                             effectivestartdate
                       ) rnk
                FROM xxmx_pay_calc_cards_sd_stg a
               WHERE migration_set_id  = pt_i_MigrationSetID  
             )
         WHERE rnk > 1
        ) LOOP
             UPDATE xxmx_pay_calc_cards_sd_stg
                SET print_comp    = 'N',
                    print_assodet = 'N'
              WHERE assignmentnumber      = r_sd_update.assignmentnumber
                AND effectivestartdate    = r_sd_update.effectivestartdate
                AND effectiveenddate      = r_sd_update.effectiveenddate
                AND dircardcompdefname_ni = r_sd_update.dircardcompdefname_ni;
          END LOOP;
     --If tax authority P9X And tax basis =  N Then Tax authority = P6
     --If tax authority is NULL Then  Tax authority = P6
     --If tax authority is P46 and taxcode S% Then Tax authority = P6

    /* UPDATE xxmx_pay_calc_cards_sd_stg
        SET taxauth_hrx_gb_paye = 'P6'
      WHERE migration_set_id  = pt_i_MigrationSetID 
        AND (  (taxauth_hrx_gb_paye = 'P9X' AND tax_basis_hrx_gb_paye = 'N')
               OR ( taxauth_hrx_gb_paye IS NULL)
               OR (taxauth_hrx_gb_paye = 'P46' AND tax_code_hrx_gb_paye LIKE 'S%')
            );*/
     --      
     COMMIT;
     --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extraction complete Rows: '||gvn_RowCount||' inserted'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '080';
               --
               xxmx_utilities_pkg.upd_migration_details
                    (pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gcv_BusinessEntity
                    ,pt_i_SubEntity               => pt_i_SubEntity
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
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => 'END '||cv_ProcOrFuncName||' - Migration Table "'
                                             ||ct_StgTable||'" reporting details updated.'
                    ,pt_i_OracleError       => NULL
                    );
          ELSE
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set not initialized.';
               --
               RAISE e_ModuleError;
          END IF;
          --
          EXCEPTION
               WHEN e_ModuleError THEN
                    --
                    ROLLBACK;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RAISE;
               --** END e_ModuleError Exception
               WHEN OTHERS THEN
                    --
                    ROLLBACK;
                    --
                    gvt_OracleError := SUBSTR(SQLERRM||'** ERROR_BACKTRACE: '
                                           ||dbms_utility.format_error_backtrace,1,4000);
                    --
                    xxmx_utilities_pkg.log_module_message
                         (pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    RAISE;
               --** END OTHERS Exception
          --** END Exception Handler
     END pay_calc_cards_sd_stg;
     --
     --********************************
     --** PROCEDURE: pay_calc_cards_pae_stg
     --********************************
     PROCEDURE pay_calc_cards_pae_stg
                    (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
     IS
          --   -- CALC_CARDS_PAE     pay_calc_cards_pae_stg
          --** CURSOR Declarations
          CURSOR c_pae_leaver_dtls IS
            with pae_cur_row
                as (
                    SELECT
                        paev.assignment_number,
                        paev.effective_start_date,
                        paev.element_name
                    FROM
                        XXMX_PAY_EBS_PAE_DTLS_TEMP paev
                    WHERE
                        UPPER(PAE_QUAL_SCHM_NAME_SCRN_ENTRY_VAL) IN (
                                    Select UPPER(EBS_PENSION) 
                                    from XXMX_CORE.XXMX_PAY_EBS_FUS_PE_PENSCH  
                                    WHERE ENABLED_FLAG= 'Y')
                ) ,
                all_pae_rows as (
                SELECT
                *
                FROM
                xxmx_pay_ebs_pae_all_rows_dtls_v
                )
            SELECT assignment_number,
                    pae_opT_out_dt_scrn_entry_val,
                    TO_CHAR(pae_leave_date,'RRRR/MM/DD') pae_leave_date,
                    TO_CHAR(effective_start_date,'RRRR/MM/DD') effective_start_date
            FROM (
                SELECT assignment_number, 
                DECODE(pae_opt_out_dt_scrn_entry_val
                            ,NULL
                            ,'LEFTSCHEME'
                            ,'OPTOUT' 
                        ) pae_opt_out_dt_scrn_entry_val,
                DECODE(pae_qual_schm_name_scrn_entry_val,
                                    'Pension Smart Pay',
                                    apr.effective_end_date,
                                    'Standard Life',
                                    apr.effective_end_date,
                                    apr.effective_end_date
                ) pae_leave_date,
                apr.effective_start_date
                FROM  all_pae_rows apr
                where effective_Start_date = (SELECT MAX(apr1.effective_Start_date)
                                                FROM all_pae_rows apr1, pae_cur_row pcr
                                                WHERE apr.assignment_number =  apr1.assignment_number
                                                AND apr.element_name =  apr1.element_name
                                                AND apr.assignment_number = pcr.assignment_number
                                                AND   apr.element_name = pcr.element_name 
                                                AND pcr.effective_Start_date > apr1.effective_start_date
                                                AND apr1.effective_start_date < TO_DATE('2019/04/01','RRRR/MM/DD') 
                                                AND   UPPER(pae_qual_schm_name_scrn_entry_val) IN (
                                                                Select UPPER(EBS_PENSION) 
                                                                from XXMX_CORE.XXMX_PAY_EBS_FUS_PE_PENSCH  
                                                                WHERE ENABLED_FLAG= 'Y')
                                            )
                );

          --** END CURSOR << >>
          --          
          --***********************
          --** Constant Declarations
          --***********************
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'pay_calc_cards_pae_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXTRACT';
          ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE := 'xxmx_pay_calc_cards_pae_stg';
          --************************
          --** Variable Declarations
          --***********************
          vd_BeginDate                   DATE;
          --
          vv_compassoc_sourcesysid       VARCHAR2(100)  := 'CompAssoc_PAE_';
          vv_compassoc_sourcesysowner    VARCHAR2(100)  := 'EBS'; 
          vv_compassocdtl_sourcesysid    VARCHAR2(100)  := 'CompAssocDtl_PAE_';  
          vv_compassocdtl_sourcesysowner VARCHAR2(100)  := 'EBS' ;
          vv_information_category        VARCHAR2(100)  := 'ORA_HRX_GB_PAE_ADNL';
          vv_dir_info_category           VARCHAR2(100)  := 'HRX_GB_PAE';
          --*************************
          --** Exception Declarations
          --***********************
          e_ModuleError                   EXCEPTION;
     --** END Declarations
     BEGIN
          gvv_ProgressIndicator := '0010';
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'MODULE'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F' THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'DATA'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F' THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
          END IF;
          --
          gvv_ProgressIndicator := '0030';
          --
          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          gvv_ProgressIndicator := '0040';

          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Get Migration Set Name for  "'||pt_i_MigrationSetID
               ,pt_i_OracleError       => NULL
               );
          --
          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);

          DELETE FROM xxmx_pay_calc_cards_pae_stg;
          --
          IF   gvt_MigrationSetName IS NOT NULL THEN
               --
               gvv_ProgressIndicator := '0050';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Extracting "'||pt_i_SubEntity||'":'
                    ,pt_i_OracleError       => NULL
                    );
               --
               xxmx_utilities_pkg.init_migration_details
                    (pt_i_ApplicationSuite => gct_ApplicationSuite
                    ,pt_i_Application      => gct_Application
                    ,pt_i_BusinessEntity   => gcv_BusinessEntity
                    ,pt_i_SubEntity        => pt_i_SubEntity
                    ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                    ,pt_i_StagingTable     => ct_StgTable
                    ,pt_i_ExtractStartDate => SYSDATE
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Staging Table "'||ct_StgTable||'" reporting details initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
                    gvv_ProgressIndicator := '0060';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extracting Header Record into "'||ct_StgTable||'".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               INSERT INTO   xxmx_pay_calc_cards_pae_stg
               SELECT  pt_i_MigrationSetID               -- migration_set_id  
                     ,'Migration Set Name'              -- migration_set_name 
                     ,'Migration Action'                -- migration_action  
                     ,'Header'                          -- header_or_line
                     ,'CardComponent_SourceSystemId'    -- cardcomponent_sourcesystemid
                     ,'CardComponent_SourceSystemOwner' -- cardcomponent_sourcesystemowner
                     ,'EffectiveStartDate'              -- effectivestartdate
                     ,'EffectiveEndDate'                -- effectiveenddate
                     ,'DirCardCompDefName'              -- dircardcompdefname
                     ,'LegislativeDataGroupName'        -- legislativedatagroupname
                     ,'DirCardId_SourceSystemId'        -- dircardid_sourcesystemid
                     ,'CompAssoc_SourceSystemId'        -- compassoc_sourcesystemid
                     ,'CompAssoc_SourceSystemOwner'     -- compassoc_sourcesystemowner
                     ,'TaxReportingUnitName'            -- taxreportingunitname
                     ,'AssignmentNumber'                -- assignmentnumber
                     ,'CompAssocDtl_SourceSystemId'     -- compassocdtl_sourcesystemid
                     ,'CompAssocDtl_SourceSystemOwner'  -- compassocdtl_sourcesystemowner
                     ,'FLEX_Deduction_Developer_DF'     -- flex_deduction_developer_df
                     ,'EMPLOYEE_CLASSIFICATION'         -- employee_classification
                     ,'ELIGIBLE_JOBHOLDER_DATE'         -- eligible_jobholder_date
                     ,'RE_ENROLMENT_ASSESSMENT_ONLY'    -- re_enrolment_assessment_only
                     ,'CLASSIFICATION_CHANGED_PROC_DT'  -- classification_changed_proc_dt
                     ,'ACTIVE_POSTPONEMENT_TYPE'        -- active_postponement_type
                     ,'ACTIVE_POSTPONEMENT_RULE'        -- active_postponement_rule
                     ,'ACTIVE_POSTPONEMENT_END_DATE'    -- active_postponement_end_date
                     ,'ACTIVE_QUALIFYING_SCHEME'        -- active_qualifying_scheme
                     ,'QUALIFYING_SCHEME_JOIN_DATE'     -- qualifying_scheme_join_date
                     ,'QUALIFYING_SCHEME_START_DATE'    -- qualifying_scheme_start_date
                     ,'QUALIFYING_SCHEME_JOIN_METHOD'   -- qualifying_scheme_join_method
                     ,'TRANSFER_QUALIFYING_SCHEME'      -- transfer_qualifying_scheme
                     ,'QUALIFYING_SCHEME_LEAVE_REASON'  -- qualifying_scheme_leave_reason
                     ,'QUALIFYING_SCHEME_LEAVE_DATE'    -- qualifying_scheme_leave_date
                     ,'OPT_OUT_PERIOD_END_DATE'         -- opt_out_period_end_date
                     ,'OPT_OUT_REFUND_DUE'              -- opt_out_refund_due
                     ,'REASON_FOR_EXCLUSION'            -- reason_for_exclusion
                     ,'OVERRIDING_WORKER_POSTPONEMENT'  -- overriding_worker_postponement
                     ,'OVERRIDING_ELIGIBLEJH_POSTPMNT'  -- overriding_eligiblejh_postpmnt
                     ,'OVERRIDING_QUALIFYING_SCHEME'    -- overriding_qualifying_scheme
                     ,'OVERRIDING_STAGING_DATE'         -- overriding_staging_date
                     ,'LETTER_STATUS'                   -- letter_status
                     ,'LETTER_TYPE_DATE'                -- letter_type_date
                     ,'SUBSEQUENT_COMMS_REQ'            -- subsequent_comms_req
                     ,'LETTER_TYPE_GENERATED'           -- letter_type_generated
                     ,'flex_ora_hrx_gb_pae_adnl'          --flex_ora_hrx_gb_pae_adnl   
                     ,'WULS_TAKEN_DATE'                 -- wuls_taken_date
                     ,'TAX_PROTECTION_APPLIED'          -- tax_protection_applied
                     ,'PROC_AUTO_REENROLMENT_DATE'      -- proc_auto_reenrolment_date
                     ,'flex_ora_hrx_gb_ps_pension'      -- flex_ora_hrx_gb_ps_pension  
                     ,'HISTORIC_PEN_PAYROLL_ID'         -- historic_pen_payroll_id
                     ,'QUALIFYING_SCHEME_ID'            -- qualifying_scheme_id,
                     , 'ebs_asg_number'                --ebs_asg_number
                     ,'Created By'                      -- created_by       
                     ,'Creation Date'                   -- creation_date    
                     ,'Last Updated By'                 -- last_updated_by  
                     ,'LastUpdateDate'               -- last_update_date
                     ,'component_dtl_sourcesystemowner'    -- COMPONENT_DTL_SOURCESYSTEMID 
                     ,'component_dtl_sourcesystemId' -- COMPONENT_DTL_SOURCESYSTEMOWNER 
                 FROM  dual;

                 INSERT INTO XXMX_PAY_EBS_PAE_DTLS_TEMP  Select * from XXMX_PAY_EBS_PAE_DTLS_V;
               --     
                    gvv_ProgressIndicator := '0070';

                    xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Inserting data into "'||ct_StgTable||'".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               INSERT INTO xxmx_pay_calc_cards_pae_stg
               (MIGRATION_SET_ID                     
               , MIGRATION_SET_NAME                  
                ,MIGRATION_ACTION                    
                ,HEADER_OR_LINE                       
                ,SOURCESYSTEMID                       
                ,SOURCESYSTEMOWNER                    
                ,EFFECTIVESTARTDATE                   
                ,EFFECTIVEENDDATE                    
                ,DIRCARDCOMPDEFNAME                  
                ,LEGISLATIVEDATAGROUPNAME             
                ,DIRCARDID_SOURCESYSTEMID             
                ,COMPASSOC_SOURCESYSTEMID             
                ,COMPASSOC_SOURCESYSTEMOWNER          
                ,TAXREPORTINGUNITNAME                 
                ,ASSIGNMENTNUMBER                     
                ,COMPASSOCDTL_SOURCESYSTEMID          
                ,COMPASSOCDTL_SOURCESYSTEMOWNER        
                ,FLEX_HRX_GB_PAE                     
                ,EMPLOYEE_CLASSIFICATION             
                ,ELIGIBLE_JOBHOLDER_DATE             
                ,RE_ENROLMENT_ASSESSMENT_ONLY        
                ,CLASSIFICATION_CHANGED_PROC_DT       
                ,ACTIVE_POSTPONEMENT_TYPE            
                ,ACTIVE_POSTPONEMENT_RULE            
                ,ACTIVE_POSTPONEMENT_END_DATE        
                ,ACTIVE_QUALIFYING_SCHEME            
                ,QUALIFYING_SCHEME_JOIN_DATE         
                ,QUALIFYING_SCHEME_START_DATE        
                ,QUALIFYING_SCHEME_JOIN_METHOD       
                ,TRANSFER_QUALIFYING_SCHEME         
                ,QUALIFYING_SCHEME_LEAVE_REASON     
                ,QUALIFYING_SCHEME_LEAVE_DATE       
                ,OPT_OUT_PERIOD_END_DATE            
                ,OPT_OUT_REFUND_DUE                 
                ,REASON_FOR_EXCLUSION               
                ,OVERRIDING_WORKER_POSTPONEMENT     
                ,OVERRIDING_ELIGIBLEJH_POSTPMNT     
                ,OVERRIDING_QUALIFYING_SCHEME       
                ,OVERRIDING_STAGING_DATE            
                ,LETTER_STATUS                      
                ,LETTER_TYPE_DATE                   
                ,SUBSEQUENT_COMMS_REQ               
                ,LETTER_TYPE_GENERATED              
                ,FLEX_ORA_HRX_GB_PAE_ADNL           
                ,WULS_TAKEN_DATE                    
                ,TAX_PROTECTION_APPLIED             
                ,PROC_AUTO_REENROLMENT_DATE         
                ,FLEX_ORA_HRX_GB_PS_PENSION         
                ,HISTORIC_PEN_PAYROLL_ID            
                ,QUALIFYING_SCHEME_ID               
                ,EBS_ASG_NUMBER                     
                ,CREATED_BY                         
                ,CREATION_DATE                      
                ,LAST_UPDATED_BY                    
                ,LAST_UPDATE_DATE                   
                ,COMPONENT_DTL_SOURCESYSTEMOWNER    
                ,COMPONENT_DTL_SOURCESYSTEMID       )
               SELECT  pt_i_MigrationSetID                                      -- migration_set_id 
                      ,gvt_MigrationSetName                                     -- migration_set_name
                      ,'CREATE'                                                 -- migration_action  
                      ,'Line'                                                    -- header_or_line,
                      ,fus_pae_card.source_system_id_card_comp                  -- cardcomponent_sourcesystemid,
                      ,fus_pae_card.source_system_owner_card_comp               -- cardcomponent_sourcesystemowner,
                      ,TO_CHAR(fus_pae_card.effective_start_date,'RRRR/MM/DD')  -- effectivestartdate,  DECIDE FUSION/EE START DATE
                      ,TO_CHAR(fus_pae_card.effective_end_date,'RRRR/MM/DD')    -- effectiveenddate,  DECIDE FUSION/EE END DATE 
                      ,fus_pae_card.display_name                                -- dircardcompdefname,
                      ,fus_pae_card.ldg                                         -- legislativedatagroupname,
                      ,fus_pae_card.dir_card_id                                 -- dircardid_sourcesystemid,
                      ,vv_compassoc_sourcesysid||fus_pae_card.assignment_number -- compassoc_sourcesystemid,
                      ,vv_compassoc_sourcesysowner                              -- compassoc_sourcesystemowner,
                      ,get_fusion_legal_emp(fus_pae_card.assignment_number)     -- taxreportingunitname,
                      ,fus_pae_card.assignment_number                           -- assignmentnumber,
                      ,vv_compassocdtl_sourcesysid||fus_pae_card.assignment_number     -- compassocdtl_sourcesystemid,
                      ,vv_compassocdtl_sourcesysowner                           -- compassocdtl_sourcesystemowner,
                      ,fus_pae_card.dir_information_category                    -- flex_deduction_developer_df,
                      ,CASE
                         WHEN ebs_pae_dtls.pae_pens_class_SCRN_ENTRY_VAL = 'WORKER'                  THEN  'WORKER'
                         WHEN ebs_pae_dtls.pae_pens_class_SCRN_ENTRY_VAL = 'NON ELIGIBLE JOB HOLDER' THEN 'NONELIGIBLEJH'
                         WHEN ebs_pae_dtls.pae_pens_class_SCRN_ENTRY_VAL =  'ELIGIBLE JOB HOLDER'    THEN 'ELIGIBLEJH'
                         ELSE 'NOTASSESSED'
                         END                                                    -- employee_classification,
                           -- If Employee Classified as ELIGIBLE JOB HOLDER, Then consider 
                         -- Eligible job holder date from EBS
                      ,CASE
                        WHEN ebs_pae_dtls.pae_pens_class_SCRN_ENTRY_VAL =  'ELIGIBLE JOB HOLDER' 
                        THEN SUBSTR(ebs_pae_dtls.pae_elij_job_hold_dt_SCRN_ENTRY_VAL,1,10) 
                        ELSE NULL
                        END                                                            -- eligible_jobholder_date,        
                      ,NULL                                                     -- re_enrolment_assessment_only,
                      ,TO_CHAR(ebs_pae_dtls.effective_start_date,'RRRR/MM/DD')  -- classification_changed_proc_dt,
                     -- Where there is a value for Qualifying scheme name exist in EBS, migrate as NULL
                     -- Postpone type in EBS is 'ELIGIBLE JOB HOLDER DEFERMENT' THEN 'ELIGIBLEJH'
                     -- Else NONE
                     -- Does not make sense to me now commented out for now.
                      ,CASE 
                  --     WHEN ebs_pae_dtls.pae_qual_schm_name_scrn_entry_val IS NOT NULL THEN NULL
                         WHEN ebs_pae_dtls.pae_postpn_type_SCRN_ENTRY_VAL = 'ELIGIBLE JOB HOLDER DEFERMENT' THEN 'ELIGIBLEJH'
                         WHEN ebs_pae_dtls.pae_postpn_type_SCRN_ENTRY_VAL = 'DB SCHEME DEFERMENT' THEN 'DBSCHEME'
                         WHEN ebs_pae_dtls.pae_postpn_type_SCRN_ENTRY_VAL = 'WORKER DEFERMENT' THEN 'WORKER'
                         ELSE 'NONE'
                       END                                                      -- active_postponement_type,                             
                    -- Where there is a value for Qualifying scheme name exist in EBS, migrate as NULL
                    -- Postpone Type in EBS IS NOT NULL THEN 'ELIGIBLEJH'
                    -- Else NULL
                    -- Does not make sense to me now commented out for now.
                      ,CASE
                      --   WHEN ebs_pae_dtls.pae_qual_schm_name_scrn_entry_val IS NOT NULL THEN NULL 
                         WHEN ebs_pae_dtls.pae_postpn_type_SCRN_ENTRY_VAL <> ' ' THEN 'MAX'
                         ELSE NULL
                       END                                                      -- active_postponement_rule,                              
                     -- Where there is a value for Qualifying scheme name exist in EBS, migrate as NULL
                    -- Else postponement end date
                      ,CASE
                         WHEN ebs_pae_dtls.pae_qual_schm_name_SCRN_ENTRY_VAL IS NOT NULL THEN NULL
                         ELSE SUBSTR(ebs_pae_dtls.pae_postpn_end_dt_SCRN_ENTRY_VAL,1,10) 
                         END                                                    -- active_postponement_end_date,
                    -- Qualifying scheme name will be Pension Element Type ID from Fusion
                    -- Review this for each iteration
                    ,/*( Select to_CHAR(FUSION_PENSION_SCHEME_ID ) from XXMX_CORE.XXMX_PAY_EBS_FUSION_PENSION_SCHEME 
                        WHERE UPPER(EBS_PENSION) = UPPER(ebs_pae_dtls.pae_qual_schm_name_SCRN_ENTRY_VAL)
                        AND ENABLED_FLAG= 'Y') */
                        (Select distinct to_CHAR(FUSION_PENSION_SCHEME_ID ) from XXMX_CORE.XXMX_PAY_EBS_FUS_PE_PENSCH  PEN ,xxmx_per_assignments_m_stg ASG
                        WHERE UPPER(EBS_PENSION) = UPPER(ebs_pae_dtls.pae_qual_schm_name_SCRN_ENTRY_VAL)
                        AND ENABLED_FLAG= 'Y'
                        AND asg.Assignment_number = fus_pae_card.ASSIGNMENT_NUMBER
                        AND ACTION_CODE IN ('CURRENT','ADD_ASSIGN')
                        AND asg.PAYROLLNAME= NVL( PEN.Payroll_name ,asg.PAYROLLNAME))-- active_qualifying_scheme,
                    -- If the Optin date is not available in EBS
                    -- Get the Pension element entry start date
                      --,NVL(to_char(ebs_pae_dtls.pae_opt_in_dt ,'RRRR/MM/DD') ,SUBSTR(ebs_pae_dtls.pae_elij_job_hold_dt,1,10)) -- qualifying_scheme_join_date,
                      ,NVL(ebs_pae_dtls.pae_opt_in_dt_SCRN_ENTRY_VAL ,  SUBSTR(ebs_pae_dtls.pae_elij_job_hold_dt_SCRN_ENTRY_VAL,1,10))  qualifying_scheme_join_date
                      ,NULL                                                     -- qualifying_scheme_start_date, 
                                --Defaulted to OPTIN. Will be upadted as per Petrofac inputs.          
                      ,DECODE(ebs_pae_dtls.PAE_QUAL_SCHM_NAME_SCRN_ENTRY_VAL, NULL,
                              NULL,
                              'AUTOENROL'
                             )                                                  -- qualifying_scheme_join_method,
                      ,NULL                                                     -- transfer_qualifying_scheme,
                      ,NULL                                                     -- qualifying_scheme_leave_reason, 
                      ,NULL                                                     -- qualifying_scheme_leave_date, 
                      ,SUBSTR(ebs_pae_dtls.PAE_OPT_OUT_DT_SCRN_ENTRY_VAL,1,10)  -- opt_out_period_end_date,
                      ,'N'                                                      -- opt_out_refund_due,
                      ,(SELECT 'ORA_HRX_GB_TAXPROTECTED'
                          FROM xxmx_ebs_pae_exclusion_list_emp pea_exclusion
                         WHERE pea_exclusion.person_number = fus_pae_card.payroll_relationship_number
                       )                                                        -- reason_for_exclusion,   EBS_PAE_DTLS.PAE_EXCLUSION_RSN_SCRN_ENTRY_VAL 
                      ,NULL                                                     -- overriding_worker_postponement,
                      ,NULL                                                     -- overriding_eligiblejh_postpmnt,
                      ,NULL                                                     -- overriding_qualifying_scheme,
                      ,NULL                                                     -- overriding_staging_date,
                      ,'ORA_HRX_GB_LET_GENERATED'                               -- letter_status,
                      ,TO_CHAR(ebs_pae_dtls.effective_start_date,'RRRR/MM/DD')  -- letter_type_date,
                      ,NULL                                                     -- subsequent_comms_req,
                      ,NULL                                                     -- letter_type_generated, 
                      ,NULL                                                     --flex_ora_hrx_gb_pae_adnl   
                      ,NULL                                                     -- wuls_taken_date, 
                      ,NULL                                                     -- tax_protection_applied, 
                      ,NULL                                                     -- proc_auto_reenrolment_date,
                      ,NULL                                                     -- flex_ora_hrx_gb_ps_pension
                      ,NULL                                                     -- historic_pen_payroll_id,  
                      ,(SELECT bpcard.dir_card_comp_id
                          FROM xxmx_fusion_calc_card_bp_dtls bpcard
                         WHERE bpcard.assignment_number = fus_pae_card.assignment_number
                           AND bpcard.card_comp_effective_start_date =  (
                                                                         SELECT MAX(card_comp_effective_start_date)
                                                                         FROM xxmx_fusion_calc_card_bp_dtls bpcard1
                                                                         WHERE bpcard.dir_card_comp_id =  bpcard1.dir_card_comp_id
                                                                        )
                       )                                                       -- dir_card_comp_id,
                      ,to_CHAR(ebs_pae_dtls.assignment_number)
                      ,xxmx_utilities_pkg.gvv_UserName            -- created by 
                      ,TO_CHAR(SYSDATE,'RRRR/MM/DD')              -- creation date
                      ,xxmx_utilities_pkg.gvv_UserName            -- last updated by
                      ,TO_CHAR(SYSDATE,'RRRR/MM/DD')              -- last update date
                      ,fus_pae_card.SOURCE_SYSTEM_OWNER_CARD_COMP_DTLS
                      ,to_char(fus_pae_card.SOURCE_SYSTEM_ID_CARD_COMP_DTLS)
                FROM   xxmx_fusion_calc_card_pae_dtls     fus_pae_card,
                       XXMX_PAY_EBS_PAE_DTLS_TEMP           ebs_pae_dtls
               WHERE   fus_pae_card.assignment_number ='E'||ebs_pae_dtls.assignment_number 
               AND     fus_pae_card.dir_information_category = vv_dir_info_category
               AND      ebs_pae_dtls.pae_qual_schm_name_SCRN_ENTRY_VAL is not null
               AND     ebs_pae_dtls.effective_start_date IN( SELECT MAX(effective_start_date)
                                                            FROM XXMX_PAY_EBS_PAE_DTLS_TEMP ebs1
                                                            WHERE fus_pae_card.assignment_number = 'E'||ebs1.assignment_number 
                                                            )
               AND EXISTS (Select 1
                                from per_all_assignments_f@mxdm_nvis_extract paaf
                                    ,pay_payrolls_f@mxdm_nvis_extract ppf
                                where TO_DATE(gd_migration_date,'RRRR/MM/DD') between paaf.effective_Start_Date and paaf.effective_end_date                                                        
                                and trunc(sysdate) between ppf.effective_Start_Date and ppf.effective_end_date
                                AND paaf.assignment_number= ebs_pae_dtls.assignment_number
                                and ppf.payroll_id = paaf.payroll_id
                                and PAyroll_name IN( Select parameter_value 
                                                    From xxmx_migration_parameters
                                                    where parameter_code= 'PAYROLL_NAME'
                                                    and enabled_flag = 'Y'))
             UNION ALL
               SELECT  pt_i_MigrationSetID                                      -- migration_set_id 
                      ,gvt_MigrationSetName                                     -- migration_set_name
                      ,'CREATE'                                                 -- migration_action  
                      ,'Line'                                                   -- header_or_line,
                      ,fus_pae_card.source_system_id_card_comp                  -- cardcomponent_sourcesystemid,
                      ,fus_pae_card.source_system_owner_card_comp               -- cardcomponent_sourcesystemowner,
                      ,TO_CHAR(fus_pae_card.effective_start_date,'RRRR/MM/DD')  -- effectivestartdate, DECIDE FUSION/EE START DATE
                      ,TO_CHAR(fus_pae_card.effective_end_date,'RRRR/MM/DD')    -- effectiveenddate,  DECIDE FUSION/EE END DATE
                      ,fus_pae_card.display_name                                -- dircardcompdefname,
                      ,fus_pae_card.ldg                                         -- legislativedatagroupname,
                      ,fus_pae_card.dir_card_id                                 -- dircardid_sourcesystemid,
                      ,vv_compassoc_sourcesysid||fus_pae_card.assignment_number -- compassoc_sourcesystemid,
                      ,vv_compassoc_sourcesysowner                              -- compassoc_sourcesystemowner,
                      ,get_fusion_legal_emp(fus_pae_card.assignment_number)    -- taxreportingunitname,
                      ,fus_pae_card.assignment_number                           -- assignmentnumber,
                      ,vv_compassocdtl_sourcesysid||fus_pae_card.assignment_number     -- compassocdtl_sourcesystemid,
                      ,vv_compassocdtl_sourcesysowner                           -- compassocdtl_sourcesystemowner,
                      ,fus_pae_card.dir_information_category                    -- flex_deduction_developer_df,
                      ,NULL                                                     -- employee_classification, COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- eligible_jobholder_date,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG
                      ,NULL                                                     -- re_enrolment_assessment_only,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- classification_changed_proc_dt,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- active_postponement_type,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- active_postponement_rule,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- active_postponement_end_date,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- active_qualifying_scheme,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- qualifying_scheme_join_date,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- qualifying_scheme_start_date,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- qualifying_scheme_join_method,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- transfer_qualifying_scheme,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- qualifying_scheme_leave_reason,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- qualifying_scheme_leave_date,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- opt_out_period_end_date,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- opt_out_refund_due,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- reason_for_exclusion, COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- overriding_worker_postponement,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- overriding_eligiblejh_postpmnt,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- overriding_qualifying_scheme, COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- overriding_staging_date,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- letter_status,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- letter_type_date,   COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- subsequent_comms_req,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- letter_type_generated,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     --flex_ora_hrx_gb_pae_adnl   
                      ,NULL                                                     -- wuls_taken_date,  COLUMNS APPLICABLE FOR ORA_HRX_GB_PAE_ADNL INFO CATEG 
                      ,NULL                                                      -- tax_protection_applied,  COLUMNS APPLICABLE FOR ORA_HRX_GB_PAE_ADNL INFO CATEG 
                      ,NULL                                                     -- proc_auto_reenrolment_date,  COLUMNS APPLICABLE FOR ORA_HRX_GB_PAE_ADNL INFO CATEG 
                      ,NULL                                                     -- flex_ora_hrx_gb_ps_pension  
                      ,NULL                                                     -- historic_pen_payroll_id,   COLUMNS APPLICABLE FOR ORA_HRX_GB_PS_PENSION INFO CATEG 
                      ,NULL                                       -- dir_card_comp_id,
                      ,to_CHAR(ebs_pae_dtls.assignment_number )
                      ,xxmx_utilities_pkg.gvv_UserName            -- created by 
                      ,TO_CHAR(SYSDATE,'RRRR/MM/DD')              -- creation date
                      ,xxmx_utilities_pkg.gvv_UserName            -- last updated by
                      ,TO_CHAR(SYSDATE,'RRRR/MM/DD')              -- last update date
                      ,fus_pae_card.SOURCE_SYSTEM_OWNER_CARD_COMP_DTLS
                      ,to_char(fus_pae_card.SOURCE_SYSTEM_ID_CARD_COMP_DTLS)
               FROM   xxmx_fusion_calc_card_pae_dtls fus_pae_card,
                   XXMX_PAY_EBS_PAE_DTLS_TEMP           ebs_pae_dtls
               WHERE   fus_pae_card.assignment_number ='E'||ebs_pae_dtls.assignment_number 
                 AND  fus_pae_card.dir_information_category = vv_information_category
                 AND      ebs_pae_dtls.pae_qual_schm_name_SCRN_ENTRY_VAL is not null
                 AND     ebs_pae_dtls.effective_start_date IN( SELECT MAX(effective_start_date)
                                                            FROM XXMX_PAY_EBS_PAE_DTLS_TEMP ebs1
                                                            WHERE fus_pae_card.assignment_number = 'E'||ebs1.assignment_number 
                                                            )
                 AND EXISTS  (Select 1
                                from per_all_assignments_f@mxdm_nvis_extract paaf
                                    ,pay_payrolls_f@mxdm_nvis_extract ppf
                                where TO_DATE(gd_migration_date,'RRRR/MM/DD') between paaf.effective_Start_Date and paaf.effective_end_date                                                        
                                and trunc(sysdate) between ppf.effective_Start_Date and ppf.effective_end_date
                                AND paaf.assignment_number= ebs_pae_dtls.assignment_number
                                and ppf.payroll_id = paaf.payroll_id
                                and PAyroll_name IN( Select parameter_value 
                                                    From xxmx_migration_parameters
                                                    where parameter_code= 'PAYROLL_NAME'
                                                    and enabled_flag = 'Y'));
               /*  AND EXISTS (SELECT 1 
                               FROM xxmx_ebs_pae_exclusion_list_emp pea_exclusion
                                    ,xxmx_fusion_workers pfw
                              WHERE pea_exclusion.person_number  = pfw.person_number
                                AND pfw.assignment_number        = fus_pae_card.assignment_number
                             )*/

               -- call utilities 
                   gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                    (gct_StgSchema,ct_StgTable,pt_i_MigrationSetID);
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Inserted Rows: '||gvn_RowCount||' inserted'
                    ,pt_i_OracleError       => NULL
                    );                                         
               --
               gvv_ProgressIndicator := '0080';
               --              

               FOR r_pae_leaver_dtls IN c_pae_leaver_dtls
               LOOP

                    UPDATE xxmx_pay_calc_cards_pae_stg
                        SET 
                            qualifying_scheme_leave_reason   =to_Char( r_pae_leaver_dtls.pae_opT_out_dt_scrn_entry_val),
                            qualifying_scheme_leave_date     = to_char(r_pae_leaver_dtls.pae_leave_date),
                            qualifying_scheme_start_date     = to_char( r_pae_leaver_dtls.effective_Start_date)
                      WHERE migration_set_id            = pt_i_MigrationSetID                                     
                        AND flex_hrx_gb_pae             = vv_dir_info_category
                        AND ebs_asg_number            = r_pae_leaver_dtls.assignment_number;
               END LOOP;
                   -- call utilities 
                   gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                    (gct_StgSchema,ct_StgTable,pt_i_MigrationSetID);
               --
               UPDATE xxmx_pay_calc_cards_pae_stg
                  SET active_postponement_rule = 'NONE'
                WHERE active_postponement_type = 'NONE'
                  AND migration_set_id         = pt_i_MigrationSetID;
               --     
               UPDATE xxmx_pay_calc_cards_pae_stg
                  SET active_postponement_end_date = NULL
                WHERE active_postponement_rule     = 'MAX'
                  AND migration_set_id             = pt_i_MigrationSetID;
               --
               UPDATE xxmx_pay_calc_cards_pae_stg
                  SET qualifying_scheme_join_method = 'OPTIN'
                WHERE employee_classification       <> 'ELIGIBLEJH'
                  AND migration_set_id              = pt_i_MigrationSetID;
               --
               UPDATE xxmx_pay_calc_cards_pae_stg
                  SET qualifying_scheme_join_method = NULL
                WHERE employee_classification       = 'NOTASSESSED'
                  AND migration_set_id              = pt_i_MigrationSetID;
               --
               COMMIT;
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extraction Rows: '||gvn_RowCount||' Updated'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '090';
               --
               xxmx_utilities_pkg.upd_migration_details
                    (pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gcv_BusinessEntity
                    ,pt_i_SubEntity               => pt_i_SubEntity
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
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => 'END '||cv_ProcOrFuncName||' - Migration Table "'||ct_StgTable||'" completed.'
                    ,pt_i_OracleError       => NULL
                    );
          ELSE
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set not initialized.';
               --
               RAISE e_ModuleError;
          END IF;
          --
          EXCEPTION
               WHEN e_ModuleError THEN
                    --
                    ROLLBACK;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RAISE;
                    --
               --** END e_ModuleError Exception
               WHEN OTHERS THEN
                    --
                    ROLLBACK;
                    --
                    gvt_OracleError := SUBSTR(SQLERRM||'** ERROR_BACKTRACE: '
                                           ||dbms_utility.format_error_backtrace,1,4000);
                    --
                    xxmx_utilities_pkg.log_module_message
                         (pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    RAISE;
               --** END OTHERS Exception
          --** END Exception Handler
     END pay_calc_cards_pae_stg;
     --
     --********************************
     --** PROCEDURE: pay_calc_cards_bp_stg
     --********************************
     PROCEDURE pay_calc_cards_bp_stg
                    (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
     IS
     -- CALC_CARDS_BP     pay_calc_cards_bp_stg
          --*********************
          --** CURSOR Declarations
          --***********************
        CURSOR c_bp_card_details IS 
            SELECT    Fusion_asg_number
                         ,MIN(effective_start_date)  effective_start_date
                         ,effective_end_date
                         ,calc_card_comp
                         ,ee_pct
                         ,er_pct
                         ,flat_er_amount
                         ,flat_ee_amount
              FROM
                  (SELECT distinct Fusion_asg_number
                      --   ,input_value_name
                         ,Fusion_input_value
                         ,effective_start_date
                         ,effective_end_date
                         ,calc_card_comp
                         ,screen_entry_value
                    FROM  XXMX_PAY_EBS_ELEM_ENTRY_VALS_V1 ele,
                          XXMX_PAY_BP_Calc_Card_Map bp_map
                    WHERE  ele.element_name= bp_map.ebs_element
                    AND  ele.input_value_name = bp_map.ebs_input_value
                    and Fusion_input_value IN( 'Percentage for Employee Contribution','Flat Amount for Employer Contribution',
                                                'Flat Amount for Employee Contribution')
                    --and screen_entry_value is not null
                    and bp_map.payroll_name is null
                    AND EXISTS (SELECT 1
                                FROM xxmx_per_assignments_m_xfm asg
                                WHERE ele.assignment_number = SUBSTR(asg.assignment_number ,2,LENGTH(asg.assignment_number))
                                )
                    and (
                    --ele.effective_Start_Date BETWEEN ADD_MONTHS(TO_DATE(g_start_of_year,'DD/MM/RRRR') ,-12) and  TO_DATE(g_cutoff_date,'DD/MM/RRRR') 
                    --or
                    Trunc(Sysdate) between ele.effective_Start_Date and ele.effective_end_date)
                    AND EXISTS  (Select 1
                                from per_all_assignments_f@mxdm_nvis_extract paaf
                                    ,pay_payrolls_f@mxdm_nvis_extract ppf
                                where TO_DATE(gd_migration_date,'RRRR/MM/DD') between paaf.effective_Start_Date and paaf.effective_end_date                                                        
                                and trunc(sysdate) between ppf.effective_Start_Date and ppf.effective_end_date
                                AND paaf.assignment_number = ele.assignment_number
                                and ppf.payroll_id = paaf.payroll_id
                                and ppf.PAyroll_name IN( Select parameter_value 
                                                    From xxmx_migration_parameters
                                                    where parameter_code= 'PAYROLL_NAME'
                                                    and enabled_flag = 'Y')
                                )
                     )
                      PIVOT ( MAX ( screen_entry_value )
                     FOR Fusion_input_value IN ( 'Percentage for Employee Contribution' AS ee_pct,'ER PerCent' AS er_pct ,'Flat Amount for Employer Contribution' AS flat_er_amount,'Flat Amount for Employee Contribution' AS flat_ee_amount)
                   )
                   GROUP BY Fusion_asg_number
                         ,effective_end_date
                         ,calc_card_comp
                         ,ee_pct
                         ,er_pct
                         ,flat_er_amount
                         ,flat_ee_amount

            UNION 
            SELECT    Fusion_asg_number
                         ,effective_start_date
                         ,effective_end_date
                         ,calc_card_comp
                         ,ee_pct
                         ,er_pct
                         ,flat_er_amount
                         ,flat_ee_amount
              FROM
                  (SELECT distinct Fusion_asg_number
                        -- ,input_value_name
                         ,Fusion_input_value
                         ,effective_start_date
                         ,effective_end_date
                         ,calc_card_comp
                         ,screen_entry_value
                    FROM  XXMX_PAY_EBS_ELEM_ENTRY_VALS_V1 ele,
                          XXMX_PAY_BP_Calc_Card_Map bp_map
                    WHERE  ele.element_name= bp_map.ebs_element
                    AND  ele.input_value_name = bp_map.ebs_input_value
                    and Fusion_input_value IN( 'Percentage for Employee Contribution','Flat Amount for Employer Contribution',
                                                'Flat Amount for Employee Contribution')
                   -- and screen_entry_value is not null
                    and bp_map.payroll_name is not null
                    and (
                    --ele.effective_Start_Date BETWEEN ADD_MONTHS(TO_DATE(g_start_of_year,'DD/MM/RRRR') ,-12) and  TO_DATE(g_cutoff_date,'DD/MM/RRRR') 
                    --or
                    Trunc(Sysdate) between ele.effective_Start_Date and ele.effective_end_date)
                    AND EXISTS  (Select 1
                                from per_all_assignments_f@mxdm_nvis_extract paaf
                                    ,pay_payrolls_f@mxdm_nvis_extract ppf
                                where TO_DATE(gd_migration_date,'RRRR/MM/DD') between paaf.effective_Start_Date and paaf.effective_end_date                                                        
                                and trunc(sysdate) between ppf.effective_Start_Date and ppf.effective_end_date
                                AND paaf.assignment_number = ele.assignment_number
                                and ppf.payroll_id = paaf.payroll_id
                                and ppf.PAyroll_name IN( Select parameter_value 
                                                    From xxmx_migration_parameters
                                                    where parameter_code= 'PAYROLL_NAME'
                                                    and enabled_flag = 'Y')
                            )
                    AND EXISTS (SELECT 1
                                FROM xxmx_per_assignments_m_xfm asg
                                WHERE ele.assignment_number = SUBSTR(asg.assignment_number ,2,LENGTH(asg.assignment_number))
                                )
                    AND Exists (select 1
                                from per_all_Assignments_f@MXDM_NVIS_EXTRACT paaf, pay_payrolls_f@MXDM_NVIS_EXTRACT ppf
                                where  ppf.payroll_id = paaf.payroll_id 
                                AND paaf.assignment_number = ele.assignment_number
                                and Trunc(sysdate) between paaf.effective_start_Date and paaf.effective_end_Date 
                                and  Trunc(sysdate) between ppf.effective_start_Date and ppf.effective_end_Date
                                And UPPER(ppf.payroll_name)IN( Select DISTINCT UPPER(''''||REPLACE(REPLACE(TRIM(PAYROLL_NAME),'''','''''') ,',',''',''')||'''') 
                                                     from XXMX_PAY_BP_Calc_Card_Map
                                                     where payroll_name is not null
                                                     )
                                )
                    )
                      PIVOT ( MAX ( screen_entry_value )
                     FOR Fusion_input_value IN ( 'Percentage for Employee Contribution' AS ee_pct,'ER PerCent' AS er_pct ,'Flat Amount for Employer Contribution' AS flat_er_amount,'Flat Amount for Employee Contribution' AS flat_ee_amount)
                   )

                ;

       /*   WITH bpcard AS (
          SELECT    *
              FROM
                  (SELECT element_name
                         ,assignment_number
                         ,input_value_name
                         ,effective_start_date
                         ,effective_end_date
                         ,screen_entry_value
                    FROM  XXMX_PAY_EBS_ELEM_ENTRY_VALS_V
                   WHERE  element_name = 'PFCUK Standard Life Pension'
                     AND  input_value_name IN ('ER PerCent','EE PerCent')
                  )
             PIVOT ( MAX ( screen_entry_value )
                     FOR input_value_name IN ( 'EE PerCent' AS ee_pct,'ER PerCent' AS er_pct )
                   )
          UNION 
          SELECT    *
              FROM 
                  ( SELECT element_name
                          ,assignment_number
                          ,input_value_name
                          ,effective_start_date
                          ,effective_end_date
                          ,screen_entry_value
                     FROM XXMX_PAY_EBS_ELEM_ENTRY_VALS_V
                    WHERE element_name =  'PFCUK Pension Smart Pay'
                      AND input_value_name IN ('Employee Pension Smart Pay Percent','Employer Percent')
                  )
                   PIVOT ( MAX ( screen_entry_value )
                     FOR input_value_name IN ( 'Employee Pension Smart Pay Percent' AS ee_pct,'Employer Percent' AS er_pct )
                         )
               )
                SELECT   bpcard.element_name,
                         bpcard.assignment_number,           
                         LEAST(bpcard.effective_start_date,
                         TO_DATE(NVL(substr(ebs_pae_dtls.pae_opt_in_dt_scrn_entry_val,1,10),'4712/12/31'),'RRRR/MM/DD')
               ) effective_start_date,          
            bpcard.effective_end_date,
            bpcard.ee_pct,
            bpcard.er_pct
          FROM bpcard,
               xxmx_pay_ebs_pae_dtls_v ebs_pae_dtls
         WHERE ebs_pae_dtls.assignment_number = bpcard.assignment_number;*/
          --** END CURSOR << >>
          --***********************
          --** Constant Declarations
          --***********************
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'pay_calc_cards_bp_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXTRACT';
          ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE := 'xxmx_pay_calc_cards_bp_stg';
          --************************
          --** Variable Declarations
          --***********************
          vd_BeginDate                   DATE;
          --*************************
          --** Exception Declarations
          --***********************
          e_ModuleError                   EXCEPTION;
     --** END Declarations
     BEGIN
          gvv_ProgressIndicator := '0010';
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'MODULE'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F' THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'DATA'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F' THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
          END IF;
          --
          gvv_ProgressIndicator := '0030';
          --
          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          gvv_ProgressIndicator := '0040';

           xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Get Migration Set Name for  "'||pt_i_MigrationSetID
               ,pt_i_OracleError       => NULL
               );
          --
          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
          --
          IF   gvt_MigrationSetName IS NOT NULL THEN
               --
               gvv_ProgressIndicator := '0050';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Extracting "'||pt_i_SubEntity||'":'
                    ,pt_i_OracleError       => NULL
                    );
               --
               xxmx_utilities_pkg.init_migration_details
                    (pt_i_ApplicationSuite => gct_ApplicationSuite
                    ,pt_i_Application      => gct_Application
                    ,pt_i_BusinessEntity   => gcv_BusinessEntity
                    ,pt_i_SubEntity        => pt_i_SubEntity
                    ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                    ,pt_i_StagingTable     => ct_StgTable
                    ,pt_i_ExtractStartDate => SYSDATE
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Staging Table "'||ct_StgTable||'" reporting details initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
                    gvv_ProgressIndicator := '0060';

                   Delete from XXMX_PAY_CALC_CARDS_BP_STG;
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extracting Header Record into "'||ct_StgTable||'".'
                    ,pt_i_OracleError       => NULL
                    );
               --
                INSERT INTO xxmx_stg.xxmx_pay_calc_cards_bp_stg 
                            (migration_set_id  
                            ,migration_set_name 
                            ,migration_action  
                            ,header_line
                            ,effectivestartdate
                            ,effectiveenddate
                            ,dircarddefinitionname
                            ,legislativedatagroupname
                            ,assignmentnumber
                            ,dircardcompdefname
                            ,ee_pct
                            ,er_pct
                            ,flat_er_amt
                            ,flat_ee_amt
                            ,created_by
                            ,creation_date
                            ,last_updated_by
                            ,last_update_date
                            ,ebs_asg_number
                            ,taxreportingunitname
                            -- Pradeep code starts
                            ,AAT_ATTRIBUTE1
                            ,AAT_ATTRIBUTE5
                            -- Pradeep code ends
                            )
                    SELECT   pt_i_MigrationSetID                            -- migration_set_id  
                            ,'Migration Set Name'                            -- migration_set_name 
                            ,'Migration Action'                              -- migration_action  
                            ,'Header'
                            ,'EffectiveStartDate'
                            ,'EffectiveEndDate'
                            ,'DirCardDefinitionName'
                            ,'LegislativeDataGroupName'
                            ,'AssignmentNumber'
                            ,'DirCardCompDefName'
                            ,'EE_PCT'
                            ,'ER_PCT'
                            ,'FLAT_ER_AMT'
                            ,'FLAT_EE_AMT'
                            ,'Created By'                                    -- created_by       
                            ,'Creation Date'                                 -- creation_date    
                            ,'LastUpdatedBy'                               -- last_updated_by  
                            ,'LastUpdateDate'                             -- last_update_date
                            ,'EBS_Assignment_Id'
                            ,'TaxReportingUnitName'
                            -- Pradeep code starts
							,'AAT_ATTRIBUTE1'
							,'AAT_ATTRIBUTE5'
                            -- Pradeep code ends
                      FROM    dual;
               --     
               gvv_ProgressIndicator := '0070';

               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Inserting data into "'||ct_StgTable||'".'
                    ,pt_i_OracleError       => NULL
                    );
               --                     
               FOR r_bp_card_details IN c_bp_card_details
               LOOP
                 INSERT INTO xxmx_pay_calc_cards_bp_stg 
                            (migration_set_id  
                            ,migration_set_name 
                            ,migration_action  
                            ,header_line
                            ,effectivestartdate
                            ,effectiveenddate
                            ,dircarddefinitionname
                            ,legislativedatagroupname
                            ,assignmentnumber
                            ,dircardcompdefname
                            ,ee_pct
                            ,er_pct
                            ,Flat_ee_amt
                            ,Flat_er_amt
                            ,created_by
                            ,creation_date
                            ,last_updated_by
                            ,last_update_date
                            ,ebs_asg_number
                            ,taxreportingunitname
                            -- Pradeep code starts
							,AAT_ATTRIBUTE1
							,AAT_ATTRIBUTE5
                            -- Pradeep code ends
                            )
                 SELECT      pt_i_MigrationSetID               -- migration_set_id 
                            ,gvt_MigrationSetName              -- migration_set_name
                            ,'CREATE'                          -- migration_action  
                            ,'Line'
                            ,TO_CHAR(r_bp_card_details.effective_start_date,'RRRR/MM/DD')
                            ,TO_CHAR(r_bp_card_details.effective_end_date,'RRRR/MM/DD')
                            ,'Benefits and Pensions'
                            ,'GB Legislative Data Group'
                            ,r_bp_card_details.Fusion_asg_number
                            ,r_bp_card_details.calc_card_comp
                            ,r_bp_card_details.ee_pct
                            ,r_bp_card_details.er_pct
                            ,r_bp_card_details.flat_ee_amount
                            ,r_bp_card_details.flat_er_amount
                            ,xxmx_utilities_pkg.gvv_UserName            -- created by 
                            ,TO_CHAR(SYSDATE,'RRRR/MM/DD')              -- creation date
                            ,xxmx_utilities_pkg.gvv_UserName            -- last updated by
                            ,TO_CHAR(SYSDATE,'RRRR/MM/DD')              -- last update date
                            ,NULL
                            ,get_fusion_legal_emp(r_bp_card_details.Fusion_asg_number)  -- Fusion Assignment Number
                            -- Pradeep code starts
							,NULL
							,NULL
                            -- Pradeep code ends
                 FROM DUAL;  
               END LOOP;      
                   -- call utilities 
                   gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                    (gct_StgSchema,ct_StgTable,pt_i_MigrationSetID);
               COMMIT;
            /*   
               UPDATE xxmx_pay_calc_cards_bp_stg a
               SET EffectiveStartDate =( SELECT MIN(EffectiveStartDate)
                           FROM xxmx_pay_calc_cards_bp_stg a1
                           WHERE a1.assignmentnumber = a.assignmentnumber),
               effectiveenddate   = '4712/12/31'
;
*/
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extraction complete Rows: '||gvn_RowCount||' inserted'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '080';
               --
               xxmx_utilities_pkg.upd_migration_details
                    (pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gcv_BusinessEntity
                    ,pt_i_SubEntity               => pt_i_SubEntity
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
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => 'END '||cv_ProcOrFuncName||' - Migration Table "'||ct_StgTable||'" Completed.'
                    ,pt_i_OracleError       => NULL
                    );
          ELSE
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set not initialized.';
               --
               RAISE e_ModuleError;
          END IF;
          --
          EXCEPTION
               WHEN e_ModuleError THEN
                    --
                    ROLLBACK;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RAISE;
               --** END e_ModuleError Exception
               WHEN OTHERS THEN
                    --
                    ROLLBACK;
                    --
                    gvt_OracleError := SUBSTR(SQLERRM||'** ERROR_BACKTRACE: '
                                           ||dbms_utility.format_error_backtrace,1,4000);
                    --
                    xxmx_utilities_pkg.log_module_message
                         (pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    RAISE;
               --** END OTHERS Exception
          --** END Exception Handler
     END pay_calc_cards_bp_stg;
     --
     --********************************
     --** PROCEDURE: pay_calc_cards_sl_stg
     --********************************
     PROCEDURE pay_calc_cards_sl_stg
                    (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
     IS
     -- CALC_CARDS_SL     pay_calc_cards_sl_stg
          --********************
          --** CURSOR Declarations
          --**********************
          CURSOR c_sl_card_details IS 
          /*SELECT    *
          FROM (
                 SELECT element_name
                       ,assignment_number
                       ,input_value_name
                       ,effective_start_date
                       ,effective_end_date
                       ,screen_entry_value
                       ,FUSION_ASG_NUMBER
                  FROM  xxmx_pay_ebs_elem_entry_vals_v
                 WHERE  element_name =  'Student Loan'
                   AND  input_value_name IN ('Plan Type','Start Date')
               )
                 PIVOT ( MAX(screen_entry_value) 
                   FOR input_value_name IN ( 'Plan Type' AS Plan_Type,'Start Date' AS Start_Date )
                       );*/

               SELECT    *
                    FROM (
                    SELECT 
                    assignment_number
                    ,input_value_name 
                    ,effective_start_date
                    ,effective_end_date
                    ,screen_entry_value 
                    ,FUSION_ASG_NUMBER
                    FROM  xxmx_pay_ebs_elem_entry_vals_v1 a
                    WHERE  a.element_name IN('Court Order', 'Student Loan')
                    and a.effective_start_date IN( SELECT MAX(b.effective_start_date)
                                     FROM xxmx_pay_ebs_elem_entry_vals_v1 b
                                     WHERE a.input_value_name= b.input_value_name
                                     AND a.assignment_number= b.assignment_number
                                     AND a.element_name= b.element_name)
                    AND EXISTS  (Select 1
                                from per_all_assignments_f@mxdm_nvis_extract paaf
                                    ,pay_payrolls_f@mxdm_nvis_extract ppf
                                where TO_DATE(gd_migration_date,'RRRR/MM/DD') between paaf.effective_Start_Date and paaf.effective_end_date                                                        
                                and trunc(sysdate) between ppf.effective_Start_Date and ppf.effective_end_date
                                AND paaf.assignment_number= a.assignment_number
                                and ppf.payroll_id = paaf.payroll_id
                                and PAyroll_name IN( Select parameter_value 
                                                    From xxmx_migration_parameters
                                                    where parameter_code= 'PAYROLL_NAME'
                                                    and enabled_flag = 'Y'))                                     
                    AND  a.input_value_name IN ('Plan Type'
                                ,'Start Date'
                                ,'Protected Pay'
                                ,'Pay Value'
                                ,'DEO Underpayment Reason'
                                ,'Order Amount'
                                ,'Issued By'
                                ,'DEO Overriding Frequency'
                                ,'Fee'
                                ,'Reference'
                                ,'Type'
                                ,'Initial Debt'
                                ,'Main CTO Entry')
                    ) 
                    PIVOT (  max(screen_entry_value) SCRN_ENTRY_VAL for input_value_name  
                    IN ( 'Plan Type' AS sl_plan_type,'Start Date' AS sl_start_date,'Protected Pay' AS court_prot_pay,
                                'Pay Value' AS court_pay_value,
                                'DEO Underpayment Reason' AS court_deo_reason,
                                'Order Amount' AS   court_order_amt,
                                'Issued By' AS      court_issued_by,
                                'DEO Overriding Frequency' AS  court_deo_freq,
                                'Fee' AS    court_fee,
                                'Reference' AS  court_Ref,
                                'Type' AS    court_type,
                                'Initial Debt' AS  court_initial_debt,
                                'Main CTO Entry' AS court_cto )
                    );

          --** END CURSOR << >>
          --***********************
          --** Constant Declarations
          --***********************
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'pay_calc_cards_sl_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXTRACT';
          ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE := 'xxmx_pay_calc_cards_sl_stg';
          --************************
          --** Variable Declarations
          --***********************
          vd_BeginDate                   DATE;
          --
          vv_dircarddefinitionname       VARCHAR2(100) := 'Court Orders and Student Loans';
          vv_legislativedatagroupname    VARCHAR2(100) := 'GB Legislative Data Group';
          vv_dircardcompdefname          VARCHAR2(100) := 'Student Loan';
          --*************************
          --** Exception Declarations
          --***********************
          e_ModuleError                   EXCEPTION;
     --** END Declarations
     BEGIN
          gvv_ProgressIndicator := '0010';
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'MODULE'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F' THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'DATA'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F' THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
          END IF;
          --
          gvv_ProgressIndicator := '0030';
          --
          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          gvv_ProgressIndicator := '0040';

           xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Get Migration Set Name for  "'||pt_i_MigrationSetID
               ,pt_i_OracleError       => NULL
               );
          --
          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);

          DELETE FROM xxmx_pay_calc_cards_sl_stg;
          --
          IF   gvt_MigrationSetName IS NOT NULL THEN
               --
               gvv_ProgressIndicator := '0050';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Extracting "'||pt_i_SubEntity||'":'
                    ,pt_i_OracleError       => NULL
                    );
               --
               xxmx_utilities_pkg.init_migration_details
                    (pt_i_ApplicationSuite => gct_ApplicationSuite
                    ,pt_i_Application      => gct_Application
                    ,pt_i_BusinessEntity   => gcv_BusinessEntity
                    ,pt_i_SubEntity        => pt_i_SubEntity
                    ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                    ,pt_i_StagingTable     => ct_StgTable
                    ,pt_i_ExtractStartDate => SYSDATE
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Staging Table "'||ct_StgTable||'" reporting details initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
                    gvv_ProgressIndicator := '0060';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extracting Header Record into "'||ct_StgTable||'".'
                    ,pt_i_OracleError       => NULL
                    );
               --
                    INSERT INTO xxmx_pay_calc_cards_sl_stg
                                        (migration_set_id  
                                        ,migration_set_name 
                                        ,migration_action  
                                        , header_line
                                        ,effectivestartdate
                                        ,effectiveenddate
                                        ,dircarddefinitionname
                                        ,legislativedatagroupname
                                        ,assignmentnumber
                                        ,dircardcompdefname
                                        ,plan_type
                                        ,start_date
                                        ,TaxReportingUnitName
                                        ,created_by
                                        ,creation_date
                                        ,last_updated_by
                                        ,last_update_date
                                        )
                             SELECT       pt_i_MigrationSetID                             -- migration_set_id  
                                        ,'Migration Set Name'                            -- migration_set_name 
                                        ,'Migration Action'                              -- migration_action  
                                        ,'Header'     
                                        ,'EffectiveStartDate' 
                                        ,'EffectiveEndDate' 
                                        ,'DirCardDefinitionName' 
                                        ,'LegislativeDataGroupName' 
                                        ,'AssignmentNumber' 
                                        ,'DirCardCompDefName' 
                                        ,'Plan Type' 
                                        ,'Start Date' 
                                        ,'TaxReportingUnitName'
                                        ,'Created By'                                    -- created_by       
                                        ,'Creation Date'                                 -- creation_date    
                                        ,'LastUpdatedBy'                               -- last_updated_by  
                                        ,'LastUpdateDate'                              -- last_update_date
                                        FROM DUAL;
                    --     
                    gvv_ProgressIndicator := '0070';

                    xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Inserting data into "'||ct_StgTable||'".'
                    ,pt_i_OracleError       => NULL
                    );

          FOR sl_card_det_rec IN c_sl_card_details LOOP

                 INSERT INTO xxmx_pay_calc_cards_sl_stg
                                        (migration_set_id  
                                        ,migration_set_name 
                                        ,migration_action  
                                        ,header_line
                                        ,effectivestartdate
                                        ,effectiveenddate
                                        ,dircarddefinitionname
                                        ,legislativedatagroupname
                                        ,assignmentnumber
                                        ,dircardcompdefname
                                        ,plan_type
                                        ,start_date
                                        ,TaxReportingUnitName
                                        ,created_by
                                        ,creation_date
                                        ,last_updated_by
                                        ,last_update_date
                                        )
                        SELECT           pt_i_MigrationSetID               -- migration_set_id 
                                        ,gvt_MigrationSetName              -- migration_set_name 
                                        ,'CREATE'                          -- migration_action  
                                        ,'Line'
                                        ,TO_CHAR(sl_card_det_rec.effective_start_date,'RRRR/MM/DD')
                                        ,TO_CHAR(sl_card_det_rec.effective_end_date,'RRRR/MM/DD')
                                        ,vv_dircarddefinitionname
                                        ,vv_legislativedatagroupname
                                        ,sl_card_det_rec.FUSION_ASG_NUMBER  -- Fusion Assignment Number
                                        ,vv_dircardcompdefname
                                        ,REPLACE(sl_card_det_rec.sl_plan_type_scrn_entry_val,'0','') Plan_Type
                                        ,TO_CHAR(TO_DATE(sl_card_det_rec.sl_start_date_scrn_entry_val,'RRRR/MM/DD HH24:MI:SS'),'RRRR/MM/DD')
                                        ,get_fusion_legal_emp(sl_card_det_rec.FUSION_ASG_NUMBER)  -- Fusion Assignment Number
                                        ,xxmx_utilities_pkg.gvv_UserName            -- created by 
                                        ,TO_CHAR(SYSDATE,'RRRR/MM/DD')              -- creation date
                                        ,xxmx_utilities_pkg.gvv_UserName            -- last updated by
                                        ,TO_CHAR(SYSDATE,'RRRR/MM/DD')              -- last update date
                          FROM DUAL; 
          END LOOP;
          -- 
          COMMIT;
                  -- call utilities 
                   gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                    (gct_StgSchema,ct_StgTable,pt_i_MigrationSetID);
               --
               COMMIT;
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extraction complete Rows: '||gvn_RowCount||' inserted'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0080';
               --
               xxmx_utilities_pkg.upd_migration_details
                    (pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gcv_BusinessEntity
                    ,pt_i_SubEntity               => pt_i_SubEntity
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
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => 'END '||cv_ProcOrFuncName||' - Migration Table "'||ct_StgTable||'" completed.'
                    ,pt_i_OracleError       => NULL
                    );
          ELSE
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set not initialized.';
               --
               RAISE e_ModuleError;
          END IF;
          --
          EXCEPTION
               WHEN e_ModuleError THEN
                    --
                    ROLLBACK;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RAISE;
               --** END e_ModuleError Exception
               WHEN OTHERS THEN
                    --
                    ROLLBACK;
                    --
                    gvt_OracleError := SUBSTR(SQLERRM||'** ERROR_BACKTRACE: '
                                           ||dbms_utility.format_error_backtrace,1,4000);
                    --
                    xxmx_utilities_pkg.log_module_message
                         (pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    RAISE;
               --** END OTHERS Exception
          --** END Exception Handler
     END pay_calc_cards_sl_stg;
     --
     --********************************
     --** PROCEDURE: pay_calc_cards_nsd_stg
     --********************************
     PROCEDURE pay_calc_cards_nsd_stg
                    (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    )
     IS
     -- CALC_CARDS_NSD     pay_calc_cards_nsd_stg
          --***********************
          --** Constant Declarations
          --***********************
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'pay_calc_cards_nsd_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXTRACT';
          ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE := 'xxmx_pay_calc_cards_nsd_stg';
          --************************
          --** Variable Declarations
          --***********************
          vd_BeginDate                   DATE;
          --*************************
          --** Exception Declarations
          --***********************
          e_ModuleError                   EXCEPTION;
     --** END Declarations
     BEGIN
          gvv_ProgressIndicator := '0010';
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'MODULE'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F' THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'DATA'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F' THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
          END IF;
          --
          gvv_ProgressIndicator := '0030';
          --
          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          gvv_ProgressIndicator := '0040';
          --
          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Get Migration Set Name for  "'||pt_i_MigrationSetID
               ,pt_i_OracleError       => NULL
               );
          --
          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
          --
          DELETE FROM xxmx_pay_calc_cards_nsd_stg;


          IF   gvt_MigrationSetName IS NOT NULL THEN
               --
               gvv_ProgressIndicator := '0050';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Extracting "'||pt_i_SubEntity||'":'
                    ,pt_i_OracleError       => NULL
                    );
               --
               xxmx_utilities_pkg.init_migration_details
                    (pt_i_ApplicationSuite => gct_ApplicationSuite
                    ,pt_i_Application      => gct_Application
                    ,pt_i_BusinessEntity   => gcv_BusinessEntity
                    ,pt_i_SubEntity        => pt_i_SubEntity
                    ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                    ,pt_i_StagingTable     => ct_StgTable
                    ,pt_i_ExtractStartDate => SYSDATE
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Staging Table "'||ct_StgTable||'" reporting details initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
                    gvv_ProgressIndicator := '0060';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extracting Header Record into "'||ct_StgTable||'".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               INSERT INTO   xxmx_pay_calc_cards_nsd_stg
               SELECT pt_i_MigrationSetID                             -- migration_set_id  
                    ,'Migration Set Name'                            -- migration_set_name 
                    ,'Migration Action'                              -- migration_action  
                    ,'Header'
                    ,'DirCardCompId'
                    ,'DirInformationCategory'
                    ,'EffectiveEndDate'
                    ,'EffectiveStartDate'
                    ,'SourceSystemId'
                    ,'SourceSystemOwner'
                    ,'LDG'
                    ,'DirCardCompDefName'
                    ,'NS_STATEMENT'
                    ,'STUDENT_LOAN_DEDUCTIONS'
                    ,'NOT_PAID_BEFORE_TAX_YEAR'
                    ,'RTI_FILED'
                    ,'Created By'                                    -- created_by       
                    ,'Creation Date'                                 -- creation_date    
                    ,'Last Updated By'                               -- last_updated_by  
                    ,'Last Update Date'                              -- last_update_date
               FROM   dual;
               --     
               gvv_ProgressIndicator := '0070';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Inserting data into "'||ct_StgTable||'".'
                    ,pt_i_OracleError       => NULL
                    );

                    --
                  INSERT INTO   xxmx_pay_calc_cards_nsd_stg
                  SELECT DISTINCT
                                 pt_i_MigrationSetID               -- migration_set_id 
                                ,gvt_MigrationSetName              -- migration_set_name
                                ,'CREATE'                          -- migration_action  
                                ,'Line'
                                ,paye.dir_card_comp_id
                                ,'HRX_GB_NEW_STARTER'               -- dirinformationcategory,
                                ,'4712/12/31'                       -- effectiveenddate,
                                ,(
                                  SELECT TO_CHAR(date_start,'RRRR/MM/DD')
                                    FROM apps.per_periods_of_service@mxdm_nvis_extract ppos
                                   WHERE paaf.period_of_service_id = ppos.period_of_service_id
                                     AND date_start               >=  TO_DATE(g_start_of_year,'DD/MM/RRRR') 
                                 )                                    -- effectivestartdate,
                                ,paye.assignment_number|| '_HRX_GB_NEW_STARTER'            --sourcesystemid,
                                ,'EBS' sourcesystemowner
                                ,paye.ldg legislativedatagroupname
                                ,paye.component_name dircardcompdefname 
                                ,rti.rti_new_st_dec
                                ,rti.rti_student_loan
                                ,rti.rti_nt_paid_bet
                                ,rti.rti_ns_rti_sent
                                ,xxmx_utilities_pkg.gvv_UserName            -- created by 
                                ,TO_CHAR(SYSDATE,'RRRR/MM/DD')              -- creation date
                                ,xxmx_utilities_pkg.gvv_UserName            -- last updated by
                                ,TO_CHAR(SYSDATE,'RRRR/MM/DD')              -- last update date
                   FROM  apps.per_all_assignments_f@mxdm_nvis_extract paaf,
                         apps.pay_gb_rti_asg_info_v@mxdm_nvis_extract rti,
                         xxmx_fusion_calc_card_paye_ni_dtls           paye
                  WHERE  paaf.business_group_id   = xxmx_pay_payroll_pkg.get_business_group_id
                    --AND  paaf.effective_end_date >=  TO_DATE(g_start_of_year,'DD/MM/RRRR') 
                    and TRUNC(SYSDATE) between paaf.effective_Start_Date and paaf.effective_end_Date
                    AND  paaf.assignment_id       = rti.assignment_id
                    AND  paye.assignment_number =  paaf.assignment_type||paaf.assignment_number
                    AND  rti.rti_ns_rti_sent = 'N'
                    AND  paye.component_name      = 'PAYE'
                    AND  EXISTS (
                                    SELECT
                                        1
                                    FROM
                                        apps.per_periods_of_service@mxdm_nvis_extract ppos
                                    WHERE
                                        paaf.period_of_service_id = ppos.period_of_service_id
                                        AND   date_start >=  TO_DATE(g_start_of_year,'DD/MM/RRRR') 
                                    )
                    AND paaf.payroll_id IN (Select payroll_id
                                            from pay_payrolls_f@mxdm_nvis_extract ppf
                                            where trunc(sysdate) between ppf.effective_Start_Date and ppf.effective_end_date
                                            AND payroll_name IN( Select parameter_value 
                                                                From xxmx_migration_parameters
                                                                where parameter_code= 'PAYROLL_NAME'
                                                                and enabled_flag = 'Y'))
                    ;
                    --
                    -- call utilities 
                   gvn_RowCount := xxmx_utilities_pkg.get_row_count(gct_StgSchema,ct_StgTable,pt_i_MigrationSetID);
               --
                COMMIT;
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extraction complete Rows: '||gvn_RowCount||' inserted'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '080';
               --
               xxmx_utilities_pkg.upd_migration_details
                    (pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gcv_BusinessEntity
                    ,pt_i_SubEntity               => pt_i_SubEntity
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
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => 'END '||cv_ProcOrFuncName||' - Migration Table "'||ct_StgTable||'" completed.'
                    ,pt_i_OracleError       => NULL
                    );
          ELSE
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set not initialized.';
               --
               RAISE e_ModuleError;
          END IF;
          --
          EXCEPTION
               WHEN e_ModuleError THEN
                    --
                    ROLLBACK;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RAISE;
               --** END e_ModuleError Exception
               --
               WHEN OTHERS THEN
                    --
                    ROLLBACK;
                    --
                    gvt_OracleError := SUBSTR(SQLERRM||'** ERROR_BACKTRACE: '
                                           ||dbms_utility.format_error_backtrace,1,4000);
                    --
                    xxmx_utilities_pkg.log_module_message
                         (pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    RAISE;
               --** END OTHERS Exception
          --** END Exception Handler
     END pay_calc_cards_nsd_stg;
     --
     --********************************
     --** PROCEDURE: insert_pay_ebs_balances
     --********************************
     --    (p_balance_type VARCHAR2)  -- Replace with loop and select through cursor.
     PROCEDURE insert_pay_ebs_balances
                    (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
     IS
          --*********************
          --** CURSOR Declarations
          --***********************
          CURSOR c_balance_type IS
            SELECT LOWER(parameter_value) balance_type
              FROM xxmx_migration_parameters
             WHERE application_suite = 'HCM'
               AND application       = 'PAY'
               AND business_entity   = 'PAYROLL'
               AND sub_entity        ='ALL'
               AND parameter_code    ='BALANCE_TYPE'
               AND enabled_flag      = 'Y';
          -- Cursor to get Balance Assignments
          CURSOR c_balance_asg IS 

           SELECT  distinct asg.assignment_type||asg.assignment_number "ASSIGNMENT_NUMBER"
                  ,asg.assignment_id
                  ,pay.payroll_name
                ,pay.payroll_id
                  ,balance.effective_date effective_date
              FROM apps.per_all_assignments_f@mxdm_nvis_extract asg,
                   apps.pay_all_payrolls_f@mxdm_nvis_extract pay,
                    apps.pay_run_balances@mxdm_nvis_extract balance
             WHERE asg.business_group_id = g_busines_group_id
               AND pay.payroll_id = asg.payroll_id
               and balance.assignment_id = asg.assignment_id
               AND SYSDATE BETWEEN asg.effective_start_date AND asg.effective_end_date
               AND SYSDATE BETWEEN pay.effective_start_date AND pay.effective_end_date
               AND balance.effective_date BETWEEN CONCAT('01-',g_monthly_bal_date) AND LAST_DAY( CONCAT('01-',g_monthly_bal_date) )
               AND EXISTS(SELECT 1 from per_periods_of_service@mxdm_nvis_extract per where per.person_id = asg.person_id and actual_termination_date is null)
               -- Parameterise IN values
               AND   pay.payroll_name IN (select DISTINCT parameter_value  from xxmx_migration_parameters where parameter_code = 'PAYROLL_NAME'
               and enabled_flag = 'Y')
               AND EXISTS (SELECT 1
                        FROM XXMX_PER_ASSIGNMENTS_M_STG
                        WHERE ASSIGNMENT_NUMBER = assignment_number)
          ;

          --** END CURSOR c_balance_asg
          -- Cursor to get Balance Leaver
          CURSOR c_balance_asg_leaver IS 
		  select asg.assignment_type||asg.assignment_number "ASSIGNMENT_NUMBER"
                ,asg.assignment_id
                ,pay.payroll_name
                ,pay.payroll_id
                ,(SELECT max(effective_date)
                       FROM apps.pay_run_balances@mxdm_nvis_extract balance
                      WHERE balance.assignment_id       = asg.assignment_id
                        --AND balance.effective_date  >= TO_DATE(g_start_of_year,'DD/MM/RRRR')
                        AND balance.effective_date BETWEEN CONCAT('01-',g_monthly_bal_date) AND LAST_DAY( CONCAT('01-',g_monthly_bal_date) )
                        AND balance.effective_date  <= ppos.final_process_date
                    )final_process_date
                ,paa.assignment_action_id    
                ,ppa.effective_date
		  FROM apps.per_all_assignments_f@mxdm_nvis_extract asg,
                 apps.per_periods_of_service@mxdm_nvis_extract ppos,
                 apps.pay_all_payrolls_f@mxdm_nvis_extract pay,
                 pay_assignment_actions@mxdm_nvis_extract paa,
                 pay_payroll_Actions@mxdm_nvis_extract ppa
          WHERE asg.business_group_id = g_busines_group_id
          AND pay.payroll_id = asg.payroll_id
              -- Parameterise IN values
          AND pay.payroll_name IN (
									select DISTINCT parameter_value  
									from xxmx_migration_parameters 
									where parameter_code = 'PAYROLL_NAME'
									and enabled_flag = 'Y')
          AND   EXISTS ( SELECT 1
                              FROM apps.pay_run_balances@mxdm_nvis_extract balance
                             WHERE asg.assignment_id       = balance.assignment_id
                               AND balance.effective_date >= TO_DATE(g_start_of_year,'DD/MM/RRRR')
                               AND balance.effective_date  <= ppos.final_process_date
                          )
          AND   ppos.actual_termination_date IS NOT NULL
          AND  TRUNC(SYSDATE) BETWEEN asg.effective_start_date and asg.effective_end_date
          AND  TRUNC(SYSDATE) BETWEEN pay.effective_start_date and pay.effective_end_date
             --and assignment_number ='13736-2'
          AND  ( ppos.period_of_service_id = asg.period_of_service_id
             OR 
                 ppos.person_id = asg.person_id)
          AND ppa.payroll_action_id = paa.payroll_action_id
          AND ppa.business_group_id = g_busines_group_id
          AND date_earned is not null
          AND ppa.effective_date between  TO_DATE(g_start_of_year,'DD/MM/RRRR') AND TO_DATE(g_cutoff_date,'DD/MM/RRRR')
          AND SOURCE_ACTION_ID is not null
		  AND paa.assignment_id = asg.assignment_id
          AND EXISTS (SELECT 1
                      FROM XXMX_PER_ASSIGNMENTS_M_STG a
                      WHERE a.ASSIGNMENT_NUMBER = asg.assignment_type||asg.assignment_number)
            ;
          --** END CURSOR c_balance_asg_leaver


		  -- Cursor to get Balance Assignments
          CURSOR c_balance_asg_niable IS 
          WITH assignments AS 
          (SELECT  asg.assignment_type||asg.assignment_number  "ASSIGNMENT_NUMBER"
                  ,asg.assignment_id
                  ,pay.payroll_name
                 -- ,CONCAT('24-',g_monthly_bal_date) 
                 /* ,CASE WHEN REGEXP_LIKE ( pay.payroll_name,
                           'Monthly' ) THEN TO_DATE(g_monthly_bal_date,'dd/mm/yyyy')
                        WHEN REGEXP_LIKE ( pay.payroll_name,
                           'Weekly' ) THEN TO_DATE(g_weekly_bal_date,'dd/mm/yyyy')
                   END*/  
              FROM apps.per_all_assignments_f@mxdm_nvis_extract asg,
                   apps.pay_all_payrolls_f@mxdm_nvis_extract pay
             WHERE asg.business_group_id = g_busines_group_id
               AND pay.payroll_id      = asg.payroll_id
               AND SYSDATE BETWEEN asg.effective_start_date AND asg.effective_end_date
               AND EXISTS (SELECT 1
                             FROM apps.pay_run_balances@mxdm_nvis_extract balance
                            WHERE asg.assignment_id = balance.assignment_id
                              AND balance.effective_date >= TO_DATE(g_start_of_year,'DD/MM/RRRR')
                          )
               -- Parameterise IN values
               AND   pay.payroll_name IN (select DISTINCT parameter_value  from xxmx_migration_parameters where parameter_code = 'PAYROLL_NAME' and enabled_flag = 'Y')
          )
          --     
          SELECT * FROM assignments;
          --** END CURSOR c_balance_asg_niable 
          --    
          -- Cursor to get Balance Niable Leaver
          CURSOR c_balance_asg_niable_leaver IS 
          WITH assignments AS 
          ( SELECT  asg.assignment_type||asg.assignment_number  "ASSIGNMENT_NUMBER"
                  ,asg.assignment_id
                  ,pay.payroll_name
                  ,(SELECT max(effective_date)
                       FROM apps.pay_run_balances@mxdm_nvis_extract balance
                      WHERE balance.assignment_id       = asg.assignment_id
                        AND balance.effective_date  BETWEEN CONCAT('01-',g_monthly_bal_date) AND LAST_DAY( CONCAT('01-',g_monthly_bal_date) )
                        AND balance.effective_date  <= ppos.final_process_date
                    )final_process_date
             FROM apps.per_all_assignments_f@mxdm_nvis_extract asg,
                  apps.per_periods_of_service@mxdm_nvis_extract ppos,
                  apps.pay_all_payrolls_f@mxdm_nvis_extract pay
            WHERE asg.business_group_id = g_busines_group_id
              AND pay.payroll_id = asg.payroll_id
              AND pay.payroll_name IN (select DISTINCT parameter_value  from xxmx_migration_parameters where parameter_code = 'PAYROLL_NAME' and enabled_flag = 'Y')
              AND EXISTS (SELECT 1
                            FROM apps.pay_run_balances@mxdm_nvis_extract balance
                           WHERE asg.assignment_id       = balance.assignment_id
                             AND balance.effective_date >= TO_DATE(g_start_of_year,'DD/MM/RRRR')
                         )
              AND   ppos.period_of_service_id = asg.period_of_service_id
              AND   ppos.actual_termination_date IS NOT NULL
              AND   ppos.period_of_service_id = 
                        (SELECT MAX(ppos1.period_of_service_id)
                           FROM apps.per_periods_of_service@mxdm_nvis_extract ppos1
                          WHERE ppos.person_id = ppos1.person_id
                        )
              AND   asg.effective_start_date = 
                       (SELECT MAX(effective_start_date)
                          FROM apps.per_all_assignments_f@mxdm_nvis_extract paaf1
                         WHERE asg.assignment_id = paaf1.assignment_id
                       )
          ) 
          --
          SELECT * FROM assignments;
          --** END CURSOR c_balance_asg_niable_leaver
          --
          -- Cursor to get Rehires
          CURSOR c_rehires IS 
            WITH assignments AS 
                 (SELECT  asg.assignment_type||asg.assignment_number  "ASSIGNMENT_NUMBER"
                        ,asg.assignment_id
                        ,pay.payroll_name
                     ,(SELECT MAX(effective_date)
                       FROM apps.pay_run_balances@mxdm_nvis_extract balance
                      WHERE balance.assignment_id       = asg.assignment_id
                        AND balance.effective_date BETWEEN CONCAT('01-',g_monthly_bal_date) AND LAST_DAY( CONCAT('01-',g_monthly_bal_date) )
                        --AND balance.effective_date >= TO_DATE(g_start_of_year,'DD/MM/RRRR')
                        AND balance.effective_date  <= ppos.final_process_date
                    )final_process_date
           FROM apps.per_all_assignments_f@mxdm_nvis_extract asg,
                apps.per_periods_of_service@mxdm_nvis_extract ppos,
                apps.pay_all_payrolls_f@mxdm_nvis_extract pay
          WHERE asg.business_group_id = g_busines_group_id
            AND pay.payroll_id = asg.payroll_id
            AND pay.payroll_name IN (select DISTINCT parameter_value  from xxmx_migration_parameters where parameter_code = 'PAYROLL_NAME' and enabled_flag = 'Y')
            AND EXISTS 
                 (SELECT 1
                    FROM apps.pay_run_balances@mxdm_nvis_extract balance
                   WHERE asg.assignment_id       = balance.assignment_id
                     AND balance.effective_date >= TO_DATE(g_start_of_year,'DD/MM/RRRR')
                 )
            AND ppos.period_of_service_id = asg.period_of_service_id
            AND ppos.actual_termination_date IS NOT NULL
            AND ppos.final_process_date >= TO_DATE(g_start_of_year,'DD/MM/RRRR')
            AND ppos.actual_termination_date <= TO_DATE(g_cutoff_date,'DD/MM/RRRR')
            AND asg.effective_start_date = 
                (SELECT MAX(effective_start_date)
                   FROM apps.per_all_assignments_f@mxdm_nvis_extract paaf1
                  WHERE asg.assignment_id = paaf1.assignment_id
                )
          )
          -- 
          SELECT assignments.* FROM assignments
           WHERE NOT EXISTS (SELECT 1 
                               FROM xxmx_pay_ebs_balances bal
                              WHERE bal.assignment_id  = assignments.assignment_id
                            );
          --** END CURSOR c_rehires
          --          
          --***********************
          --** Constant Declarations
          --***********************
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'insert_pay_ebs_balances';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXTRACT';
          ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE := 'xxmx_pay_ebs_balances';
          --************************
          --** Variable Declarations
          --***********************
          vv_FusionAsgNumber             VARCHAR2(100);
          vd_BeginDate                   DATE;
          vn_counter                     NUMBER := 0;
          vn_assignment_id               NUMBER :=0;
          --***************************
          --** Record Table Declarations
          --***********************
          TYPE t_balances_tab IS TABLE OF c_balance_asg_leaver%ROWTYPE INDEX BY BINARY_INTEGER;
          p_balances_tab t_balances_tab;


          TYPE t_balances_niable_tab IS TABLE OF c_balance_asg_niable%ROWTYPE INDEX BY BINARY_INTEGER;
          p_balances_niable_tab t_balances_niable_tab;
          --
          --*************************
          --** Exception Declarations
          --***********************
          e_ModuleError                   EXCEPTION;
     --** END Declarations
     BEGIN
          gvv_ProgressIndicator := '0010';
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'MODULE'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F' THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'DATA'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F' THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
          END IF;
          --
          gvv_ProgressIndicator := '0030';
          --
          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --  
          gvt_MigrationSetName := 'Insert EBS Balances';
          --
          gvv_ProgressIndicator := '0040';
          --
          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Loop Through Balance Types Cursor'
               ,pt_i_OracleError       => NULL
               );
          -- Cursor to Loop for all the balance types.
        FOR balance_type_rec IN  c_balance_type
        LOOP
          IF balance_type_rec.balance_type = 'c_balance_asg'  THEN
              --
              gvv_ProgressIndicator := '0050';
              --
              xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Extracting Balance Type: '||balance_type_rec.balance_type
                    ,pt_i_OracleError       => NULL
                    );

           FOR r_balance_asg IN c_balance_asg LOOP
               vn_counter := vn_counter + 1;
               vn_assignment_id := r_balance_asg.assignment_id;

                    INSERT INTO xxmx_pay_ebs_balances
                    SELECT pt_i_MigrationSetID
                          ,pbv.balance_name
                          ,pbv.assignment_id
                          ,pbv.value balance_value
                          ,pbv.dimension_name
                          ,pbv.effective_date
                          ,pbv.assignment_action_id
                          ,pbv.payroll_action_id
                          ,pbv.balance_type_id
                          ,pbv.balance_dimension_id
                          ,pbv.defined_balance_id
                          ,r_balance_asg.assignment_number
                          ,balance_type_rec.balance_type
                      FROM apps.pay_balance_values_v@mxdm_nvis_extract pbv
                      WHERE (pbv.balance_name,pbv.dimension_name) IN ( SELECT ebs_balance_name,EBS_DIMENSION_NAME from xxmx_pay_balances_scope where balance_type = 'STATUTORY')
                         AND   pbv.balance_name      <> 'NIable Pay'
                        AND pbv.assignment_id     = r_balance_asg.assignment_id
                        AND pbv.effective_date    = r_balance_asg.effective_date
                        AND pbv.payroll_id    = r_balance_asg.payroll_id
                        AND pbv.business_group_id = g_busines_group_id;

                    IF  MOD(vn_counter,100) = 0 THEN
                        COMMIT;
                    END IF;
            END LOOP;
            --
            gvv_ProgressIndicator := '0060';
            --
                  xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Copleted Insert Balance Type: '||balance_type_rec.balance_type
                    ,pt_i_OracleError       => NULL
                    );

          ELSIF balance_type_rec.balance_type = 'c_balance_asg_leaver'  THEN
               vn_counter := 0;
               --        
               gvv_ProgressIndicator := '0070';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Extracting Balance Type: '||balance_type_rec.balance_type
                    ,pt_i_OracleError       => NULL
                    );


				OPEN c_balance_asg_leaver;

				FETCH c_balance_asg_leaver BULK COLLECT INTO p_balances_tab;
				FOR i IN 1..p_balances_tab.COUNT
				LOOP
                    vn_assignment_id := p_balances_tab(i).assignment_id;  
                    vn_counter := vn_counter + 1;

					INSERT INTO xxmx_pay_ebs_balances
					   SELECT pt_i_MigrationSetID
							 ,pbv.balance_name
							 ,pbv.assignment_id
							 ,pbv.value balance_value
							 ,pbv.dimension_name
							 ,pbv.effective_date
							 ,pbv.assignment_action_id
							 ,pbv.payroll_action_id
							 ,pbv.balance_type_id
							 ,pbv.balance_dimension_id
							 ,pbv.defined_balance_id
                             ,p_balances_tab(i).assignment_number
							 ,balance_type_rec.balance_type
						 FROM apps.pay_balance_values_v@mxdm_nvis_extract pbv
						WHERE (pbv.balance_name,pbv.dimension_name) IN ( SELECT ebs_balance_name,EBS_DIMENSION_NAME from xxmx_pay_balances_scope where balance_type = 'STATUTORY')  AND   pbv.assignment_id     = p_balances_tab(i).assignment_id
						  AND   pbv.assignment_action_id = p_balances_tab(i).assignment_action_id
						  AND   pbv.effective_date = p_balances_tab(i).effective_date
						  AND   pbv.business_group_id = 0
                    AND   pbv.balance_name      <> 'NIable Pay'
						  AND   pbv.payroll_id = p_balances_tab(i).payroll_id;

                      IF  MOD(vn_counter,100) = 0 THEN
                          COMMIT;
                      END IF;
            END LOOP;   
             --
             gvv_ProgressIndicator := '0080';
             --
             xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Completed Insert Balance Type: '||balance_type_rec.balance_type
                    ,pt_i_OracleError       => NULL
                    );
--
          ELSIF balance_type_rec.balance_type = 'c_balance_asg_niable' THEN

               vn_counter := 0;
               --        
               gvv_ProgressIndicator := '0090';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Extracting Balance Type: '||balance_type_rec.balance_type
                    ,pt_i_OracleError       => NULL
                    );
          --

            OPEN c_balance_asg_niable;
            FETCH c_balance_asg_niable BULK COLLECT INTO p_balances_niable_tab;
            CLOSE c_balance_asg_niable;
            FOR i IN 1..p_balances_niable_tab.COUNT
            LOOP
                vn_counter := vn_counter + 1;
                vn_assignment_id := p_balances_niable_tab(i).assignment_id;
     --          printline ('c_balance_asg_niable' ,vn_counter , vn_assignment_id);
                --
                INSERT INTO xxmx_pay_ebs_balances
                    SELECT DISTINCT 
                             pt_i_MigrationSetID
                            ,baltype.balance_name
                            ,runb.assignment_id
                            ,runb.balance_value
                            ,dim.dimension_name
                            ,runb.effective_date
                            ,runb.assignment_action_id
                            ,paa.payroll_action_id
                            ,baltype.balance_type_id
                            ,dim.balance_dimension_id
                            ,runb.defined_balance_id
                            ,p_balances_niable_tab(i).assignment_number
                            ,balance_type_rec.balance_type
                      FROM  apps.pay_run_balances@mxdm_nvis_extract runb,
                            apps.pay_defined_balances@mxdm_nvis_extract defb,
                            apps.pay_balance_types@mxdm_nvis_extract baltype,
                            apps.pay_balance_dimensions@mxdm_nvis_extract dim,
                            apps.pay_assignment_actions@mxdm_nvis_extract paa
                     WHERE  defb.balance_type_id      = baltype.balance_type_id
                       AND  defb.balance_dimension_id = dim.balance_dimension_id
                       AND  defb.defined_balance_id   = runb.defined_balance_id
                       AND  paa.assignment_action_id  = runb.assignment_action_id
                       AND  baltype.balance_name      = 'NIable Pay'
                       AND  dim.dimension_name        = '_ASG_RUN'
                       AND  runb.assignment_id        = p_balances_niable_tab(i).assignment_id
                       AND  runb.effective_date BETWEEN CONCAT('01-',g_monthly_bal_date) AND LAST_DAY( CONCAT('01-',g_monthly_bal_date) );

            END LOOP;
             --
            gvv_ProgressIndicator := '0100';
            --
                  xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Completed Insert Balance Type: '||balance_type_rec.balance_type
                    ,pt_i_OracleError       => NULL
                    );
          --
          ELSIF balance_type_rec.balance_type = 'c_balance_asg_niable_leaver'  THEN
                vn_counter := 0;
               --        
               gvv_ProgressIndicator := '0110';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Extracting Balance Type: '||balance_type_rec.balance_type
                    ,pt_i_OracleError       => NULL
                    );

            FOR r_balance_asg_niable_leaver IN c_balance_asg_niable_leaver LOOP
                vn_counter := vn_counter + 1;
                vn_assignment_id := r_balance_asg_niable_leaver.assignment_id;
-- printline ('c_balance_asg_niable_leaver' ,vn_counter , vn_assignment_id);

                 INSERT INTO xxmx_pay_ebs_balances
                 SELECT DISTINCT 
                        pt_i_MigrationSetID
                          ,baltype.balance_name
                       ,runb.assignment_id
                       ,runb.balance_value
                       ,dim.dimension_name
                       ,runb.effective_date
                       ,runb.assignment_action_id
                       ,paa.payroll_action_id
                       ,baltype.balance_type_id
                       ,dim.balance_dimension_id
                       ,runb.defined_balance_id
                       ,r_balance_asg_niable_leaver.assignment_number
                       ,balance_type_rec.balance_type
                  FROM apps.pay_run_balances@mxdm_nvis_extract runb,
                       apps.pay_defined_balances@mxdm_nvis_extract defb,
                       apps.pay_balance_types@mxdm_nvis_extract baltype,
                       apps.pay_balance_dimensions@mxdm_nvis_extract dim,
                       apps.pay_assignment_actions@mxdm_nvis_extract paa
                 WHERE defb.balance_type_id = baltype.balance_type_id
                   AND defb.balance_dimension_id = dim.balance_dimension_id
                   AND defb.defined_balance_id = runb.defined_balance_id
                   AND paa.assignment_action_id = runb.assignment_action_id
                   AND baltype.balance_name = 'NIable Pay'
                   AND dim.dimension_name = '_ASG_RUN'
                   AND runb.assignment_id = r_balance_asg_niable_leaver.assignment_id
                   AND runb.effective_date= r_balance_asg_niable_leaver.final_process_date;

            END LOOP;
            --
            gvv_ProgressIndicator := '0120';
            --
                  xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Completed Insert Balance Type: '||balance_type_rec.balance_type
                    ,pt_i_OracleError       => NULL
                    );
          --
          ELSIF balance_type_rec.balance_type = 'c_rehires'  THEN
               vn_counter := 0;
               --        
               gvv_ProgressIndicator := '0130';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Extracting Balance Type: '||balance_type_rec.balance_type
                    ,pt_i_OracleError       => NULL
                    );
            --     
            FOR r_rehires IN c_rehires LOOP
                vn_counter := vn_counter + 1;
                vn_assignment_id := r_rehires.assignment_id;
     --OPEN c_balance_asg_leaver;
     --  FETCH c_balance_asg_leaver BULK COLLECT INTO p_balances_tab;
      -- FORALL i IN 1..p_balances_tab.COUNT*/

               INSERT INTO xxmx_pay_ebs_balances
                    SELECT pt_i_MigrationSetID
                          ,pbv.balance_name
                          ,pbv.assignment_id
                          ,pbv.value balance_value
                          ,pbv.dimension_name
                          ,pbv.effective_date
                          ,pbv.assignment_action_id
                          ,pbv.payroll_action_id
                          ,pbv.balance_type_id
                          ,pbv.balance_dimension_id
                          ,pbv.defined_balance_id
                          ,r_rehires.assignment_number
                          ,balance_type_rec.balance_type
                     FROM  apps.pay_balance_values_v@mxdm_nvis_extract pbv
                      WHERE (pbv.balance_name,pbv.dimension_name) IN ( SELECT ebs_balance_name,EBS_DIMENSION_NAME from xxmx_pay_balances_scope where balance_type = 'STATUTORY')
                    AND   pbv.balance_name      <> 'NIable Pay'
                      AND pbv.assignment_id     = r_rehires.assignment_id
                   -- AND pbv.effective_date = r_balance_asg.effective_date
                      AND pbv.business_group_id = g_busines_group_id
					  AND pbv.effective_date  = r_rehires.final_process_date;


               INSERT INTO xxmx_pay_ebs_balances
                    SELECT DISTINCT 
                           pt_i_MigrationSetID
                          ,baltype.balance_name
                          ,runb.assignment_id
                          ,runb.balance_value
                          ,dim.dimension_name
                          ,runb.effective_date
                          ,runb.assignment_action_id
                          ,paa.payroll_action_id
                          ,baltype.balance_type_id
                          ,dim.balance_dimension_id
                          ,runb.defined_balance_id
                          ,r_rehires.assignment_number
                          ,balance_type_rec.balance_type
                      FROM apps.pay_run_balances@mxdm_nvis_extract runb,
                           apps.pay_defined_balances@mxdm_nvis_extract defb,
                           apps.pay_balance_types@mxdm_nvis_extract baltype,
                           apps.pay_balance_dimensions@mxdm_nvis_extract dim,
                           apps.pay_assignment_actions@mxdm_nvis_extract paa
                     WHERE defb.balance_type_id = baltype.balance_type_id
                       AND defb.balance_dimension_id = dim.balance_dimension_id
                       AND defb.defined_balance_id = runb.defined_balance_id
                       AND paa.assignment_action_id = runb.assignment_action_id
                       AND baltype.balance_name = 'NIable Pay'
                       AND dim.dimension_name = '_ASG_RUN'
                       AND runb.assignment_id = r_rehires.assignment_id
                       AND runb.effective_date  = r_rehires.final_process_date;
            END LOOP;
            --
            gvv_ProgressIndicator := '0140';
            --
                  xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Completed Insert Balance Type: '||balance_type_rec.balance_type
                    ,pt_i_OracleError       => NULL
                    );
          END IF;  -- Balance Types
     END LOOP; -- balance types

     COMMIT; -- testing Only JEM

                 gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                    ('xxmx_core',ct_StgTable,pt_i_MigrationSetID);
            --
            gvv_ProgressIndicator := '0150';
            --
                  xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => ct_StgTable ||'- Completed  '||gvn_RowCount||' records inserted.'
                    ,pt_i_OracleError       => NULL
                    );
            --
            gvv_ProgressIndicator := '0160';
            --
                  xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => ct_StgTable ||'- Opening  r_balances_asg cursor'
                    ,pt_i_OracleError       => NULL
                    );
      --
      FOR r_balances_asg IN (select DISTINCT assignment_id from xxmx_pay_ebs_balances bal)
      LOOP
           UPDATE xxmx_pay_ebs_balances
              SET ebs_assignment_number = 
                              ( SELECT assignment_number
                                  FROM apps.per_all_assignments_f@mxdm_nvis_extract
                                 WHERE assignment_id     = r_balances_asg.assignment_id
                                   AND assignment_number IS NOT NULL
                                   AND rownum = 1
                              )
            WHERE assignment_id = r_balances_asg.assignment_id;
      END LOOP;
            --
            gvv_ProgressIndicator := '0170';
            --
                  xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => ct_StgTable ||'- Completed Updated Assignment Name.'
                    ,pt_i_OracleError       => NULL
                    );
          --
          COMMIT;
          --
          EXCEPTION
               --
               WHEN e_ModuleError THEN
                    --
                    ROLLBACK;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RAISE;
               --** END e_ModuleError Exception
               WHEN OTHERS THEN
                    --
                    ROLLBACK;
                    --
                    gvt_OracleError := SUBSTR(SQLERRM||'** ERROR_BACKTRACE: '
                                           ||dbms_utility.format_error_backtrace,1,4000);
                    --
                    xxmx_utilities_pkg.log_module_message
                         (pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    RAISE;
               --** END OTHERS Exception
          --** END Exception Handler
     END insert_pay_ebs_balances;
     --
     --**********************
     ----** PROCEDURE: stg_main
     --**********************
     PROCEDURE stg_main
                    (pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE)
     IS
          --**********************
          ----** CURSOR Declarations
          --**********************
          CURSOR StagingMetadata_cur
                      (pt_ApplicationSuite             xxmx_migration_metadata.application_suite%TYPE
                      ,pt_Application                  xxmx_migration_metadata.application%TYPE
                      ,pt_BusinessEntity               xxmx_migration_metadata.business_entity%TYPE)
          IS
               SELECT  xmm.sub_entity
                      ,xmm.entity_package_name
                      ,xmm.stg_procedure_name
               FROM    xxmx_migration_metadata  xmm
               WHERE   xmm.enabled_flag = 'Y'
               AND     xmm.application_suite = pt_ApplicationSuite
               AND     xmm.application       = pt_Application
               AND     xmm.business_entity   = pt_BusinessEntity
               ORDER BY xmm.sub_entity_seq;
          --** END CURSOR StagingMetadata_cur
          --************************
          --** Constant Declarations
          --************************
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                         := 'stg_main';
          ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE := 'ALL';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE      := 'EXTRACT';
          --************************
          --** Variable Declarations
          --************************
          vt_ConfigParameter              xxmx_client_config_parameters.config_parameter%TYPE;
          vt_MigrationSetID               xxmx_migration_headers.migration_set_id%TYPE;
          --*************************
          --** Exception Declarations
          --*************************
          e_ModuleError                   EXCEPTION;
     --** END Declarations **
     BEGIN
          gvv_ProgressIndicator := '0010';
          --
          IF   pt_i_ClientCode       IS NULL
          OR   pt_i_MigrationSetName IS NULL
          THEN
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- "pt_i_ClientCode" and "pt_i_MigrationSetName" parameters are mandatory.';
               --
               RAISE e_ModuleError;
          END IF;
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => ct_SubEntity
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'MODULE'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F' THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => ct_SubEntity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => gvt_ReturnMessage
                    );
               --
               RAISE e_ModuleError;
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => 'RUN EXTRACT'
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => ' START Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          gvv_ProgressIndicator := '0030';
          --
          xxmx_utilities_pkg.init_migration_set
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_MigrationSetName => pt_i_MigrationSetName
               ,pt_o_MigrationSetID   => vt_MigrationSetID
               );
          --
          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '- Migration Set "'||pt_i_MigrationSetName
                                        ||'" initialized (Generated Migration Set ID = '||vt_MigrationSetID||').  Processing extracts:'
               ,pt_i_OracleError       => NULL
               );
          --
          gvv_ProgressIndicator := '0040';
          --
		  --
		  --
		  --
			 --**********************************
			 --  Function Set Parameters
			 --**********************************

			BEGIN 
				SELECT PARAMETER_VALUE
				INTO gd_migration_date
				FROM XXMX_MIGRATION_PARAMETERS
				WHERE APPLICATION= 'PAY'
				AND PARAMETER_CODE= 'PAY_MIGRATION_DATE';

				SELECT PARAMETER_VALUE
				INTO g_start_of_year
				FROM XXMX_MIGRATION_PARAMETERS
				WHERE APPLICATION= 'PAY'
				AND PARAMETER_CODE= 'PAY_START_OF_YEAR';

				SELECT PARAMETER_VALUE
				INTO g_cutoff_date
				FROM XXMX_MIGRATION_PARAMETERS
				WHERE APPLICATION= 'PAY'
				AND PARAMETER_CODE= 'PAY_CUTOFF_DATE';

				SELECT PARAMETER_VALUE
				INTO g_weekly_bal_date
				FROM XXMX_MIGRATION_PARAMETERS
				WHERE APPLICATION= 'PAY'
				AND PARAMETER_CODE= 'PAY_WEEKLY_BAL_DATE';

				SELECT PARAMETER_VALUE
				INTO g_monthly_bal_date
				FROM XXMX_MIGRATION_PARAMETERS
				WHERE APPLICATION= 'PAY'
				AND PARAMETER_CODE= 'PAY_MONTHLY_BAL_DATE';

			EXCEPTION
				WHEN OTHERS THEN 
					gvv_ProgressIndicator := '0041';

						xxmx_utilities_pkg.log_module_message
					   (pt_i_ApplicationSuite  => gct_ApplicationSuite
					   ,pt_i_Application       => gct_Application
					   ,pt_i_BusinessEntity    => gcv_BusinessEntity
					   ,pt_i_SubEntity         => ct_SubEntity
					   ,pt_i_Phase             => ct_Phase
					   ,pt_i_Severity          => 'NOTIFICATION'
					   ,pt_i_PackageName       => gcv_PackageName
					   ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
					   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
					   ,pt_i_ModuleMessage     => '- PARAMETER Initialize Failed "'
					   ,pt_i_OracleError       => NULL
					   );
			END;


          FOR  StagingMetadata_rec
          IN   StagingMetadata_cur
                    (gct_ApplicationSuite,gct_Application,gcv_BusinessEntity)
          LOOP
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => ct_SubEntity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Calling Procedure "'
                                             ||StagingMetadata_rec.entity_package_name||'.'
                                             ||StagingMetadata_rec.stg_procedure_name||'".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_SQLStatement := 'BEGIN '
                                 ||StagingMetadata_rec.entity_package_name
                                 ||'.'
                                 ||StagingMetadata_rec.stg_procedure_name
                                 ||gcv_SQLSpace
                                 ||'('
                                 ||' pt_i_MigrationSetID          => '
                                 ||vt_MigrationSetID
                                 ||',pt_i_SubEntity               => '''
                                 ||StagingMetadata_rec.sub_entity
                                 ||''''
                                 ||'); END;';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => ct_SubEntity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => SUBSTR('- Generated SQL Statement: '||gvv_SQLStatement,1,4000)
                    ,pt_i_OracleError       => NULL
                    );
               --
               EXECUTE IMMEDIATE gvv_SQLStatement;
          END LOOP;
          --
          gvv_ProgressIndicator := '0050';
          --
          COMMIT;
          --
          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          EXCEPTION
               WHEN e_ModuleError THEN
                    --
                    xxmx_utilities_pkg.log_module_message
                         (pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RAISE;
               --** END e_ModuleError Exception
               WHEN OTHERS THEN
                    --
                    ROLLBACK;
                    --
                    gvt_OracleError := SUBSTR(SQLERRM||'** ERROR_BACKTRACE: '
                                           ||dbms_utility.format_error_backtrace,1,4000);
                    --
                    xxmx_utilities_pkg.log_module_message
                         (pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    RAISE;
               --** END OTHERS Exception
          --** END Exception Handler
     END stg_main; 
     --
     --*******************
     ----** PROCEDURE: purge
     --*******************
     PROCEDURE purge(pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE)
     IS
          --**********************
          ----** CURSOR Declarations
          --**********************
          CURSOR PurgingMetadata_cur
                      (pt_ApplicationSuite             xxmx_migration_metadata.application_suite%TYPE
                      ,pt_Application                  xxmx_migration_metadata.application%TYPE
                      ,pt_BusinessEntity               xxmx_migration_metadata.business_entity%TYPE)
          IS
               SELECT  xmm.stg_table
                      ,xmm.xfm_table
               FROM    xxmx_migration_metadata  xmm
               WHERE   1 = 1
               AND     xmm.application_suite = pt_ApplicationSuite
               AND     xmm.application       = pt_Application
               AND     xmm.business_entity   = pt_BusinessEntity
               ORDER BY xmm.sub_entity_seq;
          --** END CURSOR PurgingMetadata_cur
          --************************
          --** Constant Declarations
          --************************
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                         := 'purge';
          ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE := 'ALL';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE      := 'CORE';
          --************************
          --** Variable Declarations
          --************************
          vt_ConfigParameter              xxmx_client_config_parameters.config_parameter%TYPE;
          vt_ClientSchemaName             xxmx_client_config_parameters.config_value%TYPE;
          vv_PurgeTableName               VARCHAR2(30);
          --*************************
          --** Exception Declarations
          --*************************
          e_ModuleError                   EXCEPTION;
     --** END Declarations **
     BEGIN
          gvv_ProgressIndicator := '0010';
          --
          IF   pt_i_ClientCode     IS NOT NULL
          AND  pt_i_MigrationSetID IS NOT NULL
          THEN
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- "pt_i_ClientCode" and "pt_i_MigrationSetID" parameters are mandatory.';
               --
               RAISE e_ModuleError;
          END IF;
          --
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => ct_SubEntity
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'MODULE'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F' THEN
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".';
               --
               RAISE e_ModuleError;
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '- Purging tables.'
               ,pt_i_OracleError       => NULL
               );
          --
          gvv_ProgressIndicator := '0030';
          --
          gvv_SQLAction := 'DELETE';
          --
          gvv_SQLWhereClause := 'WHERE 1 = 1 '||'AND   migration_set_id = '||pt_i_MigrationSetID;
          --
          FOR  PurgingMetadata_rec
          IN   PurgingMetadata_cur
                    (gct_ApplicationSuite,gct_Application,gcv_BusinessEntity)
          LOOP
               --
               --** ISV 21/10/2020 - Replace with new constant for Staging Schema.
               --
               gvv_SQLTableClause := 'FROM '
                                   ||gct_StgSchema
                                   ||'.'
                                   ||PurgingMetadata_rec.stg_table;
               --
               gvv_SQLStatement := gvv_SQLAction
                                 ||gcv_SQLSpace
                                 ||gvv_SQLTableClause
                                 ||gcv_SQLSpace
                                 ||gvv_SQLWhereClause;
               --
               EXECUTE IMMEDIATE gvv_SQLStatement;
               --
               gvn_RowCount := SQL%ROWCOUNT;
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => ct_SubEntity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Records purged FROM "'||PurgingMetadata_rec.stg_table||'" table: '||gvn_RowCount
                    ,pt_i_OracleError       => NULL
                    );

          END LOOP;
          --
          vv_PurgeTableName := 'xxmx_migration_details';
          --
          gvv_SQLTableClause := 'FROM '
                              ||gct_CoreSchema
                              ||'.'
                              ||vv_PurgeTableName;
          --
          gvv_SQLStatement := gvv_SQLAction
                            ||gcv_SQLSpace
                            ||gvv_SQLTableClause
                            ||gcv_SQLSpace
                            ||gvv_SQLWhereClause;
          --
          EXECUTE IMMEDIATE gvv_SQLStatement;
          --
          gvn_RowCount := SQL%ROWCOUNT;
          --
          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '  - Records purged FROM "'||vv_PurgeTableName||'" table: '||gvn_RowCount
               ,pt_i_OracleError       => NULL
               );
          --
          vv_PurgeTableName := 'xxmx_migration_headers';
          --
          gvv_SQLTableClause := 'FROM '
                              ||gct_CoreSchema
                              ||'.'
                              ||vv_PurgeTableName;
          --
          gvv_SQLStatement := gvv_SQLAction
                            ||gcv_SQLSpace
                            ||gvv_SQLTableClause
                            ||gcv_SQLSpace
                            ||gvv_SQLWhereClause;
          --
          EXECUTE IMMEDIATE gvv_SQLStatement;
          --
          gvn_RowCount := SQL%ROWCOUNT;
          --
          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '  - Records purged FROM "'||vv_PurgeTableName||'" table: '||gvn_RowCount
               ,pt_i_OracleError       => NULL
               );
          --
          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '- Purging complete.'
               ,pt_i_OracleError       => NULL
               );
          --
          COMMIT;
          --
          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          EXCEPTION
               WHEN e_ModuleError THEN
                    --
                    xxmx_utilities_pkg.log_module_message
                         (pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RAISE;
               --** END e_ModuleError Exception
               WHEN OTHERS THEN
                    --
                    ROLLBACK;
                    --
                    gvt_OracleError := SUBSTR(SQLERRM||'** ERROR_BACKTRACE: '
                                            ||dbms_utility.format_error_backtrace,1,4000);
                    --
                    xxmx_utilities_pkg.log_module_message
                         (pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );

                    --
                    RAISE;
               --** END OTHERS Exception
          --** END Exception Handler
     END purge;  

	PROCEDURE insert_pay_ebs_balances_addnl (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                                            ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
	IS
    CURSOR c_additional_balance_asg
	IS 
        SELECT
            asg.assignment_number,
            asg.assignment_id,
            pay.payroll_id,
            asg.assignment_type ||asg.assignment_number FUSION_ASG_NUMBER,
            max(effective_date) effective_date
        FROM
            apps.per_all_assignments_f@mxdm_nvis_extract asg,
            apps.pay_all_payrolls_f@mxdm_nvis_extract pay,
             apps.pay_run_balances@mxdm_nvis_extract balance
        WHERE    asg.business_group_id = 0
            AND   pay.payroll_id = asg.payroll_id
            AND   SYSDATE BETWEEN asg.effective_start_date AND asg.effective_end_date
            AND   SYSDATE BETWEEN pay.effective_start_date AND pay.effective_end_date
            AND   asg.assignment_id = balance.assignment_id
            AND   balance.effective_date   BETWEEN CONCAT('01-',g_monthly_bal_date) AND LAST_DAY( CONCAT('01-',g_monthly_bal_date) )
            AND   pay.payroll_name IN (select DISTINCT parameter_value  from xxmx_migration_parameters where parameter_code = 'PAYROLL_NAME' and enabled_flag = 'Y')
      Group by  asg.assignment_number,
            asg.assignment_id,
            pay.payroll_id,
            asg.assignment_type ||asg.assignment_number
        ;

	   CURSOR c_additional_balance_asg_leaver
		 IS 
		 select asg.assignment_number
                ,asg.assignment_id
                ,pay.payroll_name
                ,pay.payroll_id
                ,(SELECT max(effective_date)
				  FROM apps.pay_run_balances@mxdm_nvis_extract balance
				  WHERE balance.assignment_id       = asg.assignment_id
				  AND balance.effective_date  >= TO_DATE(g_start_of_year,'DD/MM/RRRR')
				  AND balance.effective_date  <= ppos.final_process_date
				)final_process_date
		FROM apps.per_all_assignments_f@mxdm_nvis_extract asg,
			 apps.per_periods_of_service@mxdm_nvis_extract ppos,
			 apps.pay_all_payrolls_f@mxdm_nvis_extract pay             
		WHERE asg.business_group_id = 0
		AND pay.payroll_id = asg.payroll_id
		  -- Parameterise IN values
		AND pay.payroll_name IN (select DISTINCT parameter_value  
								from xxmx_migration_parameters 
								where parameter_code = 'PAYROLL_NAME'
								and enabled_flag = 'Y')
		AND   EXISTS ( SELECT 1
						  FROM apps.pay_run_balances@mxdm_nvis_extract balance
						 WHERE asg.assignment_id       = balance.assignment_id
						   AND balance.effective_date >= TO_DATE(g_start_of_year,'DD/MM/RRRR')
						   AND balance.effective_date  <= ppos.final_process_date
					  )
		AND   ppos.actual_termination_date IS NOT NULL
		AND  TRUNC(SYSDATE) BETWEEN asg.effective_start_date and asg.effective_end_date
		AND  TRUNC(SYSDATE) BETWEEN pay.effective_start_date and pay.effective_end_date
		 --and assignment_number ='13736-2'
		AND  ( ppos.period_of_service_id = asg.period_of_service_id
		 OR 
			 ppos.person_id = asg.person_id)
            ;

	CURSOR c_rehires_addnl_balance
	 IS 
	WITH assignments AS (
        SELECT
            asg.assignment_number,
            asg.assignment_id,
            pay.payroll_name,
			pay.payroll_id,
			(SELECT MAX(effective_date)
                       FROM apps.pay_run_balances@mxdm_nvis_extract balance
                      WHERE balance.assignment_id       = asg.assignment_id
                        AND balance.effective_date  >= TO_DATE(g_start_of_year,'DD/MM/RRRR')
                        AND balance.effective_date  <= ppos.final_process_date
            )final_process_date
        FROM
            apps.per_all_assignments_f@mxdm_nvis_extract asg,
            apps.per_periods_of_service@mxdm_nvis_extract ppos,
            apps.pay_all_payrolls_f@mxdm_nvis_extract pay
        WHERE
            asg.business_group_id = 0
            AND   pay.payroll_id = asg.payroll_id
            AND   pay.payroll_name IN (
                select DISTINCT parameter_value  from xxmx_migration_parameters where parameter_code = 'PAYROLL_NAME' and enabled_flag = 'Y')
           AND   EXISTS (
                SELECT
                    1
                FROM
                    apps.pay_run_balances@mxdm_nvis_extract balance
                WHERE
                    asg.assignment_id = balance.assignment_id
                    AND   balance.effective_date >= TO_DATE(g_start_of_year,'DD/MM/RRRR')
                    AND balance.effective_date  <= ppos.final_process_date
            )
            AND   ppos.period_of_service_id = asg.period_of_service_id
            AND   ppos.actual_termination_date IS NOT NULL
            AND   ppos.final_process_date >= TO_DATE(g_start_of_year,'DD/MM/RRRR')
            AND   ppos.actual_termination_date <= TO_DATE(g_cutoff_date,'DD/MM/RRRR')
            AND   asg.effective_start_date = (
                SELECT
                    MAX(effective_start_date)
                FROM
                    apps.per_all_assignments_f@mxdm_nvis_extract paaf1
                WHERE
                    asg.assignment_id = paaf1.assignment_id
            )
    ) SELECT
        assignments.*
      FROM
        assignments
      WHERE NOT EXISTS (SELECT 1 
						  FROM  xxmx_pay_ebs_balances bal
                         WHERE bal.assignment_id  = assignments.assignment_id
						   AND bal.cursor_name LIKE 'c_additional%'
                        );

    l_counter   NUMBER := 0;
	l_assignment_id NUMBER :=0;
	--TYPE t_balances_tab IS TABLE OF c_balance_asg%ROWTYPE INDEX BY BINARY_INTEGER;
	--p_balances_tab t_balances_tab;	

	--** END CURSOR c_rehires
          --          
          --***********************
          --** Constant Declarations
          --***********************
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'insert_pay_ebs_balances_addnl';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXTRACT';
          ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE := 'xxmx_pay_ebs_balances';
          --************************
          --** Variable Declarations
          --***********************
          vv_FusionAsgNumber             VARCHAR2(100);
          vd_BeginDate                   DATE;
          vn_counter                     NUMBER := 0;
          vn_assignment_id               NUMBER :=0;
          --***************************
          --** Record Table Declarations
          --***********************
          --
		  TYPE t_balances_tab IS TABLE OF c_additional_balance_asg_leaver%ROWTYPE INDEX BY BINARY_INTEGER;
          p_balances_tab t_balances_tab;
          --*************************
          --** Exception Declarations
          --***********************
          e_ModuleError                   EXCEPTION;
     --** END Declarations
	BEGIN
		gvv_ProgressIndicator := '0010';
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'MODULE'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F' THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'DATA'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F' THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
          END IF;
          --
          gvv_ProgressIndicator := '0030';
          --
          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --  
          gvt_MigrationSetName := 'Insert EBS Balances';
          --
          gvv_ProgressIndicator := '0040';
          --
          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Loop Through Balance Types Cursor'
               ,pt_i_OracleError       => NULL
               );

    FOR r_balance_asg IN c_additional_balance_asg LOOP
        l_counter := l_counter + 1;
		l_assignment_id := r_balance_asg.assignment_id;

		--printline(l_counter||' AssignmentId: '||l_assignment_id||'Time: '||TO_CHAR(SYSDATE,'DD/MM/RRRR HH24:MI:SS'));
	    INSERT INTO xxmx_pay_ebs_addln_bal
            SELECT
                pt_i_MigrationSetID,
                pbv.balance_name,
                pbv.assignment_id,
                pbv.value balance_value,
                pbv.dimension_name,
                pbv.effective_date,
                pbv.assignment_action_id,
                pbv.payroll_action_id,
                pbv.balance_type_id,
                pbv.balance_dimension_id,
                pbv.defined_balance_id,
				r_balance_asg.assignment_number,
				'c_additional_balance_asg'
            FROM
                apps.pay_balance_values_v@mxdm_nvis_extract pbv
            WHERE
			(pbv.balance_name ) IN( select distinct EBS_BAlance_name  from xxmx_pay_balances_scope where balance_type = 'CUSTOM')
			AND   pbv.assignment_id = r_balance_asg.assignment_id
			AND  pbv.DIMENSION_NAME IN( select distinct EBS_DIMENSION_NAME  from xxmx_pay_balances_scope where balance_type = 'CUSTOM')
			-- AND   pbv.effective_date = r_balance_asg.effective_date
			AND   pbv.business_group_id = 0
			and pbv.payroll_id = r_balance_asg.payroll_id	
			AND pbv.effective_date =r_balance_asg.effective_date;

        IF
            MOD(l_counter,100) = 0
        THEN
            COMMIT;
        END IF;
    END LOOP;
	--
	/*l_counter := 0;
	Open c_additional_balance_asg_leaver;
	FETCH c_additional_balance_asg_leaver BULK COLLECT INTO p_balances_tab;
	CLOSE c_additional_balance_asg_leaver;
	FOR i IN 1..p_balances_tab.COUNT 
	LOOP
        l_counter := l_counter + 1;
		l_assignment_id := p_balances_tab(i).assignment_id;


	/*OPEN c_balance_asg_leaver;
	LOOP
	FETCH c_balance_asg_leaver BULK COLLECT INTO p_balances_tab;
	FORALL i IN 1..p_balances_tab.COUNT*/
	    /*   INSERT INTO xxmx_pay_ebs_addln_bal
            SELECT
                pt_i_MigrationSetID,
                pbv.balance_name,
                pbv.assignment_id,
                pbv.value balance_value,
                pbv.dimension_name,
                pbv.effective_date,
                pbv.assignment_action_id,
                pbv.payroll_action_id,
                pbv.balance_type_id,
                pbv.balance_dimension_id,
                pbv.defined_balance_id,
				p_balances_tab(i).assignment_number,
				'c_additional_balance_asg_leaver'
            FROM
                apps.pay_balance_values_v@mxdm_nvis_extract pbv
            WHERE
			 (pbv.balance_name ) IN( select distinct EBS_BAlance_name  from xxmx_pay_balances_scope where balance_type = 'CUSTOM')
			AND   pbv.assignment_id = p_balances_tab(i).assignment_id
			AND  pbv.DIMENSION_NAME IN( select distinct EBS_DIMENSION_NAME  from xxmx_pay_balances_scope where balance_type = 'CUSTOM')
			AND   pbv.business_group_id = 0
			AND PBV.effective_date =p_balances_tab(i).final_process_date
			and pbv.payroll_id = p_balances_tab(i).payroll_id;
			--and pbv.assignment_action_id = p_balances_tab(i).assignment_action_id;

        IF  MOD(l_counter,100) = 0
        THEN
            COMMIT;
        END IF;

	END LOOP;	


	l_counter := 0;
	FOR r_rehires IN c_rehires_addnl_balance LOOP
        l_counter := l_counter + 1;
		l_assignment_id := r_rehires.assignment_id;


	/*OPEN c_balance_asg_leaver;
	LOOP
	FETCH c_balance_asg_leaver BULK COLLECT INTO p_balances_tab;
	FORALL i IN 1..p_balances_tab.COUNT*/
	   /*    INSERT INTO xxmx_pay_ebs_addln_bal
            SELECT
                pt_i_MigrationSetID,
                pbv.balance_name,
                pbv.assignment_id,
                pbv.value balance_value,
                pbv.dimension_name,
                pbv.effective_date,
                pbv.assignment_action_id,
                pbv.payroll_action_id,
                pbv.balance_type_id,
                pbv.balance_dimension_id,
                pbv.defined_balance_id,
				r_rehires.assignment_number,
				'c_rehires_addnl_balance'
            FROM
                apps.pay_balance_values_v@mxdm_nvis_extract pbv
            WHERE
                 (pbv.balance_name ) IN( select distinct EBS_BAlance_name  from xxmx_pay_balances_scope where balance_type = 'CUSTOM')
                AND   pbv.assignment_id =r_rehires.assignment_id
                AND  pbv.DIMENSION_NAME IN( select distinct EBS_DIMENSION_NAME  from xxmx_pay_balances_scope where balance_type = 'CUSTOM')
               -- AND   pbv.effective_date = r_balance_asg.effective_date
                AND   pbv.business_group_id = 0
                AND PBV.effective_date =r_rehires.final_process_date
                and pbv.payroll_id =r_rehires.payroll_id;


	END LOOP;	*/
	--	
	--
	--

	--
	--
	COMMIT;
	EXCEPTION
               --
               WHEN e_ModuleError THEN
                    --
                    ROLLBACK;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RAISE;
               --** END e_ModuleError Exception
               WHEN OTHERS THEN
                    --
                    ROLLBACK;
                    --
                    gvt_OracleError := SUBSTR(SQLERRM||'** ERROR_BACKTRACE: '
                                           ||dbms_utility.format_error_backtrace,1,4000);
                    --
                    xxmx_utilities_pkg.log_module_message
                         (pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    RAISE;
               --** END OTHERS Exception
	END insert_pay_ebs_balances_addnl;	

	--***********************************
	-- Procedure xxmx_pay_ebs_balance_ext
	--***********************************

    PROCEDURE XXMX_PAY_EBS_BALANCE_EXT   (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
										 ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
    IS
    l_sysdate VARCHAR2(1000) := TO_CHAR(SYSDATE,'RRRRMMDDHH24MISS');

    TYPE t_balances_tab IS TABLE OF xxmx_pay_balances_stg%ROWTYPE INDEX BY PLS_INTEGER;
    p_balances_tab t_balances_tab;
    l_sum_value NUMBER;
    CURSOR c_multiple_balances
    IS

    WITH multiple_balances AS (
        SELECT
            COUNT(*),
            assignmentnumber,
            balancename,
            dimensionname,
            last_day(TO_DATE(uploaddate,'yyyy/mm/dd') ) uploaddate_ld,
            trunc(TO_DATE(uploaddate,'yyyy/mm/dd'),'MM') uploaddate_sd
        FROM
            xxmx_pay_balances_stg src1
        WHERE

               src1.headerorline = 'Line'
            AND   src1.payrollname NOT LIKE '%Weekly%'
            AND   src1.balancename NOT LIKE '%Weekly%'
        GROUP BY
            src1.balancename,
            src1.dimensionname,
            src1.assignmentnumber,
            last_day(TO_DATE(src1.uploaddate,'yyyy/mm/dd') ),
            trunc(TO_DATE(uploaddate,'yyyy/mm/dd'),'MM')
        HAVING
            COUNT(*) > 1
    ) SELECT
        src.assignmentnumber,
        src.balancename,
        src.dimensionname,
        src.uploaddate,
        src.value,
        src.linesequence,
        mb.uploaddate_sd,
        mb.uploaddate_ld,
        src.migration_Set_id,
        DENSE_RANK() OVER(
            PARTITION BY src.assignmentnumber,
            src.balancename,
            src.dimensionname,
            last_day(TO_DATE(src.uploaddate,'yyyy/mm/dd') )
            ORDER BY
                src.linesequence
        ) rnk
      FROM
        xxmx_pay_balances_stg src,
        multiple_balances mb
      WHERE
       -- src.batch_id = pfc_util_pkg.gc_cust_batch_id
           src.headerorline = 'Line'
        AND   src.assignmentnumber = mb.assignmentnumber
        AND   src.balancename = mb.balancename
        AND   src.dimensionname = mb.dimensionname
        AND   TO_DATE(src.uploaddate,'RRRR/MM/DD') BETWEEN mb.uploaddate_sd AND mb.uploaddate_ld;


        --***********************
          --** Constant Declarations
          --***********************
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'xxmx_pay_ebs_balance_ext';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXTRACT';
          ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE := 'xxmx_pay_balances_stg';
          --************************
          --** Variable Declarations
          --***********************
          vd_sysdate   VARCHAR(30); 
          --*************************
          --** Exception Declarations
          --***********************
          e_ModuleError                   EXCEPTION;
     --

    BEGIN

          gvv_ProgressIndicator := '0010';
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'MODULE'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F' THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'DATA'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F' THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
          END IF;
          --
          gvv_ProgressIndicator := '0030';
          --
          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --  
          gvt_MigrationSetName := 'Balance_Intialization_'|| l_sysdate||pt_i_MigrationSetID;
          --
          DELETE FROM xxmx_pay_balances_stg;
          COMMIT;
          --
          gvv_ProgressIndicator := '0040';
          --
          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Loop Through to Update Contexts'
               ,pt_i_OracleError       => NULL
               );

            FOR r_ctx IN (SELECT * FROM xxmx_pay_balance_contexts)
            LOOP
                UPDATE XXMX_PAY_BALANCE_CONTEXTS 
                SET process_type = NVL(get_ebs_screen_entry_val
                                                           (get_assignment_number(r_ctx.assignmentnumber,'N')
                                                           ,'NI','Process Type')
                                                      ,'N')
                WHERE assignmentnumber = r_ctx.assignmentnumber;
            END LOOP;		



          gvv_ProgressIndicator := '0050';
          --
          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Insert Into XXMX_PAY_BALANCES_STG'
               ,pt_i_OracleError       => NULL
               );


			INSERT INTO xxmx_pay_balances_stg
			  WITH balance_values AS (
			SELECT ebs_assignment_number,
						balance_name,
						dimension_name,
						effective_date,
						balance_value
  			  FROM 	xxmx_pay_ebs_balance_values_v
			),
			niable_pay_ytd AS (
			SELECT SUM(balance_value) balance_value,
					ebs_assignment_number,
					balance_name
			  FROM balance_values
			 WHERE balance_name = 'NIable Pay'
			   AND effective_date BETWEEN  TO_DATE(g_start_of_year,'DD/MM/RRRR') AND TO_DATE(g_cutoff_date,'DD/MM/RRRR')
			 GROUP BY ebs_assignment_number,
					balance_name
			)		
			SELECT * FROM (
				SELECT
				PT_I_MIGRATIONSETID                          migration_set_id ,               
				'BatchName'                         migration_set_name,
				'Migration_action'                           migration_action  ,
				'HeaderOrLine' headerorline,
				'LegislativeDataGroupName' ldg,
				'UploadDate' uploaddate,
				'SourceSystemOwner' sourcesystemowner,
				'LineSequence' linesequence,
				'AssignmentNumber' assignmentnumber,
				'BalanceDate' balancedate,
				'BalanceName' balancename,
				'ContextOneName' contextonename,
				'ContextOneValue' contextonevalue,
				'ContextTwoName' contexttwoname,
				'ContextTwoValue' contexttwovalue,
				'ContextThreeName' contextthreename,
				'ContextThreeValue' contextthreevalue,
				'ContextFourName' contextfourname,
				'ContextFourValue' contextfourvalue,
				'ContextFiveName' contextfivename,
				'ContextFiveValue' contextfivevalue,
				'DimensionName' dimensionname,
				'LegalEmployerName' legalemployername,
				'PayrollName' payrollname,
				'PayrollRelationshipNumber' payrollrelationshipnumber,
				'TermNumber' termnumber,
				'Value' value,
				NULL assignment_action_id ,
				NULL payroll_action_id ,
				NULL balance_type_id ,
				NULL balance_dimension_id ,
				NULL defined_balance_id 
				,UPPER(sys_context('userenv','OS_USER'))      created_by       
				,TO_CHAR(SYSDATE,'RRRR/MM/DD')                creation_date   
				,UPPER(sys_context('userenv','OS_USER'))      last_updated_by  
				,TO_CHAR(SYSDATE,'RRRR/MM/DD')                last_update_date     
			FROM dual
			UNION ALL
			SELECT
				PT_I_MIGRATIONSETID                          migration_set_id ,               
				gvt_MigrationSetName                        migration_set_name,
				'CREATE'                           migration_action  ,
				'Header' headerorline,
				'GB Legislative Data Group'  ldg,
				TO_CHAR(SYSDATE,'RRRR/MM/DD') uploaddate,
				'EBS' sourcesystemowner,
				'LineSequence' linesequence,
				'AssignmentNumber' assignmentnumber,
				'BalanceDate' balancedate,
				'BalanceName' balancename,
				'ContextOneName' contextonename,
				'ContextOneValue' contextonevalue,
				'ContextTwoName' contexttwoname,
				'ContextTwoValue' contexttwovalue,
				'ContextThreeName' contextthreename,
				'ContextThreeValue' contextthreevalue,
				'ContextFourName' contextfourname,
				'ContextFourValue' contextfourvalue,
				'ContextFiveName' contextfivename,
				'ContextFiveValue' contextfivevalue,
				'DimensionName' dimensionname,
				'LegalEmployerName' legalemployername,
				'PayrollName' payrollname,
				'PayrollRelationshipNumber' payrollrelationshipnumber,
				'TermNumber' termnumber,
				'Value' value,
				NULL assignment_action_id ,
				NULL payroll_action_id ,
				NULL balance_type_id ,
				NULL balance_dimension_id ,
				NULL defined_balance_id 
				,UPPER(sys_context('userenv','OS_USER'))      created_by       
				,TO_CHAR(SYSDATE,'RRRR/MM/DD')                creation_date   
				,UPPER(sys_context('userenv','OS_USER'))      last_updated_by  
				,TO_CHAR(SYSDATE,'RRRR/MM/DD')                last_update_date 
				FROM dual
		 UNION ALL
		  SELECT
			PT_I_MIGRATIONSETID                          migration_set_id ,               
			gvt_MigrationSetName          migration_set_name,
			'CREATE'                           migration_action  ,
			'Line' headerorline,
			'GB Legislative Data Group'  legislativedatagroupname,
			--TO_CHAR(effective_date,'RRRR/MM/DD') upload_date,
             TO_CHAR(SYSDATE,'RRRR/MM/DD') upload_date,
			'EBS' sourcesystemowner,
			NULL linesequence,
			fusion_asg_number assignmentnumber,
			--TO_CHAR(effective_date,'RRRR/MM/DD HH24:MI:SS') balance_date,
         TO_CHAR(TRUNC(SYSDATE),'RRRR/MM/DD HH24:MI:SS') balance_date,
			fusion_balance_name balancename,
			ctx_one,
			ctx_one_val,
			ctx_two,
			ctx_two_val,
			ctx_three,
			ctx_three_val,
			ctx_four,
			ctx_four_val,
			ctx_five,
			ctx_five_val,
			fusion_dimension_name,
			legal_employer_name,
			payroll_name,
			payrollrelationshipnumber,
			termnumber,
			TO_CHAR(balance_value) value,
			NULL assignment_action_id ,
			NULL payroll_action_id ,
			NULL balance_type_id ,
			NULL balance_dimension_id ,
			NULL defined_balance_id
			,UPPER(sys_context('userenv','OS_USER'))      created_by       
			,TO_CHAR(SYSDATE,'RRRR/MM/DD')                creation_date   
			,UPPER(sys_context('userenv','OS_USER'))      last_updated_by  
			,TO_CHAR(SYSDATE,'RRRR/MM/DD')                last_update_date 
			FROM (			
					  SELECT 
						bv.ebs_assignment_number,
						pbc.assignmentnumber fusion_asg_number,
						bv.effective_date,
						balscope.fusion_balance_name,
						--balscope.ebs_balance_name,
						balscope.fusion_dimension_name,
						bv.balance_value balance_value,
						balscope.ctx_one,
						DECODE(balscope.ctx_one,'Aggregation Information',to_CHAR(pbc.aggregation_information)
                                         ,'Term Number' , to_char(pbc.termnumber)
                                         ,'Payroll Relationship Number' , to_char(pbc.PAYROLLRELATIONSHIPNUMBER)
                                         ,'Reference Code',to_char( pbc.reference_Code)
                                         ,NULL,NULL) ctx_one_val,
						balscope.ctx_two ctx_two,
						DECODE(balscope.ctx_two,'Assignment Number',to_char(pbc.assignmentnumber)
                                         ,'Term Number',to_char(pbc.termnumber)
                                         ,'Tax Reporting Unit',to_char(pbc.tax_reporting_unit)
                                         ,'NI Category',to_char(pbc.ni_category)
                                         ,NULL,NULL) ctx_two_val,
						balscope.ctx_three ctx_three,
						DECODE(balscope.ctx_three,'NI Reporting HMRC Payroll ID',to_char(pbc.ni_reporting_hmrc_payroll_id)
                                          ,'Payroll Relationship Number',to_char(pbc.PAYROLLRELATIONSHIPNUMBER)
                                          ,'Pension Basis',to_char(pbc.pension_basis)
                                          ,NULL,NULL) ctx_three_val,
						balscope.ctx_four,
						DECODE(balscope.ctx_four,'Tax Reporting Unit',to_char(pbc.tax_reporting_unit)
                                          ,'Process Type',to_char(pbc.process_type)
                                          ,NULL,NULL) ctx_four_val,
						balscope.ctx_five,
						DECODE(balscope.ctx_five,'NI Reporting HMRC Payroll ID',to_char(pbc.ni_reporting_hmrc_payroll_id)
                                          ,'Tax Reporting Unit',to_char(pbc.tax_reporting_unit)
                                          ,NULL,NULL) ctx_five_val,
						pbc.legal_employer_name,
						pbc.payroll_name,
						pbc.payrollrelationshipnumber,
						pbc.termnumber
					  FROM balance_values bv,
							xxmx_pay_balances_Scope balscope,
							xxmx_pay_balance_contexts pbc
					  WHERE balscope.balance_type IN ('STATUTORY')
							 AND balscope.ebs_balance_name =  bv.balance_name
							 AND pbc.assignmentnumber ='E'||bv.ebs_assignment_number
							 AND (( REGEXP_SUBSTR(ebs_balance_name,'[[:alpha:]]+',1,2)  = pbc.ni_category
							 --AND bv.effective_date BETWEEN TO_DATE(pbc.ni_esd,'RRRR-MM-DD') AND TO_DATE(pbc.ni_eed,'RRRR-MM-DD')
							 )
								OR balscope.ctx_two IS NULL)
							 AND bv.balance_name <> 'NIable Pay'
					 /* GROUP BY 	bv.ebs_assignment_number,
						pbc.assignmentnumber,
						bv.effective_date,
						balscope.fusion_balance_name,
						--balscope.ebs_balance_name,
						balscope.fusion_dimension_name,
						balscope.ctx_one,
						DECODE(balscope.ctx_one,'Aggregation Information',to_CHAR(pbc.aggregation_information)
                                         ,'Term Number' , to_char(pbc.termnumber)
                                         ,'Payroll Relationship Number' , to_char(pbc.PAYROLLRELATIONSHIPNUMBER)
                                         ,'Reference Code',to_char( pbc.reference_Code)
                                         ,NULL,NULL) ,
						balscope.ctx_two ,
						DECODE(balscope.ctx_two,'Assignment Number',to_char(pbc.assignmentnumber)
                                         ,'Term Number',to_char(pbc.termnumber)
                                         ,'Tax Reporting Unit',to_char(pbc.tax_reporting_unit)
                                         ,'NI Category',to_char(pbc.ni_category)
                                         ,NULL,NULL) ,
						balscope.ctx_three ,
						DECODE(balscope.ctx_three,'NI Reporting HMRC Payroll ID',to_char(pbc.ni_reporting_hmrc_payroll_id)
                                          ,'Payroll Relationship Number',to_char(pbc.PAYROLLRELATIONSHIPNUMBER)
                                          ,'Pension Basis',to_char(pbc.pension_basis)
                                          ,NULL,NULL) ,
						balscope.ctx_four,
						DECODE(balscope.ctx_four,'Tax Reporting Unit',to_char(pbc.tax_reporting_unit)
                                          ,'Process Type',to_char(pbc.process_type)
                                          ,NULL,NULL) ,
						balscope.ctx_five,
						DECODE(balscope.ctx_five,'NI Reporting HMRC Payroll ID',to_char(pbc.ni_reporting_hmrc_payroll_id)
                                          ,'Tax Reporting Unit',to_char(pbc.tax_reporting_unit)
                                          ,NULL,NULL) ,
                  pbc.legal_employer_name,
						pbc.payroll_name,
						pbc.payrollrelationshipnumber,
						pbc.termnumber*/
					UNION
					SELECT  bv.ebs_assignment_number,
							pbc.assignmentnumber fusion_asg_number,
							bv.effective_date, --upload_date
							balscope.fusion_balance_name,
							--balscope.ebs_balance_name,
							balscope.fusion_dimension_name,
							bv.balance_value balance_value,
							balscope.ctx_one,
							DECODE(balscope.ctx_one,'Aggregation Information',to_CHAR(pbc.aggregation_information)
                                         ,'Term Number' , to_char(pbc.termnumber)
                                         ,'Payroll Relationship Number' , to_char(pbc.PAYROLLRELATIONSHIPNUMBER)
                                         ,'Reference Code',to_char( pbc.reference_Code)
                                         ,NULL,NULL) ctx_one_val,
						balscope.ctx_two ctx_two,
						DECODE(balscope.ctx_two,'Assignment Number',to_char(pbc.assignmentnumber)
                                         ,'Term Number',to_char(pbc.termnumber)
                                         ,'Tax Reporting Unit',to_char(pbc.tax_reporting_unit)
                                         ,'NI Category',to_char(pbc.ni_category)
                                         ,NULL,NULL) ctx_two_val,
						balscope.ctx_three ctx_three,
						DECODE(balscope.ctx_three,'NI Reporting HMRC Payroll ID',to_char(pbc.ni_reporting_hmrc_payroll_id)
                                          ,'Payroll Relationship Number',to_char(pbc.PAYROLLRELATIONSHIPNUMBER)
                                          ,'Pension Basis',to_char(pbc.pension_basis)
                                          ,NULL,NULL) ctx_three_val,
						balscope.ctx_four,
						DECODE(balscope.ctx_four,'Tax Reporting Unit',to_char(pbc.tax_reporting_unit)
                                          ,'Process Type',to_char(pbc.process_type)
                                          ,NULL,NULL) ctx_four_val,
						balscope.ctx_five,
						DECODE(balscope.ctx_five,'NI Reporting HMRC Payroll ID',to_char(pbc.ni_reporting_hmrc_payroll_id)
                                          ,'Tax Reporting Unit',to_char(pbc.tax_reporting_unit)
                                          ,NULL,NULL) ctx_five_val,
                     pbc.legal_employer_name,
							pbc.payroll_name,
							pbc.payrollrelationshipnumber,
							pbc.termnumber
				   FROM balance_values bv,
						xxmx_pay_balances_Scope balscope,
						xxmx_pay_balance_contexts pbc
				 WHERE balscope.balance_type IN ('STATUTORY')
					 AND balscope.ebs_balance_name =  bv.balance_name
					 AND pbc.assignmentnumber = 'E'||bv.ebs_assignment_number
					 AND ebs_balance_name = 'NIable Pay'
					 AND balscope.ebs_dimension_name LIKE '_ASG_RUN'
					-- AND bv.effective_date > LAST_DAY(TO_DATE(g_start_of_year,'DD/MM/RRRR'))
				 /*GROUP BY 	bv.ebs_assignment_number,
						pbc.assignmentnumber,
						bv.effective_date,
						balscope.fusion_balance_name,
						--balscope.ebs_balance_name,
						balscope.fusion_dimension_name,					
						balscope.ctx_one,
						DECODE(balscope.ctx_one,'Aggregation Information',to_CHAR(pbc.aggregation_information)
                                         ,'Term Number' , to_char(pbc.termnumber)
                                         ,'Payroll Relationship Number' , to_char(pbc.PAYROLLRELATIONSHIPNUMBER)
                                         ,'Reference Code',to_char( pbc.reference_Code)
                                         ,NULL,NULL) ,
						balscope.ctx_two ,
						DECODE(balscope.ctx_two,'Assignment Number',to_char(pbc.assignmentnumber)
                                         ,'Term Number',to_char(pbc.termnumber)
                                         ,'Tax Reporting Unit',to_char(pbc.tax_reporting_unit)
                                         ,'NI Category',to_char(pbc.ni_category)
                                         ,NULL,NULL) ,
						balscope.ctx_three ,
						DECODE(balscope.ctx_three,'NI Reporting HMRC Payroll ID',to_char(pbc.ni_reporting_hmrc_payroll_id)
                                          ,'Payroll Relationship Number',to_char(pbc.PAYROLLRELATIONSHIPNUMBER)
                                          ,'Pension Basis',to_char(pbc.pension_basis)
                                          ,NULL,NULL) ,
						balscope.ctx_four,
						DECODE(balscope.ctx_four,'Tax Reporting Unit',to_char(pbc.tax_reporting_unit)
                                          ,'Process Type',to_char(pbc.process_type)
                                          ,NULL,NULL) ,
						balscope.ctx_five,
						DECODE(balscope.ctx_five,'NI Reporting HMRC Payroll ID',to_char(pbc.ni_reporting_hmrc_payroll_id)
                                          ,'Tax Reporting Unit',to_char(pbc.tax_reporting_unit)
                                          ,NULL,NULL) ,
                  pbc.legal_employer_name,
						pbc.payroll_name,
						pbc.payrollrelationshipnumber,
						pbc.termnumber*/
				 )
				 ORDER BY assignmentnumber, balancename, dimensionname 
				);

           /* WITH balance_values AS (
                SELECT ebs_assignment_number,
                            balance_name,
                            dimension_name,
                            effective_date,
                            balance_value
                  FROM 	xxmx_pay_ebs_balance_values_v
            ),
            niable_pay_ytd AS (
            SELECT SUM(balance_value) balance_value,
                    ebs_assignment_number,
                    balance_name
              FROM balance_values
             WHERE balance_name = 'NIable Pay'
               AND effective_date BETWEEN  TO_DATE(g_start_of_year,'DD/MM/RRRR') AND TO_DATE(g_cutoff_date,'DD/MM/RRRR')
             GROUP BY ebs_assignment_number,
                    balance_name
            )
            SELECT * FROM (
                SELECT
                 pt_i_MigrationSetID                          migration_set_id ,               
                'Migration Set Name'                         migration_set_name,
                'Migration Action'                           migration_action  ,
                'HeaderOrLine' headerorline,
                'LegislativeDataGroupName' ldg,           
                'UploadDate' uploaddate,
                'SourceSystemOwner' sourcesystemowner,
                'LineSequence' linesequence,
                'AssignmentNumber' assignmentnumber,
                'BalanceDate' balancedate,
                'BalanceName' balancename,
                'ContextOneName' contextonename,
                'ContextOneValue' contextonevalue,
                'ContextTwoName' contexttwoname,
                'ContextTwoValue' contexttwovalue,
                'ContextThreeName' contextthreename,
                'ContextThreeValue' contextthreevalue,
                'ContextFourName' contextfourname,
                'ContextFourValue' contextfourvalue,
                'ContextFiveName' contextfivename,
                'ContextFiveValue' contextfivevalue,
                'DimensionName' dimensionname,
                'LegalEmployerName' legalemployername,
                'PayrollName' payrollname,
                'PayrollRelationshipNumber' payrollrelationshipnumber,
                'TermNumber' termnumber,
                'Value' value,
                NULL assignment_action_id ,
                NULL payroll_action_id ,
                NULL balance_type_id ,
                NULL balance_dimension_id ,
                NULL defined_balance_id 
            ,UPPER(sys_context('userenv','OS_USER'))      created_by       
            ,TO_CHAR(SYSDATE,'RRRR/MM/DD')                creation_date   
            ,UPPER(sys_context('userenv','OS_USER'))      last_updated_by  
            ,TO_CHAR(SYSDATE,'RRRR/MM/DD')                last_update_date     
            --,NULL 									ebs_asg_number
            FROM dual
            UNION ALL
            SELECT
                 pt_i_MigrationSetID                          migration_set_id  ,
                'Migration Set Name'                         migration_set_name,
                'Migration Action'                           migration_action  ,
                'Header' headerorline,
                'GB Legislative Data Group' ldg,
                TO_CHAR(SYSDATE,'RRRR/MM/DD') uploaddate,
                'EBS' sourcesystemowner,
                'LineSequence' linesequence,
                'AssignmentNumber' assignmentnumber,
                'BalanceDate' balancedate,
                'BalanceName' balancename,
                'ContextOneName' contextonename,
                'ContextOneValue' contextonevalue,
                'ContextTwoName' contexttwoname,
                'ContextTwoValue' contexttwovalue,
                'ContextThreeName' contextthreename,
                'ContextThreeValue' contextthreevalue,
                'ContextFourName' contextfourname,
                'ContextFourValue' contextfourvalue,
                'ContextFiveName' contextfivename,
                'ContextFiveValue' contextfivevalue,
                'DimensionName' dimensionname,
                'LegalEmployerName' legalemployername,
                'PayrollName' payrollname,
                'PayrollRelationshipNumber' payrollrelationshipnumber,
                'TermNumber' termnumber,
                'Value' value,
                NULL assignment_action_id ,
                NULL payroll_action_id ,
                NULL balance_type_id ,
                NULL balance_dimension_id ,
                NULL defined_balance_id ,
                UPPER(sys_context('userenv','OS_USER'))      created_by   ,  
                TO_CHAR(SYSDATE,'RRRR/MM/DD')                creation_date ,  
                UPPER(sys_context('userenv','OS_USER'))      last_updated_by , 
                TO_CHAR(SYSDATE,'RRRR/MM/DD')                last_update_date 
              --  NULL
                FROM dual
                )
        UNION ALL
          SELECT  
             pt_i_MigrationSetID                  migration_set_id  ,
             gvt_MigrationSetName                 migration_set_name,
            'CREATE'                              migration_action  ,
            'Line'							      headerorline,
            'GB Legislative Data Group'           legislativedatagroupname,
            TO_CHAR(effective_date,'RRRR/MM/DD')  upload_date,
            'EBS'  sourcesystemowner,
            NULL linesequence,
            fusion_asg_number assignmentnumber,
            TO_CHAR(effective_date,'RRRR/MM/DD HH24:MI:SS') balance_date,
            fusion_balance_name balancename,
            ctx_one,
            ctx_one_val,
            ctx_two,
            ctx_two_val,
            ctx_three,
            ctx_three_val,
            ctx_four,
            ctx_four_val,
            ctx_five,
            ctx_five_val,
            fusion_balance_dimension,
            legal_employer_name,
            payroll_name,
            payrollrelationshipnumber,
            termnumber,
            TO_CHAR(balance_value) value,
            NULL assignment_action_id ,
            NULL payroll_action_id ,
            NULL balance_type_id ,
            NULL balance_dimension_id ,
            NULL defined_balance_id
            ,UPPER(sys_context('userenv','OS_USER'))      created_by       
            ,TO_CHAR(SYSDATE,'RRRR/MM/DD')                creation_date   
            ,UPPER(sys_context('userenv','OS_USER'))      last_updated_by  
            ,TO_CHAR(SYSDATE,'RRRR/MM/DD')                last_update_date     
            --,ebs_assignment_number
            FROM (			
                SELECT 
                        bv.ebs_assignment_number,
                        pbc.assignmentnumber fusion_asg_number,
                        bv.effective_date,
                        balscope.fusion_balance_name,
                        --balscope.ebs_balance_name,
                        balscope.fusion_balance_dimension,
                        bv.balance_value balance_value,
                        'Aggregation Information'              ctx_one,
                        TO_CHAR(pbc.aggregation_information)  ctx_one_val,
                        'NI Category' ctx_two,
                        TO_CHAR(pbc.ni_category) ctx_two_val,
                        'Pension Basis' ctx_three,
                        TO_CHAR(pbc.pension_basis) ctx_three_val,
                        'Process Type'  ctx_four,
                        TO_CHAR(pbc.process_type) ctx_four_val,
                        'NI Reporting HMRC Payroll ID'  ctx_five,
                        TO_CHAR(pbc.ni_reporting_hmrc_payroll_id) ctx_five_val,
                        pbc.legal_employer_name,
                        pbc.payroll_name,
                        TO_CHAR(pbc.payrollrelationshipnumber) payrollrelationshipnumber,
                        pbc.termnumber
                      FROM balance_values bv,
                            xxmx_pay_balances_map balscope,
                            xxmx_pay_balance_contexts pbc
                      WHERE balscope.balance_type IN ('STATUTORY','ADDITIONAL')
                             AND balscope.ebs_balance_name =  bv.balance_name
                             AND pbc.assignmentnumber = 'E'||bv.ebs_assignment_number
                             AND ( REGEXP_SUBSTR(ebs_balance_name,'[[:alpha:]]+',1,2)  = pbc.ni_category
                             --AND bv.effective_date BETWEEN TO_DATE(pbc.ni_esd,'RRRR-MM-DD') AND TO_DATE(pbc.ni_eed,'RRRR-MM-DD')
                             )
                             AND bv.balance_name <> 'NIable Pay'
                UNION 
                    SELECT  bv.ebs_assignment_number,
                            pbc.assignmentnumber fusion_asg_number,
                            bv.effective_date, --upload_date
                            balscope.fusion_balance_name,
                            --balscope.ebs_balance_name,
                            balscope.fusion_balance_dimension,
                            SUM(bv.balance_value) balance_value,
                            'Aggregation Information'              ctx_one,
                            TO_CHAR(pbc.aggregation_information)  ctx_one_val,
                            'NI Category' ctx_two,
                            TO_CHAR(pbc.ni_category) ctx_two_val,
                            'Pension Basis' ctx_three,
                            TO_CHAR(pbc.pension_basis) ctx_three_val,
                            'Process Type'  ctx_four,
                            TO_CHAR(pbc.process_type) ctx_four_val,
                            'NI Reporting HMRC Payroll ID'  ctx_five,
                            TO_CHAR(pbc.ni_reporting_hmrc_payroll_id) ctx_five_val,
                            pbc.legal_employer_name,
                            pbc.payroll_name,
                            TO_CHAR(pbc.payrollrelationshipnumber) payrollrelationshipnumber,
                            pbc.termnumber
                   FROM balance_values bv,
                        xxmx_pay_balances_map balscope,
                        xxmx_pay_balance_contexts pbc
                 WHERE balscope.balance_type IN ('STATUTORY','ADDITIONAL')
                     AND balscope.ebs_balance_name =  bv.balance_name
                     AND pbc.assignmentnumber = 'E'||bv.ebs_assignment_number
                     AND ebs_balance_name = 'NIable Pay'
                     AND balscope.ebs_balance_dimension LIKE '_ASG_RUN%'
                 GROUP BY 	bv.ebs_assignment_number,
                        pbc.assignmentnumber,
                        bv.effective_date,
                        balscope.fusion_balance_name,
                        --balscope.ebs_balance_name,
                        balscope.fusion_balance_dimension,					
                        'Aggregation Information'    ,
                        pbc.aggregation_information  ,
                        'NI Category' ,
                        pbc.ni_category ,
                        'Pension Basis' ,
                        pbc.pension_basis ,
                        'Process Type'  ,
                        pbc.process_type ,
                        'NI Reporting HMRC Payroll ID'  ,
                        pbc.ni_reporting_hmrc_payroll_id ,
                        pbc.legal_employer_name,
                        pbc.payroll_name,
                        pbc.payrollrelationshipnumber,
                        pbc.termnumber 
                );*/

	UPDATE XXMX_pay_balances_stg
           SET linesequence = ROWNUM||pt_i_MigrationSetID
		 WHERE headerorline = 'Line'
		   AND migration_Set_id =  pt_i_MigrationSetID;
                --ORDER BY  balancename, dimensionname 
            COMMIT;

         EXCEPTION
          WHEN e_ModuleError THEN
                    --
                    ROLLBACK;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RAISE;
               --** END e_ModuleError Exception
               --
          WHEN OTHERS THEN
                    --
                    ROLLBACK;
                    --
                    gvt_OracleError := SUBSTR(SQLERRM||'** ERROR_BACKTRACE: '
                                           ||dbms_utility.format_error_backtrace,1,4000);
                    --
                    xxmx_utilities_pkg.log_module_message
                         (pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    RAISE;
               --** END OTHERS Exception
          --** END Exception Handler     

        END xxmx_pay_ebs_balance_ext; 

	 --********************************
     --** PROCEDURE: pay_cus_balances_stg
     --********************************
     PROCEDURE pay_cus_balances_stg
                    (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
     IS
          --***********************
          --** CURSOR Declarations
          --***********************
          l_sysdate VARCHAR2(1000) := TO_CHAR(SYSDATE,'RRRRMMDDHH24MISS');

          CURSOR EbsAssignments_cur IS
              SELECT  DISTINCT
                       ebs_assignment_number
                      ,balance_name
                      ,dimension_name
                      ,effective_date
              FROM     xxmx_pay_ebs_balances bal
              WHERE    1 = 1
              AND      bal.assignment_action_id = (
                                                   SELECT  MAX(assignment_action_id)
                                                   FROM    xxmx_pay_ebs_balances bal1
                                                   WHERE   1 = 1
                                                   AND     bal.assignment_id  = bal1.assignment_id
                                                   AND     bal.balance_name   = bal1.balance_name
                                                   AND     bal.dimension_name = bal1.dimension_name
                                                   AND     bal.effective_date = bal1.effective_date
                                                  )                           
              ORDER BY ebs_assignment_number, balance_name ASC;
          --
          --***********************
          --** Constant Declarations
          --***********************
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'pay_cus_balances_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXTRACT';
          ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE := 'xxmx_pay_cus_balances_stg';
          --************************
          --** Variable Declarations
          --***********************
          vd_sysdate   VARCHAR(30); 
          --*************************
          --** Exception Declarations
          --***********************
          e_ModuleError                   EXCEPTION;
     --
     BEGIN
          --
          gvv_ProgressIndicator := '0010';
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'MODULE'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F' THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          DELETE FROM xxmx_pay_ebs_addln_bal;
          DELETE FROM xxmx_pay_cus_bal_stg;

          COMMIT;
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'DATA'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          gvv_ProgressIndicator := '0030';
          --
          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          gvv_ProgressIndicator := '0040';
          --
          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
          --
          IF   gvt_MigrationSetName IS NOT NULL THEN
               --
               gvv_ProgressIndicator := '0050';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Extracting "'||pt_i_SubEntity||'":'
                    ,pt_i_OracleError       => NULL
                    );
               --
               xxmx_utilities_pkg.init_migration_details
                    (pt_i_ApplicationSuite => gct_ApplicationSuite
                    ,pt_i_Application      => gct_Application
                    ,pt_i_BusinessEntity   => gcv_BusinessEntity
                    ,pt_i_SubEntity        => pt_i_SubEntity
                    ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                    ,pt_i_StagingTable     => ct_StgTable
                    ,pt_i_ExtractStartDate => SYSDATE
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Staging Table "'||ct_StgTable||'" reporting details initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               -- 
               --
               --
			   gvv_ProgressIndicator := '0061';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => 'call procedure insert_pay_ebs_balances_addnl to populate the temp table xxmx_pay_balances_stg'
                    ,pt_i_OracleError       => NULL
                    );


			   insert_pay_ebs_balances_addnl( pt_i_MigrationSetID, pt_i_SubEntity);

               gvv_ProgressIndicator := '0070';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => 'Procedure insert_pay_ebs_balances_addnl returned'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0080';
               --
               --** Extract the Entity data and insert into the staging table.
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extracting Header data into "'||ct_StgTable||'".'
                    ,pt_i_OracleError       => NULL
                    );
                    -- 

                INSERT INTO xxmx_pay_cus_bal_stg
                    SELECT
                    PT_I_MIGRATIONSETID                          migration_set_id ,               
                    'BatchName'                         migration_set_name,
                    'Migration_action'                           migration_action  ,
                    'HeaderOrLine' headerorline,
                    'LegislativeDataGroupName' ldg,
                    'UploadDate' uploaddate,
                    'SourceSystemOwner' sourcesystemowner,
                    'LineSequence' linesequence,
                    'AssignmentNumber' assignmentnumber,
                    'BalanceDate' balancedate,
                    'BalanceName' balancename,
                    'ContextOneName' contextonename,
                    'ContextOneValue' contextonevalue,
                    'ContextTwoName' contexttwoname,
                    'ContextTwoValue' contexttwovalue,
                    'ContextThreeName' contextthreename,
                    'ContextThreeValue' contextthreevalue,
                    'ContextFourName' contextfourname,
                    'ContextFourValue' contextfourvalue,
                    'ContextFiveName' contextfivename,
                    'ContextFiveValue' contextfivevalue,
                    'DimensionName' dimensionname,
                    'LegalEmployerName' legalemployername,
                    'PayrollName' payrollname,
                    'PayrollRelationshipNumber' payrollrelationshipnumber,
                    'TermNumber' termnumber,
                    'Value' value,
                    NULL assignment_action_id ,
                    NULL payroll_action_id ,
                    NULL balance_type_id ,
                    NULL balance_dimension_id ,
                    NULL defined_balance_id 
                    ,UPPER(sys_context('userenv','OS_USER'))      created_by       
                    ,TO_CHAR(SYSDATE,'RRRR/MM/DD')                creation_date   
                    ,UPPER(sys_context('userenv','OS_USER'))      last_updated_by  
                    ,TO_CHAR(SYSDATE,'RRRR/MM/DD')                last_update_date     
                FROM dual
			UNION ALL
                SELECT
                    PT_I_MIGRATIONSETID                          migration_set_id ,               
                    'Balance_Intialization_'|| l_sysdate ||pt_i_MigrationSetID     migration_set_name,
                    'CREATE'                           migration_action  ,
                    'Header' headerorline,
                    'GB Legislative Data Group'  ldg,
                    TO_CHAR(SYSDATE,'RRRR/MM/DD') uploaddate,
                    'EBS' sourcesystemowner,
                    'LineSequence' linesequence,
                    'AssignmentNumber' assignmentnumber,
                    'BalanceDate' balancedate,
                    'BalanceName' balancename,
                    'ContextOneName' contextonename,
                    'ContextOneValue' contextonevalue,
                    'ContextTwoName' contexttwoname,
                    'ContextTwoValue' contexttwovalue,
                    'ContextThreeName' contextthreename,
                    'ContextThreeValue' contextthreevalue,
                    'ContextFourName' contextfourname,
                    'ContextFourValue' contextfourvalue,
                    'ContextFiveName' contextfivename,
                    'ContextFiveValue' contextfivevalue,
                    'DimensionName' dimensionname,
                    'LegalEmployerName' legalemployername,
                    'PayrollName' payrollname,
                    'PayrollRelationshipNumber' payrollrelationshipnumber,
                    'TermNumber' termnumber,
                    'Value' value,
                    NULL assignment_action_id ,
                    NULL payroll_action_id ,
                    NULL balance_type_id ,
                    NULL balance_dimension_id ,
                    NULL defined_balance_id 
                    ,UPPER(sys_context('userenv','OS_USER'))      created_by       
                    ,TO_CHAR(SYSDATE,'RRRR/MM/DD')                creation_date   
                    ,UPPER(sys_context('userenv','OS_USER'))      last_updated_by  
                    ,TO_CHAR(SYSDATE,'RRRR/MM/DD')                last_update_date 
                    FROM dual
                UNION
                    SELECT  
                     pt_i_MigrationSetID                  migration_set_id  ,
                    'Balance_Intialization_'|| l_sysdate ||pt_i_MigrationSetID     migration_set_name,
                    'CREATE'                              migration_action  ,
                    'Line' headerorline,
                    'GB Legislative Data Group'                  legislativedatagroupname,
                    --TO_CHAR(effective_date,'RRRR/MM/DD') upload_date,
                    TO_CHAR(SYSDATE,'RRRR/MM/DD') uploaddate,
                    'EBS' sourcesystemowner,
                    NULL linesequence,
                    fusion_asg_number assignmentnumber,
                    --TO_CHAR(effective_date,'RRRR/MM/DD HH24:MI:SS') balance_date,
                    TO_CHAR(LAST_DAY(TO_DATE(SYSDATE,'DD/MM/RRRR')) ,'RRRR/MM/DD HH24:MI:SS') balance_date,
                    fusion_balance_name balancename,
                    ctx_one,
                    ctx_one_val,
                    ctx_two,
                    ctx_two_val,
                    ctx_three,
                    ctx_three_val,
                    ctx_four,
                    ctx_four_val,
                    ctx_five,
                    ctx_five_val,
                    fusion_dimension_name,
                    legal_employer_name,
                    payroll_name,
                    payrollrelationshipnumber,
                    termnumber,
                    TO_CHAR(balance_value) value,
                    NULL assignment_action_id ,
                    NULL payroll_action_id ,
                    NULL balance_type_id ,
                    NULL balance_dimension_id ,
                    NULL defined_balance_id
                    ,UPPER(sys_context('userenv','OS_USER'))      created_by          
                    ,TO_CHAR(SYSDATE,'RRRR/MM/DD')                last_update_date  
                    ,UPPER(sys_context('userenv','OS_USER'))      created_by       
                    ,TO_CHAR(SYSDATE,'RRRR/MM/DD')                last_update_date  
                    FROM (SELECT 
                        bv.ebs_assignment_number,
                        pbc.assignmentnumber fusion_asg_number,
                        bv.effective_date,
                        balscope.fusion_balance_name,
                        balscope.fusion_dimension_name,
                        bv.balance_value balance_value,
                        NULL ctx_one,
                        NULL ctx_one_val,
                        NULL ctx_two,
                        NULL ctx_two_val,
                        NULL ctx_three,
                        NULL ctx_three_val,
                        NULL ctx_four,
                        NULL ctx_four_val,
                        'NI Reporting HMRC Payroll ID'  ctx_five,
                        TO_CHAR(pbc.ni_reporting_hmrc_payroll_id) ctx_five_val,
                        pbc.legal_employer_name,
                        pbc.payroll_name,
                        TO_CHAR(pbc.payrollrelationshipnumber) payrollrelationshipnumber,
                        pbc.termnumber
				  FROM xxmx_pay_ebs_addln_bal bv,
                       xxmx_pay_balances_scope balscope,
					   xxmx_pay_balance_contexts pbc
				  WHERE balscope.balance_type IN ('CUSTOM')
             	  AND balscope.ebs_balance_name =  bv.balance_name
				  AND pbc.assignmentnumber ='E'||bv.ebs_assignment_number
                  AND assignment_action_id = (
							SELECT   MAX(assignment_action_id)
							FROM  xxmx_pay_ebs_addln_bal bal1
							WHERE 	bv.assignment_id = bal1.assignment_id
                            AND   bv.balance_name = bal1.balance_name
							AND   bv.dimension_name = bal1.dimension_name
							)
                    )
				 ;


		END IF;



	UPDATE xxmx_pay_cus_bal_stg
           SET linesequence = ROWNUM||pt_i_MigrationSetID
		 WHERE headerorline = 'Line'
		   AND migration_Set_id =  pt_i_MigrationSetID;

     COMMIT;
--
     EXCEPTION
          WHEN e_ModuleError THEN
                    --
                    ROLLBACK;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RAISE;
               --** END e_ModuleError Exception
               --
          WHEN OTHERS THEN
                    --
                    ROLLBACK;
                    --
                    gvt_OracleError := SUBSTR(SQLERRM||'** ERROR_BACKTRACE: '
                                           ||dbms_utility.format_error_backtrace,1,4000);
                    --
                    xxmx_utilities_pkg.log_module_message
                         (pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    RAISE;
               --** END OTHERS Exception
          --** END Exception Handler     
     END pay_cus_balances_stg;

      PROCEDURE SMBC_calc_cards_pae_stg
                    (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
     IS
          --   -- CALC_CARDS_PAE     pay_calc_cards_pae_stg
          --** CURSOR Declarations

         CURSOR C_PAE_Both
         IS 
         select PAE_BAL.*
         From XXMX_PAE_EBS_INFO_V PAE_BAL, pay_payrolls_f@mxdm_nvis_extract pay
         where pay.payroll_id =PAE_BAL.payroll_id
         and PAE_BAL.QUALIFY_SCHEME IS NOT NULL
         and trunc(sysdate) between pay.effective_start_date and pay.effective_end_date
         and pay.payroll_name IN( Select parameter_value 
                                                    From xxmx_migration_parameters
                                                    where parameter_code= 'PAYROLL_NAME'
                                                    and enabled_flag = 'Y')
        ;

          --** END CURSOR << >>
          --          
          --***********************
          --** Constant Declarations
          --***********************
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'pay_calc_cards_pae_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXTRACT';
          ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE := 'xxmx_pay_calc_cards_pae_stg';
          --************************
          --** Variable Declarations
          --***********************
          vd_BeginDate                   DATE;
          --
          vv_compassoc_sourcesysid       VARCHAR2(100)  := 'CompAssoc_PAE_';
          vv_compassoc_sourcesysowner    VARCHAR2(100)  := 'EBS'; 
          vv_compassocdtl_sourcesysid    VARCHAR2(100)  := 'CompAssocDtl_PAE_';  
          vv_compassocdtl_sourcesysowner VARCHAR2(100)  := 'EBS' ;
          vv_information_category        VARCHAR2(100)  := 'ORA_HRX_GB_PAE_ADNL';
          vv_dir_info_category           VARCHAR2(100)  := 'HRX_GB_PAE';
          --*************************
          --** Exception Declarations
          --***********************
          e_ModuleError                   EXCEPTION;
     --** END Declarations
     BEGIN
          gvv_ProgressIndicator := '0010';
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'MODULE'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F' THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          gvv_ReturnStatus  := '';
          --
          xxmx_utilities_pkg.clear_messages
               (pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gcv_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages for all previous runs are deleted.
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'DATA'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F' THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               RAISE e_ModuleError;
          END IF;
          --
          gvv_ProgressIndicator := '0030';
          --
          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          gvv_ProgressIndicator := '0040';

          xxmx_utilities_pkg.log_module_message
               (pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gcv_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Get Migration Set Name for  "'||pt_i_MigrationSetID
               ,pt_i_OracleError       => NULL
               );
          --
          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);

          DELETE FROM xxmx_pay_calc_cards_pae_stg;
          --
          IF   gvt_MigrationSetName IS NOT NULL THEN
               --
               gvv_ProgressIndicator := '0050';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Extracting "'||pt_i_SubEntity||'":'
                    ,pt_i_OracleError       => NULL
                    );
               --
               xxmx_utilities_pkg.init_migration_details
                    (pt_i_ApplicationSuite => gct_ApplicationSuite
                    ,pt_i_Application      => gct_Application
                    ,pt_i_BusinessEntity   => gcv_BusinessEntity
                    ,pt_i_SubEntity        => pt_i_SubEntity
                    ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                    ,pt_i_StagingTable     => ct_StgTable
                    ,pt_i_ExtractStartDate => SYSDATE
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Staging Table "'||ct_StgTable||'" reporting details initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
                    gvv_ProgressIndicator := '0060';
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extracting Header Record into "'||ct_StgTable||'".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               INSERT INTO   xxmx_pay_calc_cards_pae_stg
               SELECT  pt_i_MigrationSetID               -- migration_set_id  
                     ,'Migration Set Name'              -- migration_set_name 
                     ,'Migration Action'                -- migration_action  
                     ,'Header'                          -- header_or_line
                     ,'CardComponent_SourceSystemId'    -- cardcomponent_sourcesystemid
                     ,'CardComponent_SourceSystemOwner' -- cardcomponent_sourcesystemowner
                     ,'EffectiveStartDate'              -- effectivestartdate
                     ,'EffectiveEndDate'                -- effectiveenddate
                     ,'DirCardCompDefName'              -- dircardcompdefname
                     ,'LegislativeDataGroupName'        -- legislativedatagroupname
                     ,'DirCardId_SourceSystemId'        -- dircardid_sourcesystemid
                     ,'CompAssoc_SourceSystemId'        -- compassoc_sourcesystemid
                     ,'CompAssoc_SourceSystemOwner'     -- compassoc_sourcesystemowner
                     ,'TaxReportingUnitName'            -- taxreportingunitname
                     ,'AssignmentNumber'                -- assignmentnumber
                     ,'CompAssocDtl_SourceSystemId'     -- compassocdtl_sourcesystemid
                     ,'CompAssocDtl_SourceSystemOwner'  -- compassocdtl_sourcesystemowner
                     ,'FLEX_Deduction_Developer_DF'     -- flex_deduction_developer_df
                     ,'EMPLOYEE_CLASSIFICATION'         -- employee_classification
                     ,'ELIGIBLE_JOBHOLDER_DATE'         -- eligible_jobholder_date
                     ,'RE_ENROLMENT_ASSESSMENT_ONLY'    -- re_enrolment_assessment_only
                     ,'CLASSIFICATION_CHANGED_PROC_DT'  -- classification_changed_proc_dt
                     ,'ACTIVE_POSTPONEMENT_TYPE'        -- active_postponement_type
                     ,'ACTIVE_POSTPONEMENT_RULE'        -- active_postponement_rule
                     ,'ACTIVE_POSTPONEMENT_END_DATE'    -- active_postponement_end_date
                     ,'ACTIVE_QUALIFYING_SCHEME'        -- active_qualifying_scheme
                     ,'QUALIFYING_SCHEME_JOIN_DATE'     -- qualifying_scheme_join_date
                     ,'QUALIFYING_SCHEME_START_DATE'    -- qualifying_scheme_start_date
                     ,'QUALIFYING_SCHEME_JOIN_METHOD'   -- qualifying_scheme_join_method
                     ,'TRANSFER_QUALIFYING_SCHEME'      -- transfer_qualifying_scheme
                     ,'QUALIFYING_SCHEME_LEAVE_REASON'  -- qualifying_scheme_leave_reason
                     ,'QUALIFYING_SCHEME_LEAVE_DATE'    -- qualifying_scheme_leave_date
                     ,'OPT_OUT_PERIOD_END_DATE'         -- opt_out_period_end_date
                     ,'OPT_OUT_REFUND_DUE'              -- opt_out_refund_due
                     ,'REASON_FOR_EXCLUSION'            -- reason_for_exclusion
                     ,'OVERRIDING_WORKER_POSTPONEMENT'  -- overriding_worker_postponement
                     ,'OVERRIDING_ELIGIBLEJH_POSTPMNT'  -- overriding_eligiblejh_postpmnt
                     ,'OVERRIDING_QUALIFYING_SCHEME'    -- overriding_qualifying_scheme
                     ,'OVERRIDING_STAGING_DATE'         -- overriding_staging_date
                     ,'LETTER_STATUS'                   -- letter_status
                     ,'LETTER_TYPE_DATE'                -- letter_type_date
                     ,'SUBSEQUENT_COMMS_REQ'            -- subsequent_comms_req
                     ,'LETTER_TYPE_GENERATED'           -- letter_type_generated
                     ,'flex_ora_hrx_gb_pae_adnl'          --flex_ora_hrx_gb_pae_adnl   
                     ,'WULS_TAKEN_DATE'                 -- wuls_taken_date
                     ,'TAX_PROTECTION_APPLIED'          -- tax_protection_applied
                     ,'PROC_AUTO_REENROLMENT_DATE'      -- proc_auto_reenrolment_date
                     ,'flex_ora_hrx_gb_ps_pension'      -- flex_ora_hrx_gb_ps_pension  
                     ,'HISTORIC_PEN_PAYROLL_ID'         -- historic_pen_payroll_id
                     ,'QUALIFYING_SCHEME_ID'            -- qualifying_scheme_id,
                     , 'ebs_asg_number'                --ebs_asg_number
                     ,'Created By'                      -- created_by       
                     ,'Creation Date'                   -- creation_date    
                     ,'Last Updated By'                 -- last_updated_by  
                     ,'LastUpdateDate'               -- last_update_date
                     ,'component_dtl_sourcesystemowner'    -- COMPONENT_DTL_SOURCESYSTEMID 
                     ,'component_dtl_sourcesystemId' -- COMPONENT_DTL_SOURCESYSTEMOWNER 
                 FROM  dual;

               --     
                    gvv_ProgressIndicator := '0070';

                    xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Inserting data into "'||ct_StgTable||'".'
                    ,pt_i_OracleError       => NULL
                    );
               --

            FOR rec_pae_both IN C_PAE_Both
            LOOP
               INSERT INTO xxmx_pay_calc_cards_pae_stg
               (MIGRATION_SET_ID                     
               , MIGRATION_SET_NAME                  
                ,MIGRATION_ACTION                    
                ,HEADER_OR_LINE                       
                ,SOURCESYSTEMID                       
                ,SOURCESYSTEMOWNER                    
                ,EFFECTIVESTARTDATE                   
                ,EFFECTIVEENDDATE                    
                ,DIRCARDCOMPDEFNAME                  
                ,LEGISLATIVEDATAGROUPNAME             
                ,DIRCARDID_SOURCESYSTEMID             
                ,COMPASSOC_SOURCESYSTEMID             
                ,COMPASSOC_SOURCESYSTEMOWNER          
                ,TAXREPORTINGUNITNAME                 
                ,ASSIGNMENTNUMBER                     
                ,COMPASSOCDTL_SOURCESYSTEMID          
                ,COMPASSOCDTL_SOURCESYSTEMOWNER        
                ,FLEX_HRX_GB_PAE                     
                ,EMPLOYEE_CLASSIFICATION             
                ,ELIGIBLE_JOBHOLDER_DATE             
                ,RE_ENROLMENT_ASSESSMENT_ONLY        
                ,CLASSIFICATION_CHANGED_PROC_DT       
                ,ACTIVE_POSTPONEMENT_TYPE            
                ,ACTIVE_POSTPONEMENT_RULE            
                ,ACTIVE_POSTPONEMENT_END_DATE        
                ,ACTIVE_QUALIFYING_SCHEME            
                ,QUALIFYING_SCHEME_JOIN_DATE         
                ,QUALIFYING_SCHEME_START_DATE        
                ,QUALIFYING_SCHEME_JOIN_METHOD       
                ,TRANSFER_QUALIFYING_SCHEME         
                ,QUALIFYING_SCHEME_LEAVE_REASON     
                ,QUALIFYING_SCHEME_LEAVE_DATE       
                ,OPT_OUT_PERIOD_END_DATE            
                ,OPT_OUT_REFUND_DUE                 
                ,REASON_FOR_EXCLUSION               
                ,OVERRIDING_WORKER_POSTPONEMENT     
                ,OVERRIDING_ELIGIBLEJH_POSTPMNT     
                ,OVERRIDING_QUALIFYING_SCHEME       
                ,OVERRIDING_STAGING_DATE            
                ,LETTER_STATUS                      
                ,LETTER_TYPE_DATE                   
                ,SUBSEQUENT_COMMS_REQ               
                ,LETTER_TYPE_GENERATED              
                ,FLEX_ORA_HRX_GB_PAE_ADNL           
                ,WULS_TAKEN_DATE                    
                ,TAX_PROTECTION_APPLIED             
                ,PROC_AUTO_REENROLMENT_DATE         
                ,FLEX_ORA_HRX_GB_PS_PENSION         
                ,HISTORIC_PEN_PAYROLL_ID            
                ,QUALIFYING_SCHEME_ID               
                ,EBS_ASG_NUMBER                     
                ,CREATED_BY                         
                ,CREATION_DATE                      
                ,LAST_UPDATED_BY                    
                ,LAST_UPDATE_DATE                   
                ,COMPONENT_DTL_SOURCESYSTEMOWNER    
                ,COMPONENT_DTL_SOURCESYSTEMID       )
               SELECT  pt_i_MigrationSetID                                      -- migration_set_id 
                      ,gvt_MigrationSetName                                     -- migration_set_name
                      ,'CREATE'                                                 -- migration_action  
                      ,'Line'                                                    -- header_or_line,
                      ,fus_pae_card.source_system_id_card_comp                  -- cardcomponent_sourcesystemid,
                      ,fus_pae_card.source_system_owner_card_comp               -- cardcomponent_sourcesystemowner,
                      ,TO_CHAR(fus_pae_card.effective_start_date,'YYYY/MM/DD')  -- effectivestartdate,  DECIDE FUSION/EE START DATE
                      ,TO_CHAR(fus_pae_card.effective_end_date,'YYYY/MM/DD')    -- effectiveenddate,  DECIDE FUSION/EE END DATE 
                      ,fus_pae_card.display_name                                -- dircardcompdefname,
                      ,fus_pae_card.ldg                                         -- legislativedatagroupname,
                      ,fus_pae_card.dir_card_id                                 -- dircardid_sourcesystemid,
                      ,vv_compassoc_sourcesysid||fus_pae_card.assignment_number -- compassoc_sourcesystemid,
                      ,vv_compassoc_sourcesysowner                              -- compassoc_sourcesystemowner,
                      ,get_fusion_legal_emp(fus_pae_card.assignment_number)     -- taxreportingunitname,
                      ,fus_pae_card.assignment_number                           -- assignmentnumber,
                      ,vv_compassocdtl_sourcesysid||fus_pae_card.assignment_number     -- compassocdtl_sourcesystemid,
                      ,vv_compassocdtl_sourcesysowner                           -- compassocdtl_sourcesystemowner,
                      ,fus_pae_card.dir_information_category                    -- flex_deduction_developer_df,
                      ,CASE
                         WHEN ebs_pae_dtls.pae_pens_class_SCRN_ENTRY_VAL = 'WORKER'                  THEN  'WORKER'
                         WHEN ebs_pae_dtls.pae_pens_class_SCRN_ENTRY_VAL = 'NON ELIGIBLE JOB HOLDER' THEN 'NONELIGIBLEJH'
                         WHEN ebs_pae_dtls.pae_pens_class_SCRN_ENTRY_VAL =  'ELIGIBLE JOB HOLDER'    THEN 'ELIGIBLEJH'
                         ELSE 'NOTASSESSED'
                         END                                                    -- employee_classification,
                           -- If Employee Classified as ELIGIBLE JOB HOLDER, Then consider 
                         -- Eligible job holder date from EBS
                      ,CASE
                        WHEN ebs_pae_dtls.pae_pens_class_SCRN_ENTRY_VAL =  'ELIGIBLE JOB HOLDER' 
                        THEN  NVL(NVL(SUBSTR(ebs_pae_dtls.pae_elij_job_hold_dt_SCRN_ENTRY_VAL,1,10),substr(ebs_pae_dtls.PAE_AUTO_ENRL_DT_SCRN_ENTRY_VAL,1,10)),substr(ebs_pae_dtls.effective_start_date,1,10)) 
                        ELSE NULL
                        END                                                            -- eligible_jobholder_date,        
                      ,NULL                                                     -- re_enrolment_assessment_only,
                      ,TO_CHAR(ebs_pae_dtls.effective_start_date,'YYYY/MM/DD')  -- classification_changed_proc_dt,
                     -- Where there is a value for Qualifying scheme name exist in EBS, migrate as NULL
                     -- Postpone type in EBS is 'ELIGIBLE JOB HOLDER DEFERMENT' THEN 'ELIGIBLEJH'
                     -- Else NONE
                     -- Does not make sense to me now commented out for now.
                      ,CASE 
                         WHEN ebs_pae_dtls.pae_qual_schm_name_scrn_entry_val IS NOT NULL THEN NULL
                         WHEN ebs_pae_dtls.pae_postpn_type_SCRN_ENTRY_VAL = 'ELIGIBLE JOB HOLDER DEFERMENT' THEN 'ELIGIBLEJH'
                         WHEN ebs_pae_dtls.pae_postpn_type_SCRN_ENTRY_VAL = 'DB SCHEME DEFERMENT' THEN 'DBSCHEME'
                         WHEN ebs_pae_dtls.pae_postpn_type_SCRN_ENTRY_VAL = 'WORKER DEFERMENT' THEN 'WORKER'
                         ELSE 'NONE'
                       END                                                      -- active_postponement_type,                             
                    -- Where there is a value for Qualifying scheme name exist in EBS, migrate as NULL
                    -- Postpone Type in EBS IS NOT NULL THEN 'ELIGIBLEJH'
                    -- Else NULL
                    -- Does not make sense to me now commented out for now.
                      ,CASE
                         WHEN ebs_pae_dtls.pae_qual_schm_name_scrn_entry_val IS NOT NULL THEN NULL 
                         WHEN ebs_pae_dtls.pae_postpn_type_SCRN_ENTRY_VAL <> ' ' THEN 'MAX'
                         ELSE NULL
                       END                                                      -- active_postponement_rule,                              
                     -- Where there is a value for Qualifying scheme name exist in EBS, migrate as NULL
                    -- Else postponement end date
                      ,CASE
                         WHEN ebs_pae_dtls.pae_qual_schm_name_SCRN_ENTRY_VAL IS NOT NULL THEN NULL
                         ELSE SUBSTR(ebs_pae_dtls.pae_postpn_end_dt_SCRN_ENTRY_VAL,1,10) 
                         END                                                    -- active_postponement_end_date,
                    -- Qualifying scheme name will be Pension Element Type ID from Fusion
                    -- Review this for each iteration
                    ,    (Select distinct to_CHAR(FUSION_PENSION_SCHEME_ID ) from XXMX_CORE.XXMX_PAY_EBS_FUS_PE_PENSCH  PEN ,xxmx_per_assignments_m_stg ASG
                        WHERE UPPER(EBS_PENSION) = UPPER(ebs_pae_dtls.pae_qual_schm_name_SCRN_ENTRY_VAL)
                        AND ENABLED_FLAG= 'Y'
                        AND asg.Assignment_number = fus_pae_card.ASSIGNMENT_NUMBER
                        AND ACTION_CODE IN ('CURRENT','ADD_ASSIGN')
                        AND asg.PAYROLLNAME= NVL( PEN.Payroll_name ,asg.PAYROLLNAME))-- active_qualifying_scheme,
                    -- If the Optin date is not available in EBS
                    -- Get the Pension element entry start date
                      --,NVL(to_char(ebs_pae_dtls.pae_opt_in_dt ,'YYYY/MM/DD') ,SUBSTR(ebs_pae_dtls.pae_elij_job_hold_dt,1,10)) -- qualifying_scheme_join_date,
                      ,NVL(ebs_pae_dtls.pae_opt_in_dt_SCRN_ENTRY_VAL ,  SUBSTR(ebs_pae_dtls.pae_elij_job_hold_dt_SCRN_ENTRY_VAL,1,10))  qualifying_scheme_join_date
                      ,NULL                                                     -- qualifying_scheme_start_date, 
                                --Defaulted to OPTIN. Will be upadted as per Petrofac inputs.          
                      ,DECODE(ebs_pae_dtls.PAE_QUAL_SCHM_NAME_SCRN_ENTRY_VAL, NULL,
                              NULL,
                              'AUTOENROL'
                             )                                                  -- qualifying_scheme_join_method,
                      ,NULL                                                     -- transfer_qualifying_scheme,
                      ,NULL                                                     -- qualifying_scheme_leave_reason, 
                      ,NULL                                                     -- qualifying_scheme_leave_date, 
                      ,SUBSTR(ebs_pae_dtls.PAE_OPT_OUT_DT_SCRN_ENTRY_VAL,1,10)  -- opt_out_period_end_date,
                      ,'N'                                                      -- opt_out_refund_due,
                      ,(SELECT 'ORA_HRX_GB_TAXPROTECTED'
                          FROM xxmx_ebs_pae_exclusion_list_emp pea_exclusion
                         WHERE pea_exclusion.person_number = fus_pae_card.payroll_relationship_number
                       )                                                        -- reason_for_exclusion,   EBS_PAE_DTLS.PAE_EXCLUSION_RSN_SCRN_ENTRY_VAL 
                      ,NULL                                                     -- overriding_worker_postponement,
                      ,NULL                                                     -- overriding_eligiblejh_postpmnt,
                      ,NULL                                                     -- overriding_qualifying_scheme,
                      ,NULL                                                     -- overriding_staging_date,
                      ,'ORA_HRX_GB_LET_GENERATED'                               -- letter_status,
                      ,TO_CHAR(ebs_pae_dtls.effective_start_date,'YYYY/MM/DD')  -- letter_type_date,
                      ,NULL                                                     -- subsequent_comms_req,
                      ,NULL                                                     -- letter_type_generated, 
                      ,NULL                                                     --flex_ora_hrx_gb_pae_adnl   
                      ,NULL                                                     -- wuls_taken_date, 
                      ,NULL                                                     -- tax_protection_applied, 
                      ,NULL                                                     -- proc_auto_reenrolment_date,
                      ,NULL                                                     -- flex_ora_hrx_gb_ps_pension
                      ,NULL                                                     -- historic_pen_payroll_id,  
                      ,(SELECT bpcard.dir_card_comp_id
                          FROM xxmx_fusion_calc_card_bp_dtls bpcard
                         WHERE bpcard.assignment_number = fus_pae_card.assignment_number
                           AND bpcard.card_comp_effective_start_date =  (
                                                                         SELECT MAX(card_comp_effective_start_date)
                                                                         FROM xxmx_fusion_calc_card_bp_dtls bpcard1
                                                                         WHERE bpcard.dir_card_comp_id =  bpcard1.dir_card_comp_id
                                                                        )
                       )                                                       -- dir_card_comp_id,
                      ,to_CHAR(ebs_pae_dtls.assignment_number)
                      ,xxmx_utilities_pkg.gvv_UserName            -- created by 
                      ,TO_CHAR(SYSDATE,'YYYY/MM/DD')              -- creation date
                      ,xxmx_utilities_pkg.gvv_UserName            -- last updated by
                      ,TO_CHAR(SYSDATE,'YYYY/MM/DD')              -- last update date
                      ,fus_pae_card.SOURCE_SYSTEM_OWNER_CARD_COMP_DTLS
                      ,to_char(fus_pae_card.SOURCE_SYSTEM_ID_CARD_COMP_DTLS)
                FROM   xxmx_fusion_calc_card_pae_dtls     fus_pae_card,
                       XXMX_PAY_EBS_PAE_DTLS_V           ebs_pae_dtls
               WHERE   fus_pae_card.assignment_number = ebs_pae_dtls.Fusion_asg_number 
               AND     fus_pae_card.dir_information_category = vv_dir_info_category
               UNION ALL
               SELECT  pt_i_MigrationSetID                                      -- migration_set_id 
                      ,gvt_MigrationSetName                                     -- migration_set_name
                      ,'CREATE'                                                 -- migration_action  
                      ,'Line'                                                   -- header_or_line,
                      ,fus_pae_card.source_system_id_card_comp                  -- cardcomponent_sourcesystemid,
                      ,fus_pae_card.source_system_owner_card_comp               -- cardcomponent_sourcesystemowner,
                      ,TO_CHAR(fus_pae_card.effective_start_date,'YYYY/MM/DD')  -- effectivestartdate, DECIDE FUSION/EE START DATE
                      ,TO_CHAR(fus_pae_card.effective_end_date,'YYYY/MM/DD')    -- effectiveenddate,  DECIDE FUSION/EE END DATE
                      ,fus_pae_card.display_name                                -- dircardcompdefname,
                      ,fus_pae_card.ldg                                         -- legislativedatagroupname,
                      ,fus_pae_card.dir_card_id                                 -- dircardid_sourcesystemid,
                      ,vv_compassoc_sourcesysid||fus_pae_card.assignment_number -- compassoc_sourcesystemid,
                      ,vv_compassoc_sourcesysowner                              -- compassoc_sourcesystemowner,
                      ,get_fusion_legal_emp(fus_pae_card.assignment_number)    -- taxreportingunitname,
                      ,fus_pae_card.assignment_number                           -- assignmentnumber,
                      ,vv_compassocdtl_sourcesysid||fus_pae_card.assignment_number     -- compassocdtl_sourcesystemid,
                      ,vv_compassocdtl_sourcesysowner                           -- compassocdtl_sourcesystemowner,
                      ,fus_pae_card.dir_information_category                    -- flex_deduction_developer_df,
                      ,NULL                                                     -- employee_classification, COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- eligible_jobholder_date,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG
                      ,NULL                                                     -- re_enrolment_assessment_only,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- classification_changed_proc_dt,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- active_postponement_type,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- active_postponement_rule,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- active_postponement_end_date,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- active_qualifying_scheme,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- qualifying_scheme_join_date,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- qualifying_scheme_start_date,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- qualifying_scheme_join_method,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- transfer_qualifying_scheme,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- qualifying_scheme_leave_reason,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- qualifying_scheme_leave_date,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- opt_out_period_end_date,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- opt_out_refund_due,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- reason_for_exclusion, COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- overriding_worker_postponement,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- overriding_eligiblejh_postpmnt,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- overriding_qualifying_scheme, COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- overriding_staging_date,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- letter_status,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- letter_type_date,   COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- subsequent_comms_req,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     -- letter_type_generated,  COLUMNS APPLICABLE FOR HRX_GB_PAE INFO CATEG 
                      ,NULL                                                     --flex_ora_hrx_gb_pae_adnl   
                      ,NULL                                                     -- wuls_taken_date,  COLUMNS APPLICABLE FOR ORA_HRX_GB_PAE_ADNL INFO CATEG 
                      ,NULL                                                      -- tax_protection_applied,  COLUMNS APPLICABLE FOR ORA_HRX_GB_PAE_ADNL INFO CATEG 
                      ,NULL                                                     -- proc_auto_reenrolment_date,  COLUMNS APPLICABLE FOR ORA_HRX_GB_PAE_ADNL INFO CATEG 
                      ,NULL                                                     -- flex_ora_hrx_gb_ps_pension  
                      ,NULL                                                     -- historic_pen_payroll_id,   COLUMNS APPLICABLE FOR ORA_HRX_GB_PS_PENSION INFO CATEG 
                      ,NULL                                       -- dir_card_comp_id,
                      ,to_CHAR(ebs_pae_dtls.assignment_number )
                      ,xxmx_utilities_pkg.gvv_UserName            -- created by 
                      ,TO_CHAR(SYSDATE,'YYYY/MM/DD')              -- creation date
                      ,xxmx_utilities_pkg.gvv_UserName            -- last updated by
                      ,TO_CHAR(SYSDATE,'YYYY/MM/DD')              -- last update date
                      ,fus_pae_card.SOURCE_SYSTEM_OWNER_CARD_COMP_DTLS
                      ,to_char(fus_pae_card.SOURCE_SYSTEM_ID_CARD_COMP_DTLS)
               FROM   xxmx_fusion_calc_card_pae_dtls fus_pae_card,
                   XXMX_PAY_EBS_PAE_DTLS_V           ebs_pae_dtls
               WHERE   fus_pae_card.assignment_number = ebs_pae_dtls.Fusion_asg_number 
               AND     fus_pae_card.dir_information_category = vv_information_category
               AND      ebs_pae_dtls.pae_qual_schm_name_SCRN_ENTRY_VAL is not null
               ;

            END LOOP;
               -- call utilities 
                   gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                    (gct_StgSchema,ct_StgTable,pt_i_MigrationSetID);
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Inserted Rows: '||gvn_RowCount||' inserted'
                    ,pt_i_OracleError       => NULL
                    );                                         
               --
               gvv_ProgressIndicator := '0080';
               --              

                   -- call utilities 
                   gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                    (gct_StgSchema,ct_StgTable,pt_i_MigrationSetID);
               --
               UPDATE xxmx_pay_calc_cards_pae_stg
                  SET active_postponement_rule = 'NONE'
                WHERE active_postponement_type = 'NONE'
                  AND migration_set_id         = pt_i_MigrationSetID;
               --     
               UPDATE xxmx_pay_calc_cards_pae_stg
                  SET active_postponement_end_date = NULL
                WHERE active_postponement_rule     = 'MAX'
                  AND migration_set_id             = pt_i_MigrationSetID;
               --
               UPDATE xxmx_pay_calc_cards_pae_stg
                  SET qualifying_scheme_join_method = 'OPTIN'
                WHERE employee_classification       <> 'ELIGIBLEJH'
                  AND migration_set_id              = pt_i_MigrationSetID;
               --
               UPDATE xxmx_pay_calc_cards_pae_stg
                  SET qualifying_scheme_join_method = NULL
                WHERE employee_classification       = 'NOTASSESSED'
                  AND migration_set_id              = pt_i_MigrationSetID;
               --
               COMMIT;
               --
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Extraction Rows: '||gvn_RowCount||' Updated'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '090';
               --
               xxmx_utilities_pkg.upd_migration_details
                    (pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gcv_BusinessEntity
                    ,pt_i_SubEntity               => pt_i_SubEntity
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
               xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gcv_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => 'END '||cv_ProcOrFuncName||' - Migration Table "'||ct_StgTable||'" completed.'
                    ,pt_i_OracleError       => NULL
                    );
          ELSE
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set not initialized.';
               --
               RAISE e_ModuleError;
          END IF;
          --
          EXCEPTION
               WHEN e_ModuleError THEN
                    --
                    ROLLBACK;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RAISE;
                    --
               --** END e_ModuleError Exception
               WHEN OTHERS THEN
                    --
                    ROLLBACK;
                    --
                    gvt_OracleError := SUBSTR(SQLERRM||'** ERROR_BACKTRACE: '
                                           ||dbms_utility.format_error_backtrace,1,4000);
                    --
                    xxmx_utilities_pkg.log_module_message
                         (pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gcv_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    RAISE;
               --** END OTHERS Exception
          --** END Exception Handler
     END ;

END xxmx_pay_payroll_pkg;
/
