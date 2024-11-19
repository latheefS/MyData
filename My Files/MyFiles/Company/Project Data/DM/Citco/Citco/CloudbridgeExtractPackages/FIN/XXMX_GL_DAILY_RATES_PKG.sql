CREATE OR REPLACE package xxmx_gl_daily_rates_pkg as 
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
     ** FILENAME  :  xxmx_gl_daily_rates_pkg.sql
     **
     ** FILEPATH  :  $XXMX_TOP/install/sql
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  XXMX_CORE
     **
     ** AUTHORS   :  Shaik Latheef
     **
     ** PURPOSE   :  This script installs the package for the Maximise GL Daily Rates
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
     **            $XXMX_TOP/install/sql/xxmx_gl_daily_rates_stg_dbi.sql
     **            $XXMX_TOP/install/sql/xxmx_gl_daily_rates_xfm_dbi.sql
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
     **   1.0  17-JUL-2023	Shaik Latheef       Created for Maximise
     **
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

    /****************************************************************	
	----------------Export GL Daily Rates----------------------------
	*****************************************************************/
    PROCEDURE stg_main 
        (
         pt_i_ClientCode                    IN          xxmx_client_config_parameters.client_code%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE );

    PROCEDURE export_gl_daily_rates
       (
         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE );  


end xxmx_gl_daily_rates_pkg;
/


CREATE OR REPLACE PACKAGE BODY xxmx_gl_daily_rates_pkg
AS
     --
     --**********************
     --** Global Declarations
     --**********************
     --
     /* Maximise Integration Globals */
     --
     /* Global Constants for use in all xxmx_gl_dailyrates_pkg Procedure/Function Calls within this package */
     --
     gcv_PackageName                 CONSTANT  VARCHAR2(30)                                 := 'xxmx_gl_dailyrates_pkg';
     gct_ApplicationSuite            CONSTANT  xxmx_module_messages.application_suite%TYPE  := 'FIN';
     gct_Application                 CONSTANT  xxmx_module_messages.application%TYPE        := 'GL';
     gct_StgSchema                   CONSTANT  VARCHAR2(10)                                 := 'xxmx_stg';
     gct_XfmSchema                   CONSTANT  VARCHAR2(10)                                 := 'xxmx_xfm';
     gct_CoreSchema                  CONSTANT  VARCHAR2(10)                                 := 'xxmx_core';
     gct_BusinessEntity              CONSTANT  xxmx_migration_metadata.business_entity%TYPE := 'DAILY_RATES';
     gct_SubEntity                   CONSTANT  xxmx_module_messages.sub_entity%TYPE         := 'DAILY_RATES';
     --
     /* Global Progress Indicator Variable for use in all Procedures/Functions within this package */
     --
     gvv_ProgressIndicator                     VARCHAR2(100);
     --
     /* Global Variables for receiving Status/Messages from certain Procedure/Function Calls (e.g. xxmx_utilities_pkg.clear_messages */
     --
     gvv_ReturnStatus                          VARCHAR2(1);
     gvt_ReturnMessage                         xxmx_module_messages.module_message%TYPE;
     --
     /* Global Variables for data existence checking */
     --
     gvn_ExistenceCount                        NUMBER;
     --
     /* Global Variables for Exception Handlers */
     --
     gvt_Severity                              xxmx_module_messages.severity%TYPE;
     gvt_ModuleMessage                         xxmx_module_messages.module_message%TYPE;
     gvt_OracleError                           xxmx_module_messages.oracle_error%TYPE;
     e_moduleerror                             EXCEPTION;
     e_dateerror                               EXCEPTION;
     --
     /* Global Variables for Exception Handlers */
     --
     gvt_MigrationSetName                      xxmx_migration_headers.migration_set_name%TYPE;
     --
     /* Global constants and variables for dynamic SQL usage */
     --
     gcv_SQLSpace                    CONSTANT  VARCHAR2(1) := ' ';
     gvv_SQLAction                             VARCHAR2(20);
     gvv_SQLTableClause                        VARCHAR2(100);
     gvv_SQLColumnList                         VARCHAR2(4000);
     gvv_SQLValuesList                         VARCHAR2(4000);
     gvv_SQLWhereClause                        VARCHAR2(4000);
     gvv_SQLStatement                          VARCHAR2(32000);
     gvv_SQLResult                             VARCHAR2(4000);
     --
     /* Global variables for holding table row counts */
     --
     gvn_RowCount                              NUMBER;
     --
     /* Global variables for transform procedures */
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
     --*****************************
     --** PROCEDURE: gl_dailyrates_stg
     --*****************************
     --

     PROCEDURE export_gl_daily_rates
                    (
                       pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE,
                       pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    )
     IS
          --
          --
          --**********************
          --** CURSOR Declarations
          --**********************
          --
          -- Cursor to get the daily rates
          --
          CURSOR GLDailyrates_cur (p_conv_date_param varchar2)
          IS
             --
             --
              SELECT typ.user_conversion_type
                   ,rat.from_currency 
                   ,rat.to_currency        
                   ,rat.conversion_date                 as from_conversion_date
                   ,rat.conversion_date                 as to_conversion_date
                   ,rat.conversion_rate                 as conversion_rate
                   ,rev.conversion_rate                 as inverse_rate
             FROM   gl_daily_conversion_types@MXDM_NVIS_EXTRACT typ
             ,      gl_daily_rates@MXDM_NVIS_EXTRACT            rat
             ,      gl_daily_rates@MXDM_NVIS_EXTRACT            rev
             WHERE  rat.conversion_type = typ.conversion_type
             and  rev.conversion_type = typ.conversion_type
             AND    rat.from_currency   < rat.to_currency 
             AND    rev.from_currency   > rev.to_currency 
             AND    rat.CONVERSION_DATE >= to_date(p_conv_date_param,'dd/mm/yyyy')
             AND    rat.CONVERSION_DATE = rev.CONVERSION_DATE
             and    rat.from_currency=rev.to_currency
             and    rat.to_currency=rev.from_currency
             and    rat.status_code = 'C'
             and    rev.status_code = 'C'
             ;


          --** END CURSOR **
          --
          --
          --********************
          --** Type Declarations
          --********************
          --
          TYPE gl_dailyrates_tt IS TABLE OF GLDailyrates_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          /*
          ** This is declared in each Procedure within the package to allow for
          ** a different value to be assigned in the Staging/Transform/Export
          ** procedures.
          */
          --
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                           := 'export_gl_daily_rates';
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE := 'xxmx_gl_daily_rates_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE        := 'EXTRACT';
          --
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_ListParameterCode            xxmx_migration_parameters.parameter_code%TYPE;
          vn_ListValueCount               NUMBER;
          vb_OkayToExtract                BOOLEAN;
          vb_PeriodAndYearMatch           BOOLEAN;
