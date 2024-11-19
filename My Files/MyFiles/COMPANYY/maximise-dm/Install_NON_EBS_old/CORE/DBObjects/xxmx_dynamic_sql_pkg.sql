create or replace PACKAGE           xxmx_dynamic_sql_pkg
IS
     --
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
     ** FILENAME  :  xxmx_dynamic_sql_pkg.sql
     **
     ** FILEPATH  :
     **
     ** VERSION   :  1.0
     **
     ** EXECUTE
     ** IN SCHEMA :  APPS
     **
     ** AUTHORS   :  Ian S. Vickerstaff
     **
     ** PURPOSE   : This script creates the package which performs all Dynamic SQL
     **             processing for Maximise.
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
     **            $XXMX_TOP/install/sql/xxmx_utilities_dbi.sql
     **            $XXMX_TOP/install/sql/xxmx_dynamic_sql_dbi.sql
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
     ** xxmx_utilities_pkg.sql HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     **   1.0  09-JUL-2020  Ian S. Vickerstaff  Created for Maximise.
     **
     ******************************************************************************
     **
     **  Data Element Prefixes
     **  =====================
     **
     **  Utilizing prefixes and suffixes for data and object names enhances the
     **  readability of code and allows for the context of a data element to be
     **  identified (and hopefully understood) without having to refer to the
     **  data element declarations section.
     **
     **  This Package utilises prefixes of upto 6 characters for all data elements
     **  wherever possible.
     **
     **  The construction of Prefixes is governed by the following rules:
     **
     **  1) Optional Scope Identifier Character:
     **
     **     g = If a prefix starts with a "g" this denotes that the data element
     **         is "global" in scope, whether defined in the package body (and
     **         therefore only global within the package itself), or defined in the
     **         package specification (and therefore referencable outside of the
     **         package).
     **
     **     p = If a prefix starts with a "p" this denotes that the data element
     **         is a parameter.  This is mutally exclusive with "g" as parameters
     **         are by nature, global in scope.
     **
     **     Note: Prefixes that do not start with the above denote local data
     **           elements (only referencable within the scope of the package).
     **
     **  2) Constant/Variable Identifier Character:
     **
     **     c = Constant value data elements should include "c" in their prefix.
     **         Local constant data element prefixes will start with this, but for
     **         global constant data element prefixes, this will be the second
     **         character.
     **
     **     v = Variable value data elements should include "v" in their prefix.
     **         Local variable data element prefixes will start with this, but for
     **         global variable data elements, this will be the second
     **         character.
     **
     **  3) Data Type Idenfifier Character:
     **
     **     Following the constant/variable identifier, a character is
     **     utilised to identify the data type of the elements:
     **
     **         b = Data element of type BOOLEAN.
     **         d = Data element of type DATE.
     **         i = Data element of type INTEGER.
     **         n = Data element of type NUMBER.
     **         r = Data element of type REAL.
     **         n = Data element of type VARCHAR2.
     **         n = Data element of type %TYPE (database inherited type).
     **
     **  4) Direction indicators for Parameters:
     **
     **     Parameter data elements should include one of the following
     **
     **         i  = Input parameter (readable value only within the package)
     **         o  = Output parameter (value assignable within the package)
     **         io = Input/Output parameter (readable/assignable)
     **
     **     To avoid potential confusion with other data element indicators
     **     (e.g. "i" is used to indicqte a data type of Integer but also
     **     that a parameter has an input direction) it would be best to
     **     separate the direction indicators from previous indicators by
     **     an underscore "_".
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
     **       This data element is a global constant tieh type is determined from a
     **       database table column.
     **
     **       ct_ProcOrFuncName
     **       -----------------
     **       This data element is a local constant with type is determined from a
     **       database table column.
     **
     **       vt_APInvoiceID
     **       --------------
     **       This data element is a variable with type is determined from a
     **       database table column and is meant to hold the Oracle internal
     **       identifier for a Payables Invoice Header.
     **
     **       vt_APInvoiceLineID
     **       --------------
     **       Similar to the previous example but this clearly identified that the
     **       data element is intended to hold the Oracle internal identifier for
     **       a Payables Invoice Line.
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
     /*
     ********************************************
     ** GLOBAL TYPES ACCESSIBLE BY OTHER PACKAGES
     ********************************************
     */
     --
     TYPE g_ParamValueList_tt               IS TABLE OF xxmx_migration_parameters.parameter_value%TYPE;
     --
     /*
     ************************************************
     ** GLOBAL CONSTANTS ACCESSIBLE BY OTHER PACKAGES
     ************************************************
     */
     --
     gcn_ApplicationErrorNumber                CONSTANT NUMBER := -20000;
     gcn_BulkCollectLimit                      CONSTANT NUMBER  := 1000;    -- cursor fetch limit
     --
     /*
     ************************************************
     ** GLOBAL VARIABLES ACCESSIBLE BY OTHER PACKAGES
     ************************************************
     */
     --
     gvv_UserName                                       VARCHAR2(100)   := UPPER(sys_context('userenv','OS_USER'));
     --
     /*
     **************************************
     ** PROCEDURE AND FUNCTION DECLARATIONS
     **************************************
     */
     --
     /*
     ******************************
     ** FUNCTION: get_object_status
     ******************************
     */
     --
     FUNCTION get_object_status
                    (
                     pt_i_Owner                     IN      all_objects.owner%TYPE
                    ,pt_i_ObjectName                IN      all_objects.object_name%TYPE
                    ,pt_i_ObjectType                IN      all_objects.object_type%TYPE
                    )
     RETURN VARCHAR2;
                    --
     --** END FUNCTION get_object_status
     --
     --
     /*
     ***************************************
     ** FUNCTION: get_row_count
     **
     ** Overloaded Function using File Set
     ** ID to group data.
     **
     ** Called from procedures which operate
     ** on Client Data loaded from Data File
     ** but before a Migration Set ID has
     ** been generated..
     **
     ** Returns a number which is the count
     ** of rows in a single table.
     **
     ** Allows upto 5 optional conditions
     ** to be added to the basic query.
     ***************************************
     */
     --
     FUNCTION get_row_count
                    (
                     pt_i_SchemaName                 IN      xxmx_stg_tables.schema_name%TYPE
                    ,pt_i_TableName                  IN      xxmx_stg_tables.table_name%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pv_i_OptionalJoinCondition1     IN      VARCHAR2 DEFAULT NULL
                    ,pv_i_OptionalJoinCondition2     IN      VARCHAR2 DEFAULT NULL
                    ,pv_i_OptionalJoinCondition3     IN      VARCHAR2 DEFAULT NULL
                    ,pv_i_OptionalJoinCondition4     IN      VARCHAR2 DEFAULT NULL
                    ,pv_i_OptionalJoinCondition5     IN      VARCHAR2 DEFAULT NULL
                    )
     RETURN NUMBER;
                    --
     --** END FUNCTION get_row_count
     --
     --
     /*
     ***************************************
     ** FUNCTION: get_row_count
     **
     ** Overloaded Function using Migration
     ** Set ID to group data.
     **
     ** Called from each Extract procedure
     ** when Client Data is being extracted
     ** from the Source Database via DB Link.
     **
     ** Returns a number which is the count
     ** of rows in a single table.
     **
     ** Allows upto 5 optional conditions
     ** to be added to the basic query.
     ***************************************
     */
     --
     FUNCTION get_row_count
                    (
                     pt_i_SchemaName                 IN      xxmx_stg_tables.schema_name%TYPE
                    ,pt_i_TableName                  IN      xxmx_stg_tables.table_name%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_i_OptionalJoinCondition1     IN      VARCHAR2 DEFAULT NULL
                    ,pv_i_OptionalJoinCondition2     IN      VARCHAR2 DEFAULT NULL
                    ,pv_i_OptionalJoinCondition3     IN      VARCHAR2 DEFAULT NULL
                    ,pv_i_OptionalJoinCondition4     IN      VARCHAR2 DEFAULT NULL
                    ,pv_i_OptionalJoinCondition5     IN      VARCHAR2 DEFAULT NULL
                    )
     RETURN NUMBER;
                    --
     --** END FUNCTION get_row_count
     --
     --
     /*
     **********************************
     ** PROCEDURE: prevalidate_stg_data
     **********************************
     */
     --
     PROCEDURE prevalidate_stg_data
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_metadata.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_metadata.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    );
                    --
     --** END PROCEDURE prevalidate_stg_data
     --
     --
     --/*
     --*******************************
     --** PROCEDURE: transfer_stg_data
     --*******************************
     --*/
     ----
      PROCEDURE transfer_stg_data
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_metadata.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_metadata.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    );
                    --
     ----** END PROCEDURE transfer_stg_data
     --
     --
     /*
     ****************************
     ** PROCEDURE: transform_data
     ****************************
     */
     --
      PROCEDURE transform_data
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_metadata.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_metadata.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    );

                    --
     --** END PROCEDURE transform_data
     --
     --
     /*
     ** This procedure is called by the Extension Handler procedures
     ** and simply builds the Dynamic SQL statement to execute a
     ** single Business Entity Level Extension.
     **
     ** It must receive a return status back from the Extension so that
     ** it (in turn) can return a status back to the Extension Handler.
     **
     ** This one procedure is utilized to execute both Seeded and Custom
     ** Business Entity Level Extensions.
     */
     --
     PROCEDURE execute_extension
                    (
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pv_i_ExtensionType              IN      VARCHAR2
                    ,pt_i_Phase                      IN      xxmx_seeded_extensions.phase%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    ,pv_o_ReturnMessage                 OUT  VARCHAR2
                    );
                    --
     --** END PROCEDURE execute_extension
     --
     --
     /*
     ** This procedure is called by the Extension Handler procedures
     ** and simply builds the Dynamic SQL statement to execute a
     ** single Sub-Entity Level Extension.
     **
     ** It must receive a return status back from the Extension so that
     ** it (in turn) can return a status back to the Extension Handler.
     **
     ** This one procedure is utilized to execute both Seeded and Custom
     ** Sub-Entity Level Extensions.
     */
     --
     PROCEDURE call_sub_extension
                    (
                     pt_i_ExtSchemaName              IN      xxmx_seeded_sub_extensions.schema_name%TYPE
                    ,pt_i_ExtPackageName             IN      xxmx_seeded_sub_extensions.extension_package%TYPE
                    ,pt_i_ExtProcedureName           IN      xxmx_seeded_sub_extensions.extension_procedure%TYPE
                    ,pt_i_ApplicationSuite           IN      xxmx_seeded_sub_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_sub_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_sub_extensions.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_seeded_sub_extensions.sub_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    ,pv_o_ReturnMessage                 OUT  VARCHAR2
                    );
                    --
     --** END PROCEDURE call_sub_extension
     --
     --
     /*
     ** This procedure handles the definition validation and execution
     ** of Seeded Extensions written by the Maximise Development Team.
     **
     ** Business Entity Level Extensions which are designed to operate on
     ** data held in multiple Sub-Entity related tables are defined in the
     ** xxmx_seeded_extensions table.
     **     
     ** Sub-Entity Level Extensions which are designed to operate on data
     ** held in single Sub-Entity related table are defined in the
     ** xxmx_seeded_sub_extensions table.
     **
     ** Specific Business Entity Level Extensions may need to be executed
     ** BEFORE or AFTER any Sub-Entity Level Extensions and this design
     ** handles both cases.     
     */
     --
    /* PROCEDURE call_seeded_extensions
                    (
                     pt_i_BusinessEntity             IN      xxmx_seeded_sub_extensions.business_entity%TYPE
                    ,pt_i_Phase                      IN      xxmx_seeded_sub_extensions.phase%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    ,pv_o_ReturnMessage                 OUT  VARCHAR2
                    );
                    --
     --** END PROCEDURE execute_seeded_extensions*/
     --
     --
     /*
     ** This procedure handles the definition validation and execution
     ** of Custom Extensions written by V 1 Implementation Teams and / or
     ** Client Development Teams.
     **
     ** Business Entity Level Extensions which are designed to operate on
     ** data held in multiple Sub-Entity related tables are defined in the
     ** xxmx_custom_extensions table.
     **     
     ** Sub-Entity Level Extensions which are designed to operate on data
     ** held in single Sub-Entity related table are defined in the
     ** xxmx_custom_sub_extensions table.
     **
     ** Specific Business Entity Level Extensions may need to be executed
     ** BEFORE or AFTER any Sub-Entity Level Extensions and this design
     ** handles both cases.     
     */
     --
    /* PROCEDURE execute_custom_extensions
                    (
                     pt_i_BusinessEntity             IN      xxmx_custom_sub_extensions.business_entity%TYPE
                    ,pt_i_Phase                      IN      xxmx_custom_sub_extensions.phase%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    ,pv_o_ReturnMessage                 OUT  VARCHAR2
                    );
                    --
     --** END PROCEDURE execute_custom_extensions
     */
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
                     pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    );
                    --
     --** END PROCEDURE stg_main
     --
     --
     /*
     ***************************************************
     ** PROCEDURE: log_purge_message
     **
     ** Called from each purge_migration_data procedure.
     ***************************************************
     */
     --
     PROCEDURE log_purge_message
                    (
                     pt_i_ApplicationSuite           IN      xxmx_purge_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_purge_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_purge_messages.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_purge_messages.sub_entity%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_purge_messages.migration_set_id%TYPE
                    ,pt_i_Severity                   IN      xxmx_purge_messages.severity%TYPE
                    ,pt_i_ProgressIndicator          IN      xxmx_purge_messages.progress_indicator%TYPE
                    ,pt_i_PurgeMessage               IN      xxmx_purge_messages.purge_message%TYPE
                    ,pt_i_OracleError                IN      xxmx_purge_messages.oracle_error%TYPE
                    );
                    --
     --** END PROCEDURE log_purge_message
     --
     --
     /*
     **********************************
     ** PROCEDURE: purge_migration_data
     **********************************
     */
     --
     PROCEDURE purge_migration_data
                    (
                     pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_i_PurgeClientData            IN      VARCHAR2 DEFAULT 'N'
                    ,pv_i_PurgeModuleMessages        IN      VARCHAR2 DEFAULT 'N'
                    ,pv_i_PurgeDataMessages          IN      VARCHAR2 DEFAULT 'N'
                    ,pv_i_PurgeControlTables         IN      VARCHAR2 DEFAULT 'N'
                    );
                    --
     --** END PROCEDURE purge_migration_data
     --
     --
     /*
     **********************************
     ** PROCEDURE: gen_ctl_script - Control File Generation
     **********************************
     */ 

    PROCEDURE gen_ctl_script( ot_errbuf              OUT    xxmx_module_messages.module_message%TYPE,
                              ot_retcode             OUT    VARCHAR2,
                              pt_i_Application       IN     xxmx_migration_metadata.application%TYPE,
                              pt_object_name         IN     VARCHAR2);
    --
    --
 /*
 **********************************
 ** PROCEDURE: Generate_Ctl - Control File Generation
 **********************************
 */

    PROCEDURE generate_ctl(  pt_i_ApplicationSuite            IN      xxmx_migration_metadata.application_suite%TYPE
                             ,pt_i_Application                IN      xxmx_migration_metadata.application%TYPE
                             ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                             ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                             ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                             ,pv_o_ReturnStatus               OUT     VARCHAR2);

    Procedure xfm_populate    (  pt_i_ApplicationSuite           IN      xxmx_migration_metadata.application_suite%TYPE
                              ,pt_i_Application                IN      xxmx_migration_metadata.application%TYPE
                              ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                              ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                              ,pt_fusion_template_name         IN      xxmx_xfm_tables.fusion_template_name%TYPE DEFAULT NULL
                              ,pt_fusion_template_sheet_name   IN      xxmx_xfm_tables.fusion_template_sheet_name%TYPE DEFAULT NULL
                              ,pt_fusion_template_sheet_order  IN      xxmx_xfm_tables.fusion_template_sheet_order%TYPE DEFAULT NULL
                              ,pv_o_ReturnStatus               OUT  VARCHAR2);

    Procedure stg_populate    (  pt_i_ApplicationSuite         IN      xxmx_migration_metadata.application_suite%TYPE
                              ,pt_i_Application                IN      xxmx_migration_metadata.application%TYPE
                              ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                              ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                              ,pt_import_data_file_name       IN      xxmx_stg_tables.import_data_file_name%TYPE  DEFAULT NULL
                              ,pt_control_file_name            IN      xxmx_stg_tables.control_file_name%TYPE DEFAULT NULL
                              ,pt_control_file_delimiter       IN      xxmx_stg_tables.control_file_delimiter%TYPE DEFAULT NULL
                              ,pv_o_ReturnStatus               OUT  VARCHAR2) ;
                              
      -- Updates mandatory flags in Data dictionary tables
      PROCEDURE stg_update_columns ( p_table_name VARCHAR2 DEFAULT NULL);
      
      PROCEDURE xfm_update_columns ( p_table_name IN VARCHAR2);
      

END xxmx_dynamic_sql_pkg;

