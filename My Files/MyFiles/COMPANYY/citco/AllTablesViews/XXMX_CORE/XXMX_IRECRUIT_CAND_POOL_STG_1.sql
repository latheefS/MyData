--------------------------------------------------------
--  DDL for Package Body XXMX_IRECRUIT_CAND_POOL_STG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_IRECRUIT_CAND_POOL_STG" AS
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
--** FILENAME  :  xxmx_irec_candidate_pool_stg.sql
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
    gcv_PackageName                           CONSTANT  VARCHAR2(30)                                := 'xxmx_irecruit_cand_pool_stg';
    gct_ApplicationSuite                      CONSTANT  xxmx_module_messages.application_suite%TYPE := 'HCM';
    gct_Application                           CONSTANT  xxmx_module_messages.application%TYPE       := 'IREC';
    gv_i_BusinessEntity                       CONSTANT  VARCHAR2(100)                               := 'CANDIDATE_POOL';
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
   -- gvt_user_person_type                       xxmx_migration_parameters.PARAMETER_VALUE%TYPE;

PROCEDURE   stg_main (    pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                            ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE )
IS

        CURSOR METADATA_CUR
        IS
            SELECT  Entity_package_name,Stg_procedure_name, BUSINESS_ENTITY,SUB_ENTITY_SEQ
			FROM     xxmx_migration_metadata a
			WHERE application_suite = gct_ApplicationSuite
            AND Application = gct_Application
            and business_entity = gv_i_BusinessEntity
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

    cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'run_extract';
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
            ,pt_i_ModuleMessage       => 'Parameter for Irec Extract',
             pt_i_OracleError         => NULL
        );

      --
        /*gvv_migration_date_from := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application                =>     gct_Application
                        ,pt_i_BusinessEntity             =>     'JOB_REFERRAL'
                        ,pt_i_SubEntity                  =>     'ALL'
                        ,pt_i_ParameterCode              =>     'MIGRATE_DATE_FROM');  */


      --  gvd_migration_date_from := TO_DATE(gvv_migration_date_from,'YYYY-MM-DD');

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
      /*  gvv_migration_date_to := xxmx_utilities_pkg.get_single_parameter_value(
                        pt_i_ApplicationSuite           =>     gct_ApplicationSuite
                        ,pt_i_Application               =>     gct_Application
                        ,pt_i_BusinessEntity            =>     'JOB_REFERRAL'
                        ,pt_i_SubEntity                 =>     'ALL'
                        ,pt_i_ParameterCode             =>     'MIGRATE_DATE_TO');        */

       -- gvd_migration_date_to := TO_DATE(gvv_migration_date_to,'YYYY-MM-DD');

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


END stg_main;

