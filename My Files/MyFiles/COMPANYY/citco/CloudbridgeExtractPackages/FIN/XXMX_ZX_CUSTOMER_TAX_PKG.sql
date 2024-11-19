CREATE OR REPLACE package xxmx_zx_customer_tax_pkg as 
     --
     --
     /*
     *****************************************************************************
     **
     **                 		  Copyright (c) 2022 Version 1
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
     ** FILENAME  :  xxmx_zx_customer_tax_pkg.sql
     **
     ** FILEPATH  :  $XXMX_TOP/install/sql
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Shaik Latheef
     **
     ** PURPOSE   :  This script installs the package for the Maximise Customer Tax
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
     **            $XXMX_TOP/install/sql/xxmx_zx_customers_tax_stg_dbi.sql
     **            $XXMX_TOP/install/sql/xxmx_zx_customers_tax_xfm_dbi.sql
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
     **   1.0  20-SEP-2023	Shaik Latheef       Created for Maximise
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
	----------------Export ZX Customer Tax---------------------------
	****************************************************************/
    PROCEDURE stg_main 
        (
         pt_i_ClientCode                    IN          xxmx_client_config_parameters.client_code%TYPE
        ,pt_i_MigrationSetName              IN          xxmx_migration_headers.migration_set_name%TYPE ) ;

	PROCEDURE zx_tax_profile_stg
        (
         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE ) ;

	PROCEDURE zx_tax_registration_stg
        (
         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE ) ;	

	PROCEDURE zx_party_classific_stg
        (
         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
        ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE ) ;

end xxmx_zx_customer_tax_pkg;
/


CREATE OR REPLACE package body xxmx_zx_customer_tax_pkg as
     --
     --**********************
     --** Global Declarations
     --**********************
     --
     /* Maximise Integration Globals */
     --
     /* Global Constants for use in all xxmx_zx_customer_tax_pkg Procedure/Function Calls within this package */
     --
     gcv_PackageName                 CONSTANT  VARCHAR2(30)                                 := 'xxmx_zx_customer_tax_pkg';
     gct_ApplicationSuite            CONSTANT  xxmx_module_messages.application_suite%TYPE  := 'FIN';
     gct_Application                 CONSTANT  xxmx_module_messages.application%TYPE        := 'ZX';
     gct_StgSchema                   CONSTANT  VARCHAR2(10)                                 := 'xxmx_stg';
     gct_XfmSchema                   CONSTANT  VARCHAR2(10)                                 := 'xxmx_xfm';
     gct_CoreSchema                  CONSTANT  VARCHAR2(10)                                 := 'xxmx_core';
     gct_BusinessEntity              CONSTANT  xxmx_migration_metadata.business_entity%TYPE := 'CUSTOMER_TAX';
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
     --** PROCEDURE: stg_main
     --*****************************
     --
	 
       procedure stg_main
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                    )
       is
		--
        --**********************
        --** Cursor Declarations
        --**********************
		
        CURSOR metadata_cur
                      (
                       pt_ApplicationSuite             xxmx_migration_metadata.application_suite%TYPE
                      ,pt_Application                  xxmx_migration_metadata.application%TYPE
                      ,pt_BusinessEntity               xxmx_migration_metadata.business_entity%TYPE
                      )
        IS
         SELECT  entity_package_name
                ,stg_procedure_name
                ,business_entity
                ,sub_entity_seq
                ,sub_entity
         FROM    xxmx_migration_metadata a
         WHERE 	 application_suite = gct_ApplicationSuite
         AND   	 Application = gct_Application
         AND   	 business_entity = gct_BusinessEntity
         AND   	 a.enabled_flag = 'Y'
         ORDER BY
         Business_entity_seq,
         Sub_entity_seq;
		 
        --
        --************************
        --** Constant Declarations
        --************************
        --
		
        cv_ProcOrFuncName                   CONSTANT    VARCHAR2(30) := 'stg_main';
        gct_SubEntity                       CONSTANT  xxmx_module_messages.sub_entity%TYPE := 'ALL';
        ct_Phase                            CONSTANT    xxmx_module_messages.phase%TYPE  := 'EXTRACT';
		
        --
        --************************
        --** Variable Declarations
        --************************
        --		
		
        vt_MigrationSetID                               xxmx_migration_headers.migration_set_id%TYPE;
		
        --
        --*************************
        --** Exception Declarations
        --*************************
        --
		
        e_ModuleError                   EXCEPTION;
		
        --
     --** END Declarations **
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
		/*
        ** Clear Customer Tax Module Messages
        */
        --
		  --
          gvv_ReturnStatus  := '';
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
        /*
        ** Migration Set ID Generation
        */
        --
		  --
          gvv_ProgressIndicator := '0030';
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
                    (
                     gct_ApplicationSuite
                    ,gct_Application
                    ,gct_BusinessEntity
                    )
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

     --
     --********************************
     --** PROCEDURE: zx_tax_profile_stg
     --********************************
     --
	 
