create or replace PACKAGE    "XXMX_UTILITIES_PKG" 
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
     **   1.7  26-July-2023 Shireesha TR/       Changes made in procedures   
     **                     Ayush Rathore       xxmx_write_dbcs, xxmx_zip_file and 
     **					                        xxmx_batch_extract_data for Load batching
     **   1.8  18-Aug-2023  Pallavi Kanajar	    Changed to XXMX_READ_DATAFILE Procedure 
	 **   1.9  31-Aug-2023  Shaik Latheef       Modified generate_table_data for batching 
	 **											STG & XFM File Generation
	 **											Added get_batch_status & get_stgxfm_batch_data_count
     **                                         for STG & XFM File Generation
     **   2.0  27-Sep-2023  Shireesha TR/       Added procedures- xxmx_delete_dbfile_nonbatching,XXMX_LOADDB_FILE,XXMX_ZIP_FILE_NONBATCHING
     **   					Ayush Rathore       XXMX_ZIP_FILE_NONBATCHING,XXMX_LOADDB_ORACLEDB_SCH and DELETE_ZIPFILE_NONBATCHING
     **   2.1  13-Oct-2023  Shireesha           Added xxmx_getfile_Status function
     **   2.2  18-oct-2023  Shireesha           Added pt_batch_count in p_extract_data procedure
     **   2.3  19-oct-2023  Shireesha           Added common_load_column_is_null Exception in batch_extract_data procedure 
     **   2.4  30-Oct-2023  Ayush Rathore		Added file_name in ProceduresXXMX_WRITE_DBCS , XXMX_ZIP_FILE , XXMX_Write_ORACLEDB_SCH and xxmx_delete_dbfile for HCM                                        
     **   2.5  02-Nov-2023  Ayush Rathore       Added changes to include Headers in HCM Load files being generated in proc XXMX_WRITE_DBCS , XXMX_ZIP_FILE , xxmx_delete_dbfile
     **   2.6  09-Nov-2023  Shireesha           Added filename changes in procedures-XXMX_WRITE_DBCS , XXMX_ZIP_FILE, xxmx_delete_dbfile
     **						Ayush Rathore		Added filename changes for HCM in procedures-XXMX_WRITE_DBCS , XXMX_ZIP_FILE
     **   2.7  17-NOV-2023  Pallavi 		Changes to Non EBS code
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
                            ,pv_i_filesetid VARCHAR2 DEFAULT NULL
                            ,pt_iteration  VARCHAR2 DEFAULT NULL
							,pt_batch_count NUMBER DEFAULT NULL
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
     -- |------------------------------< get_stgxfm_batch_data_count >--------------------------------|
     -- ----------------------------------------------------------------------------

	FUNCTION get_stgxfm_batch_data_count (
        pv_i_table_name VARCHAR2, pv_i_batch_name VARCHAR2
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
    --
    --
    -- ----------------------------------------------------------------------------
    -- |---------------------< GET_COUNT_FOR_EXTRACT >----------------------------|
    -- ----------------------------------------------------------------------------
    --
    PROCEDURE insert_extract_control (
        p_business_entity  VARCHAR2,
        p_migration_set_id VARCHAR2,
        p_sub_entity       VARCHAR2,
        p_iteration        VARCHAR2
        ,p_extract_start_time timestamp
       ,p_extract_end_time timestamp
    );
    --
    --
    -- ----------------------------------------------------------------------------
    -- |---------------------< GET_COUNT_FOR_TRANSFORM >----------------------------|
    -- ----------------------------------------------------------------------------
    --
    PROCEDURE insert_transform_control (
        p_business_entity  VARCHAR2,
        p_migration_set_id VARCHAR2,
        p_sub_entity       VARCHAR2,
        p_iteration        VARCHAR2
        ,p_transform_start_time timestamp
        ,p_transform_end_time timestamp
    );

    -- ----------------------------------------------------------------------------
    -- |---------------------< GET_COUNT_FOR_TRANSFORM >----------------------------|
    -- ----------------------------------------------------------------------------
    --
    PROCEDURE get_cumulative_counts (
    iter varchar2,
    busn_entity varchar2,
    sb_entity varchar2,
    applction varchar2,
    applcn_suite varchar2,
    extract_cnt out VARCHAR2,
    transform_cnt out VARCHAR2

    );

    -- ----------------------------------------------------------------------------
    -- |---------------------< GET_FUSION_ERROR_COUNT >----------------------------|
    -- Procedure to get cumulative counts for Fusion Error.
    -- ----------------------------------------------------------------------------
    --
    PROCEDURE get_fusion_errCount(itr varchar2, error_count out integer);

    -- ----------------------------------------------------------------------------
    -- |---------------------< CONVERT_TIMEZONE_DASHBOARD >----------------------------|
    -- Procedure to convert timezone to UTC
    -- ----------------------------------------------------------------------------
    --
    PROCEDURE convert_timezone_dashboard (
    time_var IN OUT VARCHAR2,
    timezone VARCHAR2);
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
                     pv_i_application_suite    IN      VARCHAR2
                    ,pt_i_BusinessEntity       IN      xxmx_migration_metadata.business_entity%TYPE
                    ,pt_i_sub_entity           IN      xxmx_migration_metadata.sub_entity%TYPE 
                    ,pt_i_instance_id          IN      xxmx_dm_oic_read_log.instance_id%TYPE DEFAULT NULL
					,pt_i_iteration             IN     VARCHAR2 DEFAULT NULL
                    ,pt_i_FileName              IN      xxmx_migration_metadata.data_file_name%TYPE DEFAULT NULL
                   );

	-- ----------------------------------------------------------------------------
     -- |------------------------------< get_FBDI_filenames >--------------------------------|
     -- ----------------------------------------------------------------------------
	PROCEDURE get_FBDI_filenames(pv_i_application_suite IN  VARCHAR2,
                             pv_i_business_entity   IN  VARCHAR2,
                             pv_i_sub_entity        IN  VARCHAR2,
                             pv_o_fbdi_filenames    OUT XMLType);

  /*
     **************************************
     ** FUNCTION: external_file_exists
     **
     ** Called from each Extract procedure.
     **
     **************************************
     */
     --Added procedure for NON-EBS Clients
     --

      PROCEDURE external_file_exists ( pt_i_ApplicationSuite           IN      xxmx_migration_headers.application_suite%TYPE
                                   ,pt_i_Application                IN      xxmx_migration_headers.application%TYPE
                                   ,pt_i_BusinessEntity             IN      xxmx_migration_headers.business_entity%TYPE
                                   ,pt_i_FileSetID                  IN      xxmx_migration_details.file_set_id%TYPE
                                   ,pv_o_ReturnStatus                  OUT  VARCHAR2
                                   ,pt_o_ReturnMessage                 OUT  xxmx_data_messages.data_message%TYPE);


     /*
     **************************************
     ** FUNCTION: xxmx_read_datafile
     **
     ** Called from each Extract procedure.
     **
     **************************************
     */
     --
        PROCEDURE xxmx_read_datafile(pt_i_ApplicationSuite           IN      xxmx_migration_headers.application_suite%TYPE
                               ,pt_i_Application                IN      xxmx_migration_headers.application%TYPE
                               ,pt_i_BusinessEntity             IN      xxmx_migration_headers.business_entity%TYPE
                               ,pt_i_subEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                               ,pt_i_FileSetID                  IN      xxmx_migration_details.file_set_id%TYPE
                               ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                               ,pv_o_ReturnStatus                  OUT  VARCHAR2
                               ,pt_o_ReturnMessage                 OUT  xxmx_data_messages.data_message%TYPE);
        --End of Added procedure for NON-EBS Clients                             

        FUNCTION XXMX_DM_ESS_SUB_ENTITY( p_businessentity VARCHAR2, p_subentity VARCHAR2) 
       RETURN VARCHAR2;

        PROCEDURE XXMX_COMMIT;

         PROCEDURE   BATCH_CSV_FILE_TEMP_DATA (
                                            p_business_entity IN VARCHAR2,
                                            p_sub_entity IN VARCHAR2 DEFAULT NULL,
                                            p_batch_count IN NUMBER,
                                            p_ct_phase IN VARCHAR2 DEFAULT NULL
                                            );

       PROCEDURE fusion_Customer_batch(p_batch_id VARCHAR2);

       PROCEDURE xxmx_write_dbcs (  pt_i_businessentity IN VARCHAR2, pt_load_fileID number, pt_file_name IN VARCHAR2 DEFAULT NULL) ; -- 2.4                                    

    PROCEDURE xxmx_zip_file (pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                            ,pt_dirname                      IN      VARCHAR2
                            ,pt_load_fileID number
                            ,pt_filename                 IN VARCHAR2 DEFAULT NULL) ;   -- 2.4


      PROCEDURE   batch_extract_data (
            p_application_suite IN VARCHAR2,
            p_business_entity IN VARCHAR2,
            p_sub_entity IN VARCHAR2 DEFAULT NULL,
            p_batch_count IN NUMBER,
            p_ct_phase IN VARCHAR2 DEFAULT 'EXTRACT'
        );

    PROCEDURE XXMX_COMMIT (p_sec IN VARCHAR2);

    procedure XXMX_Write_ORACLEDB_SCH (pt_i_BusinessEntity   IN  xxmx_migration_metadata.business_entity%TYPE
                                        , pt_load_fileID number
                                        ,pt_file_name IN VARCHAR2 DEFAULT NULL);  -- 2.4

    PROCEDURE xxmx_log_oic_status(pt_i_instance_id  IN VARCHAR2,
                                  pt_i_statusmessage IN VARCHAR2,
                                  pt_i_statuscode   IN VARCHAR2);
                                  
    procedure xxmx_delete_dbfile(pt_i_BusinessEntity   IN  xxmx_migration_metadata.business_entity%TYPE
                                ,pt_dirname                      IN      VARCHAR2
                                ,pt_filename IN VARCHAR2 DEFAULT NULL  -- 2.4
                                ,pt_load_fileID IN NUMBER);  -- 2.5
    procedure xxmx_delete_dbfile_nonbatching(pt_i_BusinessEntity   IN  xxmx_migration_metadata.business_entity%TYPE
                                ,pt_dirname                      IN      VARCHAR2)  ;                            
   PROCEDURE xxmx_delete_zipfile(pt_i_BusinessEntity   IN  xxmx_migration_metadata.business_entity%TYPE
                                   ,pt_dirname                      IN      VARCHAR2) ;
  
  PROCEDURE XXMX_LOADDB_FILE (
    pv_i_business_entity IN VARCHAR2,
    pv_i_subentity       IN VARCHAR2,
    pv_i_file_name       IN VARCHAR2,
    pv_i_data_file       IN VARCHAR2,
    pv_i_load_file_id    IN VARCHAR2);
    
    PROCEDURE XXMX_ZIP_FILE_NONBATCHING (
    pt_i_businessentity IN xxmx_migration_metadata.business_entity%TYPE,
    pt_i_subentity      IN xxmx_migration_metadata.sub_entity%TYPE DEFAULT NULL,
    pt_dirname          IN VARCHAR2,
    pv_i_file_name      IN VARCHAR2 DEFAULT NULL,
    pt_i_load_file_id   IN NUMBER);

   procedure XXMX_LOADDB_ORACLEDB_SCH ( pv_i_business_entity IN VARCHAR2,
    pv_i_subentity       IN VARCHAR2,
    pv_i_file_name       IN VARCHAR2,
    pv_i_data_file       IN VARCHAR2,
    pv_i_load_file_id    IN VARCHAR2);

    procedure DELETE_ZIPFILE_NONBATCHING(pv_i_business_entity varchar2);
                                                          
   FUNCTION get_primary_ledger_id (p_bu_name IN VARCHAR2, p_business_entity IN VARCHAR2)
   RETURN VARCHAR2;
   FUNCTION xxmx_load_file_status (pt_i_instance_id IN VARCHAR2)
   Return VARCHAR2;
   
   FUNCTION  xxmx_getfile_Status ( pv_i_load_file_id VARCHAR2)
   RETURN VARCHAR2;
   	FUNCTION get_batch_status (p_business_entity IN VARCHAR2)
	Return VARCHAR2;
END xxmx_utilities_pkg;
/
show errors package xxmx_utilities_pkg;
/
--
--
--
create or replace PACKAGE BODY "XXMX_UTILITIES_PKG" 
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
          v_debug_message                          VARCHAR2(5);
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

          v_debug_message := xxmx_utilities_pkg.get_single_parameter_value
                                                              (
                                                               pt_i_ApplicationSuite          => 'XXMX'
                                                              ,pt_i_Application               => 'XXMX'
                                                              ,pt_i_BusinessEntity            => 'ALL'
                                                              ,pt_i_SubEntity                 => 'ALL'
                                                              ,pt_i_ParameterCode             => 'DEBUG'
                                                              );

          IF( v_debug_message = 'Y' AND  UPPER(pt_i_Severity) IN ('NOTIFICATION')) THEN
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
          ELSIF( UPPER(pt_i_Severity) IN ('WARNING', 'ERROR'))THEN
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
          END IF;
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
          v_debug_message                           VARCHAR2(5);
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

          v_debug_message := xxmx_utilities_pkg.get_single_parameter_value
                                                              (
                                                               pt_i_ApplicationSuite          => 'XXMX'
                                                              ,pt_i_Application               =>'XXMX'
                                                              ,pt_i_BusinessEntity            => 'ALL'
                                                              ,pt_i_SubEntity                 => 'ALL'
                                                              ,pt_i_ParameterCode             => 'DEBUG'
                                                              );

          IF( v_debug_message = 'Y' AND  UPPER(pt_i_Severity) IN ('NOTIFICATION')) THEN
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
          ELSIF( UPPER(pt_i_Severity) IN ('WARNING', 'ERROR'))THEN
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
          END IF;
          --

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
          AND    XMM.ENABLED_FLAG = 'Y'
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
          AND  ((xst.application_suite  = pt_i_ApplicationSuite AND xst.application = pt_i_Application) OR
                (xst.application_suite  = pt_i_ApplicationSuite AND xst.application = 'ALL'))
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
          AND  ((xst.application_suite  = pt_i_ApplicationSuite AND xst.application = pt_i_Application) OR
                (xst.application_suite  = pt_i_ApplicationSuite AND xst.application = 'ALL'))          
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
               --RAISE e_ModuleError;
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
          vt_MigrationSetID               xxmx_migration_details.migration_set_id%TYPE;
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
                    SELECT migration_set_id
                    INTO   vt_MigrationSetID
                    FROM   xxmx_migration_headers
                    WHERE  1 = 1
                    AND BUSINESS_ENTITY = UPPER(pt_i_BusinessEntity)
                    AND    file_set_id = pt_i_FileSetID;
                    --
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
                               ,vt_MigrationSetID               -- migration_set_id          
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

                    SELECT migration_set_id
                    INTO   vt_MigrationSetID
                    FROM   xxmx_migration_headers
                    WHERE  1 = 1
                    AND BUSINESS_ENTITY = UPPER(pt_i_BusinessEntity)
                    AND    file_set_id = pt_i_FileSetID;

                    UPDATE xxmx_migration_details
                    SET migration_set_id= vt_MigrationSetID
                    WHERE file_set_id=pt_i_FileSetID
                    AND business_entity=pt_i_BusinessEntity
                    AND sub_entity=pt_i_SubEntity
                    and Application = pt_i_Application;

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
                    ,pt_i_Severity          => 'NOTIFICATION'
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
                    AND  ((xst.application_suite  = pt_i_ApplicationSuite AND xst.application = pt_i_Application) OR
                            (xst.application_suite  = pt_i_ApplicationSuite AND xst.application = 'ALL'))
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
                         AND  ((xst.application_suite  = pt_i_ApplicationSuite AND xst.application = pt_i_Application) OR
                            (xst.application_suite  = pt_i_ApplicationSuite AND xst.application = 'ALL'))
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
          vt_MigrationSetID               xxmx_migration_details.migration_set_id%TYPE;
          lv_exists                       NUMBER := NULL;
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
          SELECT xxmx_migration_set_ids_s.NEXTVAL
          INTO   vt_MigrationSetID
          FROM   dual;
          --
          --
          gvv_ProgressIndicator := '0010';

          --
          Select count(1)
          INTO lv_exists
          FROM xxmx_migration_headers
          WHERE File_set_id = pt_i_FileSetID
          AND Business_entity = pt_i_BusinessEntity 
          AND application_suite =  UPPER(pt_i_ApplicationSuite)  -- application_suite
          AND application = UPPER(pt_i_Application) 
          AND phase = 'EXTRACT'   ;


          IF( lv_exists IS NOT NULL and lv_exists =  1 ) 
          THEN 
            UPDATE xxmx_migration_headers
            SET migration_set_id= vt_MigrationSetID
            ,migration_set_name = pt_o_MigrationSetName
            WHERE File_set_id = pt_i_FileSetID
            AND Business_entity = pt_i_BusinessEntity 
            AND application_suite =  UPPER(pt_i_ApplicationSuite)  -- application_suite
            AND application = UPPER(pt_i_Application) 
            AND phase = 'EXTRACT' ;
        ELSIF (lv_exists >  1 ) THEN
             log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => gct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => 'Nultiple Entries in Migration Header for '||pt_i_FileSetID
                         ,pt_i_OracleError       => NULL
                         );
        ELSE 
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
                      ,vt_MigrationSetID             -- migration_set_id
                      ,pt_o_MigrationSetName         -- migration_set_name
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
						,pv_i_filesetid VARCHAR2 DEFAULT NULL
                        ,pt_iteration  VARCHAR2 DEFAULT NULL
						,pt_batch_count NUMBER DEFAULT NULL
						)
