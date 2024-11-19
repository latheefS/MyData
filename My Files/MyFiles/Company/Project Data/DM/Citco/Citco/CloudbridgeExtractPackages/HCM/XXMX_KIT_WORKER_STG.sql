CREATE OR REPLACE PACKAGE xxmx_kit_worker_stg AS

  PROCEDURE export
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE export_period_of_service_1
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE export_period_of_service_2
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

/* New procedure for Work Relationship    */
 PROCEDURE export_per_workrel
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;
/* New procedure for Work Relationship*/

  PROCEDURE export_all_assignments_m_1
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE export_all_assignments_m_2
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE export_all_assignments_m_3
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE export_all_assignments_m_4
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE export_assign_supervisors_f
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE export_all_assign_m_inactive
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;


/* added  methods*/
  PROCEDURE export_asg_pay_method
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

  PROCEDURE export_asg_payroll
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

	PROCEDURE export_asg_salary
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

	PROCEDURE export_asg_wrkmsr
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

	PROCEDURE export_asg_gradestep
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

	PROCEDURE export_ext_Bank_Account
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

	FUNCTION get_legal_employer_name( p_organization_id	NUMBER)
    RETURN VARCHAR2;

	PROCEDURE export_all_assignments_m_5
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

	PROCEDURE export_senioritydt
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;

    PROCEDURE export_assignments
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) ;


/* End of added  methods*/	

  PROCEDURE export_lookups;

  FUNCTION get_target_lookup_code
    (p_src_lookup_code IN varchar2
    ,p_src_lookup_type IN varchar2) RETURN varchar2;

  PROCEDURE load_usr_wrk_lkp
    (p_lkp_type IN varchar2);

  PROCEDURE purge
    (pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE ) ;

END xxmx_kit_worker_stg;
/


