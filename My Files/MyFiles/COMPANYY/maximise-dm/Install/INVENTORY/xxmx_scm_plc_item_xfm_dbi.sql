--*****************************************************************************
--**
--**                 Copyright (c) 2022 Version 1
--**
--**                           Millennium House,
--**                           Millennium Walkway,
--**                           Dublin 1
--**                           D01 F5P8
--**
--**                           All rights reserved.
--**
--*****************************************************************************
--**
--**
--** FILENAME  : xxmx_scm_plc_item_xfm_dbi.sql
--**
--** FILEPATH  :  $XXV1_TOP/install/sql
--**
--** VERSION   :  1.0
--**
--** EXECUTE
--** IN SCHEMA :  APPS
--**
--** AUTHORS   :  Sinchana Ramesh
--**
--** PURPOSE   :  This script installs the XXMX_XFM DB Objects for the Cloudbridge
--**              SCM PLC ITEM Data Migration.
--**
--** NOTES     :
--**
--******************************************************************************
--**
--** PRE-REQUISITIES
--** ---------------
--**
--** If this script is to be executed as part of an installation script, ensure
--** that the installation script performs the following tasks prior to calling
--** this script.
--**
--** Task  Description
--** ----  ---------------------------------------------------------------------
--** 1.    Run the installation script to create all necessary database objects
--**       and Concurrent definitions:
--**
--**            $XXV1_TOP/install/sql/xxv1_mxdm_utilities_1_dbi.sql
--**
--** If this script is not to be executed as part of an installation script,
--** ensure that the tasks above are, or have been, performed prior to executing
--** this script.
--**
--******************************************************************************
--**
--** CALLING INSTALLATION SCRIPTS
--** ----------------------------
--**
--** The following installation scripts call this script:
--**
--** File Path                                     File Name
--** --------------------------------------------  ------------------------------
--** N/A                                           N/A
--**
--******************************************************************************
--**
--** CALLED INSTALLATION SCRIPTS
--** ---------------------------
--**
--** The following installation scripts are called by this script:
--**
--** File Path                                    File Name
--** -------------------------------------------  ------------------------------
--** N/A                                          N/A
--**
--******************************************************************************
--**
--** PARAMETERS
--** ----------
--**
--** Parameter                       IN OUT  Type
--** -----------------------------  ------  ------------------------------------
--** [parameter_name]                IN OUT
--**
--******************************************************************************
--**
--** [previous_filename] HISTORY
--** -----------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -----------------------------------
--** [ 1.0  DD-Mon-YYYY  Change Author       Created.                          ]
--**
--******************************************************************************
--**
--** xxcust_common_pkg.sql HISTORY
--** ------------------------------------
--**
--**   Vsn  Change Date  Changed By          Change Description
--** -----  -----------  ------------------  -------------------------------------------
--**   1.0  16-JUL-2024  Sinchana Ramesh     Created ITEM XFM tables for Cloudbridge.
--** 
--**************************************************************************************
--**
--**  Data Element Prefixes
--**  =====================
--**
--**  Utilizing prefixes for data and object names enhances the readability of code
--**  and allows for the context of a data element to be identified (and hopefully
--**  understood) without having to refer to the data element declarations section.
--**
--**  For example, having a variable in code simply named "x_id" is not very
--**  useful.  Don't laugh, I've seen it done.
--**
--**  If you came across such a variable hundreds of lines down in a packaged
--**  procedure or function, you could assume the variable's data type was
--**  NUMBER or INTEGER (if its purpose was to store an Oracle internal ID),
--**  but you would have to check in the declaration section to be sure.
--**
--**  However, if the purpose of the "x_id" variable was not to store an Oracle
--**  internal ID but perhaps some kind of client data identifier e.g. an
--**  Employee ID (and you could not tell this from the name) then the data type
--**  could easily be be VARCHAR2.  Again, you would have to navigate to the
--**  declaration section to be sure of the data type.
--**
--**  Also, the variable name does not give any developer who may need to modify
--**  the code (apart from the original author that is) any context as to the
--**  meaning of the variable.  Even the original author may struggle to remember
--**  what this variable is used for if s/he had to modify their own code months
--**  or years in the future.
--**
--**  This Package utilises prefixes of upto 6 characters for all data elements
--**  wherever possible.
--**
--**  The construction of Prefixes is governed by the following rules:
--**
--**       Parameters
--**       ----------
--**       1) Parameter prefixes always start with "p".
--**       
--**       2) The second character in a parameter prefix denotes its
--**          data type:
--**       
--**               b = Data element of type BOOLEAN.
--**               d = Data element of type DATE.
--**               i = Data element of type INTEGER.
--**               n = Data element of type NUMBER.
--**               r = Data element of type REAL.
--**               v = Data element of type VARCHAR2.
--**               t = Data element of type %TYPE (DB inherited type).
--**       
--**       3) The third and/or fourth characters in a parameter prefix
--**          denote the direction in which value in the paramater is
--**          communicated:
--**       
--**               i  = Input parameter (readable value only)
--**               o  = Output parameter (value assignable)
--**               io = Input/Output parameter (readable/assignable)
--**       
--**          For clarity, the direction indicators are separated from
--**          the first two characters by an underscore. e.g. pv_i_
--**
--**       Global Data Elements
--**       --------------------
--**       1) Global data elements will always start with a "g" whether
--**          defined in the package body (and therefore only global within
--**          the package itself), or defined in the package specification
--**          (and therefore referencable outside of the package).
--**      
--**          The subequent characters in a global prefix will follow the same
--**          conventions as per local constants and variables as explained
--**          below.
--**      
--**       Local Data Elements
--**       -------------------
--**       1) The first character of a local data element's prefix (or second
--**          character for global) denotes the data element's assignability:
--**      
--**               c = Denotes a constant.
--**              
--**               v = Denotes a variable.
--**      
--**       2) The second character or a local data element's prefix (or third
--**          character for global) denotes its data type (as with parameters):
--**      
--**               b = Data element of type BOOLEAN.
--**               d = Data element of type DATE.
--**               i = Data element of type INTEGER.
--**               n = Data element of type NUMBER.
--**               r = Data element of type REAL.
--**               v = Data element of type VARCHAR2.
--**               t = Data element of type %TYPE (DB inherited type).
--**
--**  Prefix Examples
--**  ===============
--**
--**       Prefix    Indication
--**       --------  ----------------------------------------
--**       pb_i_     Input Parameter of type BOOLEAN
--**       pd_i_     Input Parameter of type DATE
--**       pi_i_     Input Parameter of type INTEGER
--**       pn_i_     Input Parameter of type NUMBER
--**       pr_i_     Input Parameter of type REAL
--**       pv_i_     Input Parameter of type VARCHAR2
--**       pt_i_     Input Parameter of type %TYPE
--**
--**       pb_o_     Output Parameter of type BOOLEAN
--**       pd_o_     Output Parameter of type DATE
--**       pi_o_     Output Parameter of type INTEGER
--**       pn_o_     Output Parameter of type NUMBER
--**       pr_o_     Output Parameter of type REAL
--**       pv_o_     Output Parameter of type VARCHAR2
--**       pt_o_     Output Parameter of type %TYPE
--**
--**       pb_io_    Input/Output Parameter of type BOOLEAN
--**       pd_io_    Input/Output Parameter of type DATE
--**       pi_io_    Input/Output Parameter of type INTEGER
--**       pn_io_    Input/Output Parameter of type NUMBER
--**       pr_io_    Input/Output Parameter of type REAL
--**       pv_io_    Input/Output Parameter of type VARCHAR2
--**       pt_io_    Input/Output Parameter of type %TYPE
--**
--**       gcb_      Global Constant of type BOOLEAN
--**       gcd_      Global Constant of type DATE
--**       gci_      Global Constant of type INTEGER
--**       gcn_      Global Constant of type NUMBER
--**       gcr_      Global Constant of type REAL
--**       gcv_      Global Constant of type VARCHAR2
--**       gct_      Global Constant of type %TYPE
--**
--**       gvb_      Global Variable of type BOOLEAN
--**       gvd_      Global Variable of type DATE
--**       gvi_      Global Variable of type INTEGER
--**       gvn_      Global Variable of type NUMBER
--**       gvr_      Global Variable of type REAL
--**       gvv_      Global Variable of type VARCHAR2
--**       gvt_      Global Variable of type %TYPE
--**
--**       cb_       Constant of type BOOLEAN
--**       cd_       Constant of type DATE
--**       ci_       Constant of type INTEGER
--**       cn_       Constant of type NUMBER
--**       cr_       Constant of type REAL
--**       cv_       Constant of type VARCHAR2
--**       ct_       Constant of type %TYPE
--**
--**       vb_       Variable of type BOOLEAN
--**       vd_       Variable of type DATE
--**       vi_       Variable of type INTEGER
--**       vn_       Variable of type NUMBER
--**       vr_       Variable of type REAL
--**       vv_       Variable of type VARCHAR2
--**       vt_       Variable of type %TYPE
--**
--**  PL/SQL Construct Suffixes
--**  =========================
--**
--**  Specific suffixes have been employed for PL/SQL Constructs:
--**
--**       _cur      Cursor Names
--**       _rt       PL/SQL Record Type Declarations
--**       _tt       PL/SQL Table Type Declarations
--**       _tbl      PL/SQL Table Declarations
--**       _rec      PL/SQL Record Declarations (or implicit
--**                 cursor record declarations)
--**
--**  Other Data Element Naming Conventions
--**  =====================================
--**
--**  Data elements names should have meaning which indicate their purpose or
--**  usage whilst adhering to the Oracle name length limit of 30 characters.
--**
--**  To compensate for longer data element prefixes, the rest of a data element
--**  name is constructed without underscores.  However to aid in maintaining
--**  readability and meaning, data elements names will contain concatenated
--**  words with initial letters capitalised in a similar manner to JAVA naming
--**  conventions.
--**
--**  By using the above conventions you can create meaningful data element
--**  names such as:
--**
--**       pn_i_POHeaderID
--**       ---------------
--**       This clearly identifies that the data element is an inbound only
--**       (non assignable) parameter of type NUMBER which holds an Oracle
--**       internal PO Header identifier.
--**
--**       pb_o_CreateOutputFileAsCSV
--**       --------------------------
--**       This clearly identifies that the data element is an output only
--**       parameter of type BOOLEAN that contains a flag which indicates
--**       that output of the calling process should be formatted as a CSV
--**       file.
--**
--**       gcv_PackageName
--**       ---------------
--**       This data element is a global constant of type VARCHAR2.
--**
--**       gvv_ProcOrFuncName
--**       ------------------
--**       This data element is a global variable or type VARCHAR2.
--**
--**       vt_APInvoiceID
--**       --------------
--**       This data element is a variable whose type is determined from a
--**       database table column and is meant to hold the Oracle internal
--**       identifier for a Payables Invoice Header.
--**
--**       vt_APInvoiceLineID
--**       ------------------
--**       Similar to the previous example but this clearly identified that the
--**       data element is intended to hold the Oracle internal identifier for
--**       a Payables Invoice Line.
--**
--**  Similarly for PL/SQL Constructs:
--**
--**       APInvoiceHeaders_cur
--**
--**       APInvoiceHeader_rec
--**
--**       TYPE EmployeeData_rt IS RECORD OF
--**            (
--**             employee_number   VARCHAR2(20)
--**            ,employee_name     VARCHAR2(30)
--**            );
--**
--**       TYPE EmployeeData_tt IS TABLE OF Employee_rt;
--**   
--**       EmployeeData_tbl        EmployeeData_tt;
--**      
--**  Careful and considerate use of the above rules when naming data elements
--**  can be a boon to other developers who may need to understand and/or modify
--**  your code in future.  In conjunction with good commenting practices of
--**  course.
--**
--******************************************************************************

PROMPT
PROMPT
PROMPT *****************************************************************************
PROMPT **
PROMPT ** Installing Extract Database Objects for Cloudbridge Item Data Migration
PROMPT **
PROMPT *****************************************************************************
PROMPT
PROMPT
--
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Dropping Tables
PROMPT ******************
--

