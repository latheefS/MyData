CREATE OR REPLACE PACKAGE  xxmx_po_headers_pkg AS 
     --
     --
     /*
     *****************************************************************************
     **
     **                 Copyright (c) 2022 Version 1
     **
     **                           Millennium House,
     **                           Millennium Walkway,
     **                           Dublin 1
     **                           D01 F5P8
     **
     **                           All rights reserved.
     **
     *****************************************************************************
     **
     **
     ** FILENAME  :  xxmx_po_headers_pkg.sql
     **
     ** FILEPATH  :  $XXMX_TOP/install/sql
     **
     ** VERSION   :  1.2
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Ian S. Vickerstaff
     **
     ** PURPOSE   :  This script installs the package for the Maximise PO
     **              Data Migration.
     **
     ** NOTES     :
     **
     ******************************************************************************
     **
     ** PRE-REQUISITIES
     ** ---------------
     **
     ** If this script is to be executed as part of an installation script, ensure
     ** that the installation script performs the following tasks prior to calling
     ** this script.
     **
     ** Task  Description
     ** ----  ---------------------------------------------------------------------
     ** 1.    Run the installation script to create all necessary database objects
     **       and Concurrent definitions:
     **
     **            $XXMX_TOP/install/sql/xxmx_ap_inv_stg_dbi.sql
     **            $XXMX_TOP/install/sql/xxmx_ap_inv_xfm_dbi.sql
     **
     ** If this script is not to be executed as part of an installation script,
     ** ensure that the tasks above are, or have been, performed prior to executing
     ** this script.
     **
     ******************************************************************************
     **
     ** CALLING INSTALLATION SCRIPTS
     ** ----------------------------
     **
     ** The following installation scripts call this script:
     **
     ** File Path                                     File Name
     ** --------------------------------------------  ------------------------------
     ** N/A                                           N/A
     **
     ******************************************************************************
     **
     ** CALLED INSTALLATION SCRIPTS
     ** ---------------------------
     **
     ** The following installation scripts are called by this script:
     **
     ** File Path                                    File Name
     ** -------------------------------------------  ------------------------------
     ** N/A                                          N/A
     **
     ******************************************************************************
     **
     ** PARAMETERS
     ** ----------
     **
     ** Parameter                       IN OUT  Type
     ** -----------------------------  ------  ------------------------------------
     ** [parameter_name]                IN OUT
     **
     ******************************************************************************
     **
     ** [previous_filename] HISTORY
     ** -----------------------------
     **
     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     ** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
     **
     ******************************************************************************
     **
     ** xxcust_common_pkg.sql HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     **   1.0  23-NOV-2020  Ian S. Vickerstaff  Created for Maximise.
     **
     **   1.1  08-JAN-2022  Pallavi Kanajar    Extract Outstanding PO Amount
     **
     ******************************************************************************
     **
     **  Data Element Prefixes
     **  =====================
     **
     **  Utilizing prefixes for data and object names enhances the readability of code
     **  and allows for the context of a data element to be identified (and hopefully
     **  understood) without having to refer to the data element declarations section.
     **
     **  For example, having a variable in code simply named "x_id" is not very
     **  useful.  Don't laugh, I've seen it done.
     **
     **  If you came across such a variable hundreds of lines down in a packaged
     **  procedure or function, you could assume the variable's data type was
     **  NUMBER or INTEGER (if its purpose was to store an Oracle internal ID),
     **  but you would have to check in the declaration section to be sure.
     **
     **  However, if the purpose of the "x_id" variable was not to store an Oracle
     **  internal ID but perhaps some kind of client data identifier e.g. an
     **  Employee ID (and you could not tell this from the name) then the data type
     **  could easily be be VARCHAR2.  Again, you would have to navigate to the
     **  declaration section to be sure of the data type.
     **
     **  Also, the variable name does not give any developer who may need to modify
     **  the code (apart from the original author that is) any context as to the
     **  meaning of the variable.  Even the original author may struggle to remember
     **  what this variable is used for if s/he had to modify their own code months
     **  or years in the future.
     **
     **  This Package utilises prefixes of upto 6 characters for all data elements
     **  wherever possible.
     **
     **  The construction of Prefixes is governed by the following rules:
     **
     **       Parameters
     **       ----------
     **       1) Parameter prefixes always start with "p".
     **
     **       2) The second character in a parameter prefix denotes its
     **          data type:
     **
     **               b = Data element of type BOOLEAN.
     **               d = Data element of type DATE.
     **               i = Data element of type INTEGER.
     **               n = Data element of type NUMBER.
     **               r = Data element of type REAL.
     **               v = Data element of type VARCHAR2.
     **               t = Data element of type %TYPE (DB inherited type).
     **
     **       3) The third and/or fourth characters in a parameter prefix
     **          denote the direction in which value in the paramater is
     **          communicated:
     **
     **               i  = Input parameter (readable value only)
     **               o  = Output parameter (value assignable)
     **               io = Input/Output parameter (readable/assignable)
     **
     **          For clarity, the direction indicators are separated from
     **          the first two characters by an underscore. e.g. pv_i_
     **
     **       Global Data Elements
     **       --------------------
     **       1) Global data elements will always start with a "g" whether
     **          defined in the package body (and therefore only global within
     **          the package itself), or defined in the package specification
     **          (and therefore referencable outside of the package).
     **
     **          The subequent characters in a global prefix will follow the same
     **          conventions as per local constants and variables as explained
     **          below.
     **
     **       Local Data Elements
     **       -------------------
     **       1) The first character of a local data element's prefix (or second
     **          character for global) denotes the data element's assignability:
     **
     **               c = Denotes a constant.
     **
     **               v = Denotes a variable.
     **
     **       2) The second character or a local data element's prefix (or third
     **          character for global) denotes its data type (as with parameters):
     **
     **               b = Data element of type BOOLEAN.
     **               d = Data element of type DATE.
     **               i = Data element of type INTEGER.
     **               n = Data element of type NUMBER.
     **               r = Data element of type REAL.
     **               v = Data element of type VARCHAR2.
     **               t = Data element of type %TYPE (DB inherited type).
     **
     **  Prefix Examples
     **  ===============
     **
     **       Prefix    Indication
     **       --------  ----------------------------------------
     **       pb_i_     Input Parameter of type BOOLEAN
     **       pd_i_     Input Parameter of type DATE
     **       pi_i_     Input Parameter of type INTEGER
     **       pn_i_     Input Parameter of type NUMBER
     **       pr_i_     Input Parameter of type REAL
     **       pv_i_     Input Parameter of type VARCHAR2
     **       pt_i_     Input Parameter of type %TYPE
     **
     **       pb_o_     Output Parameter of type BOOLEAN
     **       pd_o_     Output Parameter of type DATE
     **       pi_o_     Output Parameter of type INTEGER
     **       pn_o_     Output Parameter of type NUMBER
     **       pr_o_     Output Parameter of type REAL
     **       pv_o_     Output Parameter of type VARCHAR2
     **       pt_o_     Output Parameter of type %TYPE
     **
     **       pb_io_    Input/Output Parameter of type BOOLEAN
     **       pd_io_    Input/Output Parameter of type DATE
     **       pi_io_    Input/Output Parameter of type INTEGER
     **       pn_io_    Input/Output Parameter of type NUMBER
     **       pr_io_    Input/Output Parameter of type REAL
     **       pv_io_    Input/Output Parameter of type VARCHAR2
     **       pt_io_    Input/Output Parameter of type %TYPE
     **
     **       gcb_      Global Constant of type BOOLEAN
     **       gcd_      Global Constant of type DATE
     **       gci_      Global Constant of type INTEGER
     **       gcn_      Global Constant of type NUMBER
     **       gcr_      Global Constant of type REAL
     **       gcv_      Global Constant of type VARCHAR2
     **       gct_      Global Constant of type %TYPE
     **
     **       gvb_      Global Variable of type BOOLEAN
     **       gvd_      Global Variable of type DATE
     **       gvi_      Global Variable of type INTEGER
     **       gvn_      Global Variable of type NUMBER
     **       gvr_      Global Variable of type REAL
     **       gvv_      Global Variable of type VARCHAR2
     **       gvt_      Global Variable of type %TYPE
     **
     **       cb_       Constant of type BOOLEAN
     **       cd_       Constant of type DATE
     **       ci_       Constant of type INTEGER
     **       cn_       Constant of type NUMBER
     **       cr_       Constant of type REAL
     **       cv_       Constant of type VARCHAR2
     **       ct_       Constant of type %TYPE
     **
     **       vb_       Variable of type BOOLEAN
     **       vd_       Variable of type DATE
     **       vi_       Variable of type INTEGER
     **       vn_       Variable of type NUMBER
     **       vr_       Variable of type REAL
     **       vv_       Variable of type VARCHAR2
     **       vt_       Variable of type %TYPE
     **
     **  PL/SQL Construct Suffixes
     **  =========================
     **
     **  Specific suffixes have been employed for PL/SQL Constructs:
     **
     **       _cur      Cursor Names
     **       _rt       PL/SQL Record Type Declarations
     **       _tt       PL/SQL Table Type Declarations
     **       _tbl      PL/SQL Table Declarations
     **       _rec      PL/SQL Record Declarations (or implicit
     **                 cursor record declarations)
     **
     **  Other Data Element Naming Conventions
     **  =====================================
     **
     **  Data elements names should have meaning which indicate their purpose or
     **  usage whilst adhering to the Oracle name length limit of 30 characters.
     **
     **  To compensate for longer data element prefixes, the rest of a data element
     **  name is constructed without underscores.  However to aid in maintaining
     **  readability and meaning, data elements names will contain concatenated
     **  words with initial letters capitalised in a similar manner to JAVA naming
     **  conventions.
     **
     **  By using the above conventions you can create meaningful data element
     **  names such as:
     **
     **       pn_i_POHeaderID
     **       ---------------
     **       This clearly identifies that the data element is an inbound only
     **       (non assignable) parameter of type NUMBER which holds an Oracle
     **       internal PO Header identifier.
     **
     **       pb_o_CreateOutputFileAsCSV
     **       --------------------------
     **       This clearly identifies that the data element is an output only
     **       parameter of type BOOLEAN that contains a flag which indicates
     **       that output of the calling process should be formatted as a CSV
     **       file.
     **
     **       gct_PackageName
     **       ---------------
     **       This data element is a global constant of type VARCHAR2.
     **
     **       ct_ProcOrFuncName
     **       -----------------
     **       This data element is a local constant of type VARCHAR2.
     **
     **       vt_APInvoiceID
     **       --------------
     **       This data element is a variable whose type is determined from a
     **       database table column and is meant to hold the Oracle internal
     **       identifier for a Payables Invoice Header.
     **
     **       vt_APInvoiceLineID
     **       ------------------
     **       Similar to the previous example but this clearly identified that the
     **       data element is intended to hold the Oracle internal identifier for
     **       a Payables Invoice Line.
     **
     **  Similarly for PL/SQL Constructs:
     **
     **       APInvoiceHeaders_cur
     **
     **       APInvoiceHeader_rec
     **
     **       TYPE EmployeeData_rt IS RECORD OF
     **            (
     **             employee_number   VARCHAR2(20)
     **            ,employee_name     VARCHAR2(30)
     **            );
     **
     **       TYPE EmployeeData_tt IS TABLE OF Employee_rt;
     **
     **       EmployeeData_tbl        EmployeeData_tt;
     **
     **  Careful and considerate use of the above rules when naming data elements
     **  can be a boon to other developers who may need to understand and/or modify
     **  your code in future.  In conjunction with good commenting practices of
     **  course.
     **
     ******************************************************************************
     */
     --
     --

    PROCEDURE stg_main 
        (
         pt_i_ClientCode                    IN          xxmx_client_config_parameters.client_code%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) ;

    PROCEDURE export_po_headers_std
        (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);


	PROCEDURE export_po_lines_std
        (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);

    PROCEDURE export_po_line_locations_std
        (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);

    PROCEDURE export_po_distributions_std
        (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);

    PROCEDURE export_po_headers_bpa
        (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);


	PROCEDURE export_po_lines_bpa
        (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);

    PROCEDURE export_po_line_locations_bpa
        (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);

    PROCEDURE export_po_headers_cpa
        (pt_i_MigrationSetID              IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE);

