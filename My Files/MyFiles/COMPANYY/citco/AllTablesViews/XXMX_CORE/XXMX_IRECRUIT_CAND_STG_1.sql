--------------------------------------------------------
--  DDL for Package Body XXMX_IRECRUIT_CAND_STG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_IRECRUIT_CAND_STG" AS
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
--** FILENAME  :  xxmx_irecruit_cand_stg.sql
--**
--** FILEPATH  :  $XXV1_TOP/install/sql
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  APPS
--**
--** AUTHORS   :  Shireesha T.R
--**
--** PURPOSE   :  This package contains procedures for extracting IRecruitment into Staging tables

	/****************************************************************
	----------------Export IRecruitment Information-------------------------
	*****************************************************************/
    gvv_ReturnStatus                          VARCHAR2(1);
    gvt_ReturnMessage                         xxmx_module_messages.module_message%TYPE;
    gvv_ProgressIndicator                     VARCHAR2(100);
    gcv_PackageName                           CONSTANT  VARCHAR2(30)                                := 'xxmx_irecruit_cand_stg';
    gct_ApplicationSuite                      CONSTANT  xxmx_module_messages.application_suite%TYPE := 'HCM';
    gct_Application                           CONSTANT  xxmx_module_messages.application%TYPE       := 'IREC';
    gv_i_BusinessEntity                       CONSTANT  VARCHAR2(100)                               := 'CANDIDATE';
    ct_Phase                                  CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
    cv_i_BusinessEntityLevel                  CONSTANT  VARCHAR2(100)                               := 'ALL';
    gv_hr_date					              DATE                                                  := '31-DEC-4712';
	--pt_i_MigrationSetName                     VARCHAR2(100)                                         := 'IRecruitment '||to_char(SYSDATE, 'DD/MM/YYYY');  --no hard code
	p_bg_name								  VARCHAR2(100)                                         := 'TEST_BG';
    gvt_Severity                              xxmx_module_messages.severity%TYPE;
    gvt_ModuleMessage                         xxmx_module_messages.module_message%TYPE;
    gvt_OracleError                           xxmx_module_messages.oracle_error%TYPE;
    gvv_leg_code                VARCHAR2(100);

    E_MODULEERROR                              EXCEPTION;
    gvv_migration_date_from                    VARCHAR2(30);
	gvv_prev_tax_year_date                     VARCHAR2(30);
	gvd_migration_date_from                    DATE;
	gvd_prev_tax_year_date                     DATE;
	gvv_migration_date_to                      VARCHAR2(30);
	gvd_migration_date_to                      DATE;
    gvt_user_person_type                       xxmx_migration_parameters.PARAMETER_VALUE%TYPE;

    PROCEDURE set_parameters (pt_i_MigrationSetID IN xxmx_migration_headers.migration_set_id%TYPE)
    IS
        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'set_parameters';
    BEGIN


         gvv_migration_date_from := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'ALL'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'MIGRATE_DATE_FROM');


        gvd_migration_date_from := TO_DATE(gvv_migration_date_from,'YYYY-MM-DD');

        gvv_ProgressIndicator := '0021';
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
            ,pt_i_ModuleMessage       => 'Parameter for Irec Extract'||gvd_migration_date_from,
             pt_i_OracleError         => NULL
        );
         --
        gvv_migration_date_to := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application               =>     gct_Application
                        ,pt_i_BusinessEntity            =>     'ALL'
                        ,pt_i_SubEntity                 =>     'ALL'
                        ,pt_i_ParameterCode             =>     'MIGRATE_DATE_TO');

        gvd_migration_date_to := TO_DATE(gvv_migration_date_to,'YYYY-MM-DD');

        gvv_ProgressIndicator := '0021';
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
            ,pt_i_ModuleMessage       => 'Parameter for Irec Extract'||gvd_migration_date_to,
             pt_i_OracleError         => NULL
        );
    END;

    PROCEDURE   stg_main (    pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                            ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE )
    IS

        CURSOR METADATA_CUR
        IS
            SELECT  Entity_package_name,Stg_procedure_name, BUSINESS_ENTITY,SUB_ENTITY_SEQ
			FROM     xxmx_migration_metadata a
			WHERE application_suite = gct_ApplicationSuite
            AND Application = gct_Application
            AND business_entity = gv_i_BusinessEntity
			AND a.enabled_flag = 'Y'
            Order by Business_entity_seq, Sub_entity_seq;

        CURSOR BG_CUR
        IS
         SELECT DISTINCT
                    haou.organization_id,
                    haou.name
            FROM    apps.hr_all_organization_units@MXDM_NVIS_EXTRACT    haou
                  ,apps.hr_organization_information@MXDM_NVIS_EXTRACT  hoi
           WHERE   1 = 1
           AND     hoi.organization_id   = haou.organization_id
           AND     hoi.org_information1  = 'HR_BG'
           AND     haou.name            IN (
                                            SELECT xp.parameter_value
                                            FROM   xxmx_migration_parameters  xp
                                            WHERE  1 = 1
                                            AND    xp.application_suite      = 'HCM'
                                            AND    xp.application            = 'HR'
                                            AND    xp.business_entity        = 'ALL'
                                            AND    xp.sub_entity             = 'ALL'
                                            AND    xp.parameter_code         = 'BUSINESS_GROUP_NAME'
                                            AND    NVL(xp.enabled_flag, 'N') = 'Y'
                        		);

    lv_sql VARCHAR2(32000);
    e_DateError                         EXCEPTION;

    l_leg_code VARCHAR2(1000);
    l_bg_name VARCHAR2(1000);
    l_bg_id NUMBER;

    cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'stg_main';
    ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
    cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT '';
    cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'RUN EXTRACT';

    vt_MigrationSetID                           xxmx_migration_headers.migration_set_id%TYPE;
    pt_i_MigrationSetID                         xxmx_migration_headers.migration_set_id%TYPE;
    vt_BusinessEntitySeq                        xxmx_migration_metadata.business_entity_seq%TYPE;


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
                        ,pt_i_MigrationSetID      => vt_MigrationSetID
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
            ,pt_i_MigrationSetID      => vt_MigrationSetID
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => 'Parameter for Irec Extract',
             pt_i_OracleError         => NULL
        );

      --
       set_parameters (vt_MigrationSetID);

        gvv_ProgressIndicator := '0021';
        xxmx_utilities_pkg.log_module_message(
            pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_MigrationSetID      => vt_MigrationSetID
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => 'Parameter for Irec Extract'||gvd_migration_date_to,
             pt_i_OracleError         => NULL
        );

      	/*gvt_user_person_type := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite            =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'CANDIDATE'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'PERSON_TYPE');  */


        gvv_ProgressIndicator := '0025';
        xxmx_utilities_pkg.log_module_message(
            pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_MigrationSetID      => vt_MigrationSetID
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => 'Call to Irecruitment Extracts',
             pt_i_OracleError         => NULL
        );

     FOR BG_REC IN BG_CUR LOOP -- 10

        l_bg_name := NULL;
        l_bg_id := NULL;
        l_bg_name := BG_REC.name;
        l_bg_id := BG_REC.organization_id;

        FOR METADATA_REC IN METADATA_CUR -- 2
        LOOP