PROMPT
PROMPT Dropping Table XXMX_SCM_SYS_ITEMS_XFM
PROMPT
--
EXEC DropTable('XXMX_SCM_SYS_ITEMS_XFM')
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_ITEM_REV_XFM									
PROMPT
--
EXEC DropTable('XXMX_SCM_ITEM_REV_XFM')
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_ITEM_CAT_XFM								
PROMPT
--
EXEC DropTable('XXMX_SCM_ITEM_CAT_XFM')
--
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_ITEM_ASSOC_XFM								
PROMPT
--
EXEC DropTable('XXMX_SCM_ITEM_ASSOC_XFM')
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_ITEM_REL_XFM								
PROMPT
--
EXEC DropTable('XXMX_SCM_ITEM_REL_XFM')
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_ITEM_EFF_XFM								
PROMPT
--
EXEC DropTable('XXMX_SCM_ITEM_EFF_XFM')
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_ITEM_EFF_TL_XFM								
PROMPT
--
EXEC DropTable('XXMX_SCM_ITEM_EFF_TL_XFM')
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_ITEM_REV_EFF_XFM								
PROMPT
--
EXEC DropTable('XXMX_SCM_ITEM_REV_EFF_XFM')
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_ITEM_REV_EFF_TL_XFM								
PROMPT
--
EXEC DropTable('XXMX_SCM_ITEM_REV_EFF_TL_XFM')
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_ITEM_SUPP_EFF_XFM								
PROMPT
--
EXEC DropTable('XXMX_SCM_ITEM_SUPP_EFF_XFM')
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_ITEM_SUPP_EFF_TL_XFM								
PROMPT
--
EXEC DropTable('XXMX_SCM_ITEM_SUPP_EFF_TL_XFM')
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_ITEM_STYL_ATTR_XFM								
PROMPT
--
EXEC DropTable('XXMX_SCM_ITEM_STYL_ATTR_XFM')
--
--
--
PROMPT
PROMPT Dropping Table XXMX_SCM_TP_ITEMS_XFM								
PROMPT
--
EXEC DropTable('XXMX_SCM_TP_ITEMS_XFM')
--
--
PROMPT
PROMPT
PROMPT ******************
PROMPT ** Creating Tables
PROMPT ******************
--
PROMPT
PROMPT Creating Table XXMX_SCM_SYS_ITEMS_XFM
PROMPT
--

--Migration_set_id is generated in the Cloudbridge Code
--File_set_id is mandatory for Data File (non-Ebs Source)


