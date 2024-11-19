create or replace PACKAGE xxmx_po_receipt_pkg 
AS
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
     ** FILENAME  :  xxmx_po_receipt_pkg.sql
     **
     ** FILEPATH  :  $XXMX_TOP/install/sql
     **
     ** VERSION   :  1.3
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Sinchana Ramesh
     **
     ** PURPOSE   :  This script installs the package for the Maximise PO Receipts
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
     **            $XXMX_TOP/install/sql/xxmx_po_receipt_stg_dbi.sql
     **            $XXMX_TOP/install/sql/xxmx_po_receipt_xfm_dbi.sql
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
     **   1.0  22-MAY-2023  Sinchana Ramesh     Created for Maximise.
     **
     **   1.1  22-MAY-2023  Sinchana Ramesh     Extract logic updates.
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
     ******************************************************************************
     */
     --
     --
     /*
     ********************************
     ** PROCEDURE: po_rcpt_hdr_stg
     ********************************
     */
     --
     PROCEDURE po_rcpt_hdr_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     ********************************
     ** PROCEDURE: po_rcpt_hdr_xfm
     ********************************
     */
     --
     /*PROCEDURE po_rcpt_hdr_xfm
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_SimpleXfmPerformedBy       IN      xxmx_migration_metadata.simple_xfm_performed_by%TYPE
                    );*/
     --
     --
	 /*
     **********************************
     ** PROCEDURE: po_rcpt_txn_stg
     **********************************
     */
     --
     PROCEDURE po_rcpt_txn_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     **********************************
     ** PROCEDURE: po_rcpt_txn_xfm
     **********************************
     */
     --
     /*PROCEDURE po_rcpt_txn_xfm
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_SimpleXfmPerformedBy       IN      xxmx_migration_metadata.simple_xfm_performed_by%TYPE
                    );*/
     --
     --
     /*
     **********************
     ** PROCEDURE: stg_main
     **********************
     */
     --
      PROCEDURE stg_main 
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                    );
     --
     --
     /*
     **********************
     ** PROCEDURE: xfm_main
     **********************
     */
     --
     /*PROCEDURE xfm_main
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    );*/
     --
     --
     /*
     *******************
     ** PROCEDURE: purge
     *******************
     */
     --
     /*PROCEDURE purge
                   (
                    pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                   ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                   );*/
      --   
      --
END xxmx_po_receipt_pkg;
/
Show errors package xxmx_po_receipt_pkg;
/
create or replace PACKAGE BODY xxmx_po_receipt_pkg AS
    gct_PackageName                           CONSTANT xxmx_module_messages.package_name%TYPE       := 'xxmx_po_receipt_pkg';
    gvv_ReturnStatus                          VARCHAR2(1); 
    gvt_ReturnMessage                         xxmx_module_messages.module_message%TYPE;
    gvv_ProgressIndicator                     VARCHAR2(100); 
    gcv_PackageName                           CONSTANT  VARCHAR2(30)                                := 'xxmx_po_receipt_pkg';
    gct_ApplicationSuite                      CONSTANT  xxmx_module_messages.application_suite%TYPE := 'SCM';
    gct_Application                           CONSTANT  xxmx_module_messages.application%TYPE       := 'PO';
    gct_BusinessEntity                        CONSTANT xxmx_migration_metadata.business_entity%TYPE := 'PURCHASE_ORDER_RECEIPT';
    gv_i_BusinessEntity                       CONSTANT  VARCHAR2(100)                               := 'PURCHASE_ORDER_RECEIPT';
    ct_Phase                                  CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
    cv_i_BusinessEntityLevel                  CONSTANT  VARCHAR2(100)                               := 'ALL';
    gv_hr_date                                DATE                                                  := '31-DEC-4712';
    p_bg_name                                 VARCHAR2(100)                                         := 'TEST_BG'; 
    gvt_MigrationSetName                      xxmx_migration_headers.migration_set_name%TYPE;  
    gvt_Severity                              xxmx_module_messages.severity%TYPE;
    gvt_ModuleMessage                         xxmx_module_messages.module_message%TYPE;
    gvt_OracleError                           xxmx_module_messages.oracle_error%TYPE;
    gvn_RowCount                              NUMBER;
    gct_StgSchema                             VARCHAR2(30)       := 'XXMX_STG';
    E_MODULEERROR                             EXCEPTION;
    e_DateError                               EXCEPTION;
    --ct_ProcOrFuncName                         CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'po_rcpt_hdr_stg';                                                                                      
    --ct_ProcOrFuncName                         CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'po_rcpt_txn_stg';


PROCEDURE stg_main (pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                   ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE ) 
IS 
CURSOR METADATA_CUR
        IS
            SELECT    Entity_package_name,Stg_procedure_name, BUSINESS_ENTITY,SUB_ENTITY_SEQ,sub_entity
                                           FROM   xxmx_migration_metadata a 
                                           WHERE application_suite = gct_ApplicationSuite
            AND                       Application = gct_Application
                                           AND      BUSINESS_ENTITY = gv_i_BusinessEntity
                                           AND      a.enabled_flag = 'Y'
            Order by Business_entity_seq, Sub_entity_seq;

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'stg_main'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_SCM_PO_RCPT_HDR_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PURCHASE_ORDER_RECEIPT';
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
PROCEDURE po_rcpt_hdr_stg
         (
        pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
         ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE )  
         IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'po_rcpt_hdr_stg'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_SCM_PO_RCPT_HDR_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PURCHASE_ORDER_RECEIPT';
        ct_ProcOrFuncName                   CONSTANT    xxmx_module_messages.proc_or_func_name%TYPE := 'po_rcpt_hdr_stg';                                                                                      