--                dbms_output.put_line(' #' ||r_package_name.v_package ||' #'|| l_bg_name || '  #' || l_bg_id || '  #' || vt_MigrationSetID || '  #' || pt_i_MigrationSetName  );

                    lv_sql:= 'BEGIN '
                            ||METADATA_REC.Entity_package_name
                            ||'.'||METADATA_REC.Stg_procedure_name
                            ||'('||''''|| l_bg_name
                            ||''','
                            ||l_bg_id
                            ||','
                            ||vt_MigrationSetID
                            ||','''
                            ||pt_i_MigrationSetName
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
                        ,pt_i_ModuleMessage       => lv_sql       ,
                        pt_i_OracleError         => NULL
                     );
                    DBMS_OUTPUT.PUT_LINE(lv_sql);

        END LOOP;

    END LOOP;
    EXCEPTION
        WHEN e_ModuleError THEN
                --
        xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_MigrationSetID      => vt_MigrationSetID
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
                    ,pt_i_MigrationSetID      => vt_MigrationSetID
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
                    ,pt_i_MigrationSetID      => vt_MigrationSetID
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


    END stg_main;

    PROCEDURE export_irecruit_cand
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE )  IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_irecruit_cand';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_HCM_IREC_CAN_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'CANDIDATE';

        lvv_migration_date_to                           VARCHAR2(30);
        lvv_migration_date_from                         VARCHAR2(30);
        lvv_prev_tax_year_date                          VARCHAR2(30);
        lvd_migration_date_to                           DATE;
        lvd_migration_date_from                         DATE;
        lvd_prev_tax_year_date                          DATE;

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
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
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
        set_parameters (pt_i_MigrationSetID);

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
        DELETE
        FROM    XXMX_HCM_IREC_CAN_STG
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;

		INSERT
        INTO    XXMX_HCM_IREC_CAN_STG
               ( FILE_SET_ID					,
				MIGRATION_SET_ID 				,
				MIGRATION_SET_NAME 				,
				MIGRATION_STATUS				,
				BG_NAME   						,
				BG_ID            				,
				METADATA						,
				OBJECTNAME						,
				---                             ,
				PERSON_ID						,
				CANDIDATE_NUMBER				,
				OBJECT_STATUS					,
				PREF_PHONE_CNT_TYPE_CODE		,
				AVAILABILITY_DATE				,
				SEARCH_DATE						,
				CAND_LAST_MODIFIED_DATE			,
				ADDED_BY_FLOW_CODE				,
				CONFIRMED_FLAG					,
				VISIBLE_TO_CANDIDATE_FLAG		,
				START_DATE						,
				DATE_OF_BIRTH					,
				DATE_OF_DEATH					,
				COUNTRY_OF_BIRTH				,
				REGION_OF_BIRTH					,
				TOWN_OF_BIRTH					,
				OPT_IN_MKT_EMAILS_DATE			,
				OPT_IN_MKT_EMAILS_FLAG			,
				CAND_PREF_LANGUAGE_CODE			,
				SOURCE							,
				SOURCE_MEDIUM					,
				ADD_TO_POOL_NAME				,
				POOL_OWNER_PERSON_NUMBER		,
				POOL_OWNER_PERSON_ID			,
				CATEGORY_CODE					,
				PHONE_VERIFIED_FLAG
			)
        SELECT
				NULL
				,pt_i_MigrationSetID
				,pt_i_MigrationSetName
				,'EXTRACTED'
		        ,p_bg_name
				,p_bg_id
                ,'MERGE'
                ,'Candidate'
				,Null
				,ppf.APPLICANT_NUMBER AS CANDIDATE_NUMBER
				,'ACTIVE'
				,NULL
				,ppf.effective_start_date AS Availability_Date
				,ppf.effective_start_date AS SEARCH_DATE
				,ppf.date_employee_data_verified as CandLastModifiedDate
				,NULL
				--,'YES'
                ,'Y'
				,NULL
				,ppf.start_date
				,ppf.date_of_birth
				,ppf.date_of_death
				,country_of_birth
				,ppf.region_of_birth
				,ppf.town_of_birth
				,NULL
				,NULL
				,NVL(ppf.correspondence_language,'US')
				,NULL
				,NULL
				,NULL
				,NULL
                ,NULL
                ,NULL
				,'YES'
        FROM
                per_all_people_f@MXDM_NVIS_EXTRACT  ppf  ,
                per_person_type_usages_f@MXDM_NVIS_EXTRACT pptu,
                per_person_types@MXDM_NVIS_EXTRACT   ppt

        WHERE   current_employee_flag IS NULL
        and pptu.person_id = ppf.person_id
        and pptu.person_type_id = ppt.person_type_id
        --AND UPPER(ppt.user_person_type) = UPPER(gvt_user_person_type)
        AND UPPER(ppt.user_person_type) IN( SELECT UPPER(PARAMETER_VALUE)
                                            FROM XXMX_MIGRATION_PARAMETERS
                                            WHERE APPLICATION = 'IREC'
                                            AND APPLICATION_SUITE = 'HCM'
                                            AND PARAMETER_CODE = 'PERSON_TYPE'
                                            AND ENABLED_FLAG='Y')        --and papf.person_id = 3416
        AND ppf.business_Group_id = p_bg_id
        and ppf.effective_Start_date  IN ( Select max(papf1.effective_start_date)
                                            FROM 	per_all_people_f@MXDM_NVIS_EXTRACT   papf1
                                            WHERE   ppf.person_id = papf1.person_id
                                            AND(
                                                (  trunc(papf1.effective_start_Date) BETWEEN trunc(gvd_migration_Date_From) and trunc(gvd_migration_Date_to)
                                                    OR trunc(papf1.effective_end_Date) BETWEEN trunc(gvd_migration_Date_From) and trunc(gvd_migration_Date_to)
                                                )

                                                OR
                                                ( trunc(gvd_migration_Date_From) BETWEEN trunc(papf1.effective_start_Date) AND trunc(papf1.effective_end_Date)
                                                OR trunc(gvd_migration_Date_to) BETWEEN trunc(papf1.effective_start_Date) AND trunc(papf1.effective_end_Date))
                                                )
                                            );