--
--
-- **************
-- ** Items table 
-- **************
CREATE TABLE XXMX_XFM.XXMX_SCM_SYS_ITEMS_XFM
    (
     FILE_SET_ID                                     VARCHAR2(30)
    ,MIGRATION_SET_ID                                NUMBER
    ,MIGRATION_SET_NAME                              VARCHAR2(100)
    ,MIGRATION_STATUS                                VARCHAR2(50)
    ,ORG_ID                                          NUMBER
    ,OPERATING_UNIT                                  VARCHAR2(240)
    ,TRANSACTION_TYPE                                VARCHAR2(10)
    ,BATCH_ID                                        NUMBER(18)
    ,BATCH_NUMBER                                    VARCHAR2(40)
    ,ITEM_NUMBER                                     VARCHAR2(300)
    ,OUTSIDE_PROCESS_SERVICE_FLAG                    VARCHAR2(1)
    ,ORGANIZATION_CODE                               NUMBER(18)
    ,DESCRIPTION                                     VARCHAR2(240)
    ,TEMPLATE_NAME                                   VARCHAR2(960)
    ,SOURCE_SYSTEM_CODE                              VARCHAR2(30)
    ,SOURCE_SYSTEM_REFERENCE                         VARCHAR2(255)
    ,SOURCE_SYSTEM_REFERENCE_DESC                    VARCHAR2(240)
    ,ITEM_CATALOG_GROUP_NAME                         VARCHAR2(820)
    ,PRIMARY_UOM_NAME                                VARCHAR2(25)
    ,CURRENT_PHASE_CODE                              VARCHAR2(120)
    ,INVENTORY_ITEM_STATUS_CODE                      VARCHAR2(10)
    ,NEW_ITEM_CLASS_NAME                             VARCHAR2(820)
    ,ASSET_TRACKED                                   VARCHAR2(1)
    ,ALLOW_MAINTENANCE_ASSET_FLAG                    VARCHAR2(1)
    ,ENABLE_GENEALOGY_FLAG                           VARCHAR2(1)
    ,ASSET_CLASS                                     VARCHAR2(30)
    ,EAM_ITEM_TYPE                                   NUMBER
    ,EAM_ACTIVITY_TYPE_CODE                          VARCHAR2(30)
    ,EAM_ACTIVITY_CAUSE_CODE                         VARCHAR2(30)
    ,EAM_ACT_NOTIFICATION_FLAG                       VARCHAR2(1)
    ,EAM_ACT_SHUTDOWN_STATUS                         VARCHAR2(30)
    ,EAM_ACTIVITY_SOURCE_CODE                        VARCHAR2(30)
    ,COSTING_ENABLED_FLAG                            VARCHAR2(1)
    ,STD_LOT_SIZE                                    NUMBER
    ,INVENTORY_ASSET_FLAG                            VARCHAR2(1)
    ,DEAFULT_INCLUDE_IN_ROLLUP_FLAG                  VARCHAR2(1)
    ,ORDER_COST                                      NUMBER
    ,VMI_MINIMUM_DAYS                                NUMBER
    ,VMI_FIXED_ORDER_QUANTITY                        NUMBER
    ,VMI_MINIMUM_UNITS                               NUMBER
    ,ASN_AUTOEXPIRE_FLAG                             NUMBER
    ,CARRYING_COST                                   NUMBER
    ,CONSIGNED_FLAG                                  NUMBER
    ,FIXED_DAYS_SUPPLY                               NUMBER
    ,FIXED_LOT_MULTIPLIER                            NUMBER
    ,FIXED_ORDER_QUANTITY                            NUMBER
    ,FORECAST_HORIZON                                NUMBER
    ,INVENTORY_PLANNING_CODE                         NUMBER
    ,MRP_SAFETY_STOCK_PERCENT                        NUMBER
    ,DEMAND_PERIOD                                   NUMBER
    ,DAYS_OF_COVER                                   NUMBER
    ,MIN_MINMAX_QUANTITY                             NUMBER
    ,MAX_MINMAX_QUANTITY                             NUMBER
    ,MINIMUM_ORDER_QUANTITY                          NUMBER
    ,MAXIMUM_ORDER_QUANTITY                          NUMBER
    ,PLANNER_CODE                                    VARCHAR2(10)
    ,PLANNING_MAKE_BUY_CODE                          NUMBER
    ,SOURCE_SUBINVENTORY                             VARCHAR2(10)
    ,SOURCE_TYPE                                     NUMBER
    ,SO_AUTHORIZATION_CODE                           NUMBER
    ,SUBCONTRACTING_COMPONENT                        NUMBER
    ,VMI_FORECAST_TYPE                               NUMBER
    ,VMI_MAXIMUM_UNITS                               NUMBER
    ,VMI_MAXIMUM_DAYS                                NUMBER
    ,SOURCE_ORGANIZATION_CODE                        VARCHAR2(18)
    ,RESTRICT_SUBINVENTORIES_CODE                    NUMBER
    ,RESTRICT_LOCATORS_CODE                          NUMBER
    ,CHILD_LOT_FLAG                                  VARCHAR2(1)
    ,CHILD_LOT_PREFIX                                VARCHAR2(30)
    ,CHILD_LOT_STARTING_NUMBER                       NUMBER
    ,CHILD_LOT_VALIDATION_FLAG                       VARCHAR2(1)
    ,COPY_LOT_ATTRIBUTE_FLAG                         VARCHAR2(1)
    ,EXPIRATION_ACTION_CODE                          VARCHAR2(32)
    ,EXPIRATION_ACTION_INTERVAL                      NUMBER
    ,STOCKED_ENABLED_FLAG                            VARCHAR2(1)
    ,START_AUTO_LOT_NUMBER                           VARCHAR2(80)
    ,SHELF_LIFE_CODE                                 NUMBER
    ,SHELF_LIFE_DAYS                                 NUMBER
    ,SERIAL_NUMBER_CONTROL_CODE                      NUMBER
    ,SERIAL_STATUS_ENABLED                           VARCHAR2(1)
    ,REVISION_QTY_CONTROL_CODE                       NUMBER
    ,RETEST_INTERVAL                                 NUMBER
    ,AUTO_LOT_ALPHA_PREFIX                           VARCHAR2(80)
    ,AUTO_SERIAL_ALPHA_PREFIX                        VARCHAR2(80)
    ,BULK_PICKED_FLAG                                VARCHAR2(1)
    ,CHECK_SHORTAGES_FLAG                            VARCHAR2(1)
    ,CYCLE_COUNT_ENABLED_FLAG                        VARCHAR2(1)
    ,DEFAULT_GRADE                                   VARCHAR2(150)
    ,GRADE_CONTROL_FLAG                              VARCHAR2(1)
    ,HOLD_DAYS                                       NUMBER
    ,LOT_DIVISIBLE_FLAG                              VARCHAR2(1)
    ,MATURITY_DAYS                                   NUMBER
    ,DEFAULT_LOT_STATUS_ID                           NUMBER(18)
    ,DEFAULT_SERIAL_STATUS_ID                        NUMBER(18)
    ,LOT_SPLIT_ENABLED                               VARCHAR2(1)
    ,LOT_MERGE_ENABLED                               VARCHAR2(1)
    ,INVENTORY_ITEM_FLAG                             VARCHAR2(1)
    ,LOCATION_CONTROL_CODE                           NUMBER
    ,LOT_CONTROL_CODE                                NUMBER
    ,LOT_STATUS_ENABLED                              VARCHAR2(1)
    ,LOT_SUBSTITUTION_ENABLED                        VARCHAR2(1)
    ,LOT_TRANSLATE_ENABLED                           VARCHAR2(1)
    ,MTL_TRANSACTIONS_ENABLED_FLAG                   VARCHAR2(1)
    ,POSITIVE_MEASUREMENT_ERROR                      NUMBER
    ,NEGATIVE_MEASUREMENT_ERROR                      NUMBER
    ,PARENT_CHILD_GENERATION_FLAG                    VARCHAR2(1)
    ,RESERVABLE_TYPE                                 NUMBER
    ,START_AUTO_SERIAL_NUMBERS                       VARCHAR2(80)
    ,INVOICING_RULE_ID                               NUMBER(18)
    ,TAX_CODE                                        VARCHAR2(50)
    ,SALES_ACCOUNT                                   NUMBER(18)
    ,PAYMENT_TERMS_NAME                              VARCHAR2(15)
    ,INVOICE_ENABLED_FLAG                            VARCHAR2(1)
    ,INVOICEABLE_ITEM_FLAG                           VARCHAR2(1)
    ,ACCOUNTING_RULE_ID                              NUMBER(18)
    ,AUTO_CREATED_CONFIG_FLAG                        VARCHAR2(1)
    ,REPLINISH_TO_ORDER_FLAG                         VARCHAR2(1)
    ,PICK_COMPONENTS_FLAG                            VARCHAR2(1)
    ,BASE_ITEM_NUMBER                                VARCHAR2(300)
    ,EFFECTIVITY_CONTROL                             NUMBER
    ,CONFIG_ORGS                                     VARCHAR2(30)
    ,CONFIG_MATCH                                    VARCHAR2(30)
    ,CONFIG_MODEL_TYPE                               VARCHAR2(30)
    ,BOM_ITEM_TYPE                                   NUMBER
    ,CUM_MANUFACTURING_LEAD_TIME                     NUMBER
    ,PREPROCESSING_LEAD_TIME                         NUMBER
    ,CUMULATIVE_TOTAL_LEAD_TIME                      NUMBER
    ,FIXED_LEAD_TIME                                 NUMBER
    ,VARIABLE_LEAD_TIME                              NUMBER
    ,FULL_LEAD_TIME                                  NUMBER
    ,LEAD_TIME_LOT_SIZE                              NUMBER
    ,POSTPROCESSING_LEAD_TIME                        NUMBER
    ,ATO_FORECAST_CONTROL                            NUMBER
    ,CRITICAL_COMPONENT_FLAG                         NUMBER
    ,ACCEPTABLE_EARLY_DAYS                           NUMBER
    ,CREATE_SUPPLY_FLAG                              VARCHAR2(1)
    ,DAYS_TGT_INV_SUPPLY                             NUMBER
    ,DAYS_TGT_INV_WINDOW                             NUMBER
    ,DAYS_MAX_INV_SUPPLY                             NUMBER
    ,DAYS_MAX_INV_WINDOW                             NUMBER
    ,DEMAND_TIME_FENCE_CODE                          NUMBER
    ,DEMAND_TIME_FENCE_DAYS                          NUMBER
    ,DRP_PLANNED_FLAG                                NUMBER
    ,END_ASSEMBLY_PEGGING_FLAG                       VARCHAR2(1)
    ,EXCLUDE_FROM_BUDGET_FLAG                        NUMBER
    ,MRP_CALCULATE_ATP_FLAG                          VARCHAR2(1)
    ,MRP_PLANNING_CODE                               NUMBER
    ,PLANNED_INV_POINT_FLAG                          VARCHAR2(1)
    ,PLANNING_TIME_FENCE_CODE                        NUMBER
    ,PLANNING_TIME_FENCE_DAYS                        NUMBER
    ,PREPOSITION_POINT                               VARCHAR2(1)
    ,RELEASE_TIME_FENCE_CODE                         NUMBER
    ,RELEASE_TIME_FENCE_DAYS                         NUMBER
    ,REPAIR_LEADTIME                                 NUMBER
    ,REPAIR_YIELD                                    NUMBER
    ,REPAIR_PROGRAM                                  NUMBER
    ,ROUNDING_CONTROL_TYPE                           NUMBER
    ,SHRINKAGE_RATE                                  NUMBER
    ,SUBSTITUTION_WINDOW_CODE                        NUMBER
    ,SUBSTITUTION_WINDOW_DAYS                        NUMBER
    ,TRADE_ITEM_DESCRIPTOR                           VARCHAR2(35)
    ,ALLOWED_UNITS_LOOKUP_CODE                       NUMBER
    ,DUAL_UOM_DEVIATION_HIGH                         NUMBER
    ,DUAL_UOM_DEVIATION_LOW                          NUMBER
    ,ITEM_TYPE                                       VARCHAR2(30)
    ,LONG_DESCRIPTION                                VARCHAR2(4000)
    ,HTML_LONG_DESCRIPTION                           CLOB
    ,ONT_PRICING_QTY_SOURCE                          VARCHAR2(30)
    ,SECONDARY_DEFAULT_IND                           VARCHAR2(30)
    ,SECONDARY_UOM_NAME                              VARCHAR2(25)
    ,TRACKING_QTY_IND                                VARCHAR2(30)
    ,ENGINEERED_ITEM_FLAG                            VARCHAR2(1)
    ,ATP_COMPONENTS_FLAG                             VARCHAR2(1)
    ,ATP_FLAG                                        VARCHAR2(1)
    ,OVER_SHIPMENT_TOLERANCE                         NUMBER
    ,UNDER_SHIPMENT_TOLERANCE                        NUMBER
    ,OVER_RETURN_TOLERANCE                           NUMBER
    ,UNDER_RETURN_TOLERANCE                          NUMBER
    ,DOWNLOADABLE_FLAG                               VARCHAR2(1)
    ,ELECTRONIC_FLAG                                 VARCHAR2(1)
    ,INDIVISIBLE_FLAG                                VARCHAR2(1)
    ,INTERNAL_ORDERS_ENABLED_FLAG                    VARCHAR2(1)
    ,ATP_RULE_ID                                     NUMBER(18)
    ,CHARGE_PERIODICITY_NAME                         VARCHAR2(25)
    ,CUSTOMER_ORDER_ENABLED_FLAG                     VARCHAR2(1)
    ,DEFAULT_SHIPPING_ORG_CODE                       VARCHAR2(18)
    ,DEFAULT_SO_SOURCE_TYPE                          VARCHAR2(30)
    ,ELIGIBILITY_COMPATIBILITY_RULE                  VARCHAR2(1)
    ,FINANCING_ALLOWED_FLAG                          VARCHAR2(1)
    ,INTERNAL_ORDER_FLAG                             VARCHAR2(1)
    ,PICKING_RULE_ID                                 NUMBER
    ,RETURNABLE_FLAG                                 VARCHAR2(1)
    ,RETURN_INSPECTION_REQUIREMENT                   NUMBER
    ,SALES_PRODUCT_TYPE                              VARCHAR2(30)
    ,BACK_TO_BACK_ENABLED                            VARCHAR2(5)
    ,SHIPPABLE_ITEM_FLAG                             VARCHAR2(1)
    ,SHIP_MODEL_COMPLETE_FLAG                        VARCHAR2(1)
    ,SO_TRANSACTIONS_FLAG                            VARCHAR2(1)
    ,CUSTOMER_ORDER_FLAG                             VARCHAR2(1)
    ,UNIT_WEIGHT                                     NUMBER
    ,WEIGHT_UOM_NAME                                 VARCHAR2(25)
    ,UNIT_VOLUME                                     NUMBER
    ,VOLUME_UOM_NAME                                 VARCHAR2(25)
    ,DIMENSION_UOM_NAME                              VARCHAR2(25)
    ,UNIT_LENGTH                                     NUMBER
    ,UNIT_WIDTH                                      NUMBER
    ,UNIT_HEIGHT                                     NUMBER
    ,COLLATERAL_FLAG                                 VARCHAR2(1)
    ,CONTAINER_ITEM_FLAG                             VARCHAR2(1)
    ,CONTAINER_TYPE_CODE                             VARCHAR2(30)
    ,EQUIPMENT_TYPE                                  NUMBER
    ,EVENT_FLAG                                      VARCHAR2(1)
    ,INTERNAL_VOLUME                                 NUMBER
    ,MAXIMUM_LOAD_WEIGHT                             NUMBER
    ,MINIMUM_FILL_PERCENT                            NUMBER
    ,VEHICLE_ITEM_FLAG                               VARCHAR2(1)
    ,CAS_NUMBER                                      VARCHAR2(30)
    ,HAZARDOUS_MATERIAL_FLAG                         VARCHAR2(1)
    ,PROCESS_COSTING_ENABLED_FLAG                    VARCHAR2(1)
    ,PROCESS_EXECUTION_ENABLED_FLAG                  VARCHAR2(1)
    ,PROCESS_QUALITY_ENABLED_FLAG                    VARCHAR2(1)
    ,PROCESS_SUPPLY_LOCATOR_ID                       NUMBER(18)
    ,PROCESS_SUPPLY_SUBINVENTORY                     VARCHAR2(10)
    ,PROCESS_YIELD_LOCATOR_ID                        NUMBER(18)
    ,PROCESS_YIELD_SUBINVENTORY                      VARCHAR2(10)
    ,RECIPE_ENABLED_FLAG                             VARCHAR2(1)
    ,EXPENSE_ACCOUNT_NUMBER                          NUMBER
    ,UN_NUMBER_CODE                                  VARCHAR2(30)
    ,UNIT_OF_ISSUE                                   VARCHAR2(25)
    ,ROUNDING_FACTOR                                 NUMBER
    ,RECEIPT_CLOSE_TOLERANCE                         NUMBER
    ,PURCHASING_TAX_CODE                             VARCHAR2(50)
    ,PURCHASING_ITEM_FLAG                            VARCHAR2(1)
    ,PRICE_TOLERANCE_PERCENT                         NUMBER
    ,OUTSOURCED_ASSEMBLY                             NUMBER
    ,OUTSIDE_PROCESSING_UOM_TYPE                     VARCHAR2(25)
    ,NEGOTIATION_REQUIRED_FLAG                       VARCHAR2(1)
    ,MUST_USE_APPROVED_VENDOR_FLAG                   VARCHAR2(1)
    ,MATCH_APPROVAL_LEVEL                            NUMBER(1)
    ,INVOICE_MATCH_OPTION                            NUMBER(1)
    ,LIST_PRICE_PER_UNIT                             NUMBER
    ,INVOICE_CLOSE_TOLERANCE                         NUMBER
    ,HAZARD_CLASS_CODE                               VARCHAR2(30)
    ,BUYER_NAME                                      VARCHAR2(240)
    ,TAXABLE_FLAG                                    VARCHAR2(1)
    ,PURCHASING_ENABLED_FLAG                         VARCHAR2(1)
    ,OUTSIDE_OPERATION_FLAG                          VARCHAR2(1)
    ,MARKET_PRICE                                    NUMBER
    ,ASSET_CATEGORY_ID                               NUMBER(18)
    ,ALLOW_ITEM_DESC_UPDATE_FLAG                     VARCHAR2(1)
    ,ALLOW_EXPRESS_DELIVERY_FLAG                     VARCHAR2(1)
    ,ALLOW_SUBSTITUTE_RECEIPTS_FLAG                  VARCHAR2(1)
    ,ALLOW_UNORDERED_RECEIPTS_FLAG                   VARCHAR2(1)
    ,DAYS_EARLY_RECEIPT_ALLOWED                      NUMBER
    ,DAYS_LATE_RECEIPT_ALLOWED                       NUMBER
    ,RECEIVING_ROUTING_ID                            NUMBER(18)
    ,ENFORCE_SHIP_TO_LOCATION_CODE                   VARCHAR2(25)
    ,QTY_RCV_EXCEPTION_CODE                          VARCHAR2(25)
    ,QTY_RCV_TOLERANCE                               NUMBER
    ,RECEIPT_DAYS_EXCEPTION_CODE                     VARCHAR2(25)
    ,ASSET_CREATION_CODE                             VARCHAR2(30)
    ,SERVICE_START_TYPE_CODE                         VARCHAR2(3)
    ,COMMS_NL_TRACKABLE_FLAG                         VARCHAR2(1)
    ,CSS_ENABLED_FLAG                                VARCHAR2(1)
    ,CONTRACT_ITEM_TYPE_CODE                         VARCHAR2(30)
    ,STANDARD_COVERAGE                               VARCHAR2(150)
    ,DEFECT_TRACKING_ON_FLAG                         VARCHAR2(1)
    ,IB_ITEM_INSTANCE_CLASS                          VARCHAR2(30)
    ,MATERIAL_BILLABLE_FLAG                          VARCHAR2(30)
    ,RECOVERED_PART_DISP_CODE                        VARCHAR2(30)
    ,SERVICEABLE_PRODUCT_FLAG                        VARCHAR2(1)
    ,SERVICE_STARTING_DELAY                          NUMBER
    ,SERVICE_DURATION_NUMBER                         NUMBER
    ,SERVICE_DURATION_PERIOD_NAME                    VARCHAR2(25)
    ,SERV_REQ_ENABLED_CODE                           VARCHAR2(30)
    ,ALLOW_SUSPEND_FLAG                              VARCHAR2(1)
    ,ALLOW_TERMINATE_FLAG                            VARCHAR2(1)
    ,REQUIRES_FULFILLMENT_LOC_FLAG                   VARCHAR2(1)
    ,REQUIRES_ITM_ASSOCIATION_FLAG                   VARCHAR2(1)
    ,SERVICE_START_DELAY                             NUMBER
    ,SERVICE_DURATION_TYPE_CODE                      VARCHAR2(3)
    ,COMMS_ACTIVATION_REQD_FLAG                      VARCHAR2(1)
    ,SERV_BILLING_ENABLED_FLAG                       VARCHAR2(1)
    ,ORDERABLE_ON_WEB_FLAG                           VARCHAR2(1)
    ,BACK_ORDERABLE_FLAG                             VARCHAR2(1)
    ,WEB_STATUS                                      VARCHAR2(30)
    ,MINIMUM_LICENSE_QUANTITY                        NUMBER
    ,BUILD_IN_WIP_FLAG                               VARCHAR2(1)
    ,CONTRACT_MANUFACTURED                           VARCHAR2(1)
    ,WIP_SUPPLY_LOCATOR_ID                           NUMBER(18)
    ,WIP_SUPPLY_TYPE                                 NUMBER(18)
    ,WIP_SUPPLY_SUBINVENTORY                         VARCHAR2(10)
    ,OVERCOMPLETION_TOLERANCE_TYPE                   NUMBER
    ,OVERCOMPLETION_TOLERANCE_VALUE                  NUMBER
    ,INVENTORY_CARRY_PENALTY                         NUMBER
    ,OPERATION_SLACK_PENALTY                         NUMBER
    ,REVISION                                        VARCHAR2(18)
    ,STYLE_ITEM_FLAG                                 VARCHAR2(1)
    ,STYLE_ITEM_NUMBER                               VARCHAR(700)
    ,VERSION_START_DATE                              DATE
    ,VERSION_REVISION_CODE                           VARCHAR2(18)
    ,VERSION_LABEL                                   VARCHAR2(80)
    ,SERVICE_START_UPON_MILESTONE_CODE               VARCHAR2(3)
    ,SALES_PRODUCT_SUB_TYPE                          VARCHAR2(3)
    ,GLOBAL_ATTRIBUTE_CATEGORY                       VARCHAR2(150)
    ,GLOBAL_ATTRIBUTE1                               VARCHAR2(150)
    ,GLOBAL_ATTRIBUTE2                               VARCHAR2(150)
    ,GLOBAL_ATTRIBUTE3                               VARCHAR2(150)
    ,GLOBAL_ATTRIBUTE4                               VARCHAR2(150)
    ,GLOBAL_ATTRIBUTE5                               VARCHAR2(150)
    ,GLOBAL_ATTRIBUTE6                               VARCHAR2(150)
    ,GLOBAL_ATTRIBUTE7                               VARCHAR2(150)
    ,GLOBAL_ATTRIBUTE8                               VARCHAR2(150)
    ,GLOBAL_ATTRIBUTE9                               VARCHAR2(150)
    ,GLOBAL_ATTRIBUTE10                              VARCHAR2(150)
    ,ATTRIBUTE_CATEGORY                              VARCHAR2(30)
    ,ATTRIBUTE1                                      VARCHAR2(240)
    ,ATTRIBUTE2                                      VARCHAR2(240)
    ,ATTRIBUTE3                                      VARCHAR2(240)
    ,ATTRIBUTE4                                      VARCHAR2(240)
    ,ATTRIBUTE5                                      VARCHAR2(240)
    ,ATTRIBUTE6                                      VARCHAR2(240)
    ,ATTRIBUTE7                                      VARCHAR2(240)
    ,ATTRIBUTE8                                      VARCHAR2(240)
    ,ATTRIBUTE9                                      VARCHAR2(240)
    ,ATTRIBUTE10                                     VARCHAR2(240)
    ,ATTRIBUTE11                                     VARCHAR2(240)
    ,ATTRIBUTE12                                     VARCHAR2(240)
    ,ATTRIBUTE13                                     VARCHAR2(240)
    ,ATTRIBUTE14                                     VARCHAR2(240)
    ,ATTRIBUTE15                                     VARCHAR2(240)
    ,ATTRIBUTE16                                     VARCHAR2(240)
    ,ATTRIBUTE17                                     VARCHAR2(240)
    ,ATTRIBUTE18                                     VARCHAR2(240)
    ,ATTRIBUTE19                                     VARCHAR2(240)
    ,ATTRIBUTE20                                     VARCHAR2(240)
    ,ATTRIBUTE21                                     VARCHAR2(240)
    ,ATTRIBUTE22                                     VARCHAR2(240)
    ,ATTRIBUTE23                                     VARCHAR2(240)
    ,ATTRIBUTE24                                     VARCHAR2(240)
    ,ATTRIBUTE25                                     VARCHAR2(240)
    ,ATTRIBUTE26                                     VARCHAR2(240)
    ,ATTRIBUTE27                                     VARCHAR2(240)
    ,ATTRIBUTE28                                     VARCHAR2(240)
    ,ATTRIBUTE29                                     VARCHAR2(240)
    ,ATTRIBUTE30                                     VARCHAR2(240)
    ,ATTRIBUTE_NUMBER1                               NUMBER
    ,ATTRIBUTE_NUMBER2                               NUMBER
    ,ATTRIBUTE_NUMBER3                               NUMBER
    ,ATTRIBUTE_NUMBER4                               NUMBER
    ,ATTRIBUTE_NUMBER5                               NUMBER
    ,ATTRIBUTE_NUMBER6                               NUMBER
    ,ATTRIBUTE_NUMBER7                               NUMBER
    ,ATTRIBUTE_NUMBER8                               NUMBER
    ,ATTRIBUTE_NUMBER9                               NUMBER
    ,ATTRIBUTE_NUMBER10                              NUMBER
    ,ATTRIBUTE_DATE1                                 DATE
    ,ATTRIBUTE_DATE2                                 DATE
    ,ATTRIBUTE_DATE3                                 DATE
    ,ATTRIBUTE_DATE4                                 DATE
    ,ATTRIBUTE_DATE5                                 DATE
    ,ATTRIBUTE_TIMESTAMP1                            TIMESTAMP(6)
    ,ATTRIBUTE_TIMESTAMP2                            TIMESTAMP(6)
    ,ATTRIBUTE_TIMESTAMP3                            TIMESTAMP(6)
    ,ATTRIBUTE_TIMESTAMP4                            TIMESTAMP(6)
    ,ATTRIBUTE_TIMESTAMP5                            TIMESTAMP(6)
    ,GLOBAL_ATTRIBUTE11                              VARCHAR2(150)
    ,GLOBAL_ATTRIBUTE12                              VARCHAR2(150)
    ,GLOBAL_ATTRIBUTE13                              VARCHAR2(150)
    ,GLOBAL_ATTRIBUTE14                              VARCHAR2(150)
    ,GLOBAL_ATTRIBUTE15                              VARCHAR2(150)
    ,GLOBAL_ATTRIBUTE16                              VARCHAR2(150)
    ,GLOBAL_ATTRIBUTE17                              VARCHAR2(150)
    ,GLOBAL_ATTRIBUTE18                              VARCHAR2(150)
    ,GLOBAL_ATTRIBUTE19                              VARCHAR2(150)
    ,GLOBAL_ATTRIBUTE20                              VARCHAR2(150)
    ,GLOBAL_ATTRIBUTE_NUMBER1                        NUMBER
    ,GLOBAL_ATTRIBUTE_NUMBER2                        NUMBER
    ,GLOBAL_ATTRIBUTE_NUMBER3                        NUMBER
    ,GLOBAL_ATTRIBUTE_NUMBER4                        NUMBER
    ,GLOBAL_ATTRIBUTE_NUMBER5                        NUMBER
    ,GLOBAL_ATTRIBUTE_DATE1                          DATE
    ,GLOBAL_ATTRIBUTE_DATE2                          DATE
    ,GLOBAL_ATTRIBUTE_DATE3                          DATE
    ,GLOBAL_ATTRIBUTE_DATE4                          DATE
    ,GLOBAL_ATTRIBUTE_DATE5                          DATE
    ,PRC_BU_NAME                                     VARCHAR2(240)
    ,FORCE_PURCHASE_LEAD_TIME_FLAG                   VARCHAR2(1)
    ,REPLACEMENT_TYPE                                VARCHAR2(30)
    ,BUYER_EMAIL_ADDRESS                             VARCHAR2(240)
    ,DEFAULT_EXPENDITURE_TYPE                        VARCHAR2(240)
    ,HARD_PEGGING_LEVEL                              VARCHAR2(25)
    ,COMN_SUPPLY_PRJ_DEMAND_FLAG                     VARCHAR2(1)
    ,ENABLE_IOT_FLAG                                 VARCHAR2(1)
    ,RCS_PACKAGING_STRING                            VARCHAR2(100)
    ,CREATE_SUPPLY_AFTER_DATE                        DATE
    ,CREATE_FIXED_DATE                               VARCHAR2(30)
    ,UNDER_COMPL_TOLERANCE_TYPE                      VARCHAR2(30)
    ,UNDER_COMPL_TOLERANCE_VALUE                     NUMBER
    ,REPAIR_TRANSACTION_NAME                         VARCHAR2(250)
    ,NEW_PRIMARY_UOM_NAME                            VARCHAR2(25)
    ,NEW_SECONDARY_UOM_NAME                          VARCHAR2(25)
    );