END  XXMX_PO_HEADERS_PKG;


/


CREATE OR REPLACE PACKAGE BODY XXMX_PO_HEADERS_PKG AS 
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

	/****************************************************************	
	----------------Export Purchase Orders Information---------------
	****************************************************************/
    gvv_ReturnStatus                          VARCHAR2(1);

    gvt_ReturnMessage                         xxmx_module_messages.module_message%TYPE;
    gvv_ProgressIndicator                     VARCHAR2(100); 
    gcv_PackageName                           CONSTANT  VARCHAR2(30)                                := 'XXMX_PO_HEADERS_PKG';
    gct_ApplicationSuite                      CONSTANT  xxmx_module_messages.application_suite%TYPE := 'SCM';
    gct_Application                           CONSTANT  xxmx_module_messages.application%TYPE       := 'PO';
    gv_i_BusinessEntity                         VARCHAR2(100)                               := 'PURCHASE_ORDERS';
    ct_Phase                                  CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
    cv_i_BusinessEntityLevel                  CONSTANT  VARCHAR2(100)                               := 'ALL';
    --gv_hr_date					              DATE                                                  := '31-DEC-4712';
    gct_stgschema                                       VARCHAR2(10)                                := 'XXMX_STG';
    gvt_migrationsetname                      VARCHAR2(100);
    gvt_Severity                              xxmx_module_messages.severity%TYPE;
    gvt_ModuleMessage                         xxmx_module_messages.module_message%TYPE;
    gvt_OracleError                           xxmx_module_messages.oracle_error%TYPE;
    gvn_RowCount                              NUMBER;

    E_MODULEERROR                             EXCEPTION;
    e_DateError                               EXCEPTION;