--          vt_MigrationSetID               xxmx_migration_headers.migration_set_id%TYPE;
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
          vt_cutoffdate                             varchar2(20);
          EmptyLedgerName_tbl             xxmx_utilities_pkg.g_ParamValueList_tt;
          gl_dailyrates_tbl               gl_dailyrates_tt;
          --
          --
          --*************************
          --** Exception Declarations
          --*************************
          --
          e_ModuleError                   EXCEPTION;
          --
          --
     --** END Declarations
     --
     --
BEGIN
    --
    gvv_ProgressIndicator := '0010';
    --
    vb_OkayToExtract  := TRUE;
    gvv_ReturnStatus  := '';
    gvt_ReturnMessage := '';
    --
    xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite => gct_ApplicationSuite
               ,pt_i_Application      => gct_Application
               ,pt_i_BusinessEntity   => gct_BusinessEntity
               ,pt_i_SubEntity        => gct_SubEntity
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
                    ,pt_i_SubEntity         => gct_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
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
               ,pt_i_SubEntity        => gct_SubEntity
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
                    ,pt_i_SubEntity         => gct_SubEntity
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => ct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gcv_PackageName
                    ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
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
               ,pt_i_SubEntity         => gct_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '  - Procedure "'
                                        ||gcv_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" initiated.'
               ,pt_i_OracleError       => NULL
    );
    --
    --
    gvv_ProgressIndicator := '0040';
    --
    gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
    --
    -- If the Migration Set Name is NULL then the Migration has not been initialized.
    --
    IF   gvt_MigrationSetName IS NULL
    THEN
        gvt_Severity      := 'ERROR';
        gvt_ModuleMessage := '- Migration Set not initialized.';
        --
        RAISE e_ModuleError;
    ELSE
        --
        gvv_ProgressIndicator := '0050';
        --
        --
        xxmx_utilities_pkg.init_migration_details
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_StagingTable      => ct_StgTable
                         ,pt_i_ExtractStartDate  => SYSDATE
                         );
        --
        xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - Staging Table "'
                                                  ||ct_StgTable
                                                  ||'" reporting details initialised.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    --
        xxmx_utilities_pkg.log_module_message
        (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - Extracting GL dailyrates for specific '
                         ,pt_i_OracleError       => NULL
                         );
                    --
        vt_cutoffdate := xxmx_utilities_pkg.get_single_parameter_value
        (
                     pt_i_ApplicationSuite           => gct_ApplicationSuite
                    ,pt_i_Application                => gct_Application
                    ,pt_i_BusinessEntity             => 'DAILY_RATES'
                    ,pt_i_SubEntity                  => 'DAILY_RATES'
                    ,pt_i_ParameterCode              => 'CUT_OFF_DATE'
        );
        xxmx_utilities_pkg.log_module_message
        (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - vt_cutoffdate='||vt_cutoffdate
                         ,pt_i_OracleError       => NULL
        );
        --
        gvv_ProgressIndicator := '060';
        --
        gvv_ProgressIndicator := '0140';
        --
        OPEN GLDailyrates_cur(vt_cutoffdate);
        --
        gvv_ProgressIndicator := '0150';
        --
            LOOP
            --
            FETCH        GLDailyrates_cur
                BULK COLLECT
                INTO         gl_dailyrates_tbl
                LIMIT        xxmx_utilities_pkg.gcn_BulkCollectLimit;
            --
                EXIT WHEN    gl_dailyrates_tbl.COUNT = 0;
            --
            gvv_ProgressIndicator := '0160';
            --
            FORALL GLdailyrates_idx 
                IN 1..gl_dailyrates_tbl.COUNT
            --
                INSERT
                INTO   xxmx_stg.xxmx_gl_daily_rates_stg
                (
                                                               migration_set_id
                                                              ,migration_set_name
                                                              ,migration_status
                                                              ,from_currency
                                                              ,to_currency
                                                              ,from_conversion_date
                                                              ,to_conversion_date
                                                              ,user_conversion_type
                                                              ,conversion_rate
                                                              ,inverse_conversion_rate
                                                              ,attribute_category
                                                              ,attribute1
                                                              ,attribute2
                                                              ,attribute3
                                                              ,attribute4
                                                              ,attribute5
                                                              ,attribute6
                                                              ,attribute7
                                                              ,attribute8
                                                              ,attribute9
                                                              ,attribute10
                                                              ,attribute11
                                                              ,attribute12
                                                              ,attribute13
                                                              ,attribute14
                                                              ,attribute15
															  ,attribute_date1
                                                              ,attribute_date2
                                                              ,attribute_date3
                                                              ,attribute_date4
                                                              ,attribute_date5
                                                              ,attribute_number1
                                                              ,attribute_number2
															  ,attribute_number3
															  ,attribute_number4
															  ,attribute_number5
                )
                VALUES
                (
                                                               pt_i_MigrationSetID                                           -- migration_set_id
                                                              ,gvt_MigrationSetName                                          -- migration_set_name
                                                              ,'EXTRACTED'                                                   -- migration_status
                                                              ,gl_dailyrates_tbl(GLdailyrates_idx).from_currency             -- from_currency
                                                              ,gl_dailyrates_tbl(GLdailyrates_idx).to_currency               -- to_currency
                                                              ,gl_dailyrates_tbl(GLdailyrates_idx).from_conversion_date      -- from_conversion_date
                                                              ,gl_dailyrates_tbl(GLdailyrates_idx).to_conversion_date        -- to_conversion_date
                                                              ,gl_dailyrates_tbl(GLdailyrates_idx).user_conversion_type      -- user_conversion_type
                                                              ,gl_dailyrates_tbl(GLdailyrates_idx).CONVERSION_RATE           -- conversion_rate
                                                              ,gl_dailyrates_tbl(GLdailyrates_idx).inverse_rate              -- inverse_conversion_rate
                                                              ,NULL                                                          -- attribute_category
                                                              ,NULL                                                          -- attribute1
                                                              ,NULL                                                          -- attribute2
                                                              ,NULL                                                          -- attribute3
                                                              ,NULL                                                          -- attribute4
                                                              ,NULL                                                          -- attribute5
                                                              ,NULL                                                          -- attribute6
                                                              ,NULL                                                          -- attribute7
                                                              ,NULL                                                          -- attribute8
                                                              ,NULL                                                          -- attribute9
                                                              ,NULL                                                          -- attribute10
                                                              ,NULL                                                          -- attribute11
                                                              ,NULL                                                          -- attribute12
                                                              ,NULL                                                          -- attribute13
                                                              ,NULL                                                          -- attribute14
                                                              ,NULL                                                          -- attribute15
                                                              ,NULL                                                          -- attribute_date1
                                                              ,NULL                                                          -- attribute_date2
                                                              ,NULL                                                          -- attribute_date3
                                                              ,NULL                                                          -- attribute_date4
                                                              ,NULL                                                          -- attribute_date5
                                                              ,NULL                                                          -- attribute_number1
                                                              ,NULL                                                          -- attribute_number2
                                                              ,NULL                                                          -- attribute_number3
                                                              ,NULL                                                          -- attribute_number4
                                                              ,NULL                                                          -- attribute_number5
                );
                --
                --** END FORALL 
                --
            END LOOP; --** GLDailyrates_cur BULK COLLECT LOOP
            --
            gvv_ProgressIndicator := '0170';
            --
        CLOSE GLDailyrates_cur;
        --
        gvv_ProgressIndicator := '0190';
        --
                    /*
                    ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
                    ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
                    ** is reached.  Also the rowcount for this extract will report TOTAL rows extracted across
                    ** all GL Ledgers in the Migration Set.
                    */
                    --
                    gvn_RowCount := xxmx_utilities_pkg.get_row_count
                                         (
                                          gct_StgSchema
                                         ,ct_StgTable
                                         ,pt_i_MigrationSetID
                                         );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
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
                    COMMIT;
                    --
                    --** Update the migration details (Migration status will be automatically determined
                    --** in the called procedure dependant on the Phase and if an Error Message has been
                    --** passed).
                    --
                    gvv_ProgressIndicator := '0200';
                    --
                    --** ISV 21/10/2020 - Removed Sequence Number parameters as the procedure will now determine the correct values from the metadata
                    --**                  table based on the Application Suite, Application, Business Entity and Sub-Entity parameters.
                    --**
                    --**                  Removed "entity" from procedure_name.
                    --
                    xxmx_utilities_pkg.upd_migration_details
                         (
                          pt_i_MigrationSetID          => pt_i_MigrationSetID
                         ,pt_i_BusinessEntity          => gct_BusinessEntity
                         ,pt_i_SubEntity               => gct_SubEntity
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
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '  - Migration Table "'
                                                  ||ct_StgTable
                                                  ||'" reporting details updated.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
               --
          END IF;
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => gct_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => ct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gcv_PackageName
               ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gcv_PackageName
                                        ||'.'
                                        ||cv_ProcOrFuncName
                                        ||'" completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    IF   GLDailyrates_cur%ISOPEN
                    THEN
                         --
                         CLOSE GLDailyrates_cur;
                         --
                    END IF;
                    --
                    ROLLBACK;
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
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
               --
               WHEN OTHERS
               THEN
                    --
                    IF   GLDailyrates_cur%ISOPEN
                    THEN
                         --
                         CLOSE GLDailyrates_cur;
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
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gcv_PackageName
                         ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted at after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    RAISE;
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END export_gl_daily_rates;
     --
     --
     --
     procedure stg_main
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                    )
     is
        CURSOR metadata_cur
        IS
         SELECT  Entity_package_name
                ,Stg_procedure_name
                ,BUSINESS_ENTITY
                ,SUB_ENTITY_SEQ
                ,sub_entity
         FROM    xxmx_migration_metadata a
         WHERE 	 application_suite = gct_ApplicationSuite
         AND   	 Application = gct_Application
         AND   	 business_entity = gct_BusinessEntity
         AND   	 a.enabled_flag = 'Y'
         ORDER BY
         Business_entity_seq,
         Sub_entity_seq;

        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'stg_main';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
        vt_MigrationSetID                               xxmx_migration_headers.migration_set_id%TYPE;
        lv_sql                                          VARCHAR2(32000);