--
--
PROMPT
PROMPT Creating Table XXMX_SCM_ITEM_REV_XFM
PROMPT
--
-- **********************
-- **Item Revisions Table
-- **********************
CREATE TABLE  XXMX_XFM.XXMX_SCM_ITEM_REV_XFM
    (
     FILE_SET_ID                                     VARCHAR2(30)
    ,MIGRATION_SET_ID                                NUMBER
    ,MIGRATION_SET_NAME                              VARCHAR2(100)
    ,MIGRATION_STATUS                                VARCHAR2(50)
    ,ORG_ID                                          NUMBER
    ,OPERATING_UNIT                                  VARCHAR2(240)  
    ,TRANSACTION_TYPE                                VARCHAR2(10)
    ,BATCH_ID                                        NUMBER(18)
    ,BATCH_NUMBER                                    VARCHAR2(40)
    ,ITEM_NUMBER                                     VARCHAR2(700) 
    ,ORGANIZATION_CODE                               VARCHAR2(18)  
    ,REVISION                                        VARCHAR2(18)
    ,REVISION_REASON                                 VARCHAR2(30)
    ,SOURCE_SYSTEM_CODE                              VARCHAR2(30)
    ,SOURCE_SYSTEM_REFERENCE                         VARCHAR2(255)
    ,DESCRIPTION                                     VARCHAR2(240)
    ,EFFECTIVITY_DATE                                DATE
    ,ECN_INITIATION_DATE                             DATE
    ,IMPLEMENTATION_DATE                             DATE
    ,ATTRIBUTE_CATEGORY                              VARCHAR2(30)
    ,ATTRIBUTE1                                      VARCHAR2(150)
    ,ATTRIBUTE2                                      VARCHAR2(150)
    ,ATTRIBUTE3                                      VARCHAR2(150)
    ,ATTRIBUTE4                                      VARCHAR2(150)
    ,ATTRIBUTE5                                      VARCHAR2(150)
    ,ATTRIBUTE6                                      VARCHAR2(150)
    ,ATTRIBUTE7                                      VARCHAR2(150)
    ,ATTRIBUTE8                                      VARCHAR2(150)
    ,ATTRIBUTE9                                      VARCHAR2(150)
    ,ATTRIBUTE10                                     VARCHAR2(150)
    ,ATTRIBUTE11                                     VARCHAR2(150)
    ,ATTRIBUTE12                                     VARCHAR2(150)
    ,ATTRIBUTE13                                     VARCHAR2(150)
    ,ATTRIBUTE14                                     VARCHAR2(150)
    ,ATTRIBUTE15                                     VARCHAR2(150)
    ,ATTRIBUTE_NUMBER1                               NUMBER
    ,ATTRIBUTE_NUMBER2                               NUMBER
    ,ATTRIBUTE_NUMBER3                               NUMBER
    ,ATTRIBUTE_NUMBER4                               NUMBER
    ,ATTRIBUTE_NUMBER5                               NUMBER
    ,ATTRIBUTE_NUMBER6                               NUMBER
    ,ATTRIBUTE_NUMBER7                               NUMBER
    ,ATTRIBUTE_NUMBER8                               NUMBER
    ,ATTRIBUTE_NUMBER9                               NUMBER
    ,ATTRIBUTE_NUMBER10                              NUMBER
    ,ATTRIBUTE_DATE1                                 DATE
    ,ATTRIBUTE_DATE2                                 DATE
    ,ATTRIBUTE_DATE3                                 DATE
    ,ATTRIBUTE_DATE4                                 DATE
    ,ATTRIBUTE_DATE5                                 DATE
    ,ATTRIBUTE_TIMESTAMP1                            TIMESTAMP(6)
    ,ATTRIBUTE_TIMESTAMP2                            TIMESTAMP(6)
    ,ATTRIBUTE_TIMESTAMP3                            TIMESTAMP(6)
    ,ATTRIBUTE_TIMESTAMP4                            TIMESTAMP(6)
    ,ATTRIBUTE_TIMESTAMP5                            TIMESTAMP(6)
    );