PROCEDURE export_irec_cand_pool_member
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE )  IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := '';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_HCM_IREC_CAN_POOL_MEMBR_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'CANDIDATE_POOL_MEMBER';

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
        FROM   XXMX_HCM_IREC_CAN_POOL_MEMBR_STG
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;

		INSERT
        INTO  XXMX_HCM_IREC_CAN_POOL_MEMBR_STG(
			FILE_SET_ID			,
		    MIGRATION_SET_ID 	,
		    MIGRATION_SET_NAME 	,
		    MIGRATION_STATUS	,
		    BG_NAME   			,
		    BG_ID            	,
		    METADATA			,
		    OBJECTNAME			,
		    ---
			POOL_MEMBER_ID		,
			CANDIDATE_NUMBER	,
			POOL_NAME			,
			STATUS				,
			POOL_ID				,
			ADDED_BY_PERSON_ID	,
			ADDED_FROM_POOL_ID	,
			ADDED_FROM_POOL_NAME,
			ADDED_FROM_POOL_STATUS	,
			ADDED_FROM_REQUISITION_ID,
			ADDED_FROM_REQUISITION_NUMBER,
			CURRENT_PHASE_ID        ,
			CURRENT_STATE_ID		,
			MEMBER_ID  		     	,
			CURRENT_PHASE_CODE		,
			SOURCE					,
			CURRENT_STATE_CODE		,
		    GUID					,
		    SOURCE_SYSTEM_ID		,
		    SOURCE_SYSTEM_OWNER		,
		    ---
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
		    ATTRIBUTE_DATE1 	    ,
		    ATTRIBUTE_DATE2         ,
		    ATTRIBUTE_DATE3         ,
		    ATTRIBUTE_DATE4         ,
		    ATTRIBUTE_DATE5 		)
		SELECT
			NULL					,
			pt_i_MigrationSetID 	,
			pt_i_MigrationSetNamE	,
			'EXTRACTED'         	,
			p_bg_name           	,
			p_bg_id             	,
			'MERGE'             	,
			'CANDIDATE_POOL_MEMBER'	,
			NULL AS poolmemberid,
			ppf.applicant_number AS candidatenumber,
			pjb.name|| '_'|| 'POOL' AS poolname,
			'ORA_PUBLIC' AS status,
			NULL AS poolid,
			NULL AS addedbypersonid,
			NULL AS addedfrompoolid,
			NULL AS addedfrompoolname,
			NULL AS addedfrompoolstatus,
			NULL AS addedfromrequisitionid,
			NULL AS addedfromrequisitionnumber,
			NULL AS currentphaseid,
			NULL AS currentstateid,
			NULL AS memberid,
			'NEW' AS currentphasecode,
			NULL AS source,
			NULL AS currentstatecode,
			NULL AS    GUID		,
			NULL AS    SOURCE_SYSTEM_ID	,
			NULL AS    SOURCE_SYSTEM_OWNER,
			NULL AS     ATTRIBUTE_CATEGORY 	,
			NULL AS     ATTRIBUTE1 			,
			NULL AS     ATTRIBUTE2 			,
			NULL AS     ATTRIBUTE3 			,
			NULL AS     ATTRIBUTE4 			,
			NULL AS     ATTRIBUTE5 			,
			NULL AS     ATTRIBUTE6 			,
			NULL AS     ATTRIBUTE7 			,
			NULL AS     ATTRIBUTE8 			,
			NULL AS     ATTRIBUTE9 			,
			NULL AS     ATTRIBUTE10 		,
			NULL AS     ATTRIBUTE_NUMBER1 	,
			NULL AS     ATTRIBUTE_NUMBER2 	,
			NULL AS     ATTRIBUTE_NUMBER3 	,
			NULL AS     ATTRIBUTE_NUMBER4 	,
			NULL AS     ATTRIBUTE_NUMBER5 	,
			NULL AS     ATTRIBUTE_DATE1 	,
			NULL AS     ATTRIBUTE_DATE2 	,
			NULL AS     ATTRIBUTE_DATE3 	,
			NULL AS     ATTRIBUTE_DATE4 	,
			NULL AS     ATTRIBUTE_DATE5



		FROM
			per_all_people_f@mxdm_nvis_extract        ppf,
			per_jobs@mxdm_nvis_extract                pjb,
			per_all_assignments_f@mxdm_nvis_extract   papf
		WHERE
			papf.job_id = pjb.job_id
			AND ppf.person_id = papf.person_id
            AND papf.business_group_id = p_bg_id
            AND trunc(sysdate) between ppf.effective_start_date and ppf.effective_end_date
            AND trunc(sysdate) between papf.effective_start_date and papf.effective_end_date;


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
	END export_irec_cand_pool_member ;


