create or replace PACKAGE BODY XXMX_PO_HEADERS_PKG AS
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
--** FILENAME  :  xxmx_po_pkg.pkb
--**
--** FILEPATH  :  $XXV1_TOP/install/sql
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  XXMX_STG
--**
--** AUTHORS   :  Shaik Latheef
--**
--** PURPOSE   :  This package contains procedures for extracting Purchase Order into Staging tables
--** 1.1 			Changed the amount based logic to get the amount from remaining quantity instead of actual for Lines, Locations and distribution
--** 1.2    Meenakshi Rajendran   Performance Tuning - Added optimizer hint, Moved main query to cursor & replaced hr_locations_all table into hr_locations

	/****************************************************************
	----------------Export Purchase Orders Information---------------
	****************************************************************/
    gvv_ReturnStatus                          VARCHAR2(1);
    gvt_ReturnMessage                         xxmx_module_messages.module_message%TYPE;
    gvv_ProgressIndicator                     VARCHAR2(100);
    gcv_PackageName                           CONSTANT  VARCHAR2(30)                                := 'XXMX_PO_HEADERS_PKG';
    gct_ApplicationSuite                      CONSTANT  xxmx_module_messages.application_suite%TYPE := 'SCM';
    gct_Application                           CONSTANT  xxmx_module_messages.application%TYPE       := 'PO';
    gv_i_BusinessEntity                       CONSTANT  VARCHAR2(100)                               := 'PURCHASE_ORDERS';
    ct_Phase                                  CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
    cv_i_BusinessEntityLevel                  CONSTANT  VARCHAR2(100)                               := 'ALL';
    --gv_hr_date					              DATE                                                  := '31-DEC-4712';
    gct_stgschema                                       VARCHAR2(10)                                := 'XXMX_STG';
    gvt_migrationsetname                      VARCHAR2(100);
    gvt_Severity                              xxmx_module_messages.severity%TYPE;
    gvt_ModuleMessage                         xxmx_module_messages.module_message%TYPE;
    gvt_OracleError                           xxmx_module_messages.oracle_error%TYPE;
    gvn_RowCount                              NUMBER;
     gvn_message                                        varchar2(2000);

    E_MODULEERROR                             EXCEPTION;
    e_DateError                               EXCEPTION;


PROCEDURE stg_main (pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                   ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE )
IS

        CURSOR METADATA_CUR
        IS
            SELECT	entity_package_name,stg_procedure_name, business_entity,sub_entity_seq,sub_entity
			FROM	xxmx_migration_metadata a
			WHERE	application_suite = gct_ApplicationSuite
            AND		Application = gct_Application
			AND 	BUSINESS_ENTITY = gv_i_BusinessEntity
			AND 	a.enabled_flag = 'Y'
            Order by Business_entity_seq, Sub_entity_seq;

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'stg_main';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_SCM_PO_HEADERS_STD_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PURCHASE_ORDERS';
        vt_MigrationSetID                               xxmx_migration_headers.migration_set_id%TYPE;
        lv_sql                                          VARCHAR2(32000);
BEGIN