--
--
PROMPT
PROMPT Creating Table XXMX_SCM_ITEM_CAT_XFM
PROMPT
--
-- ************************
-- **Item Categories Table
-- ************************
CREATE TABLE  XXMX_XFM.XXMX_SCM_ITEM_CAT_XFM
    (
     FILE_SET_ID                VARCHAR2(30)
    ,MIGRATION_SET_ID           NUMBER
    ,MIGRATION_SET_NAME         VARCHAR2(100)
    ,MIGRATION_STATUS           VARCHAR2(50)
    ,ORG_ID                     NUMBER
    ,OPERATING_UNIT             VARCHAR2(240) 
    ,TRANSACTION_TYPE           VARCHAR2(10)
    ,BATCH_ID                   NUMBER(18)    
    ,BATCH_NUMBER               VARCHAR2(40)  
    ,ITEM_NUMBER                VARCHAR2(300) 
    ,ORGANIZATION_CODE          VARCHAR2(18)  
    ,CATEGORY_SET_NAME          VARCHAR2(30)  
    ,CATEGORY_NAME              VARCHAR2(250) 
    ,CATEGORY_CODE              VARCHAR2(820) 
    ,OLD_CATEGORY_NAME          VARCHAR2(250) 
    ,OLD_CATEGORY_CODE          VARCHAR2(820) 
    ,SOURCE_SYSTEM_CODE         VARCHAR2(30)  
    ,SOURCE_SYSTEM_REFERENCE    VARCHAR2(255)
    ,START_DATE                 DATE
    ,END_DATE                   DATE  
    );
--
--
PROMPT
PROMPT Creating Table XXMX_SCM_ITEM_ASSOC_XFM
PROMPT
--
-- **************************
-- **Item Associations Table
-- **************************
CREATE TABLE XXMX_XFM.XXMX_SCM_ITEM_ASSOC_XFM
    (
     FILE_SET_ID                           VARCHAR2(30)
    ,MIGRATION_SET_ID                      NUMBER
    ,MIGRATION_SET_NAME                    VARCHAR2(100)
    ,MIGRATION_STATUS                      VARCHAR2(50)
    ,ORG_ID                                NUMBER
    ,OPERATING_UNIT                        VARCHAR2(240)
    ,TRANSACTION_TYPE                      VARCHAR2(10)
    ,BATCH_ID                              NUMBER(18)     
    ,BATCH_NUMBER                          VARCHAR2(40)   
    ,ITEM_NUMBER                           VARCHAR2(700)  
    ,ORGANIZATION_CODE                     VARCHAR2(18)   
    ,SOURCE_SYSTEM_CODE                    VARCHAR2(30)   
    ,SOURCE_SYSTEM_REFERENCE               VARCHAR2(255)  
    ,PRIMARY_FLAG                          VARCHAR2(1)    
    ,STATUS_CODE                           NUMBER         
    ,SUPPLIER_NAME                         VARCHAR2(360)  
    ,SUPPLIER_NUMBER                       VARCHAR2(30)   
    ,SUPPLIER_SITE_NAME                    VARCHAR2(240)  
    ,VERSION_START_DATE                    DATE           
    ,VERSION_REVISION_CODE                 VARCHAR2(18)   
    ,STYLE_ITEM_FLAG                       VARCHAR2(1)    
    );
--
--
PROMPT
PROMPT Creating Table XXMX_SCM_ITEM_REL_XFM
PROMPT
--
-- ****************************
-- **Item Releationships Table
-- ****************************
CREATE TABLE  XXMX_XFM.XXMX_SCM_ITEM_REL_XFM
    (
     FILE_SET_ID                           VARCHAR2(30)
    ,MIGRATION_SET_ID                      NUMBER
    ,MIGRATION_SET_NAME                    VARCHAR2(100)
    ,MIGRATION_STATUS                      VARCHAR2(50)
    ,ORG_ID                                NUMBER
    ,OPERATING_UNIT                        VARCHAR2(240)
    ,TRANSACTION_TYPE                      VARCHAR2(10)
    ,BATCH_ID                              NUMBER(18)      
    ,BATCH_NUMBER                          VARCHAR2(40)    
    ,ITEM_RELATIONSHIP_TYPE                VARCHAR2(120)   
    ,ITEM_NUMBER                           VARCHAR2(820)   
    ,ORGANIZATION_CODE                     VARCHAR2(18)    
    ,MASTER_ORGANIZATION_CODE              VARCHAR2(18)    
    ,SOURCE_SYSTEM_CODE                    VARCHAR2(30)    
    ,SOURCE_SYSTEM_REFERENCE               VARCHAR2(255)   
    ,RELATED_SOURCE_SYSTEM_REF             VARCHAR2(255)   
    ,TP_ITEM_NUMBER                        VARCHAR2(150)   
    ,DESCRIPTION                           VARCHAR2(800)   
    ,RELATED_ITEM_NUMBER                   VARCHAR2(820)   
    ,RELATED_ITEM_RANK                      VARCHAR2(80)    
    ,REVISION_CODE                         VARCHAR2(18)    
    ,SUB_TYPE                              VARCHAR2(100)   
    ,CROSS_REFERENCE                       VARCHAR2(1020)  
    ,ORG_INDEPENDENT_FLAG                  VARCHAR2(4)     
    ,EPC_GTIN_SERIAL                       NUMBER(18)      
    ,START_DATE_ACTIVE                     DATE            
    ,END_DATE_ACTIVE                       DATE            
    ,PREFERENCE_NUMBER                     NUMBER(18)      
    ,MRP_PLANNING_CODE                     NUMBER(18)      
    ,RECIPROCAL_FLAG                       VARCHAR2(4)     
    ,PLANNING_ENABLED_FLAG                 VARCHAR2(4)     
    ,TRADING_PARTNER_NUMBER                VARCHAR2(30)    
    ,UOM_NAME                              VARCHAR2(25)    
    ,ATTRIBUTE_CATEGORY                    VARCHAR2(600)   
    ,ATTRIBUTE1                            VARCHAR2(600)    
    ,ATTRIBUTE2                            VARCHAR2(600)    
    ,ATTRIBUTE3                            VARCHAR2(600)   
    ,ATTRIBUTE4                            VARCHAR2(600)   
    ,ATTRIBUTE5                            VARCHAR2(600)   
    ,ATTRIBUTE6                            VARCHAR2(600)   
    ,ATTRIBUTE7                            VARCHAR2(600)   
    ,ATTRIBUTE8                            VARCHAR2(600)   
    ,ATTRIBUTE9                            VARCHAR2(600)   
    ,ATTRIBUTE10                           VARCHAR2(600)   
    ,ATTRIBUTE11                           VARCHAR2(600)   
    ,ATTRIBUTE12                           VARCHAR2(600)   
    ,ATTRIBUTE13                           VARCHAR2(600)   
    ,ATTRIBUTE14                           VARCHAR2(600)   
    ,ATTRIBUTE15                           VARCHAR2(600)   
    ,ATTRIBUTE16                           VARCHAR2(600)   
    ,ATTRIBUTE17                           VARCHAR2(600)   
    ,ATTRIBUTE18                           VARCHAR2(600)   
    ,ATTRIBUTE19                           VARCHAR2(600)   
    ,ATTRIBUTE20                           VARCHAR2(600)   
    ,ATTRIBUTE21                           VARCHAR2(600)   
    ,ATTRIBUTE22                           VARCHAR2(600)   
    ,ATTRIBUTE23                           VARCHAR2(600)   
    ,ATTRIBUTE24                           VARCHAR2(600)   
    ,ATTRIBUTE25                           VARCHAR2(600)   
    ,ATTRIBUTE26                           VARCHAR2(600)   
    ,ATTRIBUTE27                           VARCHAR2(600)   
    ,ATTRIBUTE28                           VARCHAR2(600)   
    ,ATTRIBUTE29                           VARCHAR2(600)   
    ,ATTRIBUTE30                           VARCHAR2(600)   
    ,ATTRIBUTE_NUMBER1                     NUMBER          
    ,ATTRIBUTE_NUMBER2                     NUMBER          
    ,ATTRIBUTE_NUMBER3                     NUMBER          
    ,ATTRIBUTE_NUMBER4                     NUMBER          
    ,ATTRIBUTE_NUMBER5                     NUMBER          
    ,ATTRIBUTE_NUMBER6                     NUMBER          
    ,ATTRIBUTE_NUMBER7                     NUMBER          
    ,ATTRIBUTE_NUMBER8                     NUMBER          
    ,ATTRIBUTE_NUMBER9                     NUMBER          
    ,ATTRIBUTE_NUMBER10                    NUMBER          
    ,ATTRIBUTE_DATE1                       DATE            
    ,ATTRIBUTE_DATE2                       DATE            
    ,ATTRIBUTE_DATE3                       DATE            
    ,ATTRIBUTE_DATE4                       DATE            
    ,ATTRIBUTE_DATE5                       DATE           
    ,ATTRIBUTE_TIMESTAMP1                  TIMESTAMP(6)    
    ,ATTRIBUTE_TIMESTAMP2                  TIMESTAMP(6)    
    ,ATTRIBUTE_TIMESTAMP3                  TIMESTAMP(6)    
    ,ATTRIBUTE_TIMESTAMP4                  TIMESTAMP(6)    
    ,ATTRIBUTE_TIMESTAMP5                  TIMESTAMP(6)    
    ,STATUS_CODE                           VARCHAR2(30)
    ,RELATIONSHIP_RANK                     NUMBER   
    );