--        lvv_migration_date_to                           VARCHAR2(30); 
--        lvv_migration_date_from                         VARCHAR2(30); 
--        lvv_prev_tax_year_date                          VARCHAR2(30);         
--        lvd_migration_date_to                           DATE;  
--        lvd_migration_date_from                         DATE;
--        lvd_prev_tax_year_date                          DATE;  

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

        DELETE 
        FROM    XXMX_SCM_PO_RCPT_HDR_STG ;

        COMMIT;

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
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity 
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Extracting "'
                                             ||pt_i_SubEntity
                                             ||'".'
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
                 ,pt_i_SubEntity        => pt_i_SubEntity
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
            --** Extract the data and insert into the staging table.
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
                 --end if;
            --
            --** ISV 21/10/2020 - The staging table is in the xxmx_stg schema but should not need to be prefixed as there should
            --**                  by a Synonym in the xxmx_core schema to that table.
            --

INSERT  
           INTO    XXMX_SCM_PO_RCPT_HDR_STG (
           HEADER_INTERFACE_NUMBER          ,  
           MIGRATION_SET_ID                 ,  
           MIGRATION_SET_NAME               ,  
           MIGRATION_STATUS                 ,  
           RECEIPT_SOURCE_CODE              ,  
           ASN_TYPE                         ,  
           TRANSACTION_TYPE                 ,  
           NOTICE_CREATION_DATE             ,  
           SHIPMENT_NUMBER                  ,  
           RECEIPT_NUMBER                   ,  
           VENDOR_NAME                      ,  
           VENDOR_NUM                       ,  
           VENDOR_SITE_CODE                 ,  
           FROM_ORGANIZATION_CODE           ,  
           SHIP_TO_ORGANIZATION_CODE        ,  
           LOCATION_CODE                    ,  
           BILL_OF_LADING                   ,  
           PACKING_SLIP                     ,  
           SHIPPED_DATE                     ,  
           CARRIER_NAME                     ,  
           EXPECTED_RECEIPT_DATE            ,  
           NUM_OF_CONTAINERS                ,  
           WAY_BILL_AIRBILL_NUM              ,  
           COMMENTS                         ,  
           GROSS_WEIGHT                     ,  
           GROSS_WEIGHT_UNIT_OF_MEASURE     ,  
           NET_WEIGHT                       ,  
           NET_WEIGHT_UNIT_OF_MEASURE       ,  
           TAR_WEIGHT                       ,  
           TAR_WEIGHT_UNIT_OF_MEASURE       ,  
           PACKAGING_CODE                   ,  
           CARRIER_METHOD                   ,  
           CARRIER_EQUIPMENT                ,  
           SPECIAL_HANDLING_CODE            ,  
           HAZARD_CODE                      ,  
           HAZARD_CLASS                     ,  
           HAZARD_DESCRIPTION               ,  
           FREIGHT_TERMS                    ,  
           FREIGHT_BILL_NUMBER              ,  
           INVOICE_NUM                      ,  
           INVOICE_DATE                     ,  
           TOTAL_INVOICE_AMOUNT             ,  
           TAX_NAME                         ,  
           TAX_AMOUNT                       ,  
           FREIGHT_AMOUNT                   ,  
           CURRENCY_CODE                    ,  
           CONVERSION_RATE_TYPE             ,  
           CONVERSION_RATE                  ,  
           CONVERSION_RATE_DATE             ,  
           PAYMENT_TERMS_NAME               ,  
           EMPLOYEE_NAME                    ,  
           TRANSACTION_DATE                 ,  
           CUSTOMER_ACCOUNT_NUMBER          ,  
           CUSTOMER_PARTY_NAME              ,  
           CUSTOMER_PARTY_NUMBER            ,  
           BUSINESS_UNIT                    ,  
           RA_OUTSOURCER_PARTY_NAME         ,  
           RECEIPT_ADVICE_NUMBER            ,  
           RA_DOCUMENT_CODE                 ,  
           RA_DOCUMENT_NUMBER               ,  
           RA_DOC_REVISION_NUMBER           ,  
           RA_DOC_REVISION_DATE             ,  
           RA_DOC_CREATION_DATE             ,  
           RA_DOC_LAST_UPDATE_DATE          ,  
           RA_OUTSOURCER_CONTACT_NAME       ,  
           RA_VENDOR_SITE_NAME              ,  
           RA_NOTE_TO_RECEIVER              ,  
           RA_DOO_SOURCE_SYSTEM_NAME        ,  
           ATTRIBUTE_CATEGORY               ,  
           ATTRIBUTE1                       ,  
           ATTRIBUTE2                       ,  
           ATTRIBUTE3                       ,  
           ATTRIBUTE4                       ,  
           ATTRIBUTE5                       ,  
           ATTRIBUTE6                       ,  
           ATTRIBUTE7                       ,  
           ATTRIBUTE8                       ,  
           ATTRIBUTE9                       ,  
           ATTRIBUTE10                      ,  
           ATTRIBUTE11                      ,  
           ATTRIBUTE12                      ,  
           ATTRIBUTE13                      ,  
           ATTRIBUTE14                      ,  
           ATTRIBUTE15                      ,  
           ATTRIBUTE16                      ,  
           ATTRIBUTE17                      ,  
           ATTRIBUTE18                      ,  
           ATTRIBUTE19                      ,  
           ATTRIBUTE20                      ,  
           ATTRIBUTE_NUMBER1                ,  
           ATTRIBUTE_NUMBER2                ,  
           ATTRIBUTE_NUMBER3                ,  
           ATTRIBUTE_NUMBER4                ,  
           ATTRIBUTE_NUMBER5                ,  
           ATTRIBUTE_NUMBER6                ,  
           ATTRIBUTE_NUMBER7                ,  
           ATTRIBUTE_NUMBER8                ,  
           ATTRIBUTE_NUMBER9                ,  
           ATTRIBUTE_NUMBER10               ,  
           ATTRIBUTE_DATE1                  ,  
           ATTRIBUTE_DATE2                  ,  
           ATTRIBUTE_DATE3                  ,  
           ATTRIBUTE_DATE4                  ,  
           ATTRIBUTE_DATE5                  ,  
           ATTRIBUTE_TIMESTAMP1             ,  
           ATTRIBUTE_TIMESTAMP2             ,  
           ATTRIBUTE_TIMESTAMP3             ,  
           ATTRIBUTE_TIMESTAMP4             ,  
           ATTRIBUTE_TIMESTAMP5             ,  
           GL_DATE                          ,  
           RECEIPT_HEADER_ID                ,  
           EXTERNAL_SYS_TXN_REFERENCE       ,  
           EMPLOYEE_ID                        
         ) 
           SELECT  distinct 
            rsh.shipment_header_id                                                                           AS HEADER_INTERFACE_NUMBER
           ,pt_i_MigrationSetID                                                                             --MIGRATION_SET_ID                                                                                                               
           ,gvt_MigrationSetName                                                                           --MIGRATION_SET_NAME                                                                                      
           ,'EXTRACTED'                                                                                    --MIGRATION_STATUS                                                                                                                                                                                                                    
          ,rsh.receipt_source_code                                                                           AS RECEIPT_SOURCE_CODE
          ,rsh.asn_type                                                                                      AS ASN_TYPE
          ,'NEW'                                                                                             AS TRANSACTION_TYPE
          ,rsh.notice_creation_date                                                                          AS NOTICE_CREATION_DATE
          ,rsh.shipment_num                                                                                  AS SHIPMENT_NUM
          ,rsh.receipt_num                                                                                   AS RECEIPT_NUM
          ,pv.vendor_name                                                                                    AS VENDOR_NAME
          ,pv.segment1                                                                                       AS VENDOR_NUM
          ,pvs.vendor_site_code                                                                              AS VENDOR_SITE_CODE
          ,null                                                                                              AS FROM_ORGANIZATION_CODE
          ,null                                                                                              AS SHIP_TO_ORGANIZATION_CODE
          ,null                                                                                              AS LOCATION_CODE
          ,rsh.bill_of_lading                                                                                AS BILL_OF_LADING
          ,rsh.packing_slip                                                                                  AS PACKING_SLIP
          ,rsh.shipped_date                                                                                  AS SHIPPED_DATE
          ,rsh.freight_carrier_code                                                                          AS FREIGHT_CARRIER_NAME
          ,rsh.expected_receipt_date                                                                         AS EXPECTED_RECEIPT_DATE
          ,rsh.num_of_containers                                                                             AS NUM_OF_CONTAINERS
          ,rsh.waybill_airbill_num                                                                           AS WAYBILL_AIRBILL_NUM
          ,replace(replace(replace(replace(rsh.comments , chr(13)), chr(10),',') ,'"','""'),'   ','')        AS COMMENTS
          ,rsh.gross_weight                                                                                  AS GROSS_WEIGHT
          ,rsh.gross_weight_uom_code                                                                         AS GROSS_WEIGHT_UNIT_OF_MEASURE
          ,rsh.net_weight                                                                                    AS NET_WEIGHT
          ,rsh.net_weight_uom_code                                                                           AS NET_WEIGHT_UNIT_OF_MEASURE
          ,rsh.tar_weight                                                                                    AS TAR_WEIGHT
          ,rsh.tar_weight_uom_code                                                                           AS TAR_WEIGHT_UNIT_OF_MEASURE
          ,rsh.packaging_code                                                                                AS PACKAGING_CODE
          ,rsh.carrier_method                                                                                AS CARRIER_METHOD
          ,rsh.carrier_equipment                                                                             AS CARRIER_EQUIPMENT
          ,rsh.special_handling_code                                                                         AS SPECIAL_HANDLING_CODE
          ,rsh.hazard_code                                                                                   AS HAZARD_CODE
          ,rsh.hazard_class                                                                                  AS HAZARD_CLASS
          ,rsh.hazard_description                                                                            AS HAZARD_DESCRIPTION
          ,rsh.freight_terms                                                                                 AS FREIGHT_TERMS
          ,rsh.freight_bill_number                                                                           AS FREIGHT_BILL_NUMBER
          ,rsh.invoice_num                                                                                   AS INVOICE_NUM
          ,rsh.invoice_date                                                                                  AS INVOICE_DATE
          ,rsh.invoice_amount                                                                                AS TOTAL_INVOICE_AMOUNT
          ,rsh.tax_name                                                                                      AS TAX_NAME
          ,rsh.tax_amount                                                                                    AS TAX_AMOUNT
          ,rsh.freight_amount                                                                                AS FREIGHT_AMOUNT
          ,rsh.currency_code                                                                                 AS CURRENCY_CODE
          ,rsh.conversion_rate_type                                                                          AS CONVERSION_RATE_TYPE
          ,rsh.conversion_rate                                                                               AS CONVERSION_RATE
          ,rsh.conversion_date                                                                               AS CONVERSION_RATE_DATE
          ,rsh.payment_terms_id                                                                              AS PAYMENT_TERMS_NAME
          ,NULL                                                                                              AS EMPLOYEE_NAME
          ,(SELECT MAX(rt.transaction_date)                                                                  
            FROM  apps.rcv_transactions@MXDM_NVIS_EXTRACT rt                                                 
            WHERE rsh.shipment_header_id = rt.shipment_header_id)                                            AS TRANSACTION_DATE
          ,NULL                                                                                              AS CUSTOMER_ACCOUNT_NUMBER
          ,NULL                                                                                              AS CUSTOMER_PARTY_NAME
          ,NULL                                                                                              AS CUSTOMER_PARTY_NUMBER
          ,NULL                                                                                              AS BUSINESS_UNIT
          ,NULL                                                                                              AS RA_OUTSOURCER_PARTY_NAME
          ,NULL                                                                                              AS RECEIPT_ADVICE_NUMBER
          ,NULL                                                                                              AS RA_DOCUMENT_CODE
          ,NULL                                                                                              AS RA_DOCUMENT_NUMBER
          ,NULL                                                                                              AS RA_DOC_REVISION_NUMBER
          ,NULL                                                                                              AS RA_DOC_REVISION_DATE
          ,NULL                                                                                              AS RA_DOC_CREATION_DATE
          ,NULL                                                                                              AS RA_DOC_LAST_UPDATE_DATE
          ,NULL                                                                                              AS RA_OUTSOURCER_CONTACT_NAME
          ,NULL                                                                                              AS RA_VENDOR_SITE_NAME
          ,NULL                                                                                              AS RA_NOTE_TO_RECEIVER
          ,NULL                                                                                              AS RA_DOO_SOURCE_SYSTEM_NAME                             
          ,NULL                                                                                              AS ATTRIBUTE_CATEGORY
          ,NULL                                                                                              AS ATTRIBUTE1
          ,NULL                                                                                              AS ATTRIBUTE2
          ,NULL                                                                                              AS ATTRIBUTE3
          ,NULL                                                                                              AS ATTRIBUTE4
          ,NULL                                                                                              AS ATTRIBUTE5
          ,NULL                                                                                              AS ATTRIBUTE6
          ,NULL                                                                                              AS ATTRIBUTE7
          ,NULL                                                                                              AS ATTRIBUTE8
          ,NULL                                                                                              AS ATTRIBUTE9
          ,NULL                                                                                              AS ATTRIBUTE10
          ,NULL                                                                                              AS ATTRIBUTE11
          ,NULL                                                                                              AS ATTRIBUTE12
          ,NULL                                                                                              AS ATTRIBUTE13
          ,NULL                                                                                              AS ATTRIBUTE14
          ,NULL                                                                                              AS ATTRIBUTE15
          ,NULL                                                                                              AS ATTRIBUTE16
          ,NULL                                                                                              AS ATTRIBUTE17
          ,NULL                                                                                              AS ATTRIBUTE18
          ,NULL                                                                                              AS ATTRIBUTE19
          ,NULL                                                                                              AS ATTRIBUTE20
          ,NULL                                                                                              AS ATTRIBUTE_NUMBER1
          ,NULL                                                                                              AS ATTRIBUTE_NUMBER2
          ,NULL                                                                                              AS ATTRIBUTE_NUMBER3
          ,NULL                                                                                              AS ATTRIBUTE_NUMBER4
          ,NULL                                                                                              AS ATTRIBUTE_NUMBER5
          ,NULL                                                                                              AS ATTRIBUTE_NUMBER6
          ,NULL                                                                                              AS ATTRIBUTE_NUMBER7
          ,NULL                                                                                              AS ATTRIBUTE_NUMBER8
          ,NULL                                                                                              AS ATTRIBUTE_NUMBER9
          ,NULL                                                                                              AS ATTRIBUTE_NUMBER10
          ,NULL                                                                                              AS ATTRIBUTE_DATE1
          ,NULL                                                                                              AS ATTRIBUTE_DATE2
          ,NULL                                                                                              AS ATTRIBUTE_DATE3
          ,NULL                                                                                              AS ATTRIBUTE_DATE4
          ,NULL                                                                                              AS ATTRIBUTE_DATE5
          ,NULL                                                                                              AS ATTRIBUTE_TIMESTAMP1
          ,NULL                                                                                              AS ATTRIBUTE_TIMESTAMP2
          ,NULL                                                                                              AS ATTRIBUTE_TIMESTAMP3
          ,NULL                                                                                              AS ATTRIBUTE_TIMESTAMP4
          ,NULL                                                                                              AS ATTRIBUTE_TIMESTAMP5
          ,NULL                                                                                              AS GL_DATE
          ,NULL                                                                                              AS RECEIPT_HEADER_ID
		  ,NULL                                                                                              AS EXTERNAL_SYS_TXN_REFERENCE
          ,NULL                                                                                              AS EMPLOYEE_ID


      FROM  apps.rcv_shipment_headers@MXDM_NVIS_EXTRACT rsh,
            apps.po_vendors@MXDM_NVIS_EXTRACT pv,
            apps.po_vendor_sites_all@MXDM_NVIS_EXTRACT pvs
     WHERE  1 = 1
       AND  rsh.vendor_id = pv.vendor_id
       AND  rsh.vendor_site_id = pvs.vendor_site_id
       AND  pv.vendor_id = pvs.vendor_id
       AND  EXISTS ( SELECT 1
                       FROM   rcv_shipment_lines@MXDM_NVIS_EXTRACT rsl,
                              rcv_transactions@MXDM_NVIS_EXTRACT rt,
                            (SELECT po_header_id,
                                    po_line_id,
                                    line_location_id,
                                    SUM(open_po) open_po,
                                    SUM(received) received,
                                    SUM(billed) billed
                                    FROM xxmx_po_open_quantity_mv pov
                              WHERE    pov.open_po > 0
                                   AND pov.received > 0
                                   AND pov.billed >= 0
                                   AND (pov.received - pov.billed) > 0
                              GROUP BY po_header_id,
                                       po_line_id,
                                       line_location_id) po_v
                      WHERE     rsl.shipment_header_id = rsh.shipment_header_id
                           AND rsl.po_header_id = po_v.po_header_id
                           AND rsl.po_line_id = po_v.po_line_id
                           AND rsl.po_line_location_id = po_v.line_location_id
                           AND rsl.shipment_header_id = rt.shipment_header_id
                           AND rsl.shipment_line_id = rt.shipment_line_id
                           AND rt.transaction_type = 'RECEIVE'
                           AND (NVL(rt.amount_billed, 0) != NVL(rt.amount, 0) OR NVL(rt.quantity_billed, 0) != NVL(rt.quantity, 0))); 
 COMMIT;

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