BEGIN
    --
    gvv_ProgressIndicator := '0010';
    --
    IF   pt_i_ClientCode       IS NULL
    OR   pt_i_MigrationSetName IS NULL
    THEN
        --
        gvt_Severity      := 'ERROR';
        gvt_ModuleMessage := '- "pt_i_ClientCode" and "pt_i_MigrationSetName" parameters are mandatory.';
        --
        RAISE e_ModuleError;
        --
    END IF;
    --
          --
          gvv_ReturnStatus  := '';
          --
          /*
          ** Clear Daily Rates Module Messages
          */
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => gct_SubEntity
               ,pt_i_Phase               => ct_Phase
               ,pt_i_MessageType         => 'MODULE'
               ,pv_o_ReturnStatus        => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F'
          THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => gct_SubEntity
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'ERROR'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                    ,pt_i_OracleError         => gvt_ReturnMessage
                    );
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => gct_SubEntity
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
          gvv_ProgressIndicator := '0030';
          --
          /*
          ** Migration Set ID Generation
          */
          --
          xxmx_utilities_pkg.init_migration_set
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_MigrationSetName  => pt_i_MigrationSetName
               ,pt_o_MigrationSetID    => vt_MigrationSetID
               );
		  --	   
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => gct_SubEntity
               ,pt_i_MigrationSetID      => vt_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gcv_PackageName
               ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => '- Migration Set "'
                                          ||pt_i_MigrationSetName
                                          ||'" initialized (Generated Migration Set ID = '
                                          ||vt_MigrationSetID
                                          ||').  Processing extracts:'
               ,pt_i_OracleError         => NULL
               );
          /*
          ** Loop through the Migration Metadata table to retrieve
          ** the Staging Package Name, Procedure Name and table name
          ** for each extract requied for the current Business Entity.
          */
          --
          gvv_ProgressIndicator := '0040';
          --
          FOR  Metadata_rec
          IN   Metadata_cur
          LOOP
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => gct_SubEntity
                    ,pt_i_MigrationSetID      => vt_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => '- Calling Procedure "'
                                               ||Metadata_rec.entity_package_name
                                               ||'.'
                                               ||Metadata_rec.stg_procedure_name
                                               ||'".'
                    ,pt_i_OracleError         => NULL
                    );
               --
               gvv_SQLStatement := 'BEGIN '
                                 ||Metadata_rec.entity_package_name
                                 ||'.'
                                 ||Metadata_rec.stg_procedure_name
                                 ||gcv_SQLSpace
                                 ||'(pt_i_MigrationSetID          => '
                                 ||vt_MigrationSetID
                                 ||',pt_i_SubEntity     => '''
                                 ||Metadata_rec.sub_entity||''''
                                 ||'); END;';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite    => gct_ApplicationSuite
                    ,pt_i_Application         => gct_Application
                    ,pt_i_BusinessEntity      => gct_BusinessEntity
                    ,pt_i_SubEntity           => gct_SubEntity
                    ,pt_i_MigrationSetID      => vt_MigrationSetID
                    ,pt_i_Phase               => ct_Phase
                    ,pt_i_Severity            => 'NOTIFICATION'
                    ,pt_i_PackageName         => gcv_PackageName
                    ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                    ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage       => SUBSTR(
                                                        '- Generated SQL Statement: '
                                                      ||gvv_SQLStatement
                                                       ,1
                                                       ,4000
                                                       )
                    ,pt_i_OracleError         => NULL
                    );
               --
               EXECUTE IMMEDIATE gvv_SQLStatement;
               --
          END LOOP;
         --
         gvv_ProgressIndicator :='0050';
    --
    COMMIT;
    --
    --
    xxmx_utilities_pkg.log_module_message
    (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => gct_SubEntity
               ,pt_i_MigrationSetID      => vt_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gcv_PackageName
               ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'||gcv_PackageName||'.'||cv_ProcOrFuncName||'" completed.'
               ,pt_i_OracleError         => NULL
    );
          --
EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => gct_ApplicationSuite
                         ,pt_i_Application         => gct_Application
                         ,pt_i_BusinessEntity      => gct_BusinessEntity
                         ,pt_i_SubEntity           => gct_SubEntity
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => gvt_Severity
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => gvt_ModuleMessage
                         ,pt_i_OracleError         => NULL
                         );
                    --
                    RAISE;
                    --
               --** END e_ModuleError Exception
               --
               WHEN OTHERS
               THEN
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
                         ,pt_i_SubEntity           => gct_SubEntity
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => gcv_PackageName
                         ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError         => gvt_OracleError
                         );
                    --
                    RAISE;
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
       --
    end stg_main;

END xxmx_gl_daily_rates_pkg;
/
