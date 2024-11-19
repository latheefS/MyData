--------------------------------------------------------
--  DDL for Package Body XXMX_IREC_GEO_HIER_STG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "XXMX_CORE"."XXMX_IREC_GEO_HIER_STG" AS
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
    gcv_PackageName                           CONSTANT  VARCHAR2(30)                                := 'xxmx_irec_geo_hier_stg';
    gct_ApplicationSuite                      CONSTANT  xxmx_module_messages.application_suite%TYPE := 'HCM';
    gct_Application                           CONSTANT  xxmx_module_messages.application%TYPE       := 'IREC';
    gv_i_BusinessEntity                       CONSTANT  VARCHAR2(100)                               := 'GEOGRAPHY_HIERARCHY';
    ct_Phase                                  CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
    cv_i_BusinessEntityLevel                  CONSTANT  VARCHAR2(100)                               := 'ALL';
    gv_hr_date					              DATE                                                  := '31-DEC-4712';


    gvt_Severity                              xxmx_module_messages.severity%TYPE;
    gvt_ModuleMessage                         xxmx_module_messages.module_message%TYPE;
    gvt_OracleError                           xxmx_module_messages.oracle_error%TYPE;


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
            and business_entity=gv_i_BusinessEntity
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


PROCEDURE export_irec_geo_hier_node
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE )  IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_irec_geo_hier_node';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_HCM_IREC_GEO_HIER_NODE_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'GEOGRAPHY_HIERARCHY_NODE';

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
        FROM   XXMX_HCM_IREC_GEO_HIER_NODE_STG
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;

		INSERT
        INTO  XXMX_HCM_IREC_GEO_HIER_NODE_STG(
                FILE_SET_ID		    ,
                MIGRATION_SET_ID 	,
                MIGRATION_SET_NAME  ,
                MIGRATION_STATUS	,
                BG_NAME   			,
                BG_ID            	,
                METADATA			,
                OBJECTNAME			,
                --
                LOCATION_CODE		,
                ADDRESS_LINE_1		,
                ADDRESS_LINE_2		,
                ADDRESS_LINE_3		,
                COUNTRY				,
                POSTAL_CODE			,
                REGION_1			,
                REGION_2			,
                REGION_3 			,
                GEOGRAPHY_ID		,
                GEOGRAPHY_NODE_ID	,
                HIERARCHY_ID		,
                NAME				,
                COUNTRY_CODE		,
                LEVEL1				,
                LEVEL2				,
                GEOGRAPHY_ELEMENT1	,
                GEOGRAPHY_ELEMENT2	,
                GEOGRAPHY_ELEMENT3	,
                GEOGRAPHY_ELEMENT4	,
                GEOGRAPHY_ELEMENT5	,
                GEOGRAPHY_ELEMENT6	,
                GEOGRAPHY_ELEMENT7	,
                GEOGRAPHY_ELEMENT8	,
                GEOGRAPHY_ELEMENT9	,
                GEOGRAPHY_ELEMENT10	,
                DELETE_FLAG			,
                GUID				,
                SOURCE_SYSTEM_ID	,
                SOURCE_SYSTEM_OWNER	,
                ---
                ATTRIBUTE_CATEGORY 	,
                ATTRIBUTE1 			,
                ATTRIBUTE2 			,
                ATTRIBUTE3 			,
                ATTRIBUTE4 			,
                ATTRIBUTE5 			,
                ATTRIBUTE6 			,
                ATTRIBUTE7 			,
                ATTRIBUTE8 			,
                ATTRIBUTE9 			,
                ATTRIBUTE10 		,
                ATTRIBUTE_NUMBER1 	,
                ATTRIBUTE_NUMBER2 	,
                ATTRIBUTE_NUMBER3 	,
                ATTRIBUTE_NUMBER4 	,
                ATTRIBUTE_NUMBER5 	,
                ATTRIBUTE_DATE1 	,
                ATTRIBUTE_DATE2 	,
                ATTRIBUTE_DATE3 	,
                ATTRIBUTE_DATE4     ,
                ATTRIBUTE_DATE5 )
                SELECT
                null,
            pt_i_MigrationSetID 	,
			pt_i_MigrationSetNamE	,
			'EXTRACTED'         	,
			p_bg_name           	,
			p_bg_id             	,
			'MERGE'             	,
			'GEOGRAPHY_HIERARCHY'	,
			loc.location_code as Location_name      ,
			loc.address_line_1						,
			loc.address_line_2						,
			loc.address_line_3						,
			loc.country								,
			loc.postal_code							,
			loc.region_1							,
			loc.region_2							,
			loc.region_3							,
			NULL AS GEOGRAPHY_ID		,
            NULL AS GEOGRAPHY_NODE_ID	,
            NULL AS HIERARCHY_ID		,
            Null AS NAME				,
            Null AS COUNTRY_CODE ,
            NULL AS LEVEL1				,
            NULL AS LEVEL2				,
            NULL AS GEOGRAPHY_ELEMENT1	,
            NULL AS GEOGRAPHY_ELEMENT2	,
            NULL AS GEOGRAPHY_ELEMENT3	,
            NULL AS GEOGRAPHY_ELEMENT4	,
            NULL AS GEOGRAPHY_ELEMENT5	,
            NULL AS GEOGRAPHY_ELEMENT6	,
            NULL AS GEOGRAPHY_ELEMENT7	,
            NULL AS GEOGRAPHY_ELEMENT8	,
            NULL AS GEOGRAPHY_ELEMENT9	,
            NULL AS GEOGRAPHY_ELEMENT10	,
            NULL AS DELETE_FLAG			,
            NULL AS GUID				,
            NULL AS SOURCE_SYSTEM_ID	,
            NULL AS SOURCE_SYSTEM_OWNER	,
            --
            NULL AS ATTRIBUTE_CATEGORY 	,
            NULL AS ATTRIBUTE1 			,
            NULL AS ATTRIBUTE2 			,
            NULL AS ATTRIBUTE3 			,
            NULL AS ATTRIBUTE4 			,
            NULL AS ATTRIBUTE5 			,
            NULL AS ATTRIBUTE6 			,
            NULL AS ATTRIBUTE7 			,
            NULL AS ATTRIBUTE8 			,
            NULL AS ATTRIBUTE9 			,
            NULL AS ATTRIBUTE10 		,
            NULL AS ATTRIBUTE_NUMBER1 	,
            NULL AS ATTRIBUTE_NUMBER2 	,
            NULL AS ATTRIBUTE_NUMBER3 	,
            NULL AS ATTRIBUTE_NUMBER4 	,
            NULL AS ATTRIBUTE_NUMBER5 	,
            NULL AS ATTRIBUTE_DATE1 	,
            NULL AS ATTRIBUTE_DATE2 	,
            NULL AS ATTRIBUTE_DATE3 	,
            NULL AS ATTRIBUTE_DATE4     ,
            NULL AS ATTRIBUTE_DATE5
		FROM
			hr_locations_all@mxdm_nvis_extract loc
		WHERE
      		EXISTS (
					SELECT
						vac.location_id
					FROM
						per_vacancies@mxdm_nvis_extract vac
					WHERE
						vac.status = 'APPROVED'
					AND vac.location_id = loc.location_id
                    AND  Vac.BUSINESS_GROUP_ID=p_bg_id
    				AND sysdate BETWEEN vac.date_from AND nvl(vac.date_to, sysdate)
					);


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

	END export_irec_geo_hier_node;