--		FROM
--				per_all_people_f@MXDM_NVIS_EXTRACT   ppf,
--				per_person_types@MXDM_NVIS_EXTRACT   ppt
--		WHERE
--        ppt.user_person_type = gvt_user_person_type
--		AND ppt.person_type_id = ppf.person_type_id
--		AND CURRENT_EMPLOYEE_FLAG IS NULL
--        AND ppf.business_Group_id = p_bg_id
--        AND ppf.effective_Start_date  IN ( Select max(papf1.effective_start_date)
--                                            FROM 	per_all_people_f@MXDM_NVIS_EXTRACT   papf1
--                                            WHERE   ppf.person_id = papf1.person_id
--                                            AND(
--                                                (  trunc(papf1.effective_start_Date) BETWEEN trunc(gvd_migration_Date_From) and trunc(gvd_migration_Date_to)
--                                                    OR trunc(papf1.effective_end_Date) BETWEEN trunc(gvd_migration_Date_From) and trunc(gvd_migration_Date_to)
--                                                )
--
--                                                OR
--                                                ( trunc(gvd_migration_Date_From) BETWEEN trunc(papf1.effective_start_Date) AND trunc(papf1.effective_end_Date)
--                                                OR trunc(gvd_migration_Date_to) BETWEEN trunc(papf1.effective_start_Date) AND trunc(papf1.effective_end_Date))
--                                                )
--                                            );

        --
        gvv_ProgressIndicator := '0030';
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

    EXCEPTION
        WHEN e_ModuleError THEN
                --
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
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
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
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
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

END export_irecruit_cand;




PROCEDURE export_irecruit_cand_email
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE )  IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_irecruit_cand_email';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_HCM_IREC_CAN_EMAIL_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'CANDIDATE_EMAIL';

        lvv_migration_date_to                           VARCHAR2(30);
        lvv_migration_date_from                         VARCHAR2(30);
        lvv_prev_tax_year_date                          VARCHAR2(30);
        lvd_migration_date_to                           DATE;
        lvd_migration_date_from                         DATE;
        lvd_prev_tax_year_date                          DATE;

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
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
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
        set_parameters (pt_i_MigrationSetID);
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
        DELETE
        FROM    XXMX_HCM_IREC_CAN_EMAIL_STG
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;

		INSERT
        INTO    XXMX_HCM_IREC_CAN_EMAIL_STG
               ( 	FILE_SET_ID					,
				 	MIGRATION_SET_ID 			,
				 	MIGRATION_SET_NAME 			,
				 	MIGRATION_STATUS			,
				 	BG_NAME   					,
				 	BG_ID            			,
				 	METADATA					,
				 	OBJECTNAME					,
				 	---    ,
				 	EMAIL_ADDRESS_ID			,
				 	PERSON_ID					,
				 	CANDIDATE_NUMBER			,
				 	EMAIL_TYPE					,
				 	EMAIL_ADDRESS				,
				 	DATE_FROM					,
				 	DATE_TO						,
				 	PRIMARY_EMAIL_FLAG			,
				 	USE_FOR_COMMUNICATION		,
				 	GUID						,
				 	SOURCE_SYSTEM_ID			,
				 	SOURCE_SYSTEM_OWNER			,
				 	---	,
				 	ATTRIBUTE_CATEGORY 			,
				 	ATTRIBUTE1 					,
				 	ATTRIBUTE2 					,
				 	ATTRIBUTE3 					,
				 	ATTRIBUTE4 					,
				 	ATTRIBUTE5 					,
				 	ATTRIBUTE6 					,
				 	ATTRIBUTE7 					,
				 	ATTRIBUTE8 					,
				 	ATTRIBUTE9 					,
				 	ATTRIBUTE10 				,
				 	ATTRIBUTE_NUMBER1 			,
				 	ATTRIBUTE_NUMBER2 			,
			     	ATTRIBUTE_NUMBER3 		    ,
		        	ATTRIBUTE_NUMBER4 		    ,
		         	ATTRIBUTE_NUMBER5 		    ,
		         	ATTRIBUTE_DATE1 		    ,
		         	ATTRIBUTE_DATE2 		    ,
		         	ATTRIBUTE_DATE3 		    ,
		         	ATTRIBUTE_DATE4 		    ,
		         	ATTRIBUTE_DATE5

				)SELECT
				NULL
				,pt_i_MigrationSetID
				,pt_i_MigrationSetName
				,'EXTRACTED'
		        ,p_bg_name
				,p_bg_id
                ,'MERGE'
                ,'CandidateEmail'
				,null
				,ppf.person_id
				,ppf.employee_number AS candidate_number
				,'Work Email'
				,NVL(ppf.email_address,'NONE')
				,ppf.start_date
				--,ppf.mailstop
                ,gv_hr_date
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
				,NULL
        FROM
                per_all_people_f@MXDM_NVIS_EXTRACT  ppf  ,
                per_person_type_usages_f@MXDM_NVIS_EXTRACT pptu,
                per_person_types@MXDM_NVIS_EXTRACT   ppt

        WHERE   current_employee_flag IS NULL
        AND pptu.person_id = ppf.person_id
        AND pptu.person_type_id = ppt.person_type_id
        AND UPPER(ppt.user_person_type) IN( SELECT UPPER(PARAMETER_VALUE)
                                            FROM XXMX_MIGRATION_PARAMETERS
                                            WHERE APPLICATION = 'IREC'
                                            AND APPLICATION_SUITE = 'HCM'
                                            AND PARAMETER_CODE = 'PERSON_TYPE')        --and papf.person_id = 3416
        AND ppf.business_Group_id = p_bg_id
        and ppf.effective_Start_date  IN ( Select max(papf1.effective_start_date)
                                            FROM 	per_all_people_f@MXDM_NVIS_EXTRACT   papf1
                                            WHERE   ppf.person_id = papf1.person_id
                                            AND(
                                                (  trunc(papf1.effective_start_Date) BETWEEN trunc(gvd_migration_Date_From) and trunc(gvd_migration_Date_to)
                                                    OR trunc(papf1.effective_end_Date) BETWEEN trunc(gvd_migration_Date_From) and trunc(gvd_migration_Date_to)
                                                )

                                                OR
                                                ( trunc(gvd_migration_Date_From) BETWEEN trunc(papf1.effective_start_Date) AND trunc(papf1.effective_end_Date)
                                                OR trunc(gvd_migration_Date_to) BETWEEN trunc(papf1.effective_start_Date) AND trunc(papf1.effective_end_Date))
                                                )
                                            );

