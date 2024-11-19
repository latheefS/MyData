--------------------------------------------------------
--  DDL for Package XXMX_UTILITIES_PKG
--------------------------------------------------------

  CREATE OR REPLACE EDITIONABLE PACKAGE "XXMX_CORE"."XXMX_UTILITIES_PKG" IS
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
     **  08/12/2022 Michal Arrowsmith  Added generate_table_data_func for OIC to 
     **                                be able to check if this process completed or not.
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
-- ----------------------------------------------------------------------------
-- |-------------------------< call_fusion_load_gen >--------------------------|
-- ----------------------------------------------------------------------------
PROCEDURE call_fusion_load_gen(
                     pv_i_application_suite    IN      VARCHAR2
                    ,pt_i_BusinessEntity       IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_sub_entity           IN      xxmx_migration_metadata.sub_entity%TYPE 
                   );
function call_fusion_load_gen2(
                     pv_i_application_suite    IN      VARCHAR2
                    ,pt_i_BusinessEntity       IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_sub_entity           IN      xxmx_migration_metadata.sub_entity%TYPE 
                   )
return varchar2;

     --
     /*
     ***************************************
     ** PROCEDURE: log_module_message
     **
     ** Called from each various procedures.
     ***************************************
     */
     --
    function handle_double_quotes
        (
            pv_i_StringToConvert varchar2
        )
    return varchar2;
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

    function generate_table_data_func 
    (
        pv_i_table_name IN VARCHAR2
    )   return varchar2;

	-- ----------------------------------------------------------------------------
     -- |------------------------------< get_excel_data_header >--------------------------------|
     -- ----------------------------------------------------------------------------
	FUNCTION get_excel_data_header( pv_i_sub_entity varchar2 DEFAULT NULL,
									pv_i_table_name  varchar2 DEFAULT NULL
								   )
	return clob;

	-- ----------------------------------------------------------------------------
     -- |------------------------------< get_FBDI_filenames >--------------------------------|
     -- ----------------------------------------------------------------------------
	PROCEDURE get_FBDI_filenames(pv_i_application_suite IN  VARCHAR2,
                             pv_i_business_entity   IN  VARCHAR2,
                             pv_i_sub_entity        IN  VARCHAR2,
                             pv_o_fbdi_filenames    OUT XMLType);

    FUNCTION get_primary_ledger_id(p_bu_name IN VARCHAR2,p_business_entity VARCHAR2)
    RETURN VARCHAR2;
--
procedure clean_xfm_data
(
    pt_i_xfm_table_id       in number,
    pt_i_xfm_table_name     in varchar2
);
--
END xxmx_utilities_pkg;

/
