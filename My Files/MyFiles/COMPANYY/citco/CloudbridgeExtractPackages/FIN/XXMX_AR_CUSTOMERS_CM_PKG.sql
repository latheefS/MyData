CREATE OR REPLACE PACKAGE             "XXMX_AR_CUSTOMERS_CM_PKG" AUTHID CURRENT_USER 
AS
     --
     /*
     ******************************************************************************
     **
     **                 Copyright (c) 2020 Version 1
     **
     **                           Millennium House,
     **                           Millennium Walkway,
     **                           Dublin 1    
     **                           D01 F5P8
     **
     **                           All rights reserved.
     **
     ******************************************************************************
     **
     **
     ** FILENAME  :  xxmx_custom_pkg.sql
     **
     ** FILEPATH  :  $XXV1_TOP/install/sql
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  David Higham
     **
     ** PURPOSE   :  This script installs the package specification for the Maximise
     **              packge XXMX_AR_CUSTOMERS_PKG custom Procedures and Functions.
     **
     ** NOTES     :
     **
     *******************************************************************************
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
     **            $XXV1_TOP/install/sql/xxv1_mxdm_utilities_1_dbi.sql
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
     **   1.0  15-APR-2021  David Higham        Initial implementation
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
     --
     /*
     *******************************
     ** PROCEDURE: Post Transform CM
     *******************************
     */
     PROCEDURE post_xfm_bank_accounts_cm
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE 
                    );         
     --
     PROCEDURE post_xfm_parties_cm
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE 
                    );     
     --
     PROCEDURE post_xfm_party_sites_cm
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE 
                    );     
     --
     PROCEDURE post_xfm_locations_cm
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE 
                    );     
     --
     PROCEDURE post_xfm_contact_points_cm
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE 
                    );     
     --
     --
     /*
     *******************************
     ** PROCEDURE: exclude_customers
     *******************************
     */
     --
     -- 
     PROCEDURE exclude_customers;
     --
     --
     /*
     ******************************
     ** PROCEDURE: customers_cm_stg
     ******************************
     */
     --
     -- 
     PROCEDURE customers_cm_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE 
                    );
     --
     --
END xxmx_ar_customers_cm_pkg;


/


CREATE OR REPLACE PACKAGE BODY             "XXMX_AR_CUSTOMERS_CM_PKG" 
AS
     --
     /*
     **********************
     ** Global Declarations
     **********************
     */
     --
     /*
     ** Maximise Integration Globals
     */
     --
     /*
     ** Global Constants for use in all xxmx_utilities_pkg Procedure/Function Calls within this package
     */
     --
     gct_PackageName                           CONSTANT xxmx_module_messages.package_name%TYPE       := 'xxmx_ar_customers_cm_pkg';
     gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE  := 'FIN';
     gct_Application                           CONSTANT xxmx_module_messages.application%TYPE        := 'AR';
     gct_StgSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_stg';
     gct_XfmSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_xfm';
     gct_CoreSchema                            CONSTANT VARCHAR2(10)                                 := 'xxmx_core';
     gct_BusinessEntity                        CONSTANT xxmx_migration_metadata.business_entity%TYPE := 'CUSTOMERS';
     gct_OrigSystem                            CONSTANT VARCHAR2(10)                                 := 'ORACLER12';     
     gct_DefaultEmail                          CONSTANT VARCHAR2(50)                                 := 'sundryincometeam@solihull.gov.uk';
     gct_DefaultEmailFmt                       CONSTANT VARCHAR2(20)                                 := 'MAILTEXT';
     gct_MaskingEmail                          CONSTANT VARCHAR2(50)                                 := 'oracletesters@solihull.gov.uk';     
     --
     /*
     ** Global Variables for use in all Procedures/Functions within this package.
     */
     --
     gvv_ProgressIndicator                              VARCHAR2(100);
     --
     /*
     ** Global Variables for receiving Status/Messages from certain Procedure/Function Calls (e.g. xxmx_utilities_pkg.clear_messages
     */
     --
     gvv_ReturnStatus                                   VARCHAR2(1);
     gvt_ReturnMessage                                  xxmx_module_messages.module_message%TYPE;
     --
     /*
     ** Global Variables for Exception Handlers
     */
     --
     gvv_ApplicationErrorMessage                        VARCHAR2(2048);
     gvt_Severity                                       xxmx_module_messages.severity%TYPE;
     gvt_ModuleMessage                                  xxmx_module_messages.module_message%TYPE;
     gvt_OracleError                                    xxmx_module_messages.oracle_error%TYPE;
     --
     /*
     ** Global Variables for Migration Set Name
     */
     --
     gvt_MigrationSetName                               xxmx_migration_headers.migration_set_name%TYPE;
     --
     /*
     ** Global constants and variables for dynamic SQL usage
     */
     --
     gcv_SQLSpace                             CONSTANT  VARCHAR2(1) := ' ';
     gvv_SQLAction                                      VARCHAR2(20);
     gvv_SQLTableClause                                 VARCHAR2(100);
     gvv_SQLColumnList                                  VARCHAR2(4000);
     gvv_SQLValuesList                                  VARCHAR2(4000);
     gvv_SQLWhereClause                                 VARCHAR2(4000);
     gvv_SQLStatement                                   VARCHAR2(32000);
     gvv_SQLResult                                      VARCHAR2(4000);
     --
     /*
     ** Global variables for holding table row counts
     */
     --
     gvn_RowCount                                       NUMBER;
     --
     /*
     ** Global variables for transform procedures
     */
     --
     gvb_SimpleTransformsRequired              BOOLEAN;
     gvt_TransformCategoryCode                 xxmx_simple_transforms.category_code%TYPE;
     gvb_MissingSimpleTransforms               BOOLEAN;
     gvb_DataEnrichmentRequired                BOOLEAN;
     gvt_ParameterCode                         xxmx_migration_parameters.parameter_code%TYPE;
     gvv_ParameterCheckResult                  VARCHAR2(10);
     gvb_MissingDataEnrichment                 BOOLEAN;
     gvb_ComplexTransformsRequired             BOOLEAN;
     gvb_PerformComplexTransforms              BOOLEAN;
     --
     --
     PROCEDURE post_xfm_bank_accounts_cm
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE 
                    )
     IS
          --
          --
          --**********************
          --** CURSOR Declarations
          --**********************
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'post_xfm_bank_accounts_cm';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE      := 'various';
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
          --
     --** END Declarations
     --
     --
     BEGIN
          --
          gvv_ProgressIndicator := '-CM0010';
          --
          --
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => 'CUSTOMERS'
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_Severity            => 'NOTIFICATION'               
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                           ||gct_PackageName
                                           ||'.'
                                           ||ct_ProcOrFuncName
                                           ||'" initiated.'
               ,pt_i_OracleError         => NULL
               );
          --
          --
          --** Update Customer Tables
          --
          gvv_ProgressIndicator := '-CM0020';

          UPDATE xxmx_xfm.xxmx_ar_cust_banks_xfm
          SET    bank_account_currency_code = 'GBP'
		  WHERE  migration_set_id = pt_i_MigrationSetID
		  AND    bank_account_currency_code is null;

          COMMIT;
          --
          gvv_ProgressIndicator := '-CM0030';
          --
          --** Update the migration details (Migration status will be automatically determined
          --** in the called procedure dependant on the Phase and if an Error Message has been
          --** passed).
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => 'CUSTOMERS'
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_Severity            => 'NOTIFICATION'               
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                           ||gct_PackageName
                                           ||'.'
                                           ||ct_ProcOrFuncName
                                           ||'" completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          EXCEPTION
               --
               --
               WHEN OTHERS
               THEN
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
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => 'CUSTOMERS'
                         ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_Severity            => 'ERROR'       
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
     END post_xfm_bank_accounts_cm;	 
     --
     --
     PROCEDURE post_xfm_parties_cm
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE 
                    ) 
     IS
          --
          --
          --**********************
          --** CURSOR Declarations
          --**********************
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'post_xfm_parties_cm';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE      := 'various';
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
          --
     --** END Declarations
     --
     --
     BEGIN
          --
          gvv_ProgressIndicator := '-CM0010';
          --
          --
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => 'CUSTOMERS'
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_Severity            => 'NOTIFICATION'               
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                           ||gct_PackageName
                                           ||'.'
                                           ||ct_ProcOrFuncName
                                           ||'" initiated.'
               ,pt_i_OracleError         => NULL
               );
          --
          --
          --** Update Customer Tables
          --
          gvv_ProgressIndicator := '-CM0020';

          UPDATE xxmx_hz_parties_xfm
          SET attribute_category=null
          WHERE migration_SET_id = pt_i_MigrationSetID
          AND attribute_category is not null;

          UPDATE xxmx_hz_parties_xfm
          SET organization_name=replace(organization_name,',')
          ,person_first_name=replace(person_first_name,',')
          ,person_last_name=replace(person_last_name,',')
          WHERE migration_SET_id = pt_i_MigrationSetID;

          COMMIT;
          --
          gvv_ProgressIndicator := '-CM0030';
          --
          --** Update the migration details (Migration status will be automatically determined
          --** in the called procedure dependant on the Phase and if an Error Message has been
          --** passed).
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => 'CUSTOMERS'
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_Severity            => 'NOTIFICATION'               
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                           ||gct_PackageName
                                           ||'.'
                                           ||ct_ProcOrFuncName
                                           ||'" completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          EXCEPTION
               --
               --
               WHEN OTHERS
               THEN
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
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => 'CUSTOMERS'
                         ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_Severity            => 'ERROR'       
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
     END post_xfm_parties_cm;
     --
     --
     --
     PROCEDURE post_xfm_party_sites_cm
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE 
                    ) 
     IS
          --
          --
          --**********************
          --** CURSOR Declarations
          --**********************
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'post_xfm_party_sites_cm';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE      := 'various';
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
          --
     --** END Declarations
     --
     --
     BEGIN
          --
          gvv_ProgressIndicator := '-CM0010';
          --
          --
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => 'CUSTOMERS'
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_Severity            => 'NOTIFICATION'               
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                           ||gct_PackageName
                                           ||'.'
                                           ||ct_ProcOrFuncName
                                           ||'" initiated.'
               ,pt_i_OracleError         => NULL
               );
          --
          --
          --** Update Customer Tables
          --
          gvv_ProgressIndicator := '-CM0020';

          UPDATE xxmx_hz_party_sites_xfm
          SET identifying_address_flag='Y'
          WHERE migration_SET_id=pt_i_MigrationSetID
          AND party_orig_system_reference||site_orig_system_reference
          IN 
          (select cc.party_orig_system_reference||cc.site_orig_system_reference
          FROM
          (select unique aa.party_orig_system_reference
          ,aa.site_orig_system_reference
          ,row_number() over(partition by aa.party_orig_system_reference
          order by aa.party_orig_system_reference,aa.start_date_active) seq
          from xxmx_hz_party_sites_xfm aa
          WHERE aa.migration_SET_id=pt_i_MigrationSetID
          AND aa.party_orig_system_reference NOT IN (select unique bb.party_orig_system_reference
          from xxmx_hz_party_sites_xfm bb
          WHERE bb.identifying_address_flag='Y'
          AND bb.migration_SET_id=pt_i_MigrationSetID)
          ) cc
          WHERE cc.seq=1);

          COMMIT;
          --
          gvv_ProgressIndicator := '-CM0030';
          --
          --** Update the migration details (Migration status will be automatically determined
          --** in the called procedure dependant on the Phase and if an Error Message has been
          --** passed).
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => 'CUSTOMERS'
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_Severity            => 'NOTIFICATION'               
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                           ||gct_PackageName
                                           ||'.'
                                           ||ct_ProcOrFuncName
                                           ||'" completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          EXCEPTION
               --
               --
               WHEN OTHERS
               THEN
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
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => 'CUSTOMERS'
                         ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_Severity            => 'ERROR'       
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
     END post_xfm_party_sites_cm;
     --     
     --
     PROCEDURE post_xfm_locations_cm
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE 
                    ) 
     IS
          --
          --
          --**********************
          --** CURSOR Declarations
          --**********************
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'post_xfm_locations_cm';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE      := 'various';
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
          --
     --** END Declarations
     --
     --
     BEGIN
          --
          gvv_ProgressIndicator := '-CM0010';
          --
          --
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => 'CUSTOMERS'
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_Severity            => 'NOTIFICATION'               
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                           ||gct_PackageName
                                           ||'.'
                                           ||ct_ProcOrFuncName
                                           ||'" initiated.'
               ,pt_i_OracleError         => NULL
               );
          --
          --
          --** Update Customer Tables
          --
          gvv_ProgressIndicator := '-CM0020';


          UPDATE xxmx_hz_locations_xfm
          SET address1=replace(address1,',')
          ,address2=replace(address2,',')
          ,address3=replace(address3,',')
          ,address4=replace(address4,',')
          ,city=replace(city,',')
          WHERE migration_SET_id = pt_i_MigrationSetID;

          UPDATE xxmx_hz_locations_xfm
          SET address1=replace(address1,'.')
          ,address2=replace(address2,'.')
          ,address3=replace(address3,'.')
          ,address4=replace(address4,'.')
          ,city=replace(city,'.')
          WHERE migration_SET_id = pt_i_MigrationSetID;

          COMMIT;
          --
          gvv_ProgressIndicator := '-CM0030';
          --
          --** Update the migration details (Migration status will be automatically determined
          --** in the called procedure dependant on the Phase and if an Error Message has been
          --** passed).
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => 'CUSTOMERS'
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_Severity            => 'NOTIFICATION'               
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                           ||gct_PackageName
                                           ||'.'
                                           ||ct_ProcOrFuncName
                                           ||'" completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          EXCEPTION
               --
               --
               WHEN OTHERS
               THEN
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
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => 'CUSTOMERS'
                         ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_Severity            => 'ERROR'       
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
     END post_xfm_locations_cm;
     --
     --
     --
     PROCEDURE post_xfm_contact_points_cm
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE 
                    ) 
     IS
          --
          --
          --**********************
          --** CURSOR Declarations
          --**********************
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'post_xfm_contact_points_cm';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE      := 'various';
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
          --
     --** END Declarations
     --
     --
     BEGIN
          --
          gvv_ProgressIndicator := '-CM0010';
          --
          --
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => 'CUSTOMERS'
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_Severity            => 'NOTIFICATION'               
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                           ||gct_PackageName
                                           ||'.'
                                           ||ct_ProcOrFuncName
                                           ||'" initiated.'
               ,pt_i_OracleError         => NULL
               );
          --
          --
          --** Update Customer Tables
          --
          gvv_ProgressIndicator := '-CM0020';


          UPDATE xxmx_hz_contact_points_xfm
          SET email_address= gct_MaskingEmail
          WHERE migration_SET_id = pt_i_MigrationSetID
          AND contact_point_type='EMAIL';


          COMMIT;
          --
          gvv_ProgressIndicator := '-CM0030';
          --
          --** Update the migration details (Migration status will be automatically determined
          --** in the called procedure dependant on the Phase and if an Error Message has been
          --** passed).
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => 'CUSTOMERS'
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_Severity            => 'NOTIFICATION'               
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                           ||gct_PackageName
                                           ||'.'
                                           ||ct_ProcOrFuncName
                                           ||'" completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          EXCEPTION
               --
               --
               WHEN OTHERS
               THEN
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
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => 'CUSTOMERS'
                         ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_Severity            => 'ERROR'       
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
     END post_xfm_contact_points_cm;
     --
     --
     /*
     ****************************************
     ** PROCEDURE: create_collection_contacts
     **
     ** Phone number / email address @ party level
     **
     ** v1.1 - removed not exist as missing
     **        some contacts 	 
     ****************************************
     */
     PROCEDURE create_collection_contacts(pt_i_MigrationSetID in xxmx_migration_headers.migration_set_id%TYPE)
     IS
     BEGIN