PROCEDURE stg_main (pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                   ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE ) 
IS 

        CURSOR METADATA_CUR
        IS
         SELECT	entity_package_name
                 ,stg_procedure_name
                 ,business_entity
                 ,sub_entity_seq
                 ,sub_entity
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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;

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
        gv_i_BusinessEntity                         VARCHAR2(100)                               := 'PURCHASE_ORDERS';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_SCM_PO_HEADERS_STD_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PO_HEADERS_STD';

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

            SELECT  distinct pt_i_MigrationSetID      													--migration_set_id                         
                    ,gvt_MigrationSetName                               								--migration_set_name
                    ,'EXTRACTED'                               											--migration_status
                    ,pha.PO_HEADER_ID																	--interface_header_key
                    ,''																					--action
                    ,''																					--batch_id
                    ,pha.INTERFACE_SOURCE_CODE															--interface_source_code
                    ,pha.AUTHORIZATION_STATUS															--approval_action
                    ,pha.SEGMENT1																		--document_num
                    ,pha.TYPE_LOOKUP_CODE																--document_type_code
                    ,(SELECT pds.display_name
                        FROM   apps.po_doc_style_lines_tl@MXDM_NVIS_EXTRACT pds
                        WHERE  pds.document_subtype = 'STANDARD'
                        AND    pds.style_id = pha.style_id) 											--style_display_name
                    ,hout.name																			--prc_bu_name
                    ,NVL((SELECT hou.name
                            FROM   apps.po_distributions_all@MXDM_NVIS_EXTRACT         pda
                                  ,apps.po_req_distributions_all@MXDM_NVIS_EXTRACT     prda
                                  ,apps.po_requisition_lines_all@MXDM_NVIS_EXTRACT     prla
                                  ,apps.po_requisition_headers_all@MXDM_NVIS_EXTRACT   prha
                                  ,apps.hr_operating_units@MXDM_NVIS_EXTRACT           hou
                            WHERE  pha.po_header_id           = pda.po_header_id
                            AND    pda.req_distribution_id    = prda.distribution_id
                            AND    prda.requisition_line_id   = prla.requisition_line_id
                            AND    prla.requisition_header_id = prha.requisition_header_id
                            AND    hou.organization_id        = prha.org_id
                            AND    rownum                     = 1),hout.name)							--req_bu_name
                    , (SELECT xep.name
                        FROM   apps.hr_operating_units@MXDM_NVIS_EXTRACT hou
                        ,apps.xle_entity_profiles@MXDM_NVIS_EXTRACT xep
                        WHERE  xep.legal_entity_id  = hou.default_legal_context_id
                        AND    hou.organization_id = hout.organization_id)                              --soldto_le_name
                    , hout.name                                                                         --billto_bu_name
                    ,(SELECT lower(ppf.email_address)
                       FROM   apps.per_all_people_f@MXDM_NVIS_EXTRACT  ppf
                       WHERE  ppf.person_id            = pha.agent_id
                       AND    ppf.email_address       IS NOT NULL
                       AND    ppf.effective_start_date = ( SELECT max(effective_start_date)
                                                           FROM   apps.per_all_people_f@MXDM_NVIS_EXTRACT  ppf1
                                                           WHERE  ppf1.person_id = ppf.person_id) )		--agent_name
                    ,pha.CURRENCY_CODE																	--currency_code
                    ,pha.RATE																			--rate
                    ,pha.RATE_TYPE																		--rate_type
                    ,pha.RATE_DATE																		--rate_date
                    ,pha.COMMENTS																		--comments
                    , ( SELECT hrlb.location_code
                         from   apps.hr_locations_all@MXDM_NVIS_EXTRACT           hrlb
                         WHERE  hrlb.location_id                  = pha.bill_to_location_id )           --bill_to_location
                    , ( SELECT hrls.location_code
                         from   apps.hr_locations_all@MXDM_NVIS_EXTRACT           hrls
                         WHERE  hrls.location_id                  = pha.ship_to_location_id )           --ship_to_location
                    ,pv.VENDOR_NAME																		--vendor_name
                    ,pv.SEGMENT1																		--vendor_num
                    ,pvsa.VENDOR_SITE_CODE																--vendor_site_code
                    ,''																					--vendor_contact
                    ,''																					--vendor_doc_num
                    ,pha.fob_lookup_code																--fob
                    ,''																					--freight_carrier
                    ,pha.freight_terms_lookup_code                                                      --freight_terms
                    ,pha.PAY_ON_CODE																	--pay_on_code
                    ,(select name
                        from   apps.ap_terms@MXDM_NVIS_EXTRACT
                        where  term_id = pha.terms_id)  												--payment_terms
                    ,''																					--originator_role
                    ,pha.CHANGE_SUMMARY																	--change_order_desc
                    ,pha.ACCEPTANCE_REQUIRED_FLAG														--acceptance_required_flag
                    ,''																					--acceptance_within_days
                    ,pha.SUPPLIER_NOTIF_METHOD															--supplier_notif_method
                    ,pha.FAX																			--fax
                    ,pha.EMAIL_ADDRESS																	--email_address
                    ,pha.CONFIRMING_ORDER_FLAG															--confirming_order_flag
                    ,pha.NOTE_TO_VENDOR																	--note_to_vendor
                    ,pha.NOTE_TO_RECEIVER																--note_to_receiver
                    ,''																					--default_taxation_country
                    ,''																					--tax_document_subtype
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
                    ,''																					--first_pty_reg_num
                    ,''																					--third_pty_reg_num
                    ,''																					--buyer_managed_transport_flag
                    ,''																					--master_contract_number
                    ,''																					--master_contract_type
                    ,''																					--cc_email_address
                    ,''																					--bcc_email_address
                    ,pha.po_header_id																	--po_header_id                                             				--po_header_id
            FROM
                     PO_HEADERS_ALL@MXDM_NVIS_EXTRACT			pha
                    ,PO_VENDORS@MXDM_NVIS_EXTRACT   			pv
                    ,PO_VENDOR_SITES_ALL@MXDM_NVIS_EXTRACT		pvsa
                    ,(SELECT  
                                po_header_id
                                , unit_price
                                , matching_basis
                                ,'YES' line_close
                                , SUM(open_po) po_open_line
                                , SUM(close_po) po_close_line
                        FROM    xxmx_scm_po_open_qty_mv
                        WHERE   1 = 1
                        AND     (close_po > 0  or  open_po > 0)
                        GROUP BY  po_header_id, unit_price, matching_basis,'YES') mv
                    ,apps.hr_operating_units@MXDM_NVIS_EXTRACT         hout
            WHERE  1                                 = 1
            --
            AND pha.type_lookup_code              	= 'STANDARD'
            AND pha.po_header_id                     = mv.po_header_id
            AND pha.org_id                        = hout.organization_id
            --
            AND pha.vendor_id                   	= pv.vendor_id
            AND pha.vendor_site_id               	= pvsa.vendor_site_id
            AND EXISTS                                 ( SELECT 1
                                                            FROM   xxmx_scm_po_open_qty_mv mv1
                                                            WHERE  mv1.po_header_id     = pha.po_header_id
                                                            AND    mv1.open_po          > 0 )
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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;
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
        gv_i_BusinessEntity                         VARCHAR2(100)                               := 'PURCHASE_ORDERS';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_SCM_PO_LINES_STD_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PO_LINES_STD';

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


                INSERT  
                INTO    XXMX_SCM_PO_LINES_STD_STG
                       (MIGRATION_SET_ID				,
                        MIGRATION_SET_NAME				,
                        MIGRATION_STATUS				, 
                        INTERFACE_LINE_KEY				,
                        INTERFACE_HEADER_KEY			,
                        ACTION							,
                        LINE_NUM						,
                        LINE_TYPE						,
                        ITEM							,
                        ITEM_DESCRIPTION				,
                        ITEM_REVISION					,
                        CATEGORY						,
                        AMOUNT							,
                        QUANTITY						,
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

                SELECT  distinct pt_i_MigrationSetID                               							--migration_set_id                               
                        ,gvt_migrationsetname                               								--migration_set_name                               
                        ,'EXTRACTED'                														--migration_status 
                        ,pla.po_line_id||'_'||pla.LINE_NUM    													--interface_line_key
                        ,pha.PO_HEADER_ID	                  													--interface_header_key
                        ,''               																	--action
                        ,pla.LINE_NUM              															--line_num
                        ,plt.LINE_TYPE       																--line_type	
                        ,(SELECT msib.segment1||'.'||msib.segment2
                           FROM   apps.mtl_system_items_b@MXDM_NVIS_EXTRACT msib
                           WHERE  msib.inventory_item_id =  pla.item_id
                           AND    ROWNUM = 1)             													--item
                        ,pla.ITEM_DESCRIPTION        														--item_description
                        ,pla.ITEM_REVISION       															--item_revision	
                        , ( SELECT mct.description
                            FROM   apps.mtl_categories_b@MXDM_NVIS_EXTRACT      mcb
                                  ,apps.mtl_categories_tl@MXDM_NVIS_EXTRACT     mct
                            WHERE  1 = 1
                            AND    mcb.category_id = mct.category_id
                            AND    mcb.category_id = pla.category_id )   									--category	
                        ,CASE WHEN mv.MATCHING_BASIS = 'AMOUNT' 
                          THEN mv.po_open_line
                         END                                                                     AS   AMOUNT
                        ,CASE WHEN mv.MATCHING_BASIS = 'QUANTITY' 
                           THEN mv.po_open_line
                         END                                                                     AS   QUANTITY
                        ,NVL(pla.unit_meas_lookup_code, 'Each')                                  AS   UNIT_OF_MEASURE
                        ,CASE WHEN mv.MATCHING_BASIS = 'QUANTITY' 
                           THEN mv.unit_price
                          END                                                                    AS   UNIT_PRICE
                        ,pla.SECONDARY_QUANTITY    															--secondary_quantity
                        ,pla.SECONDARY_UNIT_OF_MEASURE														--secondary_unit_of_measure
                        ,pla.VENDOR_PRODUCT_NUM       														--vendor_product_num
                        ,pla.NEGOTIATED_BY_PREPARER_FLAG  													--negotiated_by_preparer_flag
                       , ( SELECT phc.hazard_class
                            FROM   apps.po_hazard_classes_tl@MXDM_NVIS_EXTRACT  phc
                            WHERE  phc.hazard_class_id = pla.hazard_class_id)                               -- hazard_class
                        , ( SELECT poun.un_number
                            FROM   apps.po_un_numbers_tl@MXDM_NVIS_EXTRACT poun
                            WHERE  poun.un_number_id = pla.un_number_id)                                    --Un_Number
                        ,pla.NOTE_TO_VENDOR																	--note_to_vendor
                        ,''                               													--note_to_receiver
                        ,''                               													--line_attribute_category_lines
                        ,''                               													--line_attribute1	
                        ,''                               													--line_attribute2	
                        ,''                               													--line_attribute3	
                        ,''                               													--line_attribute4	
                        ,''                               													--line_attribute5	
                        ,''                               													--line_attribute6	
                        ,''                               													--line_attribute7	
                        ,''                               													--line_attribute8	
                        ,''                               													--line_attribute9	
                        ,''                               													--line_attribute10
                        ,''                               													--line_attribute11
                        ,''                               													--line_attribute12
                        ,''                               													--line_attribute13
                        ,''                               													--line_attribute14
                        ,''                               													--line_attribute15
                        ,''                               													--line_attribute16
                        ,''                               													--line_attribute17
                        ,''                               													--line_attribute18
                        ,''                               													--line_attribute19
                        ,''                               													--line_attribute20
                        ,''                               													--attribute_date1	
                        ,''                               													--attribute_date2	
                        ,''                               													--attribute_date3	
                        ,''                               													--attribute_date4	
                        ,''                               													--attribute_date5	
                        ,''                               													--attribute_date6	
                        ,''                               													--attribute_date7	
                        ,''                               													--attribute_date8	
                        ,''                               													--attribute_date9	
                        ,''                               													--attribute_date10
                        ,''                               													--attribute_number1
                        ,''                               													--attribute_number2
                        ,''                               													--attribute_number3
                        ,''                               													--attribute_number4
                        ,''                               													--attribute_number5
                        ,''                               													--attribute_number6
                        ,''                               													--attribute_number7
                        ,''                               													--attribute_number8
                        ,''                               													--attribute_number9
                        ,''                               													--attribute_number10
                        ,''                               													--attribute_timestamp1
                        ,''                               													--attribute_timestamp2
                        ,''                               													--attribute_timestamp3
                        ,''                               													--attribute_timestamp4
                        ,''                               													--attribute_timestamp5
                        ,''                               													--attribute_timestamp6
                        ,''                               													--attribute_timestamp7
                        ,''                               													--attribute_timestamp8
                        ,''                               													--attribute_timestamp9
                        ,''                               													--attribute_timestamp10
                        ,''                               													--unit_weight		
                        ,''                               													--weight_uom_code	
                        ,''                               													--weight_unit_of_measure
                        ,''                               													--unit_volume		
                        ,''                               													--volume_uom_code	
                        ,''                               													--volume_unit_of_measure
                        ,''                               													--template_name	
                        ,''                               													--item_attribute_category
                        ,''                               													--item_attribute1	
                        ,''                               													--item_attribute2	
                        ,''                               													--item_attribute3	
                        ,''                               													--item_attribute4	
                        ,''                               													--item_attribute5	
                        ,''                               													--item_attribute6	
                        ,''                               													--item_attribute7	
                        ,''                               													--item_attribute8	
                        ,''                               													--item_attribute9	
                        ,''                               													--item_attribute10
                        ,''                               													--item_attribute11
                        ,''                               													--item_attribute12
                        ,''                               													--item_attribute13
                        ,''                               													--item_attribute14
                        ,''                               													--item_attribute15
                        ,''                               													--source_agreement_prc_bu_name
                        ,''                               													--source_agreement
                        ,''                               													--source_agreement_line
                        ,''                               													--discount_type	
                        ,''                               													--discount		
                        ,''                               													--discount_reason
                        ,pla.max_retainage_amount	      													--max_retainage_amount
                        ,pha.po_header_id               													--po_header_id 
                        ,pla.po_line_id               														--po_line_id
                FROM
                         PO_HEADERS_ALL@MXDM_NVIS_EXTRACT		    pha
                        ,PO_LINES_ALL@MXDM_NVIS_EXTRACT   			pla
                        ,PO_LINE_TYPES_TL@MXDM_NVIS_EXTRACT			plt
                        ,(SELECT   line_num
                                , po_header_id
                                , po_line_id
                                , unit_price
                                , matching_basis
                                ,'YES' line_close
                                , SUM(open_po) po_open_line
                                , SUM(close_po) po_close_line
                        FROM    xxmx_scm_po_open_qty_mv
                        WHERE   1 = 1
                        AND     (close_po > 0  or  open_po > 0)
                        GROUP BY line_num, po_header_id, po_line_id, unit_price, matching_basis,'YES') mv
                WHERE  1                                  = 1
                --
                 AND pha.type_lookup_code                 = 'STANDARD'
                 --
                 AND pla.po_header_id                  	 = pha.po_header_id
                 AND pla.line_type_id                     = plt.line_type_id
                 AND pha.po_header_id                     = mv.po_header_id
                 AND pla.po_line_id                       = mv.po_line_id
                 AND EXISTS                                 ( SELECT 1
                                                            FROM   xxmx_scm_po_open_qty_mv mv1
                                                            WHERE  mv1.po_header_id     = pha.po_header_id
                                                            AND    mv1.open_po          > 0 )
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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;
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
        gv_i_BusinessEntity                         VARCHAR2(100)                               := 'PURCHASE_ORDERS';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PO_LINE_LOCATIONS_STD';

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

            INSERT  
            INTO    XXMX_SCM_PO_LINE_LOCATIONS_STD_STG
                   (MIGRATION_SET_ID					,
                    MIGRATION_SET_NAME					,
                    MIGRATION_STATUS					, 
                    INTERFACE_LINE_LOCATION_KEY			,
                    INTERFACE_LINE_KEY					,
                    SHIPMENT_NUM						,
                    SHIP_TO_LOCATION					,
                    SHIP_TO_ORGANIZATION_CODE			,
                    AMOUNT								,
                    QUANTITY							,
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

            SELECT  distinct pt_i_MigrationSetID  														--migration_set_id                             
                    ,gvt_migrationsetname        														--migration_set_name                       
                    ,'EXTRACTED'																		      --migration_status
                    ,plla.line_location_id||'_'||plla.shipment_num							      --interface_line_location_key
                    ,pla.po_line_id||'_'||pla.line_num														--interface_line_key
                    ,plla.shipment_num																	   --shipment_num
                    ,( SELECT hrla.location_code
                       FROM   hr_locations_all@MXDM_NVIS_EXTRACT hrla			
                       WHERE  hrla.location_id = plla.ship_to_location_id )					--ship_to_location
                    ,''																					      --ship_to_organization_code
                    , CASE WHEN plt.MATCHING_BASIS = 'AMOUNT' 
                           THEN (NVL(pda.amount_ordered, 0) - NVL(pda.amount_cancelled, 0) - NVL(pda.amount_billed, 0))
                      END                                                                 AS AMOUNT
                    , CASE WHEN plt.MATCHING_BASIS = 'QUANTITY' 
                           THEN (pda.quantity_ordered - NVL(pda.quantity_cancelled, 0) - NVL(pda.quantity_billed, 0)) 
                      END                                                                  AS quantity	
                    ,plla.need_by_date 																	--need_by_date
                    ,plla.promised_date																	--promised_date
                    ,plla.secondary_quantity															   --secondary_quantity
                    ,plla.secondary_unit_of_measure													--secondary_unit_of_measure
                    ,''																					      --destination_type_code
                    ,''																					      --accrue_on_receipt_flag
                    ,''																					      --allow_substitute_receipts_flag
                    ,''																			      		--assessable_value
                    ,plla.days_early_receipt_allowed													--days_early_receipt_allowed
                    ,plla.days_late_receipt_allowed													--days_late_receipt_allowed
                    ,plla.enforce_ship_to_location_code												--enforce_ship_to_location_code
                    ,plla.inspection_required_flag														--inspection_required_flag
                    ,plla.receipt_required_flag															--receipt_required_flag
                    ,plla.invoice_close_tolerance														--invoice_close_tolerance
                    ,plla.receive_close_tolerance														--receipt_close_tolerance
                    ,plla.qty_rcv_tolerance																--qty_rcv_tolerance
                    ,plla.qty_rcv_exception_code														--qty_rcv_exception_code
                    ,plla.receipt_days_exception_code													--receipt_days_exception_code
                    ,''																					      --receiving_routing
                    ,plla.note_to_receiver																--note_to_receiver
                    ,''																					--input_tax_classification_code
                    ,''																					--line_intended_use
                    ,''																					--product_category
                    ,''																					--product_fisc_classification
                    ,''																					--product_type
                    ,''																					--trx_business_category_code
                    ,''																					--user_defined_fisc_class
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
                    ,''																					--freight_carrier
                    ,''																					--mode_of_transport
                    ,''																					--service_level
                    ,''																					--final_discharge_location_code
                    ,''																					--requested_ship_date
                    ,''																					--promised_ship_date
                    ,plla.need_by_date																--requested_delivery_date
                    ,plla.promised_date															--promised_delivery_date
                    ,''																					--retainage_rate
                    ,''																					--invoice_match_option
                    ,pha.po_header_id																--po_header_id
                    ,pla.po_line_id																	--po_line_id
                    ,plla.line_location_id														--line_location_id
            FROM
                     PO_HEADERS_ALL@MXDM_NVIS_EXTRACT			pha
                    ,PO_LINES_ALL@MXDM_NVIS_EXTRACT   			pla
                    ,PO_LINE_LOCATIONS_ALL@MXDM_NVIS_EXTRACT	plla
                    ,po_line_types@MXDM_NVIS_EXTRACT            plt
                    ,po_distributions_all@MXDM_NVIS_EXTRACT     pda
                    ,(SELECT   line_num
                                , po_header_id
                                , po_line_id
                                , unit_price
                                , matching_basis
                                , line_location_id
                                , shipment_num
                                , SUM(open_po) po_open_line
                                , SUM(close_po) po_close_line
                        FROM    xxmx_scm_po_open_qty_mv
                        WHERE   1 = 1
                        AND     (close_po > 0  or  open_po > 0)
                        GROUP BY line_num, po_header_id, po_line_id, unit_price, line_location_id,shipment_num,matching_basis) mv
              WHERE 1                                   = 1
              AND pha.type_lookup_code                  = 'STANDARD'		  
              --
              AND pla.line_type_id                      = plt.line_type_id
              AND pha.po_header_id                      = pda.po_header_id
              AND pla.po_line_id                        = pda.po_line_id
              AND plla.line_location_id                 = pda.line_location_id
              AND pha.po_header_id                      = mv.po_header_id
              AND pla.po_line_id                        = mv.po_line_id		  
              AND plla.line_location_id                 = mv.line_location_id	
              AND EXISTS                                 ( SELECT 1
                                                            FROM   xxmx_scm_po_open_qty_mv mv1
                                                            WHERE  mv1.po_header_id     = pha.po_header_id
                                                            AND    mv1.open_po          > 0 )
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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;
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
        gv_i_BusinessEntity                         VARCHAR2(100)                               := 'PURCHASE_ORDERS';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PO_DISTRIBUTIONS_STD';

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

            INSERT  
            INTO    XXMX_SCM_PO_DISTRIBUTIONS_STD_STG
                   (MIGRATION_SET_ID				,
                    MIGRATION_SET_NAME				,
                    MIGRATION_STATUS				, 
                    INTERFACE_DISTRIBUTION_KEY		,
                    INTERFACE_LINE_LOCATION_KEY		,	
                    DISTRIBUTION_NUM				,
                    DELIVER_TO_LOCATION				,
                    DELIVER_TO_PERSON_FULL_NAME		,
                    DESTINATION_SUBINVENTORY		,
                    AMOUNT_ORDERED					,
                    QUANTITY_ORDERED				,
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

            SELECT  distinct pt_i_MigrationSetID  														--migration_set_id                            
                    ,gvt_MigrationSetName        														--migration_set_name                      
                    ,'EXTRACTED'													      					--migration_status
                    ,pda.po_distribution_id||'_'||pda.distribution_num							--interface_distribution_key
                    ,plla.line_location_id||'_'||plla.SHIPMENT_NUM   								--interface_line_location_key
                    ,pda.distribution_num 																--distribution_num
                    ,( SELECT hrlb.location_code
                       FROM   hr_locations_all@MXDM_NVIS_EXTRACT hrlb
                       WHERE  1 = 1 
                       AND    hrlb.location_id = pda.deliver_to_location_id)					--deliver_to_location
                    ,''																					      --deliver_to_person_full_name
                    ,pda.destination_subinventory 														--destination_subinventory
                    , CASE WHEN plt.MATCHING_BASIS = 'AMOUNT' 
                           THEN (NVL(pda.amount_ordered, 0) - NVL(pda.amount_cancelled, 0) - NVL(pda.amount_billed, 0))
                      END                                                                     		    --amount
                    , CASE WHEN plt.MATCHING_BASIS = 'QUANTITY' 
                           THEN (pda.quantity_ordered - NVL(pda.quantity_cancelled, 0) - NVL(pda.quantity_billed, 0)) 
                      END                                                                               --quantity	
                    ,gcc.segment1																		--charge_account_segment1
                    ,gcc.segment2																		--charge_account_segment2
                    ,gcc.segment3																		--charge_account_segment3
                    ,gcc.segment4																		--charge_account_segment4
                    ,gcc.segment5																		--charge_account_segment5
                    ,gcc.segment6																		--charge_account_segment6
                    ,gcc.segment7																		--charge_account_segment7
                    ,gcc.segment8																		--charge_account_segment8
                    ,gcc.segment9																		--charge_account_segment9
                    ,''																					--charge_account_segment10
                    ,''																					--charge_account_segment11
                    ,''																					--charge_account_segment12
                    ,''																					--charge_account_segment13
                    ,''																					--charge_account_segment14
                    ,''																					--charge_account_segment15
                    ,''																					--charge_account_segment16
                    ,''																					--charge_account_segment17
                    ,''																					--charge_account_segment18
                    ,''																					--charge_account_segment19
                    ,''																					--charge_account_segment20
                    ,''																					--charge_account_segment21
                    ,''																					--charge_account_segment22
                    ,''																					--charge_account_segment23
                    ,''																					--charge_account_segment24
                    ,''																					--charge_account_segment25
                    ,''																					--charge_account_segment26
                    ,''																					--charge_account_segment27
                    ,''																					--charge_account_segment28
                    ,''																					--charge_account_segment29
                    ,''																					--charge_account_segment30
                    ,pda.destination_context															--destination_context
                    ,(SELECT p.segment1
                      FROM   pa_projects_all@MXDM_NVIS_EXTRACT p
                      WHERE  p.project_id=pda.project_id)										--project
                    ,(SELECT t.task_number
                      FROM   pa_tasks@MXDM_NVIS_EXTRACT t
                      WHERE  t.task_id = pda.task_id)												--task
                    ,pda.expenditure_item_date														--pjc_expenditure_item_date
                    ,pda.expenditure_type																--expenditure_type
                    ,(SELECT haou.name
                      FROM   apps.hr_all_organization_units@MXDM_NVIS_EXTRACT haou
                      where  haou.organization_id =pda.expenditure_organization_id) 	--expenditure_organization
                    ,''																					--pjc_billable_flag
                    ,''																					--pjc_capitalizable_flag
                    ,''																					--pjc_work_type
                    ,''																					--pjc_reserved_attribute1
                    ,''																					--pjc_reserved_attribute2
                    ,''																					--pjc_reserved_attribute3
                    ,''																					--pjc_reserved_attribute4
                    ,''																					--pjc_reserved_attribute5
                    ,''																					--pjc_reserved_attribute6
                    ,''																					--pjc_reserved_attribute7
                    ,''																					--pjc_reserved_attribute8
                    ,''																					--pjc_reserved_attribute9
                    ,''																					--pjc_reserved_attribute10
                    ,''																					--pjc_user_def_attribute1
                    ,''																					--pjc_user_def_attribute2
                    ,''																					--pjc_user_def_attribute3
                    ,''																					--pjc_user_def_attribute4
                    ,''																					--pjc_user_def_attribute5
                    ,''																					--pjc_user_def_attribute6
                    ,''																					--pjc_user_def_attribute7
                    ,''																					--pjc_user_def_attribute8
                    ,''																					--pjc_user_def_attribute9
                    ,''																					--pjc_user_def_attribute10
                    ,pda.rate																			--rate
                    ,pda.rate_date																		--rate_date
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
                    ,CASE when pda.deliver_to_location_id is not null
                        then (select lower(ppf.email_address)
                              from   per_all_people_f@MXDM_NVIS_EXTRACT  ppf
                              where  ppf.person_id = pda.deliver_to_person_id
                              and    ppf.email_address is not null
                              and    ppf.effective_start_date =  ( select max(effective_start_date)
                                                                   from   per_all_people_f@MXDM_NVIS_EXTRACT  ppf1
                                                                   where  ppf1.person_id = ppf.person_id)
                              )  end																	--deliver_to_person_email_addr
                    ,''																					--budget_date
                    ,''																					--pjc_contract_number
                    ,''																					--pjc_funding_source
                    ,pha.po_header_id																	--po_header_id
                    ,pla.po_line_id																		--po_line_id
                    ,plla.line_location_id																--line_location_id
                    ,pda.po_distribution_id																--po_distribution_id				
            FROM
                     PO_HEADERS_ALL@MXDM_NVIS_EXTRACT			pha
                    ,PO_LINES_ALL@MXDM_NVIS_EXTRACT   			pla
                    ,PO_LINE_LOCATIONS_ALL@MXDM_NVIS_EXTRACT	plla
                    ,PO_DISTRIBUTIONS_ALL@MXDM_NVIS_EXTRACT		pda
                    ,gl_code_combinations@MXDM_NVIS_EXTRACT     gcc
                    ,po_line_types@MXDM_NVIS_EXTRACT            plt
                    ,(SELECT   line_num
                                , po_header_id
                                , po_line_id
                                , unit_price
                                ,po_distribution_id
                                , matching_basis
                                , line_location_id
                                , shipment_num
                                , SUM(open_po) po_open_line
                                , SUM(close_po) po_close_line
                        FROM    xxmx_scm_po_open_qty_mv
                        WHERE   1 = 1
                        AND     (close_po > 0  or  open_po > 0)
                        GROUP BY line_num, shipment_num,  po_header_id, po_line_id,LINE_LOCATION_ID, po_distribution_id, unit_price, matching_basis) mv
              WHERE 1                                   = 1
              AND pha.type_lookup_code                  = 'STANDARD'		  
              --
              AND  NVL(pda.code_combination_id, 0)      = gcc.code_combination_id(+)
              AND pla.line_type_id                      = plt.line_type_id
              AND  pda.po_header_id                     = mv.po_header_id
              AND  pda.po_line_id                       = mv.po_line_id
              AND  pda.line_location_id                 = mv.line_location_id
              AND  pda.po_distribution_id               = mv.po_distribution_id
              AND EXISTS                                 ( SELECT 1
                                                            FROM   xxmx_scm_po_open_qty_mv mv1
                                                            WHERE  mv1.po_header_id     = pha.po_header_id
                                                            AND    mv1.open_po          > 0 )
              -- 
              AND pda.po_header_id                      = pha.po_header_id
              AND pda.po_line_id                        = pla.po_line_id
              AND pda.line_location_id                  = plla.line_location_id
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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;
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
        gv_i_BusinessEntity                            VARCHAR2(100)                     := 'PURCHASE_ORDERS_BPA';
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
                    ALLOW_ORDER_FRM_UNASSIGND_SITES		   ,
                    OUTSIDE_PROCESS_ENABLED_FLAG				,
                    MASTER_CONTRACT_NUMBER						,
                    MASTER_CONTRACT_TYPE						,
                    PO_HEADER_ID														
                  )

            SELECT  distinct pt_i_MigrationSetID													--migration_set_id
                    ,gvt_migrationsetname																--migration_set_name                               
                    ,'EXTRACTED'																		   --migration_status
                    ,pha.po_header_id																	--interface_header_key
                    ,''  																					--action
                    ,''	   																				--batch_id
                    ,pha.interface_source_code														--interface_source_code
                    ,pha.authorization_status														--approval_action
                    ,pha.segment1																		--document_num
                    ,pha.type_lookup_code																--document_type_code
                    ,''																					   --style_display_name
                    ,''																					   --prc_bu_name
                    ,''																					   --agent_name
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
                     PO_HEADERS_ALL@MXDM_NVIS_EXTRACT			pha
                    ,PO_VENDORS@MXDM_NVIS_EXTRACT   			pv
                    ,PO_VENDOR_SITES_ALL@MXDM_NVIS_EXTRACT		pvsa
                    ,XXMX_PURCHASE_ORDER_SCOPE_V				xpos
            WHERE  1                                 = 1
            --
            AND pha.type_lookup_code              	= 'BLANKET'
            AND pha.org_id                    	 	= xpos.org_id
            AND pha.po_header_id				      	= xpos.po_header_id
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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;
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
        gv_i_BusinessEntity                            VARCHAR2(100)                     := 'PURCHASE_ORDERS_BPA';
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

            SELECT  distinct pt_i_MigrationSetID												--migration_set_id
                    ,gvt_migrationsetname															--migration_set_name                               
                    ,'EXTRACTED'																		--migration_status
                    ,pla.po_line_id||'_'||pla.line_num											--interface_line_key
                    ,pha.po_header_id																--interface_header_key
                    ,''																					--action
                    ,pla.line_num																	--line_num
                    ,plt.line_type																	--line_type
                    ,''																					--item
                    ,pla.item_description															--item_description
                    ,pla.item_revision																--item_revision
                    ,''																					--category
                    ,pla.committed_amount															--committed_amount
                    ,pla.unit_meas_lookup_code													--unit_of_measure
                    ,pla.unit_price																	--unit_price
                    ,pla.allow_price_override_flag												--allow_price_override_flag
                    ,pla.not_to_exceed_price														--not_to_exceed_price
                    ,pla.vendor_product_num														--vendor_product_num
                    ,pla.negotiated_by_preparer_flag											--negotiated_by_preparer_flag
                    ,pla.note_to_vendor															--note_to_vendor
                    ,''																					--note_to_receiver
                    ,pla.min_release_amount														--min_release_amount
                    ,pla.expiration_date															--expiration_date
                    ,pla.supplier_part_auxid														--supplier_part_auxid
                    ,pla.supplier_ref_number														--supplier_ref_number
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
                    ,pla.amount																		--amount
                    ,pla.price_break_lookup_code												--price_break_lookup_code
                    ,pla.quantity_committed														--quantity_committed
                    ,''																					--allow_description_update_flag
                    ,pha.po_header_id																--po_header_id
                    ,pla.po_line_id																	--po_line_id
            FROM
                     PO_HEADERS_ALL@MXDM_NVIS_EXTRACT		    pha
                    ,PO_LINES_ALL@MXDM_NVIS_EXTRACT   			pla
                    ,PO_LINE_TYPES_TL@MXDM_NVIS_EXTRACT			plt
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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;
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
        gv_i_BusinessEntity                            VARCHAR2(100)                     := 'PURCHASE_ORDERS_BPA';
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

            SELECT  distinct pt_i_MigrationSetID  				               				--migration_set_id                             
                    ,gvt_migrationsetname        				               				--migration_set_name                       
                    ,'EXTRACTED'								                						--migration_status
                    ,plla.line_location_id||'_'||plla.shipment_num								--interface_line_location_key
                    ,pla.po_line_id||'_'||pla.line_num												--interface_line_key
                    ,plla.shipment_num																	--shipment_num
                    ,''															      					--ship_to_location
                    ,''																	   				--ship_to_organization_code
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
                    ,pha.po_header_id																--po_header_id
                    ,pla.po_line_id																	--po_line_id
                    ,plla.line_location_id														--line_location_id	
            FROM
                     PO_HEADERS_ALL@MXDM_NVIS_EXTRACT			pha
                    ,PO_LINES_ALL@MXDM_NVIS_EXTRACT   			pla
                    ,PO_LINE_LOCATIONS_ALL@MXDM_NVIS_EXTRACT	plla
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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;
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
        gv_i_BusinessEntity                            VARCHAR2(100)                     := 'PURCHASE_ORDERS_CPA';
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
                    ALLOW_ORDER_FRM_UNASSIGND_SITES			,
                    OUTSIDE_PROCESS_ENABLED_FLAG				,
                    DISABLE_AUTOSOURCING_FLAG					,
                    MASTER_CONTRACT_NUMBER						,
                    MASTER_CONTRACT_TYPE						,
                    PO_HEADER_ID								
                )

            SELECT  distinct pt_i_MigrationSetID														--migration_set_id                              
                    ,gvt_migrationsetname                              							--migration_set_name
                    ,'EXTRACTED'																		      --migration_status
                    ,pha.po_header_id																	   --interface_header_key
                    ,''																					      --action
                    ,''																					      --batch_id
                    ,pha.interface_source_code															--interface_source_code
                    ,pha.authorization_status															--approval_action
                    ,pha.segment1																		   --document_num
                    ,pha.type_lookup_code																   --document_type_code
                    ,''																					      --style_display_name
                    ,''																					      --prc_bu_name
                    ,''																					      --agent_name
                    ,pha.currency_code																	   --currency_code
                    ,pha.comments																		   --comments
                    ,pv.vendor_name																	   	--vendor_name
                    ,pv.segment1																		      --vendor_num
                    ,pvsa.vendor_site_code																--vendor_site_code
                    ,''																					      --vendor_contact
                    ,''																					      --vendor_doc_num
                    ,pha.fob_lookup_code															   	--fob
                    ,''																			      		--freight_carrier
                    ,pha.freight_terms_lookup_code														--freight_terms
                    ,pha.pay_on_code																	   --pay_on_code
                    ,''																					      --payment_terms
                    ,''																					      --originator_role
                    ,pha.change_summary																	--change_order_desc
                    ,pha.acceptance_required_flag														--acceptance_required_flag
                    ,''																					      --acceptance_within_days
                    ,pha.supplier_notif_method													   	--supplier_notif_method
                    ,pha.fax																			      --fax
                    ,pha.email_address																	   --email_address
                    ,pha.confirming_order_flag															--confirming_order_flag
                    ,pha.blanket_total_amount															--amount_agreed
                    ,pha.amount_limit																	   --amount_limit
                    ,pha.min_release_amount																--min_release_amount
                    ,pha.start_date																		   --effective_date
                    ,pha.end_date																		   --expiration_date
                    ,pha.note_to_vendor																	--note_to_vendor
                    ,pha.note_to_receiver															   	--note_to_receiver
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
                    ,pha.po_header_id																--po_header_id
            FROM
                     PO_HEADERS_ALL@MXDM_NVIS_EXTRACT			pha
                    ,PO_VENDORS@MXDM_NVIS_EXTRACT   			pv
                    ,PO_VENDOR_SITES_ALL@MXDM_NVIS_EXTRACT		pvsa
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
            -- Hr_Utility.raise_error@MXDM_NVIS_EXTRACT;
    END export_po_headers_cpa;
END XXMX_PO_HEADERS_PKG;
/