--		FROM    per_all_people_f@MXDM_NVIS_EXTRACT ppf,
--                per_person_types@MXDM_NVIS_EXTRACT   ppt
--		WHERE
--        ppt.user_person_type = gvt_user_person_type
--        AND CURRENT_EMPLOYEE_FLAG IS NULL
--        AND ppf.business_Group_id = p_bg_id
--        AND ppf.effective_Start_date  IN ( Select max(papf1.effective_start_date)
--                                            FROM 	per_all_people_f@MXDM_NVIS_EXTRACT   papf1
--                                            WHERE   ppf.person_id = papf1.person_id
--                                            AND(
--                                                (  trunc(papf1.effective_start_Date) BETWEEN trunc(gvd_migration_Date_From) and trunc(gvd_migration_Date_to)
--                                                    OR trunc(papf1.effective_end_Date) BETWEEN trunc(gvd_migration_Date_From) and trunc(gvd_migration_Date_to)
--                                                )
--
--                                                OR
--                                                ( trunc(gvd_migration_Date_From) BETWEEN trunc(papf1.effective_start_Date) AND trunc(papf1.effective_end_Date)
--                                                OR trunc(gvd_migration_Date_to) BETWEEN trunc(papf1.effective_start_Date) AND trunc(papf1.effective_end_Date))
--                                                )
--                                            );

        --
        gvv_ProgressIndicator := '0030';
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

    EXCEPTION
        WHEN e_ModuleError THEN
                --
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
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
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
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
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

	END export_irecruit_cand_email;

    PROCEDURE get_legislation_code (p_bg_id NUMBER)
    IS
    BEGIN
         BEGIN
            SELECT  legislation_code
			INTO gvv_leg_code
            FROM    per_business_groups@MXDM_NVIS_EXTRACT
            where   business_group_id= p_bg_id ;
        EXCEPTION
            WHEN no_data_found THEN
				BEGIN
					SELECT   org_information9
					INTO gvv_leg_code
					FROM hr_organization_information@MXDM_NVIS_EXTRACT
					WHERE org_information_context LIKE 'Business Group Information'
					AND organization_id = p_bg_id;
				EXCEPTION
					WHEN OTHERS THEN
						gvv_leg_code := NULL;
				END;
        END;

    END;