PROCEDURE zx_tax_profile_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    )
IS
          --
          --
          /*
          **********************
          ** CURSOR Declarations
          **********************
          */
          --
          --
    CURSOR party_tax_profile_cur is
        SELECT  DISTINCT
             'Customer site'                                  		as PARTY_TYPE_CODE
            ,scope.party_site_number                             	as PARTY_NUMBER
            ,scope.party_name                                      	as PARTY_NAME
            ,zxptp.PROCESS_FOR_APPLICABILITY_FLAG  					as PROCESS_FOR_APPLICABILITY_FLAG
            ,zxptp.ROUNDING_LEVEL_CODE                    			as ROUNDING_LEVEL_CODE
            ,zxptp.ROUNDING_RULE_CODE                      			as ROUNDING_RULE_CODE
            ,zxptp.TAX_CLASSIFICATION_CODE            				as TAX_CLASSIFICATION_CODE
            ,zxptp.INCLUSIVE_TAX_FLAG                      			as INCLUSIVE_TAX_FLAG
            ,zxptp.allow_offset_tax_flag                   			as ALLOW_OFFSET_TAX_FLAG
            ,zxptp.COUNTRY_CODE                                  	as COUNTRY_CODE
            ,zxptp.REGISTRATION_TYPE_CODE              				as REGISTRATION_TYPE_CODE
            ,zxptp.REP_REGISTRATION_NUMBER            				as REP_REGISTRATION_NUMBER
                FROM 
                     ZX_REGISTRATIONS@MXDM_NVIS_EXTRACT       zxr,
                     ZX_PARTY_TAX_PROFILE@MXDM_NVIS_EXTRACT   zxptp,
                     XXMX_CUSTOMER_SCOPE_V               	  scope
                WHERE zxr.EFFECTIVE_TO            IS NULL
                AND zxr.PARTY_TAX_PROFILE_ID    = zxptp.PARTY_TAX_PROFILE_ID
                AND zxptp.PARTY_ID              = scope.party_site_id
        UNION
         SELECT  DISTINCT
             'Customer site'                                  		as PARTY_TYPE_CODE
            ,scope.party_site_number                             	as PARTY_NUMBER
            ,scope.party_name                                      	as PARTY_NAME
            ,zxptp.PROCESS_FOR_APPLICABILITY_FLAG  					as PROCESS_FOR_APPLICABILITY_FLAG
            ,zxptp.ROUNDING_LEVEL_CODE                    			as ROUNDING_LEVEL_CODE
            ,zxptp.ROUNDING_RULE_CODE                      			as ROUNDING_RULE_CODE
            ,zxptp.TAX_CLASSIFICATION_CODE            				as TAX_CLASSIFICATION_CODE
            ,zxptp.INCLUSIVE_TAX_FLAG                      			as INCLUSIVE_TAX_FLAG
            ,zxptp.allow_offset_tax_flag                   			as ALLOW_OFFSET_TAX_FLAG
            ,zxptp.COUNTRY_CODE                                  	as COUNTRY_CODE
            ,zxptp.REGISTRATION_TYPE_CODE              				as REGISTRATION_TYPE_CODE
            ,zxptp.REP_REGISTRATION_NUMBER            				as REP_REGISTRATION_NUMBER
                FROM 
                     ZX_PARTY_TAX_PROFILE@MXDM_NVIS_EXTRACT   zxptp,
                     XXMX_CUSTOMER_SCOPE_V               scope
                WHERE 1=1
                AND zxptp.PARTY_ID              = scope.party_site_id
                AND PARTY_TYPE_CODE = 'THIRD_PARTY_SITE'
                AND zxptp.REP_REGISTRATION_NUMBER IS NOT NULL
                ;
          --
          --
          /*
          ********************
          ** Type Declarations
          ********************
          */
          --
          TYPE party_tax_profile_tt    IS TABLE OF party_tax_profile_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          --
          /*
          ************************
          ** Constant Declarations
          ************************
          */          
          --
          /*
          ** This is declared in each Procedure within the package to allow for
          ** a different value to be assigned in the Staging/Transform/Export
          ** procedures.
          */
          --
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'zx_tax_profile_stg';         
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE := 'xxmx_zx_tax_profile_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXTRACT';
          --
          /*
          ************************
          ** Variable Declarations
          ************************
          */
          --
          gct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE         := 'TAX_PROFILE';
          --
          /*
          ****************************
          ** Record Table Declarations
          ****************************
          */
          --
          --
		  /*
          ****************************
          ** PL/SQL Table Declarations
          ****************************
          */
          --
          party_tax_profile_tbl                       party_tax_profile_tt;
          --
          /*
          *************************
          ** Exception Declarations
          *************************
          */
          --
          --** Set gvt_Severity, gvv_ProgressIndicator and gvt_ModuleMessage
          --** before raising this exception.
          --
          e_ModuleError                   EXCEPTION;
          --
     --** END Declarations
     --
     --
     BEGIN
          --
          -- Delete any MODULE messages from previous executions
          -- for the Business Entity and Business Entity Level
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
          --
          -- Delete any DATA messages from previous executions
          -- for the Business Entity and Business Entity Level.
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
    /*
    ** Retrieve the Migration Set Name
    */
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
               /*
               ** The Migration Set has been initialised, so now initialize the detail record
               ** for the current entity.
               */
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
               gvv_ProgressIndicator := '0060';
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
                         ,pt_i_ModuleMessage     => '  - Extracting data into "'||ct_StgTable||'".'
                         ,pt_i_OracleError       => NULL
                         );
    --
    OPEN party_tax_profile_cur;
    --
    LOOP
        --
        gvv_ProgressIndicator := '0070';
        --
        FETCH party_tax_profile_cur
            BULK    COLLECT
            INTO    party_tax_profile_tbl
            LIMIT   xxmx_utilities_pkg.gcn_BulkCollectLimit;
        --
        EXIT WHEN party_tax_profile_tbl.COUNT = 0;
        --
            gvv_ProgressIndicator := '0080';
            --
            FORALL i IN 1..party_tax_profile_tbl.COUNT
                INSERT INTO xxmx_stg.xxmx_zx_tax_profile_stg
                (
                                         migration_set_id
                                        ,migration_set_name
                                        ,migration_status
                                        ,PARTY_TYPE_CODE
										,PARTY_NUMBER
										,PARTY_NAME
                                        ,PROCESS_FOR_APPLICABILITY_FLAG
                                        ,ROUNDING_LEVEL_CODE
                                        ,ROUNDING_RULE_CODE
                                        ,TAX_CLASSIFICATION_CODE
                                        ,INCLUSIVE_TAX_FLAG
                                        ,ALLOW_OFFSET_TAX_FLAG
                                        ,COUNTRY_CODE
                                        ,REGISTRATION_TYPE_CODE
                                        ,REP_REGISTRATION_NUMBER
                )
                VALUES
                (
                                        pt_i_MigrationSetID
                                       ,gvt_MigrationSetName
                                       ,'EXTRACTED'
                                       ,party_tax_profile_tbl(i).PARTY_TYPE_CODE
                                       ,party_tax_profile_tbl(i).PARTY_NUMBER
                                       ,party_tax_profile_tbl(i).PARTY_NAME
                                       ,party_tax_profile_tbl(i).PROCESS_FOR_APPLICABILITY_FLAG
                                       ,party_tax_profile_tbl(i).ROUNDING_LEVEL_CODE
                                       ,party_tax_profile_tbl(i).ROUNDING_RULE_CODE
                                       ,party_tax_profile_tbl(i).TAX_CLASSIFICATION_CODE
                                       ,party_tax_profile_tbl(i).INCLUSIVE_TAX_FLAG
                                       ,party_tax_profile_tbl(i).ALLOW_OFFSET_TAX_FLAG
                                       ,party_tax_profile_tbl(i).COUNTRY_CODE
                                       ,party_tax_profile_tbl(i).REGISTRATION_TYPE_CODE
                                       ,party_tax_profile_tbl(i).REP_REGISTRATION_NUMBER
                );
            --END FORALL;
    END LOOP; --party_tax_profile_cur BULK COLLECT LOOP
    --
    gvv_ProgressIndicator := '0090';
    --
    CLOSE party_tax_profile_cur;
    --
    gvv_ProgressIndicator := '0100';
    --
                    /*
                    ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
                    ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
                    ** is reached.  Also the rowcount for this extract will report TOTAL rows extracted across
                    ** all ZX Ledgers in the Migration Set.
                    */
                    --
    gvn_RowCount := xxmx_utilities_pkg.get_row_count
        (
             gct_StgSchema
            ,ct_StgTable
            ,pt_i_MigrationSetID
        );
    --
    COMMIT;
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
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '0110';
               --
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
                    IF   party_tax_profile_cur%ISOPEN
                    THEN
                         --
                         CLOSE party_tax_profile_cur;
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
                    IF   party_tax_profile_cur%ISOPEN
                    THEN
                         --
                         CLOSE party_tax_profile_cur;
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
                         ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    RAISE;
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
END zx_tax_profile_stg;


     --
     --*************************************
     --** PROCEDURE: zx_tax_registration_stg
     --*************************************
     --

