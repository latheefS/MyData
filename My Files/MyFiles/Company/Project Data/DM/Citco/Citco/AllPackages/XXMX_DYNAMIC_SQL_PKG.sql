--------------------------------------------------------
--  DDL for Package XXMX_DYNAMIC_SQL_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_DYNAMIC_SQL_PKG" 
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