PROCEDURE export_irecruit_cand_address
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE )  IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_irecruit_cand_address';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_HCM_IREC_CAN_ADDRESS_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'CANDIDATE_ADDRESS';

        lvv_migration_date_to                           VARCHAR2(30);
        lvv_migration_date_from                         VARCHAR2(30);
        lvv_prev_tax_year_date                          VARCHAR2(30);
        lvd_migration_date_to                           DATE;
        lvd_migration_date_from                         DATE;
        lvd_prev_tax_year_date                          DATE;

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
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
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
        set_parameters (pt_i_MigrationSetID);
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
        DELETE
        FROM    XXMX_HCM_IREC_CAN_ADDRESS_STG
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;

		INSERT
        INTO    XXMX_HCM_IREC_CAN_ADDRESS_STG
               ( FILE_SET_ID					,
				MIGRATION_SET_ID 				,
				MIGRATION_SET_NAME 				,
				MIGRATION_STATUS				,
				BG_NAME   						,
				BG_ID            				,
				METADATA						,
				OBJECTNAME						,
				---                             ,

				PERSON_ADDR_USAGE_ID			,
				EFFECTIVE_START_DATE			,
				EFFECTIVE_END_DATE				,
				PERSON_ID						,
				CANDIDATE_NUMBER				,
				ADDRESS_TYPE					,
				ADDRESS_LINE_1					,
				ADDRESS_LINE_2					,
				ADDRESS_LINE_3					,
				ADDRESS_LINE_4					,
				TOWN_OR_CITY					,
				REGION_1						,
				REGION_2						,
				REGION_3						,
				COUNTRY							,
				COUNTRY_CODE					,
				POSTAL_CODE						 ,
                LONG_POSTAL_CODE				 ,
                ADDL_ADDRESS_ATTRIBUTE_1		 ,
                ADDL_ADDRESS_ATTRIBUTE_2		 ,
                ADDL_ADDRESS_ATTRIBUTE_3		 ,
                ADDL_ADDRESS_ATTRIBUTE_4		 ,
                ADDL_ADDRESS_ATTRIBUTE_5		 ,
                GUID							 ,
                SOURCE_SYSTEM_ID				 ,
                SOURCE_SYSTEM_OWNER				 ,
                ---
                ATTRIBUTE_CATEGORY 				,
                ATTRIBUTE1 						,
                ATTRIBUTE2 						,
                ATTRIBUTE3 						,
                ATTRIBUTE4 						,
                ATTRIBUTE5 						,
                ATTRIBUTE6 						,
                ATTRIBUTE7 						,
                ATTRIBUTE8 						,
                ATTRIBUTE9 						,
                ATTRIBUTE10 					,
                ATTRIBUTE_NUMBER1 				,
                ATTRIBUTE_NUMBER2 				,
                ATTRIBUTE_NUMBER3 				,
                ATTRIBUTE_NUMBER4 				,
                ATTRIBUTE_NUMBER5 				,
                ATTRIBUTE_DATE1 				,
                ATTRIBUTE_DATE2 				,
                ATTRIBUTE_DATE3 				,
                ATTRIBUTE_DATE4 				,
                ATTRIBUTE_DATE5 				)SELECT
				NULL
				,pt_i_MigrationSetID
				,pt_i_MigrationSetName
				,'EXTRACTED'
		        ,p_bg_name
				,p_bg_id
                ,'MERGE'
                ,'CANDIDATE_ADDRESS'
				,NULL AS personaddrusageid
				,pea.date_from         AS effectivestartdate
				,pea.date_to           AS effectiveenddate
				,NULL AS PERSON_ID
				,ppf.employee_number   AS candidatenumber
				,pea.address_type      AS addresstype
				, pea.address_line1     AS addressline1
				,pea.address_line2     AS addressline2
				,pea.address_line3     AS addressline3
				,NULL AS AddressLine4
				,town_or_city          AS townorcity
				,region_1              AS region1
				,region_2              AS region2
				,region_3             AS region3
				,pea.country           AS country
				,NULL AS countrycode
				,pea.postal_code       AS postalcode
				,NULL AS longpostalcode
				,pea.addr_attribute1   AS addladdressattribute1
				,pea.addr_attribute2   AS addladdressattribute2
				,pea.addr_attribute3   AS addladdressattribute3
				,pea.addr_attribute4   AS addladdressattribute4
				,pea.addr_attribute5   AS addladdressattribute5
				,NULL AS GUID
                ,NULL AS SOURCE_SYSTEM_ID
                ,NULL AS SOURCE_SYSTEM_OWNER

                ,NULL AS ATTRIBUTE_CATEGORY
                ,NULL AS ATTRIBUTE1
                ,NULL AS ATTRIBUTE2
                ,NULL AS ATTRIBUTE3
                ,NULL AS ATTRIBUTE4
                ,NULL AS ATTRIBUTE5
                ,NULL AS ATTRIBUTE6
                ,NULL AS ATTRIBUTE7
                ,NULL AS ATTRIBUTE8
                ,NULL AS ATTRIBUTE9
                ,NULL AS ATTRIBUTE10
                ,NULL AS ATTRIBUTE_NUMBER1
                ,NULL AS ATTRIBUTE_NUMBER2
                ,NULL AS ATTRIBUTE_NUMBER3
                ,NULL AS ATTRIBUTE_NUMBER4
                ,NULL AS ATTRIBUTE_NUMBER5
                ,NULL AS ATTRIBUTE_DATE1
                ,NULL AS ATTRIBUTE_DATE2
                ,NULL AS ATTRIBUTE_DATE3
                ,NULL AS ATTRIBUTE_DATE4
                ,NULL AS ATTRIBUTE_DATE5
		FROM
				per_all_people_f@mxdm_nvis_extract   ppf,
				per_person_types@mxdm_nvis_extract   ppt,
				per_addresses@mxdm_nvis_extract      pea

		WHERE

				 ppt.person_type_id = ppf.person_type_id
				AND ppt.person_type_id = pea.person_id
				AND UPPER(ppt.user_person_type) IN( SELECT UPPER(PARAMETER_VALUE)
													FROM XXMX_MIGRATION_PARAMETERS
													WHERE APPLICATION = 'IREC'
													AND APPLICATION_SUITE = 'HCM'
													AND PARAMETER_CODE = 'PERSON_TYPE'
													AND ENABLED_FLAG='Y')
                AND ppf.business_Group_id = p_bg_id
                 AND trunc(sysdate) between ppf.effective_Start_Date and ppf.effective_end_Date;

--                and ppt.BUSINESS_GROUP_ID=p_bg_id
--                and pea.BUSINESS_GROUP_ID=p_bg_id

--                 and ppf.effective_Start_date  IN ( Select max(papf1.effective_start_date)
--                                            FROM 	per_all_people_f@MXDM_NVIS_EXTRACT   papf1
--                                            WHERE   ppf.person_id = papf1.person_id
--                                            AND(
--                                                (  trunc(papf1.effective_start_Date) BETWEEN trunc(gvd_migration_Date_From) and trunc(gvd_migration_Date_to)
--                                                    OR trunc(papf1.effective_end_Date) BETWEEN trunc(gvd_migration_Date_From) and trunc(gvd_migration_Date_to)
--                                                )
--
--                                                OR
--                                                ( trunc(gvd_migration_Date_From) BETWEEN trunc(papf1.effective_start_Date) AND trunc(papf1.effective_end_Date)
--                                                OR trunc(gvd_migration_Date_to) BETWEEN trunc(papf1.effective_start_Date) AND trunc(papf1.effective_end_Date))
--                                                )
--                                            );

	gvv_ProgressIndicator := '0030';
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

    EXCEPTION
        WHEN e_ModuleError THEN
                --
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
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
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
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
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

	END export_irecruit_cand_address;