PROCEDURE zx_tax_registration_stg
(
     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
)
is
    --  **********************
    --  ** CURSOR Declarations
    --  **********************
    CURSOR party_tax_reg_cur is
        SELECT  DISTINCT
             scope.party_site_number                             	as PARTY_NUMBER
            ,scope.party_name                                      	as PARTY_NAME
            ,'Customer site'                                  		as PARTY_TYPE_CODE
            --,zxptp.REP_REGISTRATION_NUMBER            				as REP_REGISTRATION_NUMBER
            ,null                                         			as ROUNDING_LEVEL_CODE
            ,zxptp.ROUNDING_RULE_CODE                      			as ROUNDING_RULE_CODE
            --,zxptp.COUNTRY_CODE                                  		as COUNTRY_CODE
            --,zxptp.TAX_CLASSIFICATION_CODE            				as TAX_CLASSIFICATION_CODE
            ,zxptp.SELF_ASSESS_FLAG                          		as SELF_ASSESS_FLAG
            --,''                                                  		as SUPLIER_FLAG
            --,'Y'                                                		as CUSTOMER_FLAG
            --,zxptp.PROCESS_FOR_APPLICABILITY_FLAG 					as PROCESS_FOR_APPLICABILITY_FLAG
            --,''                                         				as ALLOW_OFFSET_TAX_FLAG
            --,''                                          				as TRANSPORT_PRVDR_FLAG
            ,zxr.TAX_REGIME_CODE                              		as TAX_REGIME_CODE
            ,zxr.TAX                                                as TAX
            ,zxr.TAX_JURISDICTION_CODE                  			as TAX_JURISDICTION_CODE
            ,zxr.REGISTRATION_TYPE_CODE                				as REGISTRATION_TYPE_CODE
            ,zxr.DEFAULT_REGISTRATION_FLAG          				as DEFAULT_REGISTRATION_FLAG
            ,ZXR.REGISTRATION_NUMBER                      			as REGISTRATION_NUMBER
            ,nvl(hps.start_date_active,hps.creation_date)      		as EFFECTIVE_FROM
            ,zxr.EFFECTIVE_TO                                    	as EFFECTIVE_TO
            ,zxr.REGISTRATION_REASON_CODE            				as REGISTRATION_REASON_CODE
            ,zxr.REGISTRATION_STATUS_CODE            				as REGISTRATION_STATUS_CODE
            ,zxr.REGISTRATION_SOURCE_CODE            				as REGISTRATION_SOURCE_CODE
            ,zxr.INCLUSIVE_TAX_FLAG                        			as INCLUSIVE_TAX_FLAG
            ,zxr.REP_PARTY_TAX_NAME                        			as REP_PARTY_TAX_NAME
            --,''                                           			as LEGAL_LOCATION_CODE
            --,''                                                		as ADDRESS_LINE_1
            --,''                                                  		as TOWN_OR_CITY                                       
            --,''                                                    	as REGION_1                                           
            --,''                                            			as TAX_AUTHORITY_NAME
        FROM 
            ZX_REGISTRATIONS@MXDM_NVIS_EXTRACT       zxr,
            ZX_PARTY_TAX_PROFILE@MXDM_NVIS_EXTRACT   zxptp,
            apps.hz_party_sites@MXDM_NVIS_EXTRACT    hps,
            XXMX_CUSTOMER_SCOPE_V                    scope
            
        WHERE   sysdate between zxr.EFFECTIVE_FROM and nvl(zxr.EFFECTIVE_TO,sysdate+1)
        AND     zxr.PARTY_TAX_PROFILE_ID    = zxptp.PARTY_TAX_PROFILE_ID
        AND     zxptp.PARTY_ID              = scope.party_site_id
        and     scope.party_site_id         = hps.party_site_id
        and     zxptp.PARTY_TYPE_CODE       = 'THIRD_PARTY_SITE';
    --
    --
                    /*
          ********************
          ** Type Declarations
          ********************
          */
          --
          TYPE party_tax_reg_tt    IS TABLE OF party_tax_reg_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          --
          /*
          ************************
          ** Constant Declarations
          ************************
          */          
          --
          /*
          ** This is declared in each Procedure within the package to allow for
          ** a different value to be assigned in the Staging/Transform/Export
          ** procedures.
          */
          --
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'zx_tax_registration_stg';         
          ct_StgTable                     CONSTANT  xxmx_migration_metadata.stg_table%TYPE := 'xxmx_zx_tax_registration_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXTRACT';
          --
          /*
          ************************
          ** Variable Declarations
          ************************
          */
          --
          gct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE         := 'TAX_REGISTRATION';
          --
          /*
          ****************************
          ** Record Table Declarations
          ****************************
          */
          --
          --
		  /*
          ****************************
          ** PL/SQL Table Declarations
          ****************************
          */
          --
          party_tax_reg_tbl                       party_tax_reg_tt;
          --
          /*
          *************************
          ** Exception Declarations
          *************************
          */
          --
          --** Set gvt_Severity, gvv_ProgressIndicator and gvt_ModuleMessage
          --** before raising this exception.
          --
          e_ModuleError                   EXCEPTION;
          --
     --** END Declarations
     --
     --
     BEGIN
          --
          -- Delete any MODULE messages from previous executions
          -- for the Business Entity and Business Entity Level
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
          --
          -- Delete any DATA messages from previous executions
          -- for the Business Entity and Business Entity Level.
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
    /*
    ** Retrieve the Migration Set Name
    */
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
               /*
               ** The Migration Set has been initialised, so now initialize the detail record
               ** for the current entity.
               */
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
               gvv_ProgressIndicator := '0060';
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
                         ,pt_i_ModuleMessage     => '  - Extracting data into "'||ct_StgTable||'".'
                         ,pt_i_OracleError       => NULL
                         );
               --
               OPEN party_tax_reg_cur;
               --
               LOOP
                    --
                    gvv_ProgressIndicator := '0070';
                    --
                    FETCH party_tax_reg_cur
                       BULK 	COLLECT
                       INTO		party_tax_reg_tbl
                       LIMIT    xxmx_utilities_pkg.gcn_BulkCollectLimit;
                    --
                    EXIT WHEN party_tax_reg_tbl.COUNT = 0;
                    --
                    gvv_ProgressIndicator := '0080';
                    --
                    FORALL i IN 1..party_tax_reg_tbl.COUNT
                         INSERT INTO xxmx_stg.xxmx_zx_tax_registration_stg
                                     (
                                         migration_set_id
                                        ,migration_set_name                                 
                                        ,migration_status                                   
                                        ,PARTY_NUMBER
                                        ,PARTY_NAME                                         
                                        ,PARTY_TYPE_CODE                                    
                                        ,TAX_REGIME_CODE                                    
                                        ,TAX
                                        ,TAX_JURISDICTION_CODE 
                                        ,REGISTRATION_TYPE_CODE                             
                                        ,REGISTRATION_NUMBER                                
                                        ,EFFECTIVE_FROM
                                        ,EFFECTIVE_TO
                                        ,DEFAULT_REGISTRATION_FLAG
                                        ,REGISTRATION_REASON_CODE
                                        ,REGISTRATION_STATUS_CODE
                                        ,REGISTRATION_SOURCE_CODE
                                        ,REP_PARTY_TAX_NAME
                                        ,ROUNDING_LEVEL_CODE
                                        ,SELF_ASSESS_FLAG
                                        ,INCLUSIVE_TAX_FLAG
                                     )
                         VALUES
                                    (
                                        pt_i_MigrationSetID
                                       ,gvt_MigrationSetName
                                       ,'EXTRACTED'
                                       ,party_tax_reg_tbl(i).PARTY_NUMBER
                                       ,party_tax_reg_tbl(i).PARTY_NAME
                                       ,party_tax_reg_tbl(i).PARTY_TYPE_CODE
                                       ,party_tax_reg_tbl(i).TAX_REGIME_CODE
                                       ,party_tax_reg_tbl(i).TAX
                                       ,party_tax_reg_tbl(i).TAX_JURISDICTION_CODE 
                                       ,party_tax_reg_tbl(i).REGISTRATION_TYPE_CODE
                                       ,party_tax_reg_tbl(i).REGISTRATION_NUMBER
                                       ,party_tax_reg_tbl(i).EFFECTIVE_FROM
                                       ,party_tax_reg_tbl(i).EFFECTIVE_TO
                                       ,party_tax_reg_tbl(i).DEFAULT_REGISTRATION_FLAG
                                       ,party_tax_reg_tbl(i).REGISTRATION_REASON_CODE
                                       ,party_tax_reg_tbl(i).REGISTRATION_STATUS_CODE
                                       ,party_tax_reg_tbl(i).REGISTRATION_SOURCE_CODE
                                       ,party_tax_reg_tbl(i).REP_PARTY_TAX_NAME
                                       ,party_tax_reg_tbl(i).ROUNDING_LEVEL_CODE
                                       ,party_tax_reg_tbl(i).SELF_ASSESS_FLAG
                                       ,party_tax_reg_tbl(i).INCLUSIVE_TAX_FLAG
                                    );
                   --END FORALL;
    		   END LOOP; --party_tax_reg_cur BULK COLLECT LOOP
               --
               gvv_ProgressIndicator := '0090';
               --
               CLOSE party_tax_reg_cur;
               --
               gvv_ProgressIndicator := '0100';
    		   --
                    /*
                    ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
                    ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
                    ** is reached.  Also the rowcount for this extract will report TOTAL rows extracted across
                    ** all ZX Ledgers in the Migration Set.
                    */
                    --
    gvn_RowCount := xxmx_utilities_pkg.get_row_count
        (
             gct_StgSchema
            ,ct_StgTable
            ,pt_i_MigrationSetID
        );
    --
    COMMIT;
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
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '0110';
               --
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
                    IF   party_tax_reg_cur%ISOPEN
                    THEN
                         --
                         CLOSE party_tax_reg_cur;
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
                    IF   party_tax_reg_cur%ISOPEN
                    THEN
                         --
                         CLOSE party_tax_reg_cur;
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
                         ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    RAISE;
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END zx_tax_registration_stg;
	 
     --
     --************************************
     --** PROCEDURE: zx_party_classific_stg
     --************************************
     --	 

     PROCEDURE zx_party_classific_stg
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    )
     IS
          --
          -- CURSOR Declarations
          --