END po_rcpt_hdr_stg; 

--END xxmx_po_receipt_pkg;


PROCEDURE po_rcpt_txn_stg
         (
        pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
         ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE )  
         IS

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'po_rcpt_txn_stg'; 
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_SCM_PO_RCPT_TXN_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'PURCHASE_ORDER_RECEIPT';
		ct_ProcOrFuncName                   CONSTANT    xxmx_module_messages.proc_or_func_name%TYPE := 'po_rcpt_txn_stg';


--        lvv_migration_date_to                           VARCHAR2(30); 
--        lvv_migration_date_from                         VARCHAR2(30); 
--        lvv_prev_tax_year_date                          VARCHAR2(30);         
--        lvd_migration_date_to                           DATE;  
--        lvd_migration_date_from                         DATE;
--        lvd_prev_tax_year_date                          DATE;  

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

        DELETE 
        FROM    XXMX_SCM_PO_RCPT_TXN_STG    
          ;
		COMMIT;

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
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity 
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Extracting "'
                                             ||pt_i_SubEntity
                                             ||'".'
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
                 ,pt_i_SubEntity        => pt_i_SubEntity
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
            --** Extract the data and insert into the staging table.
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
                 --end if;
            --
            --** ISV 21/10/2020 - The staging table is in the xxmx_stg schema but should not need to be prefixed as there should
            --**                  by a Synonym in the xxmx_core schema to that table.
            --