--
--
PROMPT
PROMPT Creating Table XXMX_SCM_ITEM_EFF_XFM
PROMPT
--
-- ***********************************
-- **Item Extensible Flexfields Table
-- ***********************************
CREATE TABLE  XXMX_SCM_ITEM_EFF_XFM
    (
     FILE_SET_ID                    VARCHAR2(30)
    ,MIGRATION_SET_ID               NUMBER
    ,MIGRATION_SET_NAME             VARCHAR2(100)
    ,MIGRATION_STATUS               VARCHAR2(50)
    ,ORG_ID                         NUMBER
    ,OPERATING_UNIT                 VARCHAR2(240)
    ,TRANSACTION_TYPE               VARCHAR2(10)            
    ,BATCH_ID                       NUMBER(18)
    ,BATCH_NUMBER                   VARCHAR2(40)            
    ,ITEM_NUMBER                    VARCHAR2(820)           
    ,ORGANIZATION_CODE              VARCHAR2(18)
    ,SOURCE_SYSTEM_CODE             VARCHAR2(30)
    ,SOURCE_SYSTEM_REFERENCE        VARCHAR2(255)       
    ,CONTEXT_CODE                   VARCHAR2(80)
    ,ATTRIBUTE_CHAR1                VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR2                VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR3                VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR4                VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR5                VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR6                VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR7                VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR8                VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR9                VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR10               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR11               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR12               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR13               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR14               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR15               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR16               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR17               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR18               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR19               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR20               VARCHAR2(4000)          
    ,ATTRIBUTE_NUMBER1              NUMBER                  
    ,ATTRIBUTE_NUMBER2              NUMBER                  
    ,ATTRIBUTE_NUMBER3              NUMBER                  
    ,ATTRIBUTE_NUMBER4              NUMBER                  
    ,ATTRIBUTE_NUMBER5              NUMBER                  
    ,ATTRIBUTE_NUMBER6              NUMBER                  
    ,ATTRIBUTE_NUMBER7              NUMBER                  
    ,ATTRIBUTE_NUMBER8              NUMBER                  
    ,ATTRIBUTE_NUMBER9              NUMBER                  
    ,ATTRIBUTE_NUMBER10             NUMBER                  
    ,ATTRIBUTE_DATE1                DATE                    
    ,ATTRIBUTE_DATE2                DATE                    
    ,ATTRIBUTE_DATE3                DATE                    
    ,ATTRIBUTE_DATE4                DATE                    
    ,ATTRIBUTE_DATE5                DATE                    
    ,ATTRIBUTE_CHAR21               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR22               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR23               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR24               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR25               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR26               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR27               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR28               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR29               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR30               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR31               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR32               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR33               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR34               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR35               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR36               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR37               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR38               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR39               VARCHAR2(4000)          
    ,ATTRIBUTE_CHAR40               VARCHAR2(4000)          
    ,ATTRIBUTE_NUMBER11             NUMBER                  
    ,ATTRIBUTE_NUMBER12             NUMBER                  
    ,ATTRIBUTE_NUMBER13             NUMBER                  
    ,ATTRIBUTE_NUMBER14             NUMBER                  
    ,ATTRIBUTE_NUMBER15             NUMBER                  
    ,ATTRIBUTE_NUMBER16             NUMBER                  
    ,ATTRIBUTE_NUMBER17             NUMBER                  
    ,ATTRIBUTE_NUMBER18             NUMBER                  
    ,ATTRIBUTE_NUMBER19             NUMBER                  
    ,ATTRIBUTE_NUMBER20             NUMBER                  
    ,ATTRIBUTE_DATE6                DATE                    
    ,ATTRIBUTE_DATE7                DATE                    
    ,ATTRIBUTE_DATE8                DATE                    
    ,ATTRIBUTE_DATE9                DATE                    
    ,ATTRIBUTE_DATE10               DATE                    
    ,ATTRIBUTE_TIMESTAMP1           TIMESTAMP(6)            
    ,ATTRIBUTE_TIMESTAMP2           TIMESTAMP(6)            
    ,ATTRIBUTE_TIMESTAMP3           TIMESTAMP(6)            
    ,ATTRIBUTE_TIMESTAMP4           TIMESTAMP(6)            
    ,ATTRIBUTE_TIMESTAMP5           TIMESTAMP(6)            
    ,ATTRIBUTE_TIMESTAMP6           TIMESTAMP(6)            
    ,ATTRIBUTE_TIMESTAMP7           TIMESTAMP(6)            
    ,ATTRIBUTE_TIMESTAMP8           TIMESTAMP(6)            
    ,ATTRIBUTE_TIMESTAMP9           TIMESTAMP(6)            
    ,ATTRIBUTE_TIMESTAMP10          TIMESTAMP(6)            
    ,VERSION_START_DATE             DATE                    
    ,VERSION_REVISION_CODE          VARCHAR2(18)
    ,ATTRIBUTE_NUMBER1_UOM_NAME     VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER2_UOM_NAME     VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER3_UOM_NAME     VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER4_UOM_NAME     VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER5_UOM_NAME     VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER6_UOM_NAME     VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER7_UOM_NAME     VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER8_UOM_NAME     VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER9_UOM_NAME     VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER10_UOM_NAME    VARCHAR2(25)      
    ,ATTRIBUTE_NUMBER11_UOM_NAME    VARCHAR2(25)      
    ,ATTRIBUTE_NUMBER12_UOM_NAME    VARCHAR2(25)      
    ,ATTRIBUTE_NUMBER13_UOM_NAME    VARCHAR2(25)      
    ,ATTRIBUTE_NUMBER14_UOM_NAME    VARCHAR2(25)      
    ,ATTRIBUTE_NUMBER15_UOM_NAME    VARCHAR2(25)      
    ,ATTRIBUTE_NUMBER16_UOM_NAME    VARCHAR2(25)      
    ,ATTRIBUTE_NUMBER17_UOM_NAME    VARCHAR2(25)      
    ,ATTRIBUTE_NUMBER18_UOM_NAME    VARCHAR2(25)      
    ,ATTRIBUTE_NUMBER19_UOM_NAME    VARCHAR2(25)      
    ,ATTRIBUTE_NUMBER20_UOM_NAME    VARCHAR2(25)      
    ,ATTRIBUTE_NUMBER1_UE           NUMBER                  
    ,ATTRIBUTE_NUMBER2_UE           NUMBER                  
    ,ATTRIBUTE_NUMBER3_UE           NUMBER                  
    ,ATTRIBUTE_NUMBER4_UE           NUMBER                  
    ,ATTRIBUTE_NUMBER5_UE           NUMBER                  
    ,ATTRIBUTE_NUMBER6_UE           NUMBER                  
    ,ATTRIBUTE_NUMBER7_UE           NUMBER                  
    ,ATTRIBUTE_NUMBER8_UE           NUMBER                  
    ,ATTRIBUTE_NUMBER9_UE           NUMBER                  
    ,ATTRIBUTE_NUMBER10_UE          NUMBER                  
    ,ATTRIBUTE_NUMBER11_UE          NUMBER                  
    ,ATTRIBUTE_NUMBER12_UE          NUMBER                  
    ,ATTRIBUTE_NUMBER13_UE          NUMBER                  
    ,ATTRIBUTE_NUMBER14_UE          NUMBER                  
    ,ATTRIBUTE_NUMBER15_UE          NUMBER                  
    ,ATTRIBUTE_NUMBER16_UE          NUMBER                  
    ,ATTRIBUTE_NUMBER17_UE          NUMBER                  
    ,ATTRIBUTE_NUMBER18_UE          NUMBER                  
    ,ATTRIBUTE_NUMBER19_UE          NUMBER                  
    ,ATTRIBUTE_NUMBER20_UE          NUMBER
    );
--
--
PROMPT
PROMPT Creating Table XXMX_SCM_ITEM_EFF_TL_XFM
PROMPT
--
-- ***********************************************
-- **Item Translatable Extensible Flexfields Table
-- ***********************************************
CREATE TABLE  XXMX_SCM_ITEM_EFF_TL_XFM
    (
     FILE_SET_ID                    VARCHAR2(30)
    ,MIGRATION_SET_ID               NUMBER
    ,MIGRATION_SET_NAME             VARCHAR2(100)
    ,MIGRATION_STATUS               VARCHAR2(50)
    ,ORG_ID                         NUMBER
    ,OPERATING_UNIT                 VARCHAR2(240)
    ,TRANSACTION_TYPE               VARCHAR2(10)
    ,BATCH_ID                       NUMBER(18)      
    ,BATCH_NUMBER                   VARCHAR2(40)    
    ,ITEM_NUMBER                    VARCHAR2(820)   
    ,ORGANIZATION_CODE              VARCHAR2(18)    
    ,SOURCE_SYSTEM_CODE             VARCHAR2(30)    
    ,SOURCE_SYSTEM_REFERENCE        VARCHAR2(255)   
    ,CONTEXT_CODE                   VARCHAR2(80)    
    ,ATTRIBUTE_CHAR1                VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR2                VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR3                VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR4                VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR5                VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR6                VARCHAR2(4000)    
    ,ATTRIBUTE_CHAR7                VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR8                VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR9                VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR10               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR11               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR12               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR13               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR14               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR15               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR16               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR17               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR18               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR19               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR20               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR21               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR22               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR23               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR24               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR25               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR26               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR27               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR28               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR29               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR30               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR31               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR32               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR33               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR34               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR35               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR36               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR37               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR38               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR39               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR40               VARCHAR2(4000)  
    ,SOURCE_LANG                    VARCHAR2(4)     
    ,LANGUAGE                       VARCHAR2(4)     
    ,VERSION_START_DATE             DATE            
    ,VERSION_REVISION_CODE          VARCHAR2(18)     
    );
--
--
PROMPT
PROMPT Creating Table XXMX_SCM_ITEM_REV_EFF_XFM
PROMPT
--
-- *******************************************
-- **Item Revision Extensible Flexfields Table
-- ********************************************
CREATE TABLE  XXMX_SCM_ITEM_REV_EFF_XFM
    (
     FILE_SET_ID                    VARCHAR2(30)
    ,MIGRATION_SET_ID               NUMBER
    ,MIGRATION_SET_NAME             VARCHAR2(100)
    ,MIGRATION_STATUS               VARCHAR2(50)
    ,ORG_ID                         NUMBER
    ,OPERATING_UNIT                 VARCHAR2(240)
    ,TRANSACTION_TYPE               VARCHAR2(10)
    ,BATCH_ID                       NUMBER(18)
    ,BATCH_NUMBER                   VARCHAR2(40)     
    ,ITEM_NUMBER                    VARCHAR2(820)    
    ,ORGANIZATION_CODE              VARCHAR2(18)
    ,REVISION                       VARCHAR2(18)     
    ,SOURCE_SYSTEM_CODE             VARCHAR2(30)
    ,SOURCE_SYSTEM_REFERENCE        VARCHAR2(255)
    ,CONTEXT_CODE                   VARCHAR2(80)
    ,ATTRIBUTE_CHAR1                VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR2                VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR3                VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR4                VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR5                VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR6                VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR7                VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR8                VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR9                VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR10               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR11               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR12               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR13               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR14               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR15               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR16               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR17               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR18               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR19               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR20               VARCHAR2(4000)   
    ,ATTRIBUTE_NUMBER1              NUMBER           
    ,ATTRIBUTE_NUMBER2              NUMBER           
    ,ATTRIBUTE_NUMBER3              NUMBER           
    ,ATTRIBUTE_NUMBER4              NUMBER           
    ,ATTRIBUTE_NUMBER5              NUMBER           
    ,ATTRIBUTE_NUMBER6              NUMBER           
    ,ATTRIBUTE_NUMBER7              NUMBER           
    ,ATTRIBUTE_NUMBER8              NUMBER           
    ,ATTRIBUTE_NUMBER9              NUMBER           
    ,ATTRIBUTE_NUMBER10             NUMBER           
    ,ATTRIBUTE_DATE1                DATE             
    ,ATTRIBUTE_DATE2                DATE             
    ,ATTRIBUTE_DATE3                DATE             
    ,ATTRIBUTE_DATE4                DATE             
    ,ATTRIBUTE_DATE5                DATE             
    ,ATTRIBUTE_CHAR21               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR22               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR23               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR24               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR25               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR26               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR27               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR28               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR29               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR30               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR31               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR32               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR33               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR34               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR35               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR36               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR37               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR38               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR39               VARCHAR2(4000)   
    ,ATTRIBUTE_CHAR40               VARCHAR2(4000)   
    ,ATTRIBUTE_NUMBER11             NUMBER           
    ,ATTRIBUTE_NUMBER12             NUMBER           
    ,ATTRIBUTE_NUMBER13             NUMBER           
    ,ATTRIBUTE_NUMBER14             NUMBER           
    ,ATTRIBUTE_NUMBER15             NUMBER           
    ,ATTRIBUTE_NUMBER16             NUMBER           
    ,ATTRIBUTE_NUMBER17             NUMBER           
    ,ATTRIBUTE_NUMBER18             NUMBER           
    ,ATTRIBUTE_NUMBER19             NUMBER           
    ,ATTRIBUTE_NUMBER20             NUMBER           
    ,ATTRIBUTE_DATE6                DATE             
    ,ATTRIBUTE_DATE7                DATE             
    ,ATTRIBUTE_DATE8                DATE             
    ,ATTRIBUTE_DATE9                DATE             
    ,ATTRIBUTE_DATE10               DATE             
    ,ATTRIBUTE_TIMESTAMP1           TIMESTAMP(6)     
    ,ATTRIBUTE_TIMESTAMP2           TIMESTAMP(6)     
    ,ATTRIBUTE_TIMESTAMP3           TIMESTAMP(6)     
    ,ATTRIBUTE_TIMESTAMP4           TIMESTAMP(6)     
    ,ATTRIBUTE_TIMESTAMP5           TIMESTAMP(6)     
    ,ATTRIBUTE_TIMESTAMP6           TIMESTAMP(6)     
    ,ATTRIBUTE_TIMESTAMP7           TIMESTAMP(6)     
    ,ATTRIBUTE_TIMESTAMP8           TIMESTAMP(6)     
    ,ATTRIBUTE_TIMESTAMP9           TIMESTAMP(6)     
    ,ATTRIBUTE_TIMESTAMP10          TIMESTAMP(6)     
    ,VERSION_START_DATE             DATE             
    ,VERSION_CODE                   VARCHAR2(18)
    ,ATTRIBUTE_NUMBER1_UOM_NAME     VARCHAR2(25)
    ,ATTRIBUTE_NUMBER2_UOM_NAME     VARCHAR2(25)
    ,ATTRIBUTE_NUMBER3_UOM_NAME     VARCHAR2(25)
    ,ATTRIBUTE_NUMBER4_UOM_NAME     VARCHAR2(25)
    ,ATTRIBUTE_NUMBER5_UOM_NAME     VARCHAR2(25)
    ,ATTRIBUTE_NUMBER6_UOM_NAME     VARCHAR2(25)
    ,ATTRIBUTE_NUMBER7_UOM_NAME     VARCHAR2(25)
    ,ATTRIBUTE_NUMBER8_UOM_NAME     VARCHAR2(25)
    ,ATTRIBUTE_NUMBER9_UOM_NAME     VARCHAR2(25)
    ,ATTRIBUTE_NUMBER10_UOM_NAME    VARCHAR2(25)
    ,ATTRIBUTE_NUMBER11_UOM_NAME    VARCHAR2(25)
    ,ATTRIBUTE_NUMBER12_UOM_NAME    VARCHAR2(25)
    ,ATTRIBUTE_NUMBER13_UOM_NAME    VARCHAR2(25)
    ,ATTRIBUTE_NUMBER14_UOM_NAME    VARCHAR2(25)
    ,ATTRIBUTE_NUMBER15_UOM_NAME    VARCHAR2(25)
    ,ATTRIBUTE_NUMBER16_UOM_NAME    VARCHAR2(25)
    ,ATTRIBUTE_NUMBER17_UOM_NAME    VARCHAR2(25)
    ,ATTRIBUTE_NUMBER18_UOM_NAME    VARCHAR2(25)
    ,ATTRIBUTE_NUMBER19_UOM_NAME    VARCHAR2(25)
    ,ATTRIBUTE_NUMBER20_UOM_NAME    VARCHAR2(25)
    ,ATTRIBUTE_NUMBER1_UE           NUMBER          
    ,ATTRIBUTE_NUMBER2_UE           NUMBER       
    ,ATTRIBUTE_NUMBER3_UE           NUMBER       
    ,ATTRIBUTE_NUMBER4_UE           NUMBER       
    ,ATTRIBUTE_NUMBER5_UE           NUMBER           
    ,ATTRIBUTE_NUMBER6_UE           NUMBER           
    ,ATTRIBUTE_NUMBER7_UE           NUMBER           
    ,ATTRIBUTE_NUMBER8_UE           NUMBER           
    ,ATTRIBUTE_NUMBER9_UE           NUMBER           
    ,ATTRIBUTE_NUMBER10_UE          NUMBER           
    ,ATTRIBUTE_NUMBER11_UE          NUMBER           
    ,ATTRIBUTE_NUMBER12_UE          NUMBER           
    ,ATTRIBUTE_NUMBER13_UE          NUMBER           
    ,ATTRIBUTE_NUMBER14_UE          NUMBER           
    ,ATTRIBUTE_NUMBER15_UE          NUMBER           
    ,ATTRIBUTE_NUMBER16_UE          NUMBER           
    ,ATTRIBUTE_NUMBER17_UE          NUMBER           
    ,ATTRIBUTE_NUMBER18_UE          NUMBER           
    ,ATTRIBUTE_NUMBER19_UE          NUMBER           
    ,ATTRIBUTE_NUMBER20_UE          NUMBER   
    );