--
-- Party Level - Collection Contacts
--
     --
     -- #1 Party Extract Contacts x1
     --
         INSERT INTO xxmx_stg.xxmx_hz_parties_stg
         (
           migration_set_id,
             migration_set_name,
             migration_status,
             party_orig_system,
             party_orig_system_reference,
             party_type,
             party_number,
             party_usage_code,
             person_first_name,
             person_last_name  
         )
         SELECT DISTINCT
                mhr.migration_set_id migration_set_id, 
                mhr.migration_set_name migration_set_name, 
                'EXTRACTED' migratrion_status,
                gct_OrigSystem party_orig_system,
                'XXDM-CC-'||hps.party_id party_orig_system_reference,
                'PERSON' party_type,
                'XXDM-CC-'||hpp.party_number party_number,
                'ORG_CONTACT' party_usage_code,
                'Collections' person_first_name,
                'Contact' person_last_name
         FROM   (SELECT distinct account_party_id party_id, party_site_id, cust_account_id, account_number, cust_acct_site_id
                 FROM XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101')              selection
                ,xxmx_migration_headers                          mhr
                ,apps.hz_contact_points@MXDM_NVIS_EXTRACT        hcp
                ,apps.hz_party_sites@MXDM_NVIS_EXTRACT           hps
                ,apps.hz_parties@MXDM_NVIS_EXTRACT               hpp
                ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT         hca
                ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT   hcas              
         WHERE  1 = 1
         AND    hcp.owner_table_id          = selection.party_id
         AND    hcp.owner_table_name        = 'HZ_PARTIES'
         AND    hcp.status                  = 'A'
         AND    hcp.primary_flag            = 'Y'
         AND    hcp.contact_point_type      in ('PHONE','EMAIL')
         AND    hps.party_site_id           = selection.party_site_id
         AND    hpp.party_id                = hps.party_id
         AND    hcp.owner_table_id          = hpp.party_id
         AND    hca.cust_account_id         = selection.cust_account_id
         AND    hca.account_number          = selection.account_number
         AND    hcas.cust_account_id        = hca.cust_account_id
         AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
         AND    hcas.party_site_id          = selection.party_site_id
         AND    hcas.org_id                 = '101'
         AND    mhr.migration_set_id        = pt_i_MigrationSetID;
/*
         AND    EXISTS ( SELECT 1
                         FROM   xxmx_stg.xxmx_hz_parties_stg hpp2
                         WHERE  hpp2.migration_set_id =  pt_i_MigrationSetID
                         AND    hpp2.party_orig_system_reference = to_char(hpp.party_id));
*/
/*
         AND    NOT EXISTS (SELECT 1 
                            FROM   apps.hz_relationships@MXDM_NVIS_EXTRACT hzr
                            WHERE  hzr.subject_table_name = 'HZ_PARTIES'
                            AND    hzr.subject_type = hpp.party_type
                            AND    hzr.subject_id   = hpp.party_id
                            AND    hzr.relationship_code like '%CONTACT%');                         
*/
     --
     -- #2 Relationships x1
     --
         INSERT INTO xxmx_stg.xxmx_hz_relationships_stg
         (
             migration_set_id, 
             migration_set_name, 
             migration_status,
             sub_orig_system,
             sub_orig_system_reference,
             obj_orig_system,
             obj_orig_system_reference,
             relationship_type,
             relationship_code,
             start_date,
             end_date,
             subject_type,
             object_type,
             rel_orig_system,
             rel_orig_system_reference
         )
         SELECT DISTINCT
                mhr.migration_set_id migration_set_id, 
                mhr.migration_set_name migration_set_name, 
                'EXTRACTED' migration_status,
                gct_OrigSystem sub_orig_system,
                'XXDM-CC-'||hps.party_id sub_orig_system_reference,
                gct_OrigSystem obj_orig_system,
                hps.party_id obj_orig_system_reference,
                'CONTACT' relationship_type,
                'CONTACT_OF' relationship_code,
                trunc(sysdate) start_date,
                to_date('31/12/4712','DD/MM/YYYY') end_date,
                'PERSON' subject_type,
                hpp.party_type object_type,
                gct_OrigSystem rel_orig_system,
                'XXDM-CC-'||hps.party_id rel_orig_system_reference
         FROM   (SELECT distinct account_party_id party_id, party_site_id, cust_account_id, account_number, cust_acct_site_id
                 FROM XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101')              selection
                ,xxmx_migration_headers                          mhr
                ,apps.hz_contact_points@MXDM_NVIS_EXTRACT        hcp
                ,apps.hz_party_sites@MXDM_NVIS_EXTRACT           hps
                ,apps.hz_parties@MXDM_NVIS_EXTRACT               hpp
                ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT         hca
                ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT   hcas              
         WHERE  1 = 1
         AND    hcp.owner_table_id          = selection.party_id
         AND    hcp.owner_table_name        = 'HZ_PARTIES'
         AND    hcp.status                  = 'A'
         AND    hcp.primary_flag            = 'Y'
         AND    hcp.contact_point_type      in ('PHONE','EMAIL')
         AND    hps.party_site_id           = selection.party_site_id
         AND    hpp.party_id                = hps.party_id
         AND    hcp.owner_table_id          = hpp.party_id
         AND    hca.cust_account_id         = selection.cust_account_id
         AND    hca.account_number          = selection.account_number
         AND    hcas.cust_account_id        = hca.cust_account_id
         AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
         AND    hcas.party_site_id          = selection.party_site_id
         AND    hcas.org_id                 = '101'
         AND    mhr.migration_set_id        = pt_i_MigrationSetID;
/*
         AND    EXISTS ( SELECT 1
                         FROM   xxmx_stg.xxmx_hz_parties_stg hpp2
                         WHERE  hpp2.migration_set_id =  pt_i_MigrationSetID
                         AND    hpp2.party_orig_system_reference = to_char(hpp.party_id));
*/
/*                         
         AND    NOT EXISTS (SELECT 1 
                            FROM   apps.hz_relationships@MXDM_NVIS_EXTRACT hzr
                            WHERE  hzr.subject_table_name = 'HZ_PARTIES'
                            AND    hzr.subject_type = hpp.party_type
                            AND    hzr.subject_id   = hpp.party_id
                            AND    hzr.relationship_code like '%CONTACT%');  
*/
--
     -- #3 Account Contact Source System Reference - x account sites
     --
         INSERT INTO xxmx_stg.xxmx_hz_cust_acct_contacts_stg
         (
             migration_set_id, 
             migration_set_name, 
             migration_status,
             cust_orig_system,
             cust_orig_system_reference,
             cust_site_orig_system,
             cust_site_orig_sys_ref,
             cust_contact_orig_system,
             cust_contact_orig_sys_ref,
             role_type,
             primary_flag,
             rel_orig_system,
             rel_orig_system_reference
         )
         SELECT DISTINCT
                 mhr.migration_set_id migration_set_id, 
                 mhr.migration_set_name migration_set_name, 
                 'EXTRACTED' migration_status,
                 gct_OrigSystem cust_orig_system,
                 hca.account_number cust_orig_system_reference,
                 gct_OrigSystem cust_site_orig_system,
                 hcas.cust_account_id||'-'||hcas.cust_acct_site_id cust_site_orig_sys_ref,
                 gct_OrigSystem cust_contact_orig_system,
                 'XXDM-CC-'||hps.party_site_id||'-'||hcas.cust_acct_site_id cust_contact_orig_sys_ref,  --hcas.cust_acct_site_id
                 'CONTACT' role_type,
                 'N' primary_flag,
                 gct_OrigSystem rel_orig_system,
                 'XXDM-CC-'||hps.party_id rel_orig_system_reference
         FROM   (SELECT distinct account_party_id party_id, party_site_id, cust_account_id, account_number, cust_acct_site_id
                 FROM XXMX_CUSTOMER_SCOPE_TEMP_STG)              selection
                ,xxmx_migration_headers                          mhr
                ,apps.hz_contact_points@MXDM_NVIS_EXTRACT        hcp
                ,apps.hz_party_sites@MXDM_NVIS_EXTRACT           hps
                ,apps.hz_parties@MXDM_NVIS_EXTRACT               hpp
                ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT         hca
                ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT   hcas              
         WHERE  1 = 1
         AND    hcp.owner_table_id          = selection.party_id
         AND    hcp.owner_table_name        = 'HZ_PARTIES'
         AND    hcp.status                  = 'A'
         AND    hcp.primary_flag            = 'Y'
         AND    hcp.contact_point_type      in ('PHONE','EMAIL')
         AND    hps.party_site_id           = selection.party_site_id
         AND    hpp.party_id                = hps.party_id
         AND    hcp.owner_table_id          = hpp.party_id
         AND    hca.cust_account_id         = selection.cust_account_id
         AND    hca.account_number          = selection.account_number
         AND    hcas.cust_account_id        = hca.cust_account_id
         AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
         AND    hcas.party_site_id          = selection.party_site_id
         AND    hcas.org_id                 = '101'
         AND    mhr.migration_set_id        = pt_i_MigrationSetID;
/*	 
         AND    EXISTS ( SELECT 1
                         FROM   xxmx_stg.xxmx_hz_parties_stg hpp2
                         WHERE  hpp2.migration_set_id =  pt_i_MigrationSetID
                         AND    hpp2.party_orig_system_reference = to_char(hpp.party_id));
*/
/*                         
         AND    NOT EXISTS (SELECT 1 
                            FROM   apps.hz_relationships@MXDM_NVIS_EXTRACT hzr
                            WHERE  hzr.subject_table_name = 'HZ_PARTIES'
                            AND    hzr.subject_type = hpp.party_type
                            AND    hzr.subject_id   = hpp.party_id
                            AND    hzr.relationship_code like '%CONTACT%');   
*/
     --
     -- #4 Account Contact Points - per party, per contact type
     --
         INSERT INTO xxmx_stg.xxmx_hz_contact_points_stg
         (
             migration_set_id, 
             migration_set_name, 
             migration_status,
             cp_orig_system,
             cp_orig_system_reference,
             party_orig_system,
             party_orig_system_reference,
             primary_flag,
             contact_point_type,
             contact_point_purpose,
             phone_area_code,
             phone_country_code,
             phone_extension,
             phone_line_type,
             phone_number,
             email_address,
             email_format,
             rel_orig_system,
             rel_orig_system_reference
         )
         SELECT  DISTINCT
                mhr.migration_set_id migration_set_id, 
                mhr.migration_set_name migration_set_name, 
                'EXTRACTED' migration_status,
                gct_OrigSystem cp_orig_system,
                'XXDM-CC-PHONE-'||hps.party_id cp_orig_system_reference,
                gct_OrigSystem party_orig_system,
                'XXDM-CC-'||hps.party_id party_orig_system_reference,
                'N' primary_flag,
                'PHONE' contact_point_type,
                'BUSINESS' contact_point_purpose,
                hcp.phone_area_code,
                hcp.phone_country_code,
                hcp.phone_extension,
                hcp.phone_line_type,
                hcp.phone_number,
                null,
                null,
                gct_OrigSystem rel_orig_system,
                'XXDM-CC-'||hps.party_id rel_orig_system_reference
         FROM   (select distinct account_party_id party_id, party_site_id, cust_account_id, account_number, cust_acct_site_id
                 from XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101')              selection
                ,xxmx_migration_headers                          mhr
                ,apps.hz_contact_points@MXDM_NVIS_EXTRACT        hcp
                ,apps.hz_party_sites@MXDM_NVIS_EXTRACT           hps
                ,apps.hz_parties@MXDM_NVIS_EXTRACT               hpp
                ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT         hca
                ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT   hcas              
         WHERE  1 = 1
         AND    hcp.owner_table_id          = selection.party_id
         AND    hcp.owner_table_name        = 'HZ_PARTIES'
         AND    hcp.status                  = 'A'
         AND    hcp.primary_flag            = 'Y'
         AND    hcp.contact_point_type      = 'PHONE'
         AND    hps.party_Site_Id           = selection.party_site_id
         AND    hpp.party_id                = hps.party_id
         AND    hca.cust_account_id         = selection.cust_account_id
         AND    hca.account_number          = selection.account_number
         AND    hcas.cust_account_id        = hca.cust_account_id
         AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
         AND    hcas.party_site_id          = selection.party_site_id
         AND    hcas.org_id                 = '101'
         AND    mhr.migration_set_id        = pt_i_MigrationSetID
/*
         AND    EXISTS ( SELECT 1
                         FROM   xxmx_stg.xxmx_hz_parties_stg hpp2
                         WHERE  hpp2.migration_set_id =  pt_i_MigrationSetID
                         AND    hpp2.party_orig_system_reference = to_char(hpp.party_id)) 
*/
/*                        
         AND    NOT EXISTS (SELECT 1 
                            FROM   apps.hz_relationships@MXDM_NVIS_EXTRACT hzr
                            WHERE  hzr.subject_table_name = 'HZ_PARTIES'
                            AND    hzr.subject_type = hpp.party_type
                            AND    hzr.subject_id   = hpp.party_id
                            AND    hzr.relationship_code like '%CONTACT%')
*/
         UNION
         SELECT  DISTINCT
                mhr.migration_set_id migration_set_id, 
                mhr.migration_set_name migration_set_name, 
                'EXTRACTED' migration_status,
                gct_OrigSystem cp_orig_system,
                'XXDM-CC-EMAIL-'||hps.party_id cp_orig_system_reference,
                gct_OrigSystem party_orig_system,
                'XXDM-CC-'||hps.party_id party_orig_system_reference,
                'N' primary_flag,
                'EMAIL' contact_point_type,                
                'BUSINESS' contact_point_purpose,
                null,null,null,null,null,
                hcp.email_address,
                hcp.email_format,
                gct_OrigSystem rel_orig_system,
                'XXDM-CC-'||hps.party_id rel_orig_system_reference
         FROM   (select distinct account_party_id party_id, party_site_id, cust_account_id, account_number, cust_acct_site_id
                 from XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101')              selection
                ,xxmx_migration_headers                          mhr
                ,apps.hz_contact_points@MXDM_NVIS_EXTRACT        hcp
                ,apps.hz_party_sites@MXDM_NVIS_EXTRACT           hps
                ,apps.hz_parties@MXDM_NVIS_EXTRACT               hpp
                ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT         hca
                ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT   hcas              
         WHERE  1 = 1
         AND    hcp.owner_table_id          = selection.party_id
         AND    hcp.owner_table_name        = 'HZ_PARTIES'
         AND    hcp.status                  = 'A'
         AND    hcp.primary_flag            = 'Y'
         AND    hcp.contact_point_type      = 'EMAIL'
         AND    hps.party_Site_Id           = selection.party_site_id
         AND    hpp.party_id                = hps.party_id
         AND    hca.cust_account_id         = selection.cust_account_id
         AND    hca.account_number          = selection.account_number
         AND    hcas.cust_account_id        = hca.cust_account_id
         AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
         AND    hcas.party_site_id          = selection.party_site_id
         AND    hcas.org_id                 = '101'
         AND    mhr.migration_set_id        = pt_i_MigrationSetID;
/*		 
         AND    EXISTS ( SELECT 1
                         FROM   xxmx_stg.xxmx_hz_parties_stg hpp2
                         WHERE  hpp2.migration_set_id =  pt_i_MigrationSetID
                         AND    hpp2.party_orig_system_reference = to_char(hpp.party_id));
*/
/*                         
         AND    NOT EXISTS (SELECT 1 
                            FROM   apps.hz_relationships@MXDM_NVIS_EXTRACT hzr
                            WHERE  hzr.subject_table_name = 'HZ_PARTIES'
                            AND    hzr.subject_type = hpp.party_type
                            AND    hzr.subject_id   = hpp.party_id
                            AND    hzr.relationship_code like '%CONTACT%');
*/
     --
     -- #5 Contact Roles x1 (party)
     --
         INSERT INTO xxmx_stg.xxmx_hz_org_contact_roles_stg
         (
                migration_set_id, 
                migration_set_name, 
                migration_status,
                contact_role_orig_system,
                contact_role_orig_sys_ref,
                rel_orig_system,
                rel_orig_system_reference,
                role_type,
                role_level,
                primary_flag,
                primary_contact_per_role_type
         )
         SELECT DISTINCT
                mhr.migration_set_id migration_set_id, 
                mhr.migration_set_name migration_set_name, 
                'EXTRACTED' migration_status,
                gct_OrigSystem contact_role_orig_system,
                'XXDM-CC'||hps.party_id cp_orig_system_reference,
                gct_OrigSystem rel_orig_system,
                'XXDM-CC-'||hps.party_id rel_orig_system_reference,
                'CONTACT' role_type,
                'N' role_level,
                'N' primary_flag,
                'N' primary_contact_per_role_type
         FROM   (SELECT distinct account_party_id party_id, party_site_id, cust_account_id, account_number, cust_acct_site_id
                 FROM XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101')              selection
                ,xxmx_migration_headers                          mhr
                ,apps.hz_contact_points@MXDM_NVIS_EXTRACT        hcp
                ,apps.hz_party_sites@MXDM_NVIS_EXTRACT           hps
                ,apps.hz_parties@MXDM_NVIS_EXTRACT               hpp
                ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT         hca
                ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT   hcas              
         WHERE  1 = 1
         AND    hcp.owner_table_id          = selection.party_id
         AND    hcp.owner_table_name        = 'HZ_PARTIES'
         AND    hcp.status                  = 'A'
         AND    hcp.primary_flag            = 'Y'
         AND    hcp.contact_point_type      in ('PHONE','EMAIL')
         AND    hps.party_site_id           = selection.party_site_id
         AND    hpp.party_id                = hps.party_id
         AND    hcp.owner_table_id          = hpp.party_id
         AND    hca.cust_account_id         = selection.cust_account_id
         AND    hca.account_number          = selection.account_number
         AND    hcas.cust_account_id        = hca.cust_account_id
         AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
         AND    hcas.party_site_id          = selection.party_site_id
         AND    hcas.org_id                 = '101'
         AND    mhr.migration_set_id        = pt_i_MigrationSetID;
/*
         AND    EXISTS ( SELECT 1
                         FROM   xxmx_stg.xxmx_hz_parties_stg hpp2
                         WHERE  hpp2.migration_set_id =  pt_i_MigrationSetID
                         AND    hpp2.party_orig_system_reference = to_char(hpp.party_id));
*/
/*						 
         AND    NOT EXISTS (SELECT 1 
                            FROM   apps.hz_relationships@MXDM_NVIS_EXTRACT hzr
                            WHERE  hzr.subject_table_name = 'HZ_PARTIES'
                            AND    hzr.subject_type = hpp.party_type
                            AND    hzr.subject_id   = hpp.party_id
                            AND    hzr.relationship_code like '%CONTACT%');   
*/
     --
     -- #6 Relationship Source - Imp Contacts - x1 party
     --
         INSERT INTO xxmx_stg.xxmx_hz_org_contacts_stg
         (	
                migration_set_id, 
                migration_set_name, 
                migration_status,
                rel_orig_system,
                rel_orig_system_reference
    	    )
         SELECT DISTINCT
                  mhr.migration_set_id migration_set_id, 
                  mhr.migration_set_name migration_set_name, 
                  'EXTRACTED' migration_status,
                  gct_OrigSystem rel_orig_system,
                  'XXDM-CC-'||hps.party_id rel_orig_system_reference
         FROM   (select distinct account_party_id party_id, party_site_id, cust_account_id, account_number, cust_acct_site_id
                 from XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101')              selection
                ,xxmx_migration_headers                          mhr
                ,apps.hz_contact_points@MXDM_NVIS_EXTRACT        hcp
                ,apps.hz_party_sites@MXDM_NVIS_EXTRACT           hps
                ,apps.hz_parties@MXDM_NVIS_EXTRACT               hpp
                ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT         hca
                ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT   hcas              
         WHERE  1 = 1
         AND    hcp.owner_table_id          = selection.party_id
         AND    hcp.owner_table_name        = 'HZ_PARTIES'
         AND    hcp.status                  = 'A'
         AND    hcp.primary_flag            = 'Y'
         AND    hcp.contact_point_type      = 'PHONE'
         AND    hps.party_Site_Id           = selection.party_site_id
         AND    hpp.party_id                = hps.party_id
         AND    hca.cust_account_id         = selection.cust_account_id
         AND    hca.account_number          = selection.account_number
         AND    hcas.cust_account_id        = hca.cust_account_id
         AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
         AND    hcas.party_site_id          = selection.party_site_id
         AND    hcas.org_id                 = '101'
         AND    mhr.migration_set_id        = pt_i_MigrationSetID;
/*
         AND    EXISTS ( SELECT 1
                         FROM   xxmx_stg.xxmx_hz_parties_stg hpp2
                         WHERE  hpp2.migration_set_id =  pt_i_MigrationSetID
                         AND    hpp2.party_orig_system_reference = to_char(hpp.party_id));
*/
/*						 
                             AND    NOT EXISTS (SELECT 1 
                            FROM   apps.hz_relationships@MXDM_NVIS_EXTRACT hzr
                            WHERE  hzr.subject_table_name = 'HZ_PARTIES'
                            AND    hzr.subject_type = hpp.party_type
                            AND    hzr.subject_id   = hpp.party_id
                            AND    hzr.relationship_code like '%CONTACT%');	 
*/
							END;     
     --
     --
     /*
     **************************************
     ** PROCEDURE: create_ebilling_contacts
     **
     ** v1.1 - removed not exist as missing
     **        some contacts 
     **************************************
     */
     PROCEDURE create_ebilling_contacts(pt_i_MigrationSetID in xxmx_migration_headers.migration_set_id%TYPE)
     IS
     BEGIN
     --
     -- #1 Party Extract Contacts -- A/C Site Email Addresses - 1 per site
     --
        INSERT INTO xxmx_stg.xxmx_hz_parties_stg
        (
         migration_set_id,
         migration_set_name,
         migration_status,
         party_orig_system,
         party_orig_system_reference,
         party_type,
         party_number,
         party_usage_code,
         person_first_name,
         person_last_name  
        )
        SELECT DISTINCT
               mhr.migration_set_id migration_set_id, 
               mhr.migration_set_name migration_set_name, 
               'EXTRACTED' migratrion_status,
               gct_OrigSystem party_orig_system,
               'XXDM-EB-EMAIL-'||hps.party_site_id party_orig_system_reference,
               'PERSON' party_type,
               'XXDM-EB-EMAIL-'||hps.party_site_id party_number,
               'ORG_CONTACT' party_usage_code,
               'eBilling' person_first_name,
               'Contact' person_last_name
        FROM   (SELECT distinct account_party_id party_id, party_site_id, cust_account_id, account_number, cust_acct_site_id, org_id
                FROM XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101') selection
               ,xxmx_migration_headers                          mhr
               ,apps.hz_contact_points@MXDM_NVIS_EXTRACT        hcp
               ,apps.hz_party_sites@MXDM_NVIS_EXTRACT           hps
               ,apps.hz_parties@MXDM_NVIS_EXTRACT               hpp
               ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT         hca
               ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT   hcas              
        WHERE  1 = 1
        AND    hcp.owner_table_id(+)       = selection.party_site_id
        AND    hcp.owner_table_name(+)     = 'HZ_PARTY_SITES'
        AND    hcp.status(+)               = 'A'
        AND    hcp.primary_flag(+)         = 'Y'
        AND    hcp.contact_point_type(+)   = 'EMAIL'
        AND    hps.party_Site_Id           = selection.party_site_id
        AND    hpp.party_id                = hps.party_id
        AND    hca.cust_account_id         = selection.cust_account_id
        AND    hca.account_number          = selection.account_number
        AND    hcas.cust_account_id        = hca.cust_account_id
        AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
        AND    hcas.party_site_id          = selection.party_site_id
        AND    hcas.org_id                 = selection.org_id
        AND    mhr.migration_set_id        = pt_i_MigrationSetID;
/*		
        AND    EXISTS ( SELECT 1
                        FROM   xxmx_stg.xxmx_hz_parties_stg hpp2
                        WHERE  hpp2.migration_set_id =  pt_i_MigrationSetID
                        AND    hpp2.party_orig_system_reference = to_char(hpp.party_id));
*/
		/*
                    AND    NOT EXISTS (SELECT 1 
                                       FROM   apps.hz_relationships@MXDM_NVIS_EXTRACT hzr
                                       WHERE  hzr.subject_table_name = 'HZ_PARTIES'
                                       AND    hzr.subject_type = hpp.party_type
                                       AND    hzr.subject_id   = hpp.party_id
                                       AND    hzr.relationship_code like '%CONTACT%'); 
        */
     --
     -- #2 Relationships - 1 per site
     --        
        INSERT INTO xxmx_stg.xxmx_hz_relationships_stg
        (
            migration_set_id, 
            migration_set_name, 
            migration_status,
            sub_orig_system,
            sub_orig_system_reference,
            obj_orig_system,
            obj_orig_system_reference,
            relationship_type,
            relationship_code,
            start_date,
            end_date,
            subject_type,
            object_type,
            rel_orig_system,
            rel_orig_system_reference
        )
        SELECT DISTINCT
                  mhr.migration_set_id migration_set_id, 
                  mhr.migration_set_name migration_set_name, 
                  'EXTRACTED' migration_status,
                  gct_OrigSystem sub_orig_system,
                  'XXDM-EB-EMAIL-'||hps.party_site_id  sub_orig_system_reference,
                  gct_OrigSystem obj_orig_system,
                  hps.party_id obj_orig_system_reference,
                  'CONTACT' relationship_type,
                  'CONTACT_OF' relationship_code,
                  trunc(sysdate) start_date,
                  to_date('31/12/4712','DD/MM/YYYY') end_date,
                  'PERSON' subject_type,
                  hpp.party_type object_type,
                  gct_OrigSystem rel_orig_system,
                  'XXDM-EB-EMAIL-'||hps.party_site_id rel_orig_system_reference
        FROM   (SELECT distinct account_party_id party_id, party_site_id, cust_account_id, account_number, cust_acct_site_id, org_id
                FROM XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101')              selection
               ,xxmx_migration_headers                          mhr
               ,apps.hz_contact_points@MXDM_NVIS_EXTRACT        hcp
               ,apps.hz_party_sites@MXDM_NVIS_EXTRACT           hps
               ,apps.hz_parties@MXDM_NVIS_EXTRACT               hpp
               ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT         hca
               ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT   hcas              
        WHERE  1 = 1
        AND    hcp.owner_table_id(+)       = selection.party_site_id
        AND    hcp.owner_table_name(+)     = 'HZ_PARTY_SITES'
        AND    hcp.status(+)               = 'A'
        AND    hcp.primary_flag(+)         = 'Y'
        AND    hcp.contact_point_type(+)   = 'EMAIL'
        AND    hps.party_Site_Id           = selection.party_site_id
        AND    hpp.party_id                = hps.party_id
        AND    hca.cust_account_id         = selection.cust_account_id
        AND    hca.account_number          = selection.account_number
        AND    hcas.cust_account_id        = hca.cust_account_id
        AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
        AND    hcas.party_site_id          = selection.party_site_id
        AND    hcas.org_id                 = selection.org_id
        AND    mhr.migration_set_id        = pt_i_MigrationSetID;
/*		
        AND    EXISTS ( SELECT 1
                        FROM   xxmx_stg.xxmx_hz_parties_stg hpp2
                        WHERE  hpp2.migration_set_id =  pt_i_MigrationSetID
                        AND    hpp2.party_orig_system_reference = to_char(hpp.party_id));		
*/
/*
                    AND    NOT EXISTS (SELECT 1 
                                       FROM   apps.hz_relationships@MXDM_NVIS_EXTRACT hzr
                                       WHERE  hzr.subject_table_name = 'HZ_PARTIES'
                                       AND    hzr.subject_type = hpp.party_type
                                       AND    hzr.subject_id   = hpp.party_id
                                       AND    hzr.relationship_code like '%CONTACT%'); 
*/
     --
     -- #3 Account Contact Source System Reference
     --
        INSERT INTO xxmx_stg.xxmx_hz_cust_acct_contacts_stg
        (
                         migration_set_id, 
                         migration_set_name, 
                         migration_status,
                         cust_orig_system,
                         cust_orig_system_reference,
                         cust_site_orig_system,
                         cust_site_orig_sys_ref,
                         cust_contact_orig_system,
                         cust_contact_orig_sys_ref,
                         role_type,
                         primary_flag,
                         rel_orig_system,
                         rel_orig_system_reference
         )
         SELECT DISTINCT
                    mhr.migration_set_id migration_set_id, 
                    mhr.migration_set_name migration_set_name, 
                    'EXTRACTED' migration_status,
                    gct_OrigSystem cust_orig_system,
                    hca.account_number cust_orig_system_reference,
                    gct_OrigSystem cust_site_orig_system,
                    hcas.cust_account_id||'-'||hcas.cust_acct_site_id cust_site_orig_sys_ref,
                    gct_OrigSystem cust_contact_orig_system,
                    'XXDM-EB-EMAIL-'||hps.party_site_id||'-'||hcas.cust_acct_site_id  cust_contact_orig_sys_ref,
                    'CONTACT' role_type,
                    'N' primary_flag,
                    gct_OrigSystem rel_orig_system,
                    'XXDM-EB-EMAIL-'||hps.party_site_id  rel_orig_system_reference
        FROM   (SELECT distinct account_party_id party_id, party_site_id, cust_account_id, account_number, cust_acct_site_id, org_id
                FROM XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101')              selection
               ,xxmx_migration_headers                          mhr
               ,apps.hz_contact_points@MXDM_NVIS_EXTRACT        hcp
               ,apps.hz_party_sites@MXDM_NVIS_EXTRACT           hps
               ,apps.hz_parties@MXDM_NVIS_EXTRACT               hpp
               ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT         hca
               ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT   hcas              
        WHERE  1 = 1
        AND    hcp.owner_table_id(+)       = selection.party_site_id
        AND    hcp.owner_table_name(+)     = 'HZ_PARTY_SITES'
        AND    hcp.status(+)               = 'A'
        AND    hcp.primary_flag(+)         = 'Y'
        AND    hcp.contact_point_type(+)   = 'EMAIL'
        AND    hps.party_Site_Id           = selection.party_site_id
        AND    hpp.party_id                = hps.party_id
        AND    hca.cust_account_id         = selection.cust_account_id
        AND    hca.account_number          = selection.account_number
        AND    hcas.cust_account_id        = hca.cust_account_id
        AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
        AND    hcas.party_site_id          = selection.party_site_id
        AND    hcas.org_id                 = selection.org_id
        AND    mhr.migration_set_id        = pt_i_MigrationSetID;
/*		
        AND    EXISTS ( SELECT 1
                        FROM   xxmx_stg.xxmx_hz_parties_stg hpp2
                        WHERE  hpp2.migration_set_id =  pt_i_MigrationSetID
                        AND    hpp2.party_orig_system_reference = to_char(hpp.party_id));
*/
/*        
                    AND    NOT EXISTS (SELECT 1 
                                       FROM   apps.hz_relationships@MXDM_NVIS_EXTRACT hzr
                                       WHERE  hzr.subject_table_name = 'HZ_PARTIES'
                                       AND    hzr.subject_type = hpp.party_type
                                       AND    hzr.subject_id   = hpp.party_id
                                       AND    hzr.relationship_code like '%CONTACT%'); 
*/
     --
     -- #4 Account Contact Points - per site
     --
         INSERT INTO xxmx_stg.xxmx_hz_contact_points_stg
         (
             migration_set_id, 
             migration_set_name, 
             migration_status,
             cp_orig_system,
             cp_orig_system_reference,
             party_orig_system,
             party_orig_system_reference,
             primary_flag,
             contact_point_type,
             contact_point_purpose,             
             email_address,
             email_format,
             rel_orig_system,
             rel_orig_system_reference
         )
         SELECT  DISTINCT
                mhr.migration_set_id migration_set_id, 
                mhr.migration_set_name migration_set_name, 
                'EXTRACTED' migration_status,
                gct_OrigSystem cp_orig_system,
                'XXDM-EB-EMAIL-'||hps.party_site_id  cp_orig_system_reference,
                gct_OrigSystem party_orig_system,
                'XXDM-EB-EMAIL-'||hps.party_site_id  party_orig_system_reference,
                'N' primary_flag,
                'EMAIL' contact_point_type,
                'BUSINESS' contact_point_purpose,
                nvl(hcp.email_address, gct_DefaultEmail) email_address,
                nvl(hcp.email_format, gct_DefaultEmailFmt) email_format,
                gct_OrigSystem rel_orig_system,
                'XXDM-EB-EMAIL-'||hps.party_site_id rel_orig_system_reference                           
         FROM   (SELECT distinct account_party_id party_id, party_site_id, cust_account_id, account_number, cust_acct_site_id, org_id
                 FROM XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101')              selection
                ,xxmx_migration_headers                          mhr
                ,apps.hz_contact_points@MXDM_NVIS_EXTRACT        hcp
                ,apps.hz_party_sites@MXDM_NVIS_EXTRACT           hps
                ,apps.hz_parties@MXDM_NVIS_EXTRACT               hpp
                ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT         hca
                ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT   hcas              
         WHERE  1 = 1
         AND    hcp.owner_table_id(+)       = selection.party_site_id
         AND    hcp.owner_table_name(+)     = 'HZ_PARTY_SITES'
         AND    hcp.status(+)               = 'A'
         AND    hcp.primary_flag(+)         = 'Y'
         AND    hcp.contact_point_type(+)   = 'EMAIL'
         AND    hps.party_Site_Id           = selection.party_site_id
         AND    hpp.party_id                = hps.party_id
         AND    hca.cust_account_id         = selection.cust_account_id
         AND    hca.account_number          = selection.account_number
         AND    hcas.cust_account_id        = hca.cust_account_id
         AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
         AND    hcas.party_site_id          = selection.party_site_id
         AND    hcas.org_id                 = selection.org_id
         AND    mhr.migration_set_id        = pt_i_MigrationSetID;
/*		 
         AND    EXISTS ( SELECT 1
                         FROM   xxmx_stg.xxmx_hz_parties_stg hpp2
                         WHERE  hpp2.migration_set_id =  pt_i_MigrationSetID
                         AND    hpp2.party_orig_system_reference = to_char(hpp.party_id));
*/
/*         
         AND    NOT EXISTS (SELECT 1 
                            FROM   apps.hz_relationships@MXDM_NVIS_EXTRACT hzr
                            WHERE  hzr.subject_table_name = 'HZ_PARTIES'
                            AND    hzr.subject_type = hpp.party_type
                            AND    hzr.subject_id   = hpp.party_id
                            AND    hzr.relationship_code like '%CONTACT%'); 
*/                            
     --
     -- #5 Contact Roles - 1 per site/role - SMBC = CONTACT / STMTS / DUN / BILL_TO
     --
         INSERT INTO xxmx_stg.xxmx_hz_org_contact_roles_stg
         (
                migration_set_id, 
                migration_set_name, 
                migration_status,
                contact_role_orig_system,
                contact_role_orig_sys_ref,
                rel_orig_system,
                rel_orig_system_reference,
                role_type,
                role_level,
                primary_flag,
                primary_contact_per_role_type
         )
         SELECT DISTINCT
                mhr.migration_set_id migration_set_id, 
                mhr.migration_set_name migration_set_name, 
                'EXTRACTED' migration_status,
                gct_OrigSystem contact_role_orig_system,
                'XXDM-EB-EMAIL-'||hps.party_site_id||'-CNTC' cp_orig_system_reference,
                gct_OrigSystem rel_orig_system,
                'XXDM-EB-EMAIL-'||hps.party_site_id rel_orig_system_reference,
                'CONTACT' role_type,
                'N' role_level,
                'N' primary_flag,
                'N' primary_contact_per_role_type
         FROM   (SELECT distinct account_party_id party_id, party_site_id, cust_account_id, account_number, cust_acct_site_id, org_id
                 FROM XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101')              selection
                ,xxmx_migration_headers                          mhr
                ,apps.hz_contact_points@MXDM_NVIS_EXTRACT        hcp
                ,apps.hz_party_sites@MXDM_NVIS_EXTRACT           hps
                ,apps.hz_parties@MXDM_NVIS_EXTRACT               hpp
                ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT         hca
                ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT   hcas              
         WHERE  1 = 1
         AND    hcp.owner_table_id(+)       = selection.party_site_id
         AND    hcp.owner_table_name(+)     = 'HZ_PARTY_SITES'
         AND    hcp.status(+)               = 'A'
         AND    hcp.primary_flag(+)         = 'Y'
         AND    hcp.contact_point_type(+)   = 'EMAIL'
         AND    hps.party_Site_Id           = selection.party_site_id
         AND    hpp.party_id                = hps.party_id
         AND    hca.cust_account_id         = selection.cust_account_id
         AND    hca.account_number          = selection.account_number
         AND    hcas.cust_account_id        = hca.cust_account_id
         AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
         AND    hcas.party_site_id          = selection.party_site_id
         AND    hcas.org_id                 = selection.org_id
         AND    mhr.migration_set_id        = pt_i_MigrationSetID
/*
         AND    EXISTS ( SELECT 1
                         FROM   xxmx_stg.xxmx_hz_parties_stg hpp2
                         WHERE  hpp2.migration_set_id =  pt_i_MigrationSetID
                         AND    hpp2.party_orig_system_reference = to_char(hpp.party_id))		 
*/
/*
         AND    NOT EXISTS (SELECT 1 
                            FROM   apps.hz_relationships@MXDM_NVIS_EXTRACT hzr
                            WHERE  hzr.subject_table_name = 'HZ_PARTIES'
                            AND    hzr.subject_type = hpp.party_type
                            AND    hzr.subject_id   = hpp.party_id
                            AND    hzr.relationship_code like '%CONTACT%')
*/
         UNION
         SELECT DISTINCT
               mhr.migration_set_id migration_set_id, 
               mhr.migration_set_name migration_set_name, 
               'EXTRACTED' migration_status,
               gct_OrigSystem contact_role_orig_system,
               'XXDM-EB-EMAIL-'||hps.party_site_id||'-DUN' cp_orig_system_reference,
               gct_OrigSystem rel_orig_system,
               'XXDM-EB-EMAIL-'||hps.party_site_id rel_orig_system_reference,
               'DUN' role_type,
               'N' role_level,
               'N' primary_flag,
               'N' primary_contact_per_role_type
         FROM   (SELECT distinct account_party_id party_id, party_site_id, cust_account_id, account_number, cust_acct_site_id, org_id
                 FROM XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101')              selection
                ,xxmx_migration_headers                          mhr
                ,apps.hz_contact_points@MXDM_NVIS_EXTRACT        hcp
                ,apps.hz_party_sites@MXDM_NVIS_EXTRACT           hps
                ,apps.hz_parties@MXDM_NVIS_EXTRACT               hpp
                ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT         hca
                ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT   hcas              
         WHERE  1 = 1
         AND    hcp.owner_table_id(+)       = selection.party_site_id
         AND    hcp.owner_table_name(+)     = 'HZ_PARTY_SITES'
         AND    hcp.status(+)               = 'A'
         AND    hcp.primary_flag(+)         = 'Y'
         AND    hcp.contact_point_type(+)   = 'EMAIL'
         AND    hps.party_Site_Id           = selection.party_site_id
         AND    hpp.party_id                = hps.party_id
         AND    hca.cust_account_id         = selection.cust_account_id
         AND    hca.account_number          = selection.account_number
         AND    hcas.cust_account_id        = hca.cust_account_id
         AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
         AND    hcas.party_site_id          = selection.party_site_id
         AND    hcas.org_id                 = selection.org_id
         AND    mhr.migration_set_id        = pt_i_MigrationSetID
/*		 
         AND    EXISTS ( SELECT 1 
                         FROM   xxmx_stg.xxmx_hz_parties_stg hpp2
                         WHERE  hpp2.migration_set_id =  pt_i_MigrationSetID
                         AND    hpp2.party_orig_system_reference = to_char(hpp.party_id))
*/
/*
         AND    NOT EXISTS (SELECT 1 
                            FROM   apps.hz_relationships@MXDM_NVIS_EXTRACT hzr
                            WHERE  hzr.subject_table_name = 'HZ_PARTIES'
                            AND    hzr.subject_type = hpp.party_type
                            AND    hzr.subject_id   = hpp.party_id
                            AND    hzr.relationship_code like '%CONTACT%')               
*/
         UNION
         SELECT DISTINCT
               mhr.migration_set_id migration_set_id, 
               mhr.migration_set_name migration_set_name, 
               'EXTRACTED' migration_status,
               gct_OrigSystem contact_role_orig_system,
               'XXDM-EB-EMAIL-'||hps.party_site_id||'-STMTS' cp_orig_system_reference,
               gct_OrigSystem rel_orig_system,
               'XXDM-EB-EMAIL-'||hps.party_site_id rel_orig_system_reference,
               'STMTS' role_type,
               'N' role_level,
               'N' primary_flag,
               'N' primary_contact_per_role_type
         FROM   (SELECT distinct account_party_id party_id, party_site_id, cust_account_id, account_number, cust_acct_site_id, org_id
                 FROM XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101')              selection
                ,xxmx_migration_headers                          mhr
                ,apps.hz_contact_points@MXDM_NVIS_EXTRACT        hcp
                ,apps.hz_party_sites@MXDM_NVIS_EXTRACT           hps
                ,apps.hz_parties@MXDM_NVIS_EXTRACT               hpp
                ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT         hca
                ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT   hcas              
         WHERE  1 = 1
         AND    hcp.owner_table_id(+)       = selection.party_site_id
         AND    hcp.owner_table_name(+)     = 'HZ_PARTY_SITES'
         AND    hcp.status(+)               = 'A'
         AND    hcp.primary_flag(+)         = 'Y'
         AND    hcp.contact_point_type(+)   = 'EMAIL'
         AND    hps.party_Site_Id           = selection.party_site_id
         AND    hpp.party_id                = hps.party_id
         AND    hca.cust_account_id         = selection.cust_account_id
         AND    hca.account_number          = selection.account_number
         AND    hcas.cust_account_id        = hca.cust_account_id
         AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
         AND    hcas.party_site_id          = selection.party_site_id
         AND    hcas.org_id                 = selection.org_id
         AND    mhr.migration_set_id        = pt_i_MigrationSetID
/*		 
         AND    EXISTS ( SELECT 1
                         FROM   xxmx_stg.xxmx_hz_parties_stg hpp2
                         WHERE  hpp2.migration_set_id =  pt_i_MigrationSetID
                         AND    hpp2.party_orig_system_reference = to_char(hpp.party_id))
*/
/*
         AND    NOT EXISTS (SELECT 1 
                            FROM   apps.hz_relationships@MXDM_NVIS_EXTRACT hzr
                            WHERE  hzr.subject_table_name = 'HZ_PARTIES'
                            AND    hzr.subject_type = hpp.party_type
                            AND    hzr.subject_id   = hpp.party_id
                            AND    hzr.relationship_code like '%CONTACT%')                       
*/
         UNION
         SELECT DISTINCT
               mhr.migration_set_id migration_set_id, 
               mhr.migration_set_name migration_set_name, 
               'EXTRACTED' migration_status,
               gct_OrigSystem contact_role_orig_system,
               'XXDM-EB-EMAIL-'||hps.party_site_id||'-BILLTO' cp_orig_system_reference,
               gct_OrigSystem rel_orig_system,
               'XXDM-EB-EMAIL-'||hps.party_site_id rel_orig_system_reference,
               'BILL_TO' role_type,
               'N' role_level,
               'N' primary_flag,
               'N' primary_contact_per_role_type
         FROM   (SELECT distinct account_party_id party_id, party_site_id, cust_account_id, account_number, cust_acct_site_id, org_id
                 FROM XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101')              selection
                ,xxmx_migration_headers                          mhr
                ,apps.hz_contact_points@MXDM_NVIS_EXTRACT        hcp
                ,apps.hz_party_sites@MXDM_NVIS_EXTRACT           hps
                ,apps.hz_parties@MXDM_NVIS_EXTRACT               hpp
                ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT         hca
                ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT   hcas              
         WHERE  1 = 1
         AND    hcp.owner_table_id(+)       = selection.party_site_id
         AND    hcp.owner_table_name(+)     = 'HZ_PARTY_SITES'
         AND    hcp.status(+)               = 'A'
         AND    hcp.primary_flag(+)         = 'Y'
         AND    hcp.contact_point_type(+)   = 'EMAIL'
         AND    hps.party_Site_Id           = selection.party_site_id
         AND    hpp.party_id                = hps.party_id
         AND    hca.cust_account_id         = selection.cust_account_id
         AND    hca.account_number          = selection.account_number
         AND    hcas.cust_account_id        = hca.cust_account_id
         AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
         AND    hcas.party_site_id          = selection.party_site_id
         AND    hcas.org_id                 = selection.org_id
         AND    mhr.migration_set_id        = pt_i_MigrationSetID;
/*		 
         AND    EXISTS ( SELECT 1
                         FROM   xxmx_stg.xxmx_hz_parties_stg hpp2
                         WHERE  hpp2.migration_set_id =  pt_i_MigrationSetID
                         AND    hpp2.party_orig_system_reference = to_char(hpp.party_id));
*/
/*
         AND    NOT EXISTS (SELECT 1 
                            FROM   apps.hz_relationships@MXDM_NVIS_EXTRACT hzr
                            WHERE  hzr.subject_table_name = 'HZ_PARTIES'
                            AND    hzr.subject_type = hpp.party_type
                            AND    hzr.subject_id   = hpp.party_id
                            AND    hzr.relationship_code like '%CONTACT%');
*/                            
     --
     -- #6 Relationship Source - Imp Contacts - per relationship
     --                    
         INSERT INTO xxmx_stg.xxmx_hz_org_contacts_stg
         (   
                migration_set_id, 
                migration_set_name, 
                migration_status,
                rel_orig_system,
                rel_orig_system_reference
         )	
         SELECT DISTINCT
                  mhr.migration_set_id migration_set_id, 
                  mhr.migration_set_name migration_set_name, 
                  'EXTRACTED' migration_status,
                  gct_OrigSystem rel_orig_system,
                  'XXDM-EB-EMAIL-'||hps.party_site_id rel_orig_system_reference
         FROM   (SELECT distinct account_party_id party_id, party_site_id, cust_account_id, account_number, cust_acct_site_id, org_id
                 FROM XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101')              selection
                ,xxmx_migration_headers                          mhr
                ,apps.hz_contact_points@MXDM_NVIS_EXTRACT        hcp
                ,apps.hz_party_sites@MXDM_NVIS_EXTRACT           hps
                ,apps.hz_parties@MXDM_NVIS_EXTRACT               hpp
                ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT         hca
                ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT   hcas              
         WHERE  1 = 1
         AND    hcp.owner_table_id(+)       = selection.party_site_id
         AND    hcp.owner_table_name(+)     = 'HZ_PARTY_SITES'
         AND    hcp.status(+)               = 'A'
         AND    hcp.primary_flag(+)         = 'Y'
         AND    hcp.contact_point_type(+)   = 'EMAIL'
         AND    hps.party_Site_Id           = selection.party_site_id
         AND    hpp.party_id                = hps.party_id
         AND    hca.cust_account_id         = selection.cust_account_id
         AND    hca.account_number          = selection.account_number
         AND    hcas.cust_account_id        = hca.cust_account_id
         AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
         AND    hcas.party_site_id          = selection.party_site_id
         AND    hcas.org_id                 = selection.org_id
         AND    mhr.migration_set_id        = pt_i_MigrationSetID;
/*		 
         AND    EXISTS ( SELECT 1
                         FROM   xxmx_stg.xxmx_hz_parties_stg hpp2
                         WHERE  hpp2.migration_set_id =  pt_i_MigrationSetID
                         AND    hpp2.party_orig_system_reference = to_char(hpp.party_id));
*/
/*
         AND    NOT EXISTS (SELECT 1 
                            FROM   apps.hz_relationships@MXDM_NVIS_EXTRACT hzr
                            WHERE  hzr.subject_table_name = 'HZ_PARTIES'
                            AND    hzr.subject_type = hpp.party_type
                            AND    hzr.subject_id   = hpp.party_id
                            AND    hzr.relationship_code like '%CONTACT%');
*/
     --
     -- #7 Roles/Responsibility - 1 per site / role : DUN / STMTS / BILL_TO
     --
         INSERT INTO xxmx_stg.xxmx_hz_role_resps_stg
         (
                  migration_set_id, 
                  migration_set_name, 
                  migration_status,
                  cust_contact_orig_system,
                  cust_contact_orig_sys_ref,                            
                  role_resp_orig_system,
                  role_resp_orig_sys_ref,
                  responsibility_type,
                  primary_flag
         )
         SELECT  DISTINCT
                  mhr.migration_set_id migration_set_id, 
                  mhr.migration_set_name migration_set_name, 
                 'EXTRACTED' migration_status,
                 gct_OrigSystem cust_contact_orig_system,
                 'XXDM-EB-EMAIL-'||hps.party_site_id||'-'||hcas.cust_acct_site_id cust_contact_orig_sys_ref,                            
                 gct_OrigSystem role_resp_orig_system,
                 'XXDM-EB-EMAIL-'||hps.party_site_id||'-'||hcas.cust_acct_site_id||'-B' role_resp_orig_sys_ref,
                 'BILL_TO' responsibility_type,
                 'N' primary_flag
         FROM   (select distinct account_party_id party_id, party_site_id, cust_account_id, account_number, cust_acct_site_id, org_id
                 from XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101')              selection
                ,xxmx_migration_headers                          mhr
                ,apps.hz_contact_points@MXDM_NVIS_EXTRACT        hcp
                ,apps.hz_party_sites@MXDM_NVIS_EXTRACT           hps
                ,apps.hz_parties@MXDM_NVIS_EXTRACT               hpp
                ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT         hca
                ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT   hcas              
         WHERE  1 = 1
         AND    hcp.owner_table_id(+)       = selection.party_site_id
         AND    hcp.owner_table_name(+)     = 'HZ_PARTY_SITES'
         AND    hcp.status(+)               = 'A'
         AND    hcp.primary_flag(+)         = 'Y'
         AND    hcp.contact_point_type(+)   = 'EMAIL'
         AND    hps.party_Site_Id           = selection.party_site_id
         AND    hpp.party_id                = hps.party_id
         AND    hca.cust_account_id         = selection.cust_account_id
         AND    hca.account_number          = selection.account_number
         AND    hcas.cust_account_id        = hca.cust_account_id
         AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
         AND    hcas.party_site_id          = selection.party_site_id
         AND    hcas.org_id                 = selection.org_id
         AND    mhr.migration_set_id        = pt_i_MigrationSetID
/*		 
         AND    EXISTS ( SELECT 1
                         FROM   xxmx_stg.xxmx_hz_parties_stg hpp2
                         WHERE  hpp2.migration_set_id =  pt_i_MigrationSetID
                         AND    hpp2.party_orig_system_reference = to_char(hpp.party_id))
*/
/*
         AND    NOT EXISTS (SELECT 1 
                            FROM   apps.hz_relationships@MXDM_NVIS_EXTRACT hzr
                            WHERE  hzr.subject_table_name = 'HZ_PARTIES'
                            AND    hzr.subject_type = hpp.party_type
                            AND    hzr.subject_id   = hpp.party_id
                            AND    hzr.relationship_code like '%CONTACT%')
*/
         UNION                    
         SELECT  DISTINCT
                  mhr.migration_set_id migration_set_id, 
                  mhr.migration_set_name migration_set_name, 
                 'EXTRACTED' migration_status,
                 gct_OrigSystem cust_contact_orig_system,
                 'XXDM-EB-EMAIL-'||hps.party_site_id||'-'||hcas.cust_acct_site_id cust_contact_orig_sys_ref,                            
                 gct_OrigSystem role_resp_orig_system,
                 'XXDM-EB-EMAIL-'||hps.party_site_id||'-'||hcas.cust_acct_site_id||'-D' role_resp_orig_sys_ref,
                 'DUN' responsibility_type,
                 'N' primary_flag
         FROM   (select distinct account_party_id party_id, party_site_id, cust_account_id, account_number, cust_acct_site_id, org_id
                 from XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101')             selection
                ,xxmx_migration_headers                          mhr
                ,apps.hz_contact_points@MXDM_NVIS_EXTRACT        hcp
                ,apps.hz_party_sites@MXDM_NVIS_EXTRACT           hps
                ,apps.hz_parties@MXDM_NVIS_EXTRACT               hpp
                ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT         hca
                ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT   hcas              
         WHERE  1 = 1
         AND    hcp.owner_table_id(+)       = selection.party_site_id
         AND    hcp.owner_table_name(+)     = 'HZ_PARTY_SITES'
         AND    hcp.status(+)               = 'A'
         AND    hcp.primary_flag(+)         = 'Y'
         AND    hcp.contact_point_type(+)   = 'EMAIL'
         AND    hps.party_Site_Id           = selection.party_site_id
         AND    hpp.party_id                = hps.party_id
         AND    hca.cust_account_id         = selection.cust_account_id
         AND    hca.account_number          = selection.account_number
         AND    hcas.cust_account_id        = hca.cust_account_id
         AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
         AND    hcas.party_site_id          = selection.party_site_id
         AND    hcas.org_id                 = selection.org_id
         AND    mhr.migration_set_id        = pt_i_MigrationSetID
/*		 
         AND    EXISTS ( SELECT 1
                         FROM   xxmx_stg.xxmx_hz_parties_stg hpp2
                         WHERE  hpp2.migration_set_id =  pt_i_MigrationSetID
                         AND    hpp2.party_orig_system_reference = to_char(hpp.party_id))		 
*/
/*
         AND    NOT EXISTS (SELECT 1 
                            FROM   apps.hz_relationships@MXDM_NVIS_EXTRACT hzr
                            WHERE  hzr.subject_table_name = 'HZ_PARTIES'
                            AND    hzr.subject_type = hpp.party_type
                            AND    hzr.subject_id   = hpp.party_id
                            AND    hzr.relationship_code like '%CONTACT%')
*/
         UNION
         SELECT  DISTINCT
                mhr.migration_set_id migration_set_id, 
                mhr.migration_set_name migration_set_name, 
                 'EXTRACTED' migration_status,
                 gct_OrigSystem cust_contact_orig_system,
                 'XXDM-EB-EMAIL-'||hps.party_site_id||'-'||hcas.cust_acct_site_id cust_contact_orig_sys_ref,                           
                 gct_OrigSystem role_resp_orig_system,
                 'XXDM-EB-EMAIL-'||hps.party_site_id||'-'||hcas.cust_acct_site_id||'-S' role_resp_orig_sys_ref,
                 'STMTS' responsibility_type,
                 'N' primary_flag
         FROM   (select distinct account_party_id party_id, party_site_id, cust_account_id, account_number, cust_acct_site_id, org_id
                 from XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101')              selection
                ,xxmx_migration_headers                          mhr
                ,apps.hz_contact_points@MXDM_NVIS_EXTRACT        hcp
                ,apps.hz_party_sites@MXDM_NVIS_EXTRACT           hps
                ,apps.hz_parties@MXDM_NVIS_EXTRACT               hpp
                ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT         hca
                ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT   hcas              
         WHERE  1 = 1
         AND    hcp.owner_table_id(+)       = selection.party_site_id
         AND    hcp.owner_table_name(+)     = 'HZ_PARTY_SITES'
         AND    hcp.status(+)               = 'A'
         AND    hcp.primary_flag(+)         = 'Y'
         AND    hcp.contact_point_type(+)   = 'EMAIL'
         AND    hps.party_Site_Id           = selection.party_site_id
         AND    hpp.party_id                = hps.party_id
         AND    hca.cust_account_id         = selection.cust_account_id
         AND    hca.account_number          = selection.account_number
         AND    hcas.cust_account_id        = hca.cust_account_id
         AND    hcas.cust_acct_site_id      = selection.cust_acct_site_id
         AND    hcas.party_site_id          = selection.party_site_id
         AND    hcas.org_id                 = selection.org_id
         AND    mhr.migration_set_id        = pt_i_MigrationSetID;
/*		 
         AND    EXISTS ( SELECT 1
                         FROM   xxmx_stg.xxmx_hz_parties_stg hpp2
                         WHERE  hpp2.migration_set_id =  pt_i_MigrationSetID
                         AND    hpp2.party_orig_system_reference = to_char(hpp.party_id));
*/
/*
         AND    NOT EXISTS (SELECT 1 
                            FROM   apps.hz_relationships@MXDM_NVIS_EXTRACT hzr
                            WHERE  hzr.subject_table_name = 'HZ_PARTIES'
                            AND    hzr.subject_type = hpp.party_type
                            AND    hzr.subject_id   = hpp.party_id
                            AND    hzr.relationship_code like '%CONTACT%'); 	 
*/
     END;     
     --
     --
     /*
     *****************************************
     ** PROCEDURE: create_ship2_bill2_contacts
     **
     ** v1.1 - removed not exist as missing
     **        some contacts     
     *****************************************
     */
     PROCEDURE create_ship2_bill2_contacts(pt_i_MigrationSetID in xxmx_migration_headers.migration_set_id%TYPE)
     IS
     BEGIN

     --
     -- Create CONTACT Party x1
     --
         INSERT INTO xxmx_stg.xxmx_hz_parties_stg
         (
          migration_set_id,
          migration_set_name,
          migration_status,
          party_orig_system,
          party_orig_system_reference,
          party_type,
          party_number,
          party_usage_code,
          person_first_name,
          person_last_name  
         )
         SELECT distinct mhr.migration_set_id                                                migration_set_id,
                mhr.migration_set_name                                                       migration_set_name, 
                'EXTRACTED'                                                                  migratrion_status,
                gct_OrigSystem                                                               party_orig_system,
                'XXB2-'||BillToSite.cust_acct_site_id||'-'||ShipToSite.cust_acct_site_id     party_orig_system_reference,
                'PERSON'                                                                     party_type,
                'XXB2-'||BillToSite.cust_acct_site_id||'-'||ShipToSite.cust_acct_site_id     party_number,
                'ORG_CONTACT'                                                                party_usage_code,
                nvl(ShipToPty.person_first_name,ShipToPty.party_name)                        person_first_name, 
                nvl(ShipToPty.person_last_name,'ShipTo Contact')                             person_last_name
         FROM   (select distinct cust_account_id, account_number, account_party_id party_id, cust_acct_site_id, org_id
                         from XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101') selection
               ,xxmx_migration_headers                            mhr
               ,apps.hz_locations@MXDM_NVIS_EXTRACT               ShipToSiteLoc                  
               ,apps.hz_party_sites@MXDM_NVIS_EXTRACT             ShipToPtySite
               ,apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT      ShipToUses
               ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT     ShipToSite
               ,apps.hz_parties@MXDM_NVIS_EXTRACT                 ShipToPty
               ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT           ShipToCus
               ,apps.hz_party_usg_assignments@MXDM_NVIS_EXTRACT   BillToPtyUsg
               ,apps.hz_parties@MXDM_NVIS_EXTRACT                 BillToPty                  
               ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT     BillToSite
               ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT           BillToCus
         WHERE   1=1
         AND    BillToCus.cust_account_id     = selection.cust_account_id
         AND    BillToCus.account_number      = selection.account_number
         AND    BillToCus.attribute1 is not null
         AND    BillToSite.cust_account_id    = selection.cust_account_id
         AND    BillToSite.cust_acct_site_id  = selection.cust_acct_site_id
         AND    BillToSite.org_id             = selection.org_id		 
         AND    BillToPty.party_id            = BillToCus.party_id
         AND    BillToPty.status              = 'A'
         AND    BillToPtyUsg.party_id         = BillToCus.party_id
         AND    BillToPtyUsg.status_flag      = 'A'
         AND    BillToPtyUsg.party_usage_code = 'CUSTOMER'
         AND    upper(ShipToCus.attribute2)   = upper(BillToCus.attribute1)
         AND    ShipToSite.cust_account_id    = ShipToCus.cust_account_id
         AND    ShipToSite.status             = 'A'
         AND    ShipToPty.party_id            = ShipToCus.party_id
         AND    ShipToPty.status              = 'A'
         AND    ShipToPtySite.party_site_id = ShipToSite.party_site_id
         AND    ShipToSiteLoc.location_id = ShipToPtySite.location_id
         AND    ShipToUses.cust_acct_site_id = ShipToSite.cust_acct_site_id
         AND    ShipToUses.org_id            = ShipToSite.org_id
         AND    ShipToUses.site_use_code = 'SHIP_TO'
         AND    ShipToUses.primary_flag = 'Y'
         AND    ShipToUses.status = 'A'
         AND    mhr.migration_set_id  = pt_i_MigrationSetID;
/*		 
         AND    EXISTS ( SELECT 1
                         FROM   xxmx_stg.xxmx_hz_parties_stg hpp2
                         WHERE  hpp2.migration_set_id =  pt_i_MigrationSetID
                         AND    hpp2.party_orig_system_reference = to_char(BillToPty.party_id));
*/
/*						 
        AND    NOT EXISTS (SELECT 1 
                            FROM   apps.hz_relationships@MXDM_NVIS_EXTRACT hzr
                            WHERE  hzr.subject_table_name = 'HZ_PARTIES'
                            AND    hzr.subject_type = BillToPty.party_type
                            AND    hzr.subject_id   = BillToPty.party_id
                            AND    hzr.relationship_code like '%CONTACT%');
*/
     --
     -- Create CONTACT Party Site x1
     --
         INSERT INTO XXMX_STG.xxmx_hz_party_sites_stg
         (
             migration_set_id,
             migration_set_name, 
             migration_status,
             party_orig_system,
             party_orig_system_reference,
             site_orig_system,
             site_orig_system_reference,
             location_orig_system,
             location_orig_System_Reference,
             party_site_name,
             party_site_number,
             identifying_address_flag,
             rel_orig_system,
             rel_orig_system_reference
         )
         SELECT distinct
                mhr.migration_set_id                                                      migration_set_id,
                mhr.migration_set_name                                                    migration_set_name, 
                'EXTRACTED'                                                               migratrion_status,
                gct_OrigSystem                                                            party_orig_system,
                'XXB2-'||BillToSite.cust_acct_site_id||'-'||ShipToSite.cust_acct_site_id  party_orig_system_reference,
                gct_OrigSystem                                                            site_orig_system,
                'XXB2-'||BillToSite.cust_acct_site_id||'-'||ShipToSite.cust_acct_site_id  site_orig_system_reference,
                gct_OrigSystem                                                            location_orig_system,
                'XXB2-'||BillToSite.cust_acct_site_id||'-'||ShipToSite.cust_acct_site_id  location_orig_System_Reference,
                'Ship To Contact'                                                         party_site_name,
                'XXB2-'||BillToSite.cust_acct_site_id||'-'||ShipToSite.cust_acct_site_id  party_site_number,
                'Y'                                                                       identifying_address_flag,
                gct_OrigSystem                                                            rel_orig_system,
                'XXB2-'||BillToSite.cust_acct_site_id||'-'||ShipToSite.cust_acct_site_id  rel_orig_system_reference
         FROM   (select distinct cust_account_id, account_number, account_party_id party_id, cust_acct_site_id, org_id
                         from XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101') selection
               ,xxmx_migration_headers                            mhr
               ,apps.hz_locations@MXDM_NVIS_EXTRACT               ShipToSiteLoc                  
               ,apps.hz_party_sites@MXDM_NVIS_EXTRACT             ShipToPtySite
               ,apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT      ShipToUses
               ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT     ShipToSite
               ,apps.hz_parties@MXDM_NVIS_EXTRACT                 ShipToPty
               ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT           ShipToCus
               ,apps.hz_party_usg_assignments@MXDM_NVIS_EXTRACT   BillToPtyUsg
               ,apps.hz_parties@MXDM_NVIS_EXTRACT                 BillToPty                  
               ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT     BillToSite
               ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT           BillToCus
         WHERE   1=1
         AND    BillToCus.cust_account_id     = selection.cust_account_id
         AND    BillToCus.account_number      = selection.account_number
         AND    BillToCus.attribute1 is not null
         AND    BillToSite.cust_account_id    = selection.cust_account_id
         AND    BillToSite.cust_acct_site_id  = selection.cust_acct_site_id
         AND    BillToSite.org_id             = selection.org_id
         AND    BillToPty.party_id            = BillToCus.party_id
         AND    BillToPty.status              = 'A'
         AND    BillToPtyUsg.party_id         = BillToCus.party_id
         AND    BillToPtyUsg.status_flag      = 'A'
         AND    BillToPtyUsg.party_usage_code = 'CUSTOMER'
         AND    upper(ShipToCus.attribute2)   = upper(BillToCus.attribute1)
         AND    ShipToSite.cust_account_id = ShipToCus.cust_account_id
         AND    ShipToSite.status = 'A'
         AND    ShipToPty.party_id            = ShipToCus.party_id
         AND    ShipToPty.status              = 'A'
         AND    ShipToPtySite.party_site_id = ShipToSite.party_site_id
         AND    ShipToSiteLoc.location_id = ShipToPtySite.location_id
         AND    ShipToUses.cust_acct_site_id = ShipToSite.cust_acct_site_id
         AND    ShipToUses.org_id            = ShipToSite.org_id
         AND    ShipToUses.site_use_code = 'SHIP_TO'
         AND    ShipToUses.primary_flag = 'Y'
         AND    ShipToUses.status = 'A'
         AND    mhr.migration_set_id  = pt_i_MigrationSetID;
/*		 
         AND    EXISTS ( SELECT 1
                         FROM   xxmx_stg.xxmx_hz_parties_stg hpp2
                         WHERE  hpp2.migration_set_id =  pt_i_MigrationSetID
                         AND    hpp2.party_orig_system_reference = to_char(BillToPty.party_id));
*/
/*						 
         AND    NOT EXISTS (SELECT 1 
                            FROM   apps.hz_relationships@MXDM_NVIS_EXTRACT hzr
                            WHERE  hzr.subject_table_name = 'HZ_PARTIES'
                            AND    hzr.subject_type = BillToPty.party_type
                            AND    hzr.subject_id   = BillToPty.party_id
                            AND    hzr.relationship_code like '%CONTACT%');
*/
							--
     -- Create Account Contacts - 1 per customer site
     --
         INSERT INTO xxmx_stg.xxmx_hz_cust_acct_contacts_stg
         (
             migration_set_id, 
             migration_set_name, 
             migration_status,
             cust_orig_system,
             cust_orig_system_reference,
             cust_site_orig_system,
             cust_site_orig_sys_ref,
             cust_contact_orig_system,
             cust_contact_orig_sys_ref,
             role_type,
             primary_flag,
             rel_orig_system,
             rel_orig_system_reference
         )
         SELECT distinct
                mhr.migration_set_id                                                       migration_set_id,
                mhr.migration_set_name                                                     migration_set_name, 
                'EXTRACTED'                                                                migratrion_status,
                gct_OrigSystem                                                             cust_orig_system,
                BillToCus.account_number                                                   cust_orig_system_reference,
                gct_OrigSystem                                                             cust_site_orig_system,
                BillToSite.cust_account_id||'-'||BillToSite.cust_acct_site_id              cust_site_orig_sys_ref,
                gct_OrigSystem                                                             cust_contact_orig_system,
                'XXB2-'||BillToSite.cust_acct_site_id||'-'||ShipToSite.cust_acct_site_id   cust_contact_orig_sys_ref,
                'CONTACT'                                                                  role_type,
                'N'                                                                        primary_indicator,
                gct_OrigSystem                                                             rel_orig_system,
                'XXB2-'||BillToSite.cust_acct_site_id||'-'||ShipToSite.cust_acct_site_id   rel_orig_system_reference    
         FROM   (select distinct cust_account_id, account_number, account_party_id party_id, cust_acct_site_id, org_id
                         from XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101') selection
               ,xxmx_migration_headers                            mhr
               ,apps.hz_locations@MXDM_NVIS_EXTRACT               ShipToSiteLoc                  
               ,apps.hz_party_sites@MXDM_NVIS_EXTRACT             ShipToPtySite
               ,apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT      ShipToUses
               ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT     ShipToSite
               ,apps.hz_parties@MXDM_NVIS_EXTRACT                 ShipToPty
               ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT           ShipToCus
               ,apps.hz_party_usg_assignments@MXDM_NVIS_EXTRACT   BillToPtyUsg
               ,apps.hz_parties@MXDM_NVIS_EXTRACT                 BillToPty                  
               ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT     BillToSite
               ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT           BillToCus
         WHERE   1=1
         AND    BillToCus.cust_account_id     = selection.cust_account_id
         AND    BillToCus.account_number      = selection.account_number
         AND    BillToCus.attribute1 is not null
         AND    BillToSite.cust_account_id    = selection.cust_account_id
         AND    BillToSite.cust_acct_site_id  = selection.cust_acct_site_id
         AND    BillToSite.org_id             = selection.org_id
         AND    BillToPty.party_id            = BillToCus.party_id
         AND    BillToPty.status              = 'A'
         AND    BillToPtyUsg.party_id         = BillToCus.party_id
         AND    BillToPtyUsg.status_flag      = 'A'
         AND    BillToPtyUsg.party_usage_code = 'CUSTOMER'
         AND    upper(ShipToCus.attribute2)   = upper(BillToCus.attribute1)
         AND    ShipToSite.cust_account_id = ShipToCus.cust_account_id
         AND    ShipToSite.status = 'A'
         AND    ShipToPty.party_id            = ShipToCus.party_id
         AND    ShipToPty.status              = 'A'
         AND    ShipToPtySite.party_site_id = ShipToSite.party_site_id
         AND    ShipToSiteLoc.location_id = ShipToPtySite.location_id
         AND    ShipToUses.cust_acct_site_id = ShipToSite.cust_acct_site_id
         AND    ShipToUses.org_id            = ShipToSite.org_id         
         AND    ShipToUses.site_use_code = 'SHIP_TO'
         AND    ShipToUses.primary_flag = 'Y'
         AND    ShipToUses.status = 'A'
         AND    mhr.migration_set_id  = pt_i_MigrationSetID;
/*		 
         AND    EXISTS ( SELECT 1
                         FROM   xxmx_stg.xxmx_hz_parties_stg hpp2
                         WHERE  hpp2.migration_set_id =  pt_i_MigrationSetID
                         AND    hpp2.party_orig_system_reference = to_char(BillToPty.party_id));		 
*/
/*
         AND    NOT EXISTS (SELECT 1 
                            FROM   apps.hz_relationships@MXDM_NVIS_EXTRACT hzr
                            WHERE  hzr.subject_table_name = 'HZ_PARTIES'
                            AND    hzr.subject_type = BillToPty.party_type
                            AND    hzr.subject_id   = BillToPty.party_id
                            AND    hzr.relationship_code like '%CONTACT%');
*/
							--
     -- Create Contact Role x1
     --
         INSERT INTO xxmx_stg.xxmx_hz_org_contact_roles_stg
         (
                migration_set_id, 
                migration_set_name, 
                migration_status,
                contact_role_orig_system,
                contact_role_orig_sys_ref,
                rel_orig_system,
                rel_orig_system_reference,
                role_type,
                role_level,
                primary_flag,
                primary_contact_per_role_type
         )
         SELECT distinct
                mhr.migration_set_id                                                       migration_set_id,
                mhr.migration_set_name                                                     migration_set_name, 
                'EXTRACTED'                                                                migratrion_status,
                gct_OrigSystem                                                             contact_role_orig_system,
                'XXB2-'||BillToSite.cust_acct_site_id||'-'||ShipToSite.cust_acct_site_id   contact_role_orig_sys_ref,
                gct_OrigSystem                                                             rel_orig_system,
                'XXB2-'||BillToSite.cust_acct_site_id||'-'||ShipToSite.cust_acct_site_id   rel_orig_system_reference,
                'CONTACT'                                                                  role_type,
                'N'                                                                        role_level,
                'N'                                                                        primary_flag,
                'N'                                                                        primary_contact_per_role_type
         FROM   (select distinct cust_account_id, account_number, account_party_id party_id, cust_acct_site_id, org_id
                         from XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101') selection
               ,xxmx_migration_headers                            mhr
               ,apps.hz_locations@MXDM_NVIS_EXTRACT               ShipToSiteLoc                  
               ,apps.hz_party_sites@MXDM_NVIS_EXTRACT             ShipToPtySite
               ,apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT      ShipToUses
               ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT     ShipToSite
               ,apps.hz_parties@MXDM_NVIS_EXTRACT                 ShipToPty
               ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT           ShipToCus
               ,apps.hz_party_usg_assignments@MXDM_NVIS_EXTRACT   BillToPtyUsg
               ,apps.hz_parties@MXDM_NVIS_EXTRACT                 BillToPty                  
               ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT     BillToSite
               ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT           BillToCus
         WHERE   1=1
         AND    BillToCus.cust_account_id     = selection.cust_account_id
         AND    BillToCus.account_number      = selection.account_number
         AND    BillToCus.attribute1 is not null
         AND    BillToSite.cust_account_id    = selection.cust_account_id
         AND    BillToSite.cust_acct_site_id  = selection.cust_acct_site_id
         AND    BillToSite.org_id             = selection.org_id		 
         AND    BillToPty.party_id            = BillToCus.party_id
         AND    BillToPty.status              = 'A'
         AND    BillToPtyUsg.party_id         = BillToCus.party_id
         AND    BillToPtyUsg.status_flag      = 'A'
         AND    BillToPtyUsg.party_usage_code = 'CUSTOMER'
         AND    upper(ShipToCus.attribute2)   = upper(BillToCus.attribute1)
         AND    ShipToSite.cust_account_id = ShipToCus.cust_account_id
         AND    ShipToSite.status = 'A'
         AND    ShipToPty.party_id            = ShipToCus.party_id
         AND    ShipToPty.status              = 'A'
         AND    ShipToPtySite.party_site_id = ShipToSite.party_site_id
         AND    ShipToSiteLoc.location_id = ShipToPtySite.location_id
         AND    ShipToUses.cust_acct_site_id = ShipToSite.cust_acct_site_id
         AND    ShipToUses.org_id            = ShipToSite.org_id
         AND    ShipToUses.site_use_code = 'SHIP_TO'
         AND    ShipToUses.primary_flag = 'Y'
         AND    ShipToUses.status = 'A'
         AND    mhr.migration_set_id  = pt_i_MigrationSetID;
/*
         AND    EXISTS ( SELECT 1
                         FROM   xxmx_stg.xxmx_hz_parties_stg hpp2
                         WHERE  hpp2.migration_set_id =  pt_i_MigrationSetID
                         AND    hpp2.party_orig_system_reference = to_char(BillToPty.party_id));		 
*/
/*
         AND    NOT EXISTS (SELECT 1 
                            FROM   apps.hz_relationships@MXDM_NVIS_EXTRACT hzr
                            WHERE  hzr.subject_table_name = 'HZ_PARTIES'
                            AND    hzr.subject_type = BillToPty.party_type
                            AND    hzr.subject_id   = BillToPty.party_id
                            AND    hzr.relationship_code like '%CONTACT%');                            
*/
							--
     -- Create Contacts x1
     --
         INSERT INTO xxmx_stg.xxmx_hz_org_contacts_stg
         (
                migration_set_id, 
                migration_set_name, 
                migration_status,
                rel_orig_system,
                rel_orig_system_reference
         )
         SELECT distinct
                mhr.migration_set_id                                                        migration_set_id,
                mhr.migration_set_name                                                      migration_set_name, 
                'EXTRACTED'                                                                 migratrion_status,
                gct_OrigSystem                                                              rel_orig_system,
                'XXB2-'||BillToSite.cust_acct_site_id||'-'||ShipToSite.cust_acct_site_id    rel_orig_system_reference
         FROM   (select distinct cust_account_id, account_number, account_party_id party_id, cust_acct_site_id, org_id
                         from XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101') selection
               ,xxmx_migration_headers                            mhr
               ,apps.hz_locations@MXDM_NVIS_EXTRACT               ShipToSiteLoc                  
               ,apps.hz_party_sites@MXDM_NVIS_EXTRACT             ShipToPtySite
               ,apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT      ShipToUses
               ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT     ShipToSite
               ,apps.hz_parties@MXDM_NVIS_EXTRACT                 ShipToPty
               ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT           ShipToCus
               ,apps.hz_party_usg_assignments@MXDM_NVIS_EXTRACT   BillToPtyUsg
               ,apps.hz_parties@MXDM_NVIS_EXTRACT                 BillToPty                  
               ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT     BillToSite
               ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT           BillToCus
         WHERE   1=1
         AND    BillToCus.cust_account_id     = selection.cust_account_id
         AND    BillToCus.account_number      = selection.account_number
         AND    BillToCus.attribute1 is not null
         AND    BillToSite.cust_account_id    = selection.cust_account_id
         AND    BillToSite.cust_acct_site_id  = selection.cust_acct_site_id
         AND    BillToSite.org_id             = selection.org_id		 
         AND    BillToPty.party_id            = BillToCus.party_id
         AND    BillToPty.status              = 'A'
         AND    BillToPtyUsg.party_id         = BillToCus.party_id
         AND    BillToPtyUsg.status_flag      = 'A'
         AND    BillToPtyUsg.party_usage_code = 'CUSTOMER'
         AND    upper(ShipToCus.attribute2)   = upper(BillToCus.attribute1)
         AND    ShipToSite.cust_account_id = ShipToCus.cust_account_id
         AND    ShipToSite.status = 'A'
         AND    ShipToPty.party_id            = ShipToCus.party_id
         AND    ShipToPty.status              = 'A'
         AND    ShipToPtySite.party_site_id = ShipToSite.party_site_id
         AND    ShipToSiteLoc.location_id = ShipToPtySite.location_id
         AND    ShipToUses.cust_acct_site_id = ShipToSite.cust_acct_site_id
         AND    ShipToUses.org_id            = ShipToSite.org_id
         AND    ShipToUses.site_use_code = 'SHIP_TO'
         AND    ShipToUses.primary_flag = 'Y'
         AND    ShipToUses.status = 'A'
         AND    mhr.migration_set_id  = pt_i_MigrationSetID;
/*
         AND    EXISTS ( SELECT 1
                         FROM   xxmx_stg.xxmx_hz_parties_stg hpp2
                         WHERE  hpp2.migration_set_id =  pt_i_MigrationSetID
                         AND    hpp2.party_orig_system_reference = to_char(BillToPty.party_id));
*/
/*
         AND    NOT EXISTS (SELECT 1 
                            FROM   apps.hz_relationships@MXDM_NVIS_EXTRACT hzr
                            WHERE  hzr.subject_table_name = 'HZ_PARTIES'
                            AND    hzr.subject_type = BillToPty.party_type
                            AND    hzr.subject_id   = BillToPty.party_id
                            AND    hzr.relationship_code like '%CONTACT%'); 
*/
							--
     -- Create Contact Location x1
     --
         INSERT INTO XXMX_STG.xxmx_hz_locations_stg
         (
                migration_set_id,
                migration_set_name, 
                migration_status,
                location_orig_system,
                location_orig_system_reference,
                country,
                address1,
                address2,
                address3,
                address4,
                city,
                state,
                province,
                county,
                postal_code,
                timezone_code,
                description				   
         )
         SELECT distinct 
                mhr.migration_set_id                        migration_set_id,
                mhr.migration_set_name                      migration_set_name, 
                'EXTRACTED'                                 migratrion_status,
                gct_OrigSystem                              location_orig_system,
                'XXB2-'||BillToSite.cust_acct_site_id||'-'||ShipToSite.cust_acct_site_id  location_orig_system_reference,               
                'GB'                                        country,
                ShipToSiteLoc.address1                      address1,
                ShipToSiteLoc.address2                      address2,
                ShipToSiteLoc.address3                      address3,
                ShipToSiteLoc.address4                      address4,
                ShipToSiteLoc.city                          city,
                ShipToSiteLoc.state                         state,
                ShipToSiteLoc.province                      province,
                ShipToSiteLoc.county                        county,
                ShipToSiteLoc.postal_code                   postal_code,
                'BST'                                       timezone_code,
                'Ship To Contact'                           description
         FROM   (select distinct cust_account_id, account_number, account_party_id party_id, cust_acct_site_id, org_id
                         from XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101') selection
               ,xxmx_migration_headers                            mhr
               ,apps.hz_locations@MXDM_NVIS_EXTRACT               ShipToSiteLoc                  
               ,apps.hz_party_sites@MXDM_NVIS_EXTRACT             ShipToPtySite
               ,apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT      ShipToUses
               ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT     ShipToSite
               ,apps.hz_parties@MXDM_NVIS_EXTRACT                 ShipToPty
               ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT           ShipToCus
               ,apps.hz_party_usg_assignments@MXDM_NVIS_EXTRACT   BillToPtyUsg
               ,apps.hz_parties@MXDM_NVIS_EXTRACT                 BillToPty                  
               ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT     BillToSite
               ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT           BillToCus
         WHERE   1=1
         AND    BillToCus.cust_account_id     = selection.cust_account_id
         AND    BillToCus.account_number      = selection.account_number
         AND    BillToCus.attribute1 is not null
         AND    BillToSite.cust_account_id    = selection.cust_account_id
         AND    BillToSite.cust_acct_site_id  = selection.cust_acct_site_id
         AND    BillToSite.org_id             = selection.org_id		 
         AND    BillToPty.party_id            = BillToCus.party_id
         AND    BillToPty.status              = 'A'
         AND    BillToPtyUsg.party_id         = BillToCus.party_id
         AND    BillToPtyUsg.status_flag      = 'A'
         AND    BillToPtyUsg.party_usage_code = 'CUSTOMER'
         AND    upper(ShipToCus.attribute2)   = upper(BillToCus.attribute1)
         AND    ShipToSite.cust_account_id = ShipToCus.cust_account_id
         AND    ShipToSite.status = 'A'
         AND    ShipToPty.party_id            = ShipToCus.party_id
         AND    ShipToPty.status              = 'A'
         AND    ShipToPtySite.party_site_id = ShipToSite.party_site_id
         AND    ShipToSiteLoc.location_id = ShipToPtySite.location_id
         AND    ShipToUses.cust_acct_site_id = ShipToSite.cust_acct_site_id
         AND    ShipToUses.org_id            = ShipToSite.org_id
         AND    ShipToUses.site_use_code = 'SHIP_TO'
         AND    ShipToUses.primary_flag = 'Y'
         AND    ShipToUses.status = 'A'
         AND    mhr.migration_set_id  = pt_i_MigrationSetID;
/*		 
         AND    EXISTS ( SELECT 1
                         FROM   xxmx_stg.xxmx_hz_parties_stg hpp2
                         WHERE  hpp2.migration_set_id =  pt_i_MigrationSetID
                         AND    hpp2.party_orig_system_reference = to_char(BillToPty.party_id));		 
*/
/*
         AND    NOT EXISTS (SELECT 1 
                            FROM   apps.hz_relationships@MXDM_NVIS_EXTRACT hzr
                            WHERE  hzr.subject_table_name = 'HZ_PARTIES'
                            AND    hzr.subject_type = BillToPty.party_type
                            AND    hzr.subject_id   = BillToPty.party_id
                            AND    hzr.relationship_code like '%CONTACT%'); 
*/
							--
     -- Create Relationship x1
     --
         INSERT INTO xxmx_stg.xxmx_hz_relationships_stg
         (
             migration_set_id, 
             migration_set_name, 
             migration_status,
             sub_orig_system,
             sub_orig_system_reference,
             obj_orig_system,
             obj_orig_system_reference,
             relationship_type,
             relationship_code,
             start_date,
             end_date,
             subject_type,
             object_type,
             rel_orig_system,
             rel_orig_system_reference
         )
         SELECT distinct
                mhr.migration_set_id                        migration_set_id,
                mhr.migration_set_name                      migration_set_name, 
                'EXTRACTED'                                 migratrion_status,
                gct_OrigSystem                              sub_orig_system,
                'XXB2-'||BillToSite.cust_acct_site_id||'-'||ShipToSite.cust_acct_site_id   sub_orig_system_reference,                   
                gct_OrigSystem                              obj_orig_system,
                BillToPty.party_id                          obj_orig_system_reference,                   
                'CONTACT'                                   relationship_type, 
                'CONTACT_OF'                                relationship_code,
                trunc(sysdate)                              start_date,
                to_date('31/12/4712','DD/MM/YYYY')          end_date,
                'PERSON'                                    subject_type,
                BillToPty.party_type                        object_type,
                gct_OrigSystem                              rel_orig_system,
                'XXB2-'||BillToSite.cust_acct_site_id||'-'||ShipToSite.cust_acct_site_id           rel_orig_system_reference
         FROM   (select distinct cust_account_id, account_number, account_party_id party_id, cust_acct_site_id, org_id
                         from XXMX_CUSTOMER_SCOPE_TEMP_STG where org_id = '101') selection
               ,xxmx_migration_headers                            mhr
               ,apps.hz_locations@MXDM_NVIS_EXTRACT               ShipToSiteLoc                  
               ,apps.hz_party_sites@MXDM_NVIS_EXTRACT             ShipToPtySite
               ,apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT      ShipToUses
               ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT     ShipToSite
               ,apps.hz_parties@MXDM_NVIS_EXTRACT                 ShipToPty
               ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT           ShipToCus
               ,apps.hz_party_usg_assignments@MXDM_NVIS_EXTRACT   BillToPtyUsg
               ,apps.hz_parties@MXDM_NVIS_EXTRACT                 BillToPty                  
               ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT     BillToSite
               ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT           BillToCus
         WHERE   1=1
         AND    BillToCus.cust_account_id     = selection.cust_account_id
         AND    BillToCus.account_number      = selection.account_number
         AND    BillToCus.attribute1 is not null
         AND    BillToSite.cust_account_id    = selection.cust_account_id
         AND    BillToSite.cust_acct_site_id  = selection.cust_acct_site_id
         AND    BillToSite.org_id             = selection.org_id
         AND    BillToPty.party_id            = BillToCus.party_id
         AND    BillToPty.status              = 'A'
         AND    BillToPtyUsg.party_id         = BillToCus.party_id
         AND    BillToPtyUsg.status_flag      = 'A'
         AND    BillToPtyUsg.party_usage_code = 'CUSTOMER'
         AND    upper(ShipToCus.attribute2)   = upper(BillToCus.attribute1)
         AND    ShipToSite.cust_account_id = ShipToCus.cust_account_id
         AND    ShipToSite.status = 'A'
         AND    ShipToPty.party_id            = ShipToCus.party_id
         AND    ShipToPty.status              = 'A'
         AND    ShipToPtySite.party_site_id = ShipToSite.party_site_id
         AND    ShipToSiteLoc.location_id = ShipToPtySite.location_id
         AND    ShipToUses.cust_acct_site_id = ShipToSite.cust_acct_site_id
         AND    ShipToUses.org_id            = ShipToSite.org_id
         AND    ShipToUses.site_use_code = 'SHIP_TO'
         AND    ShipToUses.primary_flag = 'Y'
         AND    ShipToUses.status = 'A'
         AND    mhr.migration_set_id  = pt_i_MigrationSetID;
/*		 
         AND    EXISTS ( SELECT 1
                         FROM   xxmx_stg.xxmx_hz_parties_stg hpp2
                         WHERE  hpp2.migration_set_id =  pt_i_MigrationSetID
                         AND    hpp2.party_orig_system_reference = to_char(BillToPty.party_id));		 
*/
/*
         AND    NOT EXISTS (SELECT 1 
                            FROM   apps.hz_relationships@MXDM_NVIS_EXTRACT hzr
                            WHERE  hzr.subject_table_name = 'HZ_PARTIES'
                            AND    hzr.subject_type = BillToPty.party_type
                            AND    hzr.subject_id   = BillToPty.party_id
                            AND    hzr.relationship_code like '%CONTACT%');  
*/
							END;     
     --
     --
     --
     PROCEDURE delete_smbc_contact_recs(pt_i_MigrationSetID in xxmx_migration_headers.migration_set_id%TYPE) IS
     BEGIN
        --
        -- Role / Responsibilities
        --
        DELETE FROM XXMX_STG.xxmx_hz_role_resps_stg
        WHERE  migration_set_id = pt_i_MigrationSetID
        AND    cust_contact_orig_sys_ref not in 
        (
           SELECT cust_contact_orig_sys_ref
           FROM   XXMX_STG.xxmx_hz_cust_acct_contacts_stg
           WHERE  migration_set_id = pt_i_MigrationSetID
           AND    rel_orig_system_reference in 
          (
             SELECT distinct cac.rel_orig_system_reference
             FROM xxmx_stg.xxmx_hz_cust_accounts_stg acc,
                  XXMX_STG.xxmx_hz_cust_acct_sites_stg cas,
                  XXMX_STG.xxmx_hz_cust_acct_contacts_stg cac
             WHERE cas.migration_set_id = pt_i_MigrationSetID
             AND   cac.migration_set_id = pt_i_MigrationSetID 
             AND   acc.migration_set_id = pt_i_MigrationSetID 
             AND   cas.cust_site_orig_sys_ref = cac.cust_site_orig_sys_ref
             AND   acc.cust_orig_system_reference = cas.cust_orig_system_reference
             AND   cas.ou_name = 'Solihull Community Housing'
          )
        );

        --
        -- HZ ORG CONTACTS
        --
        DELETE  XXMX_STG.xxmx_hz_org_contacts_stg
        WHERE migration_set_id = pt_i_MigrationSetID
        AND   rel_orig_system_reference not in 
        (
             SELECT distinct cac.rel_orig_system_reference
             FROM xxmx_stg.xxmx_hz_cust_accounts_stg acc,
                  XXMX_STG.xxmx_hz_cust_acct_sites_stg cas,
                  XXMX_STG.xxmx_hz_cust_acct_contacts_stg cac
             WHERE cas.migration_set_id = pt_i_MigrationSetID
             AND   cac.migration_set_id = pt_i_MigrationSetID 
             AND   acc.migration_set_id = pt_i_MigrationSetID      
             AND   cas.cust_site_orig_sys_ref = cac.cust_site_orig_sys_ref
             AND   acc.cust_orig_system_reference = cas.cust_orig_system_reference
             AND   cas.ou_name = 'Solihull Community Housing'
        );


        --
        -- HZ ORG CONTACT Roles
        --
        DELETE  XXMX_STG.xxmx_hz_org_contact_roles_stg
        WHERE migration_set_id = pt_i_MigrationSetID
        AND   rel_orig_system_reference not in 
        (
             SELECT distinct cac.rel_orig_system_reference
             FROM xxmx_stg.xxmx_hz_cust_accounts_stg acc,
                  XXMX_STG.xxmx_hz_cust_acct_sites_stg cas,
                  XXMX_STG.xxmx_hz_cust_acct_contacts_stg cac
             WHERE cas.migration_set_id = pt_i_MigrationSetID
             AND   cac.migration_set_id = pt_i_MigrationSetID  
             AND   acc.migration_set_id = pt_i_MigrationSetID      
             AND   cas.cust_site_orig_sys_ref = cac.cust_site_orig_sys_ref
             AND   acc.cust_orig_system_reference = cas.cust_orig_system_reference
             AND   cas.ou_name = 'Solihull Community Housing'
        );


        --
        -- Contact Points
        --
        DELETE FROM XXMX_STG.xxmx_hz_contact_points_stg
        WHERE  migration_set_id = pt_i_MigrationSetID
        AND    rel_orig_system_reference not in 
        (
             SELECT distinct cac.rel_orig_system_reference
             FROM xxmx_stg.xxmx_hz_cust_accounts_stg acc,
                  XXMX_STG.xxmx_hz_cust_acct_sites_stg cas,
                  XXMX_STG.xxmx_hz_cust_acct_contacts_stg cac
             WHERE cas.migration_set_id = pt_i_MigrationSetID
             AND   cac.migration_set_id = pt_i_MigrationSetID  
             AND   acc.migration_set_id = pt_i_MigrationSetID      
             AND   cas.cust_site_orig_sys_ref = cac.cust_site_orig_sys_ref
             AND   acc.cust_orig_system_reference = cas.cust_orig_system_reference
             AND   cas.ou_name = 'Solihull Community Housing'
        );

        --
        -- Party Site uses
        --
        DELETE FROM XXMX_STG.xxmx_hz_party_site_uses_stg
        WHERE  migration_set_id = pt_i_MigrationSetID
        AND    party_orig_system_reference in 
        (
        SELECT sub_orig_system_reference
        FROM XXMX_STG.xxmx_hz_relationships_stg r1
        WHERE  migration_set_id = pt_i_MigrationSetID
        AND    rel_orig_system_reference not in
        (
             SELECT distinct cac.rel_orig_system_reference
             FROM xxmx_stg.xxmx_hz_cust_accounts_stg acc,
                  XXMX_STG.xxmx_hz_cust_acct_sites_stg cas,
                  XXMX_STG.xxmx_hz_cust_acct_contacts_stg cac
             WHERE cas.migration_set_id = pt_i_MigrationSetID
             AND   cac.migration_set_id = pt_i_MigrationSetID  
             AND   acc.migration_set_id = pt_i_MigrationSetID      
             AND   cas.cust_site_orig_sys_ref = cac.cust_site_orig_sys_ref
             AND   acc.cust_orig_system_reference = cas.cust_orig_system_reference
             AND   cas.ou_name = 'Solihull Community Housing'
        )
        AND not exists (SELECT 1 FROM XXMX_STG.xxmx_hz_cust_accounts_stg hca
                        WHERE migration_set_id = pt_i_MigrationSetID
                        AND hca.party_orig_system_reference = r1.sub_orig_system_reference)
        union
        SELECT obj_orig_system_reference
        FROM XXMX_STG.xxmx_hz_relationships_stg r2
        WHERE  migration_set_id = pt_i_MigrationSetID
        AND    rel_orig_system_reference not in 
        (
             SELECT distinct cac.rel_orig_system_reference
             FROM xxmx_stg.xxmx_hz_cust_accounts_stg acc,
                  XXMX_STG.xxmx_hz_cust_acct_sites_stg cas,
                  XXMX_STG.xxmx_hz_cust_acct_contacts_stg cac
             WHERE cas.migration_set_id = pt_i_MigrationSetID
             AND   cac.migration_set_id = pt_i_MigrationSetID  
             AND   acc.migration_set_id = pt_i_MigrationSetID      
             AND   cas.cust_site_orig_sys_ref = cac.cust_site_orig_sys_ref
             AND   acc.cust_orig_system_reference = cas.cust_orig_system_reference
             AND   cas.ou_name = 'Solihull Community Housing'
        )
        AND not exists (SELECT 1 FROM XXMX_STG.xxmx_hz_cust_accounts_stg hca
                        WHERE migration_set_id = pt_i_MigrationSetID
                        AND hca.party_orig_system_reference = r2.obj_orig_system_reference)
        );


        --
        -- Locations
        --
        DELETE FROM xxmx_stg.xxmx_hz_locations_stg
        WHERE  migration_set_id = pt_i_MigrationSetID
        AND    location_orig_system_reference in 
        (
        SELECT location_orig_system_reference FROM XXMX_STG.xxmx_hz_party_sites_stg
        WHERE  migration_set_id = pt_i_MigrationSetID
        AND    party_orig_system_reference in 
        (
        SELECT sub_orig_system_reference
        FROM XXMX_STG.xxmx_hz_relationships_stg r1
        WHERE  migration_set_id = pt_i_MigrationSetID
        AND    rel_orig_system_reference not in
        (
             SELECT distinct cac.rel_orig_system_reference
             FROM xxmx_stg.xxmx_hz_cust_accounts_stg acc,
                  XXMX_STG.xxmx_hz_cust_acct_sites_stg cas,
                  XXMX_STG.xxmx_hz_cust_acct_contacts_stg cac
             WHERE cas.migration_set_id = pt_i_MigrationSetID
             AND   cac.migration_set_id = pt_i_MigrationSetID  
             AND   acc.migration_set_id = pt_i_MigrationSetID      
             AND   cas.cust_site_orig_sys_ref = cac.cust_site_orig_sys_ref
             AND   acc.cust_orig_system_reference = cas.cust_orig_system_reference
             AND   cas.ou_name = 'Solihull Community Housing'
        )
        AND not exists (SELECT 1 FROM XXMX_STG.xxmx_hz_cust_accounts_stg hca
                        WHERE migration_set_id = pt_i_MigrationSetID
                        AND hca.party_orig_system_reference = r1.sub_orig_system_reference)
        union
        SELECT obj_orig_system_reference
        FROM XXMX_STG.xxmx_hz_relationships_stg r2
        WHERE  migration_set_id = pt_i_MigrationSetID
        AND    rel_orig_system_reference not in 
        (
             SELECT distinct cac.rel_orig_system_reference
             FROM xxmx_stg.xxmx_hz_cust_accounts_stg acc,
                  XXMX_STG.xxmx_hz_cust_acct_sites_stg cas,
                  XXMX_STG.xxmx_hz_cust_acct_contacts_stg cac
             WHERE cas.migration_set_id = pt_i_MigrationSetID
             AND   cac.migration_set_id = pt_i_MigrationSetID  
             AND   acc.migration_set_id = pt_i_MigrationSetID      
             AND   cas.cust_site_orig_sys_ref = cac.cust_site_orig_sys_ref
             AND   acc.cust_orig_system_reference = cas.cust_orig_system_reference
             AND   cas.ou_name = 'Solihull Community Housing'
        )
        AND not exists (SELECT 1 FROM XXMX_STG.xxmx_hz_cust_accounts_stg hca
                        WHERE migration_set_id = pt_i_MigrationSetID
                        AND hca.party_orig_system_reference = r2.obj_orig_system_reference)
        ));



        --
        -- Sites
        --
        DELETE FROM XXMX_STG.xxmx_hz_party_sites_stg
        WHERE  migration_set_id = pt_i_MigrationSetID
        AND    party_orig_system_reference in 
        (
        SELECT sub_orig_system_reference
        FROM XXMX_STG.xxmx_hz_relationships_stg r1
        WHERE  migration_set_id = pt_i_MigrationSetID
        AND    rel_orig_system_reference not in
        (
             SELECT distinct cac.rel_orig_system_reference
             FROM xxmx_stg.xxmx_hz_cust_accounts_stg acc,
                  XXMX_STG.xxmx_hz_cust_acct_sites_stg cas,
                  XXMX_STG.xxmx_hz_cust_acct_contacts_stg cac
             WHERE cas.migration_set_id = pt_i_MigrationSetID
             AND   cac.migration_set_id = pt_i_MigrationSetID  
             AND   acc.migration_set_id = pt_i_MigrationSetID      
             AND   cas.cust_site_orig_sys_ref = cac.cust_site_orig_sys_ref
             AND   acc.cust_orig_system_reference = cas.cust_orig_system_reference
             AND   cas.ou_name = 'Solihull Community Housing'
        )
        AND not exists (SELECT 1 FROM XXMX_STG.xxmx_hz_cust_accounts_stg hca
                        WHERE migration_set_id = pt_i_MigrationSetID
                        AND hca.party_orig_system_reference = r1.sub_orig_system_reference)
        union
        SELECT obj_orig_system_reference
        FROM XXMX_STG.xxmx_hz_relationships_stg r2
        WHERE  migration_set_id = pt_i_MigrationSetID
        AND    rel_orig_system_reference not in 
        (
             SELECT distinct cac.rel_orig_system_reference
             FROM xxmx_stg.xxmx_hz_cust_accounts_stg acc,
                  XXMX_STG.xxmx_hz_cust_acct_sites_stg cas,
                  XXMX_STG.xxmx_hz_cust_acct_contacts_stg cac
             WHERE cas.migration_set_id = pt_i_MigrationSetID
             AND   cac.migration_set_id = pt_i_MigrationSetID  
             AND   acc.migration_set_id = pt_i_MigrationSetID      
             AND   cas.cust_site_orig_sys_ref = cac.cust_site_orig_sys_ref
             AND   acc.cust_orig_system_reference = cas.cust_orig_system_reference
             AND   cas.ou_name = 'Solihull Community Housing'
        )
        AND not exists (SELECT 1 FROM XXMX_STG.xxmx_hz_cust_accounts_stg hca
                        WHERE migration_set_id = pt_i_MigrationSetID
                        AND hca.party_orig_system_reference = r2.obj_orig_system_reference)
        );


        --
        -- Parties
        --
        DELETE FROM XXMX_STG.xxmx_hz_parties_stg
        WHERE  migration_set_id = pt_i_MigrationSetID
        AND    party_orig_system_reference in 
        (
        SELECT sub_orig_system_reference
        FROM XXMX_STG.xxmx_hz_relationships_stg r1
        WHERE  migration_set_id = pt_i_MigrationSetID
        AND    rel_orig_system_reference not in
        (
             SELECT distinct cac.rel_orig_system_reference
             FROM xxmx_stg.xxmx_hz_cust_accounts_stg acc,
                  XXMX_STG.xxmx_hz_cust_acct_sites_stg cas,
                  XXMX_STG.xxmx_hz_cust_acct_contacts_stg cac
             WHERE cas.migration_set_id = pt_i_MigrationSetID
             AND   cac.migration_set_id = pt_i_MigrationSetID 
             AND   acc.migration_set_id = pt_i_MigrationSetID      
             AND   cas.cust_site_orig_sys_ref = cac.cust_site_orig_sys_ref
             AND   acc.cust_orig_system_reference = cas.cust_orig_system_reference
             AND   cas.ou_name = 'Solihull Community Housing'
        )
        AND not exists (SELECT 1 FROM XXMX_STG.xxmx_hz_cust_accounts_stg hca
                        WHERE migration_set_id = pt_i_MigrationSetID
                        AND hca.party_orig_system_reference = r1.sub_orig_system_reference)
        union
        SELECT obj_orig_system_reference
        FROM XXMX_STG.xxmx_hz_relationships_stg r2
        WHERE  migration_set_id = pt_i_MigrationSetID
        AND    rel_orig_system_reference not in 
        (
             SELECT distinct cac.rel_orig_system_reference
             FROM xxmx_stg.xxmx_hz_cust_accounts_stg acc,
                  XXMX_STG.xxmx_hz_cust_acct_sites_stg cas,
                  XXMX_STG.xxmx_hz_cust_acct_contacts_stg cac
             WHERE cas.migration_set_id = pt_i_MigrationSetID
             AND   cac.migration_set_id = pt_i_MigrationSetID  
             AND   acc.migration_set_id = pt_i_MigrationSetID 
             AND   cas.cust_site_orig_sys_ref = cac.cust_site_orig_sys_ref
             AND   acc.cust_orig_system_reference = cas.cust_orig_system_reference
             AND   cas.ou_name = 'Solihull Community Housing'
        )
        AND not exists (SELECT 1 FROM XXMX_STG.xxmx_hz_cust_accounts_stg hca
                        WHERE migration_set_id = pt_i_MigrationSetID
                        AND hca.party_orig_system_reference = r2.obj_orig_system_reference)
        );

        --
        -- Relationships
        --
        DELETE FROM XXMX_STG.xxmx_hz_relationships_stg
        WHERE  migration_set_id = pt_i_MigrationSetID
        AND    rel_orig_system_reference not in 
        (
             SELECT distinct cac.rel_orig_system_reference
             FROM xxmx_stg.xxmx_hz_cust_accounts_stg acc,
                  XXMX_STG.xxmx_hz_cust_acct_sites_stg cas,
                  XXMX_STG.xxmx_hz_cust_acct_contacts_stg cac
             WHERE cas.migration_set_id = pt_i_MigrationSetID
             AND   cac.migration_set_id = pt_i_MigrationSetID 
             AND   acc.migration_set_id = pt_i_MigrationSetID      
             AND   cas.cust_site_orig_sys_ref = cac.cust_site_orig_sys_ref
             AND   acc.cust_orig_system_reference = cas.cust_orig_system_reference
             AND   cas.ou_name = 'Solihull Community Housing'
        );


        --
        -- Cust Account Contacts
        --
           DELETE XXMX_STG.xxmx_hz_cust_acct_contacts_stg
           WHERE  migration_set_id = pt_i_MigrationSetID
           AND    rel_orig_system_reference not in 
          (
             SELECT distinct cac.rel_orig_system_reference
             FROM xxmx_stg.xxmx_hz_cust_accounts_stg acc,
                  XXMX_STG.xxmx_hz_cust_acct_sites_stg cas,
                  XXMX_STG.xxmx_hz_cust_acct_contacts_stg cac
             WHERE cas.migration_set_id = pt_i_MigrationSetID
             AND   cac.migration_set_id = pt_i_MigrationSetID 
             AND   acc.migration_set_id = pt_i_MigrationSetID      
             AND   cas.cust_site_orig_sys_ref = cac.cust_site_orig_sys_ref
             AND   acc.cust_orig_system_reference = cas.cust_orig_system_reference
             AND   cas.ou_name = 'Solihull Community Housing'
          );


/*
 * Superceded by the code above
 *
        DELETE FROM xxmx_stg.xxmx_parties_to_delete 
        WHERE   migration_set_id = pt_i_MigrationSetID;

        INSERT into xxmx_stg.xxmx_parties_to_delete
        SELECT pt_i_MigrationSetID migration_set_Id, p.party_orig_system_reference 
        FROM   XXMX_STG.xxmx_hz_parties_stg p
        WHERE  p.migration_set_id = pt_i_MigrationSetID
        AND    p.party_orig_system_reference in 
        (
           SELECT p1.party_orig_system_reference
           FROM   XXMX_STG.xxmx_hz_parties_stg p1
           WHERE  p1.migration_set_id = pt_i_MigrationSetID
           AND    not exists (SELECT 1 
		                      FROM   XXMX_STG.xxmx_hz_cust_accounts_stg acc
                              WHERE  acc.migration_set_id = pt_i_MigrationSetID
                              AND    acc.party_orig_system_reference = p1.party_orig_system_reference
		)
        minus
        SELECT p.party_orig_system_reference
        FROM   XXMX_STG.xxmx_hz_relationships_stg r,
               XXMX_STG.xxmx_hz_parties_stg p,
               XXMX_STG.xxmx_hz_party_sites_stg ps,
               XXMX_STG.xxmx_hz_cust_acct_sites_stg cas
        WHERE  cas.migration_set_id = pt_i_MigrationSetID
        AND    cas.ou_name = 'Solihull Community Housing' --'SOLIHULL';
        AND    ps.migration_set_id = pt_i_MigrationSetID
        AND    ps.site_orig_system_reference = cas.site_orig_system_reference
        AND    p.migration_set_id = pt_i_MigrationSetID
        AND    p.party_orig_system_reference = ps.party_orig_system_reference
        AND    (r.sub_orig_system_reference = p.party_orig_system_reference or 
                r.obj_orig_system_reference = p.party_orig_system_reference)
        AND  not exists (select 1 from xxmx_stg.xxmx_parties_to_delete x
                         where x.migration_set_id = pt_i_MigrationSetID
                         and   x.party_orig_system_reference = p.party_orig_system_reference)
        );

        --
        -- Role Resps
        --
        delete from xxmx_stg.xxmx_hz_role_resps_stg
        where migration_set_id = pt_i_MigrationSetID
        and   cust_contact_orig_sys_ref in
        (
        select cust_contact_orig_sys_ref
        from XXMX_STG.xxmx_hz_cust_acct_contacts_stg
        where migration_set_id= pt_i_MigrationSetID
        and   rel_orig_system_reference in
        (
        select rel_orig_system_reference
        from   XXMX_STG.xxmx_hz_relationships_stg
        where migration_set_id= pt_i_MigrationSetID
        and 
            ( sub_orig_system_reference in
              (
                 select party_orig_system_reference
                 from XXMX_STG.xxmx_parties_to_delete
                 where migration_set_id = pt_i_MigrationSetID
              )
              or
              obj_orig_system_reference in
              (
                 select party_orig_system_reference
                 from XXMX_STG.xxmx_parties_to_delete
                 where migration_set_id = pt_i_MigrationSetID
              )
			)
        )
        );
        --
        -- Cust Acc Contacts
        -- 
        delete XXMX_STG.xxmx_hz_cust_acct_contacts_stg
        where migration_set_id= pt_i_MigrationSetID
        and   rel_orig_system_reference in
        (
        select rel_orig_system_reference
        from   XXMX_STG.xxmx_hz_relationships_stg
        where migration_set_id= pt_i_MigrationSetID
        and 
            ( sub_orig_system_reference in
              (
                 select party_orig_system_reference
                 from XXMX_STG.xxmx_parties_to_delete
                 where migration_set_id = pt_i_MigrationSetID
              )
              or
              obj_orig_system_reference in
              (
                 select party_orig_system_reference
                 from XXMX_STG.xxmx_parties_to_delete
                 where migration_set_id = pt_i_MigrationSetID
              )
			));


        --
        -- xxmx_hz_org_contacts_stg
        --
        delete from xxmx_stg.xxmx_hz_org_contacts_stg
        where migration_set_id = pt_i_MigrationSetID
        and   rel_orig_system_reference in 
        (
        select rel_orig_system_reference
        from   XXMX_STG.xxmx_hz_relationships_stg
        where migration_set_id= pt_i_MigrationSetID
        and 
            ( sub_orig_system_reference in
              (
                 select party_orig_system_reference
                 from XXMX_STG.xxmx_parties_to_delete
                 where migration_set_id = pt_i_MigrationSetID
              )
              or
              obj_orig_system_reference in
              (
                 select party_orig_system_reference
                 from XXMX_STG.xxmx_parties_to_delete
                 where migration_set_id = pt_i_MigrationSetID
              )
			));

        --
        --xxmx_hz_org_contact_roles_stg
        --
        delete from xxmx_stg.xxmx_hz_org_contact_roles_stg
        where migration_set_id = pt_i_MigrationSetID
        and   rel_orig_system_reference in 
        (
        select rel_orig_system_reference
        from   XXMX_STG.xxmx_hz_relationships_stg
        where migration_set_id= pt_i_MigrationSetID
        and 
            ( sub_orig_system_reference in
              (
                 select party_orig_system_reference
                 from XXMX_STG.xxmx_parties_to_delete
                 where migration_set_id = pt_i_MigrationSetID
              )
              or
              obj_orig_system_reference in
              (
                 select party_orig_system_reference
                 from XXMX_STG.xxmx_parties_to_delete
                 where migration_set_id = pt_i_MigrationSetID
              )
			));
        --
        --
        --xxmx_hz_contact_points_stg
        --
        delete from xxmx_stg.xxmx_hz_contact_points_stg
        where migration_set_id = pt_i_MigrationSetID
        and   rel_orig_system_reference in 
        (
        select rel_orig_system_reference
        from   XXMX_STG.xxmx_hz_relationships_stg
        where migration_set_id= pt_i_MigrationSetID
        and 
            ( sub_orig_system_reference in
              (
                 select party_orig_system_reference
                 from XXMX_STG.xxmx_parties_to_delete
                 where migration_set_id = pt_i_MigrationSetID
              )
              or
              obj_orig_system_reference in
              (
                 select party_orig_system_reference
                 from XXMX_STG.xxmx_parties_to_delete
                 where migration_set_id = pt_i_MigrationSetID
              )
			)
        );

        --
        -- xxmx_hz_relationships_stg
        --
        delete from XXMX_STG.xxmx_hz_relationships_stg
        where migration_set_id= pt_i_MigrationSetID
        and 
            ( sub_orig_system_reference in
              (
                 select party_orig_system_reference
                 from XXMX_STG.xxmx_parties_to_delete
                 where migration_set_id = pt_i_MigrationSetID
              )
              or
              obj_orig_system_reference in
              (
                 select party_orig_system_reference
                 from XXMX_STG.xxmx_parties_to_delete
                 where migration_set_id = pt_i_MigrationSetID
              )
			);

        --
        -- Site uses
        --
        delete from XXMX_STG.xxmx_hz_party_site_uses_stg
        where migration_set_id = pt_i_MigrationSetID
        and   site_orig_system_reference in 
        (
        select site_orig_system_reference
        from xxmx_stg.xxmx_hz_party_sites_stg
        where migration_set_id = pt_i_MigrationSetID
        and   party_orig_system_reference in 
        (
        select party_orig_system_reference
        from   xxmx_stg.xxmx_parties_to_delete
        where  migration_set_id= pt_i_MigrationSetID
        )
        );
        --
        -- Locations
        --
        delete from XXMX_STG.xxmx_hz_locations_stg
        where migration_set_id = pt_i_MigrationSetID
        and   location_orig_system_reference in
        (
        select location_orig_system_reference
        from xxmx_stg.xxmx_hz_party_sites_stg
        where migration_set_id = pt_i_MigrationSetID
        and   party_orig_system_reference in 
        (
        select party_orig_system_reference
        from   xxmx_stg.xxmx_parties_to_delete
        where  migration_set_id= pt_i_MigrationSetID
        )
        );

        --
        -- Sites 
        --
        delete from xxmx_stg.xxmx_hz_party_sites_stg
        where migration_set_id = pt_i_MigrationSetID
        and   party_orig_system_reference in 
        (
        select party_orig_system_reference
        from   xxmx_stg.xxmx_parties_to_delete
        where  migration_set_id= pt_i_MigrationSetID
        );


        -- Party 
        delete from XXMX_STG.xxmx_hz_parties_stg
        where migration_set_id = pt_i_MigrationSetID
        and   party_orig_system_reference in
        (
        select party_orig_system_reference
        from XXMX_STG.xxmx_parties_to_delete
        where migration_set_id = pt_i_MigrationSetID
        );

        --
        -- Tidy up tables where relationship has been extracted but party 
        -- it relates to has not
        --
        --
        -- Sites
        --
        DELETE FROM  XXMX_STG.xxmx_hz_party_sites_stg
        WHERE migration_set_id = pt_i_MigrationSetID
        AND   (nvl(rel_orig_system,'NULLVAL'),rel_orig_system_reference) 
        in 
        (
        SELECT nvl(rel_orig_system,'NULLVAL'), rel_orig_system_reference
        FROM   XXMX_STG.xxmx_hz_relationships_stg r
        WHERE  r.migration_set_id = pt_i_MigrationSetID
        AND    NOT EXISTS (SELECT 1 FROM xxmx_stg.xxmx_hz_parties_stg hp
                           WHERE hp.migration_set_Id = pt_i_MigrationSetID
                           AND   hp.party_orig_system_reference = r.obj_orig_system_reference)
        );

        --
        -- Cust Acct Contacts
        --
        DELETE FROM XXMX_STG.xxmx_hz_cust_acct_contacts_stg
        WHERE migration_set_id = pt_i_MigrationSetID
        AND   (nvl(rel_orig_system,'NULLVAL'),rel_orig_system_reference) 
        in 
        (
        SELECT nvl(rel_orig_system,'NULLVAL'), rel_orig_system_reference
        FROM   XXMX_STG.xxmx_hz_relationships_stg r
        WHERE  r.migration_set_id = pt_i_MigrationSetID
        AND    NOT EXISTS (SELECT 1 FROM xxmx_stg.xxmx_hz_parties_stg hp
                           WHERE hp.migration_set_Id = pt_i_MigrationSetID
                           AND   hp.party_orig_system_reference = r.obj_orig_system_reference)
        );

        --
        -- Org Contacts
        --
        DELETE FROM xxmx_hz_org_contacts_stg
        WHERE migration_set_id = pt_i_MigrationSetID
        AND   (nvl(rel_orig_system,'NULLVAL'),rel_orig_system_reference) 
        in 
        (
        SELECT nvl(rel_orig_system,'NULLVAL'), rel_orig_system_reference
        FROM   XXMX_STG.xxmx_hz_relationships_stg r
        WHERE  r.migration_set_id = pt_i_MigrationSetID
        AND    NOT EXISTS (SELECT 1 FROM xxmx_stg.xxmx_hz_parties_stg hp
                           WHERE hp.migration_set_Id = pt_i_MigrationSetID
                           AND   hp.party_orig_system_reference = r.obj_orig_system_reference)
        );

        --
        --Org Contact Roles
        --
        DELETE FROM  xxmx_hz_org_contact_roles_stg
        WHERE migration_set_id= pt_i_MigrationSetID
        AND   (nvl(rel_orig_system,'NULLVAL'),rel_orig_system_reference) 
        in 
        (
        SELECT nvl(rel_orig_system,'NULLVAL'), rel_orig_system_reference
        FROM   XXMX_STG.xxmx_hz_relationships_stg r
        WHERE  r.migration_set_id = pt_i_MigrationSetID
        AND    NOT EXISTS (SELECT 1 FROM xxmx_stg.xxmx_hz_parties_stg hp
                           WHERE hp.migration_set_Id = pt_i_MigrationSetID
                           AND   hp.party_orig_system_reference = r.obj_orig_system_reference)
        );


        --
        -- Contact Points
        --
        DELETE FROM  xxmx_hz_contact_points_stg
        WHERE migration_set_id = pt_i_MigrationSetID
        AND   (nvl(rel_orig_system,'NULLVAL'),rel_orig_system_reference) 
        in 
        (
        SELECT nvl(rel_orig_system,'NULLVAL'), rel_orig_system_reference
        FROM   XXMX_STG.xxmx_hz_relationships_stg r
        WHERE  r.migration_set_id = pt_i_MigrationSetID
        AND    NOT EXISTS (SELECT 1 FROM xxmx_stg.xxmx_hz_parties_stg hp
                           WHERE hp.migration_set_Id = pt_i_MigrationSetID
                           AND   hp.party_orig_system_reference = r.obj_orig_system_reference)
        );

        --
        -- Relationships
        --
        DELETE FROM XXMX_STG.xxmx_hz_relationships_stg
        WHERE migration_set_id = pt_i_MigrationSetID  
        AND (nvl(rel_orig_system,'NULLVAL'),rel_orig_system_reference) in 
        (
        SELECT nvl(rel_orig_system,'NULLVAL'), rel_orig_system_reference
        FROM   XXMX_STG.xxmx_hz_relationships_stg r
        WHERE  r.migration_set_id = pt_i_MigrationSetID
        AND    NOT EXISTS (SELECT 1 FROM xxmx_stg.xxmx_hz_parties_stg hp
                           WHERE hp.migration_set_Id = pt_i_MigrationSetID
                           AND   hp.party_orig_system_reference = r.obj_orig_system_reference)
        );
*/        
        --
        COMMIT;     
     END;
     --
     --
     PROCEDURE exclude_customers IS
     BEGIN

     DELETE FROM XXMX_CUSTOMER_EXCLUSIONS;
     COMMIT;
     --
     -- Populate Exclusions Table
     --
     -- SMBC require that customers that are exclusively SHIP_TO customers
     -- (have no BILL_TO site) should not be migrated
     --
     INSERT INTO XXMX_CUSTOMER_EXCLUSIONS
     (
          CUST_ACCOUNT_ID     
         ,ACCOUNT_NUMBER    
         ,CUST_ACCT_SITE_ID   
         ,PARTY_ID            
         ,PARTY_SITE_ID       
         ,LOCATION_ID       
         ,ORG_ID
     )
     SELECT ShipToCus.cust_account_id, ShipToCus.account_number,'','','','',''
     FROM   
     --          (select distinct cst.cust_account_id, cst.account_number
     --           from XXMX_CUSTOMER_SCOPE_TEMP_STG cst)          selection
             apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT    hcsu
            ,apps.hz_party_sites@MXDM_NVIS_EXTRACT           hpsa
            ,apps.hz_party_usg_assignments@MXDM_NVIS_EXTRACT hpua
            ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT   ShipToSite                  
            ,apps.hz_cust_accounts@MXDM_NVIS_EXTRACT         ShipToCus
     WHERE   1=1
     --   AND    ShipToCus.cust_account_id    = selection.cust_account_id
     --   AND    ShipToCus.account_number     = selection.account_number
     AND    hpua.party_id                = ShipToCus.party_id
     AND    hpua.status_flag             = 'A'
     AND    hpua.party_usage_code        = 'CUSTOMER'
     AND    ShipToSite.cust_account_id   = ShipToCus.cust_account_id
     AND    ShipToSite.org_id            = '101'
     AND    hpsa.party_site_id           = ShipToSite.party_site_id
     AND    hcsu.cust_acct_site_id       = ShipToSite.cust_acct_site_id
     AND    hcsu.site_use_code           = 'SHIP_TO'
     AND    hcsu.org_id                  = ShiptoSite.org_id
     AND    NOT EXISTS
    (
       SELECT 1  
       FROM   apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT  hcsu2
             ,apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT hcasa2
       WHERE  hcasa2.cust_account_id  = ShipToCus.cust_account_id
       AND    hcsu2.cust_acct_site_id = hcasa2.cust_acct_site_id
       AND    hcsu2.org_id            = hcasa2.org_id
       AND    hcsu2.site_use_code     = 'BILL_TO'
     );

     --
     -- SMBC Contacts To Exclude
     -- 
     INSERT INTO XXMX_CUSTOMER_EXCLUSIONS
     (
          CUST_ACCOUNT_ID     
         ,ACCOUNT_NUMBER    
         ,CUST_ACCT_SITE_ID   
         ,PARTY_ID            
         ,PARTY_SITE_ID       
         ,PARTY_SITE_NUM
         ,LOCATION_ID       
         ,ORG_ID
     )
     SELECT distinct '','','',r.subject_id, ps.party_site_id,ps.party_site_number,'',''
     FROM   
         apps.hz_party_sites@MXDM_NVIS_EXTRACT ps,
         apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT s,
         apps.hz_cust_accounts@MXDM_NVIS_EXTRACT acc,
         apps.hz_parties@MXDM_NVIS_EXTRACT p,
         apps.hz_relationships@MXDM_NVIS_EXTRACT r
     WHERE  r.relationship_type like 'CONTACT'
     AND    r.directional_flag = 'F'
     AND    r.subject_table_name = 'HZ_PARTIES'
     AND    p.party_id = r.object_id
     AND    acc.party_id = p.party_id
     AND    s.cust_account_id = acc.cust_account_id
     AND    s.org_id = 101
     AND    ps.party_id(+) = r.subject_id
     AND    not exists (select 1 
                        from apps.hz_cust_accounts@MXDM_NVIS_EXTRACT cnt_acct
                        where cnt_acct.party_id = r.subject_id)
     UNION                      
     SELECT distinct '','','',r.party_id, ps.party_site_id,ps.party_site_number,'',''
     FROM   
         apps.hz_party_sites@MXDM_NVIS_EXTRACT ps,
         apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT s,
         apps.hz_cust_accounts@MXDM_NVIS_EXTRACT acc,
         apps.hz_parties@MXDM_NVIS_EXTRACT p,
         apps.hz_relationships@MXDM_NVIS_EXTRACT r
     WHERE  r.relationship_type like 'CONTACT'
     AND    r.directional_flag = 'F'
     AND    r.subject_table_name = 'HZ_PARTIES'
     AND    p.party_id = r.object_id
     AND    acc.party_id = p.party_id
     AND    s.cust_account_id = acc.cust_account_id
     AND    s.org_id = 101
     AND    ps.party_id(+) = r.party_id
     AND    not exists (select 1 
                        from apps.hz_cust_accounts@MXDM_NVIS_EXTRACT cnt_acct
                        where cnt_acct.party_id = r.subject_id);   

     COMMIT;

     END;
     --	 
     --
     -- Main Procedure
     --     
     PROCEDURE customers_cm_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE 
                    )
     IS
          --
          --
          --**********************
          --** CURSOR Declarations
          --**********************
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'customers_cm_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE             := 'EXTRACT';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE      := 'various';
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
          --
     --** END Declarations
     --
     --
     BEGIN
          --
          gvv_ProgressIndicator := '-CM0010';
          --
          --
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => 'CUSTOMERS'
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_Severity            => 'NOTIFICATION'               
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                           ||gct_PackageName
                                           ||'.'
                                           ||ct_ProcOrFuncName
                                           ||'" initiated.'
               ,pt_i_OracleError         => NULL
               );
          --
          --
          --** Update Customer DFFs
          --
          gvv_ProgressIndicator := '-CM0020';
          --
          --** Remove SMBC contact records
          --
          xxmx_ar_customers_cm_pkg.delete_smbc_contact_recs(pt_i_MigrationSetID);
          --
          --
          --** Update the DFF columns for each customer record in the STG table
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => 'CUSTOMERS'
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_Severity            => 'NOTIFICATION'               
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                           ||gct_PackageName
                                           ||'.'
                                           ||ct_ProcOrFuncName
                                           ||'" running.'
               ,pt_i_OracleError         => NULL
               );

          UPDATE xxmx_stg.xxmx_hz_cust_accounts_stg s
          SET (s.attribute1,s.attribute2,s.attribute3,s.attribute4,s.attribute5) =
                 (
                   SELECT ca.attribute1,ca.attribute2,ca.attribute3,ca.attribute4,ca.attribute5
                   FROM   apps.hz_cust_accounts@MXDM_NVIS_EXTRACT ca
                   WHERE  ca.account_number = s.account_number
                   AND    ca.party_id       = s.party_orig_system_reference
                 )
          WHERE s.migration_set_id = pt_i_MigrationSetID;
          --
          --** Requested by SMBC and Chris Lewis (21/04/2021)
          --** Nullify collector name so that fusion will pickup the default
          --** based on Cloud profile class.
          --
          UPDATE xxmx_stg.xxmx_hz_cust_profiles_stg
          SET    collector_name = ''
          WHERE  migration_set_id = pt_i_MigrationSetID;
          --
          UPDATE xxmx_stg.xxmx_hz_cust_profiles_stg
          SET    customer_profile_class_name = 'SCH Standard'
          WHERE  migration_set_id = pt_i_MigrationSetID
          AND    customer_profile_class_name = 'SCH STANDARD';          
          --
          --** Requested by SMBC and Chris Lewis (24/06/2021)
          --** Nullify statement cycle and send statements
          --** assigned based on Cloud profile class.
          --
          UPDATE xxmx_stg.xxmx_hz_cust_profiles_stg
          SET    statements = '',
                 credit_balance_statements = '',
                 statement_cycle_name = ''
          WHERE  migration_set_id = pt_i_MigrationSetID;
          --
	   	  -- Chris Lewis (17/08/2021) no Gardening Invoices profile classes 
          -- should be getting migrated.
          --
          DELETE FROM XXMX_xfm.xxmx_hz_cust_profiles_xfm
          WHERE migration_set_id = pt_i_MigrationSetID
          AND customer_profile_class_name = 'Gardening Invoices';         
          --
          -- Create STMTS and DUN site uses for every BILL_TO site use - ADDED 24/08/2021 - for DM7
          --
          --
          xxmx_core.xxmx_ar_account_site_uses_enrichment(pt_i_MigrationSetID,'CUSTOMERS','ACCOUNT_SITE_USES');    
          --
          UPDATE xxmx_stg.xxmx_hz_cust_acct_sites_stg
          SET    set_code = decode(ou_name,'SOLIHULL','SMBC_RDS','Solihull Community Housing','SCH_RDS','')
          WHERE  migration_set_id = pt_i_MigrationSetID;

          UPDATE xxmx_stg.xxmx_hz_cust_site_uses_stg
          SET    set_code = decode(ou_name,'SOLIHULL','SMBC_RDS','Solihull Community Housing','SCH_RDS','')
          WHERE  migration_set_id = pt_i_MigrationSetID;

          UPDATE xxmx_stg.xxmx_hz_cust_acct_relate_stg
          SET    set_code = decode(ou_name,'SOLIHULL','SMBC_RDS','Solihull Community Housing','SCH_RDS','')
          WHERE  migration_set_id = pt_i_MigrationSetID;   
          --
          -- Added 26/08/2021 - requested by Ankur
          --
          DELETE FROM XXMX_HZ_PARTY_SITE_USES_STG
          WHERE migration_set_id = pt_i_MigrationSetID
          AND site_use_type = 'HOME';
          --
          -- Rougue PARTY_RELATIONSHIP party
          --
DELETE FROM XXMX_STG.xxmx_hz_parties_stg
WHERE migration_set_id = pt_i_MigrationSetID
AND party_orig_system_reference = '68486975';      
--
-- Cust Site Not needed as primary BILL_TO already assigned
--
DELETE FROM XXMX_XFM.xxmx_hz_cust_site_uses_xfm
WHERE  migration_set_id = '1204'
AND    cust_site_orig_sys_ref = '16016951-480821'
AND    cust_siteuse_orig_sys_ref = '504676';
          --
          --
          COMMIT;
          --
          --
          -- Dunning Letter Update - SITE LEVEL
          -- 
          -- Set DUNNING_LETTERS (SEND_DUNNING flag) to 'N' where there is an open dispute. 
          -- Open dispute is any payment schedule which is open and has an amount_due_remaining and an amount_in_dispute > 0
          --
          --          
          UPDATE     xxmx_stg.xxmx_hz_cust_profiles_stg hzcp
          SET        hzcp.dunning_letters = 'N'
          WHERE      (hzcp.cust_orig_system_reference, hzcp.cust_site_orig_sys_ref, hzcp.ou_name) IN
                        (
                         SELECT cp.cust_orig_system_reference, cp.cust_site_orig_sys_ref, cp.ou_name
                         FROM   apps.hr_all_organization_units@MXDM_NVIS_EXTRACT org,
                                xxmx_stg.xxmx_hz_cust_profiles_stg cp
                         WHERE  cp.migration_set_id = pt_i_MigrationSetID
                         AND    cp.cust_site_orig_sys_ref is not null
                         AND    org.name = cp.ou_name
                         AND    exists (
                                         SELECT 1
                                         FROM 
                                               apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT     hcasa,
                                               apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT      csu,
                                               apps.ar_payment_schedules_all@MXDM_NVIS_EXTRACT   ps
                                         WHERE ps.amount_due_remaining <> 0 
                                         AND   ps.amount_in_dispute > 0
                                         AND   ps.status = 'OP'
                                         AND   csu.site_use_id = ps.customer_site_use_id
                                         AND   csu.site_use_code = 'BILL_TO'
                                         AND   hcasa.org_id = csu.org_id
                                         AND   hcasa.cust_acct_site_id = csu.cust_acct_site_id
                                         AND   csu.org_id = org.organization_id
                                         AND   hcasa.cust_account_id||'-'||hcasa.cust_acct_site_id = cp.cust_site_orig_sys_ref
                                       )
                      )
          AND     hzcp.migration_set_id = pt_i_MigrationSetID;
          --          
          --
          -- Dunning Letter Update - CUSTOMER LEVEL
          --
          -- Set DUNNING_LETTERS (SEND_DUNNING flag) to 'N' where there is an open dispute. 
          -- Open dispute is any payment schedule which is open and has an amount_due_remaining and an amount_in_dispute > 0
          --
          --          
          UPDATE     xxmx_stg.xxmx_hz_cust_profiles_stg hzcp
          SET        hzcp.dunning_letters = 'N'
          WHERE      (hzcp.cust_orig_system_reference) IN
                        (
                         SELECT cp.cust_orig_system_reference
                         FROM   apps.hr_all_organization_units@MXDM_NVIS_EXTRACT org,
                                xxmx_stg.xxmx_hz_cust_profiles_stg cp
                         WHERE  cp.migration_set_id = pt_i_MigrationSetID
                         AND    cp.cust_site_orig_sys_ref is not null
                         AND    org.name = cp.ou_name
                         AND    exists (
                                         SELECT 1
                                         FROM 
                                               apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT     hcasa,
                                               apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT      csu,
                                               apps.ar_payment_schedules_all@MXDM_NVIS_EXTRACT   ps
                                         WHERE ps.amount_due_remaining <> 0 
                                         AND   ps.amount_in_dispute > 0
                                         AND   ps.status = 'OP'
                                         AND   csu.site_use_id = ps.customer_site_use_id
                                         AND   csu.site_use_code = 'BILL_TO'
                                         AND   hcasa.org_id = csu.org_id
                                         AND   hcasa.cust_acct_site_id = csu.cust_acct_site_id
                                         AND   csu.org_id = org.organization_id
                                         AND   hcasa.cust_account_id||'-'||hcasa.cust_acct_site_id = cp.cust_site_orig_sys_ref
                                       )
                      )
          AND     hzcp.migration_set_id = pt_i_MigrationSetID
          AND     hzcp.cust_site_orig_sys_ref is null;
          --          
		  --
		  -- Record records with DUNNING FLAG updated for future processing
		  --
          -- Dunning Letter Update - CUST LEVEL
          --
          DELETE FROM xxmx_stg.xxmx_dunning_flag_updates where migration_set_id = pt_i_MigrationSetID;
          --
          --
          --
          INSERT INTO xxmx_stg.xxmx_dunning_flag_updates
          (
              migration_set_id,
              account_number,
              party_name,
              cust_account_name,
              trx_number, 
              trx_date,
              amount_due_original,
              amount_due_remaining,
              amount_in_dispute,
              actual_date_closed,
              dispute_date
          )
          SELECT distinct 
                    pt_i_MigrationSetID,
                    hca.account_number account_number,
                    hp.party_name,
                    hca.account_name,
                    ps.trx_number, 
                    ps.trx_date,
                    ps.amount_due_original, 
                    ps.amount_due_remaining,
                    ps.amount_in_dispute,
                    ps.actual_date_closed,
                    ps.dispute_date
          FROM   
                 apps.hz_parties@MXDM_NVIS_EXTRACT                 hp,          
                 apps.hz_cust_accounts@MXDM_NVIS_EXTRACT           hca,
                 apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT     hcasa,
                 apps.hz_cust_site_uses_all@MXDM_NVIS_EXTRACT      csu,
                 apps.ar_payment_schedules_all@MXDM_NVIS_EXTRACT   ps,                        
                 apps.hr_all_organization_units@MXDM_NVIS_EXTRACT org,
                 XXMX_STG.xxmx_hz_cust_profiles_stg cp
          WHERE  cp.migration_set_id = pt_i_MigrationSetID
          AND    cp.dunning_letters = 'N'
          AND    cp.cust_orig_system_reference is not null
          AND    org.name = cp.ou_name                        
          AND    ps.amount_due_remaining <> 0 
          AND    ps.amount_in_dispute > 0
          AND    ps.status = 'OP'
          AND    csu.site_use_id = ps.customer_site_use_id
          AND    csu.site_use_code = 'BILL_TO'
          AND    hcasa.org_id = csu.org_id
          AND    hcasa.cust_acct_site_id = csu.cust_acct_site_id
          AND    csu.org_id = org.organization_id
          AND    hcasa.cust_account_id||'-'||hcasa.cust_acct_site_id = cp.cust_site_orig_sys_ref
          AND    hca.cust_account_id = hcasa.cust_account_id
          AND    hp.party_id = hca.party_id;

--
-- Added data fix as name not coming through extract - DH 27/08/2021
--
update xxmx_xfm.xxmx_hz_parties_xfm
set person_first_name = 'Victoria',
    person_last_name = 'Strickson'
where party_orig_system_reference = '68486975'
and   migration_set_id = pt_i_MigrationSetID;

          COMMIT;
/*
          INSERT INTO xxmx_stg.xxmx_dunning_flag_updates(migration_set_id, cust_orig_system_reference,account_number,cust_site_orig_sys_ref,ou_name)
          SELECT DISTINCT pt_i_MigrationSetID, cp.cust_orig_system_reference, acc.account_number,cp.cust_site_orig_sys_ref,cp.ou_name
          FROM   xxmx_stg.xxmx_hz_cust_accounts_stg acc,
                 apps.hr_all_organization_units@MXDM_NVIS_EXTRACT org,
                 xxmx_stg.xxmx_hz_cust_profiles_stg cp
          WHERE  cp.migration_set_id = pt_i_MigrationSetID
          AND    cp.cust_site_orig_sys_ref is not null
          AND    org.name = cp.ou_name
          AND    acc.cust_orig_system_reference = cp.cust_orig_system_reference
          AND    acc.migration_set_id = pt_i_MigrationSetID               
          AND    EXISTS (
                          SELECT 1
                          FROM 
                                apps.hz_cust_acct_sites_all@MXDM_NVIS_EXTRACT     hcasa,
                                apps.HZ_CUST_SITE_USES_ALL@MXDM_NVIS_EXTRACT      csu,
                                apps.AR_PAYMENT_SCHEDULES_ALL@MXDM_NVIS_EXTRACT   ps
                          WHERE ps.amount_due_remaining <> 0 
                          AND   ps.amount_in_dispute > 0
                          AND   ps.status = 'OP'
                          AND   csu.site_use_id = ps.customer_site_use_id
                          AND   csu.site_use_code = 'BILL_TO'
                          AND   hcasa.org_id = csu.org_id
                          AND   hcasa.cust_acct_site_id = csu.cust_acct_site_id
                          AND   csu.org_id = org.organization_id
                          AND   hcasa.cust_account_id||'-'||hcasa.cust_acct_site_id = cp.cust_site_orig_sys_ref
                        );
*/
--
          -- ================================================================================
		  -- Create ebilling contacts
          -- ================================================================================
          -- Migrate primary email address from EBS Party Site Level to new contact in fusion
          -- against Customer Site - responsibilities DUN / STMTS / BILL_TO
          -- 
          --
          gvv_ProgressIndicator := '-CM0030A';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => 'CUSTOMERS'
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_Severity            => 'NOTIFICATION'               
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                           ||gct_PackageName
                                           ||'.'
                                           ||'create_ebilling_contacts'
                                           ||'" running.'
               ,pt_i_OracleError         => NULL
               );          
           --    
          create_ebilling_contacts(pt_i_MigrationSetID);
          COMMIT;
		  --
          -- ================================================================================
		  -- Create collection contacts
          -- ================================================================================
          -- Migrate phone number / email address at EBS Party level to new contact in fusion 
          -- against Customer Site - no responsibilities
          --
          --
          gvv_ProgressIndicator := '-CM0030B';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => 'CUSTOMERS'
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_Severity            => 'NOTIFICATION'               
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                           ||gct_PackageName
                                           ||'.'
                                           ||'create_collection_contacts'
                                           ||'" running.'
               ,pt_i_OracleError         => NULL
               );          
           --           
          create_collection_contacts(pt_i_MigrationSetID);
          COMMIT;          
		  --
          -- ================================================================================
		  -- Create Bill To contacts from Ship To customers
          -- ================================================================================
          -- Create ship to customer as contact against related Bill To customer.
          -- Ship To onlt customers will not get migrated - CL 18/05/2021
          --
          --
          gvv_ProgressIndicator := '-CM0030C';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => 'CUSTOMERS'
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_Severity            => 'NOTIFICATION'               
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                           ||gct_PackageName
                                           ||'.'
                                           ||'create_ship2bill2_contacts'
                                           ||'" running.'
               ,pt_i_OracleError         => NULL
               );          
           -- 
          create_ship2_bill2_contacts(pt_i_MigrationSetID);
          COMMIT;          
          --
          --
          -- 
-- Temporary Fix          
update XXMX_STG.xxmx_ar_cust_banks_stg
set    bank_account_name = 'UNKNOWN'
where  migration_set_id = pt_i_MigrationSetID
and    bank_account_name is null;        

delete from   XXMX_STG.xxmx_hz_contact_points_stg
where migration_set_id = pt_i_MigrationSetID
and contact_point_type = 'TLX';

delete from   XXMX_STG.xxmx_hz_contact_points_stg
where migration_set_id = pt_i_MigrationSetID
and contact_point_type = 'PHONE'
and phone_number is null;

update XXMX_STG.xxmx_hz_parties_stg
set person_first_name = 'DUMMY',
    person_last_name = 'NAME'
where migration_set_id = pt_i_MigrationSetID
and   party_orig_system_reference = '2575';

-- --------------------------------------------------------------------------------
-- Delete contact records with no relationship record
-- --------------------------------------------------------------------------------
delete from XXMX_STG.xxmx_hz_cust_acct_contacts_stg ac
where migration_set_id = pt_i_MigrationSetID
and   not exists (select 1 from xxmx_stg.xxmx_hz_relationships_stg r
                  where r.migration_set_id= pt_i_MigrationSetID
                  and  r.rel_orig_system_reference = ac.rel_orig_system_reference);

delete from XXMX_STG.xxmx_hz_org_contacts_stg ac
where migration_set_id = pt_i_MigrationSetID
and   not exists (select 1 from xxmx_stg.xxmx_hz_relationships_stg r
                  where r.migration_set_id= pt_i_MigrationSetID
                  and  r.rel_orig_system_reference = ac.rel_orig_system_reference);
-- --------------------------------------------------------------------------------

          COMMIT;
          --
          gvv_ProgressIndicator := '-CM0030';
          --
          --** Update the migration details (Migration status will be automatically determined
          --** in the called procedure dependant on the Phase and if an Error Message has been
          --** passed).
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => 'CUSTOMERS'
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_Severity            => 'NOTIFICATION'               
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                           ||gct_PackageName
                                           ||'.'
                                           ||ct_ProcOrFuncName
                                           ||'" completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          EXCEPTION
               --
               --
               WHEN OTHERS
               THEN
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
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => 'CUSTOMERS'
                         ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_Severity            => 'ERROR'       
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
     END customers_cm_stg;
     --
     --
END xxmx_ar_customers_cm_pkg;
/
