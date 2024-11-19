create or replace PACKAGE XXMX_AP_SUPP_TAX_PKG
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
     ** FILENAME  :  XXMX_AP_SUPP_TAX_PKG.sql
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
     ** PURPOSE   :  This script installs the package for the Maximise Supplier Tax
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
     **            $XXMX_TOP/install/sql/XXMX_AP_SUPP_TAX_STG_DBI.sql
     **            $XXMX_TOP/install/sql/XXMX_AP_SUPP_TAX_XFM_DBI.sql
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
     **   1.0  05-SEP-2023  Sinchana Ramesh     Created for Maximise.
     **
     **   1.1  05-SEP-2023  Sinchana Ramesh     Extract logic updates.
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
     ** PROCEDURE: AP_SUPP_TAX_STG
     ********************************
     */
     --
     PROCEDURE   ap_supp_tax_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
     --
     --
     /*
     ********************************
     ** PROCEDURE: AP_SUPP_REG_STG
     ********************************
     */
     --
     PROCEDURE   ap_supp_reg_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    );
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
END XXMX_AP_SUPP_TAX_PKG;
/
Show errors package XXMX_AP_SUPP_TAX_PKG;
/

create or replace PACKAGE BODY XXMX_AP_SUPP_TAX_PKG
AS
     --
     --**********************
     --** Global Declarations
     --**********************
     --
     /*
     ** Maximise Integration Globals
     */
     --
     /*
     ** Global Constants for use in all xxmx_utilities_pkg Procedure/Function Calls within this package
     */
     --
    gct_PackageName                           CONSTANT xxmx_module_messages.package_name%TYPE       := 'XXMX_AP_SUPP_TAX_PKG';
    gvv_ReturnStatus                          VARCHAR2(1); 
    gvt_ReturnMessage                         xxmx_module_messages.module_message%TYPE;
    gvv_ProgressIndicator                     VARCHAR2(100); 
    gcv_PackageName                           CONSTANT  VARCHAR2(30)                                := 'XXMX_AP_SUPP_TAX_PKG';
    gct_ApplicationSuite                      CONSTANT  xxmx_module_messages.application_suite%TYPE := 'FIN';
    gct_Application                           CONSTANT  xxmx_module_messages.application%TYPE       := 'AP';
    gct_BusinessEntity                        CONSTANT xxmx_migration_metadata.business_entity%TYPE := 'SUPPLIER_TAX';
    gv_i_BusinessEntity                       CONSTANT  VARCHAR2(100)                               := 'SUPPLIER_TAX';
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
    
    /*
     ** Global Variables for Exception Handlers
     */
     -- 
     gvv_ApplicationErrorMessage                        VARCHAR2(2048);

     /*
     ******************************
     ** PROCEDURE: <Procedure Name>
     ** keep parameters as is
     ******************************
     */
    -- 
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
        cv_StagingTable                     CONSTANT    VARCHAR2(100) DEFAULT 'XXMX_AP_SUPP_TAX_STG';
        cv_i_BusinessEntityLevel            CONSTANT    VARCHAR2(100) DEFAULT 'SUPPLIER_TAX';
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
                    ,pt_i_ModuleMessage       => 'From to or Prev Tax Year variable not populated'  
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

--------------------
     PROCEDURE ap_supp_tax_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    )
     IS
     --
     --
     --**********************
     --** CURSOR Declarations
     --**********************
     --
     --<<Cursor to get the detail of SubEntity??>>
     --
     CURSOR get_supp_party_sites_cur
     IS
     SELECT DISTINCT
     hp.party_id,
     s.segment1                        --*Party Number
     ,
     s.vendor_name                  --Party Name
     ,
     NULL party_site_id,
     NULL operating_unit,
     NULL vendor_site_code,
     party_type_code,
     tax.country_code,
     tax.rep_registration_number
     FROM
     apps.zx_party_tax_profile@mxdm_nvis_extract       tax
     --   ,apps.zx_registrations@mxdm_nvis_extract     zr
     ,
     apps.hz_parties@mxdm_nvis_extract           hp,
     apps.ap_suppliers@mxdm_nvis_extract         s,
     xxmx_supplier_scope_v                  xss
     WHERE
     1 = 1
     AND tax.party_id = hp.party_id
     AND tax.party_type_code = 'THIRD_PARTY'