INSERT  
           INTO    XXMX_SCM_PO_RCPT_TXN_STG (			
		   INTERFACE_LINE_NUM                   ,        
           MIGRATION_SET_ID                     ,  
           MIGRATION_SET_NAME                   ,  
           MIGRATION_STATUS                     ,  
         --INTERFACE_LINE_NUM                   ,  
           TRANSACTION_TYPE                     ,  
           AUTO_TRANSACT_CODE                   ,  
           TRANSACTION_DATE                     ,  
           SOURCE_DOCUMENT_CODE                 ,  
           RECEIPT_SOURCE_CODE                  ,  
           HEADER_INTERFACE_NUM                 ,  
           PARENT_TRANSACTION_ID                ,  
           PARENT_INTF_LINE_NUM                 ,  
           TO_ORGANIZATION_CODE                 ,  
           ITEM_NUM                             ,  
           ITEM_DESCRIPTION                     ,  
           ITEM_REVISION                        ,  
           DOCUMENT_NUM                         ,  
           DOCUMENT_LINE_NUM                    ,  
           DOCUMENT_SHIPMENT_LINE_NUM           ,  
           DOCUMENT_DISTRIBUTION_NUM            ,  
           BUSINESS_UNIT                        ,  
           SHIPMENT_NUM                         ,  
           EXPECTED_RECEIPT_DATE                ,  
           SUBINVENTORY                         ,  
           LOCATOR                              ,  
           QUANTITY                             ,  
           UNIT_OF_MEASURE                      ,  
           PRIMARY_QUANTITY                     ,  
           PRIMARY_UNIT_OF_MEASURE              ,  
           SECONDARY_QUANTITY                   ,  
           SECONDARY_UNIT_OF_MEASURE            ,  
           VENDOR_NAME                          ,  
           VENDOR_NUM                           ,  
           VENDOR_SITE_CODE                     ,  
           CUSTOMER_PARTY_NAME                  ,  
           CUSTOMER_PARTY_NUMBER                ,  
           CUSTOMER_ACCOUNT_NUMBER              ,  
           SHIP_TO_LOCATION_CODE                ,  
           LOCATION_CODE                        ,  
           REASON_NAME                          ,  
           DELIVER_TO_PERSON_NAME               ,  
           DELIVER_TO_LOCATION_CODE             ,  
           RECEIPT_EXCEPTION_FLAG               ,  
           ROUTING_HEADER_ID                    ,  
           DESTINATION_TYPE_CODE                ,  
           INTERFACE_SOURCE_CODE                ,  
           INTERFACE_SOURCE_LINE_ID             ,  
           AMOUNT                               ,  
           CURRENCY_CODE                        ,  
           CURRENCY_CONVERSION_TYPE             ,  
           CURRENCY_CONVERSION_RATE             ,  
           CURRENCY_CONVERSION_DATE             ,  
           INSPECTION_STATUS_CODE               ,  
           INSPECTION_QUALITY_CODE              ,  
           FROM_ORGANIZATION_CODE               ,  
           FROM_SUBINVENTORY                    ,  
           FROM_LOCATOR                         ,  
           FREIGHT_CARRIER_NAME                 ,  
           BILL_OF_LADING                       ,  
           PACKING_SLIP                         ,  
           SHIPPED_DATE                         ,  
           NUM_OF_CONTAINERS                    ,  
           WAYBILL_AIRBILL_NUM                 ,  
           RMA_REFERENCE                        ,  
           COMMENTS                             ,  
           TRUCK_NUM                            ,  
           CONTAINER_NUM                        ,  
           SUBSTITUTE_ITEM_NUM                  ,  
           NOTICE_UNIT_PRICE                    ,  
           ITEM_CATEGORY                        ,  
           INTRANSIT_OWNING_ORG_CODE            ,  
           ROUTING_CODE                         ,  
           BARCODE_LABEL                        ,  
           COUNTRY_OF_ORIGIN_CODE               ,  
           CREATE_DEBIT_MEMO_FLAG               ,  
           LICENSE_PLATE_NUMBER                 ,  
           TRANSFER_LICENSE_PLATE_NUMBER        ,  
           LPN_GROUP_NUM                        ,  
           ASN_LINE_NUM                         ,  
           EMPLOYEE_NAME                        ,  
           SOURCE_TRANSACTION_NUM               ,  
           PARENT_SOURCE_TRANSACTION_NUM        ,  
           PARENT_INTERFACE_TXN_ID              ,  
           MATCHING_BASIS                       ,  
           RA_OUTSOURCER_PARTY_NAME             ,  
           RA_DOCUMENT_NUMBER                   ,  
           RA_DOCUMENT_LINE_NUMBER              ,  
           RA_NOTE_TO_RECEIVER                  ,  
           RA_VENDOR_SITE_NAME                  ,  
           ATTRIBUTE_CATEGORY                   ,  
           ATTRIBUTE1                           ,  
           ATTRIBUTE2                           ,  
           ATTRIBUTE3                           ,  
           ATTRIBUTE4                           ,  
           ATTRIBUTE5                           ,  
           ATTRIBUTE6                           ,  
           ATTRIBUTE7                           ,  
           ATTRIBUTE8                           ,  
           ATTRIBUTE9                           ,  
           ATTRIBUTE10                          ,  
           ATTRIBUTE11                          ,  
           ATTRIBUTE12                          ,  
           ATTRIBUTE13                          ,  
           ATTRIBUTE14                          ,  
           ATTRIBUTE15                          ,  
           ATTRIBUTE16                          ,  
           ATTRIBUTE17                          ,  
           ATTRIBUTE18                          ,  
           ATTRIBUTE19                          ,  
           ATTRIBUTE20                          ,  
           ATTRIBUTE_NUMBER1                    ,  
           ATTRIBUTE_NUMBER2                    ,  
           ATTRIBUTE_NUMBER3                    ,  
           ATTRIBUTE_NUMBER4                    ,  
           ATTRIBUTE_NUMBER5                    ,  
           ATTRIBUTE_NUMBER6                    ,  
           ATTRIBUTE_NUMBER7                    ,  
           ATTRIBUTE_NUMBER8                    ,  
           ATTRIBUTE_NUMBER9                    ,  
           ATTRIBUTE_NUMBER10                   ,  
           ATTRIBUTE_DATE1                      ,  
           ATTRIBUTE_DATE2                      ,  
           ATTRIBUTE_DATE3                      ,  
           ATTRIBUTE_DATE4                      ,  
           ATTRIBUTE_DATE5                      ,  
           ATTRIBUTE_TIMESTAMP1                 ,  
           ATTRIBUTE_TIMESTAMP2                 ,  
           ATTRIBUTE_TIMESTAMP3                 ,  
           ATTRIBUTE_TIMESTAMP4                 ,  
           ATTRIBUTE_TIMESTAMP5                 ,  
           CONSIGNED_FLAG                       ,  
           SOLDTO_LEGAL_ENTITY                  ,  
           CONSUMED_QUANTITY                    ,  
           DEFAULT_TAXATION_COUNTRY             ,  
           TRX_BUSINESS_CATEGORY                ,  
           DOCUMENT_FISCAL_CLASSIFICATION       ,  
           USER_DEFINED_FISC_CLASS              ,  
           PRODUCT_FISC_CLASS_NAME              ,  
           INTENDED_USE                         ,
           PRODUCT_CATEGORY                     , 
           TAX_CLASSIFICATION_CODE              ,  
           PRODUCT_TYPE                         , 
           FIRST_PTY_NUMBER                     ,  
           THIRD_PTY_NUMBER                     ,  
           TAX_INVOICE_NUMBER                   , 
           TAX_INVOICE_DATE                     ,  
           FINAL_DISCHARGE_LOC_CODE             ,  
           ASSESSABLE_VALUE                     ,  
           PHYSICAL_RETURN_REQD                 ,  
           EXTERNAL_SYSTEM_PACKING_UNIT         ,
           EWAY_BILL_NUMBER                     ,  
           EWAY_BILL_DATE                       ,  
           RECALL_NOTICE_NUMBER                 ,  
           RECALL_NOTICE_LINE_NUMBER            ,  
           EXTERNAL_SYS_TXN_REFERENCE           , 
           DEFAULT_LOTSER_FROM_ASN              ,  
           EMPLOYEE_ID                          
         )   