PROCEDURE export_irecruit_cand_phone
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE )  IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_irecruit_cand_phone';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_HCM_IREC_CAN_PHONE_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'CANDIDATE_PHONE';

        lvv_migration_date_to                           VARCHAR2(30);
        lvv_migration_date_from                         VARCHAR2(30);
        lvv_prev_tax_year_date                          VARCHAR2(30);
        lvd_migration_date_to                           DATE;
        lvd_migration_date_from                         DATE;
        lvd_prev_tax_year_date                          DATE;

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
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
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
        set_parameters (pt_i_MigrationSetID);
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
        DELETE
        FROM    XXMX_HCM_IREC_CAN_PHONE_STG
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;


           gvv_ProgressIndicator := '0015';
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
                ,pt_i_ModuleMessage       => 'Before Insert into ' || cv_StagingTable   || '".'
                ,pt_i_OracleError         => gvt_ReturnMessage  );
        --


		INSERT
        INTO    XXMX_HCM_IREC_CAN_PHONE_STG
               (
					FILE_SET_ID             ,
					MIGRATION_SET_ID 		,
					MIGRATION_SET_NAME 		,
		            MIGRATION_STATUS		,
                    BG_NAME   				,
                    BG_ID            		,
                    METADATA				,
                    OBJECTNAME				,
                    ---                     ,
                    PHONE_ID				,
                    PERSON_ID				,
                    CANDIDATE_NUMBER		,
                    DATE_FROM				,
                    DATE_TO					,
                    PHONE_NUMBER			,
                    PHONE_TYPE				,
                    COUNTRY_CODE_NUMBER		,
                    AREA_CODE				,
                    EXTENSION				,
                    LEGISLATION_CODE		,
                    SPEED_DIAL_NUMBER		,
                    VALIDITY				,
                    PRIMARY_PHONE_FLAG		,
                    USE_FOR_COMMUNICATION	,
                    GUID					,
                    SOURCE_SYSTEM_ID		,
                    SOURCE_SYSTEM_OWNER		,
                    ---                     ,
                    ATTRIBUTE_CATEGORY 		,
                    ATTRIBUTE1 				,
                    ATTRIBUTE2 				,
                    ATTRIBUTE3 				,
                    ATTRIBUTE4 				,
                    ATTRIBUTE5 				,
                    ATTRIBUTE6 				,
                    ATTRIBUTE7 				,
                    ATTRIBUTE8 				,
                    ATTRIBUTE9 				,
                    ATTRIBUTE10 			,
                    ATTRIBUTE_NUMBER1 		,
                    ATTRIBUTE_NUMBER2 		,
                    ATTRIBUTE_NUMBER3 		,
                    ATTRIBUTE_NUMBER4 		,
                    ATTRIBUTE_NUMBER5 		,
                    ATTRIBUTE_DATE1 		,
                    ATTRIBUTE_DATE2 		,
                    ATTRIBUTE_DATE3 		,
                    ATTRIBUTE_DATE4 		,
                    ATTRIBUTE_DATE5
                )Select
					 NULL
					,pt_i_MigrationSetID
					,pt_i_MigrationSetName
					,'EXTRACTED'
					,p_bg_name
					,p_bg_id
					,'MERGE'
					,'CandidatePhone'
					,null
					,null
					,papf.applicant_number AS candidate_number
					,pph.date_from
					,pph.date_to
					,pph.phone_number
                    ,pph.PHONE_TYPE
                    ,NULL
                    ,NULL
                    ,NULL
					,gvv_leg_code
					,NULL
					,pph.validity
					,NULL
					,NULL
					,NULL
					,NULL
					,NULL
					,NULL
					,NULL
					,NULL
					,NULL
					,NULL
					,NULL
					,NULL
					,NULL
					,NULL
					,NULL
					,NULL
					,NULL
					,NULL
					,NULL
					,NULL
					,NULL
					,NULL
					,NULL
					,NULL
					,NULL
					,NULL
        FROM
                per_all_people_f@MXDM_NVIS_EXTRACT  papf  ,
                per_person_type_usages_f@MXDM_NVIS_EXTRACT pptu,
                per_person_types@MXDM_NVIS_EXTRACT   ppt,
                per_phones@MXDM_NVIS_EXTRACT        pph
        WHERE   current_employee_flag IS NULL
        and pptu.person_id = papf.person_id
        and pptu.person_type_id = ppt.person_type_id
        AND UPPER(ppt.user_person_type) IN( SELECT UPPER(PARAMETER_VALUE)
                                            FROM XXMX_MIGRATION_PARAMETERS
                                            WHERE APPLICATION = 'IREC'
                                            AND APPLICATION_SUITE = 'HCM'
                                            AND PARAMETER_CODE = 'PERSON_TYPE')
        --and papf.person_id = 3416
        and pph.parent_id = papf.person_id
        AND papf.business_Group_id = p_bg_id
        and papf.effective_Start_date  IN ( Select max(papf1.effective_start_date)
                                            FROM 	per_all_people_f@MXDM_NVIS_EXTRACT   papf1
                                            WHERE   papf.person_id = papf1.person_id
                                            AND(
                                                (  trunc(papf1.effective_start_Date) BETWEEN trunc(gvd_migration_Date_From) and trunc(gvd_migration_Date_to)
                                                    OR trunc(papf1.effective_end_Date) BETWEEN trunc(gvd_migration_Date_From) and trunc(gvd_migration_Date_to)
                                                )

                                                OR
                                                ( trunc(gvd_migration_Date_From) BETWEEN trunc(papf1.effective_start_Date) AND trunc(papf1.effective_end_Date)
                                                OR trunc(gvd_migration_Date_to) BETWEEN trunc(papf1.effective_start_Date) AND trunc(papf1.effective_end_Date))
                                                )
                                            );

        --
        COMMIT;
        --
        gvv_ProgressIndicator := '0030';
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

    EXCEPTION
        WHEN e_ModuleError THEN
                --
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
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
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
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
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

	END export_irecruit_cand_phone;