CREATE OR REPLACE PACKAGE BODY xxmx_kit_worker_stg AS
	 --
     --//================================================================================
     --// Version1
     --// $Id:$
     --//================================================================================
     --// Object Name        :: xxmx_kit_worker_stg
     --//
     --// Object Type        :: Package Body
     --//
     --// Object Description :: This package contains procedures FOR generating HCM 
     --//                            components FOR person Migration
     --//
     --//
     --// Version Control
     --//================================================================================
     --// Version      Author               Date               Description
     --//--------------------------------------------------------------------------------
     --// 1.0          Ian                  11/11/2020          Initial Build
     --// 1.1          Pallavi			    11-NOV-20           Add Extracts for PaymentMethod, Salary , Work Measure, GradeStep
	 --// 1.2          Pallavi Kanajar		26/03/2021 			Added People Group Name, Supervisor and all Other attributes (location
	 --//														Department, Position to Assignment File, Added Person_type Parameter
     --// 1.3          Pallavi Kanajar      10/05/2021           Parameter for Payroll
     --// 1.4          Pallavi Kanajar      27/05/2021          Added Sort_code in the File
     --// 1.5          Pallavi Kanajar      17/06/2021          PositionOverride Flag reset to 'Y' in the File
     --// 1.6          Pallavi Kanajar      09/08/2022          Added materialized view 
      --//================================================================================
     --

    gvv_legal_employer_name VARCHAR2(1000);-- DEFAULT      xxmx_KIT_UTIL_stg.get_legal_employer_name;
    gvv_per_type_emp VARCHAR2(1000) DEFAULT             xxmx_KIT_UTIL_stg.get_per_emp_type;
    gvv_per_type_cwk VARCHAR2(1000) DEFAULT             xxmx_KIT_UTIL_stg.get_per_cwk_type;
    gvv_astat_active_np VARCHAR2(1000) DEFAULT          xxmx_KIT_UTIL_stg.get_astat_active_nopay;
    v_astat_active_p VARCHAR2(1000) DEFAULT             xxmx_KIT_UTIL_stg.get_astat_active_pay;
    v_astat_inactive_np VARCHAR2(1000) DEFAULT          xxmx_KIT_UTIL_stg.get_astat_inactive_nopay;
    v_astat_inactive_p VARCHAR2(1000) DEFAULT           xxmx_KIT_UTIL_stg.get_astat_inactive_pay;
    v_astat_suspend_np VARCHAR2(1000) DEFAULT           xxmx_KIT_UTIL_stg.get_astat_suspend_nopay;
    v_astat_suspend_p VARCHAR2(1000) DEFAULT            xxmx_KIT_UTIL_stg.get_astat_suspend_pay;
    v_leg_code   VARCHAR2(100) ;--DEFAULT                  xxmx_KIT_UTIL_stg.get_legislation_code;
    v_business_name VARCHAR2(1000) DEFAULT              xxmx_KIT_UTIL_stg.get_business_name;

    gcd_maxOracleDate date DEFAULT to_date ('31-12-4712' ,'DD-MM-YYYY');


	gvv_migration_date_from                         VARCHAR2(30); 
	gvv_prev_tax_year_date                          VARCHAR2(30);         
	gvd_migration_date_from                         DATE;
	gvd_prev_tax_year_date                          DATE;   
	gvv_migration_date_to                          VARCHAR2(30); 
	gvd_migration_date_to                          DATE; 

    --
    /*
    **********************
    ** Global Declarations
    **********************
    */
    --
    /* Maximise Integration Globals */
    --
    /* Global Constants for use in all xxmx_utilities_pkg Procedure/Function Calls within this package */
    --
    gcv_PackageName                           CONSTANT VARCHAR2(30)                                := 'xxmx_kit_worker_stg';
    gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE := 'HCM';
    gct_Application                           CONSTANT xxmx_module_messages.application%TYPE       := 'HR';
    gv_i_BusinessEntity                       CONSTANT VARCHAR2(100) DEFAULT 'WORKER';
    gvv_leg_code                                VARCHAR2(100);

    gvv_ReturnStatus                            VARCHAR2(1); 
    gvv_ProgressIndicator                       VARCHAR2(100); 
    gvn_RowCount                                NUMBER;
    gvt_ReturnMessage                           xxmx_module_messages .module_message%TYPE;
    gvt_Severity                                xxmx_module_messages .severity%TYPE;
    gvt_OracleError                             xxmx_module_messages .oracle_error%TYPE;
    gvt_ModuleMessage                           xxmx_module_messages .module_message%TYPE;
    e_ModuleError                 EXCEPTION;

    TYPE wrk_lkp_map_rec IS RECORD (ebs_lookup_type     VARCHAR2(200)
                                    ,ebs_lookup_code     VARCHAR2(200)
                                    ,fusion_lookup_code  VARCHAR2(200));

    TYPE wrk_lkp_map_tab IS TABLE OF wrk_lkp_map_rec INDEX BY pls_integer;

    g_wrk_lkp_map wrk_lkp_map_tab;

    l_bu_id VARCHAR2(4000);



    /************************************************
	****************Update Procedure*****************
	DESC: Updates People Group to Fusion Segments
	*************************************************
	*************************************************/

    PROCEDURE UPDATE_PEOPLE_GRP
    IS 

        lv_delimiter VARCHAR2(10);
        lv_delimiter_rep VARCHAR2(10);
        lv_fusion VARCHAR2(1000);
        lv_sql VARCHAR2(32000) := NULL;

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'UPDATE_PEOPLE_GRP';   
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT '';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'WORKER EXPORT';

        vt_BusinessEntitySeq                            xxmx_migration_metadata.business_entity_seq%TYPE;
    BEGIN 

        SELECT '||'''||REGEXP_SUBSTR(parameter_value, '[^(a-z)(A-Z)(0-9)*]',1,1)||'''||' 
              , REGEXP_SUBSTR(parameter_value, '[^(a-z)(A-Z)(0-9)*]',1,1)
        INTO lv_delimiter_rep
            ,lv_delimiter
        FROM xxmx_migration_parameters
        WHERE parameter_code = 'PEOPLE_GROUP';



        SELECT REPLACE(REPLACE(PARAMETER_VALUE,lv_delimiter,lv_delimiter_rep),'||||','||') "Fusion_Delimiter"
        INTO lv_fusion
        FROM  xxmx_migration_parameters
        WHERE parameter_code = 'PEOPLE_GROUP';

             lv_sql:= 'UPDATE XXMX_PER_ASSIGNMENTS_M_STG ASG '
                        ||'SET PEOPLE_GROUP_NAME = '
                        ||' (SELECT '||lv_fusion|| ' FROM PAY_PEOPLE_GROUPS@MXDM_NVIS_EXTRACT '
                        ||'  WHERE PEOPLE_GROUP_ID = ASG.PEOPLE_GROUP_ID )'
                        ||' WHERE PEOPLE_GROUP_ID IS NOT NULL ';

        --    DBMS_OUTPUT.PUT_LINE(lv_sql);

        EXECUTE IMMEDIATE lv_sql;

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
                        ,pt_i_ModuleMessage       => '- Procedure UPDATE_PEOPLE_GRP Completed.  "'
                        ,pt_i_OracleError         => NULL   );
    END UPDATE_PEOPLE_GRP;

	/************************************************
	****************Update Procedure*****************
	DESC: Updates Person_id to Number Identifer
	*************************************************
	*************************************************/	


    Function get_legislation_code (p_bg_id NUMBER)
    Return varchar2
    IS
    BEGIN 
         BEGIN
            SELECT  legislation_code 
			INTO    v_leg_code                
            FROM    per_business_groups@MXDM_NVIS_EXTRACT
            where   business_group_id= p_bg_id ;
        EXCEPTION
            WHEN no_data_found THEN 
				BEGIN
					SELECT   org_information9
					INTO v_leg_code
					FROM hr_organization_information@MXDM_NVIS_EXTRACT
					WHERE org_information_context LIKE 'Business Group Information'
					AND organization_id = p_bg_id;
				EXCEPTION	
					WHEN OTHERS THEN 
						v_leg_code := NULL;
				END;
        END;	
        Return v_leg_code;
    END get_legislation_code;

     PROCEDURE set_parameters (p_bg_id IN NUMBER)

	IS

	BEGIN 
		/***********Set Legislation_code- Harded for SMBC*************/
		 gvv_leg_code:=get_legislation_code (p_bg_id );


        gvv_migration_date_from := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'HCMEMPLOYEE'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'MIGRATE_DATE_FROM'
        );        
        gvd_migration_date_from := TO_DATE(gvv_migration_date_from,'YYYY-MM-DD');
         --


        gvv_migration_date_to := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'HCMEMPLOYEE'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'MIGRATE_DATE_TO'
        );        
        gvd_migration_date_to := TO_DATE(gvv_migration_date_to,'YYYY-MM-DD');
         --         

	END;


    FUNCTION get_legal_employer_name( p_organization_id	NUMBER)
    RETURN VARCHAR2
    IS
	gvv_legal_entity_id NUMBER;
    BEGIN 
         BEGIN
				SELECT
					xep.legal_entity_id   "Legal Entity ID",
					xep.name              "Legal Entity"
				INTO gvv_legal_entity_id,
					 gvv_legal_employer_name
				FROM
					hr_all_organization_units@MXDM_NVIS_EXTRACT      o,
					hr_all_organization_units_tl@MXDM_NVIS_EXTRACT   otl,
					hr_organization_information@MXDM_NVIS_EXTRACT    o2,
					hr_organization_information@MXDM_NVIS_EXTRACT    o3,
					xle_entity_profiles@MXDM_NVIS_EXTRACT            xep
				WHERE
					o.organization_id = o2.organization_id
					AND o.organization_id = o3.organization_id
					AND o2.org_information_context = 'CLASS'
					AND o3.org_information_context = 'Operating Unit Information'
					AND o2.org_information1 = 'OPERATING_UNIT'
					AND o2.org_information2 = 'Y'
					AND o.organization_id = otl.organization_id
					AND xep.legal_entity_id = o3.org_information2
					and o.organization_id = p_organization_id
					And rownum=1
					;
          /*  SELECT distinct 
					xep.legal_entity_id        "Legal Entity ID",
					xep.name                   "Legal Entity"
			INTO gvv_legal_entity_id,
				gvv_legal_employer_name 
			FROM
					xle_entity_profiles@MXDM_NVIS_EXTRACT           xep,
					xle_registrations@MXDM_NVIS_EXTRACT             reg,
					hr_all_organization_units@MXDM_NVIS_EXTRACT      hr_ou,
					hr_locations_all@MXDM_NVIS_EXTRACT               hr_loc     	 
			WHERE xep.transacting_entity_flag   =  'Y'
			AND xep.legal_entity_id           =  reg.source_id
			AND reg.source_table              =  'XLE_ENTITY_PROFILES'
			AND reg.identifying_flag          =  'Y'
			AND reg.location_id               =  hr_loc.location_id
			and hr_ou.location_id           = hr_loc.location_id
			and hr_ou.organization_id =p_organization_id
			;
*/
        exception
            when no_data_found then 
            gvv_legal_entity_id:= NULL;
            gvv_legal_employer_name := NULL;
        end;
	Return gvv_legal_employer_name ;
    END get_legal_employer_name;


    PROCEDURE export
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export';   
        vt_ClientSchemaName                             xxmx_client_config_parameters.config_value%TYPE;
        vt_MigrationSetID                               xxmx_migration_headers.migration_set_id%TYPE;
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT '';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'WORKER EXPORT';

        vt_BusinessEntitySeq                            xxmx_migration_metadata.business_entity_seq%TYPE;

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
        /***********Set Legislation_code- Harded for SMBC*************/
		gvv_leg_code := get_legislation_code (p_bg_id );

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
                        ,pt_i_ModuleMessage       => '- Calling Procedure get_legislation_code for  "' ||p_bg_id 
                        ,pt_i_OracleError         => NULL   );

        --0
        gvv_ProgressIndicator := '0050';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_lookups".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_lookups;

        --2
        gvv_ProgressIndicator := '0080';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_period_of_service_1".' 
                        ,pt_i_OracleError         => NULL   );
        --     
        export_period_of_service_1 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --3
        gvv_ProgressIndicator := '0090';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_period_of_service_2".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_period_of_service_2 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --4
        gvv_ProgressIndicator := '0100';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_all_assignments_m_1".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_all_assignments_m_1 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --5
        gvv_ProgressIndicator := '0110';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_all_assignments_m_2".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_all_assignments_m_2 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --6
        gvv_ProgressIndicator := '0120';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_all_assignments_m_3".' 
                        ,pt_i_OracleError         => NULL   );
        --
        export_all_assignments_m_3 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --7
        gvv_ProgressIndicator := '0130';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_all_assignments_m_4".' 
                        ,pt_i_OracleError         => NULL   );
        --
        export_all_assignments_m_4 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);

		--8
        gvv_ProgressIndicator := '0135';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_all_assignments_m_5".' 
                        ,pt_i_OracleError         => NULL   );
        --
        export_all_assignments_m_5 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --9
        gvv_ProgressIndicator := '0140';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_assign_supervisors_f".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_assign_supervisors_f (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
        --9
        gvv_ProgressIndicator := '0150';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_all_assign_m_inactive".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
        export_all_assign_m_inactive (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
		--
		gvv_ProgressIndicator := '0160';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_asg_pay_method".' 
                        ,pt_i_OracleError         => NULL   );
        -- 

		export_asg_pay_method(p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
		--
		gvv_ProgressIndicator := '0170';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_asg_payroll".' 
                        ,pt_i_OracleError         => NULL   );
        -- 

		export_asg_payroll(p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
		--      
		gvv_ProgressIndicator := '0180';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_asg_wrkmsr".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
		--
		--
		export_asg_wrkmsr(p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
		--
		--
		gvv_ProgressIndicator := '0190';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_asg_gradestep".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
		export_asg_gradestep(p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
		--
		--
		gvv_ProgressIndicator := '0200';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_asg_salary".' 
                        ,pt_i_OracleError         => NULL   );
        -- 
		--
		--
		export_asg_salary(p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
		--
		--
		gvv_ProgressIndicator := '0210';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_ext_Bank_Account".' 
                        ,pt_i_OracleError         => NULL   );
		--
		--
		export_ext_Bank_Account(p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);

		--
		gvv_ProgressIndicator := '0220';
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
                        ,pt_i_ModuleMessage       => '- Calling Procedure "' ||gcv_PackageName ||'.export_Senioritydt;".' 
                        ,pt_i_OracleError         => NULL   );

		export_Senioritydt(p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);
		--

        update_people_grp;
        COMMIT;
            --  
    EXCEPTION
        WHEN OTHERS THEN
        --
        ROLLBACK;
        --
        gvt_OracleError := SUBSTR(
                                    SQLERRM ||'** ERROR_BACKTRACE: ' ||dbms_utility.format_error_backtrace
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
        -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;    
    END export;

    PROCEDURE export_lookups IS
        v_cnt NUMBER DEFAULT 0;
        TYPE seed_emp_cat_codes IS VARRAY (4) OF VARCHAR2(264);
        v_seed_emp_cat_lkp_codes seed_emp_cat_codes DEFAULT seed_emp_cat_codes ('FR'
                                                                            ,'FT'
                                                                            ,'PR'
                                                                            ,'PT');
        TYPE seed_employee_category_codes IS VARRAY (6) OF VARCHAR2(264);
        v_seed_emp_catg_lkp_codes seed_employee_category_codes DEFAULT seed_employee_category_codes ('BC'
                                                                                                    ,'BE'
                                                                                                    ,'CL'
                                                                                                    ,'SP'
                                                                                                    ,'TC'
                                                                                                    ,'WC');
        TYPE seed_frq_codes IS VARRAY (5) OF VARCHAR2(264);
        v_seed_frq_lkp_codes seed_frq_codes DEFAULT seed_frq_codes ('D'
                                                                ,'M'
                                                                ,'W'
                                                                ,'Y'
                                                                ,'H');
        TYPE seed_qual_units_codes IS VARRAY (5) OF VARCHAR2(264);
        v_seed_qual_unit_lkp_codes seed_qual_units_codes DEFAULT seed_qual_units_codes ('D'
                                                                                    ,'M'
                                                                                    ,'W'
                                                                                    ,'Y'
                                                                                    ,'H');
    BEGIN
        FOR i IN 1 .. v_seed_emp_cat_lkp_codes.last LOOP
            v_cnt := i;

            g_wrk_lkp_map (v_cnt).ebs_lookup_type := 'EMP_CAT';

            g_wrk_lkp_map (v_cnt).ebs_lookup_code := v_seed_emp_cat_lkp_codes (i);

            g_wrk_lkp_map (v_cnt).fusion_lookup_code := v_seed_emp_cat_lkp_codes (i);
        END LOOP;

        v_cnt := v_cnt + 1;

        g_wrk_lkp_map (v_cnt).ebs_lookup_type := 'CWK_ASG_CATEGORY';

        g_wrk_lkp_map (v_cnt).ebs_lookup_code := 'PERM';

        g_wrk_lkp_map (v_cnt).fusion_lookup_code := 'FR';

        v_cnt := v_cnt + 1;

        g_wrk_lkp_map (v_cnt).ebs_lookup_type := 'CWK_ASG_CATEGORY';

        g_wrk_lkp_map (v_cnt).ebs_lookup_code := 'TEMP';

        g_wrk_lkp_map (v_cnt).fusion_lookup_code := 'FT';

        FOR i IN 1 .. v_seed_emp_catg_lkp_codes.last LOOP
            v_cnt := v_cnt + 1;

            g_wrk_lkp_map (v_cnt).ebs_lookup_type := 'EMPLOYEE_CATG';

            g_wrk_lkp_map (v_cnt).ebs_lookup_code := v_seed_emp_catg_lkp_codes (i);

            g_wrk_lkp_map (v_cnt).fusion_lookup_code := v_seed_emp_catg_lkp_codes (i);
        END LOOP;

        FOR i IN 1 .. v_seed_frq_lkp_codes.last LOOP
            v_cnt := v_cnt + 1;

            g_wrk_lkp_map (v_cnt).ebs_lookup_type := 'FREQUENCY';

            g_wrk_lkp_map (v_cnt).ebs_lookup_code := v_seed_frq_lkp_codes (i);

            g_wrk_lkp_map (v_cnt).fusion_lookup_code := v_seed_frq_lkp_codes (i);
        END LOOP;

        FOR i IN 1 .. v_seed_qual_unit_lkp_codes.last LOOP
            v_cnt := v_cnt + 1;

            g_wrk_lkp_map (v_cnt).ebs_lookup_type := 'QUALIFYING_UNITS';

            g_wrk_lkp_map (v_cnt).ebs_lookup_code := v_seed_qual_unit_lkp_codes (i);

            g_wrk_lkp_map (v_cnt).fusion_lookup_code := v_seed_qual_unit_lkp_codes (i);
        END LOOP;

        v_cnt := v_cnt + 1;

        g_wrk_lkp_map (v_cnt).ebs_lookup_type := 'HOURLY_SALARIED_CODE';

        g_wrk_lkp_map (v_cnt).ebs_lookup_code := 'H';

        g_wrk_lkp_map (v_cnt).fusion_lookup_code := 'H';

        v_cnt := v_cnt + 1;

        g_wrk_lkp_map (v_cnt).ebs_lookup_type := 'HOURLY_SALARIED_CODE';

        g_wrk_lkp_map (v_cnt).ebs_lookup_code := 'S';

        g_wrk_lkp_map (v_cnt).fusion_lookup_code := 'S';

        v_cnt := v_cnt + 1;

        g_wrk_lkp_map (v_cnt).ebs_lookup_type := 'REC_TYPE';

        g_wrk_lkp_map (v_cnt).ebs_lookup_code := 'AG';

        g_wrk_lkp_map (v_cnt).fusion_lookup_code := 'AG';

        v_cnt := v_cnt + 1;

        g_wrk_lkp_map (v_cnt).ebs_lookup_type := 'REC_TYPE';

        g_wrk_lkp_map (v_cnt).ebs_lookup_code := 'IRC_TP_SITE';

        g_wrk_lkp_map (v_cnt).fusion_lookup_code := 'IRC_TP_SITE';

        load_usr_wrk_lkp ('BARGAINING_UNIT_CODE');

        load_usr_wrk_lkp ('REC_TYPE');

        load_usr_wrk_lkp ('EMP_CAT');

        load_usr_wrk_lkp ('CWK_ASG_CATEGORY');

        load_usr_wrk_lkp ('EMPLOYEE_CATG');

        load_usr_wrk_lkp ('FREQUENCY');

        load_usr_wrk_lkp ('HOURLY_SALARIED_CODE');

        load_usr_wrk_lkp ('QUALIFYING_UNITS');

        COMMIT;
    END export_lookups;

    PROCEDURE load_usr_wrk_lkp
        (p_lkp_type IN VARCHAR2) IS

        v_cnt NUMBER DEFAULT 0;

        CURSOR c1
        (c_lkp_type IN VARCHAR2) IS
            SELECT  lookup_type ebs_lookup_type
                    ,lookup_code ebs_lookup_code
                    ,lookup_code target_lookup_code
            FROM    fnd_lookup_values@MXDM_NVIS_EXTRACT flv
            --fnd_lookup_values_vl@MXDM_NVIS_EXTRACT flv
            WHERE   lookup_type = c_lkp_type
            AND     view_application_id = 3;

        v_wrk_lkp_map wrk_lkp_map_tab;
        v_src_lkp_type VARCHAR2(200);
        v_src_lkp_code VARCHAR2(200);
        v_tgt_lkp_code VARCHAR2(200);

    BEGIN
        v_cnt := g_wrk_lkp_map.last + 1;

        OPEN c1 (p_lkp_type);

        LOOP
        FETCH c1
            INTO    v_src_lkp_type
                    ,v_src_lkp_code
                    ,v_tgt_lkp_code;

        IF c1%FOUND THEN
            g_wrk_lkp_map (v_cnt).ebs_lookup_type := v_src_lkp_type;

            g_wrk_lkp_map (v_cnt).ebs_lookup_code := v_src_lkp_code;

            g_wrk_lkp_map (v_cnt).fusion_lookup_code := v_tgt_lkp_code;

            v_cnt := v_cnt + 1;
        END IF;

        EXIT WHEN c1%NOTFOUND;
        END LOOP;

        CLOSE c1;
    EXCEPTION
        WHEN no_data_found THEN
        RETURN;
    END load_usr_wrk_lkp;

    FUNCTION get_target_lookup_code
        (p_src_lookup_code IN VARCHAR2
        ,p_src_lookup_type IN VARCHAR2) RETURN VARCHAR2 IS
        v_ret VARCHAR2(200);
    BEGIN
        IF g_wrk_lkp_map IS NULL THEN
            RETURN v_ret;
        END IF;

        IF g_wrk_lkp_map.count = 0 THEN
            RETURN v_ret;
        END IF;

        FOR i IN g_wrk_lkp_map.first .. g_wrk_lkp_map.last LOOP
            IF g_wrk_lkp_map (i).ebs_lookup_type = p_src_lookup_type THEN
                IF g_wrk_lkp_map (i).ebs_lookup_code = p_src_lookup_code THEN
                    v_ret := g_wrk_lkp_map (i).fusion_lookup_code;
                END IF;
            END IF;
        END LOOP;

        RETURN v_ret;
    END get_target_lookup_code;

    PROCEDURE export_period_of_service_1
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'EXPORT_PERIOD_OF_SERVICE_1'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_POS_WR_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERIOD_OF_SERVICE_1';
        lvv_migration_date_from                         VARCHAR2(30); 
        lvv_prev_tax_year_date                          VARCHAR2(30);         
        lvd_migration_date_from                         DATE;
        lvd_prev_tax_year_date                          DATE;     

    BEGIN
        --
        --       
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
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0005';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'DATA'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        IF   gvv_ReturnStatus = 'F'
        THEN
            xxmx_utilities_pkg.log_module_message
                (pt_i_ApplicationSuite    => gct_ApplicationSuite
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
        END IF;
        --
        --
        lvv_migration_date_from := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'HCMEMPLOYEE'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'MIGRATE_DATE_FROM'
        );        
        lvd_migration_date_from := TO_DATE(lvv_migration_date_from,'YYYY-MM-DD');
         --
        lvv_prev_tax_year_date := xxmx_utilities_pkg.get_single_parameter_value(
                             pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                             ,pt_i_Application                =>     gct_Application
                             ,pt_i_BusinessEntity             =>     'HCMEMPLOYEE'
                             ,pt_i_SubEntity                  =>     'ALL'
                             ,pt_i_ParameterCode              =>     'PREV_TAX_YEAR_DATE'
        ); 
        lvd_prev_tax_year_date := TO_DATE(lvv_prev_tax_year_date,'YYYY-MM-DD');       --2019-12-31
         --
        gvv_ProgressIndicator := '0005';
        IF  NVL( lvd_migration_date_from, NULL ) is null or  NVL( lvd_prev_tax_year_date, NULL ) is null
        THEN 
                 --
                 xxmx_utilities_pkg.log_module_message
                         (
                         pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                         ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => '- Oracle error. Migration from date or Previous Tax Year Date not found.'
                         ,pt_i_OracleError         => gvt_ReturnMessage
                         );
                 --
                 RAISE e_ModuleError;
                 --
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
        DELETE 
        FROM    xxmx_per_pos_wr_stg
        WHERE   bg_id    = p_bg_id    ;    

        COMMIT;    
        --
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
                        ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable   || '".'   
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
        --   
        INSERT  
        INTO    xxmx_per_pos_wr_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,termination_accepted_person_id
                ,person_id
                ,date_start
                ,accepted_termination_date
                ,actual_termination_date
                ,notified_termination_date
                ,projected_termination_date
                ,adjusted_svc_date
                ,date_employee_data_verified
                ,fast_path_employee
                ,legal_employer_name
                ,legislation_code
                ,on_military_service
                ,original_date_of_hire
                ,period_type
                ,primary_flag
                ,rehire_authorizor
                ,rehire_reason
                ,rehire_recommendation
                ,action_occurrence_id
                ,period_of_service_id
				,attribute1
				,personnumber)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,c80_term_accepted_person_id
                ,xxmx_per_persons_stg.person_id person_id
                ,c34_date_start date_start
                ,c56_accepted_termination_date accepted_termination_date
                ,c36_actual_termination_date actual_termination_date
                ,c48_notified_termination_date notified_termination_date
                ,c50_projected_termination_date projected_termination_date
                ,c71_adjusted_svc_date adjusted_svc_date
                ,c72_date_employee_data_verifie date_employee_data_verified
                ,nvl (c74_fast_path_employee
                        ,'Y') fast_path_employee
                ,Case When business_group_id is NOT NULL THEN 
					xxmx_kit_worker_stg.get_legal_employer_name(business_group_id)
					ELSE 
						NULL
					END "legal_employer"
                ,gvv_leg_code legislation_code
                ,nvl (c75_on_military_service
                        ,'N') on_military_service
                ,c46_original_date_of_hire original_date_of_hire
                ,'E' period_type
                ,'Y' primary_flag
                ,c29_rehire_authorizor rehire_authorizor
                ,c37_rehire_reason rehire_reason
                ,nvl (c73_rehire_recommendation
                        ,'N') rehire_recommendation
                ,NULL action_occurrence_id
                ,s0_period_of_service_id
                   -- || '_PERIOD_OF_SERVICE'
				,payroll_name
				,c_per_periods_of_ser.personnumber
        FROM    xxmx_per_persons_stg xxmx_per_persons_stg
                ,
                (
                SELECT  per_all_people_f.rehire_authorizor c29_rehire_authorizor
                    ,per_periods_of_service.date_start c34_date_start
                    ,per_periods_of_service.pds_information23 c35_pds_information23
                    ,per_periods_of_service.actual_termination_date c36_actual_termination_date
                    ,per_all_people_f.rehire_reason c37_rehire_reason
                    ,per_all_people_f.original_date_of_hire c46_original_date_of_hire
					,per_All_people_f.business_group_id
                    ,per_periods_of_service.attribute_category c47_attribute_category
                    ,per_periods_of_service.notified_termination_date c48_notified_termination_date
                    ,per_periods_of_service.projected_termination_date c50_projected_termination_date
                    ,per_periods_of_service.accepted_termination_date c56_accepted_termination_date
                    ,per_periods_of_service.adjusted_svc_date c71_adjusted_svc_date
                    ,per_all_people_f.date_employee_data_verified c72_date_employee_data_verifie
                    ,per_periods_of_service.person_id c76_s_person_id
                    ,per_periods_of_service.termination_accepted_person_id c80_term_accepted_person_id
                    ,per_all_people_f.fast_path_employee c74_fast_path_employee
                    ,per_all_people_f.on_military_service c75_on_military_service
                    ,per_all_people_f.rehire_recommendation c73_rehire_recommendation
					,(SELECT distinct Organization_id FROM per_all_assignments_f@MXDM_NVIS_EXTRACT paaf
					WHERE period_of_service_id = per_periods_of_service.period_of_service_id 
					AND person_id = per_all_people_f.person_id
					AND rownum=1
					AND TRUNC(SYSDATE) BETWEEN paaf.effective_start_date   AND     paaf.effective_end_date) s_organization_id
                    ,per_periods_of_service.period_of_service_id s0_period_of_service_id
					,(SELECT Payroll_name
					  FROM PAY_PAYROLLS_F@MXDM_NVIS_EXTRACT ppf,Per_all_assignments_f@MXDM_NVIS_EXTRACT paaf
					  WHERE PPF.PAYROLL_ID = paaf.payroll_id
					  and paaf.person_id = per_all_people_f.person_id
					  and paaf.primary_flag = 'Y'
					  and rownum= 1
					  and trunc(sysdate) BETWEEN paaf.effective_start_date and paaf.effective_end_date
					  AND trunc(sysdate) BETWEEN ppf.effective_start_date and ppf.effective_end_date)
					  Payroll_name 
					  ,per_all_people_f.employee_number personnumber
                FROM per_periods_of_service@MXDM_NVIS_EXTRACT per_periods_of_service
                    ,xxmx_hcm_person_scope_mv per_all_people_f
                WHERE  per_periods_of_service.business_group_id  = p_bg_id
                AND    per_periods_of_service.business_group_id = per_all_people_f.business_group_id
				AND    per_periods_of_service.person_id = per_all_people_f.person_id
                         AND     per_periods_of_service.date_start BETWEEN per_all_people_f.effective_start_date
                                                                 AND     per_all_people_f.effective_end_date
/*                AND     (
                                        lvd_migration_date_from <  per_all_people_f.effective_end_date  
                                OR      lvd_prev_tax_year_date  <  per_all_people_f.effective_end_date                       
                        )   */
                ) c_per_periods_of_ser
        WHERE   (
                        xxmx_per_persons_stg.person_id = c76_s_person_id

                )
        ;
        --
        -- 
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed' 
                        ,pt_i_OracleError         => gvt_ReturnMessage       );   

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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;

    END export_period_of_service_1;

    PROCEDURE export_period_of_service_2
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'EXPORT_PERIOD_OF_SERVICE_2'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_POS_WR_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERIOD_OF_SERVICE_2';

        lvv_migration_date_from                         VARCHAR2(30); 
        lvv_prev_tax_year_date                          VARCHAR2(30);         
        lvd_migration_date_from                         DATE;
        lvd_prev_tax_year_date                          DATE;     

    BEGIN
        --
        --       
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
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0005';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'DATA'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        IF   gvv_ReturnStatus = 'F'
        THEN
            xxmx_utilities_pkg.log_module_message
                (pt_i_ApplicationSuite    => gct_ApplicationSuite
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
        END IF;    
        --
        --
        lvv_migration_date_from := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'HCMEMPLOYEE'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'MIGRATE_DATE_FROM'
        );        
        lvd_migration_date_from := TO_DATE(lvv_migration_date_from,'YYYY-MM-DD');
         --
        lvv_prev_tax_year_date := xxmx_utilities_pkg.get_single_parameter_value(
                             pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                             ,pt_i_Application                =>     gct_Application
                             ,pt_i_BusinessEntity             =>     'HCMEMPLOYEE'
                             ,pt_i_SubEntity                  =>     'ALL'
                             ,pt_i_ParameterCode              =>     'PREV_TAX_YEAR_DATE'
        ); 
        lvd_prev_tax_year_date := TO_DATE(lvv_prev_tax_year_date,'YYYY-MM-DD');      
         --
        gvv_ProgressIndicator := '0005';
        IF  NVL( lvd_migration_date_from, NULL ) is null or  NVL( lvd_prev_tax_year_date, NULL ) is null
        THEN 
                 --
                 xxmx_utilities_pkg.log_module_message
                         (
                         pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                         ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => '- Oracle error. Migration from date or Previous Tax Year Date not found.'
                         ,pt_i_OracleError         => gvt_ReturnMessage
                         );
                 --
                 RAISE e_ModuleError;
                 --
        END IF;              
        --
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
                        ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable   || '".'   
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
        -- 
        INSERT  
        INTO    xxmx_per_pos_wr_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,termination_accepted_person_id
                ,person_id
                ,date_start
                ,actual_termination_date
                ,notified_termination_date
                ,projected_termination_date
                ,date_employee_data_verified
                ,fast_path_employee
                ,legal_employer_name
                ,legislation_code
                ,on_military_service
                ,original_date_of_hire
                ,period_type
                ,primary_flag
                ,rehire_authorizor
                ,rehire_reason
                ,rehire_recommendation
                ,action_occurrence_id
                ,period_of_service_id
				,attribute1
				,personnumber)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,NULL termination_accepted_person_id
                ,xxmx_per_persons_stg.person_id person_id
                ,c34_date_start date_start
                ,c36_actual_termination_date actual_termination_date
                ,c48_notified_termination_date notified_termination_date
                ,c50_projected_termination_date projected_termination_date
                ,c70_date_employee_data_verifie date_employee_data_verified
                ,nvl (c72_fast_path_employee
                        ,'Y') fast_path_employee
                ,Case When business_group_id is NOT NULL THEN 
					xxmx_kit_worker_stg.get_legal_employer_name(business_group_id)
					ELSE 
						NULL
					END "legal_employer"
                ,gvv_leg_code
                ,nvl (c73_on_military_service
                        ,'N') on_military_service
                ,c46_original_date_of_hire original_date_of_hire
                ,'C' period_type
                ,'Y' primary_flag
                ,c29_rehire_authorizor rehire_authorizor
                ,c37_rehire_reason rehire_reason
                ,nvl (c71_rehire_recommendation
                        ,'N') rehire_recommendation
                ,NULL action_occurrence_id
                ,s0_period_of_placement_id
                    || '_PERIOD_OF_PLACEMENT'
				,payroll_name
				,c_per_periods_of_ser.personnumber
        FROM    xxmx_per_persons_stg xxmx_per_persons_stg
                ,
                (
                SELECT   distinct per_all_people_f.rehire_authorizor c29_rehire_authorizor
                    ,per_periods_of_placement.date_start c34_date_start
                    ,per_periods_of_placement.actual_termination_date c36_actual_termination_date
                    ,per_all_people_f.rehire_reason c37_rehire_reason
                    ,per_all_people_f.original_date_of_hire c46_original_date_of_hire
                    ,NULL c48_notified_termination_date
                    ,per_periods_of_placement.projected_termination_date c50_projected_termination_date
                    ,per_all_people_f.date_employee_data_verified c70_date_employee_data_verifie
                    ,per_all_people_f.person_id c74_s_person_id
					,per_all_people_f.business_Group_id
                    ,per_all_people_f.fast_path_employee c72_fast_path_employee
                    ,per_all_people_f.on_military_service c73_on_military_service
                    ,per_all_people_f.rehire_recommendation c71_rehire_recommendation
                    ,per_periods_of_placement.period_of_placement_id s0_period_of_placement_id
					,(select distinct Organization_id from xxmx_hcm_current_asg_scope_mv paaf
					where period_of_service_id = per_periods_of_placement.period_of_placement_id
					and person_id = per_all_people_f.person_id
					and rownum=1
					AND TRUNC(per_all_people_f.effective_start_Date) BETWEEN paaf.effective_start_date   AND     paaf.effective_end_date) s_organization_id
					,(SELECT Payroll_name
					  FROM PAY_PAYROLLS_F@MXDM_NVIS_EXTRACT ppf,Per_all_assignments_f@MXDM_NVIS_EXTRACT paaf
					  WHERE PPF.PAYROLL_ID = paaf.payroll_id
					  and paaf.person_id = per_all_people_f.person_id
					  and paaf.primary_flag = 'Y'
					  and trunc(sysdate) BETWEEN paaf.effective_start_date and paaf.effective_end_date
					  AND trunc(sysdate) BETWEEN ppf.effective_start_date and ppf.effective_end_date)
					  Payroll_name 
					  ,per_all_people_f.npw_number personnumber
                FROM    per_periods_of_placement@MXDM_NVIS_EXTRACT per_periods_of_placement
                    ,xxmx_hcm_person_scope_mv  per_all_people_f
                WHERE   per_periods_of_placement.person_id = per_all_people_f.person_id
                AND    per_all_people_f.business_group_id= per_periods_of_placement.business_group_id
                AND    per_all_people_f.business_group_id= p_bg_id
                ) c_per_periods_of_ser
        WHERE   (
                        xxmx_per_persons_stg.person_id = c74_s_person_id

                )
        ;
        --
        -- 
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed' 
                        ,pt_i_OracleError         => gvt_ReturnMessage       );   

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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;

    END export_period_of_service_2;
    
    PROCEDURE export_per_workrel
    (p_bg_name                      IN      varchar2
    ,p_bg_id                        IN      number
    ,pt_i_MigrationSetID            IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_MigrationSetName          IN      xxmx_migration_headers.migration_set_name%TYPE ) IS
    
    cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'EXPORT_PER_WORKREL'; 
    ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
    cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_WORKREL_STG';
    cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_WORKRELATIONSHIP';
    
    BEGIN
        --
        --       
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
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0005';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'DATA'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        IF   gvv_ReturnStatus = 'F'
        THEN
            xxmx_utilities_pkg.log_module_message
                (pt_i_ApplicationSuite    => gct_ApplicationSuite
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
        END IF;
        --
        --
        --
        set_parameters(p_bg_id);
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
        FROM    XXMX_PER_WORKREL_STG
        WHERE   bg_id    = p_bg_id    ; 
        
        COMMIT;   
        --
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
                        ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable   || '".'   
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
                        
       INSERT  
				INTO    XXMX_PER_WORKREL_STG
						(migration_set_id
						,migration_set_name                   
						,migration_status
						,bg_name
						,bg_id
						,PERSON_ID
                        ,PERSONNUMBER
                        ,DATE_START
                        ,WORKER_TYPE
                        ,LEGAL_EMPLOYER_NAME
                        ,ACTION_CODE
                        ,REASON_CODE
                        ,PRIMARY_FLAG
                        ,TERMINATE_WORK_RELATIONSHIP_FLAG
                        ,ACTUAL_TERMINATION_DATE
                        ,LAST_WORKING_DATE
                      )
              SELECT     distinct pt_i_MigrationSetID                               
						,pt_i_MigrationSetName                               
						,'EXTRACTED'  
						,p_bg_name
						,p_bg_id
                        ,person_id
                        ,PERSONNUMBER
                        ,DATE_start
                        ,proposed_worker_type
                        ,legal_employer_name
                        ,action_code
                        ,REASON_CODE
                        ,'Y' 
                        ,null
                        ,null
                        ,null
                        
           FROM          xxmx_per_assignments_m_stg
           WHERE action_code='HIRE'
           AND bg_id = p_bg_id
UNION ALL           
     SELECT      distinct pt_i_MigrationSetID                               
						,pt_i_MigrationSetName                               
						,'EXTRACTED'  
						,p_bg_name
						,p_bg_id
                        ,asg.person_id
                        ,asg.PERSONNUMBER
                        ,asg.DATE_start
                        ,asg.proposed_worker_type
                        ,asg.legal_employer_name
                        ,asg.action_code
                        ,asg.REASON_CODE
                        ,'Y'   
                        ,'Y'
                        ,pos.actual_termination_date
                        ,pos.last_working_date
           FROM          xxmx_per_assignments_m_stg asg, xxmx_per_pos_wr_stg pos
           WHERE asg.action_code='TERMINATION'
           AND asg.bg_id = p_bg_id
           AND asg.PERIOD_OF_SERVICE_ID=pos.PERIOD_OF_SERVICE_ID;
           
        COMMIT;
        --
        -- 
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed' 
                        ,pt_i_OracleError         => gvt_ReturnMessage       );   

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
    
    END export_per_workrel;

    PROCEDURE export_all_assignments_m_1
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'EXPORT_ALL_ASSIGNMENTS_M_1'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_ASSIGNMENTS_M_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'ALL_ASSIGNMENTS_M_1';
	    lvv_migration_date_from                         VARCHAR2(30); 
        lvv_prev_tax_year_date                          VARCHAR2(30);         
        lvd_migration_date_from                         DATE;
        lvd_prev_tax_year_date                          DATE;   
		lvv_migration_date_to                          VARCHAR2(30); 
        lvd_migration_date_to                          DATE; 
    BEGIN
         --
        --       
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
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0005';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'DATA'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        IF   gvv_ReturnStatus = 'F'
        THEN
            xxmx_utilities_pkg.log_module_message
                (pt_i_ApplicationSuite    => gct_ApplicationSuite
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
        DELETE 
        FROM    xxmx_per_assignments_m_stg
        WHERE   bg_id    = p_bg_id    ;  

        COMMIT;         
        --
        set_parameters(p_bg_id);
        --
        --
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
                        ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable   || '".'   
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
        -- 
        INSERT  
        INTO    xxmx_per_assignments_m_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
				,bargaining_unit_code
				,date_probation_end
				,employee_category
				,employment_category
				,establishment_id
				,expense_check_address
				,grade_code
				,position_code
				,grade_ladder_pgm_name
				,hourly_salaried_code
				,internal_building
				,internal_floor 
				,internal_location
				,internal_mailstop
				,internal_office_number
				,job_code
				,labour_union_member_flag
				,location_code
				,job_id
				,location_id
				,position_id
				,ORGANIZATION_ID
				,contract_id
				,grade_id 
				,manager_flag
				,normal_hours
				,frequency
				,notice_period
				,notice_period_uom
				,USER_PERSON_TYPE
				,PROBATION_PERIOD
				,PROBATION_UNIT
				,project_title
				,projected_assignment_end
				,SPEC_CEILING_STEP
				,WORK_AT_HOME_FLAG
				,TIME_NORMAL_FINISH
				,TIME_NORMAL_START
                ,effective_start_date
                ,effective_end_date
                ,person_id
                ,period_of_service_id
                ,assignment_type
                ,assignment_NUMBER
                ,assignment_sequence
                ,assignment_status_type_id
                ,primary_flag
                ,action_code
                ,assignment_name
                ,assignment_status_type
                ,auto_end_flag
                ,effective_sequence
                ,legal_employer_name
                ,legislation_code
                ,primary_work_terms_flag
                ,primary_assignment_flag
                ,primary_work_relation_flag
                ,system_person_type
                ,business_unit_name
                ,action_occurrence_id
                ,position_override_flag
                ,effective_latest_change
                ,allow_asg_override_flag
                ,freeze_start_date
                ,freeze_until_date
                ,assignment_id
				,Reason_code
				,work_terms_assignment_id
				,proposed_worker_type 
				,PAYROLLNAME
				,default_code_comb_id
				,personnumber
				)
		SELECT  distinct  pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,get_target_lookup_code (c72_bargaining_unit_code,'BARGAINING_UNIT_CODE') bargaining_unit_code
				,date_probation_end
				,get_target_lookup_code (c75_employee_category
                                        ,'EMPLOYEE_CATEGORY') employee_category
				,get_target_lookup_code (c76_employment_category
                                        ,'EMP_CAT') employment_category
				,Org_name
				,EXPENSE_CHECK_ADDRESS
				,Grade_Code
				,position_code
				,GRADE_LADDER_PGM_NAME
				,c77_hourly_salaried_code
				,internal_address_line
				,internal_address_line
				,internal_address_line
				,internal_address_line
				,internal_address_line
				,job_code
				,labour_union_member_flag
				,location_code
				,to_char(job_id)
				,to_char(location_id)
				,to_char(position_id)
				,Org_name
				,Contract_name
				,to_char(grade_id)
				,manager_flag
				,normal_hours
				,frequency
				,notice_period
				,c74_notice_period_uom
				,USER_PERSON_TYPE
				,probation_period
				,probation_unit
				,project_title
				,projected_assignment_end
				,SPECIAL_CEILING_STEP_NAME
				,WORK_AT_HOME
				,TIME_NORMAL_FINISH
				,TIME_NORMAL_START
                ,c8_effective_start_date effective_start_date
                --,NVL(c12_effective_end_date, to_date ('31-12-4712','DD-MM-YYYY')) effective_end_date
				, to_date ('31-12-4712','DD-MM-YYYY') effective_end_date
                ,c21_s_person_id person_id
                ,s0_period_of_placement_id|| '_PERIOD_OF_PLACEMENT' period_of_service_id
                ,'C' assignment_type
                ,'C'||c14_assignment_NUMBER assignment_NUMBER
                ,c2_assignment_sequence assignment_sequence
                ,c19_pay_system_status||'_'||c20_per_system_status 
                ,c4_primary_flag
                ,'CURRENT'
                ,c11_assignment_name assignment_name
                ,'P_ACTIVE_ASSIGN' assignment_status_type
                ,'Y' auto_end_flag	
                ,effective_sequence
                ,Case When business_group_id is NOT NULL THEN 
					xxmx_kit_worker_stg.get_legal_employer_name(business_group_id)
					ELSE 
						NULL
					END "legal_employer"
                ,gvv_leg_code
                ,c9_primary_work_terms_flag primary_work_terms_flag
                ,c7_primary_assignment_flag primary_assignment_flag
                ,c10_primary_work_relation_flag primary_work_relation_flag
                ,SYSTEM_PERSON_TYPE system_person_type
                , business_unit_name
                ,NULL action_occurrence_id
                ,'Y' position_override_flag
                --,'N' position_override_flag
                ,'Y' effective_latest_change
                ,'Y' allow_asg_override_flag
                ,to_date ('01-01-1901','DD-MM-YYYY') freeze_start_date
                ,to_date ('31-12-4712','DD-MM-YYYY') freeze_until_date
                ,c25_assignment_id|| '_CWK_ASSIGNMENT'
				,change_reason
				,'CT'||c14_assignment_NUMBER
				,'E'
				,Payroll_name 
            ,default_code_comb_id
			, c_per_all_assignment.personnumber
        FROM    xxmx_per_persons_stg xxmx_per_persons_stg
            ,(
                SELECT distinct  per_all_assignments_f.change_reason
					,per_all_assignments_f.assignment_sequence c2_assignment_sequence
                    ,per_all_assignments_f.primary_flag c4_primary_flag
                    ,per_all_assignments_f.primary_flag  c7_primary_assignment_flag
                    ,to_date ('01-09-2019','DD-MM-YYYY') c8_effective_start_date
                    ,per_all_assignments_f.primary_flag c9_primary_work_terms_flag
                    ,'Y' c10_primary_work_relation_flag
                    ,per_all_assignments_f.title c11_assignment_name
					,1 effective_sequence
                    ,per_person_types.person_type_id c24_person_type_id
                    ,per_all_assignments_f.assignment_id c25_assignment_id
                    ,per_all_assignments_f.effective_end_date c12_effective_end_date
                    ,per_assignment_status_types.pay_system_status c19_pay_system_status
                    ,per_assignment_status_types.per_system_status c20_per_system_status
                    ,per_all_assignments_f.organization_id c17_organization_id
					,per_All_Assignments_f.business_Group_id
                    ,per_all_assignments_f.person_id c21_s_person_id
                    ,per_all_assignments_f.assignment_number c14_assignment_number
                    ,per_all_assignments_f.contract_id c23_contract_id
                    ,per_all_assignments_f.assignment_status_type_id s0_asg_status_type_id
					,per_all_Assignments_f.DATE_PROBATION_END  
                    ,per_periods_of_placement.period_of_placement_id s0_period_of_placement_id
                    ,per_periods_of_placement.final_process_date final_process_date
                    ,per_all_assignments_f.bargaining_unit_code c72_bargaining_unit_code
                    ,per_all_assignments_f.hourly_salaried_code c77_hourly_salaried_code
					,per_all_assignments_f.labour_union_member_flag labour_union_member_flag
					,per_all_assignments_f.employee_category c75_employee_category
					,per_all_assignments_f.employment_category c76_employment_category
                    ,per_all_assignments_f.contract_id c87_contract_id
                    ,per_all_assignments_f.notice_period_uom c74_notice_period_uom
					,per_all_Assignments_f.internal_address_line
					,per_all_Assignments_f.job_id
					,per_all_Assignments_f.grade_id
					,per_all_Assignments_f.location_id
					,per_all_Assignments_f.position_id
                    ,'CURRENT' action_code
					,per_all_assignments_f.manager_flag
					,per_all_assignments_f.normal_hours
					,per_all_assignments_f.frequency
					,per_all_assignments_f.notice_period
					,per_all_people_f.employee_number
					,per_all_assignments_f.probation_period
					,per_all_assignments_f.probation_unit
					,per_all_assignments_f.project_title
					,per_all_assignments_f.projected_assignment_end
					,per_all_assignments_f.WORK_AT_HOME
					,(SELECT NAME 
					  FROM HR_ALL_ORGANIZATION_UNITS@MXDM_NVIS_EXTRACT 
					  WHERE organization_id = per_all_assignments_f.Business_group_id
					  AND TRUNC(SYSDATE ) BETWEEN DATE_FROM AND NVL(DATE_TO, '31-DEC-4712'))
					  business_unit_name
					,(SELECT Reference 
					  FROM per_contracts_f@MXDM_NVIS_EXTRACT 
					  WHERE contract_id = per_all_assignments_f.contract_id
					  AND TRUNC(SYSDATE ) BETWEEN effective_Start_date AND NVL(effective_end_date, '31-DEC-4712'))
					  contract_name
					,(SELECT NAME 
					  FROM HR_ALL_ORGANIZATION_UNITS@MXDM_NVIS_EXTRACT 
					  WHERE organization_id = per_all_assignments_f.organization_id
					  AND TRUNC(SYSDATE ) BETWEEN DATE_FROM AND NVL(DATE_TO, '31-DEC-4712'))
					  Org_name
					,(SELECT Name 
					 FROM per_grades_tl@MXDM_NVIS_EXTRACT 
					WHERE grade_id = per_All_assignments_f.grade_id)
					GRADE_CODE
					,per_all_assignments_f.GRADE_LADDER_PGM_ID
					,per_all_people_f.EXPENSE_CHECK_SEND_TO_ADDRESS "EXPENSE_CHECK_ADDRESS"
					,(Select Name from per_jobs_tl@MXDM_NVIS_EXTRACT where job_id  =  per_All_assignments_f.job_id) JOB_CODE
					,(Select location_code 
					  from hr_locations_all@MXDM_NVIS_EXTRACT 
					  where location_id  =  per_All_assignments_f.location_id)
					location_code
					,per_periods_of_placement.Date_start
					,(Select name from HR_ALL_POSITIONS_F@MXDM_NVIS_EXTRACT  HAPF
					  WHERE position_id = per_All_assignments_f.position_id
					  AND  Trunc(sysdate) BETWEEN HAPF.effective_Start_date AND HAPF.effective_end_date)
					  POSITION_CODE
					,per_person_types.SYSTEM_PERSON_TYPE
					,per_person_types.USER_PERSON_TYPE
				--	,PER_ALL_ASSIGNMENTS_F.RETIREMENT_DATE
					,(SELECT psp.spinal_point
					from  PER_SPINAL_POINT_STEPS_F@MXDM_NVIS_EXTRACT	PSPSF
						, per_spinal_points@MXDM_NVIS_EXTRACT PSP
						,per_grade_spines_f@MXDM_NVIS_EXTRACT pgsf 
					where Step_id  = PER_ALL_ASSIGNMENTS_F.SPECIAL_CEILING_STEP_ID
					and PSP.spinal_point_id =PSPSF.spinal_point_id
					and  TRUNC(SYSDATE) BETWEEN pgsf.effective_Start_date AND pgsf.effective_end_date				
					AND psp.parent_spine_id = pgsf.parent_spine_id
					and pgsf.grade_id = PER_ALL_ASSIGNMENTS_F.grade_id
					and Trunc(sysdate) between PSPSF.effective_Start_date and PSPSF.effective_end_date)
					SPECIAL_CEILING_STEP_NAME
					,PER_ALL_ASSIGNMENTS_F.TIME_NORMAL_FINISH
					,PER_ALL_ASSIGNMENTS_F.TIME_NORMAL_START
					,PER_ALL_ASSIGNMENTS_F.PEOPLE_GROUP_ID
					,(SELECT NAME FROM per_collective_agreements@MXDM_NVIS_EXTRACT PCA 
					  WHERE  collective_agreement_id = per_All_Assignments_f.COLLECTIVE_AGREEMENT_ID 
					  AND TRUNC(SYSDATE)BETWEEN PCA.Start_Date AND PCA.end_date)
					  COLLECTIVE_AGREEMENT_NAME
					,(SELECT Name 
					  FROM BEN_PGM_F@MXDM_NVIS_EXTRACT BPF
					  WHERE PGM_ID = per_all_assignments_f.GRADE_LADDER_PGM_ID
					  AND TRUNC(SYSDATE) BETWEEN BPF.effective_start_Date AND BPF.effective_end_date)
					GRADE_LADDER_PGM_NAME
					,(SELECT Payroll_name
					  FROM PAY_PAYROLLS_F@MXDM_NVIS_EXTRACT ppf
					  WHERE PAYROLL_ID = per_all_assignments_f.payroll_id
					  AND trunc(sysdate) BETWEEN ppf.effective_start_date and ppf.effective_end_date)
					  Payroll_name 
                 ,per_all_assignments_f.default_code_comb_id
				 ,per_all_people_f.npw_number personnumber
                FROM    per_person_type_usages_f@MXDM_NVIS_EXTRACT per_person_type_usages_f
                    ,xxmx_hcm_current_asg_scope_mv per_all_assignments_f
                    ,per_assignment_status_types@MXDM_NVIS_EXTRACT per_assignment_status_types
                    ,xxmx_hcm_person_scope_mv per_all_people_f
                    ,per_person_types@MXDM_NVIS_EXTRACT per_person_types
                    ,per_periods_of_placement@MXDM_NVIS_EXTRACT per_periods_of_placement
                    --,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
                WHERE  per_all_assignments_f.assignment_type = 'C'
                AND    per_person_types.system_person_type IN ('CWK','EX_CWK')
                AND     per_all_assignments_f.assignment_status_type_id = per_assignment_status_types.assignment_status_type_id
                AND    per_all_assignments_f.person_id = per_all_people_f.person_id
				AND    per_all_assignments_f.primary_flag = 'Y'
                AND    per_all_assignments_f.effective_start_date BETWEEN per_all_people_f.effective_start_date
                                                                        AND     per_all_people_f.effective_end_date
                AND    per_all_assignments_f.person_id = per_person_type_usages_f.person_id
                AND    per_all_assignments_f.effective_start_date BETWEEN per_person_type_usages_f.effective_start_date
                                                                        AND     per_person_type_usages_f.effective_end_date
                AND   per_person_types.person_type_id = per_person_type_usages_f.person_type_id
				and   per_periods_of_placement.actual_termination_date IS NULL
                AND   per_periods_of_placement.person_id = per_all_assignments_f.person_id
				AND   per_all_people_f.person_id = per_person_type_usages_f.person_id
                AND   per_all_assignments_f.business_group_id = p_bg_id
                UNION 
				SELECT  distinct per_all_assignments_f.change_reason
					,per_all_assignments_f.assignment_sequence c2_assignment_sequence
                    ,per_all_assignments_f.primary_flag c4_primary_flag
                    ,per_all_assignments_f.primary_flag  c7_primary_assignment_flag
                    ,CASE WHEN (to_char( per_periods_of_placement.Date_start,'MMYYYY')=
						   to_char( per_periods_of_placement.ACTUAL_TERMINATION_DATE,'MMYYYY'))
						THEN  per_periods_of_placement.Date_start
						ELSE 
							trunc((per_periods_of_placement.ACTUAL_TERMINATION_DATE),'month') 
						END c8_effective_start_date
                    ,per_all_assignments_f.primary_flag c9_primary_work_terms_flag
                    ,'Y' c10_primary_work_relation_flag
                    ,per_all_assignments_f.title c11_assignment_name
					,CASE WHEN (to_char( per_periods_of_placement.Date_start,'MMYYYY')=
						   to_char( per_periods_of_placement.ACTUAL_TERMINATION_DATE,'MMYYYY'))
						THEN  2
						ELSE 
							 1
						END   effective_sequence
                    ,per_person_types.person_type_id c24_person_type_id
                    ,per_all_assignments_f.assignment_id c25_assignment_id
                    ,per_all_assignments_f.effective_end_date c12_effective_end_date
                    ,per_assignment_status_types.pay_system_status c19_pay_system_status
                    ,per_assignment_status_types.per_system_status c20_per_system_status
                    ,per_all_assignments_f.organization_id c17_organization_id
					,per_all_assignments_f.Business_group_id
                    ,per_all_assignments_f.person_id c21_s_person_id
                    ,per_all_assignments_f.assignment_number c14_assignment_number
                    ,per_all_assignments_f.contract_id c23_contract_id
                    ,per_all_assignments_f.assignment_status_type_id s0_asg_status_type_id
					,per_all_Assignments_f.DATE_PROBATION_END  
                    ,per_periods_of_placement.period_of_placement_id s0_period_of_placement_id
                    ,per_periods_of_placement.final_process_date final_process_date
                    ,per_all_assignments_f.bargaining_unit_code c72_bargaining_unit_code
                    ,per_all_assignments_f.hourly_salaried_code c77_hourly_salaried_code
					,per_all_assignments_f.labour_union_member_flag labour_union_member_flag
					,per_all_assignments_f.employee_category c75_employee_category
					,per_all_assignments_f.employment_category c76_employment_category
                    ,per_all_assignments_f.contract_id c87_contract_id
                    ,per_all_assignments_f.notice_period_uom c74_notice_period_uom
					,per_all_Assignments_f.internal_address_line
					,per_all_Assignments_f.job_id
					,per_all_Assignments_f.grade_id
					,per_all_Assignments_f.location_id
					,per_all_Assignments_f.position_id
                    ,'CURRENT' action_code
					,per_all_assignments_f.manager_flag
					,per_all_assignments_f.normal_hours
					,per_all_assignments_f.frequency
					,per_all_assignments_f.notice_period
					,per_all_people_f.employee_number
					,per_all_assignments_f.probation_period
					,per_all_assignments_f.probation_unit
					,per_all_assignments_f.project_title
					,per_all_assignments_f.projected_assignment_end
					,per_all_assignments_f.WORK_AT_HOME
					,(SELECT NAME 
					  FROM HR_ALL_ORGANIZATION_UNITS@MXDM_NVIS_EXTRACT 
					  WHERE organization_id = per_all_assignments_f.Business_group_id
					  AND TRUNC(SYSDATE ) BETWEEN DATE_FROM AND NVL(DATE_TO, '31-DEC-4712'))
					  business_unit_name
					,(SELECT Reference 
					  FROM per_contracts_f@MXDM_NVIS_EXTRACT 
					  WHERE contract_id = per_all_assignments_f.contract_id
					  AND TRUNC(SYSDATE ) BETWEEN effective_Start_date AND NVL(effective_end_date, '31-DEC-4712'))
					  contract_name
					,(SELECT NAME 
					  FROM HR_ALL_ORGANIZATION_UNITS@MXDM_NVIS_EXTRACT 
					  WHERE organization_id = per_all_assignments_f.organization_id
					  AND TRUNC(SYSDATE ) BETWEEN DATE_FROM AND NVL(DATE_TO, '31-DEC-4712'))
					  Org_name
					,(SELECT Name 
					 FROM per_grades_tl@MXDM_NVIS_EXTRACT 
					WHERE grade_id = per_All_assignments_f.grade_id)
					GRADE_CODE
					,per_all_assignments_f.GRADE_LADDER_PGM_ID
					,per_all_people_f.EXPENSE_CHECK_SEND_TO_ADDRESS "EXPENSE_CHECK_ADDRESS"
					,(Select Name from per_jobs_tl@MXDM_NVIS_EXTRACT where job_id  =  per_All_assignments_f.job_id) JOB_CODE
					,(Select location_code from hr_locations_all@MXDM_NVIS_EXTRACT where location_id  =  per_All_assignments_f.location_id)
					location_code
					,per_periods_of_placement.Date_start
					,(Select name from HR_ALL_POSITIONS_F@MXDM_NVIS_EXTRACT  HAPF
					  WHERE position_id = per_All_assignments_f.position_id
					  AND  Trunc(sysdate) BETWEEN HAPF.effective_Start_date AND HAPF.effective_end_date)
					  POSITION_CODE
					,per_person_types.SYSTEM_PERSON_TYPE
					,per_person_types.USER_PERSON_TYPE
				--	,PER_ALL_ASSIGNMENTS_F.RETIREMENT_DATE
					,(SELECT psp.spinal_point
					from  PER_SPINAL_POINT_STEPS_F@MXDM_NVIS_EXTRACT	PSPSF
						, per_spinal_points@MXDM_NVIS_EXTRACT PSP
						,per_grade_spines_f@MXDM_NVIS_EXTRACT pgsf 
					where Step_id  = PER_ALL_ASSIGNMENTS_F.SPECIAL_CEILING_STEP_ID
					and PSP.spinal_point_id =PSPSF.spinal_point_id
					and  TRUNC(SYSDATE) BETWEEN pgsf.effective_Start_date AND pgsf.effective_end_date				
					AND psp.parent_spine_id = pgsf.parent_spine_id
					and pgsf.grade_id = PER_ALL_ASSIGNMENTS_F.grade_id
					and Trunc(sysdate) between PSPSF.effective_Start_date and PSPSF.effective_end_date)
					SPECIAL_CEILING_STEP_NAME
					,PER_ALL_ASSIGNMENTS_F.TIME_NORMAL_FINISH
					,PER_ALL_ASSIGNMENTS_F.TIME_NORMAL_START
					,PER_ALL_ASSIGNMENTS_F.PEOPLE_GROUP_ID
					,(SELECT NAME FROM per_collective_agreements@MXDM_NVIS_EXTRACT PCA 
					  WHERE  collective_agreement_id = per_All_Assignments_f.COLLECTIVE_AGREEMENT_ID 
					  AND TRUNC(SYSDATE)BETWEEN PCA.Start_Date AND PCA.end_date)
					  COLLECTIVE_AGREEMENT_NAME
					,(SELECT Name 
					  FROM BEN_PGM_F@MXDM_NVIS_EXTRACT BPF
					  WHERE PGM_ID = per_all_assignments_f.GRADE_LADDER_PGM_ID
					  AND TRUNC(SYSDATE) BETWEEN BPF.effective_start_Date AND BPF.effective_end_date)
					GRADE_LADDER_PGM_NAME
					,(SELECT Payroll_name
					  FROM PAY_PAYROLLS_F@MXDM_NVIS_EXTRACT ppf
					  WHERE PAYROLL_ID = per_all_assignments_f.payroll_id
					  AND trunc(sysdate) BETWEEN ppf.effective_start_date and ppf.effective_end_date)
					  Payroll_name 
                 ,per_all_assignments_f.default_code_comb_id
				 ,per_all_people_f.npw_number personnumber
                FROM    per_person_type_usages_f@MXDM_NVIS_EXTRACT per_person_type_usages_f
                    ,xxmx_hcm_current_asg_scope_mv per_all_assignments_f
                    ,per_assignment_status_types@MXDM_NVIS_EXTRACT per_assignment_status_types
                    ,xxmx_hcm_person_scope_mv per_all_people_f
                    ,per_person_types@MXDM_NVIS_EXTRACT per_person_types
                    ,per_periods_of_placement@MXDM_NVIS_EXTRACT per_periods_of_placement
                    --,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
                WHERE  per_all_assignments_f.assignment_type = 'C'
                AND    per_person_types.system_person_type IN ('CWK','EX_CWK')
                AND     per_all_assignments_f.assignment_status_type_id = per_assignment_status_types.assignment_status_type_id
                AND    per_all_assignments_f.person_id = per_all_people_f.person_id
                AND    per_all_assignments_f.effective_start_date BETWEEN per_all_people_f.effective_start_date
                                                                        AND     per_all_people_f.effective_end_date
                AND    per_all_assignments_f.person_id = per_person_type_usages_f.person_id
                AND    per_all_assignments_f.effective_start_date BETWEEN per_person_type_usages_f.effective_start_date
                                                                        AND     per_person_type_usages_f.effective_end_date
                AND   per_person_types.person_type_id = per_person_type_usages_f.person_type_id
				AND   per_periods_of_placement.actual_termination_date IS NOT NULL
				AND   per_periods_of_placement.actual_termination_date  BETWEEN  TRUNC(gvd_migration_date_from) AND '31-DEC-4712'
				AND    per_all_assignments_f.primary_flag = 'Y'
                AND   per_periods_of_placement.person_id = per_all_assignments_f.person_id
                AND   per_all_people_f.person_id = per_person_type_usages_f.person_id
                AND   per_all_assignments_f.business_group_id = p_bg_id
               	 ) c_per_all_assignment
        where    xxmx_per_persons_stg.person_id = c21_s_person_id
        ;

        /*SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,c8_effective_start_date effective_start_date
                ,(CASE
                    WHEN    (
                                    c12_effective_end_date = final_process_date
                            AND     c20_per_system_status = 'TERM_ASSIGN'
                            )
                            THEN    to_date ('31-12-4712'
                                            ,'DD-MM-YYYY')
                    ELSE    c12_effective_end_date END) effective_end_date
                ,c21_s_person_id
                    || '_PERSON' person_id
                ,s0_period_of_placement_id
                    || '_PERIOD_OF_PLACEMENT' period_of_service_id
                ,'CT' assignment_type
                ,'CWK_TERM_'
                    || c14_assignment_NUMBER assignment_NUMBER
                ,c2_assignment_sequence assignment_sequence
                ,(CASE
                    WHEN    (
                                    c20_per_system_status = 'TERM_ASSIGN'
                            AND     c19_pay_system_status = 'P'
                            )
                            THEN    v_astat_inactive_p
                    WHEN    (
                                    c20_per_system_status = 'TERM_ASSIGN'
                            AND     c19_pay_system_status = 'D'
                            )
                            THEN    v_astat_inactive_np
                    WHEN    (
                                    c20_per_system_status = 'SUSP_CWK_ASG'
                            AND     c19_pay_system_status = 'P'
                            )
                            THEN    v_astat_suspend_p
                    WHEN    (
                                    c20_per_system_status = 'SUSP_CWK_ASG'
                            AND     c19_pay_system_status = 'D'
                            )
                            THEN    v_astat_suspend_np
                    WHEN    (
                                    c20_per_system_status = 'ACTIVE_CWK'
                            AND     c19_pay_system_status = 'P'
                            )
                            THEN    v_astat_active_p
                    WHEN    (
                                    c20_per_system_status = 'ACTIVE_CWK'
                            AND     c19_pay_system_status = 'D'
                            )
                            THEN    gvv_astat_active_np
                    ELSE    'N/A' END) assignment_status_type_id
                ,'N' c4_primary_flag
                ,action_code
                ,c11_assignment_name assignment_name
                ,(CASE
                    WHEN    (
                                    c20_per_system_status = 'TERM_ASSIGN'
                            AND     c19_pay_system_status = 'P'
                            )
                            THEN    'INACTIVE'
                    WHEN    (
                                    c20_per_system_status = 'TERM_ASSIGN'
                            AND     c19_pay_system_status = 'D'
                            )
                            THEN    'INACTIVE'
                    WHEN    (
                                    c20_per_system_status = 'SUSP_CWK_ASG'
                            AND     c19_pay_system_status = 'P'
                            )
                            THEN    'SUSPEND'
                    WHEN    (
                                    c20_per_system_status = 'SUSP_CWK_ASG'
                            AND     c19_pay_system_status = 'D'
                            )
                            THEN    'SUSPEND'
                    WHEN    (
                                    c20_per_system_status = 'ACTIVE_CWK'
                            AND     c19_pay_system_status = 'P'
                            )
                            THEN    'ACTIVE'
                    WHEN    (
                                    c20_per_system_status = 'ACTIVE_CWK'
                            AND     c19_pay_system_status = 'D'
                            )
                            THEN    'ACTIVE'
                    ELSE    'N/A' END) assignment_status_type
                ,'Y' auto_end_flag
                ,1 effective_sequence
                ,Case When c17_organization_id is NOT NULL THEN 
					xxmx_kit_worker_stg.get_legal_employer_name(SUBSTR(c17_organization_id,1,INSTR(c17_organization_id,'_',1)-1))
					ELSE 
						NULL
					END "legal_employer"
                ,v_leg_code
                ,c9_primary_work_terms_flag primary_work_terms_flag
                ,c7_primary_assignment_flag primary_assignment_flag
                ,c10_primary_work_relation_flag primary_work_relation_flag
                ,'CWK' system_person_type
                ,v_business_name business_unit_name
                ,NULL action_occurrence_id
                ,'Y' position_override_flag
                ,'Y' effective_latest_change
                ,'Y' allow_asg_override_flag
                ,to_date ('01-01-1901'
                            ,'DD-MM-YYYY') freeze_start_date
                ,to_date ('31-12-4712'
                            ,'DD-MM-YYYY') freeze_until_date
                ,c25_assignment_id
                    || '_CWK_TERM'
        FROM    xxmx_per_persons_stg xxmx_per_persons_stg
            ,(
                SELECT  per_all_assignments_f.assignment_sequence c2_assignment_sequence
                    ,per_all_assignments_f.primary_flag c4_primary_flag
                    ,'Y' c7_primary_assignment_flag
                    ,per_all_assignments_f.effective_start_date c8_effective_start_date
                    ,per_all_assignments_f.primary_flag c9_primary_work_terms_flag
                    ,'Y' c10_primary_work_relation_flag
                    ,'CT'
                        || per_all_assignments_f.assignment_NUMBER c11_assignment_name
                    ,per_person_types.person_type_id c24_person_type_id
                    ,per_all_assignments_f.assignment_id c25_assignment_id
                    ,per_all_assignments_f.effective_end_date c12_effective_end_date
                    ,per_assignment_status_types.pay_system_status c19_pay_system_status
                    ,per_assignment_status_types.per_system_status c20_per_system_status
                    ,per_all_assignments_f.organization_id c17_organization_id
                    ,per_all_assignments_f.person_id c21_s_person_id
                    ,per_all_assignments_f.assignment_NUMBER c14_assignment_NUMBER
                    ,per_all_assignments_f.contract_id c23_contract_id
                    ,per_all_assignments_f.assignment_status_type_id s0_asg_status_type_id
                    ,per_periods_of_placement.period_of_placement_id s0_period_of_placement_id
                    ,per_periods_of_placement.final_process_date final_process_date
                    ,'ASG_CHANGE' action_code
					,(Select Name from per_grades_tl@MXDM_NVIS_EXTRACT where grade_id = per_All_assignments_f.grade_id)
					,per_all_assignments_f.GRADE_LADDER_PGM_ID
					,per_all_people_f.EXPENSE_CHECK_SEND_TO_ADDRESS "EXPENSE_CHECK_ADDRESS"
					,(Select Name from per_jobs_tl@MXDM_NVIS_EXTRACT where job_id  =  per_All_assignments_f.job_id)
					,(Select location_code from hr_locations_all@MXDM_NVIS_EXTRACT where location_id  =  per_All_assignments_f.location_id)
					,per_periods_of_placement.Date_start
					,(Select name from HR_ALL_POSITIONS_F@MXDM_NVIS_EXTRACT  HAPF
					  WHERE position_id = per_All_assignments_f.position_id
					  AND  Trunc(sysdate) BETWEEN HAPF.effective_Start_date AND HAPF.effective_end_date)
					,PER_ALL_ASSIGNMENTS_F.PROJECTED_ASSIGNMENT_END
					,per_person_types.SYSTEM_PERSON_TYPE
					,per_person_types.USER_PERSON_TYPE
				--	,PER_ALL_ASSIGNMENTS_F.RETIREMENT_DATE
					,(SELECT Name from  PER_SPINAL_POINT_STEPS_F@MXDM_NVIS_EXTRACT	PSPSF, per_spinal_points@MXDM_NVIS_EXTRACT PSP
						where Step_id  = PER_ALL_ASSIGNMENTS_F.SPECIAL_CEILING_STEP_ID
						and PSP.spinal_point_id =PSPSF.spinal_point_id
						and Trunc(sysdate) between PSPSF.effective_Start_date and PSPSF.effective_end_date)
					,PER_ALL_ASSIGNMENTS_F.TIME_NORMAL_FINISH
					,PER_ALL_ASSIGNMENTS_F.TIME_NORMAL_START
					,PER_ALL_ASSIGNMENTS_F.PEOPLE_GROUP_ID
					,(SELECT NAME FROM per_collective_agreements@MXDM_NVIS_EXTRACT PCA 
					  WHERE  collective_agreement_id = per_All_Assignments_f.COLLECTIVE_AGREEMENT_ID 
					  AND TRUNC(SYSDATE)BETWEEN PCA.Start_Date AND PCA.end_date)
                FROM    per_person_type_usages_f@MXDM_NVIS_EXTRACT per_person_type_usages_f
                    ,per_all_assignments_f@MXDM_NVIS_EXTRACT per_all_assignments_f
                    ,per_assignment_status_types@MXDM_NVIS_EXTRACT per_assignment_status_types
                    ,per_all_people_f@MXDM_NVIS_EXTRACT per_all_people_f
                    ,per_person_types@MXDM_NVIS_EXTRACT per_person_types
                    ,per_periods_of_placement@MXDM_NVIS_EXTRACT per_periods_of_placement
                    ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
                WHERE   (
                                per_all_assignments_f.assignment_type = 'C'
                        )
                AND     (
                                per_person_types.system_person_type IN ('CWK','EX_CWK')
                        )
                AND     (
                                per_all_assignments_f.assignment_status_type_id = per_assignment_status_types.assignment_status_type_id
                        )
                AND     (
                                per_all_assignments_f.person_id = per_all_people_f.person_id
                        AND     per_all_assignments_f.effective_start_date BETWEEN per_all_people_f.effective_start_date
                                                                        AND     per_all_people_f.effective_end_date
                        )
                AND     (
                                per_all_assignments_f.person_id = per_person_type_usages_f.person_id
                        AND     per_all_assignments_f.effective_start_date BETWEEN per_person_type_usages_f.effective_start_date
                                                                        AND     per_person_type_usages_f.effective_end_date
                        )
                AND     (
                                per_person_types.person_type_id = per_person_type_usages_f.person_type_id
                        )
                AND     (
                                per_periods_of_placement.person_id = per_all_assignments_f.person_id
                        AND     per_periods_of_placement.date_start = per_all_assignments_f.period_of_placement_date_start
                        )
                AND     (
                                horg.organization_id = per_all_assignments_f.business_group_id
                        AND     horg.name = p_bg_name
                        )
                ) c_per_all_assignment
        where      (
                            xxmx_per_persons_stg.person_id = c21_s_person_id

                    )
        and         exists (
        select 1 from xxmx_per_pos_wr_stg inn
        where  inn.period_of_service_id = s0_period_of_placement_id
                    || '_PERIOD_OF_PLACEMENT'
        and    c8_effective_start_date between  inn.date_start and  nvl(actual_termination_date,to_date('31-12-4712','DD-MM-YYYY'))
        and    inn.period_type = 'C'
        and    inn.person_id = c21_s_person_id
                                                            || '_PERSON'
        );*/

        COMMIT;
        --
        -- 
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed' 
                        ,pt_i_OracleError         => gvt_ReturnMessage       );   

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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;

    END export_all_assignments_m_1;

    PROCEDURE export_all_assignments_m_2
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'EXPORT_ALL_ASSIGNMENTS_M_2'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_ASSIGNMENTS_M_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'ALL_ASSIGNMENTS_M_2';

		lvv_migration_date_from                         VARCHAR2(30); 
        lvv_prev_tax_year_date                          VARCHAR2(30);         
        lvd_migration_date_from                         DATE;
        lvd_prev_tax_year_date                          DATE;   
		lvv_migration_date_to                          VARCHAR2(30); 
        lvd_migration_date_to                          DATE; 

        lv_person_id VARCHAR2(30);


    BEGIN
        --
        --       
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
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0005';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'DATA'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        IF   gvv_ReturnStatus = 'F'
        THEN
            xxmx_utilities_pkg.log_module_message
                (pt_i_ApplicationSuite    => gct_ApplicationSuite
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
        END IF;      
		--
		--
        set_parameters(p_bg_id);
        --
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
                        ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable   || '".'   
                        ,pt_i_OracleError         => gvt_ReturnMessage       );


		--INSERT INTO XXMX_TEST VALUES('export_all_assignments_m_2'||gvd_migration_date_from||' '||gvd_migration_date_to); 
	--	INSERT INTO XXMX_TEST VALUES (lv_person_id);


        INSERT  
        INTO    xxmx_per_assignments_m_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
				,bargaining_unit_code
				,date_probation_end
				,employee_category
				,employment_category
				,establishment_id
				,expense_check_address
				,grade_code
				,position_code
				,grade_ladder_pgm_name
				,hourly_salaried_code
				,internal_building
				,internal_floor 
				,internal_location
				,internal_mailstop
				,internal_office_number
				,job_code
				,labour_union_member_flag
				,location_code
				,job_id
				,location_id
				,position_id
				,ORGANIZATION_ID
				,contract_id
				,grade_id 
				,manager_flag
				,normal_hours
				,frequency
				,notice_period
				,notice_period_uom
				,USER_PERSON_TYPE
				,PROBATION_PERIOD
				,PROBATION_UNIT
				,project_title
				,projected_assignment_end
				,SPEC_CEILING_STEP
				,WORK_AT_HOME_FLAG
				,TIME_NORMAL_FINISH
				,TIME_NORMAL_START
                ,effective_start_date
                ,effective_end_date
                ,person_id
                ,period_of_service_id
                ,assignment_type
                ,assignment_NUMBER
                ,assignment_sequence
                ,assignment_status_type_id
                ,primary_flag
                ,action_code
                ,assignment_name
                ,assignment_status_type
                ,auto_end_flag
                ,effective_sequence
                ,legal_employer_name
                ,legislation_code
                ,primary_work_terms_flag
                ,primary_assignment_flag
                ,primary_work_relation_flag
                ,system_person_type
                ,business_unit_name
                ,action_occurrence_id
                ,position_override_flag
                ,effective_latest_change
                ,allow_asg_override_flag
                ,freeze_start_date
                ,freeze_until_date
                ,assignment_id
				,Reason_code
				,job_post_source_name
                ,person_referred_by_id
                ,applicant_rank
                ,posting_content_id
                ,source_type
				,work_terms_assignment_id
				,proposed_worker_type
				,PAYROLLNAME
                ,people_group_id
                ,default_code_comb_id
				,personnumber)
		SELECT  distinct pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,get_target_lookup_code (c72_bargaining_unit_code,'BARGAINING_UNIT_CODE') bargaining_unit_code
				,c17_date_probation_end
				,get_target_lookup_code (c75_employee_category
                                        ,'EMPLOYEE_CATEGORY') employee_category
				,get_target_lookup_code (c76_employment_category
                                        ,'EMP_CAT') employment_category
				,Org_name
				,EXPENSE_CHECK_ADDRESS
				,Grade_Code
				,position_code
				,GRADE_LADDER_PGM_NAME
				,c77_hourly_salaried_code
				,c10_internal_location
				,c10_internal_location
				,c10_internal_location
				,c10_internal_location
				,c10_internal_location
				,job_code
				,c39_labour_union_member_flag
				,location_code
				,to_char(c82_job_id)
				,to_char(c83_location_id)
				,to_char(c84_position_id)
				,Org_id
				,Contract_name
				,to_char(c85_grade_id)
				,c30_manager_flag
				,c52_normal_hours
				,c73_frequency
				,c59_notice_period
				,c74_notice_period_uom
				,USER_PERSON_TYPE
				,c48_probation_period
				,c14_probation_unit
				,c54_project_title
				,c15_projected_assignment_end
				,SPECIAL_CEILING_STEP_NAME
				,c37_work_at_home
				,c40_time_normal_finish
				,c3_time_normal_start
                ,c8_effective_start_date effective_start_date
                , to_date ('31-12-4712','DD-MM-YYYY') effective_end_date
                ,c25_s_person_id person_id
                ,s0_period_of_service_id --|| '_PERIOD_OF_SERVICE' 
                ,'E' assignment_type
                ,'E'||c14_assignment_number assignment_number
                ,c2_assignment_sequence assignment_sequence 
                ,ASSIGNMENT_STATUS_TYPE_ID 
                ,c4_primary_flag
                ,'CURRENT'
                ,c11_assignment_name assignment_name
                ,'P_ACTIVE_ASSIGN' 
                ,'Y' auto_end_flag	
                ,effective_sequence
                ,Case When business_group_id is NOT NULL THEN 
					xxmx_kit_worker_stg.get_legal_employer_name(business_group_id)
					ELSE 
						NULL
					END "legal_employer"
                ,gvv_leg_code
                ,c9_primary_work_terms_flag primary_work_terms_flag
                ,c7_primary_assignment_flag primary_assignment_flag
                ,c10_primary_work_relation_flag primary_work_relation_flag
                ,SYSTEM_PERSON_TYPE system_person_type
                , business_unit_name
                ,NULL action_occurrence_id
                ,'Y' position_override_flag
                --,'N' position_override_flag
                ,'Y' effective_latest_change
                ,'Y' allow_asg_override_flag
                ,to_date ('01-01-1901','DD-MM-YYYY') freeze_start_date
                ,to_date ('31-12-4712','DD-MM-YYYY') freeze_until_date
                ,c20_assignment_id --|| '_EMP_ASSIGNMENT'
				,change_reason
				,c50_job_post_source_name
                ,c42_person_referred_by_id
                ,c58_applicant_rank
                ,c57_posting_content_id
                ,c79_source_type
				--,'ET'|| 
                 ,c20_assignment_id               --,c14_assignment_number
				,'E'
				,payroll_name
                ,c86_people_group_id
                ,default_code_comb_id
				,c_per_all_assignmen.personnumber
        FROM    xxmx_per_persons_stg xxmx_per_persons_stg		
			,
			(
			SELECT  distinct  per_all_assignments_f.assignment_sequence c2_assignment_sequence
                    ,per_all_assignments_f.primary_flag c4_primary_flag
                    ,per_all_assignments_f.primary_flag  c7_primary_assignment_flag
                    ,per_all_assignments_f.effective_start_date c8_effective_start_date
                    ,per_all_assignments_f.primary_flag c9_primary_work_terms_flag
                    ,'Y' c10_primary_work_relation_flag
                    ,per_all_assignments_f.title c11_assignment_name
					, 1 effective_sequence
                    ,per_all_assignments_f.assignment_id c20_assignment_id
                    ,per_person_types.person_type_id c24_person_type_id
                    ,per_all_assignments_f.effective_end_date c12_effective_end_date
                    ,per_assignment_status_types.ASSIGNMENT_STATUS_TYPE_ID
                    ,per_assignment_status_types.pay_system_status c22_pay_system_status
                    ,per_assignment_status_types.per_system_status c21_per_system_status
                    ,per_all_assignments_f.organization_id c17_organization_id
                    ,per_all_assignments_f.person_id c25_s_person_id
					,per_all_Assignments_f.business_Group_id
                    ,per_all_assignments_f.assignment_NUMBER c14_assignment_NUMBER
                    ,per_all_assignments_f.assignment_status_type_id s0_asg_status_type_id
                    ,per_periods_of_service.final_process_date final_process_date
                    ,per_periods_of_service.period_of_service_id s0_period_of_service_id
					,per_all_assignments_f.sal_review_period c2_sal_review_period
                    ,per_all_assignments_f.time_normal_start c3_time_normal_start
                    ,per_all_people_f.internal_location c10_internal_location
                    ,per_all_assignments_f.probation_unit c14_probation_unit
                    ,per_all_assignments_f.projected_assignment_end c15_projected_assignment_end
                    ,per_all_assignments_f.date_probation_end c17_date_probation_end
                    ,per_all_people_f.projected_start_date c18_projected_start_date
                    ,per_all_assignments_f.manager_flag c30_manager_flag
                    ,per_all_assignments_f.work_at_home c37_work_at_home
                    ,per_all_assignments_f.labour_union_member_flag c39_labour_union_member_flag
                    ,per_all_assignments_f.time_normal_finish c40_time_normal_finish
                    ,per_all_assignments_f.person_referred_by_id c42_person_referred_by_id
                    ,per_all_assignments_f.probation_period c48_probation_period
                    ,per_all_assignments_f.job_post_source_name c50_job_post_source_name
                    ,per_all_assignments_f.normal_hours c52_normal_hours
                    ,per_all_assignments_f.project_title c54_project_title
                    ,'Y' c55_primary_work_terms_flag
                    ,NULL c56_default_code_comb_id
                    ,per_all_assignments_f.posting_content_id c57_posting_content_id
                    ,per_all_assignments_f.applicant_rank c58_applicant_rank
                    ,per_all_assignments_f.notice_period c59_notice_period
                    ,per_all_assignments_f.ass_attribute_category c60_ass_attribute_category
                    ,per_all_assignments_f.grade_id c85_grade_id
                    ,per_all_assignments_f.position_id c84_position_id
                    ,per_all_assignments_f.job_id c82_job_id
                    ,per_all_assignments_f.location_id c83_location_id                    
                    ,per_all_assignments_f.people_group_id c86_people_group_id
                    ,per_all_assignments_f.assignment_NUMBER c65_assignment_NUMBER
                    ,per_all_assignments_f.employment_category c76_employment_category
                    ,per_all_assignments_f.frequency c73_frequency
                    ,per_all_assignments_f.sal_review_period_frequency c78_sal_review_period_frequenc
                    ,per_all_assignments_f.source_type c79_source_type
                    ,per_all_assignments_f.bargaining_unit_code c72_bargaining_unit_code
                    ,per_all_assignments_f.hourly_salaried_code c77_hourly_salaried_code
                    ,per_all_assignments_f.contract_id c87_contract_id
                    ,per_all_assignments_f.notice_period_uom c74_notice_period_uom
                    ,per_all_assignments_f.employee_category c75_employee_category
                    ,per_person_types.system_person_type c91_system_person_type
					,per_All_assignments_f.change_reason
					,'CURRENT' action_code
                    ,per_all_people_f.first_name || '.' ||  per_all_people_f.last_name  c110_billing_title
                    ,(SELECT Name 
					  FROM per_grades_tl@MXDM_NVIS_EXTRACT 
					  WHERE grade_id = per_All_assignments_f.grade_id) 
					  GRADE_CODE
					,per_all_assignments_f.GRADE_LADDER_PGM_ID
					,per_all_people_f.EXPENSE_CHECK_SEND_TO_ADDRESS "EXPENSE_CHECK_ADDRESS"
					,(SELECT Name 
					  FROM per_jobs_tl@MXDM_NVIS_EXTRACT 
					  WHERE job_id  =  per_All_assignments_f.job_id)
                    JOB_CODE
					,(SELECT location_code 
					  FROM hr_locations_all@MXDM_NVIS_EXTRACT 
					  WHERE location_id  =  per_All_assignments_f.location_id)
                    LOCATION_CODE
					,per_periods_of_service.Date_start
					,(SELECT name 
					  FROM HR_ALL_POSITIONS_F@MXDM_NVIS_EXTRACT  HAPF
					  WHERE position_id = per_All_assignments_f.position_id
					  AND  TRUNC(SYSDATE) BETWEEN HAPF.effective_Start_date AND HAPF.effective_end_date) 
					 POSITION_CODE
					,PER_ALL_ASSIGNMENTS_F.PROJECTED_ASSIGNMENT_END
					,per_person_types.SYSTEM_PERSON_TYPE
					,per_person_types.USER_PERSON_TYPE
                    ,PER_ALL_ASSIGNMENTS_F.SPECIAL_CEILING_STEP_ID
                    ,(SELECT PSP.spinal_point
					from  PER_SPINAL_POINT_STEPS_F@MXDM_NVIS_EXTRACT	PSPSF
						, per_spinal_points@MXDM_NVIS_EXTRACT PSP
						,per_grade_spines_f@MXDM_NVIS_EXTRACT pgsf 
					where Step_id  = PER_ALL_ASSIGNMENTS_F.SPECIAL_CEILING_STEP_ID
					and PSP.spinal_point_id =PSPSF.spinal_point_id
					and  TRUNC(SYSDATE) BETWEEN pgsf.effective_Start_date AND pgsf.effective_end_date				
					AND psp.parent_spine_id = pgsf.parent_spine_id
					and pgsf.grade_id = PER_ALL_ASSIGNMENTS_F.grade_id
					and Trunc(sysdate) between PSPSF.effective_Start_date and PSPSF.effective_end_date)
					  SPECIAL_CEILING_STEP_NAME
					,PER_ALL_ASSIGNMENTS_F.TIME_NORMAL_FINISH
					,PER_ALL_ASSIGNMENTS_F.TIME_NORMAL_START
					,PER_ALL_ASSIGNMENTS_F.PEOPLE_GROUP_ID
                    ,(SELECT GROUP_NAME
					  FROM PAY_PEOPLE_GROUPS@MXDM_NVIS_EXTRACT PPG
                      WHERE PPG.people_group_id = per_all_assignments_f.people_group_id
                      AND PPG.end_date_active IS NULL)
					  PEOPLE_GROUP_NAME
					,(SELECT NAME 
					  FROM per_collective_agreements@MXDM_NVIS_EXTRACT PCA 
					  WHERE  collective_agreement_id = per_All_Assignments_f.COLLECTIVE_AGREEMENT_ID 
					  AND TRUNC(SYSDATE)BETWEEN PCA.Start_Date AND PCA.end_date)
					  COLLECTIVE_AGREEMENT_NAME
					,(SELECT Name 
					  FROM BEN_PGM_F@MXDM_NVIS_EXTRACT BPF
					  WHERE PGM_ID = per_all_assignments_f.GRADE_LADDER_PGM_ID
					  AND TRUNC(SYSDATE) BETWEEN BPF.effective_start_Date AND BPF.effective_end_date)
					GRADE_LADDER_PGM_NAME	
					,(SELECT NAME 
					  FROM HR_ALL_ORGANIZATION_UNITS@MXDM_NVIS_EXTRACT 
					  WHERE organization_id = per_all_assignments_f.Business_group_id
					  AND TRUNC(SYSDATE ) BETWEEN DATE_FROM AND NVL(DATE_TO, '31-DEC-4712'))
					  business_unit_name
					,(SELECT Reference 
					  FROM per_contracts_f@MXDM_NVIS_EXTRACT 
					  WHERE contract_id = per_all_assignments_f.contract_id
					  AND TRUNC(SYSDATE ) BETWEEN effective_Start_date AND NVL(effective_end_date, '31-DEC-4712'))
					  contract_name
					,(SELECT NAME 
					  FROM HR_ALL_ORGANIZATION_UNITS@MXDM_NVIS_EXTRACT 
					  WHERE organization_id = per_all_assignments_f.organization_id
					  AND TRUNC(SYSDATE ) BETWEEN DATE_FROM AND NVL(DATE_TO, '31-DEC-4712'))
					  Org_name
                    ,(SELECT organization_id 
					  FROM HR_ALL_ORGANIZATION_UNITS@MXDM_NVIS_EXTRACT 
					  WHERE organization_id = per_all_assignments_f.organization_id
					  AND TRUNC(SYSDATE ) BETWEEN DATE_FROM AND NVL(DATE_TO, '31-DEC-4712'))  
                      Org_id
					,(SELECT Payroll_name
					  FROM PAY_PAYROLLS_F@MXDM_NVIS_EXTRACT ppf
					  WHERE PAYROLL_ID = per_all_assignments_f.payroll_id
					  AND trunc(sysdate) BETWEEN ppf.effective_start_date and ppf.effective_end_date)
					  Payroll_name 
                 ,per_all_assignments_f.default_code_comb_id
				 ,per_all_people_f.employee_number personnumber
             FROM    per_person_type_usages_f@MXDM_NVIS_EXTRACT per_person_type_usages_f
                    ,xxmx_hcm_current_asg_scope_mv per_all_assignments_f
                    ,per_assignment_status_types@MXDM_NVIS_EXTRACT per_assignment_status_types
                    ,xxmx_hcm_person_scope_mv per_all_people_f
                    ,per_person_types@MXDM_NVIS_EXTRACT per_person_types
                    ,per_periods_of_service@MXDM_NVIS_EXTRACT per_periods_of_service
                   -- ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
                WHERE  per_all_assignments_f.assignment_type = 'E'
                --AND    per_person_types.system_person_type IN ('EMP','EX_EMP')
                AND     per_all_assignments_f.assignment_status_type_id = per_assignment_status_types.assignment_status_type_id
                AND    per_all_assignments_f.person_id = per_all_people_f.person_id
                AND    per_all_assignments_f.effective_start_date BETWEEN per_all_people_f.effective_start_date
                                                                        AND     per_all_people_f.effective_end_date
                AND    per_all_assignments_f.person_id = per_person_type_usages_f.person_id
                AND    per_all_assignments_f.effective_start_date BETWEEN per_person_type_usages_f.effective_start_date
                                                                        AND     per_person_type_usages_f.effective_end_date
                AND   per_person_types.person_type_id = per_person_type_usages_f.person_type_id
				and   per_periods_of_service.actual_termination_date IS NULL
				AND    per_all_assignments_f.primary_flag = 'Y'
				and   per_all_people_f.person_type_id = per_person_types.person_type_id
                AND   per_periods_of_service.person_id = per_all_assignments_f.person_id
				AND per_periods_of_service.period_of_service_id =NVL(per_all_assignments_f.period_of_service_id,per_periods_of_service.period_of_service_id )
             --   AND   (per_all_assignments_f.period_of_service_id is not null AND per_periods_of_service.period_of_service_id =per_all_assignments_f.period_of_service_id)
                AND   per_all_assignments_f.business_group_id = p_bg_id
                AND EXISTS(   SELECT 1
                              FROM PAY_PAYROLLS_F@MXDM_NVIS_EXTRACT ppf
                              WHERE PPF.PAYROLL_ID = per_all_assignments_f.payroll_id
                              AND trunc(sysdate) BETWEEN ppf.effective_start_date and ppf.effective_end_date
                              AND UPPER(PPF.PAYROLL_NAME) IN (SELECT UPPER(PARAMETER_VALUE )
                                                            FROM xxmx_migration_parameters 
                                                            WHERE parameter_code like 'PAYROLL_NAME'
                                                            AND ENABLED_FLAG='Y' )
                            )
				UNION
				SELECT  distinct per_all_assignments_f.assignment_sequence c2_assignment_sequence
                    ,per_all_assignments_f.primary_flag c4_primary_flag
                    ,per_all_assignments_f.primary_flag  c7_primary_assignment_flag
                    ,CASE
						WHEN (to_char( per_periods_of_service.Date_start,'MMYYYY')=
							to_char( per_periods_of_service.ACTUAL_TERMINATION_DATE,'MMYYYY'))
						THEN  per_periods_of_service.Date_start
						ELSE 
							trunc((PER_PERIODS_OF_SERVICE.ACTUAL_TERMINATION_DATE),'month') 
						END c8_effective_start_date
                    ,per_all_assignments_f.primary_flag c9_primary_work_terms_flag
                    ,'Y' c10_primary_work_relation_flag
                    ,per_all_assignments_f.title c11_assignment_name
                    ,CASE
						WHEN (to_char( per_periods_of_service.Date_start,'MMYYYY')=
							to_char( per_periods_of_service.ACTUAL_TERMINATION_DATE,'MMYYYY'))
						THEN  2
						ELSE 
								1
						END effective_sequence					
                    ,per_all_assignments_f.assignment_id c20_assignment_id
                    ,per_person_types.person_type_id c24_person_type_id
                    ,per_all_assignments_f.effective_end_date c12_effective_end_date
                    ,per_assignment_status_types.ASSIGNMENT_STATUS_TYPE_ID
                    ,per_assignment_status_types.pay_system_status c22_pay_system_status
                    ,per_assignment_status_types.per_system_status c21_per_system_status
                    ,per_all_assignments_f.organization_id c17_organization_id
                    ,per_all_assignments_f.person_id c25_s_person_id
					,per_all_Assignments_f.business_Group_id
                    ,per_all_assignments_f.assignment_NUMBER c14_assignment_NUMBER
                    ,per_all_assignments_f.assignment_status_type_id s0_asg_status_type_id
                    ,per_periods_of_service.final_process_date final_process_date
                    ,per_periods_of_service.period_of_service_id s0_period_of_service_id
					,per_all_assignments_f.sal_review_period c2_sal_review_period
                    ,per_all_assignments_f.time_normal_start c3_time_normal_start
                    ,per_all_people_f.internal_location c10_internal_location
                    ,per_all_assignments_f.probation_unit c14_probation_unit
                    ,per_all_assignments_f.projected_assignment_end c15_projected_assignment_end
                    ,per_all_assignments_f.date_probation_end c17_date_probation_end
                    ,per_all_people_f.projected_start_date c18_projected_start_date
                    ,per_all_assignments_f.manager_flag c30_manager_flag
                    ,per_all_assignments_f.work_at_home c37_work_at_home
                    ,per_all_assignments_f.labour_union_member_flag c39_labour_union_member_flag
                    ,per_all_assignments_f.time_normal_finish c40_time_normal_finish
                    ,per_all_assignments_f.person_referred_by_id c42_person_referred_by_id
                    ,per_all_assignments_f.probation_period c48_probation_period
                    ,per_all_assignments_f.job_post_source_name c50_job_post_source_name
                    ,per_all_assignments_f.normal_hours c52_normal_hours
                    ,per_all_assignments_f.project_title c54_project_title
                    ,'Y' c55_primary_work_terms_flag
                    ,NULL c56_default_code_comb_id
                    ,per_all_assignments_f.posting_content_id c57_posting_content_id
                    ,per_all_assignments_f.applicant_rank c58_applicant_rank
                    ,per_all_assignments_f.notice_period c59_notice_period
                    ,per_all_assignments_f.ass_attribute_category c60_ass_attribute_category
                    ,per_all_assignments_f.grade_id c85_grade_id
                    ,per_all_assignments_f.position_id c84_position_id
                    ,per_all_assignments_f.job_id c82_job_id
                    ,per_all_assignments_f.location_id c83_location_id                    
                    ,per_all_assignments_f.people_group_id c86_people_group_id
                    ,per_all_assignments_f.assignment_NUMBER c65_assignment_NUMBER
                    ,per_all_assignments_f.employment_category c76_employment_category
                    ,per_all_assignments_f.frequency c73_frequency
                    ,per_all_assignments_f.sal_review_period_frequency c78_sal_review_period_frequenc
                    ,per_all_assignments_f.source_type c79_source_type
                    ,per_all_assignments_f.bargaining_unit_code c72_bargaining_unit_code
                    ,per_all_assignments_f.hourly_salaried_code c77_hourly_salaried_code
                    ,per_all_assignments_f.contract_id c87_contract_id
                    ,per_all_assignments_f.notice_period_uom c74_notice_period_uom
                    ,per_all_assignments_f.employee_category c75_employee_category
                    ,per_person_types.system_person_type c91_system_person_type
					,per_All_assignments_f.change_reason
					,'CURRENT' action_code
                    ,per_all_people_f.first_name || '.' ||  per_all_people_f.last_name  c110_billing_title
                    ,(SELECT Name 
					  FROM per_grades_tl@MXDM_NVIS_EXTRACT 
					  WHERE grade_id = per_All_assignments_f.grade_id) 
					  GRADE_CODE
					,per_all_assignments_f.GRADE_LADDER_PGM_ID
					,per_all_people_f.EXPENSE_CHECK_SEND_TO_ADDRESS "EXPENSE_CHECK_ADDRESS"
					,(SELECT Name 
					  FROM per_jobs_tl@MXDM_NVIS_EXTRACT 
					  WHERE job_id  =  per_All_assignments_f.job_id)
                    JOB_CODE
					,(SELECT location_code 
					  FROM hr_locations_all@MXDM_NVIS_EXTRACT 
					  WHERE location_id  =  per_All_assignments_f.location_id)
                    LOCATION_CODE
					,per_periods_of_service.Date_start
					,(SELECT name 
					  FROM HR_ALL_POSITIONS_F@MXDM_NVIS_EXTRACT  HAPF
					  WHERE position_id = per_All_assignments_f.position_id
					  AND  TRUNC(SYSDATE) BETWEEN HAPF.effective_Start_date AND HAPF.effective_end_date) 
					 POSITION_CODE
					,PER_ALL_ASSIGNMENTS_F.PROJECTED_ASSIGNMENT_END
					,per_person_types.SYSTEM_PERSON_TYPE
					,per_person_types.USER_PERSON_TYPE
                    ,PER_ALL_ASSIGNMENTS_F.SPECIAL_CEILING_STEP_ID
                    ,(SELECT PSP.spinal_point
					from  PER_SPINAL_POINT_STEPS_F@MXDM_NVIS_EXTRACT	PSPSF
						, per_spinal_points@MXDM_NVIS_EXTRACT PSP
						,per_grade_spines_f@MXDM_NVIS_EXTRACT pgsf 
					where Step_id  = PER_ALL_ASSIGNMENTS_F.SPECIAL_CEILING_STEP_ID
					and PSP.spinal_point_id =PSPSF.spinal_point_id
					and  TRUNC(SYSDATE) BETWEEN pgsf.effective_Start_date AND pgsf.effective_end_date				
					AND psp.parent_spine_id = pgsf.parent_spine_id
					and pgsf.grade_id = PER_ALL_ASSIGNMENTS_F.grade_id
					and Trunc(sysdate) between PSPSF.effective_Start_date and PSPSF.effective_end_date)
					  SPECIAL_CEILING_STEP_NAME
					,PER_ALL_ASSIGNMENTS_F.TIME_NORMAL_FINISH
					,PER_ALL_ASSIGNMENTS_F.TIME_NORMAL_START
					,PER_ALL_ASSIGNMENTS_F.PEOPLE_GROUP_ID
                    ,(SELECT GROUP_NAME
					  FROM PAY_PEOPLE_GROUPS@MXDM_NVIS_EXTRACT PPG
                      WHERE PPG.people_group_id = per_all_assignments_f.people_group_id
                      AND PPG.end_date_active IS NULL)
					  PEOPLE_GROUP_NAME
					,(SELECT NAME 
					  FROM per_collective_agreements@MXDM_NVIS_EXTRACT PCA 
					  WHERE  collective_agreement_id = per_All_Assignments_f.COLLECTIVE_AGREEMENT_ID 
					  AND TRUNC(SYSDATE)BETWEEN PCA.Start_Date AND PCA.end_date)
					  COLLECTIVE_AGREEMENT_NAME
					,(SELECT Name 
					  FROM BEN_PGM_F@MXDM_NVIS_EXTRACT BPF
					  WHERE PGM_ID = per_all_assignments_f.GRADE_LADDER_PGM_ID
					  AND TRUNC(SYSDATE) BETWEEN BPF.effective_start_Date AND BPF.effective_end_date)
					GRADE_LADDER_PGM_NAME	
					,(SELECT NAME 
					  FROM HR_ALL_ORGANIZATION_UNITS@MXDM_NVIS_EXTRACT 
					  WHERE organization_id = per_all_assignments_f.Business_group_id
					  AND TRUNC(SYSDATE ) BETWEEN DATE_FROM AND NVL(DATE_TO, '31-DEC-4712'))
					  business_unit_name
					,(SELECT Reference 
					  FROM per_contracts_f@MXDM_NVIS_EXTRACT 
					  WHERE contract_id = per_all_assignments_f.contract_id
					  AND TRUNC(SYSDATE ) BETWEEN effective_Start_date AND NVL(effective_end_date, '31-DEC-4712'))
					  contract_name
					,(SELECT NAME 
					  FROM HR_ALL_ORGANIZATION_UNITS@MXDM_NVIS_EXTRACT 
					  WHERE organization_id = per_all_assignments_f.organization_id
					  AND TRUNC(SYSDATE ) BETWEEN DATE_FROM AND NVL(DATE_TO, '31-DEC-4712'))
					  Org_name
                    ,(SELECT organization_id 
					  FROM HR_ALL_ORGANIZATION_UNITS@MXDM_NVIS_EXTRACT 
					  WHERE organization_id = per_all_assignments_f.organization_id
					  AND TRUNC(SYSDATE ) BETWEEN DATE_FROM AND NVL(DATE_TO, '31-DEC-4712'))  
                      Org_id  
					,(SELECT Payroll_name
					  FROM PAY_PAYROLLS_F@MXDM_NVIS_EXTRACT ppf
					  WHERE PAYROLL_ID = per_all_assignments_f.payroll_id
					  AND trunc(sysdate) BETWEEN ppf.effective_start_date and ppf.effective_end_date)
					  Payroll_name 
                 ,per_all_assignments_f.default_code_comb_id
				 ,per_all_people_f.employee_number personnumber
                FROM    per_person_type_usages_f@MXDM_NVIS_EXTRACT per_person_type_usages_f
                    ,xxmx_hcm_current_asg_scope_mv per_all_assignments_f
                    ,per_assignment_status_types@MXDM_NVIS_EXTRACT per_assignment_status_types
                    ,xxmx_hcm_person_scope_mv per_all_people_f
                    ,per_person_types@MXDM_NVIS_EXTRACT per_person_types
                    ,per_periods_of_service@MXDM_NVIS_EXTRACT per_periods_of_service
                   -- ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
                WHERE  per_all_assignments_f.assignment_type = 'E'
                --AND    per_person_types.system_person_type IN ('EMP','EX_EMP')
                AND     per_all_assignments_f.assignment_status_type_id = per_assignment_status_types.assignment_status_type_id
                AND    per_all_assignments_f.person_id = per_all_people_f.person_id
                AND    per_all_assignments_f.effective_start_date BETWEEN per_all_people_f.effective_start_date
                                                                        AND     per_all_people_f.effective_end_date
                AND    per_all_assignments_f.person_id = per_person_type_usages_f.person_id
                AND    per_all_assignments_f.effective_start_date BETWEEN per_person_type_usages_f.effective_start_date
                                                                        AND     per_person_type_usages_f.effective_end_date
                AND   per_person_types.person_type_id = per_person_type_usages_f.person_type_id
				and   per_periods_of_service.actual_termination_date IS  NOT NULL
				AND   per_periods_of_service.actual_termination_date  BETWEEN  TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
				AND    per_all_assignments_f.primary_flag = 'Y'
				and   per_all_people_f.person_type_id = per_person_types.person_type_id
                AND   per_periods_of_service.person_id = per_all_assignments_f.person_id
				AND per_periods_of_service.period_of_service_id =NVL(per_all_assignments_f.period_of_service_id,per_periods_of_service.period_of_service_id )
             --   AND   (per_all_assignments_f.period_of_service_id is not null AND per_periods_of_service.period_of_service_id =per_all_assignments_f.period_of_service_id)
                AND   per_all_assignments_f.business_group_id = p_bg_id
                AND EXISTS(   SELECT 1
                              FROM PAY_PAYROLLS_F@MXDM_NVIS_EXTRACT ppf
                              WHERE PPF.PAYROLL_ID = per_all_assignments_f.payroll_id
                              AND trunc(sysdate) BETWEEN ppf.effective_start_date and ppf.effective_end_date
                              AND UPPER(PPF.PAYROLL_NAME) IN (SELECT UPPER(PARAMETER_VALUE )
                                                            FROM xxmx_migration_parameters 
                                                            WHERE parameter_code like 'PAYROLL_NAME'
                                                            AND ENABLED_FLAG='Y' )
                            )
				) c_per_all_assignmen	
        where  
		 xxmx_per_persons_stg.person_id = c25_s_person_id

		;


      /*  SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,c8_effective_start_date effective_start_date
                ,(CASE
                    WHEN    (
                                    c12_effective_end_date = final_process_date
                            AND     c21_per_system_status = 'TERM_ASSIGN'
                            )
                            THEN    to_date ('31-12-4712'
                                            ,'DD-MM-YYYY')
                    ELSE    c12_effective_end_date END) effective_end_date
                ,c25_s_person_id
                    || '_PERSON' person_id
                ,s0_period_of_service_id
                    || '_PERIOD_OF_SERVICE' period_of_service_id
                ,'ET' assignment_type
                ,'EMP_TERM_'
                    || c14_assignment_NUMBER assignment_NUMBER
                ,c2_assignment_sequence assignment_sequence
                ,(CASE
                    WHEN    (
                                    c21_per_system_status = 'TERM_ASSIGN'
                            AND     c22_pay_system_status = 'P'
                            )
                            THEN    v_astat_inactive_p
                    WHEN    (
                                    c21_per_system_status = 'TERM_ASSIGN'
                            AND     c22_pay_system_status = 'D'
                            )
                            THEN    v_astat_inactive_np
                    WHEN    (
                                    c21_per_system_status = 'SUSP_ASSIGN'
                            AND     c22_pay_system_status = 'P'
                            )
                            THEN    v_astat_suspend_p
                    WHEN    (
                                    c21_per_system_status = 'SUSP_ASSIGN'
                            AND     c22_pay_system_status = 'D'
                            )
                            THEN    v_astat_suspend_np
                    WHEN    (
                                    c21_per_system_status = 'ACTIVE_ASSIGN'
                            AND     c22_pay_system_status = 'P'
                            )
                            THEN    v_astat_active_p
                    WHEN    (
                                    c21_per_system_status = 'ACTIVE_ASSIGN'
                            AND     c22_pay_system_status = 'D'
                            )
                            THEN    gvv_astat_active_np
                    ELSE    'N/A' END) assignment_status_type_id
                ,'N' c4_primary_flag
                ,'ASG_CHANGE' action_code
                ,c11_assignment_name assignment_name
                ,(CASE
                    WHEN    (
                                    c21_per_system_status = 'TERM_ASSIGN'
                            AND     c22_pay_system_status = 'P'
                            )
                            THEN    'INACTIVE'
                    WHEN    (
                                    c21_per_system_status = 'TERM_ASSIGN'
                            AND     c22_pay_system_status = 'D'
                            )
                            THEN    'INACTIVE'
                    WHEN    (
                                    c21_per_system_status = 'SUSP_ASSIGN'
                            AND     c22_pay_system_status = 'P'
                            )
                            THEN    'SUSPEND'
                    WHEN    (
                                    c21_per_system_status = 'SUSP_ASSIGN'
                            AND     c22_pay_system_status = 'D'
                            )
                            THEN    'SUSPEND'
                    WHEN    (
                                    c21_per_system_status = 'ACTIVE_ASSIGN'
                            AND     c22_pay_system_status = 'P'
                            )
                            THEN    'ACTIVE'
                    WHEN    (
                                    c21_per_system_status = 'ACTIVE_ASSIGN'
                            AND     c22_pay_system_status = 'D'
                            )
                            THEN    'ACTIVE'
                    ELSE    'N/A' END) assignment_status_type
                ,'Y' auto_end_flag
                ,1 effective_sequence
                ,Case When c17_organization_id is NOT NULL THEN 
					xxmx_kit_worker_stg.get_legal_employer_name(SUBSTR(c17_organization_id,1,INSTR(c17_organization_id,'_',1)-1))
					ELSE 
						NULL
					END "legal_employer"
                ,gvv_leg_code
                ,c9_primary_work_terms_flag primary_work_terms_flag
                ,c7_primary_assignment_flag primary_assignment_flag
                ,c10_primary_work_relation_flag primary_work_relation_flag
                ,'EMP' system_person_type
                    ,v_business_name business_unit_name
                ,NULL action_occurrence_id
                ,'Y' position_override_flag
                ,'Y' effective_latest_change
                ,'Y' allow_asg_override_flag
                ,to_date ('01-01-1901'
                            ,'dd-mm-yyyy') freeze_start_date
                ,to_date ('31-12-4712'
                            ,'dd-mm-yyyy') freeze_until_date
                ,c20_assignment_id
                    || '_EMP_TERM'
        FROM    xxmx_per_persons_stg xxmx_per_persons_stg
                ,(
                SELECT  per_all_assignments_f.assignment_sequence c2_assignment_sequence
                    ,per_all_assignments_f.primary_flag c4_primary_flag
                    ,'Y' c7_primary_assignment_flag
                    ,per_all_assignments_f.effective_start_date c8_effective_start_date
                    ,per_all_assignments_f.primary_flag c9_primary_work_terms_flag
                    ,'Y' c10_primary_work_relation_flag
                    ,per_all_assignments_f.title c11_assignment_name
                    ,per_all_assignments_f.assignment_id c20_assignment_id
                    ,per_person_types.person_type_id c24_person_type_id
                    ,per_all_assignments_f.effective_end_date c12_effective_end_date
                    ,per_assignment_status_types.pay_system_status c22_pay_system_status
                    ,per_assignment_status_types.per_system_status c21_per_system_status
                    ,per_all_assignments_f.organization_id c17_organization_id
                    ,per_all_assignments_f.person_id c25_s_person_id
                    ,per_all_assignments_f.assignment_NUMBER c14_assignment_NUMBER
                    ,per_all_assignments_f.assignment_status_type_id s0_asg_status_type_id
                    ,per_periods_of_service.final_process_date final_process_date
                    ,per_periods_of_service.period_of_service_id s0_period_of_service_id
                FROM    per_person_type_usages_f@MXDM_NVIS_EXTRACT per_person_type_usages_f
                    ,per_all_assignments_f@MXDM_NVIS_EXTRACT per_all_assignments_f
                    ,per_assignment_status_types@MXDM_NVIS_EXTRACT per_assignment_status_types
                    ,per_all_people_f@MXDM_NVIS_EXTRACT per_all_people_f
                    ,per_person_types@MXDM_NVIS_EXTRACT per_person_types
                    ,per_periods_of_service@MXDM_NVIS_EXTRACT per_periods_of_service
                    ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
                WHERE  per_person_types.system_person_type IN ('EMP','EX_EMP')
                AND  per_all_assignments_f.assignment_type = 'E'
                AND  per_all_assignments_f.person_id = per_all_people_f.person_id
                AND  per_all_assignments_f.effective_start_date BETWEEN per_all_people_f.effective_start_date
                                                                        AND     per_all_people_f.effective_end_date
                AND  per_all_assignments_f.person_id = per_person_type_usages_f.person_id
                AND  per_all_assignments_f.effective_start_date BETWEEN per_person_type_usages_f.effective_start_date
                                                                        AND     per_person_type_usages_f.effective_end_date
                AND  per_person_types.person_type_id = per_person_type_usages_f.person_type_id
                AND  per_all_assignments_f.assignment_status_type_id = per_assignment_status_types.assignment_status_type_id
                AND  per_periods_of_service.period_of_service_id = per_all_assignments_f.period_of_service_id
                AND  horg.organization_id = per_periods_of_service.business_group_id
				AND  horg.name = p_bg_name
                ) c_per_all_assignmen
        where      (
                            xxmx_per_persons_stg.person_id = c25_s_person_id

                    )
        and         exists (
        select 1 from xxmx_per_pos_wr_stg inn
        where  inn.period_of_service_id = s0_period_of_service_id
                    || '_PERIOD_OF_SERVICE'
        and    c8_effective_start_date  between inn.date_start and nvl(actual_termination_date,to_date('31-12-4712','DD-MM-YYYY'))
        and    inn.period_type = 'E'
        and    inn.person_id = c25_s_person_id
                                                            || '_PERSON'
        );*/
        --
        -- 
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed' 
                        ,pt_i_OracleError         => gvt_ReturnMessage       );   

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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;
    END export_all_assignments_m_2;

    PROCEDURE export_all_assignments_m_3
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'EXPORT_ALL_ASSIGNMENTS_M_3'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_ASSIGNMENTS_M_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'ALL_ASSIGNMENTS_M_3';

		lvv_migration_date_from                         VARCHAR2(30); 
        lvv_prev_tax_year_date                          VARCHAR2(30);         
        lvd_migration_date_from                         DATE;
        lvd_prev_tax_year_date                          DATE;   
		lvv_migration_date_to                          VARCHAR2(30); 
        lvd_migration_date_to                          DATE; 	


    BEGIN
        --
        --       
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
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0005';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'DATA'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        IF   gvv_ReturnStatus = 'F'
        THEN
            xxmx_utilities_pkg.log_module_message
                (pt_i_ApplicationSuite    => gct_ApplicationSuite
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
        END IF;
        --

        -- 
		--
		--
        --
       set_parameters(p_bg_id);
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
                        ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable   || '".'   
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
	  --
         INSERT  
        INTO    xxmx_per_assignments_m_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
				,bargaining_unit_code
				,date_probation_end
				,EMPLOYEE_CATEGORY
				,employment_category
				,establishment_id
				,expense_check_address
				,grade_code
				,position_code
				,grade_ladder_pgm_name
				,hourly_salaried_code
				,SAL_REVIEW_PERIOD 
				,SAL_REVIEW_PERIOD_FREQUENCY
				,internal_building
				,internal_floor 
				,internal_location
				,internal_mailstop
				,internal_office_number
				,job_code
				,labour_union_member_flag
				,location_code
				,job_id
				,location_id
				,position_id
				,ORGANIZATION_ID
				,contract_id
				,grade_id 
				,manager_flag
				,normal_hours
				,frequency
				,notice_period
				,notice_period_uom
				,USER_PERSON_TYPE
				,PROBATION_PERIOD
				,PROBATION_UNIT
				,project_title
				,projected_assignment_end
				,SPEC_CEILING_STEP
				,WORK_AT_HOME_FLAG
				,TIME_NORMAL_FINISH
				,TIME_NORMAL_START
                ,effective_start_date
                ,effective_end_date
                ,person_id
                ,period_of_service_id
                ,assignment_type
                ,assignment_NUMBER
                ,assignment_sequence
                ,assignment_status_type_id
                ,primary_flag
                ,action_code
                ,assignment_name
                ,assignment_status_type
                ,auto_end_flag
                ,effective_sequence
                ,legal_employer_name
                ,legislation_code
                ,primary_work_terms_flag
                ,primary_assignment_flag
                ,primary_work_relation_flag
                ,system_person_type
                ,business_unit_name
                ,action_occurrence_id
                ,position_override_flag
                ,effective_latest_change
                ,allow_asg_override_flag
                ,freeze_start_date
                ,freeze_until_date
                ,assignment_id
				,Reason_code
				,job_post_source_name
                ,person_referred_by_id
                ,applicant_rank
                ,posting_content_id
                ,source_type
				,work_terms_assignment_id
				,proposed_worker_type 
				,PAYROLLNAME
                ,people_group_id
                ,default_code_comb_id
				, personnumber
               )
		SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,get_target_lookup_code (c72_bargaining_unit_code,'BARGAINING_UNIT_CODE') bargaining_unit_code
				,c17_date_probation_end date_probation_end
				,get_target_lookup_code (c75_employee_category,'EMPLOYEE_CATEGORY') employee_category
				,get_target_lookup_code (c76_employment_category,'EMP_CAT') employment_category
				,Org_name
				,EXPENSE_CHECK_ADDRESS
				,Grade_Code
				,position_code
				,GRADE_LADDER_PGM_NAME
				,get_target_lookup_code (c77_hourly_salaried_code,'HOURLY_SALARIED_CODE') hourly_salaried_code
				,c2_sal_review_period sal_review_period
                ,get_target_lookup_code (c78_sal_review_period_frequenc,'FREQUENCY') sal_review_period_frequency
				,c10_internal_location
				,c10_internal_location
				,c10_internal_location
				,c10_internal_location
				,c10_internal_location
				,job_code
				,nvl (c39_labour_union_member_flag,'N') labour_union_member_flag
				,location_code
				,to_char(c82_job_id)
				,to_char(c83_location_id)
				,to_char(c84_position_id)
				,Org_id
				,Contract_name
				,to_char(c85_grade_id)
				,c30_manager_flag
				,c52_normal_hours normal_hours
				,get_target_lookup_code (c73_frequency,'FREQUENCY') frequency	
				,c59_notice_period 
				,get_target_lookup_code (c74_notice_period_uom,'QUALIFYING_UNITS') notice_period_uom
				,USER_PERSON_TYPE
				,c48_probation_period probation_period
				,c14_probation_unit probation_unit
				,c54_project_title
				,c15_projected_assignment_end projected_assignment_end
				,SPECIAL_CEILING_STEP_NAME
				,c37_work_at_home work_at_home
                ,c40_time_normal_finish 
                ,c3_time_normal_start 
				--,c56_default_code_comb_id default_code_comb_id
                ,actual_termination_date  --c53_effective_start_date effective_start_date
                ,to_date ('31-12-4712','DD-MM-YYYY') effective_end_date
                ,c80_s_person_id person_id
                ,s0_period_of_service_id --|| '_PERIOD_OF_SERVICE' 
                    period_of_service_id
                ,'E' assignment_type
                ,'E'||c65_assignment_number assignment_number
                ,c16_assignment_sequence assignment_sequence
                ,NULL assignment_status_type_id
                ,c43_primary_flag
                ,'TERMINATION' 
                ,c62_assignment_name assignment_name
                --,c71_pay_system_status||'_'||c70_per_system_status assignment_status_type
                ,ASSIGNMENT_STATUS_TYPE_ID assignment_status_type
                ,'Y' auto_end_flag	
                ,1 effective_sequence
                ,Case When business_group_id is NOT NULL THEN 
					xxmx_kit_worker_stg.get_legal_employer_name(business_group_id)
					ELSE 
						NULL
					END "legal_employer"
                ,gvv_leg_code			  
                ,c55_primary_work_terms_flag primary_work_terms_flag
                ,c51_primary_assignment_flag primary_assignment_flag
                ,c61_primary_work_relation_flag primary_work_relation_flag
                ,SYSTEM_PERSON_TYPE system_person_type
                ,business_unit_name
                ,NULL action_occurrence_id
                ,'Y' position_override_flag
                --,'N' position_override_flag
                ,'Y' effective_latest_change
                ,'Y' allow_asg_override_flag
                ,to_date ('01-01-1901','DD-MM-YYYY') freeze_start_date
                ,to_date ('31-12-4712','DD-MM-YYYY') freeze_until_date
                ,c90_assignment_id --|| '_EMP_ASSIGNMENT'
				,leaving_reason
				,c50_job_post_source_name job_post_source_name
                ,c42_person_referred_by_id person_referred_by_id
                ,c58_applicant_rank applicant_rank
                ,c57_posting_content_id posting_content_id
                ,get_target_lookup_code (c79_source_type,'REC_TYPE') source_type
				--,'ET'||c65_assignment_number work_terms_assignment_id
                ,c90_assignment_id work_terms_assignment_id
				,'E'
				,Payroll_name
                ,c86_people_group_id
                ,default_code_comb_id
				,c_per_all_assignment.personnumber
        FROM    xxmx_per_persons_stg xxmx_per_persons_stg
        ,(
                SELECT   per_all_assignments_f.sal_review_period c2_sal_review_period
                    ,per_all_assignments_f.time_normal_start c3_time_normal_start
                    ,per_all_people_f.internal_location c10_internal_location
                    ,per_all_assignments_f.probation_unit c14_probation_unit
                    ,per_all_assignments_f.projected_assignment_end c15_projected_assignment_end
                    ,per_all_assignments_f.assignment_sequence c16_assignment_sequence
                    ,per_all_assignments_f.date_probation_end c17_date_probation_end
                    ,per_all_people_f.projected_start_date c18_projected_start_date
                    ,per_all_assignments_f.manager_flag c30_manager_flag
                    ,per_all_assignments_f.work_at_home c37_work_at_home
                    ,per_all_assignments_f.labour_union_member_flag c39_labour_union_member_flag
                    ,per_all_assignments_f.time_normal_finish c40_time_normal_finish
                    ,per_all_assignments_f.person_referred_by_id c42_person_referred_by_id
                    ,per_all_assignments_f.primary_flag c43_primary_flag
                    ,per_all_assignments_f.probation_period c48_probation_period
                    ,per_all_assignments_f.job_post_source_name c50_job_post_source_name
                    ,per_all_assignments_f.primary_flag c51_primary_assignment_flag
                    ,per_all_assignments_f.normal_hours c52_normal_hours
                    ,per_all_assignments_f.effective_start_date c53_effective_start_date
                    ,per_all_assignments_f.project_title c54_project_title
                    ,'Y' c55_primary_work_terms_flag
                    ,NULL c56_default_code_comb_id
                    ,per_all_assignments_f.posting_content_id c57_posting_content_id
                    ,per_all_assignments_f.applicant_rank c58_applicant_rank
                    ,per_all_assignments_f.notice_period c59_notice_period
                    ,per_all_assignments_f.ass_attribute_category c60_ass_attribute_category
                    ,'Y' c61_primary_work_relation_flag
                    ,per_all_assignments_f.title c62_assignment_name
                    ,per_person_types.person_type_id c89_person_type_id
                    ,per_all_assignments_f.assignment_id c90_assignment_id
                    ,per_all_assignments_f.effective_end_date c63_effective_end_date
                    ,per_all_assignments_f.grade_id c85_grade_id
                    ,per_all_assignments_f.position_id c84_position_id
                     ,per_assignment_status_types.ASSIGNMENT_STATUS_TYPE_ID 
                    ,per_assignment_status_types.pay_system_status c71_pay_system_status
                    ,per_all_assignments_f.job_id c82_job_id
                    ,per_assignment_status_types.per_system_status c70_per_system_status
                    ,per_all_assignments_f.location_id c83_location_id
                    ,per_all_assignments_f.organization_id c67_organization_id
                    ,per_all_assignments_f.people_group_id c86_people_group_id
                    ,per_all_assignments_f.person_id c80_s_person_id
                    ,per_all_assignments_f.assignment_NUMBER c65_assignment_NUMBER
                    ,per_all_assignments_f.employment_category c76_employment_category
                    ,per_all_assignments_f.frequency c73_frequency
                    ,per_all_assignments_f.sal_review_period_frequency c78_sal_review_period_frequenc
                    ,per_all_assignments_f.source_type c79_source_type
                    ,per_all_assignments_f.bargaining_unit_code c72_bargaining_unit_code
                    ,per_all_assignments_f.hourly_salaried_code c77_hourly_salaried_code
					,per_all_assignments_f.Business_group_id
                    ,per_all_assignments_f.contract_id c87_contract_id
                    ,per_all_assignments_f.notice_period_uom c74_notice_period_uom
                    ,per_all_assignments_f.employee_category c75_employee_category
                    ,per_person_types.system_person_type c91_system_person_type
                    ,per_all_people_f.first_name || '.' ||  per_all_people_f.last_name  c110_billing_title
                    ,per_all_assignments_f.assignment_status_type_id s0_asg_status_type_id
                    ,per_periods_of_service.final_process_date final_process_date
					,per_periods_of_service.leaving_reason leaving_reason
					,per_periods_of_service.actual_termination_date actual_termination_date
                    ,per_periods_of_service.period_of_service_id s0_period_of_service_id
                    ,(SELECT Name 
					  FROM per_grades_tl@MXDM_NVIS_EXTRACT 
					  WHERE grade_id = per_All_assignments_f.grade_id) 
					  GRADE_CODE
					,per_all_assignments_f.GRADE_LADDER_PGM_ID
					,per_all_people_f.EXPENSE_CHECK_SEND_TO_ADDRESS "EXPENSE_CHECK_ADDRESS"
					,(SELECT Name 
					  FROM per_jobs_tl@MXDM_NVIS_EXTRACT 
					  WHERE job_id  =  per_All_assignments_f.job_id)
                    JOB_CODE
					,(SELECT location_code 
					  FROM hr_locations_all@MXDM_NVIS_EXTRACT 
					  WHERE location_id  =  per_All_assignments_f.location_id)
                    LOCATION_CODE
					,per_periods_of_service.Date_start
					,(SELECT name
					  FROM HR_ALL_POSITIONS_F@MXDM_NVIS_EXTRACT  HAPF
					  WHERE position_id = per_All_assignments_f.position_id
					  AND  TRUNC(SYSDATE) BETWEEN HAPF.effective_Start_date AND HAPF.effective_end_date) 
					 POSITION_CODE
					,PER_ALL_ASSIGNMENTS_F.PROJECTED_ASSIGNMENT_END
					,per_person_types.SYSTEM_PERSON_TYPE
					,per_person_types.USER_PERSON_TYPE
                    ,PER_ALL_ASSIGNMENTS_F.SPECIAL_CEILING_STEP_ID
                    ,(SELECT psp.spinal_point
					from  PER_SPINAL_POINT_STEPS_F@MXDM_NVIS_EXTRACT	PSPSF
						, per_spinal_points@MXDM_NVIS_EXTRACT PSP
						,per_grade_spines_f@MXDM_NVIS_EXTRACT pgsf 
					where Step_id  = PER_ALL_ASSIGNMENTS_F.SPECIAL_CEILING_STEP_ID
					and PSP.spinal_point_id =PSPSF.spinal_point_id
					and  TRUNC(SYSDATE) BETWEEN pgsf.effective_Start_date AND pgsf.effective_end_date				
					AND psp.parent_spine_id = pgsf.parent_spine_id
					and pgsf.grade_id = PER_ALL_ASSIGNMENTS_F.grade_id
					and Trunc(sysdate) between PSPSF.effective_Start_date and PSPSF.effective_end_date)
					SPECIAL_CEILING_STEP_NAME
					,PER_ALL_ASSIGNMENTS_F.TIME_NORMAL_FINISH
					,PER_ALL_ASSIGNMENTS_F.TIME_NORMAL_START
					,PER_ALL_ASSIGNMENTS_F.PEOPLE_GROUP_ID
					,PER_ALL_ASSIGNMENTS_F.change_reason
                    ,(SELECT GROUP_NAME
					  FROM PAY_PEOPLE_GROUPS@MXDM_NVIS_EXTRACT PPG
                      WHERE PPG.people_group_id = per_all_assignments_f.people_group_id
                      AND PPG.end_date_active IS NULL)
					  PEOPLE_GROUP_NAME
					,(SELECT NAME 
					  FROM per_collective_agreements@MXDM_NVIS_EXTRACT PCA 
					  WHERE  collective_agreement_id = per_All_Assignments_f.COLLECTIVE_AGREEMENT_ID 
					  AND TRUNC(SYSDATE)BETWEEN PCA.Start_Date AND PCA.end_date)
					  COLLECTIVE_AGREEMENT_NAME
					,(SELECT Name 
					  FROM BEN_PGM_F@MXDM_NVIS_EXTRACT BPF
					  WHERE PGM_ID = per_all_assignments_f.GRADE_LADDER_PGM_ID
					  AND TRUNC(SYSDATE) BETWEEN BPF.effective_start_Date AND BPF.effective_end_date)
					GRADE_LADDER_PGM_NAME
					,(SELECT NAME 
					  FROM HR_ALL_ORGANIZATION_UNITS@MXDM_NVIS_EXTRACT 
					  WHERE organization_id = per_all_assignments_f.Business_group_id
					  AND TRUNC(SYSDATE ) BETWEEN DATE_FROM AND NVL(DATE_TO, '31-DEC-4712'))
					  business_unit_name
					,(SELECT Reference 
					  FROM per_contracts_f@MXDM_NVIS_EXTRACT 
					  WHERE contract_id = per_all_assignments_f.contract_id
					  AND TRUNC(SYSDATE ) BETWEEN EFFECTIVE_START_DATE AND NVL(EFFECTIVE_END_DATE, '31-DEC-4712'))
					  contract_name
					,(SELECT NAME 
					  FROM HR_ALL_ORGANIZATION_UNITS@MXDM_NVIS_EXTRACT 
					  WHERE organization_id = per_all_assignments_f.organization_id
					  AND TRUNC(SYSDATE ) BETWEEN DATE_FROM AND NVL(DATE_TO, '31-DEC-4712'))
					  Org_name
                     ,(SELECT organization_id 
					  FROM HR_ALL_ORGANIZATION_UNITS@MXDM_NVIS_EXTRACT 
					  WHERE organization_id = per_all_assignments_f.organization_id
					  AND TRUNC(SYSDATE ) BETWEEN DATE_FROM AND NVL(DATE_TO, '31-DEC-4712'))
					  Org_id 
					,(SELECT Payroll_name
					  FROM PAY_PAYROLLS_F@MXDM_NVIS_EXTRACT ppf
					  WHERE PAYROLL_ID = per_all_assignments_f.payroll_id
					  AND trunc(sysdate) BETWEEN ppf.effective_start_date and ppf.effective_end_date)
					  Payroll_name 				
                 ,per_all_assignments_f.default_code_comb_id
				 ,per_all_people_f.employee_number personnumber
                FROM  per_person_type_usages_f@MXDM_NVIS_EXTRACT per_person_type_usages_f
                    ,xxmx_hcm_current_asg_scope_mv per_all_assignments_f
                    ,per_assignment_status_types@MXDM_NVIS_EXTRACT per_assignment_status_types
                    ,xxmx_hcm_person_scope_mv per_all_people_f
                    ,per_person_types@MXDM_NVIS_EXTRACT per_person_types
                    ,per_periods_of_service@MXDM_NVIS_EXTRACT per_periods_of_service
                  --  ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
                WHERE  per_all_assignments_f.assignment_type = 'E'
              --  AND    per_person_types.system_person_type IN ('EMP','EX_EMP')
                AND     per_all_assignments_f.assignment_status_type_id = per_assignment_status_types.assignment_status_type_id
                AND    per_all_assignments_f.person_id = per_all_people_f.person_id
				and   per_all_people_f.person_type_id = per_person_types.person_type_id
                AND    per_all_assignments_f.effective_start_date BETWEEN per_all_people_f.effective_start_date
                                                                        AND     per_all_people_f.effective_end_date
                AND    per_all_assignments_f.person_id = per_person_type_usages_f.person_id
                AND    per_all_assignments_f.effective_start_date BETWEEN per_person_type_usages_f.effective_start_date
                                                                        AND     per_person_type_usages_f.effective_end_date
                AND   per_person_types.person_type_id = per_person_type_usages_f.person_type_id
                AND   per_periods_of_service.person_id = per_all_assignments_f.person_id
                --AND   (per_all_assignments_f.period_of_service_id is not null AND per_periods_of_service.period_of_service_id =per_all_assignments_f.period_of_service_id)
                AND   per_periods_of_service.actual_termination_date IS NOT NULL
                AND   per_periods_of_service.actual_termination_date  BETWEEN  TRUNC(gvd_migration_date_from) AND '31-DEC-4712'
                AND   per_all_assignments_f.business_group_id = p_bg_id
                AND EXISTS(   SELECT 1
                              FROM PAY_PAYROLLS_F@MXDM_NVIS_EXTRACT ppf
                              WHERE PPF.PAYROLL_ID = per_all_assignments_f.payroll_id
                              AND trunc(sysdate) BETWEEN ppf.effective_start_date and ppf.effective_end_date
                              AND UPPER(PPF.PAYROLL_NAME) IN (SELECT UPPER(PARAMETER_VALUE )
                                                            FROM xxmx_migration_parameters 
                                                            WHERE parameter_code like 'PAYROLL_NAME'
                                                            AND ENABLED_FLAG='Y' )
                            )
	        ) c_per_all_assignment
        WHERE   xxmx_per_persons_stg.person_id = to_char(c80_s_person_id)
		;

	  COMMIT;

		/*
		SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,c53_effective_start_date effective_start_date
                ,(CASE
                    WHEN    (
                                    c63_effective_end_date = final_process_date
                            AND     c70_per_system_status = 'TERM_ASSIGN'
                            )
                            THEN    to_date ('31-12-4712'
                                            ,'DD-MM-YYYY')
                    ELSE    c63_effective_end_date END) effective_end_date
                ,c80_s_person_id
                    || '_PERSON' person_id
                ,s0_period_of_service_id
                    || '_PERIOD_OF_SERVICE' period_of_service_id
                ,'E' assignment_type
                ,'EMP_ASG_'
                    || c65_assignment_NUMBER assignment_NUMBER
                ,c16_assignment_sequence assignment_sequence
                ,(CASE
                    WHEN    (
                                    c70_per_system_status = 'TERM_ASSIGN'
                            AND     c71_pay_system_status = 'P'
                            )
                            THEN    v_astat_inactive_p
                    WHEN    (
                                    c70_per_system_status = 'TERM_ASSIGN'
                            AND     c71_pay_system_status = 'D'
                            )
                            THEN    v_astat_inactive_np
                    WHEN    (
                                    c70_per_system_status = 'SUSP_ASSIGN'
                            AND     c71_pay_system_status = 'P'
                            )
                            THEN    v_astat_suspend_p
                    WHEN    (
                                    c70_per_system_status = 'SUSP_ASSIGN'
                            AND     c71_pay_system_status = 'D'
                            )
                            THEN    v_astat_suspend_np
                    WHEN    (
                                    c70_per_system_status = 'ACTIVE_ASSIGN'
                            AND     c71_pay_system_status = 'P'
                            )
                            THEN    v_astat_active_p
                    WHEN    (
                                    c70_per_system_status = 'ACTIVE_ASSIGN'
                            AND     c71_pay_system_status = 'D'
                            )
                            THEN    gvv_astat_active_np
                    ELSE    'N/A' END) assignment_status_type_id
                ,c43_primary_flag primary_flag
                ,nvl2(c67_organization_id, c67_organization_id || '_ORGANIZATION',null) organization_id
                ,nvl2(c82_job_id, c82_job_id || '_JOB',null) job_id
                ,nvl2(c83_location_id, c83_location_id || '_LOCATION',null) location_id
                ,nvl2(c84_position_id,c84_position_id || '_POSITION',null) position_id
                ,nvl2(c85_grade_id, c85_grade_id || '_GRADE',null) grade_id
                ,get_target_lookup_code (c72_bargaining_unit_code
                                        ,'BARGAINING_UNIT_CODE') bargaining_unit_code
                ,nvl (c39_labour_union_member_flag
                        ,'N') labour_union_member_flag
                ,NULL contract_id
                ,nvl (c30_manager_flag
                        ,'N') manager_flag
                ,c17_date_probation_end date_probation_end
                ,c48_probation_period probation_period
                ,c14_probation_unit probation_unit
                ,c52_normal_hours normal_hours
                ,get_target_lookup_code (c73_frequency
                                        ,'FREQUENCY') frequency
                ,c37_work_at_home work_at_home
                ,c40_time_normal_finish time_normal_finish
                ,c3_time_normal_start time_normal_start
                ,c59_notice_period notice_period
                ,get_target_lookup_code (c74_notice_period_uom
                                        ,'QUALIFYING_UNITS') notice_period_uom
                ,c56_default_code_comb_id default_code_comb_id
                ,get_target_lookup_code (c75_employee_category
                                        ,'EMPLOYEE_CATEGORY') employee_category
                ,get_target_lookup_code (c76_employment_category
                                        ,'EMP_CAT') employment_category
                ,get_target_lookup_code (c77_hourly_salaried_code
                                        ,'HOURLY_SALARIED_CODE') hourly_salaried_code
                ,c2_sal_review_period sal_review_period
                ,get_target_lookup_code (c78_sal_review_period_frequenc
                                        ,'FREQUENCY') sal_review_period_frequency
                ,c50_job_post_source_name job_post_source_name
                ,c54_project_title project_title
                ,c42_person_referred_by_id person_referred_by_id
                ,c58_applicant_rank applicant_rank
                ,c57_posting_content_id posting_content_id
                ,get_target_lookup_code (c79_source_type
                                        ,'REC_TYPE') source_type
                ,c15_projected_assignment_end projected_assignment_end
                ,c90_assignment_id
                    || '_EMP_TERM' work_terms_assignment_id
                ,'ASG_CHANGE' action_code
                ,c62_assignment_name assignment_name
                ,(CASE
                    WHEN    (
                                    c70_per_system_status = 'TERM_ASSIGN'
                            AND     c71_pay_system_status = 'P'
                            )
                            THEN    'INACTIVE'
                    WHEN    (
                                    c70_per_system_status = 'TERM_ASSIGN'
                            AND     c71_pay_system_status = 'D'
                            )
                            THEN    'INACTIVE'
                    WHEN    (
                                    c70_per_system_status = 'SUSP_ASSIGN'
                            AND     c71_pay_system_status = 'P'
                            )
                            THEN    'SUSPEND'
                    WHEN    (
                                    c70_per_system_status = 'SUSP_ASSIGN'
                            AND     c71_pay_system_status = 'D'
                            )
                            THEN    'SUSPEND'
                    WHEN    (
                                    c70_per_system_status = 'ACTIVE_ASSIGN'
                            AND     c71_pay_system_status = 'P'
                            )
                            THEN    'ACTIVE'
                    WHEN    (
                                    c70_per_system_status = 'ACTIVE_ASSIGN'
                            AND     c71_pay_system_status = 'D'
                            )
                            THEN    'ACTIVE'
                    ELSE    'N/A' END) assignment_status_type
                ,'Y' auto_end_flag
                ,1 effective_sequence
                ,c10_internal_location internal_location
                ,Case When c67_organization_id is NOT NULL THEN 
					xxmx_kit_worker_stg.get_legal_employer_name(SUBSTR(c67_organization_id,1,INSTR(c67_organization_id,'_',1)-1))
					ELSE 
						NULL
					END "legal_employer"
                ,gvv_leg_code
                ,gvv_per_type_emp person_type_id
                ,c55_primary_work_terms_flag primary_work_terms_flag
                ,c51_primary_assignment_flag primary_assignment_flag
                ,c61_primary_work_relation_flag primary_work_relation_flag
                ,c18_projected_start_date projected_start_date
                ,'EMP' system_person_type
                ,substr(c110_billing_title,1,30) billing_title
                ,v_business_name business_unit_name
                ,NULL action_occurrence_id
                ,'Y' position_override_flag
                ,'Y' effective_latest_change
                ,'Y' allow_asg_override_flag
                ,to_date ('01-01-1901'
                            ,'dd-mm-yyyy') freeze_start_date
                ,to_date ('31-12-4712'
                            ,'dd-mm-yyyy') freeze_until_date
                ,c90_assignment_id
                    || '_EMP_ASSIGNMENT'
        FROM    xxmx_per_persons_stg xxmx_per_persons_stg
                ,(
                SELECT  per_all_assignments_f.sal_review_period c2_sal_review_period
                    ,per_all_assignments_f.time_normal_start c3_time_normal_start
                    ,per_all_people_f.internal_location c10_internal_location
                    ,per_all_assignments_f.probation_unit c14_probation_unit
                    ,per_all_assignments_f.projected_assignment_end c15_projected_assignment_end
                    ,per_all_assignments_f.assignment_sequence c16_assignment_sequence
                    ,per_all_assignments_f.date_probation_end c17_date_probation_end
                    ,per_all_people_f.projected_start_date c18_projected_start_date
                    ,per_all_assignments_f.manager_flag c30_manager_flag
                    ,per_all_assignments_f.work_at_home c37_work_at_home
                    ,per_all_assignments_f.labour_union_member_flag c39_labour_union_member_flag
                    ,per_all_assignments_f.time_normal_finish c40_time_normal_finish
                    ,per_all_assignments_f.person_referred_by_id c42_person_referred_by_id
                    ,per_all_assignments_f.primary_flag c43_primary_flag
                    ,per_all_assignments_f.probation_period c48_probation_period
                    ,per_all_assignments_f.job_post_source_name c50_job_post_source_name
                    ,per_all_assignments_f.primary_flag c51_primary_assignment_flag
                    ,per_all_assignments_f.normal_hours c52_normal_hours
                    ,per_all_assignments_f.effective_start_date c53_effective_start_date
                    ,per_all_assignments_f.project_title c54_project_title
                    ,NULL c55_primary_work_terms_flag
                    ,NULL c56_default_code_comb_id
                    ,per_all_assignments_f.posting_content_id c57_posting_content_id
                    ,per_all_assignments_f.applicant_rank c58_applicant_rank
                    ,per_all_assignments_f.notice_period c59_notice_period
                    ,per_all_assignments_f.ass_attribute_category c60_ass_attribute_category
                    ,'Y' c61_primary_work_relation_flag
                    ,'E'
                        || per_all_assignments_f.assignment_NUMBER c62_assignment_name
                    ,per_person_types.person_type_id c89_person_type_id
                    ,per_all_assignments_f.assignment_id c90_assignment_id
                    ,per_all_assignments_f.effective_end_date c63_effective_end_date
                    ,per_all_assignments_f.grade_id c85_grade_id
                    ,per_all_assignments_f.position_id c84_position_id
                    ,per_assignment_status_types.pay_system_status c71_pay_system_status
                    ,per_all_assignments_f.job_id c82_job_id
                    ,per_assignment_status_types.per_system_status c70_per_system_status
                    ,per_all_assignments_f.location_id c83_location_id
                    ,per_all_assignments_f.organization_id c67_organization_id
                    ,per_all_assignments_f.people_group_id c86_people_group_id
                    ,per_all_assignments_f.person_id c80_s_person_id
                    ,per_all_assignments_f.assignment_NUMBER c65_assignment_NUMBER
                    ,per_all_assignments_f.employment_category c76_employment_category
                    ,per_all_assignments_f.frequency c73_frequency
                    ,per_all_assignments_f.sal_review_period_frequency c78_sal_review_period_frequenc
                    ,per_all_assignments_f.source_type c79_source_type
                    ,per_all_assignments_f.bargaining_unit_code c72_bargaining_unit_code
                    ,per_all_assignments_f.hourly_salaried_code c77_hourly_salaried_code
                    ,per_all_assignments_f.contract_id c87_contract_id
                    ,per_all_assignments_f.notice_period_uom c74_notice_period_uom
                    ,per_all_assignments_f.employee_category c75_employee_category
                    ,per_person_types.system_person_type c91_system_person_type
                    ,per_all_people_f.first_name || '.' ||  per_all_people_f.last_name  c110_billing_title
                    ,per_all_assignments_f.assignment_status_type_id s0_asg_status_type_id
                    ,per_periods_of_service.final_process_date final_process_date
                    ,per_periods_of_service.period_of_service_id s0_period_of_service_id
                FROM    per_person_type_usages_f@MXDM_NVIS_EXTRACT per_person_type_usages_f
                    ,per_all_assignments_f@MXDM_NVIS_EXTRACT per_all_assignments_f
                    ,per_assignment_status_types@MXDM_NVIS_EXTRACT per_assignment_status_types
                    ,per_all_people_f@MXDM_NVIS_EXTRACT per_all_people_f
                    ,per_person_types@MXDM_NVIS_EXTRACT per_person_types
                    ,per_periods_of_service@MXDM_NVIS_EXTRACT per_periods_of_service
                    ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
                WHERE   (
                                per_all_assignments_f.assignment_type = 'E'
                        )
                AND     (
                                per_person_types.system_person_type IN ('EMP','EX_EMP')
                        )
                AND     (
                                per_all_assignments_f.assignment_status_type_id = per_assignment_status_types.assignment_status_type_id
                        )
                AND     (
                                per_all_assignments_f.person_id = per_all_people_f.person_id
                        AND     per_all_assignments_f.effective_start_date BETWEEN per_all_people_f.effective_start_date
                                                                        AND     per_all_people_f.effective_end_date
                        )
                AND     (
                                per_all_assignments_f.person_id = per_person_type_usages_f.person_id
                        AND     per_all_assignments_f.effective_start_date BETWEEN per_person_type_usages_f.effective_start_date
                                                                        AND     per_person_type_usages_f.effective_end_date
                        )
                AND     (
                                per_person_types.person_type_id = per_person_type_usages_f.person_type_id
                        )
                AND     (
                                per_periods_of_service.period_of_service_id = per_all_assignments_f.period_of_service_id
                        )
                AND     (
                                horg.organization_id = per_all_assignments_f.business_group_id
                        AND     horg.name = p_bg_name
                        )
                    ) c_per_all_assignment
        where      (
                            xxmx_per_persons_stg.person_id = c80_s_person_id

                    )
        and         exists (
        select 1 from xxmx_per_pos_wr_stg inn
        where  inn.period_of_service_id = s0_period_of_service_id
                    || '_PERIOD_OF_SERVICE'
        and    c53_effective_start_date  between inn.date_start and nvl(actual_termination_date,to_date('31-12-4712','DD-MM-YYYY'))
        and    inn.period_type = 'E'
        and    inn.person_id = c80_s_person_id
                                                            || '_PERSON'
        );*/
        --
        -- 
        --

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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed' 
                        ,pt_i_OracleError         => gvt_ReturnMessage       );   

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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;

    END export_all_assignments_m_3;

    PROCEDURE export_all_assignments_m_4
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'EXPORT_ALL_ASSIGNMENTS_M_4'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_ASSIGNMENTS_M_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'ALL_ASSIGNMENTS_M_4';

		lvv_migration_date_to                           VARCHAR2(30); 
		lvv_migration_date_from                         VARCHAR2(30); 
		lvv_prev_tax_year_date                          VARCHAR2(30);         
		lvd_migration_date_to                           DATE;  
		lvd_migration_date_from                         DATE;
		lvd_prev_tax_year_date                          DATE;   


    BEGIN
        --
        --       
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
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0005';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'DATA'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        IF   gvv_ReturnStatus = 'F'
        THEN
            xxmx_utilities_pkg.log_module_message
                (pt_i_ApplicationSuite    => gct_ApplicationSuite
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
        END IF;       
		--
		--

		--
        set_parameters(p_bg_id);
        --
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
                        ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable   || '".'   
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
        -- 
        INSERT  
        INTO    xxmx_per_assignments_m_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,effective_start_date
                ,effective_end_date
                ,person_id
                ,period_of_service_id
                ,assignment_type
                ,assignment_NUMBER
                ,assignment_sequence
                ,assignment_status_type_id
                ,primary_flag
                ,organization_id
                ,job_id
                ,location_id
                ,position_id
                ,grade_id
                ,bargaining_unit_code
                ,labour_union_member_flag
                ,manager_flag
                ,date_probation_end
                ,probation_period
                ,probation_unit
                ,normal_hours
                ,frequency
                ,WORK_AT_HOME_FLAG
                ,time_normal_finish
                ,time_normal_start
                ,notice_period
                ,notice_period_uom
                ,employee_category
                ,employment_category
                ,hourly_salaried_code
                ,sal_review_period
                ,sal_review_period_frequency
                ,job_post_source_name
                ,project_title
                ,person_referred_by_id
                ,applicant_rank
                ,posting_content_id
                ,source_type
                ,projected_assignment_end
                ,work_terms_assignment_id
                ,action_code
                ,assignment_name
                ,assignment_status_type
                ,auto_end_flag
                ,effective_sequence
                ,internal_location
                ,legal_employer_name
                ,legislation_code
                ,person_type_id
                ,primary_work_terms_flag
                ,primary_assignment_flag
                ,primary_work_relation_flag
                ,projected_start_date
                ,system_person_type
              --  ,billing_title
                ,business_unit_name
                ,action_occurrence_id
                ,position_override_flag
                ,effective_latest_change
                ,allow_asg_override_flag
                ,freeze_start_date
                ,freeze_until_date
                ,assignment_id
				,grade_code
				,grade_ladder_pgm_name
				,job_code
				,position_code
				,location_code
				,spec_ceiling_step
				,people_group_id
				,collect_agree_name
				,user_person_type
				,contract_id
				,proposed_worker_type 
				,PAYROLLNAME
				,Reason_code
                ,default_code_comb_id
                , personnumber)
		SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,actual_termination_date effective_start_date
                ,to_date ('31-12-4712','DD-MM-YYYY') effective_end_date
                ,c80_s_person_id person_id
                ,s0_period_of_placement_id|| '_PERIOD_OF_PLACEMENT' period_of_service_id
                ,'C' assignment_type
                ,'C'|| c65_assignment_number assignment_NUMBER
                ,c17_assignment_sequence assignment_sequence
                ,NULL assignment_status_type_id
                ,c44_primary_flag primary_flag
                ,org_name
                ,c82_job_id
                ,c83_location_id
                ,c84_position_id
                ,c85_grade_id
                ,get_target_lookup_code (c72_bargaining_unit_code,'BARGAINING_UNIT_CODE') bargaining_unit_code
                ,nvl (c40_labour_union_member_flag
                        ,'N') labour_union_member_flag
                ,nvl (c31_manager_flag
                        ,'N') manager_flag
                ,c18_date_probation_end date_probation_end
                ,c48_probation_period probation_period
                ,c15_probation_unit probation_unit
                ,c52_normal_hours normal_hours
                ,get_target_lookup_code (c73_frequency,'FREQUENCY') frequency
                ,c38_work_at_home work_at_home
                ,c41_time_normal_finish time_normal_finish
                ,c4_time_normal_start time_normal_start
                ,c59_notice_period notice_period
                ,get_target_lookup_code (c74_notice_period_uom
                                        ,'QUALIFYING_UNITS') notice_period_uom
                ,get_target_lookup_code (c75_employee_category
                                        ,'EMPLOYEE_CATG') employee_category
                ,get_target_lookup_code (c76_employment_category
                                        ,'CWK_ASG_CATEGORY') employment_category
                ,get_target_lookup_code (c77_hourly_salaried_code
                                        ,'HOURLY_SALARIED_CODE') hourly_salaried_code
                ,c3_sal_review_period sal_review_period
                ,get_target_lookup_code (c78_sal_review_period_frequenc
                                        ,'FREQUENCY') sal_review_period_frequency
                ,c50_job_post_source_name job_post_source_name
                ,c54_project_title project_title
                ,c43_person_referred_by_id person_referred_by_id
                ,c58_applicant_rank applicant_rank
                ,c57_posting_content_id posting_content_id
                ,get_target_lookup_code (c79_source_type,'REC_TYPE') source_type
                ,c16_projected_assignment_end projected_assignment_end
                ,'CT'||c65_assignment_number work_terms_assignment_id
                ,'TERMINATION' action_code
                ,c62_assignment_name assignment_name
                , c70_pay_system_status||'_'||c71_per_system_status assignment_status_type
                ,'Y' auto_end_flag
                ,1 effective_sequence
                ,c11_internal_location internal_location
                ,Case When business_group_id is NOT NULL THEN 
					xxmx_kit_worker_stg.get_legal_employer_name(business_group_id)
					ELSE 
						NULL
					END "legal_employer"
                ,gvv_leg_code
                ,NULL
                ,c55_primary_work_terms_flag primary_work_terms_flag
                ,c51_primary_assignment_flag primary_assignment_flag
                ,c61_primary_work_relation_flag primary_work_relation_flag
                ,c19_projected_start_date projected_start_date
                ,system_person_type
              --  ,substr(c110_billing_title,1,30) billing_title
                ,business_unit_name
                ,NULL action_occurrence_id
                ,'Y' position_override_flag
                --,'N' position_override_flag
                ,'Y' effective_latest_change
                ,'Y' allow_asg_override_flag
                ,to_date ('01-01-1901','dd-mm-yyyy') freeze_start_date
                ,to_date ('31-12-4712','dd-mm-yyyy') freeze_until_date
                ,c90_assignment_id|| '_CWK_ASSIGNMENT'
				,grade_code
				,grade_ladder_pgm_name
				,job_code
				,position_code
				,location_code
				,special_ceiling_step_name
				,c86_people_group_id
				,collective_agreement_name
				,user_person_type
				,contract_name
				,'E'
				,payroll_name
				,termination_reason
                ,default_code_comb_id
                ,per_all_assignments.personnumber
        FROM    xxmx_per_persons_stg xxmx_per_persons_stg
          		 ,
                ( SELECT  per_all_assignments_f.sal_review_period c3_sal_review_period
                    ,per_all_assignments_f.time_normal_start c4_time_normal_start
                    ,per_all_people_f.internal_location c11_internal_location
                    ,per_all_assignments_f.probation_unit c15_probation_unit
                    ,per_all_assignments_f.projected_assignment_end c16_projected_assignment_end
                    ,per_all_assignments_f.assignment_sequence c17_assignment_sequence
                    ,per_all_assignments_f.date_probation_end c18_date_probation_end
                    ,per_all_people_f.projected_start_date c19_projected_start_date
                    ,per_all_assignments_f.manager_flag c31_manager_flag
                    ,per_all_assignments_f.work_at_home c38_work_at_home
                    ,per_all_assignments_f.labour_union_member_flag c40_labour_union_member_flag
                    ,per_all_assignments_f.time_normal_finish c41_time_normal_finish
                    ,per_all_assignments_f.person_referred_by_id c43_person_referred_by_id
                    ,per_all_assignments_f.primary_flag c44_primary_flag
                    ,per_all_assignments_f.probation_period c48_probation_period
                    ,per_all_assignments_f.job_post_source_name c50_job_post_source_name
                    ,per_all_assignments_f.primary_flag c51_primary_assignment_flag
                    ,per_all_assignments_f.normal_hours c52_normal_hours
                    ,per_all_assignments_f.effective_start_date c53_effective_start_date
                    ,per_all_assignments_f.project_title c54_project_title
                    ,'Y' c55_primary_work_terms_flag
                    ,per_all_assignments_f.posting_content_id c57_posting_content_id
                    ,per_all_assignments_f.applicant_rank c58_applicant_rank
                    ,per_all_assignments_f.notice_period c59_notice_period
                    ,per_all_assignments_f.ass_attribute_category c60_ass_attribute_category
                    ,'N' c61_primary_work_relation_flag
                    ,per_all_assignments_f.title c62_assignment_name
                    ,per_person_types.person_type_id c89_person_type_id
                    ,per_all_assignments_f.assignment_id c90_assignment_id
                    ,per_all_assignments_f.effective_end_date c63_effective_end_date
                    ,per_all_assignments_f.grade_id c85_grade_id
                    ,per_all_assignments_f.position_id c84_position_id
                    ,per_assignment_status_types.pay_system_status c70_pay_system_status
                    ,per_all_assignments_f.job_id c82_job_id
                    ,per_assignment_status_types.per_system_status c71_per_system_status
                    ,per_all_assignments_f.location_id c83_location_id
                    ,per_all_assignments_f.organization_id c67_organization_id
                    ,per_all_assignments_f.people_group_id c86_people_group_id
                    ,per_all_assignments_f.person_id c80_s_person_id
                    ,per_all_assignments_f.assignment_NUMBER c65_assignment_NUMBER
                    ,per_all_assignments_f.employment_category c76_employment_category
                    ,per_all_assignments_f.frequency c73_frequency
                    ,per_all_assignments_f.sal_review_period_frequency c78_sal_review_period_frequenc
                    ,per_all_assignments_f.source_type c79_source_type
                    ,per_all_assignments_f.bargaining_unit_code c72_bargaining_unit_code
                    ,per_all_assignments_f.hourly_salaried_code c77_hourly_salaried_code
                    ,per_all_assignments_f.contract_id c87_contract_id
                    ,per_all_assignments_f.notice_period_uom c74_notice_period_uom
                    ,per_all_assignments_f.employee_category c75_employee_category
                    ,per_all_people_f.first_name || '.' ||  per_all_people_f.last_name  c110_billing_title
                    ,per_all_assignments_f.assignment_status_type_id s0_asg_status_type_id
                    ,per_periods_of_placement.period_of_placement_id s0_period_of_placement_id
					,per_periods_of_placement.TERMINATION_REASON
					,per_periods_of_placement.actual_termination_date
                    ,per_periods_of_placement.final_process_date final_process_date
                    ,(SELECT Name 
					  FROM per_grades_tl@MXDM_NVIS_EXTRACT 
					  WHERE grade_id = per_All_assignments_f.grade_id) 
					  GRADE_CODE
					,per_all_assignments_f.GRADE_LADDER_PGM_ID
					,per_all_people_f.EXPENSE_CHECK_SEND_TO_ADDRESS "EXPENSE_CHECK_ADDRESS"
					,(SELECT Name 
					  FROM per_jobs_tl@MXDM_NVIS_EXTRACT 
					  WHERE job_id  =  per_All_assignments_f.job_id)
                    JOB_CODE
					,(SELECT location_code 
					  FROM hr_locations_all@MXDM_NVIS_EXTRACT 
					  WHERE location_id  =  per_All_assignments_f.location_id)
                    LOCATION_CODE
					,per_periods_of_placement.Date_start
					,(SELECT name 
					  FROM HR_ALL_POSITIONS_F@MXDM_NVIS_EXTRACT  HAPF
					  WHERE position_id = per_All_assignments_f.position_id
					  AND  TRUNC(SYSDATE) BETWEEN HAPF.effective_Start_date AND HAPF.effective_end_date) 
					 POSITION_CODE
					,PER_ALL_ASSIGNMENTS_F.PROJECTED_ASSIGNMENT_END
					,per_All_Assignments_f.business_Group_id
					,per_person_types.SYSTEM_PERSON_TYPE
					,per_person_types.USER_PERSON_TYPE
                    ,PER_ALL_ASSIGNMENTS_F.SPECIAL_CEILING_STEP_ID
                    ,(SELECT PSP.spinal_point
					from  PER_SPINAL_POINT_STEPS_F@MXDM_NVIS_EXTRACT	PSPSF
						, per_spinal_points@MXDM_NVIS_EXTRACT PSP
						,per_grade_spines_f@MXDM_NVIS_EXTRACT pgsf 
					where Step_id  = PER_ALL_ASSIGNMENTS_F.SPECIAL_CEILING_STEP_ID
					and PSP.spinal_point_id =PSPSF.spinal_point_id
					and  TRUNC(SYSDATE) BETWEEN pgsf.effective_Start_date AND pgsf.effective_end_date				
					AND psp.parent_spine_id = pgsf.parent_spine_id
					and pgsf.grade_id = PER_ALL_ASSIGNMENTS_F.grade_id
					and Trunc(sysdate) between PSPSF.effective_Start_date and PSPSF.effective_end_date)
					  SPECIAL_CEILING_STEP_NAME
					,PER_ALL_ASSIGNMENTS_F.PEOPLE_GROUP_ID
                    ,(SELECT GROUP_NAME
					  FROM PAY_PEOPLE_GROUPS@MXDM_NVIS_EXTRACT PPG
                      WHERE PPG.people_group_id = per_all_assignments_f.people_group_id
                      AND PPG.end_date_active IS NULL)
					  PEOPLE_GROUP_NAME
					,(SELECT NAME 
					  FROM per_collective_agreements@MXDM_NVIS_EXTRACT PCA 
					  WHERE  collective_agreement_id = per_All_Assignments_f.COLLECTIVE_AGREEMENT_ID 
					  AND TRUNC(SYSDATE)BETWEEN PCA.Start_Date AND PCA.end_date)
					  COLLECTIVE_AGREEMENT_NAME
					,(SELECT Name 
					  FROM BEN_PGM_F@MXDM_NVIS_EXTRACT BPF
					  WHERE PGM_ID = per_all_assignments_f.GRADE_LADDER_PGM_ID
					  AND TRUNC(SYSDATE) BETWEEN BPF.effective_start_Date AND BPF.effective_end_date)
					GRADE_LADDER_PGM_NAME
					,(SELECT NAME 
					  FROM HR_ALL_ORGANIZATION_UNITS@MXDM_NVIS_EXTRACT 
					  WHERE organization_id = per_all_assignments_f.Business_group_id
					  AND TRUNC(SYSDATE ) BETWEEN DATE_FROM AND NVL(DATE_TO, '31-DEC-4712'))
					  business_unit_name
					,(SELECT Reference 
					  FROM per_contracts_f@MXDM_NVIS_EXTRACT 
					  WHERE contract_id = per_all_assignments_f.contract_id
					  AND TRUNC(SYSDATE ) BETWEEN effective_Start_date AND NVL(effective_end_date, '31-DEC-4712'))
					  contract_name
					,(SELECT NAME 
					  FROM HR_ALL_ORGANIZATION_UNITS@MXDM_NVIS_EXTRACT 
					  WHERE organization_id = per_all_assignments_f.organization_id
					  AND TRUNC(SYSDATE ) BETWEEN DATE_FROM AND NVL(DATE_TO, '31-DEC-4712'))
					  Org_name
					,(SELECT Payroll_name
					  FROM PAY_PAYROLLS_F@MXDM_NVIS_EXTRACT ppf
					  WHERE PAYROLL_ID = per_all_assignments_f.payroll_id
					  AND trunc(sysdate) BETWEEN ppf.effective_start_date and ppf.effective_end_date)
					  Payroll_name 	
                 ,per_all_assignments_f.default_code_comb_id
				 ,per_all_people_f.employee_number personnumber
                FROM    per_person_type_usages_f@MXDM_NVIS_EXTRACT per_person_type_usages_f
                    ,xxmx_hcm_current_asg_scope_mv per_all_assignments_f
                    ,per_assignment_status_types@MXDM_NVIS_EXTRACT per_assignment_status_types
                    ,xxmx_hcm_person_scope_mv per_all_people_f
                    ,per_person_types@MXDM_NVIS_EXTRACT per_person_types
                    ,per_periods_of_placement@MXDM_NVIS_EXTRACT per_periods_of_placement
                    --,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
                WHERE  per_all_assignments_f.assignment_type = 'C'
                AND    per_person_types.system_person_type IN ('CWK','EX_CWK')
				AND   per_all_people_f.person_id = per_person_type_usages_f.person_id
                AND    per_all_assignments_f.assignment_status_type_id = per_assignment_status_types.assignment_status_type_id
                AND    per_all_assignments_f.person_id = per_all_people_f.person_id
                AND    per_all_assignments_f.effective_start_date BETWEEN per_all_people_f.effective_start_date
                                                                        AND     per_all_people_f.effective_end_date
                AND    per_all_assignments_f.person_id = per_person_type_usages_f.person_id
                AND    per_all_assignments_f.effective_start_date BETWEEN per_person_type_usages_f.effective_start_date
                                                                        AND     per_person_type_usages_f.effective_end_date
                AND   per_person_types.person_type_id = per_person_type_usages_f.person_type_id
                AND   per_periods_of_placement.person_id = per_all_assignments_f.person_id
                AND   per_periods_of_placement.date_start = per_all_assignments_f.period_of_placement_date_start
				AND   per_periods_of_placement.actual_termination_date IS NOT NULL
                AND   per_all_assignments_f.business_group_id = p_bg_id
				AND   per_periods_of_placement.actual_termination_date  BETWEEN  TRUNC(gvd_migration_date_from) AND '31-DEC-4712'
				--AND   horg.name = p_bg_name
			)per_all_assignments
		where   xxmx_per_persons_stg.person_id = c80_s_person_id 
;

				--Commented by Pallavi 
       /* SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,c53_effective_start_date effective_start_date
                ,(CASE
                    WHEN    (
                                    c63_effective_end_date = final_process_date
                            AND     c71_per_system_status = 'TERM_ASSIGN'
                            )
                            THEN    to_date ('31-12-4712'
                                            ,'DD-MM-YYYY')
                    ELSE    c63_effective_end_date END) effective_end_date
                ,c80_s_person_id
                    || '_PERSON' person_id
                ,s0_period_of_placement_id
                    || '_PERIOD_OF_PLACEMENT' period_of_service_id
                ,'C' assignment_type
                ,'CWK_ASG_'
                    || c65_assignment_NUMBER assignment_NUMBER
                ,c17_assignment_sequence assignment_sequence
                ,(CASE
                    WHEN    (
                                    c71_per_system_status = 'TERM_ASSIGN'
                            AND     c70_pay_system_status = 'P'
                            )
                            THEN    v_astat_inactive_p
                    WHEN    (
                                    c71_per_system_status = 'TERM_ASSIGN'
                            AND     c70_pay_system_status = 'D'
                            )
                            THEN    v_astat_inactive_np
                    WHEN    (
                                    c71_per_system_status = 'SUSP_CWK_ASG'
                            AND     c70_pay_system_status = 'P'
                            )
                            THEN    v_astat_suspend_p
                    WHEN    (
                                    c71_per_system_status = 'SUSP_CWK_ASG'
                            AND     c70_pay_system_status = 'D'
                            )
                            THEN    v_astat_suspend_np
                    WHEN    (
                                    c71_per_system_status = 'ACTIVE_CWK'
                            AND     c70_pay_system_status = 'P'
                            )
                            THEN    v_astat_active_p
                    WHEN    (
                                    c71_per_system_status = 'ACTIVE_CWK'
                            AND     c70_pay_system_status = 'D'
                            )
                            THEN    gvv_astat_active_np
                    ELSE    'N/A' END) assignment_status_type_id
                ,c44_primary_flag primary_flag
                ,nvl2(c67_organization_id, c67_organization_id || '_ORGANIZATION',null) organization_id
                ,nvl2(c82_job_id, c82_job_id || '_JOB',null) job_id
                ,nvl2(c83_location_id, c83_location_id || '_LOCATION',null) location_id
                ,nvl2(c84_position_id,c84_position_id || '_POSITION',null) position_id
                ,nvl2(c85_grade_id, c85_grade_id || '_GRADE',null) grade_id
                ,get_target_lookup_code (c72_bargaining_unit_code
                                        ,'BARGAINING_UNIT_CODE') bargaining_unit_code
                ,nvl (c40_labour_union_member_flag
                        ,'N') labour_union_member_flag
                ,nvl (c31_manager_flag
                        ,'N') manager_flag
                ,c18_date_probation_end date_probation_end
                ,c48_probation_period probation_period
                ,c15_probation_unit probation_unit
                ,c52_normal_hours normal_hours
                ,get_target_lookup_code (c73_frequency
                                        ,'FREQUENCY') frequency
                ,c38_work_at_home work_at_home
                ,c41_time_normal_finish time_normal_finish
                ,c4_time_normal_start time_normal_start
                ,c59_notice_period notice_period
                ,get_target_lookup_code (c74_notice_period_uom
                                        ,'QUALIFYING_UNITS') notice_period_uom
                ,c56_default_code_comb_id default_code_comb_id
                ,get_target_lookup_code (c75_employee_category
                                        ,'EMPLOYEE_CATG') employee_category
                ,get_target_lookup_code (c76_employment_category
                                        ,'CWK_ASG_CATEGORY') employment_category
                ,get_target_lookup_code (c77_hourly_salaried_code
                                        ,'HOURLY_SALARIED_CODE') hourly_salaried_code
                ,c3_sal_review_period sal_review_period
                ,get_target_lookup_code (c78_sal_review_period_frequenc
                                        ,'FREQUENCY') sal_review_period_frequency
                ,c50_job_post_source_name job_post_source_name
                ,c54_project_title project_title
                ,c43_person_referred_by_id person_referred_by_id
                ,c58_applicant_rank applicant_rank
                ,c57_posting_content_id posting_content_id
                ,get_target_lookup_code (c79_source_type
                                        ,'REC_TYPE') source_type
                ,c16_projected_assignment_end projected_assignment_end
                ,c90_assignment_id
                    || '_CWK_TERM' work_terms_assignment_id
                ,'ASG_CHANGE' action_code
                ,c62_assignment_name assignment_name
                ,(CASE
                    WHEN    (
                                    c71_per_system_status = 'TERM_ASSIGN'
                            AND     c70_pay_system_status = 'P'
                            )
                            THEN    'INACTIVE'
                    WHEN    (
                                    c71_per_system_status = 'TERM_ASSIGN'
                            AND     c70_pay_system_status = 'D'
                            )
                            THEN    'INACTIVE'
                    WHEN    (
                                    c71_per_system_status = 'SUSP_CWK_ASG'
                            AND     c70_pay_system_status = 'P'
                            )
                            THEN    'SUSPEND'
                    WHEN    (
                                    c71_per_system_status = 'SUSP_CWK_ASG'
                            AND     c70_pay_system_status = 'D'
                            )
                            THEN    'SUSPEND'
                    WHEN    (
                                    c71_per_system_status = 'ACTIVE_CWK'
                            AND     c70_pay_system_status = 'P'
                            )
                            THEN    'ACTIVE'
                    WHEN    (
                                    c71_per_system_status = 'ACTIVE_CWK'
                            AND     c70_pay_system_status = 'D'
                            )
                            THEN    'ACTIVE'
                    ELSE    'N/A' END) assignment_status_type
                ,'Y' auto_end_flag
                ,1 effective_sequence
                ,c11_internal_location internal_location
                ,Case When c67_organization_id is NOT NULL THEN 
					xxmx_kit_worker_stg.get_legal_employer_name(SUBSTR(c67_organization_id,1,INSTR(c67_organization_id,'_',1)-1))
					ELSE 
						NULL
					END "legal_employer"
                ,gvv_leg_code
                ,NULL
                ,c55_primary_work_terms_flag primary_work_terms_flag
                ,c51_primary_assignment_flag primary_assignment_flag
                ,c61_primary_work_relation_flag primary_work_relation_flag
                ,c19_projected_start_date projected_start_date
                ,'CWK' system_person_type
                ,substr(c110_billing_title,1,30) billing_title
                    ,v_business_name business_unit_name
                ,NULL action_occurrence_id
                ,'Y' position_override_flag
                ,'Y' effective_latest_change
                ,'Y' allow_asg_override_flag
                ,to_date ('01-01-1901'
                            ,'dd-mm-yyyy') freeze_start_date
                ,to_date ('31-12-4712'
                            ,'dd-mm-yyyy') freeze_until_date
                ,c90_assignment_id
                    || '_CWK_ASSIGNMENT'
        FROM    xxmx_per_persons_stg xxmx_per_persons_stg
                ,
                (
                SELECT  per_all_assignments_f.sal_review_period c3_sal_review_period
                    ,per_all_assignments_f.time_normal_start c4_time_normal_start
                    ,per_all_people_f.internal_location c11_internal_location
                    ,per_all_assignments_f.probation_unit c15_probation_unit
                    ,per_all_assignments_f.projected_assignment_end c16_projected_assignment_end
                    ,per_all_assignments_f.assignment_sequence c17_assignment_sequence
                    ,per_all_assignments_f.date_probation_end c18_date_probation_end
                    ,per_all_people_f.projected_start_date c19_projected_start_date
                    ,per_all_assignments_f.manager_flag c31_manager_flag
                    ,per_all_assignments_f.work_at_home c38_work_at_home
                    ,per_all_assignments_f.labour_union_member_flag c40_labour_union_member_flag
                    ,per_all_assignments_f.time_normal_finish c41_time_normal_finish
                    ,per_all_assignments_f.person_referred_by_id c43_person_referred_by_id
                    ,per_all_assignments_f.primary_flag c44_primary_flag
                    ,per_all_assignments_f.probation_period c48_probation_period
                    ,per_all_assignments_f.job_post_source_name c50_job_post_source_name
                    ,per_all_assignments_f.primary_flag c51_primary_assignment_flag
                    ,per_all_assignments_f.normal_hours c52_normal_hours
                    ,per_all_assignments_f.effective_start_date c53_effective_start_date
                    ,per_all_assignments_f.project_title c54_project_title
                    ,NULL c55_primary_work_terms_flag
                    ,NULL c56_default_code_comb_id
                    ,per_all_assignments_f.posting_content_id c57_posting_content_id
                    ,per_all_assignments_f.applicant_rank c58_applicant_rank
                    ,per_all_assignments_f.notice_period c59_notice_period
                    ,per_all_assignments_f.ass_attribute_category c60_ass_attribute_category
                    ,'Y' c61_primary_work_relation_flag
                    ,'C'
                        || per_all_assignments_f.assignment_NUMBER c62_assignment_name
                    ,per_person_types.person_type_id c89_person_type_id
                    ,per_all_assignments_f.assignment_id c90_assignment_id
                    ,per_all_assignments_f.effective_end_date c63_effective_end_date
                    ,per_all_assignments_f.grade_id c85_grade_id
                    ,per_all_assignments_f.position_id c84_position_id
                    ,per_assignment_status_types.pay_system_status c70_pay_system_status
                    ,per_all_assignments_f.job_id c82_job_id
                    ,per_assignment_status_types.per_system_status c71_per_system_status
                    ,per_all_assignments_f.location_id c83_location_id
                    ,per_all_assignments_f.organization_id c67_organization_id
                    ,per_all_assignments_f.people_group_id c86_people_group_id
                    ,per_all_assignments_f.person_id c80_s_person_id
                    ,per_all_assignments_f.assignment_NUMBER c65_assignment_NUMBER
                    ,per_all_assignments_f.employment_category c76_employment_category
                    ,per_all_assignments_f.frequency c73_frequency
                    ,per_all_assignments_f.sal_review_period_frequency c78_sal_review_period_frequenc
                    ,per_all_assignments_f.source_type c79_source_type
                    ,per_all_assignments_f.bargaining_unit_code c72_bargaining_unit_code
                    ,per_all_assignments_f.hourly_salaried_code c77_hourly_salaried_code
                    ,per_all_assignments_f.contract_id c87_contract_id
                    ,per_all_assignments_f.notice_period_uom c74_notice_period_uom
                    ,per_all_assignments_f.employee_category c75_employee_category
                    ,per_all_people_f.first_name || '.' ||  per_all_people_f.last_name  c110_billing_title
                    ,per_all_assignments_f.assignment_status_type_id s0_asg_status_type_id
                    ,per_periods_of_placement.period_of_placement_id s0_period_of_placement_id
                    ,per_periods_of_placement.final_process_date final_process_date
                FROM    per_person_type_usages_f@MXDM_NVIS_EXTRACT per_person_type_usages_f
                    ,per_all_assignments_f@MXDM_NVIS_EXTRACT per_all_assignments_f
                    ,per_assignment_status_types@MXDM_NVIS_EXTRACT per_assignment_status_types
                    ,per_all_people_f@MXDM_NVIS_EXTRACT per_all_people_f
                    ,per_person_types@MXDM_NVIS_EXTRACT per_person_types
                    ,per_periods_of_placement@MXDM_NVIS_EXTRACT per_periods_of_placement
                    ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
                WHERE   (
                                per_all_assignments_f.assignment_type = 'C'
                        )
                AND     (
                                per_person_types.system_person_type IN ('CWK','EX_CWK')
                        )
                AND     (
                                per_all_assignments_f.assignment_status_type_id = per_assignment_status_types.assignment_status_type_id
                        )
                AND     (
                                per_all_assignments_f.person_id = per_all_people_f.person_id
                        AND     per_all_assignments_f.effective_start_date BETWEEN per_all_people_f.effective_start_date
                                                                        AND     per_all_people_f.effective_end_date
                        )
                AND     (
                                per_all_assignments_f.person_id = per_person_type_usages_f.person_id
                        AND     per_all_assignments_f.effective_start_date BETWEEN per_person_type_usages_f.effective_start_date
                                                                        AND     per_person_type_usages_f.effective_end_date
                        )
                AND     (
                                per_person_types.person_type_id = per_person_type_usages_f.person_type_id
                        )
                AND     (
                                per_periods_of_placement.person_id = per_all_assignments_f.person_id
                        AND     per_periods_of_placement.date_start = per_all_assignments_f.period_of_placement_date_start
                        )
                AND     (
                                horg.organization_id = per_all_assignments_f.business_group_id
                        AND     horg.name = p_bg_name
                        )
                ) per_all_assignments
        where      (
                            xxmx_per_persons_stg.person_id = c80_s_person_id

                    )
        and         exists (
        select 1 from xxmx_per_pos_wr_stg inn
        where  inn.period_of_service_id = s0_period_of_placement_id
                    || '_PERIOD_OF_PLACEMENT'
        and    c53_effective_start_date between  inn.date_start and  nvl(actual_termination_date,to_date('31-12-4712','DD-MM-YYYY'))
        and    inn.period_type = 'C'
        and    inn.person_id = c80_s_person_id
                                                            || '_PERSON'
        );*/
        --
        -- 
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed' 
                        ,pt_i_OracleError         => gvt_ReturnMessage       );   

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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;

    END export_all_assignments_m_4;

	PROCEDURE export_all_assignments_m_5
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'EXPORT_ALL_ASSIGNMENTS_M_5'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_ASSIGNMENTS_M_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'ALL_ASSIGNMENTS_M_5';

		lvv_migration_date_from                         VARCHAR2(30); 
        lvv_prev_tax_year_date                          VARCHAR2(30);         
        lvd_migration_date_from                         DATE;
        lvd_prev_tax_year_date                          DATE;   
		lvv_migration_date_to                          VARCHAR2(30); 
        lvd_migration_date_to                          DATE; 

        lv_person_id VARCHAR2(30);


    BEGIN
        --
        --       
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
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0005';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'DATA'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        IF   gvv_ReturnStatus = 'F'
        THEN
            xxmx_utilities_pkg.log_module_message
                (pt_i_ApplicationSuite    => gct_ApplicationSuite
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
        END IF;      
		--
		--
        set_parameters(p_bg_id);
        --
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
                        ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable   || '".'   
                        ,pt_i_OracleError         => gvt_ReturnMessage       );


		--INSERT INTO XXMX_TEST VALUES('export_all_assignments_m_2'||gvd_migration_date_from||' '||gvd_migration_date_to); 
	--	INSERT INTO XXMX_TEST VALUES (lv_person_id);


        INSERT  
        INTO    xxmx_per_assignments_m_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
				,bargaining_unit_code
				,date_probation_end
				,employee_category
				,employment_category
				,establishment_id
				,expense_check_address
				,grade_code
				,position_code
				,grade_ladder_pgm_name
				,hourly_salaried_code
				,internal_building
				,internal_floor 
				,internal_location
				,internal_mailstop
				,internal_office_number
				,job_code
				,labour_union_member_flag
				,location_code
				,job_id
				,location_id
				,position_id
				,ORGANIZATION_ID
				,contract_id
				,grade_id 
				,manager_flag
				,normal_hours
				,frequency
				,notice_period
				,notice_period_uom
				,user_person_type
				,probation_period
				,probation_unit
				,project_title
				,projected_assignment_end
				,spec_ceiling_step
				,WORK_AT_HOME_FLAG
				,time_normal_finish
				,time_normal_start
                ,effective_start_date
                ,effective_end_date
                ,person_id
                ,period_of_service_id
                ,assignment_type
                ,assignment_number
                ,assignment_sequence
                ,assignment_status_type_id
                ,primary_flag
                ,action_code
                ,assignment_name
                ,assignment_status_type
                ,auto_end_flag
                ,effective_sequence
                ,legal_employer_name
                ,legislation_code
                ,primary_work_terms_flag
                ,primary_assignment_flag
                ,primary_work_relation_flag
                ,system_person_type
                ,business_unit_name
                ,action_occurrence_id
                ,position_override_flag
                ,effective_latest_change
                ,allow_asg_override_flag
                ,freeze_start_date
                ,freeze_until_date
                ,assignment_id
				,reason_code
				,job_post_source_name
                ,person_referred_by_id
                ,applicant_rank
                ,posting_content_id
                ,source_type
				,work_terms_assignment_id
				,proposed_worker_type
				,PAYROLLNAME
				,people_group_id
            ,default_code_comb_id
			,personnumber)
		SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,get_target_lookup_code (c72_bargaining_unit_code,'BARGAINING_UNIT_CODE') bargaining_unit_code
				,c17_date_probation_end
				,get_target_lookup_code (c75_employee_category
                                        ,'EMPLOYEE_CATEGORY') employee_category
				,get_target_lookup_code (c76_employment_category
                                        ,'EMP_CAT') employment_category
				,Org_name
				,EXPENSE_CHECK_ADDRESS
				,Grade_Code
				,position_code
				,GRADE_LADDER_PGM_NAME
				,c77_hourly_salaried_code
				,c10_internal_location
				,c10_internal_location
				,c10_internal_location
				,c10_internal_location
				,c10_internal_location
				,job_code
				,c39_labour_union_member_flag
				,location_code
				,to_char(c82_job_id)
				,to_char(c83_location_id)
				,to_char(c84_position_id)
				,Org_id
				,Contract_name
				,to_char(c85_grade_id)
				,c30_manager_flag
				,c52_normal_hours
				,c73_frequency
				,c59_notice_period
				,c74_notice_period_uom
				,USER_PERSON_TYPE
				,c48_probation_period
				,c14_probation_unit
				,c54_project_title
				,c15_projected_assignment_end
				,SPECIAL_CEILING_STEP_NAME
				,c37_work_at_home
				,c40_time_normal_finish
				,c3_time_normal_start
                ,c8_effective_start_date effective_start_date
                , to_date ('31-12-4712','DD-MM-YYYY') effective_end_date
                ,c25_s_person_id person_id
                ,s0_period_of_service_id --|| '_PERIOD_OF_SERVICE' 
                            period_of_service_id
                ,'E' assignment_type
                ,'E'||c14_assignment_number assignment_number
                ,c2_assignment_sequence assignment_sequence
                --,c22_pay_system_status||'_'||c21_per_system_status 
                ,ASSIGNMENT_STATUS_TYPE_ID assignment_status_type_id
                ,c4_primary_flag
                ,'ADD_ASSIGN'
                ,c11_assignment_name assignment_name
                ,'P_ACTIVE_ASSIGN' assignment_status_type
                ,'Y' auto_end_flag	
                ,effective_sequence
                ,Case When business_group_id is NOT NULL THEN 
					xxmx_kit_worker_stg.get_legal_employer_name(business_group_id)
					ELSE 
						NULL
					END "legal_employer"
                ,gvv_leg_code
                ,c9_primary_work_terms_flag primary_work_terms_flag
                ,c7_primary_assignment_flag primary_assignment_flag
                ,c10_primary_work_relation_flag primary_work_relation_flag
                ,SYSTEM_PERSON_TYPE system_person_type
                , business_unit_name
                ,NULL action_occurrence_id
                ,'Y' position_override_flag
                --,'N' position_override_flag
                ,'Y' effective_latest_change
                ,'Y' allow_asg_override_flag
                ,to_date ('01-01-1901','DD-MM-YYYY') freeze_start_date
                ,to_date ('31-12-4712','DD-MM-YYYY') freeze_until_date
                ,c20_assignment_id --|| '_EMP_ASSIGNMENT'
				,change_reason
				,c50_job_post_source_name
                ,c42_person_referred_by_id
                ,c58_applicant_rank
                ,c57_posting_content_id
                ,c79_source_type
				--,'ET'||c14_assignment_number  
                ,c20_assignment_id
				,'E'
				,payroll_name
				,c86_people_group_id
            ,default_code_comb_id
			, c_per_all_assignmen.personnumber
        FROM    xxmx_per_persons_stg xxmx_per_persons_stg		
			,
			(
			SELECT   per_all_assignments_f.assignment_sequence c2_assignment_sequence
                    ,per_all_assignments_f.primary_flag c4_primary_flag
                    ,per_all_assignments_f.primary_flag c7_primary_assignment_flag
                    -- Fix for ADD_ASSIGN Assignment START DATE load Issue.
                    ,per_all_assignments_f.effective_Start_Date c8_effective_start_date
                    ,per_all_assignments_f.primary_flag c9_primary_work_terms_flag
                    ,'Y' c10_primary_work_relation_flag
                    ,per_all_assignments_f.title c11_assignment_name
					, 1 effective_sequence
                    ,per_all_assignments_f.assignment_id c20_assignment_id
                    ,per_person_types.person_type_id c24_person_type_id
                    ,per_all_assignments_f.effective_end_date c12_effective_end_date
                    ,per_assignment_status_types.ASSIGNMENT_STATUS_TYPE_ID
                    ,per_assignment_status_types.pay_system_status c22_pay_system_status
                    ,per_assignment_status_types.per_system_status c21_per_system_status
                    ,per_all_assignments_f.organization_id c17_organization_id
                    ,per_all_assignments_f.person_id c25_s_person_id
					,per_all_Assignments_f.business_Group_id
                    ,per_all_assignments_f.assignment_NUMBER c14_assignment_NUMBER
                    ,per_all_assignments_f.assignment_status_type_id s0_asg_status_type_id
                    ,per_periods_of_service.final_process_date final_process_date
                    ,per_periods_of_service.period_of_service_id s0_period_of_service_id
					,per_all_assignments_f.sal_review_period c2_sal_review_period
                    ,per_all_assignments_f.time_normal_start c3_time_normal_start
                    ,per_all_people_f.internal_location c10_internal_location
                    ,per_all_assignments_f.probation_unit c14_probation_unit
                    ,per_all_assignments_f.projected_assignment_end c15_projected_assignment_end
                    ,per_all_assignments_f.date_probation_end c17_date_probation_end
                    ,per_all_people_f.projected_start_date c18_projected_start_date
                    ,per_all_assignments_f.manager_flag c30_manager_flag
                    ,per_all_assignments_f.work_at_home c37_work_at_home
                    ,per_all_assignments_f.labour_union_member_flag c39_labour_union_member_flag
                    ,per_all_assignments_f.time_normal_finish c40_time_normal_finish
                    ,per_all_assignments_f.person_referred_by_id c42_person_referred_by_id
                    ,per_all_assignments_f.probation_period c48_probation_period
                    ,per_all_assignments_f.job_post_source_name c50_job_post_source_name
                    ,per_all_assignments_f.normal_hours c52_normal_hours
                    ,per_all_assignments_f.project_title c54_project_title
                    ,'Y' c55_primary_work_terms_flag
                    ,NULL c56_default_code_comb_id
                    ,per_all_assignments_f.posting_content_id c57_posting_content_id
                    ,per_all_assignments_f.applicant_rank c58_applicant_rank
                    ,per_all_assignments_f.notice_period c59_notice_period
                    ,per_all_assignments_f.ass_attribute_category c60_ass_attribute_category
                    ,per_all_assignments_f.grade_id c85_grade_id
                    ,per_all_assignments_f.position_id c84_position_id
                    ,per_all_assignments_f.job_id c82_job_id
                    ,per_all_assignments_f.location_id c83_location_id                    
                    ,per_all_assignments_f.people_group_id c86_people_group_id
                    ,per_all_assignments_f.assignment_NUMBER c65_assignment_NUMBER
                    ,per_all_assignments_f.employment_category c76_employment_category
                    ,per_all_assignments_f.frequency c73_frequency
                    ,per_all_assignments_f.sal_review_period_frequency c78_sal_review_period_frequenc
                    ,per_all_assignments_f.source_type c79_source_type
                    ,per_all_assignments_f.bargaining_unit_code c72_bargaining_unit_code
                    ,per_all_assignments_f.hourly_salaried_code c77_hourly_salaried_code
                    ,per_all_assignments_f.contract_id c87_contract_id
                    ,per_all_assignments_f.notice_period_uom c74_notice_period_uom
                    ,per_all_assignments_f.employee_category c75_employee_category
                    ,per_person_types.system_person_type c91_system_person_type
					,per_All_assignments_f.change_reason
					,'ADD_ASSIGN' action_code
                    ,per_all_people_f.first_name || '.' ||  per_all_people_f.last_name  c110_billing_title
                    ,(SELECT Name 
					  FROM per_grades_tl@MXDM_NVIS_EXTRACT 
					  WHERE grade_id = per_All_assignments_f.grade_id) 
					  GRADE_CODE
					,per_all_assignments_f.GRADE_LADDER_PGM_ID
					,per_all_people_f.EXPENSE_CHECK_SEND_TO_ADDRESS "EXPENSE_CHECK_ADDRESS"
					,(SELECT Name 
					  FROM per_jobs_tl@MXDM_NVIS_EXTRACT 
					  WHERE job_id  =  per_All_assignments_f.job_id)
                    JOB_CODE
					,(SELECT location_code 
					  FROM hr_locations_all@MXDM_NVIS_EXTRACT 
					  WHERE location_id  =  per_All_assignments_f.location_id)
                    LOCATION_CODE
					,per_periods_of_service.Date_start
					,(SELECT name 
					  FROM HR_ALL_POSITIONS_F@MXDM_NVIS_EXTRACT  HAPF
					  WHERE position_id = per_All_assignments_f.position_id
					  AND  TRUNC(SYSDATE) BETWEEN HAPF.effective_Start_date AND HAPF.effective_end_date) 
					 POSITION_CODE
					,PER_ALL_ASSIGNMENTS_F.PROJECTED_ASSIGNMENT_END
					,per_person_types.SYSTEM_PERSON_TYPE
					,per_person_types.USER_PERSON_TYPE
                    ,PER_ALL_ASSIGNMENTS_F.SPECIAL_CEILING_STEP_ID
                    ,(SELECT PSP.spinal_point
					from  PER_SPINAL_POINT_STEPS_F@MXDM_NVIS_EXTRACT	PSPSF
						, per_spinal_points@MXDM_NVIS_EXTRACT PSP
						,per_grade_spines_f@MXDM_NVIS_EXTRACT pgsf 
					where Step_id  = PER_ALL_ASSIGNMENTS_F.SPECIAL_CEILING_STEP_ID
					and PSP.spinal_point_id =PSPSF.spinal_point_id
					and  TRUNC(SYSDATE) BETWEEN pgsf.effective_Start_date AND pgsf.effective_end_date				
					AND psp.parent_spine_id = pgsf.parent_spine_id
					and pgsf.grade_id = PER_ALL_ASSIGNMENTS_F.grade_id
					and Trunc(sysdate) between PSPSF.effective_Start_date and PSPSF.effective_end_date)
					  SPECIAL_CEILING_STEP_NAME
					,PER_ALL_ASSIGNMENTS_F.TIME_NORMAL_FINISH
					,PER_ALL_ASSIGNMENTS_F.TIME_NORMAL_START
					,PER_ALL_ASSIGNMENTS_F.PEOPLE_GROUP_ID
                    ,(SELECT GROUP_NAME
					  FROM PAY_PEOPLE_GROUPS@MXDM_NVIS_EXTRACT PPG
                      WHERE PPG.people_group_id = per_all_assignments_f.people_group_id
                      AND PPG.end_date_active IS NULL)
					  PEOPLE_GROUP_NAME
					,(SELECT NAME 
					  FROM per_collective_agreements@MXDM_NVIS_EXTRACT PCA 
					  WHERE  collective_agreement_id = per_All_Assignments_f.COLLECTIVE_AGREEMENT_ID 
					  AND TRUNC(SYSDATE)BETWEEN PCA.Start_Date AND PCA.end_date)
					  COLLECTIVE_AGREEMENT_NAME
					,(SELECT Name 
					  FROM BEN_PGM_F@MXDM_NVIS_EXTRACT BPF
					  WHERE PGM_ID = per_all_assignments_f.GRADE_LADDER_PGM_ID
					  AND TRUNC(SYSDATE) BETWEEN BPF.effective_start_Date AND BPF.effective_end_date)
					GRADE_LADDER_PGM_NAME	
					,(SELECT NAME 
					  FROM HR_ALL_ORGANIZATION_UNITS@MXDM_NVIS_EXTRACT 
					  WHERE organization_id = per_all_assignments_f.Business_group_id
					  AND TRUNC(SYSDATE ) BETWEEN DATE_FROM AND NVL(DATE_TO, '31-DEC-4712'))
					  business_unit_name
					,(SELECT Reference 
					  FROM per_contracts_f@MXDM_NVIS_EXTRACT 
					  WHERE contract_id = per_all_assignments_f.contract_id
					  AND TRUNC(SYSDATE ) BETWEEN effective_Start_date AND NVL(effective_end_date, '31-DEC-4712'))
					  contract_name
					,(SELECT NAME 
					  FROM HR_ALL_ORGANIZATION_UNITS@MXDM_NVIS_EXTRACT 
					  WHERE organization_id = per_all_assignments_f.organization_id
					  AND TRUNC(SYSDATE ) BETWEEN DATE_FROM AND NVL(DATE_TO, '31-DEC-4712'))
					  Org_name
                    ,(SELECT ORGANIZATION_ID 
					  FROM HR_ALL_ORGANIZATION_UNITS@MXDM_NVIS_EXTRACT 
					  WHERE organization_id = per_all_assignments_f.organization_id
					  AND TRUNC(SYSDATE ) BETWEEN DATE_FROM AND NVL(DATE_TO, '31-DEC-4712'))
					  Org_id  
					,(SELECT Payroll_name
					  FROM PAY_PAYROLLS_F@MXDM_NVIS_EXTRACT ppf
					  WHERE PAYROLL_ID = per_all_assignments_f.payroll_id
					  AND trunc(sysdate) BETWEEN ppf.effective_start_date and ppf.effective_end_date)
					  Payroll_name 
                 ,per_all_assignments_f.default_code_comb_id
				 ,per_all_people_f.employee_number personnumber
                FROM    per_person_type_usages_f@MXDM_NVIS_EXTRACT per_person_type_usages_f
                    ,xxmx_hcm_current_asg_scope_mv per_all_assignments_f
                    ,per_assignment_status_types@MXDM_NVIS_EXTRACT per_assignment_status_types
                    ,xxmx_hcm_person_scope_mv per_all_people_f
                    ,per_person_types@MXDM_NVIS_EXTRACT per_person_types
                    ,per_periods_of_service@MXDM_NVIS_EXTRACT per_periods_of_service
                   -- ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
                WHERE  per_all_assignments_f.assignment_type = 'E'
                --AND    per_person_types.system_person_type IN ('EMP','EX_EMP')
                AND     per_all_assignments_f.assignment_status_type_id = per_assignment_status_types.assignment_status_type_id
                and    per_assignment_status_types.USER_STATUS <> 'Terminate and do not process'
                AND    per_all_assignments_f.person_id = per_all_people_f.person_id
                AND    per_all_assignments_f.effective_start_date BETWEEN per_all_people_f.effective_start_date
                                                                        AND     per_all_people_f.effective_end_date
                AND    per_all_assignments_f.person_id = per_person_type_usages_f.person_id
                AND    per_all_assignments_f.effective_start_date BETWEEN per_person_type_usages_f.effective_start_date
                                                                        AND     per_person_type_usages_f.effective_end_date
                AND   per_person_types.person_type_id = per_person_type_usages_f.person_type_id
				and   per_periods_of_service.actual_termination_date IS NULL
				AND    per_all_assignments_f.primary_flag <> 'Y'
				and   per_all_people_f.person_type_id = per_person_types.person_type_id
                AND   per_periods_of_service.person_id = per_all_assignments_f.person_id
				AND per_periods_of_service.period_of_service_id =NVL(per_all_assignments_f.period_of_service_id,per_periods_of_service.period_of_service_id )
             --   AND   (per_all_assignments_f.period_of_service_id is not null AND per_periods_of_service.period_of_service_id =per_all_assignments_f.period_of_service_id)
                AND   per_all_assignments_f.business_group_id = p_bg_id
                AND EXISTS(   SELECT 1
                              FROM PAY_PAYROLLS_F@MXDM_NVIS_EXTRACT ppf
                              WHERE PPF.PAYROLL_ID = per_all_assignments_f.payroll_id
                              AND trunc(sysdate) BETWEEN ppf.effective_start_date and ppf.effective_end_date
                              AND UPPER(PPF.PAYROLL_NAME) IN (SELECT UPPER(PARAMETER_VALUE )
                                                            FROM xxmx_migration_parameters 
                                                            WHERE parameter_code like 'PAYROLL_NAME'
                                                            AND ENABLED_FLAG='Y' )
                            )
				UNION
				SELECT   per_all_assignments_f.assignment_sequence c2_assignment_sequence
                    ,per_all_assignments_f.primary_flag c4_primary_flag
                    ,per_all_assignments_f.primary_flag c7_primary_assignment_flag
                    ,CASE
						WHEN (to_char( per_periods_of_service.Date_start,'MMYYYY')=
							to_char( per_periods_of_service.ACTUAL_TERMINATION_DATE,'MMYYYY'))
						THEN  per_periods_of_service.Date_start
						ELSE 
							trunc((PER_PERIODS_OF_SERVICE.ACTUAL_TERMINATION_DATE),'month') 
						END c8_effective_start_date
                    ,per_all_assignments_f.primary_flag c9_primary_work_terms_flag
                    ,'Y' c10_primary_work_relation_flag
                    ,per_all_assignments_f.title c11_assignment_name
                    ,CASE
						WHEN (to_char( per_periods_of_service.Date_start,'MMYYYY')=
							to_char( per_periods_of_service.ACTUAL_TERMINATION_DATE,'MMYYYY'))
						THEN  2
						ELSE 
								1
						END effective_sequence					
                    ,per_all_assignments_f.assignment_id c20_assignment_id
                    ,per_person_types.person_type_id c24_person_type_id
                    ,per_all_assignments_f.effective_end_date c12_effective_end_date
                    ,per_assignment_status_types.ASSIGNMENT_STATUS_TYPE_ID
                    ,per_assignment_status_types.pay_system_status c22_pay_system_status
                    ,per_assignment_status_types.per_system_status c21_per_system_status
                    ,per_all_assignments_f.organization_id c17_organization_id
                    ,per_all_assignments_f.person_id c25_s_person_id
					,per_all_Assignments_f.business_Group_id
                    ,per_all_assignments_f.assignment_NUMBER c14_assignment_NUMBER
                    ,per_all_assignments_f.assignment_status_type_id s0_asg_status_type_id
                    ,per_periods_of_service.final_process_date final_process_date
                    ,per_periods_of_service.period_of_service_id s0_period_of_service_id
					,per_all_assignments_f.sal_review_period c2_sal_review_period
                    ,per_all_assignments_f.time_normal_start c3_time_normal_start
                    ,per_all_people_f.internal_location c10_internal_location
                    ,per_all_assignments_f.probation_unit c14_probation_unit
                    ,per_all_assignments_f.projected_assignment_end c15_projected_assignment_end
                    ,per_all_assignments_f.date_probation_end c17_date_probation_end
                    ,per_all_people_f.projected_start_date c18_projected_start_date
                    ,per_all_assignments_f.manager_flag c30_manager_flag
                    ,per_all_assignments_f.work_at_home c37_work_at_home
                    ,per_all_assignments_f.labour_union_member_flag c39_labour_union_member_flag
                    ,per_all_assignments_f.time_normal_finish c40_time_normal_finish
                    ,per_all_assignments_f.person_referred_by_id c42_person_referred_by_id
                    ,per_all_assignments_f.probation_period c48_probation_period
                    ,per_all_assignments_f.job_post_source_name c50_job_post_source_name
                    ,per_all_assignments_f.normal_hours c52_normal_hours
                    ,per_all_assignments_f.project_title c54_project_title
                    ,'Y' c55_primary_work_terms_flag
                    ,NULL c56_default_code_comb_id
                    ,per_all_assignments_f.posting_content_id c57_posting_content_id
                    ,per_all_assignments_f.applicant_rank c58_applicant_rank
                    ,per_all_assignments_f.notice_period c59_notice_period
                    ,per_all_assignments_f.ass_attribute_category c60_ass_attribute_category
                    ,per_all_assignments_f.grade_id c85_grade_id
                    ,per_all_assignments_f.position_id c84_position_id
                    ,per_all_assignments_f.job_id c82_job_id
                    ,per_all_assignments_f.location_id c83_location_id                    
                    ,per_all_assignments_f.people_group_id c86_people_group_id
                    ,per_all_assignments_f.assignment_NUMBER c65_assignment_NUMBER
                    ,per_all_assignments_f.employment_category c76_employment_category
                    ,per_all_assignments_f.frequency c73_frequency
                    ,per_all_assignments_f.sal_review_period_frequency c78_sal_review_period_frequenc
                    ,per_all_assignments_f.source_type c79_source_type
                    ,per_all_assignments_f.bargaining_unit_code c72_bargaining_unit_code
                    ,per_all_assignments_f.hourly_salaried_code c77_hourly_salaried_code
                    ,per_all_assignments_f.contract_id c87_contract_id
                    ,per_all_assignments_f.notice_period_uom c74_notice_period_uom
                    ,per_all_assignments_f.employee_category c75_employee_category
                    ,per_person_types.system_person_type c91_system_person_type
					,per_All_assignments_f.change_reason
					,'ADD_ASSIGN' action_code
                    ,per_all_people_f.first_name || '.' ||  per_all_people_f.last_name  c110_billing_title
                    ,(SELECT Name 
					  FROM per_grades_tl@MXDM_NVIS_EXTRACT 
					  WHERE grade_id = per_All_assignments_f.grade_id) 
					  GRADE_CODE
					,per_all_assignments_f.GRADE_LADDER_PGM_ID
					,per_all_people_f.EXPENSE_CHECK_SEND_TO_ADDRESS "EXPENSE_CHECK_ADDRESS"
					,(SELECT Name 
					  FROM per_jobs_tl@MXDM_NVIS_EXTRACT 
					  WHERE job_id  =  per_All_assignments_f.job_id)
                    JOB_CODE
					,(SELECT location_code 
					  FROM hr_locations_all@MXDM_NVIS_EXTRACT 
					  WHERE location_id  =  per_All_assignments_f.location_id)
                    LOCATION_CODE
					,per_periods_of_service.Date_start
					,(SELECT name 
					  FROM HR_ALL_POSITIONS_F@MXDM_NVIS_EXTRACT  HAPF
					  WHERE position_id = per_All_assignments_f.position_id
					  AND  TRUNC(SYSDATE) BETWEEN HAPF.effective_Start_date AND HAPF.effective_end_date) 
					 POSITION_CODE
					,PER_ALL_ASSIGNMENTS_F.PROJECTED_ASSIGNMENT_END
					,per_person_types.SYSTEM_PERSON_TYPE
					,per_person_types.USER_PERSON_TYPE
                    ,PER_ALL_ASSIGNMENTS_F.SPECIAL_CEILING_STEP_ID
                    ,(SELECT PSP.spinal_point
					from  PER_SPINAL_POINT_STEPS_F@MXDM_NVIS_EXTRACT	PSPSF
						, per_spinal_points@MXDM_NVIS_EXTRACT PSP
						,per_grade_spines_f@MXDM_NVIS_EXTRACT pgsf 
					where Step_id  = PER_ALL_ASSIGNMENTS_F.SPECIAL_CEILING_STEP_ID
					and PSP.spinal_point_id =PSPSF.spinal_point_id
					and  TRUNC(SYSDATE) BETWEEN pgsf.effective_Start_date AND pgsf.effective_end_date				
					AND psp.parent_spine_id = pgsf.parent_spine_id
					and pgsf.grade_id = PER_ALL_ASSIGNMENTS_F.grade_id
					and Trunc(sysdate) between PSPSF.effective_Start_date and PSPSF.effective_end_date)
					  SPECIAL_CEILING_STEP_NAME
					,PER_ALL_ASSIGNMENTS_F.TIME_NORMAL_FINISH
					,PER_ALL_ASSIGNMENTS_F.TIME_NORMAL_START
					,PER_ALL_ASSIGNMENTS_F.PEOPLE_GROUP_ID
                    ,(SELECT GROUP_NAME
					  FROM PAY_PEOPLE_GROUPS@MXDM_NVIS_EXTRACT PPG
                      WHERE PPG.people_group_id = per_all_assignments_f.people_group_id
                      AND PPG.end_date_active IS NULL)
					  PEOPLE_GROUP_NAME
					,(SELECT NAME 
					  FROM per_collective_agreements@MXDM_NVIS_EXTRACT PCA 
					  WHERE  collective_agreement_id = per_All_Assignments_f.COLLECTIVE_AGREEMENT_ID 
					  AND TRUNC(SYSDATE)BETWEEN PCA.Start_Date AND PCA.end_date)
					  COLLECTIVE_AGREEMENT_NAME
					,(SELECT Name 
					  FROM BEN_PGM_F@MXDM_NVIS_EXTRACT BPF
					  WHERE PGM_ID = per_all_assignments_f.GRADE_LADDER_PGM_ID
					  AND TRUNC(SYSDATE) BETWEEN BPF.effective_start_Date AND BPF.effective_end_date)
					GRADE_LADDER_PGM_NAME	
					,(SELECT NAME 
					  FROM HR_ALL_ORGANIZATION_UNITS@MXDM_NVIS_EXTRACT 
					  WHERE organization_id = per_all_assignments_f.Business_group_id
					  AND TRUNC(SYSDATE ) BETWEEN DATE_FROM AND NVL(DATE_TO, '31-DEC-4712'))
					  business_unit_name
					,(SELECT Reference 
					  FROM per_contracts_f@MXDM_NVIS_EXTRACT 
					  WHERE contract_id = per_all_assignments_f.contract_id
					  AND TRUNC(SYSDATE ) BETWEEN effective_Start_date AND NVL(effective_end_date, '31-DEC-4712'))
					  contract_name
					,(SELECT NAME 
					  FROM HR_ALL_ORGANIZATION_UNITS@MXDM_NVIS_EXTRACT 
					  WHERE organization_id = per_all_assignments_f.organization_id
					  AND TRUNC(SYSDATE ) BETWEEN DATE_FROM AND NVL(DATE_TO, '31-DEC-4712'))
					  Org_name
                    ,(SELECT organization_id 
					  FROM HR_ALL_ORGANIZATION_UNITS@MXDM_NVIS_EXTRACT 
					  WHERE organization_id = per_all_assignments_f.organization_id
					  AND TRUNC(SYSDATE ) BETWEEN DATE_FROM AND NVL(DATE_TO, '31-DEC-4712'))
					  Org_id  
					,(SELECT Payroll_name
					  FROM PAY_PAYROLLS_F@MXDM_NVIS_EXTRACT ppf
					  WHERE PAYROLL_ID = per_all_assignments_f.payroll_id
					  AND trunc(sysdate) BETWEEN ppf.effective_start_date and ppf.effective_end_date)
					  Payroll_name 
                 ,per_all_assignments_f.default_code_comb_id
				 ,per_all_people_f.employee_number personnumber
                FROM    per_person_type_usages_f@MXDM_NVIS_EXTRACT per_person_type_usages_f
                    ,xxmx_hcm_current_asg_scope_mv per_all_assignments_f
                    ,per_assignment_status_types@MXDM_NVIS_EXTRACT per_assignment_status_types
                    ,xxmx_hcm_person_scope_mv per_all_people_f
                    ,per_person_types@MXDM_NVIS_EXTRACT per_person_types
                    ,per_periods_of_service@MXDM_NVIS_EXTRACT per_periods_of_service
                   -- ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
                WHERE  per_all_assignments_f.assignment_type = 'E'
                --AND    per_person_types.system_person_type IN ('EMP','EX_EMP')
                AND     per_all_assignments_f.assignment_status_type_id = per_assignment_status_types.assignment_status_type_id
                AND    per_all_assignments_f.person_id = per_all_people_f.person_id
                AND    per_all_assignments_f.effective_start_date BETWEEN per_all_people_f.effective_start_date
                                                                        AND     per_all_people_f.effective_end_date
                AND    per_all_assignments_f.person_id = per_person_type_usages_f.person_id
                AND    per_all_assignments_f.effective_start_date BETWEEN per_person_type_usages_f.effective_start_date
                                                                        AND     per_person_type_usages_f.effective_end_date
                AND   per_person_types.person_type_id = per_person_type_usages_f.person_type_id
                and   per_periods_of_service.actual_termination_date IS  NOT NULL
				--AND   per_periods_of_service.actual_termination_date  BETWEEN  TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
                AND   per_periods_of_service.actual_termination_date  BETWEEN  TRUNC(gvd_migration_date_from) AND '31-DEC-4712'
				AND    per_all_assignments_f.primary_flag <> 'Y'
				and   per_all_people_f.person_type_id = per_person_types.person_type_id
                AND   per_periods_of_service.person_id = per_all_assignments_f.person_id
				AND per_periods_of_service.period_of_service_id =NVL(per_all_assignments_f.period_of_service_id,per_periods_of_service.period_of_service_id )
             --   AND   (per_all_assignments_f.period_of_service_id is not null AND per_periods_of_service.period_of_service_id =per_all_assignments_f.period_of_service_id)
                AND   per_all_assignments_f.business_group_id = p_bg_id
                AND EXISTS(   SELECT 1
                              FROM PAY_PAYROLLS_F@MXDM_NVIS_EXTRACT ppf
                              WHERE PPF.PAYROLL_ID = per_all_assignments_f.payroll_id
                              AND trunc(sysdate) BETWEEN ppf.effective_start_date and ppf.effective_end_date
                              AND UPPER(PPF.PAYROLL_NAME) IN (SELECT UPPER(PARAMETER_VALUE )
                                                            FROM xxmx_migration_parameters 
                                                            WHERE parameter_code like 'PAYROLL_NAME'
                                                            AND ENABLED_FLAG='Y' )
                            )
				) c_per_all_assignmen	
        where 
		 xxmx_per_persons_stg.person_id = c25_s_person_id

		;


      /*  SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,c8_effective_start_date effective_start_date
                ,(CASE
                    WHEN    (
                                    c12_effective_end_date = final_process_date
                            AND     c21_per_system_status = 'TERM_ASSIGN'
                            )
                            THEN    to_date ('31-12-4712'
                                            ,'DD-MM-YYYY')
                    ELSE    c12_effective_end_date END) effective_end_date
                ,c25_s_person_id
                    || '_PERSON' person_id
                ,s0_period_of_service_id
                    || '_PERIOD_OF_SERVICE' period_of_service_id
                ,'ET' assignment_type
                ,'EMP_TERM_'
                    || c14_assignment_NUMBER assignment_NUMBER
                ,c2_assignment_sequence assignment_sequence
                ,(CASE
                    WHEN    (
                                    c21_per_system_status = 'TERM_ASSIGN'
                            AND     c22_pay_system_status = 'P'
                            )
                            THEN    v_astat_inactive_p
                    WHEN    (
                                    c21_per_system_status = 'TERM_ASSIGN'
                            AND     c22_pay_system_status = 'D'
                            )
                            THEN    v_astat_inactive_np
                    WHEN    (
                                    c21_per_system_status = 'SUSP_ASSIGN'
                            AND     c22_pay_system_status = 'P'
                            )
                            THEN    v_astat_suspend_p
                    WHEN    (
                                    c21_per_system_status = 'SUSP_ASSIGN'
                            AND     c22_pay_system_status = 'D'
                            )
                            THEN    v_astat_suspend_np
                    WHEN    (
                                    c21_per_system_status = 'ACTIVE_ASSIGN'
                            AND     c22_pay_system_status = 'P'
                            )
                            THEN    v_astat_active_p
                    WHEN    (
                                    c21_per_system_status = 'ACTIVE_ASSIGN'
                            AND     c22_pay_system_status = 'D'
                            )
                            THEN    gvv_astat_active_np
                    ELSE    'N/A' END) assignment_status_type_id
                ,'N' c4_primary_flag
                ,'ASG_CHANGE' action_code
                ,c11_assignment_name assignment_name
                ,(CASE
                    WHEN    (
                                    c21_per_system_status = 'TERM_ASSIGN'
                            AND     c22_pay_system_status = 'P'
                            )
                            THEN    'INACTIVE'
                    WHEN    (
                                    c21_per_system_status = 'TERM_ASSIGN'
                            AND     c22_pay_system_status = 'D'
                            )
                            THEN    'INACTIVE'
                    WHEN    (
                                    c21_per_system_status = 'SUSP_ASSIGN'
                            AND     c22_pay_system_status = 'P'
                            )
                            THEN    'SUSPEND'
                    WHEN    (
                                    c21_per_system_status = 'SUSP_ASSIGN'
                            AND     c22_pay_system_status = 'D'
                            )
                            THEN    'SUSPEND'
                    WHEN    (
                                    c21_per_system_status = 'ACTIVE_ASSIGN'
                            AND     c22_pay_system_status = 'P'
                            )
                            THEN    'ACTIVE'
                    WHEN    (
                                    c21_per_system_status = 'ACTIVE_ASSIGN'
                            AND     c22_pay_system_status = 'D'
                            )
                            THEN    'ACTIVE'
                    ELSE    'N/A' END) assignment_status_type
                ,'Y' auto_end_flag
                ,1 effective_sequence
                ,Case When c17_organization_id is NOT NULL THEN 
					xxmx_kit_worker_stg.get_legal_employer_name(SUBSTR(c17_organization_id,1,INSTR(c17_organization_id,'_',1)-1))
					ELSE 
						NULL
					END "legal_employer"
                ,gvv_leg_code
                ,c9_primary_work_terms_flag primary_work_terms_flag
                ,c7_primary_assignment_flag primary_assignment_flag
                ,c10_primary_work_relation_flag primary_work_relation_flag
                ,'EMP' system_person_type
                    ,v_business_name business_unit_name
                ,NULL action_occurrence_id
                ,'Y' position_override_flag
                ,'Y' effective_latest_change
                ,'Y' allow_asg_override_flag
                ,to_date ('01-01-1901'
                            ,'dd-mm-yyyy') freeze_start_date
                ,to_date ('31-12-4712'
                            ,'dd-mm-yyyy') freeze_until_date
                ,c20_assignment_id
                    || '_EMP_TERM'
        FROM    xxmx_per_persons_stg xxmx_per_persons_stg
                ,(
                SELECT  per_all_assignments_f.assignment_sequence c2_assignment_sequence
                    ,per_all_assignments_f.primary_flag c4_primary_flag
                    ,'Y' c7_primary_assignment_flag
                    ,per_all_assignments_f.effective_start_date c8_effective_start_date
                    ,per_all_assignments_f.primary_flag c9_primary_work_terms_flag
                    ,'Y' c10_primary_work_relation_flag
                    ,per_all_assignments_f.title c11_assignment_name
                    ,per_all_assignments_f.assignment_id c20_assignment_id
                    ,per_person_types.person_type_id c24_person_type_id
                    ,per_all_assignments_f.effective_end_date c12_effective_end_date
                    ,per_assignment_status_types.pay_system_status c22_pay_system_status
                    ,per_assignment_status_types.per_system_status c21_per_system_status
                    ,per_all_assignments_f.organization_id c17_organization_id
                    ,per_all_assignments_f.person_id c25_s_person_id
                    ,per_all_assignments_f.assignment_NUMBER c14_assignment_NUMBER
                    ,per_all_assignments_f.assignment_status_type_id s0_asg_status_type_id
                    ,per_periods_of_service.final_process_date final_process_date
                    ,per_periods_of_service.period_of_service_id s0_period_of_service_id
                FROM    per_person_type_usages_f@MXDM_NVIS_EXTRACT per_person_type_usages_f
                    ,per_all_assignments_f@MXDM_NVIS_EXTRACT per_all_assignments_f
                    ,per_assignment_status_types@MXDM_NVIS_EXTRACT per_assignment_status_types
                    ,per_all_people_f@MXDM_NVIS_EXTRACT per_all_people_f
                    ,per_person_types@MXDM_NVIS_EXTRACT per_person_types
                    ,per_periods_of_service@MXDM_NVIS_EXTRACT per_periods_of_service
                    ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
                WHERE  per_person_types.system_person_type IN ('EMP','EX_EMP')
                AND  per_all_assignments_f.assignment_type = 'E'
                AND  per_all_assignments_f.person_id = per_all_people_f.person_id
                AND  per_all_assignments_f.effective_start_date BETWEEN per_all_people_f.effective_start_date
                                                                        AND     per_all_people_f.effective_end_date
                AND  per_all_assignments_f.person_id = per_person_type_usages_f.person_id
                AND  per_all_assignments_f.effective_start_date BETWEEN per_person_type_usages_f.effective_start_date
                                                                        AND     per_person_type_usages_f.effective_end_date
                AND  per_person_types.person_type_id = per_person_type_usages_f.person_type_id
                AND  per_all_assignments_f.assignment_status_type_id = per_assignment_status_types.assignment_status_type_id
                AND  per_periods_of_service.period_of_service_id = per_all_assignments_f.period_of_service_id
                AND  horg.organization_id = per_periods_of_service.business_group_id
				AND  horg.name = p_bg_name
                ) c_per_all_assignmen
        where      (
                            xxmx_per_persons_stg.person_id = c25_s_person_id

                    )
        and         exists (
        select 1 from xxmx_per_pos_wr_stg inn
        where  inn.period_of_service_id = s0_period_of_service_id
                    || '_PERIOD_OF_SERVICE'
        and    c8_effective_start_date  between inn.date_start and nvl(actual_termination_date,to_date('31-12-4712','DD-MM-YYYY'))
        and    inn.period_type = 'E'
        and    inn.person_id = c25_s_person_id
                                                            || '_PERSON'
        );*/
        --
        -- 
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed' 
                        ,pt_i_OracleError         => gvt_ReturnMessage       );   

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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;
    END export_all_assignments_m_5;


    PROCEDURE export_assign_supervisors_f
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'EXPORT_ASSIGN_SUPERVISORS_F'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_ASG_SUP_F_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'ASSIGN_SUPERVISORS_F';

		lvv_migration_date_to                           VARCHAR2(30); 
		lvv_migration_date_from                         VARCHAR2(30); 
		lvv_prev_tax_year_date                          VARCHAR2(30);         
		lvd_migration_date_to                           DATE;  
		lvd_migration_date_from                         DATE;
		lvd_prev_tax_year_date                          DATE;   

    BEGIN
        --
        --       
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
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0005';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'DATA'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        IF   gvv_ReturnStatus = 'F'
        THEN
            xxmx_utilities_pkg.log_module_message
                (pt_i_ApplicationSuite    => gct_ApplicationSuite
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
        END IF;
        --
        --
        --
        set_parameters(p_bg_id);
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
        FROM    xxmx_per_asg_sup_f_stg
        WHERE   bg_id    = p_bg_id    ;              

        COMMIT;   
        --
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
                        ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable   || '".'   
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
        --   
        INSERT  
        INTO    xxmx_per_asg_sup_f_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,effective_start_date
                ,effective_end_date
                ,assignment_id
                ,person_id
                ,primary_flag
                ,manager_assignment_id
                ,manager_id
                ,manager_type
                ,action_occurrence_id
                ,freeze_start_date
                ,freeze_until_date
                ,assignment_supervisor_id
				,sup_attribute1
				,personnumber
				,assignment_number
				,manager_person_number
				,manager_assignment_number)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				--,C9_effective_start_Date
                ,C10_effective_start_Date
				,C9_effective_end_Date
				,c8_assignment_id --|| decode (c10_assignment_type
									--		,'E'
									--		,'_EMP'
									--		,'_CWK')
								 -- || '_ASSIGNMENT' 
                                 assignment_id
				,C9_personid person_id
				,'Y' primary_flag
				,sup.assignment_id--|| decode (sup.assignment_type
									--		,'E'
									--		,'_EMP'
									--		,'_CWK')
								 -- || '_ASSIGNMENT' 
                                 manager_assignment_id
				,sup.person_id manager_id
				,'LINE_MANAGER' manager_type
				,NULL action_occurrence_id
				,to_date ('01-01-1901','dd-mm-yyyy') freeze_stat_date
				,to_date ('31-12-4712','dd-mm-yyyy') freeze_until_date
				,(SELECT EMPLOYEE_NUMBER--||'_SUP_EMP_NUMBER'
                    FROM PER_ALL_PEOPLE_F@MXDM_NVIS_EXTRACT papf
                    WHERE TRUNC(SYSDATE) BETWEEN papf.effective_start_Date and papf.effective_end_date
                    and person_id = sup.person_id)
				,NULL
				,employee.personnumber
				,employee.c11_assignment_number
				,(select employee_number from per_all_people_f@MXDM_NVIS_EXTRACT ppf
				where person_id = sup.person_id
				and trunc(SYSDATE) between ppf.effective_start_date and ppf.effective_End_date
				and rownum=1)
				,sup.assignment_type||sup.assignment_number
        FROM per_all_Assignments_f@MXDM_NVIS_EXTRACT sup,
        (
				SELECT         
						paaf.person_id  C9_PErsonid, 
						paaf.effective_start_Date C9_effective_start_Date,
                        NVL(asg.effective_start_date ,SYSDATE) C10_effective_start_Date,
						paaf.effective_end_date C9_effective_end_Date,
						paaf.Business_group_id ,
						paaf.supervisor_id, 
						paaf.assignment_id c8_assignment_id, 
						paaf.assignment_type c10_assignment_type,
						asg.personnumber,
						paaf.assignment_type||paaf.assignment_number c11_assignment_number
				FROM xxmx_hcm_current_asg_scope_mv paaf,
                     xxmx_per_assignments_m_stg asg
				WHERE   asg.person_id=   paaf.person_id
                AND asg.action_code IN ('CURRENT','ADD_ASSIGN')

                AND paaf.business_group_id = p_bg_id
				AND exists ( Select 1
							 From xxmx_per_persons_stg xxper
							 where xxper.person_id = paaf.person_id)
                ) Employee
        WHERE sup.person_id = employee.supervisor_id
        AND trunc(sysdate) between sup.effective_start_Date and sup.effective_end_date
		AND sup.business_group_id = p_bg_id
        AND EXISTS (SELECT 1
                    FROM xxmx_per_persons_stg per
                    WHERE per.person_id = sup.person_id)
		;				
				/*
        FROM    xxmx_per_persons_stg xxmx_per_persons_stg
            ,xxmx_per_persons_stg xxmx_per_persons_stg_1
            ,per_all_assignments_f@MXDM_NVIS_EXTRACT per_all_assignments_f1
            ,
                (
                SELECT  per_all_assignments_f.effective_start_date c1_effective_start_date
                    ,
                        (
                        SELECT  max (max.effective_end_date)
                        FROM    per_all_assignments_f@MXDM_NVIS_EXTRACT max
                        START WITH (
                                        max.assignment_id = per_all_assignments_f.assignment_id
                                AND     max.effective_start_date = per_all_assignments_f.effective_start_date
                                AND     max.effective_end_date = per_all_assignments_f.effective_end_date
                                )

                        CONNECT BY PRIOR effective_end_date + 1 = effective_start_date
                        AND     max.effective_end_date <= nvl (xxmx_per_pos_wr_stg.actual_termination_date
                                                            ,to_date ('31-12-4712'
                                                                    ,'DD-MM-YYYY'))
                        AND     nvl (PRIOR supervisor_id
                                    ,- 1) = nvl (supervisor_id
                                                ,- 1)
                        AND     PRIOR assignment_id = assignment_id
                        ) c2_effective_end_date
                    ,per_all_assignments_f.assignment_id c8_assignment_id
                    ,per_all_assignments_f.assignment_type c10_assignment_type
                    ,per_all_assignments_f.supervisor_id c7_supervisor_id
                    ,per_all_assignments_f.person_id c9_person_id
                    ,per_all_assignments_f.last_update_date c6_last_update_date
                    ,per_all_assignments_f.creation_date c5_creation_date
                    ,per_all_assignments_f.assignment_id s0_assignment_id
                FROM    per_all_assignments_f@MXDM_NVIS_EXTRACT per_all_assignments_f
                    ,xxmx_per_pos_wr_stg xxmx_per_pos_wr_stg
                    ,xxmx_per_assignments_m_stg xxmx_per_assignments_m_stg
                    ,hr_all_organization_units@MXDM_NVIS_EXTRACT horg
                WHERE   (
                                horg.organization_id = per_all_assignments_f.business_group_id
                        AND     horg.name = p_bg_name
                        )
                AND     (
                                per_all_assignments_f.assignment_type IN ('E','C')
                        AND     per_all_assignments_f.supervisor_id IS NOT NULL
                        )
                AND     (
                                xxmx_per_assignments_m_stg.assignment_id = per_all_assignments_f.assignment_id
                                                                        || decode (per_all_assignments_f.assignment_type
                                                                                    ,'E'
                                                                                    ,'_EMP'
                                                                                    ,'_CWK')
                                                                        || '_ASSIGNMENT'
                        AND     xxmx_per_assignments_m_stg.assignment_type IN ('E','C')
                        AND     xxmx_per_assignments_m_stg.effective_start_date =  
                                (
                                SELECT  max (effective_start_date)
                                FROM    xxmx_per_assignments_m_stg asg
                                WHERE   asg.assignment_id = xxmx_per_assignments_m_stg.assignment_id
                                )
                        )
                AND     (
                                xxmx_per_pos_wr_stg.period_of_service_id = xxmx_per_assignments_m_stg.period_of_service_id
                        AND     per_all_assignments_f.effective_start_date BETWEEN xxmx_per_pos_wr_stg.date_start
                                                                        AND     nvl (xxmx_per_pos_wr_stg.actual_termination_date
                                                                                    ,to_date ('31-12-4712'
                                                                                                ,'DD-MM-YYYY'))
                        )
                AND     (
                                -- (
                                --         trunc (sysdate) BETWEEN per_all_assignments_f.effective_start_date
                                --                         AND     per_all_assignments_f.effective_end_date
                                -- )
                                (
                                        (
                                        TRUNC(per_all_assignments_f.effective_start_date) BETWEEN 
                                                                TRUNC(lvd_migration_date_from) AND TRUNC(lvd_migration_date_to)
                                        )
                                        OR  (
                                        TRUNC(per_all_assignments_f.effective_end_date) BETWEEN 
                                                                TRUNC(lvd_migration_date_from) AND TRUNC(lvd_migration_date_to)
                                        )
                                        OR  (
                                                TRUNC(per_all_assignments_f.effective_start_date)    < TRUNC(lvd_migration_date_from)
                                        AND TRUNC(per_all_assignments_f.effective_end_date)      > TRUNC(lvd_migration_date_to)
                                        )
                                ) 
                        OR      (
                                        (
                                                NOT EXISTS
                                                    (
                                                    SELECT  1
                                                    FROM    per_all_assignments_f@MXDM_NVIS_EXTRACT inn
                                                    WHERE   inn.assignment_id = per_all_assignments_f.assignment_id
                                                    AND     inn.effective_start_date BETWEEN xxmx_per_pos_wr_stg.date_start
                                                                                    AND     nvl (xxmx_per_pos_wr_stg.actual_termination_date
                                                                                                ,to_date ('31-12-4712'
                                                                                                        ,'DD-MM-YYYY'))
                                                    -- AND     trunc (sysdate) BETWEEN inn.effective_start_date
                                                    --                         AND     inn.effective_end_date
                                                    AND     (
                                                                (
                                                                TRUNC(inn.effective_start_date) BETWEEN 
                                                                                        TRUNC(lvd_migration_date_from) AND TRUNC(lvd_migration_date_to)
                                                                )
                                                                OR  (
                                                                TRUNC(inn.effective_end_date) BETWEEN 
                                                                                        TRUNC(lvd_migration_date_from) AND TRUNC(lvd_migration_date_to)
                                                                )
                                                                OR  (
                                                                        TRUNC(inn.effective_start_date)    < TRUNC(lvd_migration_date_from)
                                                                    AND TRUNC(inn.effective_end_date)      > TRUNC(lvd_migration_date_to)
                                                                )
                                                            )                                                     
                                                    )
                                        AND     (
                                                        per_all_assignments_f.effective_end_date =  
                                                        (
                                                        SELECT  max (paaf1.effective_end_date)
                                                        FROM    per_all_assignments_f@MXDM_NVIS_EXTRACT paaf1
                                                        WHERE   paaf1.assignment_id = per_all_assignments_f.assignment_id
                                                        AND     paaf1.effective_start_date BETWEEN xxmx_per_pos_wr_stg.date_start
                                                                                        AND     nvl (xxmx_per_pos_wr_stg.actual_termination_date
                                                                                                    ,to_date ('31-12-4712'
                                                                                                                ,'DD-MM-YYYY'))
                                                        )
                                                )
                                        )
                                )
                        )
                ) per_assign_supervisors
        WHERE   (
                        xxmx_per_persons_stg_1.person_id = c7_supervisor_id
                                                        || '_PERSON'
                )
        AND     (
                        xxmx_per_persons_stg.person_id = c9_person_id
                                                        || '_PERSON'
                )
        AND     (
                        per_all_assignments_f1.primary_flag = 'Y'
                )
        AND     (
                        per_all_assignments_f1.person_id = c7_supervisor_id
                AND     c1_effective_start_date BETWEEN per_all_assignments_f1.effective_start_date
                                                AND     per_all_assignments_f1.effective_end_date
                )
        ;
		*/

        COMMIT;
        --
        -- 
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed' 
                        ,pt_i_OracleError         => gvt_ReturnMessage       );   

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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;

    END export_assign_supervisors_f;

    PROCEDURE export_all_assign_m_inactive
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_all_assign_m_inactive'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_hrt_cnt_items_b_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'ALL_ASSIGN_M_INACTIVE';

    BEGIN
        --
        --       
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
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0005';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'DATA'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        IF   gvv_ReturnStatus = 'F'
        THEN
            xxmx_utilities_pkg.log_module_message
                (pt_i_ApplicationSuite    => gct_ApplicationSuite
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
        END IF;           
        --
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
                        ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable   || '".'   
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
        -- 
       /* INSERT  
        INTO    xxmx_per_assignments_m_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,effective_start_date
                ,effective_end_date
                ,person_id
                ,period_of_service_id
                ,assignment_type
                ,assignment_NUMBER
                ,assignment_sequence
                ,assignment_status_type_id
                ,primary_flag
                ,assignment_name
                ,Action_code
                ,auto_end_flag
                ,effective_sequence
                ,legislation_code
                ,primary_work_terms_flag
                ,primary_assignment_flag
                ,primary_work_relation_flag
                ,system_person_type
                ,action_occurrence_id
                ,position_override_flag
                ,freeze_start_date
                ,freeze_until_date
                ,assignment_id)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,ppos.date_start
				,to_date ('31-12-4712','DD-MM-YYYY') effective_end_date
				,xxmx_per_assignments_m_stg.person_id person_id
				,xxmx_per_assignments_m_stg.period_of_service_id period_of_service_id
				,xxmx_per_assignments_m_stg.assignment_type assignment_type
				,'E'||SUBSTR(xxmx_per_assignments_m_stg.assignment_NUMBER,
                        REGEXP_INSTR(xxmx_per_assignments_m_stg.assignment_NUMBER, '[[:digit:]]'),
                        length(xxmx_per_assignments_m_stg.assignment_NUMBER))
				--,xxmx_per_assignments_m_stg.assignment_NUMBER assignment_NUMBER
				,xxmx_per_assignments_m_stg.assignment_sequence assignment_sequence
				,'HIRE' action_code
				,xxmx_per_assignments_m_stg.primary_flag primary_flag
				,xxmx_per_assignments_m_stg.assignment_name assignment_name            
				,'Y' auto_end_flag
				,1 
				,gvv_leg_code
				,'N'
				,primary_flag
				,'N'
				,decode (xxmx_per_assignments_m_stg.assignment_type
						,'E'
						,'EMP'
						,'CWK') system_person_type
				,NULL action_occurrence_id
				,'Y' position_override_flag
				,'Y' effective_latest_change
				,'Y' allow_asg_override_flag
				,to_date ('01-01-1901','dd-mm-yyyy') freeze_start_date
				,to_date ('31-12-4712','dd-mm-yyyy') freeze_until_date
				,xxmx_per_assignments_m_stg.assignment_id
        FROM    xxmx_per_assignments_m_stg xxmx_per_assignments_m_stg
			   ,per_periods_of_service@MXDM_NVIS_EXTRACT ppos
        WHERE  bg_id =p_bg_id
		AND xxmx_per_assignments_m_stg.PERIOD_OF_SERVICE_ID= ppos.period_of_service_id||'_PERIOD_OF_SERVICE';
		*/

		INSERT  
        INTO    xxmx_per_assignments_m_stg
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
                ,effective_start_date
                ,effective_end_date
                ,person_id
                ,period_of_service_id
                ,assignment_type
                ,assignment_number
                ,assignment_sequence
                ,action_code
                ,primary_flag
                ,assignment_name
                ,auto_end_flag
                ,effective_sequence
                ,effective_latest_change
				,proposed_worker_type 
				,primary_assignment_flag
				,SYSTEM_PERSON_TYPE
				,USER_PERSON_TYPE
                ,freeze_start_date
                ,freeze_until_date
				,assignment_id
				,PAYROLLNAME
				,business_unit_name
				,work_terms_assignment_id
				,legal_employer_name
				,assignment_status_type
				,assignment_status_type_id
                ,people_group_id
                ,primary_work_terms_flag
				,personnumber
              )
		SELECT  distinct pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
			  	,ppos.date_start
				,to_date ('31-12-4712','DD-MM-YYYY') 
				,xxmx_per_assignments_m_stg.person_id person_id
                ,xxmx_per_assignments_m_stg.period_of_service_id 
                ,xxmx_per_assignments_m_stg.assignment_type 
               	,'E'||SUBSTR(xxmx_per_assignments_m_stg.assignment_number,
                        REGEXP_INSTR(xxmx_per_assignments_m_stg.assignment_NUMBER, '[[:digit:]]'),
                        length(xxmx_per_assignments_m_stg.assignment_number))
				,xxmx_per_assignments_m_stg.assignment_sequence 
				,DECODE( xxmx_per_assignments_m_stg.assignment_type ,
						'E','HIRE',
						'C','ADD_CWK'
						,'HIRE')action_code
				,xxmx_per_assignments_m_stg.primary_flag primary_flag
				,xxmx_per_assignments_m_stg.assignment_name     
                ,'Y'
                ,1 
				,'Y' effective_latest_change
				,'E'
				,xxmx_per_assignments_m_stg.primary_assignment_flag 
				,system_person_type
				,user_person_type
                ,to_date ('01-01-1901','dd-mm-yyyy') freeze_start_date
				,to_date ('31-12-4712','dd-mm-yyyy') freeze_until_date
                ,xxmx_per_assignments_m_stg.assignment_id
				,xxmx_per_assignments_m_stg.PAYROLLNAME
				,xxmx_per_assignments_m_stg.business_unit_name
				,xxmx_per_assignments_m_stg.work_terms_assignment_id
				,xxmx_per_assignments_m_stg.legal_employer_name
				,xxmx_per_assignments_m_stg.assignment_status_type
				,xxmx_per_assignments_m_stg.assignment_status_type_id
                ,xxmx_per_assignments_m_stg.people_group_id
                ,xxmx_per_assignments_m_stg.PRIMARY_ASSIGNMENT_FLAG primary_work_terms_flag
				,xxmx_per_assignments_m_stg.personnumber
        FROM    xxmx_per_assignments_m_stg xxmx_per_assignments_m_stg
			   ,per_periods_of_service@MXDM_NVIS_EXTRACT ppos
        WHERE   xxmx_per_assignments_m_stg.PERIOD_OF_SERVICE_ID= ppos.period_of_service_id||'_PERIOD_OF_SERVICE'
		AND		xxmx_per_assignments_m_stg.primary_flag = 'Y'
		AND 	xxmx_per_assignments_m_stg.bg_id = p_bg_id
		and     xxmx_per_assignments_m_stg.action_code = 'CURRENT'
        UNION
        SELECT  distinct pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
			  	,ppos.date_start
				,to_date ('31-12-4712','DD-MM-YYYY') 
				,xxmx_per_assignments_m_stg.person_id person_id
                ,xxmx_per_assignments_m_stg.period_of_service_id 
                ,xxmx_per_assignments_m_stg.assignment_type 
               	,xxmx_per_assignments_m_stg.assignment_type||SUBSTR(xxmx_per_assignments_m_stg.assignment_number,
                        REGEXP_INSTR(xxmx_per_assignments_m_stg.assignment_NUMBER, '[[:digit:]]'),
                        length(xxmx_per_assignments_m_stg.assignment_number))
				,xxmx_per_assignments_m_stg.assignment_sequence 
				,DECODE( xxmx_per_assignments_m_stg.assignment_type ,
						'E','HIRE',
						'C','ADD_CWK'
						,'HIRE')action_code
				,xxmx_per_assignments_m_stg.primary_flag primary_flag
				,xxmx_per_assignments_m_stg.assignment_name     
                ,'Y'
                ,1 
				,'Y' effective_latest_change
				,'C' -- proposed_worker_type
				,xxmx_per_assignments_m_stg.primary_assignment_flag 
				,system_person_type
				,user_person_type
                ,to_date ('01-01-1901','dd-mm-yyyy') freeze_start_date
				,to_date ('31-12-4712','dd-mm-yyyy') freeze_until_date
                ,xxmx_per_assignments_m_stg.assignment_id
				,xxmx_per_assignments_m_stg.PAYROLLNAME
				,xxmx_per_assignments_m_stg.business_unit_name
				,xxmx_per_assignments_m_stg.work_terms_assignment_id
				,xxmx_per_assignments_m_stg.legal_employer_name
				,xxmx_per_assignments_m_stg.assignment_status_type
				,xxmx_per_assignments_m_stg.assignment_status_type_id
                ,xxmx_per_assignments_m_stg.people_group_id
                ,xxmx_per_assignments_m_stg.PRIMARY_ASSIGNMENT_FLAG primary_work_terms_flag
				,xxmx_per_assignments_m_stg.personnumber
        FROM    xxmx_per_assignments_m_stg xxmx_per_assignments_m_stg
			   ,per_periods_of_placement@MXDM_NVIS_EXTRACT ppos
        WHERE   xxmx_per_assignments_m_stg.PERIOD_OF_SERVICE_ID= ppos.period_of_placement_id||'_PERIOD_OF_PLACEMENT'
		AND		xxmx_per_assignments_m_stg.primary_flag = 'Y'
		AND 	xxmx_per_assignments_m_stg.bg_id = p_bg_id
		and     xxmx_per_assignments_m_stg.action_code = 'CURRENT';

		COMMIT;

        --Update ContractType in assignments table.(specific for SMBC)
        /*UPDATE xxmx_per_assignments_m_stg asg
        Set CONTRACTTYPE = ( Select CONTRACT_TYPE from PQP_ASSIGNMENT_ATTRIBUTES_F@MXDM_NVIS_EXTRACT casg
                     where  casg.assignment_id = TO_NUMBER(SUBSTR(asg.assignment_id ,1,INSTR(asg.assignment_id,'_',1)-1))
                     AND trunc(sysdate) between casg.effective_Start_Date and casg.effective_end_Date 
                    );*/

        --
        -- 
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed' 
                        ,pt_i_OracleError         => gvt_ReturnMessage       );   

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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;
            --
    END export_all_assign_m_inactive;


	--******************************************************
	--***********ASSIGNMENT PERSONAL PAY METHOD*************
	--******************************************************
	PROCEDURE export_asg_pay_method
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_asg_pay_method'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_PAY_METHOD_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'WORKER_ASSG_PAYMETHOD';


    BEGIN
        --
        --       
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
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0005';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'DATA'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        IF   gvv_ReturnStatus = 'F'
        THEN
            xxmx_utilities_pkg.log_module_message
                (pt_i_ApplicationSuite    => gct_ApplicationSuite
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
        DELETE 
        FROM    XXMX_PER_PAY_METHOD_STG
        WHERE   bg_id    = p_bg_id    ;              

        COMMIT;   
        --

        --
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
                        ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable   || '".'   
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
        -- 
        INSERT  
        INTO    XXMX_PER_PAY_METHOD_STG
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
				,assignment_id 	
				,person_id		
				,personnumber
                ,ORG_PAYMENT_METHOD_CODE
				,personal_payment_name	
				,effective_start_date	
				,effective_end_date	
				,assignment_number	
				,legislation_code	
				,payroll_ship_number	
				,payment_amount_type	
				,remaining_amount_flag	
				,org_payment_method_id	
				,bank_account_number	
				,amount			
				,percentage		
				,priority		
				,run_type_id	
				,bank_number
				,bank_name	
				,branch_name	
				,sec_account_ref
				,sort_code
				,currency_code
                ,LEGISLATIVEDATAGROUPNAME
				)
        SELECT   pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,PAAF.Assignment_ID
				,PAPF.person_id
				,papf.employee_number
                ,ORG_PAYMENT_METHOD_NAME
				,ORG_PAYMENT_METHOD_NAME
				,NVL((SELECT a.effective_start_date 
				  FROM xxmx_per_assignments_m_stg a
				  WHERE a.Assignment_number= paaf.assignment_type||paaf.assignment_number
				  AND a.person_id = paaf.person_id
                  AND ROWNUM=1 
				  AND a.Action_code IN('ADD_ASSIGN', 'CURRENT')),SYSDATE)
				,PPPM.effective_end_Date
				,paaf.assignment_type||paaf.assignment_number
				,gvv_leg_code
				,NULL
				,NULL
				,NULL
				,POPM.ORG_PAYMENT_METHOD_ID
				,(Select XXMX_KIT_PERSON_STG.EXPORT_DFF_SEGMENT_VAL 
                                (pea.external_Account_id
                                ,NULL
                                ,'external_Account_id'
                                ,NULL
                                ,'pay_external_accounts'
                                ,FIFSE.application_column_name)
                    FROM FND_ID_FLEXS@MXDM_NVIS_EXTRACT FIF    ,
                         FND_ID_FLEX_SEGMENTS@MXDM_NVIS_EXTRACT FIFSE
                    WHERE FIFSE.APPLICATION_ID = FIF.APPLICATION_ID
                    and FIFSE.ID_FLEX_CODE = FIF.ID_FLEX_CODE
                    and FIF.APPLICATION_TABLE_NAME = 'PAY_EXTERNAL_ACCOUNTS'
                    and UPPER(FIFSE.segment_name) like 'ACCOUNT%NUMBER'
                    and  FIFSE.ID_FLEX_NUM  =PEA.ID_FLEX_NUM 
                ) Account_number	
				,PPPM.AMOUNT
				,PPPM.PERCENTAGE
				,PPPM.PRIORITY
				,PPPM.RUN_TYPE_ID
                ,(Select XXMX_KIT_PERSON_STG.EXPORT_DFF_SEGMENT_VAL 
                                (pea.external_Account_id
                                ,NULL
                                ,'external_Account_id'
                                ,NULL
                                ,'pay_external_accounts'
                                ,FIFSE.application_column_name)
                    FROM FND_ID_FLEXS@MXDM_NVIS_EXTRACT FIF    ,
                         FND_ID_FLEX_SEGMENTS@MXDM_NVIS_EXTRACT FIFSE
                    WHERE FIFSE.APPLICATION_ID = FIF.APPLICATION_ID
                    and FIFSE.ID_FLEX_CODE = FIF.ID_FLEX_CODE
                    and FIF.APPLICATION_TABLE_NAME = 'PAY_EXTERNAL_ACCOUNTS'
                    and UPPER(FIFSE.segment_name) like 'BANK_NAME'
                    and  FIFSE.ID_FLEX_NUM  =PEA.ID_FLEX_NUM 
                )bank_code
                ,(Select XXMX_KIT_PERSON_STG.EXPORT_DFF_SEGMENT_VAL 
                                (pea.external_Account_id
                                ,NULL
                                ,'external_Account_id'
                                ,NULL
                                ,'pay_external_accounts'
                                ,FIFSE.application_column_name)
                    FROM FND_ID_FLEXS@MXDM_NVIS_EXTRACT FIF    ,
                         FND_ID_FLEX_SEGMENTS@MXDM_NVIS_EXTRACT FIFSE
                    WHERE FIFSE.APPLICATION_ID = FIF.APPLICATION_ID
                    and FIFSE.ID_FLEX_CODE = FIF.ID_FLEX_CODE
                    and FIF.APPLICATION_TABLE_NAME = 'PAY_EXTERNAL_ACCOUNTS'
                    and UPPER(FIFSE.segment_name) like 'BANK_NAME'
                    and  FIFSE.ID_FLEX_NUM  =PEA.ID_FLEX_NUM 
                )Bank_Name
                ,NVL((Select XXMX_KIT_PERSON_STG.EXPORT_DFF_SEGMENT_VAL 
                                (pea.external_Account_id
                                ,NULL
                                ,'external_Account_id'
                                ,NULL
                                ,'pay_external_accounts'
                                ,FIFSE.application_column_name)
                    FROM FND_ID_FLEXS@MXDM_NVIS_EXTRACT FIF    ,
                         FND_ID_FLEX_SEGMENTS@MXDM_NVIS_EXTRACT FIFSE
                    WHERE FIFSE.APPLICATION_ID = FIF.APPLICATION_ID
                    and FIFSE.ID_FLEX_CODE = FIF.ID_FLEX_CODE
                    and FIF.APPLICATION_TABLE_NAME = 'PAY_EXTERNAL_ACCOUNTS'
                    and UPPER(FIFSE.segment_name) IN('BANK BRANCH','BRANCH NAME','BRANCH')
                    and  FIFSE.ID_FLEX_NUM  =PEA.ID_FLEX_NUM 
                ),'0')BankBranch_Name
                ,(Select XXMX_KIT_PERSON_STG.EXPORT_DFF_SEGMENT_VAL 
                                (pea.external_Account_id
                                ,NULL
                                ,'external_Account_id'
                                ,NULL
                                ,'pay_external_accounts'
                                ,FIFSE.application_column_name)
                    FROM FND_ID_FLEXS@MXDM_NVIS_EXTRACT FIF    ,
                         FND_ID_FLEX_SEGMENTS@MXDM_NVIS_EXTRACT FIFSE
                    WHERE FIFSE.APPLICATION_ID = FIF.APPLICATION_ID
                    and FIFSE.ID_FLEX_CODE = FIF.ID_FLEX_CODE
                    and FIF.APPLICATION_TABLE_NAME = 'PAY_EXTERNAL_ACCOUNTS'
                    and UPPER(FIFSE.segment_name) like 'BLD SOCIETY ACCOUNT NUMBER'
                    and  FIFSE.ID_FLEX_NUM  =PEA.ID_FLEX_NUM 
                )SOCIETY_NUMBER
                ,(Select XXMX_KIT_PERSON_STG.EXPORT_DFF_SEGMENT_VAL 
                                (pea.external_Account_id
                                ,NULL
                                ,'external_Account_id'
                                ,NULL
                                ,'pay_external_accounts'
                                ,FIFSE.application_column_name)
                    FROM FND_ID_FLEXS@MXDM_NVIS_EXTRACT FIF    ,
                         FND_ID_FLEX_SEGMENTS@MXDM_NVIS_EXTRACT FIFSE
                    WHERE FIFSE.APPLICATION_ID = FIF.APPLICATION_ID
                    and FIFSE.ID_FLEX_CODE = FIF.ID_FLEX_CODE
                    and FIF.APPLICATION_TABLE_NAME = 'PAY_EXTERNAL_ACCOUNTS'
                    and UPPER(FIFSE.segment_name) like 'SORT_CODE'
                    and  FIFSE.ID_FLEX_NUM  =PEA.ID_FLEX_NUM 
                )SORT_CODE
				,POPM.CURRENCY_CODE
                ,'NODATA'
		FROM 
			xxmx_hcm_person_scope_mv papf,
			XXMX_HCM_CURRENT_ASG_SCOPE_MV paaf,
			PAY_PERSONAL_PAYMENT_METHODS_F@MXDM_NVIS_EXTRACT PPPM,
			PAY_ORG_PAYMENT_METHODS_F@MXDM_NVIS_EXTRACT POPM,
			pay_external_accounts@MXDM_NVIS_EXTRACT PEA,
			PAY_PAYMENT_TYPES@MXDM_NVIS_EXTRACT PPT
		WHERE papf.person_id = paaf.person_id
		AND TRUNC(SYSDATE) BETWEEN papf.effective_start_date AND papf.effective_end_date
		AND TRUNC(SYSDATE) BETWEEN paaf.effective_start_date AND paaf.effective_end_date
		and paaf.primary_flag = 'Y'
		AND paaf.effective_start_date BETWEEN PPPM.effective_start_date AND PPPM.effective_end_date
		AND paaf.effective_start_date BETWEEN POPM.effective_start_date AND POPM.effective_end_date
		AND POPM.ORG_PAYMENT_METHOD_ID = PPPM.ORG_PAYMENT_METHOD_ID
		AND PPT.payment_type_id = POPM.payment_type_id
		AND PPPM.assignment_id = PAAF.assignment_id
		AND PAAF.business_group_id = p_bg_id
		AND PEA.external_Account_id = PPPM.external_account_id
        AND exists ( Select 1
							 From xxmx_per_persons_stg xxper
							 where xxper.person_id = papf.person_id)
        AND EXISTS ( SELECT 1
                              FROM xxmx_per_assignments_m_stg a
                              WHERE a.Assignment_number = paaf.assignment_type||paaf.assignment_number
                            )
        --AND PAPF.PER_INFORMATION_CATEGORY in('GB','US')
		;




		UPDATE xxmx_per_pay_method_stg ppm
		SET BANK_NAME = NVL( (Select FLV.meaning
							from fnd_lookup_values@MXDM_NVIS_EXTRACT FLV
							where FLV.lookup_type = 'GB_BANKS'
							 and FLV.lookup_code =ppm.BANK_NAME
							 ) , BANK_NAME)
		, BRANCH_NAME =  NVL( (Select PBB.BRANCH
							from PAY_BANK_BRANCHES@MXDM_NVIS_EXTRACT PBB
							where BRANCH_CODE=ppm.sort_Code
							 )  , BRANCH_NAME)
		WHERE bg_id = p_bg_id
		AND Migration_set_id = pt_i_MigrationSetID
		;
		--
		COMMIT;
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed' 
                        ,pt_i_OracleError         => gvt_ReturnMessage       );   

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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;

    END export_asg_pay_method;


	--******************************************************
	--***********ASSIGNMENT PERSONAL PAY METHOD*************
	--******************************************************
	PROCEDURE export_ext_Bank_Account
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_ext_bank_account'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_EXT_BANK_ACC_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'WORKER_EXT_ACC';


    BEGIN
        --
        --       
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
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0005';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'DATA'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        IF   gvv_ReturnStatus = 'F'
        THEN
            xxmx_utilities_pkg.log_module_message
                (pt_i_ApplicationSuite    => gct_ApplicationSuite
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
        DELETE 
        FROM    XXMX_EXT_BANK_ACC_STG;              

        COMMIT;   
        --

        --
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
                        ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable   || '".'   
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
        -- 
       /* INSERT  
        INTO    XXMX_EXT_BANK_ACC_STG
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
				,bank_account_number
				,bank_number		
				,bank_name			
				,branch_name		
				,currency_code
				,country_code
				,sec_account_ref
				,sort_code 	
				,person_id	
				,person_number	
				,ext_bank_acc_owner
				,externalbankaccountid
				,primary_flag 	
				)
        SELECT  distinct  pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
				,p_bg_id
			    ,ieba.BANK_ACCOUNT_NUM
				,ieb.bank_number
				,ieb.bank_name
				,iebb.BANK_BRANCH_NAME
				,NVL(ieba.currency_code,'GBP')
				,ieba.country_code
				,ieba.SECONDARY_ACCOUNT_REFERENCE		
				,iebb.branch_number  -- Added Sort_code
				,papf.person_id
				,papf.employee_number
				,papf.employee_number
				,ieba.EXT_BANK_ACCOUNT_ID
				,'Y'
		FROM    iby_ext_bank_accounts@MXDM_NVIS_EXTRACT ieba,
				iby_account_owners@MXDM_NVIS_EXTRACT iao,
				iby_ext_banks_v@MXDM_NVIS_EXTRACT ieb,
				iby_ext_bank_branches_v@MXDM_NVIS_EXTRACT iebb,
				HZ_PARTIES@MXDM_NVIS_EXTRACT HZ,
                per_all_people_f@MXDM_NVIS_EXTRACT papf
		WHERE ieba.ext_bank_account_id = iao.ext_bank_account_id
		AND ieb.bank_party_id = iebb.bank_party_id
		AND ieba.branch_id = iebb.branch_party_id
		AND ieba.bank_id = ieb.bank_party_id
		AND HZ.party_id = iao.ACCOUNT_OWNER_PARTY_ID
        AND HZ.party_id = papf.party_id
        AND TRUNC(SYSDATE) BETWEEN papf.effective_start_Date AND papf.effective_end_Date
        AND exists ( Select 1
							 From xxmx_per_persons_stg xxper
							 where xxper.person_id = papf.person_id)
		;*/
		--
		COMMIT;
		--

		INSERT INTO 
				XXMX_EXT_BANK_ACC_STG
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
				,bank_account_number
				,bank_number		
				,bank_name			
				,branch_name		
				,currency_code
				,country_code
				,sec_account_ref
				,sort_code 	
				,person_id	
				,personnumber	
				,ext_bank_acc_owner
				,externalbankaccountid
				,primary_flag 	
				)
        SELECT  distinct  pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
				,p_bg_id
			    ,ppm.bank_account_number
				,ppm.bank_number
				,ppm.bank_name
				,ppm.branch_name
				,currency_code
				,'GB'
				,sec_account_ref		
				,sort_Code -- Added Sort_code
				,ppf.person_id
				,ppf.employee_number
				,ppf.employee_number
				,NULL
				,'Y'
		FROM XXMX_PER_PAY_METHOD_STG ppm
			,xxmx_hcm_person_scope_mv ppf
		WHERE bg_id = p_bg_id
		AND ppf.person_id = ppm.person_id
		AND trunc(sysdate) between ppf.effective_start_date and ppf.effective_end_date
		AND NOT EXISTS (SELECT 1
						FROM XXMX_EXT_BANK_ACC_STG b
						WHERE b.bank_account_number= ppm.bank_account_number
						AND b.person_id = ppm.person_id);

		--
		COMMIT;
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed' 
                        ,pt_i_OracleError         => gvt_ReturnMessage       );   

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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;

    END export_ext_Bank_Account;


	--******************************************
	--***********ASSIGNMENT PAYROLL*************
	--*****************************************
	PROCEDURE export_asg_payroll
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_asg_payroll'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_ASG_PAYROLL_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'WORKER_ASSG_PAYROLL';


    BEGIN
        --
        --       
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
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0005';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'DATA'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        IF   gvv_ReturnStatus = 'F'
        THEN
            xxmx_utilities_pkg.log_module_message
                (pt_i_ApplicationSuite    => gct_ApplicationSuite
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
        END IF;    
        --
        --
        set_parameters(p_bg_id);
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
        FROM    XXMX_ASG_PAYROLL_STG
        WHERE   bg_id    = p_bg_id    ;              

        COMMIT;   
        --
		--

        --
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
                        ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable   || '".'   
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
        -- 
        INSERT  
        INTO    XXMX_ASG_PAYROLL_STG
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
				,person_id
				,assignment_number
				,payroll_name
                ,start_date
				,effective_start_date
				,effective_end_date
                ,assignment_id
				,legislation_code
				,personnumber
				)
        SELECT  distinct  pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,paaf.person_id
				,paaf.assignment_type||paaf.assignment_number
                ,ppf.Payroll_Name
                ,NVL((SELECT a.effective_start_date 
				  FROM xxmx_per_assignments_m_stg a
				  WHERE a.Assignment_number= paaf.assignment_type||paaf.assignment_number
				  AND a.person_id = paaf.person_id
                  and rownum=1
				  AND a.Action_code IN('ADD_ASSIGN', 'CURRENT')),SYSDATE)
				,NVL((SELECT a.effective_start_date 
				  FROM xxmx_per_assignments_m_stg a
				  WHERE a.Assignment_number= paaf.assignment_type||paaf.assignment_number
				  AND a.person_id = paaf.person_id
                  and rownum=1
				  AND a.Action_code IN('ADD_ASSIGN', 'CURRENT')),SYSDATE)
				--,paaf.effective_End_date
                ,gcd_maxOracleDate
				,paaf.assignment_id 
				,gvv_leg_code
				,xxper.personnumber
		FROM xxmx_hcm_current_asg_scope_mv paaf, 
			 PAY_PAYROLLS_F@MXDM_NVIS_EXTRACT ppf,
			 xxmx_per_persons_stg xxper
		WHERE paaf.payroll_id = ppf.payroll_id
		AND paaf.effective_start_date  BETWEEN paaf.effective_Start_date AND paaf.effective_end_date
		AND paaf.business_Group_id = ppf.business_Group_id 
		and paaf.business_Group_id= p_bg_id
		AND xxper.person_id = paaf.person_id
		AND trunc(sysdate) BETWEEN ppf.effective_start_Date AND ppf.effective_end_date
        AND UPPER(PPF.PAYROLL_NAME) IN (SELECT UPPER(PARAMETER_VALUE)
                                            FROM xxmx_migration_parameters 
                                            WHERE parameter_code like 'PAYROLL_NAME'
                                            AND ENABLED_FLAG='Y')
        ;
        --
        COMMIT;
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed' 
                        ,pt_i_OracleError         => gvt_ReturnMessage       );   

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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;

    END export_asg_payroll;

	--******************************************
	--***********ASSIGNMENT SALARY*************
	--*****************************************
	PROCEDURE export_asg_salary
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_asg_SALARY'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_ASG_SALARY_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'WORKER_ASSG_SALARY';

		lv_sal_count NUMBER:=NULL;
    BEGIN
        --
        --       
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
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0005';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'DATA'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        IF   gvv_ReturnStatus = 'F'
        THEN
            xxmx_utilities_pkg.log_module_message
                (pt_i_ApplicationSuite    => gct_ApplicationSuite
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
        END IF;    
        --
        set_parameters(p_bg_id);
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
        DELETE 
        FROM    XXMX_PER_ASG_SALARY_STG
        WHERE   bg_id    = p_bg_id    ;              

        COMMIT;   
        --
		--

        --
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
                        ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable   || '".'   
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
        -- 
		BEGIN 
			SELECT COUNT(*)
			INTO lv_sal_count
			FROM Per_Pay_Bases@MXDM_NVIS_EXTRACT;
		END;


		IF(lv_sal_count <> 0) THEN 
				INSERT  
				INTO    XXMX_PER_ASG_SALARY_STG
						(migration_set_id
						,migration_set_name                   
						,migration_status
						,bg_name
						,bg_id
						,assignment_id 	
						,effective_start_date	
						,effective_end_date	
						,assignment_number	
						,legislation_code	
						,name				
						,pay_basis_type 		
						,multiple_components	
						,approved			
						,proposed_salary		
						,next_sal_review_date 
						,personnumber
				)
				SELECT distinct  pt_i_MigrationSetID                               
						,pt_i_MigrationSetName                               
						,'EXTRACTED'  
						,p_bg_name
						,p_bg_id
						,paaf.assignment_id
						,NVL((SELECT a.effective_start_date 
						  FROM xxmx_per_assignments_m_stg a
						  WHERE a.Assignment_number= paaf.assignment_type||paaf.assignment_number
						  AND a.person_id = paaf.person_id
						  AND a.Action_code IN('ADD_ASSIGN', 'CURRENT')),SYSDATE)
						,ppp.date_to
						,paaf.assignment_type||paaf.assignment_number
						,gvv_leg_code
						,pb.name
						,pb.pay_basis
						,ppp.Multiple_components
						,ppp.Approved
						,ppp.proposed_salary_N
						,Next_sal_review_date
						,(select employee_number from per_all_people_f@MXDM_NVIS_EXTRACT ppf
							where person_id = paaf.person_id
							and trunc(sysdate) between ppf.effective_start_date and ppf.effective_end_date
							and rownum=1)
				from xxmx_hcm_current_asg_scope_mv paaf
					,per_pay_proposals@MXDM_NVIS_EXTRACT ppp
					,Per_Pay_Bases@MXDM_NVIS_EXTRACT PB
				WHERE  paaf.effective_start_date between paaf.effective_start_date and paaf.effective_end_date
				And ppp.Assignment_Id = paaf.Assignment_Id
				AND paaf.effective_start_date between ppp.change_date and ppp.date_to
				And PB.Pay_Basis_Id = paaf.Pay_Basis_Id
				AND paaf.business_group_id = p_bg_id
				AND exists ( Select 1
							 From xxmx_per_persons_stg xxper
							 where xxper.person_id = paaf.person_id)
                AND EXISTS ( SELECT 1
                              FROM xxmx_per_assignments_m_stg a
                              WHERE a.Assignment_number = paaf.assignment_type||paaf.assignment_number
                            )
				;

				--
		ELSE
				INSERT  
				INTO    XXMX_PER_ASG_SALARY_STG
						(migration_set_id
						,migration_set_name                   
						,migration_status
						,bg_name
						,bg_id
						,assignment_id 	
						,effective_start_date	
						,effective_end_date	
						,assignment_number	
						,legislation_code	
						,name				
						,pay_basis_type 		
						,multiple_components	
						,approved			
						,proposed_salary		
						,next_sal_review_date 
						,FTE_VALUE		
						,GRADE_VALUE
						,personnumber
				)
				SELECT  distinct pt_i_MigrationSetID                               
						,pt_i_MigrationSetName                               
						,'EXTRACTED'  
						,p_bg_name
						,p_bg_id
						,paaf.assignment_id
						,NVL((SELECT a.effective_start_date 
						  FROM xxmx_per_assignments_m_stg a
						  WHERE a.Assignment_number= paaf.assignment_type||paaf.assignment_number
						  AND a.person_id = paaf.person_id
						  AND a.Action_code IN('ADD_ASSIGN', 'CURRENT')),SYSDATE)
						,pgrf.EFFECTIVE_END_DATE
						,paaf.assignment_type||paaf.assignment_number
						,gvv_leg_code
						,pr.name
						,pr.rate_type
						,'N'
						,'Y'
						,pgrf.value*pabvf.value
						,NULL
						,pabvf.value
						,pgrf.value
						,papf.employee_number 
			from 
					xxmx_hcm_person_scope_mv                           papf,
					xxmx_hcm_current_asg_scope_mv           		   paaf,
					per_spinal_point_placements_f@MXDM_NVIS_EXTRACT    psppf,
					per_grade_spines_f@MXDM_NVIS_EXTRACT pgsf,
					per_spinal_points@MXDM_NVIS_EXTRACT  PSP,
					per_spinal_point_steps_f@MXDM_NVIS_EXTRACT  PSPSF,
					pay_grade_rules_f@MXDM_NVIS_EXTRACT pgrf,
					pay_rates@MXDM_NVIS_EXTRACT pr,
					XXMX_ASG_WORKMSURE_STG    pabvf
			where   paaf.effective_start_date  BETWEEN papf.effective_start_date AND papf.effective_end_date
			--changes for Issue 
			--AND pgrf.effective_start_date BETWEEN pabvf.effective_Start_date and pabvf.effective_end_Date
			AND pabvf.assignment_id  = paaf.assignment_id
			AND pabvf.unit= 'FTE'
			AND papf.person_id  = paaf.person_id
			AND paaf.business_group_id = p_bg_id
			AND psppf.assignment_id = paaf.assignment_id
            AND EXISTS ( SELECT 1
                          FROM xxmx_per_assignments_m_stg a
                          WHERE a.Assignment_number = paaf.assignment_type||paaf.assignment_number
                         )
			AND trunc(sysdate)  BETWEEN psppf.effective_start_date AND psppf.effective_end_date
			And pgsf.grade_id = paaf.grade_id  
			AND psp.spinal_point_id = pgrf.grade_or_spinal_point_id
			AND trunc(sysdate)  BETWEEN pgsf.effective_start_date AND pgsf.effective_end_date
			AND PSP.spinal_point_id= PSPSF.SPINAL_POINT_ID
			AND PSPSF.STEP_ID = PSPPF.STEP_ID
			AND pr.rate_id = pgrf.rate_id
			AND trunc(sysdate)   BETWEEN pspsf.effective_start_date AND pspsf.effective_end_date
			AND trunc(sysdate)   BETWEEN pspsf.effective_start_date AND pspsf.effective_end_date
			AND trunc(sysdate) BETWEEN pgrf.effective_start_date AND pgrf.effective_end_date
            AND paaf.effective_start_date BETWEEN paaf.effective_start_date AND paaf.effective_end_date
                        --Changed this condition as part of 1.4
	               /* and pgrf.effective_start_date IN( Select MAX(effective_start_date) 
                                                        from pay_grade_rules_f@MXDM_NVIS_EXTRACT pgrf1
                                                        where pgrf1.grade_or_spinal_point_id = pgrf.grade_or_spinal_point_id 
                                                        and pgrf1.rate_id = pgrf.rate_id
                                                        AND ((
                                                            TRUNC(pgrf1.effective_start_date) BETWEEN TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
                                                           )
                                                            OR  
                                                          (
                                                            TRUNC(pgrf1.effective_end_date) BETWEEN  TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
                                                           )
                                                            OR
                                                          (
                                                            TRUNC(pgrf1.effective_start_date)    < TRUNC(gvd_migration_date_from)
                                                            AND TRUNC(pgrf1.effective_end_date)  >  TRUNC(gvd_migration_date_to)
                                                          ))
						)*/;

		END IF;



		/*INSERT  
				INTO    XXMX_PER_ASG_SALARY_STG
						(migration_set_id
						,migration_set_name                   
						,migration_status
						,bg_name
						,bg_id
						,assignment_id 	
						,effective_start_date	
						,effective_end_date	
						,assignment_number	
						,legislation_code	
						,name				
						,pay_basis_type 		
						,multiple_components	
						,approved			
						,proposed_salary		
						,next_sal_review_date 
						,FTE_VALUE		
						,GRADE_VALUE
				)
				SELECT   pt_i_MigrationSetID                               
						,pt_i_MigrationSetName                               
						,'EXTRACTED'  
						,p_bg_name
						,p_bg_id
						,paaf.assignment_id
						,pgrf.EFFECTIVE_START_DATE
						,pgrf.EFFECTIVE_END_DATE
						,paaf.assignment_type||paaf.assignment_number
						,'GB'
						,pr.name
						,pr.rate_type
						,'N'
						,'Y'
						,pgrf.value	*pabvf.value
						,NULL
						,pabvf.value
						,pgrf.value
			from 
					per_all_people_f@MXDM_NVIS_EXTRACT                papf,
					per_all_assignments_f@MXDM_NVIS_EXTRACT    		   paaf,
					per_spinal_point_placements_f@MXDM_NVIS_EXTRACT    psppf,
					per_grade_spines_f@MXDM_NVIS_EXTRACT pgsf,
					per_spinal_points@MXDM_NVIS_EXTRACT  PSP,
					per_spinal_point_steps_f@MXDM_NVIS_EXTRACT  PSPSF,
					pay_grade_rules_f@MXDM_NVIS_EXTRACT pgrf,
					pay_rates@MXDM_NVIS_EXTRACT pr,
					PER_ASSIGNMENT_BUDGET_VALUES_F@MXDM_NVIS_EXTRACT pabvf
			where    TRUNC(SYSDATE)  BETWEEN papf.effective_start_date AND papf.effective_end_date
			AND papf.effective_Start_date BETWEEN pabvf.effective_Start_date and pabvf.effective_end_Date
			and pabvf.assignment_id  = paaf.assignment_id
			and pabvf.unit= 'FTE'
			AND papf.person_id  = paaf.person_id
			AND paaf.business_group_id = p_bg_id
			AND TRUNC(SYSDATE)  BETWEEN paaf.effective_start_date AND paaf.effective_end_date
			and psppf.assignment_id = paaf.assignment_id
			AND TRUNC(SYSDATE)  BETWEEN psppf.effective_start_date AND psppf.effective_end_date
			and pgsf.grade_id = paaf.grade_id  
			AND psp.spinal_point_id = pgrf.grade_or_spinal_point_id
			AND TRUNC(SYSDATE)  BETWEEN pgsf.effective_start_date AND pgsf.effective_end_date
			AND PSP.spinal_point_id= PSPsf.SPINAL_POINT_ID
			AND PSPSF.STEP_ID = PSPPF.STEP_ID
			and pr.rate_id = pgrf.rate_id
			AND TRUNC(SYSDATE)   BETWEEN pspsf.effective_start_date AND pspsf.effective_end_date
			AND TRUNC(SYSDATE) BETWEEN pgrf.effective_start_date AND pgrf.effective_end_date;
*/

        COMMIT;
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed' 
                        ,pt_i_OracleError         => gvt_ReturnMessage       );   

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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;

    END export_asg_salary;


	--******************************************
	--***********ASSIGNMENT GRADESTEP*************
	--*****************************************
	PROCEDURE export_asg_gradestep
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_asg_gradestep'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_ASG_GRADESTEP_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'WORKER_ASSG_GRADESTEP';


    BEGIN
        --
        --       
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
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0005';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'DATA'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        IF   gvv_ReturnStatus = 'F'
        THEN
            xxmx_utilities_pkg.log_module_message
                (pt_i_ApplicationSuite    => gct_ApplicationSuite
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
        END IF;    
        --
        --
        set_parameters(p_bg_id);
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
        FROM    XXMX_ASG_GRADESTEP_STG
        WHERE   bg_id    = p_bg_id    ;              

        COMMIT;   
        --
		--

        --
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
                        ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable   || '".'   
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
        -- 
        INSERT  
        INTO    XXMX_ASG_GRADESTEP_STG
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
				,person_id
				,assignment_number
				,effective_start_date
				,effective_end_date
                ,assignment_id
				,language
				,gradestepid
				,gradestepname
				,NewGradeStep
				,gradeid
				,gradename
				,personnumber
				)
        SELECT distinct  pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,papf.person_id
				,paaf.assignment_type||paaf.assignment_number         
				,psppf.effective_start_date
				,psppf.effective_End_date
				,paaf.assignment_id    
                ,pg.language
                ,psppf.step_id
                ,psp.spinal_point
                ,(SELECT distinct psp1.spinal_point
                    FROM per_spinal_points@MXDM_NVIS_EXTRACT                psp1,
                         per_spinal_point_steps_f@MXDM_NVIS_EXTRACT         pspsf1,
                         pay_grade_rules_f@MXDM_NVIS_EXTRACT                pgrf1
                    WHERE  psp1.parent_spine_id = pgsf.parent_spine_id
                    AND pspsf1.spinal_point_id = psp1.spinal_point_id
                    AND psp1.spinal_point_id = pgrf1.grade_or_spinal_point_id
                    and psp1.sequence = (SELECT MIN(psp2.sequence)
                    FROM
                          per_spinal_points@MXDM_NVIS_EXTRACT           psp2,
                          per_spinal_point_steps_f@MXDM_NVIS_EXTRACT    pspsf2
                    WHERE    pspsf2.grade_spine_id    = pspsf.grade_spine_id
                    AND   pspsf2.spinal_point_id  = psp2.spinal_point_id
                    AND   TRUNC(SYSDATE)  BETWEEN pspsf2.effective_start_date AND pspsf2.effective_end_date
                    AND   psp2.sequence > psp.sequence)   )   NEW_GRADE_STEP
				,pg.grade_id
				,pg.name
				,papf.employee_number
		FROM 
			xxmx_hcm_person_scope_mv                 papf,
			xxmx_hcm_current_asg_scope_mv    		   paaf,
            per_grades_tl@MXDM_NVIS_EXTRACT                       pg,
			per_spinal_point_placements_f@MXDM_NVIS_EXTRACT    psppf,
			per_spinal_point_steps_f@MXDM_NVIS_EXTRACT         pspsf,
			per_spinal_points@MXDM_NVIS_EXTRACT                psp,
			per_grade_spines_f@MXDM_NVIS_EXTRACT               pgsf,
			pay_grade_rules_f@MXDM_NVIS_EXTRACT                pgrf
		WHERE
			  papf.current_employee_flag = 'Y'
         AND paaf.effective_start_date  BETWEEN papf.effective_start_date AND papf.effective_end_date
         AND papf.person_id  = paaf.person_id
         --and paaf.assignment_id IN(316517,522049,20357,47956)
         AND paaf.effective_start_date  BETWEEN paaf.effective_start_date AND paaf.effective_end_date
		 --AND paaf.primary_flag  = 'Y'
         and  psppf.auto_increment_flag = 'Y'
         AND EXISTS ( SELECT 1
                          FROM xxmx_per_assignments_m_stg a
                          WHERE a.Assignment_number = paaf.assignment_type||paaf.assignment_number
                         )
         AND paaf.grade_id  = pg.grade_id
         AND paaf.assignment_id  = psppf.assignment_id
         AND paaf.effective_start_date  BETWEEN psppf.effective_start_date AND psppf.effective_end_date
         AND psppf.step_id  = pspsf.step_id
         AND pspsf.spinal_point_id = psp.spinal_point_id
         AND paaf.effective_start_date   BETWEEN pspsf.effective_start_date AND pspsf.effective_end_date
         AND psp.parent_spine_id = pgsf.parent_spine_id
         and pgsf.grade_id = pg.grade_id
         AND paaf.effective_start_date  BETWEEN pgsf.effective_start_date AND pgsf.effective_end_date
         AND psp.spinal_point_id = pgrf.grade_or_spinal_point_id
		 and papf.business_group_id = p_bg_id
         AND paaf.effective_start_date BETWEEN pgrf.effective_start_date AND pgrf.effective_end_date 
		UNION
		SELECT distinct
				pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
                ,papf.person_id
				,paaf.assignment_type||paaf.assignment_number         
				--,NULL
				--,paaf.effective_End_date
                ,psppf.effective_start_date
				,psppf.effective_End_date
				,paaf.assignment_id    
                ,pg.language
                ,psppf.step_id
                ,psp.spinal_point 
			--changes for Issue 
				,NVL((SELECT distinct psp1.spinal_point
                    FROM per_spinal_points@MXDM_NVIS_EXTRACT                psp1,
                         per_spinal_point_steps_f@MXDM_NVIS_EXTRACT         pspsf1,
                         pay_grade_rules_f@MXDM_NVIS_EXTRACT                pgrf1
                    WHERE  psp1.parent_spine_id = pgsf.parent_spine_id
                    AND pspsf1.spinal_point_id = psp1.spinal_point_id
                    AND psp1.spinal_point_id = pgrf1.grade_or_spinal_point_id
                    and psp1.sequence = (SELECT MIN(psp2.sequence)
                    FROM
                          per_spinal_points@MXDM_NVIS_EXTRACT           psp2,
                          per_spinal_point_steps_f@MXDM_NVIS_EXTRACT    pspsf2
                    WHERE    pspsf2.grade_spine_id    = pspsf.grade_spine_id
                    AND   pspsf2.spinal_point_id  = psp2.spinal_point_id
                    AND   TRUNC(SYSDATE)  BETWEEN pspsf2.effective_start_date AND pspsf2.effective_end_date
                    AND   psp2.sequence > psp.sequence)),psp.spinal_point) NEW_GRADE_STEP
				,pg.grade_id
				,pg.name
				,papf.employee_number
		FROM 
			xxmx_hcm_person_scope_mv                           papf,
			xxmx_hcm_current_asg_scope_mv              		   paaf,
            per_grades_tl@MXDM_NVIS_EXTRACT                       pg,
			per_spinal_point_placements_f@MXDM_NVIS_EXTRACT    psppf,
			per_spinal_point_steps_f@MXDM_NVIS_EXTRACT         pspsf,
			per_spinal_points@MXDM_NVIS_EXTRACT                psp,
			per_grade_spines_f@MXDM_NVIS_EXTRACT               pgsf,
			pay_grade_rules_f@MXDM_NVIS_EXTRACT                pgrf
		WHERE
			  papf.current_employee_flag = 'Y'
         AND paaf.effective_start_date  BETWEEN papf.effective_start_date AND papf.effective_end_date
         AND papf.person_id  = paaf.person_id
         --and paaf.assignment_id IN(316517,522049,20357,47956)
         AND paaf.effective_start_date  BETWEEN paaf.effective_start_date AND paaf.effective_end_date
		-- AND paaf.primary_flag  = 'Y'
         and  psppf.auto_increment_flag = 'N'
         AND EXISTS ( SELECT 1
                          FROM xxmx_per_assignments_m_stg a
                          WHERE a.Assignment_number = paaf.assignment_type||paaf.assignment_number
                         )
         AND paaf.grade_id  = pg.grade_id
         AND paaf.assignment_id  = psppf.assignment_id
         AND Trunc(sysdate)  BETWEEN psppf.effective_start_date AND psppf.effective_end_date
         AND psppf.step_id  = pspsf.step_id
         AND pspsf.spinal_point_id = psp.spinal_point_id
         AND Trunc(sysdate)  BETWEEN pspsf.effective_start_date AND pspsf.effective_end_date
         AND psp.parent_spine_id = pgsf.parent_spine_id
         and pgsf.grade_id = pg.grade_id
         AND Trunc(sysdate)  BETWEEN pgsf.effective_start_date AND pgsf.effective_end_date
         AND psp.spinal_point_id = pgrf.grade_or_spinal_point_id
		 and papf.business_group_id = p_bg_id
         --AND paaf.effective_start_date BETWEEN pgrf.effective_start_date AND pgrf.effective_end_date
         AND Trunc(sysdate) BETWEEN pgrf.effective_start_date AND pgrf.effective_end_date
        ;
        --
        COMMIT;

	DELETE FROM XXMX_ASG_GRADESTEP_STG a
	WHERE NOT EXISTS (Select 1
					 From xxmx_per_persons_stg xxper
					 where xxper.person_id = a.person_id);
	COMMIT;

	UPDATE XXMX_ASG_GRADESTEP_STG ap
	SET effective_start_date = NVL((SELECT a.effective_start_date 
				  FROM xxmx_per_assignments_m_stg a
				  WHERE a.Assignment_number= ap.assignment_number
				  AND a.person_id = ap.person_id
                  AND ROWNUM=1
				  AND a.Action_code IN('ADD_ASSIGN', 'CURRENT')),SYSDATE);
	COMMIT;
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed' 
                        ,pt_i_OracleError         => gvt_ReturnMessage       );   

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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;

    END export_asg_gradestep;


	--******************************************
	--***********ASSIGNMENT WORKMEASURE*************
	--*****************************************
	PROCEDURE export_asg_wrkmsr
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_asg_WRKMSR'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_ASG_WORKMSURE_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'WORKER_ASSG_WRKMSURE';


    BEGIN
        --
        --       
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
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0005';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'DATA'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        IF   gvv_ReturnStatus = 'F'
        THEN
            xxmx_utilities_pkg.log_module_message
                (pt_i_ApplicationSuite    => gct_ApplicationSuite
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
        END IF;    
        --
        --
        set_parameters(p_bg_id);
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
        FROM    XXMX_ASG_WORKMSURE_STG
        WHERE   bg_id    = p_bg_id    ;              

        COMMIT;   
        --
		--

        --
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
                        ,pt_i_ModuleMessage       => 'Extracting data into "' || cv_StagingTable   || '".'   
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
        -- 
        INSERT  
        INTO    XXMX_ASG_WORKMSURE_STG
                (migration_set_id
                ,migration_set_name                   
                ,migration_status
                ,bg_name
                ,bg_id
				,person_id
				,assignment_id
				,assignment_number
				,effective_start_date
				,effective_end_date
				,legislation_code
				,unit
				,value
				,personnumber
				)
        select  distinct pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,paaf.person_id
				,paaf.assignment_id
				,paaf.assignment_type||paaf.assignment_number
				,NVL((SELECT a.effective_start_date 
				  FROM xxmx_per_assignments_m_stg a
				  WHERE a.Assignment_number= paaf.assignment_type||paaf.assignment_number
				  AND a.person_id = paaf.person_id
                  and ROWNUM=1
				  AND a.Action_code IN('ADD_ASSIGN', 'CURRENT')),SYSDATE)
				,pabvf.effective_end_Date
				,gvv_leg_code
                ,pabvf.unit
				,pabvf.value 
				,personnumber
		from per_assignment_budget_values_f@MXDM_NVIS_EXTRACT pabvf, 
			 xxmx_hcm_current_asg_scope_mv paaf,
	         per_assignment_Status_types@MXDM_NVIS_EXTRACT pat ,
			 xxmx_per_persons_stg xxper
		where pabvf.assignment_id = paaf.assignment_id 
        and pat.assignment_status_type_id = paaf.assignment_status_type_id
        AND EXISTS ( SELECT 1
                          FROM xxmx_per_assignments_m_stg a
                          WHERE a.Assignment_number = paaf.assignment_type||paaf.assignment_number
                         )
		and pabvf.effective_start_date IN( Select MAX(effective_start_date) 
                                             from per_assignment_budget_values_f@MXDM_NVIS_EXTRACT pabvf1
                                             where 
                                              pabvf1.assignment_id = paaf.assignment_id
                                              and pabvf.unit = pabvf1.unit
                                              AND ((
													TRUNC(pabvf1.effective_start_date) BETWEEN TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
												   )
													OR  
												  (
													TRUNC(pabvf1.effective_end_date) BETWEEN TRUNC(gvd_migration_date_from) AND TRUNC(gvd_migration_date_to)
												   )
													OR
												  (
													TRUNC(pabvf1.effective_start_date)    <TRUNC(gvd_migration_date_from)
													AND TRUNC(pabvf1.effective_end_date)  >  TRUNC(gvd_migration_date_to)
												  ))
										)
       	and paaf.business_Group_id = pabvf.business_group_id 
		and paaf.business_Group_id = p_bg_id
        And pat.per_system_status NOT IN( 'TERM_ASSIGN')
		and paaf.assignment_number is not null
		AND xxper.person_id = paaf.person_id
       ;
	--
        COMMIT;
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed' 
                        ,pt_i_OracleError         => gvt_ReturnMessage       );   

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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;

    END export_asg_WRKMSR;


	/****************************************************************	
	----------------Export Seniority Date Information-------------------------
	*****************************************************************/

    PROCEDURE export_Senioritydt
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_Seniority_date'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'xxmx_per_senioritydt_stg';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSONS_SENORITY_DATE';



        e_DateError                         EXCEPTION;
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
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0005';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite     => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_MessageType         => 'DATA'
            ,pv_o_ReturnStatus        => gvv_ReturnStatus
            );
        IF   gvv_ReturnStatus = 'F'
        THEN
            xxmx_utilities_pkg.log_module_message
                (pt_i_ApplicationSuite    => gct_ApplicationSuite
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
        END IF;
        --
        set_parameters(p_bg_id);
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
        FROM    xxmx_per_senioritydt_stg    
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;
        --

        INSERT  
        INTO    XXMX_PER_SENIORITYDT_STG
		(
                migration_set_id 	,
				migration_set_name 		,
				migration_status		,
				bg_name   				, 
				bg_id            		,			    
				personnumber 			,
				LEGISLATION_CODE 		, 
				senioritydatecode   	,
				entrydate 				,
				effectivestartdate 		,
				effectiveenddate		,
				businessunitshortcode 	,
				manualadjustmentdays 	, 
				manualadjustmentcomments ,
				legalemployername		 , 
				datestart 				 , 
				workertype 				 , 
				personid,
				payrollname
				)
        SELECT  distinct pt_i_MigrationSetID                               
                ,pt_i_MigrationSetName                               
                ,'EXTRACTED'  
                ,p_bg_name
                ,p_bg_id
				,employee_number
				,gvv_leg_code
				,'ENTERPRISE'
				,PPOS.Date_start
				,PPOS.Date_start
				,'31-DEC-4712'
				,NULL
				,trunc(SYSDATE- ppos.date_Start)
				,'Date Correction'
				,NULL
				,PPOS.Date_start
				,'E'
				,papf.person_id
			    ,(SELECT PAYROLLNAME
				FROM xxmx_per_assignments_m_stg asg
				WHERE asg.PERSON_ID = PAPF.PERSON_ID
				AND ACTION_CODE = 'HIRE'
                and ROWNUM=1
				)
		FROM xxmx_hcm_person_scope_mv PAPF,
			per_periods_of_Service@MXDM_NVIS_EXTRACT PPOS,
			xxmx_per_persons_stg xxper
		WHERE PAPF.person_id =PPOS.person_id
		--and  papf.effective_Start_Date BETWEEN PPOS.effective_Start_Date and PPOS.effective_end_date
		AND papf.business_Group_id= p_bg_id
		AND xxper.person_id = papf.person_id
		ORDER BY employee_number
		;		
        --
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
                        ,pt_i_ModuleMessage       => 'End of extraction at ' || to_char(systimestamp,'YYYY-MM-DD HH24:MI:SS.FF2') || '. Procedure completed'
                        ,pt_i_OracleError         => gvt_ReturnMessage       );     

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
        WHEN e_DateError THEN
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
                    ,pt_i_ModuleMessage       => 'From, to or Prev Tax Year variable not populated'  
                    ,pt_i_OracleError         => gvt_ReturnMessage       );     
            --
            RAISE;          

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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;
    END export_Senioritydt;


        PROCEDURE export_assignments
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          NUMBER
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'PERSON_ASSIGNMENTS'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_PER_ASSIGNMENTS_M_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PERSON_ASSIGNMENTS';

    BEGIN

        export_all_assignments_m_1 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);

        export_all_assignments_m_2 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);


        export_all_assignments_m_4 (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);


        export_all_assign_m_inactive (p_bg_name, p_bg_id, pt_i_MigrationSetID, pt_i_MigrationSetName);

       EXCEPTION  
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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;


    END export_assignments;



    --*******************
    --** PROCEDURE: purge
    --*******************
    --
    PROCEDURE purge
                    (
                    pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    )
    IS
        --
        --
        cv_ProcOrFuncName                   CONSTANT      VARCHAR2(30) := 'purge'; 
        ct_Phase                            CONSTANT      xxmx_module_messages.phase%TYPE  := 'CORE';
        cv_i_BusinessEntityLevel            CONSTANT      VARCHAR2(100) DEFAULT 'PERSON PURGE';
        --
        e_ModuleError                   EXCEPTION;
        --

    BEGIN
        --
        --
        gvv_ProgressIndicator := '0010';
        --
        --
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        --
        --
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
        --
        IF   gvv_ReturnStatus = 'F'
        THEN
                --
                --
                xxmx_utilities_pkg.log_module_message
                    (pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError         => gvt_ReturnMessage
                    );
                --
                --
                RAISE e_ModuleError;
                --
                --
        END IF;
        --
        --
        gvv_ProgressIndicator := '0020';
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => 'Procedure "'
                                        ||gcv_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" initiated.'
            ,pt_i_OracleError         => NULL
            );
        --
        --
        IF   pt_i_MigrationSetID IS NULL
        THEN
                --
                --
                gvt_Severity      := 'ERROR';
                gvt_ModuleMessage := '- "pt_i_MigrationSetID" parameter is mandatory.';
                --
                --
                RAISE e_ModuleError;
                --
                --
        END IF;
        --
        --
        xxmx_utilities_pkg.log_module_message
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => '- Purging tables.'
            ,pt_i_OracleError         => NULL
            );
        --
        --
        gvv_ProgressIndicator := '0030';
        --
        --
        DELETE
        FROM   xxmx_per_pos_wr_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
                 (pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_per_pos_wr_stg" table: '    ||gvn_RowCount
                ,pt_i_OracleError         => NULL
                );
        --
        --
        gvv_ProgressIndicator := '0040';
        --
        --          
        DELETE
        FROM   xxmx_per_assignments_m_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
                 (pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_per_assignments_m_stg" table: '    ||gvn_RowCount
                ,pt_i_OracleError         => NULL
                );
        --
        --
        gvv_ProgressIndicator := '0050';
        --
        --          
        DELETE
        FROM   xxmx_per_asg_sup_f_stg
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
                 (pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => '  - Records purged from "xxmx_per_asg_sup_f_stg" table: '    ||gvn_RowCount
                ,pt_i_OracleError         => NULL
                );
        --
        --
        gvv_ProgressIndicator := '0060';
        --
        --          
        DELETE
        FROM   xxmx_migration_details
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
                 (pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => '  - Records purged from "XXMX_MIGRATION_DETAILS" table: '    ||gvn_RowCount
                ,pt_i_OracleError         => NULL
                );
        --
        --
        gvv_ProgressIndicator := '0070';
        --
        --          
        DELETE
        FROM   xxmx_migration_headers
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
                 (pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => '  - Records purged from "XXMX_MIGRATION_HEADERS" table: '    ||gvn_RowCount
                ,pt_i_OracleError         => NULL
                );
        --
        --
		--
        --
        gvv_ProgressIndicator := '0080';
        --
        --          
        DELETE
        FROM   XXMX_ASG_PAYROLL_STG
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
                 (pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => '  - Records purged from "XXMX_ASG_PAYROLL_STG" table: '    ||gvn_RowCount
                ,pt_i_OracleError         => NULL
                );
		--
        --
        gvv_ProgressIndicator := '0090';
        --
        --          
        DELETE
        FROM   XXMX_PER_PAY_METHOD_STG
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
                 (pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => '  - Records purged from "XXMX_PER_PAY_METHOD_STG" table: '    ||gvn_RowCount
                ,pt_i_OracleError         => NULL
                );
		--
        --
        gvv_ProgressIndicator := '0100';
        --
        --          
        DELETE
        FROM   XXMX_PER_ASG_SALARY_STG
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
                 (pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => '  - Records purged from "XXMX_PER_ASG_SALARY_STG" table: '    ||gvn_RowCount
                ,pt_i_OracleError         => NULL
                );

		--
        --
        gvv_ProgressIndicator := '0110';
        --
        --          
        DELETE
        FROM   XXMX_ASG_WORKMSURE_STG
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
                 (pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => '  - Records purged from "XXMX_ASG_WORKMSURE_STG" table: '    ||gvn_RowCount
                ,pt_i_OracleError         => NULL
                );
		--
        --
        gvv_ProgressIndicator := '0120';
        --
        --          
        DELETE
        FROM   XXMX_ASG_GRADESTEP_STG
        WHERE  migration_set_id = pt_i_MigrationSetID;
        --
        --
        gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
                 (pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => '  - Records purged from "XXMX_ASG_GRADESTEP_STG" table: '    ||gvn_RowCount
                ,pt_i_OracleError         => NULL
                );
		--
		--
		DELETE 
        FROM    xxmx_per_senioritydt_stg
		WHERE  migration_set_id = pt_i_MigrationSetID;		
		--
		gvn_RowCount := SQL%ROWCOUNT;
        --
        --
        xxmx_utilities_pkg.log_module_message
                 (pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => '  - Records purged from "XXMX_PER_SENIORITYDT_STG" table: '    ||gvn_RowCount
                ,pt_i_OracleError         => NULL
                );

		--
        xxmx_utilities_pkg.log_module_message
                 (pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => '- Purging complete.'
                ,pt_i_OracleError         => NULL
                );
        --
        --
        COMMIT;
        --
        --
        xxmx_utilities_pkg.log_module_message
                 (pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_Phase               => ct_Phase
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => 'Procedure "'
                                        ||gcv_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" completed.'
                ,pt_i_OracleError         => NULL
                );
        --
        --
        EXCEPTION
                --
                --
                WHEN OTHERS
                THEN
                    --
                    --
                    ROLLBACK;
                    --
                    --
                    gvt_OracleError := SUBSTR(
                                            SQLERRM
                                            ||'** ERROR_BACKTRACE: '
                                            ||dbms_utility.format_error_backtrace
                                            ,1
                                            ,4000
                                            );
                    --
                    --
                    xxmx_utilities_pkg.log_module_message
                        (pt_i_ApplicationSuite    => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'ERROR'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                        ,pt_i_OracleError         => gvt_OracleError
                        );
                    --
                    --
                    RAISE;
                    --
                    --
                --** END OTHERS Exception
                --
                --
        --** END Exception Handler
        --
        --
    END purge; 
END xxmx_kit_worker_stg;
/