-- setup
        --
        gvv_ReturnStatus  := '';
        gvv_ProgressIndicator := '0000';
        xxmx_utilities_pkg.clear_messages
            (
             pt_i_ApplicationSuite    => gct_ApplicationSuite
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
                        ,pt_i_migrationsetid      => vt_MigrationSetID
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => 'Migration Set "'
                                    ||pt_i_MigrationSetName
                                    ||'" initialized (Generated Migration Set ID = '
                                    ||vt_MigrationSetID
                                    ||').  Processing extracts:'
                        ,pt_i_OracleError         => NULL
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
            ,pt_i_migrationsetid      => vt_MigrationSetID
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => 'Parameter for Irec Extract'
            ,pt_i_OracleError         => NULL
        );

      --


        gvv_ProgressIndicator := '0025';
        xxmx_utilities_pkg.log_module_message(
             pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_migrationsetid      => vt_MigrationSetID
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => 'Call to Irecruitment Extracts'
            ,pt_i_OracleError         => NULL
        );


        FOR METADATA_REC IN METADATA_CUR -- 2
        LOOP
                    lv_sql:= 'BEGIN '
                            ||METADATA_REC.Entity_package_name
                            ||'.'||METADATA_REC.Stg_procedure_name
                            ||'('
                            ||vt_MigrationSetID
                            ||','''
                            ||METADATA_REC.sub_entity
                            ||''''||'); END;'
                            ;
        xxmx_utilities_pkg.log_module_message(
             pt_i_ApplicationSuite    => gct_ApplicationSuite
            ,pt_i_Application         => gct_Application
            ,pt_i_BusinessEntity      => gv_i_BusinessEntity
            ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
            ,pt_i_migrationsetid      => vt_MigrationSetID
            ,pt_i_Phase               => ct_Phase
            ,pt_i_Severity            => 'NOTIFICATION'
            ,pt_i_PackageName         => gcv_PackageName
            ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
            ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
            ,pt_i_ModuleMessage       => 'Command:='||lv_sql
            ,pt_i_OracleError         => NULL
        );
                    EXECUTE IMMEDIATE lv_sql ;

                    gvv_ProgressIndicator := '0030';
                    xxmx_utilities_pkg.log_module_message(
                         pt_i_ApplicationSuite    => gct_ApplicationSuite
                        ,pt_i_Application         => gct_Application
                        ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                        ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                        ,pt_i_migrationsetid      => vt_MigrationSetID
                        ,pt_i_Phase               => ct_Phase
                        ,pt_i_Severity            => 'NOTIFICATION'
                        ,pt_i_PackageName         => gcv_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => lv_sql
                        ,pt_i_OracleError         => NULL
                     );
                    DBMS_OUTPUT.PUT_LINE(lv_sql);

        END LOOP;

		COMMIT;

    EXCEPTION
        WHEN e_ModuleError THEN
                --
        xxmx_utilities_pkg.log_module_message(
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                    ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                    ,pt_i_migrationsetid      => vt_MigrationSetID
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
                    ,pt_i_migrationsetid      => vt_MigrationSetID
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
                    ,pt_i_migrationsetid      => vt_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                    ,pt_i_OracleError         => gvt_OracleError       );
            --
            RAISE;
            -- Hr_Utility.raise_error@XXMX_EXTRACT;

END stg_main;


	/****************************************************************
	----------------Export STD PO Headers----------------------------
	****************************************************************/

    PROCEDURE export_po_headers_std
        (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
    IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_po_headers_std';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_SCM_PO_HEADERS_STD_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PO_HEADERS_STD';

        lvv_migration_date_to                           VARCHAR2(30);
        lvv_migration_date_from                         VARCHAR2(30);
        lvv_prev_tax_year_date                          VARCHAR2(30);
        lvd_migration_date_to                           DATE;
        lvd_migration_date_from                         DATE;
        lvd_prev_tax_year_date                          DATE;

        e_DateError                         EXCEPTION;

    --Start: Added for 1.2
	CURSOR exp_po_headers IS 
    SELECT  /*+ driving_site(pha) */ distinct pt_i_MigrationSetID  as migration_set_id
                    ,gvt_MigrationSetName  as migration_set_name
                    ,'EXTRACTED'    as  migration_status
                    ,pha.PO_HEADER_ID	as interface_header_key
                    ,''	as action
                    ,null  as batch_id
                    ,pha.INTERFACE_SOURCE_CODE                                                          --interface_source_code
                    ,'BYPASS' as approval_action --pha.AUTHORIZATION_STATUS                                                           --approval_action
                    ,hout.name||'0'||substr( pha.SEGMENT1 ,5,6)  as document_num
                    ,pha.TYPE_LOOKUP_CODE   as document_type_code
                    ,(SELECT pds.display_name
                        FROM   apps.po_doc_style_lines_tl@XXMX_EXTRACT pds
                        WHERE  pds.document_subtype = 'STANDARD'
                        AND    pds.style_id = pha.style_id) as 	style_display_name
                    ,hout.name		as 	prc_bu_name
                    ,NVL((SELECT hou.name
                            FROM   apps.po_distributions_all@XXMX_EXTRACT         pda
                                  ,apps.po_req_distributions_all@XXMX_EXTRACT     prda
                                  ,apps.po_requisition_lines_all@XXMX_EXTRACT     prla
                                  ,apps.po_requisition_headers_all@XXMX_EXTRACT   prha
                                  ,apps.hr_all_organization_units@XXMX_EXTRACT           hou
                            WHERE  pha.po_header_id           = pda.po_header_id
                            AND    pda.req_distribution_id    = prda.distribution_id
                            AND    prda.requisition_line_id   = prla.requisition_line_id
                            AND    prla.requisition_header_id = prha.requisition_header_id
                            AND    hou.organization_id        = prha.org_id
                            AND    rownum                     = 1),hout.name)as req_bu_name
                    , (SELECT xep.name
                        FROM   apps.hr_operating_units@XXMX_EXTRACT hou
                        ,apps.xle_entity_profiles@XXMX_EXTRACT xep
                        WHERE  xep.legal_entity_id  = hou.default_legal_context_id
                        AND    hou.organization_id = hout.organization_id)  as  soldto_le_name
                    , hout.name  as billto_bu_name
                    ,(SELECT
                     ppf.last_name
                            || ', '
                        || ppf.first_name
                    FROM
                      per_all_people_f@xxmx_extract ppf
                    WHERE
                         ppf.person_id = pha.agent_id
                    AND    ppf.effective_start_date = (SELECT max(effective_start_Date)
                                                         FROM   per_all_people_f@XXMX_EXTRACT ppfl
                                                         WHERE  ppfl.person_id = ppf.person_id)) as agent_name  /*(SELECT pav.agent_name
                       FROM   apps.po_agents_v@XXMX_EXTRACT  pav
                       WHERE  pav.agent_id            = pha.agent_id )*/		--agent_name -- changed by Laxmikanth for New line issue
                    ,pha.CURRENCY_CODE																	--currency_code
                    ,pha.RATE                                                                           --rate
                    ,decode(pha.RATE_TYPE,null,null,'User') as rate_type
                    ,decode(pha.RATE,null,null,pha.RATE_DATE)as rate_date
                    ,REGEXP_REPLACE(pha.COMMENTS, '[^[:print:]]','') as comments -- changed by Laxmikanth for New line issue
                    , ( SELECT hrlb.location_code
                         from   apps.hr_locations@XXMX_EXTRACT           hrlb
                         WHERE  hrlb.location_id                  = pha.bill_to_location_id )as bill_to_location
                    , ( SELECT hrls.location_code
                         from   apps.hr_locations@XXMX_EXTRACT           hrls
                         WHERE  hrls.location_id                  = pha.ship_to_location_id )as ship_to_location
                    ,pv.VENDOR_NAME																		--vendor_name
                    ,pv.SEGMENT1																		--vendor_num
                    ,pvsa.VENDOR_SITE_CODE																--vendor_site_code
                    ,''	as vendor_contact
                    ,''	as vendor_doc_num
                    ,pha.fob_lookup_code																--fob
                    ,'' as freight_carrier
                    ,pha.freight_terms_lookup_code                                                      --freight_terms
                    ,pha.PAY_ON_CODE																	--pay_on_code
                    ,(select name
                        from   apps.ap_terms@XXMX_EXTRACT
                        where  term_id = pha.terms_id)  as payment_terms
                    ,''	as originator_role
                    ,null as change_order_desc--pha.CHANGE_SUMMARY																	--change_order_desc
                    ,pha.ACCEPTANCE_REQUIRED_FLAG														--acceptance_required_flag
                    ,''	as acceptance_within_days
                    ,pha.SUPPLIER_NOTIF_METHOD															--supplier_notif_method
                    ,pha.FAX																			--fax
                    ,pha.EMAIL_ADDRESS																	--email_address
                    ,pha.CONFIRMING_ORDER_FLAG															--confirming_order_flag
                    ,REGEXP_REPLACE(pha.NOTE_TO_VENDOR, '[^[:print:]]','')	as note_to_vendor -- changed by Laxmikanth for New line issue
                    ,REGEXP_REPLACE(pha.NOTE_TO_RECEIVER, '[^[:print:]]','')as note_to_receiver-- changed by Laxmikanth for New line issue
                    ,''	as default_taxation_country
                    ,''	as tax_document_subtype
                    ,''	as attribute_category
                    ,pha.SEGMENT1  as attribute1
                    ,''	as attribute2
                    ,''	as attribute3
                    ,''	as attribute4
                    ,''	as attribute5
                    ,''	as attribute6
                    ,''	as attribute7
                    ,''	as attribute8
                    ,''	as attribute9
                    ,''	as attribute10
                    ,''	as attribute11
                    ,''	as attribute12
                    ,''	as attribute13
                    ,''	as attribute14
                    ,''	as attribute15
                    ,''	as attribute16
                    ,''	as attribute17
                    ,''	as attribute18
                    ,''	as attribute19
                    ,''	as attribute20
                    ,''	as attribute_date1
                    ,''	as attribute_date2
                    ,''	as attribute_date3
                    ,''	as attribute_date4
                    ,''	as attribute_date5
                    ,''	as attribute_date6
                    ,''	as attribute_date7
                    ,''	as attribute_date8
                    ,''	as attribute_date9
                    ,''	as attribute_date10
                    ,''	as attribute_number1
                    ,''	as attribute_number2
                    ,''	as attribute_number3
                    ,''	as attribute_number4
                    ,''	as attribute_number5
                    ,''	as attribute_number6
                    ,''	as attribute_number7
                    ,''	as attribute_number8
                    ,''	as attribute_number9
                    ,''	as attribute_number10
                    ,''	as attribute_timestamp1
                    ,''	as attribute_timestamp2
                    ,''	as attribute_timestamp3
                    ,''	as attribute_timestamp4
                    ,''	as attribute_timestamp5
                    ,''	as attribute_timestamp6
                    ,''	as attribute_timestamp7
                    ,''	as attribute_timestamp8
                    ,''	as attribute_timestamp9
                    ,''	as attribute_timestamp10
                    ,''	as agent_email_address
                    ,''	as mode_of_transport
                    ,''	as service_level
                    ,''	as first_pty_reg_num
                    ,''	as third_pty_reg_num
                    ,''	as buyer_managed_transport_flag
                    ,''	as master_contract_number
                    ,''	as master_contract_type
                    ,''	as cc_email_address
                    ,''	as bcc_email_address
                    ,pha.po_header_id																	--po_header_id                                             				--po_header_id
            FROM
                     PO_HEADERS_ALL@XXMX_EXTRACT			pha
                    ,PO_VENDORS@XXMX_EXTRACT   			pv
                    ,PO_VENDOR_SITES_ALL@XXMX_EXTRACT		pvsa
                    ,XXMX_PURCHASE_ORDER_SCOPE				xpos
                    ,apps.hr_all_organization_units@XXMX_EXTRACT         hout
            WHERE  1                                 = 1
            --
            AND pha.type_lookup_code              	= 'STANDARD'
            AND pha.org_id                    	 	= xpos.org_id
            AND pha.po_header_id				  	= xpos.po_header_id
            AND pha.org_id                        = hout.organization_id
            --
            AND pha.vendor_id                   	= pv.vendor_id
            AND pha.vendor_site_id               	= pvsa.vendor_site_id
            ;

         --********************
          --** Type Declarations
          --********************
          --
          TYPE exp_po_hds_tt IS TABLE OF exp_po_headers%ROWTYPE INDEX BY BINARY_INTEGER;
		  exp_po_hds exp_po_hds_tt;
          --
          --


	--End: Added for 1.2	
    BEGIN
        --
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0000';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
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
        FROM    XXMX_SCM_PO_HEADERS_STD_STG
          ;

        COMMIT;
        --
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

               --
               OPEN exp_po_headers;

               LOOP
                    --
                    FETCH exp_po_headers
                    BULK COLLECT
                    INTO exp_po_hds
                    LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;
                    --
                    EXIT WHEN exp_po_hds.COUNT=0;

                    FORALL I
                    IN     1..exp_po_hds.COUNT
                         --

            INSERT
            INTO    XXMX_SCM_PO_HEADERS_STD_STG
                   (MIGRATION_SET_ID					,
                    MIGRATION_SET_NAME					,
                    MIGRATION_STATUS					,
                    INTERFACE_HEADER_KEY				,
                    ACTION								,
                    BATCH_ID							,
                    INTERFACE_SOURCE_CODE				,
                    APPROVAL_ACTION						,
                    DOCUMENT_NUM						,
                    DOCUMENT_TYPE_CODE					,
                    STYLE_DISPLAY_NAME					,
                    PRC_BU_NAME							,
                    REQ_BU_NAME							,
                    SOLDTO_LE_NAME						,
                    BILLTO_BU_NAME						,
                    AGENT_NAME							,
                    CURRENCY_CODE						,
                    RATE								,
                    RATE_TYPE							,
                    RATE_DATE							,
                    COMMENTS							,
                    BILL_TO_LOCATION					,
                    SHIP_TO_LOCATION					,
                    VENDOR_NAME							,
                    VENDOR_NUM							,
                    VENDOR_SITE_CODE					,
                    VENDOR_CONTACT						,
                    VENDOR_DOC_NUM						,
                    FOB									,
                    FREIGHT_CARRIER						,
                    FREIGHT_TERMS						,
                    PAY_ON_CODE							,
                    PAYMENT_TERMS						,
                    ORIGINATOR_ROLE						,
                    CHANGE_ORDER_DESC					,
                    ACCEPTANCE_REQUIRED_FLAG			,
                    ACCEPTANCE_WITHIN_DAYS				,
                    SUPPLIER_NOTIF_METHOD				,
                    FAX									,
                    EMAIL_ADDRESS						,
                    CONFIRMING_ORDER_FLAG				,
                    NOTE_TO_VENDOR						,
                    NOTE_TO_RECEIVER					,
                    DEFAULT_TAXATION_COUNTRY			,
                    TAX_DOCUMENT_SUBTYPE				,
                    ATTRIBUTE_CATEGORY					,
                    ATTRIBUTE1							,
                    ATTRIBUTE2							,
                    ATTRIBUTE3							,
                    ATTRIBUTE4							,
                    ATTRIBUTE5							,
                    ATTRIBUTE6							,
                    ATTRIBUTE7							,
                    ATTRIBUTE8							,
                    ATTRIBUTE9							,
                    ATTRIBUTE10							,
                    ATTRIBUTE11							,
                    ATTRIBUTE12							,
                    ATTRIBUTE13							,
                    ATTRIBUTE14							,
                    ATTRIBUTE15							,
                    ATTRIBUTE16							,
                    ATTRIBUTE17							,
                    ATTRIBUTE18							,
                    ATTRIBUTE19							,
                    ATTRIBUTE20							,
                    ATTRIBUTE_DATE1						,
                    ATTRIBUTE_DATE2						,
                    ATTRIBUTE_DATE3						,
                    ATTRIBUTE_DATE4						,
                    ATTRIBUTE_DATE5						,
                    ATTRIBUTE_DATE6						,
                    ATTRIBUTE_DATE7						,
                    ATTRIBUTE_DATE8						,
                    ATTRIBUTE_DATE9						,
                    ATTRIBUTE_DATE10					,
                    ATTRIBUTE_NUMBER1					,
                    ATTRIBUTE_NUMBER2					,
                    ATTRIBUTE_NUMBER3					,
                    ATTRIBUTE_NUMBER4					,
                    ATTRIBUTE_NUMBER5					,
                    ATTRIBUTE_NUMBER6					,
                    ATTRIBUTE_NUMBER7					,
                    ATTRIBUTE_NUMBER8					,
                    ATTRIBUTE_NUMBER9					,
                    ATTRIBUTE_NUMBER10					,
                    ATTRIBUTE_TIMESTAMP1				,
                    ATTRIBUTE_TIMESTAMP2				,
                    ATTRIBUTE_TIMESTAMP3				,
                    ATTRIBUTE_TIMESTAMP4				,
                    ATTRIBUTE_TIMESTAMP5				,
                    ATTRIBUTE_TIMESTAMP6				,
                    ATTRIBUTE_TIMESTAMP7				,
                    ATTRIBUTE_TIMESTAMP8				,
                    ATTRIBUTE_TIMESTAMP9				,
                    ATTRIBUTE_TIMESTAMP10				,
                    AGENT_EMAIL_ADDRESS					,
                    MODE_OF_TRANSPORT					,
                    SERVICE_LEVEL						,
                    FIRST_PTY_REG_NUM					,
                    THIRD_PTY_REG_NUM					,
                    BUYER_MANAGED_TRANSPORT_FLAG		,
                    MASTER_CONTRACT_NUMBER				,
                    MASTER_CONTRACT_TYPE				,
                    CC_EMAIL_ADDRESS					,
                    BCC_EMAIL_ADDRESS					,
                    PO_HEADER_ID
                )
          VALUES ( exp_po_hds(i).migration_set_id
		          ,exp_po_hds(i).migration_set_name
				  ,exp_po_hds(i).migration_status
				  ,exp_po_hds(i).interface_header_key
				  ,exp_po_hds(i).action
                  ,exp_po_hds(i).batch_id
                  ,exp_po_hds(i).INTERFACE_SOURCE_CODE 
                  ,exp_po_hds(i).approval_action
                  ,exp_po_hds(i).document_num
                  ,exp_po_hds(i).document_type_code
                  ,exp_po_hds(i).style_display_name
                  ,exp_po_hds(i).prc_bu_name
                  ,exp_po_hds(i).req_bu_name
                  ,exp_po_hds(i).soldto_le_name
                  ,exp_po_hds(i).billto_bu_name
                  ,exp_po_hds(i).agent_name 
                  ,exp_po_hds(i).CURRENCY_CODE																	
                  ,exp_po_hds(i).RATE                                                                           
                  ,exp_po_hds(i).rate_type
                  ,exp_po_hds(i).rate_date
                  ,exp_po_hds(i).comments
                  ,exp_po_hds(i).bill_to_location
                  ,exp_po_hds(i).ship_to_location
                  ,exp_po_hds(i).VENDOR_NAME														
                  ,exp_po_hds(i).SEGMENT1
                  ,exp_po_hds(i).VENDOR_SITE_CODE	
                  ,exp_po_hds(i).vendor_contact
                  ,exp_po_hds(i).vendor_doc_num
                  ,exp_po_hds(i).fob_lookup_code																--fob
                  ,exp_po_hds(i).freight_carrier
                  ,exp_po_hds(i).freight_terms_lookup_code                                                      --freight_terms
                  ,exp_po_hds(i).PAY_ON_CODE																	--pay_on_code
                  ,exp_po_hds(i).payment_terms
                  ,exp_po_hds(i).originator_role
                  ,exp_po_hds(i).change_order_desc --pha.CHANGE_SUMMARY																	--
                  ,exp_po_hds(i).ACCEPTANCE_REQUIRED_FLAG														--acceptance_required_flag
                  ,exp_po_hds(i).acceptance_within_days
                  ,exp_po_hds(i).SUPPLIER_NOTIF_METHOD															--supplier_notif_method
                  ,exp_po_hds(i).FAX																			--fax
                  ,exp_po_hds(i).EMAIL_ADDRESS																	--email_address
                  ,exp_po_hds(i).CONFIRMING_ORDER_FLAG															--confirming_order_flag
                  ,exp_po_hds(i).note_to_vendor 
                  ,exp_po_hds(i).note_to_receiver
                  ,exp_po_hds(i).default_taxation_country
                  ,exp_po_hds(i).tax_document_subtype
                  ,exp_po_hds(i).attribute_category
                  ,exp_po_hds(i).attribute1
				  ,exp_po_hds(i).attribute2
				  ,exp_po_hds(i).attribute3
				  ,exp_po_hds(i).attribute4
				  ,exp_po_hds(i).attribute5
				  ,exp_po_hds(i).attribute6
				  ,exp_po_hds(i).attribute7
				  ,exp_po_hds(i).attribute8
				  ,exp_po_hds(i).attribute9
				  ,exp_po_hds(i).attribute10
				  ,exp_po_hds(i).attribute11
				  ,exp_po_hds(i).attribute12
				  ,exp_po_hds(i).attribute13
				  ,exp_po_hds(i).attribute14
				  ,exp_po_hds(i).attribute15
				  ,exp_po_hds(i).attribute16
				  ,exp_po_hds(i).attribute17
				  ,exp_po_hds(i).attribute18
				  ,exp_po_hds(i).attribute19
				  ,exp_po_hds(i).attribute20
                  ,exp_po_hds(i).attribute_date1
				  ,exp_po_hds(i).attribute_date2
				  ,exp_po_hds(i).attribute_date3
				  ,exp_po_hds(i).attribute_date4
				  ,exp_po_hds(i).attribute_date5
				  ,exp_po_hds(i).attribute_date6
				  ,exp_po_hds(i).attribute_date7
				  ,exp_po_hds(i).attribute_date8
				  ,exp_po_hds(i).attribute_date9
				  ,exp_po_hds(i).attribute_date10
				  ,exp_po_hds(i).attribute_number1
				  ,exp_po_hds(i).attribute_number2
				  ,exp_po_hds(i).attribute_number3
				  ,exp_po_hds(i).attribute_number4
				  ,exp_po_hds(i).attribute_number5
				  ,exp_po_hds(i).attribute_number6
				  ,exp_po_hds(i).attribute_number7
				  ,exp_po_hds(i).attribute_number8
				  ,exp_po_hds(i).attribute_number9
				  ,exp_po_hds(i).attribute_number10
                  ,exp_po_hds(i).attribute_timestamp1
				  ,exp_po_hds(i).attribute_timestamp2
				  ,exp_po_hds(i).attribute_timestamp3
				  ,exp_po_hds(i).attribute_timestamp4
				  ,exp_po_hds(i).attribute_timestamp5
				  ,exp_po_hds(i).attribute_timestamp6
				  ,exp_po_hds(i).attribute_timestamp7
				  ,exp_po_hds(i).attribute_timestamp8
				  ,exp_po_hds(i).attribute_timestamp9
				  ,exp_po_hds(i).attribute_timestamp10
                  ,exp_po_hds(i).agent_email_address
                  ,exp_po_hds(i).mode_of_transport
                  ,exp_po_hds(i).service_level
                  ,exp_po_hds(i).first_pty_reg_num
                  ,exp_po_hds(i).third_pty_reg_num
                  ,exp_po_hds(i).buyer_managed_transport_flag
                  ,exp_po_hds(i).master_contract_number
                  ,exp_po_hds(i).master_contract_type
                  ,exp_po_hds(i).cc_email_address
                  ,exp_po_hds(i).bcc_email_address
                  ,exp_po_hds(i).po_header_id																	
				 ); 


			END LOOP;	  

			--Start: Commented for 1.2
--			SELECT  /*+ driving_site(pha) */ distinct pt_i_MigrationSetID      													--migration_set_id
--                    ,gvt_MigrationSetName                               								--migration_set_name
--                    ,'EXTRACTED'                               											--migration_status
--                    ,pha.PO_HEADER_ID																	--interface_header_key
--                    ,''																					--action
--                    ,null                                                                               --batch_id
--                    ,pha.INTERFACE_SOURCE_CODE                                                          --interface_source_code
--                    ,'BYPASS' --pha.AUTHORIZATION_STATUS                                                           --approval_action
--                    ,hout.name||'0'||substr( pha.SEGMENT1 ,5,6)                                                                    --document_num
--                    ,pha.TYPE_LOOKUP_CODE                                                               --document_type_code
--                    ,(SELECT pds.display_name
--                        FROM   apps.po_doc_style_lines_tl@XXMX_EXTRACT pds
--                        WHERE  pds.document_subtype = 'STANDARD'
--                        AND    pds.style_id = pha.style_id) 											--style_display_name
--                    ,hout.name																			--prc_bu_name
--                    ,NVL((SELECT hou.name
--                            FROM   apps.po_distributions_all@XXMX_EXTRACT         pda
--                                  ,apps.po_req_distributions_all@XXMX_EXTRACT     prda
--                                  ,apps.po_requisition_lines_all@XXMX_EXTRACT     prla
--                                  ,apps.po_requisition_headers_all@XXMX_EXTRACT   prha
--                                  ,apps.hr_all_organization_units@XXMX_EXTRACT           hou
--                            WHERE  pha.po_header_id           = pda.po_header_id
--                            AND    pda.req_distribution_id    = prda.distribution_id
--                            AND    prda.requisition_line_id   = prla.requisition_line_id
--                            AND    prla.requisition_header_id = prha.requisition_header_id
--                            AND    hou.organization_id        = prha.org_id
--                            AND    rownum                     = 1),hout.name)							--req_bu_name
--                    , (SELECT xep.name
--                        FROM   apps.hr_operating_units@XXMX_EXTRACT hou
--                        ,apps.xle_entity_profiles@XXMX_EXTRACT xep
--                        WHERE  xep.legal_entity_id  = hou.default_legal_context_id
--                        AND    hou.organization_id = hout.organization_id)                              --soldto_le_name
--                    , hout.name                                                                         --billto_bu_name
--                    ,(SELECT
--                     ppf.last_name
--                            || ', '
--                        || ppf.first_name
--                    FROM
--                      per_all_people_f@xxmx_extract ppf
--                    WHERE
--                         ppf.person_id = pha.agent_id
--                    AND    ppf.effective_start_date = (SELECT max(effective_start_Date)
--                                                         FROM   per_all_people_f@XXMX_EXTRACT ppfl
--                                                         WHERE  ppfl.person_id = ppf.person_id))  /*(SELECT pav.agent_name
--                       FROM   apps.po_agents_v@XXMX_EXTRACT  pav
--                       WHERE  pav.agent_id            = pha.agent_id )*/		--agent_name -- changed by Laxmikanth for New line issue
--                    ,pha.CURRENCY_CODE																	--currency_code
--                    ,pha.RATE                                                                           --rate
--                    ,decode(pha.RATE_TYPE,null,null,'User')                                             --rate_type
--                    ,decode(pha.RATE,null,null,pha.RATE_DATE)																		--rate_date
--                    ,REGEXP_REPLACE(pha.COMMENTS, '[^[:print:]]','')																		--comments -- changed by Laxmikanth for New line issue
--                    , ( SELECT hrlb.location_code
--                         from   apps.hr_locations@XXMX_EXTRACT           hrlb
--                         WHERE  hrlb.location_id                  = pha.bill_to_location_id )           --bill_to_location
--                    , ( SELECT hrls.location_code
--                         from   apps.hr_locations@XXMX_EXTRACT           hrls
--                         WHERE  hrls.location_id                  = pha.ship_to_location_id )           --ship_to_location
--                    ,pv.VENDOR_NAME																		--vendor_name
--                    ,pv.SEGMENT1																		--vendor_num
--                    ,pvsa.VENDOR_SITE_CODE																--vendor_site_code
--                    ,''																					--vendor_contact
--                    ,''																					--vendor_doc_num
--                    ,pha.fob_lookup_code																--fob
--                    ,''																					--freight_carrier
--                    ,pha.freight_terms_lookup_code                                                      --freight_terms
--                    ,pha.PAY_ON_CODE																	--pay_on_code
--                    ,(select name
--                        from   apps.ap_terms@XXMX_EXTRACT
--                        where  term_id = pha.terms_id)  												--payment_terms
--                    ,''																					--originator_role
--                    ,null --pha.CHANGE_SUMMARY																	--change_order_desc
--                    ,pha.ACCEPTANCE_REQUIRED_FLAG														--acceptance_required_flag
--                    ,''																					--acceptance_within_days
--                    ,pha.SUPPLIER_NOTIF_METHOD															--supplier_notif_method
--                    ,pha.FAX																			--fax
--                    ,pha.EMAIL_ADDRESS																	--email_address
--                    ,pha.CONFIRMING_ORDER_FLAG															--confirming_order_flag
--                    ,REGEXP_REPLACE(pha.NOTE_TO_VENDOR, '[^[:print:]]','')																	--note_to_vendor -- changed by Laxmikanth for New line issue
--                    ,REGEXP_REPLACE(pha.NOTE_TO_RECEIVER, '[^[:print:]]','')																--note_to_receiver-- changed by Laxmikanth for New line issue
--                    ,''																					--default_taxation_country
--                    ,''																					--tax_document_subtype
--                    ,''																					--attribute_category
--                    ,pha.SEGMENT1                                                                       --attribute1
--                    ,''																					--attribute2
--                    ,''																					--attribute3
--                    ,''																					--attribute4
--                    ,''																					--attribute5
--                    ,''																					--attribute6
--                    ,''																					--attribute7
--                    ,''																					--attribute8
--                    ,''																					--attribute9
--                    ,''																					--attribute10
--                    ,''																					--attribute11
--                    ,''																					--attribute12
--                    ,''																					--attribute13
--                    ,''																					--attribute14
--                    ,''																					--attribute15
--                    ,''																					--attribute16
--                    ,''																					--attribute17
--                    ,''																					--attribute18
--                    ,''																					--attribute19
--                    ,''																					--attribute20
--                    ,''																					--attribute_date1
--                    ,''																					--attribute_date2
--                    ,''																					--attribute_date3
--                    ,''																					--attribute_date4
--                    ,''																					--attribute_date5
--                    ,''																					--attribute_date6
--                    ,''																					--attribute_date7
--                    ,''																					--attribute_date8
--                    ,''																					--attribute_date9
--                    ,''																					--attribute_date10
--                    ,''																					--attribute_number1
--                    ,''																					--attribute_number2
--                    ,''																					--attribute_number3
--                    ,''																					--attribute_number4
--                    ,''																					--attribute_number5
--                    ,''																					--attribute_number6
--                    ,''																					--attribute_number7
--                    ,''																					--attribute_number8
--                    ,''																					--attribute_number9
--                    ,''																					--attribute_number10
--                    ,''																					--attribute_timestamp1
--                    ,''																					--attribute_timestamp2
--                    ,''																					--attribute_timestamp3
--                    ,''																					--attribute_timestamp4
--                    ,''																					--attribute_timestamp5
--                    ,''																					--attribute_timestamp6
--                    ,''																					--attribute_timestamp7
--                    ,''																					--attribute_timestamp8
--                    ,''																					--attribute_timestamp9
--                    ,''																					--attribute_timestamp10
--                    ,''																					--agent_email_address
--                    ,''																					--mode_of_transport
--                    ,''																					--service_level
--                    ,''																					--first_pty_reg_num
--                    ,''																					--third_pty_reg_num
--                    ,''																					--buyer_managed_transport_flag
--                    ,''																					--master_contract_number
--                    ,''																					--master_contract_type
--                    ,''																					--cc_email_address
--                    ,''																					--bcc_email_address
--                    ,pha.po_header_id																	--po_header_id                                             				--po_header_id
--            FROM
--                     PO_HEADERS_ALL@XXMX_EXTRACT			pha
--                    ,PO_VENDORS@XXMX_EXTRACT   			pv
--                    ,PO_VENDOR_SITES_ALL@XXMX_EXTRACT		pvsa
--                    ,XXMX_PURCHASE_ORDER_SCOPE				xpos
--                    ,apps.hr_all_organization_units@XXMX_EXTRACT         hout
--            WHERE  1                                 = 1
--            --
--            AND pha.type_lookup_code              	= 'STANDARD'
--            AND pha.org_id                    	 	= xpos.org_id
--            AND pha.po_header_id				  	= xpos.po_header_id
--            AND pha.org_id                        = hout.organization_id
--            --
--            AND pha.vendor_id                   	= pv.vendor_id
--            AND pha.vendor_site_id               	= pvsa.vendor_site_id
--            ;
			--End: Commented for 1.2

           /*
            ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
            ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
            ** is reached.
            */
        gvn_RowCount := SQL%rowcount;
        --
        gvn_message := 'Customers updated: '||gvn_RowCount;
        xxmx_utilities_pkg.log_module_message
            (
                 pt_i_ApplicationSuite    => gct_ApplicationSuite
                ,pt_i_Application         => gct_Application
                ,pt_i_BusinessEntity      => gv_i_BusinessEntity
                ,pt_i_SubEntity           => cv_i_BusinessEntityLevel
                ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                ,pt_i_Phase               => ct_Phase
                ,pt_i_PackageName         => gcv_PackageName
                ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                ,pt_i_Severity            => 'NOTIFICATION'
                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                ,pt_i_ModuleMessage       => gvn_message
                ,pt_i_OracleError         => NULL
            );
--            gvn_RowCount := xxmx_utilities_pkg.get_row_count
--                                 (
--                                  gct_StgSchema
--                                 ,cv_StagingTable
--                                 ,pt_i_MigrationSetID
--                                 );
--            --
            COMMIT;

			CLOSE exp_po_headers;


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
            -- Hr_Utility.raise_error@XXMX_EXTRACT;
    END export_po_headers_std;


	/****************************************************************
	----------------Export STD PO Lines------------------------------
	****************************************************************/

    PROCEDURE export_po_lines_std
       (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
        IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_po_lines_std';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_SCM_PO_LINES_STD_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PO_LINES_STD';

        lvv_migration_date_to                           VARCHAR2(30);
        lvv_migration_date_from                         VARCHAR2(30);
        lvv_prev_tax_year_date                          VARCHAR2(30);
        lvd_migration_date_to                           DATE;
        lvd_migration_date_from                         DATE;
        lvd_prev_tax_year_date                          DATE;

        e_DateError                         EXCEPTION;

		--Start: Added for 1.2
		CURSOR exp_po_lines IS 
		SELECT  /*+ driving_site(pha) */ distinct pt_i_MigrationSetID  as migration_set_id
                        ,gvt_migrationsetname as migration_set_name
                        ,'EXTRACTED'  as migration_status
                        ,pla.po_line_id  as interface_line_key
                        ,pha.po_header_id  as interface_header_key
                        ,'' as action
                        ,pha.SEGMENT1                                                                       -- document_num
                        ,pla.LINE_NUM              															--line_num
                        ,plt.LINE_TYPE       																--line_type
                        ,(SELECT msib.segment1||'.'||msib.segment2
                           FROM   apps.mtl_system_items_b@XXMX_EXTRACT msib
                           WHERE  msib.inventory_item_id =  pla.item_id
                           AND    ROWNUM = 1)  as  item
                        ,pla.ITEM_DESCRIPTION        														--item_description
                        ,pla.ITEM_REVISION       															--item_revision
                        , ( SELECT mct.description
                            FROM   apps.mtl_categories_b@XXMX_EXTRACT      mcb
                                  ,apps.mtl_categories_tl@XXMX_EXTRACT     mct
                            WHERE  1 = 1
                            AND    mcb.category_id = mct.category_id
                            AND    mcb.category_id = pla.category_id )  as category
                        ,case when pla.order_type_lookup_code='AMOUNT' then
                       -- pla.QUANTITY																				-- commented by Laxmikanth for the calcuated quantity
					   xlq.new_qty_ordered																			-- Added by Laxmikanth for the calcuated quantity
                        ELSE
                        pla.AMOUNT     END  as amount
                       , pla.AMOUNT as original_amount
                        ,null as migrated_amount
                        ,case when order_type_lookup_code='AMOUNT'then
                        NULL
                        ELSE
                        pla.QUANTITY       END  as quantity
						,pla.QUANTITY as  original_quantity
                        ,case when order_type_lookup_code='AMOUNT'then
                        NULL
                        ELSE
                        xlq.new_qty_ordered       END as new_qty_ordered
						--xlq.new_qty_ordered                                                                -- migrated quantity
                        ,case when order_type_lookup_code='AMOUNT'then
                        NULL
                        ELSE
                        pla.UNIT_MEAS_LOOKUP_CODE     END	as unit_of_measure					
                        ,case when order_type_lookup_code='AMOUNT'then
                        NULL
                        ELSE
                        pla.UNIT_PRICE     END  as unit_price
                        ,pla.SECONDARY_QUANTITY    															--secondary_quantity
                        ,pla.SECONDARY_UNIT_OF_MEASURE														--secondary_unit_of_measure
                        ,pla.VENDOR_PRODUCT_NUM       														--vendor_product_num
                        ,pla.NEGOTIATED_BY_PREPARER_FLAG  													--negotiated_by_preparer_flag
                       , ( SELECT phc.hazard_class
                            FROM   apps.po_hazard_classes_tl@XXMX_EXTRACT  phc
                            WHERE  phc.hazard_class_id = pla.hazard_class_id) as  hazard_class
                        , ( SELECT poun.un_number
                            FROM   apps.po_un_numbers_tl@XXMX_EXTRACT poun
                            WHERE  poun.un_number_id = pla.un_number_id) as Un_Number
                        ,REGEXP_REPLACE(pla.NOTE_TO_VENDOR, '[^[:print:]]','') as note_to_vendor
                        ,''  as note_to_receiver
                        ,''  as line_attribute_category_lines
                        ,''  as line_attribute1
						,''  as line_attribute2
						,''  as line_attribute3
						,''  as line_attribute4
						,''  as line_attribute5
						,''  as line_attribute6
						,''  as line_attribute7
						,''  as line_attribute8
						,''  as line_attribute9
						,''  as line_attribute10
						,''  as line_attribute11
						,''  as line_attribute12
						,''  as line_attribute13
						,''  as line_attribute14
						,''  as line_attribute15
						,''  as line_attribute16
						,''  as line_attribute17
						,''  as line_attribute18
						,''  as line_attribute19
						,''  as line_attribute20
                        ,''  as attribute_date1
						,''	as attribute_date2
						,''	as attribute_date3
						,''	as attribute_date4
						,''	as attribute_date5
						,''	as attribute_date6
						,''	as attribute_date7
						,''	as attribute_date8
						,''	as attribute_date9
						,''	as attribute_date10
						,''	as attribute_number1
						,''	as attribute_number2
						,''	as attribute_number3
						,''	as attribute_number4
						,''	as attribute_number5
						,''	as attribute_number6
						,''	as attribute_number7
						,''	as attribute_number8
						,''	as attribute_number9
						,''	as attribute_number10
						,''	as attribute_timestamp1
						,''	as attribute_timestamp2
						,''	as attribute_timestamp3
						,''	as attribute_timestamp4
						,''	as attribute_timestamp5
						,''	as attribute_timestamp6
						,''	as attribute_timestamp7
						,''	as attribute_timestamp8
						,''	as attribute_timestamp9
						,''	as attribute_timestamp10
                        ,'' as unit_weight
                        ,'' as weight_uom_code
                        ,'' as weight_unit_of_measure
                        ,'' as unit_volume
                        ,'' as volume_uom_code
                        ,'' as volume_unit_of_measure
                        ,'' as template_name
                        ,'' as item_attribute_category
                        ,'' as item_attribute1    
						,'' as item_attribute2
						,'' as item_attribute3
						,'' as item_attribute4
						,'' as item_attribute5
						,'' as item_attribute6
						,'' as item_attribute7
						,'' as item_attribute8
						,'' as item_attribute9
						,'' as item_attribute10
						,'' as item_attribute11
						,'' as item_attribute12
						,'' as item_attribute13
						,'' as item_attribute14
                        ,'' as item_attribute15
                        ,'' as source_agreement_prc_bu_name
                        ,'' as source_agreement
                        ,'' as source_agreement_line
                        ,'' as discount_type
                        ,'' as discount
                        ,'' as discount_reason
                        ,pla.max_retainage_amount	      													--max_retainage_amount
                        ,pha.po_header_id               													--po_header_id
                        ,pla.po_line_id               														--po_line_id
                FROM
                         PO_HEADERS_ALL@XXMX_EXTRACT		    pha
                        ,PO_LINES_ALL@XXMX_EXTRACT   			pla
                        ,PO_LINE_TYPES_TL@XXMX_EXTRACT			plt
                        ,XXMX_PURCHASE_ORDER_SCOPE            xpos
                        ,xxmx_core.XXMX_PO_LINES_QTY_V          xlq
                WHERE  1                                   = 1
                --
                 AND pha.type_lookup_code                  = 'STANDARD'
                 AND pha.org_id                            = xpos.org_id
                 AND pha.po_header_id				       = xpos.po_header_id
                 --
                 AND pla.po_header_id                  	   = pha.po_header_id
                 AND pla.line_type_id                      = plt.line_type_id
                --
                and xlq.po_header_id                       = pha.po_header_id
                and xlq.po_line_id                         = pla.po_line_id
                ;

		  --********************
          --** Type Declarations
          --********************
          --
          TYPE exp_po_lines_tt IS TABLE OF exp_po_lines%ROWTYPE INDEX BY BINARY_INTEGER;
		  exp_po_ls exp_po_lines_tt;

          --End:Added for 1.2


    BEGIN
        --
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0000';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
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
        FROM    XXMX_SCM_PO_LINES_STD_STG
          ;

        COMMIT;
        --
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

               OPEN exp_po_lines;
               --

               LOOP
                    --
                    FETCH exp_po_lines
                    BULK COLLECT
                    INTO exp_po_ls
                    LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;
                    --
                    EXIT WHEN exp_po_ls.COUNT=0;

                    FORALL I
                    IN     1.. exp_po_ls.COUNT			

               INSERT
                INTO    XXMX_SCM_PO_LINES_STD_STG
                       (MIGRATION_SET_ID				,
                        MIGRATION_SET_NAME				,
                        MIGRATION_STATUS				,
                        INTERFACE_LINE_KEY				,
                        INTERFACE_HEADER_KEY			,
                        ACTION							,
                        document_num                    ,
                        LINE_NUM						,
                        LINE_TYPE						,
                        ITEM							,
                        ITEM_DESCRIPTION				,
                        ITEM_REVISION					,
                        CATEGORY						,
                        AMOUNT	                        ,
                        original_AMOUNT							,
                        migrated_AMOUNT							,
						QUANTITY						,
                        original_QUANTITY						,
                        migrated_QUANTITY						,
                        UNIT_OF_MEASURE					,
                        UNIT_PRICE						,
                        SECONDARY_QUANTITY				,
                        SECONDARY_UNIT_OF_MEASURE		,
                        VENDOR_PRODUCT_NUM				,
                        NEGOTIATED_BY_PREPARER_FLAG		,
                        HAZARD_CLASS					,
                        UN_NUMBER						,
                        NOTE_TO_VENDOR					,
                        NOTE_TO_RECEIVER				,
                        LINE_ATTRIBUTE_CATEGORY_LINES	,
                        LINE_ATTRIBUTE1					,
                        LINE_ATTRIBUTE2					,
                        LINE_ATTRIBUTE3					,
                        LINE_ATTRIBUTE4					,
                        LINE_ATTRIBUTE5					,
                        LINE_ATTRIBUTE6					,
                        LINE_ATTRIBUTE7					,
                        LINE_ATTRIBUTE8					,
                        LINE_ATTRIBUTE9					,
                        LINE_ATTRIBUTE10				,
                        LINE_ATTRIBUTE11				,
                        LINE_ATTRIBUTE12				,
                        LINE_ATTRIBUTE13				,
                        LINE_ATTRIBUTE14				,
                        LINE_ATTRIBUTE15				,
                        LINE_ATTRIBUTE16				,
                        LINE_ATTRIBUTE17				,
                        LINE_ATTRIBUTE18				,
                        LINE_ATTRIBUTE19				,
                        LINE_ATTRIBUTE20				,
                        ATTRIBUTE_DATE1					,
                        ATTRIBUTE_DATE2					,
                        ATTRIBUTE_DATE3					,
                        ATTRIBUTE_DATE4					,
                        ATTRIBUTE_DATE5					,
                        ATTRIBUTE_DATE6					,
                        ATTRIBUTE_DATE7					,
                        ATTRIBUTE_DATE8					,
                        ATTRIBUTE_DATE9					,
                        ATTRIBUTE_DATE10				,
                        ATTRIBUTE_NUMBER1				,
                        ATTRIBUTE_NUMBER2				,
                        ATTRIBUTE_NUMBER3				,
                        ATTRIBUTE_NUMBER4				,
                        ATTRIBUTE_NUMBER5				,
                        ATTRIBUTE_NUMBER6				,
                        ATTRIBUTE_NUMBER7				,
                        ATTRIBUTE_NUMBER8				,
                        ATTRIBUTE_NUMBER9				,
                        ATTRIBUTE_NUMBER10				,
                        ATTRIBUTE_TIMESTAMP1			,
                        ATTRIBUTE_TIMESTAMP2			,
                        ATTRIBUTE_TIMESTAMP3			,
                        ATTRIBUTE_TIMESTAMP4			,
                        ATTRIBUTE_TIMESTAMP5			,
                        ATTRIBUTE_TIMESTAMP6			,
                        ATTRIBUTE_TIMESTAMP7			,
                        ATTRIBUTE_TIMESTAMP8			,
                        ATTRIBUTE_TIMESTAMP9			,
                        ATTRIBUTE_TIMESTAMP10			,
                        UNIT_WEIGHT						,
                        WEIGHT_UOM_CODE					,
                        WEIGHT_UNIT_OF_MEASURE			,
                        UNIT_VOLUME						,
                        VOLUME_UOM_CODE					,
                        VOLUME_UNIT_OF_MEASURE			,
                        TEMPLATE_NAME					,
                        ITEM_ATTRIBUTE_CATEGORY			,
                        ITEM_ATTRIBUTE1					,
                        ITEM_ATTRIBUTE2					,
                        ITEM_ATTRIBUTE3					,
                        ITEM_ATTRIBUTE4					,
                        ITEM_ATTRIBUTE5					,
                        ITEM_ATTRIBUTE6					,
                        ITEM_ATTRIBUTE7					,
                        ITEM_ATTRIBUTE8					,
                        ITEM_ATTRIBUTE9					,
                        ITEM_ATTRIBUTE10				,
                        ITEM_ATTRIBUTE11				,
                        ITEM_ATTRIBUTE12				,
                        ITEM_ATTRIBUTE13				,
                        ITEM_ATTRIBUTE14				,
                        ITEM_ATTRIBUTE15				,
                        SOURCE_AGREEMENT_PRC_BU_NAME	,
                        SOURCE_AGREEMENT				,
                        SOURCE_AGREEMENT_LINE			,
                        DISCOUNT_TYPE					,
                        DISCOUNT						,
                        DISCOUNT_REASON					,
                        MAX_RETAINAGE_AMOUNT            ,
                        PO_HEADER_ID                    ,
                        PO_LINE_ID
                    )

				VALUES (exp_po_ls(i).migration_set_id
				       ,exp_po_ls(i).migration_set_name
					   ,exp_po_ls(i).migration_status
					   ,exp_po_ls(i).interface_line_key
					   ,exp_po_ls(i).interface_header_key
					   ,exp_po_ls(i).action
					   ,exp_po_ls(i).SEGMENT1
					   ,exp_po_ls(i).LINE_NUM              															
                       ,exp_po_ls(i).LINE_TYPE       																
                       ,exp_po_ls(i).item
                       ,exp_po_ls(i).ITEM_DESCRIPTION        														
                       ,exp_po_ls(i).ITEM_REVISION       															
                       ,exp_po_ls(i).category
                       ,exp_po_ls(i).amount
                       ,exp_po_ls(i).original_amount
                       ,exp_po_ls(i).migrated_amount
                       ,exp_po_ls(i).quantity
					   ,exp_po_ls(i).original_quantity
                       ,exp_po_ls(i).new_qty_ordered
                       ,exp_po_ls(i).unit_of_measure
                       ,exp_po_ls(i).unit_price
                       ,exp_po_ls(i).SECONDARY_QUANTITY    															
                       ,exp_po_ls(i).SECONDARY_UNIT_OF_MEASURE														
                       ,exp_po_ls(i).VENDOR_PRODUCT_NUM       														
                       ,exp_po_ls(i).NEGOTIATED_BY_PREPARER_FLAG  													
                       ,exp_po_ls(i).hazard_class
                       ,exp_po_ls(i).Un_Number
                       ,exp_po_ls(i).note_to_vendor
                       ,exp_po_ls(i).note_to_receiver
					   ,exp_po_ls(i).line_attribute_category_lines
                        ,exp_po_ls(i).line_attribute1
						,exp_po_ls(i).line_attribute2
						,exp_po_ls(i).line_attribute3
						,exp_po_ls(i).line_attribute4
						,exp_po_ls(i).line_attribute5
						,exp_po_ls(i).line_attribute6
						,exp_po_ls(i).line_attribute7
						,exp_po_ls(i).line_attribute8
						,exp_po_ls(i).line_attribute9
						,exp_po_ls(i).line_attribute10
						,exp_po_ls(i).line_attribute11
						,exp_po_ls(i).line_attribute12
						,exp_po_ls(i).line_attribute13
						,exp_po_ls(i).line_attribute14
						,exp_po_ls(i).line_attribute15
						,exp_po_ls(i).line_attribute16
						,exp_po_ls(i).line_attribute17
						,exp_po_ls(i).line_attribute18
						,exp_po_ls(i).line_attribute19
						,exp_po_ls(i).line_attribute20
                        ,exp_po_ls(i).attribute_date1
						,exp_po_ls(i).attribute_date2
						,exp_po_ls(i).attribute_date3
						,exp_po_ls(i).attribute_date4
						,exp_po_ls(i).attribute_date5
						,exp_po_ls(i).attribute_date6
						,exp_po_ls(i).attribute_date7
						,exp_po_ls(i).attribute_date8
						,exp_po_ls(i).attribute_date9
						,exp_po_ls(i).attribute_date10
						,exp_po_ls(i).attribute_number1
						,exp_po_ls(i).attribute_number2
						,exp_po_ls(i).attribute_number3
						,exp_po_ls(i).attribute_number4
						,exp_po_ls(i).attribute_number5
						,exp_po_ls(i).attribute_number6
						,exp_po_ls(i).attribute_number7
						,exp_po_ls(i).attribute_number8
						,exp_po_ls(i).attribute_number9
						,exp_po_ls(i).attribute_number10
						,exp_po_ls(i).attribute_timestamp1
						,exp_po_ls(i).attribute_timestamp2
						,exp_po_ls(i).attribute_timestamp3
						,exp_po_ls(i).attribute_timestamp4
						,exp_po_ls(i).attribute_timestamp5
						,exp_po_ls(i).attribute_timestamp6
						,exp_po_ls(i).attribute_timestamp7
						,exp_po_ls(i).attribute_timestamp8
						,exp_po_ls(i).attribute_timestamp9
						,exp_po_ls(i).attribute_timestamp10
                        ,exp_po_ls(i).unit_weight
                        ,exp_po_ls(i).weight_uom_code
                        ,exp_po_ls(i).weight_unit_of_measure
                        ,exp_po_ls(i).unit_volume
                        ,exp_po_ls(i).volume_uom_code
                        ,exp_po_ls(i).volume_unit_of_measure
                        ,exp_po_ls(i).template_name
                        ,exp_po_ls(i).item_attribute_category
                        ,exp_po_ls(i).item_attribute1    
						,exp_po_ls(i).item_attribute2
						,exp_po_ls(i).item_attribute3
						,exp_po_ls(i).item_attribute4
						,exp_po_ls(i).item_attribute5
						,exp_po_ls(i).item_attribute6
						,exp_po_ls(i).item_attribute7
						,exp_po_ls(i).item_attribute8
						,exp_po_ls(i).item_attribute9
						,exp_po_ls(i).item_attribute10
						,exp_po_ls(i).item_attribute11
						,exp_po_ls(i).item_attribute12
						,exp_po_ls(i).item_attribute13
						,exp_po_ls(i).item_attribute14
                        ,exp_po_ls(i).item_attribute15
                        ,exp_po_ls(i).source_agreement_prc_bu_name
                        ,exp_po_ls(i).source_agreement
                        ,exp_po_ls(i).source_agreement_line
                        ,exp_po_ls(i).discount_type
                        ,exp_po_ls(i).discount
                        ,exp_po_ls(i).discount_reason
                        ,exp_po_ls(i).max_retainage_amount	      													
                        ,exp_po_ls(i).po_header_id               													
                        ,exp_po_ls(i).po_line_id               		
 						);

				--Start: Commented for 1.2
--				SELECT  /*+ driving_site(pha) */ distinct pt_i_MigrationSetID                               							--migration_set_id
--                        ,gvt_migrationsetname                               								--migration_set_name
--                        ,'EXTRACTED'                														--migration_status
--                        ,pla.po_line_id                                                                     --interface_line_key
--                        ,pha.po_header_id                  													--interface_header_key
--                        ,''               																	--action
--                        ,pha.SEGMENT1                                                                       -- document_num
--                        ,pla.LINE_NUM              															--line_num
--                        ,plt.LINE_TYPE       																--line_type
--                        ,(SELECT msib.segment1||'.'||msib.segment2
--                           FROM   apps.mtl_system_items_b@XXMX_EXTRACT msib
--                           WHERE  msib.inventory_item_id =  pla.item_id
--                           AND    ROWNUM = 1)             													--item
--                        ,pla.ITEM_DESCRIPTION        														--item_description
--                        ,pla.ITEM_REVISION       															--item_revision
--                        , ( SELECT mct.description
--                            FROM   apps.mtl_categories_b@XXMX_EXTRACT      mcb
--                                  ,apps.mtl_categories_tl@XXMX_EXTRACT     mct
--                            WHERE  1 = 1
--                            AND    mcb.category_id = mct.category_id
--                            AND    mcb.category_id = pla.category_id )   									--category
--                        ,case when pla.order_type_lookup_code='AMOUNT' then
--                       -- pla.QUANTITY																				-- commented by Laxmikanth for the calcuated quantity
--					   xlq.new_qty_ordered																			-- Added by Laxmikanth for the calcuated quantity
--                        ELSE
--                        pla.AMOUNT     END                                                                         -- amount
--                       , pla.AMOUNT                                                                              -- original amount
--                        ,null                                                                               -- migrated amount
--                        ,case when order_type_lookup_code='AMOUNT'then
--                        NULL
--                        ELSE
--                        pla.QUANTITY       END                                                                     -- quantity
--						,pla.QUANTITY                                                                       -- original quantity
--                        ,case when order_type_lookup_code='AMOUNT'then
--                        NULL
--                        ELSE
--                        xlq.new_qty_ordered       END 
--						--xlq.new_qty_ordered                                                                -- migrated quantity
--                        ,case when order_type_lookup_code='AMOUNT'then
--                        NULL
--                        ELSE
--                        pla.UNIT_MEAS_LOOKUP_CODE     END															--unit_of_measure
--                        ,case when order_type_lookup_code='AMOUNT'then
--                        NULL
--                        ELSE
--                        pla.UNIT_PRICE     END      																--unit_price
--                        ,pla.SECONDARY_QUANTITY    															--secondary_quantity
--                        ,pla.SECONDARY_UNIT_OF_MEASURE														--secondary_unit_of_measure
--                        ,pla.VENDOR_PRODUCT_NUM       														--vendor_product_num
--                        ,pla.NEGOTIATED_BY_PREPARER_FLAG  													--negotiated_by_preparer_flag
--                       , ( SELECT phc.hazard_class
--                            FROM   apps.po_hazard_classes_tl@XXMX_EXTRACT  phc
--                            WHERE  phc.hazard_class_id = pla.hazard_class_id)                               -- hazard_class
--                        , ( SELECT poun.un_number
--                            FROM   apps.po_un_numbers_tl@XXMX_EXTRACT poun
--                            WHERE  poun.un_number_id = pla.un_number_id)                                    --Un_Number
--                        ,REGEXP_REPLACE(pla.NOTE_TO_VENDOR, '[^[:print:]]','')																	--note_to_vendor
--                        ,''                               													--note_to_receiver
--                        ,''                               													--line_attribute_category_lines
--                        ,''                               													--line_attribute1
--                        ,''                               													--line_attribute2
--                        ,''                               													--line_attribute3
--                        ,''                               													--line_attribute4
--                        ,''                               													--line_attribute5
--                        ,''                               													--line_attribute6
--                        ,''                               													--line_attribute7
--                        ,''                               													--line_attribute8
--                        ,''                               													--line_attribute9
--                        ,''                               													--line_attribute10
--                        ,''                               													--line_attribute11
--                        ,''                               													--line_attribute12
--                        ,''                               													--line_attribute13
--                        ,''                               													--line_attribute14
--                        ,''                               													--line_attribute15
--                        ,''                               													--line_attribute16
--                        ,''                               													--line_attribute17
--                        ,''                               													--line_attribute18
--                        ,''                               													--line_attribute19
--                        ,''                               													--line_attribute20
--                        ,''                               													--attribute_date1
--                        ,''                               													--attribute_date2
--                        ,''                               													--attribute_date3
--                        ,''                               													--attribute_date4
--                        ,''                               													--attribute_date5
--                        ,''                               													--attribute_date6
--                        ,''                               													--attribute_date7
--                        ,''                               													--attribute_date8
--                        ,''                               													--attribute_date9
--                        ,''                               													--attribute_date10
--                        ,''                               													--attribute_number1
--                        ,''                               													--attribute_number2
--                        ,''                               													--attribute_number3
--                        ,''                               													--attribute_number4
--                        ,''                               													--attribute_number5
--                        ,''                               													--attribute_number6
--                        ,''                               													--attribute_number7
--                        ,''                               													--attribute_number8
--                        ,''                               													--attribute_number9
--                        ,''                               													--attribute_number10
--                        ,''                               													--attribute_timestamp1
--                        ,''                               													--attribute_timestamp2
--                        ,''                               													--attribute_timestamp3
--                        ,''                               													--attribute_timestamp4
--                        ,''                               													--attribute_timestamp5
--                        ,''                               													--attribute_timestamp6
--                        ,''                               													--attribute_timestamp7
--                        ,''                               													--attribute_timestamp8
--                        ,''                               													--attribute_timestamp9
--                        ,''                               													--attribute_timestamp10
--                        ,''                               													--unit_weight
--                        ,''                               													--weight_uom_code
--                        ,''                               													--weight_unit_of_measure
--                        ,''                               													--unit_volume
--                        ,''                               													--volume_uom_code
--                        ,''                               													--volume_unit_of_measure
--                        ,''                               													--template_name
--                        ,''                               													--item_attribute_category
--                        ,''                               													--item_attribute1
--                        ,''                               													--item_attribute2
--                        ,''                               													--item_attribute3
--                        ,''                               													--item_attribute4
--                        ,''                               													--item_attribute5
--                        ,''                               													--item_attribute6
--                        ,''                               													--item_attribute7
--                        ,''                               													--item_attribute8
--                        ,''                               													--item_attribute9
--                        ,''                               													--item_attribute10
--                        ,''                               													--item_attribute11
--                        ,''                               													--item_attribute12
--                        ,''                               													--item_attribute13
--                        ,''                               													--item_attribute14
--                        ,''                               													--item_attribute15
--                        ,''                               													--source_agreement_prc_bu_name
--                        ,''                               													--source_agreement
--                        ,''                               													--source_agreement_line
--                        ,''                               													--discount_type
--                        ,''                               													--discount
--                        ,''                               													--discount_reason
--                        ,pla.max_retainage_amount	      													--max_retainage_amount
--                        ,pha.po_header_id               													--po_header_id
--                        ,pla.po_line_id               														--po_line_id
--                FROM
--                         PO_HEADERS_ALL@XXMX_EXTRACT		    pha
--                        ,PO_LINES_ALL@XXMX_EXTRACT   			pla
--                        ,PO_LINE_TYPES_TL@XXMX_EXTRACT			plt
--                        ,XXMX_PURCHASE_ORDER_SCOPE            xpos
--                        ,xxmx_core.XXMX_PO_LINES_QTY_V          xlq
--                WHERE  1                                   = 1
--                --
--                 AND pha.type_lookup_code                  = 'STANDARD'
--                 AND pha.org_id                            = xpos.org_id
--                 AND pha.po_header_id				       = xpos.po_header_id
--                 --
--                 AND pla.po_header_id                  	   = pha.po_header_id
--                 AND pla.line_type_id                      = plt.line_type_id
--                --
--                and xlq.po_header_id                       = pha.po_header_id
--                and xlq.po_line_id                         = pla.po_line_id
--                ;
				--End: Commented for 1.2

				END LOOP;
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
            CLOSE exp_po_lines;

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
            -- Hr_Utility.raise_error@XXMX_EXTRACT;
    END export_po_lines_std;


	/****************************************************************
	----------------Export STD PO Line Locations---------------------
	*****************************************************************/

    PROCEDURE export_po_line_locations_std
        (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
        IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_po_line_locations_std';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_SCM_PO_LINE_LOCATIONS_STD_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PO_LINE_LOCATIONS_STD';

        lvv_migration_date_to                           VARCHAR2(30);
        lvv_migration_date_from                         VARCHAR2(30);
        lvv_prev_tax_year_date                          VARCHAR2(30);
        lvd_migration_date_to                           DATE;
        lvd_migration_date_from                         DATE;
        lvd_prev_tax_year_date                          DATE;

        e_DateError                         EXCEPTION;

		--Start: Added for 1.2
		CURSOR exp_po_line_locations IS 
		SELECT  /*+ driving_site(pha) */ distinct pt_i_MigrationSetID  as migration_set_id
                    ,gvt_migrationsetname  as migration_set_name
                    ,'EXTRACTED'	as migration_status
                    ,plla.line_location_id as interface_line_location_key
                    ,pla.po_line_id  as interface_line_key
                    ,pha.SEGMENT1                                                                       -- document_num
                    ,pla.line_num                                                                       -- line num
                    ,plla.shipment_num																	--shipment_num
                    ,( SELECT hrla.location_code
                       FROM   hr_locations@XXMX_EXTRACT hrla
                       WHERE  hrla.location_id = plla.ship_to_location_id )	as ship_to_location
                    ,''		as ship_to_organization_code
--                    , CASE WHEN plt.MATCHING_BASIS = 'AMOUNT'
--                           THEN (NVL(pda.amount_ordered, 0) - NVL(pda.amount_cancelled, 0) - NVL(pda.amount_billed, 0))
--                      END                                                                     		    --amount
--                    , CASE WHEN plt.MATCHING_BASIS = 'QUANTITY'
--                           THEN (pda.quantity_ordered - NVL(pda.quantity_cancelled, 0) - NVL(pda.quantity_billed, 0))
--                      END                                                                               --quantity
,0 as original_amount
,0 as migrated_amount
,case when pla.order_type_lookup_code='AMOUNT' then
                      -- (select sum(pda.quantity_ordered) from po_distributions_all@XXMX_EXTRACT  PDA where 	 pha.po_header_id = pda.po_header_id      AND pla.po_line_id= pda.po_line_id     AND plla.line_location_id  = pda.line_location_id	)
					                         	-- commented by Laxmikanth for the calcuated quantity
					   xpllq.new_qty_ordered																		-- Added by Laxmikanth for the calcuated quantity
                        ELSE
                        plla.AMOUNT     END as amount
,case when pla.order_type_lookup_code='AMOUNT'then
                        NULL
                        ELSE
                       (select sum(pda.quantity_ordered) from po_distributions_all@XXMX_EXTRACT  PDA where 	 pha.po_header_id = pda.po_header_id      AND pla.po_line_id= pda.po_line_id     AND plla.line_location_id = pda.line_location_id	)
					   END    as  quantity						
			,  (select sum(pda.quantity_ordered) from po_distributions_all@XXMX_EXTRACT  PDA where 	 pha.po_header_id = pda.po_header_id      AND pla.po_line_id= pda.po_line_id     AND plla.line_location_id  = pda.line_location_id	) as quantity_ordered                 
            ,case when pla.order_type_lookup_code='AMOUNT'then
                        NULL
                        ELSE
                       xpllq.new_qty_ordered
					   END as new_qty_ordered--xpllq.new_qty_ordered
                    ,plla.need_by_date 																	--need_by_date
                    ,plla.promised_date																	--promised_date
                    ,plla.secondary_quantity															--secondary_quantity
                    ,plla.secondary_unit_of_measure														--secondary_unit_of_measure
                    ,'' as destination_type_code																			
                    ,''	as accrue_on_receipt_flag															
                    ,''	as allow_substitute_receipts_flag																				
                    ,''	as assessable_value																
                    ,plla.days_early_receipt_allowed													--days_early_receipt_allowed
                    ,plla.days_late_receipt_allowed														--days_late_receipt_allowed
                    ,plla.enforce_ship_to_location_code													--enforce_ship_to_location_code
                    ,plla.inspection_required_flag														--inspection_required_flag
                    ,plla.receipt_required_flag															--receipt_required_flag
                    ,plla.invoice_close_tolerance														--invoice_close_tolerance
                    ,'100'  as receipt_close_tolerance --plla.receive_close_tolerance														--receipt_close_tolerance --changed as per Amit inputs (Laxmikanth)
                    ,plla.qty_rcv_tolerance																--qty_rcv_tolerance
                    ,plla.qty_rcv_exception_code														--qty_rcv_exception_code
                    ,plla.receipt_days_exception_code													--receipt_days_exception_code
                    ,(select flv.meaning from apps.fnd_lookup_values@XXMX_EXTRACT flv
where lookup_type = 'RCV_ROUTING_HEADERS' and flv.LOOKUP_CODE=	plla.RECEIVING_ROUTING_ID)	as receiving_routing
                    ,REGEXP_REPLACE(plla.note_to_receiver, '[^[:print:]]','')as note_to_receiver
                    ,'' as input_tax_classification_code
                    ,''	as line_intended_use
                    ,''	as product_category
                    ,''	as product_fisc_classification
                    ,''	as product_type
                    ,''	as trx_business_category_code
                    ,''	as user_defined_fisc_class
                    ,''	as attribute_category
                    ,''	as attribute1
                    ,''	as attribute2
                    ,''	as attribute3
                    ,''	as attribute4
                    ,''	as attribute5
                    ,''	as attribute6
                    ,''	as attribute7
                    ,''	as attribute8
                    ,''	as attribute9
                    ,''	as attribute10
                    ,''	as attribute11
                    ,''	as attribute12
                    ,''	as attribute13
                    ,''	as attribute14
                    ,''	as attribute15
                    ,''	as attribute16
                    ,''	as attribute17
                    ,''	as attribute18
                    ,''	as attribute19
                    ,''	as attribute20
                    ,''	as attribute_date1
                    ,''	as attribute_date2
                    ,''	as attribute_date3
                    ,''	as attribute_date4
                    ,''	as attribute_date5
                    ,''	as attribute_date6
                    ,''	as attribute_date7
                    ,''	as attribute_date8
                    ,''	as attribute_date9
                    ,''	as attribute_date10
                    ,''	as attribute_number1
                    ,''	as attribute_number2
                    ,''	as attribute_number3
                    ,''	as attribute_number4
                    ,''	as attribute_number5
                    ,''	as attribute_number6
                    ,''	as attribute_number7
                    ,''	as attribute_number8
                    ,''	as attribute_number9
                    ,''	as attribute_number10
                    ,''	as attribute_timestamp1
                    ,''	as attribute_timestamp2
                    ,''	as attribute_timestamp3
                    ,''	as attribute_timestamp4
                    ,''	as attribute_timestamp5
                    ,''	as attribute_timestamp6
                    ,''	as attribute_timestamp7
                    ,''	as attribute_timestamp8
                    ,''	as attribute_timestamp9
                    ,''	as attribute_timestamp10
                    ,''	as freight_carrier
                    ,''	as mode_of_transport
                    ,''	as service_level
                    ,''	as final_discharge_location_code
                    ,''	as requested_ship_date
                    ,''	as promised_ship_date
                    ,plla.need_by_date	as requested_delivery_date																--requested_delivery_date
                    ,plla.promised_date	as promised_delivery_date																--promised_delivery_date
                    ,''	as retainage_rate
                    ,'P'as invoice_match_option
                    ,pha.po_header_id																	--po_header_id
                    ,pla.po_line_id																		--po_line_id
                    ,plla.line_location_id																--line_location_id
            FROM
                     PO_HEADERS_ALL@XXMX_EXTRACT           pha
                    ,PO_LINES_ALL@XXMX_EXTRACT             pla
                    ,PO_LINE_LOCATIONS_ALL@XXMX_EXTRACT    plla
                    ,po_line_types@XXMX_EXTRACT            plt
             --       ,po_distributions_all@XXMX_EXTRACT     pda
                    ,XXMX_PURCHASE_ORDER_SCOPE           xpos
                    ,XXMX_PO_LINE_LOCATIONS_QTY_V          xpllq
              WHERE 1                                   = 1
              AND pha.type_lookup_code                  = 'STANDARD'
              AND pha.org_id                 		    = xpos.org_id
              AND pha.po_header_id				        = xpos.po_header_id
              --
              AND pla.line_type_id                      = plt.line_type_id
           --   AND pha.po_header_id                      = pda.po_header_id
          --    AND pla.po_line_id                        = pda.po_line_id
          --    AND plla.line_location_id                 = pda.line_location_id
              --
              AND pha.po_header_id                      = pla.po_header_id
              AND pla.po_header_id                      = plla.po_header_id
              AND pla.po_line_id                        = plla.po_line_id
              --
              and xpllq.po_header_id                    = pha.po_header_id
              and xpllq.po_line_id                      = pla.po_line_id
              and xpllq.line_location_id                = plla.line_location_id
              ;

         --********************
          --** Type Declarations
          --********************
          --
          TYPE exp_po_line_loc_tt IS TABLE OF exp_po_line_locations%ROWTYPE INDEX BY BINARY_INTEGER;
		  exp_po_lnloc exp_po_line_loc_tt;
          --
  --End: Added for 1.2
    BEGIN
        --
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0000';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
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
        FROM    XXMX_SCM_PO_LINE_LOCATIONS_STD_STG
          ;

        COMMIT;
        --
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

           OPEN exp_po_line_locations;
               --

               LOOP
                    --
                    FETCH exp_po_line_locations
                    BULK COLLECT
                    INTO exp_po_lnloc
                    LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;
                    --
                    EXIT WHEN exp_po_lnloc.COUNT=0;

                    FORALL I
                    IN     1..exp_po_lnloc.COUNT	

            INSERT
            INTO    XXMX_SCM_PO_LINE_LOCATIONS_STD_STG
                   (MIGRATION_SET_ID					,
                    MIGRATION_SET_NAME					,
                    MIGRATION_STATUS					,
                    INTERFACE_LINE_LOCATION_KEY			,
                    INTERFACE_LINE_KEY					,
                    document_num                        ,
                    line_num                            ,
                    SHIPMENT_NUM						,
                    SHIP_TO_LOCATION					,
                    SHIP_TO_ORGANIZATION_CODE			,
                    original_AMOUNT								,
                    migrated_AMOUNT								,
					amount								,
					quantity					,
                    original_QUANTITY							,
                    migrated_QUANTITY							,
                    NEED_BY_DATE						,
                    PROMISED_DATE						,
                    SECONDARY_QUANTITY					,
                    SECONDARY_UNIT_OF_MEASURE			,
                    DESTINATION_TYPE_CODE				,
                    ACCRUE_ON_RECEIPT_FLAG				,
                    ALLOW_SUBSTITUTE_RECEIPTS_FLAG		,
                    ASSESSABLE_VALUE					,
                    DAYS_EARLY_RECEIPT_ALLOWED			,
                    DAYS_LATE_RECEIPT_ALLOWED			,
                    ENFORCE_SHIP_TO_LOCATION_CODE		,
                    INSPECTION_REQUIRED_FLAG			,
                    RECEIPT_REQUIRED_FLAG				,
                    INVOICE_CLOSE_TOLERANCE				,
                    RECEIPT_CLOSE_TOLERANCE				,
                    QTY_RCV_TOLERANCE					,
                    QTY_RCV_EXCEPTION_CODE				,
                    RECEIPT_DAYS_EXCEPTION_CODE			,
                    RECEIVING_ROUTING					,
                    NOTE_TO_RECEIVER					,
                    INPUT_TAX_CLASSIFICATION_CODE		,
                    LINE_INTENDED_USE					,
                    PRODUCT_CATEGORY					,
                    PRODUCT_FISC_CLASSIFICATION 		,
                    PRODUCT_TYPE						,
                    TRX_BUSINESS_CATEGORY_CODE			,
                    USER_DEFINED_FISC_CLASS				,
                    ATTRIBUTE_CATEGORY					,
                    ATTRIBUTE1							,
                    ATTRIBUTE2							,
                    ATTRIBUTE3							,
                    ATTRIBUTE4							,
                    ATTRIBUTE5							,
                    ATTRIBUTE6							,
                    ATTRIBUTE7							,
                    ATTRIBUTE8							,
                    ATTRIBUTE9							,
                    ATTRIBUTE10							,
                    ATTRIBUTE11							,
                    ATTRIBUTE12							,
                    ATTRIBUTE13							,
                    ATTRIBUTE14							,
                    ATTRIBUTE15							,
                    ATTRIBUTE16							,
                    ATTRIBUTE17							,
                    ATTRIBUTE18							,
                    ATTRIBUTE19							,
                    ATTRIBUTE20							,
                    ATTRIBUTE_DATE1						,
                    ATTRIBUTE_DATE2						,
                    ATTRIBUTE_DATE3						,
                    ATTRIBUTE_DATE4						,
                    ATTRIBUTE_DATE5						,
                    ATTRIBUTE_DATE6						,
                    ATTRIBUTE_DATE7						,
                    ATTRIBUTE_DATE8						,
                    ATTRIBUTE_DATE9						,
                    ATTRIBUTE_DATE10					,
                    ATTRIBUTE_NUMBER1					,
                    ATTRIBUTE_NUMBER2					,
                    ATTRIBUTE_NUMBER3					,
                    ATTRIBUTE_NUMBER4					,
                    ATTRIBUTE_NUMBER5					,
                    ATTRIBUTE_NUMBER6					,
                    ATTRIBUTE_NUMBER7					,
                    ATTRIBUTE_NUMBER8					,
                    ATTRIBUTE_NUMBER9					,
                    ATTRIBUTE_NUMBER10					,
                    ATTRIBUTE_TIMESTAMP1				,
                    ATTRIBUTE_TIMESTAMP2				,
                    ATTRIBUTE_TIMESTAMP3				,
                    ATTRIBUTE_TIMESTAMP4				,
                    ATTRIBUTE_TIMESTAMP5				,
                    ATTRIBUTE_TIMESTAMP6				,
                    ATTRIBUTE_TIMESTAMP7				,
                    ATTRIBUTE_TIMESTAMP8				,
                    ATTRIBUTE_TIMESTAMP9				,
                    ATTRIBUTE_TIMESTAMP10				,
                    FREIGHT_CARRIER						,
                    MODE_OF_TRANSPORT					,
                    SERVICE_LEVEL						,
                    FINAL_DISCHARGE_LOCATION_CODE		,
                    REQUESTED_SHIP_DATE					,
                    PROMISED_SHIP_DATE					,
                    REQUESTED_DELIVERY_DATE				,
                    PROMISED_DELIVERY_DATE				,
                    RETAINAGE_RATE						,
                    INVOICE_MATCH_OPTION				,
                    PO_HEADER_ID						,
                    PO_LINE_ID							,
                    LINE_LOCATION_ID
                )
            VALUES ( exp_po_lnloc(i).migration_set_id
			        ,exp_po_lnloc(i).migration_set_name
					,exp_po_lnloc(i).migration_status
					,exp_po_lnloc(i).interface_line_location_key
					,exp_po_lnloc(i).interface_line_key
					,exp_po_lnloc(i).SEGMENT1                                                                       
                    ,exp_po_lnloc(i).line_num                                                                       
                    ,exp_po_lnloc(i).shipment_num																	
                    ,exp_po_lnloc(i).ship_to_location
                    ,exp_po_lnloc(i).ship_to_organization_code
					,exp_po_lnloc(i).original_amount
					,exp_po_lnloc(i).migrated_amount
					,exp_po_lnloc(i).amount
					,exp_po_lnloc(i).quantity
                    ,exp_po_lnloc(i).quantity_ordered
					,exp_po_lnloc(i).new_qty_ordered
                    ,exp_po_lnloc(i).need_by_date 																	
                    ,exp_po_lnloc(i).promised_date																	
                    ,exp_po_lnloc(i).secondary_quantity															
                    ,exp_po_lnloc(i).secondary_unit_of_measure														
                    ,exp_po_lnloc(i).destination_type_code
                    ,exp_po_lnloc(i).accrue_on_receipt_flag
                    ,exp_po_lnloc(i).allow_substitute_receipts_flag
                    ,exp_po_lnloc(i).assessable_value
                    ,exp_po_lnloc(i).days_early_receipt_allowed													
                    ,exp_po_lnloc(i).days_late_receipt_allowed														
                    ,exp_po_lnloc(i).enforce_ship_to_location_code													
                    ,exp_po_lnloc(i).inspection_required_flag														
                    ,exp_po_lnloc(i).receipt_required_flag															
                    ,exp_po_lnloc(i).invoice_close_tolerance														
                    ,exp_po_lnloc(i).receipt_close_tolerance 
                    ,exp_po_lnloc(i).qty_rcv_tolerance																
                    ,exp_po_lnloc(i).qty_rcv_exception_code														
                    ,exp_po_lnloc(i).receipt_days_exception_code													
                    ,exp_po_lnloc(i).receiving_routing
                    ,exp_po_lnloc(i).note_to_receiver
					,exp_po_lnloc(i).input_tax_classification_code
                    ,exp_po_lnloc(i).line_intended_use
                    ,exp_po_lnloc(i).product_category
                    ,exp_po_lnloc(i).product_fisc_classification
                    ,exp_po_lnloc(i).product_type
                    ,exp_po_lnloc(i).trx_business_category_code
                    ,exp_po_lnloc(i).user_defined_fisc_class
                    ,exp_po_lnloc(i).attribute_category
                    ,exp_po_lnloc(i).attribute1
                    ,exp_po_lnloc(i).attribute2
                    ,exp_po_lnloc(i).attribute3
                    ,exp_po_lnloc(i).attribute4
                    ,exp_po_lnloc(i).attribute5
                    ,exp_po_lnloc(i).attribute6
                    ,exp_po_lnloc(i).attribute7
                    ,exp_po_lnloc(i).attribute8
                    ,exp_po_lnloc(i).attribute9
                    ,exp_po_lnloc(i).attribute10
                    ,exp_po_lnloc(i).attribute11
                    ,exp_po_lnloc(i).attribute12
                    ,exp_po_lnloc(i).attribute13
                    ,exp_po_lnloc(i).attribute14
                    ,exp_po_lnloc(i).attribute15
                    ,exp_po_lnloc(i).attribute16
                    ,exp_po_lnloc(i).attribute17
                    ,exp_po_lnloc(i).attribute18
                    ,exp_po_lnloc(i).attribute19
                    ,exp_po_lnloc(i).attribute20
                    ,exp_po_lnloc(i).attribute_date1
                    ,exp_po_lnloc(i).attribute_date2
                    ,exp_po_lnloc(i).attribute_date3
                    ,exp_po_lnloc(i).attribute_date4
                    ,exp_po_lnloc(i).attribute_date5
                    ,exp_po_lnloc(i).attribute_date6
                    ,exp_po_lnloc(i).attribute_date7
                    ,exp_po_lnloc(i).attribute_date8
                    ,exp_po_lnloc(i).attribute_date9
                    ,exp_po_lnloc(i).attribute_date10
                    ,exp_po_lnloc(i).attribute_number1
                    ,exp_po_lnloc(i).attribute_number2
                    ,exp_po_lnloc(i).attribute_number3
                    ,exp_po_lnloc(i).attribute_number4
                    ,exp_po_lnloc(i).attribute_number5
                    ,exp_po_lnloc(i).attribute_number6
                    ,exp_po_lnloc(i).attribute_number7
                    ,exp_po_lnloc(i).attribute_number8
                    ,exp_po_lnloc(i).attribute_number9
                    ,exp_po_lnloc(i).attribute_number10
                    ,exp_po_lnloc(i).attribute_timestamp1
                    ,exp_po_lnloc(i).attribute_timestamp2
                    ,exp_po_lnloc(i).attribute_timestamp3
                    ,exp_po_lnloc(i).attribute_timestamp4
                    ,exp_po_lnloc(i).attribute_timestamp5
                    ,exp_po_lnloc(i).attribute_timestamp6
                    ,exp_po_lnloc(i).attribute_timestamp7
                    ,exp_po_lnloc(i).attribute_timestamp8
                    ,exp_po_lnloc(i).attribute_timestamp9
                    ,exp_po_lnloc(i).attribute_timestamp10
                    ,exp_po_lnloc(i).freight_carrier
                    ,exp_po_lnloc(i).mode_of_transport
                    ,exp_po_lnloc(i).service_level
                    ,exp_po_lnloc(i).final_discharge_location_code
                    ,exp_po_lnloc(i).requested_ship_date
                    ,exp_po_lnloc(i).promised_ship_date
                    ,exp_po_lnloc(i).requested_delivery_date																	
                    ,exp_po_lnloc(i).promised_delivery_date																	
                    ,exp_po_lnloc(i).retainage_rate
                    ,exp_po_lnloc(i).invoice_match_option
                    ,exp_po_lnloc(i).po_header_id																	
                    ,exp_po_lnloc(i).po_line_id																		
                    ,exp_po_lnloc(i).line_location_id		                  			
			);

			END LOOP;

			--Start: Commented for 1.2
--			SELECT  /*+ driving_site(pha) */ distinct pt_i_MigrationSetID  														--migration_set_id
--                    ,gvt_migrationsetname        														--migration_set_name
--                    ,'EXTRACTED'																		--migration_status
--                    ,plla.line_location_id                                                              --interface_line_location_key
--                    ,pla.po_line_id                                                                     --interface_line_key
--                    ,pha.SEGMENT1                                                                       -- document_num
--                    ,pla.line_num                                                                       -- line num
--                    ,plla.shipment_num																	--shipment_num
--                    ,( SELECT hrla.location_code
--                       FROM   hr_locations@XXMX_EXTRACT hrla
--                       WHERE  hrla.location_id = plla.ship_to_location_id )								--ship_to_location
--                    ,''																					--ship_to_organization_code
----                    , CASE WHEN plt.MATCHING_BASIS = 'AMOUNT'
----                           THEN (NVL(pda.amount_ordered, 0) - NVL(pda.amount_cancelled, 0) - NVL(pda.amount_billed, 0))
----                      END                                                                     		    --amount
----                    , CASE WHEN plt.MATCHING_BASIS = 'QUANTITY'
----                           THEN (pda.quantity_ordered - NVL(pda.quantity_cancelled, 0) - NVL(pda.quantity_billed, 0))
----                      END                                                                               --quantity
--,0
--,0
--,case when pla.order_type_lookup_code='AMOUNT' then
--                      -- (select sum(pda.quantity_ordered) from po_distributions_all@XXMX_EXTRACT  PDA where 	 pha.po_header_id = pda.po_header_id      AND pla.po_line_id= pda.po_line_id     AND plla.line_location_id  = pda.line_location_id	)
--					                         	-- commented by Laxmikanth for the calcuated quantity
--					   xpllq.new_qty_ordered																		-- Added by Laxmikanth for the calcuated quantity
--                        ELSE
--                        plla.AMOUNT     END                                                                         -- amount
--,case when pla.order_type_lookup_code='AMOUNT'then
--                        NULL
--                        ELSE
--                       (select sum(pda.quantity_ordered) from po_distributions_all@XXMX_EXTRACT  PDA where 	 pha.po_header_id = pda.po_header_id      AND pla.po_line_id= pda.po_line_id     AND plla.line_location_id = pda.line_location_id	)
--					   END                                                                     -- quantity						
--
--
--			,  (select sum(pda.quantity_ordered) from po_distributions_all@XXMX_EXTRACT  PDA where 	 pha.po_header_id = pda.po_header_id      AND pla.po_line_id= pda.po_line_id     AND plla.line_location_id                 = pda.line_location_id	)
--                    ,case when pla.order_type_lookup_code='AMOUNT'then
--                        NULL
--                        ELSE
--                       xpllq.new_qty_ordered
--					   END --xpllq.new_qty_ordered
--                    ,plla.need_by_date 																	--need_by_date
--                    ,plla.promised_date																	--promised_date
--                    ,plla.secondary_quantity															--secondary_quantity
--                    ,plla.secondary_unit_of_measure														--secondary_unit_of_measure
--                    ,''																					--destination_type_code
--                    ,''																					--accrue_on_receipt_flag
--                    ,''																					--allow_substitute_receipts_flag
--                    ,''																					--assessable_value
--                    ,plla.days_early_receipt_allowed													--days_early_receipt_allowed
--                    ,plla.days_late_receipt_allowed														--days_late_receipt_allowed
--                    ,plla.enforce_ship_to_location_code													--enforce_ship_to_location_code
--                    ,plla.inspection_required_flag														--inspection_required_flag
--                    ,plla.receipt_required_flag															--receipt_required_flag
--                    ,plla.invoice_close_tolerance														--invoice_close_tolerance
--                    ,'100'  --plla.receive_close_tolerance														--receipt_close_tolerance --changed as per Amit inputs (Laxmikanth)
--                    ,plla.qty_rcv_tolerance																--qty_rcv_tolerance
--                    ,plla.qty_rcv_exception_code														--qty_rcv_exception_code
--                    ,plla.receipt_days_exception_code													--receipt_days_exception_code
--                    ,(select flv.meaning from apps.fnd_lookup_values@XXMX_EXTRACT flv
--where lookup_type = 'RCV_ROUTING_HEADERS' and flv.LOOKUP_CODE=	plla.RECEIVING_ROUTING_ID)																			--receiving_routing
--                    ,REGEXP_REPLACE(plla.note_to_receiver, '[^[:print:]]','')																--note_to_receiver
--                    ,''																					--input_tax_classification_code
--                    ,''																					--line_intended_use
--                    ,''																					--product_category
--                    ,''																					--product_fisc_classification
--                    ,''																					--product_type
--                    ,''																					--trx_business_category_code
--                    ,''																					--user_defined_fisc_class
--                    ,''																					--attribute_category
--                    ,''																					--attribute1
--                    ,''																					--attribute2
--                    ,''																					--attribute3
--                    ,''																					--attribute4
--                    ,''																					--attribute5
--                    ,''																					--attribute6
--                    ,''																					--attribute7
--                    ,''																					--attribute8
--                    ,''																					--attribute9
--                    ,''																					--attribute10
--                    ,''																					--attribute11
--                    ,''																					--attribute12
--                    ,''																					--attribute13
--                    ,''																					--attribute14
--                    ,''																					--attribute15
--                    ,''																					--attribute16
--                    ,''																					--attribute17
--                    ,''																					--attribute18
--                    ,''																					--attribute19
--                    ,''																					--attribute20
--                    ,''																					--attribute_date1
--                    ,''																					--attribute_date2
--                    ,''																					--attribute_date3
--                    ,''																					--attribute_date4
--                    ,''																					--attribute_date5
--                    ,''																					--attribute_date6
--                    ,''																					--attribute_date7
--                    ,''																					--attribute_date8
--                    ,''																					--attribute_date9
--                    ,''																					--attribute_date10
--                    ,''																					--attribute_number1
--                    ,''																					--attribute_number2
--                    ,''																					--attribute_number3
--                    ,''																					--attribute_number4
--                    ,''																					--attribute_number5
--                    ,''																					--attribute_number6
--                    ,''																					--attribute_number7
--                    ,''																					--attribute_number8
--                    ,''																					--attribute_number9
--                    ,''																					--attribute_number10
--                    ,''																					--attribute_timestamp1
--                    ,''																					--attribute_timestamp2
--                    ,''																					--attribute_timestamp3
--                    ,''																					--attribute_timestamp4
--                    ,''																					--attribute_timestamp5
--                    ,''																					--attribute_timestamp6
--                    ,''																					--attribute_timestamp7
--                    ,''																					--attribute_timestamp8
--                    ,''																					--attribute_timestamp9
--                    ,''																					--attribute_timestamp10
--                    ,''																					--freight_carrier
--                    ,''																					--mode_of_transport
--                    ,''																					--service_level
--                    ,''																					--final_discharge_location_code
--                    ,''																					--requested_ship_date
--                    ,''																					--promised_ship_date
--                    ,plla.need_by_date																	--requested_delivery_date
--                    ,plla.promised_date																	--promised_delivery_date
--                    ,''																					--retainage_rate
--                    ,'P'																					--invoice_match_option
--                    ,pha.po_header_id																	--po_header_id
--                    ,pla.po_line_id																		--po_line_id
--                    ,plla.line_location_id																--line_location_id
--            FROM
--                     PO_HEADERS_ALL@XXMX_EXTRACT           pha
--                    ,PO_LINES_ALL@XXMX_EXTRACT             pla
--                    ,PO_LINE_LOCATIONS_ALL@XXMX_EXTRACT    plla
--                    ,po_line_types@XXMX_EXTRACT            plt
--             --       ,po_distributions_all@XXMX_EXTRACT     pda
--                    ,XXMX_PURCHASE_ORDER_SCOPE           xpos
--                    ,XXMX_PO_LINE_LOCATIONS_QTY_V          xpllq
--              WHERE 1                                   = 1
--              AND pha.type_lookup_code                  = 'STANDARD'
--              AND pha.org_id                 		    = xpos.org_id
--              AND pha.po_header_id				        = xpos.po_header_id
--              --
--              AND pla.line_type_id                      = plt.line_type_id
--           --   AND pha.po_header_id                      = pda.po_header_id
--          --    AND pla.po_line_id                        = pda.po_line_id
--          --    AND plla.line_location_id                 = pda.line_location_id
--              --
--              AND pha.po_header_id                      = pla.po_header_id
--              AND pla.po_header_id                      = plla.po_header_id
--              AND pla.po_line_id                        = plla.po_line_id
--              --
--              and xpllq.po_header_id                    = pha.po_header_id
--              and xpllq.po_line_id                      = pla.po_line_id
--              and xpllq.line_location_id                = plla.line_location_id
--              ;
         --End: Commented for 1.2
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

            CLOSE exp_po_line_locations;

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
            -- Hr_Utility.raise_error@XXMX_EXTRACT;
    END export_po_line_locations_std;


	/****************************************************************
	----------------Export STD PO Distributions----------------------
	*****************************************************************/

    PROCEDURE export_po_distributions_std
        (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
        IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_po_distributions_std';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_SCM_PO_DISTRIBUTIONS_STD_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PO_DISTRIBUTIONS_STD';

        lvv_migration_date_to                           VARCHAR2(30);
        lvv_migration_date_from                         VARCHAR2(30);
        lvv_prev_tax_year_date                          VARCHAR2(30);
        lvd_migration_date_to                           DATE;
        lvd_migration_date_from                         DATE;
        lvd_prev_tax_year_date                          DATE;

        e_DateError                         EXCEPTION;

		CURSOR exp_po_dists IS 
		--Start: Added for 1.2
		 SELECT  /*+ driving_site(pha) */ distinct pt_i_MigrationSetID  as migration_set_id
                    ,gvt_migrationsetname  as migration_set_name
                    ,'EXTRACTED'as migration_status
                    ,pda.po_distribution_id as interface_distribution_key
                    ,plla.line_location_id as interface_line_location_key
                    ,pha.SEGMENT1   as document_num
                    ,pla.line_num                                                                       -- line num
                    ,plla.shipment_num                                                                  -- shipment num
                    ,pda.distribution_num 																--distribution num
                    ,( SELECT hrlb.location_code
                       FROM   hr_locations@XXMX_EXTRACT hrlb
                       WHERE  1 = 1
                       AND    hrlb.location_id = pda.deliver_to_location_id)as deliver_to_location
--                    ,''																			    --deliver_to_person_full_name
                    ,(SELECT ppf.last_name||', '||ppf.first_name
                      FROM   per_all_people_f@XXMX_EXTRACT ppf
                      WHERE  ppf.person_id = pda.deliver_to_person_id
                      AND    ppf.effective_start_date = (SELECT max(effective_start_Date)
                                                         FROM   per_all_people_f@XXMX_EXTRACT ppfl
                                                         WHERE  ppfl.person_id = ppf.person_id))as deliver_to_person_full_name
                    ,pda.deliver_to_person_id                                                           --deliver_to_person_id
                    ,pda.destination_subinventory 														--destination_subinventory
--                    , CASE WHEN plt.MATCHING_BASIS = 'AMOUNT'
--                           THEN (NVL(pda.amount_ordered, 0) - NVL(pda.amount_cancelled, 0) - NVL(pda.amount_billed, 0))
--                      END                                                                     		    --amount
--                    , CASE WHEN plt.MATCHING_BASIS = 'QUANTITY'
--                           THEN (pda.quantity_ordered - NVL(pda.quantity_cancelled, 0) - NVL(pda.quantity_billed, 0))
--                      END                                                                               --quantity
,0 as Original_ammout
,0 as  migrated_amount
,case when pla.order_type_lookup_code='AMOUNT' then
                       -- pda.quantity_ordered															-- Commented by Laxmikanth for getting the the calculated quantity
						xpdq.new_qty_ordered															-- Added by Laxmikanth for getting the the calculated quantity
                        ELSE
                        pda.amount_ordered     END   as amount_ordered
,case when pla.order_type_lookup_code='AMOUNT'then
                        NULL
                        ELSE
                        pda.quantity_ordered       END as  quantity_ordered						
				--	,pda.quantity_ordered																--quantity_ordered
                    ,pda.quantity_ordered as original_qty_ordered
                    ,case when pla.order_type_lookup_code='AMOUNT'then
                        NULL
                        ELSE
                        xpdq.new_qty_ordered       END as new_qty_ordered--xpdq.new_qty_ordered
                    ,gcc.segment1																		--charge_account_segment1
                    ,gcc.segment2																		--charge_account_segment2
                    ,gcc.segment3																		--charge_account_segment3
                    ,gcc.segment4																		--charge_account_segment4
                    ,gcc.segment5																		--charge_account_segment5
                    ,gcc.segment6																		--charge_account_segment6
                    ,gcc.segment7																		--charge_account_segment7
                    ,gcc.segment8																		--charge_account_segment8
                    ,gcc.segment9																		--charge_account_segment9
                    ,'' as charge_account_segment10
                    ,''	as charge_account_segment11
                    ,''	as charge_account_segment12
                    ,''	as charge_account_segment13
                    ,''	as charge_account_segment14
                    ,''	as charge_account_segment15
                    ,''	as charge_account_segment16
                    ,''	as charge_account_segment17
                    ,''	as charge_account_segment18
                    ,''	as charge_account_segment19
                    ,''	as charge_account_segment20
                    ,''	as charge_account_segment21
                    ,''	as charge_account_segment22
                    ,''	as charge_account_segment23
                    ,''	as charge_account_segment24
                    ,''	as charge_account_segment25
                    ,''	as charge_account_segment26
                    ,''	as charge_account_segment27
                    ,''	as charge_account_segment28
                    ,''	as charge_account_segment29
                    ,''	as charge_account_segment30
                    ,pda.destination_context															--destination_context
                    ,(SELECT p.segment1
                      FROM   pa_projects_all@XXMX_EXTRACT p
                      WHERE  p.project_id=pda.project_id)as project
                    ,(SELECT t.task_number
                      FROM   pa_tasks@XXMX_EXTRACT t
                      WHERE  t.task_id = pda.task_id)as task
                    ,pda.expenditure_item_date															--pjc_expenditure_item_date
                    ,pda.expenditure_type																--expenditure_type
                    ,(SELECT haou.name
                      FROM   apps.hr_all_organization_units@XXMX_EXTRACT haou
                      where  haou.organization_id =pda.expenditure_organization_id)as expenditure_organization
                    ,''	as pjc_billable_flag
                    ,''	as pjc_capitalizable_flag
                    ,''	as pjc_work_type
                    ,''	as pjc_reserved_attribute1
                    ,''	as pjc_reserved_attribute2
                    ,''	as pjc_reserved_attribute3
                    ,''	as pjc_reserved_attribute4
                    ,''	as pjc_reserved_attribute5
                    ,''	as pjc_reserved_attribute6
                    ,''	as pjc_reserved_attribute7
                    ,''	as pjc_reserved_attribute8
                    ,''	as pjc_reserved_attribute9
                    ,''	as pjc_reserved_attribute10
                    ,''	as pjc_user_def_attribute1
                    ,''	as pjc_user_def_attribute2
                    ,''	as pjc_user_def_attribute3
                    ,''	as pjc_user_def_attribute4
                    ,''	as pjc_user_def_attribute5
                    ,''	as pjc_user_def_attribute6
                    ,''	as pjc_user_def_attribute7
                    ,''	as pjc_user_def_attribute8
                    ,''	as pjc_user_def_attribute9
                    ,''	as pjc_user_def_attribute10
                    ,pda.rate																			--rate
                    ,decode(pda.RATE,null,null,pda.RATE_DATE)	as rate_date
                    ,''	as attribute_category
                    ,''	as attribute1
                    ,''	as attribute2
                    ,''	as attribute3
                    ,''	as attribute4
                    ,''	as attribute5
                    ,''	as attribute6
                    ,''	as attribute7
                    ,''	as attribute8
                    ,''	as attribute9
                    ,''	as attribute10
                    ,''	as attribute11
                    ,''	as attribute12
                    ,''	as attribute13
                    ,''	as attribute14
                    ,''	as attribute15
                    ,''	as attribute16
                    ,''	as attribute17
                    ,''	as attribute18
                    ,''	as attribute19
                    ,''	as attribute20
                    ,''	as attribute_date1
                    ,''	as attribute_date2
                    ,''	as attribute_date3
                    ,''	as attribute_date4
                    ,''	as attribute_date5
                    ,''	as attribute_date6
                    ,''	as attribute_date7
                    ,''	as attribute_date8
                    ,''	as attribute_date9
                    ,''	as attribute_date10
                    ,''	as attribute_number1
                    ,''	as attribute_number2
                    ,''	as attribute_number3
                    ,''	as attribute_number4
                    ,''	as attribute_number5
                    ,''	as attribute_number6
                    ,''	as attribute_number7
                    ,''	as attribute_number8
                    ,''	as attribute_number9
                    ,''	as attribute_number10
                    ,''	as attribute_timestamp1
                    ,''	as attribute_timestamp2
                    ,''	as attribute_timestamp3
                    ,''	as attribute_timestamp4
                    ,''	as attribute_timestamp5
                    ,''	as attribute_timestamp6
                    ,''	as attribute_timestamp7
                    ,''	as attribute_timestamp8
                    ,''	as attribute_timestamp9
                    ,''	as attribute_timestamp10
                    ,CASE when pda.deliver_to_location_id is not null
                        then (select lower(ppf.email_address)
                              from   per_all_people_f@XXMX_EXTRACT  ppf
                              where  ppf.person_id = pda.deliver_to_person_id
                              and    ppf.email_address is not null
                              and    ppf.effective_start_date =  ( select max(effective_start_date)
                                                                   from   per_all_people_f@XXMX_EXTRACT  ppf1
                                                                   where  ppf1.person_id = ppf.person_id)
                              )  end as deliver_to_person_email_addr
                    ,''	as budget_date
                    ,''	as pjc_contract_number
                    ,''	as pjc_funding_source
                    ,pha.po_header_id																	--po_header_id
                    ,pla.po_line_id																		--po_line_id
                    ,plla.line_location_id																--line_location_id
                    ,pda.po_distribution_id																--po_distribution_id
            FROM
                     PO_HEADERS_ALL@XXMX_EXTRACT             pha
                    ,PO_LINES_ALL@XXMX_EXTRACT               pla
                    ,PO_LINE_LOCATIONS_ALL@XXMX_EXTRACT      plla
                    ,PO_DISTRIBUTIONS_ALL@XXMX_EXTRACT       pda
                    ,gl_code_combinations@XXMX_EXTRACT       gcc
                    ,po_line_types@XXMX_EXTRACT              plt
                    ,XXMX_PURCHASE_ORDER_SCOPE            xpos
                    ,xxmx_core.XXMX_PO_DISTRIBUTIONS_QTY_V   xpdq
              WHERE 1                                   = 1
              AND pha.type_lookup_code                  = 'STANDARD'
              AND pha.org_id                 		    = xpos.org_id
              AND pha.po_header_id				        = xpos.po_header_id
              --
              AND  NVL(pda.code_combination_id, 0)      = gcc.code_combination_id(+)
              AND pla.line_type_id                      = plt.line_type_id
              --
              AND pda.po_header_id                      = pha.po_header_id
              AND pda.po_line_id                        = pla.po_line_id
              AND pda.line_location_id                  = plla.line_location_id
              --
              and xpdq.po_header_id                     = pda.po_header_id
              and xpdq.po_line_id                       = pda.po_line_id
              and xpdq.line_location_id                 = pda.line_location_id
			  and pda.po_distribution_id =xpdq.po_distribution_id 
              ;

	      --********************
          --** Type Declarations
          --********************
          --
          TYPE exp_po_dists_tt IS TABLE OF exp_po_dists%ROWTYPE INDEX BY BINARY_INTEGER;
		  exp_po_dt exp_po_dists_tt;

		--End: Added for 1.2

    BEGIN
        --
        gvv_ReturnStatus  := '';
        gvt_ReturnMessage := '';
        gvv_ProgressIndicator := '0000';
        xxmx_utilities_pkg.clear_messages
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
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
        FROM    XXMX_SCM_PO_DISTRIBUTIONS_STD_STG
          ;

        COMMIT;
        --
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

              OPEN exp_po_dists;
               --

               LOOP
                    --
                    FETCH exp_po_dists
                    BULK COLLECT
                    INTO exp_po_dt
                    LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;
                    --
                    EXIT WHEN exp_po_dt.COUNT=0;

                    FORALL I
                    IN     1.. exp_po_dt.COUNT

            INSERT
            INTO    XXMX_SCM_PO_DISTRIBUTIONS_STD_STG
                   (MIGRATION_SET_ID				,
                    MIGRATION_SET_NAME				,
                    MIGRATION_STATUS				,
                    INTERFACE_DISTRIBUTION_KEY		,
                    INTERFACE_LINE_LOCATION_KEY		,
                    document_num                    ,
                    line_num                        ,
                    shipment_num                    ,
                    DISTRIBUTION_NUM				,
                    DELIVER_TO_LOCATION				,
                    DELIVER_TO_PERSON_FULL_NAME		,
                    DELIVER_TO_PERSON_ID            ,
                    DESTINATION_SUBINVENTORY		,
                    original_AMOUNT_ORDERED					,
                    migrated_AMOUNT_ORDERED					,
					amount_ordered					,
                    quantity_ordered,
                    original_QUANTITY_ORDERED				,
                    migrated_QUANTITY_ORDERED				,
                    CHARGE_ACCOUNT_SEGMENT1			,
                    CHARGE_ACCOUNT_SEGMENT2			,
                    CHARGE_ACCOUNT_SEGMENT3			,
                    CHARGE_ACCOUNT_SEGMENT4			,
                    CHARGE_ACCOUNT_SEGMENT5			,
                    CHARGE_ACCOUNT_SEGMENT6			,
                    CHARGE_ACCOUNT_SEGMENT7			,
                    CHARGE_ACCOUNT_SEGMENT8			,
                    CHARGE_ACCOUNT_SEGMENT9			,
                    CHARGE_ACCOUNT_SEGMENT10		,
                    CHARGE_ACCOUNT_SEGMENT11		,
                    CHARGE_ACCOUNT_SEGMENT12		,
                    CHARGE_ACCOUNT_SEGMENT13		,
                    CHARGE_ACCOUNT_SEGMENT14		,
                    CHARGE_ACCOUNT_SEGMENT15		,
                    CHARGE_ACCOUNT_SEGMENT16		,
                    CHARGE_ACCOUNT_SEGMENT17		,
                    CHARGE_ACCOUNT_SEGMENT18		,
                    CHARGE_ACCOUNT_SEGMENT19		,
                    CHARGE_ACCOUNT_SEGMENT20		,
                    CHARGE_ACCOUNT_SEGMENT21		,
                    CHARGE_ACCOUNT_SEGMENT22		,
                    CHARGE_ACCOUNT_SEGMENT23		,
                    CHARGE_ACCOUNT_SEGMENT24		,
                    CHARGE_ACCOUNT_SEGMENT25		,
                    CHARGE_ACCOUNT_SEGMENT26		,
                    CHARGE_ACCOUNT_SEGMENT27		,
                    CHARGE_ACCOUNT_SEGMENT28		,
                    CHARGE_ACCOUNT_SEGMENT29		,
                    CHARGE_ACCOUNT_SEGMENT30		,
                    DESTINATION_CONTEXT				,
                    PROJECT							,
                    TASK							,
                    PJC_EXPENDITURE_ITEM_DATE		,
                    EXPENDITURE_TYPE				,
                    EXPENDITURE_ORGANIZATION		,
                    PJC_BILLABLE_FLAG				,
                    PJC_CAPITALIZABLE_FLAG			,
                    PJC_WORK_TYPE					,
                    PJC_RESERVED_ATTRIBUTE1			,
                    PJC_RESERVED_ATTRIBUTE2			,
                    PJC_RESERVED_ATTRIBUTE3			,
                    PJC_RESERVED_ATTRIBUTE4			,
                    PJC_RESERVED_ATTRIBUTE5			,
                    PJC_RESERVED_ATTRIBUTE6			,
                    PJC_RESERVED_ATTRIBUTE7			,
                    PJC_RESERVED_ATTRIBUTE8			,
                    PJC_RESERVED_ATTRIBUTE9			,
                    PJC_RESERVED_ATTRIBUTE10		,
                    PJC_USER_DEF_ATTRIBUTE1			,
                    PJC_USER_DEF_ATTRIBUTE2			,
                    PJC_USER_DEF_ATTRIBUTE3			,
                    PJC_USER_DEF_ATTRIBUTE4			,
                    PJC_USER_DEF_ATTRIBUTE5			,
                    PJC_USER_DEF_ATTRIBUTE6			,
                    PJC_USER_DEF_ATTRIBUTE7			,
                    PJC_USER_DEF_ATTRIBUTE8			,
                    PJC_USER_DEF_ATTRIBUTE9			,
                    PJC_USER_DEF_ATTRIBUTE10		,
                    RATE							,
                    RATE_DATE						,
                    ATTRIBUTE_CATEGORY				,
                    ATTRIBUTE1						,
                    ATTRIBUTE2						,
                    ATTRIBUTE3						,
                    ATTRIBUTE4						,
                    ATTRIBUTE5						,
                    ATTRIBUTE6						,
                    ATTRIBUTE7						,
                    ATTRIBUTE8						,
                    ATTRIBUTE9						,
                    ATTRIBUTE10						,
                    ATTRIBUTE11						,
                    ATTRIBUTE12						,
                    ATTRIBUTE13						,
                    ATTRIBUTE14						,
                    ATTRIBUTE15						,
                    ATTRIBUTE16						,
                    ATTRIBUTE17						,
                    ATTRIBUTE18						,
                    ATTRIBUTE19						,
                    ATTRIBUTE20						,
                    ATTRIBUTE_DATE1					,
                    ATTRIBUTE_DATE2					,
                    ATTRIBUTE_DATE3					,
                    ATTRIBUTE_DATE4					,
                    ATTRIBUTE_DATE5					,
                    ATTRIBUTE_DATE6					,
                    ATTRIBUTE_DATE7					,
                    ATTRIBUTE_DATE8					,
                    ATTRIBUTE_DATE9					,
                    ATTRIBUTE_DATE10				,
                    ATTRIBUTE_NUMBER1				,
                    ATTRIBUTE_NUMBER2				,
                    ATTRIBUTE_NUMBER3				,
                    ATTRIBUTE_NUMBER4				,
                    ATTRIBUTE_NUMBER5				,
                    ATTRIBUTE_NUMBER6				,
                    ATTRIBUTE_NUMBER7				,
                    ATTRIBUTE_NUMBER8				,
                    ATTRIBUTE_NUMBER9				,
                    ATTRIBUTE_NUMBER10				,
                    ATTRIBUTE_TIMESTAMP1			,
                    ATTRIBUTE_TIMESTAMP2			,
                    ATTRIBUTE_TIMESTAMP3			,
                    ATTRIBUTE_TIMESTAMP4			,
                    ATTRIBUTE_TIMESTAMP5			,
                    ATTRIBUTE_TIMESTAMP6			,
                    ATTRIBUTE_TIMESTAMP7			,
                    ATTRIBUTE_TIMESTAMP8			,
                    ATTRIBUTE_TIMESTAMP9			,
                    ATTRIBUTE_TIMESTAMP10			,
                    DELIVER_TO_PERSON_EMAIL_ADDR	,
                    BUDGET_DATE						,
                    PJC_CONTRACT_NUMBER				,
                    PJC_FUNDING_SOURCE				,
                    PO_HEADER_ID					,
                    PO_LINE_ID						,
                    LINE_LOCATION_ID				,
                    PO_DISTRIBUTION_ID
                )


			VALUES (exp_po_dt(i).migration_set_id
			       ,exp_po_dt(i).migration_set_name
				   ,exp_po_dt(i).migration_status
				   ,exp_po_dt(i).interface_distribution_key
                   ,exp_po_dt(i).interface_line_location_key
                   ,exp_po_dt(i).document_num                                                                       -- document num
                   ,exp_po_dt(i).line_num                                                                       -- line num
                   ,exp_po_dt(i).shipment_num                                                                  -- shipment num
                   ,exp_po_dt(i).distribution_num 																--distribution num
                   ,exp_po_dt(i).deliver_to_location
                   ,exp_po_dt(i).deliver_to_person_full_name
                   ,exp_po_dt(i).deliver_to_person_id                                                           --deliver_to_person_id
                   ,exp_po_dt(i).destination_subinventory 														--destination_subinventory
					,exp_po_dt(i).Original_ammout
					,exp_po_dt(i).migrated_amount
,exp_po_dt(i).amount_ordered
,exp_po_dt(i).quantity_ordered						
                    ,exp_po_dt(i).original_qty_ordered
                    ,exp_po_dt(i).new_qty_ordered
                    ,exp_po_dt(i).segment1																		--charge_account_segment1
                    ,exp_po_dt(i).segment2																		--charge_account_segment2
                    ,exp_po_dt(i).segment3																		--charge_account_segment3
                    ,exp_po_dt(i).segment4																		--charge_account_segment4
                    ,exp_po_dt(i).segment5																		--charge_account_segment5
                    ,exp_po_dt(i).segment6																		--charge_account_segment6
                    ,exp_po_dt(i).segment7																		--charge_account_segment7
                    ,exp_po_dt(i).segment8																		--charge_account_segment8
                    ,exp_po_dt(i).segment9																		--charge_account_segment9
                    ,exp_po_dt(i).charge_account_segment10
                    ,exp_po_dt(i).charge_account_segment11
                    ,exp_po_dt(i).charge_account_segment12
                    ,exp_po_dt(i).charge_account_segment13
                    ,exp_po_dt(i).charge_account_segment14
                    ,exp_po_dt(i).charge_account_segment15
                    ,exp_po_dt(i).charge_account_segment16
                    ,exp_po_dt(i).charge_account_segment17
                    ,exp_po_dt(i).charge_account_segment18
                    ,exp_po_dt(i).charge_account_segment19
                    ,exp_po_dt(i).charge_account_segment20
                    ,exp_po_dt(i).charge_account_segment21
                    ,exp_po_dt(i).charge_account_segment22
                    ,exp_po_dt(i).charge_account_segment23
                    ,exp_po_dt(i).charge_account_segment24
                    ,exp_po_dt(i).charge_account_segment25
                    ,exp_po_dt(i).charge_account_segment26
                    ,exp_po_dt(i).charge_account_segment27
                    ,exp_po_dt(i).charge_account_segment28
                    ,exp_po_dt(i).charge_account_segment29
                    ,exp_po_dt(i).charge_account_segment30
                    ,exp_po_dt(i).destination_context															
                    ,exp_po_dt(i).project
                    ,exp_po_dt(i).task
                    ,exp_po_dt(i).expenditure_item_date															
                    ,exp_po_dt(i).expenditure_type																
                    ,exp_po_dt(i).expenditure_organization
                    ,exp_po_dt(i).pjc_billable_flag
                    ,exp_po_dt(i).pjc_capitalizable_flag
                    ,exp_po_dt(i).pjc_work_type
                    ,exp_po_dt(i).pjc_reserved_attribute1
                    ,exp_po_dt(i).pjc_reserved_attribute2
                    ,exp_po_dt(i).pjc_reserved_attribute3
                    ,exp_po_dt(i).pjc_reserved_attribute4
                    ,exp_po_dt(i).pjc_reserved_attribute5
                    ,exp_po_dt(i).pjc_reserved_attribute6
                    ,exp_po_dt(i).pjc_reserved_attribute7
                    ,exp_po_dt(i).pjc_reserved_attribute8
                    ,exp_po_dt(i).pjc_reserved_attribute9
                    ,exp_po_dt(i).pjc_reserved_attribute10
                    ,exp_po_dt(i).pjc_user_def_attribute1
                    ,exp_po_dt(i).pjc_user_def_attribute2
                    ,exp_po_dt(i).pjc_user_def_attribute3
                    ,exp_po_dt(i).pjc_user_def_attribute4
                    ,exp_po_dt(i).pjc_user_def_attribute5
                    ,exp_po_dt(i).pjc_user_def_attribute6
                    ,exp_po_dt(i).pjc_user_def_attribute7
                    ,exp_po_dt(i).pjc_user_def_attribute8
                    ,exp_po_dt(i).pjc_user_def_attribute9
                    ,exp_po_dt(i).pjc_user_def_attribute10
                    ,exp_po_dt(i).rate																			
                    ,exp_po_dt(i).rate_date
                    ,exp_po_dt(i).attribute_category
                    ,exp_po_dt(i).attribute1
                    ,exp_po_dt(i).attribute2
                    ,exp_po_dt(i).attribute3
                    ,exp_po_dt(i).attribute4
                    ,exp_po_dt(i).attribute5
                    ,exp_po_dt(i).attribute6
                    ,exp_po_dt(i).attribute7
                    ,exp_po_dt(i).attribute8
                    ,exp_po_dt(i).attribute9
                    ,exp_po_dt(i).attribute10
                    ,exp_po_dt(i).attribute11
                    ,exp_po_dt(i).attribute12
                    ,exp_po_dt(i).attribute13
                    ,exp_po_dt(i).attribute14
                    ,exp_po_dt(i).attribute15
                    ,exp_po_dt(i).attribute16
                    ,exp_po_dt(i).attribute17
                    ,exp_po_dt(i).attribute18
                    ,exp_po_dt(i).attribute19
                    ,exp_po_dt(i).attribute20
                    ,exp_po_dt(i).attribute_date1
                    ,exp_po_dt(i).attribute_date2
                    ,exp_po_dt(i).attribute_date3
                    ,exp_po_dt(i).attribute_date4
                    ,exp_po_dt(i).attribute_date5
                    ,exp_po_dt(i).attribute_date6
                    ,exp_po_dt(i).attribute_date7
                    ,exp_po_dt(i).attribute_date8
                    ,exp_po_dt(i).attribute_date9
                    ,exp_po_dt(i).attribute_date10
                    ,exp_po_dt(i).attribute_number1
                    ,exp_po_dt(i).attribute_number2
                    ,exp_po_dt(i).attribute_number3
                    ,exp_po_dt(i).attribute_number4
                    ,exp_po_dt(i).attribute_number5
                    ,exp_po_dt(i).attribute_number6
                    ,exp_po_dt(i).attribute_number7
                    ,exp_po_dt(i).attribute_number8
                    ,exp_po_dt(i).attribute_number9
                    ,exp_po_dt(i).attribute_number10
                    ,exp_po_dt(i).attribute_timestamp1
                    ,exp_po_dt(i).attribute_timestamp2
                    ,exp_po_dt(i).attribute_timestamp3
                    ,exp_po_dt(i).attribute_timestamp4
                    ,exp_po_dt(i).attribute_timestamp5
                    ,exp_po_dt(i).attribute_timestamp6
                    ,exp_po_dt(i).attribute_timestamp7
                    ,exp_po_dt(i).attribute_timestamp8
                    ,exp_po_dt(i).attribute_timestamp9
                    ,exp_po_dt(i).attribute_timestamp10
                    ,exp_po_dt(i).deliver_to_person_email_addr
                    ,exp_po_dt(i).budget_date
                    ,exp_po_dt(i).pjc_contract_number
                    ,exp_po_dt(i).pjc_funding_source
                    ,exp_po_dt(i).po_header_id																	
                    ,exp_po_dt(i).po_line_id																		
                    ,exp_po_dt(i).line_location_id																
                    ,exp_po_dt(i).po_distribution_id

			);

			END LOOP;

			--Start: Commented for 1.2 
--			SELECT  /*+ driving_site(pha) */ distinct pt_i_MigrationSetID  														--migration_set_id
--                    ,gvt_migrationsetname        														--migration_set_name
--                    ,'EXTRACTED'																		--migration_status
--                    ,pda.po_distribution_id                                                             --interface_distribution_key
--                    ,plla.line_location_id                                                              --interface_line_location_key
--                    ,pha.SEGMENT1                                                                       -- document num
--                    ,pla.line_num                                                                       -- line num
--                    ,plla.shipment_num                                                                  -- shipment num
--                    ,pda.distribution_num 																--distribution num
--                    ,( SELECT hrlb.location_code
--                       FROM   hr_locations@XXMX_EXTRACT hrlb
--                       WHERE  1 = 1
--                       AND    hrlb.location_id = pda.deliver_to_location_id)							--deliver_to_location
----                    ,''																			    --deliver_to_person_full_name
--                    ,(SELECT ppf.last_name||', '||ppf.first_name
--                      FROM   per_all_people_f@XXMX_EXTRACT ppf
--                      WHERE  ppf.person_id = pda.deliver_to_person_id
--                      AND    ppf.effective_start_date = (SELECT max(effective_start_Date)
--                                                         FROM   per_all_people_f@XXMX_EXTRACT ppfl
--                                                         WHERE  ppfl.person_id = ppf.person_id))        --deliver_to_person_full_name
--                    ,pda.deliver_to_person_id                                                           --deliver_to_person_id
--                    ,pda.destination_subinventory 														--destination_subinventory
----                    , CASE WHEN plt.MATCHING_BASIS = 'AMOUNT'
----                           THEN (NVL(pda.amount_ordered, 0) - NVL(pda.amount_cancelled, 0) - NVL(pda.amount_billed, 0))
----                      END                                                                     		    --amount
----                    , CASE WHEN plt.MATCHING_BASIS = 'QUANTITY'
----                           THEN (pda.quantity_ordered - NVL(pda.quantity_cancelled, 0) - NVL(pda.quantity_billed, 0))
----                      END                                                                               --quantity
--,0  -- Original ammout
--,0  -- migrated amount
--,case when pla.order_type_lookup_code='AMOUNT' then
--                       -- pda.quantity_ordered															-- Commented by Laxmikanth for getting the the calculated quantity
--						xpdq.new_qty_ordered															-- Added by Laxmikanth for getting the the calculated quantity
--                        ELSE
--                        pda.amount_ordered     END                                                                         -- amount_ordered
--,case when pla.order_type_lookup_code='AMOUNT'then
--                        NULL
--                        ELSE
--                        pda.quantity_ordered       END                                                                     -- quantity_ordered						
--				--	,pda.quantity_ordered																--quantity_ordered
--                    ,pda.quantity_ordered
--                    ,case when pla.order_type_lookup_code='AMOUNT'then
--                        NULL
--                        ELSE
--                        xpdq.new_qty_ordered       END --xpdq.new_qty_ordered
--                    ,gcc.segment1																		--charge_account_segment1
--                    ,gcc.segment2																		--charge_account_segment2
--                    ,gcc.segment3																		--charge_account_segment3
--                    ,gcc.segment4																		--charge_account_segment4
--                    ,gcc.segment5																		--charge_account_segment5
--                    ,gcc.segment6																		--charge_account_segment6
--                    ,gcc.segment7																		--charge_account_segment7
--                    ,gcc.segment8																		--charge_account_segment8
--                    ,gcc.segment9																		--charge_account_segment9
--                    ,''																					--charge_account_segment10
--                    ,''																					--charge_account_segment11
--                    ,''																					--charge_account_segment12
--                    ,''																					--charge_account_segment13
--                    ,''																					--charge_account_segment14
--                    ,''																					--charge_account_segment15
--                    ,''																					--charge_account_segment16
--                    ,''																					--charge_account_segment17
--                    ,''																					--charge_account_segment18
--                    ,''																					--charge_account_segment19
--                    ,''																					--charge_account_segment20
--                    ,''																					--charge_account_segment21
--                    ,''																					--charge_account_segment22
--                    ,''																					--charge_account_segment23
--                    ,''																					--charge_account_segment24
--                    ,''																					--charge_account_segment25
--                    ,''																					--charge_account_segment26
--                    ,''																					--charge_account_segment27
--                    ,''																					--charge_account_segment28
--                    ,''																					--charge_account_segment29
--                    ,''																					--charge_account_segment30
--                    ,pda.destination_context															--destination_context
--                    ,(SELECT p.segment1
--                      FROM   pa_projects_all@XXMX_EXTRACT p
--                      WHERE  p.project_id=pda.project_id)												--project
--                    ,(SELECT t.task_number
--                      FROM   pa_tasks@XXMX_EXTRACT t
--                      WHERE  t.task_id = pda.task_id)													--task
--                    ,pda.expenditure_item_date															--pjc_expenditure_item_date
--                    ,pda.expenditure_type																--expenditure_type
--                    ,(SELECT haou.name
--                      FROM   apps.hr_all_organization_units@XXMX_EXTRACT haou
--                      where  haou.organization_id =pda.expenditure_organization_id) 					--expenditure_organization
--                    ,''																					--pjc_billable_flag
--                    ,''																					--pjc_capitalizable_flag
--                    ,''																					--pjc_work_type
--                    ,''																					--pjc_reserved_attribute1
--                    ,''																					--pjc_reserved_attribute2
--                    ,''																					--pjc_reserved_attribute3
--                    ,''																					--pjc_reserved_attribute4
--                    ,''																					--pjc_reserved_attribute5
--                    ,''																					--pjc_reserved_attribute6
--                    ,''																					--pjc_reserved_attribute7
--                    ,''																					--pjc_reserved_attribute8
--                    ,''																					--pjc_reserved_attribute9
--                    ,''																					--pjc_reserved_attribute10
--                    ,''																					--pjc_user_def_attribute1
--                    ,''																					--pjc_user_def_attribute2
--                    ,''																					--pjc_user_def_attribute3
--                    ,''																					--pjc_user_def_attribute4
--                    ,''																					--pjc_user_def_attribute5
--                    ,''																					--pjc_user_def_attribute6
--                    ,''																					--pjc_user_def_attribute7
--                    ,''																					--pjc_user_def_attribute8
--                    ,''																					--pjc_user_def_attribute9
--                    ,''																					--pjc_user_def_attribute10
--                    ,pda.rate																			--rate
--                    ,decode(pda.RATE,null,null,pda.RATE_DATE)																		--rate_date
--                    ,''																					--attribute_category
--                    ,''																					--attribute1
--                    ,''																					--attribute2
--                    ,''																					--attribute3
--                    ,''																					--attribute4
--                    ,''																					--attribute5
--                    ,''																					--attribute6
--                    ,''																					--attribute7
--                    ,''																					--attribute8
--                    ,''																					--attribute9
--                    ,''																					--attribute10
--                    ,''																					--attribute11
--                    ,''																					--attribute12
--                    ,''																					--attribute13
--                    ,''																					--attribute14
--                    ,''																					--attribute15
--                    ,''																					--attribute16
--                    ,''																					--attribute17
--                    ,''																					--attribute18
--                    ,''																					--attribute19
--                    ,''																					--attribute20
--                    ,''																					--attribute_date1
--                    ,''																					--attribute_date2
--                    ,''																					--attribute_date3
--                    ,''																					--attribute_date4
--                    ,''																					--attribute_date5
--                    ,''																					--attribute_date6
--                    ,''																					--attribute_date7
--                    ,''																					--attribute_date8
--                    ,''																					--attribute_date9
--                    ,''																					--attribute_date10
--                    ,''																					--attribute_number1
--                    ,''																					--attribute_number2
--                    ,''																					--attribute_number3
--                    ,''																					--attribute_number4
--                    ,''																					--attribute_number5
--                    ,''																					--attribute_number6
--                    ,''																					--attribute_number7
--                    ,''																					--attribute_number8
--                    ,''																					--attribute_number9
--                    ,''																					--attribute_number10
--                    ,''																					--attribute_timestamp1
--                    ,''																					--attribute_timestamp2
--                    ,''																					--attribute_timestamp3
--                    ,''																					--attribute_timestamp4
--                    ,''																					--attribute_timestamp5
--                    ,''																					--attribute_timestamp6
--                    ,''																					--attribute_timestamp7
--                    ,''																					--attribute_timestamp8
--                    ,''																					--attribute_timestamp9
--                    ,''																					--attribute_timestamp10
--                    ,CASE when pda.deliver_to_location_id is not null
--                        then (select lower(ppf.email_address)
--                              from   per_all_people_f@XXMX_EXTRACT  ppf
--                              where  ppf.person_id = pda.deliver_to_person_id
--                              and    ppf.email_address is not null
--                              and    ppf.effective_start_date =  ( select max(effective_start_date)
--                                                                   from   per_all_people_f@XXMX_EXTRACT  ppf1
--                                                                   where  ppf1.person_id = ppf.person_id)
--                              )  end																	--deliver_to_person_email_addr
--                    ,''																					--budget_date
--                    ,''																					--pjc_contract_number
--                    ,''																					--pjc_funding_source
--                    ,pha.po_header_id																	--po_header_id
--                    ,pla.po_line_id																		--po_line_id
--                    ,plla.line_location_id																--line_location_id
--                    ,pda.po_distribution_id																--po_distribution_id
--            FROM
--                     PO_HEADERS_ALL@XXMX_EXTRACT             pha
--                    ,PO_LINES_ALL@XXMX_EXTRACT               pla
--                    ,PO_LINE_LOCATIONS_ALL@XXMX_EXTRACT      plla
--                    ,PO_DISTRIBUTIONS_ALL@XXMX_EXTRACT       pda
--                    ,gl_code_combinations@XXMX_EXTRACT       gcc
--                    ,po_line_types@XXMX_EXTRACT              plt
--                    ,XXMX_PURCHASE_ORDER_SCOPE            xpos
--                    ,xxmx_core.XXMX_PO_DISTRIBUTIONS_QTY_V   xpdq
--              WHERE 1                                   = 1
--              AND pha.type_lookup_code                  = 'STANDARD'
--              AND pha.org_id                 		    = xpos.org_id
--              AND pha.po_header_id				        = xpos.po_header_id
--              --
--              AND  NVL(pda.code_combination_id, 0)      = gcc.code_combination_id(+)
--              AND pla.line_type_id                      = plt.line_type_id
--              --
--              AND pda.po_header_id                      = pha.po_header_id
--              AND pda.po_line_id                        = pla.po_line_id
--              AND pda.line_location_id                  = plla.line_location_id
--              --
--              and xpdq.po_header_id                     = pda.po_header_id
--              and xpdq.po_line_id                       = pda.po_line_id
--              and xpdq.line_location_id                 = pda.line_location_id
--			  and pda.po_distribution_id =xpdq.po_distribution_id 
--              ;
--End: Commented for 1.2 
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

			CLOSE exp_po_dists;

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
            -- Hr_Utility.raise_error@XXMX_EXTRACT;
    END export_po_distributions_std;


	/****************************************************************
	----------------Export BPA PO Headers----------------------------
	*****************************************************************/

    PROCEDURE export_po_headers_bpa
      (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
        IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_po_headers_bpa';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_SCM_PO_HEADERS_BPA_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PO_HEADERS_BPA';

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
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
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
        FROM    XXMX_SCM_PO_HEADERS_BPA_STG
          ;

        COMMIT;
        --

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


            INSERT
            INTO    XXMX_SCM_PO_HEADERS_BPA_STG
                   (MIGRATION_SET_ID							,
                    MIGRATION_SET_NAME							,
                    MIGRATION_STATUS							,
                    INTERFACE_HEADER_KEY						,
                    ACTION										,
                    BATCH_ID									,
                    INTERFACE_SOURCE_CODE						,
                    APPROVAL_ACTION								,
                    DOCUMENT_NUM								,
                    DOCUMENT_TYPE_CODE							,
                    STYLE_DISPLAY_NAME							,
                    PRC_BU_NAME									,
                    AGENT_NAME									,
                    CURRENCY_CODE								,
                    COMMENTS 									,
                    VENDOR_NAME									,
                    VENDOR_NUM									,
                    VENDOR_SITE_CODE							,
                    VENDOR_CONTACT								,
                    VENDOR_DOC_NUM								,
                    FOB											,
                    FREIGHT_CARRIER								,
                    FREIGHT_TERMS								,
                    PAY_ON_CODE									,
                    PAYMENT_TERMS								,
                    ORIGINATOR_ROLE								,
                    CHANGE_ORDER_DESC							,
                    ACCEPTANCE_REQUIRED_FLAG					,
                    ACCEPTANCE_WITHIN_DAYS						,
                    SUPPLIER_NOTIF_METHOD						,
                    FAX											,
                    EMAIL_ADDRESS								,
                    CONFIRMING_ORDER_FLAG						,
                    AMOUNT_AGREED 								,
                    AMOUNT_LIMIT 								,
                    MIN_RELEASE_AMOUNT 							,
                    EFFECTIVE_DATE								,
                    EXPIRATION_DATE 							,
                    NOTE_TO_VENDOR 								,
                    NOTE_TO_RECEIVER 							,
                    GENERATE_ORDERS_AUTOMATIC 					,
                    SUBMIT_APPROVAL_AUTOMATIC					,
                    GROUP_REQUISITIONS							,
                    GROUP_REQUISITION_LINES						,
                    USE_SHIP_TO									,
                    USE_NEED_BY_DATE							,
                    CAT_ADMIN_AUTH_ENABLED_FLAG					,
                    RETRO_PRICE_APPLY_UPDATES_FLAG				,
                    RETRO_PRICE_COMM_UPDATES_FLAG				,
                    ATTRIBUTE_CATEGORY							,
                    ATTRIBUTE1									,
                    ATTRIBUTE2									,
                    ATTRIBUTE3									,
                    ATTRIBUTE4									,
                    ATTRIBUTE5									,
                    ATTRIBUTE6									,
                    ATTRIBUTE7									,
                    ATTRIBUTE8									,
                    ATTRIBUTE9									,
                    ATTRIBUTE10									,
                    ATTRIBUTE11									,
                    ATTRIBUTE12									,
                    ATTRIBUTE13									,
                    ATTRIBUTE14									,
                    ATTRIBUTE15									,
                    ATTRIBUTE16									,
                    ATTRIBUTE17									,
                    ATTRIBUTE18									,
                    ATTRIBUTE19									,
                    ATTRIBUTE20									,
                    ATTRIBUTE_DATE1								,
                    ATTRIBUTE_DATE2								,
                    ATTRIBUTE_DATE3								,
                    ATTRIBUTE_DATE4								,
                    ATTRIBUTE_DATE5								,
                    ATTRIBUTE_DATE6								,
                    ATTRIBUTE_DATE7								,
                    ATTRIBUTE_DATE8								,
                    ATTRIBUTE_DATE9								,
                    ATTRIBUTE_DATE10							,
                    ATTRIBUTE_NUMBER1							,
                    ATTRIBUTE_NUMBER2							,
                    ATTRIBUTE_NUMBER3							,
                    ATTRIBUTE_NUMBER4							,
                    ATTRIBUTE_NUMBER5							,
                    ATTRIBUTE_NUMBER6							,
                    ATTRIBUTE_NUMBER7							,
                    ATTRIBUTE_NUMBER8							,
                    ATTRIBUTE_NUMBER9							,
                    ATTRIBUTE_NUMBER10							,
                    ATTRIBUTE_TIMESTAMP1						,
                    ATTRIBUTE_TIMESTAMP2						,
                    ATTRIBUTE_TIMESTAMP3						,
                    ATTRIBUTE_TIMESTAMP4						,
                    ATTRIBUTE_TIMESTAMP5						,
                    ATTRIBUTE_TIMESTAMP6						,
                    ATTRIBUTE_TIMESTAMP7						,
                    ATTRIBUTE_TIMESTAMP8						,
                    ATTRIBUTE_TIMESTAMP9						,
                    ATTRIBUTE_TIMESTAMP10						,
                    AGENT_EMAIL_ADDRESS							,
                    MODE_OF_TRANSPORT							,
                    SERVICE_LEVEL								,
                    AGING_PERIOD_DAYS							,
                    AGING_ONSET_POINT							,
                    CONSUMPTION_ADVICE_FREQUENCY				,
                    CONSUMPTION_ADVICE_SUMMARY					,
                    DEFAULT_CONSIGNMENT_LINE_FLAG				,
                    PAY_ON_USE_FLAG 							,
                    BILLING_CYCLE_CLOSING_DATE					,
                    CONFIGURED_ITEM_FLAG						,
                    USE_SALES_ORDER_NUMBER_FLAG					,
                    BUYER_MANAGED_TRANSPORT_FLAG				,
                    ALLOW_ORDER_FRM_UNASSIGND_SITES		,
                    OUTSIDE_PROCESS_ENABLED_FLAG				,
                    MASTER_CONTRACT_NUMBER						,
                    MASTER_CONTRACT_TYPE						,
                    PO_HEADER_ID
                  )

            SELECT  distinct pt_i_MigrationSetID														--migration_set_id
                    ,gvt_migrationsetname																--migration_set_name
                    ,'EXTRACTED'																		--migration_status
                    ,pha.po_header_id																	--interface_header_key
                    ,''																					--action
                    ,''																					--batch_id
                    ,pha.interface_source_code															--interface_source_code
                    ,pha.authorization_status															--approval_action
                    ,pha.segment1																		--document_num
                    ,pha.type_lookup_code																--document_type_code
                    ,''																					--style_display_name
                    ,''																					--prc_bu_name
                    ,''																					--agent_name
                    ,pha.currency_code																	--currency_code
                    ,pha.comments																		--comments
                    ,pv.vendor_name																		--vendor_name
                    ,pv.segment1																		--vendor_num
                    ,pvsa.vendor_site_code																--vendor_site_code
                    ,''																					--vendor_contact
                    ,''																					--vendor_doc_num
                    ,pha.fob_lookup_code																--fob
                    ,''																					--freight_carrier
                    ,pha.freight_terms_lookup_code														--freight_terms
                    ,pha.pay_on_code																	--pay_on_code
                    ,''																					--payment_terms
                    ,''																					--originator_role
                    ,pha.change_summary																	--change_order_desc
                    ,pha.acceptance_required_flag														--acceptance_required_flag
                    ,''																					--acceptance_within_days
                    ,pha.supplier_notif_method															--supplier_notif_method
                    ,pha.fax																			--fax
                    ,pha.email_address																	--email_address
                    ,pha.confirming_order_flag															--confirming_order_flag
                    ,pha.blanket_total_amount															--amount_agreed
                    ,pha.amount_limit																	--amount_limit
                    ,pha.min_release_amount																--min_release_amount
                    ,pha.start_date																		--effective_date
                    ,pha.end_date																		--expiration_date
                    ,pha.note_to_vendor																	--note_to_vendor
                    ,pha.note_to_receiver																--note_to_receiver
                    ,''																					--generate_orders_automatic
                    ,''																					--submit_approval_automatic
                    ,''																					--group_requisitions
                    ,''																					--group_requisition_lines
                    ,''																					--use_ship_to
                    ,''																					--use_need_by_date
                    ,pha.cat_admin_auth_enabled_flag													--cat_admin_auth_enabled_flag
                    ,pha.retro_price_apply_updates_flag													--retro_price_apply_updates_flag
                    ,pha.retro_price_comm_updates_flag													--retro_price_comm_updates_flag
                    ,''																					--attribute_category
                    ,''																					--attribute1
                    ,''																					--attribute2
                    ,''																					--attribute3
                    ,''																					--attribute4
                    ,''																					--attribute5
                    ,''																					--attribute6
                    ,''																					--attribute7
                    ,''																					--attribute8
                    ,''																					--attribute9
                    ,''																					--attribute10
                    ,''																					--attribute11
                    ,''																					--attribute12
                    ,''																					--attribute13
                    ,''																					--attribute14
                    ,''																					--attribute15
                    ,''																					--attribute16
                    ,''																					--attribute17
                    ,''																					--attribute18
                    ,''																					--attribute19
                    ,''																					--attribute20
                    ,''																					--attribute_date1
                    ,''																					--attribute_date2
                    ,''																					--attribute_date3
                    ,''																					--attribute_date4
                    ,''																					--attribute_date5
                    ,''																					--attribute_date6
                    ,''																					--attribute_date7
                    ,''																					--attribute_date8
                    ,''																					--attribute_date9
                    ,''																					--attribute_date10
                    ,''																					--attribute_number1
                    ,''																					--attribute_number2
                    ,''																					--attribute_number3
                    ,''																					--attribute_number4
                    ,''																					--attribute_number5
                    ,''																					--attribute_number6
                    ,''																					--attribute_number7
                    ,''																					--attribute_number8
                    ,''																					--attribute_number9
                    ,''																					--attribute_number10
                    ,''																					--attribute_timestamp1
                    ,''																					--attribute_timestamp2
                    ,''																					--attribute_timestamp3
                    ,''																					--attribute_timestamp4
                    ,''																					--attribute_timestamp5
                    ,''																					--attribute_timestamp6
                    ,''																					--attribute_timestamp7
                    ,''																					--attribute_timestamp8
                    ,''																					--attribute_timestamp9
                    ,''																					--attribute_timestamp10
                    ,''																					--agent_email_address
                    ,''																					--mode_of_transport
                    ,''																					--service_level
                    ,''																					--aging_period_days
                    ,''																					--aging_onset_point
                    ,''																					--consumption_advice_frequency
                    ,''																					--consumption_advice_summary
                    ,''																					--default_consignment_line_flag
                    ,''																					--pay_on_use_flag
                    ,''																					--billing_cycle_closing_date
                    ,''																					--configured_item_flag
                    ,''																					--use_sales_order_number_flag
                    ,''																					--buyer_managed_transport_flag
                    ,''																					--allow_ordering_from_unassigned_sites
                    ,''																					--outside_process_enabled_flag
                    ,''																					--master_contract_number
                    ,''																					--master_contract_type
                    ,pha.po_header_id																	--po_header_id
            FROM
                     PO_HEADERS_ALL@XXMX_EXTRACT			pha
                    ,PO_VENDORS@XXMX_EXTRACT   			pv
                    ,PO_VENDOR_SITES_ALL@XXMX_EXTRACT		pvsa
                    ,XXMX_PURCHASE_ORDER_SCOPE_V				xpos
            WHERE  1                                 = 1
            --
            AND pha.type_lookup_code              	= 'BLANKET'
            AND pha.org_id                    	 	= xpos.org_id
            AND pha.po_header_id				  	= xpos.po_header_id
            --
            AND pha.vendor_id                   	= pv.vendor_id
            AND pha.vendor_site_id               	= pvsa.vendor_site_id
            ;

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
            -- Hr_Utility.raise_error@XXMX_EXTRACT;
    END export_po_headers_bpa;


	/****************************************************************
	----------------Export BPA PO Lines------------------------------
	*****************************************************************/

    PROCEDURE export_po_lines_bpa
       (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
        IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_po_lines_bpa';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_SCM_PO_LINES_BPA_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PO_LINES_BPA';

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
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
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
        FROM    XXMX_SCM_PO_LINES_BPA_STG
          ;

        COMMIT;
        --

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


            INSERT
            INTO    XXMX_SCM_PO_LINES_BPA_STG
                   (MIGRATION_SET_ID						,
                    MIGRATION_SET_NAME						,
                    MIGRATION_STATUS						,
                    INTERFACE_LINE_KEY						,
                    INTERFACE_HEADER_KEY					,
                    ACTION									,
                    LINE_NUM								,
                    LINE_TYPE								,
                    ITEM									,
                    ITEM_DESCRIPTION						,
                    ITEM_REVISION							,
                    CATEGORY								,
                    COMMITTED_AMOUNT						,
                    UNIT_OF_MEASURE							,
                    UNIT_PRICE								,
                    ALLOW_PRICE_OVERRIDE_FLAG				,
                    NOT_TO_EXCEED_PRICE						,
                    VENDOR_PRODUCT_NUM						,
                    NEGOTIATED_BY_PREPARER_FLAG				,
                    NOTE_TO_VENDOR							,
                    NOTE_TO_RECEIVER						,
                    MIN_RELEASE_AMOUNT						,
                    EXPIRATION_DATE							,
                    SUPPLIER_PART_AUXID 					,
                    SUPPLIER_REF_NUMBER						,
                    ATTRIBUTE_CATEGORY						,
                    ATTRIBUTE1								,
                    ATTRIBUTE2								,
                    ATTRIBUTE3								,
                    ATTRIBUTE4								,
                    ATTRIBUTE5								,
                    ATTRIBUTE6								,
                    ATTRIBUTE7								,
                    ATTRIBUTE8								,
                    ATTRIBUTE9								,
                    ATTRIBUTE10								,
                    ATTRIBUTE11								,
                    ATTRIBUTE12								,
                    ATTRIBUTE13								,
                    ATTRIBUTE14								,
                    ATTRIBUTE15								,
                    ATTRIBUTE16								,
                    ATTRIBUTE17								,
                    ATTRIBUTE18								,
                    ATTRIBUTE19								,
                    ATTRIBUTE20								,
                    ATTRIBUTE_DATE1							,
                    ATTRIBUTE_DATE2							,
                    ATTRIBUTE_DATE3							,
                    ATTRIBUTE_DATE4							,
                    ATTRIBUTE_DATE5							,
                    ATTRIBUTE_DATE6							,
                    ATTRIBUTE_DATE7							,
                    ATTRIBUTE_DATE8							,
                    ATTRIBUTE_DATE9							,
                    ATTRIBUTE_DATE10						,
                    ATTRIBUTE_NUMBER1						,
                    ATTRIBUTE_NUMBER2						,
                    ATTRIBUTE_NUMBER3						,
                    ATTRIBUTE_NUMBER4						,
                    ATTRIBUTE_NUMBER5						,
                    ATTRIBUTE_NUMBER6						,
                    ATTRIBUTE_NUMBER7						,
                    ATTRIBUTE_NUMBER8						,
                    ATTRIBUTE_NUMBER9						,
                    ATTRIBUTE_NUMBER10						,
                    ATTRIBUTE_TIMESTAMP1					,
                    ATTRIBUTE_TIMESTAMP2					,
                    ATTRIBUTE_TIMESTAMP3					,
                    ATTRIBUTE_TIMESTAMP4					,
                    ATTRIBUTE_TIMESTAMP5					,
                    ATTRIBUTE_TIMESTAMP6					,
                    ATTRIBUTE_TIMESTAMP7					,
                    ATTRIBUTE_TIMESTAMP8					,
                    ATTRIBUTE_TIMESTAMP9					,
                    ATTRIBUTE_TIMESTAMP10					,
                    AGING_PERIOD_DAYS						,
                    CONSIGNMENT_LINE_FLAG					,
                    UNIT_WEIGHT								,
                    WEIGHT_UOM_CODE							,
                    WEIGHT_UNIT_OF_MEASURE 					,
                    UNIT_VOLUME								,
                    VOLUME_UOM_CODE							,
                    VOLUME_UNIT_OF_MEASURE 					,
                    TEMPLATE_NAME							,
                    ITEM_ATTRIBUTE_CATEGORY					,
                    ITEM_ATTRIBUTE1							,
                    ITEM_ATTRIBUTE2							,
                    ITEM_ATTRIBUTE3							,
                    ITEM_ATTRIBUTE4							,
                    ITEM_ATTRIBUTE5							,
                    ITEM_ATTRIBUTE6							,
                    ITEM_ATTRIBUTE7							,
                    ITEM_ATTRIBUTE8							,
                    ITEM_ATTRIBUTE9							,
                    ITEM_ATTRIBUTE10						,
                    ITEM_ATTRIBUTE11						,
                    ITEM_ATTRIBUTE12						,
                    ITEM_ATTRIBUTE13						,
                    ITEM_ATTRIBUTE14						,
                    ITEM_ATTRIBUTE15						,
                    PARENT_ITEM								,
                    TOP_MODEL								,
                    SUPPLIER_PARENT_ITEM					,
                    SUPPLIER_TOP_MODEL						,
                    AMOUNT									,
                    PRICE_BREAK_LOOKUP_CODE					,
                    QUANTITY_COMMITTED						,
                    ALLOW_DESCRIPTION_UPDATE_FLAG			,
                    PO_HEADER_ID							,
                    PO_LINE_ID
                )

            SELECT  distinct pt_i_MigrationSetID														--migration_set_id
                    ,gvt_migrationsetname																--migration_set_name
                    ,'EXTRACTED'																		--migration_status
                    ,''																					--interface_line_key
                    ,pha.po_header_id																	--interface_header_key
                    ,''																					--action
                    ,pla.line_num																		--line_num
                    ,plt.line_type																		--line_type
                    ,''																					--item
                    ,pla.item_description																--item_description
                    ,pla.item_revision																	--item_revision
                    ,''																					--category
                    ,pla.committed_amount																--committed_amount
                    ,pla.unit_meas_lookup_code															--unit_of_measure
                    ,pla.unit_price																		--unit_price
                    ,pla.allow_price_override_flag														--allow_price_override_flag
                    ,pla.not_to_exceed_price															--not_to_exceed_price
                    ,pla.vendor_product_num																--vendor_product_num
                    ,pla.negotiated_by_preparer_flag													--negotiated_by_preparer_flag
                    ,pla.note_to_vendor																	--note_to_vendor
                    ,''																					--note_to_receiver
                    ,pla.min_release_amount																--min_release_amount
                    ,pla.expiration_date																--expiration_date
                    ,pla.supplier_part_auxid															--supplier_part_auxid
                    ,pla.supplier_ref_number															--supplier_ref_number
                    ,''																					--attribute_category
                    ,''																					--attribute1
                    ,''																					--attribute2
                    ,''																					--attribute3
                    ,''																					--attribute4
                    ,''																					--attribute5
                    ,''																					--attribute6
                    ,''																					--attribute7
                    ,''																					--attribute8
                    ,''																					--attribute9
                    ,''																					--attribute10
                    ,''																					--attribute11
                    ,''																					--attribute12
                    ,''																					--attribute13
                    ,''																					--attribute14
                    ,''																					--attribute15
                    ,''																					--attribute16
                    ,''																					--attribute17
                    ,''																					--attribute18
                    ,''																					--attribute19
                    ,''																					--attribute20
                    ,''																					--attribute_date1
                    ,''																					--attribute_date2
                    ,''																					--attribute_date3
                    ,''																					--attribute_date4
                    ,''																					--attribute_date5
                    ,''																					--attribute_date6
                    ,''																					--attribute_date7
                    ,''																					--attribute_date8
                    ,''																					--attribute_date9
                    ,''																					--attribute_date10
                    ,''																					--attribute_number1
                    ,''																					--attribute_number2
                    ,''																					--attribute_number3
                    ,''																					--attribute_number4
                    ,''																					--attribute_number5
                    ,''																					--attribute_number6
                    ,''																					--attribute_number7
                    ,''																					--attribute_number8
                    ,''																					--attribute_number9
                    ,''																					--attribute_number10
                    ,''																					--attribute_timestamp1
                    ,''																					--attribute_timestamp2
                    ,''																					--attribute_timestamp3
                    ,''																					--attribute_timestamp4
                    ,''																					--attribute_timestamp5
                    ,''																					--attribute_timestamp6
                    ,''																					--attribute_timestamp7
                    ,''																					--attribute_timestamp8
                    ,''																					--attribute_timestamp9
                    ,''																					--attribute_timestamp10
                    ,''																					--aging_period_days
                    ,''																					--consignment_line_flag
                    ,''																					--unit_weight
                    ,''																					--weight_uom_code
                    ,''																					--weight_unit_of_measure
                    ,''																					--unit_volume
                    ,''																					--volume_uom_code
                    ,''																					--volume_unit_of_measure
                    ,''																					--template_name
                    ,''																					--item_attribute_category
                    ,''																					--item_attribute1
                    ,''																					--item_attribute2
                    ,''																					--item_attribute3
                    ,''																					--item_attribute4
                    ,''																					--item_attribute5
                    ,''																					--item_attribute6
                    ,''																					--item_attribute7
                    ,''																					--item_attribute8
                    ,''																					--item_attribute9
                    ,''																					--item_attribute10
                    ,''																					--item_attribute11
                    ,''																					--item_attribute12
                    ,''																					--item_attribute13
                    ,''																					--item_attribute14
                    ,''																					--item_attribute15
                    ,''																					--parent_item
                    ,''																					--top_model
                    ,''																					--supplier_parent_item
                    ,''																					--supplier_top_model
                    ,pla.amount																			--amount
                    ,pla.price_break_lookup_code														--price_break_lookup_code
                    ,pla.quantity_committed																--quantity_committed
                    ,''																					--allow_description_update_flag
                    ,pha.po_header_id																	--po_header_id
                    ,pla.po_line_id																		--po_line_id
            FROM
                     PO_HEADERS_ALL@XXMX_EXTRACT		    pha
                    ,PO_LINES_ALL@XXMX_EXTRACT   			pla
                    ,PO_LINE_TYPES_TL@XXMX_EXTRACT			plt
                    ,XXMX_PURCHASE_ORDER_SCOPE_V				xpos
            WHERE  1                                   = 1
            --
             AND pha.type_lookup_code                  = 'BLANKET'
             AND pha.org_id                            = xpos.org_id
             AND pha.po_header_id				       = xpos.po_header_id
             --
             AND pla.po_header_id                  	   = pha.po_header_id
             AND pla.line_type_id                      = plt.line_type_id
            ;

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
            -- Hr_Utility.raise_error@XXMX_EXTRACT;
    END export_po_lines_bpa;


	/****************************************************************
	----------------Export BPA PO Line Locations---------------------
	*****************************************************************/

    PROCEDURE export_po_line_locations_bpa
       (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
        IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_po_line_locations_bpa';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_SCM_PO_LINE_LOCATIONS_BPA_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PO_LINE_LOCATIONS_BPA';

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
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
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
        FROM    XXMX_SCM_PO_LINE_LOCATIONS_BPA_STG
          ;

        COMMIT;
        --

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

            INSERT
            INTO    XXMX_SCM_PO_LINE_LOCATIONS_BPA_STG
                   (MIGRATION_SET_ID					,
                    MIGRATION_SET_NAME					,
                    MIGRATION_STATUS					,
                    INTERFACE_LINE_LOCATION_KEY			,
                    INTERFACE_LINE_KEY					,
                    SHIPMENT_NUM						,
                    SHIP_TO_LOCATION					,
                    SHIP_TO_ORGANIZATION_CODE			,
                    QUANTITY							,
                    PRICE_OVERRIDE 						,
                    PRICE_DISCOUNT						,
                    START_DATE							,
                    END_DATE							,
                    ATTRIBUTE_CATEGORY					,
                    ATTRIBUTE1							,
                    ATTRIBUTE2							,
                    ATTRIBUTE3							,
                    ATTRIBUTE4							,
                    ATTRIBUTE5							,
                    ATTRIBUTE6							,
                    ATTRIBUTE7							,
                    ATTRIBUTE8							,
                    ATTRIBUTE9							,
                    ATTRIBUTE10							,
                    ATTRIBUTE11							,
                    ATTRIBUTE12							,
                    ATTRIBUTE13							,
                    ATTRIBUTE14							,
                    ATTRIBUTE15							,
                    ATTRIBUTE16							,
                    ATTRIBUTE17							,
                    ATTRIBUTE18							,
                    ATTRIBUTE19							,
                    ATTRIBUTE20							,
                    ATTRIBUTE_DATE1						,
                    ATTRIBUTE_DATE2						,
                    ATTRIBUTE_DATE3						,
                    ATTRIBUTE_DATE4						,
                    ATTRIBUTE_DATE5						,
                    ATTRIBUTE_DATE6						,
                    ATTRIBUTE_DATE7						,
                    ATTRIBUTE_DATE8						,
                    ATTRIBUTE_DATE9						,
                    ATTRIBUTE_DATE10					,
                    ATTRIBUTE_NUMBER1					,
                    ATTRIBUTE_NUMBER2					,
                    ATTRIBUTE_NUMBER3					,
                    ATTRIBUTE_NUMBER4					,
                    ATTRIBUTE_NUMBER5					,
                    ATTRIBUTE_NUMBER6					,
                    ATTRIBUTE_NUMBER7					,
                    ATTRIBUTE_NUMBER8					,
                    ATTRIBUTE_NUMBER9					,
                    ATTRIBUTE_NUMBER10					,
                    ATTRIBUTE_TIMESTAMP1				,
                    ATTRIBUTE_TIMESTAMP2				,
                    ATTRIBUTE_TIMESTAMP3				,
                    ATTRIBUTE_TIMESTAMP4				,
                    ATTRIBUTE_TIMESTAMP5				,
                    ATTRIBUTE_TIMESTAMP6				,
                    ATTRIBUTE_TIMESTAMP7				,
                    ATTRIBUTE_TIMESTAMP8				,
                    ATTRIBUTE_TIMESTAMP9				,
                    ATTRIBUTE_TIMESTAMP10				,
                    PO_HEADER_ID						,
                    PO_LINE_ID							,
                    LINE_LOCATION_ID
                )

            SELECT  distinct pt_i_MigrationSetID  				                						--migration_set_id
                    ,gvt_migrationsetname        				                						--migration_set_name
                    ,'EXTRACTED'								                						--migration_status
                    ,''																					--interface_line_location_key
                    ,pla.po_line_id																		--interface_line_key
                    ,plla.shipment_num																	--shipment_num
                    ,''																					--ship_to_location
                    ,''																					--ship_to_organization_code
                    ,plla.quantity																		--quantity
                    ,plla.price_override																--price_override
                    ,plla.price_discount																--price_discount
                    ,plla.start_date																	--start_date
                    ,plla.end_date																		--end_date
                    ,''																					--attribute_category
                    ,''																					--attribute1
                    ,''																					--attribute2
                    ,''																					--attribute3
                    ,''																					--attribute4
                    ,''																					--attribute5
                    ,''																					--attribute6
                    ,''																					--attribute7
                    ,''																					--attribute8
                    ,''																					--attribute9
                    ,''																					--attribute10
                    ,''																					--attribute11
                    ,''																					--attribute12
                    ,''																					--attribute13
                    ,''																					--attribute14
                    ,''																					--attribute15
                    ,''																					--attribute16
                    ,''																					--attribute17
                    ,''																					--attribute18
                    ,''																					--attribute19
                    ,''																					--attribute20
                    ,''																					--attribute_date1
                    ,''																					--attribute_date2
                    ,''																					--attribute_date3
                    ,''																					--attribute_date4
                    ,''																					--attribute_date5
                    ,''																					--attribute_date6
                    ,''																					--attribute_date7
                    ,''																					--attribute_date8
                    ,''																					--attribute_date9
                    ,''																					--attribute_date10
                    ,''																					--attribute_number1
                    ,''																					--attribute_number2
                    ,''																					--attribute_number3
                    ,''																					--attribute_number4
                    ,''																					--attribute_number5
                    ,''																					--attribute_number6
                    ,''																					--attribute_number7
                    ,''																					--attribute_number8
                    ,''																					--attribute_number9
                    ,''																					--attribute_number10
                    ,''																					--attribute_timestamp1
                    ,''																					--attribute_timestamp2
                    ,''																					--attribute_timestamp3
                    ,''																					--attribute_timestamp4
                    ,''																					--attribute_timestamp5
                    ,''																					--attribute_timestamp6
                    ,''																					--attribute_timestamp7
                    ,''																					--attribute_timestamp8
                    ,''																					--attribute_timestamp9
                    ,''																					--attribute_timestamp10
                    ,pha.po_header_id																	--po_header_id
                    ,pla.po_line_id																		--po_line_id
                    ,plla.line_location_id																--line_location_id
            FROM
                     PO_HEADERS_ALL@XXMX_EXTRACT			pha
                    ,PO_LINES_ALL@XXMX_EXTRACT   			pla
                    ,PO_LINE_LOCATIONS_ALL@XXMX_EXTRACT	plla
                    ,XXMX_PURCHASE_ORDER_SCOPE_V				xpos
              WHERE 1                                   = 1
              AND pha.type_lookup_code                  = 'BLANKET'
              AND pha.org_id                 		    = xpos.org_id
              AND pha.po_header_id				        = xpos.po_header_id
              --
              AND pha.po_header_id                      = pla.po_header_id
              AND pla.po_header_id                      = plla.po_header_id
              AND pla.po_line_id                        = plla.po_line_id
              ;

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
            -- Hr_Utility.raise_error@XXMX_EXTRACT;
    END export_po_line_locations_bpa;

	/****************************************************************
	----------------Export CPA PO Headers----------------------------
	*****************************************************************/

    PROCEDURE export_po_headers_cpa
        (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE)
        IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'export_po_headers_cpa';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_SCM_PO_HEADERS_CPA_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PO_HEADERS_CPA';

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
            (pt_i_ApplicationSuite    => gct_ApplicationSuite
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
        FROM    XXMX_SCM_PO_HEADERS_CPA_STG
          ;

        COMMIT;
        --

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

            INSERT
            INTO    XXMX_SCM_PO_HEADERS_CPA_STG
                   (MIGRATION_SET_ID							,
                    MIGRATION_SET_NAME							,
                    MIGRATION_STATUS							,
                    INTERFACE_HEADER_KEY						,
                    ACTION										,
                    BATCH_ID									,
                    INTERFACE_SOURCE_CODE 						,
                    APPROVAL_ACTION								,
                    DOCUMENT_NUM								,
                    DOCUMENT_TYPE_CODE							,
                    STYLE_DISPLAY_NAME							,
                    PRC_BU_NAME									,
                    AGENT_NAME 									,
                    CURRENCY_CODE								,
                    COMMENTS									,
                    VENDOR_NAME									,
                    VENDOR_NUM 									,
                    VENDOR_SITE_CODE							,
                    VENDOR_CONTACT								,
                    VENDOR_DOC_NUM								,
                    FOB											,
                    FREIGHT_CARRIER								,
                    FREIGHT_TERMS								,
                    PAY_ON_CODE									,
                    PAYMENT_TERMS								,
                    ORIGINATOR_ROLE								,
                    CHANGE_ORDER_DESC							,
                    ACCEPTANCE_REQUIRED_FLAG					,
                    ACCEPTANCE_WITHIN_DAYS						,
                    SUPPLIER_NOTIF_METHOD 						,
                    FAX											,
                    EMAIL_ADDRESS								,
                    CONFIRMING_ORDER_FLAG						,
                    AMOUNT_AGREED								,
                    AMOUNT_LIMIT								,
                    MIN_RELEASE_AMOUNT							,
                    EFFECTIVE_DATE								,
                    EXPIRATION_DATE								,
                    NOTE_TO_VENDOR								,
                    NOTE_TO_RECEIVER							,
                    GENERATE_ORDERS_AUTOMATIC					,
                    SUBMIT_APPROVAL_AUTOMATIC					,
                    GROUP_REQUISITIONS							,
                    GROUP_REQUISITION_LINES						,
                    USE_SHIP_TO									,
                    USE_NEED_BY_DATE							,
                    ATTRIBUTE_CATEGORY							,
                    ATTRIBUTE1									,
                    ATTRIBUTE2									,
                    ATTRIBUTE3									,
                    ATTRIBUTE4									,
                    ATTRIBUTE5									,
                    ATTRIBUTE6									,
                    ATTRIBUTE7									,
                    ATTRIBUTE8									,
                    ATTRIBUTE9									,
                    ATTRIBUTE10									,
                    ATTRIBUTE11									,
                    ATTRIBUTE12									,
                    ATTRIBUTE13									,
                    ATTRIBUTE14									,
                    ATTRIBUTE15									,
                    ATTRIBUTE16									,
                    ATTRIBUTE17									,
                    ATTRIBUTE18									,
                    ATTRIBUTE19									,
                    ATTRIBUTE20									,
                    ATTRIBUTE_DATE1								,
                    ATTRIBUTE_DATE2								,
                    ATTRIBUTE_DATE3								,
                    ATTRIBUTE_DATE4								,
                    ATTRIBUTE_DATE5								,
                    ATTRIBUTE_DATE6								,
                    ATTRIBUTE_DATE7								,
                    ATTRIBUTE_DATE8								,
                    ATTRIBUTE_DATE9								,
                    ATTRIBUTE_DATE10							,
                    ATTRIBUTE_NUMBER1							,
                    ATTRIBUTE_NUMBER2							,
                    ATTRIBUTE_NUMBER3							,
                    ATTRIBUTE_NUMBER4							,
                    ATTRIBUTE_NUMBER5							,
                    ATTRIBUTE_NUMBER6							,
                    ATTRIBUTE_NUMBER7							,
                    ATTRIBUTE_NUMBER8							,
                    ATTRIBUTE_NUMBER9							,
                    ATTRIBUTE_NUMBER10							,
                    ATTRIBUTE_TIMESTAMP1						,
                    ATTRIBUTE_TIMESTAMP2						,
                    ATTRIBUTE_TIMESTAMP3						,
                    ATTRIBUTE_TIMESTAMP4						,
                    ATTRIBUTE_TIMESTAMP5						,
                    ATTRIBUTE_TIMESTAMP6						,
                    ATTRIBUTE_TIMESTAMP7						,
                    ATTRIBUTE_TIMESTAMP8						,
                    ATTRIBUTE_TIMESTAMP9						,
                    ATTRIBUTE_TIMESTAMP10						,
                    AGENT_EMAIL_ADDR							,
                    MODE_OF_TRANSPORT							,
                    SERVICE_LEVEL								,
                    USE_SALES_ORDER_NUMBER_FLAG					,
                    BUYER_MANAGED_TRANSPORT_FLAG				,
                    CONFIGURED_ITEM_FLAG						,
                    ALLOW_ORDER_FRM_UNASSIGND_SITES		,
                    OUTSIDE_PROCESS_ENABLED_FLAG				,
                    DISABLE_AUTOSOURCING_FLAG					,
                    MASTER_CONTRACT_NUMBER						,
                    MASTER_CONTRACT_TYPE						,
                    PO_HEADER_ID
                )

            SELECT  distinct pt_i_MigrationSetID														--migration_set_id
                    ,gvt_migrationsetname                              								--migration_set_name
                    ,'EXTRACTED'																		--migration_status
                    ,pha.po_header_id																	--interface_header_key
                    ,''																					--action
                    ,''																					--batch_id
                    ,pha.interface_source_code															--interface_source_code
                    ,pha.authorization_status															--approval_action
                    ,pha.segment1																		--document_num
                    ,pha.type_lookup_code																--document_type_code
                    ,''																					--style_display_name
                    ,''																					--prc_bu_name
                    ,''																					--agent_name
                    ,pha.currency_code																	--currency_code
                    ,pha.comments																		--comments
                    ,pv.vendor_name																		--vendor_name
                    ,pv.segment1																		--vendor_num
                    ,pvsa.vendor_site_code																--vendor_site_code
                    ,''																					--vendor_contact
                    ,''																					--vendor_doc_num
                    ,pha.fob_lookup_code																--fob
                    ,''																					--freight_carrier
                    ,pha.freight_terms_lookup_code														--freight_terms
                    ,pha.pay_on_code																	--pay_on_code
                    ,''																					--payment_terms
                    ,''																					--originator_role
                    ,pha.change_summary																	--change_order_desc
                    ,pha.acceptance_required_flag														--acceptance_required_flag
                    ,''																					--acceptance_within_days
                    ,pha.supplier_notif_method															--supplier_notif_method
                    ,pha.fax																			--fax
                    ,pha.email_address																	--email_address
                    ,pha.confirming_order_flag															--confirming_order_flag
                    ,pha.blanket_total_amount															--amount_agreed
                    ,pha.amount_limit																	--amount_limit
                    ,pha.min_release_amount																--min_release_amount
                    ,pha.start_date																		--effective_date
                    ,pha.end_date																		--expiration_date
                    ,pha.note_to_vendor																	--note_to_vendor
                    ,pha.note_to_receiver																--note_to_receiver
                    ,''																					--generate_orders_automatic
                    ,''																					--submit_approval_automatic
                    ,''																					--group_requisitions
                    ,''																					--group_requisition_lines
                    ,''																					--use_ship_to
                    ,''																					--use_need_by_date
                    ,''																					--attribute_category
                    ,''																					--attribute1
                    ,''																					--attribute2
                    ,''																					--attribute3
                    ,''																					--attribute4
                    ,''																					--attribute5
                    ,''																					--attribute6
                    ,''																					--attribute7
                    ,''																					--attribute8
                    ,''																					--attribute9
                    ,''																					--attribute10
                    ,''																					--attribute11
                    ,''																					--attribute12
                    ,''																					--attribute13
                    ,''																					--attribute14
                    ,''																					--attribute15
                    ,''																					--attribute16
                    ,''																					--attribute17
                    ,''																					--attribute18
                    ,''																					--attribute19
                    ,''																					--attribute20
                    ,''																					--attribute_date1
                    ,''																					--attribute_date2
                    ,''																					--attribute_date3
                    ,''																					--attribute_date4
                    ,''																					--attribute_date5
                    ,''																					--attribute_date6
                    ,''																					--attribute_date7
                    ,''																					--attribute_date8
                    ,''																					--attribute_date9
                    ,''																					--attribute_date10
                    ,''																					--attribute_number1
                    ,''																					--attribute_number2
                    ,''																					--attribute_number3
                    ,''																					--attribute_number4
                    ,''																					--attribute_number5
                    ,''																					--attribute_number6
                    ,''																					--attribute_number7
                    ,''																					--attribute_number8
                    ,''																					--attribute_number9
                    ,''																					--attribute_number10
                    ,''																					--attribute_timestamp1
                    ,''																					--attribute_timestamp2
                    ,''																					--attribute_timestamp3
                    ,''																					--attribute_timestamp4
                    ,''																					--attribute_timestamp5
                    ,''																					--attribute_timestamp6
                    ,''																					--attribute_timestamp7
                    ,''																					--attribute_timestamp8
                    ,''																					--attribute_timestamp9
                    ,''																					--attribute_timestamp10
                    ,''																					--agent_email_addr
                    ,''																					--mode_of_transport
                    ,''																					--service_level
                    ,''																					--use_sales_order_number_flag
                    ,''																					--buyer_managed_transport_flag
                    ,''																					--configured_item_flag
                    ,''																					--allow_ordering_from_unassigned_sites
                    ,''																					--outside_process_enabled_flag
                    ,''																					--disable_autosourcing_flag
                    ,''																					--master_contract_number
                    ,''																					--master_contract_type
                    ,pha.po_header_id																	--po_header_id
            FROM
                     PO_HEADERS_ALL@XXMX_EXTRACT			pha
                    ,PO_VENDORS@XXMX_EXTRACT   			pv
                    ,PO_VENDOR_SITES_ALL@XXMX_EXTRACT		pvsa
                    ,XXMX_PURCHASE_ORDER_SCOPE_V				xpos
            WHERE  1                                 = 1
            --
            AND pha.type_lookup_code              	= 'CONTRACT'
            AND pha.org_id                    	 	= xpos.org_id
            --AND pha.po_header_id				  	= xpos.po_header_id
            --
            AND pha.vendor_id                   	= pv.vendor_id
            AND pha.vendor_site_id               	= pvsa.vendor_site_id
            ;

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
            -- Hr_Utility.raise_error@XXMX_EXTRACT;
    END export_po_headers_cpa;
END XXMX_PO_HEADERS_PKG;