/
--
--
create or replace NONEDITIONABLE PACKAGE BODY                     xxmx_dynamic_sql_pkg
AS
     /*
     **********************
     ** GLOBAL DECLARATIONS
     **********************
     */
     --
     /*
     ** Global Type Declarations for use in all Procedure/Function Calls within this package.
     */
     --
     TYPE RefCursor_t IS REF CURSOR;
     --
     /*
     ** Global Constants for use in all Procedure/Function Calls within this package.
     */
     --
     gct_PackageName                 CONSTANT  xxmx_module_messages.package_name%TYPE      := 'xxmx_dynamic_sql_pkg';
     gct_XXMXApplicationSuite        CONSTANT  xxmx_module_messages.application_suite%TYPE := 'XXMX';
     gct_XXMXApplication             CONSTANT  xxmx_module_messages.application%TYPE       := 'XXMX';
     gct_StgSchema                             CONSTANT VARCHAR2(10)                       := 'xxmx_stg';
     gct_XfmSchema                             CONSTANT VARCHAR2(10)                       := 'xxmx_xfm';
     gct_CoreSchema                            CONSTANT VARCHAR2(10)                       := 'xxmx_core';
     gct_CoreBusinessEntity          CONSTANT  xxmx_module_messages.business_entity%TYPE   := 'XXMX_CORE';
     gct_CoreSubEntity               CONSTANT  xxmx_module_messages.sub_entity%TYPE        := 'XXMX_DYNASQL';
     --
     /*
     ** Global Variables for use in all Procedures/Functions within this package.
     */
     --
     gvt_FileSetID                             xxmx_migration_headers.file_set_id%TYPE;
     gvt_MigrationSetID                        xxmx_migration_headers.migration_set_id%TYPE;
     gvv_ApplicationErrorMessage               VARCHAR2(2048);
     gvv_ProgressIndicator                     VARCHAR2(100);
     gvv_ReturnStatus                          VARCHAR2(1);
     gvv_ReturnCode                            VARCHAR2(50);
     gvt_ReturnMessage                         xxmx_module_messages.module_message%TYPE;
     gvn_RowCount                              NUMBER;
     gvn_ExistenceCheckCount                   NUMBER;
     gvt_Phase                                 xxmx_module_messages.phase%TYPE;
     gvt_ObjectStatus                          all_objects.status%TYPE;
     --
     /*
     ** Global Variables for Core Parameters used within this package.
     */
     --
     gvt_StgPopulationMethod                   xxmx_core_parameters.parameter_value%TYPE;
     --
     /*
     ** Global Variables for Exception Handlers.
     */
     --
     gvt_Severity                              xxmx_module_messages.severity%TYPE;
     gvt_ModuleMessage                         xxmx_module_messages.module_message%TYPE;
     gvt_OracleError                           xxmx_module_messages.oracle_error%TYPE;
     --
     /*
     ** Global constants and variables for dynamic SQL usage.
     */
     --
     gcv_SQLSpace                    CONSTANT  VARCHAR2(1)     := ' ';
     gvv_SQLAction1                            VARCHAR2(2000);
     gvv_SQLAction2                            VARCHAR2(2000);
     gvv_SQLTableClause                        VARCHAR2(2000);
     gvv_SQLSelectColumnList                   VARCHAR2(32000);
     gvv_SQLInsertColumnList                   VARCHAR2(32000);
     gvv_SQLUpdateColumnList                   VARCHAR2(32000);
     gvv_SQLWhereClause                        VARCHAR2(32000);
     gvc_SQLStatement                          CLOB;
     gvc_SQLResult                             CLOB;
     --
     --
     /*
     ******************************
     ** FUNCTION: get_object_status
     ******************************
     */
     --
     FUNCTION get_object_status
                    (
                     pt_i_Owner                     IN      all_objects.owner%TYPE
                    ,pt_i_ObjectName                IN      all_objects.object_name%TYPE
                    ,pt_i_ObjectType                IN      all_objects.object_type%TYPE
                    )
     RETURN VARCHAR2
     IS
          --
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
          CURSOR Object_cur
                      (
                       pt_Owner                       all_objects.owner%TYPE
                      ,pt_ObjectName                  all_objects.object_name%TYPE
                      ,pt_ObjectType                  all_objects.object_type%TYPE
                      )
          IS
               --
               SELECT  ao.status
               FROM    all_objects      ao
               WHERE   1 = 1
               AND     ao.owner       = pt_Owner
               AND     ao.object_name = pt_ObjectName
               AND     ao.object_type = pt_ObjectType;
               --
          --** END CURSOR Object_cur
          --
          --
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'get_object_status';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_Owner                       all_objects.owner%TYPE;
          vt_ObjectName                  all_objects.object_name%TYPE;
          vt_ObjectType                  all_objects.object_type%TYPE;
          vt_ObjectStatus                all_objects.status%TYPE;
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
     --** END Declarations **
     --
     BEGIN
          --
          gvv_ProgressIndicator := '0010';
          --
          IF   pt_i_Owner      IS NULL
          OR   pt_i_ObjectName IS NULL
          OR   pt_i_ObjectType IS NULL
          THEN
               --
               vt_ObjectStatus   := 'ERROR';
               gvt_Severity      := 'ERROR';
               gvt_ModuleMessage := 'All paramaters are mandatory in call to "'
                                  ||gct_PackageName
                                  ||'.'
                                  ||ct_ProcOrFuncName
                                  ||'".';
               --
               RAISE e_ModuleError;
               --
          ELSE
               --
               vt_Owner      := UPPER(pt_i_Owner);
               vt_ObjectName := UPPER(pt_i_ObjectName);
               vt_ObjectType := UPPER(pt_i_ObjectType);
               --
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          OPEN Object_cur
                    (
                     pt_Owner      => vt_Owner
                    ,pt_ObjectName => vt_ObjectName
                    ,pt_ObjectType => vt_ObjectType
                    );
          --
          gvv_ProgressIndicator := '0020';
          --
          FETCH Object_cur
          INTO  vt_ObjectStatus;
          --
          gvv_ProgressIndicator := '0030';
          --
          IF   Object_cur%NOTFOUND
          THEN
               --
               vt_ObjectStatus := 'NOT EXIST';
               --
          END IF;
          --
          gvv_ProgressIndicator := '0040';
          --
          CLOSE Object_cur;
          --
          RETURN(vt_ObjectStatus);
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                         ,pt_i_Application       => gct_XXMXApplication
                         ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                         ,pt_i_SubEntity         => gct_CoreSubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => gvt_Severity
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RETURN(vt_ObjectStatus);
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
                          pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                         ,pt_i_Application       => gct_XXMXApplication
                         ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                         ,pt_i_SubEntity         => gct_CoreSubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
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
     END get_object_status;
     --
     --
     /*
     ***************************************
     ** FUNCTION: get_row_count
     **
     ** Overloaded Function using File Set
     ** ID to group data.
     **
     ** Called from procedures which operate
     ** on Client Data loaded from Data File
     ** but before a Migration Set ID has
     ** been generated..
     **
     ** Returns a number which is the count
     ** of rows in a single table.
     **
     ** Allows upto 5 optional conditions
     ** to be added to the basic query.
     ***************************************
     */
     --
     FUNCTION get_row_count
                    (
                     pt_i_SchemaName                 IN      xxmx_stg_tables.schema_name%TYPE
                    ,pt_i_TableName                  IN      xxmx_stg_tables.table_name%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pv_i_OptionalJoinCondition1     IN      VARCHAR2 DEFAULT NULL
                    ,pv_i_OptionalJoinCondition2     IN      VARCHAR2 DEFAULT NULL
                    ,pv_i_OptionalJoinCondition3     IN      VARCHAR2 DEFAULT NULL
                    ,pv_i_OptionalJoinCondition4     IN      VARCHAR2 DEFAULT NULL
                    ,pv_i_OptionalJoinCondition5     IN      VARCHAR2 DEFAULT NULL
                    )
     RETURN NUMBER
     IS
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'get_row_count';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_MigrationSetName              xxmx_migration_headers.migration_set_name%TYPE;
          --
          --*************************
          --** Exception Declarations
          --*************************
          --
          --
     --** END Declarations **
     --
     BEGIN
          --
          gvt_Phase := 'CORE';
          --
          gvv_ProgressIndicator := '0010';
          --
          gvv_SQLAction1 := 'SELECT';
          --
          gvv_SQLSelectColumnList := 'COUNT(1)';
          --
          gvv_SQLTableClause := 'FROM '
                              ||pt_i_SchemaName
                              ||'.'
                              ||pt_i_TableName;
          --
          IF   pt_i_FileSetID IS NOT NULL
          THEN
               --
               gvv_SQLWhereClause := 'WHERE 1 = 1 '
                                   ||'AND file_set_id = '''
                                   ||pt_i_FileSetID
                                   ||'''';
               --
          ELSE
               --
               gvv_SQLWhereClause := 'WHERE 1 = 1 ';
               --
          END IF;
          --
          IF   pv_i_OptionalJoinCondition1 IS NOT NULL
          THEN
               --
               gvv_SQLWhereClause := gvv_SQLWhereClause
                                   ||' '
                                   ||pv_i_OptionalJoinCondition1;
               --
          END IF;
          --
          IF   pv_i_OptionalJoinCondition2 IS NOT NULL
          THEN
               --
               gvv_SQLWhereClause := gvv_SQLWhereClause
                                   ||' '
                                   ||pv_i_OptionalJoinCondition2;
               --
          END IF;
          --
          IF   pv_i_OptionalJoinCondition3 IS NOT NULL
          THEN
               --
               gvv_SQLWhereClause := gvv_SQLWhereClause
                                   ||' '
                                   ||pv_i_OptionalJoinCondition3;
               --
          END IF;
          --
          IF   pv_i_OptionalJoinCondition4 IS NOT NULL
          THEN
               --
               gvv_SQLWhereClause := gvv_SQLWhereClause
                                   ||' '
                                   ||pv_i_OptionalJoinCondition4;
               --
          END IF;
          --
          IF   pv_i_OptionalJoinCondition5 IS NOT NULL
          THEN
               --
               gvv_SQLWhereClause := gvv_SQLWhereClause
                                   ||' '
                                   ||pv_i_OptionalJoinCondition5;
               --
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          gvc_SQLStatement := gvv_SQLAction1
                            ||gcv_SQLSpace
                            ||gvv_SQLSelectColumnList
                            ||gcv_SQLSpace
                            ||gvv_SQLTableClause
                            ||gcv_SQLSpace
                            ||gvv_SQLWhereClause;
          --
          gvv_ProgressIndicator := '0030';
          --
          xxmx_utilities_pkg.log_module_message
                             (
                              pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                             ,pt_i_Application       => gct_XXMXApplication
                             ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                             ,pt_i_SubEntity         => 'ALL'
                             ,pt_i_FileSetID         => gvt_FileSetID
                             ,pt_i_MigrationSetID    => gvt_MigrationSetID
                             ,pt_i_Phase             => gvt_Phase
                             ,pt_i_Severity          => 'NOTIFICATION'
                             ,pt_i_PackageName       => gct_PackageName
                             ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                             ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                             ,pt_i_ModuleMessage     => SUBSTR(
                                                               '        - Generated SQL Statement: '
                                                             ||gvc_SQLStatement
                                                              ,1
                                                              ,4000
                                                              )
                             ,pt_i_OracleError       => NULL
                             );
          EXECUTE IMMEDIATE gvc_SQLStatement INTO gvc_SQLResult;
          --
          RETURN(TO_NUMBER(gvc_SQLResult));
          --
          EXCEPTION
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                         ,pt_i_Application       => gct_XXMXApplication
                         ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                         ,pt_i_SubEntity         => gct_CoreSubEntity
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    COMMIT; --** Commit the message to the Module Messages table.
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END get_row_count;
     --
     --
     /*
     ***************************************
     ** FUNCTION: get_row_count
     **
     ** Overloaded Function using Migration
     ** Set ID to group data.
     **
     ** Called from each Extract procedure
     ** when Client Data is being extracted
     ** from the Source Database via DB Link.
     **
     ** Returns a number which is the count
     ** of rows in a single table.
     **
     ** Allows upto 5 optional conditions
     ** to be added to the basic query.
     ***************************************
     */
     --
     FUNCTION get_row_count
                    (
                     pt_i_SchemaName                 IN      xxmx_stg_tables.schema_name%TYPE
                    ,pt_i_TableName                  IN      xxmx_stg_tables.table_name%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_i_OptionalJoinCondition1     IN      VARCHAR2 DEFAULT NULL
                    ,pv_i_OptionalJoinCondition2     IN      VARCHAR2 DEFAULT NULL
                    ,pv_i_OptionalJoinCondition3     IN      VARCHAR2 DEFAULT NULL
                    ,pv_i_OptionalJoinCondition4     IN      VARCHAR2 DEFAULT NULL
                    ,pv_i_OptionalJoinCondition5     IN      VARCHAR2 DEFAULT NULL
                    )
     RETURN NUMBER
     IS
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'get_row_count';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_MigrationSetName              xxmx_migration_headers.migration_set_name%TYPE;
          --
          --*************************
          --** Exception Declarations
          --*************************
          --
          --
     --** END Declarations **
     --
     BEGIN
          --
          gvt_Phase := 'CORE';
          --
          gvv_ProgressIndicator := '0010';
          --
          gvv_SQLAction1 := 'SELECT';
          --
          gvv_SQLSelectColumnList := 'COUNT(1)';
          --
          gvv_SQLTableClause := 'FROM '
                              ||pt_i_SchemaName
                              ||'.'
                              ||pt_i_TableName;
          --
          IF   pt_i_MigrationSetID IS NOT NULL
          THEN
               --
               gvv_SQLWhereClause := 'WHERE 1 = 1 '
                                   ||'AND migration_set_id = '''
                                   ||pt_i_MigrationSetID
                                   ||'''';
               --
          ELSE
               --
               gvv_SQLWhereClause := 'WHERE 1 = 1 ';
               --
          END IF;
          --
          IF   pv_i_OptionalJoinCondition1 IS NOT NULL
          THEN
               --
               gvv_SQLWhereClause := gvv_SQLWhereClause
                                   ||' '
                                   ||pv_i_OptionalJoinCondition1;
               --
          END IF;
          --
          IF   pv_i_OptionalJoinCondition2 IS NOT NULL
          THEN
               --
               gvv_SQLWhereClause := gvv_SQLWhereClause
                                   ||' '
                                   ||pv_i_OptionalJoinCondition2;
               --
          END IF;
          --
          IF   pv_i_OptionalJoinCondition3 IS NOT NULL
          THEN
               --
               gvv_SQLWhereClause := gvv_SQLWhereClause
                                   ||' '
                                   ||pv_i_OptionalJoinCondition3;
               --
          END IF;
          --
          IF   pv_i_OptionalJoinCondition4 IS NOT NULL
          THEN
               --
               gvv_SQLWhereClause := gvv_SQLWhereClause
                                   ||' '
                                   ||pv_i_OptionalJoinCondition4;
               --
          END IF;
          --
          IF   pv_i_OptionalJoinCondition5 IS NOT NULL
          THEN
               --
               gvv_SQLWhereClause := gvv_SQLWhereClause
                                   ||' '
                                   ||pv_i_OptionalJoinCondition5;
               --
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          gvc_SQLStatement := gvv_SQLAction1
                            ||gcv_SQLSpace
                            ||gvv_SQLSelectColumnList
                            ||gcv_SQLSpace
                            ||gvv_SQLTableClause
                            ||gcv_SQLSpace
                            ||gvv_SQLWhereClause;
          --
          gvv_ProgressIndicator := '0030';
          --
          EXECUTE IMMEDIATE gvc_SQLStatement INTO gvc_SQLResult;
          --
          RETURN(TO_NUMBER(gvc_SQLResult));
          --
          EXCEPTION
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                         ,pt_i_Application       => gct_XXMXApplication
                         ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                         ,pt_i_SubEntity         => gct_CoreSubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    COMMIT; --** Commit the message to the Module Messages table.
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END get_row_count;
     --
     --
     /*
     ************************************************************************
     ** PROCEDURE: prevalidate_stg_data
     **
     ** This procedure is only called by the STG_MAIN procedure when Client
     ** Data is being loaded intothe STG tables from Data Files.
     **
     ** It must not be called directly.
     **
     ** As it is only called internally, it does not call the
     ** "xxmx_utilities_pkg.valid_install" and
     ** "xxmx_utilities_pkg.valid_business_entity_setup"
     ** procedures as these are called in STG_MAIN.
     **
     ** The input parameters do not need to be validated because they are
     ** supplied by STG_MAIN.
     **
     ** This procedure calls "xxmx_utilities_pkg.init_file_migration_details"
     ** to register the Sub-Entity in the XXMX_MIGRATION_DETAILS table for
     ** the File Set ID.
     **
     ** It also calls
     ************************************************************************
     */
     --
     PROCEDURE prevalidate_stg_data
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_metadata.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_metadata.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    )
     IS
          --
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
          CURSOR STGTables_cur
                      (
                       pt_BusinessEntity             xxmx_migration_metadata.business_entity%TYPE
                      ,pt_SubEntity                  xxmx_migration_metadata.sub_entity%TYPE
                      )
          IS
               --
               SELECT    xst.stg_table_id
                        ,LOWER(xst.schema_name)                         AS stg_schema_name
                        ,LOWER(xst.table_name)                          AS stg_table_name
               FROM      xxmx_migration_metadata  xmd
                        ,xxmx_stg_tables          xst
               WHERE     1 = 1
               AND       xmd.business_entity = pt_BusinessEntity
               AND       xmd.sub_entity      = pt_SubEntity
               AND       xst.metadata_id     = xmd.metadata_id;
               --
          --** END CURSOR STGTables_cur;
          --
          CURSOR ColumnMappings_cur
                      (
                       pt_StgTableID                   xxmx_stg_table_columns.stg_table_id%TYPE
                      )
          IS
               --
               SELECT    LOWER(xstc.column_name)       AS stg_column_name
                        ,UPPER(xstc.lookup_type_name)  AS lookup_type_name
                        ,LOWER(xxtc.column_name)       AS xfm_column_name
                        ,UPPER(xxtc.transform_code)    AS transform_code
               FROM      xxmx_stg_tables          xst
                        ,xxmx_stg_table_columns   xstc
                        ,xxmx_xfm_table_columns   xxtc
               WHERE     1 = 1
               AND       xst.stg_table_id         = pt_StgTableID
               AND       xstc.stg_table_id        = xst.stg_table_id
               AND       xxtc.xfm_table_id        = xst.xfm_table_id
               AND       xxtc.xfm_table_column_id = xstc.xfm_table_column_id
               AND       (
                             xstc.lookup_type_name IS NOT NULL
                          OR xxtc.transform_code   IS NOT NULL
                         )
               ORDER BY  xstc.stg_column_seq;
               --
          --** END CURSOR ColumnMappings_cur;
          --
          --******************************
          --** Dynamic Cursor Declarations
          --******************************
          --
          STGColumnData_cur               RefCursor_t;
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'prevalidate_stg_data';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_StgTableID                   xxmx_stg_tables.stg_table_id%TYPE;
          vt_StgSchemaName                xxmx_stg_tables.schema_name%TYPE;
          vt_StgTableName                 xxmx_stg_tables.table_name%TYPE;
          vt_ErrorFlag                    xxmx_migration_details.error_flag%TYPE;
          vn_RowSeq                       NUMBER;
          vn_Rowid                        VARCHAR2(1000);
          ct_Phase                        xxmx_module_messages.phase%TYPE := 'EXTRACT';
          vt_OperatingUnitName            xxmx_simple_transforms.source_operating_unit_name%TYPE;
          vt_SourceValue                  xxmx_simple_transforms.source_value%TYPE;
          vt_FusionValue                  xxmx_simple_transforms.fusion_value%TYPE;
          --
          --*************************
          --** Exception Declarations
          --*************************
          --
          e_ModuleError                   EXCEPTION;
          --
     --** END Declarations **
     --
     BEGIN
          --
          gvt_Phase :=  ct_Phase;
          --
          vt_ErrorFlag := 'N';
          --
          gvv_ProgressIndicator := '0010';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_FileSetID         => pt_i_FileSetID
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||' ('
                                        ||pt_i_BusinessEntity
                                        ||' / '
                                        ||pt_i_SubEntity
                                        ||') initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          /*
          ** For Client Data being loaded from Data File, this is the first Maximise
          ** process which operates on the Client Data at the Sub-Entity Level.
          **
          ** Therefore, it is this procedure what must write the initial Migration Detail
          ** record for each Sub-Entity.
          */
          --
          gvv_ProgressIndicator := '0050';
          --
          xxmx_utilities_pkg.init_file_migration_details
               (
                pt_i_ApplicationSuite       => pt_i_ApplicationSuite
               ,pt_i_Application            => pt_i_Application
               ,pt_i_BusinessEntity         => pt_i_BusinessEntity
               ,pt_i_SubEntity              => pt_i_SubEntity
               ,pt_i_FileSetID              => pt_i_FileSetID
               ,pt_i_ValidateStartTimestamp => LOCALTIMESTAMP
               );
          --
          /*
          ** Identify Sub-Entity specific STG tables using the STGTables_cur cursor.
          */
          --
          gvv_ProgressIndicator := '0060';
          --
          FOR STGTable_rec
          IN  STGTables_cur
                   (
                    pt_i_BusinessEntity
                   ,pt_i_SubEntity
                   )
          LOOP
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => 0
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- STG table identified '
                                             ||'for Business Entity "'
                                             ||pt_i_BusinessEntity
                                             ||'" and Sub-Entity "'
                                             ||pt_i_SubEntity
                                             ||'".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => 0
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - STG Table : "'
                                             ||STGTable_rec.stg_schema_name
                                             ||'.'
                                             ||STGTable_rec.stg_table_name
                                             ||'"'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0070';
               --
               gvn_RowCount := get_row_count
                                    (
                                     pt_i_SchemaName             => STGTable_rec.stg_schema_name
                                    ,pt_i_TableName              => STGTable_rec.stg_table_name
                                    ,pt_i_FileSetID              => pt_i_FileSetID
                                    ,pv_i_OptionalJoinCondition1 => NULL
                                    ,pv_i_OptionalJoinCondition2 => NULL
                                    ,pv_i_OptionalJoinCondition3 => NULL
                                    ,pv_i_OptionalJoinCondition4 => NULL
                                    ,pv_i_OptionalJoinCondition5 => NULL
                                    );
               --
               IF   gvn_RowCount = 0
               THEN
                    --
                    vt_ErrorFlag := 'Y';
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - There is no data in this table for File Set ID "'
                                                  ||pt_i_FileSetID
                                                  ||'".'
                         ,pt_i_OracleError       => NULL
                         );
                    --
               ELSE
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - '
                                                  ||gvn_RowCount
                                                  ||' rows exist in this table for File Set ID "'
                                                  ||pt_i_FileSetID
                                                  ||'".'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    /*
                    ** Loop through the columns in the STG table that require data verification
                    ** by LOOKUP_TYPE or TRANSFORM_CODE.
                    **
                    ** The "ColumnMappings_cur" cursor links the STG table columns to their respective XFM table
                    ** columns to retrieve the LOOKUP_TYPE from the STG table column definition and the
                    ** TRANSFORM_CODE from the XFM table column definition.  A column could have one or the
                    ** other or both.
                    **
                    ** This pre-validation procedure should not be called by STG_MAIN if the
                    ** "xxmx_utilities_pkg.valid_install" or "xxmx_utilities_pkg.valid_business_entity_setup"
                    ** functions failed.  The latter function checks that all columns are fully mapped so this
                    ** "ColumnMappings_cur" should not miss anything out.
                    */
                    --
                    gvv_ProgressIndicator := '0080';
                    --
                    FOR  ColumnMapping_rec
                    IN   ColumnMappings_cur
                              (
                               STGTable_rec.stg_table_id
                              )
                    LOOP
                         --
                         /*
                         ** Build a Ref Cursor to select the data from the STG table
                         ** for a single column.
                         */
                         --
                         gvv_ProgressIndicator := '0090';
                         --
                         gvv_SQLAction1 := 'SELECT';
                         --
                         gvv_SQLSelectColumnList := 'rowid, '
                                                  --||'operating_unit_name, '
                                                  ||ColumnMapping_rec.stg_column_name;
                         --
                         gvv_SQLTableClause := 'FROM '
                                             ||STGTable_rec.stg_schema_name
                                             ||'.'
                                             ||STGTable_rec.stg_table_name;
                         --
                         gvv_SQLWhereClause := 'WHERE 1 = 1 '
                                             ||'AND file_set_id = '''
                                             ||pt_i_FileSetID
                                             ||''' AND '
                                             ||ColumnMapping_rec.stg_column_name
                                             ||' IS NOT NULL';
                         --
                         gvc_SQLStatement := gvv_SQLAction1
                                           ||gcv_SQLSpace
                                           ||gvv_SQLSelectColumnList
                                           ||gcv_SQLSpace
                                           ||gvv_SQLTableClause
                                           ||gcv_SQLSpace
                                           ||gvv_SQLWhereClause;
                         --
                         gvv_ProgressIndicator := '0100';

                         /*INSERT INTO isv_temp
                         (SQL_STATEMENT)
                         VALUES
                         (gvc_SQLStatement);*/
                         COMMIT;
                         --
                         OPEN STGColumnData_cur
                         FOR  gvc_SQLStatement;
                         --
                         gvv_ProgressIndicator := '0110';
                         --
                         LOOP
                              --
                              gvv_ProgressIndicator := '0120';
                              --
                              FETCH  STGColumnData_cur
                              INTO   vn_Rowid
                                   -- ,vt_OperatingUnitName
                                    ,vt_SourceValue;
                              --
                              gvv_ProgressIndicator := '0130';
                              --
                              EXIT WHEN STGColumnData_cur%NOTFOUND;
                              --
                              /*
                              ** If the STG column is validated by LOOKUP_TYPE then
                              ** verify that the Source Value is one of the valid
                              ** LOOKUP_CODES.
                              */
                              --
                              IF   ColumnMapping_rec.lookup_type_name IS NOT NULL
                              THEN
                                   --
                                   gvv_ProgressIndicator := '0130';
                                   --
                                   xxmx_utilities_pkg.verify_lookup_code
                                        (
                                         pt_i_LookupType    => ColumnMapping_rec.lookup_type_name
                                        ,pt_i_LookupCode    => vt_SourceValue
                                        ,pv_o_ReturnStatus  => gvv_ReturnStatus
                                        ,pt_o_ReturnMessage => gvt_ReturnMessage
                                        );
                                   --
                                   IF   gvv_ReturnStatus <> 'S'
                                   THEN
                                        --
                                        vt_ErrorFlag := 'Y';
                                        --
                                        xxmx_utilities_pkg.log_data_message
                                             (
                                              pt_i_ApplicationSuite      => pt_i_ApplicationSuite
                                             ,pt_i_Application           => pt_i_Application
                                             ,pt_i_BusinessEntity        => pt_i_BusinessEntity
                                             ,pt_i_SubEntity             => pt_i_SubEntity
                                             --,pt_i_FileSetID             => pt_i_FileSetID
                                             ,pt_i_MigrationSetID        => 0
                                             ,pt_i_Phase                 => gvt_Phase
                                             ,pt_i_Severity              => 'ERROR'
                                             ,pt_i_DataTable             => STGTable_rec.stg_table_name
                                             ,pt_i_RecordIdentifiers     => vn_RowSeq
                                             ,pt_i_DataMessage           => gvt_ReturnMessage
                                             ,pt_i_DataElementsAndValues => 'COLUMN['
                                                                         ||ColumnMapping_rec.stg_column_name
                                                                         ||'] - VALUE['
                                                                         ||vt_SourceValue
                                                                         ||'] is not a valid LOOKUP_CODE for LOOKUP_TYPE "'
                                                                         ||ColumnMapping_rec.lookup_type_name
                                                                         ||'" in XXMX_LOOKUP_VALUES.'
                                             ); -- Pallavi 
                                        --
                                   END IF; --** IF gvv_ReturnStatus <> 'S'
                                   --
                              END IF; --** IF ColumnMapping_rec.lookup_type IS NOT NULL
                              --
                              /*
                              ** If the STG column is validated by TRANSFORM_CODE then
                              ** verify that the Source Value is one of the valid
                              ** transform SOURCE_VALUES.
                              */
                              --
                             /* IF   ColumnMapping_rec.transform_code IS NOT NULL
                              THEN
                                   --
                                   gvv_ProgressIndicator := '0140';
                                   --
                                   gvv_ReturnStatus  := NULL;
                                   gvv_ReturnCode    := NULL;
                                   gvt_ReturnMessage := NULL;
                                   --
                                   xxmx_utilities_pkg.evaluate_transform
                                        (
                                         pt_i_ApplicationSuite        => pt_i_ApplicationSuite
                                        ,pt_i_Application             => pt_i_Application
                                        ,pt_i_SourceOperatingUnitName => vt_OperatingUnitName
                                        ,pt_i_TransformCode           => ColumnMapping_rec.transform_code
                                        ,pt_i_SourceValue             => vt_SourceValue
                                        ,pt_i_EvaluationMode          => 'VERIFY'
                                        ,pt_o_FusionValue             => vt_FusionValue
                                        ,pv_o_ReturnStatus            => gvv_ReturnStatus
                                        ,pv_o_ReturnCode              => gvv_ReturnCode
                                        ,pv_o_ReturnMessage           => gvt_ReturnMessage
                                        );
                                   --
                                   IF   gvv_ReturnStatus <> 'S'
                                   THEN
                                        --
                                        vt_ErrorFlag := 'Y';
                                        --
                                        IF   gvv_ReturnCode = 'INVALID_OU'
                                        THEN
                                             --

                                             xxmx_utilities_pkg.log_data_message
                                                  (
                                                   pt_i_ApplicationSuite      => pt_i_ApplicationSuite
                                                  ,pt_i_Application           => pt_i_Application
                                                  ,pt_i_BusinessEntity        => pt_i_BusinessEntity
                                                  ,pt_i_SubEntity             => pt_i_SubEntity
                                                  ,pt_i_FileSetID             => pt_i_FileSetID
                                                  ,pt_i_MigrationSetID        => 0
                                                  ,pt_i_Phase                 => gvt_Phase
                                                  ,pt_i_Severity              => 'ERROR'
                                                  ,pt_i_DataTable             => STGTable_rec.stg_table_name
                                                  ,pt_i_RowSeq                => vn_RowSeq
                                                  ,pt_i_DataMessage           => gvt_ReturnMessage
                                                  ,pt_i_DataElementsAndValues => 'Operating Unit Name ['
                                                                              ||vt_OperatingUnitName
                                                                              ||'] does not exist in the XXMX_SOURCE_OPERATING_UNITS table.'
                                                  ); -- Pallavi
                                             --
                                        ELSE
                                             --

                                             xxmx_utilities_pkg.log_data_message
                                                  (
                                                   pt_i_ApplicationSuite      => pt_i_ApplicationSuite
                                                  ,pt_i_Application           => pt_i_Application
                                                  ,pt_i_BusinessEntity        => pt_i_BusinessEntity
                                                  ,pt_i_SubEntity             => pt_i_SubEntity
                                                  ,pt_i_FileSetID             => pt_i_FileSetID
                                                  ,pt_i_MigrationSetID        => 0
                                                  ,pt_i_Phase                 => gvt_Phase
                                                  ,pt_i_Severity              => 'ERROR'
                                                  ,pt_i_DataTable             => STGTable_rec.stg_table_name
                                                  ,pt_i_RowSeq                => vn_RowSeq
                                                  ,pt_i_DataMessage           => gvt_ReturnMessage
                                                  ,pt_i_DataElementsAndValues => 'COLUMN['
                                                                              ||ColumnMapping_rec.stg_column_name
                                                                              ||'] - VALUE['
                                                                              ||vt_SourceValue
                                                                              ||'] is not a valid SOURCE_VALUE value for TRANSFORM_CODE "'
                                                                              ||ColumnMapping_rec.transform_code
                                                                              ||'" in the XXMX_SIMPLE_TRANSFORMS table.'
                                                  );
                                                  -- Pallavi 
                                             --
                                        END IF; --** IF gvv_ReturnCode = 'INVALID_OU' **
                                        --
                                   END IF; --** IF gvv_ReturnStatus <> 'S'
                                   --
                              END IF; --** IF ColumnMapping_rec.transform_code IS NOT NULL
                              */ -- Commented by Pallavi to remove Transform from Staging tables 
                              --
                         END LOOP; --** STGColumnData_cur LOOP
                         --
                    END LOOP; --** ColumnMappings_cur LOOP
                    --
               END IF; --** IF gvn_RowCount = 0;
               --
          END LOOP; --** STGTables_cur LOOP
          --
          /*
          ** Update the Migration Details for this Sub-Entity with the
          ** Validate End Timestamp.
          */
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_FileSetID         => pt_i_FileSetID
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '- Updating Migration Detail record.'
               ,pt_i_OracleError       => NULL
               );
          --
          gvt_Phase :=  ct_Phase;

          xxmx_utilities_pkg.upd_file_migration_details
               (
                pt_i_ApplicationSuite        => pt_i_ApplicationSuite
               ,pt_i_Application             => pt_i_Application
               ,pt_i_BusinessEntity          => pt_i_BusinessEntity
               ,pt_i_SubEntity               => pt_i_SubEntity
               ,pt_i_FileSetID               => pt_i_FileSetID
               ,pt_i_Phase                   => gvt_Phase
               ,pt_i_ValidateEndTimestamp    => LOCALTIMESTAMP
               ,pt_i_ValidateRowCount        => gvn_RowCount
               ,pt_i_TransformStartTimestamp => NULL
               ,pt_i_TransformEndTimestamp   => NULL
               ,pt_i_ExportFileName          => NULL
               ,pt_i_ExportStartTimestamp    => NULL
               ,pt_i_ExportEndTimestamp      => NULL
               ,pt_i_ExportRowCount          => NULL
               ,pt_i_ErrorFlag               => vt_ErrorFlag
               );
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_FileSetID         => pt_i_FileSetID
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '- Migration Detail record updated.'
               ,pt_i_OracleError       => NULL
               );
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_FileSetID         => pt_i_FileSetID
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||' ('
                                        ||pt_i_BusinessEntity
                                        ||' / '
                                        ||pt_i_SubEntity
                                        ||') completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                         ,pt_i_Application       => gct_XXMXApplication
                         ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                         ,pt_i_SubEntity         => gct_CoreSubEntity
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'ERROR'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END e_ModuleError Exception
               --
               WHEN OTHERS
               THEN
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                         ,pt_i_Application       => gct_XXMXApplication
                         ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                         ,pt_i_SubEntity         => gct_CoreSubEntity
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END prevalidate_stg_data;
     --
     --
     /*
     ********************************************************
     ** PROCEDURE: transfer_stg_data
     **
     ** This procedure is called by the XFM_MAIN procedure
     ** and must not be called directly hence there is no
     ** Procedure specification in the Package Specification.
     **
     ** As it is only called internally, it does not call the
     ** "xxmx_utilities_pkg.valid_install" and
     ** "xxmx_utilities_pkg.valid_business_entity_setup"
     ** procedures as these are called in XFM_MAIN.
     **
     ** The input parameters do not need to be validated
     ** because they are supplied by XFM_MAIN.
     ********************************************************
     */
     --
     PROCEDURE transfer_stg_data
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_metadata.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_metadata.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    )
     IS
          --
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
          CURSOR TablePairs_cur
                      (
                       pt_BusinessEntity             xxmx_migration_metadata.business_entity%TYPE
                      ,pt_SubEntity                  xxmx_migration_metadata.sub_entity%TYPE
                      )
          IS
               --
               SELECT    xst.stg_table_id                               AS stg_table_id
                        ,LOWER(xst.schema_name)                         AS stg_schema_name
                        ,LOWER(xst.table_name)                          AS stg_table_name
                        ,xxt.xfm_table_id                               AS xfm_table_id
                        ,LOWER(xxt.schema_name)                         AS xfm_schema_name
                        ,LOWER(xxt.table_name)                          AS xfm_table_name
               FROM      xxmx_migration_metadata  xmd
                        ,xxmx_stg_tables          xst
                        ,xxmx_xfm_tables          xxt
               WHERE     1 = 1
               AND       xmd.business_entity = pt_BusinessEntity
               AND       xmd.sub_entity      = pt_SubEntity
               AND       xst.metadata_id     = xmd.metadata_id
               AND       xxt.xfm_table_id    = xst.xfm_table_id;
               --
          --** END CURSOR TablePairs_cur;
          --
          CURSOR ColumnMappings_cur
                      (
                       pt_StgTableID                   xxmx_stg_table_columns.stg_table_id%TYPE
                      )
          IS
               --
               SELECT    LOWER(xstc.column_name)  AS stg_column_name
                        ,LOWER(xxtc.column_name)  AS xfm_column_name
               FROM      xxmx_stg_table_columns   xstc
                        ,xxmx_xfm_table_columns   xxtc
               WHERE     1 = 1
               AND       xstc.stg_table_id        = pt_StgTableID
               AND       xxtc.xfm_table_column_id = xstc.xfm_table_column_id
               ORDER BY  xstc.stg_column_seq;
               --
          --** END CURSOR ColumnMappings_cur;
          --
          --******************************
          --** Dynamic Cursor Declarations
          --******************************
          --
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'transfer_stg_data';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_StgTableID                   xxmx_stg_tables.stg_table_id%TYPE;
          vt_StgSchemaName                xxmx_stg_tables.schema_name%TYPE := 'XXMX_STG';
          vt_StgTableName                 xxmx_stg_tables.table_name%TYPE;
          vt_XfmTableID                   xxmx_xfm_tables.xfm_table_id%TYPE;
          vt_XfmSchemaName                xxmx_xfm_tables.schema_name%TYPE:= 'XXMX_XFM';
          vt_XfmTableName                 xxmx_xfm_tables.table_name%TYPE;
          vv_IDLabel                      VARCHAR2(100);
          vv_IDCondition                  VARCHAR2(100);
          --
          --*************************
          --** Exception Declarations
          --*************************
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
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application     
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_FileSetID         => pt_i_FileSetID
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||' ('
                                        ||pt_i_BusinessEntity
                                        ||' / '
                                        ||pt_i_SubEntity
                                        ||') initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          gvv_ProgressIndicator := '0050';
          --
          --
          /*
          ** Identify STG and XFM tables from Business entity and Sub-entity parameters.
          **
          ** These should be passed to this procedure in UPPERCASE by XFM_MAIN.
          */
          --
          gvv_ProgressIndicator := '0060';
          --
          FOR  TablePair_rec
          IN   TablePairs_cur
                    (
                     pt_i_BusinessEntity
                    ,pt_i_SubEntity
                    )
          LOOP
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Data tables identified '
                                             ||'for Business Entity "'
                                             ||pt_i_BusinessEntity
                                             ||'" and Sub-Entity "'
                                             ||pt_i_SubEntity
                                             ||'".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - STG Table : "'
                                             ||TablePair_rec.stg_schema_name
                                             ||'.'
                                             ||TablePair_rec.stg_table_name
                                             ||'"'
                    ,pt_i_OracleError       => NULL
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - XFM Table : "'
                                             ||TablePair_rec.xfm_schema_name
                                             ||'.'
                                             ||TablePair_rec.xfm_table_name
                                             ||'"'
                    ,pt_i_OracleError       => NULL
                    );
               --
               IF   pt_i_StgPopulationMethod = 'DATA_FILE'
               THEN
                    --
                    vv_IDLabel := 'File Set ID "'
                                ||pt_i_FileSetID
                                ||'"';
                    --
                    vv_IDCondition := 'file_set_id = :1 ';
                    --
                    gvv_ProgressIndicator := '0070';
                    --
                    gvn_RowCount := get_row_count
                                         (
                                          pt_i_SchemaName             => vt_StgSchemaName
                                         ,pt_i_TableName              => TablePair_rec.stg_table_name
                                         ,pt_i_FileSetID              => pt_i_FileSetID
                                         ,pv_i_OptionalJoinCondition1 => NULL
                                         ,pv_i_OptionalJoinCondition2 => NULL
                                         ,pv_i_OptionalJoinCondition3 => NULL
                                         ,pv_i_OptionalJoinCondition4 => NULL
                                         ,pv_i_OptionalJoinCondition5 => NULL
                                         );
                    --
               ELSE /* pt_i_StgPopulationMethod = 'DB_LINK' */
                    --
                    vv_IDLabel := 'Migration Set ID "'
                                ||pt_i_MigrationSetID
                                ||'"';
                    --
                    vv_IDCondition := 'migration_set_id = :1 ';
                    --
                    gvv_ProgressIndicator := '0070';
                    --
                    gvn_RowCount := get_row_count
                                         (
                                          pt_i_SchemaName             => vt_StgSchemaName
                                         ,pt_i_TableName              => TablePair_rec.stg_table_name
                                         ,pt_i_MigrationSetID         => pt_i_MigrationSetID
                                         ,pv_i_OptionalJoinCondition1 => NULL
                                         ,pv_i_OptionalJoinCondition2 => NULL
                                         ,pv_i_OptionalJoinCondition3 => NULL
                                         ,pv_i_OptionalJoinCondition4 => NULL
                                         ,pv_i_OptionalJoinCondition5 => NULL
                                         );
                    --
               END IF; --** IF pt_i_StgPopulationMethod = 'DATA_FILE'
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Transferring Client Data from STG to XFM table for '
                                             ||vv_IDLabel
                                             ||'.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - '
                                             ||gvn_RowCount
                                             ||' rows exist in the STG table for '
                                             ||vv_IDLabel
                                             ||'.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Constructing DELETE statement to '
                                             ||'remove data previously populated into the '
                                             ||'XFM table for '
                                             ||vv_IDLabel
                                             ||'.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               /*
               ** Construct the initial DELETE statement.
               */
               --
               gvv_ProgressIndicator := '0080';
               --
               gvv_SQLAction1 := 'DELETE FROM '
                               ||gcv_SQLSpace
                               ||TablePair_rec.xfm_schema_name
                               ||'.'
                               ||TablePair_rec.xfm_table_name
                               ||' xfm';                       -- table_alias
               --
               /*
               ** Construct the WHERE clause for the DELETE statement.
               */
               --
               gvv_SQLWhereClause := 'WHERE  1 = 1 '
                                   ||'AND    xfm.'
                                   ||vv_IDCondition;
               --
               gvc_SQLStatement := gvv_SQLAction1
                                 ||gcv_SQLSpace
                                 ||gvv_SQLWhereClause;

               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '    - SQL Statement "'
                                             ||gvv_SQLAction1
                                             ||'..." constructed.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0082';
               --
              /* INSERT
               INTO   isv_temp
                           (
                            sql_statement
                           )
               VALUES      (
                            gvc_SQLStatement
                           );*/
               --
               gvv_ProgressIndicator := '0084';
               --
              /* INSERT
               INTO   isv_temp
                           (
                            sql_statement
                           )
               VALUES      (
                            'Statement Length = '||LENGTH(gvc_SQLStatement)
                           );*/
               --
               COMMIT;
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '      - Executing SQL Statement.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0090';
               --
               IF   pt_i_StgPopulationMethod = 'DATA_FILE'
               THEN
                    --
                    EXECUTE IMMEDIATE gvc_SQLStatement
                                USING pt_i_FileSetID;
                    --
               ELSE  /* pt_i_StgPopulationMethod = 'DB_LINK' */
                    --
                    EXECUTE IMMEDIATE gvc_SQLStatement
                                USING pt_i_MigrationSetID;
                    --
               END IF; --** IF pt_i_StgPopulationMethod = 'DATA_FILE'
               --
               gvv_ProgressIndicator := '0100';
               --
               gvn_RowCount := SQL%ROWCOUNT;
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '        - '
                                             ||gvn_RowCount
                                             ||' Rows deleted.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '      - SQL Statement execution complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '    - DELETE from XFM table complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Constructing INSERT AS SELECT statement to '
                                             ||'select from STG table and insert into XFM table.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               /*
               ** Construct the SELECT and INSERT column lists from the
               ** XXMX_STG_TABLE_COLUMNS Data Dictionary table.
               */
               --
               gvv_ProgressIndicator := '0110';
               --
               gvv_SQLSelectColumnList := '';
               gvv_SQLInsertColumnList := '';
               --
               FOR  ColumnMapping_rec
               IN   ColumnMappings_cur
                         (
                          TablePair_rec.stg_table_id
                         )
               LOOP
                    --
                    gvv_SQLInsertColumnList := gvv_SQLInsertColumnList
                                             ||','
                                             ||ColumnMapping_rec.xfm_column_name;
                    --
                    gvv_SQLSelectColumnList := gvv_SQLSelectColumnList
                                             ||','
                                             ||'stg.'
                                             ||ColumnMapping_rec.stg_column_name;
                    --
               END LOOP;

               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => SUBSTR('- SQL Statement "'
                                             ||gvv_SQLSelectColumnList
                                             ||'..." constructed.',1,3000)
                    ,pt_i_OracleError       => NULL
                    );
               --
               /*
               ** Trim leading commas from the column lists and encapsulate in parentheses as appropriate.
               */
               --
               gvv_ProgressIndicator := '0120';
               --
               gvv_SQLInsertColumnList := LOWER(
                                                '( '
                                              ||LTRIM(gvv_SQLInsertColumnList, ',')
                                              ||' )'
                                               );
               --
               gvv_SQLSelectColumnList := LOWER(
                                                LTRIM(gvv_SQLSelectColumnList, ',')
                                               );


               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => SUBSTR('- SQL Statement "'
                                             ||gvv_SQLInsertColumnList
                                             ||'..." constructed.',1,3000)
                    ,pt_i_OracleError       => NULL
                    );
               --
               /*
               ** Construct the SQL Actions used for the
               ** INSERT and SELECT components of the
               ** INSERT AS SELECT statement.
               */
               --
               gvv_SQLAction1 := 'INSERT INTO'
                               ||gcv_SQLSpace
                               ||TablePair_rec.xfm_schema_name
                               ||'.'
                               ||TablePair_rec.xfm_table_name;
               --
               gvv_SQLAction2 := 'SELECT';
               --
               /*
               ** Construct the Table clause (FROM clause in this case)
               ** used for the SELECT statement component of the
               ** INSERT AS SELECT.
               */
               --
               gvv_SQLTableClause := 'FROM'
                                   ||gcv_SQLSpace
                                   ||TablePair_rec.stg_schema_name
                                   ||'.'
                                   ||TablePair_rec.stg_table_name
                                   ||' stg';       -- table_alias
               --
               /*
               ** Construct the WHERE clause used for the
               ** SELECT statement component of the
               ** INSERT AS SELECT.
               */
               --
               gvv_SQLWhereClause := 'WHERE  1 = 1 '
                                   ||'AND    stg.'
                                   ||vv_IDCondition;
               --
               /*
               ** Start constructing the XFM table INSERT AS SELECT statement.
               */
               --
               gvc_SQLStatement := gvv_SQLAction1
                                 ||gcv_SQLSpace
                                 ||gvv_SQLInsertColumnList
                                 ||gcv_SQLSpace
                                 ||gvv_SQLAction2
                                 ||gcv_SQLSpace
                                 ||gvv_SQLSelectColumnList
                                 ||gcv_SQLSpace
                                 ||gvv_SQLTableClause
                                 ||gcv_SQLSpace
                                 ||gvv_SqlWhereClause;
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => SUBSTR('- SQL Statement "'
                                             ||gvc_SQLStatement
                                             ||'..." constructed.',1,3000)
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0122';
               --
               /*INSERT
               INTO   isv_temp
                           (
                            sql_statement
                           )
               VALUES      (
                            gvc_SQLStatement
                           );*/
               --
               gvv_ProgressIndicator := '0124';
               --
               /*INSERT
               INTO   isv_temp
                           (
                            sql_statement
                           )
               VALUES      (
                            'Statement Length = '||LENGTH(gvc_SQLStatement)
                           );*/
               --
               COMMIT;
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '      - Executing SQL Statement.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0130';
               --
               IF   pt_i_StgPopulationMethod = 'DATA_FILE'
               THEN
                    --
                    EXECUTE IMMEDIATE gvc_SQLStatement
                                USING pt_i_FileSetID;
                    --
               ELSE  /* pt_i_StgPopulationMethod = 'DB_LINK' */
                    --
                    EXECUTE IMMEDIATE gvc_SQLStatement
                                USING pt_i_MigrationSetID;
                    --
               END IF; --** IF pt_i_StgPopulationMethod = 'DATA_FILE'
               --
               gvv_ProgressIndicator := '0140';
               --
               gvn_RowCount := SQL%ROWCOUNT;
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '        - '
                                             ||gvn_RowCount
                                             ||' Rows copied.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '      - SQL Statement execution complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '    - INSERT into XFM table complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               /*
               ** Update the XFM table to set the XFM_STATUS to "PRE-TRANSFORM".
               */
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Constructing UPDATE statement to '
                                             ||'set "xfm_status" column to "PRE-TRANSFORM".'
                    ,pt_i_OracleError       => NULL
                    );
               --
               /*
               ** Construct the initial UPDATE statement.
               */
               --
               gvv_ProgressIndicator := '0150';
               --
               gvv_SQLAction1 := 'UPDATE'
                               ||gcv_SQLSpace
                               ||TablePair_rec.xfm_schema_name
                               ||'.'
                               ||TablePair_rec.xfm_table_name
                               ||gcv_SQLSpace
                               ||'xfm';        -- Table alias
               --
               /*
               ** construct the UPDATE column list.
               */
               --
               gvv_SQLUpdateColumnList := 'SET'
                                        ||gcv_SQLSpace
                                        ||'xfm.migration_status = ''PRE-TRANSFORM''';
               --
               /*
               ** Construct the WHERE clause for the UPDATE statement.
               */
               --
               gvv_SQLWhereClause := 'WHERE  1 = 1 '
                                   ||'AND    xfm.'
                                   ||vv_IDCondition;
               --
               gvc_SQLStatement := gvv_SQLAction1
                                 ||gcv_SQLSpace
                                 ||gvv_SQLUpdateColumnList
                                 ||gcv_SQLSpace
                                 ||gvv_SQLWhereClause;

               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '    - "'
                                             ||gvv_SQLAction1
                                             ||'..." SQL Statement constructed.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0152';
               --
               /*INSERT
               INTO   isv_temp
                           (
                            sql_statement
                           )
               VALUES      (
                            gvc_SQLStatement
                           );*/
               --
               gvv_ProgressIndicator := '0154';
               --
               /*INSERT
               INTO   isv_temp
                           (
                            sql_statement
                           )
               VALUES      (
                            'Statement Length = '||LENGTH(gvc_SQLStatement)
                           );*/
               --
               COMMIT;
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '      - Executing SQL Statement.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0160';
               --
               IF   pt_i_StgPopulationMethod = 'DATA_FILE'
               THEN
                    --
                    EXECUTE IMMEDIATE gvc_SQLStatement
                                USING pt_i_FileSetID;
                    --
               ELSE  /* pt_i_StgPopulationMethod = 'DB_LINK' */
                    --
                    EXECUTE IMMEDIATE gvc_SQLStatement
                                USING pt_i_MigrationSetID;
                    --
               END IF; --** IF pt_i_StgPopulationMethod = 'DATA_FILE'
               --
               gvv_ProgressIndicator := '0170';
               --
               gvn_RowCount := SQL%ROWCOUNT;
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '        - '
                                             ||gvn_RowCount
                                             ||' Rows updated.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '      - SQL Statement execution complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '    - UPDATE of XFM table complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Client Data transfer from STG to XFM table '
                                             ||'for Business Entity "'
                                             ||pt_i_Businessentity
                                             ||'", Sub-Entity "'
                                             ||pt_i_SubEntity
                                             ||'" and '
                                             ||vv_IDLabel
                                             ||' complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
          END LOOP; --** TablePairs_cur LOOP
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application     
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_FileSetID         => pt_i_FileSetID
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||' ('
                                        ||pt_i_BusinessEntity
                                        ||' / '
                                        ||pt_i_SubEntity
                                        ||') completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    ROLLBACK;
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'ERROR'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END e_ModuleError Exception
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END transfer_stg_data;
     --
     --
     /*
     ********************************************************
     ** PROCEDURE: transform_data
     **
     ** This procedure is called by the XFM_MAIN procedure
     ** and must not be called directly hence there is no
     ** Procedure specification in the Package Specification.
     **
     ** As it is only called internally, it does not call the
     ** "xxmx_utilities_pkg.valid_install" and
     ** "xxmx_utilities_pkg.valid_business_entity_setup"
     ** procedures as these are called in XFM_MAIN.
     **
     ** The input parameters do not need to be validated
     ** because they are supplied by XFM_MAIN.
     ********************************************************
     */
     --
     PROCEDURE transform_data
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_metadata.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_metadata.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    )
     IS
          --
          --********************
          --** Type Declarations
          --********************
          --
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
          CURSOR TransformMetadata_cur
                      (
                       pt_BusinessEntity             xxmx_migration_metadata.business_entity%TYPE
                      ,pt_SubEntity                  xxmx_migration_metadata.sub_entity%TYPE
                      )
          IS
               --
               SELECT    xmd.application_suite
                        ,xmd.application
                        ,xst.stg_table_id
                        ,LOWER(xst.schema_name)                         AS stg_schema_name
                        ,LOWER(xst.table_name)                          AS stg_table_name
                        ,xxt.xfm_table_id
                        ,LOWER(xxt.schema_name)                         AS xfm_schema_name
                        ,LOWER(xxt.table_name)                          AS xfm_table_name
               FROM      xxmx_migration_metadata  xmd
                        ,xxmx_stg_tables          xst
                        ,xxmx_xfm_tables          xxt
               WHERE     1 = 1
               AND       xmd.business_entity = pt_BusinessEntity
               AND       xmd.sub_entity      = pt_SubEntity
               AND       xst.metadata_id     = xmd.metadata_id
               AND       xxt.xfm_table_id    = xst.xfm_table_id;
               --
          --** END CURSOR TransformMetadata_cur;
          --
          CURSOR ColumnsToUpdate_cur
                      (
                       pt_XfmTableID                   xxmx_xfm_table_columns.xfm_table_id%TYPE
                      )
          IS
               --
               SELECT    xfm_column_seq
                        ,LOWER(xxtc.column_name)                             AS xfm_column_name
                        ,xxtc.transform_code
                        ,xxtc.default_value
                        ,UPPER(NVL(xxtc.default_overrides_source_val, 'N'))  AS default_overrides_source_val
                        ,UPPER(NVL(xxtc.default_on_transform_fail, 'N'))     AS default_on_transform_fail
               FROM      xxmx_xfm_table_columns   xxtc
                        ,xxmx_stg_table_columns   xstc
               WHERE     1 = 1
               AND       xxtc.xfm_table_id        = pt_XfmTableID
               AND       (
                             xxtc.transform_code     IS NOT NULL
                          OR xxtc.default_value      IS NOT NULL
                         )
               AND       xstc.xfm_table_id        = xxtc.xfm_table_id
               AND       xstc.xfm_table_column_id = xxtc.xfm_table_column_id
               ORDER BY  xxtc.xfm_column_seq;
               --
          --** END CURSOR ColumnsToUpdate_cur;
          --
          /*CURSOR TransformError_cur
                      (
                       pt_TransformErrorTbl            TransformError_tt
                      )
          IS
               --
               SELECT    rowid_seq
                        ,column_seq
                        ,column_and_error_code
               FROM      TABLE(pt_TransformErrorTbl)
               WHERE     1 = 1
               ORDER BY  rowid_seq
                        ,column_seq;*/
               --
          --** END CURSOR TransformError_cur
          --
          --******************************
          --** Dynamic Cursor Declarations
          --******************************
          --
          XFMColumnData_cur                         RefCursor_t;
          --
          --
          --**********************
          --** Record Declarations
          --**********************
          --
          --
          --***************************
          --** PLSQL Table Declarations
          --***************************
          --

          TYPE TransformError_typ IS RECORD
                 (
                  rowid_seq                     VARCHAR2(200)
                 ,column_seq                    NUMBER
                 ,column_and_error_code         VARCHAR2(240)
                 );

          TYPE TransformError_tb IS TABLE OF TransformError_typ INDEX BY BINARY_INTEGER;
          TransformError_tbl                TransformError_tb;
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'transform_data';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_ApplicationSuite             xxmx_migration_metadata.application_suite%TYPE;
          vt_Application                  xxmx_migration_metadata.application%TYPE;
          vn_TransformCount               NUMBER;
          vn_EnrichmentCount              NUMBER;
          vn_TotalDataRowsCount           NUMBER;
          vn_ProcessedRowsCount           NUMBER;
          vn_SourceReplacedCount          NUMBER;
          vn_TransformFailCount           NUMBER;
          vn_TransformSuccessCount        NUMBER;
          vn_NullDefaultedCount           NUMBER;
          vn_EnrichedCount                NUMBER;
          vb_TransformErrors              BOOLEAN;
          vn_RowSeq                       NUMBER;
          vn_Rowid                        VARCHAR2(200);
          vn_PreviousRowSeq               NUMBER;
          vt_SourceOperatingUnitName      xxmx_simple_transforms.source_operating_unit_name%TYPE;
          vt_SourceValue                  xxmx_simple_transforms.source_value%TYPE;
          vt_NewValue                     xxmx_simple_transforms.fusion_value%TYPE;
          vv_NewStatus                    VARCHAR2(50);
          vi_TransformErrorIdx            PLS_INTEGER;
          vv_ErroredColumnList            xxmx_data_messages.data_message%TYPE;
          vt_DataMessage                  xxmx_data_messages.data_message%TYPE;
          vv_IDLabel                      VARCHAR2(100);
          vv_IDCondition                  VARCHAR2(100);
          ct_Phase                        xxmx_module_messages.phase%TYPE              := 'TRANSFORM';
          vt_update_flag                  VARCHAR2(10);
          --
          --*************************
          --** Exception Declarations
          --*************************
          --
          e_ModuleError                   EXCEPTION;
          --
     --** END Declarations **
     --
     BEGIN
          --
          gvt_Phase := ct_Phase;
          --
          gvv_ProgressIndicator := '0010';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application     
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_FileSetID         => pt_i_FileSetID
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||' ('
                                        ||pt_i_BusinessEntity
                                        ||' / '
                                        ||pt_i_SubEntity
                                        ||') initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          gvv_ProgressIndicator := '0050';
          --
          IF   pt_i_StgPopulationMethod = 'DATA_FILE'
          THEN
               --
               vv_IDLabel := 'File Set ID "'
                           ||pt_i_FileSetID
                           ||'"';
               --
               --vv_IDCondition := 'file_set_id = :1 ';
               vv_IDCondition := 'migration_set_id = :1 ';
               --
               xxmx_utilities_pkg.upd_file_migration_details
                    (
                     pt_i_ApplicationSuite         => pt_i_ApplicationSuite
                    ,pt_i_Application              => pt_i_Application     
                    ,pt_i_FileSetID                => pt_i_FileSetID
                    ,pt_i_BusinessEntity           => pt_i_BusinessEntity
                    ,pt_i_SubEntity                => pt_i_SubEntity 
                    ,pt_i_Phase                    => gvt_Phase
                    ,pt_i_ValidateEndTimestamp     => NULL
                    ,pt_i_ValidateRowCount         => NULL
                    ,pt_i_TransformStartTimestamp => LOCALTIMESTAMP
                    ,pt_i_TransformEndTimestamp   => NULL
                    ,pt_i_ExportFileName          => NULL
                    ,pt_i_ExportStartTimestamp    => NULL
                    ,pt_i_ExportEndTimestamp      => NULL
                    ,pt_i_ExportRowCount          => NULL
                    ,pt_i_ErrorFlag               => NULL
                    );
               --
          ELSE
               --
               vv_IDLabel := 'Migration Set ID "'
                           ||pt_i_MigrationSetID
                           ||'"';
               --
               vv_IDCondition := 'migration_set_id = :1 ';
               --
               xxmx_utilities_pkg.upd_ext_migration_details
                    (
                     pt_i_MigrationSetID          => pt_i_MigrationSetID
                    ,pt_i_Application             => pt_i_Application
                    ,pt_i_ApplicationSuite        => pt_i_ApplicationSuite
                    ,pt_i_BusinessEntity          => pt_i_BusinessEntity
                    ,pt_i_SubEntity               => pt_i_SubEntity     
                    ,pt_i_Phase                   => gvt_Phase
                    ,pt_i_FileSetID               => NULL
                    ,pt_i_ExtractEndTimestamp     => NULL
                    ,pt_i_ExtractRowCount         => NULL
                    ,pt_i_TransformStartTimestamp => LOCALTIMESTAMP
                    ,pt_i_TransformEndTimestamp   => NULL
                    ,pt_i_ExportFileName          => NULL
                    ,pt_i_ExportStartTimestamp    => NULL
                    ,pt_i_ExportEndTimestamp      => NULL
                    ,pt_i_ExportRowCount          => NULL
                    ,pt_i_ErrorFlag               => NULL
                    );
               --
          END IF;
          --
          /*
          ** Identify STG and XFM tables from Business entity and Sub-entity parameters.
          */
          --
          gvv_ProgressIndicator := '0020';
          --
          FOR  TransformMetadata_rec
          IN   TransformMetadata_cur
                    (
                     pt_i_BusinessEntity
                    ,pt_i_SubEntity     
                    )
          LOOP
               --
               gvv_ProgressIndicator := '0050';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => pt_i_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Evaluatng Data Dictionary for XFM table "'
                                             ||TransformMetadata_rec.xfm_schema_name
                                             ||'.'
                                             ||TransformMetadata_rec.xfm_table_name
                                             ||'" to determine if Transform/Data Enrichment is required.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               gvv_ProgressIndicator := '0060';
               --
               /*
               ** Count the number of Transformations required for the XFM table (determined from the XXMX_XFM_TABLE_COLUMNS table).
               */
               --
               SELECT    COUNT(1)
               INTO      vn_TransformCount
               FROM      xxmx_xfm_table_columns   xxtc
               WHERE     1 = 1
               AND       xxtc.xfm_table_id    = TransformMetadata_rec.xfm_table_id
               AND       xxtc.transform_code IS NOT NULL;
               --
               /*
               ** Count the number of Data Enrichments required for the XFM table (determined from the XXMX_XFM_TABLE_COLUMNS table).
               */
               --
               gvv_ProgressIndicator := '0070';
               --
               SELECT    COUNT(1)
               INTO      vn_EnrichmentCount
               FROM      xxmx_xfm_table_columns   xxtc
               WHERE     1 = 1
               AND       xxtc.xfm_table_id    = TransformMetadata_rec.xfm_table_id
               AND       xxtc.default_value  IS NOT NULL;
               --
               /*
               ** Count the number of Data Rows in the XFM table for the current Migration Set ID (used for procedure messaging).
               */
               --
               gvv_ProgressIndicator := '0080';
               --
               IF   pt_i_StgPopulationMethod = 'DATA_FILE'
               THEN
                    --
                    vn_TotalDataRowsCount := get_row_count
                                                  (
                                                   pt_i_SchemaName             => TransformMetadata_rec.xfm_schema_name
                                                  ,pt_i_TableName              => TransformMetadata_rec.xfm_table_name
                                                  ,pt_i_FileSetID              => pt_i_FileSetID
                                                  ,pv_i_OptionalJoinCondition1 => NULL
                                                  ,pv_i_OptionalJoinCondition2 => NULL
                                                  ,pv_i_OptionalJoinCondition3 => NULL
                                                  ,pv_i_OptionalJoinCondition4 => NULL
                                                  ,pv_i_OptionalJoinCondition5 => NULL
                                                  );
                    --
               ELSE /* pt_i_StgPopulationMethod = 'DB_LINK' */
                    --
                    vn_TotalDataRowsCount := get_row_count
                                                  (
                                                   pt_i_SchemaName             => TransformMetadata_rec.xfm_schema_name
                                                  ,pt_i_TableName              => TransformMetadata_rec.xfm_table_name
                                                  ,pt_i_MigrationSetID         => pt_i_MigrationSetID
                                                  ,pv_i_OptionalJoinCondition1 => NULL
                                                  ,pv_i_OptionalJoinCondition2 => NULL
                                                  ,pv_i_OptionalJoinCondition3 => NULL
                                                  ,pv_i_OptionalJoinCondition4 => NULL
                                                  ,pv_i_OptionalJoinCondition5 => NULL
                                                  );
                    --
               END IF; --** IF pt_i_StgPopulationMethod = 'DATA_FILE'
               --
               /*
               ** Evaluate the requirements and perform the transforms and data enrichments.
               */
               --
               gvv_ProgressIndicator := '0090';
               --
               IF   vn_TransformCount  = 0
               AND  vn_EnrichmentCount = 0
               THEN
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '  - There are no Transforms or Data Enrichment (Default Values) registered for this table.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
               ELSE
                    --
                    /*
                    ** Perform Data Transformations utilising single-row, single-column
                    ** Dynamic SQL update statements (it has to be performed this was
                    ** to capture transformation errors at the individual row/column level.
                    **
                    ** The vb_TransformErrors boolean variable is used to identify if there
                    ** are ANY transform errors for the current XFM Table and Migration Set ID.
                    **
                    ** This variable is used to trigger the recording of error messages to be
                    ** written to the XXMX_DATA_MESSAGES table.
                    */
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '  - Performing Simple Transforms '
                                                  ||'and/or Data Enrichment (Default Values) on Client Data '
                                                  ||'in this table for '
                                                  ||vv_IDLabel
                                                  ||'.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    vb_TransformErrors    := FALSE;
                    vi_TransformErrorIdx  := 0;
                    --
                    FOR ColumnToUpdate_rec
                    IN  ColumnsToUpdate_cur
                             (
                              TransformMetadata_rec.xfm_table_id
                             )
                    LOOP
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                              ,pt_i_Application       => pt_i_Application     
                              ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                              ,pt_i_SubEntity         => pt_i_SubEntity
                              ,pt_i_FileSetID         => pt_i_FileSetID
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => gvt_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '    - Processing column "'
                                                       ||ColumnToUpdate_rec.xfm_column_name
                                                       ||'".'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         IF   ColumnToUpdate_rec.transform_code IS NOT NULL
                         AND  ColumnToUpdate_rec.default_value  IS NOT NULL
                         THEN
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                   ,pt_i_Application       => pt_i_Application     
                                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                   ,pt_i_SubEntity         => pt_i_SubEntity
                                   ,pt_i_FileSetID         => pt_i_FileSetID
                                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   ,pt_i_Phase             => gvt_Phase
                                   ,pt_i_Severity          => 'NOTIFICATION'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '      - Column has both Data Transformation and Data Enrichment defined.'
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                   ,pt_i_Application       => pt_i_Application     
                                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                   ,pt_i_SubEntity         => pt_i_SubEntity
                                   ,pt_i_FileSetID         => pt_i_FileSetID
                                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   ,pt_i_Phase             => gvt_Phase
                                   ,pt_i_Severity          => 'NOTIFICATION'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '        - Data rows with a NULL column value will be assigned the value of "'
                                                            ||ColumnToUpdate_rec.default_value
                                                            ||'" (Data Enrichment).'
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                   ,pt_i_Application       => pt_i_Application     
                                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                   ,pt_i_SubEntity         => pt_i_SubEntity
                                   ,pt_i_FileSetID         => pt_i_FileSetID
                                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   ,pt_i_Phase             => gvt_Phase
                                   ,pt_i_Severity          => 'NOTIFICATION'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '        - Data Rows with a Source Value will be transformed based on TRANSFORM_CODE: "'
                                                            ||ColumnToUpdate_rec.transform_code
                                                            ||'" (Data Transformation).'
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                              IF   ColumnToUpdate_rec.default_on_transform_fail = 'Y'
                              THEN
                                   --
                                   xxmx_utilities_pkg.log_module_message
                                        (
                                         pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                        ,pt_i_Application       => pt_i_Application     
                                        ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                        ,pt_i_SubEntity         => pt_i_SubEntity
                                        ,pt_i_FileSetID         => pt_i_FileSetID
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                        ,pt_i_Phase             => gvt_Phase
                                        ,pt_i_Severity          => 'NOTIFICATION'
                                        ,pt_i_PackageName       => gct_PackageName
                                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage     => '          - Data Rows which fail transformation will be assigned the default value.'
                                        ,pt_i_OracleError       => NULL
                                        );
                                   --
                              ELSE
                                   --
                                   xxmx_utilities_pkg.log_module_message
                                        (
                                         pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                        ,pt_i_Application       => pt_i_Application     
                                        ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                        ,pt_i_SubEntity         => pt_i_SubEntity
                                        ,pt_i_FileSetID         => pt_i_FileSetID
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                        ,pt_i_Phase             => gvt_Phase
                                        ,pt_i_Severity          => 'NOTIFICATION'
                                        ,pt_i_PackageName       => gct_PackageName
                                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage     => '          - Data Rows which fail transformation will NOT be '
                                                                 ||'assigned the default value and will retain their original value.'
                                        ,pt_i_OracleError       => NULL
                                        );
                                   --
                              END IF; --** IF ColumnToUpdate_rec.default_on_transform_fail = 'Y'
                              --
                         ELSIF ColumnToUpdate_rec.transform_code IS NOT NULL
                         THEN
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                   ,pt_i_Application       => pt_i_Application     
                                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                   ,pt_i_SubEntity         => pt_i_SubEntity
                                   ,pt_i_FileSetID         => pt_i_FileSetID
                                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   ,pt_i_Phase             => gvt_Phase
                                   ,pt_i_Severity          => 'NOTIFICATION'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '      - Column has only Data Transformation defined.'
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                   ,pt_i_Application       => pt_i_Application     
                                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                   ,pt_i_SubEntity         => pt_i_SubEntity
                                   ,pt_i_FileSetID         => pt_i_FileSetID
                                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   ,pt_i_Phase             => gvt_Phase
                                   ,pt_i_Severity          => 'NOTIFICATION'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '        - Data Rows with a Source Value will be transformed based on TRANSFORM_CODE "'
                                                            ||ColumnToUpdate_rec.transform_code
                                                            ||'" (Data Transformation).'
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                   ,pt_i_Application       => pt_i_Application     
                                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                   ,pt_i_SubEntity         => pt_i_SubEntity
                                   ,pt_i_FileSetID         => pt_i_FileSetID
                                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   ,pt_i_Phase             => gvt_Phase
                                   ,pt_i_Severity          => 'NOTIFICATION'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '          - Data Rows which fail transformation will retain their original value.'
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                   ,pt_i_Application       => pt_i_Application     
                                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                   ,pt_i_SubEntity         => pt_i_SubEntity
                                   ,pt_i_FileSetID         => pt_i_FileSetID
                                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   ,pt_i_Phase             => gvt_Phase
                                   ,pt_i_Severity          => 'NOTIFICATION'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '        - Data Rows with a NULL column value will not be defaulted.'
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                         ELSE
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                   ,pt_i_Application       => pt_i_Application     
                                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                   ,pt_i_SubEntity         => pt_i_SubEntity
                                   ,pt_i_FileSetID         => pt_i_FileSetID
                                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   ,pt_i_Phase             => gvt_Phase
                                   ,pt_i_Severity          => 'NOTIFICATION'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '      - Column has only Data Enrichment defined.'
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                              IF   ColumnToUpdate_rec.default_overrides_source_val = 'N'
                              THEN
                                   --
                                   xxmx_utilities_pkg.log_module_message
                                        (
                                         pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                        ,pt_i_Application       => pt_i_Application     
                                        ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                        ,pt_i_SubEntity         => pt_i_SubEntity
                                        ,pt_i_FileSetID         => pt_i_FileSetID
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                        ,pt_i_Phase             => gvt_Phase
                                        ,pt_i_Severity          => 'NOTIFICATION'
                                        ,pt_i_PackageName       => gct_PackageName
                                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage     => '        - Only Data Rows with a NULL column value will be defaulted.'
                                        ,pt_i_OracleError       => NULL
                                        );
                                   --
                              ELSE
                                   --
                                   xxmx_utilities_pkg.log_module_message
                                        (
                                         pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                        ,pt_i_Application       => pt_i_Application     
                                        ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                        ,pt_i_SubEntity         => pt_i_SubEntity
                                        ,pt_i_FileSetID         => pt_i_FileSetID
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                        ,pt_i_Phase             => gvt_Phase
                                        ,pt_i_Severity          => 'NOTIFICATION'
                                        ,pt_i_PackageName       => gct_PackageName
                                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage     => '        - All Data Rows will be defaulted (Source Values will be replaced).'
                                        ,pt_i_OracleError       => NULL
                                        );
                                   --
                              END IF;
                              --
                         END IF; --** IF ColumnToUpdate_rec.transform_code IS NOT NULL AND ColumnToUpdate_rec.default_value  IS NOT NULL
                         --
                         /*
                         ** Build SQL Cursor to LOOP through existing values from the XFM table for the column
                         ** that has Data Transformation or Enrichment defined for it.
                         **
                         ** The scope of the rows retrieved is controlled by the variable WHERE clause dependant
                         ** on whether the columns has Data Enrichment or Transformation or both to be performed.
                         **
                         ** We also only want to process rows that have not been transformed previously (and therefore
                         ** still have a status of "PRE-TRANSFORM".
                         **
                         ** If values are enriched or transformed incorrectly due to incorrect setup then the XFM_MAIN
                         ** procedure should be executed again once the setup has been corrected.  This will ensure that
                         ** the data in the XFM table is deleted and then re-populated from the STG table (by the
                         ** TRANSFER_STG_DATA procedure) before attempting enrichment and transformation again.
                         */
                         --
                         gvv_SQLAction1          := 'SELECT';
                         --
                         -- Changed by Pallavi - Performance
                         gvv_SQLSelectColumnList := 'distinct '--'rowid'
                                                 -- ||' ,xfm.source_operating_unit_name'
                                                  --||' ,'
                                                  ||ColumnToUpdate_rec.xfm_column_name;

                         --
                         gvv_SQLTableClause      := 'FROM '
                                                  ||TransformMetadata_rec.xfm_schema_name
                                                  ||'.'
                                                  ||TransformMetadata_rec.xfm_table_name
                                                  ||' xfm';
                         --
                         IF   ColumnToUpdate_rec.transform_code IS NOT NULL
                         AND  ColumnToUpdate_rec.default_value  IS NOT NULL
                         THEN
                              --
                              /*
                              ** As there is both Transform and Data Enrichment defined for this column we potentially
                              ** need to update every Data Row because of the default value.
                              */
                              --
                              gvv_SQLWhereClause := 'WHERE 1 = 1 '
                                                  ||'AND xfm.'
                                                  ||vv_IDCondition
                                                  ||'AND xfm.migration_status = ''PRE-TRANSFORM'' ';
                              --
                         ELSIF ColumnToUpdate_rec.transform_code IS NOT NULL
                         THEN
                              --
                              /*
                              ** As there is only Data Transform defined for this column we only need to retrieve
                              ** the Data Rows with a Source Value.
                              */
                              --
                              gvv_SQLWhereClause := 'WHERE 1 = 1 '
                                                  ||'AND xfm.'
                                                  ||vv_IDCondition
                                                  ||'AND xfm.migration_status =''PRE-TRANSFORM'' '
                                                  ||'AND xfm.'
                                                  ||ColumnToUpdate_rec.xfm_column_name
                                                  ||' IS NOT NULL';                     -- Cannot transform where client data is NULL
                              --
                         ELSE
                              --
                              /*
                              ** As there is only Data Enrichment defined for this column, if default_overrides_source_val = 'N'
                              ** then we only need to retrieve the Data Rows with a NULL Source Value otherwise we are assigning
                              ** the Default Value to every row (replacing any Source Values).
                              */
                              --
                              IF   NVL(ColumnToUpdate_rec.default_overrides_source_val,'N') = 'N'
                              THEN
                                   --
                                   gvv_SQLWhereClause := 'WHERE 1 = 1 '
                                                       ||'AND xfm.'
                                                       ||vv_IDCondition
                                                       ||'AND xfm.migration_status = ''PRE-TRANSFORM'' '
                                                       ||'AND xfm.'
                                                       ||ColumnToUpdate_rec.xfm_column_name
                                                       ||' IS NULL';                        -- Only retrieve rows with a missing Source Value
                                   --
                              ELSE
                                   --
                                   gvv_SQLWhereClause := 'WHERE 1 = 1 '
                                                       ||'AND xfm.'
                                                       ||vv_IDCondition
                                                       ||'AND xfm.migration_status = ''PRE-TRANSFORM'' ';
                                   --
                              END IF;
                              --
                         END IF;
                         --
                         /*
                         ** Construct the reference cursor to retrieve the Client Data values
                         ** for the single XFM table column.
                         */
                         --
                         gvc_SQLStatement := gvv_SQLAction1
                                           ||gcv_SQLSpace
                                           ||gvv_SQLSelectColumnList
                                           ||gcv_SQLSpace
                                           ||gvv_SQLTableClause
                                           ||gcv_SQLSpace
                                           ||gvv_SQLWhereClause;
                         --
                         /*INSERT
                         INTO   isv_temp
                                     (
                                      sql_statement
                                     )
                         VALUES      (
                                      gvc_SQLStatement
                                     );

                         COMMIT;*/

                         xxmx_utilities_pkg.log_module_message
                                        (
                                         pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                        ,pt_i_Application       => pt_i_Application     
                                        ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                        ,pt_i_SubEntity         => pt_i_SubEntity
                                        ,pt_i_FileSetID         => pt_i_FileSetID
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                        ,pt_i_Phase             => gvt_Phase
                                        ,pt_i_Severity          => 'NOTIFICATION'
                                        ,pt_i_PackageName       => gct_PackageName
                                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage     => substr('GVC_SQLSTATEMENT CREATED:'|| gvc_SQLStatement,1,4000)
                                        ,pt_i_OracleError       => NULL
                                        );
                         --
                         vn_ProcessedRowsCount    := 0;
                         vn_SourceReplacedCount   := 0;
                         vn_TransformFailCount    := 0;
                         vn_TransformSuccessCount := 0;
                         vn_NullDefaultedCount    := 0;
                         vn_EnrichedCount         := 0;
                         --
                         OPEN  XFMColumnData_cur
                         FOR   gvc_SQLStatement
                         USING pt_i_MigrationSetID;
                         --
                         LOOP
                            vt_update_flag :=NULL;
                              --
                              FETCH  XFMColumnData_cur
                              INTO  --vn_Rowid
                                    --,vt_SourceOperatingUnitName
                                    vt_SourceValue;
                              --
                              EXIT WHEN XFMColumnData_cur%NOTFOUND;
                              --
                              vn_ProcessedRowsCount := vn_ProcessedRowsCount + 1;
                              --
                              vt_NewValue  := NULL;
                              vv_NewStatus := NULL;

                              gvv_ProgressIndicator:= '0092';
                              xxmx_utilities_pkg.log_module_message
                                        (
                                         pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                        ,pt_i_Application       => pt_i_Application     
                                        ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                        ,pt_i_SubEntity         => pt_i_SubEntity
                                        ,pt_i_FileSetID         => pt_i_FileSetID
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                        ,pt_i_Phase             => gvt_Phase
                                        ,pt_i_Severity          => 'NOTIFICATION'
                                        ,pt_i_PackageName       => gct_PackageName
                                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage     => 'After Cursor Call XFMColumnData_cur:'
                                                                  || vt_SourceValue
                                                                  ||' '|| ColumnToUpdate_rec.transform_code
                                                                  ||' '|| ColumnToUpdate_rec.default_value 
                                        ,pt_i_OracleError       => NULL
                                        );
                              --
                              IF   ColumnToUpdate_rec.transform_code IS NOT NULL
                              AND   ColumnToUpdate_rec.default_value  IS NOT NULL
                              THEN
                                   --
                                   /*
                                   ** As there is both Transform and Data Enrichment defined for this column the
                                   ** Client Data Cursor (XFMColumnData_cur) should be retrieving all rows for
                                   ** the specifiedMigration Set ID.  Any single Data Row could have a Source
                                   ** Value or a NULL value.
                                   **
                                   ** a) If the Source Value IS NOT NULL then attempt to transform it.
                                   **
                                   **    i) If the transform fails, then the Source Value will be retained unless
                                   **       default_on_transform_fail = 'Y' in which case the Source Value will
                                   **       be replaced by the Default Value.
                                   **
                                   ** b) If the Source Value IS NULL simply assign the Default Value;
                                   */
                                   --
                                   IF   vt_SourceValue IS NOT NULL
                                   THEN
                                        --
                                        /*
                                        ** Call Simple Transform Procedure (in "TRANSFORM" mode)
                                        */
                                        --
                                        gvv_ReturnStatus  := NULL;
                                        gvv_ReturnCode    := NULL;
                                        gvt_ReturnMessage := NULL;
                                        --
                                        gvv_ProgressIndicator:= '0093';
                                       xxmx_utilities_pkg.log_module_message
                                        (
                                         pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                        ,pt_i_Application       => pt_i_Application     
                                        ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                        ,pt_i_SubEntity         => pt_i_SubEntity
                                        ,pt_i_FileSetID         => pt_i_FileSetID
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                        ,pt_i_Phase             => gvt_Phase
                                        ,pt_i_Severity          => 'NOTIFICATION'
                                        ,pt_i_PackageName       => gct_PackageName
                                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage     => 'Call evaluate_transform  '
                                        ,pt_i_OracleError       => NULL
                                        );

                                        xxmx_utilities_pkg.evaluate_transform
                                             (
                                              pt_i_ApplicationSuite        => pt_i_ApplicationSuite
                                             ,pt_i_Application             => pt_i_Application     
                                             ,pt_i_SourceOperatingUnitName => vt_SourceOperatingUnitName
                                             ,pt_i_TransformCode           => ColumnToUpdate_rec.transform_code
                                             ,pt_i_SourceValue             => vt_SourceValue
                                             ,pt_i_EvaluationMode          => 'TRANSFORM'
                                             ,pt_o_FusionValue             => vt_NewValue
                                             ,pv_o_ReturnStatus            => gvv_ReturnStatus
                                             ,pv_o_ReturnCode              => gvv_ReturnCode
                                             ,pv_o_ReturnMessage           => gvt_ReturnMessage
                                             );


                                       gvv_ProgressIndicator:= '0094';
                                       xxmx_utilities_pkg.log_module_message
                                        (
                                         pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                        ,pt_i_Application       => pt_i_Application     
                                        ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                        ,pt_i_SubEntity         => pt_i_SubEntity
                                        ,pt_i_FileSetID         => pt_i_FileSetID
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                        ,pt_i_Phase             => gvt_Phase
                                        ,pt_i_Severity          => 'NOTIFICATION'
                                        ,pt_i_PackageName       => gct_PackageName
                                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage     => 'After evaluate_transform  '|| gvv_ReturnStatus
                                        ,pt_i_OracleError       => NULL
                                        );
                                        --
                                        IF   gvv_ReturnStatus <> 'S'
                                        THEN
                                             --
                                             /*
                                             ** The transformation failed, so set the new value to the Default Value if
                                             ** default_on_transform_fail = 'Y' else add the Column Name to the list of columns
                                             ** which failed transformation.
                                             **
                                             ** As the replacement of Source Value with Default Value in case of failed transformation
                                             ** requires a conscious decision to be made by the user, it is not treated as an error.
                                             */
                                             --
                                             IF   ColumnToUpdate_rec.default_on_transform_fail = 'Y'
                                             THEN
                                                  --
                                                  vt_NewValue  := ColumnToUpdate_rec.default_value;
                                                  vv_NewStatus := 'ENRICHED_ON_TRANSFORM_FAIL';
                                                  --
                                                  vn_SourceReplacedCount := vn_SourceReplacedCount + 1;
                                                  --
                                             ELSE
                                                  --
                                                  /*
                                                  ** Set New Value to NULL but we still update the row for the TRANSFORM_STATUS.
                                                  */
                                                  --
                                                  vt_NewValue  := NULL;
                                                  vv_NewStatus := 'TRANSFORM_ERROR';
                                                  --
                                                  /*
                                                  ** As we cannot default the value after Transform Fail, we must
                                                  ** insert the name of the column that failed to transform
                                                  ** and the data row identifier into the Transform Error PL/SQL table.
                                                  */
                                                  --
                                                  vb_TransformErrors   := TRUE;
                                                  vi_TransformErrorIdx := vi_TransformErrorIdx + 1;
                                                  --
                                                  TransformError_tbl(vi_TransformErrorIdx).rowid_seq               := vn_Rowid;
                                                  TransformError_tbl(vi_TransformErrorIdx).column_seq            := ColumnToUpdate_rec.xfm_column_seq;
                                                  TransformError_tbl(vi_TransformErrorIdx).column_and_error_code := ColumnToUpdate_rec.xfm_column_name
                                                                                                                  ||'['
                                                                                                                  ||gvv_ReturnCode
                                                                                                                  ||']';
                                                  --
                                                  vn_TransformFailCount := vn_TransformFailCount + 1;
                                                  --
                                             END IF; --** IF ColumnToUpdate_rec.default_on_transform_fail = 'Y'
                                             --
                                        ELSE
                                             --
                                             vv_NewStatus             := 'TRANSFORMED';
                                             vt_update_flag:= 'Y';
                                             vn_TransformSuccessCount := vn_TransformSuccessCount + 1;
                                             --
                                        END IF; --** IF gvv_ReturnStatus <> 'S'
                                        --
                                   ELSE
                                        --
                                        /*
                                        ** As the Source Value is NULL, we assign the Default Value.
                                        */
                                        --
                                        vt_NewValue  := ColumnToUpdate_rec.default_value;
                                        vv_NewStatus := 'ENRICHED';
                                        vt_update_flag:= 'Y';
                                        --
                                        vn_NullDefaultedCount := vn_NullDefaultedCount + 1;
                                        --
                                   END IF; --** IF vt_SourceValue IS NOT NULL
                                   --
                              ELSIF ColumnToUpdate_rec.transform_code IS NOT NULL
                              AND   ColumnToUpdate_rec.default_value  IS NULL
                              THEN
                                   --
                                   /*
                                   ** We have a Transform Code only, so the Client Data Cursor (XFMColumnData_cur)
                                   ** should only be retrieving rows with a transformable value (Column to be
                                   ** transformed IS NOT NULL).
                                   */
                                   --
                                   /*
                                   ** Call Simple Transform Procedure (in "TRANSFORM" mode)
                                   */
                                   --
                                   gvv_ReturnStatus  := NULL;
                                   gvv_ReturnCode    := NULL;
                                   gvt_ReturnMessage := NULL;

                                   gvv_ProgressIndicator:= '0093a';
                                       xxmx_utilities_pkg.log_module_message
                                        (
                                         pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                        ,pt_i_Application       => pt_i_Application     
                                        ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                        ,pt_i_SubEntity         => pt_i_SubEntity
                                        ,pt_i_FileSetID         => pt_i_FileSetID
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                        ,pt_i_Phase             => gvt_Phase
                                        ,pt_i_Severity          => 'NOTIFICATION'
                                        ,pt_i_PackageName       => gct_PackageName
                                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage     => 'Call evaluate_transform  '
                                        ,pt_i_OracleError       => NULL
                                        );
                                   --
                                   xxmx_utilities_pkg.evaluate_transform
                                        (
                                         pt_i_ApplicationSuite        => pt_i_ApplicationSuite
                                        ,pt_i_Application             => pt_i_Application     
                                        ,pt_i_SourceOperatingUnitName => vt_SourceOperatingUnitName
                                        ,pt_i_TransformCode           => ColumnToUpdate_rec.transform_code
                                        ,pt_i_SourceValue             => vt_SourceValue
                                        ,pt_i_EvaluationMode          => 'TRANSFORM'
                                        ,pt_o_FusionValue             => vt_NewValue
                                        ,pv_o_ReturnStatus            => gvv_ReturnStatus
                                        ,pv_o_ReturnCode              => gvv_ReturnCode
                                        ,pv_o_ReturnMessage           => gvt_ReturnMessage
                                        );

                                     gvv_ProgressIndicator:= '0094a';
                                       xxmx_utilities_pkg.log_module_message
                                        (
                                         pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                        ,pt_i_Application       => pt_i_Application     
                                        ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                        ,pt_i_SubEntity         => pt_i_SubEntity
                                        ,pt_i_FileSetID         => pt_i_FileSetID
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                        ,pt_i_Phase             => gvt_Phase
                                        ,pt_i_Severity          => 'NOTIFICATION'
                                        ,pt_i_PackageName       => gct_PackageName
                                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage     => 'After evaluate_transform  '|| gvv_ReturnStatus
                                        ,pt_i_OracleError       => NULL
                                        );
                                   --
                                   /*
                                   ** If the transformation failed, add the Column Name to the list of columns
                                   ** which failed transformation.
                                   */
                                   --
                                   IF   gvv_ReturnStatus <> 'S'
                                   THEN
                                        --
                                        /*
                                        ** Set New Value to NULL but we still update the row for the TRANSFORM_STATUS.
                                        */
                                        --
                                        vt_NewValue  := NULL;
                                        vv_NewStatus := 'TRANSFORM_ERROR';
                                        --
                                        /*
                                        ** Insert the name of the column that failed to transform
                                        ** and the data row identifier into the Transform Error PL/SQL table.
                                        */
                                        --
                                        vb_TransformErrors   := TRUE;
                                        vi_TransformErrorIdx := vi_TransformErrorIdx + 1;
                                        --
                                       -- TransformError_tbl(vi_TransformErrorIdx).rowid_seq               := vn_Rowid;
                                        TransformError_tbl(vi_TransformErrorIdx).column_seq            := ColumnToUpdate_rec.xfm_column_seq;
                                        TransformError_tbl(vi_TransformErrorIdx).column_and_error_code := ColumnToUpdate_rec.xfm_column_name
                                                                                                        ||'['
                                                                                                        ||gvv_ReturnCode
                                                                                                        ||']';
                                        --
                                        vn_TransformFailCount := vn_TransformFailCount + 1;
                                        --
                                   ELSE
                                        --
                                        gvv_ProgressIndicator:= '0094b';
                                        vv_NewStatus             := 'TRANSFORMED';
                                        vt_update_flag:= 'Y';
                                        vn_TransformSuccessCount := vn_TransformSuccessCount + 1;
                                        --
                                   END IF; --** IF gvv_ReturnStatus <> 'S'
                                   --
                              ELSIF(ColumnToUpdate_rec.transform_code IS NULL
                              AND   ColumnToUpdate_rec.default_value  IS NOT NULL)
                              THEN
                                   --
                                   /*
                                   ** We have a Default Value only.
                                   **
                                   ** If default_overrides_source_val = 'N', the Client Data Cursor
                                   ** (XFMColumnData_cur) should only be retrieving rows with a NULL
                                   ** value.
                                   **
                                   ** If default_overrides_source_val = 'Y', the Client Data Cursor
                                   ** (XFMColumnData_cur) will retrieve all rows for the Migration Set ID
                                   ** resulting in all rows being assigned with the Default Value
                                   ** (any Source Values will be replaced).
                                   */
                                   --
                                   vn_EnrichedCount := vn_EnrichedCount + 1;
                                   --
                                   vt_NewValue  := ColumnToUpdate_rec.default_value;
                                   gvv_ProgressIndicator:= '0094c';
                                   vt_update_flag:= 'Y';
                                   vv_NewStatus := 'ENRICHED';
                                   --
                              END IF; --** IF ColumnToUpdate_rec.transform_code IS NOT NULL AND ColumnToUpdate_rec.default_value IS NOT NULL
                              --
                              /*
                              ** Construct UPDATE statement to update current row of the XFM table
                              ** (identified by MIGRATION_SET_ID and rowid_seq) with the new value
                              ** and / or new status.
                              */
                              --escape quotes for fusion_value
                             IF( INSTR(vt_NewValue ,'''',1) >0) 
                             THEN

                                vt_NewValue := REPLACE(vt_NewValue ,'''',''''''); 

                             END IF;
                              --
                              gvv_SQLAction1          := 'UPDATE';
                              --
                              gvv_SQLTableClause      := TransformMetadata_rec.xfm_schema_name
                                                       ||'.'
                                                       ||TransformMetadata_rec.xfm_table_name
                                                       ||' xfm';
                              --
                              -- Changed by Pallavi - Performance
                             IF( vt_NewValue = '#NULL') THEN 
                                gvv_SQLUpdateColumnList := 'SET xfm.'
                                                       ||ColumnToUpdate_rec.xfm_column_name
                                                       ||' = ' ||'NULL';
                                                       --||', xfm.migration_status = '''
                                                       --||vv_NewStatus
                                                       --||'''';
                             ELSE 
                                gvv_SQLUpdateColumnList := 'SET xfm.'
                                                       ||ColumnToUpdate_rec.xfm_column_name
                                                       ||' = '''
                                                       ||vt_NewValue
                                                       ||'''';
                                                       --||', xfm.migration_status = '''
                                                       --||vv_NewStatus
                                                       --||'''';
                             END IF; 
                              --
                             IF(vt_SourceValue IS NOT NULL) 
                             THEN
                              --
                                  gvv_SQLWhereClause      := 'WHERE 1 = 1 '
                                                           ||'AND xfm.'
                                                           ||vv_IDCondition
                                                           ||' AND xfm.'
                                                           ||ColumnToUpdate_rec.xfm_column_name
                                                           ||' = '''
                                                           ||vt_SourceValue
                                                           ||'''';                                                       
                                                           --||'AND xfm.rowid = :2 '; --Changes 6th Aug
                             ELSE
                                  gvv_SQLWhereClause      := 'WHERE 1 = 1 '
                                                           ||'AND xfm.'
                                                           ||vv_IDCondition
                                                            ;                                                       
                                                           --||'AND xfm.rowid = :2 '; --Changes 6th Aug
                             END IF;
                             -- Changed by Pallavi - Performance

                              gvc_SQLStatement := gvv_SQLAction1
                                                ||gcv_SQLSpace
                                                ||gvv_SQLTableClause
                                                ||gcv_SQLSpace
                                                ||gvv_SQLUpdateColumnList
                                                ||gcv_SQLSpace
                                                ||gvv_SQLWhereClause;
                              --
                             /* INSERT
                              INTO   isv_temp
                                          (
                                           sql_statement
                                          )
                              VALUES      (
                                           gvc_SQLStatement
                                          );
                              COMMIT;*/
                              --
                              IF   pt_i_StgPopulationMethod = 'DATA_FILE'
                                 AND vt_update_flag = 'Y'
                              THEN
                                   --
                                   EXECUTE IMMEDIATE  gvc_SQLStatement
                                               USING  pt_i_MigrationSetID;
                                                    -- ,vn_Rowid;
                                   -- Changed by Pallavi - Performance

                                    gvv_ProgressIndicator:= '0099';

                                   xxmx_utilities_pkg.log_module_message
                                    (
                                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                    ,pt_i_Application       => pt_i_Application     
                                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                    ,pt_i_SubEntity         => pt_i_SubEntity
                                    ,pt_i_FileSetID         => pt_i_FileSetID
                                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                    ,pt_i_Phase             => gvt_Phase
                                    ,pt_i_Severity          => 'NOTIFICATION'
                                    ,pt_i_PackageName       => gct_PackageName
                                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                    ,pt_i_ModuleMessage     => '    Update the XFM table using Migration_set_id '
                                    ,pt_i_OracleError       => NULL
                                    );

                                   --
                              ELSIF pt_i_StgPopulationMethod = 'DB_LINK' 
                                 AND vt_update_flag = 'Y'
                              THEN
                                   --
                                   EXECUTE IMMEDIATE  gvc_SQLStatement
                                               USING  pt_i_MigrationSetID;
                                                     --,vn_Rowid;
                                   -- Changed by Pallavi - Performance

                                    gvv_ProgressIndicator:= '0100';

                                    xxmx_utilities_pkg.log_module_message
                                    (
                                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                    ,pt_i_Application       => pt_i_Application     
                                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                    ,pt_i_SubEntity         => pt_i_SubEntity
                                    ,pt_i_FileSetID         => pt_i_FileSetID
                                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                    ,pt_i_Phase             => gvt_Phase
                                    ,pt_i_Severity          => 'NOTIFICATION'
                                    ,pt_i_PackageName       => gct_PackageName
                                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                    ,pt_i_ModuleMessage     => '    Update the XFM table using Migration_set_id '
                                    ,pt_i_OracleError       => NULL
                                    );

                                   --

                              END IF; --** IF pt_i_StgPopulationMethod = 'DATA_FILE'
                              --
                         END LOOP; --** END Xfm Table Data (XFMColumnData_cur)Loop
                         --
                         gvv_ProgressIndicator:= '0101';
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                              ,pt_i_Application       => pt_i_Application     
                              ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                              ,pt_i_SubEntity         => pt_i_SubEntity
                              ,pt_i_FileSetID         => pt_i_FileSetID
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => gvt_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '    - Data processing for column "'
                                                       ||ColumnToUpdate_rec.xfm_column_name
                                                       ||'" complete.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                              ,pt_i_Application       => pt_i_Application     
                              ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                              ,pt_i_SubEntity         => pt_i_SubEntity
                              ,pt_i_FileSetID         => pt_i_FileSetID
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => gvt_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '      - '
                                                       ||vn_ProcessedRowsCount
                                                       ||' rows were processed for this column out of '
                                                       ||vn_TotalDataRowsCount
                                                       ||' total data rows for '
                                                       ||vv_IDLabel
                                                       ||'.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         IF   vn_SourceReplacedCount > 0
                         THEN
                              --
                              gvv_ProgressIndicator:= '0102';
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                   ,pt_i_Application       => pt_i_Application     
                                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                   ,pt_i_SubEntity         => pt_i_SubEntity
                                   ,pt_i_FileSetID         => pt_i_FileSetID
                                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   ,pt_i_Phase             => gvt_Phase
                                   ,pt_i_Severity          => 'NOTIFICATION'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '      - '
                                                            ||vn_SourceReplacedCount
                                                            ||' rows had Source Values replaced with the Default Value '
                                                            ||'after transformation failed (both TRANSFORM_CODE and DEFAULT_VALUE '
                                                            ||'are specified for this column).'
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                              --
                         END IF; --** IF vn_SourceReplacedCount > 0
                         --
                         IF   vn_TransformFailCount > 0
                         THEN
                              --
                              gvv_ProgressIndicator:= '0103';
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                   ,pt_i_Application       => pt_i_Application     
                                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                   ,pt_i_SubEntity         => pt_i_SubEntity
                                   ,pt_i_FileSetID         => pt_i_FileSetID
                                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   ,pt_i_Phase             => gvt_Phase
                                   ,pt_i_Severity          => 'NOTIFICATION'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '      - '
                                                            ||vn_TransformFailCount
                                                            ||' rows had Source Values which failed to be transformed '
                                                            ||'(No DEFAULT_VALUE is specified for this column or '
                                                            ||'Default On Failed Transformation is disabled).'
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                         END IF; --** IF vn_TransformFailCount > 0
                         --
                         IF   vn_TransformSuccessCount > 0
                         THEN
                              --
                              gvv_ProgressIndicator:= '0104';
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                   ,pt_i_Application       => pt_i_Application     
                                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                   ,pt_i_SubEntity         => pt_i_SubEntity
                                   ,pt_i_FileSetID         => pt_i_FileSetID
                                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   ,pt_i_Phase             => gvt_Phase
                                   ,pt_i_Severity          => 'NOTIFICATION'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '      - '
                                                            ||vn_TransformSuccessCount
                                                            ||' rows had Source Values which were successfully transformed.'
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                              --
                         END IF; --** IF vn_TransformSuccessCount > 0
                         --
                         IF   vn_NullDefaultedCount > 0
                         THEN
                              --
                              gvv_ProgressIndicator:= '0105';
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                   ,pt_i_Application       => pt_i_Application     
                                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                   ,pt_i_SubEntity         => pt_i_SubEntity
                                   ,pt_i_FileSetID         => pt_i_FileSetID
                                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   ,pt_i_Phase             => gvt_Phase
                                   ,pt_i_Severity          => 'NOTIFICATION'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '      - '
                                                            ||vn_NullDefaultedCount
                                                            ||' rows had no Source Value to be transformed '
                                                            ||'and were assigned the Default Value (both TRANSFORM_CODE '
                                                            ||'and DEFAULT_VALUE are specified for this column).'
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                         END IF;
                         --
                         IF   vn_EnrichedCount > 0
                         THEN
                              --
                              IF   ColumnToUpdate_rec.default_overrides_source_val = 'N'
                              THEN
                                   --
                                   gvv_ProgressIndicator:= '0106';
                                   xxmx_utilities_pkg.log_module_message
                                        (
                                         pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                        ,pt_i_Application       => pt_i_Application     
                                        ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                        ,pt_i_SubEntity         => pt_i_SubEntity
                                        ,pt_i_FileSetID         => pt_i_FileSetID
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                        ,pt_i_Phase             => gvt_Phase
                                        ,pt_i_Severity          => 'NOTIFICATION'
                                        ,pt_i_PackageName       => gct_PackageName
                                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage     => '      - '
                                                                 ||vn_EnrichedCount
                                                                 ||' rows had NULL Source Values which were assigned with the Default Value.'
                                        ,pt_i_OracleError       => NULL
                                        );
                                   --
                              ELSE
                                   --
                                   gvv_ProgressIndicator:= '0107';
                                   xxmx_utilities_pkg.log_module_message
                                        (
                                         pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                        ,pt_i_Application       => pt_i_Application     
                                        ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                        ,pt_i_SubEntity         => pt_i_SubEntity
                                        ,pt_i_FileSetID         => pt_i_FileSetID
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                        ,pt_i_Phase             => gvt_Phase
                                        ,pt_i_Severity          => 'NOTIFICATION'
                                        ,pt_i_PackageName       => gct_PackageName
                                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage     => '      - '
                                                                 ||vn_EnrichedCount
                                                                 ||' rows were assigned with the Default Value (any Source Values were replaced).'
                                        ,pt_i_OracleError       => NULL
                                        );
                                   --
                              END IF; --** IF ColumnsToUpdate_cur.default_overrides_source_val = 'N'
                              --
                         END IF; --** IF vn_EnrichedCount > 0
                         --
                    END LOOP; --** END ColumnsToUpdate_cur LOOP
                    --
                    /*
                    ** If there were ANY transform errors for ANY column, retrieve the errors
                    ** from the PL/SQL error table and construct a single message for each
                    ** data row to be written to the XXMX_DATA_MESSAGES table.
                    */
                    --
                    IF   vb_TransformErrors
                    THEN
                         --
                         /*
                         ** One or more data rows failed to be transformed and were inserted into
                         ** the PL/SQL transform errors table.
                         */
                         --
                         vn_PreviousRowSeq := 0;
                         --
                           --
                         FOR i IN 1..TransformError_tbl.COUNT
                         LOOP

                              --
                              --
                              vv_ErroredColumnList := SUBSTR(vv_ErroredColumnList
                                                         ||TransformError_tbl(i).column_and_error_code
                                                         ||', ',1,3000);

                         END LOOP; --** TransformError_cur LOOP
                         --
                         /*
                           ** Write the record for the last data row with transform errors.
                           */
                         --
                         vt_DataMessage := SUBSTR(
                                                  'The following Columns failed transformation : '
                                                ||RTRIM(vv_ErroredColumnList, ', ')
                                                 ,1
                                                 ,4000
                                                 );
                         --

                         --
                         gvv_ProgressIndicator:= '0108';
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                              ,pt_i_Application       => pt_i_Application     
                              ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                              ,pt_i_SubEntity         => pt_i_SubEntity
                              ,pt_i_FileSetID         => pt_i_FileSetID
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => ct_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '  - Simple Transform Errors have been detected for table "'||vt_DataMessage
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         --
                        /* FOR  TransformError_rec
                         IN   TransformError_cur
                                   (
                                    TransformError_tbl
                                   )
                         LOOP
                              --
                              IF   TransformError_rec.rowid_seq <> vn_PreviousRowSeq
                              THEN
                                   --
                                   IF   vn_PreviousRowSeq > 0
                                   THEN
                                        --
                                        vt_DataMessage := SUBSTR(
                                                                 'The following Columns failed transformation : '
                                                               ||RTRIM(vv_ErroredColumnList, ', ')
                                                                ,1
                                                                ,4000
                                                                );
                                        --
                                        xxmx_utilities_pkg.log_data_message
                                             (
                                              pt_i_ApplicationSuite      => pt_i_ApplicationSuite
                                             ,pt_i_Application           => pt_i_Application     
                                             ,pt_i_BusinessEntity        => pt_i_BusinessEntity
                                             ,pt_i_SubEntity             => pt_i_SubEntity
                                             ,pt_i_FileSetID             => pt_i_FileSetID
                                             ,pt_i_MigrationSetID        => pt_i_MigrationSetID
                                             ,pt_i_Phase                 => gvt_Phase
                                             ,pt_i_Severity              => 'ERROR'
                                             ,pt_i_DataTable             => TransformMetadata_rec.xfm_table_name
                                             ,pt_i_RowSeq                => vn_PreviousRowSeq
                                             ,pt_i_DataMessage           => vt_DataMessage
                                             ,pt_i_DataElementsAndValues => NULL
                                             );
                                        --
                                   END IF;
                                   --
                                   vv_ErroredColumnList := TransformError_rec.column_and_error_code
                                                         ||', ';
                                   --
                                   vn_PreviousRowSeq := TransformError_rec.rowid_seq;
                                   --
                              ELSE
                                   --
                                   vv_ErroredColumnList := vv_ErroredColumnList
                                                         ||TransformError_rec.column_and_error_code
                                                         ||', ';
                                   --
                              END IF;


                              --
                         END LOOP; --** TransformError_cur LOOP*/
                         --
                         /*
                         ** Write the record for the last data row with transform errors.
                         */

                         /*xxmx_utilities_pkg.log_data_message
                              (
                               pt_i_ApplicationSuite      => pt_i_ApplicationSuite
                              ,pt_i_Application           => pt_i_Application     
                              ,pt_i_BusinessEntity        => pt_i_BusinessEntity
                              ,pt_i_SubEntity             => pt_i_SubEntity
                              ,pt_i_FileSetID             => pt_i_FileSetID
                              ,pt_i_MigrationSetID        => pt_i_MigrationSetID
                              ,pt_i_Phase                 => gvt_Phase
                              ,pt_i_Severity              => 'ERROR'
                              ,pt_i_DataTable             => TransformMetadata_rec.xfm_table_name
                              ,pt_i_RowSeq                => vn_PreviousRowSeq
                              ,pt_i_DataMessage           => vt_DataMessage
                              ,pt_i_DataElementsAndValues => NULL
                              );*/

                    ELSE
                         --
                         gvv_ProgressIndicator:= '0109';
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                              ,pt_i_Application       => pt_i_Application     
                              ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                              ,pt_i_SubEntity         => pt_i_SubEntity
                              ,pt_i_FileSetID         => pt_i_FileSetID
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => gvt_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '  - There were no Simple Transform Errors for '
                                                       ||'this table.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                    END IF; --** IF vb_TransformErrors
                    --
               END IF; --** IF vn_TransformCount = 0 AND vn_EnrichmentCount = 0
               --
          END LOOP; --** TransformMetadata_cur LOOP
          --
          COMMIT;
          --
          gvv_ProgressIndicator:= '0110';
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application     
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_FileSetID         => pt_i_FileSetID
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||' ('
                                        ||pt_i_BusinessEntity
                                        ||' / '
                                        ||pt_i_SubEntity
                                        ||') completed.'
               ,pt_i_OracleError       => NULL
               );
          --
          xxmx_utilities_pkg.upd_migration_details
               (
                pt_i_MigrationSetID          => pt_i_MigrationSetID
               ,pt_i_BusinessEntity          => pt_i_BusinessEntity
               ,pt_i_SubEntity               => pt_i_SubEntity
               ,pt_i_Phase                   => ct_Phase
               ,pt_i_ExtractCompletionDate   => NULL
               ,pt_i_ExtractRowCount         => NULL
               ,pt_i_ExportRowCount          => NULL
               ,pt_i_ErrorFlag               => NULL
               ,pt_i_ExportStartDate         => NULL
               ,pt_i_ExportCompletionDate    => NULL
               ,pt_i_TransformTable          => NULL
               ,pt_i_TransformStartDate      => SYSDATE
               ,pt_i_TransformCompletionDate => SYSDATE
               ,pt_i_ExportFileName          => NULL      
            );
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    ROLLBACK;
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'ERROR'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END e_ModuleError Exception
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => pt_i_SubEntity
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END transform_data;
     --
     --
     --
     /*
     ********************************************************************
     ** This procedure is called by the Extension Handler procedure
     ** and simply builds the Dynamic SQL statement to execute a
     ** single Business Entity Level Extension.
     **
     ** Messages logged at the Business Entity Level will be written
     ** with a Sub-Entity Code of "ALL".
     **
     ** It must receive a return status back from the Extension so that
     ** it (in turn) can return a status back to the Extension Handler.
     **
     ** This one procedure is utilized to execute both Seeded and Custom
     ** Business Entity Level Extensions.
     ********************************************************************
     */
     --
     PROCEDURE call_extension
                    (
                     pt_i_ExtSchemaName              IN      xxmx_seeded_extensions.schema_name%TYPE
                    ,pt_i_ExtPackageName             IN      xxmx_seeded_extensions.extension_package%TYPE
                    ,pt_i_ExtProcedureName           IN      xxmx_seeded_extensions.extension_procedure%TYPE
                    ,pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    ,pv_o_ReturnMessage                 OUT  VARCHAR2
                    )
     IS
          --
          --********************
          --** Type Declarations
          --********************
          --
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
          --
          --******************************
          --** Dynamic Cursor Declarations
          --******************************
          --
          --
          --**********************
          --** Record Declarations
          --**********************
          --
          --
          --***************************
          --** PLSQL Table Declarations
          --***************************
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'call_extension';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          --
          --*************************
          --** Exception Declarations
          --*************************
          --
          e_ModuleError                   EXCEPTION;
          --
     --** END Declarations **
     --
     BEGIN
          --
          /*
          ** Extensions should write their own messages to the XXMX_MODULE_MESSAGES
          ** and/or XXMX_DATA_MESSAGES tables and therefore only need to return an
          ** overall processing Status Code ('S' for Success or 'F' for Failure) to
          ** this procedure.
          **
          ** This procedure will then return an appropriate message to the calling
          ** Extension Handler procedure.
          */
          --
          gvv_ProgressIndicator := '0010';
          --
          pv_o_ReturnStatus  := 'S';
          pv_o_ReturnMessage := NULL;
          --
          gvc_SQLStatement := 'BEGIN '
                            ||pt_i_ExtSchemaName
                            ||'.'
                            ||pt_i_ExtPackageName
                            ||'.'
                            ||pt_i_ExtProcedureName
                            ||'('
                            ||' pt_i_ApplicationSuite => '''
                            ||pt_i_ApplicationSuite
                            ||''''
                            ||',pt_i_Application => '''
                            ||pt_i_Application
                            ||''''
                            ||',pt_i_BusinessEntity => '''
                            ||pt_i_BusinessEntity
                            ||''''
                            ||',pt_i_StgPopulationMethod => '''
                            ||pt_i_StgPopulationMethod
                            ||''''
                            ||',pt_i_FileSetID => '''
                            ||pt_i_FileSetID
                            ||''''
                            ||' ,pt_i_MigrationSetID => '
                            ||pt_i_MigrationSetID
                            ||' ,pv_o_ReturnStatus => :1'
                            ||' ); END;';
          --

          gvv_ProgressIndicator := '0020';
            xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvc_SQLStatement
                         ,pt_i_OracleError       => gvt_OracleError
                         );
          --
          EXECUTE IMMEDIATE  gvc_SQLStatement
                      USING  OUT pv_o_ReturnStatus;
          --
          gvv_ProgressIndicator := '0030';
          --
          IF   pv_o_ReturnStatus <> 'S'
          THEN
               --
               pv_o_ReturnMessage := 'Extension Procedure returned '
                                   ||'a Error Status.  Please refer to the XXMX_MODULE_MESSAGES '
                                   ||'table and query for the "'
                                   ||pt_i_ExtPackageName
                                   ||'" Package Name for Migration Set ID '
                                   ||pt_i_MigrationSetID
                                   ||'.';
               --
          ELSE
               --
               pv_o_ReturnMessage := 'Extension Procedure returned a Success Status.';
               --
          END IF; --** IF pv_o_ReturnStatus <> 'S'
          --
          EXCEPTION
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END call_extension;
     --
     --
     /*
     *******************************************************************
     ** This procedure is called by the Extension Handler procedure
     ** and simply builds the Dynamic SQL statement to execute a
     ** single Sub-Entity Level Extension.
     **
     ** It must receive a return status back from the Extension so that
     ** it can (in turn) return a status back to the Extension Handler.
     **
     ** This one procedure is utilized to execute both Seeded and Custom
     ** Sub-Entity Level Extensions.
     *******************************************************************
     */
     --
     PROCEDURE call_sub_extension
                    (
                     pt_i_ExtSchemaName              IN      xxmx_seeded_sub_extensions.schema_name%TYPE
                    ,pt_i_ExtPackageName             IN      xxmx_seeded_sub_extensions.extension_package%TYPE
                    ,pt_i_ExtProcedureName           IN      xxmx_seeded_sub_extensions.extension_procedure%TYPE
                    ,pt_i_ApplicationSuite           IN      xxmx_seeded_sub_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_sub_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_sub_extensions.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_seeded_sub_extensions.sub_entity%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    ,pv_o_ReturnMessage                 OUT  VARCHAR2
                    )
     IS
          --
          --********************
          --** Type Declarations
          --********************
          --
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
          --
          --******************************
          --** Dynamic Cursor Declarations
          --******************************
          --
          --
          --**********************
          --** Record Declarations
          --**********************
          --
          --
          --***************************
          --** PLSQL Table Declarations
          --***************************
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'call_sub_extension';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          --
          --*************************
          --** Exception Declarations
          --*************************
          --
          e_ModuleError                   EXCEPTION;
          --
     --** END Declarations **
     --
     BEGIN
          --
          /*
          ** Extensions should write their own messages to the XXMX_MODULE_MESSAGES
          ** and/or XXMX_DATA_MESSAGES tables and therefore only need to return an
          ** overall processing Status Code ('S' for Success or 'F' for Failure) to
          ** this procedure.
          **
          ** This procedure will then return an appropriate message to the calling
          ** Extension Handler procedure.
          */
          --
          gvv_ProgressIndicator := '0010';
          --
          pv_o_ReturnStatus  := 'S';
          pv_o_ReturnMessage := NULL;
          --
          gvc_SQLStatement := 'BEGIN '
                            ||pt_i_ExtSchemaName
                            ||'.'
                            ||pt_i_ExtPackageName
                            ||'.'
                            ||pt_i_ExtProcedureName
                            ||'('
                            ||' pt_i_ApplicationSuite => '''
                            ||pt_i_ApplicationSuite
                            ||''''
                            ||',pt_i_Application => '''
                            ||pt_i_Application
                            ||''''
                            ||',pt_i_BusinessEntity => '''
                            ||pt_i_BusinessEntity
                            ||''''
                            ||' ,pt_i_SubEntity => '''
                            ||pt_i_SubEntity
                            ||''''
                            ||' ,pt_i_StgPopulationMethod => '''
                            ||pt_i_StgPopulationMethod
                            ||''''
                            ||' ,pt_i_FileSetID => '''
                            ||pt_i_FileSetID
                            ||''''
                            ||' ,pt_i_MigrationSetID => '
                            ||pt_i_MigrationSetID
                            ||' ,pv_o_ReturnStatus => :1'
                            ||' ); END;';
          --
          gvv_ProgressIndicator := '0020';
          --
          EXECUTE IMMEDIATE  gvc_SQLStatement
                      USING  OUT pv_o_ReturnStatus;
          --
          gvv_ProgressIndicator := '0030';
          --
          IF   pv_o_ReturnStatus <> 'S'
          THEN
               --
               pv_o_ReturnMessage := 'Extension Procedure returned '
                                   ||'a Error Status.  Please refer to the XXMX_MODULE_MESSAGES '
                                   ||'table and query for the "'
                                   ||pt_i_ExtPackageName
                                   ||'" Package Name for Migration Set ID '
                                   ||pt_i_MigrationSetID
                                   ||'.';
               --
          ELSE
               --
               pv_o_ReturnMessage := 'Extension Procedure returned a Success Status.';
               --
          END IF; --** IF pv_o_ReturnStatus <> 'S'
          --
          EXCEPTION
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => gct_CoreSubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END call_sub_extension;
     --
     --
     /*
     ***********************************************************************
     ** PROCEDURE EXECUTE_EXTENSION
     **
     ** This procedure handles the definition validation and execution
     ** of Seeded or Custome Extensions.
     **
     ** Seeded extensions are those written by the Maximise Development
     ** Team.
     **
     ** Custom extensions are those which may need to be written by V 1
     ** Implementation Teams or Client Development Teams.
     **
     ** Business Entity Level Extensions which are designed to operate on
     ** data held in multiple Sub-Entity related tables are defined in the
     ** xxmx_seeded_extensions and/or xxmx_custom_extensions tables.
     **     
     ** Sub-Entity Level Extensions which are designed to operate on data
     ** held in single Sub-Entity related table are defined in the
     ** xxmx_seeded_sub_extensions and/or xxmx_seeded_sub_extensions tables.
     **
     ** Specific Business Entity Level Extensions may need to be executed
     ** BEFORE or AFTER any Sub-Entity Level Extensions and this design
     ** handles both cases.
     **
     ** pv_i_ExtensionType must have a value of "SEEDED" or "CUSTOM".
     **
     ** pt_i_StgPopulationMethod is simply passed through to the extension
     ** procedures so that they can determine whether to use pt_i_FileSetID
     ** or pt_i_MigrationSetID to access the Client Data in the STG or XFM
     ** tables.
     **
     ** The Maximise Team can provide templates for Extension Procedures.     
     ***********************************************************************
     */
     --
     PROCEDURE execute_extension
                    (
                     pt_i_ApplicationSuite           IN      xxmx_seeded_extensions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_seeded_extensions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_seeded_extensions.business_entity%TYPE
                    ,pv_i_ExtensionType              IN      VARCHAR2
                    ,pt_i_Phase                      IN      xxmx_seeded_extensions.phase%TYPE
                    ,pt_i_StgPopulationMethod        IN      xxmx_core_parameters.parameter_value%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    ,pv_o_ReturnMessage                 OUT  VARCHAR2
                    )
     IS
          --
          --********************
          --** Type Declarations
          --********************
          --
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
          /*
          ** Cursor to retrieve Business Entity Level Extensions that need to be run BEFORE
          ** or AFTER the Sub-Entity Extensions.
          */
          --
          CURSOR Extensions_cur
                      (
                       pt_ApplicationSuite             xxmx_seeded_extensions.application_suite%TYPE
                      ,pt_Application                  xxmx_seeded_extensions.application%TYPE
                      ,pt_BusinessEntity               xxmx_seeded_extensions.business_entity%TYPE
                      ,pv_ExtensionType                VARCHAR2  DEFAULT NULL
                      ,pt_Phase                        xxmx_seeded_extensions.phase%TYPE
                      ,pt_OrderToSubExtensions         xxmx_seeded_extensions.order_to_sub_extensions%TYPE 
                      )
          IS
               --
               SELECT    'Seeded'                                    AS extension_source
                        ,LOWER(xse.schema_name)                      AS schema_name
                        ,LOWER(xse.extension_package)                AS extension_package
                        ,LOWER(xse.extension_procedure)              AS extension_procedure
                        ,xse.execution_sequence                      
                        ,UPPER(NVL(xse.execute_next_on_error, 'N'))  AS execute_next_on_error
                        ,UPPER(NVL(xse.enabled_flag ,'N'))           AS enabled_flag
               FROM      xxmx_seeded_extensions  xse
               WHERE     1 = 1
               AND       pv_ExtensionType            = 'SEEDED'
               AND       xse.application_suite       = pt_ApplicationSuite
               AND       xse.application             = pt_Application
               AND       xse.business_entity         = pt_BusinessEntity
               AND       xse.phase                   = pt_Phase
               AND       xse.order_to_sub_extensions = pt_OrderToSubExtensions
               UNION
               SELECT    'Custom '
                       ||INITCAP(xce.extension_source)               AS extension_source
                        ,LOWER(xce.schema_name)                      AS schema_name
                        ,LOWER(xce.extension_package)                AS extension_package
                        ,LOWER(xce.extension_procedure)              AS extension_procedure
                        ,xce.execution_sequence                      
                        ,UPPER(NVL(xce.execute_next_on_error, 'N'))  AS execute_next_on_error
                        ,UPPER(NVL(xce.enabled_flag ,'N'))           AS enabled_flag
               FROM      xxmx_custom_extensions  xce
               WHERE     1 = 1
               AND       pv_ExtensionType            = 'CUSTOM'
               AND       xce.application_suite       = pt_ApplicationSuite
               AND       xce.application             = pt_Application
               AND       xce.business_entity         = pt_BusinessEntity
               AND       xce.phase                   = pt_Phase
               AND       xce.order_to_sub_extensions = pt_OrderToSubExtensions
               ORDER BY  5;
               --
          --** END CURSOR Extension_cur;
          --
          CURSOR SubEntities_cur
                      (
                       pt_ApplicationSuite           xxmx_migration_metadata.application_suite%TYPE
                      ,pt_Application                xxmx_migration_metadata.application%TYPE
                      ,pt_BusinessEntity             xxmx_migration_metadata.business_entity%TYPE
                      )
          IS
               --
               SELECT    UPPER(xmm.sub_entity)       AS sub_entity
               FROM      xxmx_migration_metadata     xmm
               WHERE     1 = 1
               AND       xmm.application_suite  = pt_ApplicationSuite
               AND       xmm.application        = pt_Application
               AND       xmm.business_entity    = pt_BusinessEntity
               ORDER BY  xmm.sub_entity_seq;
               --
          --** END CURSOR SubEntities_cur;
          --
          CURSOR SubExtensions_cur
                      (
                       pt_ApplicationSuite             xxmx_seeded_sub_extensions.application_suite%TYPE
                      ,pt_Application                  xxmx_seeded_sub_extensions.application%TYPE
                      ,pt_BusinessEntity               xxmx_seeded_sub_extensions.business_entity%TYPE
                      ,pt_SubEntity                    xxmx_seeded_sub_extensions.sub_entity%TYPE
                      ,pv_ExtensionType                VARCHAR2
                      ,pt_Phase                        xxmx_seeded_sub_extensions.phase%TYPE
                      )
          IS
               --
               SELECT    'Seeded'                                     AS extension_source
                        ,LOWER(xsse.schema_name)                      AS schema_name
                        ,LOWER(xsse.extension_package)                AS extension_package
                        ,LOWER(xsse.extension_procedure)              AS extension_procedure
                        ,xsse.execution_sequence
                        ,UPPER(NVL(xsse.execute_next_on_error, 'N'))  AS execute_next_on_error
                        ,UPPER(NVL(xsse.enabled_flag ,'N'))           AS enabled_flag
               FROM      xxmx_seeded_sub_extensions  xsse
               WHERE     1 = 1
               AND       pv_ExtensionType       = 'SEEDED'
               AND       xsse.application_suite = pt_ApplicationSuite
               AND       xsse.application       = pt_Application
               AND       xsse.business_entity   = pt_BusinessEntity
               AND       xsse.sub_entity        = pt_SubEntity
               AND       xsse.phase             = pt_Phase
               UNION
               SELECT    'Custom '
                       ||INITCAP(xcse.extension_source)               AS extension_source
                        ,LOWER(xcse.schema_name)                      AS schema_name
                        ,LOWER(xcse.extension_package)                AS extension_package
                        ,LOWER(xcse.extension_procedure)              AS extension_procedure
                        ,xcse.execution_sequence
                        ,UPPER(NVL(xcse.execute_next_on_error, 'N'))  AS execute_next_on_error
                        ,UPPER(NVL(xcse.enabled_flag ,'N'))           AS enabled_flag
               FROM      xxmx_custom_sub_extensions  xcse
               WHERE     1 = 1
               AND       pv_ExtensionType       = 'CUSTOM'
               AND       xcse.application_suite = pt_ApplicationSuite
               AND       xcse.application       = pt_Application
               AND       xcse.business_entity   = pt_BusinessEntity
               AND       xcse.sub_entity        = pt_SubEntity
               AND       xcse.phase             = pt_Phase
               ORDER BY  5;
               --
          --** END CURSOR SubExtensions_cur;
          --
          --******************************
          --** Dynamic Cursor Declarations
          --******************************
          --
          --
          --**********************
          --** Record Declarations
          --**********************
          --
          --
          --***************************
          --** PLSQL Table Declarations
          --***************************
          --
          --
          --************************
          --** Constant Declarations
          --************************
          --
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'EXECUTE_EXTENSION';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vv_MessageExtensionType         VARCHAR2(6);
          vb_ExtensionsDefined            BOOLEAN;
          vb_EnabledExtensionsFound       BOOLEAN;
          vb_callnextextinsequence       BOOLEAN;
          vt_ExtensionSource              xxmx_custom_extensions.extension_source%TYPE;
          vt_SchemaName                   xxmx_seeded_extensions.schema_name%TYPE;
          vt_PackageName                  xxmx_seeded_extensions.Extension_package%TYPE;
          vt_ProcedureName                xxmx_seeded_extensions.Extension_procedure%TYPE;
          vt_ExecutionSequence            xxmx_seeded_extensions.execution_sequence%TYPE;
          vt_ExecuteNextOnError           xxmx_seeded_extensions.execute_next_on_error%TYPE;
          vt_EnabledFlag                  xxmx_seeded_extensions.enabled_flag%TYPE;
          vb_PrerequisiteExists           BOOLEAN;
          vn_PrereqErrorCount             NUMBER;
          vb_CallExtension                BOOLEAN;
          --
          --*************************
          --** Exception Declarations
          --*************************
          --
          e_ModuleError                   EXCEPTION;
          --
     --** END Declarations **
     --
     BEGIN
          --
          pv_o_ReturnStatus         := 'S';
          pv_o_ReturnMessage        := NULL;
          vv_MessageExtensionType   := INITCAP(pv_i_ExtensionType);
          --
          gvv_ProgressIndicator := '0010';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application     
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
               ,pt_i_SubEntity         => 'ALL'            
               ,pt_i_FileSetID         => pt_i_FileSetID
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => pt_i_Phase
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
          gvv_ProgressIndicator := '0050';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application     
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
               ,pt_i_SubEntity         => 'ALL'
               ,pt_i_FileSetID         => pt_i_FileSetID
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => pt_i_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '- Evaluating '
                                        ||vv_MessageExtensionType
                                        ||' Extensions for the "'
                                        ||pt_i_Phase
                                        ||'" Phase of Business Entity "'
                                        ||pt_i_BusinessEntity
                                        ||'".'
               ,pt_i_OracleError       => NULL
               );
          --
          /*
          ************************************************************
          ** Business Entity Level Extensions that must execute BEFORE
          ** any Sub-Extensions.
          ************************************************************
          */
          --
          gvv_ProgressIndicator := '0060';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application     
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
               ,pt_i_SubEntity         => 'ALL'
               ,pt_i_FileSetID         => pt_i_FileSetID
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => pt_i_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '  - Processing Business Entity '
                                        ||vv_MessageExtensionType
                                        ||' Extensions (Pre-Sub-Entity).'
               ,pt_i_OracleError       => NULL
               );
          --
          vb_ExtensionsDefined      := FALSE;
          vb_EnabledExtensionsFound := FALSE;
          vb_CallNextExtInSequence  := TRUE;
          --
          gvv_ProgressIndicator := '0070';
          --
          OPEN Extensions_cur
                    (
                     pt_i_ApplicationSuite
                    ,pt_i_Application     
                    ,pt_i_BusinessEntity
                    ,pv_i_ExtensionType                    
                    ,pt_i_Phase
                    ,'BEFORE'
                    );
          --
          gvv_ProgressIndicator := '0080';
          --
          WHILE vb_CallNextExtInSequence
          LOOP
               --
               gvv_ProgressIndicator := '0090';
               --
               FETCH  Extensions_cur
               INTO   vt_ExtensionSource
                     ,vt_SchemaName        
                     ,vt_PackageName       
                     ,vt_ProcedureName     
                     ,vt_ExecutionSequence 
                     ,vt_ExecuteNextOnError
                     ,vt_EnabledFlag;       
               --
               gvv_ProgressIndicator := '0100';
               --
               IF   Extensions_cur%NOTFOUND
               THEN
                    --
                    vb_CallNextExtInSequence := FALSE;
                    --
               ELSE
                    --
                    vb_ExtensionsDefined := TRUE;
                    --
                    /*
                    ** We expect to be able to call the extension unless it hasn't been installed.
                    */
                    --
                    vb_CallExtension := TRUE;
                    --
                    gvv_ProgressIndicator := '0110';
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
                         ,pt_i_SubEntity         => 'ALL'
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => pt_i_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - Verifying Extension Package "'
                                                  ||vt_SchemaName
                                                  ||'.'
                                                  ||vt_PackageName
                                                  ||'".'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    /*
                    ** Verify specified extension PACKAGE SPECIFICATION is installed and is VALID.
                    */
                    --
                    gvt_ObjectStatus := get_object_status
                                             (
                                              pt_i_Owner      => vt_SchemaName
                                             ,pt_i_ObjectName => vt_PackageName
                                             ,pt_i_ObjectType => 'PACKAGE'
                                             );
                    --
                    IF   gvt_ObjectStatus = 'NOT EXIST'
                    THEN
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                              ,pt_i_Application       => pt_i_Application     
                              ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
                              ,pt_i_SubEntity         => 'ALL'
                              ,pt_i_FileSetID         => pt_i_FileSetID
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => gvt_Phase
                              ,pt_i_Severity          => 'ERROR'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '      - Package Specification is not installed in Schema.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         vb_CallExtension := FALSE;
                         --
                    ELSIF gvt_ObjectStatus = 'INVALID'
                    THEN
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                              ,pt_i_Application       => pt_i_Application     
                              ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
                              ,pt_i_SubEntity         => 'ALL'
                              ,pt_i_FileSetID         => pt_i_FileSetID
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => gvt_Phase
                              ,pt_i_Severity          => 'ERROR'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '      - Package Specification Status is INVALID.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         vb_CallExtension := FALSE;
                         --
                    END IF; --** IF gvt_ObjectStatus = 'NOT EXIST' OR 'INVALID'
                    --
                    /*
                    ** Verify specified extension PACKAGE BODY is installed and is VALID.
                    */
                    --
                    gvt_ObjectStatus := get_object_status
                                             (
                                              pt_i_Owner      => vt_SchemaName
                                             ,pt_i_ObjectName => vt_PackageName
                                             ,pt_i_ObjectType => 'PACKAGE BODY'
                                             );
                    --
                    IF   gvt_ObjectStatus = 'NOT EXIST'
                    THEN
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                              ,pt_i_Application       => pt_i_Application     
                              ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
                              ,pt_i_SubEntity         => 'ALL'
                              ,pt_i_FileSetID         => pt_i_FileSetID
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => gvt_Phase
                              ,pt_i_Severity          => 'ERROR'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '      - Package Body is not installed in Schema.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         vb_CallExtension := FALSE;
                         --
                    ELSIF gvt_ObjectStatus = 'INVALID'
                    THEN
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                              ,pt_i_Application       => pt_i_Application     
                              ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
                              ,pt_i_SubEntity         => 'ALL'
                              ,pt_i_FileSetID         => pt_i_FileSetID
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => gvt_Phase
                              ,pt_i_Severity          => 'ERROR'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '      - Package Body Status is INVALID.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         vb_CallExtension := FALSE;
                         --
                    END IF; --** IF gvt_ObjectStatus = 'NOT EXIST' OR 'INVALID'
                    --
                    /*
                    ** Verify the Extension is enabled.
                    */
                    --
                    IF   vt_EnabledFlag = 'Y'
                    THEN
                         --
                         vb_EnabledExtensionsFound := TRUE;
                         --
                    ELSE
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                              ,pt_i_Application       => pt_i_Application     
                              ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
                              ,pt_i_SubEntity         => 'ALL'
                              ,pt_i_FileSetID         => pt_i_FileSetID
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => gvt_Phase
                              ,pt_i_Severity          => 'ERROR'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '      - Extension Procedure "'
                                                       ||vt_PackageName
                                                       ||'.'
                                                       ||vt_ProcedureName
                                                       ||'" ('
                                                       ||vt_ExtensionSource
                                                       ||') is NOT enabled.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         vb_CallExtension := FALSE;
                         --
                    END IF; --** IF vt_EnabledFlag = 'Y'
                    --
                    IF   vb_CallExtension
                    THEN
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                              ,pt_i_Application       => pt_i_Application     
                              ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
                              ,pt_i_SubEntity         => 'ALL'
                              ,pt_i_FileSetID         => pt_i_FileSetID
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => pt_i_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '      - Calling Extension Procedure "'
                                                       ||vt_PackageName
                                                       ||'.'
                                                       ||vt_ProcedureName
                                                       ||'" ('
                                                       ||vt_ExtensionSource
                                                       ||').'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         gvv_ProgressIndicator := '0120';
                         --
                         call_extension
                              (
                               pt_i_ExtSchemaName       => vt_SchemaName
                              ,pt_i_ExtPackageName      => vt_PackageName
                              ,pt_i_ExtProcedureName    => vt_ProcedureName
                              ,pt_i_ApplicationSuite    => pt_i_ApplicationSuite
                              ,pt_i_Application         => pt_i_Application
                              ,pt_i_BusinessEntity      => pt_i_BusinessEntity
                              ,pt_i_StgPopulationMethod => pt_i_StgPopulationMethod
                              ,pt_i_FileSetID           => pt_i_FileSetID
                              ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                              ,pv_o_ReturnStatus        => gvv_ReturnStatus
                              ,pv_o_ReturnMessage       => gvt_ReturnMessage
                              );
                         --
                         IF   gvv_ReturnStatus <> 'S'
                         THEN
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                   ,pt_i_Application       => pt_i_Application     
                                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
                                   ,pt_i_SubEntity         => 'ALL'
                                   ,pt_i_FileSetID         => pt_i_FileSetID
                                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   ,pt_i_Phase             => gvt_Phase
                                   ,pt_i_Severity          => 'ERROR'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '        - '||gvt_ReturnMessage
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                              IF   vt_ExecuteNextOnError = 'N'
                              THEN
                                   --
                                   vb_CallNextExtInSequence := FALSE;
                                   --
                                   xxmx_utilities_pkg.log_module_message
                                        (
                                         pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                        ,pt_i_Application       => pt_i_Application     
                                        ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
                                        ,pt_i_SubEntity         => 'ALL'
                                        ,pt_i_FileSetID         => pt_i_FileSetID
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                        ,pt_i_Phase             => gvt_Phase
                                        ,pt_i_Severity          => 'NOTIFICATION'
                                        ,pt_i_PackageName       => gct_PackageName
                                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage     => '          - Execute Next On Error = ''N'' '
                                        ,pt_i_OracleError       => NULL
                                        );
                                   --
                              ELSE
                                   --
                                   xxmx_utilities_pkg.log_module_message
                                        (
                                         pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                        ,pt_i_Application       => pt_i_Application     
                                        ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
                                        ,pt_i_SubEntity         => 'ALL'
                                        ,pt_i_FileSetID         => pt_i_FileSetID
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                        ,pt_i_Phase             => gvt_Phase
                                        ,pt_i_Severity          => 'NOTIFICATION'
                                        ,pt_i_PackageName       => gct_PackageName
                                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage     => '          - Execute Next On Error = ''Y'' '
                                        ,pt_i_OracleError       => NULL
                                        );
                                   --
                              END IF; --** IF vt_ExecuteNextOnError = 'N'
                              --
                         ELSE
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                   ,pt_i_Application       => pt_i_Application     
                                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
                                   ,pt_i_SubEntity         => 'ALL'
                                   ,pt_i_FileSetID         => pt_i_FileSetID
                                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   ,pt_i_Phase             => gvt_Phase
                                   ,pt_i_Severity          => 'NOTIFICATION'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '        - '||gvt_ReturnMessage
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                         END IF; --** IF gvv_ReturnStatus <> 'S'
                         --
                    END IF; --** IF vb_CallExtension
                    --
               END IF; --** IF Extensions_cur%NOTFOUND
               --
          END LOOP; --** WHILE vb_CallNextExtInSequence LOOP
          --
          gvv_ProgressIndicator := '0130';
          --
          CLOSE Extensions_cur;
          --
          IF   NOT vb_ExtensionsDefined
          THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
                    ,pt_i_SubEntity         => 'ALL'
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => pt_i_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '    - No Business Entity '
                                             ||vv_MessageExtensionType
                                             ||' Extensions (Pre-Sub-Entity) are registered.'
                    ,pt_i_OracleError       => NULL);
               --
          ELSE
               --
               IF   NOT vb_EnabledExtensionsFound
               THEN
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
                         ,pt_i_SubEntity         => 'ALL'
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => pt_i_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - No registered Business Entity '
                                                  ||vv_MessageExtensionType
                                                  ||' Extensions (Pre-Sub-Entity) are enabled.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
               END IF; --** IF NOT vb_EnabledExtensionsFound
               --
          END IF; --** IF NOT vb_ExtensionsDefined
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application     
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
               ,pt_i_SubEntity         => 'ALL'
               ,pt_i_FileSetID         => pt_i_FileSetID
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => pt_i_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '  - Business Entity '
                                        ||vv_MessageExtensionType
                                        ||' Extensions (Pre-Sub-Entity) Processing Complete.'
               ,pt_i_OracleError       => NULL
               );
          --
          /*
          ******************************
          ** Sub-Entity Level Extensions
          ******************************
          */
          --
          gvv_ProgressIndicator := '0140';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application     
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
               ,pt_i_SubEntity         => 'ALL'
               ,pt_i_FileSetID         => pt_i_FileSetID
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => pt_i_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '  - Processing Sub-Entity '
                                        ||vv_MessageExtensionType
                                        ||' Extensions.'
               ,pt_i_OracleError       => NULL
               );
          --
          FOR  SubEntity_rec
          IN   SubEntities_cur
                    (
                     pt_i_ApplicationSuite
                    ,pt_i_Application
                    ,pt_i_BusinessEntity
                    )
          LOOP
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application     
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
                    ,pt_i_SubEntity         => SubEntity_rec.sub_entity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => pt_i_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '    - Processing "'
                                             ||SubEntity_rec.sub_entity
                                             ||'" Sub-Entity '
                                             ||vv_MessageExtensionType
                                             ||' Extensions.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               vb_ExtensionsDefined      := FALSE;
               vb_EnabledExtensionsFound := FALSE;
               vb_CallNextExtInSequence  := TRUE;
               --
               gvv_ProgressIndicator := '0070';
               --
               OPEN SubExtensions_cur
                         (
                          pt_i_ApplicationSuite
                         ,pt_i_Application
                         ,pt_i_BusinessEntity
                         ,SubEntity_rec.sub_entity
                         ,pv_i_ExtensionType
                         ,pt_i_Phase
                         );
               --
               gvv_ProgressIndicator := '0080';
               --
               WHILE vb_CallNextExtInSequence
               LOOP
                    --
                    gvv_ProgressIndicator := '0090';
                    --
                    FETCH  SubExtensions_cur
                    INTO   vt_ExtensionSource   
                          ,vt_SchemaName        
                          ,vt_PackageName       
                          ,vt_ProcedureName     
                          ,vt_ExecutionSequence 
                          ,vt_ExecuteNextOnError
                          ,vt_EnabledFlag;       
                    --
                    gvv_ProgressIndicator := '0100';
                    --
                    IF   SubExtensions_cur%NOTFOUND
                    THEN
                         --
                         vb_CallNextExtInSequence := FALSE;
                         --
                    ELSE
                         --
                         vb_ExtensionsDefined := TRUE;
                         --
                         /*
                         ** We expect to be able to call the extension unless it hasn't been installed.
                         */
                         --
                         vb_CallExtension := TRUE;
                         --
                         gvv_ProgressIndicator := '0110';
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                              ,pt_i_Application       => pt_i_Application     
                              ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
                              ,pt_i_SubEntity         => SubEntity_rec.sub_entity
                              ,pt_i_FileSetID         => pt_i_FileSetID
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => pt_i_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '    - Verifying '
                                                       ||vv_MessageExtensionType
                                                       ||' Extension Package "'
                                                       ||vt_SchemaName
                                                       ||'.'
                                                       ||vt_PackageName
                                                       ||'".'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         /*
                         ** Verify specified extension package exists and is VALID.
                         */
                         --
                         gvt_ObjectStatus := get_object_status
                                                  (
                                                   pt_i_Owner      => vt_SchemaName
                                                  ,pt_i_ObjectName => vt_PackageName
                                                  ,pt_i_ObjectType => 'PACKAGE'
                                                  );
                         --
                         IF   gvt_ObjectStatus = 'NOT EXIST'
                         THEN
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                   ,pt_i_Application       => pt_i_Application     
                                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
                                   ,pt_i_SubEntity         => SubEntity_rec.sub_entity
                                   ,pt_i_FileSetID         => pt_i_FileSetID
                                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   ,pt_i_Phase             => gvt_Phase
                                   ,pt_i_Severity          => 'ERROR'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '      - Package Specification is not installed in Schema.'
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                              vb_CallExtension := FALSE;
                              --
                         ELSIF gvt_ObjectStatus = 'INVALID'
                         THEN
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                   ,pt_i_Application       => pt_i_Application     
                                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
                                   ,pt_i_SubEntity         => SubEntity_rec.sub_entity
                                   ,pt_i_FileSetID         => pt_i_FileSetID
                                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   ,pt_i_Phase             => gvt_Phase
                                   ,pt_i_Severity          => 'ERROR'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '      - Package Specification Status is INVALID.'
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                              vb_CallExtension := FALSE;
                              --
                         END IF; --** IF gvt_ObjectStatus = 'NOT EXIST' OR 'INVALID'
                         --
                         /*
                         ** Verify specified extension PACKAGE BODY exists and is VALID.
                         */
                         --
                         gvt_ObjectStatus := get_object_status
                                                  (
                                                   pt_i_Owner      => vt_SchemaName
                                                  ,pt_i_ObjectName => vt_PackageName
                                                  ,pt_i_ObjectType => 'PACKAGE BODY'
                                                  );
                         --
                         IF   gvt_ObjectStatus = 'NOT EXIST'
                         THEN
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                   ,pt_i_Application       => pt_i_Application     
                                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
                                   ,pt_i_SubEntity         => SubEntity_rec.sub_entity
                                   ,pt_i_FileSetID         => pt_i_FileSetID
                                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   ,pt_i_Phase             => gvt_Phase
                                   ,pt_i_Severity          => 'ERROR'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '      - Package Body is not installed in Schema.'
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                              vb_CallExtension := FALSE;
                              --
                         ELSIF gvt_ObjectStatus = 'INVALID'
                         THEN
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                   ,pt_i_Application       => pt_i_Application     
                                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
                                   ,pt_i_SubEntity         => SubEntity_rec.sub_entity
                                   ,pt_i_FileSetID         => pt_i_FileSetID
                                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   ,pt_i_Phase             => gvt_Phase
                                   ,pt_i_Severity          => 'ERROR'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '      - Package Body Status is INVALID.'
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                              vb_CallExtension := FALSE;
                              --
                         END IF; --** IF gvt_ObjectStatus = 'NOT EXIST' OR 'INVALID'
                         --
                         /*
                         ** Verify the Seeded Extension is enabled.
                         */
                         --
                         IF   vt_EnabledFlag = 'Y'
                         THEN
                              --
                              vb_EnabledExtensionsFound := TRUE;
                              --
                         ELSE
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                   ,pt_i_Application       => pt_i_Application     
                                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
                                   ,pt_i_SubEntity         => SubEntity_rec.sub_entity
                                   ,pt_i_FileSetID         => pt_i_FileSetID
                                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   ,pt_i_Phase             => gvt_Phase
                                   ,pt_i_Severity          => 'ERROR'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '      - Extension Procedure "'
                                                            ||vt_PackageName
                                                            ||'.'
                                                            ||vt_ProcedureName
                                                            ||'" ('
                                                            ||vt_ExtensionSource
                                                            ||') is NOT enabled.'
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                              vb_CallExtension := FALSE;
                              --
                         END IF;
                         --
                         IF   vb_CallExtension
                         THEN
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                   ,pt_i_Application       => pt_i_Application
                                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                   ,pt_i_SubEntity         => SubEntity_rec.sub_entity
                                   ,pt_i_FileSetID         => pt_i_FileSetID
                                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   ,pt_i_Phase             => pt_i_Phase
                                   ,pt_i_Severity          => 'NOTIFICATION'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '      - Calling Extension Procedure "'
                                                            ||vt_PackageName
                                                            ||'.'
                                                            ||vt_ProcedureName
                                                            ||'" ('
                                                            ||vt_ExtensionSource
                                                            ||').'
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                              gvv_ProgressIndicator := '0120';
                              --
                              call_sub_extension
                                   (
                                    pt_i_ExtSchemaName       => vt_SchemaName
                                   ,pt_i_ExtPackageName      => vt_PackageName
                                   ,pt_i_ExtProcedureName    => vt_ProcedureName
                                   ,pt_i_ApplicationSuite    => pt_i_ApplicationSuite
                                   ,pt_i_Application         => pt_i_Application
                                   ,pt_i_BusinessEntity      => pt_i_BusinessEntity
                                   ,pt_i_SubEntity           => SubEntity_rec.sub_entity
                                   ,pt_i_StgPopulationMethod => pt_i_StgPopulationMethod
                                   ,pt_i_FileSetID           => pt_i_FileSetID
                                   ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                                   ,pv_o_ReturnStatus        => gvv_ReturnStatus
                                   ,pv_o_ReturnMessage       => gvt_ReturnMessage
                                   );
                              --
                              IF   gvv_ReturnStatus <> 'S'
                              THEN
                                   --
                                   xxmx_utilities_pkg.log_module_message
                                        (
                                         pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                        ,pt_i_Application       => pt_i_Application
                                        ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                        ,pt_i_SubEntity         => SubEntity_rec.sub_entity
                                        ,pt_i_FileSetID         => pt_i_FileSetID
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                        ,pt_i_Phase             => gvt_Phase
                                        ,pt_i_Severity          => 'ERROR'
                                        ,pt_i_PackageName       => gct_PackageName
                                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage     => '          - '||gvt_ReturnMessage
                                        ,pt_i_OracleError       => NULL
                                        );
                                   --
                                   IF   vt_ExecuteNextOnError = 'N'
                                   THEN
                                        --
                                        vb_CallNextExtInSequence := FALSE;
                                        --
                                        xxmx_utilities_pkg.log_module_message
                                             (
                                              pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                             ,pt_i_Application       => pt_i_Application
                                             ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                             ,pt_i_SubEntity         => SubEntity_rec.sub_entity
                                             ,pt_i_FileSetID         => pt_i_FileSetID
                                             ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                             ,pt_i_Phase             => gvt_Phase
                                             ,pt_i_Severity          => 'NOTIFICATION'
                                             ,pt_i_PackageName       => gct_PackageName
                                             ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                             ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                             ,pt_i_ModuleMessage     => '            - Execute Next On Error = ''N'' '
                                             ,pt_i_OracleError       => NULL
                                             );
                                        --
                                   ELSE
                                        --
                                        xxmx_utilities_pkg.log_module_message
                                             (
                                              pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                             ,pt_i_Application       => pt_i_Application
                                             ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                             ,pt_i_SubEntity         => SubEntity_rec.sub_entity
                                             ,pt_i_FileSetID         => pt_i_FileSetID
                                             ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                             ,pt_i_Phase             => gvt_Phase
                                             ,pt_i_Severity          => 'NOTIFICATION'
                                             ,pt_i_PackageName       => gct_PackageName
                                             ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                             ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                             ,pt_i_ModuleMessage     => '            - Execute Next On Error = ''Y'' '
                                             ,pt_i_OracleError       => NULL
                                             );
                                        --
                                   END IF;
                                   --
                              ELSE
                                   --
                                   xxmx_utilities_pkg.log_module_message
                                        (
                                         pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                        ,pt_i_Application       => pt_i_Application
                                        ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                        ,pt_i_SubEntity         => SubEntity_rec.sub_entity
                                        ,pt_i_FileSetID         => pt_i_FileSetID
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                        ,pt_i_Phase             => gvt_Phase
                                        ,pt_i_Severity          => 'NOTIFICATION'
                                        ,pt_i_PackageName       => gct_PackageName
                                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage     => '          - '||gvt_ReturnMessage
                                        ,pt_i_OracleError       => NULL
                                        );
                                   --
                              END IF; --** IF gvv_ReturnStatus <> 'S'
                              --
                         END IF; --** IF vb_CallExtension
                         --
                    END IF; --** IF SubExtensions_cur%NOTFOUND
                    --
               END LOOP; --** WHILE vb_CallNextExtInSequence LOOP
               --
               gvv_ProgressIndicator := '0130';
               --
               CLOSE SubExtensions_cur;
               --
               IF   NOT vb_ExtensionsDefined
               THEN
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => SubEntity_rec.sub_entity
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => pt_i_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '      - No "'
                                                  ||SubEntity_rec.sub_entity
                                                  ||'" Sub-Entity '
                                                  ||vv_MessageExtensionType
                                                  ||' Extensions are registered.'
                         ,pt_i_OracleError       => NULL);
                    --
               ELSE
                    --
                    IF   NOT vb_EnabledExtensionsFound
                    THEN
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                              ,pt_i_Application       => pt_i_Application
                              ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                              ,pt_i_SubEntity         => SubEntity_rec.sub_entity
                              ,pt_i_FileSetID         => pt_i_FileSetID
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => pt_i_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '      - No registered "'
                                                       ||SubEntity_rec.sub_entity
                                                       ||'" Sub-Entity '
                                                       ||vv_MessageExtensionType
                                                       ||' Extensions are enabled.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                    END IF; --** IF NOT vb_EnabledExtensionsFound
                    --
               END IF; --** IF NOT vb_ExtensionsDefined
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => SubEntity_rec.sub_entity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => pt_i_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '    - "'
                                             ||SubEntity_rec.sub_entity
                                             ||'" Sub-Entity '
                                             ||vv_MessageExtensionType
                                             ||' Extensions Processing Complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
          END LOOP; --** SubEntities_cur LOOP
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => 'ALL'
               ,pt_i_FileSetID         => pt_i_FileSetID
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => pt_i_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '  - Sub-Entity '
                                        ||vv_MessageExtensionType
                                        ||' Extensions Processing Complete.'
               ,pt_i_OracleError       => NULL
               );
          --
          /*
          ***********************************************************
          ** Business Entity Level Extensions that must execute AFTER
          ** any Sub-Extensions.
          ***********************************************************
          */
          --
          vb_ExtensionsDefined      := FALSE;
          vb_EnabledExtensionsFound := FALSE;
          vb_CallNextExtInSequence  := TRUE;
          --
          gvv_ProgressIndicator := '0060';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => 'ALL'
               ,pt_i_FileSetID         => pt_i_FileSetID
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => pt_i_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '  - Processing Business Entity '
                                        ||vv_MessageExtensionType
                                        ||' Extensions (Post-Sub-Entity).'
               ,pt_i_OracleError       => NULL
               );
          --
          vb_ExtensionsDefined     := FALSE;
          vb_CallNextExtInSequence := TRUE;
          --
          gvv_ProgressIndicator := '0070';
          --
          OPEN Extensions_cur
                    (
                     pt_i_ApplicationSuite
                    ,pt_i_Application
                    ,pt_i_BusinessEntity
                    ,NULL
                    ,pt_i_Phase
                    ,'AFTER'
                    );
          --
          gvv_ProgressIndicator := '0080';
          --
          WHILE vb_CallNextExtInSequence
          LOOP
               --
               gvv_ProgressIndicator := '0090';
               --
               FETCH  Extensions_cur
               INTO   vt_ExtensionSource
                     ,vt_SchemaName        
                     ,vt_PackageName       
                     ,vt_ProcedureName     
                     ,vt_ExecutionSequence 
                     ,vt_ExecuteNextOnError
                     ,vt_EnabledFlag;  


               --
               gvv_ProgressIndicator := '0100';
               --
               IF   Extensions_cur%NOTFOUND
               THEN
                    --
                    vb_CallNextExtInSequence := FALSE;
                    --
               ELSE
                    --
                    vb_ExtensionsDefined := TRUE;
                    vb_CallExtension  := TRUE;
                    --
                    gvv_ProgressIndicator := '0110';
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => pt_i_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - Verifying '
                                                  ||vv_MessageExtensionType
                                                  ||' Extension Package "'
                                                  ||vt_SchemaName
                                                  ||'.'
                                                  ||vt_PackageName
                                                  ||'".'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    /*
                    ** Verify specified extension PACKAGE SPECIFICATION exists and is VALID.
                    */
                    --
                    gvt_ObjectStatus := get_object_status
                                             (
                                              pt_i_Owner      => vt_SchemaName
                                             ,pt_i_ObjectName => vt_PackageName
                                             ,pt_i_ObjectType => 'PACKAGE'
                                             );
                    --
                    IF   gvt_ObjectStatus = 'NOT EXIST'
                    THEN
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                              ,pt_i_Application       => pt_i_Application
                              ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                              ,pt_i_SubEntity         => 'ALL'
                              ,pt_i_FileSetID         => pt_i_FileSetID
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => gvt_Phase
                              ,pt_i_Severity          => 'ERROR'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '      - Package Specification is not installed in Schema.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         vb_CallExtension := FALSE;
                         --
                    ELSIF gvt_ObjectStatus = 'INVALID'
                    THEN
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                              ,pt_i_Application       => pt_i_Application
                              ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                              ,pt_i_SubEntity         => 'ALL'
                              ,pt_i_FileSetID         => pt_i_FileSetID
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => gvt_Phase
                              ,pt_i_Severity          => 'ERROR'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '      - Package Specification Status is INVALID.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         vb_CallExtension := FALSE;
                         --
                    END IF; --** IF gvt_ObjectStatus = 'NOT EXIST' OR 'INVALID'
                    --
                    /*
                    ** Verify specified extension PACKAGE BODY exists and is VALID.
                    */
                    --
                    gvt_ObjectStatus := get_object_status
                                             (
                                              pt_i_Owner      => vt_SchemaName
                                             ,pt_i_ObjectName => vt_PackageName
                                             ,pt_i_ObjectType => 'PACKAGE BODY'
                                             );
                    --
                    IF   gvt_ObjectStatus = 'NOT EXIST'
                    THEN
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                              ,pt_i_Application       => pt_i_Application
                              ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                              ,pt_i_SubEntity         => 'ALL'
                              ,pt_i_FileSetID         => pt_i_FileSetID
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => gvt_Phase
                              ,pt_i_Severity          => 'ERROR'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '      - Package Body is not installed in Schema.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         vb_CallExtension := FALSE;
                         --
                    ELSIF gvt_ObjectStatus = 'INVALID'
                    THEN
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                              ,pt_i_Application       => pt_i_Application
                              ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                              ,pt_i_SubEntity         => 'ALL'
                              ,pt_i_FileSetID         => pt_i_FileSetID
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => gvt_Phase
                              ,pt_i_Severity          => 'ERROR'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '      - Package Body Status is INVALID.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         vb_CallExtension := FALSE;
                         --
                    END IF; --** IF gvt_ObjectStatus = 'NOT EXIST' OR 'INVALID'
                    --
                    /*
                    ** Verify the Seeded Extension is enabled.
                    */
                    --
                    IF   vt_EnabledFlag = 'Y'
                    THEN
                         --
                         vb_EnabledExtensionsFound := TRUE;
                         --
                    ELSE
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                              ,pt_i_Application       => pt_i_Application
                              ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                              ,pt_i_SubEntity         => 'ALL'
                              ,pt_i_FileSetID         => pt_i_FileSetID
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => gvt_Phase
                              ,pt_i_Severity          => 'ERROR'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '      - Extension Procedure "'
                                                       ||vt_PackageName
                                                       ||'.'
                                                       ||vt_ProcedureName
                                                       ||'" ('
                                                       ||vt_ExtensionSource
                                                       ||') is NOT enabled.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         vb_CallExtension := FALSE;
                         --
                    END IF;
                    --
                    IF   vb_CallExtension
                    THEN
                         --
                         xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                              ,pt_i_Application       => pt_i_Application
                              ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                              ,pt_i_SubEntity         => 'ALL'
                              ,pt_i_FileSetID         => pt_i_FileSetID
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Phase             => pt_i_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '      - Calling Extension Procedure "'
                                                       ||vt_PackageName
                                                       ||'.'
                                                       ||vt_ProcedureName
                                                       ||'" ('
                                                       ||vt_ExtensionSource
                                                       ||').'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         gvv_ProgressIndicator := '0120';
                         --
                         call_extension
                              (
                               pt_i_ExtSchemaName       => vt_SchemaName
                              ,pt_i_ExtPackageName      => vt_PackageName
                              ,pt_i_ExtProcedureName    => vt_ProcedureName
                              ,pt_i_ApplicationSuite    => pt_i_ApplicationSuite
                              ,pt_i_Application         => pt_i_Application
                              ,pt_i_BusinessEntity      => pt_i_BusinessEntity
                              ,pt_i_StgPopulationMethod => pt_i_StgPopulationMethod
                              ,pt_i_FileSetID           => pt_i_FileSetID
                              ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                              ,pv_o_ReturnStatus        => gvv_ReturnStatus
                              ,pv_o_ReturnMessage       => gvt_ReturnMessage
                              );
                         --
                         IF   gvv_ReturnStatus <> 'S'
                         THEN
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                   ,pt_i_Application       => pt_i_Application
                                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                   ,pt_i_SubEntity         => 'ALL'
                                   ,pt_i_FileSetID         => pt_i_FileSetID
                                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   ,pt_i_Phase             => gvt_Phase
                                   ,pt_i_Severity          => 'ERROR'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '        - '||gvt_ReturnMessage
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                              IF   vt_ExecuteNextOnError = 'N'
                              THEN
                                   --
                                   vb_CallNextExtInSequence := FALSE;
                                   --
                                   xxmx_utilities_pkg.log_module_message
                                        (
                                         pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                        ,pt_i_Application       => pt_i_Application
                                        ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                        ,pt_i_SubEntity         => 'ALL'
                                        ,pt_i_FileSetID         => pt_i_FileSetID
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                        ,pt_i_Phase             => gvt_Phase
                                        ,pt_i_Severity          => 'NOTIFICATION'
                                        ,pt_i_PackageName       => gct_PackageName
                                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage     => '          - Execute Next On Error = ''N'' '
                                        ,pt_i_OracleError       => NULL
                                        );
                                   --
                              ELSE
                                   --
                                   xxmx_utilities_pkg.log_module_message
                                        (
                                         pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                        ,pt_i_Application       => pt_i_Application
                                        ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                        ,pt_i_SubEntity         => 'ALL'
                                        ,pt_i_FileSetID         => pt_i_FileSetID
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                        ,pt_i_Phase             => gvt_Phase
                                        ,pt_i_Severity          => 'NOTIFICATION'
                                        ,pt_i_PackageName       => gct_PackageName
                                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage     => '          - Execute Next On Error = ''Y'' '
                                        ,pt_i_OracleError       => NULL
                                        );
                                   --
                              END IF;
                              --
                         ELSE
                              --
                              xxmx_utilities_pkg.log_module_message
                                   (
                                    pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                                   ,pt_i_Application       => pt_i_Application
                                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                   ,pt_i_SubEntity         => 'ALL'
                                   ,pt_i_FileSetID         => pt_i_FileSetID
                                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                   ,pt_i_Phase             => gvt_Phase
                                   ,pt_i_Severity          => 'NOTIFICATION'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '        - '||gvt_ReturnMessage
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                         END IF; --** IF gvv_ReturnStatus <> 'S'
                         --
                    END IF; --** IF vb_CallExtension
                    --
               END IF; --** IF Extension_cur%NOTFOUND
               --
          END LOOP; --** WHILE vb_CallNextExtInSequence LOOP
          --
          gvv_ProgressIndicator := '0130';
          --
          CLOSE Extensions_cur;
          --
          IF   NOT vb_ExtensionsDefined
          THEN
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                    ,pt_i_Application       => pt_i_Application
                    ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                    ,pt_i_SubEntity         => 'ALL'
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Phase             => pt_i_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '    - No Business Entity '
                                             ||vv_MessageExtensionType
                                             ||' Extensions (Post-Sub-Entity) are registered.'
                    ,pt_i_OracleError       => NULL);
               --
          ELSE
               --
               IF   NOT vb_EnabledExtensionsFound
               THEN
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => pt_i_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '  - No registered Business Entity '
                                                  ||vv_MessageExtensionType
                                                  ||' Extensions (Post-Sub-Entity) are enabled.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
               END IF; --** IF NOT vb_EnabledExtensionsFound
               --
          END IF; --** IF NOT vb_ExtensionsDefined
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => 'ALL'
               ,pt_i_FileSetID         => pt_i_FileSetID
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => pt_i_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '  - Business Entity '
                                        ||vv_MessageExtensionType
                                        ||' Extensions (Post-Sub-Entity) Processing Complete.'
               ,pt_i_OracleError       => NULL
               );
          --
          /*
          ** End of Seeded Extension Processing
          */
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => 'ALL'
               ,pt_i_FileSetID         => pt_i_FileSetID
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Phase             => pt_i_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||'" complete.'
               ,pt_i_OracleError       => NULL
               );
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    ROLLBACK;
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'ERROR'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END e_ModuleError Exception
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                         ,pt_i_SubEntity         => 'ALL'
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END execute_extension;
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
                     pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
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
                      ,LOWER(xmm.ENTITY_PACKAGE_NAME)    AS stg_population_package
                      ,LOWER(xmm.stg_procedure_name)  AS stg_population_procedure
               FROM    xxmx_migration_metadata  xmm
               WHERE   1 = 1
               AND     xmm.application_suite      = pt_ApplicationSuite
               AND     xmm.application            = pt_Application
               AND     xmm.business_entity        = pt_BusinessEntity
               AND     NVL(xmm.enabled_flag, 'N') = 'Y'
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
                                            ||gct_PackageName
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
                                            ||gct_PackageName
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
                                            ||gct_PackageName
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
                                                 ||gct_PackageName
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
                                            ||gct_PackageName
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
                         ,pt_i_PackageName       => gct_PackageName
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
                              ,pt_i_PackageName         => gct_PackageName
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
                              ,pt_i_PackageName         => gct_PackageName
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
                              ,pt_i_PackageName         => gct_PackageName
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
                              ,pt_i_PackageName         => gct_PackageName
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
                                   ,pt_i_PackageName         => gct_PackageName
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
                              gvc_SQLStatement := 'BEGIN '
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
                                   ,pt_i_PackageName         => gct_PackageName
                                   ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage       => SUBSTR(
                                                                       '      - Generated SQL Statement: ' ||gvc_SQLStatement
                                                                      ,1
                                                                      ,4000
                                                                      )
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                              EXECUTE IMMEDIATE gvc_SQLStatement
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
                                         pt_i_ApplicationSuite    => gct_XXMXApplicationSuite
                                        ,pt_i_Application         => gct_XXMXApplication
                                        ,pt_i_BusinessEntity      => gct_CoreBusinessEntity
                                        ,pt_i_SubEntity           => gct_Coresubentity
                                        ,pt_i_FileSetID           => vt_FileSetID
                                        ,pt_i_MigrationSetID      => vt_MigrationSetID
                                        ,pt_i_Phase               => gvt_Phase
                                        ,pt_i_Severity            => 'ERROR'
                                        ,pt_i_PackageName         => gct_PackageName
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
                                        ,pt_i_PackageName         => gct_PackageName
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
                              ,pt_i_PackageName         => gct_PackageName
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
                                   ,pt_i_SubEntity           => gct_CoreSubEntity
                                   ,pt_i_FileSetID           => vt_FileSetID
                                   ,pt_i_MigrationSetID      => vt_MigrationSetID
                                   ,pt_i_Phase               => gvt_Phase
                                   ,pt_i_Severity            => 'ERROR'
                                   ,pt_i_PackageName         => gct_PackageName
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
                              ** "EXECUTE_EXTENSION" and "execute_custom_extensions".
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
                                   ,pt_i_PackageName         => gct_PackageName
                                   ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage       => '  - Calling Extension handler for Seeded Extensions:'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                              EXECUTE_EXTENSION
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
                                         pt_i_ApplicationSuite    => gct_XXMXApplicationSuite
                                        ,pt_i_Application         => gct_XXMXApplication
                                        ,pt_i_BusinessEntity      => vt_BusinessEntity
                                        ,pt_i_SubEntity           => 'ALL'
                                        ,pt_i_FileSetID           => vt_FileSetID
                                        ,pt_i_MigrationSetID      => vt_MigrationSetID
                                        ,pt_i_Phase               => gvt_Phase
                                        ,pt_i_Severity            => 'ERROR'
                                        ,pt_i_PackageName         => gct_PackageName
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
                                   ,pt_i_PackageName         => gct_PackageName
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
                                   ,pt_i_PackageName         => gct_PackageName
                                   ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage       => '  - Calling Extension handler for Custom Extensions:'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                              EXECUTE_EXTENSION
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
                                        ,pt_i_PackageName         => gct_PackageName
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
                               pt_i_ApplicationSuite  => GCT_XXMXAPPLICATIONSUITE
                              ,pt_i_Application       => gct_XXMXApplication
                              ,pt_i_BusinessEntity    => pt_i_BusinessEntity
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
                                   ,pt_i_PackageName         => gct_PackageName
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
                                   ,pt_i_PackageName         => gct_PackageName
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
                                        ,pt_i_PackageName         => gct_PackageName
                                        ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage       => '    - Calling Procedure "'
                                                                     ||SubEntityMetadata_rec.stg_population_package
                                                                     ||'.'
                                                                     ||SubEntityMetadata_rec.stg_population_procedure
                                                                     ||'" for Sub-Entity "'
                                                                     ||SubEntityMetadata_rec.sub_entity
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
                                   gvc_SQLStatement := 'BEGIN '
                                                     ||SubEntityMetadata_rec.stg_population_package
                                                     ||'.'
                                                     ||SubEntityMetadata_rec.stg_population_procedure
                                                     ||gcv_SQLSpace
                                                     ||'('
                                                     ||'pt_i_ApplicationSuite => '''
                                                     ||vt_ApplicationSuite
                                                     ||''''
                                                     ||', pt_i_Application => '''
                                                     ||vt_Application
                                                     ||''''
                                                     ||', pt_i_BusinessEntity => '''
                                                     ||vt_BusinessEntity
                                                     ||''''
                                                     ||', pt_i_SubEntity => '''
                                                     ||SubEntityMetadata_rec.sub_entity
                                                     ||''''
                                                     ||', pt_i_MigrationSetID => '
                                                     ||vt_MigrationSetID
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
                                        ,pt_i_PackageName         => gct_PackageName
                                        ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage       => SUBSTR(
                                                                            '      - Generated SQL Statement: ' ||gvc_SQLStatement
                                                                           ,1
                                                                           ,4000
                                                                           )
                                        ,pt_i_OracleError         => NULL
                                        );
                                   --
                                   EXECUTE IMMEDIATE gvc_SQLStatement;
                                   --
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
                                   ,pt_i_PackageName         => gct_PackageName
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
                              ** "EXECUTE_EXTENSION" and "execute_custom_extensions".
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
                                   ,pt_i_PackageName         => gct_PackageName
                                   ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage       => '  - Calling Extension handler for Seeded Extensions:'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                              EXECUTE_EXTENSION
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
                                         pt_i_ApplicationSuite    => gct_XXMXApplicationSuite
                                        ,pt_i_Application         => gct_XXMXApplication
                                        ,pt_i_BusinessEntity      => gct_CoreBusinessEntity
                                        ,pt_i_SubEntity           => gct_CoreSubEntity
                                        ,pt_i_FileSetID           => vt_FileSetID
                                        ,pt_i_MigrationSetID      => vt_MigrationSetID
                                        ,pt_i_Phase               => gvt_Phase
                                        ,pt_i_Severity            => 'ERROR'
                                        ,pt_i_PackageName         => gct_PackageName
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
                                   ,pt_i_PackageName         => gct_PackageName
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
                                   ,pt_i_PackageName         => gct_PackageName
                                   ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage       => '  - Calling Extension handler for Custom Extensions:'
                                   ,pt_i_OracleError         => NULL
                                   );
                              --
                              EXECUTE_EXTENSION
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
                                         pt_i_ApplicationSuite    => gct_XXMXApplicationSuite
                                        ,pt_i_Application         => gct_XXMXApplication
                                        ,pt_i_BusinessEntity      => gct_CoreBusinessEntity
                                        ,pt_i_SubEntity           => gct_CoreSubEntity
                                        ,pt_i_FileSetID           => vt_FileSetID
                                        ,pt_i_MigrationSetID      => vt_MigrationSetID
                                        ,pt_i_Phase               => gvt_Phase
                                        ,pt_i_Severity            => 'ERROR'
                                        ,pt_i_PackageName         => gct_PackageName
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
                                   ,pt_i_PackageName         => gct_PackageName
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
                         ,pt_i_PackageName       => gct_PackageName
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
               ,pt_i_BusinessEntity      => vt_BusinessEntity
               ,pt_i_SubEntity           => gct_CoreSubEntity
               ,pt_i_FileSetID           => 0
               ,pt_i_MigrationSetID      => 0
               ,pt_i_Phase               => gvt_Phase
               ,pt_i_Severity            => 'NOTIFICATION'
               ,pt_i_PackageName         => gct_PackageName
               ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               ,pt_i_ModuleMessage       => 'Procedure "'
                                            ||gct_PackageName
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
                         ,pt_i_SubEntity           => gct_CoreSubEntity
                         ,pt_i_FileSetID           => 0
                         ,pt_i_MigrationSetID      => 0
                         ,pt_i_Phase               => gvt_Phase
                         ,pt_i_Severity            => gvt_Severity
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => gvt_ModuleMessage
                         ,pt_i_OracleError         => NULL
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
                         ,pt_i_BusinessEntity      => vt_BusinessEntity
                         ,pt_i_SubEntity           => gct_CoreSubEntity
                         ,pt_i_FileSetID           => 0
                         ,pt_i_MigrationSetID      => 0
                         ,pt_i_Phase               => gvt_Phase
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => gct_PackageName
                         ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => 'Oracle error encounted after Progress Indicator.'
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
     END stg_main;
     --
     --
     /*
     **********************
     ** PROCEDURE: xfm_main
     **********************
     */
     --
     --
     --
     /*
     **********************************
     ** PROCEDURE: log_purge_message
     **
     ** Called from the Dynamic SQL
     ** purge procedure.
     **
     ** Although this procedure does
     ** not include any Dynmaic SQL
     ** itself it is included in the
     ** Dynamic SQL Package as that is
     ** where the Purge procedure
     (( resides.
     **********************************
     */
     --
     PROCEDURE log_purge_message
                    (
                     pt_i_ApplicationSuite           IN      xxmx_purge_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_purge_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_purge_messages.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_purge_messages.sub_entity%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_purge_messages.migration_set_id%TYPE
                    ,pt_i_Severity                   IN      xxmx_purge_messages.severity%TYPE
                    ,pt_i_ProgressIndicator          IN      xxmx_purge_messages.progress_indicator%TYPE
                    ,pt_i_PurgeMessage               IN      xxmx_purge_messages.purge_message%TYPE
                    ,pt_i_OracleError                IN      xxmx_purge_messages.oracle_error%TYPE
                    )
        IS
          --
          PRAGMA AUTONOMOUS_TRANSACTION;
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
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
          --
          --************************
          --** Variable Declarations
          --************************
          --
          --
          --*************************
          --** Exception Declarations
          --*************************
          --
          e_ModuleError                   EXCEPTION;
          --
     --** END Declarations **
     --
     BEGIN
          --
          --** Insert module message record.
          --
          IF   LENGTH(pt_i_ApplicationSuite) > 5
          THEN
               --
               gvt_ModuleMessage := 'pt_i_ApplicationSuite parameter must be 5 characters or less.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          IF   LENGTH(pt_i_Application) > 5
          THEN
               --
               gvt_ModuleMessage := 'pt_i_Application parameter must be 5 characters or less.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          IF   UPPER(pt_i_Severity) NOT IN ('NOTIFICATION', 'WARNING', 'ERROR')
          THEN
               --
               gvt_ModuleMessage := 'pt_i_Severity parameter must be "NOTIFICATION,", "WARNING" or "ERROR".';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          INSERT
          INTO   xxmx_purge_messages
                 (
                  purge_message_id
                 ,application_suite
                 ,application
                 ,business_entity
                 ,sub_entity
                 ,file_set_id
                 ,migration_set_id
                 ,message_timestamp
                 ,severity
                 ,progress_indicator
                 ,purge_message
                 ,oracle_error
                 )
          VALUES
                 (
                  xxmx_purge_message_ids_s.NEXTVAL   -- purge_message_id
                 ,UPPER(pt_i_ApplicationSuite)       -- application_suite
                 ,UPPER(pt_i_Application)            -- application
                 ,UPPER(pt_i_BusinessEntity)         -- business_entity
                 ,UPPER(pt_i_SubEntity)              -- sub_entity
                 ,pt_i_FileSetID                     -- file_set_id
                 ,pt_i_MigrationSetID                -- migration_set_id
                 ,LOCALTIMESTAMP(3)                  -- message_timestamp
                 ,UPPER(pt_i_Severity)               -- severity
                 ,pt_i_ProgressIndicator             -- progress_indicator
                 ,pt_i_PurgeMessage                  -- purge_message
                 ,pt_i_OracleError                   -- oracle_error
                 );
          --
          COMMIT;
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    gvt_OracleError := NULL;
                    --
                    INSERT
                    INTO   xxmx_purge_messages
                           (
                            purge_message_id
                           ,application_suite
                           ,application
                           ,business_entity
                           ,sub_entity
                           ,file_set_id
                           ,migration_set_id
                           ,message_timestamp
                           ,severity
                           ,progress_indicator
                           ,purge_message
                           ,oracle_error
                           )
                    VALUES
                           (
                            xxmx_purge_message_ids_s.NEXTVAL   -- module_message_id
                           ,gct_XXMXApplicationSuite           -- application_suite
                           ,gct_XXMXApplication                -- application
                           ,gct_CoreBusinessEntity             -- business_entity
                           ,gct_CoreSubEntity                  -- sub_entity
                           ,pt_i_FileSetID                     -- file_set_id
                           ,pt_i_MigrationSetID                -- migration_set_id
                           ,LOCALTIMESTAMP(3)                  -- message_timestamp
                           ,'ERROR'                            -- severity
                           ,gvv_ProgressIndicator              -- progress_indicator
                           ,gvt_ModuleMessage                  -- module_message
                           ,gvt_OracleError                    -- oracle_error
                           );
                    --
                    COMMIT; --** Commit the message to the Module Messages table.
                    --
                    gvv_ApplicationErrorMessage := SUBSTR('"e_ModuleError" Exception raised after Progress Indicator "'
                                                       ||gct_PackageName
                                                       ||'.log_purge_message'
                                                       ||'-'
                                                       ||gvv_ProgressIndicator
                                                       ||'".  Please refer to XXMX_PURGE_MESSAGES table for further details.'
                                                        ,1
                                                        ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END e_ModuleError Exception
               --
               WHEN OTHERS
               THEN
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    INSERT
                    INTO   xxmx_purge_messages
                           (
                            purge_message_id
                           ,application_suite
                           ,application
                           ,business_entity
                           ,sub_entity
                           ,migration_set_id
                           ,message_timestamp
                           ,severity
                           ,progress_indicator
                           ,purge_message
                           ,oracle_error
                           )
                    VALUES
                           (
                            xxmx_purge_message_ids_s.NEXTVAL                      -- module_message_id
                           ,gct_XXMXApplicationSuite                              -- application_suite
                           ,gct_XXMXApplication                                   -- application
                           ,gct_CoreBusinessEntity                                -- business_entity
                           ,gct_CoreSubEntity                                     -- sub_entity
                           ,pt_i_MigrationSetID                                   -- migration_set_id
                           ,LOCALTIMESTAMP(3)                                     -- message_timestamp
                           ,'ERROR'                                               -- severity
                           ,gvv_ProgressIndicator                                 -- progress_indicator
                           ,'Oracle error encountered after Progress Indicator.'  -- module_message
                           ,gvt_OracleError                                       -- oracle_error
                           );
                    --
                    COMMIT; --** Commit the message to the Module Messages table.
                    --
                    gvv_ApplicationErrorMessage := SUBSTR('Unexpected Oracle Exception encountered after Progress Indicator "'
                                                       ||gct_PackageName
                                                       ||'.log_purge_message'
                                                       ||'-'
                                                       ||gvv_ProgressIndicator
                                                       ||'".  Please refer to XXMX_PURGE_MESSAGES table for further details.'
                                                        ,1
                                                        ,2048
                                                         );
                    --
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END log_purge_message;
     --
     --
     /*
     **********************************
     ** PROCEDURE: purge_migration_data
     **********************************
     */
     --
     PROCEDURE purge_migration_data
                    (
                     pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_i_PurgeClientData            IN      VARCHAR2 DEFAULT 'N'
                    ,pv_i_PurgeModuleMessages        IN      VARCHAR2 DEFAULT 'N'
                    ,pv_i_PurgeDataMessages          IN      VARCHAR2 DEFAULT 'N'
                    ,pv_i_PurgeControlTables         IN      VARCHAR2 DEFAULT 'N'
                    )
     IS
          --
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
          CURSOR PurgingMetadata_cur
                      (
                       pt_BusinessEntity               xxmx_migration_metadata.business_entity%TYPE
                      )
          IS
               --
               --
               SELECT  xst.schema_name
                      ,xst.table_name
                      ,xst.purge_flag
                      ,'STG'                    AS table_type
                      ,'XXMX_STG_TABLES'        AS data_dictionary_table
                      ,1                        AS order_by
               FROM    xxmx_migration_metadata  xmd
                      ,xxmx_stg_tables          xst
               WHERE   1 = 1
               AND     xmd.business_entity   = pt_BusinessEntity
               AND     xst.metadata_id       = xmd.metadata_id
               UNION
               SELECT  xxt.schema_name
                      ,xxt.table_name
                      ,xxt.purge_flag
                      ,'XFM'                    AS table_type
                      ,'XXMX_XFM_TABLES'        AS data_dictionary_table
                      ,2                        AS order_by
               FROM    xxmx_migration_metadata  xmd
                      ,xxmx_xfm_tables          xxt
               WHERE   1 = 1
               AND     xmd.business_entity   = pt_BusinessEntity
               AND     xxt.metadata_id       = xmd.metadata_id
               ORDER BY 6,2;
               --
               --
          --** END CURSOR PurgingMetadata_cur
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
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_PurgeScopeMessage            xxmx_purge_messages.purge_message%TYPE;
          vv_PurgeTableName               VARCHAR2(260); --** Holds combination of Schema and Table Name both of which can be 128 chars in R12.2 database.
          VT_STGPOPULATIONMETHOD          xxmx_core_parameters.parameter_value%TYPE;
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
     --** END Declarations **
     --
     --
     BEGIN
          --
          gvt_Phase := 'PURGE';
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
               --RAISE e_ModuleError;
               --
          ELSE
               --
               /*
               ** Construct reusable parts of Dynamic SQL for DELETE action.
               **
               ** There WHERE clauses will be constructed dependant the the Data Set ID parameters
               ** and STG Population Method.
               */
               --
               gvv_SQLAction1 := 'DELETE';
               --
               /*
               ** The Value assigned to the STG_POPULATION_METHOD parameter is validated in the "VALID_INSTALL" function
               ** so we do not need to validate it again here.
               */
               --
               vt_StgPopulationMethod := xxmx_utilities_pkg.get_core_parameter_value
                                              (
                                               pt_i_ParameterCode => 'STG_POPULATION_METHOD'
                                              );
               --
               gvv_ProgressIndicator := '0020';
               IF   vt_StgPopulationMethod = 'DATA_FILE'
               THEN
                    --
                    /*
                    ** Data loaded from file must be grouped by a Client provided File Set ID which is loaded
                    ** with their data into the STG tables.
                    **
                    ** Maximise procedures which process the Client Data will log messages using the File Set ID.
                    **
                    ** Data loaded from file will not have progressed any further than STG table pre-validation
                    ** if ANY pre-validation failed.  In such cases, the data will not have a Migration Set ID
                    ** only a File Set ID.  This also applies to Log and Data Messages being issued by the STG_MAIN
                    ** procedure and the pre-validation Dynamic SQL procedure.
                    **
                    ** However, if all pre-validation is passed, a Migration Set ID will have been generated and
                    ** the STG tables updated with it.  Subsequent messages written to the Module and Data Message
                    ** tables will have one or the other or both.
                    */
                    --
                    IF   pt_i_BusinessEntity IS NULL
                    AND  pt_i_FileSetID      IS NULL
                    THEN
                         --
                         gvt_Severity      := 'ERROR';

                         gvt_ModuleMessage := '- "pt_i_BusinessEntity" and "pt_i_FileSetID" parameters are mandatory '
                                            ||'in call to '
                                            ||gct_PackageName
                                            ||'.'
                                            ||ct_ProcOrFuncName
                                            ||'" when the STG_POPULATION_METHOD core parameter value is "'
                                            ||vt_StgPopulationMethod
                                            ||'".  The "pt_i_MigrationSetID" parameter is optional.';
                         --
                         RAISE e_ModuleError;
                         --
                    ELSE
                         --
                         IF   pt_i_FileSetID      IS NOT NULL
                         AND  pt_i_MigrationSetID IS NOT NULL
                         THEN
                              --
                              gvv_SQLWhereClause := 'WHERE 1 = 1 '
                                                  ||'AND   (migration_set_id = '
                                                  ||pt_i_MigrationSetID
                                                  ||' OR file_set_id = '
                                                  ||pt_i_FileSetID
                                                  ||')';
                              --
                              vt_PurgeScopeMessage := '  - Purging Migration Data for Business Entity "'
                                                    ||pt_i_BusinessEntity
                                                    ||'" and File Set ID "'
                                                    ||pt_i_FileSetID
                                                    ||'" or Migration Set ID "'
                                                    ||pt_i_MigrationSetID
                                                    ||'".';
                              --
                         ELSIF pt_i_FileSetID      IS NOT NULL
                         AND   pt_i_MigrationSetID IS NULL
                         THEN
                              --
                              gvv_SQLWhereClause := 'WHERE 1 = 1 '
                                                  ||'AND   file_set_id = '
                                                  ||pt_i_FileSetID;
                              --
                              vt_PurgeScopeMessage := '  - Purging Migration Data for Business Entity "'
                                                    ||pt_i_BusinessEntity
                                                    ||'" and File Set ID "'
                                                    ||pt_i_FileSetID
                                                    ||'".';
                         --
                         ELSE
                              --
                              gvv_SQLWhereClause := 'WHERE 1 = 1 '
                                                  ||'AND   migration_set_id = '
                                                  ||pt_i_MigrationSetID;
                              vt_PurgeScopeMessage := '  - Purging Migration Data for Business Entity "'
                                                    ||pt_i_BusinessEntity
                                                    ||'" and Migration Set ID "'
                                                    ||pt_i_MigrationSetID
                                                    ||'".';
                              --
                              --
                         END IF;
                         --
                    END IF;
                    --
               ELSE /* STG_POPULATION_METHOD_PARAMETER is "DB_LINK" */
                    --
                    /*
                    ** Data extracted by Maximise PL/SQL procedures via DB Link will have the Migration Set ID
                    ** pre-generated before the data is inserted into the STG tables so these tables can be purged
                    ** by Migration Set ID.
                    **
                    ** However, some Log Messages are issued by STG_MAIN before the Migration Set ID has been
                    ** generated and these are inserted with a Migration Set ID of 0.  These must also be included
                    ** in the purge process.
                    */
                    --
                    gvv_ProgressIndicator := '0030';
                    IF   pt_i_BusinessEntity IS  NULL
                    AND  pt_i_MigrationSetID IS  NULL
                    THEN
                         --
                         gvt_Severity      := 'ERROR';
                         gvt_ModuleMessage := '- "pt_i_BusinessEntity" and "pt_i_MigrationSetID" parameters are mandatory '
                                            ||'in call to '
                                            ||gct_PackageName
                                            ||'.'
                                            ||ct_ProcOrFuncName
                                            ||'" when the STG_POPULATION_METHOD core parameter value is "'
                                            ||vt_StgPopulationMethod
                                            ||'".';
                         --
                         RAISE e_ModuleError;
                         --
                    END IF;
                    --
               END IF; --** IF vt_StgPopulationMethod = 'DATA_FILE' OR 'DB_LINK'
               --
               gvv_ProgressIndicator := '0040';
               --
               /*log_purge_message
                    (
                     pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                    ,pt_i_Application       => gct_XXMXApplication
                    ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                    ,pt_i_SubEntity         => ct_SubEntity
                    ,pt_i_FileSetID         => pt_i_FileSetID
                    ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_PurgeMessage      => 'Procedure "'
                                              ||gct_PackageName
                                              ||'.'
                                              ||ct_ProcOrFuncName
                                              ||'" initiated.'
                    ,pt_i_OracleError       => NULL
                    );*/
               --
               IF   pv_i_PurgeClientData     = 'Y'
               OR   pv_i_PurgeModuleMessages = 'Y'
               OR   pv_i_PurgeDataMessages   = 'Y'
               OR   pv_i_PurgeControlTables  = 'Y'
               THEN
                    --
                    gvv_ProgressIndicator := '0050';
                    --
                    /*log_purge_message
                        (
                         pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                        ,pt_i_Application       => gct_XXMXApplication
                        ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                        ,pt_i_SubEntity         => ct_SubEntity
                        ,pt_i_FileSetID         => pt_i_FileSetID
                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                        ,pt_i_Severity          => 'NOTIFICATION'
                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                        ,pt_i_PurgeMessage      => NULL
                        ,pt_i_OracleError       => NULL
                        );*/
                    --
                    /*
                    ** Evaluate Purge Flags
                    */
                    --
                    IF   pv_i_PurgeClientData = 'Y'
                    THEN
                         --
                         NULL;
                         /*log_purge_message
                              (
                               pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                              ,pt_i_Application       => gct_XXMXApplication
                              ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                              ,pt_i_SubEntity         => ct_SubEntity
                              ,pt_i_FileSetID         => pt_i_FileSetID
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_PurgeMessage      => '    - Purging Client Migration Data from STG and XFM tables.'
                              ,pt_i_OracleError       => NULL
                              );*/
                         --
                         /*
                         ** Loop through the Migration Metadata table to retrieve
                         ** the staging table names to purge for the current Business
                         ** Entity.
                         */
                         --
                         FOR  PurgingMetadata_rec
                         IN   PurgingMetadata_cur
                                   (
                                    pt_i_BusinessEntity
                                   )
                         LOOP
                              --
                              IF   PurgingMetadata_rec.purge_flag = 'Y'
                              THEN
                                   --

                                 /*  log_purge_message
                                        (
                                         pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                                        ,pt_i_Application       => gct_XXMXApplication
                                        ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                                        ,pt_i_SubEntity         => ct_SubEntity
                                        ,pt_i_FileSetID         => pt_i_FileSetID
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                        ,pt_i_Severity          => 'NOTIFICATION'
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_PurgeMessage      => '      - Purging data from '
                                                                 ||PurgingMetadata_rec.table_type
                                                                 ||' table "'
                                                                 ||PurgingMetadata_rec.schema_name
                                                                 ||'.'
                                                                 ||PurgingMetadata_rec.table_name
                                                                 ||'" for Migration Set ID '
                                                                 ||pt_i_MigrationSetID
                                                                 ||'.'
                                        ,pt_i_OracleError       => NULL
                                        );*/
                                   --
                                   gvv_SQLTableClause := 'FROM '
                                                       ||PurgingMetadata_rec.schema_name
                                                       ||'.'
                                                       ||PurgingMetadata_rec.table_name;
                                   --
                                   --
                                   gvc_SQLStatement := gvv_SQLAction1
                                                     ||gcv_SQLSpace
                                                     ||gvv_SQLTableClause
                                                     ||gcv_SQLSpace
                                                     ||gvv_SQLWhereClause;
                                   --
                                   EXECUTE IMMEDIATE gvc_SQLStatement;
                                   --
                                   gvn_RowCount := SQL%ROWCOUNT;
                                   --
/*                                   log_purge_message
                                        (
                                         pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                                        ,pt_i_Application       => gct_XXMXApplication
                                        ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                                        ,pt_i_SubEntity         => ct_SubEntity
                                        ,pt_i_FileSetID         => pt_i_FileSetID
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                        ,pt_i_Severity          => 'NOTIFICATION'
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_PurgeMessage      => '      - Records purged from "'
                                                                 ||PurgingMetadata_rec.table_type
                                                                 ||' table "'
                                                                 ||PurgingMetadata_rec.schema_name
                                                                 ||'.'
                                                                 ||PurgingMetadata_rec.table_name
                                                                 ||'" : '
                                                                 ||gvn_RowCount
                                        ,pt_i_OracleError        => NULL
                                        );*/
                                   --
                              ELSE
                                   --
                                   /*log_purge_message
                                        (
                                         pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                                        ,pt_i_Application       => gct_XXMXApplication
                                        ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                                        ,pt_i_SubEntity         => ct_SubEntity
                                        ,pt_i_FileSetID         => pt_i_FileSetID
                                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                        ,pt_i_Severity          => 'NOTIFICATION'
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_PurgeMessage      => '      - Purging is disabled for '
                                                                 ||PurgingMetadata_rec.table_type
                                                                 ||' table "'
                                                                 ||PurgingMetadata_rec.schema_name
                                                                 ||'.'
                                                                 ||PurgingMetadata_rec.table_name
                                                                 ||'".  This can be enabled by updating the PURGE_FLAG '
                                                                 ||'column to ''Y'' in the "'
                                                                 ||PurgingMetadata_rec.data_dictionary_table
                                                                 ||'" table.'
                                        ,pt_i_OracleError       => NULL
                                        );*/
                                        NULL;
                                   --
                              END IF; --** IF PurgingMetadata_rec.purge_flag = 'Y'
                              --
                         END LOOP; --** PurgingMetadata_cur LOOP
                         --
                    END IF; --** IF pv_i_PurgeClientData := 'Y'
                    --
                    IF   pv_i_PurgeControlTables = 'Y'
                    THEN
                         --
                         NULL;
                       /*  log_purge_message
                              (
                               pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                              ,pt_i_Application       => gct_XXMXApplication
                              ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                              ,pt_i_SubEntity         => ct_SubEntity
                              ,pt_i_FileSetID         => pt_i_FileSetID
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_PurgeMessage      => '    - Purging Control Table Data.'
                              ,pt_i_OracleError       => NULL
                              );*/
                         --
                         /*
                         ** Purge the records for the Business Entity Levels
                         ** Levels from the Migration Details table.
                         */
                         --
                         vv_PurgeTableName := gct_CoreSchema
                                            ||'.'
                                            ||'xxmx_migration_details';
                         --
                         gvv_SQLTableClause := 'FROM '
                                             ||vv_PurgeTableName;
                         --
                         gvc_SQLStatement := gvv_SQLAction1
                                           ||gcv_SQLSpace
                                           ||gvv_SQLTableClause
                                           ||gcv_SQLSpace
                                           ||gvv_SQLWhereClause;
                         --
                         EXECUTE IMMEDIATE gvc_SQLStatement;
                         --
/*                         log_purge_message
                              (
                               pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                              ,pt_i_Application       => gct_XXMXApplication
                              ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                              ,pt_i_SubEntity         => ct_SubEntity
                              ,pt_i_FileSetID         => pt_i_FileSetID
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_PurgeMessage      => '      - Table "'
                                                        ||vv_PurgeTableName
                                                        ||'" purged.'
                              ,pt_i_OracleError       => NULL
                              );*/
                         --
                         /*
                         ** Purge the records for the Business Entity
                         ** from the Migration Headers table.
                         */
                         --
                         vv_PurgeTableName := gct_CoreSchema
                                            ||'.'
                                            ||'xxmx_migration_headers';
                         --
                         gvv_SQLTableClause := 'FROM '
                                             ||vv_PurgeTableName;
                         --
                         gvc_SQLStatement := gvv_SQLAction1
                                           ||gcv_SQLSpace
                                           ||gvv_SQLTableClause
                                           ||gcv_SQLSpace
                                           ||gvv_SQLWhereClause;
                         --
                         EXECUTE IMMEDIATE gvc_SQLStatement;
                         --
                         log_purge_message
                              (
                               pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                              ,pt_i_Application       => gct_XXMXApplication
                              ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                              ,pt_i_SubEntity         => ct_SubEntity
                              ,pt_i_FileSetID         => pt_i_FileSetID
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_PurgeMessage      => '      - Table "'
                                                        ||vv_PurgeTableName
                                                        ||'" purged.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                    END IF; --** IF pt_i_PurgeControlTables := 'Y'
                    --
                    IF   pv_i_PurgeModuleMessages = 'Y'
                    THEN
                         --
                         NULL;
                        /* log_purge_message
                              (
                               pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                              ,pt_i_Application       => gct_XXMXApplication
                              ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                              ,pt_i_SubEntity         => ct_SubEntity
                              ,pt_i_FileSetID         => pt_i_FileSetID
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_PurgeMessage      => '    - Purging Module Message Table Data.'
                              ,pt_i_OracleError       => NULL
                              );*/
                         --
                         /*
                         ** Purge the records for the Business Entity
                         ** from the Migration Headers table.
                         */
                         --
                         vv_PurgeTableName := gct_CoreSchema
                                            ||'.'
                                            ||'xxmx_module_messages';
                         --
                         gvv_SQLTableClause := 'FROM '
                                             ||vv_PurgeTableName;
                         --
                         gvc_SQLStatement := gvv_SQLAction1
                                           ||gcv_SQLSpace
                                           ||gvv_SQLTableClause
                                           ||gcv_SQLSpace
                                           ||gvv_SQLWhereClause;
                         --
                         EXECUTE IMMEDIATE gvc_SQLStatement;
                         --
                       /*  log_purge_message
                              (
                               pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                              ,pt_i_Application       => gct_XXMXApplication
                              ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                              ,pt_i_SubEntity         => ct_SubEntity
                              ,pt_i_FileSetID         => pt_i_FileSetID
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_PurgeMessage      => '      - Table purged.'
                              ,pt_i_OracleError       => NULL
                              );*/
                         --
                    END IF; --** IF pv_i_PurgeModuleMessages = 'Y'
                    --
                    IF   pv_i_PurgeDataMessages = 'Y'
                    THEN
                         --
                         log_purge_message
                              (
                               pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                              ,pt_i_Application       => gct_XXMXApplication
                              ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                              ,pt_i_SubEntity         => ct_SubEntity
                              ,pt_i_FileSetID         => pt_i_FileSetID
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_PurgeMessage      => '    - Purging Data Message Table Data.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                         /*
                         ** Purge the records for the Business Entity
                         ** from the Migration Headers table.
                         */
                         --
                         vv_PurgeTableName := gct_CoreSchema
                                            ||'.'
                                            ||'xxmx_data_messages';
                         --
                         gvv_SQLTableClause := 'FROM '
                                             ||vv_PurgeTableName;
                         --
                         gvc_SQLStatement := gvv_SQLAction1
                                           ||gcv_SQLSpace
                                           ||gvv_SQLTableClause
                                           ||gcv_SQLSpace
                                           ||gvv_SQLWhereClause;
                         --
                         EXECUTE IMMEDIATE gvc_SQLStatement;
                         --
                         log_purge_message
                              (
                               pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                              ,pt_i_Application       => gct_XXMXApplication
                              ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                              ,pt_i_SubEntity         => ct_SubEntity
                              ,pt_i_FileSetID         => pt_i_FileSetID
                              ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_PurgeMessage      => '      - Table purged.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                    END IF; --** IF pv_i_PurgeDataMessages = 'Y'
                    --
                    COMMIT;
                    --
                    log_purge_message
                         (
                          pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                         ,pt_i_Application       => gct_XXMXApplication
                         ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_PurgeMessage      => '  - Purge complete.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
               ELSE
                    --
                    log_purge_message
                         (
                          pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                         ,pt_i_Application       => gct_XXMXApplication
                         ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_PurgeMessage      => '  - No Purge Flag parameters are set to ''Y'' so no purge will be performed.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
               END IF;
               --
          END IF; --** IF NOT xxmx_utilities_pkg.valid_install
          --
          log_purge_message
               (
                pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
               ,pt_i_Application       => gct_XXMXApplication
               ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
               ,pt_i_SubEntity         => ct_SubEntity
               ,pt_i_FileSetID         => pt_i_FileSetID
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_PurgeMessage      => 'Procedure "'
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
                    log_purge_message
                         (
                          pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                         ,pt_i_Application       => gct_XXMXApplication
                         ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_PurgeMessage      => gvt_ModuleMessage
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
                    log_purge_message
                         (
                          pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                         ,pt_i_Application       => gct_XXMXApplication
                         ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                         ,pt_i_SubEntity         => ct_SubEntity
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_PurgeMessage      => 'Oracle error encounted after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
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
     END purge_migration_data;

     --
     --
     /*
     **********************************
     ** PROCEDURE: Generate_Ctl - Control File Generation
     **********************************
     */

    PROCEDURE generate_ctl(  pt_i_ApplicationSuite           IN      xxmx_migration_metadata.application_suite%TYPE
                             ,pt_i_Application                IN      xxmx_migration_metadata.application%TYPE
                             ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                             ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                             ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                             ,pv_o_ReturnStatus               OUT  VARCHAR2)

    IS 


         --
         --
         --**********************
         --** Cursor Declarations
         --**********************
         --
         CURSOR cur_ctllist
         IS 
         SELECT UPPER(stg_table) table_name
         FROM xxmx_core.xxmx_migration_metadata
         WHERE application =pt_i_Application
         AND application_suite = pt_i_ApplicationSuite
         and business_entity= pt_i_BusinessEntity
         and sub_entity= pt_i_SubEntity
         AND stg_table IS NOT NULL;

         --**********************
         --** Record Declarations
         --**********************
         --
         --
         --************************
         --** Constant Declarations
         --************************
         --
         ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'Generate_ctl';
         --
         --************************
         --** Variable Declarations
         --************************
         --
         vt_StgTableID                   xxmx_stg_tables.stg_table_id%TYPE;
         vt_StgSchemaName                xxmx_stg_tables.schema_name%TYPE;
         vt_StgTableName                 xxmx_stg_tables.table_name%TYPE;
         vt_ErrorFlag                    xxmx_migration_details.error_flag%TYPE;
         vn_RowSeq                       NUMBER;
         vn_Rowid                        VARCHAR2(1000);
         ct_Phase                        xxmx_module_messages.phase%TYPE := 'EXTRACT';
         vt_OperatingUnitName            xxmx_simple_transforms.source_operating_unit_name%TYPE;
         vt_SourceValue                  xxmx_simple_transforms.source_value%TYPE;
         vt_FusionValue                  xxmx_simple_transforms.fusion_value%TYPE;
         vt_gen_what                     VARCHAR2(30) := 'CTL';


         --
         --*************************
         --** Exception Declarations
         --*************************
         --
         --
         --** END Declarations **
         --
      BEGIN 

         gvv_ProgressIndicator := '0000';



          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_FileSetID         => pt_i_FileSetID
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||' ('
                                        ||pt_i_BusinessEntity
                                        ||' / '
                                        ||pt_i_SubEntity
                                        ||') initiated.'
               ,pt_i_OracleError       => NULL
               );

         --
         /*
         ** For Client Data being loaded from Data File, this is the first Maximise
         ** process which operates on the Client Data at the Sub-Entity Level.
         **
         ** Therefore, it is this procedure what must write the initial Migration Detail
         ** record for each Sub-Entity.
         */
         --
         gvv_ProgressIndicator := '0010';
          --
         xxmx_utilities_pkg.log_module_message
              (
               pt_i_ApplicationSuite  => pt_i_ApplicationSuite
              ,pt_i_Application       => pt_i_Application
              ,pt_i_BusinessEntity    => pt_i_BusinessEntity
              ,pt_i_SubEntity         => pt_i_SubEntity
              ,pt_i_FileSetID         => pt_i_FileSetID
              ,pt_i_MigrationSetID    => 0
              ,pt_i_Phase             => gvt_Phase
              ,pt_i_Severity          => 'NOTIFICATION'
              ,pt_i_PackageName       => gct_PackageName
              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
              ,pt_i_ModuleMessage     => '- Before the call for Cursor '
              ,pt_i_OracleError       => NULL
              );
         FOR rec IN cur_ctllist
         LOOP

            --
            gvv_ProgressIndicator := '0015';
            --
            xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                 ,pt_i_Application       => pt_i_Application
                 ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                 ,pt_i_SubEntity         => pt_i_SubEntity
                 ,pt_i_FileSetID         => pt_i_FileSetID
                 ,pt_i_MigrationSetID    => 0
                 ,pt_i_Phase             => gvt_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gct_PackageName
                 ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '- Before the call generate_ctl-  '
                                          ||','||pt_i_ApplicationSuite
                                          ||','||pt_i_Application
                                          ||' ,'||rec.table_name
                 ,pt_i_OracleError       => NULL
                 );

            IF vt_gen_what IN ( 'CTL') THEN

                  --
                  gvv_ProgressIndicator := '0016';
                  --
                  xxmx_utilities_pkg.log_module_message
                 (
                  pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                 ,pt_i_Application       => pt_i_Application
                 ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                 ,pt_i_SubEntity         => pt_i_SubEntity
                 ,pt_i_FileSetID         => pt_i_FileSetID
                 ,pt_i_MigrationSetID    => 0
                 ,pt_i_Phase             => gvt_Phase
                 ,pt_i_Severity          => 'NOTIFICATION'
                 ,pt_i_PackageName       => gct_PackageName
                 ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                 ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                 ,pt_i_ModuleMessage     => '- Before the call generate_ctl-  '
                                          ||','||pt_i_ApplicationSuite
                                          ||','||pt_i_Application
                                          ||' ,'||rec.table_name
                 ,pt_i_OracleError       => NULL
                 );
                 --

                 gen_ctl_script(ot_errbuf                => gvt_ReturnMessage,
                                ot_retcode               => gvv_ReturnCode,
                                pt_i_Application         => pt_i_Application,
                                pt_object_name           => rec.table_name);

            END IF;
         END LOOP;

         COMMIT;

         gvv_ProgressIndicator := '0020';

         xxmx_utilities_pkg.log_module_message
        (
         pt_i_ApplicationSuite  => pt_i_ApplicationSuite
        ,pt_i_Application       => pt_i_Application
        ,pt_i_BusinessEntity    => pt_i_BusinessEntity
        ,pt_i_SubEntity         => pt_i_SubEntity
        ,pt_i_FileSetID         => pt_i_FileSetID
        ,pt_i_MigrationSetID    => 0
        ,pt_i_Phase             => gvt_Phase
        ,pt_i_Severity          => 'NOTIFICATION'
        ,pt_i_PackageName       => gct_PackageName
        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
        ,pt_i_ModuleMessage     => '- Completed '||ct_ProcOrFuncName
        ,pt_i_OracleError       => NULL
        );

      EXCEPTION
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                         ,pt_i_Application       => gct_XXMXApplication
                         ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                         ,pt_i_SubEntity         => gct_CoreSubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    COMMIT; --** Commit the message to the Module Messages table.
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
    END generate_ctl;

       --
     --
     /*
     **********************************
     ** PROCEDURE: gen_ctl_script - Control File Generation
     **********************************
     */

    PROCEDURE gen_ctl_script(ot_errbuf               OUT xxmx_module_messages.module_message%TYPE,
                              ot_retcode              OUT VARCHAR2,
                              pt_i_Application     IN      xxmx_migration_metadata.application%TYPE,
                              pt_object_name        IN VARCHAR2)
    IS


         --
         --
         --**********************
         --** Cursor Declarations
         --**********************
         --
         CURSOR c_staging
         IS
         SELECT st.*
         FROM   xxmx_stg_tables st,
                XXMX_CORE.xxmx_migration_metadata stu 
         WHERE  1 = 1
         AND    stu.application = NVL(pt_i_Application, stu.application)
         AND    st.table_name = NVL(pt_object_name, st.table_name)
         --and    stu.stg_table_id = st.stg_table_id
         AND    stu.metadata_id = st.metadata_id
         ORDER BY stu.application;
         /*End of c_staging*/

         --
         --
         --      
         CURSOR c_staging_tbls (p_stg_table_id  IN NUMBER)
         IS
         SELECT *
         FROM   xxmx_stg_table_columns
         WHERE  stg_table_id = p_stg_table_id
         ORDER BY stg_column_seq;
         /*End of c_staging_tbls*/

         --**********************
         --** Record Declarations
         --**********************
         --
         --
         --************************
         --** Constant Declarations
         --************************
         --
         ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'gen_ctl_script';
         --
         --************************
         --** Variable Declarations
         --************************
         --
         vt_StgTableID                   xxmx_stg_tables.stg_table_id%TYPE;
         vt_StgSchemaName                xxmx_stg_tables.schema_name%TYPE;
         vt_StgTableName                 xxmx_stg_tables.table_name%TYPE;
         vt_ErrorFlag                    xxmx_migration_details.error_flag%TYPE;
         vn_RowSeq                       NUMBER;
         vn_Rowid                        VARCHAR2(1000);
         ct_Phase                        xxmx_module_messages.phase%TYPE := 'EXTRACT';
         vt_OperatingUnitName            xxmx_simple_transforms.source_operating_unit_name%TYPE;
         vt_SourceValue                  xxmx_simple_transforms.source_value%TYPE;
         vt_FusionValue                  xxmx_simple_transforms.fusion_value%TYPE;
         vt_gen_what                     VARCHAR2(30) := 'CTL';
         vt_message                      VARCHAR2(2000);

         vt_cnt                          NUMBER := 0;
         vt_str                          VARCHAR2(10000);
         vt_datafile_name                VARCHAR2(150);
         vt_stage                        VARCHAR2(250);

         --
         --*************************
         --** Exception Declarations
         --*************************
         --
         e_ModuleError                   EXCEPTION;
         --
         --** END Declarations **
         --

      BEGIN

         gvv_ProgressIndicator := '0000';


          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
               ,pt_i_Application       => gct_XXMXApplication
               ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
               ,pt_i_SubEntity         => gct_CoreSubEntity
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||' ('
                                        ||gct_CoreBusinessEntity
                                        ||' / '
                                        ||gct_CoreSubEntity
                                        ||') initiated.'
               ,pt_i_OracleError       => NULL
               );


         FOR x IN c_staging
         LOOP

              BEGIN
               SELECT import_data_file_name
               INTO   vt_datafile_name
               FROM   xxmx_stg_tables
               WHERE  table_name = x.TABLE_NAME;
              EXCEPTION
              WHEN OTHERS THEN
                vt_datafile_name := NULL;
                --
               gvv_ProgressIndicator := '0005';
               --
               vt_message := 'Datafile name is not set in xxmx_stg_tables';
               Raise e_ModuleError;
            END;

               --
               gvv_ProgressIndicator := '0010';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                     ,pt_i_Application       => gct_XXMXApplication
                     ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                     ,pt_i_SubEntity         => gct_CoreSubEntity
                     ,pt_i_FileSetID         => 0
                    ,pt_i_MigrationSetID    => 0
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '--================================================================'
                    ,pt_i_OracleError       => NULL
                  );

               --
               gvv_ProgressIndicator := '0015';
               --
               xxmx_utilities_pkg.log_module_message
                    (
                      pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                     ,pt_i_Application       => gct_XXMXApplication
                    ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                    ,pt_i_SubEntity         => gct_CoreSubEntity
                    ,pt_i_FileSetID         => 0
                    ,pt_i_MigrationSetID    => 0
                    ,pt_i_Phase             => gvt_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => 'Generating the ctl file ' || vt_datafile_name || ' for object ' || x.table_name
                    ,pt_i_OracleError       => NULL
                  );

             vt_cnt := 1;
             vt_str := 'LOAD DATA' || chr(10) ;
             vt_str := vt_str || 'INFILE ' || vt_datafile_name || chr(10);
             vt_str := vt_str || 'REPLACE ' || chr(10);
             vt_str := vt_str || 'INTO  TABLE ' || x.table_name || chr(10);
             vt_str := vt_str || 'FIELDS TERMINATED BY "' || x.CONTROL_FILE_DELIMITER || '" OPTIONALLY ENCLOSED BY ''"''  TRAILING NULLCOLS '|| chr(10);
             vt_str := vt_str || '(' ;


             FOR y IN c_staging_tbls(x.stg_table_id)
             LOOP


               IF y.INCLUDE_IN_CONTROL_FILE = 'Y' THEN

                 IF vt_cnt = 1 THEN
                   vt_str := vt_str || RPAD(y.COLUMN_NAME,31,' ') || NVL(NVL(y.CTL_DEFAULT_VALUE, y.CTL_FORMAT_STRING),y.CTL_FUNCTION_NAME);
                 ELSE
                   vt_str := vt_str || ',' || chr(10)|| RPAD(y.COLUMN_NAME,31,' ') || NVL(NVL(y.CTL_DEFAULT_VALUE, y.CTL_FORMAT_STRING),y.CTL_FUNCTION_NAME);
                 END IF;

                 vt_cnt := vt_cnt + 1;
               END IF;
             END LOOP;



             vt_stage := 'Assing the sql stm to the control_file_script.';
             vt_str := vt_str || chr(10) || ')' || chr(10);


            --
            gvv_ProgressIndicator := '0020';
            --
            xxmx_utilities_pkg.log_module_message
              (
                pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
               ,pt_i_Application       => gct_XXMXApplication
               ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
               ,pt_i_SubEntity         => gct_CoreSubEntity
              ,pt_i_FileSetID         => 0
              ,pt_i_MigrationSetID    => 0
              ,pt_i_Phase             => gvt_Phase
              ,pt_i_Severity          => 'NOTIFICATION'
              ,pt_i_PackageName       => gct_PackageName
              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
              ,pt_i_ModuleMessage     => 'Update the Data Dictionary tables with Ctl Script.'
              ,pt_i_OracleError       => NULL
            );


             UPDATE xxmx_stg_tables
             SET    control_file_script = vt_str
             WHERE  stg_table_id = x.stg_table_id;
             --AND LAST_UPDATE_DATE = to_date(SYSDATE,'DD-MON-RRRR')


         END LOOP;

      EXCEPTION
      WHEN e_ModuleError THEN
                 --
                 ROLLBACK;
                 --
                 gvt_OracleError := SUBSTR(
                                           SQLERRM
                                          ,1
                                          ,4000
                                          );
                 --
                 xxmx_utilities_pkg.log_module_message
                      (
                       pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                      ,pt_i_Application       => gct_XXMXApplication
                      ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                      ,pt_i_SubEntity         => gct_CoreSubEntity
                      ,pt_i_FileSetID         => 0
                      ,pt_i_MigrationSetID    => 0
                      ,pt_i_Phase             => gvt_Phase
                      ,pt_i_Severity          => 'ERROR'
                      ,pt_i_PackageName       => gct_PackageName
                      ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                      ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                      ,pt_i_ModuleMessage     => vt_message
                      ,pt_i_OracleError       => gvt_OracleError
                      );
                 --
                 --
                 RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                 --
            --** END OTHERS Exception
            --
            --** END Exception Handler
            --
       WHEN OTHERS THEN
                 --
                 ROLLBACK;
                 --
                 gvt_OracleError := SUBSTR(
                                           SQLERRM
                                          ,1
                                          ,4000
                                          );
                 --
                 xxmx_utilities_pkg.log_module_message
                      (
                       pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                      ,pt_i_Application       => gct_XXMXApplication
                      ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                      ,pt_i_SubEntity         => gct_CoreSubEntity
                      ,pt_i_FileSetID         => 0
                      ,pt_i_MigrationSetID    => 0
                      ,pt_i_Phase             => gvt_Phase
                      ,pt_i_Severity          => 'ERROR'
                      ,pt_i_PackageName       => gct_PackageName
                      ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                      ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                      ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                      ,pt_i_OracleError       => gvt_OracleError
                      );
                 --
                 COMMIT; --** Commit the message to the Module Messages table.
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
                 RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                 --
            --** END OTHERS Exception
            --
            --** END Exception Handler
            --
     END gen_ctl_script;

     /******************
     This Procedure populate XFM Tables 
     Data Dictionary .
     *********************/
        Procedure xfm_populate    (  pt_i_ApplicationSuite           IN      xxmx_migration_metadata.application_suite%TYPE
                              ,pt_i_Application                IN      xxmx_migration_metadata.application%TYPE
                              ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                              ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                              ,pt_fusion_template_name         IN      xxmx_xfm_tables.fusion_template_name%TYPE DEFAULT NULL
                              ,pt_fusion_template_sheet_name   IN      xxmx_xfm_tables.fusion_template_sheet_name%TYPE DEFAULT NULL
                              ,pt_fusion_template_sheet_order  IN      xxmx_xfm_tables.fusion_template_sheet_order%TYPE DEFAULT NULL
                              ,pv_o_ReturnStatus               OUT  VARCHAR2) 
   IS
          --
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
          --
          --******************************
          --** Dynamic Cursor Declarations
          --******************************
          --
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'xfm_populate';
          lv_table_name                             VARCHAR2(200);
          lv_count                                  NUMBER;
          --
          --************************
          --** Variable Declarations
          --************************
          --
          --
          --*************************
          --** Exception Declarations
          --*************************
          --
          e_ModuleError                   EXCEPTION;
          --
     --** END Declarations **
     --
     BEGIN
          --
          gvt_Phase := 'EXTRACT';
          --
          --
          gvv_ProgressIndicator := '0010';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||' ( '
                                        ||pt_i_BusinessEntity
                                        ||' / '
                                        ||pt_i_SubEntity
                                        ||' / '
                                        ||pt_i_ApplicationSuite
                                        ||' / '
                                        ||pt_i_Application
                                        ||' ) '||') initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          /*
          ** Below Insert will populate the XFM Tables 
          ** for passed Parameters
          */
          --
          DELETE FROM xxmx_xfm_tables
          where table_name IN( SELECT distinct UPPER(XFM_TABLE) from xxmx_migration_metadata 
                                                   where application = pt_i_Application
                                                   and application_suite = pt_i_ApplicationSuite
                                                   and business_entity = NVL(pt_i_BusinessEntity,business_entity)
                                                   and XFM_TABLE is NOT NULL
                                                   and Sub_entity = NVL(pt_i_SubEntity,Sub_entity));
          --
          --
          SELECT COUNT(1)
          INTO lv_count
          FROM      ALL_TABLES allt
          WHERE     1 = 1
          AND       allt.owner         = 'XXMX_XFM'
          --AND       allt.table_name LIKE 'XXMX%XFM'
          and       allt.table_name IN('XXMX_FA_MASS_ADDITIONS_XFM')
          ORDER BY  UPPER(allt.owner)
                   ,UPPER(allt.table_name);
          --
          gvv_ProgressIndicator := '0015';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'DELETE Command Executed '||SQL%ROWCOUNT ||' '||lv_table_name ||' '||lv_count
               ,pt_i_OracleError       => NULL
               );
          --
          INSERT
            INTO   xxmx_xfm_tables
                        (
                         xfm_table_id
                        ,metadata_id
                        ,schema_name
                        ,table_name
                        ,comments
                        ,sequence_name
                        ,generate_sequence
                        ,sequence_start_value
                        ,fusion_template_name
                        ,fusion_template_sheet_name
                        ,fusion_template_sheet_order
                        ,field_delimiter
                        ,include_column_heading
                        ,include_column_heading_by_row
                        ,purge_flag
                        ,creation_date
                        ,created_by
                        ,last_update_date
                        ,last_updated_by
                        )
            SELECT  xxmx_xfm_table_ids_s.NEXTVAL
                   ,NVL(
                        (
                         SELECT  DISTINCT
                                 xmd.metadata_id
                         FROM    xxmx_migration_metadata  xmd
                         WHERE  1 = 1
                         AND    UPPER(xmd.xfm_table) = UPPER(distinct_tables.table_name)
                         AND    ROWNUM               = 1
                        )
                       ,0
                       )                                AS metadata_id
                   ,distinct_tables.owner
                   ,distinct_tables.table_name
                   ,distinct_tables.comments
                   ,distinct_tables.sequence_name
                   ,distinct_tables.generate_sequence
                   ,distinct_tables.sequence_start_value
                   ,distinct_tables.fusion_template_name
                   ,distinct_tables.fusion_template_sheet_name
                   ,distinct_tables.fusion_template_sheet_order
                   ,distinct_tables.field_delimiter
                   ,distinct_tables.include_column_heading
                   ,distinct_tables.include_column_heading_by_row
                   ,distinct_tables.purge_flag
                   ,distinct_tables.creation_date
                   ,distinct_tables.created_by
                   ,distinct_tables.last_updated_date
                   ,distinct_tables.last_updated_by
            FROM    (
                     SELECT     DISTINCT
                                UPPER(allt.owner)                      AS owner
                               ,UPPER(allt.table_name)                 AS table_name
                               ,NULL                                   AS comments
                               ,NULL                                   AS sequence_name
                               ,NULL                                   AS generate_sequence
                               ,NULL                                   AS sequence_start_value
                               ,NVL(pt_fusion_template_name,NULL)      AS fusion_template_name
                               ,NVL(pt_fusion_template_sheet_name,NULL) AS fusion_template_sheet_name
                               ,NVL(pt_fusion_template_sheet_order,NULL)   AS fusion_template_sheet_order
                               ,DECODE(pt_i_ApplicationSuite,'HCM','|',
                                                             'FIN',',',
                                                             'SCM',',',
                                                             'PPM',',',
                                                             'OLC','|',
                                                             ',')
                                                                  AS field_delimiter
                               ,NULL                                   AS include_column_heading
                               ,NULL                                   AS include_column_heading_by_row
                               ,'Y'                                    AS purge_flag
                               ,TO_DATE(SYSDATE, 'DD-MON-RRRR')          AS creation_date
                               ,'XXMX'                                 AS created_by
                               ,TO_DATE(SYSDATE, 'DD-MON-RRRR')          AS last_updated_date
                               ,'XXMX'                                 AS last_updated_by
                     FROM      all_tables allt
                     WHERE     1 = 1
                     AND       allt.owner         = 'XXMX_XFM'
                     AND       allt.table_name LIKE 'XXMX%XFM'
                     and       allt.table_name IN( SELECT distinct UPPER(XFM_TABLE) from xxmx_migration_metadata 
                                                   where application = pt_i_Application
                                                   and application_suite = pt_i_ApplicationSuite
                                                   and business_entity = NVL(pt_i_BusinessEntity,business_entity)
                                                   and XFM_TABLE is NOT NULL
                                                   and Sub_entity = NVL(pt_i_SubEntity,Sub_entity))
                     ORDER BY  UPPER(allt.owner)
                              ,UPPER(allt.table_name)
                    ) distinct_tables;
          --
          --
          gvv_ProgressIndicator := '0020';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'After XXMX_XFM_TABLE INSERT '||SQL%ROWCOUNT
               ,pt_i_OracleError       => NULL
               );
            Commit;
            /* Update all the Tables of Cash Receipts.*/
            UPDATE xxmx_xfm_tables
            SET    metadata_id     = (
                                      SELECT metadata_id
                                      FROM   xxmx_xfm_tables
                                      WHERE  1 = 1
                                      AND    table_name = 'XXMX_AR_CASH_RCPTS_RT6_XFM'
                                     )
            WHERE 1 = 1
            AND   table_name LIKE 'XXMX_AR_CASH%'
            AND   table_name   != 'XXMX_AR_CASH_RCPTS_RT6_XFM';
           --
          -- Commit;
           --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '- Populated XFM_TABLES Data_dictionary_tables '||SQL%ROWCOUNT
               ,pt_i_OracleError       => NULL
               );
          --

           DELETE FROM xxmx_xfm_table_columns
           where xfm_table_id IN( SELECT distinct xfm_table_id
                              from xxmx_migration_metadata a, 
                                   xxmx_xfm_tables xt
                               where application = pt_i_Application
                               and application_suite = pt_i_ApplicationSuite
                               and business_entity = NVL(pt_i_BusinessEntity,business_entity)
                               and XFM_TABLE is NOT NULL
                               and xt.metadata_id = a.metadata_id
                               and Sub_entity = NVL(pt_i_SubEntity,Sub_entity));
                      --
          gvv_ProgressIndicator := '0025';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'DELETE XXMX_XFM_TABLE_COLUMNS '||SQL%ROWCOUNT
               ,pt_i_OracleError       => NULL
               );
          --  Commit;

            --
            INSERT
            INTO   xxmx_xfm_table_columns
                        (
                         xfm_table_id
                        ,xfm_table_column_id
                        ,xfm_column_seq
                        ,column_name
                        ,data_type
                        ,data_length
                        ,mandatory
                        ,comments
                        ,creation_date
                        ,created_by
                        ,last_update_date
                        ,last_updated_by
                        )
            SELECT  ordered_columns.xfm_table_id
                   ,xxmx_xfm_table_column_ids_s.NEXTVAL
                   ,ordered_columns.xfm_column_seq
                   ,ordered_columns.column_name
                   ,ordered_columns.data_type
                   ,ordered_columns.data_length
                   ,ordered_columns.mandatory
                   ,NULL                                   AS comments
                   ,TO_DATE('01-JAN-2021', 'DD-MON-RRRR')  AS creation_date
                   ,'XXMX'                                 AS created_by
                   ,TO_DATE('01-JAN-2021', 'DD-MON-RRRR')  AS last_updated_date
                   ,'XXMX'                                 AS last_updated_by
            FROM   (
                    SELECT    xxt.xfm_table_id             AS xfm_table_id
                             ,alltc.column_id              AS xfm_column_seq
                             ,UPPER(alltc.column_name)     AS column_name
                             ,alltc.data_type              AS data_type
                             ,DECODE(
                                     alltc.data_type
                                          ,'VARCHAR2' ,alltc.data_length
                                          ,'NUMBER'   ,alltc.data_length
                                                      ,NULL
                                    )                      AS data_length
                             ,DECODE(
                                     alltc.nullable
                                          ,'N' ,'Y'
                                          ,'Y' ,NULL
                                          ,'N'
                                    )                      AS mandatory
                    FROM      all_tab_columns  alltc
                             ,xxmx_xfm_tables  xxt
                    WHERE     1 = 1
                    AND       alltc.table_name = UPPER(xxt.table_name)
                    AND       xxt.schema_name  = 'XXMX_XFM'
                    AND       xxt.table_name LIKE 'XXMX%XFM'
                    and       UPPER(xxt.table_name) IN( SELECT distinct UPPER(XFM_TABLE) from xxmx_migration_metadata 
                                                   where application = pt_i_Application
                                                   and application_suite = pt_i_ApplicationSuite
                                                   and business_entity = NVL(pt_i_BusinessEntity,business_entity)
                                                   and XFM_TABLE is NOT NULL
                                                   and Sub_entity = NVL(pt_i_SubEntity,Sub_entity))
                    ORDER BY  alltc.table_name
                             ,alltc.column_id
                   )  ordered_columns;
            --
           --
          gvv_ProgressIndicator := '0030';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'AFTER XXMX_XFM_TABLE_COLUMNS INSERT '||SQL%ROWCOUNT
               ,pt_i_OracleError       => NULL
               );
            COMMIT;
      EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                         ,pt_i_Application       => gct_XXMXApplication
                         ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                         ,pt_i_SubEntity         => gct_CoreSubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'ERROR'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END e_ModuleError Exception
               --
               WHEN OTHERS
               THEN
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                         ,pt_i_Application       => gct_XXMXApplication
                         ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                         ,pt_i_SubEntity         => gct_CoreSubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END xfm_populate;    


     /******************
     This Procedure populate STG Tables 
     Data Dictionary .
     *********************/
     Procedure stg_populate    (  pt_i_ApplicationSuite         IN      xxmx_migration_metadata.application_suite%TYPE
                              ,pt_i_Application                IN      xxmx_migration_metadata.application%TYPE
                              ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                              ,pt_i_SubEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                              ,pt_import_data_file_name       IN      xxmx_stg_tables.import_data_file_name%TYPE  DEFAULT NULL
                              ,pt_control_file_name            IN      xxmx_stg_tables.control_file_name%TYPE DEFAULT NULL
                              ,pt_control_file_delimiter       IN      xxmx_stg_tables.control_file_delimiter%TYPE DEFAULT NULL
                              ,pv_o_ReturnStatus               OUT  VARCHAR2) 
      IS
          --
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
          --
          --******************************
          --** Dynamic Cursor Declarations
          --******************************
          --
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'stg_populate';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          --
          --*************************
          --** Exception Declarations
          --*************************
          --
          e_ModuleError                   EXCEPTION;
          --
     --** END Declarations **
     --
     BEGIN
          --
          gvt_Phase := 'EXTRACT';
          --
          --
          gvv_ProgressIndicator := '0010';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||' ('
                                        ||pt_i_BusinessEntity
                                        ||' / '
                                        ||pt_i_SubEntity
                                        ||') initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          /*
          ** Below Insert will populate the STG Tables 
          ** for passed Parameters
          */
         --

         DELETE FROM xxmx_stg_tables
         where table_name IN( SELECT distinct UPPER(STG_TABLE) from xxmx_migration_metadata 
                                                   where application = pt_i_Application
                                                   and application_suite = pt_i_ApplicationSuite
                                                   and business_entity = NVL(pt_i_BusinessEntity,business_entity)
                                                   and STG_TABLE is NOT NULL
                                                   and Sub_entity = NVL(pt_i_SubEntity,Sub_entity));
         --
         INSERT
         INTO   xxmx_stg_tables
                     (
                      stg_table_id
                     ,metadata_id
                     ,schema_name
                     ,table_name
                     ,comments
                     ,sequence_name
                     ,generate_sequence
                     ,sequence_start_value
                     ,import_data_file_name
                     ,control_file_name
                     ,control_file_delimiter
                     ,control_file_optional_quotes
                     ,control_file_script
                     ,object_creation_script
                     ,column_name1    
                     ,column_name2   
                     ,order_by_clause
                     ,purge_flag
                     ,creation_date
                     ,created_by
                     ,last_update_date
                     ,last_updated_by
                     )
         SELECT  xxmx_stg_table_ids_s.NEXTVAL
                ,NVL(
                     (
                      SELECT  DISTINCT
                              xmd.metadata_id
                      FROM    xxmx_migration_metadata  xmd
                      WHERE  1 = 1
                      AND    UPPER(xmd.stg_table) = UPPER(distinct_tables.table_name)
                      AND    ROWNUM               = 1
                     )
                    ,0
                    )                                AS metadata_id
                ,distinct_tables.owner
                ,distinct_tables.table_name
                ,distinct_tables.comments
                ,distinct_tables.sequence_name
                ,distinct_tables.generate_sequence
                ,distinct_tables.sequence_start_value
                ,distinct_tables.import_data_file_name
                ,distinct_tables.control_file_name
                ,distinct_tables.control_file_delimiter
                ,distinct_tables.control_file_optional_quotes
                ,distinct_tables.control_file_script
                ,distinct_tables.object_creation_script
                ,distinct_tables.column_name1   
                ,distinct_tables.column_name2   
                ,distinct_tables.order_by_clause
                ,distinct_tables.purge_flag
                ,distinct_tables.creation_date
                ,distinct_tables.created_by
                ,distinct_tables.last_updated_date
                ,distinct_tables.last_updated_by
         FROM    (
                  SELECT     DISTINCT
                             UPPER(allt.owner)                      AS owner
                            ,UPPER(allt.table_name)                 AS table_name
                            ,NULL                                   AS comments
                            ,NULL                                   AS sequence_name
                            ,NULL                                   AS generate_sequence
                            ,NULL                                   AS sequence_start_value
                            ,NVL(pt_import_data_file_name,NULL)     AS import_data_file_name
                            ,NVL(pt_control_file_name,NULL)         AS control_file_name
                            ,NVL(pt_control_file_delimiter,NULL)    AS control_file_delimiter
                            ,NULL                                   AS control_file_optional_quotes
                            ,NULL                                   AS control_file_script
                            ,NULL                                   AS object_creation_script
                            ,NULL                                   AS column_name1   
                            ,NULL                                   AS column_name2   
                            ,NULL                                   AS order_by_clause
                            ,'Y'                                    AS purge_flag
                            ,TO_DATE(SYSDATE, 'DD-MON-RRRR')          AS creation_date
                            ,'XXMX'                                 AS created_by
                            ,TO_DATE(SYSDATE, 'DD-MON-RRRR')          AS last_updated_date
                            ,'XXMX'                                 AS last_updated_by
                  FROM      all_tables allt
                  WHERE     1 = 1
                  AND       allt.owner         = 'XXMX_STG'
                  AND       allt.table_name LIKE 'XXMX%STG'                  
                  and       allt.table_name IN( SELECT distinct UPPER(STG_TABLE) from xxmx_migration_metadata 
                                                   where application = pt_i_Application
                                                   and application_suite = pt_i_ApplicationSuite
                                                   and business_entity = NVL(pt_i_BusinessEntity,business_entity)
                                                   and STG_TABLE is NOT NULL
                                                   and Sub_entity = NVL(pt_i_SubEntity,Sub_entity))
                  ORDER BY  UPPER(allt.owner)
                           ,UPPER(allt.table_name)
                 ) distinct_tables;
         --
                   xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '- Populated stg_tables Data_dictionary_tables'
               ,pt_i_OracleError       => NULL
               );
         --
         DELETE FROM xxmx_stg_table_columns
         where stg_table_id IN( SELECT distinct stg_table_id
                              from xxmx_migration_metadata a, 
                                   xxmx_stg_tables xt
                               where application = pt_i_Application
                               and application_suite = pt_i_ApplicationSuite
                               and business_entity = NVL(pt_i_BusinessEntity,business_entity)
                               and stg_TABLE is NOT NULL
                               and xt.metadata_id = a.metadata_id
                               and Sub_entity = NVL(pt_i_SubEntity,Sub_entity));

         --
         INSERT
         INTO   xxmx_stg_table_columns
                     (
                      stg_table_id
                     ,stg_table_column_id
                     ,stg_column_seq
                     ,cv40_field_name
                     ,column_name
                     ,data_type
                     ,data_length
                     ,mandatory
                     ,enabled_flag
                     ,comments
                     ,include_in_control_file
                     ,ctl_default_value
                     ,ctl_format_string
                     ,ctl_function_name
                     ,lookup_table_name
                     ,lookup_type_name
                     ,lookup_column1
                     ,lookup_column2
                     ,lookup_column3
                     ,lookup_where_clause
                     ,validation_sql1
                     ,validation_sql2
                     ,validation_sql3
                     ,xfm_table_id
                     ,xfm_table_column_id
                     ,creation_date
                     ,created_by
                     ,last_update_date
                     ,last_updated_by
                     )
         SELECT  ordered_columns.stg_table_id
                ,xxmx_stg_table_column_ids_s.NEXTVAL
                ,ordered_columns.stg_column_seq
                ,ordered_columns.column_name
                ,ordered_columns.column_name
                ,ordered_columns.data_type
                ,ordered_columns.data_length
                ,ordered_columns.mandatory
                ,'Y'                                    AS enabled_flag
                ,NULL                                   AS comments
                ,'Y'                                    AS include_in_control_file
                ,NULL                                   AS ctl_default_value
                ,NULL                                   AS ctl_format_string
                ,NULL                                   AS ctl_function_name
                ,NULL                                   AS lookup_table_name
                ,NULL                                   AS lookup_type_name
                ,NULL                                   AS lookup_column1
                ,NULL                                   AS lookup_column2
                ,NULL                                   AS lookup_column3
                ,NULL                                   AS lookup_where_clause
                ,NULL                                   AS validation_sql1
                ,NULL                                   AS validation_sql2
                ,NULL                                   AS validation_sql3
                ,NULL                                   AS xfm_table_id
                ,NULL                                   AS xfm_table_column_id
                ,TO_DATE(SYSDATE, 'DD-MON-RRRR')  AS creation_date
                ,'XXMX'                                 AS created_by
                ,TO_DATE(SYSDATE, 'DD-MON-RRRR')  AS last_updated_date
                ,'XXMX'                                 AS last_updated_by
         FROM   (
                 SELECT    xst.stg_table_id             AS stg_table_id
                          ,alltc.column_id              AS stg_column_seq
                          ,UPPER(alltc.column_name)     AS column_name
                          ,alltc.data_type              AS data_type
                          ,DECODE(
                                  alltc.data_type
                                       ,'VARCHAR2' ,alltc.data_length
                                       ,'NUMBER'   ,alltc.data_length
                                                   ,NULL
                                 )                      AS data_length
                          ,DECODE(
                                  alltc.nullable
                                       ,'N' ,'Y'
                                       ,'Y' ,NULL
                                            ,NULL
                                 )                      AS mandatory
                 FROM      all_tab_columns  alltc
                          ,xxmx_stg_tables  xst
                 WHERE     1 = 1
                 AND       alltc.table_name = UPPER(xst.table_name)
                 AND       xst.schema_name  = 'XXMX_STG'
                 and       UPPER(xst.table_name) IN( SELECT distinct UPPER(STG_TABLE) from xxmx_migration_metadata 
                                                   where application = pt_i_Application
                                                   and application_suite = pt_i_ApplicationSuite
                                                   and business_entity = NVL(pt_i_BusinessEntity,business_entity)
                                                   and STG_TABLE is NOT NULL
                                                   and Sub_entity = NVL(pt_i_SubEntity,Sub_entity))
                 ORDER BY  alltc.table_name
                          ,alltc.column_id
                )  ordered_columns;
         --
        -- COMMIT;
         --
         UPDATE  xxmx_stg_table_columns  xstc
         SET     xstc.xfm_table_id = (
                                      SELECT  xxt.xfm_table_id
                                      FROM    xxmx_stg_tables   xst
                                             ,xxmx_xfm_tables   xxt
                                      WHERE   1 = 1
                                      AND     xst.stg_table_id = xstc.stg_table_id
                                      AND     xxt.table_name   = REPLACE(xst.table_name,'_STG' ,'')||'_XFM'
                                     )
         WHERE   1 = 1
         AND     xstc.stg_table_id NOT IN (
                                           SELECT xst.stg_table_id
                                           FROM   xxmx_stg_tables  xst
                                           WHERE  1 = 1
                                           AND    xst.table_name = 'XXMX_AR_CASH_RECEIPTS_STG'
                                          );
        --
        -- COMMIT;
        UPDATE  xxmx_stg_tables  xstc
         SET     xstc.xfm_table_id = (
                                      SELECT  xxt.xfm_table_id
                                      FROM    xxmx_stg_tables   xst
                                             ,xxmx_xfm_tables   xxt
                                      WHERE   1 = 1
                                      AND     xst.stg_table_id = xstc.stg_table_id
                                      AND     xxt.table_name   = REPLACE(xst.table_name,'_STG' ,'')||'_XFM'
                                     )
         WHERE   1 = 1
         AND     xstc.stg_table_id NOT IN (
                                           SELECT xst.stg_table_id
                                           FROM   xxmx_stg_tables  xst
                                           WHERE  1 = 1
                                           AND    xst.table_name = 'XXMX_AR_CASH_RECEIPTS_STG'
                                          );
         --
         --COMMIT;

         UPDATE  xxmx_stg_table_columns  xstc
         SET     xstc.XFM_TABLE_ID= (
                                             SELECT  stc.XFM_TABLE_ID
                                             FROM    xxmx_stg_tables  stc
                                             WHERE   1 = 1
                                             AND     stc.stg_table_id = xstc.stg_table_id 
                                            );

         COMMIT;
         --
         UPDATE  xxmx_stg_table_columns  xstc
         SET     xstc.xfm_table_id   = (
                                        SELECT  xxt.xfm_table_id
                                        FROM    xxmx_xfm_tables  xxt
                                        WHERE   1 = 1
                                        AND     xxt.table_name = 'XXMX_AR_CASH_RCPTS_RT6_XFM'
                                       )
         WHERE   1 = 1
         AND     xstc.stg_table_id IN (
                                       SELECT xst.stg_table_id
                                       FROM   xxmx_stg_tables  xst
                                       WHERE  1 = 1
                                       AND    xst.table_name = 'XXMX_AR_CASH_RECEIPTS_STG'
                                      );
         --
         COMMIT;
         --
         UPDATE  xxmx_stg_table_columns  xstc
         SET     xstc.xfm_table_column_id = (
                                             SELECT  xxtc.xfm_table_column_id
                                             FROM    xxmx_xfm_table_columns  xxtc
                                             WHERE   1 = 1
                                             AND     xxtc.xfm_table_id = xstc.xfm_table_id
                                             AND     xxtc.column_name  = xstc.column_name
                                            );
         --
         COMMIT;

          --
         xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => pt_i_ApplicationSuite
               ,pt_i_Application       => pt_i_Application
               ,pt_i_BusinessEntity    => pt_i_BusinessEntity
               ,pt_i_SubEntity         => pt_i_SubEntity
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '- Populated stg_tables Data_dictionary_tables Completed'
               ,pt_i_OracleError       => NULL
               );
          --

            --
            --COMMIT;
      EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                         ,pt_i_Application       => gct_XXMXApplication
                         ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                         ,pt_i_SubEntity         => gct_CoreSubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'ERROR'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END e_ModuleError Exception
               --
               WHEN OTHERS
               THEN
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                         ,pt_i_Application       => gct_XXMXApplication
                         ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                         ,pt_i_SubEntity         => gct_CoreSubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END stg_populate; 


     /*************************************************
     This Procedure populate STG Tables Data Dictionary .
     to update Mandatory and include_in_outbound_file
     **************************************************/

     PROCEDURE xfm_update_columns(p_table_name IN VARCHAR2)

	 AS 

        --
        /* Variable Declaration */
        --
        ct_ProcOrFuncName           CONSTANT  VARCHAR2(30)    := 'xfm_update_columns';
        --
		/*Cursor Declaration*/
		--
		CURSOR cur_xfm_update
		IS
		SELECT XUC.*,XTC.xfm_table_id, XTC.xfm_table_column_id
		FROM xxmx_core.xxmx_xfm_table_columns  XTC,
			 xxmx_core.xxmx_xfm_tables XT,
			 xxmx_core.xxmx_xfm_update_columns XUC
		WHERE XTC.xfm_table_id 	= XT.xfm_table_id 	
		AND UPPER(XTC.column_name) = UPPER(XUC.column_name)
		AND UPPER(XT.table_name) = UPPER(XUC.table_name)
        AND UPPER(XT.table_name) = NVL(p_table_name,UPPER(XT.table_name))
		;
		--
		--
		/*PLSQL Table Declaration*/
		--
		TYPE t_xfm_tab IS TABLE OF cur_xfm_update%ROWTYPE INDEX BY BINARY_INTEGER;
		p_xfm_tab t_xfm_tab;
		--
	 BEGIN 

          --
          gvt_Phase := 'EXTRACT';
          --
          --
          gvv_ProgressIndicator := '0010';
          --
          xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
               ,pt_i_Application       => gct_XXMXApplication
               ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
               ,pt_i_SubEntity         => gct_CoreSubEntity
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||' ('
                                        ||gct_CoreBusinessEntity
                                        ||' / '
                                        ||gct_CoreSubEntity
                                        ||') initiated.'
               ,pt_i_OracleError       => NULL
               );
          --


		UPDATE  XXMX_CORE.xxmx_xfm_table_columns
		SET Mandatory = 'N',include_in_outbound_file = 'N'		
		WHERE column_name IN( 'LAST_UPDATED_BY',
							'LAST_UPDATE_LOGIN',
							'LAST_UPDATE_DATE',
							'CREATION_DATE',
							'CREATED_BY',
							'OBJECT_VERSION_NUMBER',
							'BG_NAME',
							'PERSON_TYPE'							
							);



		Update XXMX_CORE.xxmx_xfm_table_columns
		SET Mandatory = 'N'
		where mandatory is null;



		OPEN cur_xfm_update;
		FETCH cur_xfm_update BULK COLLECT INTO p_xfm_tab;
		CLOSE cur_xfm_update;

        gvv_ProgressIndicator := '0020';

        xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
               ,pt_i_Application       => gct_XXMXApplication
               ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
               ,pt_i_SubEntity         => gct_CoreSubEntity
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Loop to call the update tables based on xxmx_xfm_update_columns'
               ,pt_i_OracleError       => NULL
               );
          --



		FOR i IN 1..p_xfm_tab.COUNT
		LOOP

                DBMS_OUTPUT.PUT_LINE(p_xfm_tab(i).column_name ||' '||p_xfm_tab(i).table_name||' '||p_xfm_tab(i).xfm_table_id||' '||p_xfm_tab(i).xfm_TABLE_COLUMN_ID);


                UPDATE XXMX_CORE.xxmx_xfm_table_columns XU
                SET mandatory = NVL(p_xfm_tab(i).mandatory,mandatory)
                    ,include_in_outbound_file = NVL(p_xfm_tab(i).include_in_outbound_file,include_in_outbound_file)
                    ,fusion_template_field_name = NVL(p_xfm_tab(i).fusion_template_field_name,fusion_template_field_name)
                    ,user_key_flag = NVL(p_xfm_tab(i).user_key,user_key_flag)
                    ,transform_code = NVL(p_xfm_tab(i).transform_code,transform_code)
                    ,default_value = NVL(p_xfm_tab(i).default_value,XU.default_value)
                WHERE UPPER(column_name) = UPPER(p_xfm_tab(i).column_name)
                AND xfm_table_id = p_xfm_tab(i).xfm_table_id
                and xfm_table_column_id = p_xfm_tab(i).xfm_table_column_id;

                UPDATE XXMX_CORE.xxmx_xfm_tables
                SET fusion_template_sheet_name = NVL(p_xfm_tab(i).fusion_template_sheet_name,fusion_template_sheet_name)
                WHERE UPPER(table_name) =UPPER( p_xfm_tab(i).table_name)
                AND xfm_table_id = p_xfm_tab(i).xfm_table_id;


		END LOOP;

       /* Update XXMX_CORE.xxmx_xfm_table_columns
		SET DEFAULT_OVERRIDES_SOURCE_VAL = 'Y',DEFAULT_VALUE = '31-DEC-4712'
		where column_name like 'EFFECTIVE_END%DATE%';*/

        gvv_ProgressIndicator := '0020';

        xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
               ,pt_i_Application       => gct_XXMXApplication
               ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
               ,pt_i_SubEntity         => gct_CoreSubEntity
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Procedure completed : '||ct_ProcOrFuncName
               ,pt_i_OracleError       => NULL
               );
          --


		COMMIT;

        EXCEPTION 
            WHEN OTHERS
               THEN

                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                         ,pt_i_Application       => gct_XXMXApplication
                         ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                         ,pt_i_SubEntity         => gct_CoreSubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --


	END xfm_update_columns; 

    /*************************************************
     This Procedure populate XFM Tables Data Dictionary .
     to update Mandatory and include_in_control_file
     **************************************************/


    PROCEDURE stg_update_columns ( p_table_name VARCHAR2 DEFAULT NULL)
	AS 
        --
        /* Variable Declaration */
        --
        ct_ProcOrFuncName           CONSTANT  VARCHAR2(30)    := 'xxmx_update_stg_columns';

        /* Cursor Declaration */
        --
        CURSOR cur_stg_update
        IS
        SELECT SUC.*,STC.stg_table_id, STC.stg_TABLE_COLUMN_ID
        FROM XXMX_STG_TABLE_COLUMNS  STC,
            XXMX_STG_TABLES ST,
            XXMX_CORE.XXMX_STG_UPDATE_COLUMNS SUC
        WHERE 
        STC.stg_table_id 	= ST.stg_table_id 	
        AND UPPER(STC.column_name) = UPPER(SUC.column_name)
        AND UPPER(ST.table_name) = UPPER(SUC.table_name)
        AND UPPER(ST.table_name) = NVL(UPPER(ST.table_name),p_table_name)
        ;

        --
        --
        /* PLSQL Type Declaration*/
        TYPE t_stg_tab IS TABLE OF cur_stg_update%ROWTYPE INDEX BY BINARY_INTEGER;
        p_stg_tab t_stg_tab;


     BEGIN 
            --
            gvt_Phase := 'EXTRACT';
            --
            --
            gvv_ProgressIndicator := '0010';
            --
            xxmx_utilities_pkg.log_module_message
            (
            pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
            ,pt_i_Application       => gct_XXMXApplication
            ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
            ,pt_i_SubEntity         => gct_CoreSubEntity
            ,pt_i_FileSetID         => 0
            ,pt_i_MigrationSetID    => 0
            ,pt_i_Phase             => gvt_Phase
            ,pt_i_Severity          => 'NOTIFICATION'
            ,pt_i_PackageName       => gct_PackageName
            ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator => gvv_ProgressIndicator
            ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                    ||gct_PackageName
                                    ||'.'
                                    ||ct_ProcOrFuncName
                                    ||' ('
                                    ||gct_CoreBusinessEntity
                                    ||' / '
                                    ||gct_CoreSubEntity
                                    ||') initiated.'
            ,pt_i_OracleError       => NULL
            );
            --


            --
            OPEN cur_stg_update;
            FETCH cur_stg_update BULK COLLECT INTO p_stg_tab;
            CLOSE cur_stg_update;
            --
             gvv_ProgressIndicator := '0015';
            --
             xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
               ,pt_i_Application       => gct_XXMXApplication
               ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
               ,pt_i_SubEntity         => gct_CoreSubEntity
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Loop to call the update tables based on xxmx_xfm_update_columns'
               ,pt_i_OracleError       => NULL
               );

            FOR i IN 1..p_stg_tab.COUNT
            LOOP
            --

                DBMS_OUTPUT.PUT_LINE(p_stg_tab(i).column_name ||' '||p_stg_tab(i).table_name);
                --
                UPDATE xxmx_core.xxmx_stg_table_columns
                SET mandatory = p_stg_tab(i).mandatory
                , include_in_control_file = p_stg_tab(i).include_in_control_file
                WHERE UPPER(column_name) = UPPER(p_stg_tab(i).column_name)
                AND stg_table_id = p_stg_tab(i).stg_table_id
                AND stg_table_column_id = p_stg_tab(i).stg_table_column_id;
                --
            END LOOP;
            --

            Update xxmx_core.xxmx_stg_Table_columns
            SET Mandatory = 'Y',include_in_control_file = 'Y'
            where column_name IN(  'PERSONNUMBER',
            'PRIMARY_FLAG');

            Update xxmx_core.xxmx_stg_Table_columns
            SET Mandatory = 'N',include_in_control_file = 'N'
            where column_name like  '%ATTRIBUTE%';

            Update xxmx_core.xxmx_stg_Table_columns
            SET Mandatory = 'N',include_in_control_file = 'N'
            where column_name like  '%INFORMATION%';

            UPDATE xxmx_core.xxmx_stg_Table_columns
            SET Mandatory = 'Y',include_in_control_file = 'Y'
            where column_name like  '%FILE_SET_ID%';

            Update xxmx_core.xxmx_stg_Table_columns
            SET Mandatory = 'N',include_in_control_file = 'N'
            where column_name 
            IN( 'BG_ID',
                'METADATA',
                'ORG_PAYMENT_METHOD_ID',
                'MIGRATION_SET_ID',
                'GRADEID',
                'GRADESTEPID',
                'PARTY_ID',
                'USER_GUID',
                'RELATEDPERSONID',
                'ACTION_OCCURRENCE_ID',
                'WORKING_PERCENTAGE',
                'FREEZE_START_DATE',
                'FREEZE_UNTIL_DATE',
                'ASSIGNMENT_SUPERVISOR_ID',
                'PERSONID',
                'ABSENCETYPEID',
                'BANK_ID',
                'BRANCH_ID',
                'CONTPERSONID',
                'OBJECT_VERSION_NUMBER',
                'MIGRATION_ACTION',
                'SOURCESYSTEMID',
                'EMAIL_ADDRESS_ID',
                'SOURCESYSTEMOWNER',
                'ASSIGNMENT_ID',
                'MANAGER_ASSIGNMENT_ID',
                'MANAGER_ID',
                'MASTERED_IN_LDAP_FLAG',
                'OBJECT_NAME',
                'CREATED_BY',
                'CREATION_DATE',
                'LAST_UPDATED_BY',
                'LAST_UPDATE_LOGIN',
                'LAST_UPDATE_DATE',
                'CITIZENSHIP_ID',
                'OBJECTNAME');

            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'BENEFICIARY_PERSON_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);

            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'DEPENDENT_PERSON_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);

            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'LEARNING_ITEM_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);

            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'OWNED_BY_PERSON_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);

            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'CLASSROOM_RESOURCE_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);

            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'INSTRUCTOR_RESOURCE_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);

            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'COURSE_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);

            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'OFFERING_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);

            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'PRIMARY_LOCATION_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);

            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'PRIMARY_INSTRUCTOR_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);

            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'TRAINING_SUPPLIER_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);

            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'COORDINATOR_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);

            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'ACTIVITY_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);

            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'VIRTUAL_PROVIDER_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);

            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'ADHOC_RESOURCE_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);

            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'CLASSROOM_RESERVATION_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);

            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'INSTRUCTOR_RESERVATION_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);


            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'CONTENT_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);


            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'DEFAULT_ACCESS_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);


            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'PRICING_RULE_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);


            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'PRICING_COMPONENT_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);


            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'SPECIALIZATION_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);

            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'SPECIALIZATION_SECTION_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);

            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'COURSE_LEARNING_ITEM_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);

            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'RELATION_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);

            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'GLOBAL_ACCESS_GROUP_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);

            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'COMMUNITY_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);

            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'N', mandatory = 'N'
            where column_name like 'LEARNING_RECORD_ID%'
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);

            Update xxmx_core.xxmx_stg_Table_columns
            set include_in_control_file = 'Y', mandatory = 'N'
            where column_name in ('CLOSE_LIFE_EVENT','CLOSE_LIFE_EVENT_DATE')
            and stg_table_id IN( select stg_table_id from xxmx_core.xxmx_stg_Tables where table_name like p_table_name);

            --
            gvv_ProgressIndicator := '0020';
            --
            xxmx_utilities_pkg.log_module_message
               (
                pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
               ,pt_i_Application       => gct_XXMXApplication
               ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
               ,pt_i_SubEntity         => gct_CoreSubEntity
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gvt_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'Loop to call the update tables based on xxmx_xfm_update_columns'
               ,pt_i_OracleError       => NULL
               );
            --
            COMMIT;

        EXCEPTION 
            WHEN OTHERS
               THEN
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_XXMXApplicationSuite
                         ,pt_i_Application       => gct_XXMXApplication
                         ,pt_i_BusinessEntity    => gct_CoreBusinessEntity
                         ,pt_i_SubEntity         => gct_CoreSubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gvt_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    gvv_ApplicationErrorMessage := SUBSTR(
                                                          'Unexpected Oracle Exception encountered after Progress Indicator "'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --


	END ;

   PROCEDURE PURGE_MESSAGES( p_date IN VARCHAR2)
   AS 

   BEGIN 
       DELETE FROM XXMX_MODULE_MESSAGES WHERE TO_CHAR(MESSAGE_TIMESTAMP,'DD-MON-RRRR') <= TO_DATE(p_date,'DD-MON-RRRR');
       COMMIT;
   END;

          procedure trim_xfm_table_data
(
                         pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                        ,pt_i_FileSetID                  IN      xxmx_migration_headers.File_set_id%TYPE
                        ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                        ,pt_i_sub_entity                 IN      xxmx_migration_metadata.sub_entity%TYPE DEFAULT 'ALL'
)
is
	--
    -- *********************
    --  CURSOR Declarations
    -- *********************
    CURSOR c_xfm_tables (p_application_suite varchar2,p_application varchar2) is
         select
            upper( mm.xfm_table)       as xfm_table_name,
            xt.xfm_table_id            as xfm_table_id
        from 
		    xxmx_migration_metadata mm, 
			xxmx_xfm_tables xt
        where mm.application_suite     = p_application_suite
        and mm.application             = p_application
        and mm.Business_entity         = pt_i_BusinessEntity
        and mm.sub_entity              = DECODE(pt_i_sub_entity,'ALL', mm.sub_entity, pt_i_sub_entity)
        and mm.stg_table               is not null
        and mm.enabled_flag            = 'Y'
        and mm.metadata_id             = xt.metadata_id;
        --
        cursor c_table_columns ( p_xfm_table_id in number) is
            select  
                column_name, 
                fusion_template_field_name, 
                data_type, 
                field_delimiter, 
                data_length
            from    xxmx_xfm_table_columns xtc,  xxmx_xfm_tables xt
            where   xt.xfm_table_id              = p_xfm_table_id
            and     xt.xfm_Table_id              = xtc.xfm_table_id
            and     xtc.data_type                = 'VARCHAR2'
            and     xtc.include_in_outbound_file = 'Y'
            ;
        --
        --
        /************************            ** Constant Declarations
        *************************/
        --
        gct_PackageName             CONSTANT  VARCHAR2(30)                                := 'XXMX_FUSION_LOAD_GEN_PKG';
        cv_ProcOrFuncName           CONSTANT  VARCHAR2(30)                                 := 'generate_csv_file';
        vt_sub_entity                         xxmx_migration_metadata.sub_entity%TYPE :='ALL';
        --
        vt_ext                      CONSTANT  VARCHAR2(10)                            := '.csv';
        gct_phase                   CONSTANT  xxmx_module_messages.phase%TYPE       := 'EXPORT';
        g_zipped_blob               blob;
         --
              vv_file_type                          VARCHAR2(10) := 'M';
              vv_file_dir                           xxmx_file_locations.file_location%TYPE;
              v_hdr_flag                            VARCHAR2(5);

              --
              /************************
             ** Variable Declarations
             *************************/
             --
              vt_ApplicationSuite                  xxmx_migration_metadata.application_suite%TYPE:= 'XXMX';
              vt_Application                       xxmx_migration_metadata.application%TYPE:='XXMX';

              gvv_ReturnStatus                     VARCHAR2(1);
              gvt_ReturnMessage                    xxmx_module_messages.module_message%TYPE;
              gvt_ModuleMessage                    xxmx_module_messages.module_message%TYPE;
              gvt_OracleError                      xxmx_module_messages.oracle_error%TYPE;
              gvt_migrationsetname                 xxmx_migration_headers.migration_set_name%TYPE;
              gvt_Severity                         xxmx_module_messages .severity%TYPE;
              vv_hdl_file_header                   VARCHAR2(32000);
              vv_error_message                     VARCHAR2(80);
              vv_stop_processing                   VARCHAR2(1);
              vv_column_name1                       VARCHAR2(1000);
              vv_column_name2                       VARCHAR2(1000);
              gvv_SQLStatement                     VARCHAR2(32000);
              gvv_SQLStatement2                     VARCHAR2(32000);
              gvv_SQLPreString                     VARCHAR2(8000);
              gvv_ProgressIndicator                VARCHAR2(100);
              gvv_stop_processing                  VARCHAR2(5);
              gvv_sqlresult_num                    NUMBER;
              pv_o_OIC_Internal                    VARCHAR2(200);
              pv_o_FTP_Data                        VARCHAR2(200);
              pv_o_FTP_Process                     VARCHAR2(200);
              pv_o_FTP_Out                         VARCHAR2(200);
              pv_o_ZIP_Filename                    VARCHAR2(200);
              pv_o_PROPERTY_Filename               VARCHAR2(200);
              v_double_quotes_processing varchar2(30);
              g_file_id        UTL_FILE.FILE_TYPE;

              --
              --******************************
              --** Dynamic Cursor Declarations
              --******************************
              --
              TYPE RefCursor_t IS REF CURSOR;
              MandColumnData_cur                         RefCursor_t;
              --
              --***************************
              -- Record Table Declarations
              -- **************************
              --
              type extract_data is table of varchar2(4000) index by binary_integer;
              g_extract_data                 extract_data;
              --
              type exrtact_cursor_type IS REF CURSOR;
              r_data                        exrtact_cursor_type;
              --
              -- **************************
              -- Exception Declarations
              -- **************************
              --
              --** Set gvt_Severity, gvv_ProgressIndicator and gvt_ModuleMessage
              --** beFORe raising this exception.
              --
              e_ModuleError                   EXCEPTION;
              e_dataerror                     EXCEPTION;
              e_nodata                        EXCEPTION;
              --
         --** END Declarations
         --
         --
begin
    --
    gvv_ProgressIndicator := '0010';
    gvv_ReturnStatus  := '';
    --
    xxmx_utilities_pkg.clear_messages
                   (
                    pt_i_ApplicationSuite => vt_Applicationsuite
                   ,pt_i_Application      => vt_Application
                   ,pt_i_BusinessEntity   => pt_i_BusinessEntity
                   ,pt_i_SubEntity        => vt_sub_entity
                   ,pt_i_MigrationSetID   => NULL                 -- This is NULL so messages FOR all previous runs are deleted.
                   ,pt_i_Phase            => gct_phase
                   ,pt_i_MessageType      => 'MODULE'
                   ,pv_o_ReturnStatus     => gvv_ReturnStatus
                   );
    if gvv_ReturnStatus = 'F' then
        xxmx_utilities_pkg.log_module_message
                        (
                         pt_i_ApplicationSuite  => vt_Applicationsuite
                        ,pt_i_Application       => vt_Application
                        ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                        ,pt_i_SubEntity         => vt_sub_entity
                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                        ,pt_i_FileSetID         => pt_i_FileSetID
                        ,pt_i_Phase             => gct_phase
                        ,pt_i_Severity          => 'ERROR'
                        ,pt_i_PackageName       => gct_PackageName
                        ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage     => '- Oracle error in called procedure "xxmx_utilities_pkg.clear_messages".'
                        ,pt_i_OracleError       => NULL
                        );
        RAISE e_ModuleError;
    end if;
    --
    -- Verify that the value in pt_i_BusinessEntity is valid.
    --
    gvv_ProgressIndicator := '0040';
    gvv_ReturnStatus  := '';
    --
    xxmx_utilities_pkg.verify_lookup_code
                  (
                   pt_i_LookupType    => 'BUSINESS_ENTITIES'
                  ,pt_i_LookupCode    => pt_i_BusinessEntity
                  ,pv_o_ReturnStatus  => gvv_ReturnStatus
                  ,pt_o_ReturnMessage => gvt_ReturnMessage
                  );
    if gvv_ReturnStatus <> 'S' THEN
                  --
                  gvt_Severity      := 'ERROR';
                  gvt_ModuleMessage := gvt_ReturnMessage;
                  --
                  RAISE e_ModuleError;
                  --
    end if;
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
                        pt_i_BusinessEntity   => pt_i_BusinessEntity
                       ,pt_o_ApplicationSuite => vt_ApplicationSuite
                       ,pt_o_Application      => vt_Application
                       ,pv_o_ReturnStatus     => gvv_ReturnStatus
                       ,pt_o_ReturnMessage    => gvt_ReturnMessage
                       );
    if gvv_ReturnStatus <> 'S' then
                  --
                  gvt_Severity      := 'ERROR';
                  gvt_ModuleMessage := gvt_ReturnMessage;
                  --
                  RAISE e_ModuleError;
                  --
    end if;
    --
    --
    gvv_ProgressIndicator := '0060';
    --
    xxmx_utilities_pkg.log_module_message
                   (
                    pt_i_ApplicationSuite  => vt_Applicationsuite
                   ,pt_i_Application       => vt_Application
                   ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                   ,pt_i_SubEntity         => vt_sub_entity
                   ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                   ,pt_i_FileSetID         => pt_i_FileSetID
                   ,pt_i_Phase             => gct_phase
                   ,pt_i_Severity          => 'NOTIFICATION'
                   ,pt_i_PackageName       => gct_PackageName
                   ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage     => 'Procedure "'||gct_PackageName||'.'||cv_ProcOrFuncName||'" initiated.',pt_i_OracleError=> NULL
                   );
    --
    gvt_MigrationSetName := xxmx_utilities_pkg.get_migration_set_name(pt_i_MigrationSetID);
    --
    gvv_ProgressIndicator := '0070';
    --
    xxmx_utilities_pkg.log_module_message
                                  (
                                   pt_i_ApplicationSuite  => vt_Applicationsuite
                                  ,pt_i_Application       => vt_Application
                                  ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                                  ,pt_i_SubEntity         => vt_sub_entity
                                  ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                                  ,pt_i_Phase             => gct_phase
                                  ,pt_i_Severity          => 'NOTIFICATION'
                                  ,pt_i_PackageName       => gct_PackageName
                                  ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                                  ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                  ,pt_i_ModuleMessage     => 'Migration Set Name '||gvt_MigrationSetName
                                  ,pt_i_OracleError       => NULL
                                  );
    --
    --
    for r_xfm_tables in c_xfm_tables(VT_APPLICATIONSUITE ,VT_APPLICATION )
    loop
            gvv_ProgressIndicator := '0090';
            gvv_sqlresult_num     := NULL;
            gvv_stop_processing   := NULL;
            --
            gvv_sqlstatement :=  
			    'select count(1) '||
				'from xxmx_xfm_table_columns xtc,xxmx_xfm_tables xt '||
				'where xt.table_name='''||r_xfm_tables.xfm_table_name||''''||
			    'and xtc.xfm_table_id = xt.xfm_table_id and data_type=''VARCHAR2''';
            execute immediate gvv_sqlstatement into gvv_sqlresult_num;
            --
            if gvv_sqlresult_num = 0 then
                gvv_ProgressIndicator := '0110';
                gvv_stop_processing := 'Y';
                gvt_ModuleMessage := 'No Columns are marked for Fusion Outbound File in xxmx_xfm_table_columns';
                xxmx_utilities_pkg.log_module_message
                     (
                      pt_i_ApplicationSuite  => vt_Applicationsuite
                     ,pt_i_Application       => vt_Application
                     ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                     ,pt_i_SubEntity         => vt_sub_entity
                     ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                     ,pt_i_Phase             => gct_phase
                     ,pt_i_Severity          => 'ERROR'
                     ,pt_i_PackageName       => gct_PackageName
                     ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                     ,pt_i_ModuleMessage     => gvt_ModuleMessage
                     ,pt_i_OracleError       => NULL
                     );
                raise e_ModuleError;
            end if;
            --
            -- Double quote handling:
            -- Parameter values are REMOVE or KEEP
            v_double_quotes_processing := XXMX_UTILITIES_PKG.get_single_parameter_value
                    (
                     pt_i_ApplicationSuite           => 'XXMX'
                    ,pt_i_Application                => 'ALL'
                    ,pt_i_BusinessEntity             => 'COMMON'
                    ,pt_i_SubEntity                  => 'ALL'
                    ,pt_i_ParameterCode              => 'DOUBLE_QUOTES'
                    );
            if v_double_quotes_processing is null then
                v_double_quotes_processing := 'REMOVE';
            end if;
            --
            gvv_ProgressIndicator := '0080';
            gvv_stop_processing   := NULL;
            gvv_SQLStatement      := 'update '||r_xfm_tables.xfm_table_name||' set ';
            gvv_SQLStatement2     := 'update '||r_xfm_tables.xfm_table_name||' set ';
            gvv_sqlresult_num     := NULL;
            for r_table_column in c_table_columns(r_xfm_tables.xfm_table_id)
            loop
                vv_column_name1 := r_table_column.column_name||'=trim('||r_table_column.column_name||')';
                if v_double_quotes_processing = 'KEEP' then
                    vv_column_name2 := r_table_column.column_name||'=substr(replace('||r_table_column.column_name||',''"'',''""''),1,'||r_table_column.data_length||')';
                else
                    vv_column_name2 := r_table_column.column_name||'=replace('||r_table_column.column_name||',''"'','''')';
                end if;
                if c_table_columns%rowcount>1 then
                    vv_column_name1:=','||vv_column_name1;
                    vv_column_name2:=','||vv_column_name2;
                end if;
                gvv_sqlstatement  := gvv_sqlstatement||vv_column_name1;
                gvv_sqlstatement2 := gvv_sqlstatement2||vv_column_name2;
            end loop;
            --
            --
            gvv_ProgressIndicator := '0100';
            --
            xxmx_utilities_pkg.log_module_message
                          (
                           pt_i_ApplicationSuite  => vt_Applicationsuite
                          ,pt_i_Application       => vt_Application
                          ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                          ,pt_i_SubEntity         => vt_sub_entity
                          ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                          ,pt_i_Phase             => gct_phase
                          ,pt_i_Severity          => 'NOTIFICATION'
                          ,pt_i_PackageName       => gct_PackageName
                          ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                          ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                          ,pt_i_ModuleMessage     => 'SQL= '||SUBSTR(gvv_SQLStatement,1,3500)
                          ,pt_i_OracleError       => NULL
                          );
            execute immediate gvv_SQLStatement;
            --
            xxmx_utilities_pkg.log_module_message
                          (
                           pt_i_ApplicationSuite  => vt_Applicationsuite
                          ,pt_i_Application       => vt_Application
                          ,pt_i_BusinessEntity    => pt_i_BusinessEntity
                          ,pt_i_SubEntity         => vt_sub_entity
                          ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                          ,pt_i_Phase             => gct_phase
                          ,pt_i_Severity          => 'NOTIFICATION'
                          ,pt_i_PackageName       => gct_PackageName
                          ,pt_i_ProcOrFuncName    => cv_ProcOrFuncName
                          ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                          ,pt_i_ModuleMessage     => 'SQL= '||SUBSTR(gvv_SQLStatement2,1,3500)
                          ,pt_i_OracleError       => NULL
                          );
            execute immediate gvv_SQLStatement2;
            commit;
    end loop;
exception
    WHEN e_nodata THEN
           --
           xxmx_utilities_pkg.log_module_message(
                         pt_i_ApplicationSuite    => vt_Applicationsuite
                        ,pt_i_Application         => vt_Application
                        ,pt_i_BusinessEntity      => pt_i_BusinessEntity
                        ,pt_i_SubEntity           =>  vt_sub_entity
                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                        ,pt_i_Phase               => gct_phase
                        ,pt_i_Severity            => 'ERROR'
                        ,pt_i_PackageName         => gct_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => gvt_ModuleMessage
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
            --
    WHEN e_ModuleError THEN
            xxmx_utilities_pkg.log_module_message(
                         pt_i_ApplicationSuite    => vt_Applicationsuite
                        ,pt_i_Application         => vt_Application
                        ,pt_i_BusinessEntity      => pt_i_BusinessEntity
                        ,pt_i_SubEntity           =>  vt_sub_entity
                        ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                        ,pt_i_Phase               => gct_phase
                        ,pt_i_Severity            => 'ERROR'
                        ,pt_i_PackageName         => gct_PackageName
                        ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                        ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage       => gvt_ModuleMessage
                        ,pt_i_OracleError         => gvt_ReturnMessage       );
                --
                RAISE;
                --** END e_ModuleError Exception
                --

    WHEN OTHERS THEN
        ROLLBACK;
        gvt_OracleError := SUBSTR(SQLERRM||'** ERROR_BACKTRACE: '||dbms_utility.format_error_backtrace,1,4000);
        xxmx_utilities_pkg.log_module_message(
                            pt_i_ApplicationSuite    => vt_ApplicationSuite
                           ,pt_i_Application         => vt_Application
                           ,pt_i_BusinessEntity      => pt_i_BusinessEntity
                           ,pt_i_SubEntity           =>  vt_sub_entity
                           ,pt_i_MigrationSetID      => pt_i_MigrationSetID
                           ,pt_i_Phase               => gct_phase
                           ,pt_i_Severity            => 'ERROR'
                           ,pt_i_PackageName         => gct_PackageName
                           ,pt_i_ProcOrFuncName      => cv_ProcOrFuncName
                           ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                           ,pt_i_ModuleMessage       => 'Oracle Error'
                           ,pt_i_OracleError         => gvt_OracleError
                           );

        RAISE;

end trim_xfm_table_data; 

END xxmx_dynamic_sql_pkg;
/
SHOW ERRORS PACKAGE BODY xxmx_dynamic_sql_pkg;
/
--