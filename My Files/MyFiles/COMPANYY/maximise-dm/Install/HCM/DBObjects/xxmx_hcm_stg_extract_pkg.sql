create or replace PACKAGE     xxmx_hcm_stg_extract_pkg
AS
     --
     /*
     *****************************************************************************
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
     *****************************************************************************
     **
     **
     ** FILENAME  :  xxmx_hcm_stg_extract_pkg.sql
     **
     ** FILEPATH  :  $XXMX_TOP/install/sql
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Pallavi Kanajar
     **
     ** PURPOSE   :  This script installs the package for the Maximise AR Transactions
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
     **            $XXMX_TOP/install/sql/xxmx_ar_trx_stg_dbi.sql
     **            $XXMX_TOP/install/sql/xxmx_ar_trx_xfm_dbi.sql
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
     ** xxmx_hcm_stg_extract_pkg.sql HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     **   1.0  09-Nov-2021  Pallavi Kanajar  Created for Maximise.
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
     /*
     **********************
     ** PROCEDURE: stg_main
     **********************
     */
     --
     PROCEDURE stg_main
                 (
                     pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_filesetid                  IN      xxmx_migration_headers.file_set_id%TYPE
                    );
     --
     --
     /*
     **********************
     ** PROCEDURE: xfm_main
     **********************
     */
     --
     PROCEDURE xfm_main
                    (
                     pt_i_BusinessEntity        IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_filesetid             IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID        IN      xxmx_migration_headers.migration_set_id%TYPE
                    );
     --
     --
     /*
     *******************
     ** PROCEDURE: purge
     *******************
     */
     --
     PROCEDURE purge
                   (
                 pt_i_BusinessEntity        IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_filesetid             IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID        IN      xxmx_migration_headers.migration_set_id%TYPE
                   );
     --
     --

END xxmx_hcm_stg_extract_pkg;
/