PROCEDURE export_irecruit_cand_name
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE )  IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_irecruit_cand_name';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_HCM_IREC_CAN_NAME_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'CANDIDATE_NAME';

        lvv_migration_date_to                           VARCHAR2(30);
        lvv_migration_date_from                         VARCHAR2(30);
        lvv_prev_tax_year_date                          VARCHAR2(30);
        lvd_migration_date_to                           DATE;
        lvd_migration_date_from                         DATE;
        lvd_prev_tax_year_date                          DATE;

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
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
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
        set_parameters (pt_i_MigrationSetID);
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
        DELETE
        FROM    XXMX_HCM_IREC_CAN_NAME_STG
        WHERE   bg_id    = p_bg_id;

        COMMIT;

		INSERT
        INTO    XXMX_HCM_IREC_CAN_NAME_STG
               (
					FILE_SET_ID		      ,
					MIGRATION_SET_ID 	  ,
					MIGRATION_SET_NAME 	  ,
					MIGRATION_STATUS	  ,
					BG_NAME   			  ,
					BG_ID            	  ,
					METADATA			  ,
					OBJECTNAME			  ,
					---
					PERSON_NAME_ID		  ,
					EFFECTIVE_START_DATE  ,
					EFFECTIVE_END_DATE	  ,
					PERSON_ID			  ,
					CANDIDATE_NUMBER	  ,
					NAME_TYPE			  ,
					LEGISLATION_CODE	  ,
					CHAR_SET_CONTEXT	  ,
					FIRST_NAME			  ,
					LAST_NAME			  ,
					MIDDLE_NAMES		  ,
					SUFFIX				  ,
					HONORS				  ,
					KNOWN_AS			  ,
					PRE_NAME_ADJUNCT	  ,
					MILITARY_RANK		  ,
					PREVIOUS_LAST_NAME	  ,
					TITLE				  ,
					GUID				  ,
					SOURCE_SYSTEM_ID	  ,
					SOURCE_SYSTEM_OWNER	  ,
					---
					ATTRIBUTE_CATEGORY    ,
					ATTRIBUTE1 			  ,
					ATTRIBUTE2 			  ,
					ATTRIBUTE3 			  ,
					ATTRIBUTE4 			  ,
					ATTRIBUTE5 			  ,
					ATTRIBUTE6 			  ,
					ATTRIBUTE7 			  ,
					ATTRIBUTE8 			  ,
					ATTRIBUTE9 			  ,
					ATTRIBUTE10 		  ,
					ATTRIBUTE_NUMBER1 	  ,
					ATTRIBUTE_NUMBER2 	  ,
					ATTRIBUTE_NUMBER3 	  ,
					ATTRIBUTE_NUMBER4 	  ,
					ATTRIBUTE_NUMBER5 	  ,
					ATTRIBUTE_DATE1 	  ,
					ATTRIBUTE_DATE2 	  ,
					ATTRIBUTE_DATE3 	  ,
					ATTRIBUTE_DATE4 	  ,
					ATTRIBUTE_DATE5
					)Select
					NULL
                   ,pt_i_MigrationSetID
                   ,pt_i_MigrationSetName
                   ,'EXTRACTED'
                   ,p_bg_name
                   ,p_bg_id
                   ,'MERGE'
                   ,'Candidate'
                   ,Null
                   ,ppf.effective_start_date
                   ,ppf.effective_end_date
                   ,ppf.person_id
                   ,ppf.applicant_number AS candidate_number
                   ,'Global'
                   ,gvv_leg_code
                   ,NULL
                   ,ppf.first_name
                   ,ppf.last_name
                   ,ppf.middle_names
                   ,ppf.suffix
                   ,ppf.honors
                   ,ppf.known_as
                   ,ppf.pre_name_adjunct
                   ,NULL
                   ,ppf.previous_last_name
                   ,ppf.title
                   ,NULL
                   ,NULL
                   ,NULL
                   ,NULL
                   ,NULL
                   ,NULL
                   ,NULL
                   ,NULL
                   ,NULL
                   ,NULL
                   ,NULL
                   ,NULL
                   ,NULL
                   ,NULL
                   ,NULL
                   ,NULL
                   ,NULL
                   ,NULL
                   ,NULL
                   ,NULL
                   ,NULL
                   ,NULL
                   ,NULL
                   ,NULL
        FROM
                per_all_people_f@MXDM_NVIS_EXTRACT  ppf  ,
                per_person_type_usages_f@MXDM_NVIS_EXTRACT pptu,
                per_person_types@MXDM_NVIS_EXTRACT   ppt
        WHERE   current_employee_flag IS NULL
        and pptu.person_id = ppf.person_id
        and pptu.person_type_id = ppt.person_type_id
        AND trunc(sysdate) between pptu.effective_Start_Date and pptu.effective_end_Date
        AND UPPER(ppt.user_person_type) IN( SELECT UPPER(PARAMETER_VALUE)
                                            FROM XXMX_MIGRATION_PARAMETERS
                                            WHERE APPLICATION = 'IREC'
                                            AND APPLICATION_SUITE = 'HCM'
                                            AND PARAMETER_CODE = 'PERSON_TYPE')
        --and papf.person_id = 3416

        AND ppf.business_Group_id = p_bg_id
        and ppf.effective_Start_date  IN ( Select max(papf1.effective_start_date)
                                            FROM 	per_all_people_f@MXDM_NVIS_EXTRACT   papf1
                                            WHERE   ppf.person_id = papf1.person_id
                                            AND(
                                                (  trunc(papf1.effective_start_Date) BETWEEN trunc(gvd_migration_Date_From) and trunc(gvd_migration_Date_to)
                                                    OR trunc(papf1.effective_end_Date) BETWEEN trunc(gvd_migration_Date_From) and trunc(gvd_migration_Date_to)
                                                )

                                                OR
                                                ( trunc(gvd_migration_Date_From) BETWEEN trunc(papf1.effective_start_Date) AND trunc(papf1.effective_end_Date)
                                                OR trunc(gvd_migration_Date_to) BETWEEN trunc(papf1.effective_start_Date) AND trunc(papf1.effective_end_Date))
                                                )
                                            );

--		FROM
--					per_all_people_f@MXDM_NVIS_EXTRACT   ppf,
--					per_person_types@MXDM_NVIS_EXTRACT   ppt
--		WHERE
--        ppt.user_person_type   = gvt_user_person_type
--		AND 		ppt.person_type_id = ppf.person_type_id
--		AND			current_employee_flag IS NULL
--        AND ppf.business_Group_id = p_bg_id
--        and ppf.effective_Start_date  IN ( Select max(papf1.effective_start_date)
--                                            FROM 	per_all_people_f@MXDM_NVIS_EXTRACT   papf1
--                                            WHERE   ppf.person_id = papf1.person_id
--                                            AND(
--                                                (  trunc(papf1.effective_start_Date) BETWEEN trunc(gvd_migration_Date_From) and trunc(gvd_migration_Date_to)
--                                                    OR trunc(papf1.effective_end_Date) BETWEEN trunc(gvd_migration_Date_From) and trunc(gvd_migration_Date_to)
--                                                )
--
--                                                OR
--                                                ( trunc(gvd_migration_Date_From) BETWEEN trunc(papf1.effective_start_Date) AND trunc(papf1.effective_end_Date)
--                                                OR trunc(gvd_migration_Date_to) BETWEEN trunc(papf1.effective_start_Date) AND trunc(papf1.effective_end_Date))
--                                                )
--                                            );
        --
        gvv_ProgressIndicator := '0030';
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

    EXCEPTION
        WHEN e_ModuleError THEN
                --
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
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
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
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
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

	END export_irecruit_cand_name;