IS 
l_stg_table VARCHAR2(50);
l_migration_Set_id number;
l_SQL VARCHAR2(500);
BEGIN

	IF upper(pv_i_stage) = 'EXTRACT'
	 THEN 
	--
		IF pv_i_application_suite IN( 'FIN','SCM','PPM')
		 THEN
                dbms_scheduler.create_job (
                job_name   =>  pv_i_application_suite||'_'||pv_i_business_entity||'_'||pv_i_stage||'_'||pv_i_filesetid,
                job_type   => 'PLSQL_BLOCK',
                job_action => 
                'BEGIN 
                 XXMX_FIN_STG_EXTRACT_PKG.stg_main ( 
                                 pt_i_BusinessEntity           => '''||pv_i_business_entity||'''
                                ,pt_i_filesetid                => '''||pv_i_filesetid||'''
                                ,pt_iteration                  => '''||pt_iteration||''' 
								,pt_batch_count                => '''||pt_batch_count||'''
--                  
                                            ) ;
                 END;',
                enabled   =>  TRUE,  
                auto_drop =>  TRUE, 
                comments  =>  'Run '||pv_i_application_suite||'_'||pv_i_business_entity||'_'||pv_i_stage||'_'||pv_i_filesetid); 
        ELSIF pv_i_application_suite IN('OLC', 'HCM','PAY','IREC')
		 THEN
                dbms_scheduler.create_job (
                job_name   =>  pv_i_application_suite||'_'||pv_i_business_entity||'_'||pv_i_stage||'_'||pv_i_filesetid,
                job_type   => 'PLSQL_BLOCK',
                job_action => 
                'BEGIN 
                 XXMX_HCM_STG_EXTRACT_PKG.stg_main ( 
                                 pt_i_BusinessEntity           => '''||pv_i_business_entity||'''
                                ,pt_i_filesetid                => '''||pv_i_filesetid||'''
                                            ) ;
                 END;',
                enabled   =>  TRUE,  
                auto_drop =>  TRUE, 
                comments  =>  'Run '||pv_i_application_suite||'_'||pv_i_business_entity||'_'||pv_i_stage||'_'||pv_i_filesetid); 
		END IF;
	--					
	ELSIF upper(pv_i_stage) = 'TRANSFORM' 
	 THEN 
	--
            SELECT stg_table
            INTO l_stg_table
            FROM xxmx_migration_metadata
            WHERE business_entity = pv_i_business_entity
           -- AND enabled_flag = 'Y'
            AND sub_entity_seq IN( 
                                SELECT MIN(sub_entity_seq)
                                FROM xxmx_migration_metadata
                                WHERE business_entity = pv_i_business_entity
                                AND enabled_flag = 'Y');

            l_sql := 'select MAX(migration_Set_id) from XXMX_STG.'||l_stg_table;

            EXECUTE IMMEDIATE l_sql INTO l_migration_Set_id; 

             IF(l_migration_Set_id IS NULL)
                THEN
                    BEGIN
                    Select distinct max(MIGRATION_SET_ID)
                    INTO l_migration_Set_id
                    from xxmx_migration_headers
                    where business_entity = pv_i_business_entity;
            EXCEPTION
                WHEN OTHERS THEN
                    l_migration_Set_id := NULL;
                END;

            END IF;  

            IF pv_i_application_suite IN ( 'FIN','SCM','PPM')
            THEN
                    dbms_scheduler.create_job (
                    job_name   =>  pv_i_application_suite||'_'||pv_i_business_entity||'_'||pv_i_stage,
                    job_type   => 'PLSQL_BLOCK',
                    job_action => 
                    'BEGIN 
                     XXMX_FIN_STG_EXTRACT_PKG.xfm_main ( 
                                     pt_i_BusinessEntity           => '''||pv_i_business_entity||'''
                                    ,pt_i_filesetid                =>'''||pv_i_filesetid||'''
                                    ,pt_i_MigrationSetID           => '''||l_migration_Set_id||'''
                                    ,pt_iteration                  => '''||pt_iteration||''') ;
                     END;',
                    enabled   =>  TRUE,  
                    auto_drop =>  TRUE, 
                    comments  =>  'Run '||pv_i_application_suite||'_'||pv_i_business_entity||'_'||pv_i_stage||'_'||pv_i_filesetid); 
                    --
        ELSIF pv_i_application_suite IN('OLC','HCM','PAY','IREC')
            THEN
                    dbms_scheduler.create_job (
                    job_name   =>  pv_i_application_suite||'_'||pv_i_business_entity||'_'||pv_i_stage,
                    job_type   => 'PLSQL_BLOCK',
                    job_action => 
                    'BEGIN 
                    XXMX_HCM_STG_EXTRACT_PKG.xfm_main ( 
                         pt_i_BusinessEntity           => '''||pv_i_business_entity||'''
                        ,pt_i_filesetid                => '''||pv_i_filesetid||'''
                        ,pt_i_MigrationSetID   => '''||l_migration_Set_id||'''
                                    ) ;
                    END;',
                    enabled   =>  TRUE,  
                    auto_drop =>  TRUE, 
                    comments  =>  'Run '||pv_i_application_suite||'_'||pv_i_business_entity||'_'||pv_i_stage||'_'||pv_i_filesetid); 
                    --
            END IF; -- pv_i_application_suite IN ( 'FIN','SCM','PPM')
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
        IF pv_i_application_suite = 'FIN' OR pv_i_application_suite='SCM' OR pv_i_application_suite='PPM'
          THEN
        SELECT COUNT(*)
           INTO l_count 
           FROM xxmx_csv_file_temp
          WHERE file_name =  pv_i_filename
          AND line_type <> 'File Header';  
        ELSIF pv_i_application_suite = 'HCM'
          THEN          
            SELECT COUNT(*)
               INTO l_count
               FROM xxmx_hdl_file_temp
              WHERE file_name =  REPLACE(pv_i_filename,'.dat','')
              ;
              -- Added Replace function to remove .dat from FileName
            --  AND line_type <> 'File Header';    
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
---
   FUNCTION get_stgxfm_batch_data_count (
        pv_i_table_name VARCHAR2,
		pv_i_batch_name VARCHAR2
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
            table_name = pv_i_table_name
		AND batch_name = pv_i_batch_name;
        RETURN l_count;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN l_count;
    END get_stgxfm_batch_data_count;
---

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
        v_schema VARCHAR2(10):=NULL;
	lv_tab_exists  VARCHAR2(10);
	lv_migration_set_id NUMBER:= 0;


        CURSOR CUR_COLUMNS
        IS
            SELECT CASE  WHEN DATA_TYPE = 'CLOB' THEN 
                    'dbms_lob.SUBSTR('||COLUMN_NAME||',10000)'
                    WHEN DATA_TYPE = 'BLOB' THEN 
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
                     WHEN DATA_TYPE = 'BLOB' THEN 
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
        gvv_ProgressIndicator := '0005';
	lv_migration_set_id:= NULL;
	lv_tab_exists := 'N';

	BEGIN 
	    SELECT DISTINCT 'Y'
	    INTO lv_tab_exists
	    FROM all_tab_columns 
	    where table_name = UPPER(pv_i_table_name);
	EXCEPTION
	   WHEN OTHERS THEN 
    	      lv_tab_exists := 'N';
	      xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => 'XXMX'
                         ,pt_i_Application         => 'XXMX'
                         ,pt_i_BusinessEntity      => 'XXMX_CORE'
                         ,pt_i_SubEntity           => 'XXMX_UTILITIES'
                         ,pt_i_MigrationSetID      => 0
                         ,pt_i_Phase               => 'EXTRACT'
                         ,pt_i_Severity            => 'NOTIFICATION'
                         ,pt_i_PackageName         => 'XXMX_UTILITIES_PKG'
                         ,pt_i_ProcOrFuncName      => 'insert_into_arch_table'
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => pv_i_table_name||' does not exist'
                         ,pt_i_OracleError         => SUBSTR(SQLCODE||' '||SQLERRM,1,1000)
                         );
	END;

	gvv_ProgressIndicator := '0010';
	
	BEGIN 
	    l_sql := 'SELECT max(migration_set_id) FROM '||pv_i_table_name ;
	    EXECUTE IMMEDIATE l_sql INTO  lv_migration_set_id;

	EXCEPTION
	   WHEN OTHERS THEN 
    	      lv_migration_set_id:= NULL;
	      xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => 'XXMX'
                         ,pt_i_Application         => 'XXMX'
                         ,pt_i_BusinessEntity      => 'XXMX_CORE'
                         ,pt_i_SubEntity           => 'XXMX_UTILITIES'
                         ,pt_i_MigrationSetID      => 0
                         ,pt_i_Phase               => 'EXTRACT'
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => 'XXMX_UTILITIES_PKG'
                         ,pt_i_ProcOrFuncName      => 'insert_into_arch_table'
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => pv_i_table_name||' does not exist'
                         ,pt_i_OracleError         => SUBSTR(SQLCODE||' '||SQLERRM,1,1000)
                         );
	    Raise;
	END;

	IF( lv_migration_set_id IS NOT NULL AND NVL(lv_tab_exists,'N') = 'Y')
	THEN
            FOR rec IN  CUR_COLUMNS
        	LOOP
	         gvv_ProgressIndicator := '0006';
	         IF( v_column_lst is NULL) THEN
                gvv_ProgressIndicator := '0007';
                v_column_lst:= rec.COLUMN_NAME;
                v_tblcolumn_lst := rec.TBL_COLUMN_NAME;
              ELSE 
                gvv_ProgressIndicator := '0008';
                v_column_lst := v_column_lst ||' , '||rec.COLUMN_NAME;
                v_tblcolumn_lst := v_tblcolumn_lst||' , '||rec.TBL_COLUMN_NAME;
              END IF;    

          END LOOP;
         
         gvv_ProgressIndicator := '0015';
         
         --dbms_output.put_line(v_column_lst);
         IF( UPPER(pv_i_table_name) LIKE '%_STG') THEN 
            v_schema := 'XXMX_STG';
         ELSIF( UPPER(pv_i_table_name) LIKE '%_XFM') THEN 
            v_schema := 'XXMX_XFM';
         END IF; 

         l_sql :=   'INSERT INTO '
                         || v_schema||'.'||UPPER(pv_i_table_name)
                         || '_ARCH (' 
                         ||v_tblcolumn_lst
                         || ') (SELECT '
                         || v_column_lst
                         ||' FROM '
                         || v_schema||'.'||UPPER(pv_i_table_name)
                         || ' MINUS SELECT '
                         || v_column_lst
                         ||' FROM '
                          || v_schema||'.'||UPPER(pv_i_table_name)
                         || '_ARCH) ';
         gvv_ProgressIndicator := '0016';
            --dbms_output.put_line(' ');
            --dbms_output.put_line(l_sql);

	  xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => 'XXMX'
                         ,pt_i_Application         => 'XXMX'
                         ,pt_i_BusinessEntity      => 'XXMX_CORE'
                         ,pt_i_SubEntity           => 'XXMX_UTILITIES'
                         ,pt_i_MigrationSetID      => 0
                         ,pt_i_Phase               => 'EXTRACT'
                         ,pt_i_Severity            => 'NOTIFICATION'
                         ,pt_i_PackageName         => 'XXMX_UTILITIES_PKG'
                         ,pt_i_ProcOrFuncName      => 'insert_into_arch_table'
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => SUBSTR(l_sql,1,4000)
                         ,pt_i_OracleError         => SUBSTR(SQLCODE||' '||SQLERRM,1,1000)
                         );
                         
            xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => 'XXMX'
                         ,pt_i_Application         => 'XXMX'
                         ,pt_i_BusinessEntity      => 'XXMX_CORE'
                         ,pt_i_SubEntity           => 'XXMX_UTILITIES'
                         ,pt_i_MigrationSetID      => 0
                         ,pt_i_Phase               => 'EXTRACT'
                         ,pt_i_Severity            => 'NOTIFICATION'
                         ,pt_i_PackageName         => 'XXMX_UTILITIES_PKG'
                         ,pt_i_ProcOrFuncName      => 'insert_into_arch_table'
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => SUBSTR(l_sql,4001,3900)
                         ,pt_i_OracleError         => SUBSTR(SQLCODE||' '||SQLERRM,1,1000)
                         );                         

         EXECUTE IMMEDIATE l_sql;
         
         gvv_ProgressIndicator := '0020';
     END IF; -- IF( lv_migration_set_id IS NOT NULL AND NVL(lv_tab_exists,'N') = 'Y')
    EXCEPTION
        WHEN OTHERS THEN
        xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => 'XXMX'
                         ,pt_i_Application         => 'XXMX'
                         ,pt_i_BusinessEntity      => 'XXMX_CORE'
                         ,pt_i_SubEntity           => 'XXMX_UTILITIES'
                         ,pt_i_MigrationSetID      => 0
                         ,pt_i_Phase               => 'EXTRACT'
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => 'XXMX_UTILITIES_PKG'
                         ,pt_i_ProcOrFuncName      => 'insert_into_arch_table'
                         ,pt_i_ProgressIndicator   => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage       => pv_i_table_name
                         ,pt_i_OracleError         => SUBSTR(SQLCODE||' '||SQLERRM,1,1000)
                         );
         RAISE;                

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
        IF UPPER(pv_i_table_name) LIKE '%STG' THEN
       EXECUTE IMMEDIATE 'DELETE FROM XXMX_STG.' || pv_i_table_name;
            --EXECUTE IMMEDIATE 'TRUNCATE TABLE XXMX_STG.' || pv_i_table_name; 
        ELSIF upper(pv_i_table_name) LIKE '%XFM' THEN
        EXECUTE IMMEDIATE 'DELETE FROM XXMX_XFM.' || pv_i_table_name;
           -- EXECUTE IMMEDIATE 'TRUNCATE TABLE XXMX_XFM.' || pv_i_table_name;
       COMMIT;
        end if;
    END truncate_table;