SELECT  DISTINCT 
          rsl.shipment_line_id                                                         AS  INTERFACE_LINE_NUM
	     ,pt_i_MigrationSetID                                                          --MIGRATION_SET_ID                                                                                                               
         ,gvt_MigrationSetName                                                         --MIGRATION_SET_NAME                                                                                      
         ,'EXTRACTED'                                                                  --MIGRATION_STATUS 
         , rt.transaction_type                                                          AS  TRANSACTION_TYPE
         , NULL                                                                         AS  AUTO_TRANSACT_CODE
         , rt.transaction_date                                                          AS  TRANSACTION_DATE
         , rsl.source_document_code                                                     AS  SOURCE_DOCUMENT_CODE
         , rsh.receipt_source_code                                                      AS  RECEIPT_SOURCE_CODE
         , rsh.shipment_header_id                                                       AS  HEADER_INTERFACE_NUM
         , null                                                                         AS  PARENT_TRANSACTION_ID
         , null                                                                         AS  PARENT_INTF_LINE_NUM
         , null                                                                         AS  TO_ORGANIZATION_CODE
         , null                                                                         AS  ITEM_NUM
         , replace(replace(replace(rsl.item_description , chr(13)), chr(10),',') ,'"','')
                                                                                        AS  ITEM_DESCRIPTION
         , null                                                                         AS  ITEM_REVISION
         , pha.segment1                                                                 AS  DOCUMENT_NUM
         , pla.line_num                                                                 AS  DOCUMENT_LINE_NUM
         , pll.shipment_num                                                             AS  DOCUMENT_SHIPMENT_LINE_NUM
         , null                                                                         AS  DOCUMENT_DISTRIBUTION_NUM
         , null                                                                         AS  BUSINESS_UNIT
         , rsh.shipment_num                                                             AS  SHIPMENT_NUM
         , rsh.expected_receipt_date                                                    AS  EXPECTED_RECEIPT_DATE
         , rt.subinventory                                                              AS  SUBINVENTORY
         , null                                                                         AS  LOCATOR
         , rt.quantity - NVL(
                                (SELECT   SUM(ABS(rt1.quantity))
                                 FROM     apps.rcv_transactions@MXDM_NVIS_EXTRACT rt1
                                 WHERE    rt1.transaction_type = 'RETURN TO VENDOR'
                                      AND rt1.parent_transaction_id = rt.transaction_id)
                            , 0)
                       + NVL(
                                (SELECT   SUM(rt1.quantity)
                                 FROM     apps.rcv_transactions@MXDM_NVIS_EXTRACT rt1
                                 WHERE    rt1.transaction_type  = 'CORRECT'
                                      AND rt1.parent_transaction_id = rt.transaction_id)
                            , 0)
					   - NVL(rt.quantity_billed, 0)
                                                                                        AS  QUANTITY
         , rt.unit_of_measure                                                           AS  UNIT_OF_MEASURE
         , null                                                                         AS  PRIMARY_QUANTITY
         , null                                                                         AS  PRIMARY_UNIT_OF_MEASURE
         , null                                                                         AS  SECONDARY_QUANTITY
         , null                                                                         AS  SECONDARY_UNIT_OF_MEASURE
         , pv.vendor_name                                                               AS  VENDOR_NAME
         , pv.segment1                                                                  AS  VENDOR_NUM
         , pvs.vendor_site_code                                                         AS  VENDOR_SITE_CODE
         , null                                                                         AS  CUSTOMER_PARTY_NAME
         , null                                                                         AS  CUSTOMER_PARTY_NUMBER
         , null                                                                         AS  CUSTOMER_ACCOUNT_NUMBER
         , null                                                                         AS  SHIP_TO_LOCATION_CODE
         , null                                                                         AS  LOCATION_CODE
         , null                                                                         AS  REASON_NAME
         , null                                                                         AS  DELIVER_TO_PERSON_NAME
         , null                                                                         AS  DELIVER_TO_LOCATION_CODE
         , null                                                                         AS  RECEIPT_EXCEPTION_FLAG
         , rsl.routing_header_id                                                        AS  ROUTING_HEADER_ID
         , rsl.destination_type_code                                                    AS  DESTINATION_TYPE_CODE
         , null                                                                         AS  INTERFACE_SOURCE_CODE
         , null                                                                         AS  INTERFACE_SOURCE_LINE_ID
         , rt.amount   - NVL(
                                (SELECT   SUM(ABS(rt1.amount))
                                 FROM     apps.rcv_transactions@MXDM_NVIS_EXTRACT rt1
                                 WHERE    rt1.transaction_type = 'RETURN TO VENDOR'
                                      AND rt1.parent_transaction_id = rt.transaction_id)
                            , 0)
                       + NVL(
                                (SELECT   SUM(rt1.amount)
                                 FROM     apps.rcv_transactions@MXDM_NVIS_EXTRACT rt1
                                 WHERE    rt1.transaction_type  = 'CORRECT'
                                      AND rt1.parent_transaction_id = rt.transaction_id)
                            , 0)
					   - NVL(rt.amount_billed, 0)							
		                                                                                AS  AMOUNT
         , rsh.currency_code                                                            AS  CURRENCY_CODE
         , 'User'                                                                       AS  CURRENCY_CONVERSION_TYPE
         , rsh.conversion_rate                                                          AS  CURRENCY_CONVERSION_RATE
         , rsh.conversion_date                                                          AS  CURRENCY_CONVERSION_DATE
         , rt.inspection_status_code                                                    AS  INSPECTION_STATUS_CODE
         , rt.inspection_quality_code                                                   AS  INSPECTION_QUALITY_CODE
         , null                                                                         AS  FROM_ORGANIZATION_CODE
         , null                                                                         AS  FROM_SUBINVENTORY
         , null                                                                         AS  FROM_LOCATOR
         , rsh.freight_carrier_code                                                     AS  FREIGHT_CARRIER_NAME
         , rsh.bill_of_lading                                                           AS  BILL_OF_LADING
         , rsl.packing_slip                                                             AS  PACKING_SLIP
         , rsh.shipped_date                                                             AS  SHIPPED_DATE
         , rsh.num_of_containers                                                        AS  NUM_OF_CONTAINERS
         , rsh.waybill_airbill_num                                                      AS  WAYBILL_AIRBILL_NUM
         , rt.rma_reference                                                             AS  RMA_REFERENCE
         , replace(replace(replace(replace(rsl.comments , chr(13)), chr(10),',') ,'"',''),'   ','')
                                                                                        AS  COMMENTS
         , rsl.truck_num                                                                AS  TRUCK_NUM
         , rsl.container_num                                                            AS  CONTAINER_NUM
         , null                                                                         AS  SUBSTITUTE_ITEM_NUM
         , rsl.notice_unit_price                                                        AS  NOTICE_UNIT_PRICE
         , null                                                                         AS  ITEM_CATEGORY
         , null                                                                         AS  INTRANSIT_OWNING_ORG_CODE
         , null                                                                         AS  ROUTING_CODE
         , null                                                                         AS  BARCODE_LABEL
         , rsl.country_of_origin_code                                                   AS  COUNTRY_OF_ORIGIN_CODE
         , null                                                                         AS  CREATE_DEBIT_MEMO_FLAG
         , null                                                                         AS  LICENSE_PLATE_NUMBER
         , null                                                                         AS  TRANSFER_LICENSE_PLATE_NUMBER
         , null                                                                         AS  LPN_GROUP_NUM
         , null                                                                         AS  ASN_LINE_NUM
         , null                                                                         AS  EMPLOYEE_NAME
         , rt.source_transaction_num                                                    AS  SOURCE_TRANSACTION_NUM
         , null                                                                         AS  PARENT_SOURCE_TRANSACTION_NUM
         , null                                                                         AS  PARENT_INTERFACE_TXN_ID
         , null                                                                         AS  MATCHING_BASIS
         , null                                                                         AS  RA_OUTSOURCER_PARTY_NAME
         , null                                                                         AS  RA_DOCUMENT_NUMBER
         , null                                                                         AS  RA_DOCUMENT_LINE_NUMBER
         , null                                                                         AS  RA_NOTE_TO_RECEIVER
         , null                                                                         AS  RA_VENDOR_SITE_NAME 
         , NULL                                                                         AS  ATTRIBUTE_CATEGORY
         , NULL                                                                         AS  ATTRIBUTE1
         , NULL                                                                         AS  ATTRIBUTE2
         , NULL                                                                         AS  ATTRIBUTE3
         , NULL                                                                         AS  ATTRIBUTE4
         , NULL                                                                         AS  ATTRIBUTE5
         , NULL                                                                         AS  ATTRIBUTE6
         , NULL                                                                         AS  ATTRIBUTE7
         , NULL                                                                         AS  ATTRIBUTE8
         , NULL                                                                         AS  ATTRIBUTE9
         , NULL                                                                         AS  ATTRIBUTE10
         , NULL                                                                         AS  ATTRIBUTE11
         , NULL                                                                         AS  ATTRIBUTE12
         , NULL                                                                         AS  ATTRIBUTE13
         , NULL                                                                         AS  ATTRIBUTE14
         , NULL                                                                         AS  ATTRIBUTE15
         , NULL                                                                         AS  ATTRIBUTE16
         , NULL                                                                         AS  ATTRIBUTE17
         , NULL                                                                         AS  ATTRIBUTE18
         , NULL                                                                         AS  ATTRIBUTE19
         , NULL                                                                         AS  ATTRIBUTE20
         , NULL                                                                         AS  ATTRIBUTE_NUMBER1
         , NULL                                                                         AS  ATTRIBUTE_NUMBER2
         , NULL                                                                         AS  ATTRIBUTE_NUMBER3
         , NULL                                                                         AS  ATTRIBUTE_NUMBER4
         , NULL                                                                         AS  ATTRIBUTE_NUMBER5
         , NULL                                                                         AS  ATTRIBUTE_NUMBER6
         , NULL                                                                         AS  ATTRIBUTE_NUMBER7
         , NULL                                                                         AS  ATTRIBUTE_NUMBER8
         , NULL                                                                         AS  ATTRIBUTE_NUMBER9
         , NULL                                                                         AS  ATTRIBUTE_NUMBER10
         , NULL                                                                         AS  ATTRIBUTE_DATE1
         , NULL                                                                         AS  ATTRIBUTE_DATE2
         , NULL                                                                         AS  ATTRIBUTE_DATE3
         , NULL                                                                         AS  ATTRIBUTE_DATE4
         , NULL                                                                         AS  ATTRIBUTE_DATE5
         , NULL                                                                         AS  ATTRIBUTE_TIMESTAMP1
         , NULL                                                                         AS  ATTRIBUTE_TIMESTAMP2
         , NULL                                                                         AS  ATTRIBUTE_TIMESTAMP3
         , NULL                                                                         AS  ATTRIBUTE_TIMESTAMP4
         , NULL                                                                         AS  ATTRIBUTE_TIMESTAMP5
         , rt.consigned_flag                                                            AS  CONSIGNED_FLAG
         , NULL                                                                         AS  SOLDTO_LEGAL_ENTITY
         , NULL                                                                         AS  CONSUMED_QUANTITY
         , NULL                                                                         AS  DEFAULT_TAXATION_COUNTRY
         , NULL                                                                         AS  TRX_BUSINESS_CATEGORY
         , NULL                                                                         AS  DOCUMENT_FISCAL_CLASSIFICATION
         , NULL                                                                         AS  USER_DEFINED_FISC_CLASS
         , NULL                                                                         AS  PRODUCT_FISC_CLASS_NAME
         , NULL                                                                         AS  INTENDED_USE
         , NULL                                                                         AS  PRODUCT_CATEGORY
         , NULL                                                                         AS  TAX_CLASSIFICATION_CODE
         , NULL                                                                         AS  PRODUCT_TYPE
         , NULL                                                                         AS  FIRST_PTY_NUMBER
         , NULL                                                                         AS  THIRD_PTY_NUMBER
         , NULL                                                                         AS  TAX_INVOICE_NUMBER
         , NULL                                                                         AS  TAX_INVOICE_DATE
         , NULL                                                                         AS  FINAL_DISCHARGE_LOC_CODE
         , NULL                                                                         AS  ASSESSABLE_VALUE
         , NULL                                                                         AS  PHYSICAL_RETURN_REQD
         , NULL                                                                         AS  EXTERNAL_SYSTEM_PACKING_UNIT
         , NULL                                                                         AS  EWAY_BILL_NUMBER
         , NULL                                                                         AS  EWAY_BILL_DATE	   
         , NULL                                                                         AS  RECALL_NOTICE_NUMBER 
         , NULL                                                                         AS  RECALL_NOTICE_LINE_NUMBER 
         , NULL                                                                         AS  EXTERNAL_SYS_TXN_REFERENCE
         , NULL                                                                         AS  DEFAULT_LOTSER_FROM_ASN 
         , NULL                                                                         AS  EMPLOYEE_ID 

		 from apps.rcv_shipment_headers@MXDM_NVIS_EXTRACT rsh
          ,apps.rcv_shipment_lines@MXDM_NVIS_EXTRACT rsl
          ,apps.po_headers_all@MXDM_NVIS_EXTRACT pha
          ,apps.po_lines_all@MXDM_NVIS_EXTRACT pla
          ,apps.po_line_locations_all@MXDM_NVIS_EXTRACT pll
          ,apps.po_vendors@MXDM_NVIS_EXTRACT pv
          ,apps.po_vendor_sites_all@MXDM_NVIS_EXTRACT pvs
          ,apps.rcv_transactions@MXDM_NVIS_EXTRACT rt
     WHERE rsl.shipment_header_id               = rsh.shipment_header_id
     AND   rsl.shipment_header_id               = rt.shipment_header_id
     AND   rsl.shipment_line_id                 = rt.shipment_line_id
     AND   rt.transaction_type                  = 'RECEIVE'
     AND   rsh.vendor_id                        = pv.vendor_id
     AND   rsh.vendor_site_id                   = pvs.vendor_site_id
     AND   pv.vendor_id                         = pvs.vendor_id
     AND   rsl.po_header_id                     = pha.po_header_id
     AND   rsl.po_line_id                       = pla.po_line_id
     AND   rsl.po_line_location_id              = pll.line_location_id
     AND   EXISTS  (SELECT 1
                      FROM xxmx_po_open_quantity_mv po_v
                     WHERE    1 = 1
                          AND po_v.po_header_id = rsl.po_header_id
                          AND po_v.po_line_id = rsl.po_line_id
                          AND po_v.line_location_id = rsl.po_line_location_id
                          AND po_v.po_distribution_id = NVL(rsl.po_distribution_id , po_v.po_distribution_id)
                          AND po_v.open_po > 0
                          AND po_v.received > 0
                          AND po_v.billed >= 0
                          AND (po_v.received - po_v.billed) > 0
						  AND (NVL(rt.amount_billed, 0) != NVL(rt.amount, 0) OR NVL(rt.quantity_billed, 0) != NVL(rt.quantity, 0)));
	COMMIT;
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

END po_rcpt_txn_stg;                
END xxmx_po_receipt_pkg;
/
Show errors package body xxmx_po_receipt_pkg;
/