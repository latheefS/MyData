create or replace PACKAGE             "XXMX_UTILITIES_PKG" 
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
     ** FILENAME  :  xxmx_utilities_pkg.sql
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
     ** PURPOSE   : This script creates the tables, indexes, sequences, grants,
     **             and synonyms to support the following:
     **
     **                  1) Maximise Data Migration Utilities
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
     ** xxmx_utilities_pkg.sql HISTORY
     ** ------------------------------------
     **
     **   Vsn  Change Date  Changed By          Change Description
     ** -----  -----------  ------------------  -----------------------------------
     **   1.0  09-JUL-2020  Ian S. Vickerstaff  Created from original V1 Solutions
     **                                         Limited version.
     **   1.1  09-DEC-2020  Ian S. Vickerstaff  Enhancements to support calls from
     **                                         OIC.
     **   1.2  14-DEC-2020  Ian S. Vickerstaff  Minor Enhancements.
     **   1.3  08-JAN-2021  Ian S. Vickerstaff  Changed the structure of the
     **                                         XXMX_DATA_MESSAGES table (and the
     **                                         procedure that populates it) to be
     **                                         more flexible.  Record Identifier
     **                                         Names and Values are now held as
     **                                         concatenated strings instead of
     **                                         a limited number of separate columns.
     **                                         This was done to support the GL
     **                                         Utilites Pkg and the flexible
     **                                         nature of Account Structures.
     **   1.4  18-JAN-2021  Ian S. Vickerstaff  Added CONVERT_STRING function.
     **   1.5  08-FEB-2021  Ian S. Vickerstaff  Added overloaded CONVERT_STRING
     **                                         function to perform SUBSTR.
     **   1.6  10-FEB-2021  Ian S. Vickerstaff  Removed simple CONVERT_STRING
     **                                         functions as it was causing
     **                                         compilation problems in other
     **                                         packages and OIC does not like
     **                                         overloading anyway in case we ever
     **                                         need to use this function with OIC.
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
     ***************************************
     ** PROCEDURE: log_module_message
     **
     ** Called from each various procedures.
     ***************************************
     */
     --
     PROCEDURE log_module_message
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_module_messages.sub_entity%TYPE
                    ,pt_i_Phase                      IN      xxmx_module_messages.phase%TYPE
                    ,pt_i_Severity                   IN      xxmx_module_messages.severity%TYPE
                    ,pt_i_PackageName                IN      xxmx_module_messages.package_name%TYPE
                    ,pt_i_ProcOrFuncName             IN      xxmx_module_messages.proc_or_func_name%TYPE
                    ,pt_i_ProgressIndicator          IN      xxmx_module_messages.progress_indicator%TYPE
                    ,pt_i_ModuleMessage              IN      xxmx_module_messages.module_message%TYPE
                    ,pt_i_OracleError                IN      xxmx_module_messages.oracle_error%TYPE
                    );
                    --
     --** END PROCEDURE log_module_message
     --
     --
     /*
     ***************************************
     ** PROCEDURE: log_module_message
     **
     ** Called from each various procedures.
     ***************************************
     */
     --
     PROCEDURE log_module_message
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_module_messages.sub_entity%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_module_messages.file_set_id%TYPE DEFAULT 0
                    ,pt_i_MigrationSetID             IN      xxmx_module_messages.migration_set_id%TYPE
                    ,pt_i_Phase                      IN      xxmx_module_messages.phase%TYPE
                    ,pt_i_Severity                   IN      xxmx_module_messages.severity%TYPE
                    ,pt_i_PackageName                IN      xxmx_module_messages.package_name%TYPE
                    ,pt_i_ProcOrFuncName             IN      xxmx_module_messages.proc_or_func_name%TYPE
                    ,pt_i_ProgressIndicator          IN      xxmx_module_messages.progress_indicator%TYPE
                    ,pt_i_ModuleMessage              IN      xxmx_module_messages.module_message%TYPE
                    ,pt_i_OracleError                IN      xxmx_module_messages.oracle_error%TYPE
                    );
                    --
     --** END PROCEDURE log_module_message
     --
     --
     /*
     ***************************************
     ** PROCEDURE: log_data_message
     **
     ** Called from each various procedures.
     ***************************************
     */
     --
     PROCEDURE log_data_message
                    (
                     pt_i_ApplicationSuite           IN      xxmx_data_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_data_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_data_messages.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_data_messages.sub_entity%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_data_messages.migration_set_id%TYPE
                    ,pt_i_Phase                      IN      xxmx_data_messages.phase%TYPE
                    ,pt_i_Severity                   IN      xxmx_data_messages.severity%TYPE
                    ,pt_i_DataTable                  IN      xxmx_data_messages.data_table%TYPE
                    ,pt_i_RecordIdentifiers          IN      xxmx_data_messages.record_identifiers%TYPE
                    ,pt_i_DataMessage                IN      xxmx_data_messages.data_message%TYPE
                    ,pt_i_DataElementsAndValues      IN      xxmx_data_messages.data_elements_and_values%TYPE
                    );
                    --
     --** END PROCEDURE log_data_message
     --
     --
     /*
     **************************************************************
     ** The following function returns a date and time stamp in the
     ** format YYYYMMDDHH24MISS which can be used when archiving
     ** files in data cartridges called by the Patech Universal
     ** Interface.
     **************************************************************
     */
     --
     FUNCTION date_and_time_stamp
                   (
                    pv_i_IncludeSeconds             IN      VARCHAR2  DEFAULT 'Y'
                   )
     RETURN VARCHAR2;
                    --
     --** END FUNCTION date_and_time_stamp
     --
     /*
     ************************************
     ** FUNCTION: convert_string
     **
     ** Remove special characters from an
     ** input string and optionally
     ** perform a SUBSTR operation on it.
     **
     ** Pass a value greater than 0 in
     ** the pi_i_SubstrLength parameter
     ** to enable the Substr to be
     ** performed.
     ************************************
     */
     --
     FUNCTION convert_string
                   (
                    pv_i_StringToConvert            VARCHAR2
                   ,pv_i_ConvertCommaToSpace        VARCHAR2 DEFAULT 'N'
                   ,pi_i_SubstrStartPos             INTEGER  DEFAULT 1
                   ,pi_i_SubstrLength               INTEGER  DEFAULT 0
                   ,pv_i_UseBinarySubstr            VARCHAR2 DEFAULT 'N'
                   )
     RETURN VARCHAR2;
                    --
     --** END FUNCTION convert_string
     --
     --
     /*
     ******************************
     ** FUNCTION: valid_lookup_code
     ******************************
     */
     --
     FUNCTION valid_lookup_code
                    (
                     pt_i_LookupType                 IN      xxmx_lookup_values.lookup_type%TYPE
                    ,pt_i_LookupCode                 IN      xxmx_lookup_values.lookup_code%TYPE
                    )
     RETURN BOOLEAN;
                    --
     --** END FUNCTION valid_lookup_code
     --
     --
     /*
     ******************************************
     ** FUNCTION: get_business_entity_seq
     **
     ** Called from each Extract Main procedure
     ******************************************
     */
     --
     FUNCTION get_business_entity_seq
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_metadata.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_metadata.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    )
     RETURN xxmx_migration_metadata.business_entity_seq%TYPE;
                     --
     --** END FUNCTION get_business_entity_seq
     --
     --
     /*
     ******************************************
     ** FUNCTION: get_business_entity_seq
     **
     ** Called from each Extract Main procedure
     ******************************************
     */
     --
     FUNCTION get_sub_entity_seq
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_metadata.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_metadata.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.business_entity%TYPE
                    )
     RETURN xxmx_migration_metadata.sub_entity_seq%TYPE;
                     --
     --** END FUNCTION get_sub_entity_seq
     --
     --
     /*
     **********************************
     ** PROCEDURE: clear_messages
     **
     ** Called from various procedures.
     **********************************
     */
     --
     PROCEDURE clear_messages
                    (
                     pt_i_ApplicationSuite           IN      xxmx_data_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_data_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_data_messages.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_data_messages.sub_entity%TYPE
                    ,pt_i_Phase                      IN      xxmx_data_messages.phase%TYPE
                    ,pt_i_MessageType                IN      VARCHAR2
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    );
                    --
     --** END PROCEDURE clear_messages
     --
     --
     /*
     **********************************
     ** PROCEDURE: clear_messages
     **
     ** Called from various procedures.
     **********************************
     */
     --
     PROCEDURE clear_messages
                    (
                     pt_i_ApplicationSuite           IN      xxmx_data_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_data_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_data_messages.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_data_messages.sub_entity%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_data_messages.migration_set_id%TYPE
                    ,pt_i_Phase                      IN      xxmx_data_messages.phase%TYPE
                    ,pt_i_MessageType                IN      VARCHAR2
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    );
                    --
     --** END PROCEDURE clear_messages
     --
     --
     /*
     ******************************************
     ** FUNCTION: get_client_config_value
     **
     ** Called from each Extract Main procedure
     ******************************************
     */
     --
     FUNCTION get_client_config_value
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_ConfigParameter            IN      xxmx_client_config_parameters.config_parameter%TYPE
                    )
     RETURN VARCHAR2;
                    --
     --** END FUNCTION get_client_config_details
     --
     --
     /*
     ************************************
     ** FUNCTION: verify_parameter_exists
     **
     ** Called from various procedures.
     ************************************
     */
     --
     FUNCTION verify_parameter_exists
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_parameters.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_parameters.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_parameters.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_parameters.sub_entity%TYPE
                    ,pt_i_ParameterCode              IN      xxmx_migration_parameters.parameter_code%TYPE
                    )
     RETURN VARCHAR2;
                    --
     --** END FUNCTION verify_parameter_exists
     --
     --
     /*
     *****************************************
     ** FUNCTION: get_single_parameter_value
     **
     ** Called from various Extract procedures
     ** and Scope Views.
     *****************************************
     */
     --
     FUNCTION get_single_parameter_value
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_parameters.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_parameters.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_parameters.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_parameters.sub_entity%TYPE
                    ,pt_i_ParameterCode              IN      xxmx_migration_parameters.parameter_code%TYPE
                    )
     RETURN VARCHAR2;
                    --
     --** END FUNCTION get_single_parameter_value
     --
     --
     /*
     *****************************************
     ** FUNCTION: get_parameter_value_list
     **
     ** Called from various Extract procedures
     ** and Scope Views.
     *****************************************
     */
     --
     FUNCTION get_parameter_value_list
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_parameters.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_parameters.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_parameters.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_parameters.sub_entity%TYPE
                    ,pt_i_ParameterCode              IN      xxmx_migration_parameters.parameter_code%TYPE
                    ,pn_o_ReturnCount                   OUT  NUMBER
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    ,pv_o_ReturnMessage                 OUT  VARCHAR2
                    )
     RETURN g_ParamValueList_tt;
                    --
     --** END FUNCTION get_parameter_value_list
     --
     --
     /*
     ***********************************************
     ** FUNCTION : simple_transform_exists
     **
     ** The following function simply returns TRUE
     ** if at least one simple transform has been
     ** entered into the xxmx_simple_transforms
     ** table for the given parameters.
     ***********************************************
     */
     --
     FUNCTION simple_transform_exists
                   (
                    pt_i_ApplicationSuite           IN      xxmx_simple_transforms.application_suite%TYPE
                   ,pt_i_Application                IN      xxmx_simple_transforms.application%TYPE
                   ,pt_i_CategoryCode               IN      xxmx_simple_transforms.category_code%TYPE
                   )
     RETURN BOOLEAN;
                    --
     --** END FUNCTION simple_transform_exists
     --
     --
     /*
     *************************************************************
     ** The following function accepts several parameters which
     ** identify a data element value from an external application
     ** and returns its mapped equivalent for the target
     ** application
     *************************************************************
     */
     --
     FUNCTION get_transform_fusion_value
                   (
                    pt_i_ApplicationSuite           IN      xxmx_simple_transforms.application_suite%TYPE
                   ,pt_i_Application                IN      xxmx_simple_transforms.application%TYPE
                   ,pt_i_CategoryCode               IN      xxmx_simple_transforms.category_code%TYPE
                   ,pt_i_SourceValue                IN      xxmx_simple_transforms.source_value%TYPE
                   )
     RETURN VARCHAR2;
                    --
     --** END FUNCTION get_transform_fusion_value
     --
     --
     /*
     *****************************************
     ** FUNCTION: get_fusion_business_unit
     **
     ** Called from various Extract procedures
     ** and Scope Views.
     *****************************************
     */
     --
     PROCEDURE get_fusion_business_unit
                    (
                     pt_i_SourceOperatingUnitName    IN      xxmx_source_operating_units.source_operating_unit_name%TYPE
                    ,pt_o_FusionBusinessUnitName        OUT  xxmx_source_operating_units.fusion_business_unit_name%TYPE
                    ,pt_o_FusionBusinessUnitID          OUT  xxmx_source_operating_units.fusion_business_unit_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    ,pt_o_ReturnMessage                 OUT  xxmx_module_messages.module_message%TYPE
                    );
                    --
     --** END FUNCTION get_fusion_business_unit
     --
     --
     /*
     ******************************************
     ** PROCEDURE: init_migration_set
     **
     ** Called from each Extract Main procedure
     ******************************************
     */
     --
     PROCEDURE init_migration_set
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_headers.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_headers.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_headers.business_entity%TYPE
                    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                    ,pt_o_MigrationSetID                OUT  xxmx_migration_headers.migration_set_id%TYPE
                    );
                    --
     --** END PROCEDURE init_migration_set
     --
     --
     /*
     *************************************
     ** FUNCTION: get_migration_set_name
     **
     ** Called from each Extract procedure
     *************************************
     */
     --
     FUNCTION get_migration_set_name
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    )
     RETURN VARCHAR2;
                    --
     --** END FUNCTION get_migration_set_name
     --
     --
     /*
     *************************************
     ** FUNCTION: get_migration_set_id
     **
     ** Called from OIC
     *************************************
     */
     --
     FUNCTION get_migration_set_id
                    (
                     pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                    )
     RETURN VARCHAR2;
                    --
     --** END FUNCTION get_migration_set_name
     --
     --
     /*
     *******************************************
     ** PROCEDURE: init_migration_details
     **
     ** Called from each Extract procedure
     *******************************************
     */
     --
     PROCEDURE init_migration_details
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_details.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_details.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_details.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_details.sub_entity%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_details.migration_set_id%TYPE
                    ,pt_i_StagingTable               IN      xxmx_migration_details.staging_table%TYPE
                    ,pt_i_ExtractStartDate           IN      xxmx_migration_details.extract_start_datetime%TYPE
                    );
                    --
     --** END PROCEDURE init_migration_details
     --
     --
     /*
     **************************************
     ** FUNCTION: get_row_count
     **
     ** Called from each Extract procedure.
     **
     ** Returns a number which is the count
     ** of rows in a single table.
     **************************************
     */
     --
     FUNCTION get_row_count
                    (
                     pt_i_SchemaName                 IN      xxmx_client_config_parameters.config_value%TYPE
                    ,pv_i_TableName                  IN      VARCHAR2
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    )
     RETURN NUMBER;
                    --
     --** END FUNCTION get_row_count
     --
     --
     /*
     **************************************
     ** FUNCTION: get_row_count
     **
     ** Called from each Extract procedure.
     **
     ** Returns a number which is the count
     ** of rows in a single table.
     **
     ** However this version allows upto
     ** 5 optional condtions to be added
     ** to the basic query.
     **************************************
     */
     --
     FUNCTION get_row_count
                    (
                     pt_i_SchemaName                 IN      xxmx_client_config_parameters.config_value%TYPE
                    ,pv_i_TableName                  IN      VARCHAR2
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_i_OptionalJoinCondition1     IN      VARCHAR2
                    ,pv_i_OptionalJoinCondition2     IN      VARCHAR2
                    ,pv_i_OptionalJoinCondition3     IN      VARCHAR2
                    ,pv_i_OptionalJoinCondition4     IN      VARCHAR2
                    ,pv_i_OptionalJoinCondition5     IN      VARCHAR2
                    )
     RETURN NUMBER;
                    --
     --** END FUNCTION get_row_count
     --
     --
     /*
     ******************************************
     ** PROCEDURE: upd_migration_details
     **
     ** Called from each Extract procedure
     ******************************************
     */
     --
     PROCEDURE upd_migration_details
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_details.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_details.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_details.sub_entity%TYPE
                    ,pt_i_Phase                      IN      xxmx_migration_details.phase%TYPE
                    ,pt_i_ExtractCompletionDate      IN      xxmx_migration_details.extract_completion_datetime%TYPE DEFAULT NULL
                    ,pt_i_ExtractRowCount            IN      xxmx_migration_details.extract_row_count%TYPE
                    ,pt_i_TransformTable             IN      xxmx_migration_details.transform_table%TYPE
                    ,pt_i_TransformStartDate         IN      xxmx_migration_details.transform_start_datetime%TYPE
                    ,pt_i_TransformCompletionDate    IN      xxmx_migration_details.transform_completion_datetime%TYPE
                    ,pt_i_ExportFileName             IN      xxmx_migration_details.export_file_name%TYPE
                    ,pt_i_ExportStartDate            IN      xxmx_migration_details.export_start_datetime%TYPE
                    ,pt_i_ExportCompletionDate       IN      xxmx_migration_details.export_completion_datetime%TYPE
                    ,pt_i_ExportRowCount             IN      xxmx_migration_details.export_row_count%TYPE
                    ,pt_i_ErrorFlag                  IN      xxmx_migration_details.error_flag%TYPE
                    );
                    --
     --** END PROCEDURE upd_migration_details
     --
     --
     /*
     ******************************************
     ** PROCEDURE: close_extract_phase
     **
     ** Called from each Extract Main procedure
     ******************************************
     */
     --
     PROCEDURE close_extract_phase
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    );
                    --
     --** END PROCEDURE close_extract_phase
     --
     --
     --
     --
     /*
     ******************************************
     ** PROCEDURE: close_transform_phase
     **
     ** Called from each Extract Main procedure
     ******************************************
     */
     --
     PROCEDURE close_transform_phase
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    );
                    --
     --** END PROCEDURE close_transform_phase
     --
     --
     /*
     *********************************************
     ** PROCEDURE: get_data_file_details
     **
     ** Called from OIC and PL/SQL file generation
     ** procedures
     *********************************************
     */
     --
     PROCEDURE get_data_file_details
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_details.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_details.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_details.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_details.sub_entity%TYPE
                    ,pv_o_FileName                      OUT  VARCHAR2
                    ,pn_o_FileGroupNumber               OUT  NUMBER
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    );
                    --
     --** END FUNCTION get_data_file_details
     --
     --
     /*
     *********************************************
     ** FUNCTION: gen_file_name
     **
     ** Called from OIC and PL/SQL file generation
     ** procedures
     *********************************************
     */
     --
     FUNCTION gen_file_name
                    (
                     pt_i_FileType                   IN      VARCHAR2
                    ,pt_i_ApplicationSuite           IN      xxmx_migration_metadata.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_metadata.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_FileGroupNumber            IN      xxmx_migration_metadata.file_group_number%TYPE
                    ,pt_i_BusinessUnitName           IN      xxmx_migration_details.business_unit_name%TYPE
                    )
     RETURN VARCHAR2;
                    --
     --** END FUNCTION gen_file_name
     --
     --
     /*
     *********************************************
     ** FUNCTION: get_file_location
     **
     ** Called from OIC and PL/SQL file generation
     ** procedures.
     **
     ** NOTE : You MUST check in your calling
     **        procedure/function if this function
     **        returns NULL, indicating that the
     **        file name could not be retrieved or
     **        generated.
     **
     **        The xxmx_module_messages table will
     **        contain details of the error.
     *********************************************
     */
     --
     FUNCTION get_file_location
                    (
                     pt_i_ApplicationSuite           IN      xxmx_file_locations.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_file_locations.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_file_locations.business_entity%TYPE
                    ,pt_i_FileGroupNumber            IN      xxmx_file_locations.file_group_number%TYPE
                    ,pt_i_CalledFrom                 IN      xxmx_file_locations.used_by%TYPE
                    ,pt_i_FileType                   IN      xxmx_file_locations.file_type%TYPE
                    ,pt_i_FileLocationType           IN      xxmx_file_locations.file_location_type%TYPE
                    )
     RETURN VARCHAR2;
                    --
     --** END FUNCTION get_file_location
     --
     --
     /*
     *********************************************
     ** FUNCTION: gen_properties_record
     **
     ** Called from OIC and PL/SQL file generation
     ** procedures.
     **
     ** NOTE : You MUST check in your calling
     **        procedure/function if this function
     **        returns NULL, indicating that the
     **        file name could not be generated.
     **
     **        The xxmx_module_messages table will
     **        contain details of the error.
     *********************************************
     */
     --
     FUNCTION gen_properties_record
                    (
                     pt_i_ApplicationSuite           IN      xxmx_fusion_job_definitions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_fusion_job_definitions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_fusion_job_definitions.business_entity%TYPE
                    ,pt_i_FileGroupNumber            IN      xxmx_fusion_job_definitions.file_group_number%TYPE
                    ,pt_i_ZipFileName                IN      VARCHAR2
                    ,pt_i_MigrationSetID             IN      xxmx_migration_details.migration_set_id%TYPE
                    ,pv_i_BusinessUnitName           IN      VARCHAR2
                    ,pv_i_LedgerName                 IN      VARCHAR2
                    ,pd_i_Date                       IN      DATE
                    )
     RETURN VARCHAR2;
                    --
     --** END FUNCTION gen_properties_record
     --
     --
     /*
     ******************************************
     ** PROCEDURE: close_export_phase
     **
     ** Called from each Extract Main procedure
     ******************************************
     */
     --
     PROCEDURE close_export_phase
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    );
                    --
     --** END PROCEDURE close_export_phase
     --
     --
         /*
     ********************************************
     ** PROCEDURE: init_file_migration_details
     **
     ** Called from the Dynamic SQL pre-validate
     ** procedure.
     *******************************************
     */
     --
     PROCEDURE init_file_migration_details
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_details.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_details.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_details.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_details.sub_entity%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_details.file_set_id%TYPE
                    ,pt_i_ValidateStartTimestamp     IN      xxmx_migration_details.extract_start_timestamp%TYPE
                    );
     --** PROCEDURE init_file_migration_details
     --
     --
      /*
     ********************************
     ** PROCEDURE: verify_lookup_code
     ********************************
     */
     --
     PROCEDURE verify_lookup_code
                    (
                     pt_i_LookupType                 IN      xxmx_lookup_values.lookup_type%TYPE
                    ,pt_i_LookupCode                 IN      xxmx_lookup_values.lookup_code%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    ,pt_o_ReturnMessage                 OUT  xxmx_data_messages.data_message%TYPE
                    );
                    --
     --** END PROCEDURE verify_lookup_code
     --
     --
     /*
     ***************************************
     ** PROCEDURE: log_data_message
     **
     ** Called from each various procedures.
     ***************************************
     */
     --
     PROCEDURE log_data_message
                    (
                     pt_i_ApplicationSuite           IN      xxmx_data_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_data_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_data_messages.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_data_messages.sub_entity%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_data_messages.file_set_id%TYPE 
                    ,pt_i_MigrationSetID             IN      xxmx_data_messages.migration_set_id%TYPE
                    ,pt_i_Phase                      IN      xxmx_data_messages.phase%TYPE
                    ,pt_i_Severity                   IN      xxmx_data_messages.severity%TYPE
                    ,pt_i_DataTable                  IN      xxmx_data_messages.data_table%TYPE
                    ,pt_i_RowSeq                     IN      xxmx_data_messages.row_seq%TYPE
                    ,pt_i_DataMessage                IN      xxmx_data_messages.data_message%TYPE
                    ,pt_i_DataElementsAndValues      IN      xxmx_data_messages.data_elements_and_values%TYPE
                    );
                    --
     --** END PROCEDURE log_data_message
     --
     --
          /*
     *****************************************************************************************
     ** PROCEDURE: valid_install
     **
     ** This function will verify that the initial installation scripts for Maximise have
     ** been executed.
     **
     ** This procedure is called from STG_MAIN.
     *****************************************************************************************
     */
     --
     FUNCTION valid_install
     RETURN BOOLEAN;
                    --
     --** END FUNCTION valid_install
     --
     --
     /*
     ***********************************************
     ** PROCEDURE : evaluate_transform
     **
     ** The following procedure operates in one of
     ** two modes when called.
     **
     ** If called in "VERIFY" mode it simply
     ** verifies that there is a transform specified
     ** for the given Source Value.
     **
     ** If called in "TRANSFORM" mode it returns
     ** the Fusion Value determined from the Source
     ** Value.
     ***********************************************
     */
     --
     PROCEDURE evaluate_transform
                    (
                     pt_i_ApplicationSuite           IN      xxmx_simple_transforms.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_simple_transforms.application%TYPE
                    ,pt_i_SourceOperatingUnitName    IN      xxmx_simple_transforms.source_operating_unit_name%TYPE
                    ,pt_i_TransformCode              IN      xxmx_simple_transforms.transform_code%TYPE
                    ,pt_i_SourceValue                IN      xxmx_simple_transforms.source_value%TYPE
                    ,pt_i_EvaluationMode             IN      xxmx_lookup_values.lookup_code%TYPE
                    ,pt_o_FusionValue                   OUT  xxmx_simple_transforms.fusion_value%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    ,pv_o_ReturnCode                    OUT  VARCHAR2
                    ,pv_o_ReturnMessage                 OUT  VARCHAR2                   
                    );
                    --
     --** END PROCEDURE evaluate_transform
     /*
     *****************************************
     ** FUNCTION: get_core_parameter_value
     **
     ** Called from Maximise Core procedures.
     *****************************************
     */
     --
     FUNCTION get_core_parameter_value
                    (
                     pt_i_ParameterCode              IN      xxmx_core_parameters.parameter_code%TYPE
                    )
     RETURN VARCHAR2;
     --
     --
      /*
     ***************************************************
     ** PROCEDURE: upd_file_migration_details
     **
     ** Called from the Dynamic SQL procedure
     ** "xxmx_dynamic_sql_pkg.prevalidate_stg_data" as
     ** that is the first Maximise process which operates
     ** on the Client Data at the Sub-Entity Level when
     ** Client Data is being loaded from Data Files.
     ***************************************************
     */
     --
     PROCEDURE upd_file_migration_details
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_details.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_details.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_details.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_details.sub_entity%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_details.file_set_id%TYPE
                    ,pt_i_Phase                      IN      xxmx_migration_details.phase%TYPE
                    ,pt_i_ValidateEndTimestamp       IN      xxmx_migration_details.validate_end_timestamp%TYPE
                    ,pt_i_ValidateRowCount           IN      xxmx_migration_details.validate_row_count%TYPE
                    ,pt_i_TransformStartTimestamp    IN      xxmx_migration_details.transform_start_timestamp%TYPE
                    ,pt_i_TransformEndTimestamp      IN      xxmx_migration_details.transform_end_timestamp%TYPE
                    ,pt_i_ExportFileName             IN      xxmx_migration_details.export_file_name%TYPE
                    ,pt_i_ExportStartTimestamp       IN      xxmx_migration_details.export_start_timestamp%TYPE
                    ,pt_i_ExportEndTimestamp         IN      xxmx_migration_details.export_end_timestamp%TYPE
                    ,pt_i_ExportRowCount             IN      xxmx_migration_details.export_row_count%TYPE
                    ,pt_i_ErrorFlag                  IN      xxmx_migration_details.error_flag%TYPE
                    );
                    --
     --** PROCEDURE upd_file_migration_details
     --
     --
     /*
     ***************************************************
     ** PROCEDURE: upd_ext_migration_details
     **
     ** Called from each Maximise Extract procedure when
     ** Client Data is being extracted from a Source
     ** Database via DB Link.
     ***************************************************
     */
     --
     PROCEDURE upd_ext_migration_details
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_details.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_details.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_details.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_details.sub_entity%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_details.migration_set_id%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_details.file_set_id%TYPE
                    ,pt_i_Phase                      IN      xxmx_migration_details.phase%TYPE
                    ,pt_i_ExtractEndTimestamp        IN      xxmx_migration_details.extract_end_timestamp%TYPE
                    ,pt_i_ExtractRowCount            IN      xxmx_migration_details.extract_row_count%TYPE
                    ,pt_i_TransformStartTimestamp    IN      xxmx_migration_details.transform_start_timestamp%TYPE
                    ,pt_i_TransformEndTimestamp      IN      xxmx_migration_details.transform_end_timestamp%TYPE
                    ,pt_i_ExportFileName             IN      xxmx_migration_details.export_file_name%TYPE
                    ,pt_i_ExportStartTimestamp       IN      xxmx_migration_details.export_start_timestamp%TYPE
                    ,pt_i_ExportEndTimestamp         IN      xxmx_migration_details.export_end_timestamp%TYPE
                    ,pt_i_ExportRowCount             IN      xxmx_migration_details.export_row_count%TYPE
                    ,pt_i_ErrorFlag                  IN      xxmx_migration_details.error_flag%TYPE
                    );
                    --
     --** PROCEDURE upd_ext_migration_details     
     /*
     ************************************
     ** PROCEDURE: get_entity_application
     ************************************
     */
     --
     PROCEDURE get_entity_application
                    (
                     pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_o_ApplicationSuite              OUT  xxmx_migration_metadata.application_suite%TYPE
                    ,pt_o_Application                   OUT  xxmx_migration_metadata.application%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    ,pt_o_ReturnMessage                 OUT  xxmx_data_messages.data_message%TYPE
                    );
                    --
     --** END FUNCTION get_entity_application
     --
     --
      /*
     *****************************************************************************************
     ** PROCEDURE: valid_business_entity_setup
     **
     ** This function verifies that required metadata has been setup for a single Business
     ** Entity.
     **
     ** Business Entity Level checks are:
     **
     ** 1) XXMX_MIGRATION_METADATA table is populated.  If this isn't populated then no
     **    further verifications can be performed.
     **
     ** Sub-Entity Level checks are:
     **
     ** 2) At least one STG table is defined in the Data Dictionary.
     ** 3) At least one XFM table is defined in the Data Dictionary.
     ** 4) Identifies any STG tables which are not linked to an XFM table.
     ** 5) For those STG tables which are linked to an XFM table, identifies any Client Data
     **    Columns which are not mapped between the two.
     **
     ** File Group Level checks are:
     **
     ** 6) 
     **
     ** This procedure is called from STG_MAIN and or XFM_MAIN.
     *****************************************************************************************
     */
     --
     FUNCTION valid_business_entity_setup
                    (
                     pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE DEFAULT NULL
                    )
     RETURN BOOLEAN;
     --
     --
     /*
     ******************************************
     ** PROCEDURE: init_file_migration_set
     **
     ** Called from the Dynamic SQL STG_MAIN
     ** procedure.
     ******************************************
     */
     --
     PROCEDURE init_file_migration_set
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_headers.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_headers.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_headers.business_entity%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_o_MigrationSetName           OUT  xxmx_Migration_headers.migration_set_name%TYPE
                    );
                    --
     --** PROCEDURE init_file_migration_set
     --
     --
     /*
     ******************************************
     ** PROCEDURE: init_ext_migration_set
     **
     ** Called from the Dynamic SQL STG_MAIN
     ** procedure.
     ******************************************
     */
     --
     PROCEDURE init_ext_migration_set
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_headers.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_headers.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_headers.business_entity%TYPE
                    ,pt_o_MigrationSetID             OUT  xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_o_MigrationSetName           OUT  xxmx_Migration_headers.migration_set_name%TYPE
                    );

    -- ----------------------------------------------------------------------------
    -- |-----------------------------< WRITE_CSV >-------------------------|
    -- ----------------------------------------------------------------------------
    --
    PROCEDURE write_csv (pv_i_business_entity  IN VARCHAR2
                            ,pv_i_file_name        IN VARCHAR2
                            ,pv_i_data             IN VARCHAR2
                            ,pv_i_line_type        IN   VARCHAR2
                            ,pv_i_file_type        IN VARCHAR2 DEFAULT 'M');
    -- ----------------------------------------------------------------------------
     -- |------------------------------< OPEN_CSV >--------------------------------|
     -- ----------------------------------------------------------------------------
     PROCEDURE  open_csv (    pv_i_business_entity               IN   VARCHAR2
                            ,pv_i_file_name                     IN   VARCHAR2
                            ,pv_i_hdrname                       IN   VARCHAR2 DEFAULT NULL
                            ,pv_i_directory_name                IN   VARCHAR2
                            ,pv_i_line_type                     IN   VARCHAR2
                            ,pv_i_data                          IN   VARCHAR2
                            ,pv_o_ReturnStatus                  OUT  VARCHAR2
                            ,pt_o_ReturnMessage                 OUT  xxmx_data_messages.data_message%TYPE);
    -- ----------------------------------------------------------------------------
     -- |------------------------------< p_extract_data >--------------------------------|
     -- ----------------------------------------------------------------------------
      PROCEDURE p_extract_data( 
                           pv_i_application_suite VARCHAR2
                        , pv_i_business_entity VARCHAR2						
                        , pv_i_stage VARCHAR2 default null
                        );
      -- ----------------------------------------------------------------------------
     -- |------------------------------< get_csvdata_count >--------------------------------|
     -- ----------------------------------------------------------------------------
      FUNCTION get_csvdata_count  (   
                                          pv_i_application_suite   VARCHAR2,
                                      pv_i_filename     VARCHAR2
                                  )
       RETURN NUMBER;
	   
	-- ----------------------------------------------------------------------------
     -- |------------------------------< get_stgxfm_data_count >--------------------------------|
     -- ----------------------------------------------------------------------------
	   
	FUNCTION get_stgxfm_data_count (
        pv_i_table_name VARCHAR2
    ) RETURN NUMBER;

	-- ----------------------------------------------------------------------------
     -- |------------------------------< insert_into_arch_table >--------------------------------|
     -- ----------------------------------------------------------------------------	
	PROCEDURE insert_into_arch_table( pv_i_table_name VARCHAR2
                    );
					
	-- ----------------------------------------------------------------------------
     -- |------------------------------< truncate_stg_xfm_table >--------------------------------|
     -- ----------------------------------------------------------------------------	
	PROCEDURE truncate_stg_xfm_table( pv_i_table_name VARCHAR2
                    );
	
	-- ----------------------------------------------------------------------------
     -- |------------------------------< delete_mapping_master >--------------------------------|
     -- ----------------------------------------------------------------------------
	PROCEDURE delete_mapping_master( pv_i_application_suite VARCHAR2 default 'ALL');
	
	-- ----------------------------------------------------------------------------
     -- |------------------------------< truncate_table >--------------------------------|
     -- ----------------------------------------------------------------------------
	PROCEDURE truncate_table(pv_i_table_name VARCHAR2);
	
	-- ----------------------------------------------------------------------------
     -- |------------------------------< generate_table_data >--------------------------------|
     -- ----------------------------------------------------------------------------
	PROCEDURE generate_table_data(pv_i_table_name IN VARCHAR2);
	
	-- ----------------------------------------------------------------------------
     -- |------------------------------< get_excel_data_header >--------------------------------|
     -- ----------------------------------------------------------------------------
	FUNCTION get_excel_data_header( pv_i_sub_entity varchar2 DEFAULT NULL,
									pv_i_table_name  varchar2 DEFAULT NULL
								   )
	return clob;
	
	-- ----------------------------------------------------------------------------
     -- |------------------------------< call_fusion_load_gen >--------------------------------|
     -- ----------------------------------------------------------------------------
	PROCEDURE call_fusion_load_gen(
                     pv_i_application_suite         IN      VARCHAR2
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_sub_entity            IN      xxmx_migration_metadata.sub_entity%TYPE 
                   );
				   
	-- ----------------------------------------------------------------------------
     -- |------------------------------< get_FBDI_filenames >--------------------------------|
     -- ----------------------------------------------------------------------------
	PROCEDURE get_FBDI_filenames(pv_i_application_suite IN  VARCHAR2,
                             pv_i_business_entity   IN  VARCHAR2,
                             pv_i_sub_entity        IN  VARCHAR2,
                             pv_o_fbdi_filenames    OUT XMLType);