--   AND ( tax.country_code IS NOT NULL
--   and tax.rep_registration_number IS NOT NULL )
     AND hp.party_id = s.party_id
     AND s.vendor_id = xss.vendor_id

     UNION
     SELECT
     d.party_id,
     c.segment1,
     c.vendor_name                              --Party Name    
     ,
     a.party_site_id,
     (
        SELECT
            name
        FROM
            apps.hr_all_organization_units@mxdm_nvis_extract
        WHERE
            organization_id = a.org_id
     ) operating_unit,
     a.vendor_site_code      --*Party Number
     --         ,s.vendor_type_lookup_code       
     ,
     party_type_code,
     e.country_code,
     e.rep_registration_number
	 
     FROM
     apps.ap_supplier_sites_all@mxdm_nvis_extract a,
     xxmx_supplier_scope_v                   b,
     apps.ap_suppliers@mxdm_nvis_extract          c,
     apps.hz_parties@mxdm_nvis_extract            d,
     apps.zx_party_tax_profile@mxdm_nvis_extract  e
	 
     WHERE
     a.vendor_site_id = b.vendor_site_id
     AND a.vendor_id = b.vendor_id
     AND a.vendor_id = c.vendor_id
     AND c.party_id = d.party_id
     AND e.party_id = a.party_site_id
     AND e.party_type_code = 'THIRD_PARTY_SITE'