PROCEDURE export_irec_cand_pool
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE )  IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_irec_cand_pool';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_HCM_IREC_CAN_POOL_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'RUN EXTRACT';

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
        FROM   XXMX_HCM_IREC_CAN_POOL_STG
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;

		INSERT
        INTO XXMX_HCM_IREC_CAN_POOL_STG  (
            POOL_NAME               ,
			FILE_SET_ID				,
		    MIGRATION_SET_ID 		,
		    MIGRATION_SET_NAME 		,
		    MIGRATION_STATUS		,
		    BG_NAME   				,
		    BG_ID            		,
		    METADATA				,
		    OBJECTNAME				,
		    ---

			POOL_ID                 ,
			STATUS                  ,
			DEPARTMENT_NAME         ,
			DESCRIPTION             ,
			JOB_CODE                ,
			JOB_ID		            ,
			JOB_SET_CODE            ,
			OWNER_PERSON_ID			,
			OWNER_PERSON_NUMBER     ,
			OWNERSHIP_TYPE          ,
			POOL_TYPE_CODE          ,
			GUID				    ,
			SOURCE_SYSTEM_ID	    ,
			SOURCE_SYSTEM_OWNER	    ,
			---
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
			)
			SELECT
            DISTINCT cpst.pool_name AS pool_name ,
			NULL                    	,
			pt_i_MigrationSetID         ,
			pt_i_MigrationSetName       ,
			'EXTRACTED'                 ,
			p_bg_name           	    ,
			p_bg_id             	    ,
			'MERGE'             	    ,
			'CANDIDATE_POOL'	        ,
			NULL AS pool_id             ,
			'ACTIVE' AS status          ,
			NULL AS departmentname      ,
			NULL AS description         ,
			NULL AS jobcode             ,
			NULL AS jobid               ,
			NULL AS jobsetcode			,
			NULL AS ownerpersonid		,
			NULL AS ownerpersonnumber   ,
			NULL AS ownershiptype       ,
			'CANDIDATE' AS pooltypecode ,

			NULL AS	GUID				  ,
			NULL AS	SOURCE_SYSTEM_ID	  ,
			NULL AS	SOURCE_SYSTEM_OWNER	  ,
			NULL AS	ATTRIBUTE_CATEGORY 	  ,
			NULL AS	ATTRIBUTE1 			  ,
			NULL AS	ATTRIBUTE2 			  ,
			NULL AS	ATTRIBUTE3 			  ,
			NULL AS	ATTRIBUTE4 			  ,
			NULL AS	ATTRIBUTE5 			  ,
			NULL AS	ATTRIBUTE6 			  ,
			NULL AS	ATTRIBUTE7 			  ,
			NULL AS	ATTRIBUTE8 			  ,
			NULL AS	ATTRIBUTE9 			  ,
			NULL AS	ATTRIBUTE10 		  ,
			NULL AS	ATTRIBUTE_NUMBER1 	  ,
			NULL AS	ATTRIBUTE_NUMBER2 	  ,
			NULL AS	ATTRIBUTE_NUMBER3 	  ,
			NULL AS	ATTRIBUTE_NUMBER4 	  ,
			NULL AS	ATTRIBUTE_NUMBER5 	  ,
			NULL AS	ATTRIBUTE_DATE1 	  ,
			NULL AS	ATTRIBUTE_DATE2 	  ,
			NULL AS	ATTRIBUTE_DATE3 	  ,
			NULL AS	ATTRIBUTE_DATE4 	  ,
			NULL AS	ATTRIBUTE_DATE5


		FROM
			XXMX_HCM_IREC_CAN_POOL_MEMBR_STG cpst
        where bg_id = p_bg_id;


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
	END export_irec_cand_pool ;





PROCEDURE export_irec_cand_pool_owner
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE )  IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := '';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_HCM_IREC_CAN_POOL_OWNER_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'candidate_pool_owner';

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
        FROM   XXMX_HCM_IREC_CAN_POOL_OWNER_STG
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;

		INSERT
        INTO  XXMX_HCM_IREC_CAN_POOL_OWNER_STG(
			POOL_NAME                               ,
			FILE_SET_ID								,
		    MIGRATION_SET_ID 						,
		    MIGRATION_SET_NAME 						,
		    MIGRATION_STATUS						,
		    BG_NAME   								,
		    BG_ID            						,
		    METADATA								,
		    OBJECTNAME								,
		    ---
			POOL_OWNER_ID							,
			OWNER_PERSON_NUMBER						,
			POOL_STATUS								,
			POOL_ID									,
			OWNER_PERSON_ID							,
			GUID									,
			SOURCE_SYSTEM_ID						,
			SOURCE_SYSTEM_OWNER						,
			---
			ATTRIBUTE_CATEGORY 						,
			ATTRIBUTE1 								,
			ATTRIBUTE2 								,
			ATTRIBUTE3 								,
			ATTRIBUTE4 								,
			ATTRIBUTE5 								,
			ATTRIBUTE6 								,
			ATTRIBUTE7 								,
			ATTRIBUTE8 								,
			ATTRIBUTE9 								,
			ATTRIBUTE10 							,
			ATTRIBUTE_NUMBER1 						,
			ATTRIBUTE_NUMBER2 						,
			ATTRIBUTE_NUMBER3 						,
			ATTRIBUTE_NUMBER4 						,
			ATTRIBUTE_NUMBER5 						,
			ATTRIBUTE_DATE1 						,
			ATTRIBUTE_DATE2 						,
			ATTRIBUTE_DATE3 						,
			ATTRIBUTE_DATE4 						,
			ATTRIBUTE_DATE5 )
		SELECT
			DISTINCT cpst.pool_name AS pool_name  	,
			NULL                                    ,
			pt_i_migrationsetid                    ,
			pt_i_MigrationSetName                  ,
			'EXTRACTED'                            ,
			p_bg_name                              ,
			p_bg_id                                ,
			'MERGE'                                ,
			'Candidate',
			NULL AS       POOL_OWNER_ID                   ,
			NULL AS          OWNER_PERSON_NUMBER             ,
			'ACTIVE' AS POOL_STATUS                 ,
			NULL AS   POOL_ID                        ,
			NULL AS OWNER_PERSON_ID					,
            NULL AS  GUID									,
			NULL AS SOURCE_SYSTEM_ID						,
			NULL AS SOURCE_SYSTEM_OWNER						,
			NULL AS	ATTRIBUTE_CATEGORY 				,
			NULL AS    ATTRIBUTE1 			        ,
			NULL AS   ATTRIBUTE2 			        ,
			NULL AS   ATTRIBUTE3 			        ,
			NULL AS  ATTRIBUTE4						,
			NULL AS  ATTRIBUTE5 			        ,
			NULL AS  ATTRIBUTE6 			        ,
			NULL AS  ATTRIBUTE7 			        ,
			NULL AS  ATTRIBUTE8 			        ,
			NULL AS  ATTRIBUTE9 			        ,
			NULL AS  ATTRIBUTE10 		            ,
			NULL AS  ATTRIBUTE_NUMBER1 	            ,
			NULL AS  ATTRIBUTE_NUMBER2 				,
			NULL AS  ATTRIBUTE_NUMBER3 	            ,
			NULL AS  ATTRIBUTE_NUMBER4 	            ,
			NULL AS  ATTRIBUTE_NUMBER5 	            ,
			NULL AS  ATTRIBUTE_DATE1 	            ,
			NULL AS  ATTRIBUTE_DATE2 	            ,
			NULL AS  ATTRIBUTE_DATE3 	            ,
			NULL AS  ATTRIBUTE_DATE4 	            ,
			NULL AS  ATTRIBUTE_DATE5

		FROM
			xxmx_hcm_irec_can_pool_membr_stg cpst
        where bg_id = p_bg_id           ;

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

	END export_irec_cand_pool_owner ;