END xxmx_utilities_pkg;
/
--
--
SHOW ERRORS PACKAGE xxmx_utilities_pkg;
--
--
PROMPT
PROMPT
PROMPT *********************************************
PROMPT ** Creating Package Body : xxmx_utilities_pkg
PROMPT *********************************************
PROMPT
--
create or replace PACKAGE BODY             "XXMX_UTILITIES_PKG" 
IS
     --
     --
     /*
     **********************
     ** GLOBAL DECLARATIONS
     **********************
     */
     --
     /*
     ** Global Constants for use in all xxmx_utilities_pkg Procedure/Function Calls within this package.
     */
     --
     gct_PackageName                 CONSTANT  xxmx_module_messages.package_name%TYPE       := 'XXMX_UTILITIES_PKG';
     gct_ApplicationSuite            CONSTANT  xxmx_module_messages.application_suite%TYPE  := 'XXMX';
     gct_Application                 CONSTANT  xxmx_module_messages.application%TYPE        := 'XXMX';
     gct_Phase                                 xxmx_module_messages.phase%TYPE              := 'CORE';
     gct_BusinessEntity              CONSTANT  xxmx_migration_metadata.business_entity%TYPE := 'XXMX_CORE';
     gct_SubEntity                   CONSTANT  xxmx_module_messages.sub_entity%TYPE         := 'XXMX_UTILITIES';
     gvv_ReturnStatus                          VARCHAR2(1);
     gvv_ReturnCode                            VARCHAR2(50);
     gvt_ReturnMessage                         xxmx_module_messages.module_message%TYPE;
     gvt_StgPopulationMethod                   xxmx_core_parameters.parameter_value%TYPE;
     gvt_BEApplicationSuite                    xxmx_migration_metadata.application_suite%TYPE;
     gvt_BEApplication                         xxmx_migration_metadata.application%TYPE;

     --
     /*
     ** Global Variables for use in all Procedures/Functions within this package.
     */
     --
     gvv_ApplicationErrorMessage               VARCHAR2(2048);
     gvv_ProgressIndicator                     VARCHAR2(100);
     --
     /*
     ** Global Variables for Exception Handlers.
     */
     --
     gvt_Severity                              xxmx_module_messages.severity%TYPE;
     gvt_ModuleMessage                         xxmx_module_messages.module_message%TYPE;
     gvt_OracleError                           xxmx_module_messages.oracle_error%TYPE;

     g_file_id        UTL_FILE.FILE_TYPE; 

     --
     /*
     ** Global constants and variables for dynamic SQL usage.
     */
     --
     gcv_SQLSpace                    CONSTANT  VARCHAR2(1)     := ' ';
     gvv_SQLAction                                      VARCHAR2(20);
     gvv_SQLTableClause                                 VARCHAR2(100);
     gvv_SQLColumnList                                  VARCHAR2(4000);
     gvv_SQLValuesList                                  VARCHAR2(4000);
     gvv_SQLWhereClause                                 VARCHAR2(4000);
     gvv_SQLStatement                                   VARCHAR2(32000);
     gvv_SQLResult                                      VARCHAR2(4000);
     gvn_ExistenceCheckCount                            NUMBER;
     --
     --
     --
     /*
     **************************************
     ** PROCEDURE AND FUNCTION DECLARATIONS
     **************************************
     */
     --
     --
     /*
     **********************************
     ** PROCEDURE: log_module_message
     **
     ** Called from various procedures.
     **********************************
     */
     --
     PROCEDURE log_module_message
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_module_messages.sub_entity%TYPE
                    ,pt_i_Phase                      IN      xxmx_module_messages.phase%TYPE
                    ,pt_i_Severity                   IN      xxmx_module_messages.severity%TYPE
                    ,pt_i_PackageName                IN      xxmx_module_messages.package_name%TYPE
                    ,pt_i_ProcOrFuncName             IN      xxmx_module_messages.proc_or_func_name%TYPE
                    ,pt_i_ProgressIndicator          IN      xxmx_module_messages.progress_indicator%TYPE
                    ,pt_i_ModuleMessage              IN      xxmx_module_messages.module_message%TYPE
                    ,pt_i_OracleError                IN      xxmx_module_messages.oracle_error%TYPE
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'log_module_message';
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
          IF   LENGTH(pt_i_ApplicationSuite) > 4
          THEN
               --
               gvt_ModuleMessage := 'pt_i_ApplicationSuite parameter must be 4 characters or less.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          IF   LENGTH(pt_i_Application) > 4
          THEN
               --
               gvt_ModuleMessage := 'pt_i_Application parameter must be 4 characters or less.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          IF   UPPER(pt_i_Phase) NOT IN ('CORE', 'EXTRACT', 'TRANSFORM', 'EXPORT')
          THEN
               --
               gvt_ModuleMessage := 'pt_i_Phase parameter must be "CORE,", "EXTRACT", "TRANSFORM" or "EXPORT".';
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
          INTO   xxmx_module_messages
                 (
                  module_message_id
                 ,application_suite
                 ,application
                 ,business_entity
                 ,sub_entity
                 ,phase
                 ,message_timestamp
                 ,severity
                 ,package_name
                 ,proc_or_func_name
                 ,progress_indicator
                 ,module_message
                 ,oracle_error
                 )
          VALUES
                 (
                  xxmx_module_message_ids_s.NEXTVAL  -- module_message_id
                 ,UPPER(pt_i_ApplicationSuite)       -- application_suite
                 ,UPPER(pt_i_Application)            -- application
                 ,UPPER(pt_i_BusinessEntity)         -- business_entity
                 ,UPPER(pt_i_SubEntity)              -- sub_entity
                 ,UPPER(pt_i_Phase)                  -- phase
                 ,LOCALTIMESTAMP(3)                  -- message_timestamp
                 ,UPPER(pt_i_Severity)               -- severity
                 ,LOWER(pt_i_PackageName)            -- package_name
                 ,LOWER(pt_i_ProcOrFuncName)         -- proc_or_func_name
                 ,pt_i_ProgressIndicator             -- progress_indicator
                 ,pt_i_ModuleMessage                 -- module_message
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
                    INTO   xxmx_module_messages
                           (
                            module_message_id
                           ,application_suite
                           ,application
                           ,business_entity
                           ,sub_entity
                           ,phase
                           ,message_timestamp
                           ,severity
                           ,package_name
                           ,proc_or_func_name
                           ,progress_indicator
                           ,module_message
                           ,oracle_error
                           )
                    VALUES
                           (
                            xxmx_module_message_ids_s.NEXTVAL  -- module_message_id
                           ,'XXMX'                             -- application_suite
                           ,'XXMX'                             -- application
                           ,gct_BusinessEntity                 -- business_entity
                           ,gct_SubEntity                      -- sub_entity
                           ,'CORE'                             -- phase
                           ,LOCALTIMESTAMP(3)                  -- message_timestamp
                           ,'ERROR'                            -- severity
                           ,LOWER(gct_PackageName)             -- package_name
                           ,LOWER(ct_ProcOrFuncName)           -- proc_or_func_name
                           ,gvv_ProgressIndicator              -- progress_indicator
                           ,gvt_ModuleMessage                  -- module_message
                           ,gvt_OracleError                    -- oracle_error
                           );
                    --
                    COMMIT; --** Commit the message to the Module Messages table.
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
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    INSERT
                    INTO   xxmx_module_messages
                           (
                            module_message_id
                           ,application_suite
                           ,application
                           ,business_entity
                           ,sub_entity
                           ,phase
                           ,message_timestamp
                           ,severity
                           ,package_name
                           ,proc_or_func_name
                           ,progress_indicator
                           ,module_message
                           ,oracle_error
                           )
                    VALUES
                           (
                            xxmx_module_message_ids_s.NEXTVAL                     -- module_message_id
                           ,'XXMX'                                                -- application_suite
                           ,'XXMX'                                                -- application
                           ,gct_BusinessEntity                                    -- business_entity
                           ,gct_SubEntity                                         -- sub_entity
                           ,'CORE'                                                -- phase
                           ,LOCALTIMESTAMP(3)                                     -- message_timestamp
                           ,'ERROR'                                               -- severity
                           ,LOWER(gct_PackageName)                                -- package_name
                           ,LOWER(ct_ProcOrFuncName)                              -- proc_or_func_name
                           ,gvv_ProgressIndicator                                 -- progress_indicator
                           ,'Oracle error encountered after Progress Indicator.'  -- module_message
                           ,gvt_OracleError                                       -- oracle_error
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
     END log_module_message;
     --
     --
     /*
     **********************************
     ** PROCEDURE: log_module_message
     **
     ** Called from various procedures.
     **********************************
     */
     --
     PROCEDURE log_module_message
                    (
                     pt_i_ApplicationSuite           IN      xxmx_module_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_module_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_module_messages.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_module_messages.sub_entity%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_module_messages.file_set_id%TYPE DEFAULT 0
                    ,pt_i_MigrationSetID             IN      xxmx_module_messages.migration_set_id%TYPE
                    ,pt_i_Phase                      IN      xxmx_module_messages.phase%TYPE
                    ,pt_i_Severity                   IN      xxmx_module_messages.severity%TYPE
                    ,pt_i_PackageName                IN      xxmx_module_messages.package_name%TYPE
                    ,pt_i_ProcOrFuncName             IN      xxmx_module_messages.proc_or_func_name%TYPE
                    ,pt_i_ProgressIndicator          IN      xxmx_module_messages.progress_indicator%TYPE
                    ,pt_i_ModuleMessage              IN      xxmx_module_messages.module_message%TYPE
                    ,pt_i_OracleError                IN      xxmx_module_messages.oracle_error%TYPE
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'log_module_message';
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
          IF   LENGTH(pt_i_ApplicationSuite) > 4
          THEN
               --
               gvt_ModuleMessage := 'pt_i_ApplicationSuite parameter must be 4 characters or less.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          IF   LENGTH(pt_i_Application) > 4
          THEN
               --
               gvt_ModuleMessage := 'pt_i_Application parameter must be 4 characters or less.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          IF   UPPER(pt_i_Phase) NOT IN ('CORE', 'EXTRACT', 'TRANSFORM', 'EXPORT')
          THEN
               --
               gvt_ModuleMessage := 'pt_i_Phase parameter must be "CORE,", "EXTRACT", "TRANSFORM" or "EXPORT".';
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
          INTO   xxmx_module_messages
                 (
                  module_message_id
                 ,application_suite
                 ,application
                 ,business_entity
                 ,sub_entity
                 ,migration_set_id
                 ,phase
                 ,message_timestamp
                 ,severity
                 ,package_name
                 ,proc_or_func_name
                 ,progress_indicator
                 ,module_message
                 ,oracle_error
                 )
          VALUES
                 (
                  xxmx_module_message_ids_s.NEXTVAL  -- module_message_id
                 ,UPPER(pt_i_ApplicationSuite)       -- application_suite
                 ,UPPER(pt_i_Application)            -- application
                 ,UPPER(pt_i_BusinessEntity)         -- business_entity
                 ,UPPER(pt_i_SubEntity)              -- sub_entity
                 ,pt_i_MigrationSetID                -- migration_set_id
                 ,UPPER(pt_i_Phase)                  -- phase
                 ,LOCALTIMESTAMP(3)                  -- message_timestamp
                 ,UPPER(pt_i_Severity)               -- severity
                 ,LOWER(pt_i_PackageName)            -- package_name
                 ,LOWER(pt_i_ProcOrFuncName)         -- proc_or_func_name
                 ,pt_i_ProgressIndicator             -- progress_indicator
                 ,pt_i_ModuleMessage                 -- module_message
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
                    INTO   xxmx_module_messages
                           (
                            module_message_id
                           ,application_suite
                           ,application
                           ,business_entity
                           ,sub_entity
                           ,migration_set_id
                           ,phase
                           ,message_timestamp
                           ,severity
                           ,package_name
                           ,proc_or_func_name
                           ,progress_indicator
                           ,module_message
                           ,oracle_error
                           )
                    VALUES
                           (
                            xxmx_module_message_ids_s.NEXTVAL  -- module_message_id
                           ,'XXMX'                             -- application_suite
                           ,'XXMX'                             -- application
                           ,gct_BusinessEntity                 -- business_entity
                           ,gct_SubEntity                      -- sub_entity
                           ,pt_i_MigrationSetID                -- migration_set_id
                           ,'CORE'                             -- phase
                           ,LOCALTIMESTAMP(3)                  -- message_timestamp
                           ,'ERROR'                            -- severity
                           ,LOWER(gct_PackageName)             -- package_name
                           ,LOWER(ct_ProcOrFuncName)           -- proc_or_func_name
                           ,gvv_ProgressIndicator              -- progress_indicator
                           ,gvt_ModuleMessage                  -- module_message
                           ,gvt_OracleError                    -- oracle_error
                           );
                    --
                    COMMIT; --** Commit the message to the Module Messages table.
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
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    INSERT
                    INTO   xxmx_module_messages
                           (
                            module_message_id
                           ,application_suite
                           ,application
                           ,business_entity
                           ,sub_entity
                           ,migration_set_id
                           ,phase
                           ,message_timestamp
                           ,severity
                           ,package_name
                           ,proc_or_func_name
                           ,progress_indicator
                           ,module_message
                           ,oracle_error
                           )
                    VALUES
                           (
                            xxmx_module_message_ids_s.NEXTVAL                     -- module_message_id
                           ,'XXMX'                                                -- application_suite
                           ,'XXMX'                                                -- application
                           ,gct_BusinessEntity                                    -- business_entity
                           ,gct_SubEntity                                         -- sub_entity
                           ,pt_i_MigrationSetID                                   -- migration_set_id
                           ,'CORE'                                                -- phase
                           ,LOCALTIMESTAMP(3)                                     -- message_timestamp
                           ,'ERROR'                                               -- severity
                           ,LOWER(gct_PackageName)                                -- package_name
                           ,LOWER(ct_ProcOrFuncName)                              -- proc_or_func_name
                           ,gvv_ProgressIndicator                                 -- progress_indicator
                           ,'Oracle error encountered after Progress Indicator.'  -- module_message
                           ,gvt_OracleError                                       -- oracle_error
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
     END log_module_message;
     --
     --
     /*
     **********************************
     ** PROCEDURE: log_data_message
     **
     ** Called from various procedures.
     **********************************
     */
     --
     PROCEDURE log_data_message
                    (
                     pt_i_ApplicationSuite           IN      xxmx_data_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_data_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_data_messages.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_data_messages.sub_entity%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_data_messages.migration_set_id%TYPE
                    ,pt_i_Phase                      IN      xxmx_data_messages.phase%TYPE
                    ,pt_i_Severity                   IN      xxmx_data_messages.severity%TYPE
                    ,pt_i_DataTable                  IN      xxmx_data_messages.data_table%TYPE
                    ,pt_i_RecordIdentifiers          IN      xxmx_data_messages.record_identifiers%TYPE
                    ,pt_i_DataMessage                IN      xxmx_data_messages.data_message%TYPE
                    ,pt_i_DataElementsAndValues      IN      xxmx_data_messages.data_elements_and_values%TYPE
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'log_data_message';
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
          --
     --** END Declarations **
     --
     BEGIN
          --
          gvv_ProgressIndicator := '0010';
          --
          --** Insert data message record.
          --
          IF   LENGTH(pt_i_ApplicationSuite) > 4
          THEN
               --
               gvt_ModuleMessage := 'pt_i_ApplicationSuite parameter must be 4 characters or less.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          IF   LENGTH(pt_i_Application) > 4
          THEN
               --
               gvt_ModuleMessage := 'pt_i_Application parameter must be 4 characters or less.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          IF   UPPER(pt_i_Phase) NOT IN ('EXTRACT', 'TRANSFORM', 'EXPORT')
          THEN
               --
               gvt_ModuleMessage := 'pt_i_Phase parameter must be "EXTRACT", "TRANSFORM" or "EXPORT".';
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
          INTO   xxmx_data_messages
                 (
                  data_message_id
                 ,application_suite
                 ,application
                 ,business_entity
                 ,sub_entity
                 ,migration_set_id
                 ,phase
                 ,message_timestamp
                 ,severity
                 ,data_table
                 ,record_identifiers
                 ,data_message
                 ,data_elements_and_values
                 )
          VALUES
                 (
                  xxmx_data_message_ids_s.NEXTVAL  -- data_message_id
                 ,UPPER(pt_i_ApplicationSuite)     -- application_suite
                 ,UPPER(pt_i_Application)          -- application
                 ,UPPER(pt_i_BusinessEntity)       -- business_entity
                 ,UPPER(pt_i_SubEntity)            -- sub_entity
                 ,pt_i_MigrationSetID              -- migration_set_id
                 ,UPPER(pt_i_Phase)                -- phase
                 ,LOCALTIMESTAMP(3)                -- message_timestamp
                 ,UPPER(pt_i_Severity)             -- severity
                 ,LOWER(pt_i_DataTable)            -- data_table
                 ,pt_i_RecordIdentifiers           -- record_identifiers
                 ,pt_i_DataMessage                 -- data_message
                 ,pt_i_DataElementsAndValues       -- data_elements_and_values
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
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => gvt_OracleError
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
                    gvt_ModuleMessage := 'Oracle error encountered after Progress Indicator.';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END log_data_message;
     --
     --
     /*
     **************************************************************
     ** FUNCTION : date_and_time_stamp
     **
     ** The following function returns a date and time stamp in the
     ** format YYYYMMDDHH24MISS which can be used when archiving
     ** files in data cartridges called by the Patech Universal
     ** Interface.
     **************************************************************
     */
     --
     FUNCTION date_and_time_stamp
                   (
                    pv_i_IncludeSeconds             IN      VARCHAR2  DEFAULT 'Y'
                   )
     RETURN VARCHAR2
     IS
          --
          --
          --***********************
          --** Cursor Declarations
          --***********************
          --
          --
          --***********************
          --** Record Declarations
          --***********************
          --
          --
          --*************************
          --** Constant Declarations
          --*************************
          --
          --
          --*************************
          --** Variable Declarations
          --*************************
          --
          vv_DateAndTimeStamp             VARCHAR2(20);
          --
          --**************************
          --** Exception Declarations
          --**************************
          --
          --
     --** END Declarations **
     --
     --
     BEGIN
          --
          IF   pv_i_IncludeSeconds = 'N'
          THEN
               --
               SELECT TO_CHAR(SYSDATE ,'RRRRMMDDHH24MI')
               INTO   vv_DateAndTimeStamp
               FROM   sys.dual;
               --
          ELSE
               --
               SELECT TO_CHAR(SYSDATE ,'RRRRMMDDHH24MISS')
               INTO   vv_DateAndTimeStamp
               FROM   sys.dual;
               --
          END IF;
          --
          RETURN(vv_DateAndTimeStamp);
          --
          EXCEPTION
               --
               WHEN OTHERS
               THEN
                    --
                    RETURN('NONE');
                    --
               --** END OTHERS EXCEPTION **
               --
          --** END EXCEPTION Handler **
          --
     END date_and_time_stamp;
     --
     --
     /*
     ************************************
     ** FUNCTION: convert_string
     **
     ** Remove special characters from an
     ** input string and optionally
     ** perform a SUBSTR operation on it.
     **
     ** Pass a value greater than 0 in
     ** the pi_i_SubstrLength parameter
     ** to enable the Substr to be
     ** performed.
     ************************************
     */
     --
     FUNCTION convert_string
                   (
                    pv_i_StringToConvert            VARCHAR2
                   ,pv_i_ConvertCommaToSpace        VARCHAR2 DEFAULT 'N'
                   ,pi_i_SubstrStartPos             INTEGER  DEFAULT 1
                   ,pi_i_SubstrLength               INTEGER  DEFAULT 0
                   ,pv_i_UseBinarySubstr            VARCHAR2 DEFAULT 'N'
                   )
     RETURN VARCHAR2 IS
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'convert_string';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vv_String                   varchar2(2000) := null;
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
          gvv_ProgressIndicator := '0010';
          --
          vv_String := TRIM(pv_i_StringToConvert);
          --
          /*
          ** Remove commas, replacing them with space.
          */
          --
          IF   UPPER(pv_i_ConvertCommaToSpace) = 'Y'
          THEN
               --
               vv_String := REPLACE(vv_String, ',', ' ');
               --
          END IF;
          --
          gvv_ProgressIndicator := '0020';
          --
          /*
          ** Process special characters
          */
          --
          /*
          ** Replace Copyright Symbol (©) with space
          */
          --
          vv_String := REPLACE(
                               vv_String
                                    ,CHR(49833)
                                    ,' '
                              );
          --
          /*
          ** Replace Special (–) with hyphen
          */
          --
          vv_String := REPLACE(
                               vv_String
                                    ,CHR(14844051)
                                    ,'-'
                              );
          --
          /*
          ** Replace Special (’) with standard single quote.
          */
          --
          vv_String := REPLACE(
                               vv_String
                                    ,CHR(14844057)
                                    ,'`'
                              );
          --
          /*
          ** Replace Special (“) with standard double quote.
          */
          --
          vv_String := TRANSLATE(
                                 vv_String
                                      ,CHR(14844060)
                                      ,'"'
                                );
          --
          /*
          ** Replace Special (”) with standard double quote.
          */
          --
          vv_String := TRANSLATE(
                                 vv_String
                                      ,CHR(14844061)
                                      ,'"'
                                );
          --
          /*
          ** Replace Special (?) with the pound currency symbol.
          */
          --
          vv_String := REPLACE(
                               vv_String
                                    ,CHR(15712189)
                                    ,'£'
                              );
          --
          /*
          ** Replace Carriage Returns/Line Feeds with space.
          */
          --
          vv_String := REPLACE(
                               vv_String
                                   ,CHR(9)
                                   ,' '
                              );
          --
          vv_String := REPLACE(
                               vv_String
                                    ,CHR(10)
                                    ,' '
                              );
          --
          vv_String := REPLACE(
                               vv_String
                                    ,CHR(13)
                                    ,' '
                              );
          --
          /*
          ** Replace NULL with character equivalent.
          */
          --
          vv_String := REPLACE(
                               vv_String
                                    ,CHR(0)
                                    ,''
                              );
          --
          --/*
          --** Handling double quote (not sure if this was needed in the first place or if it is needed for Maximise so commenting out for now)
          --*/
          ----
          --vv_String := LTRIM(vv_String,'"');
          ----
          --IF   SUBSTR(vv_String, LENGTH(vv_String), 1) = '"'
          --AND  ASCII(SUBSTR(vv_String, LENGTH(vv_String)-1, 1)) NOT BETWEEN 48 AND 57
          --THEN
          --     --
          --     vv_String := rtrim(vv_String,'"');
          --     --
          --     fin_utilities_pkg.print_log('rtrim double quoate '||vv_String);
          --     --
          --END IF;
          ----
          --vv_String := REPLACE(vv_String,'"','""');
          ----
          --vv_String := trim(vv_String);
          ----
          ---- Check the string length in case it is longer than it should be
          ----
          --IF   LENGTH(vv_String) > p_length
          --THEN
          --     --
          --     vv_String := substr(vv_String,1,p_length);
          --     --
          --END IF;
          --
          IF   pi_i_SubstrLength > 0
          THEN
               --
               IF   pv_i_UseBinarySubstr = 'Y'
               THEN
                    --
                    vv_String := SUBSTRB(
                                         vv_String
                                        ,pi_i_SubstrStartPos
                                        ,pi_i_SubstrLength
                                        );
                    --
               ELSE
                    --
                    vv_String := SUBSTR(
                                        vv_String
                                       ,pi_i_SubstrStartPos
                                       ,pi_i_SubstrLength
                                       );
                    --
               END IF;
               --
          END IF;
          --
          RETURN(vv_String);
          --
     END convert_string;
     --
     --
     /*
     ******************************
     ** FUNCTION: valid_lookup_code
     ******************************
     */
     --
     FUNCTION valid_lookup_code
                    (
                     pt_i_LookupType                 IN      xxmx_lookup_values.lookup_type%TYPE
                    ,pt_i_LookupCode                 IN      xxmx_lookup_values.lookup_code%TYPE
                    )
     RETURN BOOLEAN
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'valid_lookup_code';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_ValidLookupCode              xxmx_lookup_values.lookup_code%TYPE;
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
          gvv_ProgressIndicator := '0010';
          --
          SELECT 'Y'
          INTO   vt_ValidLookupCode
          FROM   xxmx_lookup_values  xlv
          WHERE  1 = 1
          AND    xlv.lookup_type            = pt_i_LookupType
          AND    xlv.lookup_code            = pt_i_LookupCode
          AND    NVL(xlv.enabled_flag, 'N') = 'Y';
          --
          RETURN(TRUE);
          --
          EXCEPTION
               --
               WHEN OTHERS
               THEN
                    --
                    RETURN(FALSE);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END valid_lookup_code;
     --
     --
     --******************************************
     --** FUNCTION: get_business_entity_seq
     --**
     --** Called from each Extract Main procedure
     --******************************************
     --
     FUNCTION get_business_entity_seq
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_metadata.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_metadata.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    )
     RETURN xxmx_migration_metadata.business_entity_seq%TYPE
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'get_business_entity_seq';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_BusinessEntitySeq            xxmx_migration_metadata.business_entity_seq%TYPE;
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
          gvv_ProgressIndicator := '0010';
          --
          SELECT DISTINCT
                 xmm.business_entity_seq
          INTO   vt_BusinessEntitySeq
          FROM   xxmx_migration_metadata  xmm
          WHERE  1 = 1
          AND    xmm.application_suite = pt_i_ApplicationSuite
          AND    xmm.application       = pt_i_Application
          AND    xmm.business_entity   = pt_i_BusinessEntity
          AND    xmm.stg_table is not null;
          --
          RETURN(vt_BusinessEntitySeq);
          --
          EXCEPTION
               --
               WHEN NO_DATA_FOUND
               THEN
                    --
                    gvt_ModuleMessage := 'Could not retrieve "business_entity_seq" from "xxmx_migration_metadata" table '
                                       ||'for Business Entity "'
                                       ||pt_i_BusinessEntity
                                       ||'".';
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'WARNING'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RETURN(NULL);
                    --
               --** END NO_DATA_FOUND Exception
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
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    RETURN(NULL);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END get_business_entity_seq;
     --
     --
     /*
     ******************************************
     ** FUNCTION: get_sub_entity_seq
     **
     ** Called from each Extract Main procedure
     ******************************************
     */
     --
     FUNCTION get_sub_entity_seq
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_metadata.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_metadata.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_metadata.business_entity%TYPE
                    )
     RETURN xxmx_migration_metadata.sub_entity_seq%TYPE
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'get_sub_entity_seq';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_SubEntitySeq                 xxmx_client_config_parameters.config_value%TYPE;
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
          gvv_ProgressIndicator := '0010';
          --
          SELECT xmm.sub_entity_seq
          INTO   vt_SubEntitySeq
          FROM   xxmx_migration_metadata  xmm
          WHERE  1 = 1
          AND    xmm.application_suite = pt_i_ApplicationSuite
          AND    xmm.application       = pt_i_Application
          AND    xmm.business_entity   = pt_i_BusinessEntity
          AND    xmm.sub_entity        = pt_i_SubEntity
          AND    xmm.stg_table is not null;
          --
          RETURN(vt_SubEntitySeq);
          --
          EXCEPTION
               --
               WHEN NO_DATA_FOUND
               THEN
                    --
                    gvt_ModuleMessage := 'Could not retrieve "business_entity_seq" and "sub_entity_seq" from "xxmx_migration_metadata" table '
                                       ||'for Business Entity "'
                                       ||pt_i_BusinessEntity
                                       ||'" and Sub-Entity "'
                                       ||pt_i_SubEntity
                                       ||'"';
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'WARNING'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RETURN(NULL);
                    --
               --** END NO_DATA_FOUND Exception
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
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    RETURN(NULL);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END get_sub_entity_seq;
     --
     --
     /*
     **********************************
     ** PROCEDURE: clear_messages
     **
     ** Called from various procedures.
     **********************************
     */
     --
     PROCEDURE clear_messages
                    (
                     pt_i_ApplicationSuite           IN      xxmx_data_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_data_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_data_messages.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_data_messages.sub_entity%TYPE
                    ,pt_i_Phase                      IN      xxmx_data_messages.phase%TYPE
                    ,pt_i_MessageType                IN      VARCHAR2
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'clear_messages';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_RowCount                     NUMBER;
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
          gvv_ProgressIndicator := '0010';
          pv_o_ReturnStatus     := 'S';
          --
          --** Delete message records.
          --
          IF   pt_i_ApplicationSuite IS NULL
          OR   pt_i_Application      IS NULL
          OR   pt_i_BusinessEntity   IS NULL
          OR   pt_i_Phase            IS NULL
          OR   pt_i_MessageType      IS NULL
          THEN
               --
               gvt_ModuleMessage := 'pt_i_ApplicationSuite, pt_i_Application, pt_i_BusinessEntity, pt_i_Phase and pt_i_MessageType parameters are mandatory.';
               --
               RAISE e_ModuleError;
               --
          ELSIF pt_i_MessageType = 'MODULE'
          THEN
               --
               DELETE
               FROM   xxmx_module_messages
               WHERE  1 = 1
               AND    application_suite = pt_i_ApplicationSuite
               AND    application       = pt_i_Application
               AND    phase             = pt_i_Phase
               AND    business_entity   = pt_i_BusinessEntity
               AND    sub_entity        = NVL(pt_i_SubEntity, sub_entity);
               --
               vt_RowCount := SQL%ROWCOUNT;
               --
          ELSIF pt_i_MessageType = 'DATA'
          THEN
               --
               DELETE
               FROM   xxmx_data_messages
               WHERE  1 = 1
               AND    application_suite = pt_i_ApplicationSuite
               AND    application       = pt_i_Application
               AND    phase             = pt_i_Phase
               AND    business_entity   = pt_i_BusinessEntity
               AND    sub_entity        = NVL(pt_i_SubEntity, sub_entity);
               --
               vt_RowCount := SQL%ROWCOUNT;
               --
          ELSE
               --
               gvt_ModuleMessage := 'pt_i_MessageType parameter must have a value of "MODULE" or "DATA".';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_Phase             => gct_Phase
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => gct_SubEntity
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => vt_RowCount
                                        ||' '
                                        ||pt_i_MessageType
                                        ||' message records deleted.'
               ,pt_i_OracleError       => gvt_OracleError
               );
          --
          COMMIT;
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
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
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
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END clear_messages;
     --
     --
     /*
     **********************************
     ** PROCEDURE: clear_messages
     **
     ** Called from various procedures.
     **********************************
     */
     --
     PROCEDURE clear_messages
                    (
                     pt_i_ApplicationSuite           IN      xxmx_data_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_data_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_data_messages.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_data_messages.sub_entity%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_data_messages.migration_set_id%TYPE
                    ,pt_i_Phase                      IN      xxmx_data_messages.phase%TYPE
                    ,pt_i_MessageType                IN      VARCHAR2
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'clear_messages';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_RowCount                     NUMBER;
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
          gvv_ProgressIndicator := '0010';
          pv_o_ReturnStatus     := 'S';
          --
          --** Delete message records.
          --
          IF   pt_i_ApplicationSuite IS NULL
          OR   pt_i_Application      IS NULL
          OR   pt_i_BusinessEntity   IS NULL
          OR   pt_i_Phase            IS NULL
          OR   pt_i_MessageType      IS NULL
          THEN
               --
               gvt_ModuleMessage := 'pt_i_ApplicationSuite, pt_i_Application, pt_i_BusinessEntity, pt_i_Phase and pt_i_MessageType parameters are mandatory.';
               --
               RAISE e_ModuleError;
               --
          ELSIF pt_i_MessageType = 'MODULE'
          THEN
               --
               DELETE
               FROM   xxmx_module_messages
               WHERE  1 = 1
               AND    application_suite = pt_i_ApplicationSuite
               AND    application       = pt_i_Application
               AND    phase             = pt_i_Phase
               AND    business_entity   = pt_i_BusinessEntity
               AND    sub_entity        = NVL(pt_i_SubEntity, sub_entity)
               AND    migration_set_id  = NVL(pt_i_MigrationSetID, migration_set_id);
               --
               vt_RowCount := SQL%ROWCOUNT;
               --
          ELSIF pt_i_MessageType = 'DATA'
          THEN
               --
               DELETE
               FROM   xxmx_data_messages
               WHERE  1 = 1
               AND    application_suite = pt_i_ApplicationSuite
               AND    application       = pt_i_Application
               AND    phase             = pt_i_Phase
               AND    business_entity   = pt_i_BusinessEntity
               AND    sub_entity        = NVL(pt_i_SubEntity, sub_entity)
               AND    migration_set_id  = NVL(pt_i_MigrationSetID, migration_set_id);
               --
               vt_RowCount := SQL%ROWCOUNT;
               --
          ELSE
               --
               gvt_ModuleMessage := 'pt_i_MessageType parameter must have a value of "MODULE" or "DATA".';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_Phase             => gct_Phase
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => gct_SubEntity
               ,pt_i_MigrationSetID    => pt_i_MigrationSetID
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => vt_RowCount
                                        ||' '
                                        ||pt_i_MessageType
                                        ||' message records deleted.'
               ,pt_i_OracleError       => gvt_OracleError
               );
          --
          COMMIT;
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
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
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
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END clear_messages;
     --
     --
     /*
     ******************************************
     ** FUNCTION: get_client_config_value
     **
     ** Called from each Extract Main procedure
     ******************************************
     */
     --
     FUNCTION get_client_config_value
                    (
                     pt_i_ClientCode                 IN      xxmx_client_config_parameters.client_code%TYPE
                    ,pt_i_ConfigParameter            IN      xxmx_client_config_parameters.config_parameter%TYPE
                    )
     RETURN VARCHAR2
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'get_client_config_value';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_ConfigValue            xxmx_client_config_parameters.config_value%TYPE;
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
          gvv_ProgressIndicator := '0010';
          --
          SELECT  xccp.config_value
          INTO    vt_ConfigValue
          FROM    xxmx_client_config_parameters  xccp
          WHERE   1 = 1
          AND     xccp.client_code      = pt_i_ClientCode
          AND     xccp.config_parameter = pt_i_ConfigParameter;
          --
          RETURN(vt_ConfigValue);
          --
          EXCEPTION
               --
               WHEN TOO_MANY_ROWS
               THEN
                    --
                    gvt_ModuleMessage := 'Too many matches found for Client Code "'
                                       ||pt_i_ClientCode
                                       ||'" and Config Parameter "'
                                       ||pt_i_ConfigParameter
                                       ||'" in "xxmx_client_config_parameters" table.  No config value returned.';
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'WARNING'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RETURN(NULL);
                    --
               --** END TOO_MANY_ROWS Exception
               --
               WHEN NO_DATA_FOUND
               THEN
                    --
                    gvt_ModuleMessage := 'No matches found for Client Code "'
                                       ||pt_i_ClientCode
                                       ||'" and Config Parameter "'
                                       ||pt_i_ConfigParameter
                                       ||'" in "xxmx_client_config_parameters" table.  No config value returned.';
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'WARNING'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RETURN(NULL);
                    --
               --** END NO_DATA_FOUND Exception
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    vt_ConfigValue := NULL;
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END get_client_config_value;
     --
     --
     /*
     ************************************
     ** FUNCTION: verify_parameter_exists
     **
     ** Called from various procedures.
     ************************************
     */
     --
     FUNCTION verify_parameter_exists
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_parameters.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_parameters.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_parameters.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_parameters.sub_entity%TYPE
                    ,pt_i_ParameterCode              IN      xxmx_migration_parameters.parameter_code%TYPE
                    )
     RETURN VARCHAR2
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'verify_parameter_exists';
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
          --
     --** END Declarations **
     --
     BEGIN
          --
          gvv_ProgressIndicator := '0010';
          --
          SELECT COUNT(1)
          INTO   gvn_ExistenceCheckCount
          FROM   xxmx_migration_parameters
          WHERE  1 = 1
          AND    application_suite      = pt_i_ApplicationSuite
          AND    application            = pt_i_Application
          AND    business_entity        = pt_i_BusinessEntity
          AND    sub_entity             = pt_i_SubEntity
          AND    parameter_code         = pt_i_ParameterCode
          AND    NVL(enabled_flag, 'N') = 'Y';
          --
          IF   gvn_ExistenceCheckCount > 1
          THEN
               --
               RETURN('LIST');
               --
          ELSIF gvn_ExistenceCheckCount = 1
          THEN
               --
               RETURN('SINGLE');
               --
          ELSE
               --
               RETURN('NONE');
               --
          END IF;
          --
          EXCEPTION
               --
               WHEN NO_DATA_FOUND
               THEN
                    --
                    gvt_ModuleMessage := 'No matches found for Parameter Code "'
                                       ||pt_i_ParameterCode
                                       ||'" in "xxmx_migration_parameters" table.  No parameter value returned.';
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'WARNING'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RETURN('NONE');
                    --
               --** END NO_DATA_FOUND Exception
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
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END verify_parameter_exists;
     --
     --
     /*
     *****************************************
     ** FUNCTION: get_single_parameter_value
     **
     ** Called from various Extract procedures
     ** and Scope Views.
     *****************************************
     */
     --
     FUNCTION get_single_parameter_value
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_parameters.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_parameters.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_parameters.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_parameters.sub_entity%TYPE
                    ,pt_i_ParameterCode              IN      xxmx_migration_parameters.parameter_code%TYPE
                    )
     RETURN VARCHAR2
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'get_single_parameter_value';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_ParameterValue               xxmx_migration_parameters.parameter_value%TYPE;
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
          gvv_ProgressIndicator := '0010';
          --
          SELECT parameter_value
          INTO   vt_ParameterValue
          FROM   xxmx_migration_parameters
          WHERE  1 = 1
          AND    application_suite      = pt_i_ApplicationSuite
          AND    application            = pt_i_Application
          AND    business_entity        = pt_i_BusinessEntity
          AND    sub_entity             = pt_i_SubEntity
          AND    parameter_code         = pt_i_ParameterCode
          AND    NVL(enabled_flag, 'N') = 'Y';
          --
          RETURN(vt_ParameterValue);
          --
          EXCEPTION
               --
               WHEN TOO_MANY_ROWS
               THEN
                    --
                    gvt_ModuleMessage := 'Too many matches found for Parameter Code "'
                                       ||pt_i_ParameterCode
                                       ||'" in "xxmx_migration_parameters" table.  No parameter value returned.';
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'WARNING'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RETURN(NULL);
                    --
               --** END TOO_MANY_ROWS Exception
               --
               WHEN NO_DATA_FOUND
               THEN
                    --
                    gvt_ModuleMessage := 'No matches found for Parameter Code "'
                                       ||pt_i_ParameterCode
                                       ||'" in "xxmx_migration_parameters" table.  No parameter value returned.';
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'WARNING'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RETURN(NULL);
                    --
               --** END NO_DATA_FOUND Exception
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
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END get_single_parameter_value;
     --
     --
     /*
     *****************************************
     ** FUNCTION: get_parameter_value_list
     **
     ** Called from various Extract procedures
     ** and Scope Views.
     *****************************************
     */
     --
     FUNCTION get_parameter_value_list
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_parameters.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_parameters.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_parameters.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_parameters.sub_entity%TYPE
                    ,pt_i_ParameterCode              IN      xxmx_migration_parameters.parameter_code%TYPE
                    ,pn_o_ReturnCount                   OUT  NUMBER
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    ,pv_o_ReturnMessage                 OUT  VARCHAR2
                    )
     RETURN g_ParamValueList_tt
     IS
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
          CURSOR ParameterValues_cur
                    (
                     pt_ApplicationSuite             xxmx_migration_parameters.application_suite%TYPE
                    ,pt_Application                  xxmx_migration_parameters.application%TYPE
                    ,pt_BusinessEntity               xxmx_migration_parameters.business_entity%TYPE
                    ,pt_SubEntity                    xxmx_migration_parameters.sub_entity%TYPE
                    ,pt_ParameterCode                xxmx_migration_parameters.parameter_code%TYPE
                    )
          IS
               --
               SELECT xmp.parameter_value
               FROM   xxmx_migration_parameters  xmp
               WHERE  1 = 1
               AND    xmp.application_suite      = pt_ApplicationSuite
               AND    xmp.application            = pt_Application
               AND    xmp.business_entity        = 'ALL'
               AND    xmp.sub_entity             = 'ALL'
               AND    xmp.parameter_code         = pt_ParameterCode
               AND    NVL(xmp.enabled_flag, 'N') = 'Y'
               AND    NOT EXISTS (
                                  SELECT 'X'
                                  FROM   xxmx_migration_parameters  xmp2
                                  WHERE  1 = 1
                                  AND    xmp2.application_suite      = pt_ApplicationSuite
                                  AND    xmp2.application            = pt_Application
                                  AND    xmp2.business_entity        = pt_BusinessEntity
                                  AND    (
                                             xmp2.sub_entity         = pt_SubEntity
                                          OR xmp2.sub_entity         = 'ALL'
                                         )
                                  AND    xmp2.parameter_code         = pt_ParameterCode
                                  AND    NVL(xmp2.enabled_flag, 'N') = 'Y'
                                 )
               UNION
               SELECT xmp4.parameter_value
               FROM   xxmx_migration_parameters  xmp4
               WHERE  1 = 1
               AND    xmp4.application_suite      = pt_ApplicationSuite
               AND    xmp4.application            = pt_Application
               AND    xmp4.business_entity        = pt_BusinessEntity
               AND    xmp4.sub_entity             = 'ALL'
               AND    xmp4.parameter_code         = pt_ParameterCode
               AND    NVL(xmp4.enabled_flag, 'N') = 'Y'
               AND    NOT EXISTS (
                                  SELECT 'X'
                                  FROM   xxmx_migration_parameters  xmp5
                                  WHERE  1 = 1
                                  AND    xmp5.application_suite      = pt_ApplicationSuite
                                  AND    xmp5.application            = pt_Application
                                  AND    xmp5.business_entity        = pt_BusinessEntity
                                  AND    xmp5.sub_entity             = pt_SubEntity
                                  AND    xmp5.parameter_code         = pt_ParameterCode
                                  AND    NVL(xmp5.enabled_flag, 'N') = 'Y'
                                 )
               UNION
               SELECT xmp6.parameter_value
               FROM   xxmx_migration_parameters  xmp6
               WHERE  1 = 1
               AND    xmp6.application_suite      = pt_ApplicationSuite
               AND    xmp6.application            = pt_Application
               AND    xmp6.business_entity        = pt_BusinessEntity
               AND    xmp6.sub_entity             = pt_SubEntity
               AND    xmp6.parameter_code         = pt_ParameterCode
               AND    NVL(xmp6.enabled_flag, 'N') = 'Y';
               --
          --** END CURSOR ParameterValues_cur
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'get_parameter_value_list';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          --
          --****************************
          --** Record Table Declarations
          --****************************
          --
          --
          --****************************
          --** PL/SQL Table Declarations
          --****************************
          --
          EmptyParameterValues_tbl        g_ParamValueList_tt;
          ParameterValues_tbl             g_ParamValueList_tt;
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
          gvv_ProgressIndicator := '0010';
          --
          pn_o_ReturnCount   := 0;
          pv_o_ReturnStatus  := 'S';
          pv_o_ReturnMessage := '';
          --
          OPEN  ParameterValues_cur
                    (
                     pt_i_ApplicationSuite
                    ,pt_i_Application
                    ,pt_i_BusinessEntity
                    ,pt_i_SubEntity
                    ,pt_i_ParameterCode
                    );
          --
          gvv_ProgressIndicator := '0020';
          --
          IF   ParameterValues_cur%NOTFOUND
          THEN
               --
               ParameterValues_tbl := EmptyParameterValues_tbl;
               pv_o_ReturnStatus   := 'F';
               pv_o_ReturnMessage  := 'No "'
                                    ||pt_i_ParameterCode
                                    ||'" parameter vaues found in XXMX_MIGRATION_PARAMS table for Application Suite "'
                                    ||pt_i_ApplicationSuite
                                    ||'", Application "'
                                    ||pt_i_Application
                                    ||'", Entity "'
                                    ||pt_i_BusinessEntity
                                    ||'" (or "ALL").  Parameter values list PL/SQL table is empty.';
               --
               CLOSE ParameterValues_cur;
               --
               RETURN(ParameterValues_tbl);
               --
          END IF;
          --
          gvv_ProgressIndicator := '0030';
          --
          FETCH        ParameterValues_cur
          BULK COLLECT
          INTO         ParameterValues_tbl;
          --
          gvv_ProgressIndicator := '0040';
          --
          CLOSE  ParameterValues_cur;
          --
          gvv_ProgressIndicator := '0050';
          --
          SELECT COUNT(1)
          INTO   pn_o_ReturnCount
          FROM   TABLE(ParameterValues_tbl);
          --
          gvv_ProgressIndicator := '0060';
          --
          RETURN(ParameterValues_tbl);
          --
          EXCEPTION
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    ParameterValues_tbl := EmptyParameterValues_tbl;
                    pn_o_ReturnCount    := 0;
                    pv_o_ReturnStatus   := 'F';
                    pv_o_ReturnMessage  := 'Oracle error encountered in called procedure: '
                                         ||'.  See log messages for called procedure.';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END get_parameter_value_list;
     --
     --
     /*
     ***********************************************
     ** FUNCTION : simple_transform_exists
     **
     ** The following function simply returns TRUE
     ** if at least one simple transform has been
     ** entered into the xxmx_simple_transforms
     ** table for the given parameters.
     ***********************************************
     */
     --
     FUNCTION simple_transform_exists
                   (
                    pt_i_ApplicationSuite           IN      xxmx_simple_transforms.application_suite%TYPE
                   ,pt_i_Application                IN      xxmx_simple_transforms.application%TYPE
                   ,pt_i_CategoryCode               IN      xxmx_simple_transforms.category_code%TYPE
                   )
     RETURN BOOLEAN
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'simple_transform_exists';
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
          --
     --** END Declarations **
     --
     BEGIN
          --
          gvv_ProgressIndicator := '0010';
          --
          gvn_ExistenceCheckCount := NULL;
          --
          SELECT COUNT(1)
          INTO   gvn_ExistenceCheckCount
          FROM   xxmx_simple_transforms  xst
          WHERE  1 = 1
          AND    xst.application_suite  = pt_i_ApplicationSuite
          AND    xst.application        = pt_i_Application
          AND    xst.category_code      = pt_i_CategoryCode
          AND    xst.source_value      IS NOT NULL
          AND    xst.fusion_value      IS NOT NULL;
          --
          IF   gvn_ExistenceCheckCount > 0
          THEN
               --
               RETURN(TRUE);
               --
          ELSE
               --
               RETURN(FALSE);
               --
          END IF;
          --
          EXCEPTION
               --
               WHEN NO_DATA_FOUND
               THEN
                    --
                    RETURN(FALSE);
                    --
               --** END OTHERS Exception
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
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END simple_transform_exists;
     --
     --
     /*
     *************************************************************
     ** FUNCTION : get_transform_fusion_value
     **
     ** The following function accepts several parameters which
     ** identify a data element value from an external application
     ** and returns its mapped equivalent for the target
     ** application
     *************************************************************
     */
     --
     FUNCTION get_transform_fusion_value
                   (
                    pt_i_ApplicationSuite           IN      xxmx_simple_transforms.application_suite%TYPE
                   ,pt_i_Application                IN      xxmx_simple_transforms.application%TYPE
                   ,pt_i_CategoryCode               IN      xxmx_simple_transforms.category_code%TYPE
                   ,pt_i_SourceValue                IN      xxmx_simple_transforms.source_value%TYPE
                   )
     RETURN VARCHAR2
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'get_transform_fusion_value';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_ReturnValue                  xxmx_simple_transforms.fusion_value%TYPE;
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
          gvv_ProgressIndicator := '0010';
          --
          SELECT xst.fusion_value
          INTO   vt_ReturnValue
          FROM   xxmx_simple_transforms   xst
          WHERE  1 = 1
          AND    xst.application_suite = pt_i_ApplicationSuite
          AND    xst.application       = pt_i_Application
          AND    xst.category_code     = pt_i_CategoryCode
          AND    xst.source_value      = pt_i_SourceValue;
          --
          RETURN(vt_ReturnValue);
          --
          EXCEPTION
               --
               /*
               ** The TOO_MANY_ROWS exception should no longer be possible due to the implementation of
               ** a unique index on all columns of the xxmx_simple_transforms table.
               */
               --
               --WHEN TOO_MANY_ROWS
               --THEN
               --     --
               --     vt_ReturnValue := NULL;
               --     --
               --     gvt_ModuleMessage := 'Too many matches found for Application Suite "'
               --                        ||pt_i_ApplicationSuite
               --                        ||'", Application "'
               --                        ||pt_i_Application
               --                        ||'", XREF Category Code "'
               --                        ||pt_i_CategoryCode
               --                        ||'" and External Value '
               --                        ||pt_i_SourceValue
               --                        ||'" in xxmx_simple_transforms table.  No transformation value returned.';
               --     --
               --     log_module_message
               --          (
               --           pt_i_ApplicationSuite    => gct_ApplicationSuite
               --          ,pt_i_Application         => gct_Application
               --          ,pt_i_Phase               => gct_Phase
               --          ,pt_i_BusinessEntity      => gct_BusinessEntity
               --          ,pt_i_SubEntity           => gct_SubEntity
               --          ,pt_i_Severity            => 'WARNING'
               --          ,pt_i_PackageName         => gct_PackageName
               --          ,pt_i_ProcOrFuncName      => ct_ProcOrFuncName
               --          ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
               --          ,pt_i_ModuleMessage       => gvt_ModuleMessage
               --          ,pt_i_OracleError         => NULL
               --          );
               --     --
               --     RETURN(vt_ReturnValue);
               --     --
               ----** END TOO_MANY_ROWS Exception
               --
               WHEN NO_DATA_FOUND
               THEN
                    --
                    gvt_ModuleMessage := 'No transformations found for Application Suite "'
                                       ||pt_i_ApplicationSuite
                                       ||'", Application "'
                                       ||pt_i_Application
                                       ||'", Category Code "'
                                       ||pt_i_CategoryCode
                                       ||'" and Source Value '
                                       ||pt_i_SourceValue
                                       ||'" in xxmx_simple_transforms table.  No transformation value returned.';
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'WARNING'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RETURN(NULL);
                    --
               --** END NO_DATA_FOUND Exception
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
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END get_transform_fusion_value;
     --
     --
     /*
     *****************************************
     ** FUNCTION: get_fusion_business_unit
     **
     ** Called from various Extract procedures
     ** and Scope Views.
     *****************************************
     */
     --
     PROCEDURE get_fusion_business_unit
                    (
                     pt_i_SourceOperatingUnitName    IN      xxmx_source_operating_units.source_operating_unit_name%TYPE
                    ,pt_o_FusionBusinessUnitName        OUT  xxmx_source_operating_units.fusion_business_unit_name%TYPE
                    ,pt_o_FusionBusinessUnitID          OUT  xxmx_source_operating_units.fusion_business_unit_id%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    ,pt_o_ReturnMessage                 OUT  xxmx_module_messages.module_message%TYPE
                    )
     IS
          --
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'get_fusion_business_unit';
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
          --
     --** END Declarations **
     --
     BEGIN
          --
          gvv_ProgressIndicator := '0010';
          --
          pv_o_ReturnStatus           := 'S';
          pt_o_FusionBusinessUnitName := NULL;
          pt_o_FusionBusinessUnitID   := NULL;
          --
          SELECT  fusion_business_unit_name
                 ,fusion_business_unit_id
          INTO    pt_o_FusionBusinessUnitName
                 ,pt_o_FusionBusinessUnitID
          FROM    xxmx_source_operating_units
          WHERE   1 = 1
          AND     source_operating_unit_name = pt_i_SourceOperatingUnitName
          AND     migration_enabled_flag     = 'Y';
          --
          --
          EXCEPTION
               --
               WHEN NO_DATA_FOUND
               THEN
                    --
                    pv_o_ReturnStatus := 'E';
                    --
                    pt_o_ReturnMessage := 'Source Operating Unit "'
                                        ||pt_i_SourceOperatingUnitName
                                        ||'" is not defined in the XXMX_SOURCE_OPERATING_UNITS table '
                                        ||'or is diabled for migration.';
                    --
               --** END NO_DATA_FOUND Exception
               --
               WHEN TOO_MANY_ROWS
               THEN
                    --
                    pv_o_ReturnStatus := 'E';
                    --
                    pt_o_ReturnMessage := 'Source Operating Unit "'
                                        ||pt_i_SourceOperatingUnitName
                                        ||'" must only be defined once (and enabled for migration) '
                                        ||'in the XXMX_SOURCE_OPERATING_UNITS table.';
                    --
               --** END TOO_MANY_ROWS Exception
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
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END get_fusion_business_unit;
     --
     --
     /*
     ******************************************
     ** PROCEDURE: init_migration_set
     **
     ** Called from each Extract Main procedure
     ******************************************
     */
     --
     PROCEDURE init_migration_set
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_headers.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_headers.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_headers.business_entity%TYPE
                    ,pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                    ,pt_o_MigrationSetID                OUT  xxmx_migration_headers.migration_set_id%TYPE
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'init_migration_set';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_BusinessEntitySeq            xxmx_migration_metadata.business_entity_seq%TYPE;
          vt_exists                       NUMBER;
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
          gvv_ProgressIndicator := '0010';
          --
          SELECT   xxmx_migration_set_ids_s.NEXTVAL
          INTO     pt_o_MigrationSetID
          FROM     dual;
          --
          /*
          ** Retrieve the Business Entity sequence numbers for inclusion in the
          ** insert into the Migration Headers table.
          */
          --
          vt_BusinessEntitySeq := get_business_entity_seq
                                       (
                                        pt_i_ApplicationSuite => pt_i_ApplicationSuite
                                       ,pt_i_Application      => pt_i_Application
                                       ,pt_i_BusinessEntity   => pt_i_BusinessEntity
                                       );
          --
          --** Insert initial record into extract requests table
          --**
          --** the extract procedures will update this record using
          --** the returned migration_set_id
          --
          gvv_ProgressIndicator := '0010';
          --
          SELECT Count(1) 
          INTO vt_exists
          FROM xxmx_migration_headers
          WHERE migration_set_name = pt_i_MigrationSetName
          AND migration_set_id = 0;

          IF(vt_exists = 1) THEN 
            UPDATE xxmx_migration_headers
            SET migration_set_id = pt_o_MigrationSetID
            WHERE migration_set_name = pt_i_MigrationSetName
            ;
          ELSE 

          INSERT
          INTO   xxmx_migration_headers
                      (
                       application_suite
                      ,application
                      ,business_entity_seq
                      ,business_entity
                      ,migration_set_id
                      ,migration_set_name
                      ,phase
                      ,migration_status
                      )
          VALUES
                      (
                       UPPER(pt_i_ApplicationSuite)  -- application_suite
                      ,UPPER(pt_i_Application)       -- application
                      ,vt_BusinessEntitySeq          -- business_entity_seq
                      ,pt_i_BusinessEntity           -- business_entity
                      ,pt_o_MigrationSetID           -- migration_set_id
                      ,pt_i_MigrationSetName         -- migration_set_name
                      ,'EXTRACT'                     -- phase
                      ,'EXTRACTING'                  -- migration_status
                      );
         END IF;
          --
          COMMIT;
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
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
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
     END init_migration_set;
     --
     --
     /*
     *************************************
     ** FUNCTION: get_migration_set_name
     **
     ** Called from each Extract procedure
     *************************************
     */
     --
     FUNCTION get_migration_set_name
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    )
     RETURN VARCHAR2
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'get_migration_set_name';
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
          gvv_ProgressIndicator := '0010';
          --
          SELECT migration_set_name
          INTO   vt_MigrationSetName
          FROM   xxmx_migration_headers
          WHERE  1 = 1
          AND    migration_set_id = pt_i_MigrationSetID;
          --
          RETURN(vt_MigrationSetName);
          --
          EXCEPTION
               --
               WHEN TOO_MANY_ROWS
               THEN
                    --
                    gvt_ModuleMessage := 'Too many matches found for Migration Set ID "'
                                       ||pt_i_MigrationSetID
                                       ||'" in XXMX_MIGRATION_HEADERS table.  No Migration Set Name returned.';
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RETURN(NULL);
                    --
               --** END TOO_MANY_ROWS Exception
               --
               WHEN NO_DATA_FOUND
               THEN
                    --
                    gvt_ModuleMessage := 'No matches found for Migration Set ID "'
                                       ||pt_i_MigrationSetID
                                       ||'" in XXMX_MIGRATION_HEADERS table.  No Migration Set Name returned.';
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RETURN(NULL);
                    --
               --** END NO_DATA_FOUND Exception
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
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
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
     END get_migration_set_name;
     --
     --
     /*
     *************************************
     ** FUNCTION: get_migration_set_id
     **
     ** Called from OIC
     *************************************
     */
     --
     FUNCTION get_migration_set_id
                    (
                     pt_i_MigrationSetName           IN      xxmx_migration_headers.migration_set_name%TYPE
                    )
     RETURN VARCHAR2
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'get_migration_set_id';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_MigrationSetID              xxmx_migration_headers.migration_set_id%TYPE;
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
          gvv_ProgressIndicator := '0010';
          --
          SELECT migration_set_id
          INTO   vt_MigrationSetID
          FROM   xxmx_migration_headers
          WHERE  1 = 1
          AND    migration_set_name = pt_i_MigrationSetName;
          --
          RETURN(vt_MigrationSetID);
          --
          EXCEPTION
               --
               WHEN TOO_MANY_ROWS
               THEN
                    --
                    gvt_ModuleMessage := 'Too many matches found for Migration Set Name "'
                                       ||pt_i_MigrationSetName
                                       ||'" in XXMX_MIGRATION_HEADERS table.  No Migration Set ID returned.';
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RETURN(NULL);
                    --
               --** END TOO_MANY_ROWS Exception
               --
               WHEN NO_DATA_FOUND
               THEN
                    --
                    gvt_ModuleMessage := 'No matches found for Migration Set Name "'
                                       ||pt_i_MigrationSetName
                                       ||'" in XXMX_MIGRATION_HEADERS table.  No Migration Set ID returned.';
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RETURN(NULL);
                    --
               --** END NO_DATA_FOUND Exception
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
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
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
     END get_migration_set_id;
     --
     --
     /*
     *************************************
     ** PROCEDURE: init_migration_details
     **
     ** Called from each Extract procedure
     *************************************
     */
     --
     PROCEDURE init_migration_details
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_details.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_details.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_details.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_details.sub_entity%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_details.migration_set_id%TYPE
                    ,pt_i_StagingTable               IN      xxmx_migration_details.staging_table%TYPE
                    ,pt_i_ExtractStartDate           IN      xxmx_migration_details.extract_start_datetime%TYPE
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'init_migration_details';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vn_ExistenceCount               NUMBER;
          vt_BusinessEntitySeq            xxmx_migration_details.business_entity_seq%TYPE;
          vt_SubEntitySeq                 xxmx_migration_details.sub_entity_seq%TYPE;
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
          gvv_ProgressIndicator := '0010';
          --
          IF   pt_i_ApplicationSuite IS NOT NULL
          AND  pt_i_Application      IS NOT NULL
          AND  pt_i_BusinessEntity   IS NOT NULL
          AND  pt_i_SubEntity        IS NOT NULL
          AND  pt_i_MigrationSetID   IS NOT NULL
          THEN
               --
               gvv_ProgressIndicator := '0020';
               --
               SELECT COUNT(1)
               INTO   vn_ExistenceCount
               FROM   xxmx_migration_details  xfmd
               WHERE  1 = 1
               AND    xfmd.migration_set_id = pt_i_MigrationSetID
               AND    xfmd.business_entity  = pt_i_BusinessEntity
               AND    xfmd.sub_entity       = pt_i_SubEntity;
               --
               IF   vn_ExistenceCount = 0
               THEN
                    --
                    gvv_ProgressIndicator := '0030';
                    --
                    /*
                    ** Retrieve the Business Entity and Sub-Entity sequence numbers for inclusion in the
                    ** insert into the Migration Details table.
                    */
                    --
                    vt_BusinessEntitySeq := get_business_entity_seq
                                                 (
                                                  pt_i_ApplicationSuite => pt_i_ApplicationSuite
                                                 ,pt_i_Application      => pt_i_Application
                                                 ,pt_i_BusinessEntity   => pt_i_BusinessEntity
                                                 );
                    --
                    vt_SubEntitySeq      := get_sub_entity_seq
                                                 (
                                                  pt_i_ApplicationSuite => pt_i_ApplicationSuite
                                                 ,pt_i_Application      => pt_i_Application
                                                 ,pt_i_BusinessEntity   => pt_i_BusinessEntity
                                                 ,pt_i_SubEntity        => pt_i_SubEntity
                                                 );
                    --
                    gvv_ProgressIndicator := '0040';
                    --
                    INSERT
                    INTO   xxmx_migration_details
                               (
                                application_suite
                               ,application
                               ,business_entity_seq
                               ,business_entity
                               ,sub_entity_seq
                               ,sub_entity
                               ,migration_set_id
                               ,phase
                               ,staging_table
                               ,extract_start_datetime
                               ,extract_completion_datetime
                               ,extract_row_count
                               ,transform_table
                               ,transform_start_datetime
                               ,transform_completion_datetime
                               ,export_file_name
                               ,export_start_datetime
                               ,export_completion_datetime
                               ,migration_status
                               ,error_flag
                               )
                    VALUES
                               (
                                UPPER(pt_i_ApplicationSuite)    -- application_suite
                               ,UPPER(pt_i_Application)         -- application
                               ,vt_BusinessEntitySeq            -- business_entity_seq
                               ,UPPER(pt_i_BusinessEntity)      -- business_entity
                               ,vt_SubEntitySeq                 -- sub_entity_seq
                               ,UPPER(pt_i_SubEntity)           -- sub_entity
                               ,pt_i_MigrationSetID             -- migration_set_id
                               ,'EXTRACT'                       -- phase
                               ,SUBSTR(LOWER(pt_i_StagingTable),1,30)        -- staging_table
                               ,pt_i_ExtractStartDate           -- extract_start_datetime
                               ,NULL                            -- extract_completion_datetime
                               ,NULL                            -- extract_row_count
                               ,NULL                            -- transform_table
                               ,NULL                            -- transform_start_datetime
                               ,NULL                            -- transform_completion_datetime
                               ,NULL                            -- export_file_name
                               ,NULL                            -- export_start_datetime
                               ,NULL                            -- export_completion_datetime
                               ,NULL                            -- migration_status
                               ,NULL                            -- error_flag
                               );
                    --
               ELSE
                    --
                    gvt_ModuleMessage := 'Entity Level details already exist in "xxmx_migration_details" for Migration Set ID '
                                       ||pt_i_MigrationSetID
                                       ||', Business Entity "'
                                       ||pt_i_BusinessEntity
                                       ||'" and Sub-Entity "'
                                       ||pt_i_SubEntity
                                       ||'".';
                    --
                    RAISE e_ModuleError;
                    --
               END IF;
               --
          ELSE
               --
               gvt_ModuleMessage := 'Application Suite, Application, Business Entity, Sub-Entity and Migration Set ID Parameters must be populated.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          COMMIT;
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    ROLLBACK;
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    COMMIT; --** Commit the message to the Module Messages table.
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
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
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
     END init_migration_details;
     --
     --
     /*
     **************************************
     ** FUNCTION: get_row_count
     **
     ** Called from each Extract procedure.
     **
     ** Returns a number which is the count
     ** of rows in a single table.
     **************************************
     */
     --
     FUNCTION get_row_count
                    (
                     pt_i_SchemaName                 IN      xxmx_client_config_parameters.config_value%TYPE
                    ,pv_i_TableName                  IN      VARCHAR2
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
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
          gvv_ProgressIndicator := '0010';
          --
          gvv_SQLAction := 'SELECT';
          --
          gvv_SQLColumnList := 'COUNT(1)';
          --
          gvv_SQLTableClause := 'FROM '
                              ||pt_i_SchemaName
                              ||'.'
                              ||pv_i_TableName;
          --
          IF   pt_i_MigrationSetID IS NOT NULL
          THEN
               --
               gvv_SQLWhereClause := 'WHERE 1 = 1 '
                                   ||'AND   migration_set_id = '
                                   ||pt_i_MigrationSetID;
               --
          ELSE
               --
               gvv_SQLWhereClause := 'WHERE 1 = 1 ';
               --
          END IF;
          --
          gvv_SQLStatement := gvv_SQLAction
                            ||gcv_SQLSpace
                            ||gvv_SQLColumnList
                            ||gcv_SQLSpace
                            ||gvv_SQLTableClause
                            ||gcv_SQLSpace
                            ||gvv_SQLWhereClause;
          --
          EXECUTE IMMEDIATE gvv_SQLStatement INTO gvv_SQLResult;
          --
          RETURN(TO_NUMBER(gvv_SQLResult));
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
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
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
     **************************************
     ** FUNCTION: get_row_count
     **
     ** Called from each Extract procedure.
     **
     ** Returns a number which is the count
     ** of rows in a single table.
     **
     ** However this version allows upto
     ** 5 optional condtions to be added
     ** to the basic query.
     **************************************
     */
     --
     FUNCTION get_row_count
                    (
                     pt_i_SchemaName                 IN      xxmx_client_config_parameters.config_value%TYPE
                    ,pv_i_TableName                  IN      VARCHAR2
                    ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                    ,pv_i_OptionalJoinCondition1     IN      VARCHAR2
                    ,pv_i_OptionalJoinCondition2     IN      VARCHAR2
                    ,pv_i_OptionalJoinCondition3     IN      VARCHAR2
                    ,pv_i_OptionalJoinCondition4     IN      VARCHAR2
                    ,pv_i_OptionalJoinCondition5     IN      VARCHAR2
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
          gvv_ProgressIndicator := '0010';
          --
          gvv_SQLAction := 'SELECT';
          --
          gvv_SQLColumnList := 'COUNT(1)';
          --
          gvv_SQLTableClause := 'FROM '
                              ||pt_i_SchemaName
                              ||'.'
                              ||pv_i_TableName;
          --
          IF   pt_i_MigrationSetID IS NOT NULL
          THEN
               --
               gvv_SQLWhereClause := 'WHERE 1 = 1 '
                                   ||'AND migration_set_id = '
                                   ||pt_i_MigrationSetID;
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
          gvv_SQLStatement := gvv_SQLAction
                            ||gcv_SQLSpace
                            ||gvv_SQLColumnList
                            ||gcv_SQLSpace
                            ||gvv_SQLTableClause
                            ||gcv_SQLSpace
                            ||gvv_SQLWhereClause;
          --
          --log_module_message
          --     (
          --      pt_i_ApplicationSuite  => gct_ApplicationSuite
          --     ,pt_i_Application       => gct_Application
          --     ,pt_i_Phase             => gct_Phase
          --     ,pt_i_BusinessEntity    => gct_BusinessEntity
          --     ,pt_i_SubEntity         => gct_SubEntity
          --     ,pt_i_Severity          => 'NOTIFICATION'
          --     ,pt_i_PackageName       => gct_PackageName
          --     ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
          --     ,pt_i_ProgressIndicator => gvv_ProgressIndicator
          --     ,pt_i_ModuleMessage     => SUBSTR(
          --                                       'Generated SQL Statement -> '
          --                                     ||gvv_SQLStatement
          --                                      ,1
          --                                      ,2000
          --                                      )
          --     ,pt_i_OracleError       => gvt_OracleError
          --     );
          --
          gvv_ProgressIndicator := '0030';
          --
          EXECUTE IMMEDIATE gvv_SQLStatement INTO gvv_SQLResult;
          --
          RETURN(TO_NUMBER(gvv_SQLResult));
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
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
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
     *************************************
     ** PROCEDURE: upd_migration_details
     **
     ** Called from each Extract procedure
     *************************************
     */
     --
     PROCEDURE upd_migration_details
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_details.migration_set_id%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_details.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_details.sub_entity%TYPE
                    ,pt_i_Phase                      IN      xxmx_migration_details.phase%TYPE
                    ,pt_i_ExtractCompletionDate      IN      xxmx_migration_details.extract_completion_datetime%TYPE DEFAULT NULL
                    ,pt_i_ExtractRowCount            IN      xxmx_migration_details.extract_row_count%TYPE
                    ,pt_i_TransformTable             IN      xxmx_migration_details.transform_table%TYPE
                    ,pt_i_TransformStartDate         IN      xxmx_migration_details.transform_start_datetime%TYPE
                    ,pt_i_TransformCompletionDate    IN      xxmx_migration_details.transform_completion_datetime%TYPE
                    ,pt_i_ExportFileName             IN      xxmx_migration_details.export_file_name%TYPE
                    ,pt_i_ExportStartDate            IN      xxmx_migration_details.export_start_datetime%TYPE
                    ,pt_i_ExportCompletionDate       IN      xxmx_migration_details.export_completion_datetime%TYPE
                    ,pt_i_ExportRowCount             IN      xxmx_migration_details.export_row_count%TYPE
                    ,pt_i_ErrorFlag                  IN      xxmx_migration_details.error_flag%TYPE
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'upd_migration_details';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vn_ExistenceCount               NUMBER;
          vt_MigrationStatus              xxmx_migration_details.migration_status%TYPE;
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
          gvv_ProgressIndicator := '0010';
          --
          IF   pt_i_MigrationSetID IS NOT NULL
          AND  pt_i_BusinessEntity IS NOT NULL
          AND  pt_i_SubEntity      IS NOT NULL
          THEN
               --
               gvv_ProgressIndicator := '0020';
               --
               SELECT COUNT(1)
               INTO   vn_ExistenceCount
               FROM   xxmx_migration_details  xfmd
               WHERE  1 = 1
               AND    xfmd.migration_set_id = pt_i_MigrationSetID
               AND    xfmd.business_entity  = UPPER(pt_i_BusinessEntity)
               AND    xfmd.sub_entity       = UPPER(pt_i_SubEntity);
               --
               IF   vn_ExistenceCount = 0
               THEN
                    --
                    gvt_ModuleMessage := 'Migration has not been initialized for Migration Set ID '
                                       ||pt_i_MigrationSetID
                                       ||', Business Entity "'
                                       ||pt_i_BusinessEntity
                                       ||'" and Sub-Entity "'
                                       ||pt_i_SubEntity
                                       ||'.';
                    --
                  --  RAISE e_ModuleError;
                    --
               ELSE
                    --
                    gvv_ProgressIndicator := '0040';
                    --
                    IF   UPPER(pt_i_Phase) = 'EXTRACT'
                    THEN
                         --
                         IF   UPPER(NVL(pt_i_ErrorFlag, 'N')) = 'N'
                         THEN
                              --
                              vt_MigrationStatus := 'TRANSFORM_READY';
                              --
                         ELSE
                              --
                              vt_MigrationStatus := 'EXTRACT_ERRORS';
                              --
                         END IF;
                         --
                    ELSIF UPPER(pt_i_Phase) = 'TRANSFORM'
                    THEN
                         --
                         IF   UPPER(NVL(pt_i_ErrorFlag, 'N')) = 'N'
                         THEN
                              --
                              vt_MigrationStatus := 'EXPORT_READY';
                              --
                         ELSE
                              --
                              vt_MigrationStatus := 'TRANSFORM_ERRORS';
                              --
                         END IF;
                         --
                    ELSIF UPPER(pt_i_Phase) = 'EXPORT'
                    THEN
                         --
                         IF   UPPER(NVL(pt_i_ErrorFlag, 'N')) = 'N'
                         THEN
                              --
                              vt_MigrationStatus := 'FUSION_IMPORT_READY';
                              --
                         ELSE
                              --
                              vt_MigrationStatus := 'EXPORT_ERRORS';
                              --
                         END IF;
                         --
                    ELSE
                         --
                         gvt_ModuleMessage := 'Phase Parameter must have a value of "EXTRACT", "TRANSFORM" or "EXPORT".';
                         --
                         RAISE e_ModuleError;
                         --
                    END IF;
                    --
                    --** Update record in migration details table
                    --
                    UPDATE xxmx_migration_details
                    SET    phase                         = UPPER(pt_i_Phase)
                          ,extract_completion_datetime   = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'EXTRACT' ,pt_i_ExtractCompletionDate
                                                                                 ,extract_completion_datetime
                                                                 )
                          ,extract_row_count             = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'EXTRACT' ,pt_i_ExtractRowCount
                                                                                 ,extract_row_count
                                                                 )
                          ,transform_table               = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'TRANSFORM' ,LOWER(pt_i_TransformTable)
                                                                                   ,transform_table
                                                                 )
                          ,transform_start_datetime      = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'TRANSFORM' ,pt_i_TransformStartDate
                                                                                   ,transform_start_datetime
                                                                 )
                          ,transform_completion_datetime = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                       ,'TRANSFORM' ,pt_i_TransformCompletionDate
                                                                                    ,transform_completion_datetime
                                                                 )
                          ,export_file_name              = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                       ,'EXPORT' ,pt_i_ExportFileName
                                                                                 ,export_file_name
                                                                 )
                          ,export_start_datetime         = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                       ,'EXPORT' ,pt_i_ExportStartDate
                                                                                 ,export_start_datetime
                                                                 )
                          ,export_completion_datetime    = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                       ,'EXPORT' ,pt_i_ExportCompletionDate
                                                                                 ,export_completion_datetime
                                                                 )
                          ,export_row_count              = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                       ,'EXPORT' ,pt_i_ExportRowCount
                                                                                 ,export_row_count
                                                                 )
                          ,migration_status              = vt_MigrationStatus
                          ,error_flag                    = UPPER(pt_i_ErrorFlag)
                    WHERE  1 = 1
                    AND    migration_set_id = pt_i_MigrationSetID
                    AND    business_entity  = UPPER(pt_i_BusinessEntity)
                    AND    sub_entity       = UPPER(pt_i_SubEntity);
                    --
               END IF;
               --
          ELSE
               --
               gvt_ModuleMessage := 'Migration Set ID and Entity Parameters must be populated.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          COMMIT;
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    ROLLBACK;
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    COMMIT; --** Commit the message to the Module Messages table.
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
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
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
     END upd_migration_details;
     --
     --
     /*
     ******************************************
     ** PROCEDURE: close_extract_phase
     **
     ** Called from each Extract Main procedure
     ******************************************
     */
     --
     PROCEDURE close_extract_phase
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'close_extract_phase';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vn_ExistenceCount               NUMBER;
          vt_MigrationStatus              xxmx_migration_headers.migration_status%TYPE;
          vn_DetailErrorCount             NUMBER;
          vt_ErrorMessage                 xxmx_module_messages.module_message%TYPE;
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
          gvv_ProgressIndicator := '0010';
          --
          IF   pt_i_MigrationSetID IS NOT NULL
          THEN
               --
               gvv_ProgressIndicator := '0020';
               --
               --
               SELECT COUNT(1)
               INTO   vn_ExistenceCount
               FROM   xxmx_migration_headers  xfmh
               WHERE  1 = 1
               AND    xfmh.migration_set_id = pt_i_MigrationSetID;
               --
               IF   vn_ExistenceCount = 0
               THEN
                    --
                    gvv_ProgressIndicator := '0030';
                    --
                    gvt_ModuleMessage := 'Migration Set has not been initialized for Migration Set ID '||pt_i_MigrationSetID||'.';
                    --
                    RAISE e_ModuleError;
                    --
               ELSE
                    --
                    --** Examine the Migration Details table for the current Migration Set ID
                    --** to ascertain if there have been any errors at the detail level for
                    --** the specific Phase.
                    --
                    SELECT COUNT(1)
                    INTO   vn_DetailErrorCount
                    FROM   xxmx_migration_details  xmd
                    WHERE  1 = 1
                    AND    xmd.migration_set_id  = pt_i_MigrationSetID
                    AND    xmd.phase             = 'EXTRACT'
                    AND    xmd.error_flag        = 'Y';
                    --
                    gvv_ProgressIndicator := '0040';
                    --
                    IF   vn_DetailErrorCount = 0
                    THEN
                         --
                         vt_ErrorMessage    := NULL;
                         vt_MigrationStatus := 'TRANSFORM_READY';
                         --
                    ELSE
                         --
                         vt_ErrorMessage    := 'Extract errors exist.  Transform phase cannot be entered.';
                         vt_MigrationStatus := 'EXTRACT_ERRORS';
                         --
                    END IF;
                    --
                    --** Update record in migration headers table
                    --
                    UPDATE xxmx_migration_headers
                    SET    migration_status = vt_MigrationStatus
                    WHERE  1 = 1
                    AND    migration_set_id = pt_i_MigrationSetID
                    and    phase            = 'EXTRACT';
                    --
               END IF;
               --
          ELSE
               --
               gvt_ModuleMessage := 'Migration Set ID Parameter must be populated.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          COMMIT;
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    ROLLBACK;
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    COMMIT; --** Commit the message to the Module Messages table.
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
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
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
     END close_extract_phase;
     --
     --
     /*
     ******************************************
     ** PROCEDURE: close_transform_phase
     **
     ** Called from each Extract Main procedure
     ******************************************
     */
     --
     PROCEDURE close_transform_phase
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'close_transform_phase';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vn_ExistenceCount               NUMBER;
          vt_MigrationStatus              xxmx_migration_headers.migration_status%TYPE;
          vn_DetailErrorCount             NUMBER;
          vt_ErrorMessage                 xxmx_module_messages.module_message%TYPE;
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
          gvv_ProgressIndicator := '0010';
          --
          IF   pt_i_MigrationSetID IS NOT NULL
          THEN
               --
               gvv_ProgressIndicator := '0020';
               --
               SELECT COUNT(1)
               INTO   vn_ExistenceCount
               FROM   xxmx_migration_headers  xfmh
               WHERE  1 = 1
               AND    xfmh.migration_set_id = pt_i_MigrationSetID;
               --
               IF   vn_ExistenceCount = 0
               THEN
                    --
                    gvv_ProgressIndicator := '0030';
                    --
                    gvt_ModuleMessage := 'Migration Set has not been initialized for Migration Set ID '||pt_i_MigrationSetID||'.';
                    --
                    RAISE e_ModuleError;
                    --
               ELSE
                    --
                    --** Examine the Migration Details table for the current Migration Set ID
                    --** to ascertain if there have been any errors at the detail level for
                    --** the specific Phase.
                    --
                    SELECT COUNT(1)
                    INTO   vn_DetailErrorCount
                    FROM   xxmx_migration_details  xmd
                    WHERE  1 = 1
                    AND    xmd.migration_set_id = pt_i_MigrationSetID
                    AND    xmd.phase            = 'TRANSFORM'
                    AND    xmd.error_flag       = 'Y';
                    --
                    gvv_ProgressIndicator := '0040';
                    --
                    IF   vn_DetailErrorCount = 0
                    THEN
                         --
                         vt_ErrorMessage    := NULL;
                         vt_MigrationStatus := 'EXPORT_READY';
                         --
                    ELSE
                         --
                         vt_ErrorMessage    := 'Transform errors exist.  Export phase cannot be entered.';
                         vt_MigrationStatus := 'TRANSFORM_ERRORS';
                         --
                    END IF;
                    --
                    --** Update record in migration headers table
                    --
                    UPDATE xxmx_migration_headers
                    SET    migration_status = vt_MigrationStatus
                    WHERE  1 = 1
                    AND    migration_set_id = pt_i_MigrationSetID
                    AND    phase            = 'TRANSFORM';
                    --
               END IF;
               --
          ELSE
               --
               gvt_ModuleMessage := 'Migration Set ID Parameter must be populated.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          COMMIT;
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    ROLLBACK;
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    COMMIT; --** Commit the message to the Module Messages table.
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
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
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
     END close_transform_phase;
     --
     --
     /*
     *********************************************
     ** PROCEDURE: get_data_file_details
     **
     ** Called from OIC and PL/SQL file generation
     ** procedures
     *********************************************
     */
     --
     PROCEDURE get_data_file_details
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_details.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_details.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_details.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_details.sub_entity%TYPE
                    ,pv_o_FileName                      OUT  VARCHAR2
                    ,pn_o_FileGroupNumber               OUT  NUMBER
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    )
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'get_data_file_details';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_DataFileName                 xxmx_migration_metadata.data_file_name%TYPE;
          vt_DataFileExtension            xxmx_migration_metadata.data_file_extension%TYPE;
          vt_SubEntity                    xxmx_migration_details.sub_entity%TYPE;
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
          gvv_ProgressIndicator := '0010';
          --
          pv_o_ReturnStatus  := 'S';
          --
          pv_o_FileName        := NULL;
          pn_o_FileGroupNumber := NULL;
          --
          IF   pt_i_ApplicationSuite    IS NOT NULL
          AND  pt_i_Application         IS NOT NULL
          AND  pt_i_BusinessEntity      IS NOT NULL
          AND  pt_i_SubEntity           IS NOT NULL
          THEN
               --
               gvv_ProgressIndicator := '0020';
               --
               BEGIN
                    --
                    SELECT LTRIM(RTRIM(data_file_name))
                          ,LTRIM(
                                 RTRIM(
                                       LOWER(data_file_extension)
                                      )
                                ,'.'
                                )
                          ,file_group_number
                    INTO   vt_DataFileName
                          ,vt_DataFileExtension
                          ,pn_o_FileGroupNumber
                    FROM   xxmx_migration_metadata  xmd
                    WHERE  1 = 1
                    AND    xmd.application_suite = pt_i_ApplicationSuite
                    AND    xmd.application       = pt_i_Application
                    AND    xmd.business_entity   = pt_i_BusinessEntity
                    AND    xmd.sub_entity        = pt_i_SubEntity;
                    --
                    EXCEPTION
                         --
                         WHEN NO_DATA_FOUND
                         THEN
                              --
                              gvt_ModuleMessage := 'Could not retrieve "exp_file_name", "exp_file_extension" and "file_group_number" '
                                                 ||'from the "xxmx_migration_metadata" table for Business Entity "'
                                                 ||pt_i_BusinessEntity
                                                 ||'" and Sub-Entity "'
                                                 ||pt_i_SubEntity
                                                 ||'".';
                              --
                              RAISE e_ModuleError;
                              --
                         --** END NO_DATA_FOUND Exception
                         --
                         WHEN OTHERS
                         THEN
                              --
                              gvt_ModuleMessage := 'Unexpected Oracle error encountered after Progress Indicator.';
                              --
                              RAISE e_ModuleError;
                              --
                         --** END NO_DATA_FOUND Exception
                         --
                    --** END Metadata Block Exception Handler
               END;
               --
               pv_o_FileName := vt_DataFileName
                              ||'.'
                              ||vt_DataFileExtension;
               --
          ELSE
               --
               gvt_ModuleMessage := 'All parameters are mandatory.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    pv_o_FileName        := NULL;
                    pn_o_FileGroupNumber := NULL;
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
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
                    pv_o_FileName        := NULL;
                    pn_o_FileGroupNumber := NULL;
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
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
     END get_data_file_details;
     --
     --
     /*
     *********************************************
     ** FUNCTION: gen_file_name
     **
     ** Called from OIC and PL/SQL file generation
     ** procedures.
     **
     ** NOTE : You MUST check in your calling
     **        procedure/function if this function
     **        returns NULL, indicating that the
     **        file name could not be retrieved or
     **        generated.
     **
     **        The xxmx_module_messages table will
     **        contain details of the error.
     *********************************************
     */
     --
     FUNCTION gen_file_name
                    (
                     pt_i_FileType                   IN      VARCHAR2
                    ,pt_i_ApplicationSuite           IN      xxmx_migration_metadata.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_metadata.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_FileGroupNumber            IN      xxmx_migration_metadata.file_group_number%TYPE
                    ,pt_i_BusinessUnitName           IN      xxmx_migration_details.business_unit_name%TYPE
                    )
     RETURN VARCHAR2
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'gen_file_name';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_PropertyFileNamePrefix       xxmx_file_group_properties.property_file_name_prefix%TYPE;
          vv_DateAndTimeStamp             VARCHAR2(20);
          vt_BusinessUnitName             xxmx_migration_details.business_unit_name%TYPE;
          vv_FileName                     VARCHAR2(1000);
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
          gvv_ProgressIndicator := '0010';
          --
          vv_DateAndTimeStamp := xxmx_utilities_pkg.date_and_time_stamp
                                      (
                                       pv_i_IncludeSeconds => 'N'
                                      );
          --
          vv_FileName := NULL;
          --
          IF   pt_i_FileType            IS NOT NULL
          AND  pt_i_ApplicationSuite    IS NOT NULL
          AND  pt_i_Application         IS NOT NULL
          AND  pt_i_BusinessEntity      IS NOT NULL
          AND  pt_i_FileGroupNumber     IS NOT NULL
          AND  pt_i_BusinessUnitName    IS NOT NULL
          THEN
               --
               vt_BusinessUnitName := REPLACE(pt_i_BusinessUnitName, '''', '');
               vt_BusinessUnitName := REPLACE(vt_BusinessUnitName, ' ', '_');
               --
               IF   valid_lookup_code
                         (
                          'FILE_TYPES'
                         ,UPPER(pt_i_FileType)
                         )
               THEN
                    --
                    IF   UPPER(pt_i_FileType) = 'PROPERTIES'
                    THEN
                         --
                         BEGIN
                              --
                              SELECT LOWER(xfgp.property_file_name_prefix)
                              INTO   vt_PropertyFileNamePrefix
                              FROM   xxmx_file_group_properties  xfgp
                              WHERE  1 = 1
                              AND    xfgp.application_suite = pt_i_ApplicationSuite
                              AND    xfgp.application       = pt_i_Application
                              AND    xfgp.business_entity   = pt_i_BusinessEntity
                              AND    xfgp.file_group_number = pt_i_FileGroupNumber;
                              --
                              EXCEPTION
                                   --
                                   WHEN NO_DATA_FOUND
                                   THEN
                                        --
                                        gvt_ModuleMessage := 'Could not retrieve "property_file_name_prefix" '
                                                           ||'from the "xxmx_file_group_properties" table for Business Entity "'
                                                           ||pt_i_BusinessEntity
                                                           ||'" and File Group Number "'
                                                           ||pt_i_FileGroupNumber
                                                           ||'".';
                                        --
                                        RAISE e_ModuleError;
                                        --
                                   --** END NO_DATA_FOUND Exception **
                                   --
                                   WHEN OTHERS
                                   THEN
                                        --
                                        gvt_ModuleMessage := 'Unexpected Oracle error encountered after Progress Indicator.';
                                        --
                                        RAISE e_ModuleError;
                                        --
                                   --**END OTHERS Exception **
                                   --
                              --** END Exception Handler **
                              --
                         END;
                         --
                         vv_FileName := vt_PropertyFileNamePrefix
                                      ||'.properties';
                         --
                    ELSIF UPPER(pt_i_FileType) = 'ZIP'
                    THEN
                         --
                         vv_FileName := LTRIM(RTRIM(pt_i_ApplicationSuite))
                                      ||'_'
                                      ||LTRIM(RTRIM(vt_BusinessUnitName))
                                      ||'_'
                                      ||LTRIM(RTRIM(pt_i_Application))
                                      ||'_'
                                      ||LTRIM(RTRIM(pt_i_BusinessEntity))
                                      ||'_FG'
                                      ||LTRIM(RTRIM(pt_i_FileGroupNumber))
                                      ||'_'
                                      ||LTRIM(RTRIM(vv_DateAndTimeStamp))
                                      ||'.zip';
                         --
                         vv_FileName := LOWER(vv_FileName);
                         --
                    ELSE
                         --
                         gvt_ModuleMessage := 'This procedure can only be used to generate file names for '
                                            ||'"PROPERTIES" and "ZIP" files.';
                         --
                         RAISE e_ModuleError;
                         --
                    END IF;
                    --
               ELSE
                    --
                    gvt_ModuleMessage := '"pt_i_FileType" parameter must have a value corresponding to a LOOKUP_CODE in the '
                                       ||'XXMX_LOOKUP_VALUES table for the LOOKUP_TYPE of "FILE_TYPES".';
                    --
                    RAISE e_ModuleError;
                    --
               END IF;
               --
          ELSE
               --
               gvt_ModuleMessage := 'All parameters are mandatory.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          RETURN(vv_FileName);
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RETURN(NULL);
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
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    RETURN(NULL);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END gen_file_name;
     --
     --
     /*
     *********************************************
     ** FUNCTION: get_file_location
     **
     ** Called from OIC and PL/SQL file generation
     ** procedures.
     **
     ** NOTE : You MUST check in your calling
     **        procedure/function if this function
     **        returns NULL, indicating that the
     **        file name could not be retrieved or
     **        generated.
     **
     **        The xxmx_module_messages table will
     **        contain details of the error.
     *********************************************
     */
     --
     FUNCTION get_file_location
                    (
                     pt_i_ApplicationSuite           IN      xxmx_file_locations.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_file_locations.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_file_locations.business_entity%TYPE
                    ,pt_i_FileGroupNumber            IN      xxmx_file_locations.file_group_number%TYPE
                    ,pt_i_CalledFrom                 IN      xxmx_file_locations.used_by%TYPE
                    ,pt_i_FileType                   IN      xxmx_file_locations.file_type%TYPE
                    ,pt_i_FileLocationType           IN      xxmx_file_locations.file_location_type%TYPE
                    )
     RETURN VARCHAR2
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'get_file_location';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_FileLocation                 xxmx_file_locations.file_location%TYPE;
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
          gvv_ProgressIndicator := '0010';
          --
          vt_FileLocation := NULL;
          --
          IF   pt_i_ApplicationSuite IS NOT NULL
          AND  pt_i_Application      IS NOT NULL
          AND  pt_i_BusinessEntity   IS NOT NULL
          AND  pt_i_FileGroupNumber  IS NOT NULL
          AND  pt_i_CalledFrom       IS NOT NULL
          AND  pt_i_FileType         IS NOT NULL
          AND  pt_i_FileLocationType IS NOT NULL
          THEN
               --
               gvv_ProgressIndicator := '0020';
               --
               IF   NOT valid_lookup_code
                         (
                          'CALL_SOURCES'
                         ,UPPER(pt_i_CalledFrom)
                         )
               THEN
                    --
                    gvt_ModuleMessage := '"pt_i_CalledFrom" parameter must have a value corresponding to a LOOKUP_CODE in the '
                                       ||'XXMX_LOOKUP_VALUES table for the LOOKUP_TYPE of "CALL_SOURCES".';
                    --
                    RAISE e_ModuleError;
                    --
               END IF;
               --
               IF   NOT valid_lookup_code
                         (
                          'FILE_TYPES'
                         ,UPPER(pt_i_FileType)
                         )
               THEN
                    --
                    gvt_ModuleMessage := '"pt_i_CalledFrom" parameter must have a value corresponding to a LOOKUP_CODE in the '
                                       ||'XXMX_LOOKUP_VALUES table for the LOOKUP_TYPE of "FILE_TYPES".';
                    --
                    RAISE e_ModuleError;
                    --
               END IF;
               --
               IF   NOT valid_lookup_code
                         (
                          'FILE_LOCATION_TYPES'
                         ,UPPER(pt_i_FileLocationType)
                         )
               THEN
                    --
                    gvt_ModuleMessage := '"pt_i_FileLocationType" parameter must have a value corresponding to a LOOKUP_CODE in the '
                                       ||'XXMX_LOOKUP_VALUES table for the LOOKUP_TYPE of "FILE_LOCATION_TYPES".';
                    --
                    RAISE e_ModuleError;
                    --
               END IF;
               --
               BEGIN
                    --
                    SELECT xml.file_location
                    INTO   vt_FileLocation
                    FROM   xxmx_file_locations  xml
                    WHERE  1 = 1
                    AND    xml.application_suite  = pt_i_ApplicationSuite
                    AND    xml.application        = pt_i_Application
                    AND    xml.business_entity    = pt_i_BusinessEntity
                    AND    xml.file_group_number  = pt_i_FileGroupNumber
                    AND    xml.used_by            = pt_i_CalledFrom
                    AND    xml.file_type          = pt_i_FileType
                    AND    xml.file_location_type = pt_i_FileLocationType;
                    --
                    EXCEPTION
                         --
                         WHEN NO_DATA_FOUND
                         THEN
                              --
                              gvt_ModuleMessage := 'Could not retrieve "FILE_LOCATION" '
                                                 ||'from the "XXMX_FILE_LOCATIONS" table for Business Entity "'
                                                 ||pt_i_BusinessEntity
                                                 ||'", File Group Number "'
                                                 ||pt_i_FileGroupNumber
                                                 ||'", Called From "'
                                                 ||pt_i_CalledFrom
                                                 ||'", File Type "'
                                                 ||pt_i_FileType
                                                 ||'" and File Location Type "'
                                                 ||pt_i_FileLocationType
                                                 ||'".';
                              --
                              RAISE e_ModuleError;
                              --
                         --** END NO_DATA_FOUND Exception **
                         --
                         --
                         WHEN OTHERS
                         THEN
                              --
                              gvt_ModuleMessage := 'Unexpected Oracle error encountered after Progress Indicator.';
                              --
                              RAISE e_ModuleError;
                              --
                         --** END OTHERS Exception **
                         --
                    --** END Exception Handler **
                    --
               END;
               --
          ELSE
               --
               gvt_ModuleMessage := 'All parameters are mandatory.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          RETURN(vt_FileLocation);
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RETURN(NULL);
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
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    RETURN(NULL);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END get_file_location;
     --
     --
     /*
     *********************************************
     ** FUNCTION: gen_properties_record
     **
     ** Called from OIC and PL/SQL file generation
     ** procedures.
     **
     ** NOTE : You MUST check in your calling
     **        procedure/function if this function
     **        returns NULL, indicating that the
     **        file name could not be generated.
     **
     **        The xxmx_module_messages table will
     **        contain details of the error.
     *********************************************
     */
     --
     FUNCTION gen_properties_record
                    (
                     pt_i_ApplicationSuite           IN      xxmx_fusion_job_definitions.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_fusion_job_definitions.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_fusion_job_definitions.business_entity%TYPE
                    ,pt_i_FileGroupNumber            IN      xxmx_fusion_job_definitions.file_group_number%TYPE
                    ,pt_i_ZipFileName                IN      VARCHAR2
                    ,pt_i_MigrationSetID             IN      xxmx_migration_details.migration_set_id%TYPE
                    ,pv_i_BusinessUnitName           IN      VARCHAR2
                    ,pv_i_LedgerName                 IN      VARCHAR2
                    ,pd_i_Date                       IN      DATE
                    )
     RETURN VARCHAR2
     IS
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
          CURSOR JobDefinition_cur
                      (
                       pt_ApplicationSuite           xxmx_fusion_job_definitions.application_suite%TYPE
                      ,pt_Application                xxmx_fusion_job_definitions.application%TYPE
                      ,pt_BusinessEntity             xxmx_fusion_job_definitions.business_entity%TYPE
                      ,pt_FileGroupNumber            xxmx_fusion_job_definitions.file_group_number%TYPE
                      )
          IS
               --
               SELECT  xfjd.fusion_job_package_name
                      ,xfjd.fusion_job_definition_name
               FROM    xxmx_fusion_job_definitions  xfjd
               WHERE   1 = 1
               AND     xfjd.application_suite = pt_ApplicationSuite
               AND     xfjd.application       = pt_Application
               AND     xfjd.business_entity   = pt_BusinessEntity
               AND     xfjd.file_group_number = pt_FileGroupNumber;
               --
          --** END CURSOR JobDefinition_cur
          --
          --
          CURSOR JobParameters_cur
                      (
                       pt_FusionJobDefinitionName      xxmx_fusion_job_parameters.fusion_job_definition_name%TYPE
                      )
          IS
               --
               SELECT   xfjp.parameter_value
               FROM     xxmx_fusion_job_parameters  xfjp
               WHERE    1 = 1
               AND      xfjp.fusion_job_definition_name = pt_FusionJobDefinitionName
               ORDER BY xfjp.parameter_seq;
               --
          --** END CURSOR JobParameters_cur
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'gen_properties_record';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_FusionJobPackageName         xxmx_fusion_job_definitions.fusion_job_package_name%TYPE;
          vt_FusionJobDefinitionName      xxmx_fusion_job_definitions.fusion_job_definition_name%TYPE;
          vt_SubEntity                    xxmx_migration_details.sub_entity%TYPE;
          vv_PropertiesRecord             VARCHAR2(2000);
          vv_DateFormat                   VARCHAR2(30);
          vv_DateValue                    VARCHAR2(30);
          vt_ParameterValue               xxmx_migration_parameters.parameter_value%TYPE;
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
          gvv_ProgressIndicator := '0010';
          --
          /* Check the basic parameters have been supplied. */
          --
          IF   pt_i_ApplicationSuite    IS NOT NULL
          AND  pt_i_Application         IS NOT NULL
          AND  pt_i_BusinessEntity      IS NOT NULL
          AND  pt_i_FileGroupNumber     IS NOT NULL
          THEN
               --
               /* Retrieve the Job Definition values to start constructing the Properties File record */
               --
               OPEN JobDefinition_cur
                         (
                          pt_i_ApplicationSuite
                         ,pt_i_Application
                         ,pt_i_BusinessEntity
                         ,pt_i_FileGroupNumber
                         );
               --
               FETCH  JobDefinition_cur
               INTO   vt_FusionJobPackageName
                     ,vt_FusionJobDefinitionName;
               --
               IF   JobDefinition_cur%NOTFOUND
               THEN
                    --
                    gvt_ModuleMessage := 'Job Definition not found in the "xxmx_fusion_job_definitions" table "'
                                       ||pt_i_BusinessEntity
                                       ||'" Business Entity must be generated at the individual extract level.  '
                                       ||'"pt_i_SubEntity" parameter is required.';
                    --
                    RAISE e_ModuleError;
                    --
               END IF;
               --
               vv_PropertiesRecord := vt_FusionJobPackageName
                                    ||','
                                    ||vt_FusionJobDefinitionName
                                    ||','
                                    ||SUBSTR(pt_i_ZipFileName, 1, (INSTR(pt_i_ZipFileName, '.', 1)-1))
                                    ||',';
               --
               FOR  JobParameters_rec
               IN   JobParameters_cur
                         (
                          vt_FusionJobDefinitionName
                         )
               LOOP
                    --
                    IF   JobParameters_rec.parameter_value = '[BUSINESS_UNIT_NAME]'
                    THEN
                         --
                         vv_PropertiesRecord := vv_PropertiesRecord
                                              ||pv_i_BusinessUnitName
                                              ||',';

                         --
                    ELSIF JobParameters_rec.parameter_value = '[LEDGER_NAME]'
                    THEN
                         --
                         vv_PropertiesRecord := vv_PropertiesRecord
                                              ||pv_i_LedgerName
                                              ||',';

                         --
                    ELSIF JobParameters_rec.parameter_value = '[MIGRATION_SET_ID]'
                    THEN
                         --
                         vv_PropertiesRecord := vv_PropertiesRecord
                                              ||pt_i_MigrationSetID
                                              ||',';

                         --
                    ELSIF JobParameters_rec.parameter_value = '[SYSDATE]'
                    THEN
                         --
                         vv_PropertiesRecord := vv_PropertiesRecord
                                              ||SYSDATE
                                              ||',';

                         --
                    ELSIF JobParameters_rec.parameter_value LIKE '[SYSDATEAS:%'
                    THEN
                         --
                         BEGIN
                              --
                              vv_DateFormat := RTRIM(
                                                     SUBSTR(
                                                            JobParameters_rec.parameter_value
                                                           ,12
                                                           )
                                                    ,']'
                                                    );
                              --
                              vv_DateValue := TO_CHAR(SYSDATE, vv_DateFormat);
                              --
                              vv_PropertiesRecord := vv_PropertiesRecord
                                                   ||vv_DateValue
                                                   ||',';
                              --
                              EXCEPTION
                                   --
                                   WHEN OTHERS
                                   THEN
                                        --
                                        RAISE;
                                        --
                                   --** END OTHERS Exception
                                   --
                              --** END Exception Handler
                              --
                         END;
                         --
                    ELSIF JobParameters_rec.parameter_value = '[AR_TRX_SOURCE_ID]'
                    THEN
                         --
                         --
                         vt_ParameterValue := get_single_parameter_value
                                                   (
                                                    pt_i_ApplicationSuite => 'FIN'
                                                   ,pt_i_Application      => 'AR'
                                                   ,pt_i_BusinessEntity   => 'TRANSACTIONS'
                                                   ,pt_i_SubEntity        => 'ALL'
                                                   ,pt_i_ParameterCode    => 'AR_TRX_SOURCE_ID'
                                                   );
                         --
                         vv_PropertiesRecord := vv_PropertiesRecord
                                              ||vt_ParameterValue
                                              ||',';
                         --
                    ELSE
                         --
                         vv_PropertiesRecord := vv_PropertiesRecord
                                              ||JobParameters_rec.parameter_value
                                              ||',';
                         --
                    END IF;
                    --
               END LOOP;
               --
               vv_PropertiesRecord := RTRIM(vv_PropertiesRecord, ',');
               --
          ELSE
               --
               gvt_ModuleMessage := 'All parameters are mandatory.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          RETURN(vv_PropertiesRecord);
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RETURN(NULL);
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
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    RETURN(NULL);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END gen_properties_record;
     --
     --
     /*
     ******************************************
     ** PROCEDURE: close_transform_phase
     **
     ** Called from each Extract Main procedure
     ******************************************
     */
     --
     PROCEDURE close_export_phase
                    (
                     pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'close_export_phase';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vn_ExistenceCount               NUMBER;
          vt_MigrationStatus              xxmx_migration_headers.migration_status%TYPE;
          vn_DetailErrorCount             NUMBER;
          vt_ErrorMessage                 xxmx_module_messages.module_message%TYPE;
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
          gvv_ProgressIndicator := '0010';
          --
          IF   pt_i_MigrationSetID IS NOT NULL
          THEN
               --
               gvv_ProgressIndicator := '0020';
               --
               SELECT COUNT(1)
               INTO   vn_ExistenceCount
               FROM   xxmx_migration_headers  xfmh
               WHERE  1 = 1
               AND    xfmh.migration_set_id = pt_i_MigrationSetID;
               --
               IF   vn_ExistenceCount = 0
               THEN
                    --
                    gvv_ProgressIndicator := '0030';
                    --
                    gvt_ModuleMessage := 'Migration Set has not been initialized for Migration Set ID '||pt_i_MigrationSetID||'.';
                    --
                    RAISE e_ModuleError;
                    --
               ELSE
                    --
                    --** Examine the Migration Details table for the current Migration Set ID
                    --** to ascertain if there have been any errors at the detail level for
                    --** the specific Phase.
                    --
                    SELECT COUNT(1)
                    INTO   vn_DetailErrorCount
                    FROM   xxmx_migration_details  xmd
                    WHERE  1 = 1
                    AND    xmd.migration_set_id = pt_i_MigrationSetID
                    AND    xmd.phase            = 'EXPORT'
                    AND    xmd.error_flag       = 'Y';
                    --
                    gvv_ProgressIndicator := '0040';
                    --
                    IF   vn_DetailErrorCount = 0
                    THEN
                         --
                         vt_ErrorMessage    := NULL;
                         vt_MigrationStatus := 'FUSION_IMPORT_READY';
                         --
                    ELSE
                         --
                         vt_ErrorMessage    := 'Export errors exist.  Import to Fusion Cloud cannot be performed.';
                         vt_MigrationStatus := 'EXPORT_ERRORS';
                         --
                    END IF;
                    --
                    --** Update record in migration headers table
                    --
                    UPDATE xxmx_migration_headers
                    SET    migration_status = vt_MigrationStatus
                    WHERE  1 = 1
                    AND    migration_set_id = pt_i_MigrationSetID
                    AND    phase            = 'EXPORT';
                    --
               END IF;
               --
          ELSE
               --
               gvt_ModuleMessage := 'Migration Set ID Parameter must be populated.';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          COMMIT;
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    ROLLBACK;
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    COMMIT; --** Commit the message to the Module Messages table.
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
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
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
     END close_export_phase;
     --
     --
     --
     --
    /*
     ********************************************
     ** PROCEDURE: init_file_migration_details
     **
     ** Called from the Dynamic SQL pre-validate
     ** procedure.
     *******************************************
     */
     --
     PROCEDURE init_file_migration_details
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_details.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_details.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_details.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_details.sub_entity%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_details.file_set_id%TYPE
                    ,pt_i_ValidateStartTimestamp     IN      xxmx_migration_details.extract_start_timestamp%TYPE
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'init_file_migration_details';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vn_ExistenceCount               NUMBER;
          vt_BusinessEntitySeq            xxmx_migration_details.business_entity_seq%TYPE;
          vt_SubEntitySeq                 xxmx_migration_details.sub_entity_seq%TYPE;
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
          gct_Phase := 'EXTRACT';
          --
          gvv_ProgressIndicator := '0010';
          --
          IF   pt_i_ApplicationSuite       IS NOT NULL
          AND  pt_i_Application            IS NOT NULL
          AND  pt_i_BusinessEntity         IS NOT NULL
          AND  pt_i_SubEntity              IS NOT NULL
          AND  pt_i_FileSetID              IS NOT NULL
          AND  pt_i_ValidateStartTimestamp IS NOT NULL
          THEN
               --
               gvv_ProgressIndicator := '0020';
               --
               SELECT COUNT(1)
               INTO   vn_ExistenceCount
               FROM   xxmx_migration_details  xfmd
               WHERE  1 = 1
               AND    xfmd.business_entity  = pt_i_BusinessEntity
               AND    xfmd.sub_entity       = pt_i_SubEntity
               AND    xfmd.file_set_id      = pt_i_FileSetID;
               --
               IF   vn_ExistenceCount = 0
               THEN
                    --
                    gvv_ProgressIndicator := '0030';
                    --
                    /*
                    ** Retrieve the Business Entity and Sub-Entity sequence numbers for inclusion in the
                    ** insert into the Migration Details table.
                    */
                    --
                    vt_BusinessEntitySeq := get_business_entity_seq
                                                 (
                                                  pt_i_ApplicationSuite => pt_i_ApplicationSuite
                                                 ,pt_i_Application      => pt_i_Application
                                                 ,pt_i_BusinessEntity   => pt_i_BusinessEntity
                                                 );
                    --
                    vt_SubEntitySeq      := get_sub_entity_seq
                                                 (
                                                  pt_i_ApplicationSuite => pt_i_ApplicationSuite
                                                 ,pt_i_Application      => pt_i_Application
                                                 ,pt_i_BusinessEntity   => pt_i_BusinessEntity
                                                 ,pt_i_SubEntity        => pt_i_SubEntity
                                                 );
                    --
                    gvv_ProgressIndicator := '0040';
                    --
                    INSERT
                    INTO   xxmx_migration_details
                               (
                                application_suite        
                               ,application              
                               ,business_entity_seq      
                               ,business_entity          
                               ,sub_entity_seq           
                               ,sub_entity               
                               ,file_set_id              
                               ,migration_set_id         
                               ,phase                    
                               ,validate_start_timestamp 
                               ,validate_end_timestamp   
                               ,validate_hours           
                               ,validate_minutes         
                               ,validate_seconds         
                               ,validate_row_count       
                               ,extract_start_timestamp  
                               ,extract_end_timestamp    
                               ,extract_hours            
                               ,extract_minutes          
                               ,extract_seconds          
                               ,extract_row_count        
                               ,transform_start_timestamp
                               ,transform_end_timestamp  
                               ,transform_hours          
                               ,transform_minutes        
                               ,transform_seconds        
                               ,export_file_name         
                               ,export_start_timestamp   
                               ,export_end_timestamp     
                               ,export_hours             
                               ,export_minutes           
                               ,export_seconds           
                               ,export_row_count         
                               ,migration_status         
                               ,error_flag               
                               )
                    VALUES
                               (
                                UPPER(pt_i_ApplicationSuite)    -- application_suite         
                               ,UPPER(pt_i_Application)         -- application               
                               ,vt_BusinessEntitySeq            -- business_entity_seq       
                               ,UPPER(pt_i_BusinessEntity)      -- business_entity           
                               ,vt_SubEntitySeq                 -- sub_entity_seq            
                               ,UPPER(pt_i_SubEntity)           -- sub_entity                
                               ,pt_i_FileSetID                  -- file_set_id               
                               ,0                               -- migration_set_id          
                               ,'EXTRACT'                       -- phase                     
                               ,pt_i_ValidateStartTimestamp     -- validate_start_timestamp  
                               ,NULL                            -- validate_end_timestamp    
                               ,NULL                            -- validate_hours            
                               ,NULL                            -- validate_minutes          
                               ,NULL                            -- validate_seconds          
                               ,NULL                            -- validate_row_count        
                               ,NULL                            -- extract_start_timestamp   
                               ,NULL                            -- extract_end_timestamp     
                               ,NULL                            -- extract_hours             
                               ,NULL                            -- extract_minutes           
                               ,NULL                            -- extract_seconds           
                               ,NULL                            -- extract_row_count         
                               ,NULL                            -- transform_start_timestamp 
                               ,NULL                            -- transform_end_timestamp   
                               ,NULL                            -- transform_hours           
                               ,NULL                            -- transform_minutes         
                               ,NULL                            -- transform_seconds         
                               ,NULL                            -- export_file_name          
                               ,NULL                            -- export_start_timestamp    
                               ,NULL                            -- export_end_timestamp      
                               ,NULL                            -- export_hours              
                               ,NULL                            -- export_minutes            
                               ,NULL                            -- export_seconds            
                               ,NULL                            -- export_row_count          
                               ,NULL                            -- migration_status          
                               ,NULL                            -- error_flag                
                               );
                    --
               ELSE
                    --
                    gvt_ModuleMessage := 'Entity Level details already exist in "xxmx_migration_details" for Business Entity "'
                                       ||pt_i_BusinessEntity
                                       ||'", Sub-Entity "'
                                       ||pt_i_SubEntity
                                       ||'" and File Set ID "'
                                       ||pt_i_FileSetID
                                       ||'".';
                    --
                    --RAISE e_ModuleError;
                    --
               END IF;
               --
          ELSE
               --
               gvt_ModuleMessage := 'All Input Parameters are mandatory in call to "'
                                  ||gct_PackageName
                                  ||'.'
                                  ||ct_ProcOrFuncName
                                  ||'".';
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          COMMIT;
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    ROLLBACK;
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
                         ,pt_i_SubEntity         => pt_i_SubEntity       
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    COMMIT; --** Commit the message to the Module Messages table.
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
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
                         ,pt_i_SubEntity         => pt_i_SubEntity       
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gct_Phase
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
     END init_file_migration_details;
     --
     --
     /*
     ********************************
     ** PROCEDURE: verify_lookup_code
     ********************************
     */
     --
     PROCEDURE verify_lookup_code
                    (
                     pt_i_LookupType                 IN      xxmx_lookup_values.lookup_type%TYPE
                    ,pt_i_LookupCode                 IN      xxmx_lookup_values.lookup_code%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    ,pt_o_ReturnMessage                 OUT  xxmx_data_messages.data_message%TYPE
                    )
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'verify_lookup_code';
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
          --
     --** END Declarations **
     --
     BEGIN
          --
          gvv_ProgressIndicator := '0010';
          --
          pv_o_ReturnStatus  := 'S';
          pt_o_ReturnMessage := ''; 
          --
          SELECT COUNT(1)
          INTO   gvn_ExistenceCheckCount
          FROM   xxmx_lookup_types  xlt
          WHERE  1 = 1
          AND    xlt.lookup_type = pt_i_LookupType;
          --
          IF   gvn_ExistenceCheckCount = 0
          THEN
               --
               pv_o_ReturnStatus := 'F';
               --
               pt_o_ReturnMessage := 'Lookup Type "'
                                   ||pt_i_LookupType
                                   ||'" is not defined in the XXMX_LOOKUP_TYPES table.';
               --
          ELSE
               --
               SELECT COUNT(1)
               INTO   gvn_ExistenceCheckCount
               FROM   xxmx_lookup_values  xlv
               WHERE  1 = 1
               AND    xlv.lookup_type            = pt_i_LookupType
               AND    xlv.lookup_code            = pt_i_LookupCode
               AND    NVL(xlv.enabled_flag, 'N') = 'Y';
               --
               IF   gvn_ExistenceCheckCount = 0
               THEN
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    pt_o_ReturnMessage := 'Lookup Code "'
                                        ||pt_i_LookupCode
                                        ||'" is not defined in the XXMX_LOOKUP_VALUES table for Lookup Type "'
                                        ||pt_i_LookupType
                                        ||'" or it is not enabled.';
                    --
               ELSIF gvn_ExistenceCheckCount > 1
               THEN
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    pt_o_ReturnMessage := 'Lookup Code "'
                                        ||pt_i_LookupCode
                                        ||'" is defined in the XXMX_LOOKUP_VALUES table for Lookup Type "'
                                        ||pt_i_LookupType
                                        ||'" more than once.';
                    --
               END IF; --** IF   gvn_ExistenceCheckCount = 0
               --
          END IF; --** IF   gvn_ExistenceCheckCount = 0
          --
          EXCEPTION
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
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    pt_o_ReturnMessage := 'Oracle error encountered in call to "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||'".  Please refer to the Module Messages table for more details.';
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END verify_lookup_code;
     --
     --  
     --
     --
     /*
     **********************************
     ** PROCEDURE: log_data_message
     **
     ** Called from various procedures.
     **********************************
     */
     --
     PROCEDURE log_data_message
                    (
                     pt_i_ApplicationSuite           IN      xxmx_data_messages.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_data_messages.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_data_messages.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_data_messages.sub_entity%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_data_messages.file_set_id%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_data_messages.migration_set_id%TYPE
                    ,pt_i_Phase                      IN      xxmx_data_messages.phase%TYPE
                    ,pt_i_Severity                   IN      xxmx_data_messages.severity%TYPE
                    ,pt_i_DataTable                  IN      xxmx_data_messages.data_table%TYPE
                    ,pt_i_RowSeq                     IN      xxmx_data_messages.row_seq%TYPE
                    ,pt_i_DataMessage                IN      xxmx_data_messages.data_message%TYPE
                    ,pt_i_DataElementsAndValues      IN      xxmx_data_messages.data_elements_and_values%TYPE
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'log_data_message';
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
          --
     --** END Declarations **
     --
     BEGIN
          --
          gvv_ProgressIndicator := '0010';
          --
          --** Insert data message record.
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
          IF   UPPER(pt_i_Phase) NOT IN ('EXTRACT', 'TRANSFORM', 'EXPORT')
          THEN
               --
               gvt_ModuleMessage := 'pt_i_Phase parameter must be "EXTRACT", "TRANSFORM" or "EXPORT".';
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
          INTO   xxmx_data_messages
                 (
                  data_message_id
                 ,application_suite
                 ,application
                 ,business_entity
                 ,sub_entity
                 ,file_set_id
                 ,migration_set_id
                 ,phase
                 ,message_timestamp
                 ,severity
                 ,data_table
                 ,row_seq
                 ,data_message
                 ,data_elements_and_values
                 )
          VALUES
                 (
                  xxmx_data_message_ids_s.NEXTVAL  -- data_message_id
                 ,UPPER(pt_i_ApplicationSuite)     -- application_suite
                 ,UPPER(pt_i_Application)          -- application
                 ,UPPER(pt_i_BusinessEntity)       -- business_entity
                 ,UPPER(pt_i_SubEntity)            -- sub_entity
                 ,pt_i_FileSetID                   -- file_set_id
                 ,pt_i_MigrationSetID              -- migration_set_id
                 ,UPPER(pt_i_Phase)                -- phase
                 ,LOCALTIMESTAMP(3)                -- message_timestamp
                 ,UPPER(pt_i_Severity)             -- severity
                 ,LOWER(pt_i_DataTable)            -- data_table
                 ,pt_i_RowSeq                      -- row_seq
                 ,pt_i_DataMessage                 -- data_message
                 ,pt_i_DataElementsAndValues       -- data_elements_and_values
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
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => gvt_OracleError
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
                    gvt_ModuleMessage := 'Oracle error encountered after Progress Indicator.';
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END log_data_message;
     --
     --
     /*
     *****************************************************************************************
     ** PROCEDURE: valid_install
     **
     ** This function will verify that the initial installation scripts for Maximise have
     ** been executed.
     **
     ** This procedure is called from STG_MAIN.
     *****************************************************************************************
     */
     --
     FUNCTION valid_install
     RETURN BOOLEAN
     IS
          --
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
          CURSOR CoreParameters_cur
          IS
               --
               SELECT  UPPER(parameter_code)  AS parameter_code
                      ,UPPER(lookup_type)     AS lookup_type
                      ,parameter_value
               FROM    xxmx_core_parameters;
               --
          --** END CURSOR CoreParameters_cur
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'valid_install';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vb_ReturnStatus                 BOOLEAN;
          vb_SeededLookupsPopulated       BOOLEAN;
          vb_CoreParametersPopulated      BOOLEAN;
          vb_ClientParametersPopulated    BOOLEAN;
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
          vb_ReturnStatus := TRUE;
          --
          gvv_ProgressIndicator := '0010';
          --
          log_module_message
               (
                pt_i_ApplicationSuite  => GCT_APPLICATIONSUITE
               ,pt_i_Application       => GCT_APPLICATION
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => GCT_SUBENTITY
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'FUNCTION : '
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||' initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          /*
          *********************************************************
          ** Verify that Core tables have been initially populated.
          *********************************************************
          */
          --
          log_module_message
               (
                pt_i_ApplicationSuite  => GCT_APPLICATIONSUITE
               ,pt_i_Application       => GCT_APPLICATION
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => GCT_SUBENTITY
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '- Verifying Core Tables have been initially populated.'
               ,pt_i_OracleError       => NULL
               );
          --
          /*
          ** XXMX_MIGRATION_METADATA table.
          */
          --
          gvn_ExistenceCheckCount := NULL;
          --
          SELECT  COUNT(*)
          INTO    gvn_ExistenceCheckCount
          FROM    xxmx_migration_metadata xmd
          WHERE   1 = 1;
          --
          IF   gvn_ExistenceCheckCount = 0
          THEN
               --
               vb_ReturnStatus := FALSE;
               --
               log_module_message
                    (
                     pt_i_ApplicationSuite  => GCT_APPLICATIONSUITE
                    ,pt_i_Application       => GCT_APPLICATION
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => GCT_SUBENTITY
                    ,pt_i_FileSetID         => 0
                    ,pt_i_MigrationSetID    => 0
                    ,pt_i_Phase             => gct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Table "xxmx_migration_metadata" is NOT populated.  '
                                             ||'Please ensure the "xxmx_populate_metadata.sql" script is executed.'
                    ,pt_i_OracleError       => NULL
                    );
               --
          END IF; --** IF gvn_ExistenceCheckCount = 0
          --
          /*
          ** XXMX_LOOKUP_TYPES /XXMX_LOOKUP_VALUES tables.
          **
          ** The XXMX_LOOKUP_VALUES table is populated by the same script as
          ** the XXMX_LOOKUP_TYPES table so there should no need to check
          ** the XXMX_LOOKUP_VALUES table.          
          */
          --
          vb_SeededLookupsPopulated := TRUE;
          --
          SELECT COUNT(*)
          INTO   gvn_ExistenceCheckCount
          FROM   xxmx_lookup_types
          WHERE  1 = 1
          AND    customisation_level = 'S';
          --
          IF   gvn_ExistenceCheckCount = 0
          THEN
               --
               vb_SeededLookupsPopulated := FALSE;
               --
               vb_ReturnStatus := FALSE;
               --
               log_module_message
                    (
                     pt_i_ApplicationSuite  => GCT_APPLICATIONSUITE
                    ,pt_i_Application       => GCT_APPLICATION
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => GCT_SUBENTITY
                    ,pt_i_FileSetID         => 0
                    ,pt_i_MigrationSetID    => 0
                    ,pt_i_Phase             => gct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Table "xxmx_lookup_types" is NOT populated with SEEDED Lookups.  '
                                             ||'Please ensure the "xxmx_populate_lookups.sql" script is executed.'
                    ,pt_i_OracleError       => NULL
                    );
               --
          END IF; --** IF gvn_ExistenceCheckCount = 0
          --
           --
          /*
          ** XXMX_SOURCE_OPERATING_UNITS Table.
          */
          --
          gvv_ProgressIndicator := '0020';
          --
          SELECT COUNT(*)
          INTO   gvn_ExistenceCheckCount
          FROM   xxmx_source_operating_units;
          --
          IF   gvn_ExistenceCheckCount = 0
          THEN
               --
               vb_ReturnStatus := FALSE;
               --
               log_module_message
                    (
                     pt_i_ApplicationSuite  => GCT_APPLICATIONSUITE
                    ,pt_i_Application       => GCT_APPLICATION
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => GCT_SUBENTITY
                    ,pt_i_FileSetID         => 0
                    ,pt_i_MigrationSetID    => 0
                    ,pt_i_Phase             => gct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Table "xxmx_source_operating_units" is NOT populated.  '
                                             ||'Please ensure the "xxmx_populate_operating_units.sql" script is executed.'
                    ,pt_i_OracleError       => NULL
                    );
               --
          ELSE /* This can be moved into the verify_metadata procedure specific Business Entity processing section. */
               --
               /*
               ** Detailed Checks on the XXMX_SORCE_OPERATING_UNITS table
               ** can be placed here when we have more time such as:
               **
               ** We can check the XXMX_MIGRATION_METADATA table to see:
               **
               ** 1) If AP Invoices is enabled, then check that
               **    AP_INV_FUSION_CLEARING_ACCT is populated.  If it
               **    is we could call the XXMX_GL_UTILITIES to check
               **    the entered account is valid.
               ** 2) If AR Invoices is enabled, then check that
               **    AR_TRX_FUSION_CLEARING_ACCT is populated.  If it
               **    is we could call the XXMX_GL_UTILITIES to check
               **    the entered account is valid.
               ** 3) If CASH_RECEIPTS is enabled then chack that the
               **    Cash Receipt related data held against the Operating
               **    Unit has been provided (e.g. LOCKBOX_NUMBER,
               **    LOCKBOX_ID, LOCKBOX_TRANSMISSION_FMT,
               **    LOCKBOX_TRANSMISSION_FMT_ID).
               */
               --
               NULL;
               --
          END IF; --** IF gvn_ExistenceCheckCount = 0
          --
          /*
          ** XXMX_MIGRATION_PARAMETERS Table.
          */
          --
          gvv_ProgressIndicator := '0030';
          --
          vb_CoreParametersPopulated := TRUE;
          --
          SELECT COUNT(*)
          INTO   gvn_ExistenceCheckCount
          FROM   xxmx_core_parameters;
          --
          IF   gvn_ExistenceCheckCount = 0
          THEN
               --
               vb_CoreParametersPopulated := FALSE;
               vb_ReturnStatus            := FALSE;
               --
               log_module_message
                    (
                     pt_i_ApplicationSuite  => GCT_APPLICATIONSUITE
                    ,pt_i_Application       => GCT_APPLICATION
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => GCT_SUBENTITY
                    ,pt_i_FileSetID         => 0
                    ,pt_i_MigrationSetID    => 0
                    ,pt_i_Phase             => gct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Table "xxmx_core_parameters" is NOT populated.  '
                                             ||'Please ensure the "xxmx_populate_core_parameters.sql" script is executed.'
                    ,pt_i_OracleError       => NULL
                    );
               --
          END IF; --** IF gvn_ExistenceCheckCount = 0
          --
          /*
          ** XXMX_MIGRATION_PARAMETERS Table.
          */
          --
          gvv_ProgressIndicator := '0040';
          --
          vb_ClientParametersPopulated := TRUE;
          --
          SELECT COUNT(*)
          INTO   gvn_ExistenceCheckCount
          FROM   xxmx_migration_parameters;
          --
          IF   gvn_ExistenceCheckCount = 0
          THEN
               --
               vb_ClientParametersPopulated := FALSE;
               vb_ReturnStatus              := FALSE;
               --
               log_module_message
                    (
                     pt_i_ApplicationSuite  => GCT_APPLICATIONSUITE
                    ,pt_i_Application       => GCT_APPLICATION
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => GCT_SUBENTITY
                    ,pt_i_FileSetID         => 0
                    ,pt_i_MigrationSetID    => 0
                    ,pt_i_Phase             => gct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Table "xxmx_migration_parameters" is NOT populated.  '
                                             ||'Please ensure the "xxmx_populate_default_migration_parameters.sql" script is executed.'
                    ,pt_i_OracleError       => NULL
                    );
               --
          END IF; --** IF gvn_ExistenceCheckCount = 0
          --
          /*
          ** XXMX_FILE_GROUP_PROPERTIES Table.
          */
          --
          gvv_ProgressIndicator := '0050';
          --
          SELECT COUNT(*)
          INTO   gvn_ExistenceCheckCount
          FROM   xxmx_file_group_properties;
          --
          IF   gvn_ExistenceCheckCount = 0
          THEN
               --
              -- vb_ReturnStatus := FALSE;
               --
               log_module_message
                    (
                     pt_i_ApplicationSuite  => GCT_APPLICATIONSUITE
                    ,pt_i_Application       => GCT_APPLICATION
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => GCT_SUBENTITY
                    ,pt_i_FileSetID         => 0
                    ,pt_i_MigrationSetID    => 0
                    ,pt_i_Phase             => gct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Table "xxmx_file_group_properties" is NOT populated.  '
                                             ||'Please ensure the "xxmx_populate_file_groups.sql" script is executed.'
                    ,pt_i_OracleError       => NULL
                    );
               --
          END IF; --** IF gvn_ExistenceCheckCount = 0
          --
          /*
          ** XXMX_FILE_LOCATIONS Table.
          */
          --
          gvv_ProgressIndicator := '0060';
          --
          SELECT COUNT(*)
          INTO   gvn_ExistenceCheckCount
          FROM   xxmx_file_locations;
          --
          IF   gvn_ExistenceCheckCount = 0
          THEN
               --
              -- vb_ReturnStatus := FALSE;
               --
               log_module_message
                    (
                     pt_i_ApplicationSuite  => GCT_APPLICATIONSUITE
                    ,pt_i_Application       => GCT_APPLICATION
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => GCT_SUBENTITY
                    ,pt_i_FileSetID         => 0
                    ,pt_i_MigrationSetID    => 0
                    ,pt_i_Phase             => gct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Table "xxmx_file_locations" is NOT populated.  '
                                             ||'Please ensure the "xxmx_populate_file_locations.sql" script is executed.'
                    ,pt_i_OracleError       => NULL
                    );
               --
          END IF; --** IF gvn_ExistenceCheckCount = 0
          --
          /*
          ** XXMX_FUSION_JOB_DEFINITIONS Table.
          **
          ** We don't need to check that the XXMX_FUSION_JOB_PARAMETERS table
          ** is populated as that is populated by the same script as the
          ** XXMX_FUSION_JOB_DEFINITIONS table.
          */
          --
          gvv_ProgressIndicator := '0070';
          --
          SELECT COUNT(*)
          INTO   gvn_ExistenceCheckCount
          FROM   xxmx_fusion_job_definitions;
          --
          IF   gvn_ExistenceCheckCount = 0
          THEN
               --
               --vb_ReturnStatus := FALSE;
               --
               log_module_message
                    (
                     pt_i_ApplicationSuite  => GCT_APPLICATIONSUITE
                    ,pt_i_Application       => GCT_APPLICATION
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => GCT_SUBENTITY
                    ,pt_i_FileSetID         => 0
                    ,pt_i_MigrationSetID    => 0
                    ,pt_i_Phase             => gct_Phase
                    ,pt_i_Severity          => 'ERROR'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Table "xxmx_fusion_job_definitions" is NOT populated.  '
                                             ||'Please ensure the "xxmx_populate_fusion_job_defs.sql" script is executed.'
                    ,pt_i_OracleError       => NULL
                    );
               --
          END IF; --** IF gvn_ExistenceCheckCount = 0
          --
          /*
          ** Verify Core Parameters in the XXMX_CORE_PARAMETERS table
          ** and have valid values.
          **
          ** The valid values can only be verified if the XXMX_LOOKUPS_TABLE
          ** and XXMX_LOOKUP_VALUES tables have been populated and the
          ** PARAMETER_CODE has a LOOKUP_TYPE specified for it.
          */
          --
          IF   vb_CoreParametersPopulated
          THEN
               --
               log_module_message
                    (
                     pt_i_ApplicationSuite  => GCT_APPLICATIONSUITE
                    ,pt_i_Application       => GCT_APPLICATION
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => GCT_SUBENTITY
                    ,pt_i_FileSetID         => 0
                    ,pt_i_MigrationSetID    => 0
                    ,pt_i_Phase             => gct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '- Verifying Parameters required by Core Functionality (not Client Data Scope parameters).'
                    ,pt_i_OracleError       => NULL
                    );
               --
               /*
               ** Verify Parameters required by Core Code have valid values.
               */
               --
               FOR  CoreParameter_rec
               IN   CoreParameters_cur
               LOOP
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => GCT_APPLICATIONSUITE
                         ,pt_i_Application       => GCT_APPLICATION
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => GCT_SUBENTITY
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '  - Verifying Parameter "'
                                                  ||CoreParameter_rec.parameter_code
                                                  ||'".'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    gvv_ProgressIndicator := '0075';
                    --
                    IF   CoreParameter_rec.parameter_value IS NULL
                    THEN
                         --
                         vb_ReturnStatus := FALSE;
                         --
                         log_module_message
                              (
                               pt_i_ApplicationSuite  => GCT_APPLICATIONSUITE
                              ,pt_i_Application       => GCT_APPLICATION
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => GCT_SUBENTITY
                              ,pt_i_FileSetID         => 0
                              ,pt_i_MigrationSetID    => 0
                              ,pt_i_Phase             => gct_Phase
                              ,pt_i_Severity          => 'ERROR'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '    - Parameter does not have a value assigned in the XXMX_CORE_PARAMETERS '
                                                       ||'table.  All Core Parameters should have a value.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                    ELSE
                         --
                         gvv_ProgressIndicator := '0080';
                         --
                         IF   CoreParameter_rec.lookup_type IS NOT NULL
                         THEN
                              --
                              log_module_message
                                   (
                                    pt_i_ApplicationSuite  => GCT_APPLICATIONSUITE
                                   ,pt_i_Application       => GCT_APPLICATION
                                   ,pt_i_BusinessEntity    => gct_BusinessEntity
                                   ,pt_i_SubEntity         => GCT_SUBENTITY
                                   ,pt_i_FileSetID         => 0
                                   ,pt_i_MigrationSetID    => 0
                                   ,pt_i_Phase             => gct_Phase
                                   ,pt_i_Severity          => 'NOTIFICATION'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '    - Verifying parameter value "'
                                                            ||CoreParameter_rec.parameter_value
                                                            ||'" against Lookup Type "'
                                                            ||CoreParameter_rec.lookup_type
                                                            ||'".'
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                              gvv_ProgressIndicator := '0085';
                              verify_lookup_code
                                   (
                                    pt_i_LookupType    => CoreParameter_rec.lookup_type
                                   ,pt_i_LookupCode    => CoreParameter_rec.parameter_value
                                   ,pv_o_ReturnStatus  => gvv_ReturnStatus
                                   ,pt_o_ReturnMessage => gvt_ReturnMessage
                                   );
                              --
                              IF   gvv_ReturnStatus  <> 'S'
                              THEN
                                   --
                                   vb_ReturnStatus := FALSE;
                                   gvv_ProgressIndicator := '0090';
                                   --
                                   log_module_message
                                        (
                                         pt_i_ApplicationSuite  => GCT_APPLICATIONSUITE
                                        ,pt_i_Application       => GCT_APPLICATION
                                        ,pt_i_BusinessEntity    => gct_BusinessEntity
                                        ,pt_i_SubEntity         => GCT_SUBENTITY
                                        ,pt_i_FileSetID         => 0
                                        ,pt_i_MigrationSetID    => 0
                                        ,pt_i_Phase             => gct_Phase
                                        ,pt_i_Severity          => 'ERROR'
                                        ,pt_i_PackageName       => gct_PackageName
                                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage     => '      - '
                                                                 ||gvt_ReturnMessage
                                        ,pt_i_OracleError       => NULL
                                        );
                                   --
                              ELSE
                                   --
                                   gvv_ProgressIndicator := '0095';
                                   log_module_message
                                        (
                                         pt_i_ApplicationSuite  => GCT_APPLICATIONSUITE
                                        ,pt_i_Application       => GCT_APPLICATION
                                        ,pt_i_BusinessEntity    => gct_BusinessEntity
                                        ,pt_i_SubEntity         => GCT_SUBENTITY
                                        ,pt_i_FileSetID         => 0
                                        ,pt_i_MigrationSetID    => 0
                                        ,pt_i_Phase             => gct_Phase
                                        ,pt_i_Severity          => 'NOTIFICATION'
                                        ,pt_i_PackageName       => gct_PackageName
                                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage     => '      - Parameter value "'
                                                                 ||CoreParameter_rec.parameter_value
                                                                 ||'" is valid.'
                                        ,pt_i_OracleError       => NULL
                                        );
                                   --
                              END IF; --** IF gvv_ReturnStatus <> 'S'
                              --
                         ELSE
                              --
                              gvv_ProgressIndicator := '0100';
                              log_module_message
                                   (
                                    pt_i_ApplicationSuite  => GCT_APPLICATIONSUITE
                                   ,pt_i_Application       => GCT_APPLICATION
                                   ,pt_i_BusinessEntity    => gct_BusinessEntity
                                   ,pt_i_SubEntity         => GCT_SUBENTITY
                                   ,pt_i_FileSetID         => 0
                                   ,pt_i_MigrationSetID    => 0
                                   ,pt_i_Phase             => gct_Phase
                                   ,pt_i_Severity          => 'NOTIFICATION'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '    - Parameter has no Lookup Type to validate value "'
                                                            ||CoreParameter_rec.parameter_value
                                                            ||'" against therefore value is assumed to be valid.'
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                         END IF; --** IF CoreParameter_rec.lookup_type IS NOT NULL
                         --
                    END IF; --** IF vt_ParameterCheck IS NULL
                    --
               END LOOP; --** CoreParameters_cur LOOP
               --
          END IF; --** IF vb_ParametersPopulated
          --
          RETURN(vb_ReturnStatus);
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    ROLLBACK;
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => GCT_APPLICATIONSUITE
                         ,pt_i_Application       => GCT_APPLICATION
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => GCT_SUBENTITY
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gct_Phase
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
                    RETURN(FALSE);
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
                                             ,1
                                             ,4000
                                             );
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => GCT_APPLICATIONSUITE
                         ,pt_i_Application       => GCT_APPLICATION
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => GCT_SUBENTITY
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gct_Phase
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
                    RETURN(FALSE);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END valid_install;

    /*
     ***********************************************
     ** PROCEDURE : evaluate_transform
     **
     ** The following procedure operates in one of
     ** two modes when called.
     **
     ** If called in "VERIFY" mode it simply
     ** verifies that there is a transform specified
     ** for the given Source Value.
     **
     ** If called in "TRANSFORM" mode it returns
     ** the Fusion Value determined from the Source
     ** Value.
     ***********************************************
     */
     --
     PROCEDURE evaluate_transform
                    (
                     pt_i_ApplicationSuite           IN      xxmx_simple_transforms.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_simple_transforms.application%TYPE
                    ,pt_i_SourceOperatingUnitName    IN      xxmx_simple_transforms.source_operating_unit_name%TYPE
                    ,pt_i_TransformCode              IN      xxmx_simple_transforms.transform_code%TYPE
                    ,pt_i_SourceValue                IN      xxmx_simple_transforms.source_value%TYPE
                    ,pt_i_EvaluationMode             IN      xxmx_lookup_values.lookup_code%TYPE
                    ,pt_o_FusionValue                   OUT  xxmx_simple_transforms.fusion_value%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    ,pv_o_ReturnCode                    OUT  VARCHAR2
                    ,pv_o_ReturnMessage                 OUT  VARCHAR2                   
                    )
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'evaluate_transform';
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
          gvv_ProgressIndicator := '0010';
          --
          pv_o_ReturnStatus  := 'S';
          pv_o_ReturnCode    := '';
          pv_o_ReturnMessage := '';
          gvv_ReturnStatus   := '';
          gvt_ReturnMessage  := '';
          --
            log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Begin evaluate_transform'
                         ,pt_i_OracleError       => gvt_OracleError
                         );

           gvt_ModuleMessage:= 'Begin ';
          --
          IF   pt_i_ApplicationSuite IS NULL
          OR   pt_i_Application      IS NULL
          OR   pt_i_TransformCode    IS NULL
          OR   pt_i_SourceValue      IS NULL
          OR   pt_i_EvaluationMode   IS NULL
          THEN
               --
               gvv_ProgressIndicator := '0010';
               gvt_ModuleMessage:= '"pt_i_ApplicationSuite", "pt_i_Application", "pt_i_TransformCode", '
                                   ||'"pt_i_SourceValue" and "pt_i_EvaluationMode" parameters are mandatory'
                                   ||'in call to "'
                                   ||gct_PackageName
                                   ||'.'
                                   ||ct_ProcOrFuncName
                                   ||'".';
               pv_o_ReturnMessage := '"pt_i_ApplicationSuite", "pt_i_Application", "pt_i_TransformCode", '
                                   ||'"pt_i_SourceValue" and "pt_i_EvaluationMode" parameters are mandatory'
                                   ||'in call to "'
                                   ||gct_PackageName
                                   ||'.'
                                   ||ct_ProcOrFuncName
                                   ||'".';
               --
               RAISE e_ModuleError;
               --
          ELSE
               --
               IF   pt_i_SourceOperatingUnitName IS NOT NULL
               THEN
                    --
                    gvv_ProgressIndicator := '0020';
                    SELECT COUNT(1)
                    INTO   gvn_ExistenceCheckCount
                    FROM   xxmx_source_operating_units  xsou
                    WHERE  1 = 1
                    AND    xsou.source_operating_unit_name = pt_i_SourceOperatingUnitName;
                    --
                    IF   gvn_ExistenceCheckCount = 0
                    THEN
                         --
                         gvv_ProgressIndicator := '0030';
                         pv_o_ReturnCode    := 'INVALID_OU';
                         pv_o_ReturnMessage := 'Value "'
                                             ||pt_i_SourceOperatingUnitName
                                             ||'" in the "pt_i_SourceOperatingUnitName" parameter does '
                                             ||'not exist in the "xxmx_source_operating_units" table.';
                         --
                         RAISE e_ModuleError;
                         --
                    END IF; --** IF   gvn_ExistenceCheckCount = 0
                    --
               END IF; --** IF   pt_i_SourceOperatingUnitName IS NOT NULL
               --
               IF   pt_i_EvaluationMode = 'VERIFY'
               THEN
                    --
                    gvn_ExistenceCheckCount := NULL;
                    gvv_ProgressIndicator := '0040';
                    --
                    SELECT COUNT(1)
                    INTO   gvn_ExistenceCheckCount
                    FROM   xxmx_simple_transforms  xst
                    WHERE  1 = 1
                    AND    xst.application_suite          = pt_i_ApplicationSuite
                    AND    xst.application                = pt_i_Application
                      AND    NVL(xst.source_operating_unit_name,'X') = NVL(pt_i_SourceOperatingUnitName, NVL(xst.source_operating_unit_name,'X'))
                    AND    xst.transform_code             = pt_i_TransformCode
                    AND    xst.source_value               = pt_i_SourceValue;
                    --
                    IF   gvn_ExistenceCheckCount = 0
                    THEN
                         --
                         pv_o_ReturnCode := 'NO_TRANSFORM';
                         gvv_ProgressIndicator := '0050';
                         --
                         pv_o_ReturnMessage := 'Source Value "'
                                             ||pt_i_SourceValue
                                             ||'" does not exist in the "xxmx_simple_transforms" table '
                                             ||'for Transform Code "'
                                             ||pt_i_TransformCode
                                             ||'".';
                         gvt_ModuleMessage:= 'Source Value "'
                                             ||pt_i_SourceValue
                                             ||'" does not exist in the "xxmx_simple_transforms" table '
                                             ||'for Transform Code "'
                                             ||pt_i_TransformCode
                                             ||'".';
                         --
                         RAISE e_ModuleError;
                         --
                    END IF; --** IF   gvn_ExistenceCheckCount = 0
                    --
               ELSIF pt_i_EvaluationMode = 'TRANSFORM'
               THEN
                    --
                    BEGIN
                         --
                         SELECT xst.fusion_value
                         INTO   pt_o_FusionValue
                         FROM   xxmx_simple_transforms   xst
                         WHERE  1 = 1
                         AND    xst.application_suite          = pt_i_ApplicationSuite
                         AND    xst.application                = pt_i_Application
                         AND    NVL(xst.source_operating_unit_name,'X') = NVL(pt_i_SourceOperatingUnitName, NVL(xst.source_operating_unit_name,'X'))
                         AND    xst.transform_code             = pt_i_TransformCode
                         AND    xst.source_value               = pt_i_SourceValue;
                         --
                         EXCEPTION
                              --
                              /*
                              ** TOO_MANY_ROWS Exception should not be possible due to
                              ** unique index on xxmx_simple_transforms table.
                              */
                              --
                              WHEN NO_DATA_FOUND
                              THEN
                                   --
                                   gvv_ProgressIndicator := '0060';
                                   pv_o_ReturnCode := 'NO_TRANSFORM';
                                   --
                                   IF   pt_i_SourceOperatingUnitName IS NOT NULL
                                   THEN
                                        --
                                        gvt_ModuleMessage := 'No transformations found for Application Suite "'
                                                           ||pt_i_ApplicationSuite
                                                           ||'", Application "'
                                                           ||pt_i_Application
                                                           ||'", Source Operating Unit Name "'
                                                           ||pt_i_SourceOperatingUnitName
                                                           ||'", Transform Code "'
                                                           ||pt_i_TransformCode
                                                           ||'" and Source Value '
                                                           ||pt_i_SourceValue
                                                           ||'" in xxmx_simple_transforms table.  No transformation value returned.';
                                        --
                                   ELSE
                                        --
                                        gvt_ModuleMessage := 'No transformations found for Application Suite "'
                                                           ||pt_i_ApplicationSuite
                                                           ||'", Application "'
                                                           ||pt_i_Application
                                                           ||'", Transform Code "'
                                                           ||pt_i_TransformCode
                                                           ||'" and Source Value '
                                                           ||pt_i_SourceValue
                                                           ||'" in xxmx_simple_transforms table.  No transformation value returned.';
                                        --
                                   END IF;
                                   --
                                   RAISE e_ModuleError;
                                   --
                              --** END NO_DATA_FOUND Exception
                              --
                              WHEN OTHERS
                              THEN
                                   --
                                   RAISE;
                                   --
                              --** END OTHERS Exception
                              --
                         --** END Local Exception Handler
                         --
                    END; --** END FUSION_VALUE retrieval block
                    --
               ELSE
                    --
                    gvt_ModuleMessage := '"pt_i_EvaluationMode" parameter must have a value of "VERIFY" or "TRANSFORM".';
                    --
                    RAISE e_ModuleError;
                    --
               END IF;
               --
          END IF; --** IF any required parameters are NULL
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                      log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'ERROR  evaluate_transform ' ||gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    pv_o_ReturnStatus  := 'F';
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
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END evaluate_transform;
     --
     /*
     *****************************************
     ** FUNCTION: get_core_parameter_value
     **
     ** Called from Maximise Core procedures.
     *****************************************
     */
     --
     FUNCTION get_core_parameter_value
                    (
                     pt_i_ParameterCode              IN      xxmx_core_parameters.parameter_code%TYPE
                    )
     RETURN VARCHAR2
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'get_core_parameter_value';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_ParameterValue               xxmx_core_parameters.parameter_value%TYPE;
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
          gvv_ProgressIndicator := '0010';
          --
          SELECT parameter_value
          INTO   vt_ParameterValue
          FROM   xxmx_core_parameters
          WHERE  1 = 1
          AND    parameter_code = pt_i_ParameterCode;
          --
          RETURN(vt_ParameterValue);
          --
          EXCEPTION
               --
               WHEN TOO_MANY_ROWS
               THEN
                    --
                    gvt_ModuleMessage := 'Too many matches found for Parameter Code "'
                                       ||pt_i_ParameterCode
                                       ||'" in "xxmx_core_parameters" table.  No parameter value returned.';
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'WARNING'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RETURN(NULL);
                    --
               --** END TOO_MANY_ROWS Exception
               --
               WHEN NO_DATA_FOUND
               THEN
                    --
                    gvt_ModuleMessage := 'No matches found for Parameter Code "'
                                       ||pt_i_ParameterCode
                                       ||'" in "xxmx_core_parameters" table.  No parameter value returned.';
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'WARNING'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    RETURN(NULL);
                    --
               --** END NO_DATA_FOUND Exception
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
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
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
                    RAISE_APPLICATION_ERROR(gcn_ApplicationErrorNumber, gvv_ApplicationErrorMessage);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END get_core_parameter_value;
     --
     --
     /*
     ***************************************************
     ** PROCEDURE: upd_file_migration_details
     **
     ** Called from the Dynamic SQL procedure
     ** "xxmx_dynamic_sql_pkg.prevalidate_stg_data" as
     ** that is the first Maximise process which operates
     ** on the Client Data at the Sub-Entity Level when
     ** Client Data is being loaded from Data Files.
     ***************************************************
     */
     --
     PROCEDURE upd_file_migration_details
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_details.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_details.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_details.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_details.sub_entity%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_details.file_set_id%TYPE
                    ,pt_i_Phase                      IN      xxmx_migration_details.phase%TYPE
                    ,pt_i_ValidateEndTimestamp       IN      xxmx_migration_details.validate_end_timestamp%TYPE
                    ,pt_i_ValidateRowCount           IN      xxmx_migration_details.validate_row_count%TYPE
                    ,pt_i_TransformStartTimestamp    IN      xxmx_migration_details.transform_start_timestamp%TYPE
                    ,pt_i_TransformEndTimestamp      IN      xxmx_migration_details.transform_end_timestamp%TYPE
                    ,pt_i_ExportFileName             IN      xxmx_migration_details.export_file_name%TYPE
                    ,pt_i_ExportStartTimestamp       IN      xxmx_migration_details.export_start_timestamp%TYPE
                    ,pt_i_ExportEndTimestamp         IN      xxmx_migration_details.export_end_timestamp%TYPE
                    ,pt_i_ExportRowCount             IN      xxmx_migration_details.export_row_count%TYPE
                    ,pt_i_ErrorFlag                  IN      xxmx_migration_details.error_flag%TYPE
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'upd_file_migration_details';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vn_ExistenceCount               NUMBER;
          vt_MigrationStatus              xxmx_migration_details.migration_status%TYPE;
          vt_StartTimestamp               xxmx_migration_details.extract_start_timestamp%TYPE;
          vt_ElapsedTime                  TIMESTAMP(3);
          vn_ValidateHours                NUMBER(2);
          vn_ValidateMinutes              NUMBER(2);
          vn_ValidateSeconds              NUMBER(2);
          vn_TransformHours               NUMBER(2);
          vn_TransformMinutes             NUMBER(2);
          vn_TransformSeconds             NUMBER(2);
          vn_ExportHours                  NUMBER(2);
          vn_ExportMinutes                NUMBER(2);
          vn_ExportSeconds                NUMBER(2);
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
          gvv_ProgressIndicator := '0010';
          --
          IF   pt_i_ApplicationSuite IS NULL
          OR   pt_i_Application      IS NULL
          OR   pt_i_BusinessEntity   IS NULL
          OR   pt_i_SubEntity        IS NULL
          OR   pt_i_FileSetID        IS NULL
          OR   pt_i_Phase            IS NULL
          THEN
               --
               gvt_ModuleMessage := '"pt_i_ApplicationSuite", "pt_i_Application", "pt_i_BusinessEntity", "pt_i_SubEntity" '
                                  ||'"pt_i_FileSetID" and "pt_i_Phase" are all mandatory in call to "'
                                  ||gct_PackageName
                                  ||'.'
                                  ||ct_ProcOrFuncName
                                  ||'".';
               --
               RAISE e_ModuleError;
               --
          ELSE
               --
               gvv_ProgressIndicator := '0020';
               --
               SELECT COUNT(1)
               INTO   vn_ExistenceCount
               FROM   xxmx_migration_details  xfmd
               WHERE  1 = 1
               AND    xfmd.business_entity  = pt_i_BusinessEntity
               AND    xfmd.sub_entity       = pt_i_SubEntity
               AND    xfmd.file_set_id      = pt_i_FileSetID;
               --
               IF   vn_ExistenceCount = 0
               THEN
                    --
                    gvt_ModuleMessage := 'Initial Migration Detail has not been registered for '
                                       ||'Business Entity "'
                                       ||pt_i_BusinessEntity
                                       ||'", Sub-Entity "'
                                       ||pt_i_SubEntity
                                       ||'" and File Set ID "'
                                       ||pt_i_FileSetID
                                       ||'".';
                    --
                    RAISE e_ModuleError;
                    --
               ELSE
                    --
                    gvv_ProgressIndicator := '0040';
                    --
                    IF   UPPER(pt_i_Phase) = 'EXTRACT'
                    THEN
                         --
                         --** If the Extract End Timestamp parameter IS NOT NULL
                         --** then the extract process has completed, so evaluate the
                         --** Error Flag parameter to determine the Migration Status
                         --** and Calculate the elapsed processing time.
                         --
                         IF   pt_i_ValidateEndTimestamp IS NOT NULL
                         THEN
                              --
                              IF   UPPER(NVL(pt_i_ErrorFlag, 'N')) = 'N'
                              THEN
                                   --
                                   vt_MigrationStatus := 'TRANSFORM_READY';
                                   --
                              ELSE
                                   --
                                   vt_MigrationStatus := 'VALIDATE_ERRORS';
                                   --
                              END IF;
                              --
                              --** Calculate Extract Elapsed Time
                              --
                              vn_ValidateHours   := NULL;
                              vn_ValidateMinutes := NULL;
                              vn_ValidateSeconds := NULL;
                              --
                              BEGIN
                                   --
                                   SELECT xmd.extract_start_timestamp
                                   INTO   vt_StartTimestamp
                                   FROM   xxmx_migration_details  xmd
                                   WHERE  1 = 1
                                   AND    xmd.business_entity  = pt_i_BusinessEntity
                                   AND    xmd.sub_entity       = pt_i_SubEntity
                                   AND    xmd.file_set_id      = pt_i_FileSetID;
                                   --
                                   EXCEPTION
                                        --
                                        WHEN OTHERS
                                        THEN
                                             --
                                             vt_StartTimestamp := NULL;
                                             --
                                        --** END OTHERS Exception
                                        --
                                   --** END Exception Handler
                                   --
                              END;
                              --
                              IF   vt_StartTimestamp IS NOT NULL
                              THEN
                                   --
                                   SELECT  EXTRACT(HOUR   FROM (pt_i_ValidateEndTimestamp - vt_StartTimestamp))
                                          ,EXTRACT(MINUTE FROM (pt_i_ValidateEndTimestamp - vt_StartTimestamp))
                                          ,EXTRACT(SECOND FROM (pt_i_ValidateEndTimestamp - vt_StartTimestamp))
                                   INTO    vn_ValidateHours
                                          ,vn_ValidateMinutes
                                          ,vn_ValidateSeconds
                                   FROM    dual;
                                   --
                              END IF; --** IF vt_StartTimestamp IS NOT NULL
                              --
                         END IF; --** IF pt_i_ExtractEndTimestamp IS NOT NULL
                         --
                    ELSIF UPPER(pt_i_Phase) = 'TRANSFORM'
                    THEN
                         --
                         --** If the Transform End Timestamp parameter IS NOT NULL
                         --** then the transform process has completed, so evaluate the
                         --** Error Flag parameter to determine the Migration Status
                         --** and Calculate the elapsed processing time.
                         --
                         IF   pt_i_TransformEndTimestamp IS NOT NULL
                         THEN
                              --
                              IF   UPPER(NVL(pt_i_ErrorFlag, 'N')) = 'N'
                              THEN
                                   --
                                   vt_MigrationStatus := 'EXPORT_READY';
                                   --
                              ELSE
                                   --
                                   vt_MigrationStatus := 'TRANSFORM_ERRORS';
                                   --
                              END IF;
                              --
                              --** Calculate Transform Elapsed Time
                              --
                              vn_TransformHours   := NULL;
                              vn_TransformMinutes := NULL;
                              vn_TransformSeconds := NULL;
                              --
                              BEGIN
                                   --
                                   SELECT xmd.transform_start_timestamp
                                   INTO   vt_StartTimestamp
                                   FROM   xxmx_migration_details  xmd
                                   WHERE  1 = 1
                                   AND    xmd.business_entity  = pt_i_BusinessEntity
                                   AND    xmd.sub_entity       = pt_i_SubEntity
                                   AND    xmd.file_set_id      = pt_i_FileSetID;
                                   --
                                   EXCEPTION
                                        --
                                        WHEN OTHERS
                                        THEN
                                             --
                                             vt_StartTimestamp := NULL;
                                             --
                                        --** END OTHERS Exception
                                        --
                                   --** END Exception Handler
                                   --
                              END;
                              --
                              IF   vt_StartTimestamp IS NOT NULL
                              THEN
                                   --
                                   SELECT  EXTRACT(HOUR   FROM (pt_i_TransformEndTimestamp - vt_StartTimestamp))
                                          ,EXTRACT(MINUTE FROM (pt_i_TransformEndTimestamp - vt_StartTimestamp))
                                          ,EXTRACT(SECOND FROM (pt_i_TransformEndTimestamp - vt_StartTimestamp))
                                   INTO    vn_TransformHours
                                          ,vn_TransformMinutes
                                          ,vn_TransformSeconds
                                   FROM    dual;
                                   --
                              END IF; --** IF vt_StartTimestamp IS NOT NULL
                              --
                         END IF; --** IF pt_i_ExtractEndTimestamp IS NOT NULL
                         --
                    ELSIF UPPER(pt_i_Phase) = 'EXPORT'
                    THEN
                         --
                         --** If the Export End Timestamp parameter IS NOT NULL
                         --** then the export process has completed, so evaluate the
                         --** Error Flag parameter to determine the Migration Status
                         --** and Calculate the elapsed processing time.
                         --
                         --** Calculate Export Elapsed Time
                         --
                         IF   pt_i_ExportEndTimestamp IS NOT NULL
                         THEN
                              --
                              IF   UPPER(NVL(pt_i_ErrorFlag, 'N')) = 'N'
                              THEN
                                   --
                                   vt_MigrationStatus := 'FUSION_IMPORT_READY';
                                   --
                              ELSE
                                   --
                                   vt_MigrationStatus := 'EXPORT_ERRORS';
                                   --
                              END IF;
                              --
                              --** Calculate Export Elapsed Time
                              --
                              vn_ExportHours   := NULL;
                              vn_ExportMinutes := NULL;
                              vn_ExportSeconds := NULL;
                              --
                              BEGIN
                                   --
                                   SELECT xmd.export_start_timestamp
                                   INTO   vt_StartTimestamp
                                   FROM   xxmx_migration_details  xmd
                                   WHERE  1 = 1
                                   AND    xmd.business_entity  = pt_i_BusinessEntity
                                   AND    xmd.sub_entity       = pt_i_SubEntity
                                   AND    xmd.file_set_id      = pt_i_FileSetID;
                                   --
                                   EXCEPTION
                                        --
                                        WHEN OTHERS
                                        THEN
                                             --
                                             vt_StartTimestamp := NULL;
                                             --
                                        --** END OTHERS Exception
                                        --
                                   --** END Exception Handler
                                   --
                              END;
                              --
                              IF   vt_StartTimestamp IS NOT NULL
                              THEN
                                   --
                                   SELECT  EXTRACT(HOUR   FROM (pt_i_ExportEndTimestamp - vt_StartTimestamp))
                                          ,EXTRACT(MINUTE FROM (pt_i_ExportEndTimestamp - vt_StartTimestamp))
                                          ,EXTRACT(SECOND FROM (pt_i_ExportEndTimestamp - vt_StartTimestamp))
                                   INTO    vn_ExportHours
                                          ,vn_ExportMinutes
                                          ,vn_ExportSeconds
                                   FROM    dual;
                                   --
                              END IF; --** IF vt_StartTimestamp IS NOT NULL
                              --
                         END IF; --** IF pt_i_ExtractEndTimestamp IS NOT NULL
                         --
                    ELSE
                         --
                         gvt_ModuleMessage := 'Phase Parameter must have a value of "EXTRACT", "TRANSFORM" or "EXPORT".';
                         --
                         RAISE e_ModuleError;
                         --
                    END IF;
                    --
                    --** Update record in migration details table
                    --
                    UPDATE xxmx_migration_details
                    SET    phase                         = UPPER(pt_i_Phase)
                          ,validate_end_timestamp        = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'EXTRACT' ,pt_i_ValidateEndTimestamp
                                                                                 ,validate_end_timestamp
                                                                 )
                          ,validate_hours                = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'EXTRACT' ,vn_ValidateHours
                                                                                 ,validate_hours
                                                                 )
                          ,validate_minutes              = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'EXTRACT' ,vn_ValidateMinutes
                                                                                 ,validate_minutes
                                                                 )
                          ,validate_seconds              = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'EXTRACT' ,vn_ValidateSeconds
                                                                                 ,validate_seconds
                                                                 )
                          ,validate_row_count            = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'EXTRACT' ,pt_i_ValidateRowCount
                                                                                 ,validate_row_count
                                                                 )
                          ,transform_start_timestamp     = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'TRANSFORM' ,pt_i_TransformStartTimestamp
                                                                                   ,transform_start_timestamp
                                                                 )
                          ,transform_end_timestamp       = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                       ,'TRANSFORM' ,pt_i_TransformEndTimestamp
                                                                                    ,transform_end_timestamp
                                                                 )
                          ,transform_hours               = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'TRANSFORM' ,vn_TransformHours
                                                                                   ,transform_hours
                                                                 )
                          ,transform_minutes             = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'TRANSFORM' ,vn_TransformMinutes
                                                                                   ,transform_minutes
                                                                 )
                          ,transform_seconds             = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'TRANSFORM' ,vn_TransformSeconds
                                                                                   ,transform_seconds
                                                                 )
                          ,export_file_name              = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                       ,'EXPORT' ,pt_i_ExportFileName
                                                                                 ,export_file_name
                                                                 )
                          ,export_start_timestamp        = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                       ,'EXPORT' ,pt_i_ExportStartTimestamp
                                                                                 ,export_start_timestamp
                                                                 )
                          ,export_end_timestamp          = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                       ,'EXPORT' ,pt_i_ExportEndTimestamp
                                                                                 ,export_end_timestamp
                                                                 )
                          ,export_hours                  = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'EXPORT' ,vn_ExportHours
                                                                                ,export_hours
                                                                 )
                          ,export_minutes                = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'EXPORT' ,vn_ExportMinutes
                                                                                ,export_minutes
                                                                 )
                          ,export_seconds                = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'EXPORT' ,vn_ExportSeconds
                                                                                ,export_seconds
                                                                 )
                          ,export_row_count              = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                       ,'EXPORT' ,pt_i_ExportRowCount
                                                                                 ,export_row_count
                                                                 )
                          ,migration_status              = vt_MigrationStatus
                          ,error_flag                    = UPPER(pt_i_ErrorFlag)
                    WHERE  1 = 1
                    AND    business_entity  = pt_i_BusinessEntity
                    AND    sub_entity       = pt_i_SubEntity
                    AND    file_set_id      = pt_i_FileSetID;
                    --
               END IF; --** IF vn_ExistenceCount = 0
               --
          END IF; --** If Required Parameters are NULL
          --
          COMMIT;
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    ROLLBACK;
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
                         ,pt_i_SubEntity         => pt_i_SubEntity       
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    COMMIT; --** Commit the message to the Module Messages table.
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
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => pt_i_ApplicationSuite
                         ,pt_i_Application       => pt_i_Application     
                         ,pt_i_BusinessEntity    => pt_i_BusinessEntity  
                         ,pt_i_SubEntity         => pt_i_SubEntity       
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gct_Phase
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
     END upd_file_migration_details;
     --
     --
     /*
     ***************************************************
     ** PROCEDURE: upd_ext_migration_details
     **
     ** Called from each Maximise Extract procedure when
     ** Client Data is being extracted from a Source
     ** Database via DB Link.
     ***************************************************
     */
     --
     PROCEDURE upd_ext_migration_details
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_details.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_details.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_details.business_entity%TYPE
                    ,pt_i_SubEntity                  IN      xxmx_migration_details.sub_entity%TYPE
                    ,pt_i_MigrationSetID             IN      xxmx_migration_details.migration_set_id%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_details.file_set_id%TYPE
                    ,pt_i_Phase                      IN      xxmx_migration_details.phase%TYPE
                    ,pt_i_ExtractEndTimestamp        IN      xxmx_migration_details.extract_end_timestamp%TYPE
                    ,pt_i_ExtractRowCount            IN      xxmx_migration_details.extract_row_count%TYPE
                    ,pt_i_TransformStartTimestamp    IN      xxmx_migration_details.transform_start_timestamp%TYPE
                    ,pt_i_TransformEndTimestamp      IN      xxmx_migration_details.transform_end_timestamp%TYPE
                    ,pt_i_ExportFileName             IN      xxmx_migration_details.export_file_name%TYPE
                    ,pt_i_ExportStartTimestamp       IN      xxmx_migration_details.export_start_timestamp%TYPE
                    ,pt_i_ExportEndTimestamp         IN      xxmx_migration_details.export_end_timestamp%TYPE
                    ,pt_i_ExportRowCount             IN      xxmx_migration_details.export_row_count%TYPE
                    ,pt_i_ErrorFlag                  IN      xxmx_migration_details.error_flag%TYPE
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'upd_ext_migration_details';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vn_ExistenceCount               NUMBER;
          vt_MigrationStatus              xxmx_migration_details.migration_status%TYPE;
          vt_StartTimestamp               xxmx_migration_details.extract_start_timestamp%TYPE;
          vt_ElapsedTime                  TIMESTAMP(3);
          vn_ExtractHours                 NUMBER(2);
          vn_ExtractMinutes               NUMBER(2);
          vn_ExtractSeconds               NUMBER(2);
          vn_TransformHours               NUMBER(2);
          vn_TransformMinutes             NUMBER(2);
          vn_TransformSeconds             NUMBER(2);
          vn_ExportHours                  NUMBER(2);
          vn_ExportMinutes                NUMBER(2);
          vn_ExportSeconds                NUMBER(2);
          --
          --*************************
          --** Exception Declarations
          --*************************
          --
          e_ModuleError                   EXCEPTION;
          e_DataError                     EXCEPTION;
          --
     --** END Declarations **
     --
     BEGIN
          --
          gvv_ProgressIndicator := '0010';
          --
          IF   pt_i_ApplicationSuite IS NULL
          OR   pt_i_Application      IS NULL
          OR   pt_i_BusinessEntity   IS NULL
          OR   pt_i_SubEntity        IS NULL
          OR   pt_i_Phase            IS NULL
          THEN
               --
               gvt_ModuleMessage := '"pt_i_ApplicationSuite", "pt_i_Application", "pt_i_BusinessEntity", "pt_i_SubEntity" '
                                  ||'"pt_i_MigrationSetID" and "pt_i_Phase" are all mandatory in call to "'
                                  ||gct_PackageName
                                  ||'.'
                                  ||ct_ProcOrFuncName
                                  ||'".';
               --
               RAISE e_ModuleError;
               --
          ELSE
               --
               gvv_ProgressIndicator := '0020';
               --
               SELECT COUNT(1)
               INTO   vn_ExistenceCount
               FROM   xxmx_migration_details  xfmd
               WHERE  1 = 1
               AND    xfmd.business_entity  = pt_i_BusinessEntity
               AND    xfmd.sub_entity       = pt_i_SubEntity
               AND(    xfmd.migration_set_id = pt_i_MigrationSetID
               OR  xfmd.file_set_id= pt_i_FileSetID);
               --
               IF   vn_ExistenceCount = 0
               THEN
                    --
                    gvt_ModuleMessage := 'Initial Migration Detail has not been registered for '
                                       ||'Business Entity "'
                                       ||pt_i_BusinessEntity
                                       ||'", Sub-Entity "'
                                       ||pt_i_SubEntity
                                       ||'" and Migration Set ID "'
                                       ||pt_i_MigrationSetID
                                       ||'".'
                                       ||'" and File Set ID "'
                                       ||pt_i_FileSetID
                                       ;
                    --
                   -- RAISE e_DataError;
                    --
               ELSE
                    --
                    gvv_ProgressIndicator := '0040';
                    --
                    IF   UPPER(pt_i_Phase) = 'EXTRACT'
                    THEN
                         --
                         --** If the Extract End Timestamp parameter IS NOT NULL
                         --** then the extract process has completed, so evaluate the
                         --** Error Flag parameter to determine the Migration Status
                         --** and Calculate the elapsed processing time.
                         --
                         IF   pt_i_ExtractEndTimestamp IS NOT NULL
                         THEN
                              --
                              IF   UPPER(NVL(pt_i_ErrorFlag, 'N')) = 'N'
                              THEN
                                   --
                                   vt_MigrationStatus := 'TRANSFORM_READY';
                                   --
                              ELSE
                                   --
                                   vt_MigrationStatus := 'EXTRACT_ERRORS';
                                   --
                              END IF;
                              --
                              --** Calculate Extract Elapsed Time
                              --
                              vn_ExtractHours   := NULL;
                              vn_ExtractMinutes := NULL;
                              vn_ExtractSeconds := NULL;
                              --
                              BEGIN
                                   --
                                   SELECT xmd.extract_start_timestamp
                                   INTO   vt_StartTimestamp
                                   FROM   xxmx_migration_details  xmd
                                   WHERE  1 = 1
                                   AND    xmd.business_entity  = pt_i_BusinessEntity
                                   AND    xmd.sub_entity       = pt_i_SubEntity
                                   AND    xmd.migration_set_id = pt_i_MigrationSetID;
                                   --
                                   EXCEPTION
                                        --
                                        WHEN OTHERS
                                        THEN
                                             --
                                             vt_StartTimestamp := NULL;
                                             --
                                        --** END OTHERS Exception
                                        --
                                   --** END Exception Handler
                                   --
                              END;
                              --
                              IF   vt_StartTimestamp IS NOT NULL
                              THEN
                                   --
                                   SELECT  EXTRACT(HOUR   FROM (pt_i_ExtractEndTimestamp - vt_StartTimestamp))
                                          ,EXTRACT(MINUTE FROM (pt_i_ExtractEndTimestamp - vt_StartTimestamp))
                                          ,EXTRACT(SECOND FROM (pt_i_ExtractEndTimestamp - vt_StartTimestamp))
                                   INTO    vn_ExtractHours
                                          ,vn_ExtractMinutes
                                          ,vn_ExtractSeconds
                                   FROM    dual;
                                   --
                              END IF; --** IF vt_StartTimestamp IS NOT NULL
                              --
                         END IF; --** IF pt_i_ExtractEndTimestamp IS NOT NULL
                         --
                    ELSIF UPPER(pt_i_Phase) = 'TRANSFORM'
                    THEN
                         --
                         --** If the Transform End Timestamp parameter IS NOT NULL
                         --** then the transform process has completed, so evaluate the
                         --** Error Flag parameter to determine the Migration Status
                         --** and Calculate the elapsed processing time.
                         --
                         IF   pt_i_TransformEndTimestamp IS NOT NULL
                         THEN
                              --
                              IF   UPPER(NVL(pt_i_ErrorFlag, 'N')) = 'N'
                              THEN
                                   --
                                   vt_MigrationStatus := 'EXPORT_READY';
                                   --
                              ELSE
                                   --
                                   vt_MigrationStatus := 'TRANSFORM_ERRORS';
                                   --
                              END IF;
                              --
                              --** Calculate Transform Elapsed Time
                              --
                              vn_TransformHours   := NULL;
                              vn_TransformMinutes := NULL;
                              vn_TransformSeconds := NULL;
                              --
                              BEGIN
                                   --
                                   SELECT xmd.transform_start_timestamp
                                   INTO   vt_StartTimestamp
                                   FROM   xxmx_migration_details  xmd
                                   WHERE  1 = 1
                                   AND    xmd.business_entity  = pt_i_BusinessEntity
                                   AND    xmd.sub_entity       = pt_i_SubEntity
                                   AND    xmd.migration_set_id = pt_i_MigrationSetID;
                                   --
                                   EXCEPTION
                                        --
                                        WHEN OTHERS
                                        THEN
                                             --
                                             vt_StartTimestamp := NULL;
                                             --
                                        --** END OTHERS Exception
                                        --
                                   --** END Exception Handler
                                   --
                              END;
                              --
                              IF   vt_StartTimestamp IS NOT NULL
                              THEN
                                   --
                                   SELECT  EXTRACT(HOUR   FROM (pt_i_TransformEndTimestamp - vt_StartTimestamp))
                                          ,EXTRACT(MINUTE FROM (pt_i_TransformEndTimestamp - vt_StartTimestamp))
                                          ,EXTRACT(SECOND FROM (pt_i_TransformEndTimestamp - vt_StartTimestamp))
                                   INTO    vn_TransformHours
                                          ,vn_TransformMinutes
                                          ,vn_TransformSeconds
                                   FROM    dual;
                                   --
                              END IF; --** IF vt_StartTimestamp IS NOT NULL
                              --
                         END IF; --** IF pt_i_ExtractEndTimestamp IS NOT NULL
                         --
                    ELSIF UPPER(pt_i_Phase) = 'EXPORT'
                    THEN
                         --
                         --** If the Export End Timestamp parameter IS NOT NULL
                         --** then the export process has completed, so evaluate the
                         --** Error Flag parameter to determine the Migration Status
                         --** and Calculate the elapsed processing time.
                         --
                         --** Calculate Export Elapsed Time
                         --
                         IF   pt_i_ExportEndTimestamp IS NOT NULL
                         THEN
                              --
                              IF   UPPER(NVL(pt_i_ErrorFlag, 'N')) = 'N'
                              THEN
                                   --
                                   vt_MigrationStatus := 'FUSION_IMPORT_READY';
                                   --
                              ELSE
                                   --
                                   vt_MigrationStatus := 'EXPORT_ERRORS';
                                   --
                              END IF;
                              --
                              --** Calculate Export Elapsed Time
                              --
                              vn_ExportHours   := NULL;
                              vn_ExportMinutes := NULL;
                              vn_ExportSeconds := NULL;
                              --
                              BEGIN
                                   --
                                   SELECT xmd.export_start_timestamp
                                   INTO   vt_StartTimestamp
                                   FROM   xxmx_migration_details  xmd
                                   WHERE  1 = 1
                                   AND    xmd.business_entity  = pt_i_BusinessEntity
                                   AND    xmd.sub_entity       = pt_i_SubEntity
                                   AND    xmd.migration_set_id = pt_i_MigrationSetID;
                                   --
                                   EXCEPTION
                                        --
                                        WHEN OTHERS
                                        THEN
                                             --
                                             vt_StartTimestamp := NULL;
                                             --
                                        --** END OTHERS Exception
                                        --
                                   --** END Exception Handler
                                   --
                              END;
                              --
                              IF   vt_StartTimestamp IS NOT NULL
                              THEN
                                   --
                                   SELECT  EXTRACT(HOUR   FROM (pt_i_ExportEndTimestamp - vt_StartTimestamp))
                                          ,EXTRACT(MINUTE FROM (pt_i_ExportEndTimestamp - vt_StartTimestamp))
                                          ,EXTRACT(SECOND FROM (pt_i_ExportEndTimestamp - vt_StartTimestamp))
                                   INTO    vn_ExportHours
                                          ,vn_ExportMinutes
                                          ,vn_ExportSeconds
                                   FROM    dual;
                                   --
                              END IF; --** IF vt_StartTimestamp IS NOT NULL
                              --
                         END IF; --** IF pt_i_ExtractEndTimestamp IS NOT NULL
                         --
                    ELSE
                         --
                         gvt_ModuleMessage := 'Phase Parameter must have a value of "EXTRACT", "TRANSFORM" or "EXPORT".';
                         --
                         RAISE e_ModuleError;
                         --
                    END IF;
                    --
                    --** Update record in migration details table
                    --
                    UPDATE xxmx_migration_details
                    SET    phase                         = UPPER(pt_i_Phase)
                          ,extract_end_timestamp         = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'EXTRACT' ,pt_i_ExtractEndTimestamp
                                                                                 ,extract_end_timestamp
                                                                 )
                          ,extract_hours                 = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'EXTRACT' ,vn_ExtractHours
                                                                                 ,extract_hours
                                                                 )
                          ,extract_minutes               = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'EXTRACT' ,vn_ExtractMinutes
                                                                                 ,extract_minutes
                                                                 )
                          ,extract_seconds               = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'EXTRACT' ,vn_ExtractSeconds
                                                                                 ,extract_seconds
                                                                 )
                          ,extract_row_count             = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'EXTRACT' ,pt_i_ExtractRowCount
                                                                                 ,extract_row_count
                                                                 )
                          ,transform_start_timestamp     = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'TRANSFORM' ,pt_i_TransformStartTimestamp
                                                                                   ,transform_start_timestamp
                                                                 )
                          ,transform_end_timestamp       = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                       ,'TRANSFORM' ,pt_i_TransformEndTimestamp
                                                                                    ,transform_end_timestamp
                                                                 )
                          ,transform_hours               = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'TRANSFORM' ,vn_TransformHours
                                                                                   ,transform_hours
                                                                 )
                          ,transform_minutes             = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'TRANSFORM' ,vn_TransformMinutes
                                                                                   ,transform_minutes
                                                                 )
                          ,transform_seconds             = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'TRANSFORM' ,vn_TransformSeconds
                                                                                   ,transform_seconds
                                                                 )
                          ,export_file_name              = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                       ,'EXPORT' ,pt_i_ExportFileName
                                                                                 ,export_file_name
                                                                 )
                          ,export_start_timestamp        = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                       ,'EXPORT' ,pt_i_ExportStartTimestamp
                                                                                 ,export_start_timestamp
                                                                 )
                          ,export_end_timestamp          = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                       ,'EXPORT' ,pt_i_ExportEndTimestamp
                                                                                 ,export_end_timestamp
                                                                 )
                          ,export_hours                  = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'EXPORT' ,vn_ExportHours
                                                                                ,export_hours
                                                                 )
                          ,export_minutes                = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'EXPORT' ,vn_ExportMinutes
                                                                                ,export_minutes
                                                                 )
                          ,export_seconds                = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                      ,'EXPORT' ,vn_ExportSeconds
                                                                                ,export_seconds
                                                                 )
                          ,export_row_count              = DECODE(
                                                                  UPPER(pt_i_Phase)
                                                                       ,'EXPORT' ,pt_i_ExportRowCount
                                                                                 ,export_row_count
                                                                 )
                          ,migration_status              = vt_MigrationStatus
                          ,error_flag                    = UPPER(pt_i_ErrorFlag)
                    WHERE  1 = 1
                    AND    migration_set_id = pt_i_MigrationSetID
                    AND    business_entity  = UPPER(pt_i_BusinessEntity)
                    AND    sub_entity       = UPPER(pt_i_SubEntity);
                    --
               END IF; --** IF vn_ExistenceCount = 0
               --
          END IF; --** If Required Parameters are NULL
          --
          COMMIT;
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    ROLLBACK;
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    COMMIT; --** Commit the message to the Module Messages table.
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
                --
               WHEN e_DataError
               THEN
                    --
                    --ROLLBACK;
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    COMMIT; --** Commit the message to the Module Messages table.
                    --
                    gvv_ApplicationErrorMessage := SUBSTR('"e_DataError" Exception raised after Progress Indicator "'
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
                                             ,1
                                             ,4000
                                             );
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => pt_i_MigrationSetID
                         ,pt_i_Phase             => gct_Phase
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
     END upd_ext_migration_details;
     --
     --
     /*
     ************************************
     ** PROCEDURE: get_entity_application
     ************************************
     */
     --
     PROCEDURE get_entity_application
                    (
                     pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_o_ApplicationSuite              OUT  xxmx_migration_metadata.application_suite%TYPE
                    ,pt_o_Application                   OUT  xxmx_migration_metadata.application%TYPE
                    ,pv_o_ReturnStatus                  OUT  VARCHAR2
                    ,pt_o_ReturnMessage                 OUT  xxmx_data_messages.data_message%TYPE
                    )
     IS
          --
          --**********************
          --** Cursor Declarations
          --**********************
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'get_entity_application';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_BusinessEntity               xxmx_migration_metadata.business_entity%TYPE;
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
          gvv_ProgressIndicator := '0010';
          --
          pv_o_ReturnStatus  := 'S';
          pt_o_ReturnMessage := ''; 
          --
          IF   pt_i_BusinessEntity IS NULL
          THEN
               --
               pt_o_ReturnMessage := '"pt_i_BusinessEntity" Parameter is mandatory in calls to "'
                                   ||gct_PackageName
                                   ||'.'
                                   ||ct_ProcOrFuncName
                                   ||'".';
               --
               RAISE e_ModuleError;
               --
          ELSE
               --
               vt_BusinessEntity := UPPER(pt_i_BusinessEntity);
               --
          END IF; --** IF pt_i_BusinessEntity OR pt_i_SubEntity IS NULL
          --
          verify_lookup_code
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
               pt_o_ReturnMessage := gvt_ReturnMessage;
               --
               RAISE e_ModuleError;
               --
          END IF; --** IF gvv_ReturnStatus <> 'S'
          --
          SELECT  DISTINCT
                  UPPER(xmd.application_suite)
                 ,UPPER(xmd.application)
          INTO    pt_o_ApplicationSuite
                 ,pt_o_Application
          FROM    xxmx_migration_metadata  xmd
          WHERE   1 = 1
          AND     xmd.business_entity = pt_i_BusinessEntity;
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    NULL;
                    --
               --**END e_ModuleError
               --
               WHEN NO_DATA_FOUND
               THEN
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    pt_o_ReturnMessage := 'Business Entity "'
                                        ||pt_i_BusinessEntity
                                        ||'" not found in the XXMX_MIGRATION_METADATA table.';
                    --
               --** END NO_DATA_FOUND Exception
               --
               WHEN TOO_MANY_ROWS
               THEN
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    pt_o_ReturnMessage := 'Business Entity "'
                                        ||pt_i_BusinessEntity
                                        ||'" is associated with more than one Application in the XXMX_MIGRATION_METADATA table.';
                    --
               --** END TOO_MANY_ROWS Exception
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
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Oracle error encountered after Progress Indicator.'
                         ,pt_i_OracleError       => gvt_OracleError
                         );
                    --
                    pv_o_ReturnStatus := 'F';
                    --
                    pt_o_ReturnMessage := 'Oracle error encountered in call to "'
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||'".  Please refer to the Module Messages table for more details.';
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END get_entity_application;
     --
     --
       /*
     *****************************************************************************************
     ** PROCEDURE: valid_business_entity_setup
     **
     ** This function verifies that required metadata has been setup for a single Business
     ** Entity.
     **
     ** Business Entity Level checks are:
     **
     ** 1) XXMX_MIGRATION_METADATA table is populated.  If this isn't populated then no
     **    further verifications can be performed.
     **
     ** Sub-Entity Level checks are:
     **
     ** 2) At least one STG table is defined in the Data Dictionary.
     ** 3) At least one XFM table is defined in the Data Dictionary.
     ** 4) Identifies any STG tables which are not linked to an XFM table.
     ** 5) For those STG tables which are linked to an XFM table, identifies any Client Data
     **    Columns which are not mapped between the two.
     **
     ** File Group Level checks are:
     **
     ** 6) 
     **
     ** This procedure is called from STG_MAIN and or XFM_MAIN.
     *****************************************************************************************
     */
     --
     FUNCTION valid_business_entity_setup
                    (
                     pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE DEFAULT NULL
                    )
     RETURN BOOLEAN
     IS
          --
          --
          --**********************
          --** Cursor Declarations
          --**********************
          --
          CURSOR Metadata_cur
                      (
                       pt_BusinessEntity             xxmx_migration_metadata.business_entity%TYPE
                      )
          IS
               --
               SELECT    xmd.metadata_id
                        ,xmd.application_suite
                        ,xmd.application
                        ,xmd.business_entity
                        ,xmd.sub_entity
                        ,xmd.file_group_number
               FROM      xxmx_migration_metadata  xmd
               WHERE     1 = 1
               AND       xmd.business_entity = NVL(pt_BusinessEntity, xmd.business_entity)
               AND       STG_TABLE IS NOT NULL
               ORDER BY  xmd.business_entity_seq
                        ,xmd.sub_entity_seq;
               --
          --** END CURSOR Metadata_cur;
          --
          CURSOR UnmappedTables_cur
                      (
                       pt_MetadataID                   xxmx_stg_tables.metadata_id%TYPE
                      )
          IS
               --
               SELECT   stg_table_id
                       ,schema_name
                       ,table_name
               FROM     xxmx_stg_tables   xst
               WHERE    1 = 1
               AND      xst.metadata_id          = pt_MetadataID
               AND      NVL(xst.xfm_table_id, 0) = 0
               ORDER BY xst.table_name;
               --
          --** END CURSOR UnmappedTables_cur;
          --
          CURSOR TablePairs_cur
                      (
                       pt_MetadataID                   xxmx_stg_tables.metadata_id%TYPE
                      )
          IS
               --
               SELECT    xst.stg_table_id
                        ,LOWER(xst.schema_name)                         AS stg_schema_name
                        ,LOWER(xst.table_name)                          AS stg_table_name
                        ,xxt.xfm_table_id
                        ,LOWER(xxt.schema_name)                         AS xfm_schema_name
                        ,LOWER(xxt.table_name)                          AS xfm_table_name
               FROM      xxmx_stg_tables          xst
                        ,xxmx_xfm_tables          xxt
               WHERE     1 = 1
               AND       xst.metadata_id     = pt_MetadataID
               AND       xxt.xfm_table_id    = xst.xfm_table_id;
               --
          --** END CURSOR TablePairs_cur;
          --
          CURSOR UnmappedColumns_cur
                      (
                       pt_StgTableID                   xxmx_stg_table_columns.stg_table_id%TYPE
                      )
          IS
               --
               SELECT   xstc.column_name
               FROM     xxmx_stg_table_columns   xstc
               WHERE    1 = 1
               AND      xstc.stg_table_id                = pt_StgTableID
               AND      NVL(xstc.xfm_table_column_id, 0) = 0
               ORDER BY xstc.stg_column_seq;
               --
          --** END CURSOR UnmappedColumns_cur;
          --
          CURSOR FileGroups_cur
                      (
                       pt_BusinessEntity             xxmx_migration_metadata.business_entity%TYPE
                      )
          IS
               --
               SELECT    xmd.application_suite
                        ,xmd.application
                        ,xmd.business_entity
                        ,xmd.file_group_number
               FROM      xxmx_migration_metadata  xmd
               WHERE     1 = 1
               AND       xmd.business_entity = pt_BusinessEntity
               AND       file_group_number IS NOT NULL
               ORDER BY  xmd.file_group_number;
               --
          --** END CURSOR FileGroups_cur;
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'verify_business_entity_setup';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vb_ReturnStatus                 BOOLEAN;
          vt_BusinessEntity               xxmx_migration_metadata.business_entity%TYPE;
          vb_MetadataPopulated            BOOLEAN;
          vt_ParameterCode                xxmx_core_parameters.parameter_code%TYPE;
          vt_ParameterValue               xxmx_core_parameters.parameter_value%TYPE;
          vb_DataTablesExist              BOOLEAN;
          vt_StgTableID                   xxmx_stg_tables.stg_table_id%TYPE;
          vt_StgSchemaName                xxmx_stg_tables.schema_name%TYPE;
          vt_StgTableName                 xxmx_stg_tables.table_name%TYPE;
          vt_XfmTableID                   xxmx_xfm_tables.xfm_table_id%TYPE;
          vt_XfmSchemaName                xxmx_xfm_tables.schema_name%TYPE;
          vt_XfmTableName                 xxmx_xfm_tables.table_name%TYPE;
          vn_MissingMappingCount          NUMBER;
          vv_UnmappedColumnNames          VARCHAR2(2000);
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
          vb_ReturnStatus := TRUE;
          --
          gvv_ProgressIndicator := '0010';
          --
          /*
          ** The XXMX_MIGRATION_METADATA table must be populated before any processing can
          ** be performed for a Business Entity/Sub-Entity combination.
          **
          ** This procedure can not be called for Sub-Entity only.
          **
          ** If both pt_i_BusinessEntity and pt_i_SubEntity are both passed as NULL
          ** then this procedure will attempt to verify that the Data Dictionary tables
          ** have been populated for all Business Entity/Sub-Entity combinations in the
          ** XXMX_MIGRATION_METADATA table.
          **
          ** If pt_i_BusinessEntity IS NOT NULL then this procedure will attempt to verify
          ** that the Data Dictionary tables have been populated for all Sub-Entities
          ** associated with the Business Entity.
          */
          --
          IF   pt_i_BusinessEntity IS NULL
          THEN
               --
               gvt_ModuleMessage := 'Parameter "pt_i_BusinessEntity" is mandatory in call to "'
                                  ||gct_PackageName
                                  ||'.'
                                  ||ct_ProcOrFuncName;
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          vt_BusinessEntity := UPPER(pt_i_BusinessEntity);
          --
          /*
          ** Verify that the value in pt_i_BusinessEntity is valid.
          */
          --
          gvv_ProgressIndicator := '0020';
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
               gvt_ModuleMessage := gvt_ReturnMessage;
               --
               RAISE e_ModuleError;
               --
          END IF;
          --
          log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => gct_SubEntity
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => 'PROCEDURE : '
                                        ||gct_PackageName
                                        ||'.'
                                        ||ct_ProcOrFuncName
                                        ||' initiated.'
               ,pt_i_OracleError       => NULL
               );
          --
          /*
          ** Verify if the XXMX_MIGRATON_METADATA table has been populated.
          **
          ** This is one of the main driving tables for the migration process
          ** so if a Business entity is missing from this table a migration
          ** can not be run for it.
          */
          --
          log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => gct_SubEntity
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => '- Verifying Business Entity "'
                                        ||vt_BusinessEntity
                                        ||'" in Migration Metadata table.'
               ,pt_i_OracleError       => NULL
               );
          --
          gvn_ExistenceCheckCount := NULL;
          vb_MetadataPopulated    := TRUE;
          --
          gvv_ProgressIndicator := '0050';
          --
          SELECT  COUNT(*)
          INTO    gvn_ExistenceCheckCount
          FROM    xxmx_migration_metadata xmd
          WHERE   1 = 1
          AND     xmd.business_entity = vt_BusinessEntity;
          --
          IF   gvn_ExistenceCheckCount = 0
          THEN
               --
               vb_MetadataPopulated := FALSE;
               --
               gvt_ModuleMessage := '  - INVALID: Table "xxmx_migration_metadata" is NOT populated for this Business Entity.';
               --
               RAISE e_ModuleError;
               --
          ELSE
               --
               gvt_ModuleMessage := '  - VALID: Table "xxmx_migration_metadata" is populated for this Business Entity.';
               --
          END IF; --** IF gvn_ExistenceCheckCount = 0
          --
          /*
          ** Get Business Entity Application
          */
          --
          get_entity_application
                    (
                     pt_i_BusinessEntity   => vt_BusinessEntity
                    ,pt_o_ApplicationSuite => gvt_BEApplicationSuite
                    ,pt_o_Application      => gvt_BEApplication
                    ,pv_o_ReturnStatus     => gvv_ReturnStatus
                    ,pt_o_ReturnMessage    => gvt_ReturnMessage
                    );
          --
          IF   gvv_ReturnStatus <> 'S'
          THEN
               --
               gvt_ModuleMessage := gvt_ReturnMessage;
               --
               RAISE e_ModuleError;
               --
          END IF; --** IF gvv_ReturnStatus <> 'S'
          --
          log_module_message
               (
                pt_i_ApplicationSuite  => gct_ApplicationSuite
               ,pt_i_Application       => gct_Application
               ,pt_i_BusinessEntity    => gct_BusinessEntity
               ,pt_i_SubEntity         => gct_SubEntity
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => gct_PackageName
               ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
               ,pt_i_ProgressIndicator => gvv_ProgressIndicator
               ,pt_i_ModuleMessage     => gvt_ModuleMessage
               ,pt_i_OracleError       => NULL
               );
          --
          IF  vb_MetadataPopulated
          THEN
               --
               log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => gct_SubEntity
                    ,pt_i_FileSetID         => 0
                    ,pt_i_MigrationSetID    => 0
                    ,pt_i_Phase             => gct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Verifying Sub-Entity specific Metadata setup.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               /*
               ** LOOP through the XXMX_MIGRATION_METADATA table for all Sub-entities
               ** within the Business Entity to verify:
               **
               ** 1) An STG table is defined in the Data Dictionary.
               ** 2) One or more XFM tables are defined in the Data Dictionary.
               ** 3) STG Table Columns are fully mapped to XFM Table Columns.
               */
               --
               gvv_ProgressIndicator := '0100';
               --
               FOR   Metadata_rec
               IN    Metadata_cur
                          (
                           pt_i_BusinessEntity
                          )
               LOOP
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - Verifying Metadata setup for Sub-Entity "'
                                                  ||Metadata_rec.sub_entity
                                                  ||'".'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '      - Verifying Data Dictionary entries.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
                    /*
                    ** Verify that STG and XFM tables have been defined in the Data Dictionary.
                    */
                    --
                    gvv_ProgressIndicator := '0110';
                    --
                    vb_DataTablesExist      := TRUE;
                    gvn_ExistenceCheckCount := NULL;
                    --
                    SELECT COUNT(*)
                    INTO   gvn_ExistenceCheckCount
                    FROM   xxmx_stg_tables
                    WHERE  1 = 1
                    AND    metadata_id = Metadata_rec.metadata_id;
                    --
                    IF   gvn_ExistenceCheckCount = 0
                    THEN
                         --
                         --vb_ReturnStatus    := FALSE;  commented by Pallavi
                         vb_DataTablesExist := FALSE;
                         --
                         log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => gct_SubEntity
                              ,pt_i_FileSetID         => 0
                              ,pt_i_MigrationSetID    => 0
                              ,pt_i_Phase             => gct_Phase
                              ,pt_i_Severity          => 'ERROR'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '        - INVALID : There are no STG tables defined in "xxmx_stg_tables" '
                                                       ||'for this Business Entity and Sub-entity or they are not linked '
                                                       ||'to "xxmx_migration_metadata" by "metadata_id".'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                    END IF;
                    --
                    gvv_ProgressIndicator := '0120';
                    --
                    SELECT COUNT(*)
                    INTO   gvn_ExistenceCheckCount
                    FROM   xxmx_xfm_tables
                    WHERE  1 = 1
                    AND    metadata_id = Metadata_rec.metadata_id;
                    --
                    IF   gvn_ExistenceCheckCount = 0
                    THEN
                         --
                         --vb_ReturnStatus    := FALSE;  commented by Pallavi
                         vb_DataTablesExist := FALSE;
                         --
                         log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => gct_SubEntity
                              ,pt_i_FileSetID         => 0
                              ,pt_i_MigrationSetID    => 0
                              ,pt_i_Phase             => gct_Phase
                              ,pt_i_Severity          => 'ERROR'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '        - INVALID : There are no XFM tables defined in "xxmx_xfm_tables" '
                                                       ||'for this Business Entity and Sub-entity or they are not linked '
                                                       ||'to "xxmx_migration_metadata" by "metadata_id".'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                    END IF;
                    --
                    IF   vb_DataTablesExist
                    THEN
                         --
                         /*
                         ** Data Tables exist in the Data Dictionary and are linked to to the Business
                         ** Entity / Sub-Entity Metadata table but all STG tables may not have been mapped
                         ** to an XFM table.
                         **
                         ** Some Business Entity Migrations may require additional XFM tables which may be
                         ** used to store Header/Footer records generated from the main Client Data XFM table
                         ** and in such cases the additional XFM tables may not link back to an STG table which
                         ** is perfectly feasible.
                         **
                         ** However, all STG tables must link to a single XFM table.
                         */
                         --
                         FOR UnmappedTable_rec
                         IN  UnmappedTables_cur
                                  (
                                   Metadata_rec.metadata_id
                                  )
                         LOOP
                              --
                              --vb_ReturnStatus    := FALSE;  commented by Pallavi
                              --
                              log_module_message
                                   (
                                    pt_i_ApplicationSuite  => gct_ApplicationSuite
                                   ,pt_i_Application       => gct_Application
                                   ,pt_i_BusinessEntity    => gct_BusinessEntity
                                   ,pt_i_SubEntity         => gct_SubEntity
                                   ,pt_i_FileSetID         => 0
                                   ,pt_i_MigrationSetID    => 0
                                   ,pt_i_Phase             => gct_Phase
                                   ,pt_i_Severity          => 'NOTIFICATION'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '        - INVALID : STG table "'
                                                            ||UnmappedTable_rec.schema_name
                                                            ||'.'
                                                            ||UnmappedTable_rec.table_name
                                                            ||' is not mapped to an XFM Table.'
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                         END LOOP; --** UnmappedTables_cur LOOP
                         --
                         /*
                         ** Verify that all STG tables which are mapped to an XFM table (a table pair) have
                         ** had all Client Data columns mapped to their respective XFM table columns.
                         */
                         --
                         gvv_ProgressIndicator := '0130';
                         --
                         FOR TablePair_rec
                         IN  TablePairs_cur
                                  (
                                   Metadata_rec.metadata_id
                                  )
                         LOOP
                              --
                              log_module_message
                                   (
                                    pt_i_ApplicationSuite  => gct_ApplicationSuite
                                   ,pt_i_Application       => gct_Application
                                   ,pt_i_BusinessEntity    => gct_BusinessEntity
                                   ,pt_i_SubEntity         => gct_SubEntity
                                   ,pt_i_FileSetID         => 0
                                   ,pt_i_MigrationSetID    => 0
                                   ,pt_i_Phase             => gct_Phase
                                   ,pt_i_Severity          => 'NOTIFICATION'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '        - Verifying paired STG/XFM tables:'
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                              log_module_message
                                   (
                                    pt_i_ApplicationSuite  => gct_ApplicationSuite
                                   ,pt_i_Application       => gct_Application
                                   ,pt_i_BusinessEntity    => gct_BusinessEntity
                                   ,pt_i_SubEntity         => gct_SubEntity
                                   ,pt_i_FileSetID         => 0
                                   ,pt_i_MigrationSetID    => 0
                                   ,pt_i_Phase             => gct_Phase
                                   ,pt_i_Severity          => 'NOTIFICATION'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '          - Table Pair : '
                                                            ||TablePair_rec.stg_schema_name
                                                            ||'.'
                                                            ||TablePair_rec.stg_table_name
                                                            ||' / '
                                                            ||TablePair_rec.xfm_schema_name
                                                            ||'.'
                                                            ||TablePair_rec.xfm_table_name
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                              log_module_message
                                   (
                                    pt_i_ApplicationSuite  => gct_ApplicationSuite
                                   ,pt_i_Application       => gct_Application
                                   ,pt_i_BusinessEntity    => gct_BusinessEntity
                                   ,pt_i_SubEntity         => gct_SubEntity
                                   ,pt_i_FileSetID         => 0
                                   ,pt_i_MigrationSetID    => 0
                                   ,pt_i_Phase             => gct_Phase
                                   ,pt_i_Severity          => 'NOTIFICATION'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '            - Verifying Client Data Column mapping integrity:'
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                              gvv_ProgressIndicator := '0140';
                              --
                              SELECT COUNT(1)
                              INTO   vn_MissingMappingCount
                              FROM   xxmx_stg_table_columns   xstc
                              WHERE  1 = 1
                              AND    xstc.stg_table_id                = vt_StgTableID
                              AND    NVL(xstc.xfm_table_column_id, 0) = 0;
                              --
                              IF   vn_MissingMappingCount > 0
                              THEN
                                   --
                                   --vb_ReturnStatus    := FALSE;  commented by Pallavi
                                   --
                                   log_module_message
                                        (
                                         pt_i_ApplicationSuite  => gct_ApplicationSuite
                                        ,pt_i_Application       => gct_Application
                                        ,pt_i_BusinessEntity    => gct_BusinessEntity
                                        ,pt_i_SubEntity         => gct_SubEntity
                                        ,pt_i_FileSetID         => 0
                                        ,pt_i_MigrationSetID    => 0
                                        ,pt_i_Phase             => gct_Phase
                                        ,pt_i_Severity          => 'ERROR'
                                        ,pt_i_PackageName       => gct_PackageName
                                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage     => '              - INVALID: '
                                                                 ||vn_MissingMappingCount
                                                                 ||' Client Data Column/s in the "'
                                                                 ||TablePair_rec.stg_schema_name
                                                                 ||'.'
                                                                 ||TablePair_rec.stg_table_name
                                                                 ||'" table is/are not mapped to a column in the "'
                                                                 ||TablePair_rec.xfm_schema_name
                                                                 ||'.'
                                                                 ||TablePair_rec.xfm_table_name
                                                                 ||'" table.  Data can not be transferred / transformed.'
                                        ,pt_i_OracleError       => NULL
                                   );
                                   --
                                   /*
                                   ** If there are 50 or less missing column mappings
                                   ** the list the STG table column names.
                                   */
                                   --
                                   IF   vn_MissingMappingCount <= 50
                                   THEN
                                        --
                                        gvv_ProgressIndicator := '0150';
                                        --
                                        vv_UnmappedColumnNames := '';
                                        --
                                        FOR   UnmappedColumn_rec
                                        IN    UnmappedColumns_cur
                                                   (
                                                    vt_StgTableID
                                                   )
                                        LOOP
                                             --
                                             vv_UnmappedColumnNames := vv_UnmappedColumnNames
                                                                     ||UnmappedColumn_rec.column_name
                                                                     ||', ';
                                             --
                                        END LOOP;
                                        --
                                        vv_UnmappedColumnNames := RTRIM(vv_UnmappedColumnNames, ', ');
                                        --
                                        log_module_message
                                             (
                                              pt_i_ApplicationSuite  => gct_ApplicationSuite
                                             ,pt_i_Application       => gct_Application
                                             ,pt_i_BusinessEntity    => gct_BusinessEntity
                                             ,pt_i_SubEntity         => gct_SubEntity
                                             ,pt_i_FileSetID         => 0
                                             ,pt_i_MigrationSetID    => 0
                                             ,pt_i_Phase             => gct_Phase
                                             ,pt_i_Severity          => 'ERROR'
                                             ,pt_i_PackageName       => gct_PackageName
                                             ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                             ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                             ,pt_i_ModuleMessage     => SUBSTR(
                                                                               '                - Client Data Column/s with missing mappings : '
                                                                             ||vv_UnmappedColumnNames
                                                                              ,1
                                                                              ,1800
                                                                              )
                                             ,pt_i_OracleError       => NULL
                                             );
                                        --
                                   END IF; --** vn_MissingMappingCount <= 50
                                   --
                              ELSE
                                   --
                                   log_module_message
                                        (
                                         pt_i_ApplicationSuite  => gct_ApplicationSuite
                                        ,pt_i_Application       => gct_Application
                                        ,pt_i_BusinessEntity    => gct_BusinessEntity
                                        ,pt_i_SubEntity         => gct_SubEntity
                                        ,pt_i_FileSetID         => 0
                                        ,pt_i_MigrationSetID    => 0
                                        ,pt_i_Phase             => gct_Phase
                                        ,pt_i_Severity          => 'NOTIFICATION'
                                        ,pt_i_PackageName       => gct_PackageName
                                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                        ,pt_i_ModuleMessage     => '              - VALID: All Client Data Columns in the "'
                                                                 ||TablePair_rec.stg_schema_name
                                                                 ||'.'
                                                                 ||TablePair_rec.stg_table_name
                                                                 ||'" table are mapped to a column in the "'
                                                                 ||TablePair_rec.xfm_schema_name
                                                                 ||'.'
                                                                 ||TablePair_rec.xfm_table_name
                                                                 ||'" table.'
                                        ,pt_i_OracleError       => NULL
                                        );
                                   --
                              END IF; --** IF vn_MissingMappingCount > 0
                              --
                              log_module_message
                                   (
                                    pt_i_ApplicationSuite  => gct_ApplicationSuite
                                   ,pt_i_Application       => gct_Application
                                   ,pt_i_BusinessEntity    => gct_BusinessEntity
                                   ,pt_i_SubEntity         => gct_SubEntity
                                   ,pt_i_FileSetID         => 0
                                   ,pt_i_MigrationSetID    => 0
                                   ,pt_i_Phase             => gct_Phase
                                   ,pt_i_Severity          => 'NOTIFICATION'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '            - Client Data Column mapping verification complete.'
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                              log_module_message
                                   (
                                    pt_i_ApplicationSuite  => gct_ApplicationSuite
                                   ,pt_i_Application       => gct_Application
                                   ,pt_i_BusinessEntity    => gct_BusinessEntity
                                   ,pt_i_SubEntity         => gct_SubEntity
                                   ,pt_i_FileSetID         => 0
                                   ,pt_i_MigrationSetID    => 0
                                   ,pt_i_Phase             => gct_Phase
                                   ,pt_i_Severity          => 'NOTIFICATION'
                                   ,pt_i_PackageName       => gct_PackageName
                                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                                   ,pt_i_ModuleMessage     => '        - Paired STG/XFM table verification complete.'
                                   ,pt_i_OracleError       => NULL
                                   );
                              --
                         END LOOP; --** TablePairs_cur LOOP
                         --
                    END IF; --** IF vb_DataTablesExist
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => '    - Sub-Entity "'
                                                  ||Metadata_rec.sub_entity
                                                  ||'" setup verification complete.'
                         ,pt_i_OracleError       => NULL
                         );
                    --
               END LOOP; --** Metadata_cur LOOP
               --
               log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => gct_SubEntity
                    ,pt_i_FileSetID         => 0
                    ,pt_i_MigrationSetID    => 0
                    ,pt_i_Phase             => gct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Sub-Entity specific Metadata verification complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               /*
               ** LOOP through the XXMX_MIGRATION_METADATA table for all File Group Numbers
               ** within the Business Entity to verify:
               **
               ** 1) File Group Properties have been defined.
               ** 2) File Locations have been defined.
               ** 3) Fusion Job Definitions have been defined.
               */
               --
               log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => gct_SubEntity
                    ,pt_i_FileSetID         => 0
                    ,pt_i_MigrationSetID    => 0
                    ,pt_i_Phase             => gct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Verifying Core table population related to File Groups.'
                    ,pt_i_OracleError       => NULL
                    );
               --
               FOR  FileGroup_rec
               IN   FileGroups_cur
                         (
                          pt_i_BusinessEntity
                         )
               LOOP
                    --
                    /*
                    ** Verify that File Group Properties have been defined.
                    */
                    --
                    gvv_ProgressIndicator := '0160';
                    --
                    gvn_ExistenceCheckCount := NULL;
                    --
                    SELECT COUNT(*)
                    INTO   gvn_ExistenceCheckCount
                    FROM   xxmx_file_group_properties  xfpg
                    WHERE  1 = 1
                    AND    xfpg.application_suite = FileGroup_rec.application_suite
                    AND    xfpg.application       = FileGroup_rec.application
                    AND    xfpg.business_entity   = FileGroup_rec.business_entity
                    AND    xfpg.file_group_number = FileGroup_rec.file_group_number;
                    --
                    IF   gvn_ExistenceCheckCount = 0
                    THEN
                         --
                         --vb_ReturnStatus := FALSE;
                         --
                         log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => gct_SubEntity
                              ,pt_i_FileSetID         => 0
                              ,pt_i_MigrationSetID    => 0
                              ,pt_i_Phase             => gct_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '    - INVALID: Table "xxmx_file_group_properties" is '
                                                       ||'not populated for File Group Number "'
                                                       ||FileGroup_rec.file_group_number
                                                       ||'".  Ensure that the "xxmx_populate_file_groups.sql" script has been executed.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                    END IF; --** IF gvn_ExistenceCheckCount = 0
                    --
                    /*
                    ** Verify that File Locations have been defined.
                    */
                    --
                    gvv_ProgressIndicator := '0170';
                    --
                    gvn_ExistenceCheckCount := NULL;
                    --
                    SELECT COUNT(*)
                    INTO   gvn_ExistenceCheckCount
                    FROM   xxmx_file_locations  xfl
                    WHERE  1 = 1
                    AND    xfl.application_suite = FileGroup_rec.application_suite
                    AND    xfl.application       = FileGroup_rec.application
                    AND    xfl.business_entity   = FileGroup_rec.business_entity
                    AND    xfl.file_group_number = FileGroup_rec.file_group_number;
                    --
                    IF   gvn_ExistenceCheckCount = 0
                    THEN
                         --
                         --vb_ReturnStatus := FALSE;
                         --
                         log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => gct_SubEntity
                              ,pt_i_FileSetID         => 0
                              ,pt_i_MigrationSetID    => 0
                              ,pt_i_Phase             => gct_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '    - INVALID: Table "xxmx_file_locations" is '
                                                       ||'not populated for File Group Number "'
                                                       ||FileGroup_rec.file_group_number
                                                       ||'".  Ensure that the "xxmx_populate_file_locations.sql" script has been executed.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                    END IF; --** IF gvn_ExistenceCheckCount = 0
                    --
                    /*
                    ** Verify that Fusion Jobs have been defined.
                    */
                    --
                    gvv_ProgressIndicator := '0180';
                    --
                    gvn_ExistenceCheckCount := NULL;
                    --
                    SELECT COUNT(*)
                    INTO   gvn_ExistenceCheckCount
                    FROM   xxmx_fusion_job_definitions  xfjd
                    WHERE  1 = 1
                    AND    xfjd.application_suite = FileGroup_rec.application_suite
                    AND    xfjd.application       = FileGroup_rec.application
                    AND    xfjd.business_entity   = FileGroup_rec.business_entity
                    AND    xfjd.file_group_number = FileGroup_rec.file_group_number;
                    --
                    IF   gvn_ExistenceCheckCount = 0
                    THEN
                         --
                         --vb_ReturnStatus := FALSE;
                         --
                         log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => gct_SubEntity
                              ,pt_i_FileSetID         => 0
                              ,pt_i_MigrationSetID    => 0
                              ,pt_i_Phase             => gct_Phase
                              ,pt_i_Severity          => 'NOTIFICATION'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => '    - INVALID: Table "xxmx_fusion_job_definitions" is '
                                                       ||'not populated for File Group Number "'
                                                       ||FileGroup_rec.file_group_number
                                                       ||'".  Ensure that the "xxmx_populate_file_locations.sql" script has been executed.'
                              ,pt_i_OracleError       => NULL
                              );
                         --
                    END IF; --** IF gvn_ExistenceCheckCount = 0
                    --
               END LOOP; --** FileGroups_cur LOOP
               --
               log_module_message
                    (
                     pt_i_ApplicationSuite  => gct_ApplicationSuite
                    ,pt_i_Application       => gct_Application
                    ,pt_i_BusinessEntity    => gct_BusinessEntity
                    ,pt_i_SubEntity         => gct_SubEntity
                    ,pt_i_FileSetID         => 0
                    ,pt_i_MigrationSetID    => 0
                    ,pt_i_Phase             => gct_Phase
                    ,pt_i_Severity          => 'NOTIFICATION'
                    ,pt_i_PackageName       => gct_PackageName
                    ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage     => '  - Core table population verification complete.'
                    ,pt_i_OracleError       => NULL
                    );
               --
          END IF; --** IF vb_MetadataPopulated
          --
          /*
          ** All Business Entity Migrations which are being performed using PL/SQL Extracts over a
          ** DB Link must have at least one Migration Parameter defined in the XXMX_MIGRATION_PARAMETERS
          ** table to drive the Scope Table population procedures.
          **
          ** The actual number of Migration Parameters varies greatly from Business Entity to Business
          ** Entity.
          **
          ** If there are no Migration Parameters defined for the Business Entity at all then it
          ** is likely that the initial population of the XXMX_MIGRATION_PARAMETERS table was accidentally
          ** skipped (but this would be detected by the "valid_install" function which is executed in the
          ** STG_MAIN procedure before this procedure is called.
          **
          ** This check is in case someone has inadvertently deleted the initial migration parameters for the
          ** the Business Entity.
          **
          ** We do not need to validate the value of the STG_POPULATION_METHOD core parameter as that
          ** is also done in the "valid_install" function.
          */
          --
          vt_ParameterCode := 'STG_POPULATION_METHOD';
          --
          gvt_StgPopulationMethod := get_core_parameter_value
                                         (
                                          pt_i_ParameterCode => vt_ParameterCode
                                         );
          --
          log_module_message
              (
               pt_i_ApplicationSuite  => gct_ApplicationSuite
              ,pt_i_Application       => gct_Application
              ,pt_i_BusinessEntity    => gct_BusinessEntity
              ,pt_i_SubEntity         => gct_SubEntity
              ,pt_i_FileSetID         => 0
              ,pt_i_MigrationSetID    => 0
              ,pt_i_Phase             => gct_Phase
              ,pt_i_Severity          => 'NOTIFICATION'
              ,pt_i_PackageName       => gct_PackageName
              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
              ,pt_i_ModuleMessage     => '  - The "'
                                       ||vt_ParameterCode
                                       ||'" parameter is set to "'
                                       ||gvt_StgPopulationMethod
                                       ||'".'
              ,pt_i_OracleError       => NULL
              );
          --
          IF   gvt_StgPopulationMethod = 'DB LINK'
          THEN
               --
               log_module_message
                   (
                    pt_i_ApplicationSuite  => gct_ApplicationSuite
                   ,pt_i_Application       => gct_Application
                   ,pt_i_BusinessEntity    => gct_BusinessEntity
                   ,pt_i_SubEntity         => gct_SubEntity
                   ,pt_i_FileSetID         => 0
                   ,pt_i_MigrationSetID    => 0
                   ,pt_i_Phase             => gct_Phase
                   ,pt_i_Severity          => 'NOTIFICATION'
                   ,pt_i_PackageName       => gct_PackageName
                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage     => '    - As Client Data is to be extracted from a Source Database via PL/SQL, '
                                            ||'Migration Parameters will be required for this Business Entity.'
                   ,pt_i_OracleError       => NULL
                   );
               --
               SELECT COUNT(1)
               INTO   gvn_ExistenceCheckCount
               FROM   xxmx_migration_parameters
               WHERE  1 = 1
               AND    business_entity = pt_i_BusinessEntity;
               --
               IF   gvn_ExistenceCheckCount = 0
               THEN
                    --
                   -- vb_ReturnStatus := FALSE;
                    --
                    log_module_message
                        (
                         pt_i_ApplicationSuite  => gct_ApplicationSuite
                        ,pt_i_Application       => gct_Application
                        ,pt_i_BusinessEntity    => gct_BusinessEntity
                        ,pt_i_SubEntity         => gct_SubEntity
                        ,pt_i_FileSetID         => 0
                        ,pt_i_MigrationSetID    => 0
                        ,pt_i_Phase             => gct_Phase
                        ,pt_i_Severity          => 'ERROR'
                        ,pt_i_PackageName       => gct_PackageName
                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage     => '  - INVALID: No Migration Parameters are defined in the "xxmx_migration_parameters" table '
                                                 ||'for this Business Entity.'
                        ,pt_i_OracleError       => NULL
                        );
                    --
               ELSE
                    --
                    log_module_message
                        (
                         pt_i_ApplicationSuite  => gct_ApplicationSuite
                        ,pt_i_Application       => gct_Application
                        ,pt_i_BusinessEntity    => gct_BusinessEntity
                        ,pt_i_SubEntity         => gct_SubEntity
                        ,pt_i_FileSetID         => 0
                        ,pt_i_MigrationSetID    => 0
                        ,pt_i_Phase             => gct_Phase
                        ,pt_i_Severity          => 'ERROR'
                        ,pt_i_PackageName       => gct_PackageName
                        ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                        ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage     => '  - VALID: Migration Parameters have been defined in the "xxmx_migration_parameters" table '
                                                 ||'for this Business Entity.'
                        ,pt_i_OracleError       => NULL
                        );
                    --
                    --
               END IF;
               --
          ELSE
               --
               log_module_message
                   (
                    pt_i_ApplicationSuite  => gct_ApplicationSuite
                   ,pt_i_Application       => gct_Application
                   ,pt_i_BusinessEntity    => gct_BusinessEntity
                   ,pt_i_SubEntity         => gct_SubEntity
                   ,pt_i_FileSetID         => 0
                   ,pt_i_MigrationSetID    => 0
                   ,pt_i_Phase             => gct_Phase
                   ,pt_i_Severity          => 'NOTIFICATION'
                   ,pt_i_PackageName       => gct_PackageName
                   ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                   ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                   ,pt_i_ModuleMessage     => '    - As Client Data is being loaded from Data File, no Migration Parameters are required.'
                   ,pt_i_OracleError       => NULL
                   );
               --
          END IF;
          --
          RETURN(vb_ReturnStatus);
          --
          EXCEPTION
               --
               WHEN e_ModuleError
               THEN
                    --
                    ROLLBACK;
                    --
                    vb_ReturnStatus := FALSE;
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gct_Phase
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
                    RETURN(vb_ReturnStatus);
                    --
               --** END e_ModuleError Exception
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    vb_ReturnStatus := FALSE;
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gct_Phase
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
                    RETURN(vb_ReturnStatus);
                    --
               --** END OTHERS Exception
               --
          --** END Exception Handler
          --
     END valid_business_entity_setup;
     --
     --
     /*
     ******************************************
     ** PROCEDURE: init_file_migration_set
     **
     ** Called from the Dynamic SQL STG_MAIN
     ** procedure.
     ******************************************
     */
     --
     PROCEDURE init_file_migration_set
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_headers.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_headers.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_headers.business_entity%TYPE
                    ,pt_i_FileSetID                  IN      xxmx_migration_headers.file_set_id%TYPE
                    ,pt_o_MigrationSetName              OUT  xxmx_Migration_headers.migration_set_name%TYPE
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'init_file_migration_set';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_BusinessEntitySeq            xxmx_migration_metadata.business_entity_seq%TYPE;
          vv_DateAndTimeStamp             VARCHAR2(20);
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
          gvv_ProgressIndicator := '0010';
          --
          /*
          ** Retrieve the Business Entity sequence numbers for inclusion in the
          ** insert into the Migration Headers table.
          */
          --
          vt_BusinessEntitySeq := get_business_entity_seq
                                       (
                                        pt_i_ApplicationSuite => pt_i_ApplicationSuite
                                       ,pt_i_Application      => pt_i_Application
                                       ,pt_i_BusinessEntity   => pt_i_BusinessEntity
                                       );
          --
          /*
          ** Generate a Migration Set ID and Name.
          **
          ** For Maximise 2.0 we now generate the Migration Set Name here also
          ** (in Maximise 1.0 the User entered a free-format Migration Set Name).  
          */
          --
          vv_DateAndTimeStamp := date_and_time_stamp
                                      (
                                       pv_i_IncludeSeconds => 'Y'
                                      );
          --
          pt_o_MigrationSetName := UPPER(pt_i_ApplicationSuite)
                                 ||'_'
                                 ||UPPER(pt_i_Application)
                                 ||'_'
                                 ||UPPER(pt_i_BusinessEntity)
                                 ||'_'
                                 ||pt_i_FileSetID
                                 ||'_'
                                 ||vv_DateAndTimeStamp;
          --                     
          --** Insert initial record into extract requests table
          --**
          --** the extract procedures will update this record using
          --** the returned migration_set_id
          --
          gvv_ProgressIndicator := '0010';
          --
          INSERT
          INTO   xxmx_migration_headers
                      (
                       application_suite
                      ,application
                      ,business_entity_seq
                      ,business_entity
                      ,file_set_id
                      ,migration_set_id
                      ,migration_set_name
                      ,phase
                      ,migration_status
                      )
          VALUES
                      (
                       UPPER(pt_i_ApplicationSuite)  -- application_suite
                      ,UPPER(pt_i_Application)       -- application
                      ,vt_BusinessEntitySeq          -- business_entity_seq
                      ,pt_i_BusinessEntity           -- business_entity
                      ,pt_i_FileSetID                -- file_set_id
                      ,0                             -- migration_set_id
                      ,pt_o_MigrationSetName         -- migration_set_name
                      ,'EXTRACT'                     -- phase
                      ,'EXTRACTING'                  -- migration_status
                      );
          --
          COMMIT;
          --
          EXCEPTION
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    pt_o_MigrationSetName := NULL;
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gct_Phase
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
     END init_file_migration_set;
     --
     --
     /*
     ******************************************
     ** PROCEDURE: init_ext_migration_set
     **
     ** Called from the Dynamic SQL STG_MAIN
     ** procedure.
     ******************************************
     */
     --
     PROCEDURE init_ext_migration_set
                    (
                     pt_i_ApplicationSuite           IN      xxmx_migration_headers.application_suite%TYPE
                    ,pt_i_Application                IN      xxmx_migration_headers.application%TYPE
                    ,pt_i_BusinessEntity             IN      xxmx_migration_headers.business_entity%TYPE
                    ,pt_o_MigrationSetID                OUT  xxmx_migration_headers.migration_set_id%TYPE
                    ,pt_o_MigrationSetName              OUT  xxmx_Migration_headers.migration_set_name%TYPE
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
          ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'init_migration_set';
          --
          --************************
          --** Variable Declarations
          --************************
          --
          vt_BusinessEntitySeq            xxmx_migration_metadata.business_entity_seq%TYPE;
          vv_DateAndTimeStamp             VARCHAR2(20);
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
          gvv_ProgressIndicator := '0010';
          --
          /*
          ** Retrieve the Business Entity sequence numbers for inclusion in the
          ** insert into the Migration Headers table.
          */
          --
          vt_BusinessEntitySeq := get_business_entity_seq
                                       (
                                        pt_i_ApplicationSuite => pt_i_ApplicationSuite
                                       ,pt_i_Application      => pt_i_Application
                                       ,pt_i_BusinessEntity   => pt_i_BusinessEntity
                                       );
          --
          /*
          ** Generate a Migration Set ID and Name.
          **
          ** For Maximise 2.0 we now generate the Migration Set Name here also
          ** (in Maximise 1.0 the User entered a free-format Migration Set Name).  
          */
          --
          vv_DateAndTimeStamp := date_and_time_stamp
                                      (
                                       pv_i_IncludeSeconds => 'Y'
                                      );
          --
          SELECT xxmx_migration_set_ids_s.NEXTVAL
          INTO   pt_o_MigrationSetID
          FROM   dual;
          --
          pt_o_MigrationSetName := UPPER(pt_i_ApplicationSuite)
                                 ||'_'
                                 ||UPPER(pt_i_Application)
                                 ||'_'
                                 ||UPPER(pt_i_BusinessEntity)
                                 ||'_'
                                 ||pt_o_MigrationSetID
                                 ||'_'
                                 ||vv_DateAndTimeStamp;
          --                     
          --** Insert initial record into extract requests table
          --**
          --** the extract procedures will update this record using
          --** the returned migration_set_id
          --
          gvv_ProgressIndicator := '0010';
          --
          INSERT
          INTO   xxmx_migration_headers
                      (
                       application_suite
                      ,application
                      ,business_entity_seq
                      ,business_entity
                      ,file_set_id
                      ,migration_set_id
                      ,migration_set_name
                      ,phase
                      ,migration_status
                      )
          VALUES
                      (
                       UPPER(pt_i_ApplicationSuite)  -- application_suite
                      ,UPPER(pt_i_Application)       -- application
                      ,vt_BusinessEntitySeq          -- business_entity_seq
                      ,pt_i_BusinessEntity           -- business_entity
                      ,0                             -- file_set_id
                      ,pt_o_MigrationSetID           -- migration_set_id
                      ,pt_o_MigrationSetName         -- migration_set_name
                      ,'EXTRACT'                     -- phase
                      ,'EXTRACTING'                  -- migration_status
                      );
          --
          COMMIT;
          --
          EXCEPTION
               --
               WHEN OTHERS
               THEN
                    --
                    ROLLBACK;
                    --
                    pt_o_MigrationSetID   := NULL;
                    pt_o_MigrationSetName := NULL;
                    --
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    --
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gct_Phase
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
     END init_ext_migration_set;
     --
     --

     -- ----------------------------------------------------------------------------
     -- |------------------------------< OPEN_CSV >--------------------------------|
     -- ----------------------------------------------------------------------------
     PROCEDURE open_csv (    pv_i_business_entity               IN   VARCHAR2
                            ,pv_i_file_name                     IN   VARCHAR2
                            ,pv_i_hdrname                       IN   VARCHAR2 DEFAULT NULL
                            ,pv_i_directory_name                IN   VARCHAR2
                            ,pv_i_line_type                     IN   VARCHAR2
                            ,pv_i_data                          IN   VARCHAR2
                            ,pv_o_ReturnStatus                  OUT  VARCHAR2
                            ,pt_o_ReturnMessage                 OUT  xxmx_data_messages.data_message%TYPE
      ) IS
          --*************************
          --** Local Variables
          --*************************
          --
          vv_file_name     VARCHAR2(80); 
          vv_file_dir      VARCHAR2(80);
          ct_ProcOrFuncName  VARCHAR2(30):='open_csv';
          vc_comment     VARCHAR2(400) := 'COMMENT ##############################################################################';

          --*************************
          --** Exception Declarations
          --*************************
          --
          e_ModuleError                   EXCEPTION;

        BEGIN
                gvv_ProgressIndicator := '0005';
                --Get Directory Name
                BEGIN 
                    SELECT directory_name
                    INTO vv_file_dir
                    from all_directories
                    WHERE (directory_path like '%'||pv_i_directory_name||'%'
                     OR  directory_name like '%'||pv_i_directory_name||'%');

                EXCEPTION
                    WHEN OTHERS THEN 
                        gvt_ModuleMessage := SQLERRM;
                        raise e_ModuleError;
                END;

                -- Open the File
               -- dbms_output.put_line ('Calling write_hdr File Name '||pv_i_file_name||' '||vv_file_dir);

                --dbms_output.put_line ('Calling write_hdr File Name 1'||pv_i_file_name);
               -- dbms_output.put_line ('Calling write_hdr File Name 2'||vv_file_dir);
                --dbms_output.put_line ('Calling write_hdr File Name 3'||pv_i_business_entity);



                IF( pv_i_line_type = 'H') THEN

                   -- dbms_output.put_line ('Calling write_hdr File Name '||pv_i_file_name||' '||pv_i_business_entity);
                    g_file_id := utl_file.fopen (vv_file_dir , pv_i_file_name,  'W', 10000);
                    utl_file.put_line (g_file_id, vc_comment);
                    utl_file.put_line (g_file_id, 'COMMENT HDL Data -  '||' File: '||pv_i_file_name);
                    utl_file.put_line (g_file_id, 'COMMENT Generated by Version 1 ');
                    utl_file.put_line (g_file_id, 'COMMENT Date: '||to_char(sysdate, 'DD-MON-RRRR HH24:MI:SS'));
                    utl_file.put_line (g_file_id, 'COMMENT Please DO NOT edit this file manually');
                    utl_file.put_line (g_file_id, vc_comment);
                    utl_file.put_line (g_file_id, '');
                    utl_file.put_line (g_file_id, vc_comment);
                    utl_file.put_line (g_file_id, 'COMMENT Business Entity : '||pv_i_business_entity);
                    utl_file.put_line (g_file_id, vc_comment);
                    utl_file.put_line (g_file_id, pv_i_data);
                    UTL_FILE.FCLOSE(g_file_id);
                END IF;

                IF( pv_i_line_type = 'D') THEN

                   -- dbms_output.put_line ('Calling write_hdr File Name '||pv_i_file_name||' '||pv_i_business_entity);
                    g_file_id := utl_file.fopen (vv_file_dir , pv_i_file_name,  'A', 10000);
                    utl_file.put_line (g_file_id, pv_i_data);
                    UTL_FILE.FCLOSE(g_file_id);
                END IF;

                log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Calling write_hdr File Name '||pv_i_file_name||' '||pv_i_business_entity
                         ,pt_i_OracleError       => NULL
                         );


                -- Write the main header
                write_csv (
                             pv_i_business_entity  =>   pv_i_business_entity
                            ,pv_i_file_name        =>   pv_i_file_name
                            ,pv_i_data             =>   pv_i_data
                            ,pv_i_line_type        =>   pv_i_line_type
                            );

                --
        EXCEPTION
                --
                when e_ModuleError THEN
                 log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_FileSetID         => 0
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'NOTIFICATION'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Unable to get the directory_name: '||pv_i_directory_name||' '||gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    Raise;
                --
                when utl_file.invalid_path THEN
                utl_file.fclose_all;
                --  print_log ('Error: Invalid File Path');
                raise;
                --
                when utl_file.invalid_mode THEN
                utl_file.fclose_all;
                --   print_log ('Error: Invalid File Mode');
                raise;
                --
                when utl_file.internal_error THEN
                utl_file.fclose_all;
                --   print_log ('Error: Internal Error');
                raise;
                --
                when utl_file.invalid_operation THEN
                utl_file.fclose_all;
                --   print_log ('Error: Invalid File Operation');
                raise;
                --
                when utl_file.invalid_filehandle THEN
                utl_file.fclose_all;
                --   print_log ('Error: Invalid File Handler');
                raise;
                --
                when others THEN
                utl_file.fclose_all;
                --   print_log ('Error: Unexpected Error');
                raise;
                --
         END open_csv;
         --
         --
         --
        -- ----------------------------------------------------------------------------
        -- |-----------------------------< WRITE_CSV >-------------------------|
        -- ----------------------------------------------------------------------------
        --
        PROCEDURE write_csv (pv_i_business_entity  IN VARCHAR2
                            ,pv_i_file_name        IN VARCHAR2
                            ,pv_i_data             IN VARCHAR2
                            ,pv_i_line_type        IN   VARCHAR2
                            ,pv_i_file_type        IN VARCHAR2 DEFAULT 'M') IS
          --
          -- Local Variables
          l_file_id                  utl_file.file_type;

          vc_comment     VARCHAR2(400) := 'COMMENT ##############################################################################';
          ct_ProcOrFuncName  VARCHAR2(30):='write_csv';
        --
        begin
          --
          l_file_id := g_file_id;

          -- Write the HDL file header contents
        /*  utl_file.put_line (l_file_id, vc_comment);
          utl_file.put_line (l_file_id, 'COMMENT HDL Data -  '||pv_i_client||' File: '||pv_i_file_name);
          utl_file.put_line (l_file_id, 'COMMENT Generated by Version 1 ');
          utl_file.put_line (l_file_id, 'COMMENT Date: '||to_char(sysdate, 'DD-MON-RRRR HH24:MI:SS'));
          utl_file.put_line (l_file_id, 'COMMENT Please DO NOT edit this file manually');
          utl_file.put_line (l_file_id, vc_comment);
          utl_file.put_line (l_file_id, '');
          utl_file.put_line (l_file_id, vc_comment);
          utl_file.put_line (l_file_id, 'COMMENT Business Entity : '||pv_i_business_entity);
          utl_file.put_line (l_file_id, vc_comment);
        */
          IF( pv_i_line_type = 'H') THEN
              INSERT INTO  xxmx_csv_file_temp (file_name,line_type,line_content)
                   VALUES (pv_i_file_name,'File Header', vc_comment);
              INSERT INTO  xxmx_csv_file_temp (file_name,line_type,line_content)
                   VALUES (pv_i_file_name,'File Header','COMMENT Data -   File: '||pv_i_file_name);
              INSERT INTO  xxmx_csv_file_temp (file_name,line_type,line_content)
                   VALUES (pv_i_file_name,'File Header','COMMENT Generated by Version 1 ');
              INSERT INTO  xxmx_csv_file_temp (file_name,line_type,line_content) 
                   VALUES (pv_i_file_name,'File Header','COMMENT Date: '||to_char(sysdate, 'DD-MON-RRRR HH24:MI:SS'));
              INSERT INTO  xxmx_csv_file_temp (file_name,line_type,line_content)
                   VALUES (pv_i_file_name,'File Header','COMMENT Please DO NOT edit this file manually');
              INSERT INTO  xxmx_csv_file_temp (file_name,line_type,line_content) 
                   VALUES (pv_i_file_name,'File Header', vc_comment);
              INSERT INTO  xxmx_csv_file_temp (file_name,line_type,line_content) 
                   VALUES (pv_i_file_name,'File Header',' ');
              INSERT INTO  xxmx_csv_file_temp (file_name,line_type,line_content) 
                   VALUES (pv_i_file_name,'File Header',  vc_comment);
              INSERT INTO  xxmx_csv_file_temp (file_name,line_type,line_content) 
                   VALUES (pv_i_file_name,'File Header', 'COMMENT Business Entity : '||pv_i_business_entity);
              INSERT INTO  xxmx_csv_file_temp (file_name,line_type,line_content) 
                   VALUES (pv_i_file_name,'File Header',  vc_comment);
              INSERT INTO  xxmx_csv_file_temp (file_name,line_type,line_content) VALUES (pv_i_file_name,'File Header',  pv_i_data);
         END IF;

         IF( pv_i_line_type = 'D') THEN

               -- dbms_output.put_line ('Calling write_hdr File Name '||pv_i_file_name||' '||pv_i_business_entity);
                INSERT INTO  xxmx_csv_file_temp (ID,file_name,line_type,line_content) VALUES (xxmx_person_migr_temp_s.NEXTVAL,pv_i_file_name,'File Detail',  pv_i_data);

         END IF;

                commit;

          --
        exception
          --

          when utl_file.write_error THEN
            utl_file.fclose_all;
         --   print_log ('Error: Invalid Operation');
            raise;
            --
          when others THEN
            utl_file.fclose_all;
        --    print_log ('Error: Unexpected Error');
            raise;
          --
        END write_csv;
-- ----------------------------------------------------------------------------
-- |------------------------------< p_extract_data >------------------------|
-- ----------------------------------------------------------------------------  
PROCEDURE p_extract_data(
					      pv_i_application_suite VARCHAR2
						, pv_i_business_entity VARCHAR2						
						, pv_i_stage VARCHAR2 
						)
IS 
l_stg_table VARCHAR2(50);
l_migration_Set_id number;
l_SQL VARCHAR2(500);
BEGIN

	IF pv_i_stage = 'EXTRACT'
	 THEN 
	--
		IF pv_i_application_suite IN( 'FIN','SCM')
		 THEN
                dbms_scheduler.create_job (
                job_name   =>  pv_i_application_suite||'_'||pv_i_business_entity||'_'||pv_i_stage,
                job_type   => 'PLSQL_BLOCK',
                job_action => 
                'BEGIN 
                 XXMX_FIN_STG_EXTRACT_PKG.stg_main ( 
                                 pt_i_BusinessEntity           => '''||pv_i_business_entity||'''
                                ,pt_i_filesetid                => NULL
                                            ) ;
                 END;',
                enabled   =>  TRUE,  
                auto_drop =>  TRUE, 
                comments  =>  'Run '||pv_i_application_suite||'_'||pv_i_business_entity||'_'||pv_i_stage); 
        ELSIF pv_i_application_suite = 'HCM'
		 THEN
                dbms_scheduler.create_job (
                job_name   =>  pv_i_application_suite||'_'||pv_i_business_entity||'_'||pv_i_stage,
                job_type   => 'PLSQL_BLOCK',
                job_action => 
                'BEGIN 
                 XXMX_HCM_STG_EXTRACT_PKG.stg_main ( 
                                 pt_i_BusinessEntity           => '''||pv_i_business_entity||'''
                                ,pt_i_filesetid                => NULL
                                            ) ;
                 END;',
                enabled   =>  TRUE,  
                auto_drop =>  TRUE, 
                comments  =>  'Run '||pv_i_application_suite||'_'||pv_i_business_entity||'_'||pv_i_stage); 
		END IF;
	--					
	ELSIF pv_i_stage = 'TRANSFORM' 
	 THEN 
	--
            SELECT stg_table
            INTO l_stg_table
            FROM xxmx_migration_metadata
            WHERE business_entity = pv_i_business_entity
            AND enabled_flag = 'Y'
            AND sub_entity_seq IN( 
                                SELECT MIN(sub_entity_seq)
                                FROM xxmx_migration_metadata
                                WHERE business_entity = pv_i_business_entity
                                AND enabled_flag = 'Y');

            l_sql := 'select MAX(migration_Set_id) from '||l_stg_table;

            EXECUTE IMMEDIATE l_sql INTO l_migration_Set_id; 

            IF pv_i_application_suite IN ( 'FIN','SCM')
            THEN
                    dbms_scheduler.create_job (
                    job_name   =>  pv_i_application_suite||'_'||pv_i_business_entity||'_'||pv_i_stage,
                    job_type   => 'PLSQL_BLOCK',
                    job_action => 
                    'BEGIN 
                     XXMX_FIN_STG_EXTRACT_PKG.xfm_main ( 
                                     pt_i_BusinessEntity           => '''||pv_i_business_entity||'''
                                    ,pt_i_filesetid                => NULL
                                    ,pt_i_MigrationSetID   => '''||l_migration_Set_id||'''
                                                ) ;
                     END;',
                    enabled   =>  TRUE,  
                    auto_drop =>  TRUE, 
                    comments  =>  'Run '||pv_i_application_suite||'_'||pv_i_business_entity||'_'||pv_i_stage); 
                    --
            ELSIF pv_i_application_suite = 'HCM'
            THEN
                    dbms_scheduler.create_job (
                    job_name   =>  pv_i_application_suite||'_'||pv_i_business_entity||'_'||pv_i_stage,
                    job_type   => 'PLSQL_BLOCK',
                    job_action => 
                    'BEGIN 
                    XXMX_HCM_STG_EXTRACT_PKG.xfm_main ( 
                         pt_i_BusinessEntity           => '''||pv_i_business_entity||'''
                        ,pt_i_filesetid                => NULL
                        ,pt_i_MigrationSetID   => '''||l_migration_Set_id||'''
                                    ) ;
                    END;',
                    enabled   =>  TRUE,  
                    auto_drop =>  TRUE, 
                    comments  =>  'Run '||pv_i_application_suite||'_'||pv_i_business_entity||'_'||pv_i_stage); 
                    --
            END IF; -- pv_i_application_suite IN ( 'FIN','SCM')
	--
	END IF;  -- pv_i_stage = 'TRANSFORM' 

END  p_extract_data;
-- ----------------------------------------------------------------------------
-- |----------------------------< GET_CSVDATA_COUNT >-------------------------|
-- ----------------------------------------------------------------------------

    FUNCTION get_csvdata_count (   
    pv_i_application_suite     VARCHAR2,
    pv_i_filename     VARCHAR2					
                            )
	RETURN NUMBER IS 
        l_count NUMBER := 0; 
    BEGIN      
        IF pv_i_application_suite = 'FIN' OR pv_i_application_suite='SCM'
          THEN
        SELECT COUNT(*)
           INTO l_count 
           FROM xxmx_csv_file_temp
          WHERE file_name =  pv_i_filename;
        ELSIF pv_i_application_suite = 'HCM'
          THEN          
            SELECT COUNT(*)
               INTO l_count
               FROM xxmx_hdl_file_temp
              WHERE file_name =  pv_i_filename;   
          END IF;
        RETURN l_count;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN l_count;
    END get_csvdata_count;
--
   FUNCTION get_stgxfm_data_count (
        pv_i_table_name VARCHAR2
    ) RETURN NUMBER IS
        l_count   NUMBER := 0;
        l_sql     VARCHAR2(5000);
    BEGIN
        SELECT
            COUNT(*)
        INTO l_count
        FROM
            XXMX_DM_STG_XFM_DATA
        WHERE
            table_name = pv_i_table_name;
        RETURN l_count;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN l_count;
    END get_stgxfm_data_count;

-- ----------------------------------------------------------------------------
-- |-------------------------< INSERT_INTO_ARCH_TABLE >-----------------------|
-- ----------------------------------------------------------------------------
-- pass STG table as p_table_name
--Changed the below code to handle Clob DataType
    /*PROCEDURE insert_into_arch_table (
        pv_i_table_name VARCHAR2
    ) IS

        l_sql         VARCHAR2(5000);
    BEGIN
        l_sql := 'INSERT INTO '
                 || pv_i_table_name 
                 || '_ARCH ' 
				|| ' (SELECT * FROM '
                 || pv_i_table_name
                 || ' MINUS SELECT * FROM '
                 || pv_i_table_name
                 || '_ARCH) ';
            dbms_output.put_line(l_sql);
        EXECUTE IMMEDIATE l_sql;
    END insert_into_arch_table;*/

    -- pass STG table as p_table_name
    PROCEDURE insert_into_arch_table (pv_i_table_name VARCHAR2) 
    IS

        l_sql     LONG;
        l_clob    CLOB:= empty_clob();
        v_column_lst  VARCHAR(30000) := NULL;
        v_tblcolumn_lst  VARCHAR(30000) := NULL;


        CURSOR CUR_COLUMNS
        IS
            SELECT CASE  WHEN DATA_TYPE = 'CLOB' THEN 
                    'dbms_lob.SUBSTR('||COLUMN_NAME||',10000)'
                    ELSE
                        COLUMN_NAME
                    END COLUMN_NAME
                ,column_name TBL_COLUMN_NAME
                ,STG_COLUMN_SEQ SEQ
            FROM XXMX_STG_TABLES a, XXMX_STG_TABLE_COLUMNS B
            WHERE a.STG_table_id = b.STG_table_id 
            and a.table_name =UPPER(pv_i_table_name)
            UNION
            SELECT CASE  WHEN DATA_TYPE = 'CLOB' THEN 
                    'dbms_lob.SUBSTR('||COLUMN_NAME||',10000)'
                    ELSE
                        COLUMN_NAME
                    END COLUMN_NAME
                ,column_name TBL_COLUMN_NAME
                ,XFM_COLUMN_SEQ SEQ
            FROM XXMX_XFM_TABLES a, XXMX_XFM_TABLE_COLUMNS B
            WHERE a.xfm_table_id = b.xfm_table_id 
            and a.table_name =UPPER(pv_i_table_name)
            ORDER BY SEQ;

    BEGIN
        FOR rec IN  CUR_COLUMNS
        LOOP
            IF( v_column_lst is NULL) THEN 
                v_column_lst:= rec.COLUMN_NAME;
                v_tblcolumn_lst := rec.TBL_COLUMN_NAME;
            ELSE 
                v_column_lst := v_column_lst ||' , '||rec.COLUMN_NAME;
                v_tblcolumn_lst := v_tblcolumn_lst||' , '||rec.TBL_COLUMN_NAME;
            END IF;    

        END LOOP;
        --dbms_output.put_line(v_column_lst);

            l_sql :=   'INSERT INTO '
                         || UPPER(pv_i_table_name)
                         || '_ARCH (' 
                         ||v_tblcolumn_lst
                         || ') (SELECT '
                         || v_column_lst
                         ||' FROM '
                         || UPPER(pv_i_table_name)
                         || ' MINUS SELECT '
                         || v_column_lst
                         ||' FROM '
                         || UPPER(pv_i_table_name)
                         || '_ARCH) ';

            --dbms_output.put_line(' ');
            --dbms_output.put_line(l_sql);
        EXECUTE IMMEDIATE l_sql;
    END insert_into_arch_table;

--
-- ----------------------------------------------------------------------------
-- |-------------------------< TRUNCATE_SRC_STG_TABLE >-----------------------|
-- ----------------------------------------------------------------------------
----pass _src table for p_table_name

    PROCEDURE truncate_stg_xfm_table (
        pv_i_table_name VARCHAR2
    ) IS
        l_sql VARCHAR2(5000);
    BEGIN       
        EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || pv_i_table_name;
        EXECUTE IMMEDIATE 'TRUNCATE TABLE '
                          || replace(pv_i_table_name, '_STG', '_XFM');        
    END truncate_stg_xfm_table;

--
-- ----------------------------------------------------------------------------
-- |-------------------------< DELETE_MAPPING_MASTER >------------------------|
-- ----------------------------------------------------------------------------

    PROCEDURE delete_mapping_master ( pv_i_application_suite VARCHAR2 default 'ALL')
     IS
    BEGIN
        DELETE FROM XXMX_MAPPING_MASTER
        WHERE application_suite=decode(pv_i_application_suite, 'ALL', application_suite, pv_i_application_suite);
        DELETE FROM XXMX_SIMPLE_TRANSFORMS
        WHERE application_suite=decode(pv_i_application_suite, 'ALL', application_suite, pv_i_application_suite);

    END delete_mapping_master;
--
-- ----------------------------------------------------------------------------
-- |----------------------------< TRUNCATE_TABLE >----------------------------|
-- ----------------------------------------------------------------------------

    PROCEDURE truncate_table (
        pv_i_table_name VARCHAR2
    ) IS
    BEGIN
        EXECUTE IMMEDIATE 'TRUNCATE TABLE ' || pv_i_table_name;
    END truncate_table;
--
--
-- ----------------------------------------------------------------------------
-- |-------------------------< GENERATE_TABLE_DATA >--------------------------|
-- ----------------------------------------------------------------------------
    PROCEDURE generate_table_data (
        pv_i_table_name IN VARCHAR2
    ) IS

        v_finaltxt          VARCHAR2(20000);
        v_v_val             VARCHAR2(20000);
        v_n_val             NUMBER;
        v_d_val             DATE;
        v_ret               NUMBER;
        c                   NUMBER;
        d                   NUMBER;
        col_cnt             INTEGER;
        f                   BOOLEAN;
        rec_tab             dbms_sql.desc_tab;
        col_num             NUMBER;
        v_fh                utl_file.file_type;
        l_sql               VARCHAR2(2000);
        TYPE t_stg_xfm_data IS
            TABLE OF XXMX_DM_STG_XFM_DATA%rowtype INDEX BY PLS_INTEGER;
        p_stg_xfm_data   t_stg_xfm_data;
        tab_count           NUMBER := 0;
    BEGIN
 --
 --
        DELETE FROM XXMX_DM_STG_XFM_HEADER
        WHERE
            table_name = pv_i_table_name;

        DELETE FROM XXMX_DM_STG_XFM_DATA
        WHERE
            table_name = pv_i_table_name;
 --
       /* Check

	   IF p_table_name IN (
		--Update
            'PFC_AP_SUPP_BANK_ACCT_SRC',
            'PFC_AP_SUPP_PMT_INSTR_SRC',
            'PFC_AP_SUPP_PAYEES_SRC',
            'PFC_AP_SUPP_BANK_ACCT_STG',
            'PFC_AP_SUPP_PMT_INSTR_STG',
            'PFC_AP_SUPP_PAYEES_STG'
        ) THEN
            l_sql := 'select * from '
                     || p_table_name
                     || ' where feeder_import_batch_id= (select max(feeder_import_batch_id) from '
                     || p_table_name
                     || ' )';
        ELSE*/
            l_sql := 'select * from '
                     || pv_i_table_name
                     || ' where migration_set_id = (select max(migration_set_id) from '
                     || pv_i_table_name
                     || ' )';
        --END IF;

--
        c := dbms_sql.open_cursor;
        dbms_sql.parse(c, l_sql, dbms_sql.native);

        d := dbms_sql.execute(c);

        dbms_sql.describe_columns(c, col_cnt, rec_tab);

        dbms_output.put_line(col_cnt);
        dbms_output.put_line(d);
        FOR j IN 1..col_cnt LOOP CASE rec_tab(j).col_type
            WHEN 1 THEN
                dbms_sql.define_column(c, j, v_v_val, 2000);
            WHEN 2 THEN
                dbms_sql.define_column(c, j, v_n_val);
            WHEN 12 THEN
                dbms_sql.define_column(c, j, v_d_val);
            WHEN 180 THEN
                dbms_sql.define_column(c, j, v_v_val, 2000);
            ELSE
                dbms_sql.define_column(c, j, v_v_val, 2000);
        END CASE;
        END LOOP;
  -- This part outputs the HEADER 

        FOR j IN 1..col_cnt LOOP 
			v_finaltxt := ltrim(v_finaltxt
                                || '|'
                                || upper(rec_tab(j).col_name), '|'
								);
        END LOOP;
--
        INSERT INTO XXMX_DM_STG_XFM_HEADER VALUES (
            pv_i_table_name,
            v_finaltxt
        );
  --
  -- This part outputs the DATA
        LOOP
            v_ret := dbms_sql.fetch_rows(c);
            dbms_output.put_line(v_ret);
            EXIT WHEN v_ret = 0;
            v_finaltxt := NULL;
            FOR j IN 1..col_cnt LOOP CASE rec_tab(j).col_type
                WHEN 1 THEN
                    dbms_sql.column_value(c, j, v_v_val);  --varchar2
                --    v_finaltxt :=  ltrim(v_finaltxt||'|"'||REPLACE(REPLACE(TRIM(v_v_val),'"','""'),CHR(10),' ') ||'"','|');  
                    v_finaltxt := ltrim(v_finaltxt
                                        || '|"'
                                        || replace(replace(replace(replace(replace(v_v_val, chr(09), '| '), ' |', '|'), '|', ''),
                                        '"', '""'), chr(10), ' ')
                                        || '"', '|');

                WHEN 2 THEN
                    dbms_sql.column_value(c, j, v_n_val);  --Number
                    v_finaltxt := ltrim(v_finaltxt
                                        || '|"'
                                        || v_n_val
                                        || '"', '|');

                WHEN 12 THEN
                    dbms_sql.column_value(c, j, v_d_val); --date
                    v_finaltxt := ltrim(v_finaltxt
                                        || '|"'
                                        || to_char(v_d_val, 'DD/MM/YYYY')
                                        || '"', '|');

                WHEN 180 THEN
                    dbms_sql.column_value(c, j, v_v_val); --Timestamp
                    v_finaltxt := ltrim(v_finaltxt
                                        || '|"'
                                        || trim(v_v_val)
                                        || '"', '|');

                ELSE
         --v_finaltxt :=  ltrim(v_finaltxt||'|"'||REPLACE(REPLACE(TRIM(v_v_val),'"','""'),CHR(10),' ')||'"','|'); 
                    v_finaltxt := ltrim(v_finaltxt
                                        || '|"'
                                        || replace(replace(replace(replace(replace(v_v_val, chr(09), '| '), ' |', '|'), '|', ''),
                                        '"', '""'), chr(10), ' ')
                                        || '"', '|');
            END CASE;
            END LOOP;

            SELECT
                pv_i_table_name,                
                v_finaltxt
            INTO
                p_stg_xfm_data
            (tab_count)
            FROM
                dual;

            tab_count := tab_count + 1;

        END LOOP;


        FORALL i IN p_stg_xfm_data.first..p_stg_xfm_data.last
            INSERT INTO XXMX_DM_STG_XFM_DATA VALUES (
                p_stg_xfm_data(i).table_name,
                p_stg_xfm_data(i).table_data
            );

        dbms_sql.close_cursor(c);
--
        UPDATE XXMX_DM_STG_XFM_DATA
           SET table_data = regexp_replace(table_data, '[^[:print:]]', '')
         WHERE table_name = pv_i_table_name
           AND REGEXP_LIKE ( table_data,
                              '[^[:print:]]',
                              '' );
--
    END generate_table_data;
--
--
-- ----------------------------------------------------------------------------
-- |---------------------< GET_EXCEL_DATA_HEADER >----------------------------|
-- ----------------------------------------------------------------------------
--
    FUNCTION get_excel_data_header (
        pv_i_sub_entity   VARCHAR2 DEFAULT NULL,
        pv_i_table_name    VARCHAR2 DEFAULT NULL
    ) RETURN CLOB IS
        l_clob      CLOB := empty_clob;
        l_len       BINARY_INTEGER;
        l_content   VARCHAR2(32000);
    BEGIN
        dbms_lob.createtemporary(l_clob, true);
        dbms_lob.open(l_clob, dbms_lob.lob_readwrite);
        IF pv_i_table_name IS NULL THEN
            FOR r_output IN (
                SELECT
                    excel_file_header
                FROM
                    XXMX_DM_SUBENTITY_FILE_MAP
                WHERE
                    sub_entity = pv_i_sub_entity
            ) LOOP
                l_content := r_output.excel_file_header;
                l_len := length(l_content);
                dbms_lob.writeappend(l_clob, l_len, l_content);
            END LOOP;
        ELSE
            FOR r_output IN (
                SELECT
                    header_text
                FROM
                    XXMX_DM_STG_XFM_HEADER
                WHERE
                    table_name = pv_i_table_name
            ) LOOP
                l_content := r_output.header_text;
                l_len := length(l_content);
                dbms_lob.writeappend(l_clob, l_len, l_content);
            END LOOP;
        END IF;    
    --

        dbms_lob.close(l_clob);
--
        RETURN l_clob;
    END get_excel_data_header;
--

-- ----------------------------------------------------------------------------
-- |-------------------------< call_fusion_load_gen >--------------------------|
-- ----------------------------------------------------------------------------
PROCEDURE call_fusion_load_gen(
                     pv_i_application_suite    IN      VARCHAR2
                    ,pt_i_BusinessEntity       IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_sub_entity           IN      xxmx_migration_metadata.sub_entity%TYPE 
                   )
IS
BEGIN
    --DBMS_OUTPUT.PUT_LINE(pv_i_application_suite||'_'||pt_i_BusinessEntity||'_'||pt_i_sub_entity);
	dbms_scheduler.create_job (
	job_name => pv_i_application_suite||'_'||pt_i_BusinessEntity||'_'||pt_i_sub_entity,
	job_type => 'PLSQL_BLOCK',
	job_action =>
	'BEGIN
	XXMX_FUSION_LOAD_GEN_PKG.main (
	pv_i_application_suite => '''||pv_i_application_suite||'''
	,pt_i_BusinessEntity => '''||pt_i_BusinessEntity||'''
	,pt_i_sub_entity => '''||pt_i_sub_entity||'''
	) ;
	END;',
	enabled => TRUE,
	auto_drop => TRUE,
	comments => 'Run '||pv_i_application_suite||'_'||pt_i_BusinessEntity||'_'||pt_i_sub_entity);

END call_fusion_load_gen;
--

-- ----------------------------------------------------------------------------
-- |-------------------------< get_FBDI_filenames >--------------------------|
-- ----------------------------------------------------------------------------
PROCEDURE get_FBDI_filenames(pv_i_application_suite IN  VARCHAR2,
                             pv_i_business_entity   IN  VARCHAR2,
                             pv_i_sub_entity        IN  VARCHAR2,
                             pv_o_fbdi_filenames    OUT XMLType)
IS
    xml_sql_query CLOB;              
BEGIN
    --
    xml_sql_query := '
                    SELECT distinct file_name
                    FROM   xxmx_csv_file_temp csv_temp
                    WHERE  EXISTS (SELECT 1
                                   FROM   xxmx_migration_metadata mm,
                                          xxmx_xfm_tables xt
                                   WHERE  1 = 1
                                   AND    mm.stg_table        IS NOT NULL
                                   AND    mm.enabled_flag      = ''Y''
                                   AND    mm.metadata_id       = xt.metadata_id
                                   AND    csv_temp.file_name   = xt.fusion_template_name';
    --                             
    xml_sql_query := xml_sql_query ||chr(13)|| '               AND mm.application_suite =''' || pv_i_application_suite||'''';
    xml_sql_query := xml_sql_query ||chr(13)|| '               AND mm.business_entity =''' || pv_i_business_entity||'''';
    --
    IF pv_i_sub_entity = 'ALL'
    THEN 
        xml_sql_query := xml_sql_query ||chr(13)|| '               AND mm.sub_entity = mm.sub_entity)';
    ELSE 
        xml_sql_query := xml_sql_query ||chr(13)|| '               AND mm.sub_entity = '''|| pv_i_sub_entity ||''')';
    END IF;
    --
   -- xml_sql_query := xml_sql_query ||chr(13)|| 'AND rownum < 100';
    --             
    SELECT dbms_xmlgen.getxmltype(xml_sql_query)
    INTO   pv_o_fbdi_filenames
    FROM   DUAL;
    --
    --DBMS_OUTPUT.PUT_LINE(pv_o_fbdi_filenames.getstringval());
    --                       
    EXCEPTION
    WHEN OTHERS
    THEN
            null;
            --DBMS_OUTPUT.PUT_LINE(sqlerrm);                             
END get_FBDI_filenames;
END xxmx_utilities_pkg;

/

SHOW ERRORS PACKAGE BODY xxmx_utilities_pkg;
/
--