--   AND ( e.rep_registration_number IS NOT NULL
--        and e.country_code IS NOT NULL )

     GROUP BY
     d.party_id,
     c.segment1,
     c.vendor_name                              --Party Name    
     ,
     a.party_site_id,
     a.org_id,
     a.vendor_site_code      --*Party Number
     --         ,s.vendor_type_lookup_code       
     ,
     party_type_code,
     e.country_code,
     e.rep_registration_number;
          ----
          ----
          ----
          ----
     --** END CURSOR **
     --
     --
     --********************
     --** Type Declarations
     --********************
     --
     TYPE get_supp_party_sites_tt IS TABLE OF get_supp_party_sites_cur%ROWTYPE INDEX BY BINARY_INTEGER;
     --
     --
     --************************
     --** Constant Declarations
     --************************
     --
     ct_ProcOrFuncName               CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'ap_supp_tax_stg';  --<< Procedure Name>>
     ct_StgSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_stg';
     ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'xxmx_ap_supp_tax_stg';  --<< Staging Table Name>>
     ct_Phase                        CONSTANT xxmx_module_messages.phase%TYPE             := 'EXTRACT';
     --
     --
     --************************
     --** Variable Declarations
     --************************
     --
     --
     --
     --****************************
     --** Record Table Declarations
     --****************************
     --
     --
     --
     --****************************
     --** PL/SQL Table Declarations
     --****************************
     --
    get_supp_party_sites_tbl  get_supp_party_sites_tt;
     --
     --
     --*************************
     --** Exception Declarations
     --*************************
     --
     --** Set gvt_Severity, gvv_ProgressIndicator and gvt_ModuleMessage
     --** before raising this exception.
     --
     e_ModuleError                   EXCEPTION;
     --
     --** END Declarations
     --
     BEGIN
          --
          gvv_ProgressIndicator := '0010';
          --
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gct_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'MODULE'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F'
          THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => gvt_ReturnMessage
                    );
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gct_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'DATA'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F'
          THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => gvt_ReturnMessage
                    );
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          gvv_ProgressIndicator := '0030';
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
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          --** Retrieve the Migration Set Name
          --
          gvv_ProgressIndicator := '0040';
          --
          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
          --
          --** If the Migration Set Name is NULL then the Migration has not been initialized.
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
                                             ||'":'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --** The Migration Set has been initialized so now initialize the detail record
               --** for the current entity.
               --
               xxmx_utilities_pkg.init_migration_details
                    (
                     pt_i_ApplicationSuite => gct_ApplicationSuite
                    ,pt_i_Application      => gct_Application
                    ,pt_i_BusinessEntity   => gct_BusinessEntity
                    ,pt_i_SubEntity        => pt_i_SubEntity
                    ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                    ,pt_i_StagingTable     => ct_StgTable
                    ,pt_i_ExtractStartDate => SYSDATE
                    );
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
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_StgTable
                                             ||'" initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0050';
               --
               --** Extract the Sub-entity data and insert into the staging table.
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
                    ,pt_i_ModuleMessage     => '  - Extracting data into "'
                                             ||ct_StgTable
                                             ||'" table.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               OPEN get_supp_party_sites_cur;
               --
               gvv_ProgressIndicator := '0060';
               --
               LOOP
                    --
                    FETCH get_supp_party_sites_cur
                    BULK COLLECT
                    INTO get_supp_party_sites_tbl
                    LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;
                    --
                    EXIT WHEN get_supp_party_sites_tbl.COUNT=0;
                    --
                    gvv_ProgressIndicator := '0070';
                    --
                    FORALL I
                    IN     1..get_supp_party_sites_tbl.COUNT
                         --
                         INSERT
                             INTO    xxmx_stg.XXMX_AP_SUPP_TAX_STG
                                   (
                         SEGMENT1,                         
                         BUSINESS_UNIT,                        
                         VENDOR_SITE_CODE,                     
                         --FILE_SET_ID,             
                         MIGRATION_SET_ID,                     
                         MIGRATION_SET_NAME,                   
                         MIGRATION_STATUS,                   
                         PARTY_TYPE_CODE,                
                         PARTY_NUMBER,             
                         PARTY_NAME,        
                         PROCESS_FOR_APPLICABILITY_FLAG,         
                         ROUNDING_LEVEL_CODE,                
                         ROUNDING_RULE_CODE,               
                         TAX_CLASSIFICATION_CODE,              
                         INCLUSIVE_TAX_FLAG,       
                         ALLOW_OFFSET_TAX_FLAG,             
                         COUNTRY_CODE,  
                         REGISTRATION_TYPE_CODE,          
                         REP_REGISTRATION_NUMBER,
                         LOAD_BATCH

                                   )
                         VALUES
                                   (
                                   get_supp_party_sites_tbl(i).SEGMENT1,
                                   get_supp_party_sites_tbl(i).operating_unit,
                                   get_supp_party_sites_tbl(i).vendor_site_code,
                                   --59,--get_supp_party_sites_tbl(i).,
                                   pt_i_MigrationSetID,--get_supp_party_sites_tbl(i).,
                                   gvt_MigrationSetName,--get_supp_party_sites_tbl(i).,
                                   'EXTRACTED',--get_supp_party_sites_tbl(i).,
                                   get_supp_party_sites_tbl(i).party_type_code,
                                   null,--get_supp_party_sites_tbl(i).,
                                   get_supp_party_sites_tbl(i).vendor_name,
                                   null,--get_supp_party_sites_tbl(i).,
                                   null,--get_supp_party_sites_tbl(i).,
                                   null,--get_supp_party_sites_tbl(i).,
                                   null,--get_supp_party_sites_tbl(i).,
                                   null,--get_supp_party_sites_tbl(i).,
                                   null,--get_supp_party_sites_tbl(i).,
                                   get_supp_party_sites_tbl(i).country_code,
                                   null,--get_supp_party_sites_tbl(i).,
                                   get_supp_party_sites_tbl(i).rep_registration_number,
                                   NULL
                                   );
                         --
                    --** END FORALL
                    --
               END LOOP;
               --
               gvv_ProgressIndicator := '0080';
               --
               --** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
               --** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
               --** is reached.
               --
               gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                    (
                                     ct_StgSchema
                                    ,ct_StgTable
                                    ,pt_i_MigrationSetID
                                    );
               --
               COMMIT;
               --
               gvv_ProgressIndicator := '0090';
               --
               CLOSE get_supp_party_sites_cur;
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
                    ,pt_i_ModuleMessage     => '  - Extraction complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '0100';
               --
               xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gct_BusinessEntity
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
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_StgTable
                                             ||'" updated.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               gvv_ProgressIndicator :='0120';
               --
               --
          ELSE
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set not initialized.';
               --
               RAISE e_ModuleError;
               --
          END IF;
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
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||'" completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    xxmx_utilities_pkg.log_module_message
                        (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                        );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR('"e_ModuleError" Exception raised after Progress Indicator "'
                                                       ||gct_PackageName
                                                       ||'.'
                                                       ||ct_ProcOrFuncName
                                                       ||'-'
                                                       ||gvv_ProgressIndicator
                                                       ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                        ,1
                                                        ,2048
                                                         );
                    --
                    --RAISE_APPLICATION_ERROR(xxmx_utilities_pkg.gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END e_ModuleError Exception
               --
               WHEN OTHERS
               THEN
                    --
                    IF   get_supp_party_sites_cur%ISOPEN
                    THEN
                         --
                         CLOSE get_supp_party_sites_cur;
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
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => pt_i_SubEntity
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                         ,pt_i_OracleError         => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR('Unexpected Oracle Exception encountered after Progress Indicator "'
                                                       ||gct_PackageName
                                                       ||'.'
                                                       ||ct_ProcOrFuncName
                                                       ||'-'
                                                       ||gvv_ProgressIndicator
                                                       ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                        ,1
                                                        ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(xxmx_utilities_pkg.gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END ap_supp_tax_stg;
     --
     --
     --
------------------------------------------------------
     PROCEDURE ap_supp_reg_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    )
     IS
     --
     --**********************
     --** CURSOR Declarations
     --**********************
     --
     --<<Cursor to get the detail of SubEntity??>>
     --
     CURSOR get_supp_party_sites_cur IS
	 SELECT
     hp.party_id,
     s.segment1                        --*Party Number
     ,
     s.vendor_name                  --Party Name
     ,
     NULL party_site_id,
     NULL operating_unit,
     NULL vendor_site_code,
     h.party_type_code,
     l.registration_number,
     to_char(
         l.effective_from, 'YYYY/MM/DD'
     )    effective_from_date
     FROM
      jai_party_regs@mxdm_nvis_extract      h,
      jai_party_reg_lines@mxdm_nvis_extract l,
      ja_lookups@mxdm_nvis_extract          sec_code,
      apps.hz_parties@mxdm_nvis_extract     hp,
      apps.ap_suppliers@mxdm_nvis_extract   s,
      (
          SELECT
              vendor_id
          FROM
              xxmx_supplier_scope_v 
          GROUP BY
              vendor_id
      )                               xss
      WHERE
            1 = 1
            AND h.party_type_code = 'THIRD_PARTY'
            AND h.party_reg_id = l.party_reg_id
            AND h.supplier_flag = 'Y'
            AND h.site_flag='N'
            AND s.vendor_id = h.party_id
            AND nvl(
                l.effective_to, sysdate + 1
            ) > trunc(sysdate) -- 221
            AND l.default_section_code = sec_code.lookup_code (+)
            AND sec_code.lookup_type (+) = 'JAI_TDS_SECTION'
            AND hp.party_id = s.party_id
            AND s.vendor_id = xss.vendor_id
            AND registration_type_code = 'PAN'
            group by hp.party_id,
            s.segment1                        --*Party Number
            ,
            s.vendor_name                  --Party Name
            ,
            h.party_type_code,
            l.registration_number,
            l.effective_from
            --and  DEFAULT_SECTION_CODE is not null

        UNION
        SELECT
            hp.party_id,
            s.segment1                        --*Party Number
            ,
            s.vendor_name                  --Party Name
            ,
            ss.party_site_id,
            (
                SELECT
                    name
                FROM
                    apps.hr_all_organization_units@mxdm_nvis_extract
                WHERE
                    organization_id = ss.org_id
            ) operating_unit,
            ss.vendor_site_code,
            h.party_type_code,
            l.registration_number,
            to_char(
                l.effective_from, 'YYYY/MM/DD'
            ) effective_from_date
        FROM
            jai_party_regs@mxdm_nvis_extract             h,
            jai_party_reg_lines@mxdm_nvis_extract        l,
            ja_lookups@mxdm_nvis_extract                 sec_code,
            apps.hz_parties@mxdm_nvis_extract            hp,
            apps.ap_suppliers@mxdm_nvis_extract          s,
            apps.ap_supplier_sites_all@mxdm_nvis_extract ss,
            (
                SELECT
                    vendor_id,
                    org_id,
                    vendor_site_id
                FROM
                    xxmx_supplier_scope_v 
                GROUP BY
                    vendor_id,
                    org_id,
                    vendor_site_id
            )                                       xss
        WHERE
            1 = 1
            AND h.party_type_code = 'THIRD_PARTY_SITE'
            AND h.party_reg_id = l.party_reg_id
            AND h.supplier_flag = 'Y'
            AND ss.vendor_site_id = h.party_site_id
            AND ss.vendor_id = s.vendor_id
            AND s.vendor_id = h.party_id
            AND nvl(
                l.effective_to, sysdate + 1
            ) > trunc(sysdate) -- 221
            AND l.default_section_code = sec_code.lookup_code (+)
            --AND sec_code.lookup_type (+) = 'JAI_TDS_SECTION'
            AND hp.party_id = s.party_id
            AND s.vendor_id = xss.vendor_id
            AND registration_type_code = 'PAN'
            AND ss.vendor_site_id = xss.vendor_site_id
			--and  DEFAULT_SECTION_CODE is not null
            ;
               ----
               ----
               ----
               ----
          --** END CURSOR **
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
          TYPE get_supp_party_sites_tt IS TABLE OF get_supp_party_sites_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName               CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'ap_supp_reg_stg';  --<< Procedure Name>>
          ct_StgSchema                    CONSTANT VARCHAR2(10)                                := 'xxmx_stg';
          ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE      := 'xxmx_ap_supp_reg_stg';  --<< Staging Table Name>>
          ct_Phase                        CONSTANT xxmx_module_messages.phase%TYPE             := 'EXTRACT';
          --
          --
          --************************
          --** Variable Declarations
          --************************
          --
          --
          --
          --****************************
          --** Record Table Declarations
          --****************************
          --
          --
          --
          --****************************
          --** PL/SQL Table Declarations
          --****************************
          --
         get_supp_party_sites_tbl  get_supp_party_sites_tt;
          --
          --
          --*************************
          --** Exception Declarations
          --*************************
          --
          --** Set gvt_Severity, gvv_ProgressIndicator and gvt_ModuleMessage
          --** before raising this exception.
          --
          e_ModuleError                   EXCEPTION;
          --
     --** END Declarations
     --
     BEGIN
          --
          gvv_ProgressIndicator := '0010';
          --
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gct_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'MODULE'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F'
          THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => gvt_ReturnMessage
                    );
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gct_BusinessEntity
               ,pt_i_SubEntity        => pt_i_SubEntity
               ,pt_i_Phase            => ct_Phase
               ,pt_i_MessageType      => 'DATA'
               ,pv_o_ReturnStatus     => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F'
          THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError       => gvt_ReturnMessage
                    );
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          gvv_ProgressIndicator := '0030';
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
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          --** Retrieve the Migration Set Name
          --
          gvv_ProgressIndicator := '0040';
          --
          gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
          --
          --** If the Migration Set Name is NULL then the Migration has not been initialized.
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
                                             ||'":'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --** The Migration Set has been initialized so now initialize the detail record
               --** for the current entity.
               --
               xxmx_utilities_pkg.init_migration_details
                    (
                     pt_i_ApplicationSuite => gct_ApplicationSuite
                    ,pt_i_Application      => gct_Application
                    ,pt_i_BusinessEntity   => gct_BusinessEntity
                    ,pt_i_SubEntity        => pt_i_SubEntity
                    ,pt_i_MigrationSetID   => pt_i_MigrationSetID
                    ,pt_i_StagingTable     => ct_StgTable
                    ,pt_i_ExtractStartDate => SYSDATE
                    );
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
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_StgTable
                                             ||'" initialised.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0050';
               --
               --** Extract the Sub-entity data and insert into the staging table.
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
                    ,pt_i_ModuleMessage     => '  - Extracting data into "'
                                             ||ct_StgTable
                                             ||'" table.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               OPEN get_supp_party_sites_cur;
               --
               gvv_ProgressIndicator := '0060';
               --
               LOOP
                    --
                    FETCH get_supp_party_sites_cur
                    BULK COLLECT
                    INTO get_supp_party_sites_tbl
                    LIMIT xxmx_utilities_pkg.gcn_BulkCollectLimit;
                    --
                    EXIT WHEN get_supp_party_sites_tbl.COUNT=0;
                    --
                    gvv_ProgressIndicator := '0070';
                    --
                    FORALL I
                    IN     1..get_supp_party_sites_tbl.COUNT
                         --
                         INSERT
                             INTO    xxmx_stg.XXMX_AP_SUPP_REG_STG
                                   (
                        segment1,
                        business_unit,
                        vendor_site_code,
                        --file_set_id,
                        migration_set_id,
                        migration_set_name,
                        migration_status,
                        party_type_code,
                        party_name,
                        registration_number,
                        effective_from
                    ) VALUES (
                        get_supp_party_sites_tbl(i).segment1,
                        get_supp_party_sites_tbl(i).operating_unit,
                        get_supp_party_sites_tbl(i).vendor_site_code,
                        --60,--get_supp_party_sites_tbl(i).,
                        pt_i_migrationsetid,--get_supp_party_sites_tbl(i).,
                        gvt_migrationsetname,--get_supp_party_sites_tbl(i).,
                        'EXTRACTED',--get_supp_party_sites_tbl(i).,
                        get_supp_party_sites_tbl(i).party_type_code,
                        get_supp_party_sites_tbl(i).vendor_name,
                        get_supp_party_sites_tbl(i).registration_number,
                        get_supp_party_sites_tbl(i).effective_from_date
                       
                    );
                         --
                    --** END FORALL
                    --
            END LOOP;
               --
               gvv_ProgressIndicator := '0080';
               --
               --** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
               --** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
               --** is reached.
               --
               gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                    (
                                     ct_StgSchema
                                    ,ct_StgTable
                                    ,pt_i_MigrationSetID
                                    );
               --
               COMMIT;
               --
               gvv_ProgressIndicator := '0090';
               --
               CLOSE get_supp_party_sites_cur;
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
                    ,pt_i_ModuleMessage     => '  - Extraction complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '0100';
               --
               xxmx_utilities_pkg.upd_migration_details
                    (
                     pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_BusinessEntity          => gct_BusinessEntity
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
                    ,pt_i_ModuleMessage     => '  - Migration details for Table "'
                                             ||ct_StgTable
                                             ||'" updated.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               --
               gvv_ProgressIndicator :='0120';
               --
               --
          ELSE
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Migration Set not initialized.';
               --
               RAISE e_ModuleError;
               --
          END IF;
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
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||'" completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    xxmx_utilities_pkg.log_module_message
                        (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                        );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR('"e_ModuleError" Exception raised after Progress Indicator "'
                                                       ||gct_PackageName
                                                       ||'.'
                                                       ||ct_ProcOrFuncName
                                                       ||'-'
                                                       ||gvv_ProgressIndicator
                                                       ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                        ,1
                                                        ,2048
                                                         );
                    --
                    --RAISE_APPLICATION_ERROR(xxmx_utilities_pkg.gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END e_ModuleError Exception
               --
               WHEN OTHERS
               THEN
                    --
                    IF   get_supp_party_sites_cur%ISOPEN
                    THEN
                         --
                         CLOSE get_supp_party_sites_cur;
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
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => pt_i_SubEntity
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => 'Oracle error encounted at after Progress Indicator.'
                         ,pt_i_OracleError         => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR('Unexpected Oracle Exception encountered after Progress Indicator "'
                                                       ||gct_PackageName
                                                       ||'.'
                                                       ||ct_ProcOrFuncName
                                                       ||'-'
                                                       ||gvv_ProgressIndicator
                                                       ||'".  Please refer to XXMX_MODULE_MESSAGES table for further details.'
                                                        ,1
                                                        ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(xxmx_utilities_pkg.gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END ap_supp_reg_stg;
     --
     --
     --
END XXMX_AP_SUPP_TAX_PKG;
/
Show errors package body XXMX_AP_SUPP_TAX_PKG;
/