--
--
PROMPT
PROMPT Creating Table XXMX_SCM_ITEM_REV_EFF_TL_XFM
PROMPT
--
-- *********************************************************
-- **Item Revision Translatable Extensible Flexfields Table
-- *********************************************************
CREATE TABLE  XXMX_SCM_ITEM_REV_EFF_TL_XFM
    (
     FILE_SET_ID                    VARCHAR2(30)
    ,MIGRATION_SET_ID               NUMBER
    ,MIGRATION_SET_NAME             VARCHAR2(100)
    ,MIGRATION_STATUS               VARCHAR2(50)
    ,ORG_ID                         NUMBER
    ,OPERATING_UNIT                 VARCHAR2(240)
    ,TRANSACTION_TYPE               VARCHAR2(10)
    ,BATCH_ID                       NUMBER(18)
    ,BATCH_NUMBER                   VARCHAR2(40)    
    ,ITEM_NUMBER                    VARCHAR2(820)   
    ,ORGANIZATION_CODE              VARCHAR2(18)
    ,REVISION                       VARCHAR2(30)
    ,SOURCE_SYSTEM_CODE             VARCHAR2(30)
    ,SOURCE_SYSTEM_REFERENCE        VARCHAR2(255)   
    ,CONTEXT_CODE                   VARCHAR2(80)
    ,ATTRIBUTE_CHAR1                VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR2                VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR3                VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR4                VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR5                VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR6                VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR7                VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR8                VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR9                VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR10               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR11               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR12               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR13               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR14               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR15               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR16               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR17               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR18               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR19               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR20               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR21               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR22               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR23               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR24               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR25               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR26               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR27               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR28               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR29               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR30               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR31               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR32               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR33               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR34               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR35               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR36               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR37               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR38               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR39               VARCHAR2(4000)  
    ,ATTRIBUTE_CHAR40               VARCHAR2(4000)  
    ,VERSION_START_DATE             DATE            
    ,VERSION_REVISION_CODE          VARCHAR2(18)    
    ,SOURCE_LANG                    VARCHAR2(4)     
    ,LANGUAGE                       VARCHAR2(4)
    );  
--
--
PROMPT
PROMPT Creating Table XXMX_SCM_ITEM_SUPP_EFF_XFM
PROMPT
--
-- *******************************************
-- **Item Supplier Extensible Flexfields Table
-- *******************************************
CREATE TABLE XXMX_SCM_ITEM_SUPP_EFF_XFM
    (
     FILE_SET_ID                        VARCHAR2(30)
    ,MIGRATION_SET_ID                   NUMBER
    ,MIGRATION_SET_NAME                 VARCHAR2(100)
    ,MIGRATION_STATUS                   VARCHAR2(50)
    ,ORG_ID                             NUMBER
    ,OPERATING_UNIT                     VARCHAR2(240)
    ,TRANSACTION_TYPE                   VARCHAR2(10)
    ,BATCH_ID                           NUMBER(18)
    ,BATCH_NUMBER                       VARCHAR2(40)       
    ,ITEM_NUMBER                        VARCHAR2(820)      
    ,ORGANIZATION_CODE                  VARCHAR2(18)
    ,SUPPLIER_NAME                      VARCHAR2(360)      
    ,SUPPLIER_SITE_NAME                 VARCHAR2(240)      
    ,SOURCE_SYSTEM_CODE                 VARCHAR2(30)
    ,SOURCE_SYSTEM_REFERENCE            VARCHAR2(255)  
    ,CONTEXT_CODE                       VARCHAR2(80)
    ,ATTRIBUTE_CHAR1                    VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR2                    VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR3                    VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR4                    VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR5                    VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR6                    VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR7                    VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR8                    VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR9                    VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR10                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR11                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR12                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR13                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR14                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR15                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR16                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR17                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR18                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR19                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR20                   VARCHAR2(4000)     
    ,ATTRIBUTE_NUMBER1                  NUMBER             
    ,ATTRIBUTE_NUMBER2                  NUMBER             
    ,ATTRIBUTE_NUMBER3                  NUMBER             
    ,ATTRIBUTE_NUMBER4                  NUMBER             
    ,ATTRIBUTE_NUMBER5                  NUMBER             
    ,ATTRIBUTE_NUMBER6                  NUMBER             
    ,ATTRIBUTE_NUMBER7                  NUMBER             
    ,ATTRIBUTE_NUMBER8                  NUMBER             
    ,ATTRIBUTE_NUMBER9                  NUMBER             
    ,ATTRIBUTE_NUMBER10                 NUMBER             
    ,ATTRIBUTE_DATE1                    DATE               
    ,ATTRIBUTE_DATE2                    DATE               
    ,ATTRIBUTE_DATE3                    DATE               
    ,ATTRIBUTE_DATE4                    DATE               
    ,ATTRIBUTE_DATE5                    DATE               
    ,ATTRIBUTE_CHAR21                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR22                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR23                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR24                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR25                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR26                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR27                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR28                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR29                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR30                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR31                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR32                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR33                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR34                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR35                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR36                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR37                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR38                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR39                   VARCHAR2(4000)     
    ,ATTRIBUTE_CHAR40                   VARCHAR2(4000)     
    ,ATTRIBUTE_NUMBER11                 NUMBER             
    ,ATTRIBUTE_NUMBER12                 NUMBER             
    ,ATTRIBUTE_NUMBER13                 NUMBER             
    ,ATTRIBUTE_NUMBER14                 NUMBER             
    ,ATTRIBUTE_NUMBER15                 NUMBER             
    ,ATTRIBUTE_NUMBER16                 NUMBER             
    ,ATTRIBUTE_NUMBER17                 NUMBER             
    ,ATTRIBUTE_NUMBER18                 NUMBER             
    ,ATTRIBUTE_NUMBER19                 NUMBER             
    ,ATTRIBUTE_NUMBER20                 NUMBER             
    ,ATTRIBUTE_DATE6                    DATE               
    ,ATTRIBUTE_DATE7                    DATE               
    ,ATTRIBUTE_DATE8                    DATE               
    ,ATTRIBUTE_DATE9                    DATE               
    ,ATTRIBUTE_DATE10                   DATE               
    ,ATTRIBUTE_TIMESTAMP1               TIMESTAMP(6)       
    ,ATTRIBUTE_TIMESTAMP2               TIMESTAMP(6)       
    ,ATTRIBUTE_TIMESTAMP3               TIMESTAMP(6)       
    ,ATTRIBUTE_TIMESTAMP4               TIMESTAMP(6)       
    ,ATTRIBUTE_TIMESTAMP5               TIMESTAMP(6)       
    ,ATTRIBUTE_TIMESTAMP6               TIMESTAMP(6)       
    ,ATTRIBUTE_TIMESTAMP7               TIMESTAMP(6)       
    ,ATTRIBUTE_TIMESTAMP8               TIMESTAMP(6)       
    ,ATTRIBUTE_TIMESTAMP9               TIMESTAMP(6)       
    ,ATTRIBUTE_TIMESTAMP10              TIMESTAMP(6)       
    ,VERSION_START_DATE                 DATE               
    ,VERSION_CODE                       VARCHAR2(18)
    ,ATTRIBUTE_NUMBER1_UOM_NAME         VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER2_UOM_NAME         VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER3_UOM_NAME         VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER4_UOM_NAME         VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER5_UOM_NAME         VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER6_UOM_NAME         VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER7_UOM_NAME         VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER8_UOM_NAME         VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER9_UOM_NAME         VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER10_UOM_NAME        VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER11_UOM_NAME        VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER12_UOM_NAME        VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER13_UOM_NAME        VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER14_UOM_NAME        VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER15_UOM_NAME        VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER16_UOM_NAME        VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER17_UOM_NAME        VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER18_UOM_NAME        VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER19_UOM_NAME        VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER20_UOM_NAME        VARCHAR2(25)       
    ,ATTRIBUTE_NUMBER1_UE               NUMBER      
    ,ATTRIBUTE_NUMBER2_UE               NUMBER             
    ,ATTRIBUTE_NUMBER3_UE               NUMBER             
    ,ATTRIBUTE_NUMBER4_UE               NUMBER             
    ,ATTRIBUTE_NUMBER5_UE               NUMBER             
    ,ATTRIBUTE_NUMBER6_UE               NUMBER             
    ,ATTRIBUTE_NUMBER7_UE               NUMBER             
    ,ATTRIBUTE_NUMBER8_UE               NUMBER             
    ,ATTRIBUTE_NUMBER9_UE               NUMBER             
    ,ATTRIBUTE_NUMBER10_UE              NUMBER             
    ,ATTRIBUTE_NUMBER11_UE              NUMBER             
    ,ATTRIBUTE_NUMBER12_UE              NUMBER             
    ,ATTRIBUTE_NUMBER13_UE              NUMBER             
    ,ATTRIBUTE_NUMBER14_UE              NUMBER             
    ,ATTRIBUTE_NUMBER15_UE              NUMBER             
    ,ATTRIBUTE_NUMBER16_UE              NUMBER             
    ,ATTRIBUTE_NUMBER17_UE              NUMBER             
    ,ATTRIBUTE_NUMBER18_UE              NUMBER             
    ,ATTRIBUTE_NUMBER19_UE              NUMBER             
    ,ATTRIBUTE_NUMBER20_UE              NUMBER
    );