PROCEDURE export_irec_pool_interaction
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE )  IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_irec_pool_interaction';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_HCM_IREC_CAN_POOL_INTERACT_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'POOL_INTERACTION';

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
        FROM   XXMX_HCM_IREC_CAN_POOL_INTERACT_STG
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;

		INSERT
        INTO  XXMX_HCM_IREC_CAN_POOL_INTERACT_STG(

			CANDIDATE_NUMBER				,
			FILE_SET_ID						,
		    MIGRATION_SET_ID 				,
		    MIGRATION_SET_NAME 				,
		    MIGRATION_STATUS				,
		    BG_NAME   						,
		    BG_ID            				,
		    METADATA						,
		    OBJECTNAME						,
		    ---
			POOL_NAME						,
			INTERACTION_ID					,
			STATUS							,
			ADDED_BY_PERSON_ID				,
			ADDED_BY_PERSON_NUMBER			,
			INTERACTION_TYPE_CODE			,
			MEMBER_ID						,
			POOL_ID							,
			INTERACTION_DATE				,
			POOL_MEMBER_ID					,
			GUID	                        ,
			SOURCE_SYSTEM_ID				,
		    SOURCE_SYSTEM_OWNER				,
		    ---
		    ATTRIBUTE_CATEGORY 			   ,
		    ATTRIBUTE1 					   ,
		    ATTRIBUTE2 					   ,
		    ATTRIBUTE3 					   ,
		    ATTRIBUTE4 					   ,
		    ATTRIBUTE5 					   ,
		    ATTRIBUTE6 					   ,
		    ATTRIBUTE7 					   ,
		    ATTRIBUTE8 					   ,
		    ATTRIBUTE9 					   ,
		    ATTRIBUTE10 				   ,
		    ATTRIBUTE_NUMBER1 			   ,
		    ATTRIBUTE_NUMBER2 			   ,
		    ATTRIBUTE_NUMBER3 			   ,
		    ATTRIBUTE_NUMBER4 			   ,
		    ATTRIBUTE_NUMBER5 			   ,
		    ATTRIBUTE_DATE1 			   ,
		    ATTRIBUTE_DATE2 			   ,
		    ATTRIBUTE_DATE3 			   ,
		    ATTRIBUTE_DATE4 			   ,
		    ATTRIBUTE_DATE5
			)
		SELECT
            DISTINCT papf.applicant_number   AS candidate_number,
			NULL					,
			pt_i_MigrationSetID 	,
			pt_i_MigrationSetNamE	,
			'EXTRACTED'         	,
			p_bg_name           	,
			p_bg_id             	,
			'MERGE'             	,
			'POOL_INTERACTION'	    ,

		--    per.event_id,
		--    NULL AS poolmemberid,
		--papf.Applicant_number as Candidate_Number,
			pjb.name||'_'|| 'POOL' AS pool_name,
			NULL AS interactionid,
			'ACTIVE' AS status,
			NULL AS ADDED_BY_PERSON_ID,
			NULL AS ADDED_BY_PERSON_NUMBER,
            ( SELECT
              decode(iid.category, 'TELEPHONIC', 'ORA_PHONE', 'ORA_EMAIL')
              FROM
              irc_interview_details@mxdm_nvis_extract iid
              WHERE
              iid.event_id = per.event_id
              AND iid.status = 'COMPLETED'
              group by iid.category
            ) AS interactiontypecode,
			NULL AS memberid,
			NULL AS poolid,
			per.date_start AS INTERACTION_DATE,
			NULL AS POOL_MEMBER_ID,
			NULL AS GUID					,
			NULL AS SOURCE_SYSTEM_ID		,
			NULL AS SOURCE_SYSTEM_OWNER		,
			 ---
			NULL AS ATTRIBUTE_CATEGORY 		,
			NULL AS	ATTRIBUTE1 				,
			NULL AS ATTRIBUTE2 				,
			NULL AS ATTRIBUTE3 				,
			NULL AS ATTRIBUTE4 				,
			NULL AS ATTRIBUTE5 				,
			NULL AS ATTRIBUTE6 				,
			NULL AS ATTRIBUTE7 				,
			NULL AS ATTRIBUTE8 				,
			NULL AS ATTRIBUTE9 				,
			NULL AS ATTRIBUTE10 			,
			NULL AS ATTRIBUTE_NUMBER1 		,
			NULL AS ATTRIBUTE_NUMBER2 		,
			NULL AS ATTRIBUTE_NUMBER3 		,
			NULL AS ATTRIBUTE_NUMBER4 		,
			NULL AS ATTRIBUTE_NUMBER5 		,
			NULL AS ATTRIBUTE_DATE1 		,
			NULL AS ATTRIBUTE_DATE2 		,
			NULL AS ATTRIBUTE_DATE3 		,
			NULL AS ATTRIBUTE_DATE4 		,
			NULL AS ATTRIBUTE_DATE5



		FROM
			per_all_people_f@mxdm_nvis_extract        papf,
			per_all_assignments_f@mxdm_nvis_extract   paaf,
			per_events@mxdm_nvis_extract              per,
			irc_interview_details@mxdm_nvis_extract   iid,
			per_jobs@mxdm_nvis_extract                pjb
		WHERE
			paaf.assignment_id = per.assignment_id
			AND paaf.person_id = papf.person_id
			AND per.event_or_interview = 'I'
			AND per.event_id = iid.event_id
			AND paaf.job_id = pjb.job_id
            AND papf.business_group_id = p_bg_id
			AND trunc(sysdate) BETWEEN papf.effective_start_date AND papf.effective_end_date
			AND trunc(sysdate) BETWEEN paaf.effective_start_date AND paaf.effective_end_date;

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
	END export_irec_pool_interaction ;