--
--
-- ----------------------------------------------------------------------------
-- |-------------------------< GENERATE_TABLE_DATA >--------------------------|
-- ----------------------------------------------------------------------------
  /*  PROCEDURE generate_table_data (
        pv_i_table_name IN VARCHAR2
    ) IS
*/
      /*  v_finaltxt          VARCHAR2(20000);
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
            l_sql := 'select * from '
                     || pv_i_table_name
                     || ' where migration_set_id = (select max(migration_set_id) from '
                     || pv_i_table_name
                     || ' )';


--
        c := dbms_sql.open_cursor;
        dbms_sql.parse(c, l_sql, dbms_sql.native);

        d := dbms_sql.execute(c);

        dbms_sql.describe_columns(c, col_cnt, rec_tab);

--        dbms_output.put_line(col_cnt);
--        dbms_output.put_line(d);
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
           -- dbms_output.put_line(v_ret);
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
*/
     PROCEDURE generate_table_data (
        pv_i_table_name IN VARCHAR2
     ) IS
        v_finaltxt          VARCHAR2(32000);
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

        TYPE t_stg_xfm_data IS TABLE OF XXMX_DM_STG_XFM_DATA%rowtype INDEX BY PLS_INTEGER;
        p_stg_xfm_data   t_stg_xfm_data;
        tab_count           NUMBER := 0;
        v_schema VARCHAR2(10):=NULL;
        v_column_lst  long := NULL;

        type exrtact_cursor_type IS REF CURSOR;
        CUR                        exrtact_cursor_type;
        TYPE extract_data IS TABLE OF VARCHAR2(8000) INDEX BY BINARY_INTEGER;
        g_extract_data  extract_data;
        type p_rowid is table of varchar2(1000) index by binary_integer;
        v_rowid                 p_rowid;

        vv_column_name                       VARCHAR2(1000);
        v_seq_in_fbdi                        VARCHAR2(400);
        v_batch_load                         VARCHAR2(10);

        CURSOR CUR_COLUMNS
        IS
            SELECT CASE  WHEN DATA_TYPE = 'CLOB' THEN
                    'dbms_lob.SUBSTR('||COLUMN_NAME||',10000)'
                    ELSE
                        COLUMN_NAME
                    END COLUMN_NAME
                ,column_name TBL_COLUMN_NAME
                ,STG_COLUMN_SEQ SEQ
                ,DATA_TYPE
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
                ,DATA_TYPE
            FROM XXMX_XFM_TABLES a, XXMX_XFM_TABLE_COLUMNS B
            WHERE a.xfm_table_id = b.xfm_table_id
            and a.table_name =UPPER(pv_i_table_name)
            ORDER BY SEQ;
            
            p_application_suite VARCHAR2(10);
            p_batch_col VARCHAR2(25);

    BEGIN

        DELETE FROM XXMX_DM_STG_XFM_DATA where table_name = pv_i_table_name;
        DELETE FROM XXMX_DM_STG_XFM_HEADER where table_name = pv_i_table_name;
        
        BEGIN 
            SELECT DISTINCT application_suite
            INTO p_application_suite
            from XXMX_MIGRATION_METADATA
            where (stg_table = pv_i_table_name
            OR xfm_table = pv_i_table_name);
        EXCEPTION
            WHEN OTHERS THEN 
                p_application_suite := NULL;
        END;

        BEGIN 
            SELECT BATCH_LOAD
            INTO v_batch_load
            FROM xxmx_migration_metadata
            WHERE (UPPER(stg_table) =UPPER(pv_i_table_name)
            OR UPPER(xfm_table) =UPPER(pv_i_table_name) )
            AND ENABLED_FLAG= 'Y';
        EXCEPTION
         WHEN OTHERS THEN 
                v_batch_load:= 'N';
        END;
        if( p_application_suite IN('FIN','SCM','PPM'))
        THEN
            p_batch_col:= 'Load_Batch';
        ELSE 
            p_batch_col:='Batch_name';
        END IF;


        IF UPPER(pv_i_table_name) LIKE '%STG' THEN
            v_schema:= 'XXMX_STG' ;
        ELSIF upper(pv_i_table_name) LIKE '%XFM' THEN
           v_schema:= 'XXMX_XFM' ;
        end if;

        FOR rec IN  CUR_COLUMNS
            LOOP
                IF rec.data_type = 'DATE' THEN
                        vv_column_name := 'to_char('||rec.COLUMN_NAME||',''YYYY/MM/DD'')';
                ELSIF rec.data_type IN ('VARCHAR2','CHAR') THEN
                        vv_column_name := '''"''||'||rec.COLUMN_NAME||'||''"''';
                ELSE
                        vv_column_name := rec.COLUMN_NAME;
                END IF;
                IF( v_column_lst is NULL) THEN
                    v_column_lst:= vv_column_name;
                ELSE

                    v_column_lst :=v_column_lst|| '||'''||','||''''||'||'||vv_column_name;

                END IF;

                v_finaltxt := ltrim(v_finaltxt
                                    || ','
                                    || upper(rec.COLUMN_NAME), ','
                                    );
        END LOOP;

            --DBMS_OUTPUT.PUT_LINE(v_column_lst);
            INSERT INTO XXMX_DM_STG_XFM_HEADER VALUES (
                pv_i_table_name,
                v_finaltxt
            );

        IF( V_BATCH_LOAD= 'Y') THEN 
            OPEN CUR FOR   'select '||v_column_lst ||' , '||'NVL('||p_batch_col||',''NULL'')'||' from '
                                 ||v_schema||'.'|| pv_i_table_name;
            LOOP                             
               FETCH   CUR BULK COLLECT INTO g_extract_data,v_rowid LIMIT 20000;
            EXIT WHEN g_extract_data.COUNT=0;

            FORALL i IN 1..g_extract_data.count

               INSERT INTO XXMX_DM_STG_XFM_DATA values(pv_i_table_name,g_extract_data(i), v_rowid(i));
               commit;        

            END LOOP;                
            close CUR;            
        ELSE 
          OPEN CUR FOR   'select '||v_column_lst ||' from '
                                 ||v_schema||'.'|| pv_i_table_name;
            LOOP                             
               FETCH   CUR BULK COLLECT INTO g_extract_data LIMIT 20000;
            EXIT WHEN g_extract_data.COUNT=0;

            FORALL i IN 1..g_extract_data.count

               INSERT INTO XXMX_DM_STG_XFM_DATA(TABLE_NAME,TABLE_DATA) values(pv_i_table_name,g_extract_data(i));
               commit;        

            END LOOP;                
            close CUR;    
        END IF;
--
    END generate_table_data;

--
--
-- ----------------------------------------------------------------------------
-- |---------------------< GET_COUNT_FOR_EXTRACT >----------------------------|
-- Procedure inserts count into Maximise Control Tables.
-- ----------------------------------------------------------------------------
--
     PROCEDURE insert_extract_control( p_business_entity VARCHAR2
                                     ,p_migration_set_id VARCHAR2
                                     ,p_sub_entity VARCHAR2
                                     ,p_iteration VARCHAR2
                                     ,p_extract_start_time timestamp
                                     ,p_extract_end_time timestamp)
    AS

    v_sql VARCHAR2(32000);
    v_extract_count NUMBER;
    CURSOR c_details is
        SELECT stg_table
              ,application_suite
              ,application
        FROM  xxmx_migration_metadata
        WHERE  business_entity = p_business_entity
        AND sub_entity = p_sub_entity;
    BEGIN
    dbms_output.put_line(p_extract_start_time);
   dbms_output.put_line(p_extract_end_time);
    FOR r_details IN c_details
    LOOP
        v_sql:='select count(*) from '|| r_details.stg_table||' where migration_set_id=' || p_Migration_set_id;
        dbms_output.put_line(v_sql);
        EXECUTE IMMEDIATE v_sql INTO v_extract_count;
        v_sql:= 'INSERT  INTO xxmx_core.xxmx_dm_dashboard_cntl
        (ID,
        INSTANCE_ID,
        ITERATION,
        OIC_USER_NAME,
        APPLICATION_SUITE,
        APPLICATION,
        BUSINESS_ENTITY,
        SUB_ENTITY,
        MIGRATION_SET_ID,
        EXTRACT_COUNT,
        TRANSFORM_COUNT,
        LOAD_COUNT,
        FUSION_ERROR_COUNT,
        CREATED_BY,
        CREATION_DATE,
        LAST_UPDATED_BY,
        LAST_UPDATED_DATE,
        LAST_UPDATED_LOGIN,
        REQUEST_ID,
        IMPORT_SUCCESS_COUNT,
        EXTRACT_START_TIME,
        EXTRACT_END_TIME)
        VALUES (XXMX_DASHBOARD_CNTL_IDS_S.nextval,'
                || 'null'
                ||','
                ||''''
                ||p_iteration
                ||''''
                ||','
                ||'null'
                || ','
                ||''''
                || r_details.application_suite
                ||''''
                || ','
                ||''''
                || r_details.application
                ||''''
                || ','
                ||''''
                || p_business_entity
                ||''''
                || ','
                ||''''
                || p_sub_entity
                ||''''
                || ','
                || p_migration_set_id
                || ','
                || v_extract_count
                || ','
                || 'null,null,null'
                || ','
                || '-1'
                || ','
                || 'sysdate'
                || ','
                || '-1'
                || ','
                || 'sysdate'
                || ','
                || '-1'
                || ','
                || 'NULL'
                || ','
                || 'NULL'
                || ','
                ||'''' 
                || to_char(p_extract_start_time, 'DD-MON-RRRR HH24:MI:SS')
                ||''''
                || ','
                ||'''' 
                || to_char(p_extract_end_time, 'DD-MON-RRRR HH24:MI:SS')
                ||''''
                || ')'

                ;        
         EXECUTE IMMEDIATE  v_sql; 
        dbms_output.put_line(v_sql);
        COMMIT;
    END LOOP;
    EXCEPTION
        WHEN OTHERS THEN
        xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => 'XXMX'
                         ,pt_i_Application         => 'XXMX'
                         ,pt_i_BusinessEntity      => 'XXMX_CORE'
                         ,pt_i_SubEntity           => 'XXMX_UTILITIES'
                         ,pt_i_MigrationSetID      => 0
                         ,pt_i_Phase               => 'EXTRACT'
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => 'XXMX_UTILITIES_PKG'
                         ,pt_i_ProcOrFuncName      => 'insert_extract_control'
                         ,pt_i_ProgressIndicator   => '0000'
                         ,pt_i_ModuleMessage       => NULL
                         ,pt_i_OracleError         => SUBSTR(SQLCODE||' '||SQLERRM,1,1000)
                         );
         RAISE;                
    END insert_extract_control;

--
--
-- ----------------------------------------------------------------------------
-- |---------------------< GET_COUNT_FOR_TRANSFORM >----------------------------|
-- Procedure inserts count into Maximise Control Tables.
-- ----------------------------------------------------------------------------
--
      PROCEDURE insert_transform_control( p_Business_entity VARCHAR2
                                        ,p_Migration_set_id VARCHAR2
                                        ,p_sub_entity VARCHAR2
                                        ,p_iteration VARCHAR2
                                        ,p_transform_start_time timestamp
                                        ,p_transform_end_time timestamp)
    as
        v_sql VARCHAR2(32000);
        v_transform_count NUMBER;

        CURSOR c_details IS
        SELECT  xfm_table
                ,application_suite
                ,application
        FROM  xxmx_migration_metadata
        WHERE  business_entity = p_business_entity
        AND sub_entity = p_sub_entity;
    BEGIN
        FOR r_details IN c_details
        LOOP
            v_sql:='select count(*) from '|| r_details.XFM_table||' where migration_set_id=' || p_Migration_set_id;
            EXECUTE IMMEDIATE v_sql INTO v_transform_count;
            v_sql:= 'UPDATE XXMX_DM_DASHBOARD_CNTL SET TRANSFORM_COUNT='
                    ||v_transform_count
                    ||','
                    ||'TRANSFORM_START_TIME'
                    ||'='
                    ||''''
                    ||to_char(p_transform_start_time, 'DD-MON-RRRR HH24:MI:SS')
                    ||''''
                    ||','
                    ||'TRANSFORM_END_TIME'
                    ||'='
                    ||''''
                    ||to_char(p_transform_end_time, 'DD-MON-RRRR HH24:MI:SS')
                    ||''''
                    ||' where MIGRATION_SET_ID='
                    ||p_Migration_set_id
                    ||' AND SUB_ENTITY= '
                    ||''''
                    ||p_sub_entity
                    ||''''
                    ||'AND ITERATION ='
                    ||''''
                    ||p_iteration
                    ||''''
                    ; 

             EXECUTE IMMEDIATE  v_sql; 
            dbms_output.put_line(v_sql);
            COMMIT;
        END loop;

   EXCEPTION
        WHEN OTHERS THEN
        xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => 'XXMX'
                         ,pt_i_Application         => 'XXMX'
                         ,pt_i_BusinessEntity      => 'XXMX_CORE'
                         ,pt_i_SubEntity           => 'XXMX_UTILITIES'
                         ,pt_i_MigrationSetID      => 0
                         ,pt_i_Phase               => 'TRANSFORM'
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => 'XXMX_UTILITIES_PKG'
                         ,pt_i_ProcOrFuncName      => 'insert_transform_control'
                         ,pt_i_ProgressIndicator   => '0000'
                         ,pt_i_ModuleMessage       => NULL
                         ,pt_i_OracleError         => SUBSTR(SQLCODE||' '||SQLERRM,1,1000)
                         );
         RAISE;                
    END insert_transform_control;

--
-- ----------------------------------------------------------------------------
-- |---------------------< GET_CUMULATIVE_COUNTS >----------------------------|
-- Procedure to get cumulative counts for Extract and Transform in Dashboard.
-- ----------------------------------------------------------------------------
--
 PROCEDURE get_cumulative_counts (
    iter varchar2,
    busn_entity varchar2,
    sb_entity varchar2,
    applction varchar2,
    applcn_suite varchar2,
    extract_cnt out VARCHAR2,
    transform_cnt out VARCHAR2

    ) AS

BEGIN
/* If condition to get count for Application_suite */ 
 if applcn_suite is not null and applction IS NULL AND sb_entity is null  AND busn_entity IS NULL AND ITER IS NOT NULL THEN
   SELECT
    nvl(to_char((round((SUM(extract_count)
                       ) / power(1000,
                                    trunc(log(1000,
                                              (nullif(SUM(extract_count),0)
                                                  )))),
                   1)
             || substr(' KMGTPEZY',
                       trunc(log(1000,
                                 (nullif(SUM(extract_count),0)
                                     ))) + 1,
                       1))),0),
    nvl(to_char((round((SUM(transform_count)
                       ) / power(1000,
                                    trunc(log(1000,
                                              (nullif(SUM(transform_count),0)
                                                  )))),
                   1)
             || substr(' KMGTPEZY',
                       trunc(log(1000,
                                 (nullif(SUM(transform_count),0)
                                     ))) + 1,
                       1))),0)
INTO
    extract_cnt,
    transform_cnt
FROM
    (
        SELECT
            business_entity,
            sub_entity,
            iteration,
            MAX(migration_set_id) migration_set_id
        FROM
            xxmx_dm_dashboard_cntl
        GROUP BY
            business_entity,
            sub_entity,iteration
    )                      a,
    xxmx_dm_dashboard_cntl b
WHERE
        a.migration_set_id = b.migration_set_id
    AND a.sub_entity = b.sub_entity
    AND b.iteration = iter
    AND b.application_suite=applcn_suite
    and a.iteration=b.iteration
    AND a.business_entity = b.business_entity;

    dbms_output.put_line('APPLICATION_SUITE');

/* elsif condition to get count for APPLICATION*/    

ELSif  applction is not null AND busn_entity IS NULL AND sb_entity IS NULL then 

SELECT     nvl(to_char((round((SUM(extract_count)
                       ) / power(1000,
                                    trunc(log(1000,
                                              (nullif(SUM(extract_count),0)
                                                  )))),
                   1)
             || substr(' KMGTPEZY',
                       trunc(log(1000,
                                 (nullif(SUM(extract_count),0)
                                     ))) + 1,
                       1))),0),
    nvl(to_char((round((SUM(transform_count)
                       ) / power(1000,
                                    trunc(log(1000,
                                              (nullif(SUM(transform_count),0)
                                                  )))),
                   1)
             || substr(' KMGTPEZY',
                       trunc(log(1000,
                                 (nullif(SUM(transform_count),0)
                                     ))) + 1,
                       1))),0)             
INTO
    extract_cnt,
    transform_cnt
FROM
    (
        SELECT
            business_entity,
            sub_entity,
            iteration,
            MAX(migration_set_id) migration_set_id
        FROM
            xxmx_dm_dashboard_cntl
        GROUP BY
            business_entity,
            sub_entity,iteration
    )                      a,
    xxmx_dm_dashboard_cntl b
WHERE
        a.migration_set_id = b.migration_set_id
    AND a.sub_entity = b.sub_entity
    AND b.iteration = iter 
    and b.APPLICATION= applction
    and a.iteration=b.iteration
    AND a.business_entity = b.business_entity;

    dbms_output.put_line('APPLICATION');    

/* elsif condition to get count for BUSINESS ENTITY*/
ELSif  busn_entity is not null and sb_entity is null  then

SELECT     nvl(to_char((round((SUM(extract_count)
                       ) / power(1000,
                                    trunc(log(1000,
                                              (nullif(SUM(extract_count),0)
                                                  )))),
                   1)
             || substr(' KMGTPEZY',
                       trunc(log(1000,
                                 (nullif(SUM(extract_count),0)
                                     ))) + 1,
                       1))),0),
    nvl(to_char((round((SUM(transform_count)
                       ) / power(1000,
                                    trunc(log(1000,
                                              (nullif(SUM(transform_count),0)
                                                  )))),
                   1)
             || substr(' KMGTPEZY',
                       trunc(log(1000,
                                 (nullif(SUM(transform_count),0)
                                     ))) + 1,
                       1))),0)              
INTO
    extract_cnt,
    transform_cnt
FROM
    (
        SELECT
            business_entity,
            sub_entity,
            iteration,
            MAX(migration_set_id) migration_set_id
        FROM
            xxmx_dm_dashboard_cntl
        GROUP BY
            business_entity,
            sub_entity,iteration
    )                      a,
    xxmx_dm_dashboard_cntl b
WHERE
        a.migration_set_id = b.migration_set_id
    AND a.sub_entity = b.sub_entity
    AND b.iteration = iter 
    and b.business_entity= busn_entity
    and a.iteration=b.iteration
    AND a.business_entity = b.business_entity;

dbms_output.put_line('BUSINESS ENTITY');    

/* elsif condition to get count for SUB ENTITY*/
ELSIF  sb_entity is not null  then 

SELECT    nvl(to_char((round((SUM(extract_count)
                       ) / power(1000,
                                    trunc(log(1000,
                                              (nullif(SUM(extract_count),0)
                                                  )))),
                   1)
             || substr(' KMGTPEZY',
                       trunc(log(1000,
                                 (nullif(SUM(extract_count),0)
                                     ))) + 1,
                       1))),0),
    nvl(to_char((round((SUM(transform_count)
                       ) / power(1000,
                                    trunc(log(1000,
                                              (nullif(SUM(transform_count),0)
                                                  )))),
                   1)
             || substr(' KMGTPEZY',
                       trunc(log(1000,
                                 (nullif(SUM(transform_count),0)
                                     ))) + 1,
                       1))),0)             
INTO
    extract_cnt,
    transform_cnt
FROM
    (
        SELECT
            business_entity,
            sub_entity,
            iteration,
            MAX(migration_set_id) migration_set_id
        FROM
            xxmx_dm_dashboard_cntl
        GROUP BY
            business_entity,
            sub_entity,iteration
    )                      a,
    xxmx_dm_dashboard_cntl b
WHERE
        a.migration_set_id = b.migration_set_id
    AND a.sub_entity = b.sub_entity
    AND b.iteration = iter 
   -- and b.business_entity= be
    and b.sub_entity=sb_entity
    and a.iteration=b.iteration
    AND a.business_entity = b.business_entity;

  dbms_output.put_line('SUB_ENTITY');  

/* to get the count for ITERATION*/
ELSIF ITER IS NOT NULL then

SELECT     nvl(to_char((round((SUM(extract_count)
                       ) / power(1000,
                                    trunc(log(1000,
                                              (nullif(SUM(extract_count),0)
                                                  )))),
                   1)
             || substr(' KMGTPEZY',
                       trunc(log(1000,
                                 (nullif(SUM(extract_count),0)
                                     ))) + 1,
                       1))),0),
    nvl(to_char((round((SUM(transform_count)
                       ) / power(1000,
                                    trunc(log(1000,
                                              (nullif(SUM(transform_count),0)
                                                  )))),
                   1)
             || substr(' KMGTPEZY',
                       trunc(log(1000,
                                 (nullif(SUM(transform_count),0)
                                     ))) + 1,
                       1))),0)             
INTO
    extract_cnt,
    transform_cnt
FROM
    (
        SELECT
            business_entity,
            sub_entity,
            iteration,
            MAX(migration_set_id) migration_set_id
        FROM
            xxmx_dm_dashboard_cntl
        GROUP BY
            business_entity,
            sub_entity,iteration
    )                      a,
    xxmx_dm_dashboard_cntl b
WHERE
        a.migration_set_id = b.migration_set_id
    AND a.sub_entity = b.sub_entity
    AND b.iteration = iter 
    and a.iteration=b.iteration
    AND a.business_entity = b.business_entity;

    dbms_output.put_line('ITERATION');
END IF;

 EXCEPTION
        WHEN OTHERS THEN
        xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => 'XXMX'
                         ,pt_i_Application         => 'XXMX'
                         ,pt_i_BusinessEntity      => 'XXMX_CORE'
                         ,pt_i_SubEntity           => 'XXMX_UTILITIES'
                         ,pt_i_MigrationSetID      => 0
                         ,pt_i_Phase               => 'EXTRACT'
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => 'XXMX_UTILITIES_PKG'
                         ,pt_i_ProcOrFuncName      => 'get_cumulative_counts'
                         ,pt_i_ProgressIndicator   => '0000'
                         ,pt_i_ModuleMessage       => NULL
                         ,pt_i_OracleError         => SUBSTR(SQLCODE||' '||SQLERRM,1,1000)
                         );
         RAISE;  

    END get_cumulative_counts;
--
-- ----------------------------------------------------------------------------
-- |---------------------< GET_FUSION_ERROR_COUNT >----------------------------|
-- Procedure to get cumulative counts for Fusion Error.
-- ----------------------------------------------------------------------------
--
procedure get_fusion_errCount(itr varchar2, error_count out integer)
is
BEGIN
select SUM(NVL(FUSION_ERROR_COUNT,0)) Fusion_Error_cnt
into error_count
FROM
    (
        SELECT
            business_entity,
            sub_entity,
            MAX(migration_set_id) migration_set_id
        FROM
            xxmx_dm_dashboard_cntl
        GROUP BY
            business_entity,
            sub_entity
    )                      a,
    xxmx_dm_dashboard_cntl b
WHERE
        a.migration_set_id = b.migration_set_id
    AND a.sub_entity = b.sub_entity
    AND iteration = ITR
    AND a.business_entity = b.business_entity;

    EXCEPTION
        WHEN OTHERS THEN
        xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => 'XXMX'
                         ,pt_i_Application         => 'XXMX'
                         ,pt_i_BusinessEntity      => 'XXMX_CORE'
                         ,pt_i_SubEntity           => 'XXMX_UTILITIES'
                         ,pt_i_MigrationSetID      => 0
                         ,pt_i_Phase               => 'EXTRACT'
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => 'XXMX_UTILITIES_PKG'
                         ,pt_i_ProcOrFuncName      => 'fusion_err'
                         ,pt_i_ProgressIndicator   => '0000'
                         ,pt_i_ModuleMessage       => NULL
                         ,pt_i_OracleError         => SUBSTR(SQLCODE||' '||SQLERRM,1,1000)
                         );
         RAISE;
    end get_fusion_errCount;

-- ----------------------------------------------------------------------------
-- |---------------------< CONVERT_TIMEZONE_DASHBOARD >----------------------------|
-- Procedure to convert tvimezone to UTC
-- ----------------------------------------------------------------------------
--
PROCEDURE convert_timezone_dashboard(time_var in out VARCHAR2, timezone VARCHAR2)
 IS
V_TimeSQL VARCHAR2(500);
V_SQL VARCHAR2(100);
TIME_SQL VARCHAR2(1000);

BEGIN

TIME_SQL:= 'select to_char(TO_DATE(Translate(SUBSTR ('
           ||''''
           ||time_var
           ||''''
           ||', 1, 19),'
           ||'''T'''
           ||','
           ||''' '''
           ||'),'
           ||'''YYYY-MM-DD HH24:MI:SS'''
           ||'),'
           ||'''YYYY-MM-DD HH24:MI:SS'''
           ||') from dual'
;
execute immediate TIME_SQL into V_TimeSQL ;
   dbms_output.put_line('V_TimeSQL '||V_TimeSQL);
   V_SQL:= 'SELECT FROM_TZ(TIMESTAMP '
           ||''''
           ||  V_TimeSQL
           ||''''
           ||','
           ||''''
           || timezone
           ||''''
           ||' ) AT TIME ZONE'
           ||'''UTC'''
           ||' from dual'
           ;
           execute immediate V_SQL into time_var ;

    dbms_output.put_line('time_var'||time_var);
   EXCEPTION
        WHEN OTHERS THEN
        xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => 'XXMX'
                         ,pt_i_Application         => 'XXMX'
                         ,pt_i_BusinessEntity      => 'XXMX_CORE'
                         ,pt_i_SubEntity           => 'XXMX_UTILITIES'
                         ,pt_i_MigrationSetID      => 0
                         ,pt_i_Phase               => 'convert_timezone_dashboard'
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => 'XXMX_UTILITIES_PKG'
                         ,pt_i_ProcOrFuncName      => 'convert_timezone_dashboard'
                         ,pt_i_ProgressIndicator   => '0000'
                         ,pt_i_ModuleMessage       => NULL
                         ,pt_i_OracleError         => SUBSTR(SQLCODE||' '||SQLERRM,1,1000)
                         );
         RAISE;

END convert_timezone_dashboard;

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
                    ,pt_i_instance_id          IN      xxmx_dm_oic_read_log.instance_id%TYPE DEFAULT NULL
                    ,pt_i_iteration             IN     VARCHAR2 DEFAULT NULL
                    ,pt_i_FileName              IN      xxmx_migration_metadata.data_file_name%TYPE DEFAULT NULL
                   )
IS
BEGIN
    DBMS_OUTPUT.PUT_LINE(pv_i_application_suite||'_'||pt_i_BusinessEntity||'_'||pt_i_sub_entity);
	dbms_scheduler.create_job (
	job_name => pv_i_application_suite||'_'||pt_i_BusinessEntity||'_'||pt_i_sub_entity,
	job_type => 'PLSQL_BLOCK',
	job_action =>
	'BEGIN
	XXMX_FUSION_LOAD_GEN_PKG.main 
            (
        	 pv_i_application_suite => '''||pv_i_application_suite||'''
            ,pt_i_BusinessEntity => '''||pt_i_BusinessEntity||'''
            ,pt_i_sub_entity => '''||pt_i_sub_entity||'''
            ,pt_i_instance_id => '''||pt_i_instance_id||'''
			,pt_i_iteration => '''||pt_i_iteration||'''	
            ,pt_i_FileName => '''||pt_i_FileName||'''
            ) ;
	END;',
	enabled => TRUE,
	auto_drop => TRUE,
	comments => 'Run '||pv_i_application_suite||'_'||pt_i_BusinessEntity||'_'||pt_i_sub_entity);

 EXCEPTION
    WHEN OTHERS
    THEN

            DBMS_OUTPUT.PUT_LINE(sqlerrm);                             

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

-- Added procedure for NON-EBS Clients
-- V2.7

   PROCEDURE external_file_exists ( pt_i_ApplicationSuite           IN      xxmx_migration_headers.application_suite%TYPE
                                   ,pt_i_Application                IN      xxmx_migration_headers.application%TYPE
                                   ,pt_i_BusinessEntity             IN      xxmx_migration_headers.business_entity%TYPE
                                   ,pt_i_FileSetID                  IN      xxmx_migration_details.file_set_id%TYPE
                                   ,pv_o_ReturnStatus                  OUT  VARCHAR2
                                   ,pt_o_ReturnMessage                 OUT  xxmx_data_messages.data_message%TYPE)
   AS     
        --*************************
        --** Variable Declaration
        --*************************


      fexists BOOLEAN;
      file_length NUMBER;
      block_size BINARY_INTEGER; 
      v_file_directory VARCHAR2(100) := 'SOURCE_DATAFILE';
      v_extfile_exists VARCHAR2(1);
      ct_ProcOrFuncName  VARCHAR2(30):='external_file_exists';
      ct_phase   VARCHAR2(10):= 'EXTRACT';


        --*************************
        --** Cursor Declaration
        --*************************
      CURSOR c_filename
      IS 
      SELECT UPPER(st.table_name) stg_table, st.import_data_file_name, mm.Sub_entity
      FROM xxmx_migration_metadata mm,
           xxmx_stg_tables st
      WHERE application = pt_i_Application
      AND mm.metadata_id = st.metadata_id
      AND application_suite = pt_i_ApplicationSuite
      AND business_entity = pt_i_BusinessEntity;

        --*************************
        --** Exception Declarations
        --*************************
        --
        e_ModuleError                   EXCEPTION;
        --


   BEGIN
     FOR rec_filename in c_filename
     LOOP
         v_extfile_exists := NULL;

         utl_file.fgetattr(
                location    => v_file_directory,
                filename    => rec_filename.import_data_file_name,
                fexists     => fexists,
                file_length => file_length,
                block_size  => block_size);



          IF ( fexists) THEN
              --DBMS_OUTPUT.PUT_LINE('File Exists');
              gvv_ProgressIndicator := '0005';
              log_module_message
                    (
                     pt_i_ApplicationSuite          => gct_ApplicationSuite
                    ,pt_i_Application               => gct_Application
                    ,pt_i_BusinessEntity            => gct_BusinessEntity
                    ,pt_i_SubEntity                 => gct_subEntity
                    ,pt_i_FileSetID                 => pt_i_FileSetID
                    ,pt_i_MigrationSetID            => 0
                    ,pt_i_Phase                     => ct_phase
                    ,pt_i_Severity                  => 'NOTIFICATION'
                    ,pt_i_PackageName               => gct_PackageName
                    ,pt_i_ProcOrFuncName            => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator         => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage             => 'External File '|| rec_filename.import_data_file_name ||' Exists in Path:'||v_file_directory ||' for SubEntity '||rec_filename.Sub_entity
                    ,pt_i_OracleError               => NULL
                    );
              v_extfile_exists := 'Y';
              pv_o_ReturnStatus := 'S';
              pt_o_ReturnMessage := 'Success';

          ELSE
              --DBMS_OUTPUT.PUT_LINE('NO File Exists');
              v_extfile_exists := 'N';
              gvv_ProgressIndicator := '0010';
              gvt_ModuleMessage := 'External File '|| rec_filename.import_data_file_name ||' does not Exists in Path:'||v_file_directory||' for SubEntity '||rec_filename.Sub_entity;

              log_module_message
                    (
                     pt_i_ApplicationSuite          => gct_ApplicationSuite
                    ,pt_i_Application               => gct_Application
                    ,pt_i_BusinessEntity            => gct_BusinessEntity
                    ,pt_i_SubEntity                 => gct_subEntity
                    ,pt_i_FileSetID                 => pt_i_FileSetID
                    ,pt_i_MigrationSetID            => 0
                    ,pt_i_Phase                     => ct_phase
                    ,pt_i_Severity                  => 'NOTIFICATION'
                    ,pt_i_PackageName               => gct_PackageName
                    ,pt_i_ProcOrFuncName            => ct_ProcOrFuncName
                    ,pt_i_ProgressIndicator         => gvv_ProgressIndicator
                    ,pt_i_ModuleMessage             => 'External File '|| rec_filename.import_data_file_name ||' Does Exists in Path:'||v_file_directory ||' for SubEntity '||rec_filename.Sub_entity
                    ,pt_i_OracleError               => NULL
                    );
              --Raise e_ModuleError;
              pv_o_ReturnStatus := 'S';
          pt_o_ReturnMessage := 'SUCCESS';

          END IF;  

          
     END LOOP;

      EXCEPTION 
            when e_ModuleError THEN
                pv_o_ReturnStatus := 'F';
                 log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => gvt_ModuleMessage
                         ,pt_i_OracleError       => NULL
                         );
                    Raise;
                --
                when others THEN
                    pv_o_ReturnStatus := 'F';
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => NULL
                         ,pt_i_OracleError       => gvt_OracleError
                         );

                raise;
                --


   END external_file_exists;


   PROCEDURE xxmx_read_datafile(pt_i_ApplicationSuite           IN      xxmx_migration_headers.application_suite%TYPE
                               ,pt_i_Application                IN      xxmx_migration_headers.application%TYPE
                               ,pt_i_BusinessEntity             IN      xxmx_migration_headers.business_entity%TYPE
                               ,pt_i_subEntity                  IN      xxmx_migration_metadata.sub_entity%TYPE
                               ,pt_i_FileSetID                  IN      xxmx_migration_details.file_set_id%TYPE
                               ,pt_i_MigrationSetID             IN      xxmx_migration_headers.migration_set_id%TYPE
                               ,pv_o_ReturnStatus               OUT  VARCHAR2
                               ,pt_o_ReturnMessage              OUT  xxmx_data_messages.data_message%TYPE)
   AS                            

        --*************************
        --** Cursor Declaration
        --*************************
      CURSOR C_stgext_tbl
      IS 
          SELECT UPPER(stg_table) stg_table,
                 UPPER(REPLACE(stg_table,'STG','EXT')) ext_table,
                 business_entity
          FROM xxmx_migration_metadata mm
          WHERE application = pt_i_Application
          AND application_suite = pt_i_ApplicationSuite
          AND business_entity = pt_i_BusinessEntity
          AND UPPER(mm.sub_entity) = UPPER(pt_i_subEntity);

      CURSOR c_columns(p_table_name VARCHAR2, p_stg_table VARCHAR2)
      IS 
          Select UPPER(column_name)  COLUMN_NAME
          From all_tab_columns c 
          where table_name = p_table_name
	     AND exists  ( SELECT 1 From all_tab_columns b
        		  where table_name = p_stg_table 
			  and c.column_name = b.column_name);



        --*************************
        --** Exception Declarations
        --*************************
        --
        e_ModuleError                   EXCEPTION;
        et_exception                    EXCEPTION;
        PRAGMA EXCEPTION_INIT(et_exception, -29913);

        --*************************
        --** Variable Declarations
        --*************************
      ct_ProcOrFuncName  VARCHAR2(30):='xxmx_read_datafile';
      ct_phase           VARCHAR2(10):= 'EXTRACT';
      lv_sql             VARCHAR2(32000);   
      v_column_lst       LONG;
      v_hdr_column_lst       LONG;
      vv_column_name     VARCHAR2(500);
      v_rec_exists       VARCHAR2(1000);
      v_src_date         VARCHAR2(5);
      file_length NUMBER;
      block_size BINARY_INTEGER; 
      v_file_directory VARCHAR2(100) := 'SOURCE_DATAFILE';
      v_extfile_exists VARCHAR2(1);
      ext_table_exists VARCHAR2(1);
      fexists BOOLEAN;
      vt_MigrationSetName xxmx_migration_headers.migration_set_name%TYPE;

   Begin

        vt_MigrationSetName := get_migration_set_name(pt_i_MigrationSetID);
        gvv_ProgressIndicator := '0005';
        log_module_message
            (
             pt_i_ApplicationSuite          => gct_ApplicationSuite
            ,pt_i_Application               => gct_Application
            ,pt_i_BusinessEntity            => gct_BusinessEntity
            ,pt_i_SubEntity                 => gct_subEntity
            ,pt_i_FileSetID                 => pt_i_FileSetID
            ,pt_i_MigrationSetID            => 0
            ,pt_i_Phase                     => ct_phase
            ,pt_i_Severity                  => 'NOTIFICATION'
            ,pt_i_PackageName               => gct_PackageName
            ,pt_i_ProcOrFuncName            => ct_ProcOrFuncName
            ,pt_i_ProgressIndicator         => gvv_ProgressIndicator
            ,pt_i_ModuleMessage             => ct_ProcOrFuncName|| ' is Initiated for ' || vt_MigrationSetName
            ,pt_i_OracleError               => NULL
            );

       FOR rec IN c_stgext_tbl
       LOOP

           FOR rec_columns IN  c_columns(rec.EXT_TABLE,rec.stg_table)
           LOOP
               --v_log := 'Column Creation '||rec.EXT_TABLE ||' '||rec_columns.COLUMN_NAME;
               vv_column_name := NULL;
               BEGIN 
                    Select 'DATE'
                    INTO v_src_date
                    From all_tab_columns c 
                    where table_name = rec.stg_table
                    and column_name =rec_columns.COLUMN_NAME 
                    and Data_type = 'DATE';
               EXCEPTION
                WHEN OTHERS THEN 
                    v_src_date :=NULL;
               END;

               IF( v_src_date = 'DATE') THEN
                    vv_column_name := 'to_date('||rec_columns.COLUMN_NAME ||',''RRRR/MM/DD'')';
               ELSE
                    vv_column_name := rec_columns.COLUMN_NAME;
               END IF;
               IF( v_column_lst is NULL) THEN 
                   v_column_lst:= vv_column_name;
                   v_hdr_column_lst:= rec_columns.COLUMN_NAME;
               ELSE 
                   v_column_lst := v_column_lst ||' , '|| vv_column_name;
                   v_hdr_column_lst:= v_hdr_column_lst ||' , '||rec_columns.COLUMN_NAME;

               END IF; 
           END LOOP;

      
        utl_file.fgetattr(
                location    =>'SOURCE_DATAFILE',
                filename    => rec.stg_table||'.csv',
                fexists     => fexists,
                file_length => file_length,
                block_size  => block_size);
    
      gvv_ProgressIndicator := '0010';
        log_module_message
                (
                 pt_i_ApplicationSuite          => gct_ApplicationSuite
                ,pt_i_Application               => gct_Application
                ,pt_i_BusinessEntity            => gct_BusinessEntity
                ,pt_i_SubEntity                 => gct_subEntity
                ,pt_i_FileSetID                 => pt_i_FileSetID
                ,pt_i_MigrationSetID            => 0
                ,pt_i_Phase                     => ct_phase
                ,pt_i_Severity                  => 'NOTIFICATION'
                ,pt_i_PackageName               => gct_PackageName
                ,pt_i_ProcOrFuncName            => ct_ProcOrFuncName
                ,pt_i_ProgressIndicator         => gvv_ProgressIndicator
                ,pt_i_ModuleMessage             => 'Check if External file '|| rec.EXT_TABLE ||' is present '||file_length
                ,pt_i_OracleError               => NULL
                );
        BEGIN      
        Select 'Y' 
        INTO ext_table_exists
        from all_objects 
        where Object_name = UPPER(rec.EXT_TABLE);
        EXCEPTION
	    WHEN OTHERS THEN 
		ext_table_exists := 'N';
	END;	
                
        IF ( fexists AND ext_table_exists = 'Y' and file_length>1) THEN

             lv_sql:= ' Select count(1) '
                    ||' from xxmx_core.'|| rec.EXT_TABLE;

           EXECUTE IMMEDIATE lv_sql INTO  v_rec_exists ;
           gvt_ModuleMessage := rec.EXT_TABLE;
        --   DBMS_OUTPUT.PUT_LINE(v_rec_exists);
        
         gvv_ProgressIndicator := '0015';
        log_module_message
                (
                 pt_i_ApplicationSuite          => gct_ApplicationSuite
                ,pt_i_Application               => gct_Application
                ,pt_i_BusinessEntity            => gct_BusinessEntity
                ,pt_i_SubEntity                 => gct_subEntity
                ,pt_i_FileSetID                 => pt_i_FileSetID
                ,pt_i_MigrationSetID            => 0
                ,pt_i_Phase                     => ct_phase
                ,pt_i_Severity                  => 'NOTIFICATION'
                ,pt_i_PackageName               => gct_PackageName
                ,pt_i_ProcOrFuncName            => ct_ProcOrFuncName
                ,pt_i_ProgressIndicator         => gvv_ProgressIndicator
                ,pt_i_ModuleMessage             => 'Check if External Table '|| rec.EXT_TABLE ||' has records -'||v_rec_exists
                ,pt_i_OracleError               => NULL
                );
       

           IF( v_rec_exists >= 1) THEN 

                lv_sql := 'DELETE FROM '||rec.STG_TABLE
                        ;
                EXECUTE IMMEDIATE lv_sql;

               gvv_ProgressIndicator := '0015';
                log_module_message
                        (
                         pt_i_ApplicationSuite          => gct_ApplicationSuite
                        ,pt_i_Application               => gct_Application
                        ,pt_i_BusinessEntity            => gct_BusinessEntity
                        ,pt_i_SubEntity                 => gct_subEntity
                        ,pt_i_FileSetID                 => pt_i_FileSetID
                        ,pt_i_MigrationSetID            => 0
                        ,pt_i_Phase                     => ct_phase
                        ,pt_i_Severity                  => 'NOTIFICATION'
                        ,pt_i_PackageName               => gct_PackageName
                        ,pt_i_ProcOrFuncName            => ct_ProcOrFuncName
                        ,pt_i_ProgressIndicator         => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage             => 'Record Count in External Table '||v_rec_exists
                        ,pt_i_OracleError               => NULL
                        );
               lv_sql:=' INSERT INTO '
                        ||rec.STG_TABLE
                        ||' ( '|| v_hdr_column_lst||' ) ' 
                        ||' SELECT '|| v_column_lst||' FROM xxmx_core.'
                        ||rec.EXT_TABLE ;
          --     DBMS_OUTPUT.PUT_LINE(lv_sql);


               gvv_ProgressIndicator := '0020';
                log_module_message
                        (
                         pt_i_ApplicationSuite          => gct_ApplicationSuite
                        ,pt_i_Application               => gct_Application
                        ,pt_i_BusinessEntity            => gct_BusinessEntity
                        ,pt_i_SubEntity                 => gct_subEntity
                        ,pt_i_FileSetID                 => pt_i_FileSetID
                        ,pt_i_MigrationSetID            => 0
                        ,pt_i_Phase                     => ct_phase
                        ,pt_i_Severity                  => 'NOTIFICATION'
                        ,pt_i_PackageName               => gct_PackageName
                        ,pt_i_ProcOrFuncName            => ct_ProcOrFuncName
                        ,pt_i_ProgressIndicator         => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage             => ' Build Dynamic Query to Load Staging Tables '
                        ,pt_i_OracleError               => NULL
                        );

                gvv_ProgressIndicator := '0025';
                log_module_message
                        (
                         pt_i_ApplicationSuite          => gct_ApplicationSuite
                        ,pt_i_Application               => gct_Application
                        ,pt_i_BusinessEntity            => gct_BusinessEntity
                        ,pt_i_SubEntity                 => gct_subEntity
                        ,pt_i_FileSetID                 => pt_i_FileSetID
                        ,pt_i_MigrationSetID            => 0
                        ,pt_i_Phase                     => ct_phase
                        ,pt_i_Severity                  => 'NOTIFICATION'
                        ,pt_i_PackageName               => gct_PackageName
                        ,pt_i_ProcOrFuncName            => ct_ProcOrFuncName
                        ,pt_i_ProgressIndicator         => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage             => SUBSTR(lv_sql,1, 3000)
                        ,pt_i_OracleError               => NULL
                        );

               Execute immediate lv_sql;

                gvv_ProgressIndicator := '0030';
                log_module_message
                        (
                         pt_i_ApplicationSuite          => gct_ApplicationSuite
                        ,pt_i_Application               => gct_Application
                        ,pt_i_BusinessEntity            => gct_BusinessEntity
                        ,pt_i_SubEntity                 => gct_subEntity
                        ,pt_i_FileSetID                 => pt_i_FileSetID
                        ,pt_i_MigrationSetID            => 0
                        ,pt_i_Phase                     => ct_phase
                        ,pt_i_Severity                  => 'NOTIFICATION'
                        ,pt_i_PackageName               => gct_PackageName
                        ,pt_i_ProcOrFuncName            => ct_ProcOrFuncName
                        ,pt_i_ProgressIndicator         => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage             => 'Update the Staging tables with Migration_set_id and Migration_Set_name'
                        ,pt_i_OracleError               => NULL
                        );

                lv_sql := 'Update '||rec.STG_TABLE
                          ||' Set Migration_Set_name = '''|| vt_MigrationSetName||''''
                          ||', Migration_Set_Id =  '||pt_i_MigrationSetId
                          ||', File_Set_id = '''||pt_i_FileSetID||''''
                          ;

             gvv_ProgressIndicator := '0035';
                log_module_message
                        (
                         pt_i_ApplicationSuite          => gct_ApplicationSuite
                        ,pt_i_Application               => gct_Application
                        ,pt_i_BusinessEntity            => gct_BusinessEntity
                        ,pt_i_SubEntity                 => gct_subEntity
                        ,pt_i_FileSetID                 => pt_i_FileSetID
                        ,pt_i_MigrationSetID            => 0
                        ,pt_i_Phase                     => ct_phase
                        ,pt_i_Severity                  => 'NOTIFICATION'
                        ,pt_i_PackageName               => gct_PackageName
                        ,pt_i_ProcOrFuncName            => ct_ProcOrFuncName
                        ,pt_i_ProgressIndicator         => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage             => lv_sql
                        ,pt_i_OracleError               => NULL
                        );                          

                Execute Immediate lv_sql;
                Commit ;
           END IF;
	 ELSE
		gvv_ProgressIndicator := '0040';
	        log_module_message
                (
                 pt_i_ApplicationSuite          => gct_ApplicationSuite
                ,pt_i_Application               => gct_Application
                ,pt_i_BusinessEntity            => gct_BusinessEntity
                ,pt_i_SubEntity                 => gct_subEntity
                ,pt_i_FileSetID                 => pt_i_FileSetID
                ,pt_i_MigrationSetID            => 0
                ,pt_i_Phase                     => ct_phase
                ,pt_i_Severity                  => 'ERROR'
                ,pt_i_PackageName               => gct_PackageName
                ,pt_i_ProcOrFuncName            => ct_ProcOrFuncName
                ,pt_i_ProgressIndicator         => gvv_ProgressIndicator
                ,pt_i_ModuleMessage             => 'Either External Table  or External File doesnot exist for '|| rec.EXT_TABLE ||'.Hence skipped the Extract process'
                ,pt_i_OracleError               => NULL
                );
       
		
         END IF;
       END LOOP;
            pv_o_ReturnStatus := 'S';
            pt_o_ReturnMessage := 'Success';
            Commit ;
       EXCEPTION 
           WHEN et_exception THEN
               RollBack;
               pv_o_ReturnStatus := 'F';
               gvv_ProgressIndicator := '0025';
                log_module_message
                        (
                         pt_i_ApplicationSuite          => gct_ApplicationSuite
                        ,pt_i_Application               => gct_Application
                        ,pt_i_BusinessEntity            => gct_BusinessEntity
                        ,pt_i_SubEntity                 => gct_subEntity
                        ,pt_i_FileSetID                 => pt_i_FileSetID
                        ,pt_i_MigrationSetID            => 0
                        ,pt_i_Phase                     => ct_phase
                        ,pt_i_Severity                  => 'NOTIFICATION'
                        ,pt_i_PackageName               => gct_PackageName
                        ,pt_i_ProcOrFuncName            => ct_ProcOrFuncName
                        ,pt_i_ProgressIndicator         => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage             => SUBSTR('Unable to read the external file for '|| gvt_ModuleMessage||' '||SQLERRM||' '||SQLCODE,1, 3500) 
                        ,pt_i_OracleError               => NULL
                        );
           WHEN OTHERS THEN
                    RollBack;

                    pv_o_ReturnStatus := 'F';
                    gvt_OracleError := SUBSTR(
                                              SQLERRM
                                             ,1
                                             ,4000
                                             );
                    log_module_message
                         (
                          pt_i_ApplicationSuite  => gct_ApplicationSuite
                         ,pt_i_Application       => gct_Application
                         ,pt_i_BusinessEntity    => gct_BusinessEntity
                         ,pt_i_SubEntity         => gct_SubEntity
                         ,pt_i_FileSetID         => pt_i_FileSetID
                         ,pt_i_MigrationSetID    => 0
                         ,pt_i_Phase             => ct_Phase
                         ,pt_i_Severity          => 'ERROR'
                         ,pt_i_PackageName       => gct_PackageName
                         ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                         ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                         ,pt_i_ModuleMessage     => NULL
                         ,pt_i_OracleError       => gvt_OracleError
                         );

                raise;
                --
   END xxmx_read_datafile;    

   --End of Added procedure for NON-EBS Clients





    FUNCTION XXMX_DM_ESS_SUB_ENTITY( p_businessentity VARCHAR2, p_subentity VARCHAR2) 
    RETURN VARCHAR2
    AS
    v_load_name VARCHAR2(100);

    BEGIN 
       -- IF( p_businessentity = 'SUPPLIERS' or  p_businessentity = 'BALANCES') THEN 
        IF( p_businessentity = 'BALANCES') THEN 
            v_load_name := p_subentity;
        ELSE 
            v_load_name := p_businessentity;
        END IF;
        RETURN v_load_name;
    END;        

      PROCEDURE XXMX_COMMIT
      as 
      BEGIN 
        COMMIT;
        DBMS_session.sleep(40);

      END;


    PROCEDURE   BATCH_CSV_FILE_TEMP_DATA (
            p_business_entity IN VARCHAR2,
            p_sub_entity IN VARCHAR2 DEFAULT NULL,
            p_batch_count IN NUMBER,
            p_ct_phase IN VARCHAR2 DEFAULT NULL
        ) IS

          ct_ProcOrFuncName       CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'batch_csv_file_temp_data';

            rc                    NUMBER;
            startrow              NUMBER;
            endrow                NUMBER;
            rowvar                NUMBER;
            pv_batch_identifier   VARCHAR2(100);
            pv_seq_in_fbdi_data   VARCHAR2(100);
            ntile_var             VARCHAR2(100);
            v_position           VARCHAR2(5);
            v_1 VARcHAR2(30);
            v_2 VARcHAR2(30);
            v_3  VARcHAR2(30);
            v_batch_load         VARCHAR2(10);

    BEGIN
        IF( p_ct_phase IS NULL) THEN
            gct_phase := 'LOAD';
        ELSE 
            gct_phase := p_ct_phase;
        END IF;

        dbms_output.put_line('Start');
        gvv_ProgressIndicator:= '0001';
     BEGIN 
        SELECT BATCH_LOAD
        INTO v_batch_load
        FROM xxmx_migration_metadata
        WHERE BUSINESS_ENTITY = p_business_entity
        AND SUB_ENTITY = DECODE(NVL(p_sub_entity,'ALL'),'ALL', sub_entity, p_sub_entity)
        AND ENABLED_FLAG= 'Y';
     EXCEPTION
        WHEN OTHERS THEN 
            v_batch_load:= 'N';
     END;
     gvv_ProgressIndicator:= '0002';
     IF( v_batch_load = 'Y') THEN   
     dbms_output.put_line('Start1');
      FOR j IN (
            SELECT DISTINCT
                business_entity,
                data_file_name || '.csv' file_name,
                sub_entity_seq,
                seq_in_fbdi_data
            FROM xxmx_migration_metadata
            WHERE business_entity = p_business_entity
            AND sub_entity =  DECODE(NVL(p_sub_entity,'ALL'),'ALL', sub_entity, p_sub_entity)
          ) 
      LOOP 
          dbms_output.put_line(j.file_name);

          UPDATE xxmx_csv_file_temp
          SET business_entity = p_business_entity
          WHERE  file_name = j.file_name;

          COMMIT;

        END LOOP;


        BEGIN
          gvv_ProgressIndicator:= '0003';

          IF( p_business_entity IN('BALANCES','DAILY_RATES'))
          THEN 
            FOR k IN (
            SELECT distinct batch_value,
            Dense_rank()OVER(ORDER BY m_no) Batch_name
            FROM   (      
                    SELECT ID,
                           line_content,batch_value,
                           Min(ID )OVER(partition BY batch_value) AS m_no
                    FROM   xxmx_csv_file_temp
                    WHERE  business_entity = p_business_entity
                    AND line_type NOT IN ('File Header')
            ) )
            LOOP

                UPDATE xxmx_csv_file_temp
                SET  batch_name = file_name||'_' || k.batch_name||'_'||k.batch_value
                WHERE  batch_value = k.batch_value
                ;

            END LOOP;
         ELSE
                dbms_output.put_line('Second Loop');
                gvv_ProgressIndicator:= '0004';
                SELECT COUNT(*)/p_batch_count
                INTO ntile_var
                FROM  xxmx_csv_file_temp
                WHERE business_entity = p_business_entity;

                IF( ROUND(ntile_var) > 0) THEN
                gvv_ProgressIndicator:= '0005';
                    FOR k IN (
                        SELECT
                            batch_value, ROWID,
                            NTILE(ntile_var) OVER(
                                ORDER BY batch_value DESC
                            ) AS batch_value_1
                        FROM xxmx_csv_file_temp
                        WHERE business_entity = p_business_entity
                    ) LOOP 

                        UPDATE xxmx_csv_file_temp
                        SET batch_name = 'BATCH_' || k.batch_value_1
                        WHERE batch_value = k.batch_value
                        and ROWID = K.ROWID;
                    END LOOP;
            END IF;

         END IF;

        END;
    ELSE
        gvv_ProgressIndicator:= '0007';
        FOR j IN (
            SELECT DISTINCT
                business_entity,
                data_file_name || '.csv' file_name,
                sub_entity_seq,
                seq_in_fbdi_data
            FROM xxmx_migration_metadata
            WHERE business_entity = p_business_entity
            AND sub_entity =  DECODE(NVL(p_sub_entity,'ALL'),'ALL', sub_entity, p_sub_entity)
          ) 
       LOOP 
          dbms_output.put_line(j.file_name||'1');

          UPDATE xxmx_csv_file_temp
          SET business_entity = p_business_entity,
            Batch_name = file_name||'_' || 1
          WHERE  file_name = j.file_name;
          dbms_output.put_line(j.file_name||'updated');

          COMMIT;

        END LOOP;
    END IF;

    gvv_ProgressIndicator:= '0006';

     COMMIT;
        EXCEPTION
            WHEN OTHERS THEN

                log_module_message
                        (
                         pt_i_ApplicationSuite          => gct_ApplicationSuite
                        ,pt_i_Application               => gct_Application
                        ,pt_i_BusinessEntity            => gct_BusinessEntity
                        ,pt_i_SubEntity                 => gct_subEntity
                        ,pt_i_FileSetID                 => 0
                        ,pt_i_MigrationSetID            => 0
                        ,pt_i_Phase                     => gct_phase
                        ,pt_i_Severity                  => 'NOTIFICATION'
                        ,pt_i_PackageName               => gct_PackageName
                        ,pt_i_ProcOrFuncName            => ct_ProcOrFuncName
                        ,pt_i_ProgressIndicator         => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage             => 'Exception'
                        ,pt_i_OracleError               => SQLERRM||'-'||SQLCODE
                        );                          

    END batch_csv_file_temp_data;

    PROCEDURE fusion_Customer_batch(p_batch_id varchar2)
    AS 

        Cursor c1
        IS 
            select x.table_name 
            from xxmx_migration_metadata m
               , xxmx_xfm_tables x
            where  business_Entity = 'CUSTOMERS'
            and m.xfm_table= x.table_name;

        lv_sql VARCHAR2(20000);
        ct_ProcOrFuncName               CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'fusion_Customer_batch';
    BEGIN 
        gct_phase := 'LOAD';
        FOR i in c1
        LOOP
            lv_sql := 'UPDATE xxmx_xfm.'|| i.table_name 
                           ||' SET BATCH_ID = '||p_batch_id;
					       --||' where migration_set_id = ' ||p_migration_set_id;
            EXECUTE IMMEDIATE lv_sql;
        END LOOP;

    COMMIT;
         EXCEPTION
            WHEN OTHERS THEN

                log_module_message
                        (
                         pt_i_ApplicationSuite          => gct_ApplicationSuite
                        ,pt_i_Application               => gct_Application
                        ,pt_i_BusinessEntity            => gct_BusinessEntity
                        ,pt_i_SubEntity                 => gct_subEntity
                        ,pt_i_FileSetID                 => 0
                        ,pt_i_MigrationSetID            => 0
                        ,pt_i_Phase                     => gct_phase
                        ,pt_i_Severity                  => 'NOTIFICATION'
                        ,pt_i_PackageName               => gct_PackageName
                        ,pt_i_ProcOrFuncName            => ct_ProcOrFuncName
                        ,pt_i_ProgressIndicator         => gvv_ProgressIndicator
                        ,pt_i_ModuleMessage             => 'Exception'
                        ,pt_i_OracleError               => SQLERRM||'-'||SQLCODE
                        );                          
    END fusion_Customer_batch;


    FUNCTION get_primary_ledger_id (p_bu_name IN VARCHAR2, p_business_entity IN VARCHAR2)
    RETURN VARCHAR2
    AS

        l_primary_ledger_id VARCHAR2(100):= '-1';
    BEGIN
        IF(p_business_entity = 'INVOICES') THEN
            SELECT LEDGER_ID 
            INTO l_primary_ledger_id
            FROM xxmx_dm_fusion_das das
            where exists(SELECT 1
                         FROM xxmx_ap_invoices_xfm xfm
                         WHERE das.bu_name= xfm.fusion_business_unit
                         )
            AND bu_name = p_bu_name;
        END IF;
        RETURN l_primary_ledger_id;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN -1;
    END get_primary_ledger_id;


    procedure xxmx_delete_dbfile(pt_i_BusinessEntity   IN  xxmx_migration_metadata.business_entity%TYPE
                                ,pt_dirname                      IN      VARCHAR2
                                ,pt_filename IN VARCHAR2 DEFAULT NULL  -- 2.4
                                ,pt_load_fileID IN NUMBER)  -- 2.5
    AS
    CURSOR c1 IS
        SELECT DISTINCT BATCH_NAME ,File_name
        FROM xxmx_csv_file_temp
        where business_entity =pt_i_BusinessEntity
		and (FILE_NAME = pt_filename OR pt_filename IS NULL)--2.6
        and batch_name is not null
        and line_type <> 'File Header'
        order by batch_name;  
        
    CURSOR c2 IS  	-- START 2.5 --
        SELECT DISTINCT tmp.BATCH_NAME ,tmp.File_name
        FROM xxmx_hdl_file_temp tmp,xxmx_loadfile_status_log log 
        where tmp.business_entity =pt_i_BusinessEntity
        and tmp.batch_name is not null
        and log.LOAD_FILE_ID=pt_load_fileID
        and tmp.FILE_NAME=log.FILENAME
        and tmp.line_content not like 'METADATA%'
        and tmp.line_type <> 'File Header'
        order by tmp.batch_name; 
            		-- END  2.5 --

        vt_ApplicationSuite     xxmx_module_messages.application_suite%TYPE ;    
    BEGIN
        SELECT DISTINCT application_suite
        INTO vt_ApplicationSuite
        FROM xxmx_migration_metadata
        where business_entity = pt_i_businessentity
        and enabled_flag= 'Y';

        DBMS_OUTPUT.PUT_LINE(vt_ApplicationSuite);
    BEGIN
      IF vt_ApplicationSuite IN ('FIN','SCM','PPM') THEN
        For r1 in c1 loop
            DBMS_OUTPUT.PUT_LINE('in FIN Loop');
            UTL_FILE.FREMOVE (pt_dirname,r1.File_name||'_'||r1.batch_name||'.csv');  
            DBMS_OUTPUT.PUT_LINE(r1.File_name||'_'||r1.batch_name||'.csv'||'Removed from server');

        END LOOP;
        END IF;
	IF vt_ApplicationSuite IN ('HCM','OLC','PAY') THEN
        For r2 in c2 loop
                DBMS_OUTPUT.PUT_LINE('in HCM Loop');
            UTL_FILE.FREMOVE (pt_dirname,pt_filename||'_'||r2.batch_name||'.dat');  -- 2.4
            DBMS_OUTPUT.PUT_LINE(pt_filename||'_'||r2.batch_name||'.dat'||'Removed from server'); -- 2.4


        END LOOP;
        END IF; 

     END;
    END xxmx_delete_dbfile;

   procedure xxmx_delete_dbfile_nonbatching(pt_i_BusinessEntity   IN  xxmx_migration_metadata.business_entity%TYPE
                                ,pt_dirname                      IN      VARCHAR2)  
    AS
    CURSOR c1 IS
        SELECT DISTINCT Filename
        FROM XXMX_LIST_DB_LOADFILE
        WHERE business_entity=pt_i_BusinessEntity
        order by Filename;  

        vt_ApplicationSuite     xxmx_module_messages.application_suite%TYPE ;    
    BEGIN


        For r1 in c1 loop

            UTL_FILE.FREMOVE (pt_dirname,r1.Filename);  
            DBMS_OUTPUT.PUT_LINE(r1.Filename||'Removed from server');

        END LOOP;

    END xxmx_delete_dbfile_nonbatching;
    PROCEDURE xxmx_delete_zipfile(pt_i_BusinessEntity   IN  xxmx_migration_metadata.business_entity%TYPE
                                   ,pt_dirname                      IN      VARCHAR2)  
    AS
    CURSOR c1 IS
        SELECT DISTINCT BATCH_NAME 
              --,File_name
              ,(select BATCH_NAME
                FROM xxmx_csv_file_temp
                where business_entity =pt_i_BusinessEntity
                and batch_name is not null
                and line_type = 'File Header') file_date
        FROM xxmx_csv_file_temp
        where business_entity =pt_i_BusinessEntity
        and batch_name is not null
        and line_type <> 'File Header'
        order by batch_name;  

      CURSOR c2 IS
        SELECT DISTINCT BATCH_NAME 
             -- ,File_name
              ,(select distinct BATCH_NAME
                FROM xxmx_hdl_file_temp
                where business_entity =pt_i_BusinessEntity
                and batch_name is not null
                and LINE_CONTENT like 'METADATA%') file_date
        FROM xxmx_hdl_file_temp
        where business_entity =pt_i_BusinessEntity
        and batch_name is not null
        and LINE_CONTENT not like 'METADATA%'
        order by batch_name;

         vt_ApplicationSuite     xxmx_module_messages.application_suite%TYPE ;

    BEGIN     
        SELECT DISTINCT application_suite
        INTO vt_ApplicationSuite
        FROM xxmx_migration_metadata
        where business_entity = pt_i_businessentity
        and enabled_flag= 'Y';
    BEGIN

     IF vt_ApplicationSuite IN ('FIN','SCM','PPM') THEN
        For r1 in c1 loop
          dbms_output.put_line(pt_dirname||pt_i_BusinessEntity||'_'||r1.batch_name||'_'||r1.file_date||'.zip'); 

            UTL_FILE.FREMOVE (pt_dirname,pt_i_BusinessEntity||'_'||r1.batch_name||'_'||r1.file_date||'.zip');  
        END LOOP;    
     END IF;

   IF vt_ApplicationSuite IN ('HCM','OLC','PAY') THEN

     For r2 in c2 loop
            dbms_output.put_line(pt_dirname||pt_i_BusinessEntity||'_'||r2.batch_name||'_'||r2.file_date||'.zip'); 

            UTL_FILE.FREMOVE (pt_dirname,pt_i_BusinessEntity||'_'||r2.batch_name||'_'||r2.file_date||'.zip'); 
     END LOOP;       
     END IF;       
    END;
    END xxmx_delete_zipfile;



        --
     /*
     *****************************************
     ** PROCEDURE: xxmx_write_dbcs
     **
     ** Called from Maximise Core procedures.
     ** Write load csv file to Oracle Database Server
     *****************************************
     */
     --

   PROCEDURE xxmx_write_dbcs (  pt_i_businessentity IN VARCHAR2, pt_load_fileID number,pt_file_name IN VARCHAR2 DEFAULT NULL)  --2.4                                    
    IS
          --**********************
          --** Cursor Declarations
          --**********************
          --
        CURSOR c_file_name
        IS 
            SELECT distinct file_name ,batch_name
            FROM xxmx_csv_file_temp
            where business_entity = pt_i_businessentity
			and (FILE_NAME = pt_file_name OR pt_file_name IS NULL)--2.6
            and batch_name is not null
            and line_type <> 'File Header'
            Order by file_name;

          CURSOR c_file_name_hdl
			IS  --- START 2.5 ---
            SELECT distinct tmp.file_name ,tmp.batch_name
            FROM xxmx_hdl_file_temp tmp,xxmx_loadfile_status_log log
            where tmp.business_entity = pt_i_businessentity
            and tmp.batch_name is not null
            and log.LOAD_FILE_ID = pt_load_fileID
            and tmp.FILE_NAME=log.FILENAME
            and tmp.line_content not like 'METADATA%'
            and tmp.line_type <> 'File Header'
            Order by tmp.file_name;
            
         CURSOR c_line_type_hdl
        IS 
            SELECT distinct tmp.file_name,tmp.batch_name,tmp.line_type
            FROM xxmx_hdl_file_temp tmp,xxmx_loadfile_status_log log
            where tmp.business_entity = pt_i_businessentity
            and tmp.batch_name is not null
            and log.LOAD_FILE_ID = pt_load_fileID
            and tmp.FILE_NAME=log.FILENAME
            and tmp.line_content not like 'METADATA%'
            and tmp.line_type <> 'File Header'
            Order by tmp.file_name;  
            --- END 2.5 ---



          --
          --**********************
          --** Record Declarations
          --**********************
          --
          type extract_data is table of varchar2(4000) index by binary_integer;
          g_extract_data      extract_data; 
          --
          --************************
          --** Constant Declarations
          --************************
          ct_ProcOrFuncName       CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'XXMX_WRITE_DBCS';
          --************************
          --** Variable Declarations
          --************************
          --

            type exrtact_cursor_type IS REF CURSOR;
            r_details               exrtact_cursor_type;

            v_filename              VARCHAR2(300);
            vv_file_dir             all_directories.directory_name%TYPE;
            pv_o_FTP_Out            xxmx_file_locations.FILE_LOCATION%TYPE;
            vt_ApplicationSuite     xxmx_module_messages.application_suite%TYPE ;
            vt_Application          xxmx_module_messages.application%TYPE      ;
            vt_BusinessEntity       xxmx_migration_metadata.business_entity%TYPE ;
            vt_filegroup            xxmx_migration_metadata.file_group_number%TYPE ;
            g_file_id               UTL_FILE.FILE_TYPE; 
            g_zipped_blob           blob;
            gv_file_Blob            blob;
			v_fusion_file_name      VARCHAR2(300); -- 2.4

          --
          --*************************
          --** Exception Declarations
          --*************************
          --
          e_ModuleError                   EXCEPTION;
          --     

    BEGIN
       --DBMS_LOB.FILECLOSEALL;
       gct_phase := 'EXPORT';

       log_module_message
               (
                pt_i_ApplicationSuite  => null
               ,pt_i_Application       => null
               ,pt_i_BusinessEntity    => pt_i_businessentity
               ,pt_i_SubEntity         => null
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => 'xxmx_utilities_pkg'
               ,pt_i_ProcOrFuncName    => 'xxmx_write_dbcs'
               ,pt_i_ProgressIndicator => 0115
               ,pt_i_ModuleMessage     => 'Package:xxmx_utilities_pkg, procedure:xxmx_write_dbcs initiated.'
               ,pt_i_OracleError       => NULL
               );

       BEGIN 
        SELECT DISTINCT application_suite
             ,application
             ,business_Entity
             ,file_group_number
        INTO vt_ApplicationSuite,
             vt_Application,
             vt_BusinessEntity,
             vt_filegroup
        FROM xxmx_migration_metadata
        where business_entity = pt_i_businessentity
        and enabled_flag= 'Y';
       EXCEPTION
        WHEN OTHERS THEN 
          gvt_ModuleMessage:=  SUBSTR('Entry in Migration Metadata is wrong '|| SQLERRM,1,4000);
          gvt_OracleError := SQLERRM;
          raise e_ModuleError;
        END;

       BEGIN 
       pv_o_FTP_Out      := xxmx_utilities_pkg.get_file_location(vt_ApplicationSuite,vt_Application,vt_BusinessEntity,vt_filegroup,'OIC','DATA','FTP_OUTPUT');                
       DBMS_OUTPUT.PUT_LINE(vt_ApplicationSuite || ' '||vt_Application || ' ' ||vt_BusinessEntity|| ' '||  vt_filegroup);
       exception
            when others then
               gvt_ModuleMessage:= 'No directory was found in table xxmx_file_locations for APPLICATION:'||vt_Applicationsuite;
               gvt_OracleError:= NULL;
               raise e_ModuleError;
       end;

        DBMS_OUTPUT.PUT_LINE(pv_o_FTP_Out);

        BEGIN 
            SELECT directory_name
            INTO vv_file_dir
            from all_directories
             WHERE (directory_path like '%'||pv_o_FTP_Out||'%'
             OR  directory_name like '%'||pv_o_FTP_Out||'%');
        EXCEPTION
            WHEN OTHERS THEN 
                gvt_ModuleMessage := SQLERRM;
                raise e_ModuleError;
        END;

     IF vt_ApplicationSuite IN ('FIN','SCM','PPM') THEN  
     DBMS_OUTPUT.PUT_LINE('FILE FIN');
        FOR r_file_name in c_file_name
        LOOP
            --utl_file.fremove ('BALANCES','GlInterface'||'.csv'); 
             IF(UTL_FILE.IS_OPEN( g_file_id )) THEN
                utl_file.fclose(g_file_id);
            END IF;        

            g_file_id := utl_file.fopen (vv_file_dir , r_file_name.file_name||'_'||r_file_name.BATCH_NAME||'.csv',  'W', 10000);
            dbms_output.put_line(r_file_name.file_name);
            OPEN r_details FOR ('SELECT Line_content
                                FROM xxmx_csv_file_temp
                                where file_name = '''||r_file_name.file_name||''''||
                                ' and line_type = ''File Detail''
                                  and  batch_name = '''|| r_file_name.BATCH_NAME||''''||
                                ' and batch_name is not null ');
            LOOP


            FETCH r_details  bulk collect into g_extract_data LIMIT 10000; 
            EXIT WHEN g_extract_data.COUNT =0;

                FOR i IN 1..g_extract_data.COUNT LOOP
                    --DBMS_OUTPUT.PUT_LINE(g_extract_data(i));
                    utl_file.put_line (g_file_id, g_extract_data(i));
                END LOOP;
            END LOOP;    

            utl_file.fclose(g_file_id);
        END LOOP;
		
		xxmx_zip_file (pt_i_BusinessEntity  => pt_i_businessentity
                      ,pt_dirname    => vv_file_dir
                      ,pt_load_fileID => pt_load_fileID
                      ,pt_filename    => pt_file_name);--2.6


   else   
     FOR r_file_name in c_file_name_hdl
        LOOP
        			-- START   2.5   ----
           FOR r_line_type in c_line_type_hdl
            LOOP
             UPDATE xxmx_hdl_file_temp
             SET BATCH_NAME=r_file_name.BATCH_NAME
             WHERE line_type=r_line_type.line_type
             AND business_entity = pt_i_businessentity
             AND file_name = r_file_name.file_name
             AND line_content like 'METADATA%';
             commit;
             dbms_output.put_line('line_type: '||r_line_type.line_type);
            END LOOP;
            		-- END   2.5   ----
             IF(UTL_FILE.IS_OPEN( g_file_id )) THEN
                utl_file.fclose(g_file_id);
            END IF;        
				v_fusion_file_name :=  REPLACE(pt_file_name,'.dat','');  -- 2.4
			g_file_id := utl_file.fopen (vv_file_dir , v_fusion_file_name||'_'||r_file_name.BATCH_NAME||'.dat',  'W', 32000);  -- 2.4
            dbms_output.put_line('file_name: '||r_file_name.file_name);
            OPEN r_details FOR ('SELECT Line_content
                                FROM xxmx_hdl_file_temp
                                where file_name = '''||r_file_name.file_name||''''||
                                --' and line_type = ''File Detail''
                                '  and  batch_name = '''|| r_file_name.BATCH_NAME||''''||
                                ' and batch_name is not null order by id ');  -- 2.5
            LOOP


            FETCH r_details  bulk collect into g_extract_data LIMIT 10000; 
            EXIT WHEN g_extract_data.COUNT =0;

                FOR i IN 1..g_extract_data.COUNT LOOP
                    --DBMS_OUTPUT.PUT_LINE(g_extract_data(i));
                    utl_file.put_line (g_file_id, g_extract_data(i));
                END LOOP;
            END LOOP;    

            utl_file.fclose(g_file_id);
        END LOOP;
		  xxmx_zip_file (pt_i_BusinessEntity  => pt_i_businessentity
                      ,pt_dirname    => vv_file_dir
                      ,pt_load_fileID => pt_load_fileID
                      ,pt_filename    => v_fusion_file_name); -- 2.6
    END IF;



       /* update xxmx_loadfile_status_log set status='G' 
        where LOAD_FILE_ID = pt_load_fileID 
        and business_entity=   pt_i_businessentity 
        and status='R';         
        COMMIT;*/

         log_module_message
               (
                pt_i_ApplicationSuite  => null
               ,pt_i_Application       => null
               ,pt_i_BusinessEntity    => pt_i_businessentity
               ,pt_i_SubEntity         => null
               ,pt_i_FileSetID         => 0
               ,pt_i_MigrationSetID    => 0
               ,pt_i_Phase             => gct_Phase
               ,pt_i_Severity          => 'NOTIFICATION'
               ,pt_i_PackageName       => 'xxmx_utilities_pkg'
               ,pt_i_ProcOrFuncName    => 'xxmx_write_dbcs'
               ,pt_i_ProgressIndicator => 0116
               ,pt_i_ModuleMessage     => 'Package:xxmx_utilities_pkg, Load File generated into Server
                                           procedure:xxmx_write_dbcs completed.'
               ,pt_i_OracleError       => NULL
               );

        exception
            when e_ModuleError then
                xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => vt_Applicationsuite
                              ,pt_i_Application       => vt_Application
                              ,pt_i_BusinessEntity    => vt_BusinessEntity
                              ,pt_i_SubEntity         => 'ALL'
                              ,pt_i_MigrationSetID    => 0
                              ,pt_i_Phase             => gct_phase
                              ,pt_i_Severity          => 'ERROR'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => gvt_ModuleMessage
                              ,pt_i_OracleError       => gvt_OracleError
                              );
               raise;
            WHEN OTHERS THEN 
              xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => vt_Applicationsuite
                              ,pt_i_Application       => vt_Application
                              ,pt_i_BusinessEntity    => vt_BusinessEntity
                              ,pt_i_SubEntity         => 'ALL'
                              ,pt_i_MigrationSetID    => 0
                              ,pt_i_Phase             => gct_phase
                              ,pt_i_Severity          => 'ERROR'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => NULL
                              ,pt_i_OracleError       => SUBSTR(SQLERRM,1,1000)
                              );
               raise;

    END xxmx_write_dbcs;

  PROCEDURE xxmx_zip_file (pt_i_BusinessEntity             IN      xxmx_migration_metadata.business_entity%TYPE
                            ,pt_dirname                      IN      VARCHAR2
                            ,pt_load_fileID number
                            ,pt_filename                 IN VARCHAR2 DEFAULT NULL)      -- 2.4                               
    IS


        CURSOR c_zipfile
        IS 
            SELECT DISTINCT BATCH_NAME 
            FROM xxmx_csv_file_temp
            where business_entity =pt_i_BusinessEntity
			and (FILE_NAME = pt_filename OR pt_filename IS NULL)--2.6
            and batch_name is not null
            and line_type <> 'File Header'
            order by batch_name
            ;  

        CURSOR c_filename(p_batchname VARCHAR2)
        IS 
            SELECT distinct File_name from xxmx_csv_File_Temp 
            where business_entity = pt_i_BusinessEntity 
			and (FILE_NAME = pt_filename OR pt_filename IS NULL)--2.6
            and batch_name = p_batchname;

        CURSOR c_zipfile_hdl
        IS 
            			-- START 2.5 ---
            SELECT DISTINCT tmp.BATCH_NAME 
            FROM xxmx_hdl_file_temp tmp,xxmx_loadfile_status_log log
            where tmp.business_entity = pt_i_BusinessEntity
            and tmp.batch_name is not null
            and log.LOAD_FILE_ID = pt_load_fileID
            and tmp.FILE_NAME=log.FILENAME
            and tmp.line_content not like 'METADATA%'
            --and line_type <> 'File Header'
            order by tmp.batch_name; 

        CURSOR c_filename_hdl(p_batchname VARCHAR2)
        IS 
            SELECT distinct tmp.File_name from xxmx_hdl_file_temp tmp,xxmx_loadfile_status_log log 
            where tmp.business_entity = pt_i_BusinessEntity 
            and log.LOAD_FILE_ID = pt_load_fileID
            and tmp.FILE_NAME=log.FILENAME
            and tmp.batch_name = p_batchname;    
            			-- END 2.5 --    

         --************************
          --** Constant Declarations
          --************************
          ct_ProcOrFuncName       CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'xxmx_zip_file';
          --************************
          --** Variable Declarations
          --************************
          --

        g_zipped_blob               blob;
        gv_file_Blob  blob;
        v_file_name  VARCHAR2(200);
        vt_ApplicationSuite     xxmx_module_messages.application_suite%TYPE ;
        vt_Application          xxmx_module_messages.application%TYPE ;
        vt_BusinessEntity       xxmx_migration_metadata.business_entity%TYPE ;
		v_sub_ent               xxmx_migration_metadata.sub_entity%TYPE ;--2.6

        --
          --*************************
          --** Exception Declarations
          --*************************
          --
          e_ModuleError                   EXCEPTION;
          -- 
    BEGIN
        v_file_name:=NULL;
        BEGIN 
        SELECT DISTINCT application_suite
             ,application
             ,business_Entity
        INTO vt_ApplicationSuite,
             vt_Application,
             vt_BusinessEntity
        FROM xxmx_migration_metadata
        where business_entity = pt_i_businessentity
        and enabled_flag= 'Y';
       EXCEPTION
        WHEN OTHERS THEN 
          gvt_ModuleMessage:=  SUBSTR('Entry in Migration Metadata is wrong '|| SQLERRM,1,4000);
          gvt_OracleError := SQLERRM;
          raise e_ModuleError;
        END;

      IF vt_ApplicationSuite IN ('FIN','SCM','PPM')
       THEN
        FOR r_zip in c_zipfile
        LOOP
            g_zipped_blob := NULL;
            FOR rec_filename IN c_filename( r_zip.batch_name)
            LOOP
            dbms_output.put_line(r_zip.BATCH_NAME);
            v_file_name := rec_filename.file_name;
            gv_file_Blob:= NULL;
            --g_zipped_blob := NULL;
            gv_file_Blob:=xxmx_file_zip_utility_pkg.file2blob(pt_dirname,rec_filename.file_name||'_'||r_zip.BATCH_NAME||'.csv');

            xxmx_file_zip_utility_pkg.add1file( g_zipped_blob, rec_filename.file_name,gv_file_Blob);
            END LOOP;
            xxmx_file_zip_utility_pkg.finish_zip( g_zipped_blob );
            SELECT
            sub_entity
           INTO v_sub_ent
            FROM
           xxmx_loadfile_status_log
           WHERE
          load_file_id = pt_load_fileid;
          IF (v_sub_ent='ALL') THEN
            xxmx_file_zip_utility_pkg.save_zip( g_zipped_blob ,pt_dirname,pt_i_BusinessEntity||'_ALL_'||pt_load_fileID||'_'||r_zip.batch_name||'_'||to_char(SYSDATE,'DDMONYYYYHHMISS')||'.zip');
          ELSE  
            xxmx_file_zip_utility_pkg.save_zip( g_zipped_blob ,pt_dirname,pt_i_BusinessEntity||'_'|| v_sub_ent || '_'||pt_load_fileID||'_'||r_zip.batch_name||'_'||to_char(SYSDATE,'DDMONYYYYHHMISS')||'.zip');
          end if;
            --UTL_FILE.FREMOVE (pt_dirname,rec_filename.file_name||'_'||r_zip.BATCH_NAME||'.csv');  
        END LOOP;    
        DBMS_LOB.FILECLOSEALL;

        xxmx_delete_dbfile(pt_i_BusinessEntity  => pt_i_businessentity
                          ,pt_dirname    => pt_dirname
                          ,pt_filename=>pt_filename--2.6
						  ,pt_load_fileID => pt_load_fileID);   -- 2.5

        Update xxmx_csv_File_temp
        set BATCH_NAME  = TRUNC(SYSDATE),
            business_entity = pt_i_BusinessEntity 
        where line_type = 'File Header'
        and file_name = v_file_name;

		update xxmx_loadfile_status_log set status='G' 
        where LOAD_FILE_ID = pt_load_fileID 
        and business_entity=   pt_i_businessentity 
        ;         
        COMMIT;

        END IF;

        IF vt_ApplicationSuite IN ('HCM','OLC','PAY')
         THEN
           FOR r_zip_hdl in c_zipfile_hdl
        LOOP
            g_zipped_blob := NULL;
            FOR rec_filename_hdl IN c_filename_hdl( r_zip_hdl.batch_name)
            LOOP
            dbms_output.put_line(r_zip_hdl.BATCH_NAME);
            v_file_name := rec_filename_hdl.file_name;
            gv_file_Blob:= NULL;
            --g_zipped_blob := NULL;
            gv_file_Blob:=xxmx_file_zip_utility_pkg.file2blob(pt_dirname,pt_filename||'_'||r_zip_hdl.BATCH_NAME||'.dat'); -- 2.4

            xxmx_file_zip_utility_pkg.add1file( g_zipped_blob, pt_filename||'.dat',gv_file_Blob);  -- 2.4
            END LOOP;
            xxmx_file_zip_utility_pkg.finish_zip( g_zipped_blob );
            --xxmx_file_zip_utility_pkg.save_zip( g_zipped_blob ,pt_dirname,pt_i_BusinessEntity||'_'||r_zip_hdl.batch_name||'_'||SYSDATE||'.zip');
            xxmx_file_zip_utility_pkg.save_zip( g_zipped_blob ,pt_dirname,pt_i_BusinessEntity||'_'||pt_load_fileID||'_'||v_file_name||'_'||r_zip_hdl.batch_name||'_'||to_char(SYSDATE,'DDMONYYYYHHMISS')||'.zip'); -- 2.6
            --UTL_FILE.FREMOVE (pt_dirname,rec_filename.file_name||'_'||r_zip.BATCH_NAME||'.csv');  
        END LOOP;    
        DBMS_LOB.FILECLOSEALL;

        xxmx_delete_dbfile(pt_i_BusinessEntity  => pt_i_businessentity
                          ,pt_dirname    => pt_dirname
                          ,pt_filename  => pt_filename  -- 2.4
                          ,pt_load_fileID => pt_load_fileID); -- 2.5

 --        Update xxmx_hdl_File_temp
 --        set BATCH_NAME  = TRUNC(SYSDATE),
--            business_entity = pt_i_BusinessEntity 
--        where LINE_CONTENT like 'METADATA%'
--        and file_name = v_file_name;

        update xxmx_loadfile_status_log set status='G' 
        where LOAD_FILE_ID = pt_load_fileID 
        and business_entity=   pt_i_businessentity 
        ;         
        COMMIT;
        END IF;

        exception
            when e_ModuleError then
                xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => 'ALL'
                              ,pt_i_MigrationSetID    => 0
                              ,pt_i_Phase             => gct_phase
                              ,pt_i_Severity          => 'ERROR'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => gvt_ModuleMessage
                              ,pt_i_OracleError       => NULL
                              );
               raise;
            WHEN OTHERS THEN 
              xxmx_utilities_pkg.log_module_message
                              (
                               pt_i_ApplicationSuite  => gct_ApplicationSuite
                              ,pt_i_Application       => gct_Application
                              ,pt_i_BusinessEntity    => gct_BusinessEntity
                              ,pt_i_SubEntity         => 'ALL'
                              ,pt_i_MigrationSetID    => 0
                              ,pt_i_Phase             => gct_phase
                              ,pt_i_Severity          => 'ERROR'
                              ,pt_i_PackageName       => gct_PackageName
                              ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                              ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                              ,pt_i_ModuleMessage     => NULL
                              ,pt_i_OracleError       => SUBSTR(SQLERRM,1,1000)
                              );
               raise;
    END xxmx_zip_file;

    PROCEDURE   batch_extract_data (
            p_application_suite IN VARCHAR2,
            p_business_entity IN VARCHAR2,
            p_sub_entity IN VARCHAR2 DEFAULT NULL,
            p_batch_count IN NUMBER,
            p_ct_phase IN VARCHAR2 DEFAULT 'EXTRACT'
        ) IS

           ct_ProcOrFuncName       CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'batch_extract_data';

            rc                    NUMBER;
            startrow              NUMBER;
            endrow                NUMBER;
            rowvar                NUMBER;
            pv_batch_identifier   VARCHAR2(100);
            pv_seq_in_fbdi_data   VARCHAR2(100);
            ntile_var             VARCHAR2(100);
            V_EACH_BATCH_COUNT    NUMBER;
            v_position           VARCHAR2(5);
            v_1 VARcHAR2(30);
            v_2 VARcHAR2(30);
            v_3  VARcHAR2(30);
            v_batch_load         VARCHAR2(10);
            v_sql                VARCHAR2(2000);

            type exrtact_cursor_type IS REF CURSOR;
            r_data                        exrtact_cursor_type;

            type extract_data is table of VARCHAR2(300) INDEX BY BINARY_INTEGER;
            g_extract_data          extract_data;

            g_batch                 extract_data;

           v_STG_TABLE  xxmx_migration_metadata.xfm_table%TYPE;--
           v_SEQ_IN_FBDI_DATA  xxmx_migration_metadata.SEQ_IN_FBDI_DATA%TYPE;
           v_column_name xxmx_migration_metadata.SEQ_IN_FBDI_DATA%TYPE;
           v_Batch_name VARCHAR2(300);
           v_batch_seq  NUMBER;
           v_subentity_seq  NUMBER;
           v_batch_subentity NUMBER;
           Subentity_Seq_one_not_batched EXCEPTION; 
           v_rowid     VARCHAR2(300);
           v_new_batch VARCHAR2(300);
           v_common_load_column  VARCHAR2(300);
		   common_load_column_is_null EXCEPTION; --2.3 	
           lv_migration_set_id  xxmx_migration_headers.migration_Set_id%TYPE;
           v_batchname            NUMBER:=0;  
           table_count number;   



       CURSOR c_subentity
       IS
            SELECT distinct BATCH_LOAD
                 ,STG_TABLE
                 ,SEQ_IN_FBDI_DATA
                 ,b.common_load_column
                 ,(select stg_table 
                   FROM xxmx_migration_metadata a
                   WHERE  BUSINESS_ENTITY = p_business_entity
                   AND SUB_ENTITY_SEQ= 1
                   AND ENABLED_FLAG= 'Y') Table_name 
                ,(select common_load_column 
                   FROM xxmx_migration_metadata a1,XXMX_XFM_TABLES b1
                   WHERE  BUSINESS_ENTITY =  p_business_entity
                   AND SUB_ENTITY_SEQ= 1
                   and a1.metadata_id = b1.metadata_id
                   AND ENABLED_FLAG= 'Y') Primary_load_column
            FROM xxmx_migration_metadata a,XXMX_XFM_TABLES b
            WHERE BUSINESS_ENTITY = p_business_entity
            AND SUB_ENTITY = p_sub_entity
            AND SUB_ENTITY_SEQ> 1
            and a.metadata_id = b.metadata_id
            AND ENABLED_FLAG= 'Y'
            AND BATCH_LOAD='Y';



--     BEGIN 
--        SELECT BATCH_LOAD
--              ,STG_TABLE
--              ,SEQ_IN_FBDI_DATA 
--              ,(select common_load_column 
--                   FROM xxmx_migration_metadata a1,XXMX_XFM_TABLES b1
--                   WHERE  BUSINESS_ENTITY =  p_business_entity
--                   AND SUB_ENTITY_SEQ= 1
--                   and a1.metadata_id = b1.metadata_id
--                   AND ENABLED_FLAG= 'Y') Primary_load_column
--        INTO v_batch_load,v_STG_TABLE,v_SEQ_IN_FBDI_DATA,v_common_load_column
--        FROM xxmx_migration_metadata
--        WHERE BUSINESS_ENTITY = p_business_entity
--        AND SUB_ENTITY = DECODE(NVL(p_sub_entity,'ALL'),'ALL', sub_entity, p_sub_entity)
--        AND ENABLED_FLAG= 'Y';
--       -- AND ROWNUM=1;
--     EXCEPTION
--            
--        WHEN OTHERS THEN 
--            v_batch_load:= 'N';
--
--     END;
--        DBMS_OUTPUT.PUT_LINE(v_batch_load);
--        DBMS_OUTPUT.PUT_LINE(v_STG_TABLE);
--        DBMS_OUTPUT.PUT_LINE(v_SEQ_IN_FBDI_DATA);
--        DBMS_OUTPUT.PUT_LINE(v_common_load_column);
--     v_Sql:= 'DELETE from xxmx_dm_file_batch where tablename= '''||v_STG_TABLE||'''';
--
--     DBMS_OUTPUT.PUT_LINE(v_sql);  
--     execute immediate v_Sql;
--
--     commit;
--
--
--     v_Sql:= 'Select max(migration_set_id) from xxmx_stg.'||v_STG_TABLE;
--
--     DBMS_OUTPUT.PUT_LINE(v_sql);  
--     execute immediate v_Sql INTO lv_migration_set_id;
--
--     commit;
--
--     IF( v_batch_load = 'Y' and v_SEQ_IN_FBDI_DATA IS NOT NULL) THEN   
--     dbms_output.put_line('Start1');
--
--
--            v_sql:= 'SELECT distinct '||v_SEQ_IN_FBDI_DATA||' ,
--                            Dense_rank()OVER(ORDER BY m_no) Batch_name 
--                         FROM   ('|| 'SELECT  '||v_SEQ_IN_FBDI_DATA||',
--                        Min(ROWID )OVER(partition BY '||v_SEQ_IN_FBDI_DATA||') AS m_no
--                        FROM   XXMX_STG.'||v_STG_TABLE ||'
--                         WHERE migration_set_id = '||lv_migration_set_id ||' ) ' ;
--
--            DBMS_OUTPUT.PUT_LINE(v_sql);             
--
--            OPEN r_data for v_sql;
--            LOOP
--            v_Batch_name:= NULL;
--            v_column_name := NULL;
--            FETCH r_data INTO v_column_name, v_Batch_name; -- Added new column
--            EXIT when v_Batch_name IS NULL;
--
--                v_sql:= 'Update XXMX_STG.'||v_STG_TABLE ||
--                        ' SET batch_name = '||xxmx_loadfile_batchid_s.nextval ||
--                        ' where '||v_SEQ_IN_FBDI_DATA ||' = '''|| v_column_name||''''
--                        ||' AND migration_set_id = '||lv_migration_set_id;
--
--                DBMS_OUTPUT.PUT_LINE(v_sql);                        
--                EXECUTE IMMEDIATE v_sql;
--
--            END LOOP;
--
--
--    END IF;
--
--     IF(v_batch_load= 'Y'and v_SEQ_IN_FBDI_DATA IS NULL) THEN
--        DBMS_OUTPUT.PUT_LINE(v_batch_load);    
--
--        v_sql := 'SELECT count(*)/'||p_batch_count||
--             ' FROM  XXMX_STG.'||v_stg_table ||
--             ' WHERE migration_set_id = '||lv_migration_set_id;
--
--        DBMS_OUTPUT.PUT_LINE(v_sql||'-'||ntile_var);  
--        EXECUTE IMMEDIATE v_sql INTO ntile_var;   
--        DBMS_OUTPUT.PUT_LINE(v_sql||'-'||ntile_var);
--
--        IF( ROUND(ntile_var) > 0) THEN
--
--                v_sql:='SELECT '''||v_STG_TABLE||''', NTILE('||ntile_var||') OVER( ORDER BY '|| v_common_load_column ||' DESC   ) AS batch_name_1, '
--                        ||v_common_load_column|| '  FROM ( SELECT DISTINCT '||v_common_load_column||' FROM XXMX_STG.'||v_stg_table ||
--                        ' WHERE  migration_set_id = '||lv_migration_set_id ||' )';
--
--                DBMS_OUTPUT.PUT_LINE('TEST3-'||v_sql);
--                execute immediate 'INSERT INTO xxmx_dm_file_batch (tablename,Batch_name , batch_column)  '||v_sql;
--                
--                Commit;
--                
--                v_sql:= 'select distinct Batch_name from xxmx_dm_file_batch';
--                
--                DBMS_OUTPUT.PUT_LINE('TEST3-'||v_sql);
--                
--                Open r_data for v_sql ;
--                Loop 
--                Select  XXMX_LOADFILE_BATCHID_S.nextval
--                INTO v_batch_seq from dual;
--                Fetch r_data into v_batch_name;
--                EXIT when r_data%notfound;
--                    Update xxmx_dm_file_batch
--                    Set SEQUENCEBATCH = v_batch_seq
--                    where batch_name = v_batch_name;
--                END LOOP;
--                
--                Close r_data;
--                Commit;
--
--                v_sql:= ' UPDATE XXMX_STG.'||v_stg_table ||' a 
--                          SET batch_name =  '||' (select SequenceBatch from xxmx_dm_file_batch b where b.batch_column= a.'||v_common_load_column ||
--                                                ' and b.tablename = '''||v_stg_table||''')'||
--                        ' WHERE migration_set_id = '||lv_migration_set_id;
--                DBMS_OUTPUT.PUT_LINE('TEST3-'||v_sql);
--                EXECUTE IMMEDIATE v_sql;
--
--        END IF;
--
--
--
--        FOR rec_subentity IN c_subentity
--        LOOP
--        v_batchname := 0;        
--         v_sql := 'Create Index xxmx_stg.'||rec_subentity.stg_TABLE||'_idx1 on xxmx_stg.'||rec_subentity.stg_TABLE||' ( '||rec_subentity.common_load_column||' )';
--
--         DBMS_OUTPUT.PUT_LINE('TEST3-'||v_sql);
--         EXECUTE IMMEDIATE v_sql;
--
--        v_sql := 'SELECT  distinct '||rec_subentity.Primary_load_column||
--                        ' ,batch_name from '|| rec_subentity.Table_name||
--                        ' where migration_set_id =  '||lv_migration_set_id||
--                         ' order by batch_name ';
--
--        DBMS_OUTPUT.PUT_LINE('TEST3-'||v_sql);
--
--        open r_data for v_sql;
--        LOOP
--        fetch r_data BULK COLLECT into g_extract_data,g_batch Limit 20000;
--        EXIT WHEN  g_extract_data.count=0;
--
--        v_sql:= ' UPDATE XXMX_STG.'||rec_subentity.stg_table ||' a '
--                 ||' SET batch_name = :c' 
--                 ||' WHERE a.migration_set_id = '||lv_migration_set_id
--                 ||' and a. '||rec_subentity.common_load_column||' = :b ';
--
--
--        DBMS_OUTPUT.PUT_LINE('TEST3-'||v_sql);
--        FORALL i in 1..g_extract_data.count
--
--            EXECUTE IMMEDIATE v_sql using g_batch(i), g_extract_data(i);
--
--       END LOOP;
--
--       v_sql := 'DROP Index xxmx_stg.'||rec_subentity.stg_TABLE||'_idx1 ';
--
--       DBMS_OUTPUT.PUT_LINE('TEST3-'||v_sql);
--       EXECUTE IMMEDIATE v_sql;
--
--       END LOOP;
--      END IF;
--   END batch_extract_data; 

 BEGIN        
   IF  p_application_suite IN ('FIN','SCM','PPM') THEN
     BEGIN     
        SELECT BATCH_LOAD
              ,STG_TABLE
              ,SUB_ENTITY_SEQ
              ,SEQ_IN_FBDI_DATA 
              ,(select common_load_column 
                   FROM xxmx_migration_metadata a1,XXMX_XFM_TABLES b1
                   WHERE  BUSINESS_ENTITY =  p_business_entity
                   AND SUB_ENTITY_SEQ= 1
                   and a1.metadata_id = b1.metadata_id
                   AND ENABLED_FLAG= 'Y') Primary_load_column
        INTO v_batch_load,v_STG_TABLE,v_subentity_seq,v_SEQ_IN_FBDI_DATA,v_common_load_column
        FROM xxmx_migration_metadata
        WHERE BUSINESS_ENTITY = p_business_entity
        AND SUB_ENTITY = DECODE(NVL(p_sub_entity,'ALL'),'ALL', sub_entity, p_sub_entity)
        AND ENABLED_FLAG= 'Y';
       -- AND ROWNUM=1;
     EXCEPTION

        WHEN OTHERS THEN 
            v_batch_load:= 'N';

     END;
        DBMS_OUTPUT.PUT_LINE(v_batch_load);
        DBMS_OUTPUT.PUT_LINE(v_STG_TABLE);
        DBMS_OUTPUT.PUT_LINE(v_subentity_seq);
        DBMS_OUTPUT.PUT_LINE(v_SEQ_IN_FBDI_DATA);
        DBMS_OUTPUT.PUT_LINE(v_common_load_column);
     v_Sql:= 'DELETE from xxmx_dm_file_batch where tablename= '''||v_STG_TABLE||'''';

     DBMS_OUTPUT.PUT_LINE(v_sql);  
     execute immediate v_Sql;

     commit;


     v_Sql:= 'Select max(migration_set_id) from xxmx_stg.'||v_STG_TABLE;

     DBMS_OUTPUT.PUT_LINE(v_sql);  
     execute immediate v_Sql INTO lv_migration_set_id;

     commit;

-- IF  p_application_suite IN ('FIN','SCM','PPM') THEN
 DBMS_OUTPUT.PUT_LINE('FIN');
--
   IF  v_subentity_seq=1  THEN 
 DBMS_OUTPUT.PUT_LINE('v_subentity_seq ' || v_subentity_seq);


     IF( v_batch_load = 'Y' and v_SEQ_IN_FBDI_DATA IS NOT NULL) THEN   
     dbms_output.put_line('Start1');
 DBMS_OUTPUT.PUT_LINE('V_BATCH_LOAD IS NOT NULL' ||v_batch_load );


            v_sql:= 'SELECT distinct '||v_SEQ_IN_FBDI_DATA||' ,
                            Dense_rank()OVER(ORDER BY m_no) Load_batch 
                         FROM   ('|| 'SELECT  '||v_SEQ_IN_FBDI_DATA||',
                        Min(ROWID )OVER(partition BY '||v_SEQ_IN_FBDI_DATA||') AS m_no
                        FROM   XXMX_STG.'||v_STG_TABLE ||'
                         WHERE migration_set_id = '||lv_migration_set_id ||' ) ' ;

            DBMS_OUTPUT.PUT_LINE(v_sql);             


            OPEN r_data for v_sql;
            LOOP
            v_Batch_name:= NULL;
            v_column_name := NULL;
            FETCH r_data INTO v_column_name, v_Batch_name; -- Added new column
            EXIT when v_Batch_name IS NULL;

                v_sql:= 'Update XXMX_STG.'||v_STG_TABLE ||
                        ' SET Load_batch = '||xxmx_loadfile_batchid_s.nextval ||
                        ' where '||v_SEQ_IN_FBDI_DATA ||' = '''|| v_column_name||''''
                        ||' AND migration_set_id = '||lv_migration_set_id;

                DBMS_OUTPUT.PUT_LINE(v_sql);                        
                EXECUTE IMMEDIATE v_sql;

            END LOOP;


    END IF;

     IF(v_batch_load= 'Y'and v_SEQ_IN_FBDI_DATA IS NULL) THEN
      DBMS_OUTPUT.PUT_LINE('V_BATCH_LOAD IS  NULL' ||v_batch_load );

        DBMS_OUTPUT.PUT_LINE(v_batch_load);    

        v_sql := 'SELECT count(*)/'||p_batch_count||
             ' FROM  XXMX_STG.'||v_stg_table ||
             ' WHERE migration_set_id = '||lv_migration_set_id;

        DBMS_OUTPUT.PUT_LINE(v_sql||'='||ntile_var);  
        EXECUTE IMMEDIATE v_sql INTO ntile_var;   
        DBMS_OUTPUT.PUT_LINE(v_sql||'='||ntile_var);
	BEGIN
       IF (v_common_load_column is null) then
          dbms_output.put_line(v_common_load_column);
       RAISE common_load_column_is_null;

        else

        IF( ROUND(ntile_var) > 0) THEN

                v_sql:='SELECT '''||v_STG_TABLE||''', NTILE('||ntile_var||') OVER( ORDER BY '|| v_common_load_column ||' DESC   ) AS batch_name_1, '
                        ||v_common_load_column|| '  FROM ( SELECT DISTINCT '||v_common_load_column||' FROM XXMX_STG.'||v_stg_table ||
                        ' WHERE  migration_set_id = '||lv_migration_set_id ||' )';

                DBMS_OUTPUT.PUT_LINE('TEST3-'||v_sql);
                execute immediate 'INSERT INTO xxmx_dm_file_batch (tablename,Batch_name , batch_column)  '||v_sql;

                Commit;

                v_sql:= 'select distinct Batch_name from xxmx_dm_file_batch';

                DBMS_OUTPUT.PUT_LINE('TEST4-'||v_sql);

                Open r_data for v_sql ;
                Loop 
                Select  XXMX_LOADFILE_BATCHID_S.nextval
                INTO v_batch_seq from dual;
                Fetch r_data into v_batch_name;
                EXIT when r_data%notfound;
                    Update xxmx_dm_file_batch
                    Set SEQUENCEBATCH = v_batch_seq
                    where batch_name = v_batch_name;
                END LOOP;

                Close r_data;
                Commit;

                v_sql:= ' UPDATE XXMX_STG.'||v_stg_table ||' a 
                          SET Load_batch =  '||' (select SequenceBatch from xxmx_dm_file_batch b where b.batch_column= a.'||v_common_load_column ||
                                                ' and b.tablename = '''||v_stg_table||''')'||
                        ' WHERE migration_set_id = '||lv_migration_set_id;
                DBMS_OUTPUT.PUT_LINE('TEST5-'||v_sql);
                EXECUTE IMMEDIATE v_sql;

        END IF;
    END IF;
	exception when common_load_column_is_null then --2.3
                dbms_output.put_line('Common_load_column is null in xxmx_xfm_tables for this business entity '||p_business_entity);

            xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => p_application_suite
                         ,pt_i_Application         => null
                         ,pt_i_BusinessEntity      => p_business_entity
                         ,pt_i_SubEntity           => p_sub_entity
                         ,pt_i_MigrationSetID      => 0
                         ,pt_i_Phase               => 'EXTRACT'
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => 'XXMX_UTILITIES_PKG'
                         ,pt_i_ProcOrFuncName      => 'batch_extract_data'
                         ,pt_i_ProgressIndicator   => '0017'
                         ,pt_i_ModuleMessage       => 'Common_load_column is null in xxmx_xfm_tables for this business entity ' ||p_business_entity
                         ,pt_i_OracleError         => SUBSTR(SQLCODE||' '||SQLERRM,1,1000)
                         );

   end;                    
   END IF;
   else

   EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || v_stg_table  INTO table_count; 
        DBMS_OUTPUT.PUT_LINE('v_subentity_seq count(*) ' ||v_stg_table );

    IF table_count > 0 then

    DBMS_OUTPUT.PUT_LINE('Table has data ' || v_stg_table);


    DBMS_OUTPUT.PUT_LINE('v_subentity_seq ELSE' ||v_subentity_seq );

    v_sql:= 'select distinct 1 from xxmx_dm_file_batch 
              where tablename = (select stg_table from xxmx_migration_metadata where SUB_ENTITY_SEQ=1 and BUSINESS_ENTITY='|| '''' ||p_business_entity||'''' ||' )';

    DBMS_OUTPUT.PUT_LINE('ELSE1-'||v_sql);
    BEGIN
    EXECUTE IMMEDIATE v_sql INTO v_batch_subentity;
    EXCEPTION
    WHEN NO_DATA_FOUND THEN
      -- Handle null value case
      v_batch_subentity := null;
    END;
    --EXECUTE IMMEDIATE v_sql INTO v_batch_subentity;
    DBMS_OUTPUT.PUT_LINE('ELSE-'||v_batch_subentity);

    BEGIN
    IF (v_batch_subentity IS NULL)
     THEN 

        RAISE Subentity_Seq_one_not_batched;
    ELSE
        FOR rec_subentity IN c_subentity
        LOOP
        v_batchname := 0;        
         v_sql := 'Create Index xxmx_stg.'||rec_subentity.stg_TABLE||'_idx1 on xxmx_stg.'||rec_subentity.stg_TABLE||' ( '||rec_subentity.common_load_column||' )';

         DBMS_OUTPUT.PUT_LINE('TEST6-'||v_sql);
         EXECUTE IMMEDIATE v_sql;

        v_sql := 'SELECT  distinct '||rec_subentity.Primary_load_column||
                        ' ,Load_batch from '|| rec_subentity.Table_name||
                        ' where migration_set_id =  '||lv_migration_set_id||
                         ' order by Load_batch ';

        DBMS_OUTPUT.PUT_LINE('TEST7-'||v_sql);

        open r_data for v_sql;
        LOOP
        fetch r_data BULK COLLECT into g_extract_data,g_batch Limit 20000;
        EXIT WHEN  g_extract_data.count=0;

        v_sql:= ' UPDATE XXMX_STG.'||rec_subentity.stg_table ||' a '
                 ||' SET Load_batch = :c' 
                 ||' WHERE a.migration_set_id = '||lv_migration_set_id
                 ||' and a. '||rec_subentity.common_load_column||' = :b ';


        DBMS_OUTPUT.PUT_LINE('TEST8-'||v_sql);
        FORALL i in 1..g_extract_data.count

            EXECUTE IMMEDIATE v_sql using g_batch(i), g_extract_data(i);

       END LOOP;

       v_sql := 'DROP Index xxmx_stg.'||rec_subentity.stg_TABLE||'_idx1 ';

       DBMS_OUTPUT.PUT_LINE('TEST3-'||v_sql);
       EXECUTE IMMEDIATE v_sql;

       END LOOP;


      END IF;

      EXCEPTION
        WHEN Subentity_Seq_one_not_batched THEN
            dbms_output.put_line('SubEntity Sequence 1 is not batched for this Business Entity. Please do batch first for SubEntity Sequence 1');

            xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => p_application_suite
                         ,pt_i_Application         => null
                         ,pt_i_BusinessEntity      => p_business_entity
                         ,pt_i_SubEntity           => p_sub_entity
                         ,pt_i_MigrationSetID      => 0
                         ,pt_i_Phase               => 'EXTRACT'
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => 'XXMX_UTILITIES_PKG'
                         ,pt_i_ProcOrFuncName      => 'batch_extract_data'
                         ,pt_i_ProgressIndicator   => '0017'
                         ,pt_i_ModuleMessage       => 'SubEntity Sequence 1 is not batched for this Business Entity. Please do batch first for SubEntity Sequence 1'
                         ,pt_i_OracleError         => SUBSTR(SQLCODE||' '||SQLERRM,1,1000)
                         );
      END;
          DBMS_OUTPUT.PUT_LINE('v_subentity_seq ELSE END' ||v_subentity_seq );


    ELSE
         DBMS_OUTPUT.PUT_LINE('The table has no data for batching' ||v_STG_TABLE );
             xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => p_application_suite
                         ,pt_i_Application         => null
                         ,pt_i_BusinessEntity      => p_business_entity
                         ,pt_i_SubEntity           => p_sub_entity
                         ,pt_i_MigrationSetID      => 0
                         ,pt_i_Phase               => 'EXTRACT'
                         ,pt_i_Severity            => ''
                         ,pt_i_PackageName         => 'XXMX_UTILITIES_PKG'
                         ,pt_i_ProcOrFuncName      => 'batch_extract_data'
                         ,pt_i_ProgressIndicator   => '0018'
                         ,pt_i_ModuleMessage       => p_sub_entity ||' SubEntity stage table has no data for batching'
                         ,pt_i_OracleError         => SUBSTR(SQLCODE||' '||SQLERRM,1,1000)
                         );
   END IF;
   END IF;
   END IF;
   IF p_application_suite = 'HCM'  
     THEN
     BEGIN 
        SELECT BATCH_LOAD
              ,SUB_ENTITY_SEQ
              ,STG_TABLE
              ,SEQ_IN_FBDI_DATA 
              ,(select common_load_column 
                   FROM xxmx_migration_metadata a1,XXMX_XFM_TABLES b1
                   WHERE  BUSINESS_ENTITY =  p_business_entity
                   AND SUB_ENTITY_SEQ= 1
                   and a1.metadata_id = b1.metadata_id
                   AND ENABLED_FLAG= 'Y') Primary_load_column
        INTO v_batch_load,v_subentity_seq,v_STG_TABLE,v_SEQ_IN_FBDI_DATA,v_common_load_column
        FROM xxmx_migration_metadata
        WHERE BUSINESS_ENTITY = p_business_entity
        AND SUB_ENTITY = DECODE(NVL(p_sub_entity,'ALL'),'ALL', sub_entity, p_sub_entity)
        AND ENABLED_FLAG= 'Y';
     EXCEPTION

        WHEN OTHERS THEN 
            v_batch_load:= 'N';

     END;

        DBMS_OUTPUT.PUT_LINE(v_batch_load);
        DBMS_OUTPUT.PUT_LINE(v_subentity_seq);
        DBMS_OUTPUT.PUT_LINE(v_STG_TABLE);
        DBMS_OUTPUT.PUT_LINE(v_SEQ_IN_FBDI_DATA);
        DBMS_OUTPUT.PUT_LINE(v_common_load_column);
     v_Sql:= 'DELETE from xxmx_dm_file_batch where tablename= '''||v_STG_TABLE||'''';

     DBMS_OUTPUT.PUT_LINE(v_sql);  
     execute immediate v_Sql;
     commit;

     v_Sql:= 'Select max(migration_set_id) from xxmx_stg.'||v_STG_TABLE;

     DBMS_OUTPUT.PUT_LINE(v_sql);  
     execute immediate v_Sql INTO lv_migration_set_id;
     commit;

     DBMS_OUTPUT.PUT_LINE('HCM');

     IF v_subentity_seq = 1 
     THEN DBMS_OUTPUT.PUT_LINE('v_subentity_seq ' || v_subentity_seq);

        IF( v_batch_load = 'Y' AND v_SEQ_IN_FBDI_DATA IS NOT NULL) 
        THEN 
     dbms_output.put_line('Batch Load is Y and v_SEQ_IN_FBDI_DATA is not NULL ');


            v_sql:= 'SELECT distinct '||v_SEQ_IN_FBDI_DATA||' ,
                            Dense_rank()OVER(ORDER BY m_no) Batch_name 
                         FROM   ('|| 'SELECT  '||v_SEQ_IN_FBDI_DATA||',
                        Min(ROWID )OVER(partition BY '||v_SEQ_IN_FBDI_DATA||') AS m_no
                        FROM   XXMX_STG.'||v_STG_TABLE ||'
                         WHERE migration_set_id = '||lv_migration_set_id ||' ) ' ;

            DBMS_OUTPUT.PUT_LINE(v_sql);             

            OPEN r_data for v_sql;
            LOOP
            v_Batch_name:= NULL;
            v_column_name := NULL;
            FETCH r_data INTO v_column_name, v_Batch_name; -- Added new column
            EXIT when v_Batch_name IS NULL;

                v_sql:= 'Update XXMX_STG.'||v_STG_TABLE ||
                        ' SET batch_name = '||xxmx_loadfile_batchid_s.nextval ||
                        ' where '||v_SEQ_IN_FBDI_DATA ||' = '''|| v_column_name||''''
                        ||' AND migration_set_id = '||lv_migration_set_id;

                DBMS_OUTPUT.PUT_LINE(v_sql);                        
                EXECUTE IMMEDIATE v_sql;

            END LOOP;   
       END IF; 
       IF(v_batch_load= 'Y'and v_SEQ_IN_FBDI_DATA IS NULL) THEN
        DBMS_OUTPUT.PUT_LINE('Batch Load is Y and v_SEQ_IN_FBDI_DATA is NULL');    

        v_sql := 'SELECT count(*)/'||p_batch_count||
             ' FROM  XXMX_STG.'||v_stg_table ||
             ' WHERE migration_set_id = '||lv_migration_set_id;

        DBMS_OUTPUT.PUT_LINE(v_sql||'='||ntile_var);  
        EXECUTE IMMEDIATE v_sql INTO ntile_var;   
        DBMS_OUTPUT.PUT_LINE(v_sql||'='||ntile_var);

        IF( ROUND(ntile_var) > 0) THEN

                v_sql:='SELECT '''||v_STG_TABLE||''', NTILE('||ntile_var||') OVER( ORDER BY '|| v_common_load_column ||' DESC   ) AS batch_name_1, '
                        ||v_common_load_column|| '  FROM ( SELECT DISTINCT '||v_common_load_column||' FROM XXMX_STG.'||v_stg_table ||
                        ' WHERE  migration_set_id = '||lv_migration_set_id ||' )';

                DBMS_OUTPUT.PUT_LINE('TEST3-'||v_sql);
                execute immediate 'INSERT INTO xxmx_dm_file_batch (tablename,Batch_name , batch_column)  '||v_sql;

                Commit;

                v_sql:= 'select distinct Batch_name from xxmx_dm_file_batch';

                DBMS_OUTPUT.PUT_LINE('TEST4-'||v_sql);

                Open r_data for v_sql ;
                Loop 
                Select  XXMX_LOADFILE_BATCHID_S.nextval
                INTO v_batch_seq from dual;
                Fetch r_data into v_batch_name;
                EXIT when r_data%notfound;
                    Update xxmx_dm_file_batch
                    Set SEQUENCEBATCH = v_batch_seq
                    where batch_name = v_batch_name;
                END LOOP;

                Close r_data;
                Commit;

                v_sql:= ' UPDATE XXMX_STG.'||v_stg_table ||' a 
                          SET batch_name =  '||' (select SequenceBatch from xxmx_dm_file_batch b where b.batch_column= a.'||v_common_load_column ||
                                                ' and b.tablename = '''||v_stg_table||''')'||
                        ' WHERE migration_set_id = '||lv_migration_set_id;
                DBMS_OUTPUT.PUT_LINE('TEST5-'||v_sql);
                EXECUTE IMMEDIATE v_sql;

        END IF;        
      END IF;
   ELSE 
        EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ' || v_stg_table  INTO table_count; 
        DBMS_OUTPUT.PUT_LINE('v_subentity_seq count(*) ' ||v_stg_table );

        IF table_count > 0 then

    DBMS_OUTPUT.PUT_LINE('Table has data ' || v_stg_table);

        DBMS_OUTPUT.PUT_LINE('v_subentity_seq ELSE' ||v_subentity_seq );
     v_sql:= 'select distinct 1 from xxmx_dm_file_batch 
              where tablename = (select stg_table from xxmx_migration_metadata where SUB_ENTITY_SEQ=1 and BUSINESS_ENTITY='''||p_business_entity ||''' )';

    DBMS_OUTPUT.PUT_LINE('ELSE1-'||v_sql);
    BEGIN
    EXECUTE IMMEDIATE v_sql INTO v_batch_subentity;
    DBMS_OUTPUT.PUT_LINE('ELSE2-'||v_batch_subentity);
    EXCEPTION 
    WHEN NO_DATA_FOUND THEN
    -- Handle null value case
      v_batch_subentity := null;
    END;  

    BEGIN
    IF (v_batch_subentity IS NULL)
     THEN 
        RAISE Subentity_Seq_one_not_batched;
    ELSE
     FOR rec_subentity IN c_subentity
        LOOP
        v_batchname := 0;        
         v_sql := 'Create Index xxmx_stg.'||rec_subentity.stg_TABLE||'_idx1 on xxmx_stg.'||rec_subentity.stg_TABLE||' ( '||rec_subentity.common_load_column||' )';

         DBMS_OUTPUT.PUT_LINE('TEST6-'||v_sql);
         EXECUTE IMMEDIATE v_sql;

        v_sql := 'SELECT  distinct '||rec_subentity.Primary_load_column||
                        ' ,batch_name from '|| rec_subentity.Table_name||
                        ' where migration_set_id =  '||lv_migration_set_id||
                         ' order by batch_name ';

        DBMS_OUTPUT.PUT_LINE('TEST7-'||v_sql);
    BEGIN
        open r_data for v_sql;
        LOOP
        fetch r_data BULK COLLECT into g_extract_data,g_batch Limit 20000;
        EXIT WHEN  g_extract_data.count=0;

        v_sql:= ' UPDATE XXMX_STG.'||rec_subentity.stg_table ||' a '
                 ||' SET batch_name = :c' 
                 ||' WHERE a.migration_set_id = '||lv_migration_set_id
                 ||' and a. '||rec_subentity.common_load_column||' = :b ';


        DBMS_OUTPUT.PUT_LINE('TEST8-'||v_sql);
        FORALL i in 1..g_extract_data.count

            EXECUTE IMMEDIATE v_sql using g_batch(i), g_extract_data(i);
            DBMS_OUTPUT.PUT_LINE('Updated '|| sql%rowcount ||' records for' ||rec_subentity.stg_table);
       END LOOP;
       EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Data Not Updated '|| sql%rowcount);
 END;
       v_sql := 'DROP Index xxmx_stg.'||rec_subentity.stg_TABLE||'_idx1 ';

       DBMS_OUTPUT.PUT_LINE('TEST9-'||v_sql);
       EXECUTE IMMEDIATE v_sql;

       END LOOP;

    END IF;
    EXCEPTION
        WHEN Subentity_Seq_one_not_batched THEN
            dbms_output.put_line('SubEntity Sequence 1 is not batched for this Business Entity. Please do batch first for SubEntity Sequence 1');

            xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => p_application_suite
                         ,pt_i_Application         => null
                         ,pt_i_BusinessEntity      => p_business_entity
                         ,pt_i_SubEntity           => p_sub_entity
                         ,pt_i_MigrationSetID      => 0
                         ,pt_i_Phase               => 'EXTRACT'
                         ,pt_i_Severity            => 'ERROR'
                         ,pt_i_PackageName         => 'XXMX_UTILITIES_PKG'
                         ,pt_i_ProcOrFuncName      => 'batch_extract_data'
                         ,pt_i_ProgressIndicator   => '0017'
                         ,pt_i_ModuleMessage       => 'SubEntity Sequence 1 is not batched for this Business Entity. Please do batch first for SubEntity Sequence 1'
                         ,pt_i_OracleError         => SUBSTR(SQLCODE||' '||SQLERRM,1,1000)
                         );
   END; 
        DBMS_OUTPUT.PUT_LINE('v_subentity_seq ELSE END' ||v_subentity_seq );
   END IF;
   END IF;
   END IF;
   END batch_extract_data; 


   PROCEDURE XXMX_COMMIT (p_sec IN VARCHAR2)
      as 
   BEGIN 
        COMMIT;
        DBMS_session.sleep(p_sec);

  END;

    procedure XXMX_Write_ORACLEDB_SCH (pt_i_BusinessEntity   IN  xxmx_migration_metadata.business_entity%TYPE,
                                         pt_load_fileID number,
                                         pt_file_name IN VARCHAR2 DEFAULT NULL)  -- 2.4
   AS

  BEGIN 
    dbms_scheduler.create_job (
          job_name   =>  pt_i_BusinessEntity||'_'||'Batch_Load',
          job_type   => 'PLSQL_BLOCK',
          job_action => 
            'BEGIN 
             xxmx_utilities_pkg.xxmx_write_dbcs ( 
							 pt_i_BusinessEntity           => '''||pt_i_BusinessEntity||'''
                             ,pt_load_fileID =>  '''||pt_load_fileID||'''
                             ,pt_file_name =>  '''||pt_file_name||''') ;
             END;',
          enabled   =>  TRUE,  
          auto_drop =>  TRUE, 
          comments  =>  'Run '||pt_i_BusinessEntity||'_'||'Batch_Load'); 
    dbms_output.put_line('sch'||' '|| pt_i_BusinessEntity);
  END XXMX_Write_ORACLEDB_SCH;

  PROCEDURE   XXMX_LOADDB_FILE (
    pv_i_business_entity IN VARCHAR2,
    pv_i_subentity       IN VARCHAR2,
    pv_i_file_name       IN VARCHAR2,
    pv_i_data_file       IN VARCHAR2,
    pv_i_load_file_id         IN VARCHAR2
) IS

    TYPE extract_data IS
        TABLE OF VARCHAR2(32000) INDEX BY BINARY_INTEGER;
    g_extract_data  extract_data;
    e_moduleerror EXCEPTION;
    vv_file_dir     VARCHAR2(80);
    vv_file_dirpath VARCHAR2(200);
    g_file_id       utl_file.file_type;
    lv_dirname      VARCHAR2(200);
    TYPE refcursor_t IS REF CURSOR;
    csv_file        refcursor_t;
    g_zipped_blob   BLOB;
    gv_file_blob    BLOB;
    v_file_name     VARCHAR2(200);
    v_sql           VARCHAR2(32000);
    v_zip_file      VARCHAR2(200);
    vt_ApplicationSuite     xxmx_module_messages.application_suite%TYPE ;
BEGIN

 log_module_message
                         (
                          pt_i_ApplicationSuite    => null
                         ,pt_i_Application         => null
                         ,pt_i_BusinessEntity      => pv_i_business_entity
                         ,pt_i_SubEntity           => pv_i_subentity
                         ,pt_i_MigrationSetID      => 0
                         ,pt_i_Phase               => 'CORE'
                         ,pt_i_Severity            => 'NOTIFICATION'
                         ,pt_i_PackageName         => 'XXMX_UTILITIES_PKG'
                         ,pt_i_ProcOrFuncName      => 'XXMX_LOADDB_FILE'
                         ,pt_i_ProgressIndicator   => '0018'
                         ,pt_i_ModuleMessage       => 'Writing Load File into Db server intialised'
                         ,pt_i_OracleError         => SUBSTR(SQLCODE||' '||SQLERRM,1,1000)
                         );
    BEGIN
        SELECT
            file_location --|| lower(pv_i_subentity)
        INTO lv_dirname
        FROM
            xxmx_file_locations
        WHERE
                business_entity = pv_i_business_entity
            AND file_location_type = 'FTP_OUTPUT';

            DBMS_OUTPUT.PUT_LINE(pv_i_subentity || pv_i_business_entity ||' '||lv_dirname);

    EXCEPTION
        WHEN OTHERS THEN 
                        --gvt_ModuleMessage := SQLERRM;
            RAISE e_moduleerror;
    END;

    BEGIN
        SELECT
            directory_name,
            directory_path
        INTO
            vv_file_dir,
            vv_file_dirpath
        FROM
            all_directories
        WHERE
            ( directory_path LIKE '%'
                                  || lv_dirname
                                  || '%'
              OR directory_name LIKE '%'
                                     || lv_dirname
                                     || '%' );
       DBMS_OUTPUT.PUT_LINE(lv_dirname ||' '|| vv_file_dir|| ' '||vv_file_dirpath);


    EXCEPTION
        WHEN OTHERS THEN 
                       -- gvt_ModuleMessage := SQLERRM;

            RAISE e_moduleerror;
    END;

      /* Update the files present in the directory to the table*/

DELETE FROM XXMX_LIST_DB_LOADFILE 
      where business_entity = pv_i_business_entity
      and sub_entity= pv_i_subentity;
       
    INSERT INTO XXMX_LIST_DB_LOADFILE
    (filename,dir_path,last_update_date,business_entity,sub_entity,load_file_id)
    values (pv_i_file_name,lv_dirname,sysdate,pv_i_business_entity,pv_i_subentity,pv_i_load_file_id);

    COMMIT;
    
    SELECT DISTINCT application_suite
        INTO vt_ApplicationSuite
    FROM xxmx_migration_metadata
    where business_entity = pv_i_business_entity
    and sub_entity=pv_i_subentity
    and enabled_flag= 'Y';
    dbms_output.put_line('vt_ApplicationSuite '||vt_ApplicationSuite);

     xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => vt_ApplicationSuite
                         ,pt_i_Application         => null
                         ,pt_i_BusinessEntity      => pv_i_business_entity
                         ,pt_i_SubEntity           => pv_i_subentity
                         ,pt_i_MigrationSetID      => 0
                         ,pt_i_Phase               => 'CORE'
                         ,pt_i_Severity            => 'NOTIFICATION'
                         ,pt_i_PackageName         => 'XXMX_UTILITIES_PKG'
                         ,pt_i_ProcOrFuncName      => 'XXMX_LOADDB_FILE'
                         ,pt_i_ProgressIndicator   => '0019'
                         ,pt_i_ModuleMessage       => 'Writing Load File into Db server'
                         ,pt_i_OracleError         => SUBSTR(SQLCODE||' '||SQLERRM,1,1000)
                         );
 IF vt_ApplicationSuite IN ('HCM','OLC','PAY')   THEN



    g_file_id := utl_file.fopen(vv_file_dir, pv_i_file_name, 'W', 32000);
    OPEN csv_file FOR SELECT
                          line_content
                      FROM
                          xxmx_hdl_file_temp
                      WHERE
                          file_name = REPLACE(pv_i_data_file,'.dat','')
                          order by Id;

    LOOP
        FETCH csv_file
        BULK COLLECT INTO g_extract_data;
        EXIT WHEN g_extract_data.count = 0;
        FORALL i IN 1..g_extract_data.count
            EXECUTE IMMEDIATE 'begin UTL_FILE.PUT_LINE(:1, :2); end;'
                USING g_file_id, g_extract_data(i);

    END LOOP;

    utl_file.fclose(g_file_id);
    CLOSE csv_file;
 --  gv_file_blob := NULL;
            --g_zipped_blob := NULL;
    --gv_file_blob := xxmx_file_zip_utility_pkg.file2blob(vv_file_dir, pv_i_file_name);
    --xxmx_file_zip_utility_pkg.add1file(g_zipped_blob, pv_i_file_name, gv_file_blob);
    --xxmx_file_zip_utility_pkg.finish_zip(g_zipped_blob);
    --v_zip_file := replace(pv_i_data_file, '.dat', '')
                  --|| '_'
                  --|| to_char(sysdate, 'DDMONRRRRHHMISS')
                  --|| '.zip';



   dbms_output.put_line('vv_file_dirpath ' ||vv_file_dirpath|| 'pv_i_data_file'||pv_i_data_file);
   -- COMMIT;

END IF;

 IF vt_ApplicationSuite IN ('FIN','SCM','PPM') THEN
    g_file_id := utl_file.fopen(vv_file_dir, pv_i_file_name, 'W', 32000);
        dbms_output.put_line('vv_file_dir '|| vv_file_dir||' '||pv_i_file_name);

    OPEN csv_file FOR SELECT
                          line_content
                      FROM
                          xxmx_csv_file_temp
                      WHERE
                          file_name = pv_i_data_file
                      and line_type <> 'File Header';
    dbms_output.put_line('inside ');

    LOOP
        dbms_output.put_line('inside LOOP');

        FETCH csv_file
        BULK COLLECT INTO g_extract_data;

        EXIT WHEN g_extract_data.count = 0;
        FORALL i IN 1..g_extract_data.count
            EXECUTE IMMEDIATE 'begin UTL_FILE.PUT_LINE(:1, :2); end;'
                USING g_file_id, g_extract_data(i);
    dbms_output.put_line('INSIDE BULK -g_extract_data');

    END LOOP;

    utl_file.fclose(g_file_id);
    CLOSE csv_file;
     --gv_file_blob := NULL;
            --g_zipped_blob := NULL;
    --gv_file_blob := xxmx_file_zip_utility_pkg.file2blob(vv_file_dir, pv_i_file_name);
    --xxmx_file_zip_utility_pkg.add1file(g_zipped_blob, pv_i_file_name, gv_file_blob);
    --xxmx_file_zip_utility_pkg.finish_zip(g_zipped_blob);
    --v_zip_file := replace(pv_i_data_file, '.csv', '')
                  --|| '_'
                  --|| to_char(sysdate, 'DDMONRRRRHHMISS')
                  --|| '.zip';


END IF;
    UPDATE xxmx_list_db_loadfile
    SET
        status = 'C'
    WHERE
        business_entity = pv_i_business_entity
    AND sub_entity = pv_i_subentity
    and load_file_id=pv_i_load_file_id;

COMMIT;


 xxmx_utilities_pkg.log_module_message
                         (
                          pt_i_ApplicationSuite    => vt_ApplicationSuite
                         ,pt_i_Application         => null
                         ,pt_i_BusinessEntity      => pv_i_business_entity
                         ,pt_i_SubEntity           => pv_i_subentity
                         ,pt_i_MigrationSetID      => 0
                         ,pt_i_Phase               => 'CORE'
                         ,pt_i_Severity            => 'NOTIFICATION'
                         ,pt_i_PackageName         => 'XXMX_UTILITIES_PKG'
                         ,pt_i_ProcOrFuncName      => 'XXMX_LOADDB_FILE'
                         ,pt_i_ProgressIndicator   => '0020'
                         ,pt_i_ModuleMessage       => 'Writing Load File into Db server Ended'
                         ,pt_i_OracleError         => SUBSTR(SQLCODE||' '||SQLERRM,1,1000)
                         );
END XXMX_LOADDB_FILE;

procedure XXMX_LOADDB_ORACLEDB_SCH ( pv_i_business_entity IN VARCHAR2,
    pv_i_subentity       IN VARCHAR2,
    pv_i_file_name       IN VARCHAR2,
    pv_i_data_file       IN VARCHAR2,
    pv_i_load_file_id    IN VARCHAR2)
  AS

  BEGIN 
    dbms_scheduler.create_job (
          job_name   =>  pv_i_business_entity||'_'||'LoadFileDB'||'_'||pv_i_subentity,
          job_type   => 'PLSQL_BLOCK',
          job_action => 
             'BEGIN 
             xxmx_utilities_pkg.XXMX_LOADDB_FILE ( 
							 pv_i_business_entity           => '''||pv_i_business_entity||'''
                             ,pv_i_subentity =>  '''||pv_i_subentity||'''
							 ,pv_i_file_name =>  '''||pv_i_file_name||'''
                             ,pv_i_data_file =>  '''||pv_i_data_file||'''
                             ,pv_i_load_file_id =>  '''||pv_i_load_file_id||''') ;
             END;',
          enabled   =>  TRUE,  
          auto_drop =>  TRUE, 
          comments  =>  'Run '||'_'||'LoadFileDB'); 
    dbms_output.put_line('sch'||' LoadFileDB');
  END XXMX_LOADDB_ORACLEDB_SCH;

  procedure DELETE_ZIPFILE_NONBATCHING(pv_i_business_entity varchar2) is
    e_moduleerror EXCEPTION;
    vv_file_dir     VARCHAR2(80);
    vv_file_dirpath VARCHAR2(200);
    g_file_id       utl_file.file_type;
    lv_dirname      VARCHAR2(200);
    TYPE refcursor_t IS REF CURSOR;
    csv_file        refcursor_t;
    g_zipped_blob   BLOB;
    gv_file_blob    BLOB;
    v_file_name     VARCHAR2(200);
    v_sql           VARCHAR2(32000);
    v_zip_file      VARCHAR2(200);

begin
 SELECT
            file_location --|| lower(pv_i_subentity)
        INTO lv_dirname
        FROM
            xxmx_file_locations
        WHERE
                business_entity = pv_i_business_entity
            AND file_location_type = 'FTP_OUTPUT';


  SELECT
            directory_name,
            directory_path
        INTO
            vv_file_dir,
            vv_file_dirpath
        FROM
            all_directories
        WHERE
            ( directory_path LIKE '%'
                                  || lv_dirname
                                  || '%'
              OR directory_name LIKE '%'
                                     || lv_dirname
                                     || '%' );


    DELETE FROM dir_list;

    v_sql := 'INSERT INTO DIR_LIST ( SELECT column_value AS file_name
                FROM   TABLE(sys.ob_get_files('
                             || ''''
                             || vv_file_dirpath
                             || ''')))';
    dbms_output.put_line(v_sql);
    EXECUTE IMMEDIATE v_sql;
    FOR rec IN (
        SELECT
            file_name
        FROM
            dir_list
        where 
             lower(file_name) like '%.zip'

    ) LOOP
        utl_file.fremove(vv_file_dir, rec.file_name);
    END LOOP;  

    end DELETE_ZIPFILE_NONBATCHING;

  PROCEDURE XXMX_ZIP_FILE_NONBATCHING (
    pt_i_businessentity IN xxmx_migration_metadata.business_entity%TYPE,
    pt_i_subentity      IN xxmx_migration_metadata.sub_entity%TYPE DEFAULT NULL,
    pt_dirname          IN VARCHAR2,
    pv_i_file_name      IN VARCHAR2 DEFAULT NULL,
    pt_i_load_file_id   IN NUMBER)

    IS

    CURSOR c_zipfile IS
    SELECT DISTINCT
        filename
    FROM
        XXMX_LIST_DB_LOADFILE
    WHERE
            business_entity = pt_i_businessentity
--        AND batch_name IS NULL
--        AND line_type <> 'File Header'
    ORDER BY
        filename;

    CURSOR c_zipfile_hdl IS
    SELECT DISTINCT
        filename
    FROM
        XXMX_LIST_DB_LOADFILE
    WHERE
            business_entity = pt_i_businessentity
            and sub_entity =pt_i_subentity
--        AND batch_name IS NULL
            --and line_type <> 'File Header'
    ORDER BY
        filename;     
          --************************
          --** Constant Declarations
          --************************
    ct_procorfuncname    CONSTANT xxmx_module_messages.proc_or_func_name%TYPE := 'xxmx_zip_file_nonbatching';
    gct_application      CONSTANT xxmx_module_messages.application%TYPE := 'XXMX';
    gct_applicationsuite CONSTANT xxmx_module_messages.application_suite%TYPE := 'XXMX';
    gvt_severity         xxmx_module_messages.severity%TYPE;
    gvt_modulemessage    xxmx_module_messages.module_message%TYPE;
    gvt_oracleerror      xxmx_module_messages.oracle_error%TYPE;
    gct_BusinessEntity              CONSTANT  xxmx_migration_metadata.business_entity%TYPE := 'XXMX_CORE';
    gct_Phase                                 xxmx_module_messages.phase%TYPE              := 'CORE';
    lv_hcm_pv_file_name  xxmx_hcm_datafile_xfm_map.FUSION_DATA_FILE_NAME%TYPE; -- Pallavi

    --gvv_ApplicationErrorMessage               VARCHAR2(2048);
    -- gvv_ProgressIndicator                     VARCHAR2(100);

          --         
          --************************
          --** Variable Declarations
          --************************
          --

    g_zipped_blob        BLOB;
    gv_file_blob         BLOB;
    v_file_name          VARCHAR2(200);
    v_datafile_name          VARCHAR2(200);
    vt_applicationsuite  xxmx_module_messages.application_suite%TYPE;
    vt_application       xxmx_module_messages.application%TYPE;
    vt_businessentity    xxmx_migration_metadata.business_entity%TYPE;

        --
          --*************************
          --** Exception Declarations
          --*************************
          --
    e_moduleerror EXCEPTION;
          -- 

BEGIN
    v_file_name := NULL;
    BEGIN
        SELECT DISTINCT
            application_suite,
            application,
            business_entity
        INTO
            vt_applicationsuite,
            vt_application,
            vt_businessentity
        FROM
            xxmx_migration_metadata
        WHERE
                business_entity = pt_i_businessentity
            AND enabled_flag = 'Y';

    EXCEPTION
        WHEN OTHERS THEN
            gvt_modulemessage := substr('Entry in Migration Metadata is wrong ' || sqlerrm, 1, 4000);
            gvt_oracleerror := sqlerrm;
            RAISE e_moduleerror;
    END;



    IF vt_applicationsuite IN ( 'FIN', 'SCM', 'PPM' ) THEN
        g_zipped_blob := NULL;
        FOR r_zip IN c_zipfile LOOP

            v_file_name := r_zip.filename;
            gv_file_blob := NULL;
            --g_zipped_blob := NULL;
            gv_file_blob := xxmx_file_zip_utility_pkg.file2blob(pt_dirname, r_zip.filename);

            dbms_output.put_line(r_zip.filename);
            xxmx_file_zip_utility_pkg.add1file(g_zipped_blob, r_zip.filename, gv_file_blob);

        END LOOP;

        xxmx_file_zip_utility_pkg.finish_zip(g_zipped_blob);
	    IF (pt_i_subentity='ALL') THEN--2.6
        xxmx_file_zip_utility_pkg.save_zip(g_zipped_blob, pt_dirname, pt_i_businessentity
                                                                      ||'_ALL_'
                                                                      ||pt_i_load_file_id
                                                                      ||'_'
                                                                      || to_char(SYSDATE,'DDMONYYYYHHMISS')
                                                                      || '.zip');
        else 
        xxmx_file_zip_utility_pkg.save_zip(g_zipped_blob, pt_dirname, pt_i_businessentity
                                                                      ||'_'  
                                                                      || pt_i_subentity
                                                                      ||'_'
                                                                      ||pt_i_load_file_id
                                                                      ||'_'
                                                                      || to_char(SYSDATE,'DDMONYYYYHHMISS')
                                                                      || '.zip');                                                              
        end if;--2.6
	    dbms_lob.filecloseall;
        xxmx_delete_dbfile_nonbatching(pt_i_businessentity => pt_i_businessentity, pt_dirname => pt_dirname);

        DELETE FROM XXMX_LIST_DB_LOADFILE where business_entity=pt_i_businessentity;

        UPDATE xxmx_loadfile_status_log
        SET STATUS = 'G',
        last_update_date = sysdate
        WHERE load_file_id = pt_i_load_file_id;

        commit;
    END IF;

    IF vt_applicationsuite IN ( 'HCM','OLC','PAY' ) THEN   dbms_output.put_line('HCM');
    BEGIN
        SELECT filename
        INTO
            v_datafile_name
        FROM
            xxmx_loadfile_status_log
        WHERE
                business_entity = pt_i_businessentity
            AND load_file_id = pt_i_load_file_id;

    EXCEPTION
        WHEN OTHERS THEN
            gvt_modulemessage := substr('Entry in xxmx_loadfile_status_log is wrong ' || sqlerrm, 1, 4000);
            gvt_oracleerror := sqlerrm;
            RAISE e_moduleerror;
    END;

    BEGIN 
        SELECT DISTINCT FUSION_DATA_FILE_NAME
        INTO lv_hcm_pv_file_name
        FROM xxmx_hcm_datafile_xfm_map a, xxmx_loadfile_status_log b
        WHERE a.business_entity= b.business_entity
        and a.sub_entity = b.sub_entity
        and a.data_file_name = b.filename
        and load_file_id = pt_i_load_file_id
        AND REPLACE(FUSION_DATA_FILE_NAME,'.dat','')<> DATA_FILE_NAME ;
        EXCEPTION
            WHEN OTHERS THEN 
                lv_hcm_pv_file_name:= NULL;
    END;

      g_zipped_blob := NULL;
        FOR r_zip_hdl IN c_zipfile_hdl LOOP


            --v_file_name := (pv_i_file_name||'.dat');
            v_file_name:= r_zip_hdl.filename;
            IF(lv_hcm_pv_file_name IS NOT NULL ) THEN 
                BEGIN 
                    UTL_FILE.FRENAME ( pt_dirname,r_zip_hdl.filename,   pt_dirname ,lv_hcm_pv_file_name,FALSE);

                    UPDATE XXMX_LIST_DB_LOADFILE
                    SET FILENAME = lv_hcm_pv_file_name
                    WHERE LOAD_FILE_ID = pt_i_load_file_id;

                    v_file_name:=lv_hcm_pv_file_name;
                EXCEPTION
                    WHEN OTHERS THEN 
                        NULL;
                END;
            END IF;

            gv_file_blob := NULL;
            --g_zipped_blob := NULL;
            dbms_output.put_line(r_zip_hdl.filename);
            dbms_output.put_line(pv_i_file_name);
            dbms_output.put_line(pt_dirname);
            gv_file_blob := xxmx_file_zip_utility_pkg.file2blob(pt_dirname, v_file_name);

            xxmx_file_zip_utility_pkg.add1file(g_zipped_blob, v_file_name, gv_file_blob);

        END LOOP;

         xxmx_file_zip_utility_pkg.finish_zip(g_zipped_blob);
        xxmx_file_zip_utility_pkg.save_zip(g_zipped_blob, pt_dirname, pt_i_businessentity
                                                                      || '_'
																	  || pt_i_load_file_id		--2.6
                                                                      || '_'					--2.6
                                                                      || v_datafile_name
                                                                      || '_'
                                                                      || to_char(SYSDATE,'DDMONYYYYHHMISS')
                                                                      || '.zip');
            --UTL_FILE.FREMOVE (pt_dirname,rec_filename.file_name||'_'||r_zip.BATCH_NAME||'.csv');  

        dbms_lob.filecloseall;
        xxmx_delete_dbfile_nonbatching(pt_i_businessentity => pt_i_businessentity, pt_dirname => pt_dirname);

        DELETE FROM XXMX_LIST_DB_LOADFILE where business_entity=pt_i_businessentity and sub_entity=pt_i_subentity;

        UPDATE xxmx_loadfile_status_log
        SET STATUS = 'G',
        last_update_date = sysdate
        WHERE load_file_id = pt_i_load_file_id;

        commit;
    END IF;

EXCEPTION
    WHEN e_moduleerror THEN
        xxmx_utilities_pkg.log_module_message(pt_i_applicationsuite => gct_applicationsuite, pt_i_application => gct_application, pt_i_businessentity => gct_businessentity
        , pt_i_subentity => 'ALL', pt_i_migrationsetid => 0,
                                             pt_i_phase => gct_phase, pt_i_severity => 'ERROR', pt_i_packagename => gct_packagename, pt_i_procorfuncname => ct_procorfuncname
                                             , pt_i_progressindicator => gvv_progressindicator,
                                             pt_i_modulemessage => gvt_modulemessage, pt_i_oracleerror => NULL);

        RAISE;
    WHEN OTHERS THEN
        xxmx_utilities_pkg.log_module_message(pt_i_applicationsuite => gct_applicationsuite, pt_i_application => gct_application, pt_i_businessentity => gct_businessentity
        , pt_i_subentity => 'ALL', pt_i_migrationsetid => 0,
                                             pt_i_phase => gct_phase, pt_i_severity => 'ERROR', pt_i_packagename => gct_packagename, pt_i_procorfuncname => ct_procorfuncname
                                             , pt_i_progressindicator => gvv_progressindicator,
                                             pt_i_modulemessage => NULL, pt_i_oracleerror => substr(sqlerrm, 1, 1000));

        RAISE;
END XXMX_ZIP_FILE_NONBATCHING;
FUNCTION xxmx_getfile_status (
        pv_i_load_file_id VARCHAR2
    ) RETURN VARCHAR2 AS
        lv_record_status VARCHAR2(10);
        lv_record_count  NUMBER;
    BEGIN
        SELECT
            COUNT(DISTINCT status)
        INTO lv_record_count
        FROM
            xxmx_list_db_loadfile
        WHERE
            load_file_id = pv_i_load_file_id;

        IF ( lv_record_count = 1 ) THEN
            SELECT DISTINCT
                ( status )
            INTO lv_record_status
            FROM
                xxmx_list_db_loadfile
            WHERE
                load_file_id = pv_i_load_file_id;

            IF ( lv_record_status <> 'C' ) THEN
                RETURN 'I';
            ELSIF ( lv_record_status = 'C' ) THEN
                RETURN lv_record_status;
            END IF;

        ELSE
            RETURN 'I';
        END IF;

    EXCEPTION
        WHEN OTHERS THEN
            RETURN 'E';
    END xxmx_getfile_status;

  PROCEDURE xxmx_log_oic_status(pt_i_instance_id  IN VARCHAR2,
                                pt_i_statusmessage IN VARCHAR2,
                                pt_i_statuscode   IN VARCHAR2)

  IS
  PRAGMA AUTONOMOUS_TRANSACTION;

  --
     ct_ProcOrFuncName       CONSTANT  xxmx_module_messages.proc_or_func_name%TYPE := 'xxmx_log_oic_status';
  --

  BEGIN
        gvv_ProgressIndicator := '0010';
        IF( pt_i_statuscode = 'ERROR')
        THEN 
            UPDATE xxmx_core.xxmx_dm_oic_read_log
            SET Attribute1 = 'Integration has Completed with Errors'
               ,Error_message= pt_i_statusmessage
               ,status_code = 'E'
            where instance_id = pt_i_instance_id;
        ELSIF( pt_i_statuscode = 'SUCCESS')
        THEN
            UPDATE xxmx_core.xxmx_dm_oic_read_log
            SET Attribute1 = 'Integration has Completed SUCCESSFULLY'
               ,status_message= pt_i_statusmessage
               ,status_code = 'S'
            where instance_id = pt_i_instance_id;
        END IF;
        COMMIT;

   EXCEPTION
    WHEN OTHERS THEN 
        xxmx_utilities_pkg.log_module_message
                  (
                   pt_i_ApplicationSuite  => gct_ApplicationSuite
                  ,pt_i_Application       => gct_Application
                  ,pt_i_BusinessEntity    => gct_BusinessEntity
                  ,pt_i_SubEntity         => 'ALL'
                  ,pt_i_MigrationSetID    => 0
                  ,pt_i_Phase             => gct_phase
                  ,pt_i_Severity          => 'ERROR'
                  ,pt_i_PackageName       => gct_PackageName
                  ,pt_i_ProcOrFuncName    => ct_ProcOrFuncName
                  ,pt_i_ProgressIndicator => gvv_ProgressIndicator
                  ,pt_i_ModuleMessage     => NULL
                  ,pt_i_OracleError       => SUBSTR(SQLERRM,1,1000)
                  );
               raise;

  END xxmx_log_oic_status;

  FUNCTION xxmx_load_file_status (pt_i_instance_id IN VARCHAR2)
  Return VARCHAR2
    AS 
    v_statuscode VARCHAR2(200):= 'P';

  BEGIN 

        Select status_code 
        INTO v_statuscode
        from xxmx_dm_oic_read_log  
        where instance_id = pt_i_instance_id;

        IF( v_statuscode IS NULL) THEN 
            v_statuscode := '-1';
        END IF;

        RETURN v_statuscode;
  END;
  
  	FUNCTION get_batch_status (p_business_entity IN VARCHAR2)
    RETURN VARCHAR2
    AS
        batch_enabled VARCHAR2(100):= 'N';
    BEGIN
        SELECT batch_load
        INTO batch_enabled
        FROM
            xxmx_migration_metadata
        WHERE
            business_entity = p_business_entity
        AND sub_entity_seq = 1;
        RETURN batch_enabled;
    EXCEPTION
        WHEN OTHERS THEN
            RETURN batch_enabled;
    END get_batch_status;

END xxmx_utilities_pkg;
/
Show errors package body xxmx_utilities_pkg;
/