PROCEDURE export_irecruit_cand_attmt

        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE )  IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_irecruit_cand_attmt';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_HCM_IREC_CAN_ATTMT_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'ATTACHMENT';

        lvv_migration_date_to                           VARCHAR2(30);
        lvv_migration_date_from                         VARCHAR2(30);
        lvv_prev_tax_year_date                          VARCHAR2(30);
        lvd_migration_date_to                           DATE;
        lvd_migration_date_from                         DATE;
        lvd_prev_tax_year_date                          DATE;

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
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
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
        set_parameters (pt_i_MigrationSetID);
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
        DELETE
        FROM     XXMX_HCM_IREC_CAN_ATTMT_STG
        WHERE   bg_id    = p_bg_id    ;

        /*DELETE
        FROM    XXMX_PER_ATTACHMENT_BLOB_FILE
        WHERE   bg_id    = p_bg_id    ;*/


        COMMIT;

	    Insert into  XXMX_HCM_IREC_CAN_ATTMT_STG
		   (
				FILE_SET_ID			      ,
				MIGRATION_SET_ID 		  ,
				MIGRATION_SET_NAME 		  ,
				MIGRATION_STATUS		  ,
				BG_NAME   			      ,
				BG_ID            		  ,
				METADATA				  ,
				OBJECTNAME				  ,
				---
				ATTACHED_DOCUMENT_ID	  ,
				TITLE					  ,
				DATA_TYPE_CODE			  ,
				URL_OR_FILENAME			  ,
				CANDIDATE_NUMBER		  ,
				PERSON_ID				  ,
				CATEGORY				  ,
				---
				ATTRIBUTE_CATEGORY 	      ,
				ATTRIBUTE1 				  ,
				ATTRIBUTE2 				  ,
				ATTRIBUTE3 				  ,
				ATTRIBUTE4 				  ,
				ATTRIBUTE5 				  ,
				ATTRIBUTE6 				  ,
				ATTRIBUTE7 				  ,
				ATTRIBUTE8 				  ,
				ATTRIBUTE9 				  ,
				ATTRIBUTE10 			  ,
				ATTRIBUTE_NUMBER1 		  ,
				ATTRIBUTE_NUMBER2 		  ,
				ATTRIBUTE_NUMBER3 		  ,
				ATTRIBUTE_NUMBER4 		  ,
				ATTRIBUTE_NUMBER5 		  ,
				ATTRIBUTE_DATE1 		  ,
				ATTRIBUTE_DATE2 		  ,
				ATTRIBUTE_DATE3 		  ,
				ATTRIBUTE_DATE4 		  ,
				ATTRIBUTE_DATE5 )
				SELECT
				NULL	,
				pt_i_MigrationSetID,
				pt_i_MigrationSetName,
				'EXTRACTED',
				p_bg_name,
				p_bg_id,
				'MERGE',
				'Attchament',
				null,
				fdt.title       AS attachment_title,
				dat.user_name   AS datatype_code,
				idd.file_name,
				--fd.url,
				ppf.employee_number as Candidate_number,
				idd.person_id,
				fdc.name        AS category,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
				NULL,
                NULL
		FROM
				fnd_attached_documents@MXDM_NVIS_EXTRACT       fad,
				fnd_document_datatypes@MXDM_NVIS_EXTRACT       dat,
				fnd_documents_tl@MXDM_NVIS_EXTRACT             fdt,
				fnd_documents@MXDM_NVIS_EXTRACT                fd,
				fnd_document_categories_tl@MXDM_NVIS_EXTRACT   fdc,
				irc_documents@MXDM_NVIS_EXTRACT                idd,
				per_all_people_f@MXDM_NVIS_EXTRACT             ppf,
				per_person_types@MXDM_NVIS_EXTRACT   ppt,
                per_person_type_usages_f@MXDM_NVIS_EXTRACT pptu

	    WHERE
				fad.document_id = fd.document_id
		AND		fd.datatype_id = dat.datatype_id
		AND		fdt.document_id = fd.document_id
		AND		fdc.category_id = fd.category_id
		AND		idd.document_id = fd.document_id
		AND		idd.person_id = ppf.person_id
		AND		CURRENT_EMPLOYEE_FLAG IS NULL
		AND UPPER(ppt.user_person_type) IN( SELECT UPPER(PARAMETER_VALUE)
                                            FROM XXMX_MIGRATION_PARAMETERS
                                            WHERE APPLICATION = 'IREC'
                                            AND APPLICATION_SUITE = 'HCM'
                                            AND PARAMETER_CODE = 'PERSON_TYPE')
		AND     ppt.person_type_id = ppf.person_type_id
		AND     CURRENT_EMPLOYEE_FLAG IS NULL
        and pptu.person_id = ppf.person_id
        and pptu.person_type_id = ppt.person_type_id
		AND ppf.business_Group_id = p_bg_id
        and ppf.effective_Start_date  IN ( Select max(papf1.effective_start_date)
                                            FROM 	per_all_people_f@MXDM_NVIS_EXTRACT   papf1
                                            WHERE   ppf.person_id = papf1.person_id
                                            AND(
                                                (  trunc(papf1.effective_start_Date) BETWEEN trunc(gvd_migration_Date_From) and trunc(gvd_migration_Date_to)
                                                    OR trunc(papf1.effective_end_Date) BETWEEN trunc(gvd_migration_Date_From) and trunc(gvd_migration_Date_to)
                                                )

                                                OR
                                                ( trunc(gvd_migration_Date_From) BETWEEN trunc(papf1.effective_start_Date) AND trunc(papf1.effective_end_Date)
                                                OR trunc(gvd_migration_Date_to) BETWEEN trunc(papf1.effective_start_Date) AND trunc(papf1.effective_end_Date))
                                                )
                                            );

        --
        gvv_ProgressIndicator := '0030';
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

    EXCEPTION
        WHEN e_ModuleError THEN
                --
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
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
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
                    ,pt_i_MigrationSetID      => pt_i_MigrationSetID
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

END EXPORT_IRECRUIT_CAND_ATTMT;



END xxmx_irecruit_cand_stg;

/