create or replace PACKAGE BODY      xxmx_hcm_stg_extract_pkg
AS
    /*
     ******************************************************************************
     **
     ** xxmx_hcm_stg_extract_pkg.sql HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     **   1.0  09-Nov-2021  Pallavi Kanajar  Created for Maximise.
     **
     ******************************************************************************
     */
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
     gvt_PackageName                           CONSTANT xxmx_module_messages.package_name%TYPE       := 'XXMX_HCM_STG_EXTRACT_PKG';
     gct_ApplicationSuite                      CONSTANT xxmx_module_messages.application_suite%TYPE  := 'HCM';
     gct_Application                                    xxmx_module_messages.application%TYPE;
     gct_StgSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_stg';
     gct_XfmSchema                             CONSTANT VARCHAR2(10)                                 := 'xxmx_xfm';
     gct_CoreSchema                            CONSTANT VARCHAR2(10)                                 := 'xxmx_core';
     gct_BusinessEntity                                 xxmx_migration_metadata.business_entity%TYPE := 'ALL';
     gvt_beapplicationsuite                             xxmx_module_messages.application%TYPE;
     gvt_beapplication                                  xxmx_module_messages.application%TYPE;
     --
     /*
     ** Global Variables for use in all Procedures/Functions within this package.
     */
     --
     gvv_ProgressIndicator                              VARCHAR2(100);
     gvt_Phase                                          VARCHAR2(20);
     GVT_FILESETID                                      VARCHAR2(30);
     GVT_MIGRATIONSETID                                 NUMBER;
     --

     /*
     ** Global Variables for receiving Status/Messages from certain Procedure/Function Calls (e.g. xxmx_utilities_pkg.clear_messages
     */
     --
     gvv_ReturnStatus                                   VARCHAR2(1);
     gvt_stgpopulationmethod                            VARCHAR2(20);
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
     gcv_SQLSpace                             CONSTANT  VARCHAR2(1) := '';
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

     PROCEDURE stg_main
                    (
                     pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_filesetid                  IN      xxmx_migration_headers.file_set_id%TYPE
                    )
     IS
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
          CURSOR SubEntityMetadata_cur
                      (
                       pt_ApplicationSuite             xxmx_migration_metadata.application_suite%TYPE
                      ,pt_Application                  xxmx_migration_metadata.application%TYPE
                      ,pt_BusinessEntity               xxmx_migration_metadata.business_entity%TYPE
                      )
          IS
               --
               SELECT  UPPER(xmm.sub_entity)                AS sub_entity
                      ,LOWER(xmm.Entity_package_name)      AS stg_population_package
                      ,LOWER(xmm.STG_PROCEDURE_NAME)        AS stg_population_procedure
               FROM    xxmx_migration_metadata  xmm
               WHERE   1 = 1
               AND     xmm.application_suite      = pt_ApplicationSuite
               AND     xmm.application            = pt_Application
               AND     xmm.business_entity        = pt_BusinessEntity
               AND     NVL(xmm.enabled_flag, 'N') = 'Y'
               AND    STG_TABLE is not null
               ORDER BY xmm.sub_entity_seq;
               --
          --** END CURSOR SubEntityMetadata_cur
          --
          CURSOR STGTables_cur
                      (
                       pt_ApplicationSuite             xxmx_migration_metadata.application_suite%TYPE
                      ,pt_Application                  xxmx_migration_metadata.application%TYPE
                      ,pt_BusinessEntity               xxmx_migration_metadata.business_entity%TYPE
                      )
          IS
               --
               SELECT    LOWER(xst.schema_name)     AS schema_name
                        ,LOWER(xst.table_name)      AS table_name
               FROM      xxmx_migration_metadata  xmm
                        ,xxmx_stg_tables          xst
               WHERE     1 = 1
               AND       xmm.application_suite      = pt_ApplicationSuite
               AND       xmm.application            = pt_Application
               AND       xmm.business_entity        = pt_BusinessEntity
               AND       NVL(xmm.enabled_flag, 'N') = 'Y'
               AND       xst.metadata_id            = xmm.metadata_id 
               ORDER BY  xmm.sub_entity_seq;
               --
          --** END CURSOR SubEntityMetadata_cur
          --
          CURSOR business_groups
          IS
          SELECT DISTINCT
                  haou.organization_id bg_id,
                  haou.name bg_name
          FROM    apps.hr_all_organization_units@MXDM_NVIS_EXTRACT    haou
                 ,apps.hr_organization_information@MXDM_NVIS_EXTRACT  hoi
          WHERE   1 = 1
          AND     hoi.organization_id   = haou.organization_id
          AND     hoi.org_information1  = 'HR_BG'
          AND     haou.name IN (
                                           SELECT xp.parameter_value
                                           FROM   xxmx_migration_parameters  xp
                                           WHERE  1 = 1
                                           AND    xp.application_suite      = 'HCM'            
                                           AND    xp.application            = 'HR'
                                           AND    xp.business_entity        = 'ALL'
                                           AND    xp.sub_entity             = 'ALL'
                                           AND    xp.parameter_code         = 'BUSINESS_GROUP_NAME'
                                           AND    NVL(xp.enabled_flag, 'N') = 'Y'
                        		)
           ;

          --
          --**********************
          --** Record Declarations
          --**********************
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'stg_main';
          ct_PrevalidateProcedureCall     CONSTANT  VARCHAR2(100)                               := 'xxmx_dynamic_sql_pkg.prevalidate_stg_data';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_ApplicationSuite             xxmx_migration_metadata.application_suite%TYPE;
          vt_Application                  xxmx_migration_metadata.application%TYPE;
          vt_BusinessEntity               xxmx_migration_metadata.business_entity%TYPE;
          vt_FileSetID                    xxmx_migration_headers.file_set_id%TYPE;
          vt_MigrationSetID               xxmx_migration_headers.migration_set_id%TYPE;
          vt_MigrationSetName             xxmx_migration_headers.migration_set_name%TYPE;
          vv_PreValidationErrors          VARCHAR2(1);
          vb_AnyPrevalidationErrors       BOOLEAN;

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
     --** END Declarations **
     --
     BEGIN
          --
          gvt_Phase := 'EXTRACT';
          --
          gvv_ProgressIndicator := '0010';
          --
          IF   NOT xxmx_utilities_pkg.valid_install
          THEN
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Installation Verification failed.  Please refer to the '
                                  ||'XXMX_MODULE_MESSAGES table for function "valid_install" to '
                                  ||'review detailed error messages.';
               --
               RAISE e_ModuleError;
               --
          ELSE
               --
               gvv_ProgressIndicator := '0020';
               --
               /*
               ** Retrieve the STG_POPULATION_METHOD core parameter value which will be used
               ** to determine if the pt_i_FileSetID parameter is mandatory.
               **
               ** The existence of this parameter and its value are validated in the 
               ** "xxmx_utilities_pkg.valid_install" function and if the installis not valid
               ** no further processing can be done.
               */
               --
               gvt_StgPopulationMethod := xxmx_utilities_pkg.get_core_parameter_value
                                               (
                                                pt_i_ParameterCode => 'STG_POPULATION_METHOD'
                                               );
               --
               gvv_ProgressIndicator := '0030';
               --
               vt_MigrationSetID := 0;
               --
               IF   gvt_StgPopulationMethod = 'DATA_FILE'
               THEN
                    --
                    IF   pt_i_BusinessEntity IS NULL
                    AND  pt_i_FileSetID      IS NULL
                    THEN
                         --
                         gvt_ModuleMessage := 'All parameters are mandatory when calling "'
                                            ||gvt_PackageName
                                            ||'.'
                                            ||ct_ProcOrFuncName
                                            ||' and STG_POPULATION_METHOD is "'
                                            ||gvt_StgPopulationMethod
                                            ||'".';
                         --
                         RAISE e_ModuleError;
                         --
                    ELSIF pt_i_BusinessEntity IS NULL
                    THEN
                         --
                         gvt_ModuleMessage := 'The "pt_i_BusinessEntity" parameter is mandatory when calling "'
                                            ||gvt_PackageName
                                            ||'.'
                                            ||ct_ProcOrFuncName
                                            ||' and STG_POPULATION_METHOD is "'
                                            ||gvt_StgPopulationMethod
                                            ||'".';
                         --
                         RAISE e_ModuleError;
                         --
                    ELSIF pt_i_FileSetID IS NULL
                    THEN
                         --
                         gvt_ModuleMessage := 'The "pt_i_FileSetID" parameter is mandatory when calling "'
                                            ||gvt_PackageName
                                            ||'.'
                                            ||ct_ProcOrFuncName
                                            ||' and STG_POPULATION_METHOD is "'
                                            ||gvt_StgPopulationMethod
                                            ||'".';
                         --
                         RAISE e_ModuleError;
                         --
                    ELSE /* Both parameters are supplied */
                         --
                         IF   LENGTH(pt_i_FileSetID) > 30
                         THEN
                              --
                              gvt_ModuleMessage := 'The "pt_i_FileSetID" parameter must be 30 characters or less when calling "'
                                                 ||gvt_PackageName
                                                 ||'.'
                                                 ||ct_ProcOrFuncName
                                                 ||'".';
                              --
                              RAISE e_ModuleError;
                              --
                         ELSE
                              --
                              vt_FileSetID := pt_i_FileSetID;
                              --
                         END IF; --** IF LENGTH(pt_i_FileSetID) > 30
                         --
                    END IF; --** IF Required Parameters are NULL
                    --
               ELSE /* STG_POPULATION_METHOD = 'DB_LINK */
                    --
                    IF   pt_i_BusinessEntity IS NULL
                    THEN
                         --
                         gvt_ModuleMessage := 'The "pt_i_BusinessEntity" parameter is mandatory when calling "'
                                            ||gvt_PackageName
                                            ||'.'
                                            ||ct_ProcOrFuncName
                                            ||' and STG_POPULATION_METHOD is "'
                                            ||gvt_StgPopulationMethod
                                            ||'".  The "pt_i_FileSetID" parameter is not relevant and will be set to 0.';
                         --
                         RAISE e_ModuleError;
                         --
                    END IF; --** IF Required Parameters are NULL
                    --
                    vt_FileSetID := 0;
                    --
               END IF; --** IF gvt_StgPopulationMethod  = 'DATA_FILE' OR 'DB_LINK'
               --
               vt_BusinessEntity := UPPER(pt_i_BusinessEntity);
               --
               /*
               ** Verify that the value in pt_i_BusinessEntity is valid.
               */
               --
               gvv_ProgressIndicator := '0040';
               --
               xxmx_utilities_pkg.verify_lookup_code
                    (
                     pt_i_LookupType    => 'BUSINESS_ENTITIES'
                    ,pt_i_LookupCode    => vt_BusinessEntity
                    ,pv_o_ReturnStatus  => gvv_ReturnStatus
                    ,pt_o_ReturnMessage => gvt_ReturnMessage
                    );
               --
               IF   gvv_ReturnStatus <> 'S'
               THEN
                    --
                    gvt_Severity      := 'ERROR';
                    gvt_ModuleMessage := gvt_ReturnMessage;
                    --
                    RAISE e_ModuleError;
                    --
               END IF;
               --
               /*
               ** Retrieve the Application Suite and Application for the Business Entity.
               **
               ** A Business Entity can only be defined for a single Application e.g. there
               ** cannot be an "INVOICES" Business Entity in both the "AP" and "AR"
               ** Applications therefore for "AR" the "TRANSACTIONS" Business Entity is used.
               */
               --
               gvv_ProgressIndicator := '0050';
               --
               xxmx_utilities_pkg.get_entity_application
                         (
                          pt_i_BusinessEntity   => vt_BusinessEntity
                         ,pt_o_ApplicationSuite => vt_ApplicationSuite
                         ,pt_o_Application      => vt_Application
                         ,pv_o_ReturnStatus     => gvv_ReturnStatus
                         ,pt_o_ReturnMessage    => gvt_ReturnMessage
                         );
               --
               IF   gvv_ReturnStatus <> 'S'
               THEN
                    --
                    gvt_Severity      := 'ERROR';
                    gvt_ModuleMessage := gvt_ReturnMessage;
                    --
                    RAISE e_ModuleError;
                    --
               END IF; --** IF gvv_ReturnStatus <> 'S'
               --
               gvv_ProgressIndicator := '0060';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => vt_ApplicationSuite
                    ,pt_i_Application       => vt_Application
                    ,pt_i_BusinessEntity    => vt_BusinessEntity
                    ,pt_i_SubEntity         => 'ALL'
                    ,pt_i_FileSetID         => vt_FileSetID
                    ,pt_i_MigrationSetID    => vt_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gvt_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => 'Procedure "'
                                               ||gvt_PackageName
                                               ||'.'
                                               ||ct_ProcOrFuncName
                                               ||'" initiated.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0070';
               --
               /*
               ** Now we verify (as best we can) if the setup specific to the
               ** Business Entity has been completed before we start processing
               ** any data.
               */
               --
               IF  NOT xxmx_utilities_pkg.valid_business_entity_setup
                            (
                             pt_i_BusinessEntity
                            )
               THEN
                    --
                    gvt_Severity      := 'ERROR';
                    gvt_ModuleMessage := '- Business Entity Setup Verification failed.  Please refer to the '
                                       ||'XXMX_MODULE_MESSAGES table for function "valid_business_entity_setup" to '
                                       ||'review detailed error messages.';
                    --
                    RAISE e_ModuleError;
                    --
               ELSE
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => vt_ApplicationSuite
                         ,pt_i_Application       => vt_Application
                         ,pt_i_BusinessEntity    => vt_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         ,pt_i_FileSetID         => vt_FileSetID
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gvt_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '- Performing "'
                                                  ||gvt_StgPopulationMethod
                                                  ||'" processing path for "'
                                                  ||gvt_Phase
                                                  ||'" Phase.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    IF   gvt_StgPopulationMethod = 'DATA_FILE'
                    THEN
                         --
                         /*
                         ** For Client Data Extract provided in Data Files, we will not generate
                         ** a Migration Set ID as we do for PL/SQL extracted data.  The Client
                         ** provided File Set ID will be used to identify all Client Data involved
                         ** in a single load.
                         **
                         ** We will still generate a Migration Set Name using the
                         ** "xxmx_utilities_pkg.init_file_migration_set" procedure.
                         **
                         ** Subsequent Dynamic SQL processing (and all message logging) will use
                         ** the File Set ID.
                         **
                         ** If there are ANY pre-validation errors for ANY Sub-Entity, the Client
                         ** must correct the data and re-load the files.
                         **
                         ** If there are NO pre-validation errors, then any Seeded and Custom
                         ** Extensions are then executed.
                         */
                         --
                         /*
                         ** Loop through the Migration Metadata table to retrieve
                         ** each Sub-entity Name for which to call the Dynamic SQL
                         ** Pre-validation procedure.
                         */
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite    => vt_ApplicationSuite
                              ,pt_i_Application         => vt_Application
                              ,pt_i_BusinessEntity      => vt_BusinessEntity
                              ,pt_i_SubEntity           => 'ALL'
                              ,pt_i_FileSetID           => vt_FileSetID
                              ,pt_i_MigrationSetID      => vt_MigrationSetID
                              ,pt_i_Phase               => gvt_Phase
                              ,pt_i_Severity            => 'NOTIFICATION'
                              ,pt_i_PackageName         => gvt_PackageName
                              ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage       => '  - Generating Migration Set Name and registering Migration Header.'
                              ,pt_i_OracleError         => NULL
                              );
                         --
                         xxmx_utilities_pkg.init_file_migration_set
                              (
                               pt_i_ApplicationSuite => vt_ApplicationSuite
                              ,pt_i_Application      => vt_Application
                              ,pt_i_BusinessEntity   => vt_BusinessEntity
                              ,pt_i_FileSetID        => vt_FileSetID
                              ,pt_o_MigrationSetName => vt_MigrationSetName
                              );
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite    => vt_ApplicationSuite
                              ,pt_i_Application         => vt_Application
                              ,pt_i_BusinessEntity      => vt_BusinessEntity
                              ,pt_i_SubEntity           => 'ALL'
                              ,pt_i_FileSetID           => vt_FileSetID
                              ,pt_i_MigrationSetID      => vt_MigrationSetID
                              ,pt_i_Phase               => gvt_Phase
                              ,pt_i_Severity            => 'NOTIFICATION'
                              ,pt_i_PackageName         => gvt_PackageName
                              ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage       => '    - Generated Migration Set Name = "'
                                                         ||vt_MigrationSetName
                                                         ||'".'
                              ,pt_i_OracleError         => NULL
                              );
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite    => vt_ApplicationSuite
                              ,pt_i_Application         => vt_Application
                              ,pt_i_BusinessEntity      => vt_BusinessEntity
                              ,pt_i_SubEntity           => 'ALL'
                              ,pt_i_FileSetID           => vt_FileSetID
                              ,pt_i_MigrationSetID      => vt_MigrationSetID
                              ,pt_i_Phase               => gvt_Phase
                              ,pt_i_Severity            => 'NOTIFICATION'
                              ,pt_i_PackageName         => gvt_PackageName
                              ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage       => '  - Migration Header registered.'
                              ,pt_i_OracleError         => NULL
                              );
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite    => vt_ApplicationSuite
                              ,pt_i_Application         => vt_Application
                              ,pt_i_BusinessEntity      => vt_BusinessEntity
                              ,pt_i_SubEntity           => 'ALL'
                              ,pt_i_FileSetID           => vt_FileSetID
                              ,pt_i_MigrationSetID      => vt_MigrationSetID
                              ,pt_i_Phase               => gvt_Phase
                              ,pt_i_Severity            => 'NOTIFICATION'
                              ,pt_i_PackageName         => gvt_PackageName
                              ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage       => '  - Pre-validating STG table data loaded from data file.'
                              ,pt_i_OracleError         => NULL
                              );
                         --
                         gvv_ProgressIndicator := '0050';
                         --
                         vb_AnyPrevalidationErrors := FALSE;
                         --
                         FOR  SubEntityMetadata_rec
                         IN   SubEntityMetadata_cur
                                   (
                                    vt_ApplicationSuite
                                   ,vt_Application
                                   ,vt_BusinessEntity
                                   )
                         LOOP
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite    => vt_ApplicationSuite
                                   ,pt_i_Application         => vt_Application
                                   ,pt_i_BusinessEntity      => vt_BusinessEntity
                                   ,pt_i_SubEntity           => 'ALL'
                                   ,pt_i_FileSetID           => vt_FileSetID
                                   ,pt_i_MigrationSetID      => vt_MigrationSetID
                                   ,pt_i_Phase               => gvt_Phase
                                   ,pt_i_Severity            => 'NOTIFICATION'
                                   ,pt_i_PackageName         => gvt_PackageName
                                   ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage       => '    - Calling Procedure "'
                                                                ||ct_PrevalidateProcedureCall
                                                                ||'" for Sub-Entity "'
                                                                ||SubEntityMetadata_rec.sub_entity
                                                                ||'".'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                              gvv_SQLStatement := 'BEGIN '
                                                ||ct_PrevalidateProcedureCall
                                                ||gcv_SQLSpace
                                                ||'('
                                                ||' pt_i_ApplicationSuite => :1 '
                                                ||',pt_i_Application => :2 '
                                                ||',pt_i_BusinessEntity => :3 '
                                                ||',pt_i_SubEntity => :4 '
                                                ||',pt_i_FileSetID => :5 '
                                                ||',pv_o_ReturnStatus => :6 '
                                                ||'); END;';
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite    => vt_ApplicationSuite
                                   ,pt_i_Application         => vt_Application
                                   ,pt_i_BusinessEntity      => vt_BusinessEntity
                                   ,pt_i_SubEntity           => 'ALL'
                                   ,pt_i_FileSetID           => vt_FileSetID
                                   ,pt_i_MigrationSetID      => vt_MigrationSetID
                                   ,pt_i_Phase               => gvt_Phase
                                   ,pt_i_Severity            => 'NOTIFICATION'
                                   ,pt_i_PackageName         => gvt_PackageName
                                   ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage       => SUBSTR(
                                                                       '      - Generated SQL Statement: ' ||gvv_SQLStatement
                                                                      ,1
                                                                      ,4000
                                                                      )
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                              EXECUTE IMMEDIATE gvv_SQLStatement
                                          USING IN  vt_ApplicationSuite
                                               ,IN  vt_Application
                                               ,IN  vt_BusinessEntity
                                               ,IN  SubEntityMetadata_rec.sub_entity
                                               ,IN  vt_FileSetID
                                               ,OUT gvv_ReturnStatus;
                              --
                              IF   gvv_ReturnStatus <> 'S'
                              THEN
                                   --
                                   xxmx_utilities_pkg.log_module_message
                                        (
                                         pt_i_ApplicationSuite    => vt_ApplicationSuite
                                        ,pt_i_Application         => vt_Application
                                        ,pt_i_BusinessEntity      => vt_BusinessEntity
                                        ,pt_i_SubEntity           => SubEntityMetadata_rec.sub_entity
                                        ,pt_i_FileSetID           => vt_FileSetID
                                        ,pt_i_MigrationSetID      => vt_MigrationSetID
                                        ,pt_i_Phase               => gvt_Phase
                                        ,pt_i_Severity            => 'ERROR'
                                        ,pt_i_PackageName         => gvt_PackageName
                                        ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage       => '      - Pre-validation Procedure returned a FAIL status.  Please review '
                                                                   ||'the XXMX_MODULE_MESSAGES table for this procedure.'
                                        ,pt_i_OracleError         => NULL
                                        );
                                   --
                                   vb_AnyPrevalidationErrors := TRUE;
                                   --
                              ELSE
                                   --
                                   xxmx_utilities_pkg.log_module_message
                                        (
                                         pt_i_ApplicationSuite    => vt_ApplicationSuite
                                        ,pt_i_Application         => vt_Application
                                        ,pt_i_BusinessEntity      => vt_BusinessEntity
                                        ,pt_i_SubEntity           => SubEntityMetadata_rec.sub_entity
                                        ,pt_i_FileSetID           => vt_FileSetID
                                        ,pt_i_MigrationSetID      => vt_MigrationSetID
                                        ,pt_i_Phase               => gvt_Phase
                                        ,pt_i_Severity            => 'NOTIFICATION'
                                        ,pt_i_PackageName         => gvt_PackageName
                                        ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage       => '      - Pre-validation Procedure returned a SUCCESS status.'
                                        ,pt_i_OracleError         => NULL
                                        );
                                   --
                              END IF;
                              --
                         END LOOP; --** SubEntityMetadata_cur LOOP
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite    => vt_ApplicationSuite
                              ,pt_i_Application         => vt_Application
                              ,pt_i_BusinessEntity      => vt_BusinessEntity
                              ,pt_i_SubEntity           => 'ALL'
                              ,pt_i_FileSetID           => vt_FileSetID
                              ,pt_i_MigrationSetID      => vt_MigrationSetID
                              ,pt_i_Phase               => gvt_Phase
                              ,pt_i_Severity            => 'NOTIFICATION'
                              ,pt_i_PackageName         => gvt_PackageName
                              ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage       => '  - Pre-validation complete.'
                              ,pt_i_OracleError         => NULL
                              );
                         --
                         IF   vb_AnyPrevalidationErrors
                         THEN
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite    => vt_ApplicationSuite
                                  ,pt_i_Application         => vt_Application
                                  ,pt_i_BusinessEntity      => vt_BusinessEntity
                                  ,pt_i_SubEntity           => 'ALL'
                                  ,pt_i_FileSetID           => vt_FileSetID
                                   ,pt_i_MigrationSetID      => vt_MigrationSetID
                                   ,pt_i_Phase               => gvt_Phase
                                   ,pt_i_Severity            => 'ERROR'
                                   ,pt_i_PackageName         => gvt_PackageName
                                   ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage       => '  - One or more Sub-Entities failed pre-validation.  '
                                                              ||'Please rectify the data errors and reload the data.'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                         ELSE
                              --
                              /*
                              ** As there are no Pre-validation errors for ANY Sub-Entity, we can now call
                              ** any Maximise provided extensions (if any).
                              ** 
                              ** Some extensions may only operate specifically on a single Sub-Entity table
                              ** and therefore we call them "Sub-Extensions".  However some extensions may
                              ** need to update several Sub-Entity STG tables at the same time so we call
                              ** these Business Entity Extensions.
                              **
                              ** Business Entity and Sub-Entity extension definitions are stored in separate
                              ** tables to keep their execution sequences separate.
                              **
                              ** Some Business Entity extensions may need to be specifically run BEFORE the
                              ** Sub-Entity Extensions and some may need to be specifically run AFTER.
                              **
                              ** This functionality is all encapsulated in the Extention Handler procedures
                              ** "execute_extensions" and "execute_custom_extensions".
                              */
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite    => vt_ApplicationSuite
                                   ,pt_i_Application         => vt_Application
                                   ,pt_i_BusinessEntity      => vt_BusinessEntity
                                   ,pt_i_SubEntity           => 'ALL'
                                   ,pt_i_FileSetID           => vt_FileSetID
                                   ,pt_i_MigrationSetID      => vt_MigrationSetID
                                   ,pt_i_Phase               => gvt_Phase
                                   ,pt_i_Severity            => 'NOTIFICATION'
                                   ,pt_i_PackageName         => gvt_PackageName
                                   ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage       => '  - Calling Extension handler for Seeded Extensions:'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                              xxmx_dynamic_sql_pkg.execute_extension
                                   (
                                    pt_i_ApplicationSuite    => vt_ApplicationSuite
                                   ,pt_i_Application         => vt_Application
                                   ,pt_i_BusinessEntity      => vt_BusinessEntity
                                   ,pv_i_ExtensionType       => 'SEEDED'
                                   ,pt_i_Phase               => gvt_Phase
                                   ,pt_i_StgPopulationMethod => gvt_StgPopulationMethod
                                   ,pt_i_FileSetID           => vt_FileSetID
                                   ,pt_i_MigrationSetID      => vt_MigrationSetID
                                   ,pv_o_ReturnStatus        => gvv_ReturnStatus
                                   ,pv_o_ReturnMessage       => gvt_ReturnMessage
                                   );
                              --
                              IF   gvv_ReturnStatus <> 'S'
                              THEN
                                   --
                                   xxmx_utilities_pkg.log_module_message
                                        (
                                         pt_i_ApplicationSuite    => vt_ApplicationSuite
                                        ,pt_i_Application         => vt_Application
                                        ,pt_i_BusinessEntity      => vt_BusinessEntity
                                        ,pt_i_SubEntity           => 'ALL'
                                        ,pt_i_FileSetID           => vt_FileSetID
                                        ,pt_i_MigrationSetID      => vt_MigrationSetID
                                        ,pt_i_Phase               => gvt_Phase
                                        ,pt_i_Severity            => 'ERROR'
                                        ,pt_i_PackageName         => gvt_PackageName
                                        ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage       => '    - '
                                                                   ||gvt_ReturnMessage
                                        ,pt_i_OracleError         => NULL
                                        );
                                   --
                              END IF; --** IF gvv_ReturnStatus <> 'S'
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite    => vt_ApplicationSuite
                                   ,pt_i_Application         => vt_Application
                                   ,pt_i_BusinessEntity      => vt_BusinessEntity
                                   ,pt_i_SubEntity           => 'ALL'
                                   ,pt_i_FileSetID           => vt_FileSetID
                                   ,pt_i_MigrationSetID      => vt_MigrationSetID
                                   ,pt_i_Phase               => gvt_Phase
                                   ,pt_i_Severity            => 'NOTIFICATION'
                                   ,pt_i_PackageName         => gvt_PackageName
                                   ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage       => '  - Seeded Extension Handler complete.'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                              /*
                              ** After Maximise seeded Extensions have been executed, any custom extensions developed
                              ** by V 1 Implementation Teams or Client Development Teams are executed (if any).
                              */
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite    => vt_ApplicationSuite
                                   ,pt_i_Application         => vt_Application
                                   ,pt_i_BusinessEntity      => vt_BusinessEntity
                                   ,pt_i_SubEntity           => 'ALL'
                                   ,pt_i_FileSetID           => vt_FileSetID
                                   ,pt_i_MigrationSetID      => vt_MigrationSetID
                                   ,pt_i_Phase               => gvt_Phase
                                   ,pt_i_Severity            => 'NOTIFICATION'
                                   ,pt_i_PackageName         => gvt_PackageName
                                   ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage       => '  - Calling Extension handler for Custom Extensions:'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                             xxmx_dynamic_sql_pkg.execute_extension
                                   (
                                    pt_i_ApplicationSuite    => vt_ApplicationSuite
                                   ,pt_i_Application         => vt_Application
                                   ,pt_i_BusinessEntity      => vt_BusinessEntity
                                   ,pv_i_ExtensionType       => 'CUSTOM'
                                   ,pt_i_Phase               => gvt_Phase
                                   ,pt_i_StgPopulationMethod => gvt_StgPopulationMethod
                                   ,pt_i_FileSetID           => vt_FileSetID
                                   ,pt_i_MigrationSetID      => vt_MigrationSetID
                                   ,pv_o_ReturnStatus        => gvv_ReturnStatus
                                   ,pv_o_ReturnMessage       => gvt_ReturnMessage
                                   );
                              --
                              IF   gvv_ReturnStatus <> 'S'
                              THEN
                                   --
                                   xxmx_utilities_pkg.log_module_message
                                        (
                                        pt_i_ApplicationSuite    => vt_ApplicationSuite
                                        ,pt_i_Application         => vt_Application
                                        ,pt_i_BusinessEntity      => vt_BusinessEntity
                                        ,pt_i_SubEntity           => 'ALL'
                                        ,pt_i_FileSetID           => vt_FileSetID
                                        ,pt_i_MigrationSetID      => vt_MigrationSetID
                                        ,pt_i_Phase               => gvt_Phase
                                        ,pt_i_Severity            => 'ERROR'
                                        ,pt_i_PackageName         => gvt_PackageName
                                        ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage       => '    - '
                                                                   ||gvt_ReturnMessage
                                        ,pt_i_OracleError         => NULL
                                        );
                                   --
                              END IF; --** IF gvv_ReturnStatus <> 'S'
                              --
                         END IF; --**IF   NOT vb_AnyPrevalidationErrors
                         --
                    ELSE /* STG_POPULATION_METHOD_PARAMETER is "DB_LINK" */
                         --
                         /*
                         ** For Client Data Extract using Maximise PL/SQL packaged Extract 
                         ** procedures over a DB Link, a Migration Set ID is generated before
                         ** any of the Sub-Entity Extract procedures are submitted.
                         **
                         ** File Set ID is not relevant for PL/SQL extracted Client Data (and
                         ** hence is set to 0 earlier in this procedure).
                         **
                         ** As data is beig extracted directly from the Source EBS Database,
                         ** pre-validation is not required and all validation will be performed
                         ** in the TRANSFORM phase.
                         **
                         ** Once all extracts have completed, any Seeded and Custom Extensions
                         ** are executed.
                         */
                         --
                         /*
                         ** Initialize the Migration Set for the Business Entity retrieving
                         ** a new Migration Set ID and Name.          
                         */
                         --
                         gvv_ProgressIndicator := '0040';
                         --
                         xxmx_utilities_pkg.init_ext_migration_set
                              (
                               pt_i_ApplicationSuite    => vt_ApplicationSuite
                              ,pt_i_Application         => vt_Application
                              ,pt_i_BusinessEntity      => vt_BusinessEntity
                              ,pt_o_MigrationSetID    => vt_MigrationSetID
                              ,pt_o_MigrationSetName  => vt_MigrationSetName
                              );
                         --
                         IF   vt_MigrationSetID IS NULL
                         THEN
                              --
                              gvt_Severity      := 'ERROR';
                              gvt_ModuleMessage := '  - A Migration Set ID could not be generated.  Please refer to the XXMX_MODULE_MESSAGES table.';
                              --
                              RAISE e_ModuleError;
                              --
                         ELSE
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite    => vt_ApplicationSuite
                                   ,pt_i_Application         => vt_Application
                                   ,pt_i_BusinessEntity      => vt_BusinessEntity
                                   ,pt_i_SubEntity           => 'ALL'
                                   ,pt_i_FileSetID           => vt_FileSetID
                                   ,pt_i_MigrationSetID      => vt_MigrationSetID
                                   ,pt_i_Phase               => gvt_Phase
                                   ,pt_i_Severity            => 'NOTIFICATION'
                                   ,pt_i_PackageName         => gvt_PackageName
                                   ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage       => '  - Migration Set "'
                                                                ||vt_MigrationSetName
                                                                ||'" registered (Migration Set ID = '
                                                                ||vt_MigrationSetID
                                                                ||').'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite    => vt_ApplicationSuite
                                   ,pt_i_Application         => vt_Application
                                   ,pt_i_BusinessEntity      => vt_BusinessEntity
                                   ,pt_i_SubEntity           => 'ALL'
                                   ,pt_i_FileSetID           => vt_FileSetID
                                   ,pt_i_MigrationSetID      => vt_MigrationSetID
                                   ,pt_i_Phase               => gvt_Phase
                                   ,pt_i_Severity            => 'NOTIFICATION'
                                   ,pt_i_PackageName         => gvt_PackageName
                                   ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage       => '  - Calling Data Extract Procedures:'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                              /*
                              ** Loop through the Migration Metadata table to retrieve
                              ** the Data Extract Package Name and Procedure Name for
                              ** each Sub-Entity for the current Business Entity.
                              */
                              --
                              gvv_ProgressIndicator := '0050';
                              --
                              FOR business_groups_rec
                              IN business_groups
                              LOOP

                                      FOR  SubEntityMetadata_rec
                                      IN   SubEntityMetadata_cur
                                                (
                                                 vt_ApplicationSuite
                                                ,vt_Application
                                                ,vt_BusinessEntity
                                                )
                                      LOOP
                                           --
                                           xxmx_utilities_pkg.log_module_message
                                                (
                                                 pt_i_ApplicationSuite    => vt_ApplicationSuite
                                                ,pt_i_Application         => vt_Application
                                                ,pt_i_BusinessEntity      => vt_BusinessEntity
                                                ,pt_i_SubEntity           => 'ALL'
                                                ,pt_i_FileSetID           => vt_FileSetID
                                                ,pt_i_MigrationSetID      => vt_MigrationSetID
                                                ,pt_i_Phase               => gvt_Phase
                                                ,pt_i_Severity            => 'NOTIFICATION'
                                                ,pt_i_PackageName         => gvt_PackageName
                                                ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                                ,pt_i_ModuleMessage       => '    - Calling Procedure "'
                                                                             ||SubEntityMetadata_rec.stg_population_package
                                                                             ||'.'
                                                                             ||SubEntityMetadata_rec.stg_population_procedure
                                                                             ||'" for Sub-Entity "'
                                                                             ||SubEntityMetadata_rec.sub_entity
                                                                             ||' for Business Group '|| business_groups_rec.bg_name
                                                                             ||'".'
                                                ,pt_i_OracleError         => NULL
                                                );
                                           --
                                           /*
                                           ** Individual Data Extract Procedures will have Extract Cursors
                                           ** to insert into harcoded STG tables.
                                           **
                                           ** The extract procedures are only ever called if Client Data
                                           ** is being extracted via DB Link, so there is no need to pass
                                           ** File Set ID.  The extract procedure will default File Set ID
                                           ** to 0 during insert into the STG table.
                                           */
                                           --
                                           gvv_SQLStatement := 'BEGIN '
                                                             ||SubEntityMetadata_rec.stg_population_package
                                                             ||'.'
                                                             ||SubEntityMetadata_rec.stg_population_procedure
                                                             ||gcv_SQLSpace
                                                             ||'('
                                                             ||'p_bg_name => '''
                                                             ||business_groups_rec.bg_name
                                                             ||''''
                                                             ||', p_bg_id => '''
                                                             ||business_groups_rec.bg_id
                                                             ||''''
                                                             ||', pt_i_MigrationSetID => '
                                                             ||vt_MigrationSetID
                                                             ||', pt_i_MigrationSetName => '''
                                                             ||vt_MigrationSetName
                                                             ||''''
                                                             ||'); END;';
                                           --
                                           xxmx_utilities_pkg.log_module_message
                                                (
                                                 pt_i_ApplicationSuite    => vt_ApplicationSuite
                                                ,pt_i_Application         => vt_Application
                                                ,pt_i_BusinessEntity      => vt_BusinessEntity
                                                ,pt_i_SubEntity           => 'ALL'
                                                ,pt_i_FileSetID           => vt_FileSetID
                                                ,pt_i_MigrationSetID      => vt_MigrationSetID
                                                ,pt_i_Phase               => gvt_Phase
                                                ,pt_i_Severity            => 'NOTIFICATION'
                                                ,pt_i_PackageName         => gvt_PackageName
                                                ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                                ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                                ,pt_i_ModuleMessage       => SUBSTR(
                                                                                    '      - Generated SQL Statement: ' ||gvv_SQLStatement
                                                                                   ,1
                                                                                   ,4000
                                                                                   )
                                                ,pt_i_OracleError         => NULL
                                                );
                                           --
                                           EXECUTE IMMEDIATE gvv_SQLStatement;
                                           --
                                      END LOOP;
                              END LOOP;
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite    => vt_ApplicationSuite
                                   ,pt_i_Application         => vt_Application
                                   ,pt_i_BusinessEntity      => vt_BusinessEntity
                                   ,pt_i_SubEntity           => 'ALL'
                                   ,pt_i_FileSetID           => vt_FileSetID
                                   ,pt_i_MigrationSetID      => vt_MigrationSetID
                                   ,pt_i_Phase               => gvt_Phase
                                   ,pt_i_Severity            => 'NOTIFICATION'
                                   ,pt_i_PackageName         => gvt_PackageName
                                   ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage       => '  - Data Extract Procedure calls complete.'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                              /*
                              ** Once all Sub-Entity extracts have completed and the STG tables populated,
                              ** we can now call any Maximise provided extensions (if any).
                              ** 
                              ** Some extensions may only operate specifically on a single Sub-Entity table
                              ** and therefore we call them "Sub-Extensions".  However some extensions may
                              ** need to update several Sub-Entity STG tables at the same time so we call
                              ** these Business Entity Extensions.
                              **
                              ** Business Entity and Sub-Entity extension definitions are stored in separate
                              ** tables to keep their execution sequences separate.
                              **
                              ** Some Business Entity extensions may need to be specifically run BEFORE the
                              ** Sub-Entity Extensions and some may need to be specifically run AFTER.
                              **
                              ** This functionality is all encapsulated in the Extention Handler procedures
                              ** "execute_extensions" and "execute_custom_extensions".
                              */
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite    => vt_ApplicationSuite
                                   ,pt_i_Application         => vt_Application
                                   ,pt_i_BusinessEntity      => vt_BusinessEntity
                                   ,pt_i_SubEntity           => 'ALL'
                                   ,pt_i_FileSetID           => vt_FileSetID
                                   ,pt_i_MigrationSetID      => vt_MigrationSetID
                                   ,pt_i_Phase               => gvt_Phase
                                   ,pt_i_Severity            => 'NOTIFICATION'
                                   ,pt_i_PackageName         => gvt_PackageName
                                   ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage       => '  - Calling Extension handler for Seeded Extensions:'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                              xxmx_dynamic_sql_pkg.execute_extension
                                   (
                                    pt_i_ApplicationSuite    => vt_ApplicationSuite
                                   ,pt_i_Application         => vt_Application
                                   ,pt_i_BusinessEntity      => vt_BusinessEntity
                                   ,pv_i_ExtensionType       => 'SEEDED'
                                   ,pt_i_Phase               => gvt_Phase
                                   ,pt_i_StgPopulationMethod => gvt_StgPopulationMethod
                                   ,pt_i_FileSetID           => vt_FileSetID
                                   ,pt_i_MigrationSetID      => vt_MigrationSetID
                                   ,pv_o_ReturnStatus        => gvv_ReturnStatus
                                   ,pv_o_ReturnMessage       => gvt_ReturnMessage
                                   );
                              --
                              IF   gvv_ReturnStatus <> 'S'
                              THEN
                                   --
                                   xxmx_utilities_pkg.log_module_message
                                        (
                                         pt_i_ApplicationSuite    => vt_ApplicationSuite
                                        ,pt_i_Application         => vt_Application
                                        ,pt_i_BusinessEntity      => pt_i_BusinessEntity
                                        ,pt_i_SubEntity           => 'ALL'
                                        ,pt_i_FileSetID           => vt_FileSetID
                                        ,pt_i_MigrationSetID      => vt_MigrationSetID
                                        ,pt_i_Phase               => gvt_Phase
                                        ,pt_i_Severity            => 'ERROR'
                                        ,pt_i_PackageName         => gvt_PackageName
                                        ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage       => '    - '
                                                                   ||gvt_ReturnMessage
                                        ,pt_i_OracleError         => NULL
                                        );
                                   --
                              END IF; --** IF gvv_ReturnStatus <> 'S'
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite    => vt_ApplicationSuite
                                   ,pt_i_Application         => vt_Application
                                   ,pt_i_BusinessEntity      => vt_BusinessEntity
                                   ,pt_i_SubEntity           => 'ALL'
                                   ,pt_i_FileSetID           => vt_FileSetID
                                   ,pt_i_MigrationSetID      => vt_MigrationSetID
                                   ,pt_i_Phase               => gvt_Phase
                                   ,pt_i_Severity            => 'NOTIFICATION'
                                   ,pt_i_PackageName         => gvt_PackageName
                                   ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage       => '  - Seeded Extension Handler complete.'
                                   ,pt_i_OracleError         => NULL
                                   );
                              /*
                              ** After Maximise provided have been executed, any custom extensions developed
                              ** by V 1 Implementation Teams or Client Development Teams are executed (if any).
                              */
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite    => vt_ApplicationSuite
                                   ,pt_i_Application         => vt_Application
                                   ,pt_i_BusinessEntity      => vt_BusinessEntity
                                   ,pt_i_SubEntity           => 'ALL'
                                   ,pt_i_FileSetID           => vt_FileSetID
                                   ,pt_i_MigrationSetID      => vt_MigrationSetID
                                   ,pt_i_Phase               => gvt_Phase
                                   ,pt_i_Severity            => 'NOTIFICATION'
                                   ,pt_i_PackageName         => gvt_PackageName
                                   ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage       => '  - Calling Extension handler for Custom Extensions:'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                              xxmx_dynamic_sql_pkg.execute_extension
                                   (
                                    pt_i_ApplicationSuite    => vt_ApplicationSuite
                                   ,pt_i_Application         => vt_Application
                                   ,pt_i_BusinessEntity      => vt_BusinessEntity
                                   ,pv_i_ExtensionType       => 'CUSTOM'
                                   ,pt_i_Phase               => gvt_Phase
                                   ,pt_i_StgPopulationMethod => gvt_StgPopulationMethod
                                   ,pt_i_FileSetID           => vt_FileSetID
                                   ,pt_i_MigrationSetID      => vt_MigrationSetID
                                   ,pv_o_ReturnStatus        => gvv_ReturnStatus
                                   ,pv_o_ReturnMessage       => gvt_ReturnMessage
                                   );
                              --
                              IF   gvv_ReturnStatus <> 'S'
                              THEN
                                   --
                                   xxmx_utilities_pkg.log_module_message
                                        (
                                          pt_i_ApplicationSuite    => vt_ApplicationSuite
                                   ,pt_i_Application         => vt_Application
                                   ,pt_i_BusinessEntity      => vt_BusinessEntity
                                        ,pt_i_SubEntity           => 'ALL'
                                        ,pt_i_FileSetID           => vt_FileSetID
                                        ,pt_i_MigrationSetID      => vt_MigrationSetID
                                        ,pt_i_Phase               => gvt_Phase
                                        ,pt_i_Severity            => 'ERROR'
                                        ,pt_i_PackageName         => gvt_PackageName
                                        ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage       => '    - '
                                                                   ||gvt_ReturnMessage
                                        ,pt_i_OracleError         => NULL
                                        );
                                   --
                              END IF; --** IF gvv_ReturnStatus <> 'S'
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite    => vt_ApplicationSuite
                                   ,pt_i_Application         => vt_Application
                                   ,pt_i_BusinessEntity      => vt_BusinessEntity
                                   ,pt_i_SubEntity           => 'ALL'
                                   ,pt_i_FileSetID           => vt_FileSetID
                                   ,pt_i_MigrationSetID      => vt_MigrationSetID
                                   ,pt_i_Phase               => gvt_Phase
                                   ,pt_i_Severity            => 'NOTIFICATION'
                                   ,pt_i_PackageName         => gvt_PackageName
                                   ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage       => '  - Custom Extension Handler complete.'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                         END IF; --** IF vt_MigrationSetID IS NULL
                         --
                    END IF; --** IF gvt_StgPopulationMethod = 'DB_LINK' OR "DATA_FILE"
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => vt_ApplicationSuite
                         ,pt_i_Application       => vt_Application
                         ,pt_i_BusinessEntity    => vt_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         ,pt_i_FileSetID         => vt_FileSetID
                         ,pt_i_MigrationSetID    => vt_MigrationSetID
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gvt_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '- "'
                                                  ||gvt_StgPopulationMethod
                                                  ||'" processing path for "'
                                                  ||gvt_Phase
                                                  ||'" Phase complete.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    COMMIT;
                    --
                    gvv_ProgressIndicator := '0060';
                    --
                    --xxmx_utilities_pkg.close_extract_phase
                    --     (
                    --      vt_MigrationSetID
                    --     );
                    --
               END IF; --** IF NOT xxmx_utilities_pkg.valid_business_entity_setup
               --
          END IF; --** IF NOT xxmx_utilities_pkg.valid_install
          --
          xxmx_utilities_pkg.log_module_message
               (
                 pt_i_ApplicationSuite    => vt_ApplicationSuite
                ,pt_i_Application         => vt_Application
                ,pt_i_BusinessEntity      => pt_i_BusinessEntity
                ,pt_i_SubEntity           => 'ALL'
               ,pt_i_FileSetID           => 0
               ,pt_i_MigrationSetID      => 0
               ,pt_i_Phase               => gvt_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gvt_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                            ||gvt_PackageName
                                            ||'.'
                                            ||ct_ProcOrFuncName
                                            ||'" completed.'
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
                           pt_i_ApplicationSuite    => vt_ApplicationSuite
                                   ,pt_i_Application         => vt_Application
                                   ,pt_i_BusinessEntity      => vt_BusinessEntity
                         ,pt_i_SubEntity           => 'ALL'
                         ,pt_i_FileSetID           => 0
                         ,pt_i_MigrationSetID      => 0
                         ,pt_i_Phase               => gvt_Phase
                         ,pt_i_Severity            => gvt_Severity
                         ,pt_i_PackageName         => gvt_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => gvt_ModuleMessage
                         ,pt_i_OracleError         => NULL
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR('"e_ModuleError" Exception raised after Progress Indicator "'
                                                       ||gvt_PackageName
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
                         pt_i_ApplicationSuite    => vt_ApplicationSuite
                        ,pt_i_Application         => vt_Application
                        ,pt_i_BusinessEntity      => pt_i_BusinessEntity
                        ,pt_i_SubEntity           => 'ALL'
                        ,pt_i_FileSetID           => 0
                         ,pt_i_MigrationSetID      => 0
                         ,pt_i_Phase               => gvt_Phase
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => gvt_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError         => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR('Unexpected Oracle Exception encountered after Progress Indicator "'
                                                       ||gvt_PackageName
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
     END stg_main;
     --
     --
     /*
     **********************
     ** PROCEDURE: xfm_main
     **********************
     */
     --
     PROCEDURE xfm_main
                    (
                     pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    )
     IS
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
          CURSOR SubEntity_cur
                      (
                       pt_ApplicationSuite             xxmx_migration_metadata.application_suite%TYPE
                      ,pt_Application                  xxmx_migration_metadata.application%TYPE
                      ,pt_BusinessEntity               xxmx_migration_metadata.business_entity%TYPE
                      )
          IS
               --
               --
               SELECT  xmm.sub_entity
               FROM    xxmx_migration_metadata  xmm
               WHERE   1 = 1
               AND     xmm.application_suite = pt_ApplicationSuite
               AND     xmm.application       = pt_Application
               AND     xmm.business_entity   = pt_BusinessEntity
               AND     XMM.STG_TABLE         IS NOT NULL
               ORDER BY xmm.sub_entity_seq;
               --
               --
          --** END CURSOR SubEntity_cur
          --
          --**********************
          --** Record Declarations
          --**********************
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'xfm_main';
          ct_TransferProcedureCall        CONSTANT  VARCHAR2(100)                               := 'xxmx_dynamic_sql_pkg.transfer_stg_data';
          ct_TransformProcedureCall       CONSTANT  VARCHAR2(100)                               := 'xxmx_dynamic_sql_pkg.transform_data';
          ct_ExtensionProcedureCall       CONSTANT  VARCHAR2(100)                               := 'xxmx_dynamic_sql_pkg.execute_extensions';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_ParameterMessage             xxmx_module_messages.module_message%TYPE;
          vt_BusinessEntitySeq            xxmx_migration_metadata.business_entity_seq%TYPE;
          vb_TransferSuccess              BOOLEAN;
          vb_anytransfererrors            BOOLEAN;
          vb_anytransformerrors           BOOLEAN;
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
     --** END Declarations **
     --
     BEGIN

          --
          gvt_Phase := 'TRANSFORM';
          --
          gvv_ProgressIndicator := '0010';
          --
          IF   NOT xxmx_utilities_pkg.valid_install
          THEN
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- Installation Verification failed.  Please refer to the '
                                  ||'XXMX_MODULE_MESSAGES table for function "valid_install" to '
                                  ||'review detailed error messages.';
               --
               RAISE e_ModuleError;
               --
          ELSE
               --
               /*
               ** Retrieve the STG_POPULATION_METHOD core parameter value which will be used
               ** to determine if the pt_i_FileSetID parameter is mandatory.
               **
               ** The existence of this parameter and its value are validated in the 
               ** "xxmx_utilities_pkg.valid_install" function and if the installis not valid
               ** no further processing can be done.
               */
               --
               gvv_ProgressIndicator := '0030';
               --
               gvt_StgPopulationMethod := xxmx_utilities_pkg.get_core_parameter_value
                                               (
                                                pt_i_ParameterCode => 'STG_POPULATION_METHOD'
                                               );
               --
               vt_ParameterMessage := '';
               --
               IF   gvt_StgPopulationMethod = 'DATA_FILE'
               THEN
                    --
                    /*
                    ** Evaluate the parameters required for processing Client Data
                    ** loaded from Data File.
                    */
                    --
                    IF   pt_i_BusinessEntity IS NULL
                    AND  pt_i_FileSetID      IS NULL
                    THEN
                         --
                         vt_ParameterMessage := vt_ParameterMessage
                                              ||'"pt_i_BusinessEntity" and "pt_i_FileSetID" parameters are mandatory.  ';
                         --
                    ELSIF pt_i_BusinessEntity IS NULL
                    THEN
                         --
                         vt_ParameterMessage := vt_ParameterMessage
                                              ||'"pt_i_BusinessEntity" parameter is mandatory.  ';
                         --
                    ELSIF pt_i_FileSetID IS NULL
                    THEN
                         --
                         vt_ParameterMessage := vt_ParameterMessage
                                              ||'"pt_i_FileSetID" parameter is mandatory.  ';
                         --
                    END IF;
                    --
                    gvt_FileSetID      := pt_i_FileSetID;
                    gvt_MigrationSetID := 0;
                    --
                ELSE  /* STG_POPULATION_METHOD = 'DB_LINK */
                    --
                    /*
                    ** Evaluate the parameters required for processing Client Data
                    ** extracted via from DB Link.
                    */
                    --
                    IF   pt_i_BusinessEntity IS NULL
                    AND  pt_i_MigrationSetID IS NULL
                    THEN
                         --
                         vt_ParameterMessage := vt_ParameterMessage
                                              ||'"pt_i_BusinessEntity" and "pt_i_MigrationSetID" parameters are mandatory.  ';
                         --
                    ELSIF pt_i_BusinessEntity IS NULL
                    THEN
                         --
                         vt_ParameterMessage := vt_ParameterMessage
                                              ||'"pt_i_BusinessEntity" parameter is mandatory.  ';
                         --
                    ELSIF pt_i_MigrationSetID IS NULL
                    THEN
                         --
                         vt_ParameterMessage := vt_ParameterMessage
                                              ||'"pt_i_MigrationSetID" parameter is mandatory.  ';
                         --
                    END IF;
                    --
                    gvt_FileSetID      := 0;
                    gvt_MigrationSetID := pt_i_MigrationSetID;
                    --
                END IF; --** IF gvt_StgPopulationMethod  = 'DATA_FILE' OR 'DB_LINK'
          --

           /*
           ** If there are Parameter errors, construct the final message to be issued.
           */
           --
           IF   vt_ParameterMessage IS NOT NULL
           THEN
               --
               gvt_ModuleMessage := 'When calling "'
                                  ||gvt_PackageName
                                  ||'.'
                                  ||ct_ProcOrFuncName
                                  ||' and STG_POPULATION_METHOD is "'
                                  ||gvt_StgPopulationMethod
                                  ||'": '
                                  ||RTRIM(vt_ParameterMessage);
               --                   
               RAISE e_ModuleError;
               --
           END IF;          
          --
          gct_BusinessEntity := UPPER(pt_i_BusinessEntity);
          --
          /*
          ** Verify that the value in pt_i_BusinessEntity is valid.
          */
          --
          gvv_ProgressIndicator := '0040';
          --
          xxmx_utilities_pkg.verify_lookup_code
               (
                pt_i_LookupType    => 'BUSINESS_ENTITIES'
               ,pt_i_LookupCode    => UPPER(pt_i_BusinessEntity)
               ,pv_o_ReturnStatus  => gvv_ReturnStatus
               ,pt_o_ReturnMessage => gvt_ReturnMessage
               );
          --
          --
          /*
          ** Retrieve the Application Suite and Application for the Business Entity.
          **
          ** A Business Entity can only be defined for a single Application e.g. there
          ** cannot be an "INVOICES" Business Entity in both the "AP" and "AR"
          ** Applications therefore for "AR" the "TRANSACTIONS" Business Entity is used.
          */
          --
          gvv_ProgressIndicator := '0050';
          --
          xxmx_utilities_pkg.get_entity_application
                    (
                     pt_i_BusinessEntity   => UPPER(pt_i_BusinessEntity)
                    ,pt_o_ApplicationSuite => gvt_BEApplicationSuite
                    ,pt_o_Application      => gvt_BEApplication
                    ,pv_o_ReturnStatus     => gvv_ReturnStatus
                    ,pt_o_ReturnMessage    => gvt_ReturnMessage
                    );
          --
          IF   gvv_ReturnStatus <> 'S'
          THEN
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := gvt_ReturnMessage;
               --
               RAISE e_ModuleError;
               --
          END IF; --** IF gvv_ReturnStatus <> 'S'
          --
          gvv_ProgressIndicator := '0060';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gvt_BEApplicationSuite
               ,pt_i_Application       => gvt_BEApplication
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => 'ALL'
               ,pt_i_FileSetID         => gvt_FileSetID
               ,pt_i_MigrationSetID    => gvt_MigrationSetID
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gvt_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                          ||gvt_PackageName
                                          ||'.'
                                          ||ct_ProcOrFuncName
                                          ||'" initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          gvt_ModuleMessage := '  - Performing Data Transfer from STG to XFM tables and '
                                       ||'then Data Transformation';
          --
           IF   gvt_StgPopulationMethod  = 'DATA_FILE'
           THEN
            --
             gvt_ModuleMessage := gvt_ModuleMessage
                                ||'for Business Entity "'
                                ||pt_i_BusinessEntity
                                ||'" and File Set ID "'
                                ||gvt_FileSetID
                                ||'".';
             --
           ELSE
             --
             gvt_ModuleMessage := gvt_ModuleMessage
                                ||'for Business Entity "'
                                ||pt_i_BusinessEntity
                                ||'" and Migration Set ID "'
                                ||gvt_MigrationSetID
                                ||'".';
             --
           END IF; --** IF gvt_StgPopulationMethod  = 'DATA_FILE'
              --
              xxmx_utilities_pkg.log_module_message
                   (
                    pt_i_ApplicationSuite  => gvt_BEApplicationSuite
                   ,pt_i_Application       => gvt_BEApplication
                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                   ,pt_i_SubEntity         => 'ALL'
                   ,pt_i_FileSetID         => gvt_FileSetID
                   ,pt_i_MigrationSetID    => gvt_MigrationSetID
                   ,pt_i_Phase             => gvt_Phase
                   ,pt_i_Severity          => 'NOTIFICATION'
                   ,pt_i_PackageName       => gvt_PackageName
                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage     => gvt_ModuleMessage
                   ,pt_i_OracleError       => NULL
                   );
              --
              gvv_ProgressIndicator := '0070';
              --
              /*
              ** Loop through the Migration Metadata table to retrieve
              ** each Sub-Entity Name for the Business Entity.
              */
              --
              xxmx_utilities_pkg.log_module_message
                   (
                    pt_i_ApplicationSuite  => gvt_BEApplicationSuite
                   ,pt_i_Application       => gvt_BEApplication
                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                   ,pt_i_SubEntity         => 'ALL'
                   ,pt_i_FileSetID         => gvt_FileSetID
                   ,pt_i_MigrationSetID    => gvt_MigrationSetID
                   ,pt_i_Phase             => gvt_Phase
                   ,pt_i_Severity          => 'NOTIFICATION'
                   ,pt_i_PackageName       => gvt_PackageName
                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage     => '- Calling Transfer/Transform Procedures for Sub-Entities:'
                   ,pt_i_OracleError       => NULL
                   );
              --
              gvv_ProgressIndicator := '0080';
              --
              vb_AnyTransferErrors  := FALSE;
              vb_AnyTransformErrors := FALSE;
              --
              --
              FOR  SubEntity_rec
              IN   SubEntity_cur
                        (
                         gvt_BEApplicationSuite
                        ,gvt_BEApplication
                        ,pt_i_BusinessEntity
                        )
              LOOP
                   --
                   gvv_ProgressIndicator := '0090';
                   xxmx_utilities_pkg.log_module_message
                        (
                         pt_i_ApplicationSuite  => gvt_BEApplicationSuite
                        ,pt_i_Application       => gvt_BEApplication
                        ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                        ,pt_i_SubEntity         => 'ALL'
                        ,pt_i_FileSetID         => gvt_FileSetID
                        ,pt_i_MigrationSetID    => gvt_MigrationSetID
                        ,pt_i_Phase             => gvt_Phase
                        ,pt_i_Severity          => 'NOTIFICATION'
                        ,pt_i_PackageName       => gvt_PackageName
                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage     => '- Calling Procedures for Sub-Entity "'
                                                 ||Subentity_rec.sub_entity
                                                 ||'".'
                        ,pt_i_OracleError       => NULL
                        );
                   --
                   /*
                   *************************************************
                   ** Perform STG to XFM table Data Transfer for the
                   ** relevant execution modes.
                   *************************************************
                   */
                   --
                   gvv_ProgressIndicator := '0100';
                   xxmx_utilities_pkg.log_module_message
                        (
                         pt_i_ApplicationSuite  => gvt_BEApplicationSuite
                        ,pt_i_Application       => gvt_BEApplication
                        ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                        ,pt_i_SubEntity         => 'ALL'
                        ,pt_i_FileSetID         => gvt_FileSetID
                        ,pt_i_MigrationSetID    => gvt_MigrationSetID
                        ,pt_i_Phase             => gvt_Phase
                        ,pt_i_Severity          => 'NOTIFICATION'
                        ,pt_i_PackageName       => gvt_PackageName
                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage     => '- Calling Procedure "'
                                                 ||ct_TransferProcedureCall
                                                 ||'".'
                        ,pt_i_OracleError       => NULL
                        );
                   --
                   gvv_SQLStatement := 'BEGIN '
                                     ||ct_TransferProcedureCall
                                     ||'('
                                     ||' pt_i_ApplicationSuite    => :1 '
                                     ||',pt_i_Application         => :2 '
                                     ||',pt_i_BusinessEntity      => :3 '
                                     ||',pt_i_SubEntity           => :4 '
                                     ||',pt_i_StgPopulationMethod => :5 '
                                     ||',pt_i_FileSetID           => :6 '
                                     ||',pt_i_MigrationSetID      => :7 '
                                     ||',pv_o_ReturnStatus        => :8 '
                                     ||'); END;';
                   --
                   gvv_ProgressIndicator := '0110';
                   xxmx_utilities_pkg.log_module_message
                        (
                         pt_i_ApplicationSuite  => gvt_BEApplicationSuite
                        ,pt_i_Application       => gvt_BEApplication
                        ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                        ,pt_i_SubEntity         => 'ALL'
                        ,pt_i_FileSetID         => gvt_FileSetID
                        ,pt_i_MigrationSetID    => gvt_MigrationSetID
                        ,pt_i_Phase             => gvt_Phase
                        ,pt_i_Severity          => 'NOTIFICATION'
                        ,pt_i_PackageName       => gvt_PackageName
                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage     => SUBSTR(
                                                          '- Generated SQL Statement: '
                                                        ||gvv_SQLStatement
                                                         ,1
                                                         ,4000
                                                         )
                        ,pt_i_OracleError       => NULL
                        );
                   --
                   gvv_ReturnStatus := '';
                   --
                   EXECUTE IMMEDIATE  gvv_SQLStatement
                               USING  IN  gvt_BEApplicationSuite
                                     ,IN  gvt_BEApplication
                                     ,IN  UPPER(pt_i_BusinessEntity)
                                     ,IN  Subentity_rec.sub_entity
                                     ,IN  gvt_StgPopulationMethod
                                     ,IN  gvt_FileSetID
                                     ,IN  gvt_MigrationSetID
                                     ,OUT gvv_ReturnStatus;
                   --
                   IF   gvv_ReturnStatus <> 'S'
                   THEN
                        --
                        vb_AnyTransferErrors := TRUE;
                        --
                        gvv_ProgressIndicator := '0120';
                        xxmx_utilities_pkg.log_module_message
                             (
                              pt_i_ApplicationSuite  => gvt_BEApplicationSuite
                             ,pt_i_Application       => gvt_BEApplication
                             ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                             ,pt_i_SubEntity         => 'ALL'
                             ,pt_i_FileSetID         => gvt_FileSetID
                             ,pt_i_MigrationSetID    => gvt_MigrationSetID
                             ,pt_i_Phase             => gvt_Phase
                             ,pt_i_Severity          => 'ERROR'
                             ,pt_i_PackageName       => gvt_PackageName
                             ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                             ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                             ,pt_i_ModuleMessage     => '        - "'
                                                       ||ct_TransferProcedureCall
                                                       ||'" Procedure returned Failure status.  Transform Procedure will not be called.  '
                                                       ||'Please refer to the XXMX_MODULE_MESSAGES table.'
                             ,pt_i_OracleError       => NULL
                             );
                        --
                   ELSE
                        --
                        gvv_ProgressIndicator := '0130';
                        xxmx_utilities_pkg.log_module_message
                             (
                              pt_i_ApplicationSuite  => gvt_BEApplicationSuite
                             ,pt_i_Application       => gvt_BEApplication
                             ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                             ,pt_i_SubEntity         => 'ALL'
                             ,pt_i_FileSetID         => gvt_FileSetID
                             ,pt_i_MigrationSetID    => gvt_MigrationSetID
                             ,pt_i_Phase             => gvt_Phase
                             ,pt_i_Severity          => 'NOTIFICATION'
                             ,pt_i_PackageName       => gvt_PackageName
                             ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                             ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                             ,pt_i_ModuleMessage     => '        - "'
                                                      ||ct_TransferProcedureCall
                                                      ||'" Procedure returned Success status.'
                             ,pt_i_OracleError       => NULL
                             );
                        --

                        --
                        /*
                        ********************************************************
                        ** Transform Processing
                        **
                        ** Only perform Data Transformation if the Data Transfer
                        ** from STG to XFM table was successful.
                        ********************************************************
                        */
                        --
                        gvv_ProgressIndicator := '0140';
                        xxmx_utilities_pkg.log_module_message
                             (
                              pt_i_ApplicationSuite  => gvt_BEApplicationSuite
                             ,pt_i_Application       => gvt_BEApplication
                             ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                             ,pt_i_SubEntity         => 'ALL'
                             ,pt_i_FileSetID         => gvt_FileSetID
                             ,pt_i_MigrationSetID    => gvt_MigrationSetID
                             ,pt_i_Phase             => gvt_Phase
                             ,pt_i_Severity          => 'NOTIFICATION'
                             ,pt_i_PackageName       => gvt_PackageName
                             ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                             ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                             ,pt_i_ModuleMessage     => '      - Calling Procedure "'
                                                      ||ct_TransformProcedureCall
                                                      ||'".'
                             ,pt_i_OracleError       => NULL
                             );
                        --
                        gvv_SQLStatement := 'BEGIN '
                                             ||ct_TransformProcedureCall
                                             ||'('
                                             ||' pt_i_ApplicationSuite    => :1 '
                                             ||',pt_i_Application         => :2 '
                                             ||',pt_i_BusinessEntity      => :3 '
                                             ||',pt_i_SubEntity           => :4 '
                                             ||',pt_i_StgPopulationMethod => :5 '
                                             ||',pt_i_FileSetID           => :6 '
                                             ||',pt_i_MigrationSetID      => :7 '
                                             ||',pv_o_ReturnStatus        => :8 '
                                             ||'); END;';
                        --
                        gvv_ProgressIndicator := '0150';
                        xxmx_utilities_pkg.log_module_message
                             (
                              pt_i_ApplicationSuite  => gvt_BEApplicationSuite
                             ,pt_i_Application       => gvt_BEApplication
                             ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                             ,pt_i_SubEntity         => 'ALL'
                             ,pt_i_FileSetID         => gvt_FileSetID
                             ,pt_i_MigrationSetID    => gvt_MigrationSetID
                             ,pt_i_Phase             => gvt_Phase
                             ,pt_i_Severity          => 'NOTIFICATION'
                             ,pt_i_PackageName       => gvt_PackageName
                             ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                             ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                             ,pt_i_ModuleMessage     => SUBSTR(
                                                               '        - Generated SQL Statement: '
                                                             ||gvv_SQLStatement
                                                              ,1
                                                              ,4000
                                                              )
                             ,pt_i_OracleError       => NULL
                             );
                        --
                        gvv_ReturnStatus := '';
                        --

                        EXECUTE IMMEDIATE  gvv_SQLStatement
                                    USING  IN  gvt_BEApplicationSuite
                                          ,IN  gvt_BEApplication
                                          ,IN  pt_i_BusinessEntity
                                          ,IN  Subentity_rec.sub_entity
                                          ,IN  gvt_StgPopulationMethod
                                          ,IN  gvt_FileSetID
                                          ,IN  gvt_MigrationSetID
                                          ,OUT gvv_ReturnStatus;
                        --
                        IF   gvv_ReturnStatus <> 'S'
                        THEN
                             --
                             vb_AnyTransformErrors := TRUE;
                             --
                             gvv_ProgressIndicator := '0160';
                             xxmx_utilities_pkg.log_module_message
                                  (
                                   pt_i_ApplicationSuite  => gvt_BEApplicationSuite
                                  ,pt_i_Application       => gvt_BEApplication
                                  ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                  ,pt_i_SubEntity         => 'ALL'
                                  ,pt_i_FileSetID         => gvt_FileSetID
                                  ,pt_i_MigrationSetID    => gvt_MigrationSetID
                                  ,pt_i_Phase             => gvt_Phase
                                  ,pt_i_Severity          => 'ERROR'
                                  ,pt_i_PackageName       => gvt_PackageName
                                  ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                  ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                  ,pt_i_ModuleMessage     => '        - Procedure returned Failure status.  Please refer to the XXMX_MODULE_MESSAGES table.'
                                  ,pt_i_OracleError       => NULL
                                  );
                             --
                        ELSE
                             --
                             gvv_ProgressIndicator := '0170';
                             xxmx_utilities_pkg.log_module_message
                                  (
                                   pt_i_ApplicationSuite  => gvt_BEApplicationSuite
                                  ,pt_i_Application       => gvt_BEApplication
                                  ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                  ,pt_i_SubEntity         => 'ALL'
                                  ,pt_i_FileSetID         => gvt_FileSetID
                                  ,pt_i_MigrationSetID    => gvt_MigrationSetID
                                  ,pt_i_Phase             => gvt_Phase
                                  ,pt_i_Severity          => 'NOTIFICATION'
                                  ,pt_i_PackageName       => gvt_PackageName
                                  ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                  ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                  ,pt_i_ModuleMessage     => '        - Procedure returned Success status.'
                                  ,pt_i_OracleError       => NULL
                                  );
                             --
                        END IF; --** IF   gvc_SQLResult <> 'S'
                        --
                      END IF; --** IF   gvc_SQLResult <> 'S'
                      --
                       --
                         gvv_ProgressIndicator := '0180';
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gvt_BEApplicationSuite
                              ,pt_i_Application       => gvt_BEApplication
                              ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                              ,pt_i_SubEntity         => 'ALL'
                              ,pt_i_FileSetID         => gvt_FileSetID
                              ,pt_i_MigrationSetID    => gvt_MigrationSetID
                              ,pt_i_Phase             => gvt_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gvt_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '    - Transfer/Transform processing for Sub-Entity "'
                                                       ||Subentity_rec.sub_entity
                                                       ||'" complete.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
               END LOOP; --** SubEntity_cur LOOP
              --
        END IF;              
      EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gvt_BEApplicationSuite
                         ,pt_i_Application       => gvt_BEApplication
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gvt_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR('"e_ModuleError" Exception raised after Progress Indicator "'
                                                       ||gvt_PackageName
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
                          pt_i_ApplicationSuite  => gvt_BEApplicationSuite
                         ,pt_i_Application       => gvt_BEApplication
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gvt_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR('Unexpected Oracle Exception encountered after Progress Indicator "'
                                                       ||gvt_PackageName
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

     END xfm_main;
     --
     --
     /*
     *******************
     ** PROCEDURE: purge
     *******************
     */
     --
     PROCEDURE purge
                    (
                     pt_i_BusinessEntity        IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_filesetid             IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID        IN      xxmx_migration_headers.migration_set_id%TYPE

                    )
     IS
          --
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
          CURSOR SubEntityMetadata_cur
                      (
                       pt_ApplicationSuite             xxmx_migration_metadata.application_suite%TYPE
                      ,pt_Application                  xxmx_migration_metadata.application%TYPE
                      )
          IS
               --
               SELECT  UPPER(xmm.sub_entity)                AS sub_entity
                      ,UPPER(xmm.Business_entity)           AS Business_entity
                      ,LOWER(xmm.Entity_package_name)    AS stg_population_package
                      ,LOWER(xmm.stg_procedure_name)  AS stg_population_procedure
               FROM    xxmx_migration_metadata  xmm
               WHERE   1 = 1
               AND     xmm.application_suite      = pt_ApplicationSuite
               AND     xmm.application            = pt_Application
               AND     xmm.Business_entity        = pt_i_BusinessEntity
               AND     NVL(xmm.enabled_flag, 'N')  = 'Y'
               ORDER BY xmm.sub_entity_seq;
               --
          --** END CURSOR SubEntityMetadata_cur
          --
          --**********************
          --** Record Declarations
          --**********************
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName               CONSTANT  VARCHAR2(30)                         := 'purge';
          ct_SubEntity                    CONSTANT  xxmx_module_messages.sub_entity%TYPE := 'ALL';
          ct_Phase                        CONSTANT  xxmx_module_messages.phase%TYPE      := 'EXTRACT';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_ConfigParameter              xxmx_client_config_parameters.config_parameter%TYPE;
          vt_ApplicationSuite             xxmx_migration_metadata.application_suite%TYPE;
          vt_Application                  xxmx_migration_metadata.application%TYPE;
          --vt_ClientSchemaName             xxmx_client_config_parameters.config_value%TYPE;
          vv_PurgeTableName               VARCHAR2(30);
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
     --** END Declarations **
     --
     --
     BEGIN
          --
          gvv_ProgressIndicator := '0010';
          --
          IF   pt_i_BusinessEntity     IS NULL
          AND  (pt_i_filesetid          IS NULL 
                OR 
                pt_i_MigrationSetID    IS NULL)
          THEN
               --
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := '- "pt_i_ClientCode" and "pt_i_MigrationSetID" parameters are mandatory.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          gvv_ReturnStatus  := '';
          gvt_ReturnMessage := '';
          --
          xxmx_utilities_pkg.clear_messages
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_Phase               => ct_Phase
               ,pt_i_MessageType         => 'MODULE'
               ,pv_o_ReturnStatus        => gvv_ReturnStatus
               );
          --
          IF   gvv_ReturnStatus = 'F'
          THEN
               --
               gvt_Severity      := 'ERROR';
               --
               gvt_ModuleMessage := '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".';
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
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gvt_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                            ||gvt_PackageName
                                            ||'.'
                                            ||ct_ProcOrFuncName
                                            ||'" initiated.'
               ,pt_i_OracleError         => NULL
               );

          xxmx_utilities_pkg.get_entity_application
                         (
                          pt_i_BusinessEntity   => pt_i_BusinessEntity
                         ,pt_o_ApplicationSuite => vt_ApplicationSuite
                         ,pt_o_Application      => vt_Application
                         ,pv_o_ReturnStatus     => gvv_ReturnStatus
                         ,pt_o_ReturnMessage    => gvt_ReturnMessage
                         );
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gvt_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => '- Purging tables.'
               ,pt_i_OracleError         => NULL
               );
          --
          gvv_ProgressIndicator := '0040';
          --

          xxmx_dynamic_sql_pkg.purge_migration_data(
                    pt_i_BusinessEntity          =>  pt_i_BusinessEntity
                     ,pt_i_FileSetID             =>  pt_i_filesetid
                     ,pt_i_MigrationSetID        =>  pt_i_MigrationSetID
                     ,pv_i_PurgeClientData       => 'N'
                     ,pv_i_PurgeModuleMessages   => 'N'
                     ,pv_i_PurgeDataMessages     =>'N'
                     ,pv_i_PurgeControlTables    => 'N'
                  );

          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gvt_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => '- Purging complete.'
               ,pt_i_OracleError         => NULL
               );
          --
          COMMIT;
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite    => gct_ApplicationSuite
               ,pt_i_Application         => gct_Application
               ,pt_i_BusinessEntity      => gct_BusinessEntity
               ,pt_i_SubEntity           => ct_SubEntity
               ,pt_i_MigrationSetID      => pt_i_MigrationSetID
               ,pt_i_Phase               => ct_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gvt_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                            ||gvt_PackageName
                                            ||'.'
                                            ||ct_ProcOrFuncName
                                            ||'" completed.'
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
                         ,pt_i_SubEntity           => ct_SubEntity
                         ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => gvt_Severity
                         ,pt_i_PackageName         => gvt_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => gvt_ModuleMessage
                         ,pt_i_OracleError         => NULL
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR('"e_ModuleError" Exception raised after Progress Indicator "'
                                                       ||gvt_PackageName
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
                         ,pt_i_SubEntity           => ct_SubEntity
                         ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                         ,pt_i_Phase               => ct_Phase
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => gvt_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError         => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR('Unexpected Oracle Exception encountered after Progress Indicator "'
                                                       ||gvt_PackageName
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
     END purge;
     --
END xxmx_hcm_stg_extract_pkg;
/