CURSOR party_classification_cur is
                SELECT  DISTINCT 
                     
                     'Customer site'                      as PARTY_TYPE_CODE
					,scope.party_site_number              as PARTY_NUMBER
                    ,scope.party_name                     as PARTY_NAME
                    ,''                                   as CLASS_CATEGORY
                    ,zxft.CLASSIFICATION_TYPE_CODE        as CLASSIFICATION_TYPE_CODE
                    ,zxft.CLASSIFICATION_TYPE_CODE        as CLASSIFICATION_TYPE_NAME
                    ,null                                 as TAX_REGIME_CODE
                    ,null                				  as FISCAL_CLASSIFICATION_CODE
                    ,hzca.CLASS_CODE                      as CLASS_CODE
                    ,hzca.START_DATE_ACTIVE               as EFFECTIVE_FROM
                    ,hzca.END_DATE_ACTIVE                 as EFFECTIVE_TO
                FROM 
                     HZ_CODE_ASSIGNMENTS@MXDM_NVIS_EXTRACT    hzca,
                     ZX_FC_TYPES_B@MXDM_NVIS_EXTRACT          zxft,
                     zx_party_tax_profile@MXDM_NVIS_EXTRACT   zxptp,
                     hz_party_sites@MXDM_NVIS_EXTRACT         hzps,
                     XXMX_CUSTOMER_SCOPE_V                    scope
                WHERE   hzca.CLASS_CATEGORY                      = 'Fiscal Classification'
                AND     nvl(hzca.END_DATE_ACTIVE,sysdate+10)     > sysdate
                AND     zxft.classification_type_code            = 'FISCAL CLASSFICATION'
                AND     hzca.owner_table_id                      = zxptp.party_tax_profile_id
                and     hzps.party_site_id                       = scope.party_site_id
                and     zxptp.party_type_code                    = 'THIRD_PARTY_SITE'
                and     zxptp.party_id                           = hzps.party_site_id
                and     zxft.OWNER_ID_CHAR                       = hzca.CLASS_CATEGORY  
                ;
          /*
          ********************
          ** Type Declarations
          ********************
          */
          --
          TYPE party_classification_tt IS TABLE OF party_classification_cur%ROWTYPE INDEX BY BINARY_INTEGER;
          --
          /*
          ************************
          ** Constant Declarations
          ************************
          */          
          --
          /*
          ** This is declared in each Procedure within the package to allow for
          ** a different value to be assigned in the Staging/Transform/Export
          ** procedures.
          */
          --
          cv_ProcOrFuncName               CONSTANT  VARCHAR2(30)                          := 'zx_party_classific_stg';
          ct_StgTable                     CONSTANT xxmx_migration_metadata.stg_table%TYPE := 'xxmx_zx_party_classific_stg';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXTRACT';
          --
          /*
          ************************
          ** Variable Declarations
          ************************
          */
          --
          gct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE         := 'PARTY_CLASSIFICATION';
          --
          /*
          ****************************
          ** Record Table Declarations
          ****************************
          */
          --
          --
		  /*
          ****************************
          ** PL/SQL Table Declarations
          ****************************
          */
          --
          party_classification_tbl                    party_classification_tt;
          --
          /*
          *************************
          ** Exception Declarations
          *************************
          */
          --
          --** Set gvt_Severity, gvv_ProgressIndicator and gvt_ModuleMessage
          --** before raising this exception.
          --
          e_ModuleError                   EXCEPTION;
          --
     --** END Declarations
     --
     --
     BEGIN
          --
          -- Delete any MODULE messages from previous executions
          -- for the Business Entity and Business Entity Level
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
          --
          -- Delete any DATA messages from previous executions
          -- for the Business Entity and Business Entity Level.
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
    /*
    ** Retrieve the Migration Set Name
    */
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
               /*
               ** The Migration Set has been initialised, so now initialize the detail record
               ** for the current entity.
               */
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
               gvv_ProgressIndicator := '0060';
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
                         ,pt_i_ModuleMessage     => '  - Extracting data into "'||ct_StgTable||'".'
                         ,pt_i_OracleError       => NULL
                         );
               --
               OPEN party_classification_cur;
               --
               LOOP
                    --
                    gvv_ProgressIndicator := '0070';
                    --
                    FETCH party_classification_cur
                       BULK 	COLLECT
                       INTO     party_classification_tbl
                       LIMIT    xxmx_utilities_pkg.gcn_BulkCollectLimit;
                    --
                    EXIT WHEN party_classification_tbl.COUNT = 0;
                    --
                    gvv_ProgressIndicator := '0080';
                    --
                    FORALL i IN 1..party_classification_tbl.COUNT
                         INSERT INTO xxmx_stg.xxmx_zx_party_classific_stg
                                     (
										 MIGRATION_SET_ID
										,MIGRATION_SET_NAME
										,MIGRATION_STATUS
										,PARTY_TYPE_CODE
										,PARTY_NUMBER
										,PARTY_NAME
										,CLASS_CATEGORY
										,CLASSIFICATION_TYPE_CODE
										,CLASSIFICATION_TYPE_NAME
										,TAX_REGIME_CODE
										,FISCAL_CLASSIFICATION_CODE
										,CLASS_CODE
										,EFFECTIVE_FROM
										,EFFECTIVE_TO
                                     )
                         VALUES
                                    (
                                        pt_i_MigrationSetID
                                       ,gvt_MigrationSetName
                                       ,'EXTRACTED'
									   ,party_classification_tbl(i).PARTY_TYPE_CODE
                                       ,party_classification_tbl(i).PARTY_NUMBER
                                       ,party_classification_tbl(i).PARTY_NAME
                                       ,party_classification_tbl(i).CLASS_CATEGORY
                                       ,party_classification_tbl(i).CLASSIFICATION_TYPE_CODE
                                       ,party_classification_tbl(i).CLASSIFICATION_TYPE_NAME
                                       ,party_classification_tbl(i).TAX_REGIME_CODE
									   ,party_classification_tbl(i).FISCAL_CLASSIFICATION_CODE
                                       ,party_classification_tbl(i).CLASS_CODE
                                       ,party_classification_tbl(i).EFFECTIVE_FROM
                                       ,party_classification_tbl(i).EFFECTIVE_TO
                                    );

                   --END FORALL;
               END LOOP;  --party_classification_cur BULK COLLECT LOOP
               --
               gvv_ProgressIndicator := '0090';
               --
               CLOSE party_classification_cur;
               --
               gvv_ProgressIndicator := '0100';
    		   --
                    /*
                    ** Obtain the count of rows inserted.  We cannot use SQL$ROWCOUNT here because of the LIMIT
                    ** clause on the BULK COLLECT statement.  The rowcount will be reset each time the limit
                    ** is reached.  Also the rowcount for this extract will report TOTAL rows extracted across
                    ** all ZX Ledgers in the Migration Set.
                    */
                    --
    gvn_RowCount := xxmx_utilities_pkg.get_row_count
        (
             gct_StgSchema
            ,ct_StgTable
            ,pt_i_MigrationSetID
        );
    --
    COMMIT;
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
               --** Update the migration details (Migration status will be automatically determined
               --** in the called procedure dependant on the Phase and if an Error Message has been
               --** passed).
               --
               gvv_ProgressIndicator := '0110';
               --
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
                    IF   party_classification_cur%ISOPEN
                    THEN
                         --
                         CLOSE party_classification_cur;
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
                    IF   party_classification_cur%ISOPEN
                    THEN
                         --
                         CLOSE party_classification_cur;
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
                         ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    RAISE;
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END zx_party_classific_stg;

end xxmx_zx_customer_tax_pkg;
/