--
--
PROMPT
PROMPT Creating Table XXMX_SCM_ITEM_SUPP_EFF_TL_XFM
PROMPT
--
-- ********************************************************
-- **Item Supplier Translatable Extensible Flexfields Table
-- ********************************************************
CREATE TABLE  XXMX_SCM_ITEM_SUPP_EFF_TL_XFM
    (
     FILE_SET_ID                    VARCHAR2(30)
    ,MIGRATION_SET_ID               NUMBER
    ,MIGRATION_SET_NAME             VARCHAR2(100)
    ,MIGRATION_STATUS               VARCHAR2(50)
    ,ORG_ID                         NUMBER
    ,OPERATING_UNIT                 VARCHAR2(240)
    ,TRANSACTION_TYPE               VARCHAR2(10)
    ,BATCH_ID                       NUMBER(18)
    ,BATCH_NUMBER                   VARCHAR2(40)  
    ,ITEM_NUMBER                    VARCHAR2(820) 
    ,ORGANIZATION_CODE              VARCHAR2(18)
    ,SUPPLIER_NAME                  VARCHAR2(360) 
    ,SUPPLIER_SITE_NAME             VARCHAR2(240) 
    ,SOURCE_SYSTEM_CODE             VARCHAR2(30)
    ,SOURCE_SYSTEM_REFERENCE        VARCHAR2(255) 
    ,CONTEXT_CODE                   VARCHAR2(80)
    ,ATTRIBUTE_CHAR1                VARCHAR2(4000)
    ,ATTRIBUTE_CHAR2                VARCHAR2(4000)
    ,ATTRIBUTE_CHAR3                VARCHAR2(4000)
    ,ATTRIBUTE_CHAR4                VARCHAR2(4000)
    ,ATTRIBUTE_CHAR5                VARCHAR2(4000)
    ,ATTRIBUTE_CHAR6                VARCHAR2(4000)
    ,ATTRIBUTE_CHAR7                VARCHAR2(4000)
    ,ATTRIBUTE_CHAR8                VARCHAR2(4000)
    ,ATTRIBUTE_CHAR9                VARCHAR2(4000)
    ,ATTRIBUTE_CHAR10               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR11               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR12               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR13               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR14               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR15               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR16               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR17               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR18               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR19               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR20               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR21               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR22               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR23               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR24               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR25               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR26               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR27               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR28               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR29               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR30               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR31               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR32               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR33               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR34               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR35               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR36               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR37               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR38               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR39               VARCHAR2(4000)
    ,ATTRIBUTE_CHAR40               VARCHAR2(4000)
    ,VERSION_START_DATE                 DATE          
    ,VERSION_REVISION_CODE          VARCHAR2(18)  
    ,SOURCE_LANG                    VARCHAR2(4)   
    ,LANGUAGE                       VARCHAR2(4)
    );
--
--
PROMPT
PROMPT Creating Table XXMX_SCM_ITEM_STYL_ATTR_XFM
PROMPT
--
-- ***********************************************
-- **Item Style Variant Attribute Value Sets Table
-- ***********************************************
CREATE TABLE  XXMX_SCM_ITEM_STYL_ATTR_XFM
    (
     FILE_SET_ID                    VARCHAR2(30)
    ,MIGRATION_SET_ID               NUMBER
    ,MIGRATION_SET_NAME             VARCHAR2(100)
    ,MIGRATION_STATUS               VARCHAR2(50)
    ,ORG_ID                         NUMBER
    ,OPERATING_UNIT                 VARCHAR2(240)
    ,ATTRIBUTE_GROUP_CODE           VARCHAR2(320)
    ,ATTRIBUTE_CODE                 VARCHAR2(120) 
    ,VALUE_SET_CODE                 VARCHAR2(60)  
    ,BATCH_ID                       NUMBER(18)    
    ,BATCH_NUMBER                   VARCHAR2(40)  
    ,ITEM_NUMBER                    VARCHAR2(300) 
    ,SOURCE_SYSTEM_CODE             VARCHAR2(30)  
    ,SOURCE_SYSTEM_REFERENCE        VARCHAR2(255)  
    );
--
--
PROMPT
PROMPT Creating Table XXMX_SCM_TP_ITEMS_XFM
PROMPT
--
-- *****************************
-- **Trading Partner Items Table
-- *****************************
CREATE TABLE  XXMX_SCM_TP_ITEMS_XFM
    (
     FILE_SET_ID                    VARCHAR2(30)
    ,MIGRATION_SET_ID               NUMBER
    ,MIGRATION_SET_NAME             VARCHAR2(100)
    ,MIGRATION_STATUS               VARCHAR2(50)
    ,ORG_ID                         NUMBER
    ,OPERATING_UNIT                 VARCHAR2(240)
    ,TRANSACTION_TYPE               VARCHAR2(10)
    ,BATCH_ID                       NUMBER(18)       
    ,BATCH_NUMBER                   VARCHAR2(40)     
    ,TP_ITEM_NUMBER                 VARCHAR2(150)    
    ,TP_ITEM_DESC                   VARCHAR2(240)    
    ,TP_TYPE                        VARCHAR2(30)     
    ,TRADING_PARTNER_NUMBER         VARCHAR2(30)  
    ,START_DATE                     DATE             
    ,END_DATE                       DATE             
    ,TP_ITEM_UOM_NAME               VARCHAR2(25)     
    ,UNIT_PRICE_AMT                 NUMBER           
    ,UNIT_PRICE_CURRENCY_CODE       VARCHAR2(15)
    ,AVERAGE_RATING_NUMBER          NUMBER(18)     
    ,ATTRIBUTE_CATEGORY             VARCHAR2(30)     
    ,ATTRIBUTE1                     VARCHAR2(150)    
    ,ATTRIBUTE2                     VARCHAR2(150)    
    ,ATTRIBUTE3                     VARCHAR2(150)    
    ,ATTRIBUTE4                     VARCHAR2(150)    
    ,ATTRIBUTE5                     VARCHAR2(150)    
    ,ATTRIBUTE6                     VARCHAR2(150)    
    ,ATTRIBUTE7                     VARCHAR2(150)    
    ,ATTRIBUTE8                     VARCHAR2(150)    
    ,ATTRIBUTE9                     VARCHAR2(150)    
    ,ATTRIBUTE10                    VARCHAR2(150)   
    ,ATTRIBUTE11                    VARCHAR2(150)   
    ,ATTRIBUTE12                    VARCHAR2(150)   
    ,ATTRIBUTE13                    VARCHAR2(150)   
    ,ATTRIBUTE14                    VARCHAR2(150)   
    ,ATTRIBUTE15                    VARCHAR2(150)   
    ,ATTRIBUTE16                    VARCHAR2(150)   
    ,ATTRIBUTE17                    VARCHAR2(150)   
    ,ATTRIBUTE18                    VARCHAR2(150)   
    ,ATTRIBUTE19                    VARCHAR2(150)   
    ,ATTRIBUTE20                    VARCHAR2(150)   
    ,ATTRIBUTE21                    VARCHAR2(150)   
    ,ATTRIBUTE22                    VARCHAR2(150)   
    ,ATTRIBUTE23                    VARCHAR2(150)   
    ,ATTRIBUTE24                    VARCHAR2(150)   
    ,ATTRIBUTE25                    VARCHAR2(150)   
    ,ATTRIBUTE26                    VARCHAR2(150)   
    ,ATTRIBUTE27                    VARCHAR2(150)   
    ,ATTRIBUTE28                    VARCHAR2(150)   
    ,ATTRIBUTE29                    VARCHAR2(150)   
    ,ATTRIBUTE30                    VARCHAR2(150)   
    ,ATTRIBUTE_NUMBER1              NUMBER          
    ,ATTRIBUTE_NUMBER2              NUMBER          
    ,ATTRIBUTE_NUMBER3              NUMBER          
    ,ATTRIBUTE_NUMBER4              NUMBER          
    ,ATTRIBUTE_NUMBER5              NUMBER          
    ,ATTRIBUTE_NUMBER6              NUMBER          
    ,ATTRIBUTE_NUMBER7              NUMBER          
    ,ATTRIBUTE_NUMBER8              NUMBER          
    ,ATTRIBUTE_NUMBER9              NUMBER          
    ,ATTRIBUTE_NUMBER10             NUMBER          
    ,ATTRIBUTE_DATE1                DATE            
    ,ATTRIBUTE_DATE2                DATE            
    ,ATTRIBUTE_DATE3                DATE            
    ,ATTRIBUTE_DATE4                DATE            
    ,ATTRIBUTE_DATE5                DATE            
    ,ATTRIBUTE_TIMESTAMP1           TIMESTAMP(6)    
    ,ATTRIBUTE_TIMESTAMP2           TIMESTAMP(6)    
    ,ATTRIBUTE_TIMESTAMP3           TIMESTAMP(6)    
    ,ATTRIBUTE_TIMESTAMP4           TIMESTAMP(6)    
    ,ATTRIBUTE_TIMESTAMP5           TIMESTAMP(6)    
    ,PART_STATUS_CODE               VARCHAR2(30)
    ,NEW_TP_ITEM_NUMBER             VARCHAR2(150) 
    );   
--
--
PROMPT
PROMPT
PROMPT ********************
PROMPT ** Creating Synonyms
PROMPT ********************
--
--
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_SYS_ITEMS_XFM FOR XXMX_XFM.XXMX_SCM_SYS_ITEMS_XFM;
--
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_ITEM_REV_XFM FOR XXMX_XFM.XXMX_SCM_ITEM_REV_XFM;
--
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_ITEM_CAT_XFM FOR XXMX_XFM.XXMX_SCM_ITEM_CAT_XFM;
--
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_ITEM_ASSOC_XFM FOR XXMX_XFM.XXMX_SCM_ITEM_ASSOC_XFM;
--
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_ITEM_REL_XFM FOR XXMX_XFM.XXMX_SCM_ITEM_REL_XFM;
--
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_ITEM_EFF_XFM FOR XXMX_XFM.XXMX_SCM_ITEM_EFF_XFM;
--
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_ITEM_EFF_TL_XFM FOR XXMX_XFM.XXMX_SCM_ITEM_EFF_TL_XFM;
--
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_ITEM_REV_EFF_XFM FOR XXMX_XFM.XXMX_SCM_ITEM_REV_EFF_XFM;
--
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_ITEM_REV_EFF_TL_XFM FOR XXMX_XFM.XXMX_SCM_ITEM_REV_EFF_TL_XFM;
--
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_ITEM_SUPP_EFF_XFM FOR XXMX_XFM.XXMX_SCM_ITEM_SUPP_EFF_XFM;
--
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_ITEM_SUPP_EFF_TL_XFM FOR XXMX_XFM.XXMX_SCM_ITEM_SUPP_EFF_TL_XFM;
--
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_ITEM_STYL_ATTR_XFM FOR XXMX_XFM.XXMX_SCM_ITEM_STYL_ATTR_XFM;
--
CREATE OR REPLACE SYNONYM XXMX_CORE.XXMX_SCM_TP_ITEMS_XFM FOR XXMX_XFM.XXMX_SCM_TP_ITEMS_XFM;    
--
--
PROMPT
PROMPT
PROMPT ***********************
PROMPT ** Granting Permissions
PROMPT ***********************
--
--
PROMPT
PROMPT Granting permissions 
PROMPT
--
GRANT ALL ON XXMX_XFM.XXMX_SCM_SYS_ITEMS_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_ITEM_REV_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_ITEM_CAT_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_ITEM_ASSOC_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_ITEM_REL_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_ITEM_EFF_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_ITEM_EFF_TL_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_ITEM_REV_EFF_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_ITEM_REV_EFF_TL_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_ITEM_SUPP_EFF_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_ITEM_SUPP_EFF_TL_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_ITEM_STYL_ATTR_XFM TO XXMX_CORE;
GRANT ALL ON XXMX_XFM.XXMX_SCM_TP_ITEMS_XFM TO XXMX_CORE;
--
--
--
PROMPT
PROMPT
PROMPT ***********************************************************************************
PROMPT **                                
PROMPT ** Completed Installing Database Objects for Cloudbridge ITEM Data Migration
PROMPT **                                
PROMPT ***********************************************************************************
PROMPT
PROMPT
--
--