PROCEDURE export_irec_geo_hier
        (p_bg_name                          IN          VARCHAR2
        ,p_bg_id                            IN          number
        ,pt_i_MigrationSetID                IN          xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE )  IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_irec_geo_hier';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_HCM_IREC_GEO_HIER_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'GEOGRAPHY_HIERARCHY';
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
        FROM   XXMX_HCM_IREC_GEO_HIER_STG
        WHERE   bg_id    = p_bg_id    ;

        COMMIT;

		INSERT
        INTO  XXMX_HCM_IREC_GEO_HIER_STG(
                FILE_SET_ID		    					,
                MIGRATION_SET_ID 						,
                MIGRATION_SET_NAME  					,
                MIGRATION_STATUS						,
                BG_NAME   								,
                BG_ID            						,
                METADATA								,
                OBJECTNAME								,
                --
                LOCATION_CODE		 					,
                ADDRESS_LINE_1							,
                ADDRESS_LINE_2							,
                ADDRESS_LINE_3							,
                COUNTRY									,
                POSTAL_CODE								,
                REGION_1								,
                REGION_2								,
                REGION_3 								,
                HIERARCHY_ID							,
                NAME									,
                START_DATE								,
                STATUS_CODE								,
                START_ON_ACTIVATION_FLAG				,
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
                ATTRIBUTE_DATE4    						,
                ATTRIBUTE_DATE5 )
        SELECT
				null							    	,
				pt_i_MigrationSetID 					,
				pt_i_MigrationSetNamE					,
				'EXTRACTED'         					,
				p_bg_name           					,
				p_bg_id             					,
				'MERGE'             					,
				'GEOGRAPHY_HIERARCHY'					,
				loc.location_code as Location_name      ,
				loc.address_line_1						,
				loc.address_line_2						,
				loc.address_line_3						,
				loc.country								,
				loc.postal_code							,
				loc.region_1							,
				loc.region_2							,
				loc.region_3							,
				NULL AS  HIERARCHY_ID			        ,
				NULL AS NAME					        ,
				NULL AS START_DATE				        ,
				NULL AS STATUS_CODE				        ,
				NULL AS START_ON_ACTIVATION_FLAG        ,
				NULL AS GUID					        ,
				NULL AS SOURCE_SYSTEM_ID				,
				NULL AS SOURCE_SYSTEM_OWNER				,
				--
				NULL AS ATTRIBUTE_CATEGORY 				,
				NULL AS ATTRIBUTE1 						,
				NULL AS ATTRIBUTE2 						,
				NULL AS ATTRIBUTE3 						,
				NULL AS ATTRIBUTE4 						,
				NULL AS ATTRIBUTE5 						,
				NULL AS ATTRIBUTE6 						,
				NULL AS ATTRIBUTE7 						,
				NULL AS ATTRIBUTE8 						,
				NULL AS ATTRIBUTE9 						,
				NULL AS ATTRIBUTE10 					,
				NULL AS ATTRIBUTE_NUMBER1 				,
				NULL AS ATTRIBUTE_NUMBER2 				,
				NULL AS ATTRIBUTE_NUMBER3 				,
				NULL AS ATTRIBUTE_NUMBER4 				,
				NULL AS ATTRIBUTE_NUMBER5 				,
				NULL AS ATTRIBUTE_DATE1 				,
				NULL AS ATTRIBUTE_DATE2 				,
				NULL AS ATTRIBUTE_DATE3 				,
				NULL AS ATTRIBUTE_DATE4     			,
				NULL AS ATTRIBUTE_DATE5
		FROM
			hr_locations_all@mxdm_nvis_extract loc
		WHERE
      		EXISTS (
					SELECT
						vac.location_id
					FROM
						per_vacancies@mxdm_nvis_extract vac
					WHERE
						vac.status = 'APPROVED'
					AND vac.location_id = loc.location_id
                    AND  Vac.BUSINESS_GROUP_ID=p_bg_id
    				AND sysdate BETWEEN vac.date_from AND nvl(vac.date_to, sysdate)
					);


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

	END export_irec_geo_hier;

END xxmx_irec_geo_hier_stg;

/