PROCEDURE EXPORT_IREC_TALENT_COMM_DET
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE )  IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'EXPORT_IREC_TALENT_COMM_DET';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_HCM_IREC_CP_TAL_COMM_DET_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'irec_talent_community_details';

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
        FROM   XXMX_HCM_IREC_CP_TAL_COMM_DET_STG
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;

		INSERT
        INTO  XXMX_HCM_IREC_CP_TAL_COMM_DET_STG(

			FILE_SET_ID	  	         			    ,
		    MIGRATION_SET_ID 						,
		    MIGRATION_SET_NAME 						,
		    MIGRATION_STATUS						,
		    BG_NAME   								,
		    BG_ID            						,
		    METADATA								,
		    OBJECTNAME								,
		    ---
			LOCATION_ID				,
			OBJECT_CTX_ID           ,
			SITE_NUMBER             ,
			CLASSIFICATION_CODE     ,
			DIMENSION_TYPE_CODE     ,
			JOB_FAMILY_CODE         ,
			JOB_FAMILY_NAME         ,
			LOCATION_NAME           ,
			ORGANIZATION_CODE       ,
			ORGANIZATION_NAME       ,
			PERSON_TYPE_CODE        ,
			POOL_NAME               ,
			STATUS                  ,
			POOL_ID                 ,
			JOB_FAMILY_ID           ,
			ORGANIZATION_ID         ,
		    GUID									,
		    SOURCE_SYSTEM_ID		                ,
		    SOURCE_SYSTEM_OWNER		                ,
		    ---
		    ATTRIBUTE_CATEGORY 		                ,
		    ATTRIBUTE1 				                ,
		    ATTRIBUTE2 				                ,
		    ATTRIBUTE3 				                ,
		    ATTRIBUTE4 								,
		    ATTRIBUTE5 				                ,
		    ATTRIBUTE6 				                ,
		    ATTRIBUTE7 				                ,
		    ATTRIBUTE8 				                ,
		    ATTRIBUTE9 				                ,
		    ATTRIBUTE10 			                ,
		    ATTRIBUTE_NUMBER1 		                ,
		    ATTRIBUTE_NUMBER2 						,
		    ATTRIBUTE_NUMBER3 		                ,
		    ATTRIBUTE_NUMBER4 		                ,
		    ATTRIBUTE_NUMBER5 		                ,
		    ATTRIBUTE_DATE1 		                ,
		    ATTRIBUTE_DATE2 		                ,
		    ATTRIBUTE_DATE3 		                ,
		    ATTRIBUTE_DATE4 		                ,
		    ATTRIBUTE_DATE5 		                )

		SELECT
            NULL					,
			pt_i_MigrationSetID 	,
			pt_i_MigrationSetNamE	,
			'EXTRACTED'         	,
			p_bg_name           	,
			p_bg_id             	,
			'MERGE'             	,
			'TALENT_COMMUNITY_DETAILS',
            NULL AS locationid,
			NULL AS objectctxid,
			NULL AS sitenumber,
			NULL AS classificationcode,
			'ORA_PERSON_TYPE' AS dimensiontypecode,
			NULL AS jobfamilycode,
			NULL AS jobfamilyname,
			hla.location_code   AS locationname,
			NULL AS organizationcode,
			hro.name            AS organizationname,
			'ORA_Candidate' AS persontypecode,
			pjb.name
			|| '_'
			|| 'POOL' AS pool_name,
			'ACTIVE' AS status,
			NULL AS poolid,
			NULL AS jobfamilyid,
			NULL AS organizationid,
            Null as GUID					,
		    Null as SOURCE_SYSTEM_ID		,
		    Null as SOURCE_SYSTEM_OWNER		,
		     ---                     ,
		    Null as ATTRIBUTE_CATEGORY 		,
		    Null as ATTRIBUTE1 				,
		    Null as ATTRIBUTE2 				,
		    Null as ATTRIBUTE3 				,
		    Null as ATTRIBUTE4 				,
		    Null as ATTRIBUTE5 				,
		    Null as ATTRIBUTE6 				,
		    Null as ATTRIBUTE7 				,
		    Null as ATTRIBUTE8 				,
		    Null as ATTRIBUTE9 				,
		    Null as ATTRIBUTE10 			,
		    Null as ATTRIBUTE_NUMBER1 		,
		    Null as ATTRIBUTE_NUMBER2 		,
		    Null as ATTRIBUTE_NUMBER3 		,
		    Null as ATTRIBUTE_NUMBER4 		,
		    Null as ATTRIBUTE_NUMBER5 		,
		    Null as ATTRIBUTE_DATE1 		,
		    Null as ATTRIBUTE_DATE2 		,
		    Null as ATTRIBUTE_DATE3 		,
		    Null as ATTRIBUTE_DATE4 		,
		    Null as ATTRIBUTE_DATE5
		FROM
			per_person_types@mxdm_nvis_extract            ppt,
			hr_locations_all@mxdm_nvis_extract            hla,
			per_jobs@mxdm_nvis_extract                    pjb,
			hr_all_organization_units@mxdm_nvis_extract   hro,
			per_all_vacancies@mxdm_nvis_extract           pav
		WHERE
			ppt.user_person_type = 'Applicant'
		AND pav.location_id = hla.location_id
		AND pav.job_id = pjb.job_id
		AND hro.location_id = hla.location_id
        AND ppt.business_group_id = p_bg_id
        AND hro.business_group_id = p_bg_id
        AND ppt.business_group_id = p_bg_id
        and ppt.business_group_id = p_bg_id
        and pav.business_group_id = p_bg_id
       and pjb.business_group_id = p_bg_id
       and hro.business_group_id=p_bg_id;



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

	END EXPORT_IREC_TALENT_COMM_DET ;


END xxmx_irecruit_cand_pool_stg;

/
